From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 17/18] target_core_alua: Referrals infrastructure
Date: Tue, 19 Nov 2013 09:08:02 +0100
Message-ID: <1384848483-3771-18-git-send-email-hare@suse.de>
References: <1384848483-3771-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1384848483-3771-1-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Add infrastructure for referrals.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_alua.c     | 155 ++++++++++++++++++++++++++++++++++
 drivers/target/target_core_alua.h     |   4 +-
 drivers/target/target_core_configfs.c |   9 +-
 drivers/target/target_core_device.c   |   2 +
 drivers/target/target_core_sbc.c      |   5 +-
 drivers/target/target_core_spc.c      |  20 +++++
 include/scsi/scsi.h                   |   1 +
 include/target/target_core_base.h     |  18 ++++
 8 files changed, 211 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 19179cf..5b11908 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -56,6 +56,75 @@ static LIST_HEAD(lu_gps_list);
 struct t10_alua_lu_gp *default_lu_gp;
 
 /*
+ * REPORT REFERRALS
+ *
+ * See sbc3r35 section 5.23
+ */
+sense_reason_t
+target_emulate_report_referrals(struct se_cmd *cmd)
+{
+	struct se_device *dev = cmd->se_dev;
+	struct t10_alua_lba_map *map;
+	struct t10_alua_lba_map_member *map_mem;
+	unsigned char *buf;
+	u32 rd_len = 0, off;
+
+	if (cmd->data_length < 4) {
+		pr_warn("REPORT REFERRALS allocation length %u too"
+			" small\n", cmd->data_length);
+		return TCM_INVALID_CDB_FIELD;
+	}
+
+	buf = transport_kmap_data_sg(cmd);
+	if (!buf)
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+
+	off = 4;
+	spin_lock(&dev->t10_alua.lba_map_lock);
+	if (list_empty(&dev->t10_alua.lba_map_list)) {
+		spin_unlock(&dev->t10_alua.lba_map_lock);
+		transport_kunmap_data_sg(cmd);
+
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	list_for_each_entry(map, &dev->t10_alua.lba_map_list,
+			    lba_map_list) {
+		int desc_num = off + 3;
+		int pg_num;
+
+		off += 4;
+		put_unaligned_be64(map->lba_map_first_lba, &buf[off]);
+		off += 8;
+		put_unaligned_be64(map->lba_map_last_lba, &buf[off]);
+		off += 8;
+		rd_len += 20;
+		pg_num = 0;
+		list_for_each_entry(map_mem, &map->lba_map_mem_list,
+				    lba_map_mem_list) {
+			buf[off++] = map_mem->lba_map_mem_alua_state & 0x0f;
+			off++;
+			buf[off++] = (map_mem->lba_map_mem_alua_pg_id >> 8) & 0xff;
+			buf[off++] = (map_mem->lba_map_mem_alua_pg_id & 0xff);
+			rd_len += 4;
+			pg_num++;
+		}
+		buf[desc_num] = pg_num;
+	}
+	spin_unlock(&dev->t10_alua.lba_map_lock);
+
+	/*
+	 * Set the RETURN DATA LENGTH set in the header of the DataIN Payload
+	 */
+	put_unaligned_be16(rd_len, &buf[2]);
+
+	transport_kunmap_data_sg(cmd);
+
+	target_complete_cmd(cmd, GOOD);
+	return 0;
+}
+
+/*
  * REPORT_TARGET_PORT_GROUPS
  *
  * See spc4r17 section 6.27
@@ -389,6 +458,80 @@ static inline int core_alua_state_nonoptimized(
 	return 0;
 }
 
+static inline int core_alua_state_lba_dependent(
+	struct se_cmd *cmd,
+	struct t10_alua_tg_pt_gp *tg_pt_gp,
+	u8 *alua_ascq)
+{
+	struct se_device *dev = cmd->se_dev;
+	u32 segment_size, segment_mult, sectors;
+	u64 lba;
+
+	/* Only need to check for cdb actually containing LBAs */
+	if (!cmd->se_cmd_flags & SCF_SCSI_DATA_CDB)
+		return 0;
+
+	spin_lock(&dev->t10_alua.lba_map_lock);
+	segment_size = dev->t10_alua.lba_map_segment_size;
+	segment_mult = dev->t10_alua.lba_map_segment_multiplier;
+	sectors = cmd->data_length / dev->dev_attrib.block_size;
+
+	lba = cmd->t_task_lba;
+	while (lba < cmd->t_task_lba + sectors) {
+		struct t10_alua_lba_map *cur_map = NULL, *map;
+		struct t10_alua_lba_map_member *map_mem;
+
+		list_for_each_entry(map, &dev->t10_alua.lba_map_list,
+				    lba_map_list) {
+			u64 start_lba, last_lba;
+			u64 first_lba = map->lba_map_first_lba;
+
+			if (segment_mult) {
+				start_lba = lba % (segment_size * segment_mult);
+				last_lba = first_lba + segment_size - 1;
+				if (start_lba >= first_lba &&
+				    start_lba <= last_lba) {
+					lba += segment_size;
+					cur_map = map;
+					break;
+				}
+			} else {
+				last_lba = map->lba_map_last_lba;
+				if (lba >= first_lba && lba <= last_lba) {
+					lba = last_lba + 1;
+					cur_map = map;
+					break;
+				}
+			}
+		}
+		if (!cur_map) {
+			spin_unlock(&dev->t10_alua.lba_map_lock);
+			*alua_ascq = ASCQ_04H_ALUA_TG_PT_UNAVAILABLE;
+			return 1;
+		}
+		list_for_each_entry(map_mem, &cur_map->lba_map_mem_list,
+				    lba_map_mem_list) {
+			if (map_mem->lba_map_mem_alua_pg_id !=
+			    tg_pt_gp->tg_pt_gp_id)
+				continue;
+			switch(map_mem->lba_map_mem_alua_state) {
+			case ALUA_ACCESS_STATE_STANDBY:
+				spin_unlock(&dev->t10_alua.lba_map_lock);
+				*alua_ascq = ASCQ_04H_ALUA_TG_PT_STANDBY;
+				return 1;
+			case ALUA_ACCESS_STATE_UNAVAILABLE:
+				spin_unlock(&dev->t10_alua.lba_map_lock);
+				*alua_ascq = ASCQ_04H_ALUA_TG_PT_UNAVAILABLE;
+				return 1;
+			default:
+				break;
+			}
+		}
+	}
+	spin_unlock(&dev->t10_alua.lba_map_lock);
+	return 0;
+}
+
 static inline int core_alua_state_standby(
 	struct se_cmd *cmd,
 	unsigned char *cdb,
@@ -586,6 +729,9 @@ target_alua_state_check(struct se_cmd *cmd)
 	case ALUA_ACCESS_STATE_TRANSITION:
 		ret = core_alua_state_transition(cmd, cdb, &alua_ascq);
 		break;
+	case ALUA_ACCESS_STATE_LBA_DEPENDENT:
+		ret = core_alua_state_lba_dependent(cmd, tg_pt_gp, &alua_ascq);
+		break;
 	/*
 	 * OFFLINE is a secondary ALUA target port group access state, that is
 	 * handled above with struct se_port->sep_tg_pt_secondary_offline=1
@@ -623,6 +769,8 @@ int core_alua_parse_state(const char *state)
 		return ALUA_ACCESS_STATE_ACTIVE_OPTIMIZED;
 	if (!strncasecmp(state, "Active/NonOptimized", 19))
 		return ALUA_ACCESS_STATE_ACTIVE_NON_OPTIMIZED;
+	if (!strncasecmp(state, "LBA Dependent", 19))
+		return ALUA_ACCESS_STATE_LBA_DEPENDENT;
 	if (!strncasecmp(state, "Standby", 7))
 		return ALUA_ACCESS_STATE_STANDBY;
 	if (!strncasecmp(state, "Unavailable", 11))
@@ -640,6 +788,8 @@ char *core_alua_dump_state(int state)
 		return "Active/Optimized";
 	case ALUA_ACCESS_STATE_ACTIVE_NON_OPTIMIZED:
 		return "Active/NonOptimized";
+	case ALUA_ACCESS_STATE_LBA_DEPENDENT:
+		return "LBA Dependent";
 	case ALUA_ACCESS_STATE_STANDBY:
 		return "Standby";
 	case ALUA_ACCESS_STATE_UNAVAILABLE:
@@ -686,6 +836,11 @@ core_alua_check_transition(int state, int valid, int *primary)
 			goto not_supported;
 		*primary = 1;
 		break;
+	case ALUA_ACCESS_STATE_LBA_DEPENDENT:
+		if (!(valid & ALUA_LBD_SUP))
+			goto not_supported;
+		*primary = 1;
+		break;
 	case ALUA_ACCESS_STATE_OFFLINE:
 		/*
 		 * OFFLINE state is defined as a secondary target port
diff --git a/drivers/target/target_core_alua.h b/drivers/target/target_core_alua.h
index f2c1ef3..e4ba452 100644
--- a/drivers/target/target_core_alua.h
+++ b/drivers/target/target_core_alua.h
@@ -13,12 +13,13 @@
 /*
  * ASYMMETRIC ACCESS STATE field
  *
- * from spc4r17 section 6.27 Table 245
+ * from spc4r36j section 6.37 Table 307
  */
 #define ALUA_ACCESS_STATE_ACTIVE_OPTIMIZED	0x0
 #define ALUA_ACCESS_STATE_ACTIVE_NON_OPTIMIZED	0x1
 #define ALUA_ACCESS_STATE_STANDBY		0x2
 #define ALUA_ACCESS_STATE_UNAVAILABLE		0x3
+#define ALUA_ACCESS_STATE_LBA_DEPENDENT		0x4
 #define ALUA_ACCESS_STATE_OFFLINE		0xe
 #define ALUA_ACCESS_STATE_TRANSITION		0xf
 
@@ -88,6 +89,7 @@ extern struct kmem_cache *t10_alua_tg_pt_gp_mem_cache;
 
 extern sense_reason_t target_emulate_report_target_port_groups(struct se_cmd *);
 extern sense_reason_t target_emulate_set_target_port_groups(struct se_cmd *);
+extern sense_reason_t target_emulate_report_referrals(struct se_cmd *);
 extern int core_alua_check_nonop_delay(struct se_cmd *);
 extern int core_alua_do_port_transition(struct t10_alua_tg_pt_gp *,
 				struct se_device *, struct se_port *,
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 9ba6828..50f058c 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2059,6 +2059,13 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_state(
 		}
 		new_state = (int)tmp;
 	}
+	if (tg_pt_gp->tg_pt_gp_alua_mgmt_type & ALUA_MGMT_EXPLICIT &&
+	    new_state == ALUA_ACCESS_STATE_LBA_DEPENDENT) {
+		/* LBA DEPENDENT is only allowed with implicit ALUA */
+		pr_err("Unable to process implicit configfs ALUA transition"
+		       " while explicit ALUA management is enabled\n");
+		return -EINVAL;
+	}
 	ret = core_alua_do_port_transition(tg_pt_gp, dev,
 					NULL, NULL, new_state, 0);
 	return (!ret) ? count : -EINVAL;
@@ -2188,7 +2195,7 @@ SE_DEV_ALUA_SUPPORT_STATE_SHOW(support_lba_dependent,
 			       tg_pt_gp_alua_supported_states, ALUA_LBD_SUP);
 SE_DEV_ALUA_SUPPORT_STATE_STORE(support_lba_dependent,
 				tg_pt_gp_alua_supported_states, ALUA_LBD_SUP);
-SE_DEV_ALUA_TG_PT_ATTR(alua_support_lba_dependent, S_IRUGO | S_IWUSR);
+SE_DEV_ALUA_TG_PT_ATTR(alua_support_lba_dependent, S_IRUGO);
 
 SE_DEV_ALUA_SUPPORT_STATE_SHOW(support_unavailable,
 			       tg_pt_gp_alua_supported_states, ALUA_U_SUP);
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 207b340..3c08f99 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1439,6 +1439,8 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	spin_lock_init(&dev->t10_pr.aptpl_reg_lock);
 	INIT_LIST_HEAD(&dev->t10_alua.tg_pt_gps_list);
 	spin_lock_init(&dev->t10_alua.tg_pt_gps_lock);
+	INIT_LIST_HEAD(&dev->t10_alua.lba_map_list);
+	spin_lock_init(&dev->t10_alua.lba_map_lock);
 
 	dev->t10_wwn.t10_dev = dev;
 	dev->t10_alua.t10_dev = dev;
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 61a30f0..daaddc7 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -33,7 +33,7 @@
 
 #include "target_core_internal.h"
 #include "target_core_ua.h"
-
+#include "target_core_alua.h"
 
 static sense_reason_t
 sbc_emulate_readcapacity(struct se_cmd *cmd)
@@ -702,6 +702,9 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		case SAI_READ_CAPACITY_16:
 			cmd->execute_cmd = sbc_emulate_readcapacity_16;
 			break;
+		case SAI_REPORT_REFERRALS:
+			cmd->execute_cmd = target_emulate_report_referrals;
+			break;
 		default:
 			pr_err("Unsupported SA: 0x%02x\n",
 				cmd->t_task_cdb[1] & 0x1f);
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 44e8d69..5d86813 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -476,6 +476,11 @@ spc_emulate_evpd_86(struct se_cmd *cmd, unsigned char *buf)
 	/* If WriteCache emulation is enabled, set V_SUP */
 	if (spc_check_dev_wce(dev))
 		buf[6] = 0x01;
+	/* If an LBA map is present set R_SUP */
+	spin_lock(&cmd->se_dev->t10_alua.lba_map_lock);
+	if (!list_empty(&dev->t10_alua.lba_map_list))
+		buf[8] = 0x10;
+	spin_unlock(&cmd->se_dev->t10_alua.lba_map_lock);
 	return 0;
 }
 
