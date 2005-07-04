From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 9/9] qla1280: endianess annotations
Date: Mon, 4 Jul 2005 17:49:26 +0200
Message-ID: <20050704154926.GJ30435@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:61388 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261284AbVGDPtd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2005 11:49:33 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, jes@trained-monkey.org
Cc: linux-scsi@vger.kernel.org, ths@linux-mips.org

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/qla1280.c
===================================================================
--- linux-2.6.orig/drivers/scsi/qla1280.c	2005-06-26 16:59:06.000000000 +0200
+++ linux-2.6/drivers/scsi/qla1280.c	2005-06-26 16:59:12.000000000 +0200
@@ -1546,7 +1546,7 @@
 	int host_status = DID_ERROR;
 	uint16_t comp_status = le16_to_cpu(sts->comp_status);
 	uint16_t state_flags = le16_to_cpu(sts->state_flags);
-	uint16_t residual_length = le16_to_cpu(sts->residual_length);
+	uint16_t residual_length = le32_to_cpu(sts->residual_length);
 	uint16_t scsi_status = le16_to_cpu(sts->scsi_status);
 #if DEBUG_QLA1280_INTR
 	static char *reason[] = {
@@ -1932,7 +1932,7 @@
 			"%d,%d(0x%x)\n",
 			risc_code_address, cnt, num, risc_address);
 		for(i = 0; i < cnt; i++)
-			((uint16_t *)ha->request_ring)[i] =
+			((__le16 *)ha->request_ring)[i] =
 				cpu_to_le16(risc_code_address[i]);
 
 		mb[0] = MBC_LOAD_RAM;
@@ -2986,7 +2986,7 @@
 	struct scsi_cmnd *cmd = sp->cmd;
 	cmd_a64_entry_t *pkt;
 	struct scatterlist *sg = NULL;
-	u32 *dword_ptr;
+	__le32 *dword_ptr;
 	dma_addr_t dma_handle;
 	int status = 0;
 	int cnt;
@@ -3273,7 +3273,7 @@
 	struct scsi_cmnd *cmd = sp->cmd;
 	struct cmd_entry *pkt;
 	struct scatterlist *sg = NULL;
-	uint32_t *dword_ptr;
+	__le32 *dword_ptr;
 	int status = 0;
 	int cnt;
 	int req_cnt;
Index: linux-2.6/drivers/scsi/qla1280.h
===================================================================
--- linux-2.6.orig/drivers/scsi/qla1280.h	2005-06-26 16:59:06.000000000 +0200
+++ linux-2.6/drivers/scsi/qla1280.h	2005-06-26 16:59:12.000000000 +0200
@@ -516,23 +516,23 @@
 	uint8_t entry_count;		/* Entry count. */
 	uint8_t sys_define;		/* System defined. */
 	uint8_t entry_status;		/* Entry Status. */
-	uint32_t handle;		/* System handle. */
+	__le32 handle;			/* System handle. */
 	uint8_t lun;			/* SCSI LUN */
 	uint8_t target;			/* SCSI ID */
-	uint16_t cdb_len;		/* SCSI command length. */
-	uint16_t control_flags;		/* Control flags. */
-	uint16_t reserved;
-	uint16_t timeout;		/* Command timeout. */
-	uint16_t dseg_count;		/* Data segment count. */
+	__le16 cdb_len;			/* SCSI command length. */
+	__le16 control_flags;		/* Control flags. */
+	__le16 reserved;
+	__le16 timeout;			/* Command timeout. */
+	__le16 dseg_count;		/* Data segment count. */
 	uint8_t scsi_cdb[MAX_CMDSZ];	/* SCSI command words. */
