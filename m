From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH] fusion - bug fix - poor performance after host reset
Date: Sat, 29 Apr 2006 20:04:18 -0600
Message-ID: <20060430020418.GA27536@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:14502 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750862AbWD3CGP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Apr 2006 22:06:15 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com

This effects all U320 LSI Logic controllers, such as 53C1030
(not megaraid).

If there is any error recovery that results in a host reset,
all the devices will end up at the slowest possible speed,
e.g. asyn narrow.

To reproduce, you will need a 2.6.17-rc series kernel, and do

# hdparm -t /dev/sda  (notice the seq. read transfer rate)

# sg_reset -h /dev/sg0

# hdparm -t /dev/sda (notice the transfer rate drop to about 2 MB/s).

What this patch does is kick of domain validation after host reset, so
all device renogiate at their best rates.  The host reset had placed \
all devices at defaults settings, which is asyn narrow.

This issue was only introduced since release of 2.6.16 kernel.
This is urgent bug fix for 2.6.17-rc4.

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
 
