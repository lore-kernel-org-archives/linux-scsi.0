Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE8DFC433C1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 07:21:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC4AF6148E
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 07:21:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhC3HVI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 03:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhC3HUj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 03:20:39 -0400
Received: from smtp.gentoo.org (smtp.gentoo.org [IPv6:2001:470:ea4a:1:5054:ff:fec7:86e4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E924BC061764;
        Tue, 30 Mar 2021 00:20:36 -0700 (PDT)
Received: by sf.home (Postfix, from userid 1000)
        id 21EA65A22061; Tue, 30 Mar 2021 08:20:30 +0100 (BST)
From:   Sergei Trofimovich <slyfox@gentoo.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@kernel.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Don Brace <don.brace@microchip.com>,
        linux-ia64@vger.kernel.org, storagedev@microchip.com,
        linux-scsi <linux-scsi@vger.kernel.org>, jszczype@redhat.com,
        Scott Benesh <scott.benesh@microchip.com>,
        Scott Teel <scott.teel@microchip.com>, thenzl@redhat.com
Cc:     linux-kernel@vger.kernel.org,
        Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH v2 1/3] hpsa: use __packed on individual structs, not header-wide
Date:   Tue, 30 Mar 2021 08:19:56 +0100
Message-Id: <20210330071958.3788214-1-slyfox@gentoo.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <yq1wntpgxxr.fsf@ca-mkp.ca.oracle.com>
References: <yq1wntpgxxr.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some of the structs contain `atomic_t` values and are not intended to be
sent to IO controller as is.

The change adds __packed to every struct and union in the file.
Follow-up commits will fix `atomic_t` problems.

The commit is a no-op at least on ia64:
    $ diff -u <(objdump -d -r old.o) <(objdump -d -r new.o)

CC: linux-ia64@vger.kernel.org
CC: storagedev@microchip.com
CC: linux-scsi@vger.kernel.org
CC: Joe Szczypek <jszczype@redhat.com>
CC: Scott Benesh <scott.benesh@microchip.com>
CC: Scott Teel <scott.teel@microchip.com>
CC: Tomas Henzl <thenzl@redhat.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Don Brace <don.brace@microchip.com>
Reported-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Suggested-by: Don Brace <don.brace@microchip.com>
Fixes: f749d8b7a "scsi: hpsa: Correct dev cmds outstanding for retried cmds"
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 drivers/scsi/hpsa_cmd.h | 68 ++++++++++++++++++++---------------------
 1 file changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index d126bb877250..280e933d27e7 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -20,6 +20,8 @@
 #ifndef HPSA_CMD_H
 #define HPSA_CMD_H
 
+#include <linux/compiler.h>
+
 /* general boundary defintions */
 #define SENSEINFOBYTES          32 /* may vary between hbas */
 #define SG_ENTRIES_IN_CMD	32 /* Max SG entries excluding chain blocks */
@@ -200,12 +202,10 @@ union u64bit {
 	MAX_EXT_TARGETS + 1) /* + 1 is for the controller itself */
 
 /* SCSI-3 Commands */
-#pragma pack(1)
-
 #define HPSA_INQUIRY 0x12
 struct InquiryData {
 	u8 data_byte[36];
-};
+} __packed;
 
 #define HPSA_REPORT_LOG 0xc2    /* Report Logical LUNs */
 #define HPSA_REPORT_PHYS 0xc3   /* Report Physical LUNs */
@@ -221,7 +221,7 @@ struct raid_map_disk_data {
 	u8    xor_mult[2];            /**< XOR multipliers for this position,
 					*  valid for data disks only */
 	u8    reserved[2];
-};
+} __packed;
 
 struct raid_map_data {
 	__le32   structure_size;	/* Size of entire structure in bytes */
@@ -247,14 +247,14 @@ struct raid_map_data {
 	__le16   dekindex;		/* Data encryption key index. */
 	u8    reserved[16];
 	struct raid_map_disk_data data[RAID_MAP_MAX_ENTRIES];
-};
+} __packed;
 
 struct ReportLUNdata {
 	u8 LUNListLength[4];
 	u8 extended_response_flag;
 	u8 reserved[3];
 	u8 LUN[HPSA_MAX_LUN][8];
-};
+} __packed;
 
 struct ext_report_lun_entry {
 	u8 lunid[8];
@@ -269,20 +269,20 @@ struct ext_report_lun_entry {
 	u8 lun_count; /* multi-lun device, how many luns */
 	u8 redundant_paths;
 	u32 ioaccel_handle; /* ioaccel1 only uses lower 16 bits */
-};
+} __packed;
 
 struct ReportExtendedLUNdata {
 	u8 LUNListLength[4];
 	u8 extended_response_flag;
 	u8 reserved[3];
 	struct ext_report_lun_entry LUN[HPSA_MAX_PHYS_LUN];
-};
+} __packed;
 
 struct SenseSubsystem_info {
 	u8 reserved[36];
 	u8 portname[8];
 	u8 reserved1[1108];
-};
+} __packed;
 
 /* BMIC commands */
 #define BMIC_READ 0x26
