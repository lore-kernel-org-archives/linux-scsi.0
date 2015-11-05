From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: [PATCH 1/2] megaraid_sas: Fix TAPE drive not exposed attached to PERC5 controller
Date: Thu,  5 Nov 2015 21:17:37 +0530
Message-ID: <1446738458-12425-2-git-send-email-Sumit.Saxena@avagotech.com>
References: <1446738458-12425-1-git-send-email-Sumit.Saxena@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:35065 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030685AbbKEPsL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2015 10:48:11 -0500
Received: by pacrf6 with SMTP id rf6so11262265pac.2
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2015 07:48:10 -0800 (PST)
In-Reply-To: <1446738458-12425-1-git-send-email-Sumit.Saxena@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jbottomley@odin.com, martin.petersen@oracle.com, thenzl@redhat.com
Cc: kashyap.desai@avagotech.com, Sumit Saxena <sumit.saxena@avagotech.com>

DELL PERC5 controller's(device ID- 0x0015) firmware does not expose TAPE drives to driver in response of DCMD- MR_DCMD_PD_LIST_QUERY and it causes TAPE drives not be
exposed to OS when connected behind PERC5 controller. This patch will unblock scanning of TAPE drives connected behind PERC5 controller by exposing non TYPE_DISK
unconditionally. This patch should be applied on top of last 2 patch series submitted by me. Here is the links for those series-
http://marc.info/?l=linux-scsi&m=144489694505390&w=2      and   http://marc.info/?l=linux-scsi&m=144102204225400&w=2

Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas.h      |    1 +
 drivers/scsi/megaraid/megaraid_sas_base.c |   20 +++++++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 9b918ab..86572ee 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1790,6 +1790,7 @@ struct megasas_instance {
 	u8 UnevenSpanSupport;
 
 	u8 supportmax256vd;
+	u8 allow_fw_scan;
 	u16 fw_supported_vd_count;
 	u16 fw_supported_pd_count;
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index f8d5455..dfe1a3a 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1760,6 +1760,20 @@ static void megasas_set_dma_alignment(struct scsi_device *sdev)
 
 static int megasas_slave_configure(struct scsi_device *sdev)
 {
+	u16 pd_index = 0;
+	struct megasas_instance *instance;
+
+	instance = megasas_lookup_instance(sdev->host->host_no);
+	if (instance->allow_fw_scan) {
+		if (sdev->channel < MEGASAS_MAX_PD_CHANNELS &&
+			sdev->type == TYPE_DISK) {
+			pd_index = (sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) +
+				sdev->id;
+			if (instance->pd_list[pd_index].driveState !=
+				MR_PD_STATE_SYSTEM)
+				return -ENXIO;
+		}
+	}
 	megasas_set_dma_alignment(sdev);
 	/*
 	 * The RAID firmware may require extended timeouts.
@@ -1783,9 +1797,8 @@ static int megasas_slave_alloc(struct scsi_device *sdev)
 		pd_index =
 			(sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) +
 			sdev->id;
-		if ((instance->pd_list[pd_index].driveState ==
-			MR_PD_STATE_SYSTEM) ||
-			(instance->pd_list[pd_index].driveType != TYPE_DISK)) {
+		if ((instance->allow_fw_scan || instance->pd_list[pd_index].driveState ==
+			MR_PD_STATE_SYSTEM)) {
 			return 0;
 		}
 		return -ENXIO;
@@ -4699,6 +4712,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	case PCI_DEVICE_ID_DELL_PERC5:
 	default:
 		instance->instancet = &megasas_instance_template_xscale;
+		instance->allow_fw_scan = 1;
 		break;
 	}
 
-- 
1.7.1

