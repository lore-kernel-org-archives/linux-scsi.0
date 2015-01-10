From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/10] megaraid_sas: add endianess annotations
Date: Sat, 10 Jan 2015 18:11:16 +0100
Message-ID: <1420909883-19479-4-git-send-email-hch@lst.de>
References: <1420909883-19479-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:34178 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431AbbAJRMU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Jan 2015 12:12:20 -0500
In-Reply-To: <1420909883-19479-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com, kashyap.desai@avagotech.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org

This adds endianess annotations to all data structures, and a few
variables directly referencing them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/megaraid/megaraid_sas.h        | 296 ++++++++++++++--------------
 drivers/scsi/megaraid/megaraid_sas_base.c   |   2 +-
 drivers/scsi/megaraid/megaraid_sas_fp.c     |  10 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   2 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.h | 276 +++++++++++++-------------
 5 files changed, 293 insertions(+), 293 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index ecc4321..81484f1 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -408,7 +408,7 @@ enum MR_PD_STATE {
  * defines the physical drive address structure
  */
 struct MR_PD_ADDRESS {
-	u16     deviceId;
+	__le16	deviceId;
 	u16     enclDeviceId;
 
 	union {
@@ -433,8 +433,8 @@ struct MR_PD_ADDRESS {
  * defines the physical drive list structure
  */
 struct MR_PD_LIST {
-	u32             size;
-	u32             count;
+	__le32		size;
+	__le32		count;
 	struct MR_PD_ADDRESS   addr[1];
 } __packed;
 
@@ -451,28 +451,28 @@ union  MR_LD_REF {
 	struct {
 		u8      targetId;
 		u8      reserved;
-		u16     seqNum;
+		__le16     seqNum;
 	};
-	u32     ref;
+	__le32     ref;
 } __packed;
 
 /*
  * defines the logical drive list structure
  */
 struct MR_LD_LIST {
-	u32     ldCount;
-	u32     reserved;
+	__le32     ldCount;
+	__le32     reserved;
 	struct {
 		union MR_LD_REF   ref;
 		u8          state;
 		u8          reserved[3];
-		u64         size;
+		__le64		size;
 	} ldList[MAX_LOGICAL_DRIVES_EXT];
 } __packed;
 
 struct MR_LD_TARGETID_LIST {
-	u32	size;
-	u32	count;
+	__le32	size;
+	__le32	count;
 	u8	pad[3];
 	u8	targetId[MAX_LOGICAL_DRIVES_EXT];
 };
@@ -553,7 +553,7 @@ struct megasas_ctrl_prop {
 	} OnOffProperties;
 	u8 autoSnapVDSpace;
 	u8 viewSpace;
-	u16 spinDownTime;
+	__le16 spinDownTime;
 	u8  reserved[24];
 } __packed;
 
@@ -567,10 +567,10 @@ struct megasas_ctrl_info {
 	 */
 	struct {
 
-		u16 vendor_id;
-		u16 device_id;
-		u16 sub_vendor_id;
-		u16 sub_device_id;
+		__le16 vendor_id;
+		__le16 device_id;
+		__le16 sub_vendor_id;
+		__le16 sub_device_id;
 		u8 reserved[24];
 
 	} __attribute__ ((packed)) pci;
@@ -611,8 +611,8 @@ struct megasas_ctrl_info {
 	/*
 	 * List of components residing in flash. All str are null terminated
 	 */
-	u32 image_check_word;
-	u32 image_component_count;
+	__le32 image_check_word;
+	__le32 image_component_count;
 
 	struct {
 
@@ -629,7 +629,7 @@ struct megasas_ctrl_info {
 	 * empty if a flash operation has not occurred. All stings are null
 	 * terminated
 	 */
-	u32 pending_image_component_count;
+	__le32 pending_image_component_count;
 
 	struct {
 
@@ -662,39 +662,39 @@ struct megasas_ctrl_info {
 
 	} __attribute__ ((packed)) hw_present;
 
-	u32 current_fw_time;
+	__le32 current_fw_time;
 
 	/*
 	 * Maximum data transfer sizes
 	 */
-	u16 max_concurrent_cmds;
-	u16 max_sge_count;
-	u32 max_request_size;
+	__le16 max_concurrent_cmds;
+	__le16 max_sge_count;
+	__le32 max_request_size;
 
 	/*
 	 * Logical and physical device counts
 	 */
-	u16 ld_present_count;
-	u16 ld_degraded_count;
-	u16 ld_offline_count;
+	__le16 ld_present_count;
+	__le16 ld_degraded_count;
+	__le16 ld_offline_count;
 
-	u16 pd_present_count;
-	u16 pd_disk_present_count;
-	u16 pd_disk_pred_failure_count;
-	u16 pd_disk_failed_count;
+	__le16 pd_present_count;
+	__le16 pd_disk_present_count;
+	__le16 pd_disk_pred_failure_count;
+	__le16 pd_disk_failed_count;
 
 	/*
 	 * Memory size information
 	 */
-	u16 nvram_size;
-	u16 memory_size;
-	u16 flash_size;
+	__le16 nvram_size;
+	__le16 memory_size;
+	__le16 flash_size;
 
 	/*
 	 * Error counters
 	 */
-	u16 mem_correctable_error_count;
-	u16 mem_uncorrectable_error_count;
+	__le16 mem_correctable_error_count;
+	__le16 mem_uncorrectable_error_count;
 
 	/*
 	 * Cluster information
@@ -705,7 +705,7 @@ struct megasas_ctrl_info {
 	/*
 	 * Additional max data transfer sizes
 	 */
-	u16 max_strips_per_io;
+	__le16 max_strips_per_io;
 
 	/*
 	 * Controller capabilities structures
@@ -805,7 +805,7 @@ struct megasas_ctrl_info {
 	* deviceInterface.portAddr, and the rest shall be
 	* populated in deviceInterfacePortAddr2.
 	*/
-	u64         deviceInterfacePortAddr2[8]; /*6a0h */
+	__le64	    deviceInterfacePortAddr2[8]; /*6a0h */
 	u8          reserved3[128];              /*6e0h */
 
 	struct {                                /*760h */
@@ -842,26 +842,26 @@ struct megasas_ctrl_info {
 		u16 reserved[6];
 	} pdsForRaidLevels;
 
-	u16 maxPds;                             /*780h */
-	u16 maxDedHSPs;                         /*782h */
-	u16 maxGlobalHSPs;                      /*784h */
-	u16 ddfSize;                            /*786h */
+	__le16 maxPds;                          /*780h */
+	__le16 maxDedHSPs;                      /*782h */
+	__le16 maxGlobalHSP;                    /*784h */
+	__le16 ddfSize;                         /*786h */
 	u8  maxLdsPerArray;                     /*788h */
 	u8  partitionsInDDF;                    /*789h */
 	u8  lockKeyBinding;                     /*78ah */
 	u8  maxPITsPerLd;                       /*78bh */
 	u8  maxViewsPerLd;                      /*78ch */
 	u8  maxTargetId;                        /*78dh */
-	u16 maxBvlVdSize;                       /*78eh */
+	__le16 maxBvlVdSize;                    /*78eh */
 
-	u16 maxConfigurableSSCSize;             /*790h */
-	u16 currentSSCsize;                     /*792h */
+	__le16 maxConfigurableSSCSize;          /*790h */
+	__le16 currentSSCsize;                  /*792h */
 
 	char    expanderFwVersion[12];          /*794h */
 
-	u16 PFKTrialTimeRemaining;              /*7A0h */
+	__le16 PFKTrialTimeRemaining;           /*7A0h */
 
-	u16 cacheMemorySize;                    /*7A2h */
+	__le16 cacheMemorySize;                 /*7A2h */
 
 	struct {                                /*7A4h */
 #if   defined(__BIG_ENDIAN_BITFIELD)
@@ -931,7 +931,7 @@ struct megasas_ctrl_info {
 	u8  temperatureROC;                     /*7C9h */
 	u8  temperatureCtrl;                    /*7CAh */
 	u8  reserved4;                          /*7CBh */
-	u16 maxConfigurablePds;                 /*7CCh */
+	__le16 maxConfigurablePds;              /*7CCh */
 
 
 	u8  reserved5[2];                       /*0x7CDh */
@@ -1172,22 +1172,22 @@ struct megasas_register_set {
 
 struct megasas_sge32 {
 
-	u32 phys_addr;
-	u32 length;
+	__le32 phys_addr;
+	__le32 length;
 
 } __attribute__ ((packed));
 
 struct megasas_sge64 {
 
-	u64 phys_addr;
-	u32 length;
+	__le64 phys_addr;
+	__le32 length;
 
 } __attribute__ ((packed));
 
 struct megasas_sge_skinny {
-	u64 phys_addr;
-	u32 length;
-	u32 flag;
+	__le64 phys_addr;
+	__le32 length;
+	__le32 flag;
 } __packed;
 
 union megasas_sgl {
@@ -1210,12 +1210,12 @@ struct megasas_header {
 	u8 cdb_len;		/*06h */
 	u8 sge_count;		/*07h */
 
-	u32 context;		/*08h */
-	u32 pad_0;		/*0Ch */
+	__le32 context;		/*08h */
+	__le32 pad_0;		/*0Ch */
 
-	u16 flags;		/*10h */
-	u16 timeout;		/*12h */
-	u32 data_xferlen;	/*14h */
+	__le16 flags;		/*10h */
+	__le16 timeout;		/*12h */
+	__le32 data_xferlen;	/*14h */
 
 } __attribute__ ((packed));
 
@@ -1248,7 +1248,7 @@ typedef union _MFI_CAPABILITIES {
 		u32     reserved:25;
 #endif
 	} mfi_capabilities;
-	u32     reg;
+	__le32		reg;
 } MFI_CAPABILITIES;
 
 struct megasas_init_frame {
@@ -1260,33 +1260,33 @@ struct megasas_init_frame {
 	u8 reserved_1;		/*03h */
 	MFI_CAPABILITIES driver_operations; /*04h*/
 
-	u32 context;		/*08h */
-	u32 pad_0;		/*0Ch */
+	__le32 context;		/*08h */
+	__le32 pad_0;		/*0Ch */
 
-	u16 flags;		/*10h */
-	u16 reserved_3;		/*12h */
-	u32 data_xfer_len;	/*14h */
+	__le16 flags;		/*10h */
+	__le16 reserved_3;	/*12h */
+	__le32 data_xfer_len;	/*14h */
 
-	u32 queue_info_new_phys_addr_lo;	/*18h */
-	u32 queue_info_new_phys_addr_hi;	/*1Ch */
-	u32 queue_info_old_phys_addr_lo;	/*20h */
-	u32 queue_info_old_phys_addr_hi;	/*24h */
+	__le32 queue_info_new_phys_addr_lo;	/*18h */
+	__le32 queue_info_new_phys_addr_hi;	/*1Ch */
+	__le32 queue_info_old_phys_addr_lo;	/*20h */
+	__le32 queue_info_old_phys_addr_hi;	/*24h */
 
-	u32 reserved_4[6];	/*28h */
+	__le32 reserved_4[6];	/*28h */
 
 } __attribute__ ((packed));
 
 struct megasas_init_queue_info {
 
-	u32 init_flags;		/*00h */
-	u32 reply_queue_entries;	/*04h */
+	__le32 init_flags;		/*00h */
+	__le32 reply_queue_entries;	/*04h */
 
-	u32 reply_queue_start_phys_addr_lo;	/*08h */
-	u32 reply_queue_start_phys_addr_hi;	/*0Ch */
-	u32 producer_index_phys_addr_lo;	/*10h */
-	u32 producer_index_phys_addr_hi;	/*14h */
-	u32 consumer_index_phys_addr_lo;	/*18h */
-	u32 consumer_index_phys_addr_hi;	/*1Ch */
+	__le32 reply_queue_start_phys_addr_lo;	/*08h */
+	__le32 reply_queue_start_phys_addr_hi;	/*0Ch */
+	__le32 producer_index_phys_addr_lo;	/*10h */
+	__le32 producer_index_phys_addr_hi;	/*14h */
+	__le32 consumer_index_phys_addr_lo;	/*18h */
+	__le32 consumer_index_phys_addr_hi;	/*1Ch */
 
 } __attribute__ ((packed));
 
@@ -1302,18 +1302,18 @@ struct megasas_io_frame {
 	u8 reserved_0;		/*06h */
 	u8 sge_count;		/*07h */
 
-	u32 context;		/*08h */
-	u32 pad_0;		/*0Ch */
+	__le32 context;		/*08h */
+	__le32 pad_0;		/*0Ch */
 
-	u16 flags;		/*10h */
-	u16 timeout;		/*12h */
-	u32 lba_count;		/*14h */
+	__le16 flags;		/*10h */
+	__le16 timeout;		/*12h */
+	__le32 lba_count;	/*14h */
 
-	u32 sense_buf_phys_addr_lo;	/*18h */
-	u32 sense_buf_phys_addr_hi;	/*1Ch */
+	__le32 sense_buf_phys_addr_lo;	/*18h */
+	__le32 sense_buf_phys_addr_hi;	/*1Ch */
 
-	u32 start_lba_lo;	/*20h */
-	u32 start_lba_hi;	/*24h */
+	__le32 start_lba_lo;	/*20h */
+	__le32 start_lba_hi;	/*24h */
 
 	union megasas_sgl sgl;	/*28h */
 
@@ -1331,15 +1331,15 @@ struct megasas_pthru_frame {
 	u8 cdb_len;		/*06h */
 	u8 sge_count;		/*07h */
 
-	u32 context;		/*08h */
-	u32 pad_0;		/*0Ch */
+	__le32 context;		/*08h */
+	__le32 pad_0;		/*0Ch */
 
-	u16 flags;		/*10h */
-	u16 timeout;		/*12h */
-	u32 data_xfer_len;	/*14h */
+	__le16 flags;		/*10h */
+	__le16 timeout;		/*12h */
+	__le32 data_xfer_len;	/*14h */
 
-	u32 sense_buf_phys_addr_lo;	/*18h */
-	u32 sense_buf_phys_addr_hi;	/*1Ch */
+	__le32 sense_buf_phys_addr_lo;	/*18h */
+	__le32 sense_buf_phys_addr_hi;	/*1Ch */
 
 	u8 cdb[16];		/*20h */
 	union megasas_sgl sgl;	/*30h */
@@ -1354,19 +1354,19 @@ struct megasas_dcmd_frame {
 	u8 reserved_1[4];	/*03h */
 	u8 sge_count;		/*07h */
 
-	u32 context;		/*08h */
-	u32 pad_0;		/*0Ch */
+	__le32 context;		/*08h */
+	__le32 pad_0;		/*0Ch */
 
-	u16 flags;		/*10h */
-	u16 timeout;		/*12h */
+	__le16 flags;		/*10h */
+	__le16 timeout;		/*12h */
 
-	u32 data_xfer_len;	/*14h */
-	u32 opcode;		/*18h */
+	__le32 data_xfer_len;	/*14h */
+	__le32 opcode;		/*18h */
 
 	union {			/*1Ch */
 		u8 b[12];
-		u16 s[6];
-		u32 w[3];
+		__le16 s[6];
+		__le32 w[3];
 	} mbox;
 
 	union megasas_sgl sgl;	/*28h */
@@ -1380,22 +1380,22 @@ struct megasas_abort_frame {
 	u8 cmd_status;		/*02h */
 
 	u8 reserved_1;		/*03h */
-	u32 reserved_2;		/*04h */
+	__le32 reserved_2;	/*04h */
 
-	u32 context;		/*08h */
-	u32 pad_0;		/*0Ch */
+	__le32 context;		/*08h */
+	__le32 pad_0;		/*0Ch */
 
-	u16 flags;		/*10h */
-	u16 reserved_3;		/*12h */
-	u32 reserved_4;		/*14h */
+	__le16 flags;		/*10h */
+	__le16 reserved_3;	/*12h */
+	__le32 reserved_4;	/*14h */
 
-	u32 abort_context;	/*18h */
-	u32 pad_1;		/*1Ch */
+	__le32 abort_context;	/*18h */
+	__le32 pad_1;		/*1Ch */
 
-	u32 abort_mfi_phys_addr_lo;	/*20h */
-	u32 abort_mfi_phys_addr_hi;	/*24h */
+	__le32 abort_mfi_phys_addr_lo;	/*20h */
+	__le32 abort_mfi_phys_addr_hi;	/*24h */
 
-	u32 reserved_5[6];	/*28h */
+	__le32 reserved_5[6];	/*28h */
 
 } __attribute__ ((packed));
 
@@ -1409,14 +1409,14 @@ struct megasas_smp_frame {
 	u8 reserved_2[3];	/*04h */
 	u8 sge_count;		/*07h */
 
-	u32 context;		/*08h */
-	u32 pad_0;		/*0Ch */
+	__le32 context;		/*08h */
+	__le32 pad_0;		/*0Ch */
 
-	u16 flags;		/*10h */
-	u16 timeout;		/*12h */
+	__le16 flags;		/*10h */
+	__le16 timeout;		/*12h */
 
-	u32 data_xfer_len;	/*14h */
-	u64 sas_addr;		/*18h */
+	__le32 data_xfer_len;	/*14h */
+	__le64 sas_addr;	/*18h */
 
 	union {
 		struct megasas_sge32 sge32[2];	/* [0]: resp [1]: req */
@@ -1436,16 +1436,16 @@ struct megasas_stp_frame {
 	u8 reserved_3[2];	/*05h */
 	u8 sge_count;		/*07h */
 
-	u32 context;		/*08h */
-	u32 pad_0;		/*0Ch */
+	__le32 context;		/*08h */
+	__le32 pad_0;		/*0Ch */
 
-	u16 flags;		/*10h */
-	u16 timeout;		/*12h */
+	__le16 flags;		/*10h */
+	__le16 timeout;		/*12h */
 
-	u32 data_xfer_len;	/*14h */
+	__le32 data_xfer_len;	/*14h */
 
-	u16 fis[10];		/*18h */
-	u32 stp_flags;
+	__le16 fis[10];		/*18h */
+	__le32 stp_flags;
 
 	union {
 		struct megasas_sge32 sge32[2];	/* [0]: resp [1]: data */
@@ -1489,18 +1489,18 @@ union megasas_evt_class_locale {
 } __attribute__ ((packed));
 
 struct megasas_evt_log_info {
-	u32 newest_seq_num;
-	u32 oldest_seq_num;
-	u32 clear_seq_num;
-	u32 shutdown_seq_num;
-	u32 boot_seq_num;
+	__le32 newest_seq_num;
+	__le32 oldest_seq_num;
+	__le32 clear_seq_num;
+	__le32 shutdown_seq_num;
+	__le32 boot_seq_num;
 
 } __attribute__ ((packed));
 
 struct megasas_progress {
 
-	u16 progress;
-	u16 elapsed_seconds;
+	__le16 progress;
+	__le16 elapsed_seconds;
 
 } __attribute__ ((packed));
 
@@ -1521,9 +1521,9 @@ struct megasas_evtarg_pd {
 
 struct megasas_evt_detail {
 
-	u32 seq_num;
-	u32 time_stamp;
-	u32 code;
+	__le32 seq_num;
+	__le32 time_stamp;
+	__le32 code;
 	union megasas_evt_class_locale cl;
 	u8 arg_type;
 	u8 reserved1[15];
@@ -1542,18 +1542,18 @@ struct megasas_evt_detail {
 
 		struct {
 			struct megasas_evtarg_ld ld;
-			u64 count;
+			__le64 count;
 		} __attribute__ ((packed)) ld_count;
 
 		struct {
-			u64 lba;
+			__le64 lba;
 			struct megasas_evtarg_ld ld;
 		} __attribute__ ((packed)) ld_lba;
 
 		struct {
 			struct megasas_evtarg_ld ld;
-			u32 prevOwner;
-			u32 newOwner;
+			__le32 prevOwner;
+			__le32 newOwner;
 		} __attribute__ ((packed)) ld_owner;
 
 		struct {
@@ -1610,7 +1610,7 @@ struct megasas_evt_detail {
 
 		struct {
 			u16 vendorId;
-			u16 deviceId;
+			__le16 deviceId;
 			u16 subVendorId;
 			u16 subDeviceId;
 		} __attribute__ ((packed)) pci;
@@ -1630,9 +1630,9 @@ struct megasas_evt_detail {
 		} __attribute__ ((packed)) ecc;
 
 		u8 b[96];
-		u16 s[48];
-		u32 w[24];
-		u64 d[12];
+		__le16 s[48];
+		__le32 w[24];
+		__le64 d[12];
 	} args;
 
 	char description[128];
@@ -1651,9 +1651,9 @@ struct megasas_irq_context {
 
 struct megasas_instance {
 
-	u32 *producer;
+	__le32 *producer;
 	dma_addr_t producer_h;
-	u32 *consumer;
+	__le32 *consumer;
 	dma_addr_t consumer_h;
 	struct MR_LD_VF_AFFILIATION *vf_affiliation;
 	dma_addr_t vf_affiliation_h;
@@ -1662,7 +1662,7 @@ struct megasas_instance {
 	struct MR_CTRL_HB_HOST_MEM *hb_host_mem;
 	dma_addr_t hb_host_mem_h;
 
-	u32 *reply_queue;
+	__le32 *reply_queue;
 	dma_addr_t reply_queue_h;
 
 	u32 *crash_dump_buf;
@@ -1963,10 +1963,10 @@ u8 MR_TargetIdToLdGet(u32 ldTgtId, struct MR_DRV_RAID_MAP_ALL *map);
 struct MR_LD_RAID *MR_LdRaidGet(u32 ld, struct MR_DRV_RAID_MAP_ALL *map);
 u16 MR_ArPdGet(u32 ar, u32 arm, struct MR_DRV_RAID_MAP_ALL *map);
 u16 MR_LdSpanArrayGet(u32 ld, u32 span, struct MR_DRV_RAID_MAP_ALL *map);
-u16 MR_PdDevHandleGet(u32 pd, struct MR_DRV_RAID_MAP_ALL *map);
+__le16 MR_PdDevHandleGet(u32 pd, struct MR_DRV_RAID_MAP_ALL *map);
 u16 MR_GetLDTgtId(u32 ld, struct MR_DRV_RAID_MAP_ALL *map);
 
-u16 get_updated_dev_handle(struct megasas_instance *instance,
+__le16 get_updated_dev_handle(struct megasas_instance *instance,
 	struct LD_LOAD_BALANCE_INFO *lbInfo, struct IO_REQUEST_INFO *in_info);
 void mr_update_load_balance_params(struct MR_DRV_RAID_MAP_ALL *map,
 	struct LD_LOAD_BALANCE_INFO *lbInfo);
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 875db92..cb7d0c4 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4262,7 +4262,7 @@ int megasas_set_crash_dump_params(struct megasas_instance *instance,
 static int
 megasas_issue_init_mfi(struct megasas_instance *instance)
 {
-	u32 context;
+	__le32 context;
 
 	struct megasas_cmd *cmd;
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index 4f72287..e9138a2 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -142,7 +142,7 @@ u16 MR_LdSpanArrayGet(u32 ld, u32 span, struct MR_DRV_RAID_MAP_ALL *map)
 	return le16_to_cpu(map->raidMap.ldSpanMap[ld].spanBlock[span].span.arrayRef);
 }
 
-u16 MR_PdDevHandleGet(u32 pd, struct MR_DRV_RAID_MAP_ALL *map)
+__le16 MR_PdDevHandleGet(u32 pd, struct MR_DRV_RAID_MAP_ALL *map)
 {
 	return map->raidMap.devHndlInfo[pd].curDevHdl;
 }
@@ -735,7 +735,7 @@ static u8 mr_spanset_get_phy_params(struct megasas_instance *instance, u32 ld,
 	u8	retval = TRUE;
 	u8	do_invader = 0;
 	u64	*pdBlock = &io_info->pdBlock;
-	u16	*pDevHandle = &io_info->devHandle;
+	__le16	*pDevHandle = &io_info->devHandle;
 	u32	logArm, rowMod, armQ, arm;
 
 	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER ||
@@ -817,7 +817,7 @@ u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld, u64 stripRow,
 	u8	    retval = TRUE;
 	u8          do_invader = 0;
 	u64	    *pdBlock = &io_info->pdBlock;
-	u16	    *pDevHandle = &io_info->devHandle;
+	__le16	    *pDevHandle = &io_info->devHandle;
 
 	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER ||
 		instance->pdev->device == PCI_DEVICE_ID_LSI_FURY))
@@ -1341,11 +1341,11 @@ u8 megasas_get_best_arm_pd(struct megasas_instance *instance,
 	return io_info->pd_after_lb;
 }
 
-u16 get_updated_dev_handle(struct megasas_instance *instance,
+__le16 get_updated_dev_handle(struct megasas_instance *instance,
 	struct LD_LOAD_BALANCE_INFO *lbInfo, struct IO_REQUEST_INFO *io_info)
 {
 	u8 arm_pd;
-	u16 devHandle;
+	__le16 devHandle;
 	struct fusion_context *fusion;
 	struct MR_DRV_RAID_MAP_ALL *drv_map;
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 675b5e7..983635f 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1670,7 +1670,7 @@ megasas_build_dcdb_fusion(struct megasas_instance *instance,
 	struct MR_DRV_RAID_MAP_ALL *local_map_ptr;
 	struct fusion_context *fusion = instance->ctrl_context;
 	u8                          span, physArm;
-	u16                         devHandle;
+	__le16                      devHandle;
 	u32                         ld, arRef, pd;
 	struct MR_LD_RAID                  *raid;
 	struct RAID_CONTEXT                *pRAID_Context;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index 56e6db2..d62285e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -104,18 +104,18 @@ struct RAID_CONTEXT {
 	u8	nseg:4;
 #endif
 	u8	resvd0;
-	u16     timeoutValue;
+	__le16	timeoutValue;
 	u8      regLockFlags;
 	u8      resvd1;
-	u16     VirtualDiskTgtId;
-	u64     regLockRowLBA;
-	u32     regLockLength;
-	u16     nextLMId;
+	__le16	VirtualDiskTgtId;
+	__le64	regLockRowLBA;
+	__le32	regLockLength;
+	__le16	nextLMId;
 	u8      exStatus;
 	u8      status;
 	u8      RAIDFlags;
 	u8      numSGE;
-	u16	configSeqNum;
+	__le16	configSeqNum;
 	u8      spanArm;
 	u8      resvd2[3];
 };
@@ -182,61 +182,61 @@ enum REGION_TYPE {
 #define MPI2_WRSEQ_6TH_KEY_VALUE                (0xD)
 
 struct MPI25_IEEE_SGE_CHAIN64 {
-	u64                     Address;
-	u32                     Length;
-	u16                     Reserved1;
+	__le64			Address;
+	__le32			Length;
+	__le16			Reserved1;
 	u8                      NextChainOffset;
 	u8                      Flags;
 };
 
 struct MPI2_SGE_SIMPLE_UNION {
-	u32                     FlagsLength;
+	__le32                     FlagsLength;
 	union {
-		u32                 Address32;
-		u64                 Address64;
+		__le32                 Address32;
+		__le64                 Address64;
 	} u;
 };
 
 struct MPI2_SCSI_IO_CDB_EEDP32 {
 	u8                      CDB[20];                    /* 0x00 */
-	u32                     PrimaryReferenceTag;        /* 0x14 */
-	u16                     PrimaryApplicationTag;      /* 0x18 */
-	u16                     PrimaryApplicationTagMask;  /* 0x1A */
-	u32                     TransferLength;             /* 0x1C */
+	__be32			PrimaryReferenceTag;        /* 0x14 */
+	__be16			PrimaryApplicationTag;      /* 0x18 */
+	__be16			PrimaryApplicationTagMask;  /* 0x1A */
+	__le32			TransferLength;             /* 0x1C */
 };
 
 struct MPI2_SGE_CHAIN_UNION {
-	u16                     Length;
+	__le16			Length;
 	u8                      NextChainOffset;
 	u8                      Flags;
 	union {
-		u32                 Address32;
-		u64                 Address64;
+		__le32		Address32;
+		__le64		Address64;
 	} u;
 };
 
 struct MPI2_IEEE_SGE_SIMPLE32 {
-	u32                     Address;
-	u32                     FlagsLength;
+	__le32			Address;
+	__le32			FlagsLength;
 };
 
 struct MPI2_IEEE_SGE_CHAIN32 {
-	u32                     Address;
-	u32                     FlagsLength;
+	__le32			Address;
+	__le32			FlagsLength;
 };
 
 struct MPI2_IEEE_SGE_SIMPLE64 {
-	u64                     Address;
-	u32                     Length;
-	u16                     Reserved1;
+	__le64			Address;
+	__le32			Length;
+	__le16			Reserved1;
 	u8                      Reserved2;
 	u8                      Flags;
 };
 
 struct MPI2_IEEE_SGE_CHAIN64 {
-	u64                     Address;
-	u32                     Length;
-	u16                     Reserved1;
+	__le64			Address;
+	__le32			Length;
+	__le16			Reserved1;
 	u8                      Reserved2;
 	u8                      Flags;
 };
@@ -269,34 +269,34 @@ union MPI2_SCSI_IO_CDB_UNION {
  * Total SGE count will be one less than  _MPI2_SCSI_IO_REQUEST
  */
 struct MPI2_RAID_SCSI_IO_REQUEST {
-	u16                     DevHandle;                      /* 0x00 */
+	__le16			DevHandle;                      /* 0x00 */
 	u8                      ChainOffset;                    /* 0x02 */
 	u8                      Function;                       /* 0x03 */
-	u16                     Reserved1;                      /* 0x04 */
+	__le16			Reserved1;                      /* 0x04 */
 	u8                      Reserved2;                      /* 0x06 */
 	u8                      MsgFlags;                       /* 0x07 */
 	u8                      VP_ID;                          /* 0x08 */
 	u8                      VF_ID;                          /* 0x09 */
-	u16                     Reserved3;                      /* 0x0A */
-	u32                     SenseBufferLowAddress;          /* 0x0C */
-	u16                     SGLFlags;                       /* 0x10 */
+	__le16			Reserved3;                      /* 0x0A */
+	__le32			SenseBufferLowAddress;          /* 0x0C */
+	__le16			SGLFlags;                       /* 0x10 */
 	u8                      SenseBufferLength;              /* 0x12 */
 	u8                      Reserved4;                      /* 0x13 */
 	u8                      SGLOffset0;                     /* 0x14 */
 	u8                      SGLOffset1;                     /* 0x15 */
 	u8                      SGLOffset2;                     /* 0x16 */
 	u8                      SGLOffset3;                     /* 0x17 */
-	u32                     SkipCount;                      /* 0x18 */
-	u32                     DataLength;                     /* 0x1C */
-	u32                     BidirectionalDataLength;        /* 0x20 */
-	u16                     IoFlags;                        /* 0x24 */
-	u16                     EEDPFlags;                      /* 0x26 */
-	u32                     EEDPBlockSize;                  /* 0x28 */
-	u32                     SecondaryReferenceTag;          /* 0x2C */
-	u16                     SecondaryApplicationTag;        /* 0x30 */
-	u16                     ApplicationTagTranslationMask;  /* 0x32 */
+	__le32			SkipCount;                      /* 0x18 */
+	__le32			DataLength;                     /* 0x1C */
+	__le32			BidirectionalDataLength;        /* 0x20 */
+	__le16			IoFlags;                        /* 0x24 */
+	__le16			EEDPFlags;                      /* 0x26 */
+	__le32			EEDPBlockSize;                  /* 0x28 */
+	__le32			SecondaryReferenceTag;          /* 0x2C */
+	__le16			SecondaryApplicationTag;        /* 0x30 */
+	__le16			ApplicationTagTranslationMask;  /* 0x32 */
 	u8                      LUN[8];                         /* 0x34 */
-	u32                     Control;                        /* 0x3C */
+	__le32			Control;                        /* 0x3C */
 	union MPI2_SCSI_IO_CDB_UNION  CDB;			/* 0x40 */
 	struct RAID_CONTEXT	RaidContext;                    /* 0x60 */
 	union MPI2_SGE_IO_UNION       SGL;			/* 0x80 */
@@ -315,45 +315,45 @@ struct MEGASAS_RAID_MFA_IO_REQUEST_DESCRIPTOR {
 struct MPI2_DEFAULT_REQUEST_DESCRIPTOR {
 	u8              RequestFlags;               /* 0x00 */
 	u8              MSIxIndex;                  /* 0x01 */
-	u16             SMID;                       /* 0x02 */
-	u16             LMID;                       /* 0x04 */
-	u16             DescriptorTypeDependent;    /* 0x06 */
+	__le16		SMID;                       /* 0x02 */
+	__le16		LMID;                       /* 0x04 */
+	__le16		DescriptorTypeDependent;    /* 0x06 */
 };
 
 /* High Priority Request Descriptor */
 struct MPI2_HIGH_PRIORITY_REQUEST_DESCRIPTOR {
 	u8              RequestFlags;               /* 0x00 */
 	u8              MSIxIndex;                  /* 0x01 */
-	u16             SMID;                       /* 0x02 */
-	u16             LMID;                       /* 0x04 */
-	u16             Reserved1;                  /* 0x06 */
+	__le16		SMID;                       /* 0x02 */
+	__le16		LMID;                       /* 0x04 */
+	__le16		Reserved1;                  /* 0x06 */
 };
 
 /* SCSI IO Request Descriptor */
 struct MPI2_SCSI_IO_REQUEST_DESCRIPTOR {
 	u8              RequestFlags;               /* 0x00 */
 	u8              MSIxIndex;                  /* 0x01 */
-	u16             SMID;                       /* 0x02 */
-	u16             LMID;                       /* 0x04 */
-	u16             DevHandle;                  /* 0x06 */
+	__le16		SMID;                       /* 0x02 */
+	__le16		LMID;                       /* 0x04 */
+	__le16		DevHandle;                  /* 0x06 */
 };
 
 /* SCSI Target Request Descriptor */
 struct MPI2_SCSI_TARGET_REQUEST_DESCRIPTOR {
 	u8              RequestFlags;               /* 0x00 */
 	u8              MSIxIndex;                  /* 0x01 */
-	u16             SMID;                       /* 0x02 */
-	u16             LMID;                       /* 0x04 */
-	u16             IoIndex;                    /* 0x06 */
+	__le16		SMID;                       /* 0x02 */
+	__le16		LMID;                       /* 0x04 */
+	__le16		IoIndex;                    /* 0x06 */
 };
 
 /* RAID Accelerator Request Descriptor */
 struct MPI2_RAID_ACCEL_REQUEST_DESCRIPTOR {
 	u8              RequestFlags;               /* 0x00 */
 	u8              MSIxIndex;                  /* 0x01 */
-	u16             SMID;                       /* 0x02 */
-	u16             LMID;                       /* 0x04 */
-	u16             Reserved;                   /* 0x06 */
+	__le16		SMID;                       /* 0x02 */
+	__le16		LMID;                       /* 0x04 */
+	__le16		Reserved;                   /* 0x06 */
 };
 
 /* union of Request Descriptors */
@@ -366,10 +366,10 @@ union MEGASAS_REQUEST_DESCRIPTOR_UNION {
 	struct MEGASAS_RAID_MFA_IO_REQUEST_DESCRIPTOR      MFAIo;
 	union {
 		struct {
-			u32 low;
-			u32 high;
+			__le32 low;
+			__le32 high;
 		} u;
-		u64 Words;
+		__le64 Words;
 	};
 };
 
@@ -377,35 +377,35 @@ union MEGASAS_REQUEST_DESCRIPTOR_UNION {
 struct MPI2_DEFAULT_REPLY_DESCRIPTOR {
 	u8              ReplyFlags;                 /* 0x00 */
 	u8              MSIxIndex;                  /* 0x01 */
-	u16             DescriptorTypeDependent1;   /* 0x02 */
-	u32             DescriptorTypeDependent2;   /* 0x04 */
+	__le16		DescriptorTypeDependent1;   /* 0x02 */
+	__le32		DescriptorTypeDependent2;   /* 0x04 */
 };
 
 /* Address Reply Descriptor */
 struct MPI2_ADDRESS_REPLY_DESCRIPTOR {
 	u8              ReplyFlags;                 /* 0x00 */
 	u8              MSIxIndex;                  /* 0x01 */
-	u16             SMID;                       /* 0x02 */
-	u32             ReplyFrameAddress;          /* 0x04 */
+	__le16		SMID;                       /* 0x02 */
+	__le32		ReplyFrameAddress;          /* 0x04 */
 };
 
 /* SCSI IO Success Reply Descriptor */
 struct MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR {
 	u8              ReplyFlags;                 /* 0x00 */
 	u8              MSIxIndex;                  /* 0x01 */
-	u16             SMID;                       /* 0x02 */
-	u16             TaskTag;                    /* 0x04 */
-	u16             Reserved1;                  /* 0x06 */
+	__le16		SMID;                       /* 0x02 */
+	__le16		TaskTag;                    /* 0x04 */
+	__le16		Reserved1;                  /* 0x06 */
 };
 
 /* TargetAssist Success Reply Descriptor */
 struct MPI2_TARGETASSIST_SUCCESS_REPLY_DESCRIPTOR {
 	u8              ReplyFlags;                 /* 0x00 */
 	u8              MSIxIndex;                  /* 0x01 */
-	u16             SMID;                       /* 0x02 */
+	__le16		SMID;                       /* 0x02 */
 	u8              SequenceNumber;             /* 0x04 */
 	u8              Reserved1;                  /* 0x05 */
-	u16             IoIndex;                    /* 0x06 */
+	__le16		IoIndex;                    /* 0x06 */
 };
 
 /* Target Command Buffer Reply Descriptor */
@@ -414,16 +414,16 @@ struct MPI2_TARGET_COMMAND_BUFFER_REPLY_DESCRIPTOR {
 	u8              MSIxIndex;                  /* 0x01 */
 	u8              VP_ID;                      /* 0x02 */
 	u8              Flags;                      /* 0x03 */
-	u16             InitiatorDevHandle;         /* 0x04 */
-	u16             IoIndex;                    /* 0x06 */
+	__le16		InitiatorDevHandle;         /* 0x04 */
+	__le16		IoIndex;                    /* 0x06 */
 };
 
 /* RAID Accelerator Success Reply Descriptor */
 struct MPI2_RAID_ACCELERATOR_SUCCESS_REPLY_DESCRIPTOR {
 	u8              ReplyFlags;                 /* 0x00 */
 	u8              MSIxIndex;                  /* 0x01 */
-	u16             SMID;                       /* 0x02 */
-	u32             Reserved;                   /* 0x04 */
+	__le16		SMID;                       /* 0x02 */
+	__le32		Reserved;                   /* 0x04 */
 };
 
 /* union of Reply Descriptors */
@@ -435,7 +435,7 @@ union MPI2_REPLY_DESCRIPTORS_UNION {
 	struct MPI2_TARGET_COMMAND_BUFFER_REPLY_DESCRIPTOR TargetCommandBuffer;
 	struct MPI2_RAID_ACCELERATOR_SUCCESS_REPLY_DESCRIPTOR
 	RAIDAcceleratorSuccess;
-	u64                                             Words;
+	__le64                                             Words;
 };
 
 /* IOCInit Request message */
@@ -444,28 +444,28 @@ struct MPI2_IOC_INIT_REQUEST {
 	u8                      Reserved1;                      /* 0x01 */
 	u8                      ChainOffset;                    /* 0x02 */
 	u8                      Function;                       /* 0x03 */
-	u16                     Reserved2;                      /* 0x04 */
+	__le16			Reserved2;                      /* 0x04 */
 	u8                      Reserved3;                      /* 0x06 */
 	u8                      MsgFlags;                       /* 0x07 */
 	u8                      VP_ID;                          /* 0x08 */
 	u8                      VF_ID;                          /* 0x09 */
-	u16                     Reserved4;                      /* 0x0A */
-	u16                     MsgVersion;                     /* 0x0C */
-	u16                     HeaderVersion;                  /* 0x0E */
+	__le16			Reserved4;                      /* 0x0A */
+	__le16			MsgVersion;                     /* 0x0C */
+	__le16			HeaderVersion;                  /* 0x0E */
 	u32                     Reserved5;                      /* 0x10 */
-	u16                     Reserved6;                      /* 0x14 */
+	__le16			Reserved6;                      /* 0x14 */
 	u8                      Reserved7;                      /* 0x16 */
 	u8                      HostMSIxVectors;                /* 0x17 */
-	u16                     Reserved8;                      /* 0x18 */
-	u16                     SystemRequestFrameSize;         /* 0x1A */
-	u16                     ReplyDescriptorPostQueueDepth;  /* 0x1C */
-	u16                     ReplyFreeQueueDepth;            /* 0x1E */
-	u32                     SenseBufferAddressHigh;         /* 0x20 */
-	u32                     SystemReplyAddressHigh;         /* 0x24 */
-	u64                     SystemRequestFrameBaseAddress;  /* 0x28 */
-	u64                     ReplyDescriptorPostQueueAddress;/* 0x30 */
-	u64                     ReplyFreeQueueAddress;          /* 0x38 */
-	u64                     TimeStamp;                      /* 0x40 */
+	__le16			Reserved8;                      /* 0x18 */
+	__le16			SystemRequestFrameSize;         /* 0x1A */
+	__le16			ReplyDescriptorPostQueueDepth;  /* 0x1C */
+	__le16			ReplyFreeQueueDepth;            /* 0x1E */
+	__le32			SenseBufferAddressHigh;         /* 0x20 */
+	__le32			SystemReplyAddressHigh;         /* 0x24 */
+	__le64			SystemRequestFrameBaseAddress;  /* 0x28 */
+	__le64			ReplyDescriptorPostQueueAddress;/* 0x30 */
+	__le64			ReplyFreeQueueAddress;          /* 0x38 */
+	__le64			TimeStamp;                      /* 0x40 */
 };
 
 /* mrpriv defines */
@@ -491,41 +491,41 @@ struct MPI2_IOC_INIT_REQUEST {
 #define MR_DCMD_LD_VF_MAP_GET_ALL_LDS       0x03150200
 
 struct MR_DEV_HANDLE_INFO {
-	u16     curDevHdl;
+	__le16	curDevHdl;
 	u8      validHandles;
 	u8      reserved;
-	u16     devHandle[2];
+	__le16	devHandle[2];
 };
 
 struct MR_ARRAY_INFO {
-	u16      pd[MAX_RAIDMAP_ROW_SIZE];
+	__le16	pd[MAX_RAIDMAP_ROW_SIZE];
 };
 
 struct MR_QUAD_ELEMENT {
-	u64     logStart;
-	u64     logEnd;
-	u64     offsetInSpan;
-	u32     diff;
-	u32     reserved1;
+	__le64     logStart;
+	__le64     logEnd;
+	__le64     offsetInSpan;
+	__le32     diff;
+	__le32     reserved1;
 };
 
 struct MR_SPAN_INFO {
-	u32             noElements;
-	u32             reserved1;
+	__le32             noElements;
+	__le32             reserved1;
 	struct MR_QUAD_ELEMENT quad[MAX_RAIDMAP_SPAN_DEPTH];
 };
 
 struct MR_LD_SPAN {
-	u64      startBlk;
-	u64      numBlks;
-	u16      arrayRef;
+	__le64	 startBlk;
+	__le64	 numBlks;
+	__le16	 arrayRef;
 	u8       spanRowSize;
 	u8       spanRowDataSize;
 	u8       reserved[4];
 };
 
 struct MR_SPAN_BLOCK_INFO {
-	u64          num_rows;
+	__le64          num_rows;
 	struct MR_LD_SPAN   span;
 	struct MR_SPAN_INFO block_span_info;
 };
@@ -558,8 +558,8 @@ struct MR_LD_RAID {
 		u32     reserved4:7;
 #endif
 	} capability;
-	u32     reserved6;
-	u64     size;
+	__le32     reserved6;
+	__le64     size;
 	u8      spanDepth;
 	u8      level;
 	u8      stripeShift;
@@ -568,12 +568,12 @@ struct MR_LD_RAID {
 	u8      writeMode;
 	u8      PRL;
 	u8      SRL;
-	u16     targetId;
+	__le16     targetId;
 	u8      ldState;
 	u8      regTypeReqOnWrite;
 	u8      modFactor;
 	u8	regTypeReqOnRead;
-	u16     seqNum;
+	__le16     seqNum;
 
 	struct {
 		u32 ldSyncRequired:1;
@@ -592,20 +592,20 @@ struct MR_LD_SPAN_MAP {
 };
 
 struct MR_FW_RAID_MAP {
-	u32                 totalSize;
+	__le32                 totalSize;
 	union {
 		struct {
-			u32         maxLd;
-			u32         maxSpanDepth;
-			u32         maxRowSize;
-			u32         maxPdCount;
-			u32         maxArrays;
+			__le32         maxLd;
+			__le32         maxSpanDepth;
+			__le32         maxRowSize;
+			__le32         maxPdCount;
+			__le32         maxArrays;
 		} validationInfo;
-		u32             version[5];
+		__le32             version[5];
 	};
 
-	u32                 ldCount;
-	u32                 Reserved1;
+	__le32                 ldCount;
+	__le32                 Reserved1;
 	u8                  ldTgtIdToLd[MAX_RAIDMAP_LOGICAL_DRIVES+
 					MAX_RAIDMAP_VIEWS];
 	u8                  fpPdIoTimeoutSec;
@@ -620,7 +620,7 @@ struct IO_REQUEST_INFO {
 	u32 numBlocks;
 	u16 ldTgtId;
 	u8 isRead;
-	u16 devHandle;
+	__le16 devHandle;
 	u64 pdBlock;
 	u8 fpOkForIo;
 	u8 IoforUnevenSpan;
@@ -634,7 +634,7 @@ struct IO_REQUEST_INFO {
 struct MR_LD_TARGET_SYNC {
 	u8  targetId;
 	u8  reserved;
-	u16 seqNum;
+	__le16 seqNum;
 };
 
 #define IEEE_SGE_FLAGS_ADDR_MASK            (0x03)
@@ -720,27 +720,27 @@ struct MR_DRV_RAID_MAP {
 	 * This feild will be manupulated by driver for ext raid map,
 	 * else pick the value from firmware raid map.
 	 */
-	u32                 totalSize;
+	__le32                 totalSize;
 
 	union {
 	struct {
-		u32         maxLd;
-		u32         maxSpanDepth;
-		u32         maxRowSize;
-		u32         maxPdCount;
-		u32         maxArrays;
+		__le32         maxLd;
+		__le32         maxSpanDepth;
+		__le32         maxRowSize;
+		__le32         maxPdCount;
+		__le32         maxArrays;
 	} validationInfo;
-	u32             version[5];
+	__le32             version[5];
 	};
 
 	/* timeout value used by driver in FP IOs*/
 	u8                  fpPdIoTimeoutSec;
 	u8                  reserved2[7];
 
-	u16                 ldCount;
-	u16                 arCount;
-	u16                 spanCount;
-	u16                 reserve3;
+	__le16                 ldCount;
+	__le16                 arCount;
+	__le16                 spanCount;
+	__le16                 reserve3;
 
 	struct MR_DEV_HANDLE_INFO  devHndlInfo[MAX_RAIDMAP_PHYSICAL_DEVICES];
 	u8                  ldTgtIdToLd[MAX_LOGICAL_DRIVES_EXT];
@@ -779,10 +779,10 @@ struct MR_FW_RAID_MAP_EXT {
 	u8                  fpPdIoTimeoutSec;
 	u8                  reserved2[7];
 
-	u16                 ldCount;
-	u16                 arCount;
-	u16                 spanCount;
-	u16                 reserve3;
+	__le16                 ldCount;
+	__le16                 arCount;
+	__le16                 spanCount;
+	__le16                 reserve3;
 
 	struct MR_DEV_HANDLE_INFO  devHndlInfo[MAX_RAIDMAP_PHYSICAL_DEVICES];
 	u8                  ldTgtIdToLd[MAX_LOGICAL_DRIVES_EXT];
@@ -839,10 +839,10 @@ struct fusion_context {
 };
 
 union desc_value {
-	u64 word;
+	__le64 word;
 	struct {
-		u32 low;
-		u32 high;
+		__le32 low;
+		__le32 high;
 	} u;
 };
 
-- 
1.9.1

