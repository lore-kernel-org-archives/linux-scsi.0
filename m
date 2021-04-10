Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52EFDC433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 17:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21E51610D1
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 17:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234944AbhDJRs6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 13:48:58 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:52388 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234392AbhDJRs5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 10 Apr 2021 13:48:57 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 9F946128070F;
        Sat, 10 Apr 2021 10:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1618076922;
        bh=aX7QDgE/sTlDUQzq9DNL4K3OTw1Z2TNvV9ZDGCdVuXc=;
        h=Message-ID:Subject:From:To:Date:From;
        b=JyHHtge9a1Se840x9FKU7dKBFekzSQ2kobQLjxXLGsbCZy0NSlmrVUoRv5eJBUnVE
         xmYKWOnNXf/74kGrkZj56Fvf8MyeLmCVhKrvslptb3OXGLkREc8y1XbWMZJJoPFJ5b
         Pws5mV5qtLx8M1lqngiz+OjpF81seGrjZDg2tRqU=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id v5Vv9TaMvUSQ; Sat, 10 Apr 2021 10:48:42 -0700 (PDT)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 40AD2128070B;
        Sat, 10 Apr 2021 10:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1618076922;
        bh=aX7QDgE/sTlDUQzq9DNL4K3OTw1Z2TNvV9ZDGCdVuXc=;
        h=Message-ID:Subject:From:To:Date:From;
        b=JyHHtge9a1Se840x9FKU7dKBFekzSQ2kobQLjxXLGsbCZy0NSlmrVUoRv5eJBUnVE
         xmYKWOnNXf/74kGrkZj56Fvf8MyeLmCVhKrvslptb3OXGLkREc8y1XbWMZJJoPFJ5b
         Pws5mV5qtLx8M1lqngiz+OjpF81seGrjZDg2tRqU=
Message-ID: <dd2a3e71111fc7d1e35fa1a22de3e79adf09e26f.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.12-rc6
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 10 Apr 2021 10:48:41 -0700
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Seven fixes all in drivers.  The hpsa three are the most extensive and
the most problematic: it's a packed structure misalignment that oopses
on ia64 but looks like it would also oops on quite a few non-x86
architectures.  The pm80xx is a regression and the rest are bug fixes
for patches in the misc tree.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Can Guo (2):
      scsi: ufs: core: Fix wrong Task Tag used in task management request UPIUs
      scsi: ufs: core: Fix task management request completion timeout

Martin Wilck (1):
      scsi: scsi_transport_srp: Don't block target in SRP_PORT_LOST state

Roman Bolshakov (1):
      scsi: target: iscsi: Fix zero tag inside a trace event

Sergei Trofimovich (3):
      scsi: hpsa: Add an assert to prevent __packed reintroduction
      scsi: hpsa: Fix boot on ia64 (atomic_t alignment)
      scsi: hpsa: Use __packed on individual structs, not header-wide

Viswas G (1):
      scsi: pm80xx: Fix chip initialization failure

And the diffstat:

 drivers/scsi/hpsa_cmd.h             | 78 +++++++++++++++++++++----------------
 drivers/scsi/pm8001/pm8001_hwi.c    |  8 ++--
 drivers/scsi/scsi_transport_srp.c   |  2 +-
 drivers/scsi/ufs/ufshcd.c           | 31 +++++++--------
 drivers/target/iscsi/iscsi_target.c |  3 +-
 5 files changed, 65 insertions(+), 57 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index d126bb877250..ba6a3aa8d954 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -20,6 +20,11 @@
 #ifndef HPSA_CMD_H
 #define HPSA_CMD_H
 
+#include <linux/compiler.h>
+
+#include <linux/build_bug.h> /* static_assert */
+#include <linux/stddef.h> /* offsetof */
+
 /* general boundary defintions */
 #define SENSEINFOBYTES          32 /* may vary between hbas */
 #define SG_ENTRIES_IN_CMD	32 /* Max SG entries excluding chain blocks */
