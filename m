From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 2/5] mpt fusion: Added msi enable disable for FC,SPI and SAS
Date: Tue, 6 Jan 2009 15:02:23 +0530
Message-ID: <20090106093141.GD13033@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og113.obsmtp.com ([64.18.2.179]:36077 "EHLO
	exprod7og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbZAFJv5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2009 04:51:57 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: eric.moore@lsi.com, sathyap@lsi.com, James.Bottomley@HansenPartnership.com


Added support for MSI enable/disable for different buses FC,SPI,SAS instead
of having single MSI enable/disable feature.
---

Signed-off-by: Kashyap Desai <kadesai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index c4e8b9a..55d9a7e 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -79,9 +79,22 @@ MODULE_VERSION(my_VERSION);
 /*
  *  cmd line parameters
  */
-static int mpt_msi_enable = -1;
-module_param(mpt_msi_enable, int, 0);
-MODULE_PARM_DESC(mpt_msi_enable, " MSI Support Enable (default=0)");
+
+static int mpt_msi_enable_spi;
+module_param(mpt_msi_enable_spi, int, 0);
+MODULE_PARM_DESC(mpt_msi_enable_spi, " Enable MSI Support for SPI \
+		controllers (default=0)");
+
+static int mpt_msi_enable_fc;
+module_param(mpt_msi_enable_fc, int, 0);
+MODULE_PARM_DESC(mpt_msi_enable_fc, " Enable MSI Support for FC \
+		controllers (default=0)");
+
+static int mpt_msi_enable_sas;
+module_param(mpt_msi_enable_sas, int, 0);
+MODULE_PARM_DESC(mpt_msi_enable_sas, " Enable MSI Support for SAS \
+		controllers (default=0)");
+
 
 static int mpt_channel_mapping;
 module_param(mpt_channel_mapping, int, 0);
@@ -91,7 +104,9 @@ static int mpt_debug_level;
 static int mpt_set_debug_level(const char *val, struct kernel_param *kp);
 module_param_call(mpt_debug_level, mpt_set_debug_level, param_get_int,
 		  &mpt_debug_level, 0600);
-MODULE_PARM_DESC(mpt_debug_level, " debug level - refer to mptdebug.h - (default=0)");
+MODULE_PARM_DESC(mpt_debug_level, " debug level - refer to mptdebug.h \
+	- (default=0)");
+
 
 #ifdef MFCNT
 static int mfcounter = 0;
@@ -1751,16 +1766,25 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 		ioc->bus_type = SAS;
 	}
 
-	if (mpt_msi_enable == -1) {
-		/* Enable on SAS, disable on FC and SPI */
-		if (ioc->bus_type == SAS)
-			ioc->msi_enable = 1;
-		else
-			ioc->msi_enable = 0;
-	} else
-		/* follow flag: 0 - disable; 1 - enable */
-		ioc->msi_enable = mpt_msi_enable;
 
+	switch (ioc->bus_type) {
+
+	case SAS:
+		ioc->msi_enable = mpt_msi_enable_sas;
+		break;
+
+	case SPI:
+		ioc->msi_enable = mpt_msi_enable_spi;
+		break;
+
+	case FC:
+		ioc->msi_enable = mpt_msi_enable_fc;
+		break;
+
+	default:
+		ioc->msi_enable = 0;
+		break;
+	}
 	if (ioc->errata_flag_1064)
 		pci_disable_io_access(pdev);
 
