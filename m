From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 01/14] target: Add DIF related base definitions
Date: Wed,  8 Jan 2014 20:15:44 +0000
Message-ID: <1389212157-14540-2-git-send-email-nab@daterainc.com>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1389212157-14540-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds DIF related definitions to target_core_base.h
that includes enums for target_prot_op + target_prot_type +
target_prot_version + target_guard_type + target_pi_error.

Also included is struct se_dif_v1_tuple, along with changes
to struct se_cmd, struct se_dev_attrib, and struct se_device.

Also, add new se_subsystem_api->[init,free]_prot() callers
used by target core code to setup backend specific protection
information after the device has been configured.

Enums taken from Sagi Grimberg's original patch.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

target: more defs

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 include/target/target_core_backend.h |    2 ++
 include/target/target_core_base.h    |   59 ++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+)

diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 39e0114..930f30d 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -41,6 +41,8 @@ struct se_subsystem_api {
 	unsigned int (*get_io_opt)(struct se_device *);
 	unsigned char *(*get_sense_buffer)(struct se_cmd *);
 	bool (*get_write_cache)(struct se_device *);
+	int (*init_prot)(struct se_device *);
+	void (*free_prot)(struct se_device *);
 };
 
 struct sbc_ops {
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 45412a6..15f402c 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -166,6 +166,7 @@ enum se_cmd_flags_table {
 	SCF_COMPARE_AND_WRITE		= 0x00080000,
 	SCF_COMPARE_AND_WRITE_POST	= 0x00100000,
 	SCF_CMD_XCOPY_PASSTHROUGH	= 0x00200000,
+	SCF_PROT			= 0x00400000,
 };
 
 /* struct se_dev_entry->lun_flags and struct se_lun->lun_access */
@@ -414,6 +415,45 @@ struct se_tmr_req {
 	struct list_head	tmr_list;
 };
 
+enum target_prot_op {
+	TARGET_PROT_NORMAL,
+	TARGET_PROT_READ_INSERT,
+	TARGET_PROT_WRITE_INSERT,
+	TARGET_PROT_READ_STRIP,
+	TARGET_PROT_WRITE_STRIP,
+	TARGET_PROT_READ_PASS,
+	TARGET_PROT_WRITE_PASS,
+};
+
+enum target_prot_type {
+	TARGET_DIF_TYPE0_PROT,
+	TARGET_DIF_TYPE1_PROT,
+	TARGET_DIF_TYPE2_PROT,
+	TARGET_DIF_TYPE3_PROT,
+};
+
+enum target_prot_version {
+	TARGET_DIF_V1 = 1,
+	TARGET_DIF_V2 = 2,
+};
+
+enum target_guard_type {
+	TARGET_DIX_GUARD_CRC = 1,
+	TARGET_DIX_GUARD_IP = 2,
+};
+
+enum target_pi_error {
+	TARGET_GUARD_CHECK_FAILED = 0x1,
+	TARGET_APPTAG_CHECK_FAILED = 0x2,
+	TARGET_REFTAG_CHECK_FAILED = 0x3,
+};
+
+struct se_dif_v1_tuple {
+	__be16			guard_tag;
+	__be16			app_tag;
+	__be32			ref_tag;
+};
+
 struct se_cmd {
 	/* SAM response code being sent to initiator */
 	u8			scsi_status;
@@ -498,6 +538,20 @@ struct se_cmd {
 
 	/* Used for lun->lun_ref counting */
 	bool			lun_ref_active;
+
+	/* DIF related members */
+	enum target_prot_op	prot_op;
+	enum target_prot_type	prot_type;
+	enum target_guard_type	bg_type;
+	u16			bg_seed;
+	u16			reftag_seed;
+	u32			apptag_seed;
+	u32			prot_length;
+	struct scatterlist	*t_prot_sg;
+	unsigned int		t_prot_nents;
+	bool			prot_interleaved;
+	enum target_pi_error	pi_err;
+	u32			block_num;
 };
 
 struct se_ua {
@@ -609,6 +663,9 @@ struct se_dev_attrib {
 	int		emulate_tpws;
 	int		emulate_caw;
 	int		emulate_3pc;
+	enum target_prot_type pi_prot_type;
+	enum target_prot_version pi_prot_version;
+	enum target_guard_type pi_guard_type;
 	int		enforce_pr_isids;
 	int		is_nonrot;
 	int		emulate_rest_reord;
@@ -739,6 +796,8 @@ struct se_device {
 	/* Linked list for struct se_hba struct se_device list */
 	struct list_head	dev_list;
 	struct se_lun		xcopy_lun;
+	/* Protection Information */
+	int			prot_length;
 };
 
 struct se_hba {
-- 
1.7.10.4