@@ -200,12 +205,10 @@ union u64bit {
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
@@ -221,7 +224,7 @@ struct raid_map_disk_data {
 	u8    xor_mult[2];            /**< XOR multipliers for this position,
 					*  valid for data disks only */
 	u8    reserved[2];
-};
+} __packed;
 
 struct raid_map_data {
 	__le32   structure_size;	/* Size of entire structure in bytes */
@@ -247,14 +250,14 @@ struct raid_map_data {
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
@@ -269,20 +272,20 @@ struct ext_report_lun_entry {
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
@@ -317,7 +320,7 @@ union SCSI3Addr {
 		u8 Targ:6;
 		u8 Mode:2;        /* b10 */
 	} LogUnit;
-};
+} __packed;
 
 struct PhysDevAddr {
 	u32             TargetId:24;
@@ -325,20 +328,20 @@ struct PhysDevAddr {
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
@@ -346,7 +349,7 @@ struct CommandListHeader {
 	__le16          SGTotal;
 	__le64		tag;
 	union LUNAddr     LUN;
-};
+} __packed;
 
 struct RequestBlock {
 	u8   CDBLen;
@@ -365,18 +368,18 @@ struct RequestBlock {
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
@@ -390,7 +393,8 @@ union MoreErrInfo {
 		u8  offense_num;  /* byte # of offense 0-base */
 		u32 offense_value;
 	} Invalid_Cmd;
-};
+} __packed;
+
 struct ErrorInfo {
 	u8               ScsiStatus;
 	u8               SenseLen;
@@ -398,7 +402,7 @@ struct ErrorInfo {
 	u32              ResidualCnt;
 	union MoreErrInfo  MoreErrInfo;
 	u8               SenseInfo[SENSEINFOBYTES];
-};
+} __packed;
 /* Command types */
 #define CMD_IOCTL_PEND  0x01
 #define CMD_SCSI	0x03
@@ -453,6 +457,15 @@ struct CommandList {
 	atomic_t refcount; /* Must be last to avoid memset in hpsa_cmd_init() */
 } __aligned(COMMANDLIST_ALIGNMENT);
 
+/*
+ * Make sure our embedded atomic variable is aligned. Otherwise we break atomic
+ * operations on architectures that don't support unaligned atomics like IA64.
+ *
+ * The assert guards against reintroductin against unwanted __packed to
+ * the struct CommandList.
+ */
+static_assert(offsetof(struct CommandList, refcount) % __alignof__(atomic_t) == 0);
+
 /* Max S/G elements in I/O accelerator command */
 #define IOACCEL1_MAXSGENTRIES           24
 #define IOACCEL2_MAXSGENTRIES		28
@@ -489,7 +502,7 @@ struct io_accel1_cmd {
 	__le64 host_addr;		/* 0x70 - 0x77 */
 	u8  CISS_LUN[8];		/* 0x78 - 0x7F */
 	struct SGDescriptor SG[IOACCEL1_MAXSGENTRIES];
-} __aligned(IOACCEL1_COMMANDLIST_ALIGNMENT);
+} __packed __aligned(IOACCEL1_COMMANDLIST_ALIGNMENT);
 
 #define IOACCEL1_FUNCTION_SCSIIO        0x00
 #define IOACCEL1_SGLOFFSET              32
@@ -519,7 +532,7 @@ struct ioaccel2_sg_element {
 	u8 chain_indicator;
 #define IOACCEL2_CHAIN 0x80
 #define IOACCEL2_LAST_SG 0x40
-};
+} __packed;
 
 /*
  * SCSI Response Format structure for IO Accelerator Mode 2
@@ -559,7 +572,7 @@ struct io_accel2_scsi_response {
 	u8 sense_data_len;		/* sense/response data length */
 	u8 resid_cnt[4];		/* residual count */
 	u8 sense_data_buff[32];		/* sense/response data buffer */
-};
+} __packed;
 
 /*
  * Structure for I/O accelerator (mode 2 or m2) commands.
@@ -592,7 +605,7 @@ struct io_accel2_cmd {
 	__le32 tweak_upper;		/* Encryption tweak, upper 4 bytes */
 	struct ioaccel2_sg_element sg[IOACCEL2_MAXSGENTRIES];
 	struct io_accel2_scsi_response error_data;
-} __aligned(IOACCEL2_COMMANDLIST_ALIGNMENT);
+} __packed __aligned(IOACCEL2_COMMANDLIST_ALIGNMENT);
 
 /*
  * defines for Mode 2 command struct
@@ -618,7 +631,7 @@ struct hpsa_tmf_struct {
 	__le64 abort_tag;	/* cciss tag of SCSI cmd or TMF to abort */
 	__le64 error_ptr;		/* Error Pointer */
 	__le32 error_len;		/* Error Length */
-} __aligned(IOACCEL2_COMMANDLIST_ALIGNMENT);
+} __packed __aligned(IOACCEL2_COMMANDLIST_ALIGNMENT);
 
 /* Configuration Table Structure */
 struct HostWrite {
@@ -626,7 +639,7 @@ struct HostWrite {
 	__le32		command_pool_addr_hi;
 	__le32		CoalIntDelay;
 	__le32		CoalIntCount;
-};
+} __packed;
 
 #define SIMPLE_MODE     0x02
 #define PERFORMANT_MODE 0x04
