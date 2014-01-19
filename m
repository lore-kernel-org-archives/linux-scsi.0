From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 01/17] target: Add DIF related base definitions
Date: Sun, 19 Jan 2014 02:44:24 +0000
Message-ID: <1390099480-29013-2-git-send-email-nab@daterainc.com>
References: <1390099480-29013-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1390099480-29013-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Roland Dreier <roland@kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds DIF related definitions to target_core_base.h
that includes enums for target_prot_op + target_prot_type +
target_prot_version + target_guard_type + target_pi_error.

Also included is struct se_dif_v1_tuple, along with changes
to struct se_cmd, struct se_dev_attrib, and struct se_device.

Also, add new se_subsystem_api->[init,format,free]_prot() callers
used by target core code to setup backend specific protection
information after the device has been configured.

Enums taken from Sagi Grimberg's original patch.

v2 changes:
  - Drop guard_type related definitions
  - Update target_prot_op + target_prot_ho definitions (Sagi)
  - Drop SCF_PROT + pi_prot_version flag
  - Add se_subsystem_api->format_prot() (Sagi)
  - Add hw_pi_prot_type device attribute

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 include/target/target_core_backend.h |    3 +++
 include/target/target_core_base.h    |   44 ++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 39e0114..0dc2745 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -41,6 +41,9 @@ struct se_subsystem_api {
 	unsigned int (*get_io_opt)(struct se_device *);
 	unsigned char *(*get_sense_buffer)(struct se_cmd *);
 	bool (*get_write_cache)(struct se_device *);
+	int (*init_prot)(struct se_device *);
+	int (*format_prot)(struct se_device *);
+	void (*free_prot)(struct se_device *);
 };
 
 struct sbc_ops {
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index dd87ab4..d98048b 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -435,6 +435,34 @@ struct se_tmr_req {
 	struct list_head	tmr_list;
 };
 
+enum target_prot_op {
+	TARGET_PROT_NORMAL = 0,
+	TARGET_PROT_DIN_INSERT,
+	TARGET_PROT_DOUT_INSERT,
+	TARGET_PROT_DIN_STRIP,
+	TARGET_PROT_DOUT_STRIP,
+	TARGET_PROT_DIN_PASS,
+	TARGET_PROT_DOUT_PASS,
+};
+
+enum target_prot_ho {
+	PROT_SEPERATED,
+	PROT_INTERLEAVED,
+};
+
+enum target_prot_type {
+	TARGET_DIF_TYPE0_PROT,
+	TARGET_DIF_TYPE1_PROT,
+	TARGET_DIF_TYPE2_PROT,
+	TARGET_DIF_TYPE3_PROT,
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
@@ -519,6 +547,17 @@ struct se_cmd {
 
 	/* Used for lun->lun_ref counting */
 	bool			lun_ref_active;
+
+	/* DIF related members */
+	enum target_prot_op	prot_op;
+	enum target_prot_type	prot_type;
+	u32			prot_length;
+	u32			reftag_seed;
+	struct scatterlist	*t_prot_sg;
+	unsigned int		t_prot_nents;
+	enum target_prot_ho	prot_handover;
+	sense_reason_t		pi_err;
+	u32			block_num;
 };
 
 struct se_ua {
@@ -629,6 +668,9 @@ struct se_dev_attrib {
 	int		emulate_tpws;
 	int		emulate_caw;
 	int		emulate_3pc;
+	int		pi_prot_format;
+	enum target_prot_type pi_prot_type;
+	enum target_prot_type hw_pi_prot_type;
 	int		enforce_pr_isids;
 	int		is_nonrot;
 	int		emulate_rest_reord;
@@ -759,6 +801,8 @@ struct se_device {
 	/* Linked list for struct se_hba struct se_device list */
 	struct list_head	dev_list;
 	struct se_lun		xcopy_lun;
+	/* Protection Information */
+	int			prot_length;
 };
 
 struct se_hba {
-- 
1.7.10.4
