From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [patch-kj] kernel_thread() audit drivers/scsi/aacraid/rkt.c
Date: Mon, 21 Jun 2004 13:57:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189FD2428B@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:28037 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S264247AbUFUR5X convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 13:57:23 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: maximilian attems <janitor@sternwelten.at>, linux-scsi@vger.kernel.org

Note, this and the rx.c and sa.c patches are out of date with respect to
my recent patches (for 2.4) and sources (for 2.6) submitted to Mark
Haverkamp.

In the latest code, Aac_comm_init performs the freeing of the queues
upon failure, this should not be done in these low level interface
files.

In the latest code as well, the mapping of the device is performed by
the caller, not by the low level routines.

However, there does remain the freeing of the registered interrupt upon
failure that still needs to be cleared in the latest code and I have
taken note of that.

Good catches.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of maximilian attems
Sent: Monday, June 21, 2004 1:42 PM
To: linux-scsi@vger.kernel.org
Subject: [patch-kj] kernel_thread() audit drivers/scsi/aacraid/rkt.c


 Cleaned up code for error handing. Added checks to unmap memory,
 release IRQ's, and freeing up dev->queue.

Signed-off-by: MJK <mkemp@cs.nmsu.edu>
Signed-off-by: Maximilian Attems <janitor@sternwelten.at>



---

 linux-2.6.7-max/drivers/scsi/aacraid/rkt.c |   25
++++++++++++++++++-------
 1 files changed, 18 insertions(+), 7 deletions(-)

diff -puN drivers/scsi/aacraid/rkt.c~kernel_thread-aacraid-rkt
drivers/scsi/aacraid/rkt.c
--- linux-2.6.7/drivers/scsi/aacraid/rkt.c~kernel_thread-aacraid-rkt
2004-06-18 09:08:15.000000000 +0200
+++ linux-2.6.7-max/drivers/scsi/aacraid/rkt.c	2004-06-18
09:08:15.000000000 +0200
@@ -383,21 +383,21 @@ int aac_rkt_init(struct aac_dev *dev, un
 	if((dev->regs.rkt = (struct rkt_registers *)ioremap((unsigned
long)dev->scsi_host_ptr->base, 8192))==NULL)
 	{	
 		printk(KERN_WARNING "aacraid: unable to map i960.\n" );
-		return -1;
+		goto error_iounmap;
 	}
 	/*
 	 *	Check to see if the board failed any self tests.
 	 */
 	if (rkt_readl(dev, IndexRegs.Mailbox[7]) & SELF_TEST_FAILED) {
 		printk(KERN_ERR "%s%d: adapter self-test failed.\n",
dev->name, instance);
-		return -1;
+		goto error_iounmap;
 	}
 	/*
 	 *	Check to see if the board panic'd while booting.
 	 */
 	if (rkt_readl(dev, IndexRegs.Mailbox[7]) & KERNEL_PANIC) {
 		printk(KERN_ERR "%s%d: adapter kernel panic'd.\n",
dev->name, instance);
-		return -1;
+		goto error_iounmap;
 	}
 	start = jiffies;
 	/*
@@ -409,7 +409,7 @@ int aac_rkt_init(struct aac_dev *dev, un
 		{
 			status = rkt_readl(dev, IndexRegs.Mailbox[7]) >>
16;
 			printk(KERN_ERR "%s%d: adapter kernel failed to
start, init status = %ld.\n", dev->name, instance, status);
-			return -1;
+			goto error_iounmap;
 		}
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule_timeout(1);
@@ -417,7 +417,7 @@ int aac_rkt_init(struct aac_dev *dev, un
 	if (request_irq(dev->scsi_host_ptr->irq, aac_rkt_intr,
SA_SHIRQ|SA_INTERRUPT, "aacraid", (void *)dev)<0) 
 	{
 		printk(KERN_ERR "%s%d: Interrupt unavailable.\n", name,
instance);
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
 		printk(KERN_ERR "aacraid: Unable to create rkt
thread.\n");
-		return -1;
+		goto error_kfree;
 	}	
 	/*
 	 *	Tell the adapter that all is configured, and it can
start
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
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