-	uint32_t dseg_0_address;	/* Data segment 0 address. */
-	uint32_t dseg_0_length;		/* Data segment 0 length. */
-	uint32_t dseg_1_address;	/* Data segment 1 address. */
-	uint32_t dseg_1_length;		/* Data segment 1 length. */
-	uint32_t dseg_2_address;	/* Data segment 2 address. */
-	uint32_t dseg_2_length;		/* Data segment 2 length. */
-	uint32_t dseg_3_address;	/* Data segment 3 address. */
-	uint32_t dseg_3_length;		/* Data segment 3 length. */
+	__le32 dseg_0_address;		/* Data segment 0 address. */
+	__le32 dseg_0_length;		/* Data segment 0 length. */
+	__le32 dseg_1_address;		/* Data segment 1 address. */
+	__le32 dseg_1_length;		/* Data segment 1 length. */
+	__le32 dseg_2_address;		/* Data segment 2 address. */
+	__le32 dseg_2_length;		/* Data segment 2 length. */
+	__le32 dseg_3_address;		/* Data segment 3 address. */
+	__le32 dseg_3_length;		/* Data segment 3 length. */
 };
 
 /*
@@ -544,21 +544,21 @@
 	uint8_t entry_count;		/* Entry count. */
 	uint8_t sys_define;		/* System defined. */
 	uint8_t entry_status;		/* Entry Status. */
-	uint32_t reserved;		/* Reserved */
-	uint32_t dseg_0_address;	/* Data segment 0 address. */
-	uint32_t dseg_0_length;		/* Data segment 0 length. */
-	uint32_t dseg_1_address;	/* Data segment 1 address. */
-	uint32_t dseg_1_length;		/* Data segment 1 length. */
-	uint32_t dseg_2_address;	/* Data segment 2 address. */
-	uint32_t dseg_2_length;		/* Data segment 2 length. */
-	uint32_t dseg_3_address;	/* Data segment 3 address. */
-	uint32_t dseg_3_length;		/* Data segment 3 length. */
-	uint32_t dseg_4_address;	/* Data segment 4 address. */
-	uint32_t dseg_4_length;		/* Data segment 4 length. */
-	uint32_t dseg_5_address;	/* Data segment 5 address. */
-	uint32_t dseg_5_length;		/* Data segment 5 length. */
-	uint32_t dseg_6_address;	/* Data segment 6 address. */
-	uint32_t dseg_6_length;		/* Data segment 6 length. */
+	__le32 reserved;		/* Reserved */
+	__le32 dseg_0_address;		/* Data segment 0 address. */
+	__le32 dseg_0_length;		/* Data segment 0 length. */
+	__le32 dseg_1_address;		/* Data segment 1 address. */
+	__le32 dseg_1_length;		/* Data segment 1 length. */
+	__le32 dseg_2_address;		/* Data segment 2 address. */
+	__le32 dseg_2_length;		/* Data segment 2 length. */
+	__le32 dseg_3_address;		/* Data segment 3 address. */
+	__le32 dseg_3_length;		/* Data segment 3 length. */
+	__le32 dseg_4_address;		/* Data segment 4 address. */
+	__le32 dseg_4_length;		/* Data segment 4 length. */
+	__le32 dseg_5_address;		/* Data segment 5 address. */
+	__le32 dseg_5_length;		/* Data segment 5 length. */
+	__le32 dseg_6_address;		/* Data segment 6 address. */
+	__le32 dseg_6_length;		/* Data segment 6 length. */
 };
 
 /*
@@ -574,22 +574,22 @@
 #define RF_FULL         BIT_1	/* Full */
 #define RF_BAD_HEADER   BIT_2	/* Bad header. */
 #define RF_BAD_PAYLOAD  BIT_3	/* Bad payload. */
-	uint32_t handle;	/* System handle. */
-	uint16_t scsi_status;	/* SCSI status. */
-	uint16_t comp_status;	/* Completion status. */
-	uint16_t state_flags;	/* State flags. */
-#define SF_TRANSFER_CMPL BIT_14	/* Transfer Complete. */
-#define SF_GOT_SENSE    BIT_13	/* Got Sense */
-#define SF_GOT_STATUS    BIT_12	/* Got Status */
-#define SF_TRANSFERRED_DATA BIT_11	/* Transferred data */
-#define SF_SENT_CDB   BIT_10	/* Send CDB */
-#define SF_GOT_TARGET  BIT_9	/*  */
-#define SF_GOT_BUS     BIT_8	/*  */
-	uint16_t status_flags;	/* Status flags. */
-	uint16_t time;		/* Time. */
-	uint16_t req_sense_length;	/* Request sense data length. */
-	uint32_t residual_length;	/* Residual transfer length. */
-	uint16_t reserved[4];
+	__le32 handle;		/* System handle. */
+	__le16 scsi_status;	/* SCSI status. */
+	__le16 comp_status;	/* Completion status. */
+	__le16 state_flags;	/* State flags. */
+#define SF_TRANSFER_CMPL	BIT_14	/* Transfer Complete. */
+#define SF_GOT_SENSE	 	BIT_13	/* Got Sense */
+#define SF_GOT_STATUS	 	BIT_12	/* Got Status */
+#define SF_TRANSFERRED_DATA	BIT_11	/* Transferred data */
+#define SF_SENT_CDB	 	BIT_10	/* Send CDB */
+#define SF_GOT_TARGET	 	BIT_9	/*  */
+#define SF_GOT_BUS	 	BIT_8	/*  */
+	__le16 status_flags;	/* Status flags. */
+	__le16 time;		/* Time. */
+	__le16 req_sense_length;/* Request sense data length. */
+	__le32 residual_length;	/* Residual transfer length. */
+	__le16 reserved[4];
 	uint8_t req_sense_data[32];	/* Request sense data. */
 };
 
