From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] aacraid: Initialize rx/rkt function pointers before calling
 them
Date: Thu, 26 Apr 2007 15:58:09 -0700
Message-ID: <46312E81.7030600@us.ibm.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:59071 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031512AbXDZW55 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Apr 2007 18:57:57 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l3QLuhdW005689
	for <linux-scsi@vger.kernel.org>; Thu, 26 Apr 2007 17:56:43 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l3QMvtJ8513186
	for <linux-scsi@vger.kernel.org>; Thu, 26 Apr 2007 18:57:55 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l3QMvteS017772
	for <linux-scsi@vger.kernel.org>; Thu, 26 Apr 2007 18:57:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mark_salyzyn@adaptec.com, Alexis Bruemmer <alexisb@us.ibm.com>

Commit 8418852d11f0bbaeebeedd4243560d8fdc85410d to scsi-misc resulted in
the substitution of calls to rx_sync_cmd with a function pointer
abstraction.  aac_rx_restart_adapter requires a pointer to a sync_cmd
function, which is not set up before its first invocation.  That causes
the driver to crash at startup.  Move the initializers (we need both
rx_sync_cmd and enable_int pointers) further up to proceed the
restart_adapter call.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/aacraid/rx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
index 0c71315..b7810d6 100644
--- a/drivers/scsi/aacraid/rx.c
+++ b/drivers/scsi/aacraid/rx.c
@@ -537,6 +537,8 @@ int _aac_rx_init(struct aac_dev *dev)
 		printk(KERN_WARNING "%s: unable to map adapter.\n", name);
 		goto error_iounmap;
 	}
+	dev->a_ops.adapter_sync_cmd = rx_sync_cmd;
+	aac_adapter_comm(dev, AAC_COMM_PRODUCER);
 
 	/* Failure to reset here is an option ... */
 	dev->OIMR = status = rx_readb (dev, MUnit.OIMR);
@@ -598,7 +600,6 @@ int _aac_rx_init(struct aac_dev *dev)
 	dev->a_ops.adapter_interrupt = aac_rx_interrupt_adapter;
 	dev->a_ops.adapter_disable_int = aac_rx_disable_interrupt;
 	dev->a_ops.adapter_notify = aac_rx_notify_adapter;
-	dev->a_ops.adapter_sync_cmd = rx_sync_cmd;
 	dev->a_ops.adapter_check_health = aac_rx_check_health;
 	dev->a_ops.adapter_restart = aac_rx_restart_adapter;
 
@@ -606,7 +607,6 @@ int _aac_rx_init(struct aac_dev *dev)
 	 *	First clear out all interrupts.  Then enable the one's that we
 	 *	can handle.
 	 */
-	aac_adapter_comm(dev, AAC_COMM_PRODUCER);
 	aac_adapter_disable_int(dev);
 	rx_writel(dev, MUnit.ODR, 0xffffffff);
 	aac_adapter_enable_int(dev);
