From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 06/14] target: Convert se_cmd->execute_cmd to target_iostate
Date: Wed,  1 Jun 2016 21:48:39 +0000
Message-ID: <1464817727-9125-7-git-send-email-nab@linux-iscsi.org>
References: <1464817727-9125-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1464817727-9125-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the se_cmd->execute_cmd() caller
to accept target_iostate, and updates existing users
tree-wide.

Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_alua.c      |  9 ++++---
 drivers/target/target_core_alua.h      |  6 ++---
 drivers/target/target_core_device.c    |  2 +-
 drivers/target/target_core_pr.c        | 12 ++++++---
 drivers/target/target_core_pr.h        |  8 +++---
 drivers/target/target_core_pscsi.c     |  5 ++--
 drivers/target/target_core_sbc.c       | 47 ++++++++++++++++++++++++++--------
 drivers/target/target_core_spc.c       | 19 +++++++++-----
 drivers/target/target_core_transport.c |  2 +-
 drivers/target/target_core_user.c      |  3 ++-
 drivers/target/target_core_xcopy.c     |  6 +++--
 drivers/target/target_core_xcopy.h     |  4 +--
 include/target/target_core_backend.h   |  4 +--
 include/target/target_core_base.h      |  2 +-
 14 files changed, 86 insertions(+), 43 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index c806a96..5cb1c88 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -63,8 +63,9 @@ struct t10_alua_lu_gp *default_lu_gp;
  * See sbc3r35 section 5.23
  */
 sense_reason_t