@@ -602,7 +602,7 @@
 	uint8_t entry_count;	/* Entry count. */
 	uint8_t sys_define;	/* System defined. */
 	uint8_t entry_status;	/* Entry Status. */
-	uint32_t reserved;
+	__le32 reserved;
 	uint8_t lun;		/* SCSI LUN */
 	uint8_t target;		/* SCSI ID */
 	uint8_t modifier;	/* Modifier (7-0). */
@@ -626,11 +626,11 @@
 	uint32_t handle;	/* System handle. */
 	uint8_t lun;		/* SCSI LUN */
 	uint8_t target;		/* SCSI ID */
-	uint16_t cdb_len;	/* SCSI command length. */
-	uint16_t control_flags;	/* Control flags. */
-	uint16_t reserved;
-	uint16_t timeout;	/* Command timeout. */
-	uint16_t dseg_count;	/* Data segment count. */
+	__le16 cdb_len;		/* SCSI command length. */
+	__le16 control_flags;	/* Control flags. */
+	__le16 reserved;
+	__le16 timeout;		/* Command timeout. */
+	__le16 dseg_count;	/* Data segment count. */
 	uint8_t scsi_cdb[88];	/* SCSI command words. */
 };
 
@@ -643,20 +643,20 @@
 	uint8_t entry_count;	/* Entry count. */
 	uint8_t sys_define;	/* System defined. */
 	uint8_t entry_status;	/* Entry Status. */
-	uint32_t handle;	/* System handle. */
+	__le32 handle;	/* System handle. */
 	uint8_t lun;		/* SCSI LUN */
 	uint8_t target;		/* SCSI ID */
-	uint16_t cdb_len;	/* SCSI command length. */
-	uint16_t control_flags;	/* Control flags. */
-	uint16_t reserved;
-	uint16_t timeout;	/* Command timeout. */
-	uint16_t dseg_count;	/* Data segment count. */
+	__le16 cdb_len;	/* SCSI command length. */
+	__le16 control_flags;	/* Control flags. */
+	__le16 reserved;
+	__le16 timeout;	/* Command timeout. */
+	__le16 dseg_count;	/* Data segment count. */
 	uint8_t scsi_cdb[MAX_CMDSZ];	/* SCSI command words. */
-	uint32_t reserved_1[2];	/* unused */
-	uint32_t dseg_0_address[2];	/* Data segment 0 address. */
-	uint32_t dseg_0_length;	/* Data segment 0 length. */
-	uint32_t dseg_1_address[2];	/* Data segment 1 address. */
-	uint32_t dseg_1_length;	/* Data segment 1 length. */
+	__le32 reserved_1[2];	/* unused */
+	__le32 dseg_0_address[2];	/* Data segment 0 address. */
+	__le32 dseg_0_length;	/* Data segment 0 length. */
+	__le32 dseg_1_address[2];	/* Data segment 1 address. */
+	__le32 dseg_1_length;	/* Data segment 1 length. */
 } cmd_a64_entry_t, request_t;
 
 /*
@@ -668,16 +668,16 @@
 	uint8_t entry_count;	/* Entry count. */
 	uint8_t sys_define;	/* System defined. */
 	uint8_t entry_status;	/* Entry Status. */
