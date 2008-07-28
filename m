From: Matthew Wilcox <matthew@wil.cx>
Subject: Sample implementation of a scheme to handle missing interrupts
Date: Sun, 27 Jul 2008 23:56:23 -0600
Message-ID: <20080728055622.GB18026@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:45668 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbYG1F4j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jul 2008 01:56:39 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


There has been some discussion recently (both on the mailing list and at
OLS) of MSI and it reminded me of a perennial problem that I have with
sym2.  When interrupts don't work, I often get the bug reports, because
the user seems sym2 spewing error messages right before the panic when
it fails to mount their root filesystem.

When a command times out, the midlayer calls eh_timed_out.  We can then
poke at the chip to see if we've missed an interrupt.  In this proof of
concept patch, I call the interrupt handler and see if it did anything.
I then check if the 'something' it did includes completing the command.

I believe this to be OK because the interrupt handler calls scsi_done()
which returns immediately because the timer has expired.  Then we return
EH_HANDLED from eh_timed_out which causes the midlayer to call
__scsi_done() on our behalf, completing the command properly.

I was travelling today, and my laptop doesn't have a sym2 card (anyone
got one in CardBus form factor?  ;-), so this is totally untested.
I wanted to get it out before I went to bed so people could comment.

I had to be careful not to reference a driver data structure which could
have been freed or reused.  I also decided to print (once) an error
message telling the user why they're seeing a 30-second lag between
commands completing.

For drivers testing for MSI, the driver probably wants to do something
more complex such as disabling MSIs and printing a backtrace (possibly
with a PCI hierarchy included for our benefit).

If we have any desire to do something resembling NAPI for storage, we'd
want to use a totally different scheme.  I suspect we don't, but am
willing to be proven wrong.

(this patch depends on this little patchlet, because I find
host_scribble such a terrible name:

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 66c9448..10e73a8 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -115,13 +115,17 @@ struct scsi_cmnd {
         */
        struct scsi_pointer SCp;        /* Scratchpad used by some host adapters
 
-       unsigned char *host_scribble;   /* The host adapter is allowed to
-                                        * call scsi_malloc and get some memory
-                                        * and hang it here.  The host adapter
-                                        * is also expected to call scsi_free
-                                        * to release this memory.  (The memory
-                                        * obtained by scsi_malloc is guaranteed
-                                        * to be at an address < 16Mb). */
+       /*
+        * host_scribble is the old name and type for host_data.
+        * The host_data pointer belongs to the host; it should manage it,
+        * typically by storing a pointer to some command-specific data here.
+        * Setting it to NULL when the host has freed the data is recommended,
+        * but not enforced.
+        */
+       union {
+               unsigned char *host_scribble;
+               void *host_data;
+       };
 
        int result;             /* Status code from lower level driver */
 
)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index d39107b..c86260f 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -687,6 +614,35 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 /*
  * Error handlers called from the eh thread (one thread per HBA).
  */
+
+/*
+ * eh_timed_out is called first when a command timed out.  We should check
+ * to see if the command has been completed and we've failed to spot the
+ * interrupt.  This can happen for a number of reasons, including buggy
+ * hardware and interrupt handler failures.
+ */
+static enum scsi_eh_timer_return sym53c8xx_eh_timed_out(struct scsi_cmnd *cmd)
+{
+	static int printed_warning;
+	int result = sym53c8xx_intr(0, cmd->device->host);
+
+	if (result == IRQ_NONE)
+		return EH_NOT_HANDLED;
+
+	/* When commands have been handled, host_data is set to NULL */
+	if (cmd->host_data)
+		return EH_NOT_HANDLED;
+
+	if (!printed_warning) {
+		scmd_printk(KERN_ERR, cmd, "Command timed out and was "
+				"completed from the error handler.  Check"
+				"your interrupt settings!\n");
+		printed_warning = 1;
+	}
+
+	return EH_HANDLED;
+}
+
 static int sym53c8xx_eh_abort_handler(struct scsi_cmnd *cmd)
 {
 	return sym_eh_handler(SYM_EH_ABORT, "ABORT", cmd);
@@ -1675,6 +1611,7 @@ static struct scsi_host_template sym2_template = {
 	.slave_alloc		= sym53c8xx_slave_alloc,
 	.slave_configure	= sym53c8xx_slave_configure,
 	.slave_destroy		= sym53c8xx_slave_destroy,
+	.eh_timed_out		= sym53c8xx_eh_timed_out,
 	.eh_abort_handler	= sym53c8xx_eh_abort_handler,
 	.eh_device_reset_handler = sym53c8xx_eh_device_reset_handler,
 	.eh_bus_reset_handler	= sym53c8xx_eh_bus_reset_handler,
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 22a6aae..dfa3ca1 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -4619,6 +4619,7 @@ struct sym_ccb *sym_get_ccb (struct sym_hcb *np, struct scsi_cmnd *cmd, u_char t
 	if (!qp)
 		goto out;
 	cp = sym_que_entry(qp, struct sym_ccb, link_ccbq);
+	cmd->host_data = cp;
 
 	{
 		/*
@@ -4731,6 +4732,7 @@ void sym_free_ccb (struct sym_hcb *np, struct sym_ccb *cp)
 {
 	struct sym_tcb *tp = &np->target[cp->target];
 	struct sym_lcb *lp = sym_lp(tp, cp->lun);
+	struct scsi_cmnd *cmd;
 
 	if (DEBUG_FLAGS & DEBUG_TAGS) {
 		sym_print_addr(cp->cmd, "ccb @%p freeing tag %d.\n",
@@ -4796,6 +4798,8 @@ void sym_free_ccb (struct sym_hcb *np, struct sym_ccb *cp)
 	/*
 	 *  Make this CCB available.
 	 */
+	cmd = cp->cmd;
+	cmd->host_data = NULL;
 	cp->cmd = NULL;
 	cp->host_status = HS_IDLE;
 	sym_remque(&cp->link_ccbq);

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
