From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] allow drivers to hook into watchdog timeout
Date: Tue, 20 Jan 2004 17:00:58 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040120160058.GA8924@lst.de>
References: <20040120132052.GA6740@lst.de> <20040120155320.GA1478@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:40627 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265177AbUATQBG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2004 11:01:06 -0500
Content-Disposition: inline
In-Reply-To: <20040120155320.GA1478@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, gibbs@scsiguy.com, linux-scsi@vger.kernel.org

On Tue, Jan 20, 2004 at 07:53:20AM -0800, Mike Anderson wrote:
> Christoph Hellwig [hch@lst.de] wrote:
> > to get control first after a command timeout.  Justin, does this look
> > okay for you?  BTW, your drivers are the last ones using scsi_add_timer
> > from outside the midlayer, if we could get rid of that we'd be able to
> > keep the interface private.
> > 
> 
> If a LLDD uses this interface how does the scsi_cmnd get returned back
> to the mid-layer?

My thoughts about this interface would be that the driver performs
internals actions of whatever means and then calls scsi_eh_scmd_add
anyway - that's why it moved out of scsi_priv.h

> If one uses scsi_done without a timer set it will
> believe that the error handler is running and not pass it on to
> scsi_softirq.

We could change that by moving the guts of scsi_done to a new
__scsi_done and then make scsi_done a tiny wrapper around it, e.g:


--- 1.134/drivers/scsi/scsi.c	Sat Jan 10 21:37:37 2004
+++ edited/drivers/scsi/scsi.c	Tue Jan 20 17:56:56 2004
@@ -672,6 +694,29 @@
  */
 static DEFINE_PER_CPU(struct list_head, scsi_done_q);
 
+void __scsi_done(struct scsi_cmnd *cmd)
+{
+	unsigned long flags;
+
+	/*
+	 * Set the serial numbers back to zero
+	 */
+	cmd->serial_number = 0;
+	cmd->serial_number_at_timeout = 0;
+	cmd->state = SCSI_STATE_BHQUEUE;
+	cmd->owner = SCSI_OWNER_BH_HANDLER;
+
+	/*
+	 * Next, enqueue the command into the done queue.
+	 * It is a per-CPU queue, so we just disable local interrupts
+	 * and need no spinlock.
+	 */
+	local_irq_save(flags);
+	list_add_tail(&cmd->eh_entry, &__get_cpu_var(scsi_done_q));
+	raise_softirq_irqoff(SCSI_SOFTIRQ);
+	local_irq_restore(flags);
+}
+
 /**
  * scsi_done - Enqueue the finished SCSI command into the done queue.
  * @cmd: The SCSI Command for which a low-level device driver (LLDD) gives
@@ -687,8 +732,6 @@
  */
 void scsi_done(struct scsi_cmnd *cmd)
 {
-	unsigned long flags;
-
 	/*
 	 * We don't have to worry about this one timing out any more.
 	 * If we are unable to remove the timer, then the command
@@ -697,26 +740,8 @@
 	 * that function could really be.  It might be on another processor,
 	 * etc, etc.
 	 */
-	if (!scsi_delete_timer(cmd))
-		return;
-
-	/*
-	 * Set the serial numbers back to zero
-	 */
-	cmd->serial_number = 0;
-	cmd->serial_number_at_timeout = 0;
-	cmd->state = SCSI_STATE_BHQUEUE;
-	cmd->owner = SCSI_OWNER_BH_HANDLER;
-
-	/*
-	 * Next, enqueue the command into the done queue.
-	 * It is a per-CPU queue, so we just disable local interrupts
-	 * and need no spinlock.
-	 */
-	local_irq_save(flags);
-	list_add_tail(&cmd->eh_entry, &__get_cpu_var(scsi_done_q));
-	raise_softirq_irqoff(SCSI_SOFTIRQ);
-	local_irq_restore(flags);
+	if (scsi_delete_timer(cmd))
+		__scsi_done(cmd);
 }
 
 /**