@@ -317,7 +317,7 @@ union SCSI3Addr {
 		u8 Targ:6;
 		u8 Mode:2;        /* b10 */
 	} LogUnit;
-};
+} __packed;
 
 struct PhysDevAddr {
 	u32             TargetId:24;
@@ -325,20 +325,20 @@ struct PhysDevAddr {
 	u32             Mode:2;
 	/* 2 level target device addr */
 	union SCSI3Addr  Target[2];
-};
+} __packed;
 
 struct LogDevAddr {
 	u32            VolId:30;
 	u32            Mode:2;
 	u8             reserved[4];
-};
+} __packed;
 
 union LUNAddr {
 	u8               LunAddrBytes[8];
 	union SCSI3Addr    SCSI3Lun[4];
 	struct PhysDevAddr PhysDev;
 	struct LogDevAddr  LogDev;
-};
+} __packed;
 
 struct CommandListHeader {
 	u8              ReplyQueue;
@@ -346,7 +346,7 @@ struct CommandListHeader {
 	__le16          SGTotal;
 	__le64		tag;
 	union LUNAddr     LUN;
-};
+} __packed;
 
 struct RequestBlock {
 	u8   CDBLen;
@@ -365,18 +365,18 @@ struct RequestBlock {
 #define GET_DIR(tad) (((tad) >> 6) & 0x03)
 	u16  Timeout;
 	u8   CDB[16];
-};
+} __packed;
 
 struct ErrDescriptor {
 	__le64 Addr;
 	__le32 Len;
-};
+} __packed;
 
 struct SGDescriptor {
 	__le64 Addr;
 	__le32 Len;
 	__le32 Ext;
-};
+} __packed;
 
 union MoreErrInfo {
 	struct {
@@ -390,7 +390,8 @@ union MoreErrInfo {
 		u8  offense_num;  /* byte # of offense 0-base */
 		u32 offense_value;
 	} Invalid_Cmd;
-};
+} __packed;
+
 struct ErrorInfo {
 	u8               ScsiStatus;
 	u8               SenseLen;
@@ -398,7 +399,7 @@ struct ErrorInfo {
 	u32              ResidualCnt;
 	union MoreErrInfo  MoreErrInfo;
 	u8               SenseInfo[SENSEINFOBYTES];
-};
+} __packed;
 /* Command types */
 #define CMD_IOCTL_PEND  0x01
 #define CMD_SCSI	0x03
@@ -451,7 +452,7 @@ struct CommandList {
 	bool retry_pending;
 	struct hpsa_scsi_dev_t *device;
 	atomic_t refcount; /* Must be last to avoid memset in hpsa_cmd_init() */
-} __aligned(COMMANDLIST_ALIGNMENT);
+} __packed __aligned(COMMANDLIST_ALIGNMENT);
 
 /* Max S/G elements in I/O accelerator command */
 #define IOACCEL1_MAXSGENTRIES           24
@@ -489,7 +490,7 @@ struct io_accel1_cmd {
 	__le64 host_addr;		/* 0x70 - 0x77 */
 	u8  CISS_LUN[8];		/* 0x78 - 0x7F */
 	struct SGDescriptor SG[IOACCEL1_MAXSGENTRIES];
-} __aligned(IOACCEL1_COMMANDLIST_ALIGNMENT);
+} __packed __aligned(IOACCEL1_COMMANDLIST_ALIGNMENT);
 
 #define IOACCEL1_FUNCTION_SCSIIO        0x00
 #define IOACCEL1_SGLOFFSET              32
