From: Anton Blanchard <anton@samba.org>
Subject: Re: [RFC] IBM Power RAID driver (ipr)
Date: Mon, 19 Jan 2004 01:10:03 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040118141003.GA6293@krispykreme>
References: <40085EDA.4010802@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:64156 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S261563AbUAROLV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Jan 2004 09:11:21 -0500
Content-Disposition: inline
In-Reply-To: <40085EDA.4010802@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: linux-scsi@vger.kernel.org


Hi Brian,

> I have just written a LLD for the IBM Power RAID family of adapters.
> This includes several IBM iSeries and pSeries SCSI adapters. Please
> review for 2.6 inclusion.

Nice work! It does a good job of using all the recent PCI and SCSI
infrastructure. I had a quick look through it and can only offer some
minor suggestions.

- Since ipr_sleep_no_lock/ipr_sleep is used once, we can open code
  a schedule_timeout there instead.

- Add a comment to explain why the wakeup strategy isnt racy. I
  automatically thought it was (just like the kernel version of
  sleep_on) until I could verify all wake ups are done under the scsi
  host lock. I also have a trivial change to make the two sleep
  functions alike.

- Im a bit worried about memory barriers wrt the allow_* things. As an
  example I added some mb()s wherever ->allow_interrupts is set.
  Actually, do we need this flag at all? Cant we just set the bits on the
  card to disable interrupts, then do a synchronize_irq()? Similarly it
  would be nice to get rid of some of the other allow_ flags if we can
  get around them.

- The forcing of the pci cacheline size worries me, could we have problems 
  with enabling MWI etc after doing this?

- Do we need the extra ipr_set_pcix_cmd_reg during init? We are going to
  do it after a reset arent we?

- It looks like the kmalloc in ipr_sdt_copy is called from process
  context without any locks held, so we dont need an atomic allocation.

Anton


diff -urp t.orig/drivers/scsi/ipr.c t/drivers/scsi/ipr.c
--- t.orig/drivers/scsi/ipr.c	2004-01-01 00:01:37.000000000 +1100
+++ t/drivers/scsi/ipr.c	2004-01-19 01:08:38.958959407 +1100
@@ -670,46 +670,12 @@ static const struct ipr_ses_table_entry 
 };
 
 /**
- * ipr_sleep_no_lock - Sleep for the specified amount of time
- * @delay:		time to sleep
- *
- * Sleep for the specified amount of time
- * 
- * Return value:
- * 	none
- **/
-static void ipr_sleep_no_lock(signed long delay)
-{
-	DECLARE_WAIT_QUEUE_HEAD(internal_wait);
-
-	sleep_on_timeout(&internal_wait, (delay * HZ) / 1000);
-	return;
-}
-
-/**
- * ipr_sleep - Sleep for the specified amount of time
- * @ioa_cfg:	ioa config struct
- * @delay:		time to sleep in msecs
- *
- * Release the host lock and sleep for the specified amount of time
- * 
- * Return value:
- * 	none
- **/
-static void ipr_sleep(struct ipr_ioa_cfg *ioa_cfg, signed long delay)
-{
-	spin_unlock_irq(ioa_cfg->host->host_lock);
-	ipr_sleep_no_lock(delay);
-	spin_lock_irq(ioa_cfg->host->host_lock);
-	return;
-}
-
-/**
  * ipr_interruptible_sleep_on - Sleep on the wait queue
  * @ioa_cfg:	ioa config struct
  * @wait_head:	wait queue to sleep on
  *
- * Sleep interruptibly on the wait queue.
+ * Sleep interruptibly on the wait queue. We avoid wakeup races by
+ * having the scsi host lock held on both sleep and wakeup.
  * 
  * Return value:
  * 	0 on success / -EINTR if woken due to a signal
@@ -717,7 +683,9 @@ static void ipr_sleep(struct ipr_ioa_cfg
 static int ipr_interruptible_sleep_on(struct ipr_ioa_cfg *ioa_cfg,
 				      wait_queue_head_t *wait_head)
 {
-	DECLARE_WAITQUEUE(wait_q_entry, current);
+	wait_queue_t wait_q_entry;
+
+	init_waitqueue_entry(&wait_q_entry);
 
 	set_current_state(TASK_INTERRUPTIBLE);
 
@@ -742,7 +710,8 @@ static int ipr_interruptible_sleep_on(st
  * @ioa_cfg:	ioa config struct
  * @wait_head:	wait queue to sleep on
  *
- * Sleep uninterruptibly on the wait queue.
+ * Sleep uninterruptibly on the wait queue. We avoid wakeup races by
+ * having the scsi host lock held on both sleep and wakeup.
  * 
  * Return value:
  * 	none
@@ -1076,6 +1045,7 @@ static void ipr_mask_and_clear_all_inter
 
 	/* Stop new interrupts */
 	ioa_cfg->allow_interrupts = 0;
+	mb();
 
 	/* Set interrupt mask to stop all new interrupts */
 	writel(~0, ioa_cfg->regs.set_interrupt_mask_reg);
@@ -1395,7 +1365,7 @@ static int __devinit ipr_probe_ioa(struc
 				   ioa_cfg->chip_cfg->cache_line_size);
 
 	if (rc != PCIBIOS_SUCCESSFUL) {
-		dev_err(&pdev->dev, "Read of config space failed\n");
+		dev_err(&pdev->dev, "Write of config space failed\n");
 		rc = -EIO;
 		goto cleanup_nomem;
 	}
@@ -1412,9 +1382,6 @@ static int __devinit ipr_probe_ioa(struc
 	if ((rc = ipr_save_pcix_cmd_reg(ioa_cfg)))
 		goto cleanup_nomem;
 
-	if ((rc = ipr_set_pcix_cmd_reg(ioa_cfg)))
-		goto cleanup_nomem;
-
 	if ((rc = ipr_alloc_mem(ioa_cfg)))
 		goto cleanup;
 
@@ -2276,6 +2243,7 @@ static int ipr_reset_enable_ioa(struct i
 
 	/* Enable interrupts */
 	ioa_cfg->allow_interrupts = 1;
+	mb();
 	writel(IPR_PCII_OPER_INTERRUPTS, ioa_cfg->regs.clr_interrupt_mask_reg);
 	temp_reg = readl(ioa_cfg->regs.sense_interrupt_mask_reg);
 
@@ -6249,13 +6217,12 @@ static int ipr_diagnostic_ioctl(struct i
 	ipr_unblock_requests(ioa_cfg);
 
 	/* Wait for a second for any errors to be logged */
-	ipr_sleep(ioa_cfg, 1000);
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	schedule_timeout(HZ);
 
 	if (ioa_cfg->errors_logged)
 		rc = -EIO;
 
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-
 	return rc;
 }
 
@@ -7490,7 +7457,7 @@ static int ipr_sdt_copy(struct ipr_ioa_c
 	       ((ioa_cfg->ioa_dump->hdr.length + bytes_copied) < IPR_MAX_IOA_DUMP_SIZE)) {
 		if ((ioa_cfg->ioa_dump->page_offset >= PAGE_SIZE) ||
 		    (ioa_cfg->ioa_dump->page_offset == 0)) {
-			page = (u32 *)__get_free_page(GFP_ATOMIC);
+			page = (u32 *)__get_free_page(GFP_KERNEL);
 
 			if (!page) {
 				ipr_trace;