-target_emulate_report_referrals(struct se_cmd *cmd)
+target_emulate_report_referrals(struct target_iostate *ios)
 {
+	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
 	struct se_device *dev = cmd->se_dev;
 	struct t10_alua_lba_map *map;
 	struct t10_alua_lba_map_member *map_mem;
@@ -143,8 +144,9 @@ target_emulate_report_referrals(struct se_cmd *cmd)
  * See spc4r17 section 6.27
  */
 sense_reason_t
-target_emulate_report_target_port_groups(struct se_cmd *cmd)
+target_emulate_report_target_port_groups(struct target_iostate *ios)
 {
+	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
 	struct se_device *dev = cmd->se_dev;
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
 	struct se_lun *lun;
@@ -276,8 +278,9 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
  * See spc4r17 section 6.35
  */
 sense_reason_t
-target_emulate_set_target_port_groups(struct se_cmd *cmd)
+target_emulate_set_target_port_groups(struct target_iostate *ios)
 {
+	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
 	struct se_device *dev = cmd->se_dev;
 	struct se_lun *l_lun = cmd->se_lun;
 	struct se_node_acl *nacl = cmd->se_sess->se_node_acl;
diff --git a/drivers/target/target_core_alua.h b/drivers/target/target_core_alua.h
index 9b250f9..1e84af2 100644
--- a/drivers/target/target_core_alua.h
+++ b/drivers/target/target_core_alua.h
@@ -88,9 +88,9 @@ extern struct kmem_cache *t10_alua_tg_pt_gp_cache;
 extern struct kmem_cache *t10_alua_lba_map_cache;
 extern struct kmem_cache *t10_alua_lba_map_mem_cache;
 
-extern sense_reason_t target_emulate_report_target_port_groups(struct se_cmd *);
-extern sense_reason_t target_emulate_set_target_port_groups(struct se_cmd *);
-extern sense_reason_t target_emulate_report_referrals(struct se_cmd *);
+extern sense_reason_t target_emulate_report_target_port_groups(struct target_iostate *);
+extern sense_reason_t target_emulate_set_target_port_groups(struct target_iostate *);
+extern sense_reason_t target_emulate_report_referrals(struct target_iostate *);
 extern int core_alua_check_nonop_delay(struct se_cmd *);
 extern int core_alua_do_port_transition(struct t10_alua_tg_pt_gp *,
 				struct se_device *, struct se_lun *,
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 910c990..d82b9b4 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1026,7 +1026,7 @@ void core_dev_release_virtual_lun0(void)
  */
 sense_reason_t
 passthrough_parse_cdb(struct se_cmd *cmd,
-	sense_reason_t (*exec_cmd)(struct se_cmd *cmd))
+	sense_reason_t (*exec_cmd)(struct target_iostate *ios))
 {
 	unsigned char *cdb = cmd->t_task_cdb;
 
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index f91058f..022084f 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -197,8 +197,9 @@ static int target_check_scsi2_reservation_conflict(struct se_cmd *cmd)
 }
 
 sense_reason_t
-target_scsi2_reservation_release(struct se_cmd *cmd)
+target_scsi2_reservation_release(struct target_iostate *ios)
 {
+	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
 	struct se_device *dev = cmd->se_dev;
 	struct se_session *sess = cmd->se_sess;
 	struct se_portal_group *tpg;
@@ -243,8 +244,9 @@ out:
 }
 
 sense_reason_t
-target_scsi2_reservation_reserve(struct se_cmd *cmd)
+target_scsi2_reservation_reserve(struct target_iostate *ios)
 {
+	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
 	struct se_device *dev = cmd->se_dev;
 	struct se_session *sess = cmd->se_sess;
 	struct se_portal_group *tpg;
@@ -3565,8 +3567,9 @@ static unsigned long long core_scsi3_extract_reservation_key(unsigned char *cdb)
  * See spc4r17 section 6.14 Table 170
  */
 sense_reason_t
-target_scsi3_emulate_pr_out(struct se_cmd *cmd)
+target_scsi3_emulate_pr_out(struct target_iostate *ios)
 {
+	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
 	struct se_device *dev = cmd->se_dev;
 	unsigned char *cdb = &cmd->t_task_cdb[0];
 	unsigned char *buf;
@@ -4092,8 +4095,9 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 }
 
 sense_reason_t
-target_scsi3_emulate_pr_in(struct se_cmd *cmd)
+target_scsi3_emulate_pr_in(struct target_iostate *ios)
 {
+	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
 	sense_reason_t ret;
 
 	/*
diff --git a/drivers/target/target_core_pr.h b/drivers/target/target_core_pr.h
index e3d26e9..181bf97 100644
--- a/drivers/target/target_core_pr.h
+++ b/drivers/target/target_core_pr.h
@@ -52,8 +52,8 @@ extern struct kmem_cache *t10_pr_reg_cache;
 
 extern void core_pr_dump_initiator_port(struct t10_pr_registration *,
 			char *, u32);
-extern sense_reason_t target_scsi2_reservation_release(struct se_cmd *);
-extern sense_reason_t target_scsi2_reservation_reserve(struct se_cmd *);
+extern sense_reason_t target_scsi2_reservation_release(struct target_iostate *);
+extern sense_reason_t target_scsi2_reservation_reserve(struct target_iostate *);
 extern int core_scsi3_alloc_aptpl_registration(
 			struct t10_reservation *, u64,
 			unsigned char *, unsigned char *, u64,
@@ -66,8 +66,8 @@ extern void core_scsi3_free_pr_reg_from_nacl(struct se_device *,
 extern void core_scsi3_free_all_registrations(struct se_device *);
 extern unsigned char *core_scsi3_pr_dump_type(int);
 
-extern sense_reason_t target_scsi3_emulate_pr_in(struct se_cmd *);
-extern sense_reason_t target_scsi3_emulate_pr_out(struct se_cmd *);
+extern sense_reason_t target_scsi3_emulate_pr_in(struct target_iostate *ios);
+extern sense_reason_t target_scsi3_emulate_pr_out(struct target_iostate *ios);
 extern sense_reason_t target_check_reservation(struct se_cmd *);
 
 #endif /* TARGET_CORE_PR_H */
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index b5728bc..c52f943 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -54,7 +54,7 @@ static inline struct pscsi_dev_virt *PSCSI_DEV(struct se_device *dev)
 	return container_of(dev, struct pscsi_dev_virt, dev);
 }
 
-static sense_reason_t pscsi_execute_cmd(struct se_cmd *cmd);
+static sense_reason_t pscsi_execute_cmd(struct target_iostate *ios);
 static void pscsi_req_done(struct request *, int);
 
 /*	pscsi_attach_hba():
@@ -988,8 +988,9 @@ pscsi_parse_cdb(struct se_cmd *cmd)
 }
 
 static sense_reason_t
-pscsi_execute_cmd(struct se_cmd *cmd)
+pscsi_execute_cmd(struct target_iostate *ios)
 {
+	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
 	struct scatterlist *sgl = cmd->t_iomem.t_data_sg;
 	u32 sgl_nents = cmd->t_iomem.t_data_nents;
 	enum dma_data_direction data_direction = cmd->t_iostate.data_direction;
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 744ef71..2095f78 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -38,11 +38,12 @@
 
 static sense_reason_t
 sbc_check_prot(struct se_device *, struct se_cmd *, unsigned char *, u32, bool);
-static sense_reason_t sbc_execute_unmap(struct se_cmd *cmd);
+static sense_reason_t sbc_execute_unmap(struct target_iostate *ios);
 
 static sense_reason_t
-sbc_emulate_readcapacity(struct se_cmd *cmd)
+sbc_emulate_readcapacity(struct target_iostate *ios)
 {
+	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
 	struct se_device *dev = cmd->se_dev;
 	unsigned char *cdb = cmd->t_task_cdb;
 	unsigned long long blocks_long = dev->transport->get_blocks(dev);
@@ -90,8 +91,9 @@ sbc_emulate_readcapacity(struct se_cmd *cmd)
 }
 
 static sense_reason_t
-sbc_emulate_readcapacity_16(struct se_cmd *cmd)
+sbc_emulate_readcapacity_16(struct target_iostate *ios)
 {
+	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
 	struct se_device *dev = cmd->se_dev;
 	struct se_session *sess = cmd->se_sess;
 	int pi_prot_type = dev->dev_attrib.pi_prot_type;
@@ -163,8 +165,9 @@ sbc_emulate_readcapacity_16(struct se_cmd *cmd)
 }
 
 static sense_reason_t
-sbc_emulate_startstop(struct se_cmd *cmd)
+sbc_emulate_startstop(struct target_iostate *ios)
 {
+	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
 	unsigned char *cdb = cmd->t_task_cdb;
 
 	/*
@@ -218,8 +221,9 @@ sector_t sbc_get_write_same_sectors(struct se_cmd *cmd)
 EXPORT_SYMBOL(sbc_get_write_same_sectors);
 
 static sense_reason_t
-sbc_execute_write_same_unmap(struct se_cmd *cmd)
+sbc_execute_write_same_unmap(struct target_iostate *ios)
 {
+	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
 	struct sbc_ops *ops = cmd->protocol_data;
 	sector_t nolb = sbc_get_write_same_sectors(cmd);
 	sense_reason_t ret;
@@ -235,8 +239,10 @@ sbc_execute_write_same_unmap(struct se_cmd *cmd)
 }
 
 static sense_reason_t
-sbc_emulate_noop(struct se_cmd *cmd)
+sbc_emulate_noop(struct target_iostate *ios)
 {
+	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
+
 	target_complete_cmd(cmd, GOOD);
 	return 0;
 }
@@ -318,6 +324,14 @@ static inline unsigned long long transport_lba_64_ext(unsigned char *cdb)
 	return ((unsigned long long)__v2) | (unsigned long long)__v1 << 32;
 }
 
+static sense_reason_t sbc_execute_write_same(struct target_iostate *ios)
+{
+	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
+	struct sbc_ops *ops = cmd->protocol_data;
+
+	return ops->execute_write_same(cmd);
+}
+
 static sense_reason_t
 sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *ops)
 {
@@ -375,7 +389,7 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *o
 	if (ret)
 		return ret;
 
-	cmd->execute_cmd = ops->execute_write_same;
+	cmd->execute_cmd = &sbc_execute_write_same;
 	return 0;
 }
 
@@ -439,14 +453,23 @@ out:
 }
 
 static sense_reason_t
-sbc_execute_rw(struct se_cmd *cmd)
+sbc_execute_rw(struct target_iostate *ios)
 {
+	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
 	struct sbc_ops *ops = cmd->protocol_data;
 
 	return ops->execute_rw(cmd, cmd->t_iomem.t_data_sg, cmd->t_iomem.t_data_nents,
 			       cmd->t_iostate.data_direction);
 }
 
+static sense_reason_t sbc_execute_sync_cache(struct target_iostate *ios)
+{
+	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
+	struct sbc_ops *ops = cmd->protocol_data;
+
+	return ops->execute_sync_cache(cmd);
+}
+
 static sense_reason_t compare_and_write_post(struct se_cmd *cmd, bool success,
 					     int *post_ret)
 {
@@ -626,8 +649,9 @@ out:
 }
 
 static sense_reason_t
-sbc_compare_and_write(struct se_cmd *cmd)
+sbc_compare_and_write(struct target_iostate *ios)
 {
+	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
 	struct sbc_ops *ops = cmd->protocol_data;
 	struct se_device *dev = cmd->se_dev;
 	sense_reason_t ret;
@@ -1054,7 +1078,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 			cmd->t_iostate.t_task_lba = transport_lba_64(cdb);
 		}
 		if (ops->execute_sync_cache) {
-			cmd->execute_cmd = ops->execute_sync_cache;
+			cmd->execute_cmd = sbc_execute_sync_cache;
 			goto check_lba;
 		}
 		size = 0;
@@ -1163,8 +1187,9 @@ u32 sbc_get_device_type(struct se_device *dev)
 EXPORT_SYMBOL(sbc_get_device_type);
 
 static sense_reason_t
-sbc_execute_unmap(struct se_cmd *cmd)
+sbc_execute_unmap(struct target_iostate *ios)
 {
+	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
 	struct sbc_ops *ops = cmd->protocol_data;
 	struct se_device *dev = cmd->se_dev;
 	unsigned char *buf, *ptr = NULL;
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 2364de7..c672d9a 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -702,8 +702,9 @@ spc_emulate_evpd_00(struct se_cmd *cmd, unsigned char *buf)
 }
 
 static sense_reason_t
-spc_emulate_inquiry(struct se_cmd *cmd)
+spc_emulate_inquiry(struct target_iostate *ios)
 {
+	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
 	struct se_device *dev = cmd->se_dev;
 	struct se_portal_group *tpg = cmd->se_lun->lun_tpg;
 	unsigned char *rbuf;
@@ -982,8 +983,9 @@ static int spc_modesense_long_blockdesc(unsigned char *buf, u64 blocks, u32 bloc
 	return 17;
 }
 
-static sense_reason_t spc_emulate_modesense(struct se_cmd *cmd)
+static sense_reason_t spc_emulate_modesense(struct target_iostate *ios)
 {
+	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
 	struct se_device *dev = cmd->se_dev;
 	char *cdb = cmd->t_task_cdb;
 	unsigned char buf[SE_MODE_PAGE_BUF], *rbuf;
@@ -1107,8 +1109,9 @@ set_length:
 	return 0;
 }
 
-static sense_reason_t spc_emulate_modeselect(struct se_cmd *cmd)
+static sense_reason_t spc_emulate_modeselect(struct target_iostate *ios)
 {
+	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
 	char *cdb = cmd->t_task_cdb;
 	bool ten = cdb[0] == MODE_SELECT_10;
 	int off = ten ? 8 : 4;
@@ -1168,8 +1171,9 @@ out:
 	return ret;
 }
 
-static sense_reason_t spc_emulate_request_sense(struct se_cmd *cmd)
+static sense_reason_t spc_emulate_request_sense(struct target_iostate *ios)
 {
+	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
 	unsigned char *cdb = cmd->t_task_cdb;
 	unsigned char *rbuf;
 	u8 ua_asc = 0, ua_ascq = 0;
@@ -1201,8 +1205,9 @@ static sense_reason_t spc_emulate_request_sense(struct se_cmd *cmd)
 	return 0;
 }
 
-sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
+sense_reason_t spc_emulate_report_luns(struct target_iostate *ios)
 {
+	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
 	struct se_dev_entry *deve;
 	struct se_session *sess = cmd->se_sess;
 	struct se_node_acl *nacl;
@@ -1270,8 +1275,10 @@ done:
 EXPORT_SYMBOL(spc_emulate_report_luns);
 
 static sense_reason_t
-spc_emulate_testunitready(struct se_cmd *cmd)
+spc_emulate_testunitready(struct target_iostate *ios)
 {
+	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
+
 	target_complete_cmd(cmd, GOOD);
 	return 0;
 }
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 4156059..b6a3543 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1804,7 +1804,7 @@ void __target_execute_cmd(struct se_cmd *cmd, bool do_checks)
 	cmd->t_iostate.iomem = &cmd->t_iomem;
 	cmd->t_iostate.t_comp_func = &target_complete_ios;
 
-	ret = cmd->execute_cmd(cmd);
+	ret = cmd->execute_cmd(&cmd->t_iostate);
 	if (!ret)
 		return;
 err:
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 505b312..3467560 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1130,8 +1130,9 @@ static sector_t tcmu_get_blocks(struct se_device *dev)
 }
 
 static sense_reason_t
-tcmu_pass_op(struct se_cmd *se_cmd)
+tcmu_pass_op(struct target_iostate *ios)
 {
+	struct se_cmd *se_cmd = container_of(ios, struct se_cmd, t_iostate);
 	int ret = tcmu_queue_cmd(se_cmd);
 
 	if (ret != 0)
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index b6aeb15..04d064f 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -822,8 +822,9 @@ out:
 	target_complete_cmd(ec_cmd, SAM_STAT_CHECK_CONDITION);
 }
 
-sense_reason_t target_do_xcopy(struct se_cmd *se_cmd)
+sense_reason_t target_do_xcopy(struct target_iostate *ios)
 {
+	struct se_cmd *se_cmd = container_of(ios, struct se_cmd, t_iostate);
 	struct se_device *dev = se_cmd->se_dev;
 	struct xcopy_op *xop = NULL;
 	unsigned char *p = NULL, *seg_desc;
@@ -1006,8 +1007,9 @@ static sense_reason_t target_rcr_operating_parameters(struct se_cmd *se_cmd)
 	return TCM_NO_SENSE;
 }
 
-sense_reason_t target_do_receive_copy_results(struct se_cmd *se_cmd)
+sense_reason_t target_do_receive_copy_results(struct target_iostate *ios)
 {
+	struct se_cmd *se_cmd = container_of(ios, struct se_cmd, t_iostate);
 	unsigned char *cdb = &se_cmd->t_task_cdb[0];
 	int sa = (cdb[1] & 0x1f), list_id = cdb[2];
 	sense_reason_t rc = TCM_NO_SENSE;
diff --git a/drivers/target/target_core_xcopy.h b/drivers/target/target_core_xcopy.h
index 700a981..e4e057e 100644
--- a/drivers/target/target_core_xcopy.h
+++ b/drivers/target/target_core_xcopy.h
@@ -58,5 +58,5 @@ struct xcopy_op {
 
 extern int target_xcopy_setup_pt(void);
 extern void target_xcopy_release_pt(void);
-extern sense_reason_t target_do_xcopy(struct se_cmd *);
-extern sense_reason_t target_do_receive_copy_results(struct se_cmd *);
+extern sense_reason_t target_do_xcopy(struct target_iostate *);
+extern sense_reason_t target_do_receive_copy_results(struct target_iostate *);
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 2f6deb0..4a57477 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -61,7 +61,7 @@ void	target_complete_cmd_with_length(struct se_cmd *, u8, int);
 void	target_complete_ios(struct target_iostate *, u16);
 
 sense_reason_t	spc_parse_cdb(struct se_cmd *cmd, unsigned int *size);
-sense_reason_t	spc_emulate_report_luns(struct se_cmd *cmd);
+sense_reason_t	spc_emulate_report_luns(struct target_iostate *ios);
 sense_reason_t	spc_emulate_inquiry_std(struct se_cmd *, unsigned char *);
 sense_reason_t	spc_emulate_evpd_83(struct se_cmd *, unsigned char *);
 
@@ -91,7 +91,7 @@ sense_reason_t	transport_generic_map_mem_to_cmd(struct se_cmd *,
 
 bool	target_lun_is_rdonly(struct se_cmd *);
 sense_reason_t passthrough_parse_cdb(struct se_cmd *cmd,
-	sense_reason_t (*exec_cmd)(struct se_cmd *cmd));
+	sense_reason_t (*exec_cmd)(struct target_iostate *ios));
 
 bool target_sense_desc_format(struct se_device *dev);
 sector_t target_to_linux_sector(struct se_device *dev, sector_t lb);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index bd4346b..9bd7559 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -508,7 +508,7 @@ struct se_cmd {
 	struct list_head	se_cmd_list;
 	struct completion	cmd_wait_comp;
 	const struct target_core_fabric_ops *se_tfo;
-	sense_reason_t		(*execute_cmd)(struct se_cmd *);
+	sense_reason_t		(*execute_cmd)(struct target_iostate *);
 	sense_reason_t (*transport_complete_callback)(struct se_cmd *, bool, int *);
 	void			*protocol_data;
 
-- 
1.9.1
