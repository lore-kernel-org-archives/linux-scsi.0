From: maximilian attems <janitor@sternwelten.at>
Subject: [patch-kj] kernel_thread() audit drivers/scsi/aacraid/sa.c
Date: Mon, 21 Jun 2004 19:42:57 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040621174257.GJ1545@sputnik.stro.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:28884 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S266351AbUFURmz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 13:42:55 -0400
Received: from localhost (localhost [127.0.0.1])
	by baikonur.stro.at (Postfix) with ESMTP id 89EE85C134
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2004 19:42:54 +0200 (CEST)
Received: from baikonur.stro.at ([127.0.0.1])
	by localhost (baikonur [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 22325-01 for <linux-scsi@vger.kernel.org>;
	Mon, 21 Jun 2004 19:42:53 +0200 (CEST)
Received: from sputnik (unknown [62.47.144.54])
	by baikonur.stro.at (Postfix) with ESMTP id 8DFC35C002
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2004 19:42:53 +0200 (CEST)
Received: from max by sputnik with local (Exim 4.32)
	id 1BcSor-00048N-2y
	for linux-scsi@vger.kernel.org; Mon, 21 Jun 2004 19:42:57 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



 Cleaned up code for error handing. Added checks to unmap memory,
 release IRQ's, and freeing up dev->queue.

Signed-off-by: MJK <mkemp@cs.nmsu.edu>
Signed-off-by: Maximilian Attems <janitor@sternwelten.at>



---

 linux-2.6.7-max/drivers/scsi/aacraid/sa.c |   26 +++++++++++++++++++-------
 1 files changed, 19 insertions(+), 7 deletions(-)

diff -puN drivers/scsi/aacraid/sa.c~kernel_thread-aacraid-sa drivers/scsi/aacraid/sa.c
--- linux-2.6.7/drivers/scsi/aacraid/sa.c~kernel_thread-aacraid-sa	2004-06-18 09:08:24.000000000 +0200
+++ linux-2.6.7-max/drivers/scsi/aacraid/sa.c	2004-06-18 09:08:24.000000000 +0200
@@ -362,21 +362,21 @@ int aac_sa_init(struct aac_dev *dev, uns
 	if((dev->regs.sa = (struct sa_registers *)ioremap((unsigned long)dev->scsi_host_ptr->base, 8192))==NULL)
 	{	
 		printk(KERN_WARNING "aacraid: unable to map ARM.\n" );
-		return -1;
+		goto error_iounmap;
 	}
 	/*
 	 *	Check to see if the board failed any self tests.
 	 */
 	if (sa_readl(dev, Mailbox7) & SELF_TEST_FAILED) {
 		printk(KERN_WARNING "%s%d: adapter self-test failed.\n", name, instance);
-		return -1;
+		goto error_iounmap;
 	}
 	/*
 	 *	Check to see if the board panic'd while booting.
 	 */
 	if (sa_readl(dev, Mailbox7) & KERNEL_PANIC) {
 		printk(KERN_WARNING "%s%d: adapter kernel panic'd.\n", name, instance);
-		return -1;
+		goto error_iounmap;
 	}
 	start = jiffies;
 	/*
@@ -386,7 +386,7 @@ int aac_sa_init(struct aac_dev *dev, uns
 		if (time_after(jiffies, start+180*HZ)) {
 			status = sa_readl(dev, Mailbox7) >> 16;
 			printk(KERN_WARNING "%s%d: adapter kernel failed to start, init status = %d.\n", name, instance, le32_to_cpu(status));
-			return -1;
+			goto error_iounmap;
 		}
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule_timeout(1);
@@ -395,7 +395,7 @@ int aac_sa_init(struct aac_dev *dev, uns
 	dprintk(("ATIRQ\n"));
 	if (request_irq(dev->scsi_host_ptr->irq, aac_sa_intr, SA_SHIRQ|SA_INTERRUPT, "aacraid", (void *)dev ) < 0) {
 		printk(KERN_WARNING "%s%d: Interrupt unavailable.\n", name, instance);
-		return -1;
+		goto error_iounmap;
 	}
 
 	/*
@@ -412,7 +412,7 @@ int aac_sa_init(struct aac_dev *dev, uns
 	dprintk(("FUNCDONE\n"));
 
 	if(aac_init_adapter(dev) == NULL)
-		return -1;
+		goto error_irq;
 
 	dprintk(("NEWADAPTDONE\n"));
 	/*
@@ -421,7 +421,7 @@ int aac_sa_init(struct aac_dev *dev, uns
 	dev->thread_pid = kernel_thread((int (*)(void *))aac_command_thread, dev, 0);
 	if (dev->thread_pid < 0) {
 		printk(KERN_ERR "aacraid: Unable to create command thread.\n");
-		return -1;
+		goto error_kfree;
 	}
 
 	/*
@@ -432,5 +432,17 @@ int aac_sa_init(struct aac_dev *dev, uns
 	aac_sa_start_adapter(dev);
 	dprintk(("STARTED\n"));
 	return 0;
+
+
+error_kfree:
+	kfree(dev->queues);
+
+error_irq:
+	free_irq(dev->scsi_host_ptr->irq, (void *)dev);
+
+error_iounmap:
+	iounmap(dev->regs.sa);
+
+	return -1;
 }
 

_
