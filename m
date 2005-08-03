From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 3/7] aacraid: driver shutdown method
Date: Wed, 03 Aug 2005 15:39:01 -0700
Message-ID: <1123108741.24945.37.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:33762 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261516AbVHCWjF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2005 18:39:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>


Add in pci shutdown method so that the adapter shuts down correctly and
flushes its cache. Shutdown should also disable the adapter's interrupt
when shutdown (in particularly if the driver is rmmod'd) to prevent
spurious hardware activities.

Patch against scsi-misc-2.6 git tree.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

Index: scsi-misc-aac-1/drivers/scsi/aacraid/aacraid.h
===================================================================
--- scsi-misc-aac-1.orig/drivers/scsi/aacraid/aacraid.h	2005-07-01 11:49:36.000000000 -0700
+++ scsi-misc-aac-1/drivers/scsi/aacraid/aacraid.h	2005-07-01 11:52:07.000000000 -0700
@@ -460,6 +460,7 @@
 {
 	void (*adapter_interrupt)(struct aac_dev *dev);
 	void (*adapter_notify)(struct aac_dev *dev, u32 event);
+	void (*adapter_disable_int)(struct aac_dev *dev);
 	int  (*adapter_sync_cmd)(struct aac_dev *dev, u32 command, u32 p1, u32 p2, u32 p3, u32 p4, u32 p5, u32 p6, u32 *status, u32 *r1, u32 *r2, u32 *r3, u32 *r4);
 	int  (*adapter_check_health)(struct aac_dev *dev);
 };
@@ -994,6 +995,9 @@
 #define aac_adapter_notify(dev, event) \
 	(dev)->a_ops.adapter_notify(dev, event)
 
+#define aac_adapter_disable_int(dev) \
+	(dev)->a_ops.adapter_disable_int(dev)
+
 #define aac_adapter_sync_cmd(dev, command, p1, p2, p3, p4, p5, p6, status, r1, r2, r3, r4) \
 	(dev)->a_ops.adapter_sync_cmd(dev, command, p1, p2, p3, p4, p5, p6, status, r1, r2, r3, r4)
 
Index: scsi-misc-aac-1/drivers/scsi/aacraid/linit.c
===================================================================
--- scsi-misc-aac-1.orig/drivers/scsi/aacraid/linit.c	2005-07-01 11:49:36.000000000 -0700
+++ scsi-misc-aac-1/drivers/scsi/aacraid/linit.c	2005-07-01 11:52:07.000000000 -0700
@@ -849,11 +849,12 @@
 
 	return 0;
 
-out_deinit:
+ out_deinit:
 	kill_proc(aac->thread_pid, SIGKILL, 0);
 	wait_for_completion(&aac->aif_completion);
 
 	aac_send_shutdown(aac);
+	aac_adapter_disable_int(aac);
 	fib_map_free(aac);
 	pci_free_consistent(aac->pdev, aac->comm_size, aac->comm_addr, aac->comm_phys);
 	kfree(aac->queues);
@@ -870,6 +871,13 @@
 	return error;
 }
 
+static void aac_shutdown(struct pci_dev *dev)
+{
+	struct Scsi_Host *shost = pci_get_drvdata(dev);
+	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
+	aac_send_shutdown(aac);
+}
+
 static void __devexit aac_remove_one(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
@@ -881,6 +889,7 @@
 	wait_for_completion(&aac->aif_completion);
 
 	aac_send_shutdown(aac);
+	aac_adapter_disable_int(aac);
 	fib_map_free(aac);
 	pci_free_consistent(aac->pdev, aac->comm_size, aac->comm_addr,
 			aac->comm_phys);
@@ -901,6 +910,7 @@
 	.id_table	= aac_pci_tbl,
 	.probe		= aac_probe_one,
 	.remove		= __devexit_p(aac_remove_one),
+	.shutdown 	= aac_shutdown,
 };
 
 static int __init aac_init(void)
@@ -919,6 +929,7 @@
 		printk(KERN_WARNING
 		       "aacraid: unable to register \"aac\" device.\n");
 	}
+
 	return 0;
 }
 
Index: scsi-misc-aac-1/drivers/scsi/aacraid/rkt.c
===================================================================
--- scsi-misc-aac-1.orig/drivers/scsi/aacraid/rkt.c	2005-07-01 11:43:01.000000000 -0700
+++ scsi-misc-aac-1/drivers/scsi/aacraid/rkt.c	2005-07-01 11:52:07.000000000 -0700
@@ -88,6 +88,16 @@
 }
 
 /**
+ *	aac_rkt_disable_interrupt	-	Disable interrupts
+ *	@dev: Adapter
+ */
+
+static void aac_rkt_disable_interrupt(struct aac_dev *dev)
+{
+	rkt_writeb(dev, MUnit.OIMR, dev->OIMR = 0xff);
+}
+
+/**
  *	rkt_sync_cmd	-	send a command and wait
  *	@dev: Adapter
  *	@command: Command to execute
@@ -412,10 +422,19 @@
 	 *	Fill in the function dispatch table.
 	 */
 	dev->a_ops.adapter_interrupt = aac_rkt_interrupt_adapter;
+	dev->a_ops.adapter_disable_int = aac_rkt_disable_interrupt;
 	dev->a_ops.adapter_notify = aac_rkt_notify_adapter;
 	dev->a_ops.adapter_sync_cmd = rkt_sync_cmd;
 	dev->a_ops.adapter_check_health = aac_rkt_check_health;
 
