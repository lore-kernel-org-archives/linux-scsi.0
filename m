From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v2 13/39] megaraid_sas: raid 1 write performance for large io
Date: Wed,  8 Feb 2017 01:29:07 -0800
Message-ID: <1486546173-20713-14-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:35825 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754109AbdBHJao (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2017 04:30:44 -0500
Received: by mail-pf0-f171.google.com with SMTP id f144so41076156pfa.2
        for <linux-scsi@vger.kernel.org>; Wed, 08 Feb 2017 01:30:33 -0800 (PST)
In-Reply-To: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Avoid Host side PCI bandwidth bottleneck and hint FW to do Write buffering using
RaidFlag MR_RAID_FLAGS_IO_SUB_TYPE_LDIO_BW_LIMIT.
Once IO is landed in FW with MR_RAID_FLAGS_IO_SUB_TYPE_LDIO_BW_LIMIT,
it will do single DMA from host and buffer the Write operation. On back end,
FW will DMA same buffer to the Mirror and Data Arm.
This will improve large block IO performance which bottleneck due to Host side PCI bandwidth limitation.

Consistent ~4000MB T.P for 256K Block size is expected performance numbers.
IOPS for small Block size should be on par with Disk performance.
(E.g 42 SAS Disk in JBOD mode gives 3700MB T.P.
Same Drive used in R1 WT mode, should give ~1800MB T.P)

Using this patch 24 R1 VDs (HDD) gives below performance for Sequential Write.
Without this patch, we cannot reach above 3200MB (Throughput is in MB. )

Block Size   	50% 256K and 50% 4K          100% 256K
4K                 3100                        2030
8K                 3140                        2740
16K                3140                        3140
32K                3400                        3240
64K                3500                        3700
128K               3870                        3870
256K               3920                        3920

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        |  5 +++++
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 32 +++++++++++++++++++++++++++--
 2 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 075e2e9..bed8a37 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1409,6 +1409,8 @@ struct megasas_ctrl_info {
 #define SCAN_VD_CHANNEL	0x2
 
 #define MEGASAS_KDUMP_QUEUE_DEPTH               100
+#define MR_LARGE_IO_MIN_SIZE			(32 * 1024)
+#define MR_R1_LDIO_PIGGYBACK_DEFAULT		4
 
 enum MR_SCSI_CMD_TYPE {
 	READ_WRITE_LDIO = 0,
@@ -1875,6 +1877,7 @@ union megasas_frame {
 struct MR_PRIV_DEVICE {
 	bool is_tm_capable;
 	bool tm_busy;
+	atomic_t r1_ldio_hint;
 	u8   interface_type;
 };
 struct megasas_cmd;
@@ -2235,6 +2238,8 @@ struct megasas_instance {
 	bool is_ventura;
 	bool msix_combined;
 	u16 max_raid_mapsize;
+	/* preffered count to send as LDIO irrspective of FP capable.*/
+	u8  r1_ldio_hint_default;
 	u32 nvme_page_size;
 };
 struct MR_LD_VF_MAP {
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 379c723..edbecc5 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1383,6 +1383,7 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
 	}
 
 	instance->flag_ieee = 1;
+	instance->r1_ldio_hint_default =  MR_R1_LDIO_PIGGYBACK_DEFAULT;
 	fusion->fast_path_io = 0;
 
 	fusion->drv_map_pages = get_order(fusion->drv_map_sz);
@@ -2110,7 +2111,7 @@ static void megasas_stream_detect(struct megasas_instance *instance,
 static void
 megasas_set_raidflag_cpu_affinity(union RAID_CONTEXT_UNION *praid_context,
 				  struct MR_LD_RAID *raid, bool fp_possible,
-				  u8 is_read)
+				  u8 is_read, u32 scsi_buff_len)
 {
 	u8 cpu_sel = MR_RAID_CTX_CPUSEL_0;
 	struct RAID_CONTEXT_G35 *rctx_g35;
@@ -2161,6 +2162,17 @@ megasas_set_raidflag_cpu_affinity(union RAID_CONTEXT_UNION *praid_context,
 	}
 
 	rctx_g35->routing_flags.bits.cpu_sel = cpu_sel;
+
+	/* Always give priority to MR_RAID_FLAGS_IO_SUB_TYPE_LDIO_BW_LIMIT
+	 * vs MR_RAID_FLAGS_IO_SUB_TYPE_CACHE_BYPASS.
+	 * IO Subtype is not bitmap.
+	 */
+	if ((raid->level == 1) && (!is_read)) {
+		if (scsi_buff_len > MR_LARGE_IO_MIN_SIZE)
+			praid_context->raid_context_g35.raid_flags =
+				(MR_RAID_FLAGS_IO_SUB_TYPE_LDIO_BW_LIMIT
+				<< MR_RAID_CTX_RAID_FLAGS_IO_SUB_TYPE_SHIFT);
+	}
 }
 
 /**
@@ -2303,6 +2315,14 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 		    io_info.isRead && io_info.ra_capable)
 			fp_possible = false;
 
+		/* FP for Optimal raid level 1.
+		 * All large RAID-1 writes (> 32 KiB, both WT and WB modes)
+		 * are built by the driver as LD I/Os.
+		 * All small RAID-1 WT writes (<= 32 KiB) are built as FP I/Os
+		 * (there is never a reason to process these as buffered writes)
+		 * All small RAID-1 WB writes (<= 32 KiB) are built as FP I/Os
+		 * with the SLD bit asserted.
+		 */
 		if (io_info.r1_alt_dev_handle != MR_DEVHANDLE_INVALID) {
 			mrdev_priv = scp->device->hostdata;
 
@@ -2310,13 +2330,21 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 				(instance->host->can_queue)) {
 				fp_possible = false;
 				atomic_dec(&instance->fw_outstanding);
+			} else if ((scsi_buff_len > MR_LARGE_IO_MIN_SIZE) ||
+				   atomic_dec_if_positive(&mrdev_priv->r1_ldio_hint)) {
+				fp_possible = false;
+				atomic_dec(&instance->fw_outstanding);
+				if (scsi_buff_len > MR_LARGE_IO_MIN_SIZE)
+					atomic_set(&mrdev_priv->r1_ldio_hint,
+						   instance->r1_ldio_hint_default);
 			}
 		}
 
 		/* If raid is NULL, set CPU affinity to default CPU0 */
 		if (raid)
 			megasas_set_raidflag_cpu_affinity(praid_context,
-				raid, fp_possible, io_info.isRead);
+				raid, fp_possible, io_info.isRead,
+				scsi_buff_len);
 		else
 			praid_context->raid_context_g35.routing_flags.bits.cpu_sel =
 				MR_RAID_CTX_CPUSEL_0;
-- 
2.8.3