@@ -634,6 +639,20 @@ spc_emulate_evpd_b2(struct se_cmd *cmd, unsigned char *buf)
 	return 0;
 }
 
+/* Referrals VPD page */
+static sense_reason_t
+spc_emulate_evpd_b3(struct se_cmd *cmd, unsigned char *buf)
+{
+	struct se_device *dev = cmd->se_dev;
+
+	buf[0] = dev->transport->get_device_type(dev);
+	buf[3] = 0x0c;
+	put_unaligned_be32(dev->t10_alua.lba_map_segment_size, &buf[8]);
+	put_unaligned_be32(dev->t10_alua.lba_map_segment_size, &buf[12]);
+
+	return 0;
+}
+
 static sense_reason_t
 spc_emulate_evpd_00(struct se_cmd *cmd, unsigned char *buf);
 
@@ -648,6 +667,7 @@ static struct {
 	{ .page = 0xb0, .emulate = spc_emulate_evpd_b0 },
 	{ .page = 0xb1, .emulate = spc_emulate_evpd_b1 },
 	{ .page = 0xb2, .emulate = spc_emulate_evpd_b2 },
+	{ .page = 0xb3, .emulate = spc_emulate_evpd_b3 },
 };
 
 /* supported vital product data pages */
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 66d42ed..0a4edfe 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -155,6 +155,7 @@ enum scsi_timeouts {
 /* values for service action in */
 #define	SAI_READ_CAPACITY_16  0x10
 #define SAI_GET_LBA_STATUS    0x12
+#define SAI_REPORT_REFERRALS  0x13
 /* values for VARIABLE_LENGTH_CMD service action codes
  * see spc4r17 Section D.3.5, table D.7 and D.8 */
 #define VLC_SA_RECEIVE_CREDENTIAL 0x1800
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index b95c1f1..ab66b87 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -247,10 +247,28 @@ typedef enum {
 
 struct se_cmd;
 
+struct t10_alua_lba_map_member {
+	struct list_head lba_map_mem_list;
+	int lba_map_mem_alua_state;
+	int lba_map_mem_alua_pg_id;
+};
+
+struct t10_alua_lba_map {
+	u64 lba_map_first_lba;
+	u64 lba_map_last_lba;
+	struct list_head lba_map_list;
+	struct list_head lba_map_mem_list;
+};
+
 struct t10_alua {
 	/* ALUA Target Port Group ID */
 	u16	alua_tg_pt_gps_counter;
 	u32	alua_tg_pt_gps_count;
+	/* Referrals support */
+	spinlock_t lba_map_lock;
+	u32     lba_map_segment_size;
+	u32     lba_map_segment_multiplier;
+	struct list_head lba_map_list;
 	spinlock_t tg_pt_gps_lock;
 	struct se_device *t10_dev;
 	/* Used for default ALUA Target Port Group */
-- 
1.7.12.4
