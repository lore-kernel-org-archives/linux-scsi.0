From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH] - mpt fusion - resend negotiation parameters after host reset and resume
Date: Tue, 25 Apr 2006 17:38:58 -0600
Message-ID: <20060425233858.GB9424@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:38644 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932310AbWDYXkL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Apr 2006 19:40:11 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id k3PNYCNI027913
	for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2006 16:34:12 -0700 (PDT)
Received: from localhost (emoore-test1.co.lsil.com [172.21.48.27])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id k3PNeA7A010918
	for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2006 16:40:10 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a bug fix for mptspi driver, where after a host reset
or resume, we resend the negotiation parameters to all devices.
This bug was introduced when the driver was ported to use
the spi transport layer.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


diff -uarN b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2006-04-21 10:47:41.000000000 -0600
+++ a/drivers/message/fusion/mptspi.c	2006-04-21 10:53:25.000000000 -0600
@@ -783,6 +783,70 @@
 };
 MODULE_DEVICE_TABLE(pci, mptspi_pci_table);
 
+
+/*
+ * renegotiate for a given target
+ */
+static void
+mptspi_dv_renegotiate_work(void *data)
+{
+	struct work_queue_wrapper *wqw = (struct work_queue_wrapper *)data;
+	struct _MPT_SCSI_HOST *hd = wqw->hd;
+	struct scsi_device *sdev;
+
+	kfree(wqw);
+
+	shost_for_each_device(sdev, hd->ioc->sh)
+		mptspi_dv_device(hd, sdev);
+}
+
+static void
+mptspi_dv_renegotiate(struct _MPT_SCSI_HOST *hd)
+{
+	struct work_queue_wrapper *wqw = kmalloc(sizeof(*wqw), GFP_ATOMIC);
+
+	if (!wqw)
+		return;
+
+	INIT_WORK(&wqw->work, mptspi_dv_renegotiate_work, wqw);
+	wqw->hd = hd;
+
+	schedule_work(&wqw->work);
+}
+
+/*
+ * spi module reset handler
+ */
+static int
+mptspi_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
+{
+	struct _MPT_SCSI_HOST *hd = (struct _MPT_SCSI_HOST *)ioc->sh->hostdata;
+	int rc;
+
+	rc = mptscsih_ioc_reset(ioc, reset_phase);
+
+	if (reset_phase == MPT_IOC_POST_RESET)
+		mptspi_dv_renegotiate(hd);
+
+	return rc;
+}
+
+/*
+ * spi module resume handler
+ */
+static int
+mptspi_resume(struct pci_dev *pdev)
+{
+	MPT_ADAPTER 	*ioc = pci_get_drvdata(pdev);
+	struct _MPT_SCSI_HOST *hd = (struct _MPT_SCSI_HOST *)ioc->sh->hostdata;
+	int rc;
+
+	rc = mptscsih_resume(pdev);
+	mptspi_dv_renegotiate(hd);
+
+	return rc;
+}
+
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
@@ -1032,7 +1096,7 @@
 	.shutdown	= mptscsih_shutdown,
 #ifdef CONFIG_PM
 	.suspend	= mptscsih_suspend,
-	.resume		= mptscsih_resume,
+	.resume		= mptspi_resume,
 #endif
 };
 
@@ -1061,7 +1125,7 @@
 		  ": Registered for IOC event notifications\n"));
 	}
 
-	if (mpt_reset_register(mptspiDoneCtx, mptscsih_ioc_reset) == 0) {
+	if (mpt_reset_register(mptspiDoneCtx, mptspi_ioc_reset) == 0) {
 		dprintk((KERN_INFO MYNAM
 		  ": Registered for IOC reset notifications\n"));
 	}
 
