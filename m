From: maximilian attems <janitor@sternwelten.at>
Subject: [patch-kj] kernel_thread() audit drivers/scsi/aacraid/rkt.c
Date: Mon, 21 Jun 2004 19:42:00 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040621174200.GI1545@sputnik.stro.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:36998 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S266348AbUFURl7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 13:41:59 -0400
Received: from localhost (localhost [127.0.0.1])
	by baikonur.stro.at (Postfix) with ESMTP id EDB395C077
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2004 19:41:58 +0200 (CEST)
Received: from baikonur.stro.at ([127.0.0.1])
	by localhost (baikonur [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 19600-01 for <linux-scsi@vger.kernel.org>;
	Mon, 21 Jun 2004 19:41:58 +0200 (CEST)
Received: from sputnik (unknown [62.47.144.54])
	by baikonur.stro.at (Postfix) with ESMTP id 06A8A5C002
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2004 19:41:58 +0200 (CEST)
Received: from max by sputnik with local (Exim 4.32)
	id 1BcSnx-00048G-5M
	for linux-scsi@vger.kernel.org; Mon, 21 Jun 2004 19:42:01 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


 Cleaned up code for error handing. Added checks to unmap memory,
 release IRQ's, and freeing up dev->queue.

Signed-off-by: MJK <mkemp@cs.nmsu.edu>
Signed-off-by: Maximilian Attems <janitor@sternwelten.at>



---

 linux-2.6.7-max/drivers/scsi/aacraid/rkt.c |   25 ++++++++++++++++++-------
 1 files changed, 18 insertions(+), 7 deletions(-)

diff -puN drivers/scsi/aacraid/rkt.c~kernel_thread-aacraid-rkt drivers/scsi/aacraid/rkt.c
--- linux-2.6.7/drivers/scsi/aacraid/rkt.c~kernel_thread-aacraid-rkt	2004-06-18 09:08:15.000000000 +0200
+++ linux-2.6.7-max/drivers/scsi/aacraid/rkt.c	2004-06-18 09:08:15.000000000 +0200
@@ -383,21 +383,21 @@ int aac_rkt_init(struct aac_dev *dev, un
 	if((dev->regs.rkt = (struct rkt_registers *)ioremap((unsigned long)dev->scsi_host_ptr->base, 8192))==NULL)
 	{	
 		printk(KERN_WARNING "aacraid: unable to map i960.\n" );
-		return -1;
+		goto error_iounmap;
 	}
 	/*
 	 *	Check to see if the board failed any self tests.
 	 */
 	if (rkt_readl(dev, IndexRegs.Mailbox[7]) & SELF_TEST_FAILED) {
 		printk(KERN_ERR "%s%d: adapter self-test failed.\n", dev->name, instance);
-		return -1;
+		goto error_iounmap;
 	}
 	/*
 	 *	Check to see if the board panic'd while booting.
 	 */
 	if (rkt_readl(dev, IndexRegs.Mailbox[7]) & KERNEL_PANIC) {
 		printk(KERN_ERR "%s%d: adapter kernel panic'd.\n", dev->name, instance);
-		return -1;
+		goto error_iounmap;
 	}
 	start = jiffies;
 	/*
@@ -409,7 +409,7 @@ int aac_rkt_init(struct aac_dev *dev, un
 		{
 			status = rkt_readl(dev, IndexRegs.Mailbox[7]) >> 16;
 			printk(KERN_ERR "%s%d: adapter kernel failed to start, init status = %ld.\n", dev->name, instance, status);
-			return -1;
+			goto error_iounmap;
 		}
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule_timeout(1);
@@ -417,7 +417,7 @@ int aac_rkt_init(struct aac_dev *dev, un
 	if (request_irq(dev->scsi_host_ptr->irq, aac_rkt_intr, SA_SHIRQ|SA_INTERRUPT, "aacraid", (void *)dev)<0) 
 	{
 		printk(KERN_ERR "%s%d: Interrupt unavailable.\n", name, instance);
-		return -1;
+		goto error_iounmap;
 	}
 	/*
 	 *	Fill in the function dispatch table.
@@ -430,7 +430,7 @@ int aac_rkt_init(struct aac_dev *dev, un
 	dev->a_ops.adapter_check_health = aac_rkt_check_health;
 
 	if (aac_init_adapter(dev) == NULL)
-		return -1;
+		goto error_irq;
 	/*
 	 *	Start any kernel threads needed
 	 */
@@ -438,7 +438,7 @@ int aac_rkt_init(struct aac_dev *dev, un
 	if(dev->thread_pid < 0)
 	{
 		printk(KERN_ERR "aacraid: Unable to create rkt thread.\n");
-		return -1;
+		goto error_kfree;
 	}	
 	/*
 	 *	Tell the adapter that all is configured, and it can start
@@ -446,4 +446,15 @@ int aac_rkt_init(struct aac_dev *dev, un
 	 */
 	aac_rkt_start_adapter(dev);
 	return 0;
+
+error_kfree:
+	kfree(dev->queues);
+
+error_irq:
+	free_irq(dev->scsi_host_ptr->irq, (void *)dev);
+
+error_iounmap:
+	iounmap(dev->regs.rkt);
+
+	return -1;
 }

_