-	uint32_t dseg_0_address[2];	/* Data segment 0 address. */
-	uint32_t dseg_0_length;	/* Data segment 0 length. */
-	uint32_t dseg_1_address[2];	/* Data segment 1 address. */
-	uint32_t dseg_1_length;	/* Data segment 1 length. */
-	uint32_t dseg_2_address[2];	/* Data segment 2 address. */
-	uint32_t dseg_2_length;	/* Data segment 2 length. */
-	uint32_t dseg_3_address[2];	/* Data segment 3 address. */
-	uint32_t dseg_3_length;	/* Data segment 3 length. */
-	uint32_t dseg_4_address[2];	/* Data segment 4 address. */
-	uint32_t dseg_4_length;	/* Data segment 4 length. */
+	__le32 dseg_0_address[2];	/* Data segment 0 address. */
+	__le32 dseg_0_length;		/* Data segment 0 length. */
+	__le32 dseg_1_address[2];	/* Data segment 1 address. */
+	__le32 dseg_1_length;		/* Data segment 1 length. */
+	__le32 dseg_2_address[2];	/* Data segment 2 address. */
+	__le32 dseg_2_length;		/* Data segment 2 length. */
+	__le32 dseg_3_address[2];	/* Data segment 3 address. */
+	__le32 dseg_3_length;		/* Data segment 3 length. */
+	__le32 dseg_4_address[2];	/* Data segment 4 address. */
+	__le32 dseg_4_length;		/* Data segment 4 length. */
 };
 
 /*
@@ -689,10 +689,10 @@
 	uint8_t entry_count;	/* Entry count. */
 	uint8_t reserved_1;
 	uint8_t entry_status;	/* Entry Status not used. */
-	uint32_t reserved_2;
-	uint16_t lun;		/* Bit 15 is bus number. */
-	uint16_t reserved_4;
-	uint32_t option_flags;
+	__le32 reserved_2;
+	__le16 lun;		/* Bit 15 is bus number. */
+	__le16 reserved_4;
+	__le32 option_flags;
 	uint8_t status;
 	uint8_t reserved_5;
 	uint8_t command_count;	/* Number of ATIOs allocated. */
@@ -702,8 +702,8 @@
 	/* commands (2-26). */
 	uint8_t group_7_length;	/* SCSI CDB length for group 7 */
 	/* commands (2-26). */
-	uint16_t timeout;	/* 0 = 30 seconds, 0xFFFF = disable */
-	uint16_t reserved_6[20];
+	__le16 timeout;		/* 0 = 30 seconds, 0xFFFF = disable */
+	__le16 reserved_6[20];
 };
 
 /*
@@ -717,20 +717,20 @@
 	uint8_t entry_count;	/* Entry count. */
 	uint8_t reserved_1;
 	uint8_t entry_status;	/* Entry Status. */
-	uint32_t reserved_2;
+	__le32 reserved_2;
 	uint8_t lun;		/* SCSI LUN */
 	uint8_t reserved_3;
 	uint8_t operators;
 	uint8_t reserved_4;
-	uint32_t option_flags;
+	__le32 option_flags;
 	uint8_t status;
 	uint8_t reserved_5;
 	uint8_t command_count;	/* Number of ATIOs allocated. */
 	uint8_t immed_notify_count;	/* Number of Immediate Notify */
 	/* entries allocated. */
-	uint16_t reserved_6;
-	uint16_t timeout;	/* 0 = 30 seconds, 0xFFFF = disable */
-	uint16_t reserved_7[20];
+	__le16 reserved_6;
+	__le16 timeout;		/* 0 = 30 seconds, 0xFFFF = disable */
+	__le16 reserved_7[20];
 };
 
 /*
@@ -742,20 +742,20 @@
 	uint8_t entry_count;	/* Entry count. */
 	uint8_t reserved_1;
 	uint8_t entry_status;	/* Entry Status. */
-	uint32_t reserved_2;
+	__le32 reserved_2;
 	uint8_t lun;
 	uint8_t initiator_id;
 	uint8_t reserved_3;
 	uint8_t target_id;
-	uint32_t option_flags;
+	__le32 option_flags;
 	uint8_t status;
 	uint8_t reserved_4;
 	uint8_t tag_value;	/* Received queue tag message value */
 	uint8_t tag_type;	/* Received queue tag message type */
 	/* entries allocated. */
