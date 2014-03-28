From: Quinn Tran <quinn.tran@qlogic.com>
Subject: [PATCH 1/4] target/core: T10-Dif: check HW support capabilities
Date: Fri, 28 Mar 2014 19:05:24 -0400
Message-ID: <1396047927-14189-2-git-send-email-quinn.tran@qlogic.com>
References: <1396047927-14189-1-git-send-email-quinn.tran@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1396047927-14189-1-git-send-email-quinn.tran@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com
List-Id: linux-scsi@vger.kernel.org

Check lower layer/HW support of T10-dif capability.
When the LUN is linked between the underlining fabric
and back end device, the Protection Type(1,2,3) is
check against each other to make sure both side are
capable of supporting the same protection setting.

ln -s /sys/kernel/config/target/core/rd_mcp_0/q_tcm_mcp.0
/sys/kernel/config/target/qla2xxx/$L_WWPN/tpgt_1/lun/lun_0/tcm_123

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/target/target_core_fabric_configfs.c | 20 ++++++++++++++++++++
 drivers/target/target_core_tpg.c             |  9 +++++++++
 include/target/target_core_base.h            | 14 ++++++++++++++
 include/target/target_core_fabric.h          |  1 +
 4 files changed, 44 insertions(+)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 7de9f04..3ce07ec 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -777,6 +777,26 @@ static int target_fabric_port_link(
 				struct se_portal_group, tpg_group);
 	tf = se_tpg->se_tpg_wwn->wwn_tf;
 
+
+	if (dev->dev_attrib.pi_prot_type) {
+		uint32_t cap[] = { 0,
+				   TARGET_DIF_TYPE1_PROTECTION,
+				   TARGET_DIF_TYPE2_PROTECTION,
+				   TARGET_DIF_TYPE3_PROTECTION};
+		uint32_t pt_bits = cap[dev->dev_attrib.pi_prot_type];
+		pt_bits &= se_tpg->fabric_sup_prot_type;
+
+		/* cross check with fabric to see if t10dif is supported */
+		if (!pt_bits) {
+			//dev->dev_attrib.pi_prot_type = 0;
+			pr_err("dev[%p]: DIF protection mismatch with fabric "
+				"(%s). Transport capability bits[0x%x]\n",
+				dev, se_tpg->se_tpg_wwn->wwn_group.cg_item.ci_name,
+				se_tpg->fabric_sup_prot_type);
+			return -EFAULT;
+		}
+	}
+
 	if (lun->lun_se_dev !=  NULL) {
 		pr_err("Port Symlink already exists\n");
 		return -EEXIST;
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index c036595..9279971 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -632,6 +632,15 @@ int core_tpg_set_initiator_node_tag(
 }
 EXPORT_SYMBOL(core_tpg_set_initiator_node_tag);
 
+void core_tpg_set_fabric_t10dif(
+	struct se_portal_group *tpg,
+	uint32_t fabric_t10dif_force_on)
+{
+	tpg->fabric_t10dif_force_on = fabric_t10dif_force_on;
+}
+EXPORT_SYMBOL(core_tpg_set_fabric_t10dif);
+
+
 static void core_tpg_lun_ref_release(struct percpu_ref *ref)
 {
 	struct se_lun *lun = container_of(ref, struct se_lun, lun_ref);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index ec3e3a3..fc2c0ef 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -241,6 +241,17 @@ enum tcm_tmrsp_table {
 	TMR_FUNCTION_REJECTED		= 5,
 };
 
+enum target_guard_type_cap {
+	TARGET_GUARD_CRC = 1 << 0,
+	TARGET_GUARD_IP  = 1 << 1,
+};
+
+enum target_prot_type_cap {
+	TARGET_DIF_TYPE1_PROTECTION = 1 << 0, /* T10 DIF Type 1 */
+	TARGET_DIF_TYPE2_PROTECTION = 1 << 1, /* T10 DIF Type 2 */
+	TARGET_DIF_TYPE3_PROTECTION = 1 << 2, /* T10 DIF Type 3 */
+};
+
 /*
  * Used for target SCSI statistics
  */
@@ -862,6 +873,9 @@ struct se_portal_group {
 	enum transport_tpg_type_table se_tpg_type;
 	/* Number of ACLed Initiator Nodes for this TPG */
 	u32			num_node_acls;
+	u32			fabric_t10dif_force_on;
+	u32			fabric_sup_guard_type;
+	u32			fabric_sup_prot_type;
 	/* Used for PR SPEC_I_PT=1 and REGISTER_AND_MOVE */
 	atomic_t		tpg_pr_ref_count;
 	/* Spinlock for adding/removing ACLed Nodes */
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 1d10436..4c3dab5 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -152,6 +152,7 @@ int	core_tpg_set_initiator_node_queue_depth(struct se_portal_group *,
 		unsigned char *, u32, int);
 int	core_tpg_set_initiator_node_tag(struct se_portal_group *,
 		struct se_node_acl *, const char *);
+void	core_tpg_set_fabric_t10dif(struct se_portal_group *, uint32_t);
 int	core_tpg_register(struct target_core_fabric_ops *, struct se_wwn *,
 		struct se_portal_group *, void *, int);
 int	core_tpg_deregister(struct se_portal_group *);
-- 
1.8.4.GIT
