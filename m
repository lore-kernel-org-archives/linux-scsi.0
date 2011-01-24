From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/4] fusion: don't use flush_scheduled_work()
Date: Mon, 24 Jan 2011 14:57:31 +0100
Message-ID: <1295877451-16602-5-git-send-email-tj@kernel.org>
References: <1295877451-16602-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60520 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab1AXN5w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jan 2011 08:57:52 -0500
Received: by mail-fx0-f46.google.com with SMTP id 20so4042379fxm.19
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jan 2011 05:57:51 -0800 (PST)
In-Reply-To: <1295877451-16602-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, Eric.Moore@lsi.com
Cc: Tejun Heo <tj@kernel.org>

mptscsih_suspend() does flush_scheduled_work() but mptscsih is the
only one using the system_wq.  Make mptspi use its own workqueue, and
on suspend, flush it and then call mptscsih_suspend().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Eric Moore <Eric.Moore@lsi.com>
---
 drivers/message/fusion/mptscsih.c |    1 -
 drivers/message/fusion/mptspi.c   |   33 ++++++++++++++++++++++++++++-----
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 59b8f53..c99043a 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1227,7 +1227,6 @@ mptscsih_suspend(struct pci_dev *pdev, pm_message_t state)
 	MPT_ADAPTER 		*ioc = pci_get_drvdata(pdev);
 
 	scsi_block_requests(ioc->sh);
-	flush_scheduled_work();
 	mptscsih_shutdown(pdev);
 	return mpt_suspend(pdev,state);
 }
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 6d9568d..e7de938 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -90,6 +90,7 @@ static int mptspi_write_spi_device_pg1(struct scsi_target *,
 				       struct _CONFIG_PAGE_SCSI_DEVICE_1 *);
 
 static struct scsi_transport_template *mptspi_transport_template = NULL;
+static struct workqueue_struct *mptspi_wq;
 
 static u8	mptspiDoneCtx = MPT_MAX_PROTOCOL_DRIVERS;
 static u8	mptspiTaskCtx = MPT_MAX_PROTOCOL_DRIVERS;
@@ -1150,7 +1151,7 @@ static void mpt_dv_raid(struct _MPT_SCSI_HOST *hd, int disk)
 	wqw->hd = hd;
 	wqw->disk = disk;
 
-	schedule_work(&wqw->work);
+	queue_work(mptspi_wq, &wqw->work);
 }
 
 static int
@@ -1281,7 +1282,7 @@ mptspi_dv_renegotiate(struct _MPT_SCSI_HOST *hd)
 	INIT_WORK(&wqw->work, mptspi_dv_renegotiate_work);
 	wqw->hd = hd;
 
-	schedule_work(&wqw->work);
+	queue_work(mptspi_wq, &wqw->work);
 }
 
 /*
@@ -1524,6 +1525,18 @@ out_mptspi_probe:
 	return error;
 }
 
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/*
+ *	mptspi_suspend - Fusion MPT SPI driver suspend routine.
+ *
+ *
+ */
+int mptspi_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	flush_workqueue(mptspi_wq);
+	return mptscsih_suspend(pdev, state);
+}
+
 static struct pci_driver mptspi_driver = {
 	.name		= "mptspi",
 	.id_table	= mptspi_pci_table,
@@ -1531,7 +1544,7 @@ static struct pci_driver mptspi_driver = {
 	.remove		= __devexit_p(mptscsih_remove),
 	.shutdown	= mptscsih_shutdown,
 #ifdef CONFIG_PM
-	.suspend	= mptscsih_suspend,
+	.suspend	= mptspi_suspend,
 	.resume		= mptspi_resume,
 #endif
 };
@@ -1549,9 +1562,15 @@ mptspi_init(void)
 
 	show_mptmod_ver(my_NAME, my_VERSION);
 
+	mptspi_wq = alloc_workqueue("mptspi", 0, 0);
+	if (!mptspi_wq)
+		return -ENOMEM;
+
 	mptspi_transport_template = spi_attach_transport(&mptspi_transport_functions);
-	if (!mptspi_transport_template)
+	if (!mptspi_transport_template) {
+		destroy_workqueue(mptspi_wq);
 		return -ENODEV;
+	}
 
 	mptspiDoneCtx = mpt_register(mptscsih_io_done, MPTSPI_DRIVER,
 	    "mptscsih_io_done");
@@ -1564,8 +1583,10 @@ mptspi_init(void)
 	mpt_reset_register(mptspiDoneCtx, mptspi_ioc_reset);
 
 	error = pci_register_driver(&mptspi_driver);
-	if (error)
+	if (error) {
+		destroy_workqueue(mptspi_wq);
 		spi_release_transport(mptspi_transport_template);
+	}
 
 	return error;
 }
@@ -1587,6 +1608,8 @@ mptspi_exit(void)
 	mpt_deregister(mptspiTaskCtx);
 	mpt_deregister(mptspiDoneCtx);
 	spi_release_transport(mptspi_transport_template);
+
+	destroy_workqueue(mptspi_wq);
 }
 
 module_init(mptspi_init);
-- 
1.7.1