-	uint16_t seq_id;
+	__le16 seq_id;
 	uint8_t scsi_msg[8];	/* SCSI message not handled by ISP */
-	uint16_t reserved_5[8];
+	__le16 reserved_5[8];
 	uint8_t sense_data[18];
 };
 
@@ -768,16 +768,16 @@
 	uint8_t entry_count;	/* Entry count. */
 	uint8_t reserved_1;
 	uint8_t entry_status;	/* Entry Status. */
-	uint32_t reserved_2;
+	__le32 reserved_2;
 	uint8_t lun;
 	uint8_t initiator_id;
 	uint8_t reserved_3;
 	uint8_t target_id;
-	uint32_t option_flags;
+	__le32 option_flags;
 	uint8_t status;
 	uint8_t event;
-	uint16_t seq_id;
-	uint16_t reserved_4[22];
+	__le16 seq_id;
+	__le16 reserved_4[22];
 };
 
 /*
@@ -789,12 +789,12 @@
 	uint8_t entry_count;	/* Entry count. */
 	uint8_t reserved_1;
 	uint8_t entry_status;	/* Entry Status. */
-	uint32_t reserved_2;
+	__le32 reserved_2;
 	uint8_t lun;
 	uint8_t initiator_id;
 	uint8_t cdb_len;
 	uint8_t target_id;
-	uint32_t option_flags;
+	__le32 option_flags;
 	uint8_t status;
 	uint8_t scsi_status;
 	uint8_t tag_value;	/* Received queue tag message value */
@@ -812,28 +812,28 @@
 	uint8_t entry_count;	/* Entry count. */
 	uint8_t reserved_1;
 	uint8_t entry_status;	/* Entry Status. */
-	uint32_t reserved_2;
+	__le32 reserved_2;
 	uint8_t lun;		/* SCSI LUN */
 	uint8_t initiator_id;
 	uint8_t reserved_3;
 	uint8_t target_id;
-	uint32_t option_flags;
+	__le32 option_flags;
 	uint8_t status;
 	uint8_t scsi_status;
 	uint8_t tag_value;	/* Received queue tag message value */
 	uint8_t tag_type;	/* Received queue tag message type */
-	uint32_t transfer_length;
-	uint32_t residual;
-	uint16_t timeout;	/* 0 = 30 seconds, 0xFFFF = disable */
-	uint16_t dseg_count;	/* Data segment count. */
-	uint32_t dseg_0_address;	/* Data segment 0 address. */
-	uint32_t dseg_0_length;	/* Data segment 0 length. */
-	uint32_t dseg_1_address;	/* Data segment 1 address. */
-	uint32_t dseg_1_length;	/* Data segment 1 length. */
-	uint32_t dseg_2_address;	/* Data segment 2 address. */
-	uint32_t dseg_2_length;	/* Data segment 2 length. */
-	uint32_t dseg_3_address;	/* Data segment 3 address. */
-	uint32_t dseg_3_length;	/* Data segment 3 length. */
+	__le32 transfer_length;
+	__le32 residual;
+	__le16 timeout;		/* 0 = 30 seconds, 0xFFFF = disable */
+	__le16 dseg_count;	/* Data segment count. */
+	__le32 dseg_0_address;	/* Data segment 0 address. */
+	__le32 dseg_0_length;	/* Data segment 0 length. */
+	__le32 dseg_1_address;	/* Data segment 1 address. */
+	__le32 dseg_1_length;	/* Data segment 1 length. */
+	__le32 dseg_2_address;	/* Data segment 2 address. */
+	__le32 dseg_2_length;	/* Data segment 2 length. */
+	__le32 dseg_3_address;	/* Data segment 3 address. */
+	__le32 dseg_3_length;	/* Data segment 3 length. */
 };
 
 /*
@@ -845,24 +845,24 @@
 	uint8_t entry_count;	/* Entry count. */
 	uint8_t reserved_1;
 	uint8_t entry_status;	/* Entry Status. */
-	uint32_t reserved_2;
+	__le32 reserved_2;
 	uint8_t lun;		/* SCSI LUN */
 	uint8_t initiator_id;
 	uint8_t reserved_3;
 	uint8_t target_id;
