From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 6/13] mpt2sas: Identify Dell series-7 adapters at driver load time
Date: Mon, 13 Apr 2009 22:31:47 -0600
Message-ID: <20090414043145.GG20124@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3og59.obsmtp.com ([64.18.14.183]:59728 "EHLO
	chip3og59.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbZDNSF4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2009 14:05:56 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id n3EI5sHm004654
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2009 11:05:54 -0700 (PDT)
Received: from localhost (emoore-test1.co.lsil.com [172.21.46.33])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id n3EI5wjb020918
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2009 11:05:58 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The Dell branding along with the VID, DID, SSVID, SSDID following the LSI
branding that contains the card firmware/chip/bios versions.  If the SSDID
is not known but it is a Dell HBA, the driver will print the SSDID instead
of the Dell branding string.  Nothing will be printed for non Dell HBAs

Signed-off-by: Eric Moore <eric.moore@lsi.com>

diff -uaprN a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c	2009-04-09 16:43:07.000000000 -0600
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c	2009-04-13 15:35:02.000000000 -0600
@@ -1396,6 +1396,64 @@ mpt2sas_base_put_smid_target_assist(stru
 }
 
 /**
+ * _base_display_dell_branding - Disply branding string
+ * @ioc: per adapter object
+ *
+ * Return nothing.
+ */
+static void
+_base_display_dell_branding(struct MPT2SAS_ADAPTER *ioc)
+{
+	char dell_branding[MPT2SAS_DELL_BRANDING_SIZE];
+
+	if (ioc->pdev->subsystem_vendor != PCI_VENDOR_ID_DELL)
+		return;
+
+	memset(dell_branding, 0, MPT2SAS_DELL_BRANDING_SIZE);
+	switch (ioc->pdev->subsystem_device) {
+	case MPT2SAS_DELL_6GBPS_SAS_HBA_SSDID:
+		strncpy(dell_branding, MPT2SAS_DELL_6GBPS_SAS_HBA_BRANDING,
+		    MPT2SAS_DELL_BRANDING_SIZE - 1);
+		break;
+	case MPT2SAS_DELL_PERC_H200_ADAPTER_SSDID:
+		strncpy(dell_branding, MPT2SAS_DELL_PERC_H200_ADAPTER_BRANDING,
+		    MPT2SAS_DELL_BRANDING_SIZE - 1);
+		break;
+	case MPT2SAS_DELL_PERC_H200_INTEGRATED_SSDID:
+		strncpy(dell_branding,
+		    MPT2SAS_DELL_PERC_H200_INTEGRATED_BRANDING,
+		    MPT2SAS_DELL_BRANDING_SIZE - 1);
+		break;
+	case MPT2SAS_DELL_PERC_H200_MODULAR_SSDID:
+		strncpy(dell_branding,
+		    MPT2SAS_DELL_PERC_H200_MODULAR_BRANDING,
+		    MPT2SAS_DELL_BRANDING_SIZE - 1);
+		break;
+	case MPT2SAS_DELL_PERC_H200_EMBEDDED_SSDID:
+		strncpy(dell_branding,
+		    MPT2SAS_DELL_PERC_H200_EMBEDDED_BRANDING,
+		    MPT2SAS_DELL_BRANDING_SIZE - 1);
+		break;
+	case MPT2SAS_DELL_PERC_H200_SSDID:
+		strncpy(dell_branding, MPT2SAS_DELL_PERC_H200_BRANDING,
+		    MPT2SAS_DELL_BRANDING_SIZE - 1);
+		break;
+	case MPT2SAS_DELL_6GBPS_SAS_SSDID:
+		strncpy(dell_branding, MPT2SAS_DELL_6GBPS_SAS_BRANDING,
+		    MPT2SAS_DELL_BRANDING_SIZE - 1);
+		break;
+	default:
+		sprintf(dell_branding, "0x%4X", ioc->pdev->subsystem_device);
+		break;
+	}
+
+	printk(MPT2SAS_INFO_FMT "%s: Vendor(0x%04X), Device(0x%04X),"
+	    " SSVID(0x%04X), SSDID(0x%04X)\n", ioc->name, dell_branding,
+	    ioc->pdev->vendor, ioc->pdev->device, ioc->pdev->subsystem_vendor,
+	    ioc->pdev->subsystem_device);
+}
+
+/**
  * _base_display_ioc_capabilities - Disply IOC's capabilities.
  * @ioc: per adapter object
  *
@@ -1436,6 +1494,8 @@ _base_display_ioc_capabilities(struct MP
 		i++;
 	}
 
+	_base_display_dell_branding(ioc);
+
 	i = 0;
 	printk("), ");
 	printk("Capabilities=(");
diff -uaprN a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h	2009-04-09 16:43:07.000000000 -0600
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h	2009-04-13 15:37:15.000000000 -0600
@@ -130,6 +130,30 @@
 #define MPT2SAS_ERR_FMT			KERN_ERR MPT2SAS_FMT
 
 /*
+ * Dell HBA branding
+ */
+#define MPT2SAS_DELL_BRANDING_SIZE                 32
+
+#define MPT2SAS_DELL_6GBPS_SAS_HBA_BRANDING        "Dell 6Gbps SAS HBA"
+#define MPT2SAS_DELL_PERC_H200_ADAPTER_BRANDING    "Dell PERC H200 Adapter"
+#define MPT2SAS_DELL_PERC_H200_INTEGRATED_BRANDING "Dell PERC H200 Integrated"
+#define MPT2SAS_DELL_PERC_H200_MODULAR_BRANDING    "Dell PERC H200 Modular"
+#define MPT2SAS_DELL_PERC_H200_EMBEDDED_BRANDING   "Dell PERC H200 Embedded"
+#define MPT2SAS_DELL_PERC_H200_BRANDING            "Dell PERC H200"
+#define MPT2SAS_DELL_6GBPS_SAS_BRANDING            "Dell 6Gbps SAS"
+
+/*
+ * Dell HBA SSDIDs
+ */
+#define MPT2SAS_DELL_6GBPS_SAS_HBA_SSDID           0x1F1C
+#define MPT2SAS_DELL_PERC_H200_ADAPTER_SSDID       0x1F1D
+#define MPT2SAS_DELL_PERC_H200_INTEGRATED_SSDID    0x1F1E
+#define MPT2SAS_DELL_PERC_H200_MODULAR_SSDID       0x1F1F
+#define MPT2SAS_DELL_PERC_H200_EMBEDDED_SSDID      0x1F20
+#define MPT2SAS_DELL_PERC_H200_SSDID               0x1F21
+#define MPT2SAS_DELL_6GBPS_SAS_SSDID               0x1F22
+
+/*
  * per target private data
  */
 #define MPT_TARGET_FLAGS_RAID_COMPONENT	0x01
