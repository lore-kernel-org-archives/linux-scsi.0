From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 026/103] target: rename struct pr_reservation_template to pr_reservation
Date: Thu, 21 Jul 2011 00:05:02 -0700
Message-ID: <1311231979-6631-27-git-send-email-nab@linux-iscsi.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm7.bullet.mail.bf1.yahoo.com ([98.139.212.166]:38519 "HELO
	nm7.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752030Ab1GUHGu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:06:50 -0400
In-Reply-To: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

"_template" in the name doesn't seem (to me) to be worth the added
verbosity.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_pr.c   |    4 ++--
 drivers/target/target_core_pr.h   |    2 +-
 include/target/target_core_base.h |    6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 99b97db..2ddbe0d 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -4019,7 +4019,7 @@ static int core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 	struct se_subsystem_dev *su_dev = SU_DEV(se_dev);
 	struct se_portal_group *se_tpg;
 	struct t10_pr_registration *pr_reg, *pr_reg_tmp;
-	struct t10_reservation_template *pr_tmpl = &SU_DEV(se_dev)->t10_reservation;
+	struct t10_reservation *pr_tmpl = &SU_DEV(se_dev)->t10_reservation;
 	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
 	u32 add_desc_len = 0, add_len = 0, desc_len, exp_desc_len;
 	u32 off = 8; /* off into first Full Status descriptor */
@@ -4213,7 +4213,7 @@ static int core_pt_seq_non_holder(
 int core_setup_reservations(struct se_device *dev, int force_pt)
 {
 	struct se_subsystem_dev *su_dev = dev->se_sub_dev;
-	struct t10_reservation_template *rest = &su_dev->t10_reservation;
+	struct t10_reservation *rest = &su_dev->t10_reservation;
 	/*
 	 * If this device is from Target_Core_Mod/pSCSI, use the reservations
 	 * of the Underlying SCSI hardware.  In Linux/SCSI terms, this can
diff --git a/drivers/target/target_core_pr.h b/drivers/target/target_core_pr.h
index 5603bcf..c8f47d0 100644
--- a/drivers/target/target_core_pr.h
+++ b/drivers/target/target_core_pr.h
@@ -49,7 +49,7 @@ extern int core_pr_dump_initiator_port(struct t10_pr_registration *,
 			char *, u32);
 extern int core_scsi2_emulate_crh(struct se_cmd *);
 extern int core_scsi3_alloc_aptpl_registration(
-			struct t10_reservation_template *, u64,
+			struct t10_reservation *, u64,
 			unsigned char *, unsigned char *, u32,
 			unsigned char *, u16, u32, int, int, u8);
 extern int core_scsi3_check_aptpl_registration(struct se_device *,
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 112eb38..2b989b3 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -361,13 +361,13 @@ struct t10_reservation_ops {
 	int (*t10_pr_clear)(struct se_cmd *);
 };
 
-struct t10_reservation_template {
+struct t10_reservation {
 	/* Reservation effects all target ports */
 	int pr_all_tg_pt;
 	/* Activate Persistence across Target Power Loss enabled
 	 * for SCSI device */
 	int pr_aptpl_active;
-	/* Used by struct t10_reservation_template->pr_aptpl_buf_len */
+	/* Used by struct t10_reservation->pr_aptpl_buf_len */
 #define PR_APTPL_BUF_LEN			8192
 	u32 pr_aptpl_buf_len;
 	u32 pr_generation;
@@ -722,7 +722,7 @@ struct se_subsystem_dev {
 	/* T10 Inquiry and VPD WWN Information */
 	struct t10_wwn	t10_wwn;
 	/* T10 SPC-2 + SPC-3 Reservations */
-	struct t10_reservation_template t10_reservation;
+	struct t10_reservation t10_reservation;
 	spinlock_t      se_dev_lock;
 	void            *se_dev_su_ptr;
 	struct list_head se_dev_node;
-- 
1.7.6