-	uint32_t option_flags;
+	__le32 option_flags;
 	uint8_t status;
 	uint8_t scsi_status;
 	uint8_t tag_value;	/* Received queue tag message value */
 	uint8_t tag_type;	/* Received queue tag message type */
-	uint32_t transfer_length;
-	uint32_t residual;
-	uint16_t timeout;	/* 0 = 30 seconds, 0xFFFF = disable */
-	uint16_t dseg_count;	/* Data segment count. */
-	uint32_t dseg_0_address;	/* Data segment 0 address. */
-	uint32_t dseg_0_length;	/* Data segment 0 length. */
-	uint32_t dseg_1_address;	/* Data segment 1 address. */
-	uint16_t dseg_1_length;	/* Data segment 1 length. */
+	__le32 transfer_length;
+	__le32 residual;
+	__le16 timeout;		/* 0 = 30 seconds, 0xFFFF = disable */
+	__le16 dseg_count;	/* Data segment count. */
+	__le32 dseg_0_address;	/* Data segment 0 address. */
+	__le32 dseg_0_length;	/* Data segment 0 length. */
+	__le32 dseg_1_address;	/* Data segment 1 address. */
+	__le16 dseg_1_length;	/* Data segment 1 length. */
 	uint8_t sense_data[18];
 };
 
@@ -875,25 +875,25 @@
 	uint8_t entry_count;	/* Entry count. */
 	uint8_t reserved_1;
 	uint8_t entry_status;	/* Entry Status. */
-	uint32_t reserved_2;
+	__le32 reserved_2;
 	uint8_t lun;		/* SCSI LUN */
 	uint8_t initiator_id;
 	uint8_t reserved_3;
 	uint8_t target_id;
-	uint32_t option_flags;
+	__le32 option_flags;
 	uint8_t status;
 	uint8_t scsi_status;
 	uint8_t tag_value;	/* Received queue tag message value */
 	uint8_t tag_type;	/* Received queue tag message type */
-	uint32_t transfer_length;
-	uint32_t residual;
-	uint16_t timeout;	/* 0 = 30 seconds, 0xFFFF = disable */
-	uint16_t dseg_count;	/* Data segment count. */
-	uint32_t reserved_4[2];
-	uint32_t dseg_0_address[2];	/* Data segment 0 address. */
-	uint32_t dseg_0_length;	/* Data segment 0 length. */
-	uint32_t dseg_1_address[2];	/* Data segment 1 address. */
-	uint32_t dseg_1_length;	/* Data segment 1 length. */
+	__le32 transfer_length;
+	__le32 residual;
+	__le16 timeout;		/* 0 = 30 seconds, 0xFFFF = disable */
+	__le16 dseg_count;	/* Data segment count. */
+	__le32 reserved_4[2];
+	__le32 dseg_0_address[2];/* Data segment 0 address. */
+	__le32 dseg_0_length;	/* Data segment 0 length. */
+	__le32 dseg_1_address[2];/* Data segment 1 address. */
+	__le32 dseg_1_length;	/* Data segment 1 length. */
 };
 
 /*
@@ -905,21 +905,21 @@
 	uint8_t entry_count;	/* Entry count. */
 	uint8_t reserved_1;
 	uint8_t entry_status;	/* Entry Status. */
-	uint32_t reserved_2;
+	__le32 reserved_2;
 	uint8_t lun;		/* SCSI LUN */
 	uint8_t initiator_id;
 	uint8_t reserved_3;
 	uint8_t target_id;
-	uint32_t option_flags;
+	__le32 option_flags;
 	uint8_t status;
 	uint8_t scsi_status;
 	uint8_t tag_value;	/* Received queue tag message value */
 	uint8_t tag_type;	/* Received queue tag message type */
-	uint32_t transfer_length;
-	uint32_t residual;
-	uint16_t timeout;	/* 0 = 30 seconds, 0xFFFF = disable */
-	uint16_t dseg_count;	/* Data segment count. */
-	uint16_t reserved_4[7];
+	__le32 transfer_length;
+	__le32 residual;
+	__le16 timeout;		/* 0 = 30 seconds, 0xFFFF = disable */
+	__le16 dseg_count;	/* Data segment count. */
+	__le16 reserved_4[7];
 	uint8_t sense_data[18];
 };
 
