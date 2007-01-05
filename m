From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH 3/5] fusion: power pc and miscellaneous bug fixs
Date: Thu, 4 Jan 2007 20:46:54 -0700
Message-ID: <20070105034654.GA14122@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:43929 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030316AbXAEDpH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Jan 2007 22:45:07 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

* Endian fix's for warnings found in ppc environment.
* Fix compile time warning when calling scsi_device_reprobe, where
in newer kernels this API expects its return value to be examined.
* Fix compile errors when debug messages are enabled.

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>


diff -uarpN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2006-12-23 21:00:32.000000000 -0700
+++ a/drivers/message/fusion/mptbase.h	2006-12-25 00:35:10.000000000 -0700
@@ -1059,7 +1059,7 @@ extern int		  mpt_stm_index;	/* needed b
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 #endif		/* } __KERNEL__ */
 
-#if defined(__alpha__) || defined(__sparc_v9__) || defined(__ia64__) || defined(__x86_64__)
+#if defined(__alpha__) || defined(__sparc_v9__) || defined(__ia64__) || defined(__x86_64__) || defined(__powerpc__)
 #define CAST_U32_TO_PTR(x)	((void *)(u64)x)
 #define CAST_PTR_TO_U32(x)	((u32)(u64)x)
 #else
diff -uarpN b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2006-12-23 21:00:32.000000000 -0700
+++ a/drivers/message/fusion/mptsas.c	2006-12-25 00:54:43.000000000 -0700
@@ -245,7 +245,8 @@ static void mptsas_print_device_pg0(SasD
 	printk("Parent Handle=0x%X\n" ,le16_to_cpu(pg0->ParentDevHandle));
 	printk("Enclosure Handle=0x%X\n", le16_to_cpu(pg0->EnclosureHandle));
 	printk("Slot=0x%X\n", le16_to_cpu(pg0->Slot));
-	printk("SAS Address=0x%llX\n", le64_to_cpu(sas_address));
+	printk("SAS Address=0x%llX\n", (unsigned long long)
+	    le64_to_cpu(sas_address));
 	printk("Target ID=0x%X\n", pg0->TargetID);
 	printk("Bus=0x%X\n", pg0->Bus);
 	/* The PhyNum field specifies the PHY number of the parent
@@ -349,9 +350,9 @@ mptsas_port_delete(struct mptsas_portinf
 	phy_info = port_info->phy_info;
 
 	dsaswideprintk((KERN_DEBUG "%s: [%p]: num_phys=%02d "
-	    	"bitmask=0x%016llX\n",
-		__FUNCTION__, port_details, port_details->num_phys,
-		    port_details->phy_bitmask));
+	    "bitmask=0x%016llX\n", __FUNCTION__, port_details,
+	    port_details->num_phys, (unsigned long long)
+	    port_details->phy_bitmask));
 
 	for (i = 0; i < port_info->num_phys; i++, phy_info++) {
 		if(phy_info->port_details != port_details)
@@ -476,7 +477,7 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc
 	for (i = 0 ; i < port_info->num_phys ; i++, phy_info++) {
 		sas_address = phy_info->attached.sas_address;
 		dsaswideprintk((KERN_DEBUG "phy_id=%d sas_address=0x%018llX\n",
-			i, sas_address));
+		    i, (unsigned long long)sas_address));
 		if (!sas_address)
 			continue;
 		port_details = phy_info->port_details;
@@ -495,8 +496,8 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc
 				    (1 << phy_info->phy_id);
 			phy_info->sas_port_add_phy=1;
 			dsaswideprintk((KERN_DEBUG "\t\tForming port\n\t\t"
-				"phy_id=%d sas_address=0x%018llX\n",
-				i, sas_address));
+			    "phy_id=%d sas_address=0x%018llX\n",
+			    i, (unsigned long long)sas_address));
 			phy_info->port_details = port_details;
 		}
 
@@ -512,8 +513,9 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc
 			if (phy_info_cmp->port_details == port_details )
 				continue;
 			dsaswideprintk((KERN_DEBUG
-				"\t\tphy_id=%d sas_address=0x%018llX\n",
-				j, phy_info_cmp->attached.sas_address));
+			    "\t\tphy_id=%d sas_address=0x%018llX\n",
+			    j, (unsigned long long)
+			    phy_info_cmp->attached.sas_address));
 			if (phy_info_cmp->port_details) {
 				port_details->rphy =
 				    mptsas_get_rphy(phy_info_cmp);
@@ -546,11 +548,10 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc
 		if (!port_details)
 			continue;
 		dsaswideprintk((KERN_DEBUG
-			"%s: [%p]: phy_id=%02d num_phys=%02d "
-		    	"bitmask=0x%016llX\n",
-			__FUNCTION__,
-			port_details, i, port_details->num_phys,
-			port_details->phy_bitmask));
+		    "%s: [%p]: phy_id=%02d num_phys=%02d "
+		    "bitmask=0x%016llX\n", __FUNCTION__,
+		    port_details, i, port_details->num_phys,
+		    (unsigned long long)port_details->phy_bitmask));
 		dsaswideprintk((KERN_DEBUG"\t\tport = %p rphy=%p\n",
 			port_details->port, port_details->rphy));
 	}
@@ -2079,8 +2080,10 @@ mptsas_persist_clear_table(struct work_s
 static void
 mptsas_reprobe_lun(struct scsi_device *sdev, void *data)
 {
+	int rc;
+
 	sdev->no_uld_attach = data ? 1 : 0;
-	scsi_device_reprobe(sdev);
+	rc = scsi_device_reprobe(sdev);
 }
 
 static void
diff -uarpN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2006-12-25 01:55:05.000000000 -0700
+++ a/drivers/message/fusion/mptscsih.c	2006-12-25 01:55:24.000000000 -0700
@@ -2699,7 +2699,8 @@ mptscsih_initTarget(MPT_SCSI_HOST *hd, V
 		    struct scsi_device *sdev)
 {
 	dinitprintk((MYIOC_s_INFO_FMT "initTarget bus=%d id=%d lun=%d hd=%p\n",
-		hd->ioc->name, vtarget->bus_id, vtarget->target_id, lun, hd));
+		hd->ioc->name, vtarget->bus_id, vtarget->target_id,
+		sdev->lun, hd));
 
 	/* Is LUN supported? If so, upper 2 bits will be 0
 	* in first byte of inquiry data.
@@ -2781,7 +2782,7 @@ mptscsih_setTargetNegoParms(MPT_SCSI_HOS
 				else {
 					factor = MPT_ULTRA320;
 					if (scsi_device_qas(sdev)) {
-						ddvtprintk((KERN_INFO "Enabling QAS due to byte56=%02x on id=%d!\n", byte56, id));
+						ddvtprintk((KERN_INFO "Enabling QAS due to byte56=%02x on id=%d!\n", scsi_device_qas(sdev), id));
 						noQas = 0;
 					}
 					if (sdev->type == TYPE_TAPE &&