@@ -675,7 +688,7 @@ struct CfgTable {
 #define		HPSA_EVENT_NOTIFY_ACCEL_IO_PATH_STATE_CHANGE (1 << 30)
 #define		HPSA_EVENT_NOTIFY_ACCEL_IO_PATH_CONFIG_CHANGE (1 << 31)
 	__le32		clear_event_notify;
-};
+} __packed;
 
 #define NUM_BLOCKFETCH_ENTRIES 8
 struct TransTable_struct {
@@ -686,14 +699,14 @@ struct TransTable_struct {
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
@@ -702,7 +715,7 @@ struct bmic_identify_controller {
 	u8	pad2[136];
 	u8	controller_mode;	/* offset 292 */
 	u8	pad3[32];
-};
+} __packed;
 
 
 struct bmic_identify_physical_device {
@@ -845,7 +858,7 @@ struct bmic_identify_physical_device {
 	u8     max_link_rate[256];
 	u8     neg_phys_link_rate[256];
 	u8     box_conn_name[8];
-} __attribute((aligned(512)));
+} __packed __attribute((aligned(512)));
 
 struct bmic_sense_subsystem_info {
 	u8	primary_slot_number;
@@ -858,7 +871,7 @@ struct bmic_sense_subsystem_info {
 	u8	secondary_array_serial_number[32];
 	u8	secondary_cache_serial_number[32];
 	u8	pad[332];
-};
+} __packed;
 
 struct bmic_sense_storage_box_params {
 	u8	reserved[36];
@@ -870,7 +883,6 @@ struct bmic_sense_storage_box_params {
 	u8	reserver_3[84];
 	u8	phys_connector[2];
 	u8	reserved_4[296];
-};
+} __packed;
 
-#pragma pack()
 #endif /* HPSA_CMD_H */
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 49bf2f70a470..31e5455d280c 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -223,7 +223,7 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
 		PM8001_EVENT_LOG_SIZE;
 	pm8001_ha->main_cfg_tbl.pm8001_tbl.iop_event_log_option		= 0x01;
 	pm8001_ha->main_cfg_tbl.pm8001_tbl.fatal_err_interrupt		= 0x01;
-	for (i = 0; i < PM8001_MAX_INB_NUM; i++) {
+	for (i = 0; i < pm8001_ha->max_q_num; i++) {
 		pm8001_ha->inbnd_q_tbl[i].element_pri_size_cnt	=
 			PM8001_MPI_QUEUE | (pm8001_ha->iomb_size << 16) | (0x00<<30);
 		pm8001_ha->inbnd_q_tbl[i].upper_base_addr	=
@@ -249,7 +249,7 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
 		pm8001_ha->inbnd_q_tbl[i].producer_idx		= 0;
 		pm8001_ha->inbnd_q_tbl[i].consumer_index	= 0;
 	}
-	for (i = 0; i < PM8001_MAX_OUTB_NUM; i++) {
+	for (i = 0; i < pm8001_ha->max_q_num; i++) {
 		pm8001_ha->outbnd_q_tbl[i].element_size_cnt	=
 			PM8001_MPI_QUEUE | (pm8001_ha->iomb_size << 16) | (0x01<<30);
 		pm8001_ha->outbnd_q_tbl[i].upper_base_addr	=
@@ -671,9 +671,9 @@ static int pm8001_chip_init(struct pm8001_hba_info *pm8001_ha)
 	read_outbnd_queue_table(pm8001_ha);
 	/* update main config table ,inbound table and outbound table */
 	update_main_config_table(pm8001_ha);
-	for (i = 0; i < PM8001_MAX_INB_NUM; i++)
+	for (i = 0; i < pm8001_ha->max_q_num; i++)
 		update_inbnd_queue_table(pm8001_ha, i);
-	for (i = 0; i < PM8001_MAX_OUTB_NUM; i++)
+	for (i = 0; i < pm8001_ha->max_q_num; i++)
 		update_outbnd_queue_table(pm8001_ha, i);
 	/* 8081 controller donot require these operations */
 	if (deviceid != 0x8081 && deviceid != 0x0042) {
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 1e939a2a387f..98a34ed10f1a 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -541,7 +541,7 @@ int srp_reconnect_rport(struct srp_rport *rport)
 	res = mutex_lock_interruptible(&rport->mutex);
 	if (res)
 		goto out;
-	if (rport->state != SRP_RPORT_FAIL_FAST)
+	if (rport->state != SRP_RPORT_FAIL_FAST && rport->state != SRP_RPORT_LOST)
 		/*
 		 * sdev state must be SDEV_TRANSPORT_OFFLINE, transition
 		 * to SDEV_BLOCK is illegal. Calling scsi_target_unblock()
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c86760788c72..d3d05e997c13 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6386,37 +6386,34 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct request *req;
 	unsigned long flags;
-	int free_slot, task_tag, err;
+	int task_tag, err;
 
 	/*
-	 * Get free slot, sleep if slots are unavailable.
-	 * Even though we use wait_event() which sleeps indefinitely,
-	 * the maximum wait time is bounded by %TM_CMD_TIMEOUT.
+	 * blk_get_request() is used here only to get a free tag.
 	 */
 	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
 	req->end_io_data = &wait;
-	free_slot = req->tag;
-	WARN_ON_ONCE(free_slot < 0 || free_slot >= hba->nutmrs);
 	ufshcd_hold(hba, false);
 
 	spin_lock_irqsave(host->host_lock, flags);
-	task_tag = hba->nutrs + free_slot;
+	blk_mq_start_request(req);
 
+	task_tag = req->tag;
 	treq->req_header.dword_0 |= cpu_to_be32(task_tag);
 
-	memcpy(hba->utmrdl_base_addr + free_slot, treq, sizeof(*treq));
-	ufshcd_vops_setup_task_mgmt(hba, free_slot, tm_function);
+	memcpy(hba->utmrdl_base_addr + task_tag, treq, sizeof(*treq));
+	ufshcd_vops_setup_task_mgmt(hba, task_tag, tm_function);
 
 	/* send command to the controller */
-	__set_bit(free_slot, &hba->outstanding_tasks);
+	__set_bit(task_tag, &hba->outstanding_tasks);
 
 	/* Make sure descriptors are ready before ringing the task doorbell */
 	wmb();
 
-	ufshcd_writel(hba, 1 << free_slot, REG_UTP_TASK_REQ_DOOR_BELL);
+	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TASK_REQ_DOOR_BELL);
 	/* Make sure that doorbell is committed immediately */
 	wmb();
 
@@ -6436,24 +6433,24 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 		ufshcd_add_tm_upiu_trace(hba, task_tag, UFS_TM_ERR);
 		dev_err(hba->dev, "%s: task management cmd 0x%.2x timed-out\n",
 				__func__, tm_function);
-		if (ufshcd_clear_tm_cmd(hba, free_slot))
-			dev_WARN(hba->dev, "%s: unable clear tm cmd (slot %d) after timeout\n",
-					__func__, free_slot);
+		if (ufshcd_clear_tm_cmd(hba, task_tag))
+			dev_WARN(hba->dev, "%s: unable to clear tm cmd (slot %d) after timeout\n",
+					__func__, task_tag);
 		err = -ETIMEDOUT;
 	} else {
 		err = 0;
-		memcpy(treq, hba->utmrdl_base_addr + free_slot, sizeof(*treq));
+		memcpy(treq, hba->utmrdl_base_addr + task_tag, sizeof(*treq));
 
 		ufshcd_add_tm_upiu_trace(hba, task_tag, UFS_TM_COMP);
 	}
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	__clear_bit(free_slot, &hba->outstanding_tasks);
+	__clear_bit(task_tag, &hba->outstanding_tasks);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
+	ufshcd_release(hba);
 	blk_put_request(req);
 
-	ufshcd_release(hba);
 	return err;
 }
 
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index d0e7ed8f28cc..e5c443bfbdf9 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1166,6 +1166,7 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 
 	target_get_sess_cmd(&cmd->se_cmd, true);
 
+	cmd->se_cmd.tag = (__force u32)cmd->init_task_tag;
 	cmd->sense_reason = target_cmd_init_cdb(&cmd->se_cmd, hdr->cdb);
 	if (cmd->sense_reason) {
 		if (cmd->sense_reason == TCM_OUT_OF_RESOURCES) {
@@ -1180,8 +1181,6 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	if (cmd->sense_reason)
 		goto attach_cmd;
 
-	/* only used for printks or comparing with ->ref_task_tag */
-	cmd->se_cmd.tag = (__force u32)cmd->init_task_tag;
 	cmd->sense_reason = target_cmd_parse_cdb(&cmd->se_cmd);
 	if (cmd->sense_reason)
 		goto attach_cmd;