+	/*
+	 *	First clear out all interrupts.  Then enable the one's that we
+	 *	can handle.
+	 */
+	rkt_writeb(dev, MUnit.OIMR, 0xff);
+	rkt_writel(dev, MUnit.ODR, 0xffffffff);
+	rkt_writeb(dev, MUnit.OIMR, dev->OIMR = 0xfb);
+
 	if (aac_init_adapter(dev) == NULL)
 		goto error_irq;
 	/*
@@ -438,6 +457,7 @@
 	kfree(dev->queues);
 
 error_irq:
+	rkt_writeb(dev, MUnit.OIMR, dev->OIMR = 0xff);
 	free_irq(dev->scsi_host_ptr->irq, (void *)dev);
 
 error_iounmap:
Index: scsi-misc-aac-1/drivers/scsi/aacraid/rx.c
===================================================================
--- scsi-misc-aac-1.orig/drivers/scsi/aacraid/rx.c	2005-07-01 11:43:01.000000000 -0700
+++ scsi-misc-aac-1/drivers/scsi/aacraid/rx.c	2005-07-01 11:52:07.000000000 -0700
@@ -88,6 +88,16 @@
 }
 
 /**
+ *	aac_rx_disable_interrupt	-	Disable interrupts
+ *	@dev: Adapter
+ */
+
+static void aac_rx_disable_interrupt(struct aac_dev *dev)
+{
+	rx_writeb(dev, MUnit.OIMR, dev->OIMR = 0xff);
+}
+
+/**
  *	rx_sync_cmd	-	send a command and wait
  *	@dev: Adapter
  *	@command: Command to execute
@@ -412,10 +422,19 @@
 	 *	Fill in the function dispatch table.
 	 */
 	dev->a_ops.adapter_interrupt = aac_rx_interrupt_adapter;
+	dev->a_ops.adapter_disable_int = aac_rx_disable_interrupt;
 	dev->a_ops.adapter_notify = aac_rx_notify_adapter;
 	dev->a_ops.adapter_sync_cmd = rx_sync_cmd;
 	dev->a_ops.adapter_check_health = aac_rx_check_health;
 
+	/*
+	 *	First clear out all interrupts.  Then enable the one's that we
+	 *	can handle.
+	 */
+	rx_writeb(dev, MUnit.OIMR, 0xff);
+	rx_writel(dev, MUnit.ODR, 0xffffffff);
+	rx_writeb(dev, MUnit.OIMR, dev->OIMR = 0xfb);
+
 	if (aac_init_adapter(dev) == NULL)
 		goto error_irq;
 	/*
@@ -438,6 +457,7 @@
 	kfree(dev->queues);
 
 error_irq:
+	rx_writeb(dev, MUnit.OIMR, dev->OIMR = 0xff);
 	free_irq(dev->scsi_host_ptr->irq, (void *)dev);
 
 error_iounmap:
Index: scsi-misc-aac-1/drivers/scsi/aacraid/sa.c
===================================================================
--- scsi-misc-aac-1.orig/drivers/scsi/aacraid/sa.c	2005-07-01 11:43:01.000000000 -0700
+++ scsi-misc-aac-1/drivers/scsi/aacraid/sa.c	2005-07-01 11:52:07.000000000 -0700
@@ -82,6 +82,16 @@
 }
 
 /**
+ *	aac_sa_disable_interrupt	-	disable interrupt
+ *	@dev: Which adapter to enable.
+ */
+
+static void aac_sa_disable_interrupt (struct aac_dev *dev)
+{
+	sa_writew(dev, SaDbCSR.PRISETIRQMASK, 0xffff);
+}
+
+/**
  *	aac_sa_notify_adapter		-	handle adapter notification
  *	@dev:	Adapter that notification is for
  *	@event:	Event to notidy
@@ -214,9 +224,8 @@
  
 static void aac_sa_interrupt_adapter (struct aac_dev *dev)
 {
-	u32 ret;
 	sa_sync_cmd(dev, BREAKPOINT_REQUEST, 0, 0, 0, 0, 0, 0,
-			&ret, NULL, NULL, NULL, NULL);
+			NULL, NULL, NULL, NULL, NULL);
 }
 
 /**
@@ -352,10 +361,18 @@
 	 */
 
 	dev->a_ops.adapter_interrupt = aac_sa_interrupt_adapter;
+	dev->a_ops.adapter_disable_int = aac_sa_disable_interrupt;
 	dev->a_ops.adapter_notify = aac_sa_notify_adapter;
 	dev->a_ops.adapter_sync_cmd = sa_sync_cmd;
 	dev->a_ops.adapter_check_health = aac_sa_check_health;
 
+	/*
+	 *	First clear out all interrupts.  Then enable the one's that 
+	 *	we can handle.
+	 */
+	sa_writew(dev, SaDbCSR.PRISETIRQMASK, 0xffff);
+	sa_writew(dev, SaDbCSR.PRICLEARIRQMASK, (PrintfReady | DOORBELL_1 | 
+				DOORBELL_2 | DOORBELL_3 | DOORBELL_4));
 
 	if(aac_init_adapter(dev) == NULL)
 		goto error_irq;
@@ -381,6 +398,7 @@
 	kfree(dev->queues);
 
 error_irq:
+	sa_writew(dev, SaDbCSR.PRISETIRQMASK, 0xffff);
 	free_irq(dev->scsi_host_ptr->irq, (void *)dev);
 
 error_iounmap:

-- 
Mark Haverkamp <markh@osdl.org>