@@ -519,7 +520,7 @@ struct ioaccel2_sg_element {
 	u8 chain_indicator;
 #define IOACCEL2_CHAIN 0x80
 #define IOACCEL2_LAST_SG 0x40
-};
+} __packed;
 
 /*
  * SCSI Response Format structure for IO Accelerator Mode 2
@@ -559,7 +560,7 @@ struct io_accel2_scsi_response {
 	u8 sense_data_len;		/* sense/response data length */
 	u8 resid_cnt[4];		/* residual count */
 	u8 sense_data_buff[32];		/* sense/response data buffer */
-};
+} __packed;
 
 /*
  * Structure for I/O accelerator (mode 2 or m2) commands.
@@ -592,7 +593,7 @@ struct io_accel2_cmd {
 	__le32 tweak_upper;		/* Encryption tweak, upper 4 bytes */
 	struct ioaccel2_sg_element sg[IOACCEL2_MAXSGENTRIES];
 	struct io_accel2_scsi_response error_data;
-} __aligned(IOACCEL2_COMMANDLIST_ALIGNMENT);
+} __packed __aligned(IOACCEL2_COMMANDLIST_ALIGNMENT);
 
 /*
  * defines for Mode 2 command struct
@@ -618,7 +619,7 @@ struct hpsa_tmf_struct {
 	__le64 abort_tag;	/* cciss tag of SCSI cmd or TMF to abort */
 	__le64 error_ptr;		/* Error Pointer */
 	__le32 error_len;		/* Error Length */
-} __aligned(IOACCEL2_COMMANDLIST_ALIGNMENT);
+} __packed __aligned(IOACCEL2_COMMANDLIST_ALIGNMENT);
 
 /* Configuration Table Structure */
 struct HostWrite {
@@ -626,7 +627,7 @@ struct HostWrite {
 	__le32		command_pool_addr_hi;
 	__le32		CoalIntDelay;
 	__le32		CoalIntCount;
-};
+} __packed;
 
 #define SIMPLE_MODE     0x02
 #define PERFORMANT_MODE 0x04
@@ -675,7 +676,7 @@ struct CfgTable {
 #define		HPSA_EVENT_NOTIFY_ACCEL_IO_PATH_STATE_CHANGE (1 << 30)
 #define		HPSA_EVENT_NOTIFY_ACCEL_IO_PATH_CONFIG_CHANGE (1 << 31)
 	__le32		clear_event_notify;
-};
+} __packed;
 
 #define NUM_BLOCKFETCH_ENTRIES 8
 struct TransTable_struct {
@@ -686,14 +687,14 @@ struct TransTable_struct {
 	__le32		RepQCtrAddrHigh32;
 #define MAX_REPLY_QUEUES 64
 	struct vals32  RepQAddr[MAX_REPLY_QUEUES];
-};
+} __packed;
 
 struct hpsa_pci_info {
 	unsigned char	bus;
 	unsigned char	dev_fn;
 	unsigned short	domain;
 	u32		board_id;
-};
+} __packed;
 
 struct bmic_identify_controller {
 	u8	configured_logical_drive_count;	/* offset 0 */
@@ -702,7 +703,7 @@ struct bmic_identify_controller {
 	u8	pad2[136];
 	u8	controller_mode;	/* offset 292 */
 	u8	pad3[32];
-};
+} __packed;
 
 
 struct bmic_identify_physical_device {
@@ -845,7 +846,7 @@ struct bmic_identify_physical_device {
 	u8     max_link_rate[256];
 	u8     neg_phys_link_rate[256];
 	u8     box_conn_name[8];
-} __attribute((aligned(512)));
+} __packed __attribute((aligned(512)));
 
 struct bmic_sense_subsystem_info {
 	u8	primary_slot_number;
@@ -858,7 +859,7 @@ struct bmic_sense_subsystem_info {
 	u8	secondary_array_serial_number[32];
 	u8	secondary_cache_serial_number[32];
 	u8	pad[332];
-};
+} __packed;
 
 struct bmic_sense_storage_box_params {
 	u8	reserved[36];
@@ -870,7 +871,6 @@ struct bmic_sense_storage_box_params {
 	u8	reserver_3[84];
 	u8	phys_connector[2];
 	u8	reserved_4[296];
-};
+} __packed;
 
-#pragma pack()
 #endif /* HPSA_CMD_H */
-- 
2.31.1

