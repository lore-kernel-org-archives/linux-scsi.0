From: maximilian attems <janitor@sternwelten.at>
Subject: [patch-kj] kernel_thread() audit drivers/scsi/aacraid/rx.c
Date: Mon, 21 Jun 2004 19:39:46 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040621173946.GH1545@sputnik.stro.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:50873 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S266347AbUFURjq
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 13:39:46 -0400
Received: from localhost (localhost [127.0.0.1])
	by baikonur.stro.at (Postfix) with ESMTP id 6D2C05C134
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2004 19:39:45 +0200 (CEST)
Received: from baikonur.stro.at ([127.0.0.1])
	by localhost (baikonur [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 09988-09 for <linux-scsi@vger.kernel.org>;
	Mon, 21 Jun 2004 19:39:43 +0200 (CEST)
Received: from sputnik (unknown [62.47.144.54])
	by baikonur.stro.at (Postfix) with ESMTP id 6E31A5C002
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2004 19:39:43 +0200 (CEST)
Received: from max by sputnik with local (Exim 4.32)
	id 1BcSlm-000485-Ur
	for linux-scsi@vger.kernel.org; Mon, 21 Jun 2004 19:39:46 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Cleaned up error handling for releasing IRQ's, unmapping memory
and freeing device memory (dev->queues). Also, audited 
kernel_thread() and took appropriate action for failure.

Signed-off-by: MJK <mkemp@cs.nmsu.edu>
Signed-off-by: Maximilian Attems <janitor@sternwelten.at>



---

 linux-2.6.7-max/drivers/scsi/aacraid/rx.c |   25 ++++++++++++++++++++-----
 1 files changed, 20 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/aacraid/rx.c~kernel_thread-aacraid-rx drivers/scsi/aacraid/rx.c
--- linux-2.6.7/drivers/scsi/aacraid/rx.c~kernel_thread-aacraid-rx	2004-06-18 09:08:21.000000000 +0200
+++ linux-2.6.7-max/drivers/scsi/aacraid/rx.c	2004-06-18 09:08:21.000000000 +0200
@@ -390,14 +390,14 @@ int aac_rx_init(struct aac_dev *dev, uns
 	 */
 	if (rx_readl(dev, IndexRegs.Mailbox[7]) & SELF_TEST_FAILED) {
 		printk(KERN_ERR "%s%d: adapter self-test failed.\n", dev->name, instance);
-		return -1;
+		goto error_iounmap;
 	}
 	/*
 	 *	Check to see if the board panic'd while booting.
 	 */
 	if (rx_readl(dev, IndexRegs.Mailbox[7]) & KERNEL_PANIC) {
 		printk(KERN_ERR "%s%d: adapter kernel panic'd.\n", dev->name, instance);
-		return -1;
+		goto error_iounmap;
 	}
 	start = jiffies;
 	/*
@@ -409,7 +409,7 @@ int aac_rx_init(struct aac_dev *dev, uns
 		{
 			status = rx_readl(dev, IndexRegs.Mailbox[7]) >> 16;
 			printk(KERN_ERR "%s%d: adapter kernel failed to start, init status = %ld.\n", dev->name, instance, status);
-			return -1;
+			goto error_iounmap;
 		}
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule_timeout(1);
@@ -417,7 +417,7 @@ int aac_rx_init(struct aac_dev *dev, uns
 	if (request_irq(dev->scsi_host_ptr->irq, aac_rx_intr, SA_SHIRQ|SA_INTERRUPT, "aacraid", (void *)dev)<0) 
 	{
 		printk(KERN_ERR "%s%d: Interrupt unavailable.\n", name, instance);
-		return -1;
+		goto error_iounmap;
 	}
 	/*
 	 *	Fill in the function dispatch table.
@@ -430,15 +430,30 @@ int aac_rx_init(struct aac_dev *dev, uns
 	dev->a_ops.adapter_check_health = aac_rx_check_health;
 
 	if (aac_init_adapter(dev) == NULL)
-		return -1;
+		goto error_irq;
 	/*
 	 *	Start any kernel threads needed
 	 */
 	dev->thread_pid = kernel_thread((int (*)(void *))aac_command_thread, dev, 0);
+	if (dev->thread_pid < 0) {
+		printk(KERN_ERR "aacraid: unable to create i960 command thread.\n");
+		goto error_kfree;
+	}
 	/*
 	 *	Tell the adapter that all is configured, and it can start
 	 *	accepting requests
 	 */
 	aac_rx_start_adapter(dev);
 	return 0;
+
+error_kfree:
+	kfree(dev->queues);
+
+error_irq:
+	free_irq(dev->scsi_host_ptr->irq, (void *)dev);
+
+error_iounmap:
+	iounmap(dev->regs.rx);
+
+	return -1;
 }

_
