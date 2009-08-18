From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/4] [Target_Core_Mod/ALUA]: Add support for
	explict/implict ALUA primary/secondary state transition
Date: Tue, 18 Aug 2009 16:15:43 -0700
Message-ID: <1250637343.27590.66.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:38637 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750931AbZHRXPu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Aug 2009 19:15:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Alasdair G Kergon <agk@redhat.com>, Joel Becker <joel.becker@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Florian Haas <florian.haas@linbit.com>, Philipp Reisner <philipp.reisner@linbit.com>

Greetings,

This patch adds complete running support for Asymmetric Logical Unit Assignement
(ALUA) for explict operation (via client side SET_TARGET_PORT_GROUPS in-band method) and via
implict operation (via local configfs method).  It supports all primary and secondary ALUA access
states via CDB exclusion tables defined by SPC4, and updates existing target_core_alua.c code for
the proper ALUA Logical Unit Group <-> Target Port Group abstraction for target_core_mod storage
objects.

By default, each fabric module port/LUN that is created from a target_core_mod storage
object will become a member of 'default_tg_pt_gp' in /sys/kernel/config/target/core/$HBA/$DEV/alua/.
The fabric port/LUN can also then be explictly moved between ALUA tg_pt_gps in real-time with
active fabric mod exports.

By default, each target_core_mod storage object in /sys/kernel/config/target/core/$HBA/$DEV will
become of member of 'default_lu_gp' in /sys/kernel/config/target/core/alua/lu_gps/.  This defalt
Logical Unit Group is READ-ONLY, and the changing of ALUA primary port access state in ALUA target
port groups on one TCM storage object will NOT effect other members of the logical unit group.
Using a non default logical unit group (eg: non ID=0) is for full READ-WRITE operation is supported,
where matching target port group IDs of logical unit group members will change primary port access
state between all storage objects in said logical unit group.

This patch also adds a configfs attribute for the INQUIRY TPGS bit which sets the allowed ALUA type
(Implict/Explict, Implict, Explict or None) on a per target port group basis.  It also adds PREF=1
support for setting the preferred target port group(s) via configfs.

This patch also adds a configfs settable millisecond delay for the generic Active/NonOptimized ALUA
path which will optionally call msleep_interruptible() to allow real time throttling of traffic
via both explict and implict ALUA methods.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_alua.c      | 1022 ++++++++++++++++++++++++++++++--
 drivers/target/target_core_device.c    |   18 +-
 drivers/target/target_core_tpg.c       |    1 +
 drivers/target/target_core_transport.c |  109 +++-
 include/target/target_core_alua.h      |   47 ++-
 include/target/target_core_base.h      |   44 ++-
 include/target/target_core_transport.h |    2 +
 7 files changed, 1168 insertions(+), 75 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 8ebe225..0cfab73 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -29,6 +29,7 @@
 #include <linux/version.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
+#include <linux/configfs.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 
@@ -38,6 +39,7 @@
 #include <target/target_core_transport.h>
 #include <target/target_core_alua.h>
 #include <target/target_core_transport_plugin.h>
+#include <target/target_core_ua.h>
 #include <target/target_core_fabric_ops.h>
 #include <target/target_core_configfs.h>
 
@@ -46,23 +48,26 @@
 /*
  * REPORT_TARGET_PORT_GROUPS
  *
- * See spc4r17 6.2.7
+ * See spc4r17 section 6.27
  */
 int core_scsi3_emulate_report_target_port_groups(se_cmd_t *cmd)
 {
+	se_subsystem_dev_t *su_dev = SE_DEV(cmd)->se_sub_dev;
 	se_port_t *port;
 	t10_alua_tg_pt_gp_t *tg_pt_gp;
 	t10_alua_tg_pt_gp_member_t *tg_pt_gp_mem;
 	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
 	u32 rd_len = 0, off = 4;
 
-	spin_lock(&se_global->tg_pt_gps_lock);
-	list_for_each_entry(tg_pt_gp, &se_global->g_tg_pt_gps_list,
+	spin_lock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
+	list_for_each_entry(tg_pt_gp, &T10_ALUA(su_dev)->tg_pt_gps_list,
 			tg_pt_gp_list) {
 		/*
-		 * PREF: Preferred target port bit
+		 * PREF: Preferred target port bit, determine if this
+		 * bit should be set for port group.
 		 */
-/*		buf[off] = 0x80; */
+		if (tg_pt_gp->tg_pt_gp_pref)
+			buf[off] = 0x80;
 		/*
 		 * Set the ASYMMETRIC ACCESS State
 		 */
@@ -70,10 +75,10 @@ int core_scsi3_emulate_report_target_port_groups(se_cmd_t *cmd)
 		/*
 		 * Set supported ASYMMETRIC ACCESS State bits
 		 */
-/*		buf[off] = 0x80; // T_SUP */
-/*		buf[off] |= 0x40; // O_SUP */
-/*		buf[off] |= 0x8; // U_SUP */
-/*		buf[off] |= 0x4; // S_SUP */
+		buf[off] = 0x80; // T_SUP */
+		buf[off] |= 0x40; /* O_SUP */
+		buf[off] |= 0x8; /* U_SUP */
+		buf[off] |= 0x4; /* S_SUP */
 		buf[off] |= 0x2; /* AN_SUP */
 		buf[off++] |= 0x1; /* AO_SUP */
 		/*
@@ -86,7 +91,7 @@ int core_scsi3_emulate_report_target_port_groups(se_cmd_t *cmd)
 		/*
 		 * STATUS CODE
 		 */
-		buf[off++] = ALUA_STATUS_ALTERED_BY_IMPLICT_ALUA;
+		buf[off++] = (tg_pt_gp->tg_pt_gp_alua_access_status & 0xff);
 		/*
 		 * Vendor Specific field
 		 */
@@ -116,7 +121,7 @@ int core_scsi3_emulate_report_target_port_groups(se_cmd_t *cmd)
 		}
 		spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
 	}
-	spin_unlock(&se_global->tg_pt_gps_lock);
+	spin_unlock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
 	/*
 	 * Set the RETURN DATA LENGTH set in the header of the DataIN Payload
 	 */
@@ -128,6 +133,709 @@ int core_scsi3_emulate_report_target_port_groups(se_cmd_t *cmd)
 	return 0;
 }
 
+/*
+ * SET_TARGET_PORT_GROUPS for explict ALUA operation.
+ *
+ * See spc4r17 section 6.35
+ */
+int core_scsi3_emulate_set_target_port_groups(se_cmd_t *cmd)
+{
+	se_device_t *dev = SE_DEV(cmd);
+	se_subsystem_dev_t *su_dev = SE_DEV(cmd)->se_sub_dev;
+	se_port_t *port, *l_port = SE_LUN(cmd)->lun_sep;
+	se_node_acl_t *nacl = SE_SESS(cmd)->se_node_acl;
+	t10_alua_tg_pt_gp_t *tg_pt_gp = NULL, *l_tg_pt_gp;
+	t10_alua_tg_pt_gp_member_t *tg_pt_gp_mem, *l_tg_pt_gp_mem;
+	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
+	unsigned char *ptr = &buf[4]; /* Skip over RESERVED area in header */
+	u32 len = 4; /* Skip over RESERVED area in header */
+	int alua_access_state, primary = 0, ret;
+	u16 tg_pt_id, rtpi;
+
+	if (!(l_port))
+		return -1;
+	/*
+	 * Determine if explict ALUA via SET_TARGET_PORT_GROUPS is allowed
+	 * for the local tg_pt_gp.
+	 */
+	l_tg_pt_gp_mem = l_port->sep_alua_tg_pt_gp_mem;
+	if (!(l_tg_pt_gp_mem)) {
+		printk(KERN_ERR "Unable to access *l_tg_pt_gp_mem\n");
+		return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
+	}
+	spin_lock(&l_tg_pt_gp_mem->tg_pt_gp_mem_lock);
+	l_tg_pt_gp = l_tg_pt_gp_mem->tg_pt_gp;
+	if (!(l_tg_pt_gp)) {
+		spin_unlock(&l_tg_pt_gp_mem->tg_pt_gp_mem_lock);
+		printk(KERN_ERR "Unable to access *l_l_tg_pt_gp\n");
+		return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
+	}
+	ret = (l_tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_EXPLICT_ALUA);
+	spin_unlock(&l_tg_pt_gp_mem->tg_pt_gp_mem_lock);
+
+	if (!(ret)) {
+		printk(KERN_INFO "Unable to process SET_TARGET_PORT_GROUPS"
+				" while TPGS_EXPLICT_ALUA is disabled\n");
+		return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
+	}
+
+	while (len < cmd->data_length) {
+		alua_access_state = (ptr[0] & 0x0f);
+		/*
+		 * Check the received ALUA access state, and determine if
+		 * the state is a primary or secondary target port asymmetric
+		 * access state.
+		 */
+		ret = core_alua_check_transition(alua_access_state, &primary);
+		if (ret != 0) {
+			/*
+			 * If the SET TARGET PORT GROUPS attempts to establish
+			 * an invalid combination of target port asymmetric
+			 * access states or attempts to establish an
+			 * unsupported target port asymmetric access state,
+			 * then the command shall be terminated with CHECK
+			 * CONDITION status, with the sense key set to ILLEGAL
+			 * REQUEST, and the additional sense code set to INVALID
+			 * FIELD IN PARAMETER LIST.
+			 */
+			return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+		}
+		ret = -1;
+		/*
+		 * If the ASYMMETRIC ACCESS STATE field (see table 267)
+		 * specifies a primary target port asymmetric access state,
+		 * then the TARGET PORT GROUP OR TARGET PORT field specifies
+		 * a primary target port group for which the primary target
+		 * port asymmetric access state shall be changed. If the
+		 * ASYMMETRIC ACCESS STATE field specifies a secondary target
+		 * port asymmetric access state, then the TARGET PORT GROUP OR
+		 * TARGET PORT field specifies the relative target port
+		 * identifier (see 3.1.120) of the target port for which the
+		 * secondary target port asymmetric access state shall be
+		 * changed.
+		 */
+		if (primary) {
+			tg_pt_id = ((ptr[2] << 8) & 0xff);
+			tg_pt_id |= (ptr[3] & 0xff);
+			/*
+			 * Locate the matching target port group ID from
+			 * the global tg_pt_gp list
+			 */
+			spin_lock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
+			list_for_each_entry(tg_pt_gp,
+					&T10_ALUA(su_dev)->tg_pt_gps_list,
+					tg_pt_gp_list) {
+				if (!(tg_pt_gp->tg_pt_gp_valid_id))
+					continue;
+
+				if (tg_pt_id != tg_pt_gp->tg_pt_gp_id)
+					continue;
+
+				atomic_inc(&tg_pt_gp->tg_pt_gp_ref_cnt);
+				smp_mb__after_atomic_inc();
+				spin_unlock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
+
+				ret = core_alua_do_port_transition(tg_pt_gp,
+						dev, l_port, nacl,
+						alua_access_state, 1);
+
+				spin_lock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
+				atomic_dec(&tg_pt_gp->tg_pt_gp_ref_cnt);
+				smp_mb__after_atomic_dec();	
+				break;
+			}
+			spin_unlock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
+			/*
+			 * If not matching target port group ID can be located
+			 * throw an exception with ASCQ: INVALID_PARAMETER_LIST
+			 */
+			if (ret != 0)
+				return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+		} else {
+			rtpi = ((ptr[2] << 8) & 0xff);
+			rtpi |= (ptr[3] & 0xff);
+			/*
+			 * Locate the matching relative target port identifer
+			 * for the se_device_t storage object.
+			 */
+			spin_lock(&dev->se_port_lock);
+			list_for_each_entry(port, &dev->dev_sep_list,
+							sep_list) {
+				if (port->sep_rtpi != rtpi)
+					continue;
+
+				tg_pt_gp_mem = port->sep_alua_tg_pt_gp_mem;
+				spin_unlock(&dev->se_port_lock);
+
+				ret = core_alua_set_tg_pt_secondary_state(
+						tg_pt_gp_mem, port, 1, 1);
+
+				spin_lock(&dev->se_port_lock);
+				break;
+			}
+			spin_unlock(&dev->se_port_lock);
+			/*
+			 * If not matching relative target port identifier can
+			 * be located, throw an exception with ASCQ:
+			 * INVALID_PARAMETER_LIST
+			 */
+			if (ret != 0)
+				return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+		}
+
+		ptr += 4;
+		len += 4;
+	}
+
+	return 0;
+}
+
+static inline int core_alua_state_optimized(
+	struct se_cmd_s *cmd,
+	unsigned char *cdb,
+	u8 *alua_ascq)
+{
+	/*
+	 * For the Optimized ALUA access state case, we want to process the
+	 * incoming fabric cmd ASAP..
+	 */
+	return 0;
+}
+
+static inline int core_alua_state_nonoptimized(
+	struct se_cmd_s *cmd,
+	unsigned char *cdb,
+	int nonop_delay_msecs,
+	u8 *alua_ascq)
+{
+	/*
+	 * Set SCF_ALUA_NON_OPTIMIZED here, this value will be checked
+	 * later to determine if processing of this cmd needs to be
+	 * temporarily delayed for the Active/NonOptimized primary access state.
+	 */
+	cmd->se_cmd_flags = SCF_ALUA_NON_OPTIMIZED;
+	cmd->alua_nonop_delay = nonop_delay_msecs;
+	return 0;
+}
+
+static inline int core_alua_state_standby(
+	struct se_cmd_s *cmd,
+	unsigned char *cdb,
+	u8 *alua_ascq)
+{
+	/*
+	 * Allowed CDBs for ALUA_ACCESS_STATE_STANDBY as defined by
+	 * spc4r17 section 5.9.2.4.4
+	 */
+	switch (cdb[0]) {
+	case INQUIRY:
+	case LOG_SELECT:
+	case LOG_SENSE:
+	case MODE_SELECT:
+	case MODE_SENSE:
+	case REPORT_LUNS:
+	case RECEIVE_DIAGNOSTIC:
+	case SEND_DIAGNOSTIC:
+	case 0xa3:
+		switch (cdb[1]) {
+		case MI_REPORT_TARGET_PGS:
+			return 0;
+		default:
+			*alua_ascq = ASCQ_04H_ALUA_TG_PT_STANDBY;
+			return 1;
+		}
+	case 0xa4:
+		switch (cdb[1]) {
+		case MO_SET_TARGET_PGS:
+			return 0;
+		default:
+			*alua_ascq = ASCQ_04H_ALUA_TG_PT_STANDBY;
+			return 1;
+		}
+	case REQUEST_SENSE:
+	case PERSISTENT_RESERVE_IN:
+	case PERSISTENT_RESERVE_OUT:
+	case READ_BUFFER:
+	case WRITE_BUFFER:
+		return 0;
+	default:
+		*alua_ascq = ASCQ_04H_ALUA_TG_PT_STANDBY;
+		return 1;
+	}
+
+	return 0;
+}
+
+static inline int core_alua_state_unavailable(
+	struct se_cmd_s *cmd,
+	unsigned char *cdb,
+	u8 *alua_ascq)
+{
+	/*
+	 * Allowed CDBs for ALUA_ACCESS_STATE_UNAVAILABLE as defined by
+	 * spc4r17 section 5.9.2.4.5
+	 */
+	switch (cdb[0]) {
+	case INQUIRY:
+	case REPORT_LUNS:
+	case 0xa3:
+		switch (cdb[1]) {
+		case MI_REPORT_TARGET_PGS:
+			return 0;
+		default:
+			*alua_ascq = ASCQ_04H_ALUA_TG_PT_UNAVAILABLE;
+			return 1;
+		}
+	case 0xa4:
+		switch (cdb[1]) {
+		case MO_SET_TARGET_PGS:
+			return 0;
+		default:
+			*alua_ascq = ASCQ_04H_ALUA_TG_PT_UNAVAILABLE;
+			return 1;
+		}
+	case REQUEST_SENSE:
+	case READ_BUFFER:
+	case WRITE_BUFFER:
+		return 0;
+	default:
+		*alua_ascq = ASCQ_04H_ALUA_TG_PT_UNAVAILABLE;
+		return 1;
+	}
+	
+	return 0;
+}
+
+static inline int core_alua_state_transition(
+	struct se_cmd_s *cmd,
+	unsigned char *cdb,
+	u8 *alua_ascq)
+{
+	/*
+	 * Allowed CDBs for ALUA_ACCESS_STATE_TRANSITIO as defined by
+	 * spc4r17 section 5.9.2.5
+	 */
+	switch (cdb[0]) {
+	case INQUIRY:
+	case REPORT_LUNS:
+	case 0xa3:
+		switch (cdb[1]) {
+		case MI_REPORT_TARGET_PGS:
+			return 0;
+		default:
+			*alua_ascq = ASCQ_04H_ALUA_STATE_TRANSITION;
+			return 1;
+		}
+	case REQUEST_SENSE:
+	case READ_BUFFER:
+	case WRITE_BUFFER:
+		return 0;
+	default:
+		*alua_ascq = ASCQ_04H_ALUA_STATE_TRANSITION;
+		return 1;
+	}
+
+	return 0;
+}
+
+/*
+ * Used for alua_type SPC_ALUA_PASSTHROUGH and SPC2_ALUA_DISABLED
+ */
+int core_alua_state_check_nop(
+	struct se_cmd_s *cmd,
+	unsigned char *cdb,
+	u8 *alua_ascq)
+{
+	return 0;
+}
+
+/*
+ * Used for alua_type SPC3_ALUA_EMULATED
+ */
+int core_alua_state_check(
+	struct se_cmd_s *cmd,
+	unsigned char *cdb,
+	u8 *alua_ascq)
+{
+	se_lun_t *lun = SE_LUN(cmd);
+	se_port_t *port = lun->lun_sep;
+	t10_alua_tg_pt_gp_t *tg_pt_gp;
+	t10_alua_tg_pt_gp_member_t *tg_pt_gp_mem;
+	int out_alua_state, nonop_delay_msecs;
+
+	if (!(port))
+		return 0;
+	/*
+	 * First, check for a se_port_t specific secondary ALUA target port
+	 * access state: OFFLINE
+	 */
+	if (atomic_read(&port->sep_tg_pt_secondary_offline)) {		
+		*alua_ascq = ASCQ_04H_ALUA_OFFLINE;
+		printk(KERN_INFO "ALUA: Got secondary offline status for local"
+				" target port\n");
+		*alua_ascq = ASCQ_04H_ALUA_OFFLINE;
+		return 1;
+	}
+	 /*
+	 * Second, obtain the t10_alua_tg_pt_gp_member_t pointer to the
+	 * ALUA target port group, to obtain current ALUA access state.
+	 * Otherwise look for the underlying se_device_t association with
+	 * a ALUA logical unit group.
+	 */
+	tg_pt_gp_mem = port->sep_alua_tg_pt_gp_mem;
+	spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
+	tg_pt_gp = tg_pt_gp_mem->tg_pt_gp;
+	out_alua_state = tg_pt_gp->tg_pt_gp_alua_access_state;
+	nonop_delay_msecs = tg_pt_gp->tg_pt_gp_nonop_delay_msecs;
+	spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
+	/*
+	 * Process ALUA_ACCESS_STATE_ACTIVE_OPTMIZED in a seperate conditional
+	 * statement so the complier knows explictly to check this case first.
+	 */
+	if (out_alua_state == ALUA_ACCESS_STATE_ACTIVE_OPTMIZED)
+		return core_alua_state_optimized(cmd, cdb, alua_ascq);
+
+	switch (out_alua_state) {
+	case ALUA_ACCESS_STATE_ACTIVE_NON_OPTIMIZED:
+		return core_alua_state_nonoptimized(cmd, cdb,
+					nonop_delay_msecs, alua_ascq);
+	case ALUA_ACCESS_STATE_STANDBY:
+		return core_alua_state_standby(cmd, cdb, alua_ascq);
+	case ALUA_ACCESS_STATE_UNAVAILABLE:
+		return core_alua_state_unavailable(cmd, cdb, alua_ascq);
+	case ALUA_ACCESS_STATE_TRANSITION:
+		return core_alua_state_transition(cmd, cdb, alua_ascq);
+	/*
+	 * OFFLINE is a secondary ALUA target port group access state, that is
+	 * handled above with se_port_t->sep_tg_pt_secondary_offline=1
+	 */
+	case ALUA_ACCESS_STATE_OFFLINE:
+	default:
+		printk(KERN_ERR "Unknown ALUA access state: 0x%02x\n",
+				out_alua_state);
+		return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * Check implict and explict ALUA state change request.
+ */
+int core_alua_check_transition(int state, int *primary)
+{
+	switch (state) {
+	case ALUA_ACCESS_STATE_ACTIVE_OPTMIZED:
+	case ALUA_ACCESS_STATE_ACTIVE_NON_OPTIMIZED:
+	case ALUA_ACCESS_STATE_STANDBY:
+	case ALUA_ACCESS_STATE_UNAVAILABLE:
+		/*
+		 * OPTIMIZED, NON-OPTIMIZED, STANDBY and UNAVAILABLE are
+		 * defined as primary target port asymmetric access states.
+		 */
+		*primary = 1;
+		break;
+	case ALUA_ACCESS_STATE_OFFLINE:
+		/*
+		 * OFFLINE state is defined as a secondary target port
+		 * asymmetric access state.
+		 */
+		*primary = 0;
+		break;
+	default:
+		printk(KERN_ERR "Unknown ALUA access state: 0x%02x\n", state);
+		return -1;
+	}
+
+	return 0;
+}
+
+char *core_alua_dump_state(int state)
+{
+	switch (state) {
+	case ALUA_ACCESS_STATE_ACTIVE_OPTMIZED:
+		return "Active/Optimized";		
+	case ALUA_ACCESS_STATE_ACTIVE_NON_OPTIMIZED:
+		return "Active/NonOptimized";
+	case ALUA_ACCESS_STATE_STANDBY:
+		return "Standby";
+	case ALUA_ACCESS_STATE_UNAVAILABLE:
+		return "Unavailable";
+	case ALUA_ACCESS_STATE_OFFLINE:
+		return "Offline";
+	default:
+		return "Unknown";	
+	}
+
+	return NULL;
+}
+
+char *core_alua_dump_status(int status)
+{
+	switch (status) {
+	case ALUA_STATUS_NONE:
+		return "None";
+	case ALUA_STATUS_ALTERED_BY_EXPLICT_STPG:
+		return "Altered by Explict STPG";
+	case ALUA_STATUS_ALTERED_BY_IMPLICT_ALUA:
+		return "Altered by Implict ALUA";
+	default:
+		return "Unknown";
+	}
+
+	return NULL;
+}
+
+/*
+ * Used by fabric modules to determine when we need to delay processing
+ * for the Active/NonOptimized paths..
+ */
+int core_alua_check_nonop_delay(
+	se_cmd_t *cmd)
+{
+	if (!(cmd->se_cmd_flags & SCF_ALUA_NON_OPTIMIZED))
+		return 0;
+	if (in_interrupt())
+		return 0;
+	/*
+	 * The ALUA Active/NonOptimized access state delay can be disabled
+	 * in via configfs with a value of zero
+	 */
+	if (!(cmd->alua_nonop_delay))
+		return 0;
+	/*
+	 * se_cmd_t->alua_nonop_delay gets set by a target port group
+	 * defined interval in core_alua_state_nonoptimized()
+	 */
+	msleep_interruptible(cmd->alua_nonop_delay);
+	return 0;
+}
+EXPORT_SYMBOL(core_alua_check_nonop_delay);
+
+int core_alua_do_transition_tg_pt(
+	t10_alua_tg_pt_gp_t *tg_pt_gp,
+	se_port_t *l_port,
+	se_node_acl_t *nacl,
+	int new_state,
+	int explict)
+{
+	se_dev_entry_t *se_deve;
+	se_lun_acl_t *lacl;
+	se_port_t *port;
+	t10_alua_tg_pt_gp_member_t *mem;
+	int old_state = 0;
+
+	old_state = tg_pt_gp->tg_pt_gp_alua_access_state;
+	tg_pt_gp->tg_pt_gp_alua_access_state = new_state;
+	tg_pt_gp->tg_pt_gp_alua_access_status = (explict) ?
+				ALUA_STATUS_ALTERED_BY_EXPLICT_STPG :
+				ALUA_STATUS_ALTERED_BY_IMPLICT_ALUA;
+
+	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
+	list_for_each_entry(mem, &tg_pt_gp->tg_pt_gp_mem_list,
+				tg_pt_gp_mem_list) {
+		port = mem->tg_pt;
+		/*
+		 * After an implicit target port asymmetric access state
+		 * change, a device server shall establish a unit attention
+		 * condition for the initiator port associated with every I_T
+		 * nexus with the additional sense code set to ASYMMETRIC
+		 * ACCESS STATE CHAGED.
+		 * 
+		 * After an explicit target port asymmetric access state
+		 * change, a device server shall establish a unit attention
+		 * condition with the additional sense code set to ASYMMETRIC
+		 * ACCESS STATE CHANGED for the initiator port associated with
+		 * every I_T nexus other than the I_T nexus on which the SET
+		 * TARGET PORT GROUPS command
+		 */
+		atomic_inc(&mem->tg_pt_gp_mem_ref_cnt);
+		smp_mb__after_atomic_inc();
+		spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
+
+		spin_lock_bh(&port->sep_alua_lock);
+		list_for_each_entry(se_deve, &port->sep_alua_list,
+					alua_port_list) {
+			lacl = se_deve->se_lun_acl;
+			if (explict &&
+			   (nacl != NULL) && (nacl == lacl->se_lun_nacl) &&
+			   (l_port != NULL) && (l_port == port))
+				continue;
+
+			core_scsi3_ua_allocate(lacl->se_lun_nacl,
+				se_deve->mapped_lun, 0x2A,
+				ASCQ_2AH_ASYMMETRIC_ACCESS_STATE_CHANGED);
+		}
+		spin_unlock_bh(&port->sep_alua_lock);
+
+		spin_lock(&tg_pt_gp->tg_pt_gp_lock);
+		atomic_dec(&mem->tg_pt_gp_mem_ref_cnt);
+		smp_mb__after_atomic_dec();
+	}
+	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
+
+	printk(KERN_INFO "Successful %s ALUA transition TG PT Group: %s ID: %hu"
+		" from primary access state: %s to %s\n", (explict) ? "explict" :
+		"implict", config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item),
+		tg_pt_gp->tg_pt_gp_id, core_alua_dump_state(old_state),
+		core_alua_dump_state(new_state));
+
+	return 0;
+}
+
+int core_alua_do_port_transition(
+	t10_alua_tg_pt_gp_t *l_tg_pt_gp,
+	se_device_t *l_dev,
+	se_port_t *l_port,
+	se_node_acl_t *l_nacl,
+	int new_state,
+	int explict)
+{
+	se_device_t *dev;
+	se_port_t *port;
+	se_subsystem_dev_t *su_dev;
+	se_node_acl_t *nacl;
+	t10_alua_lu_gp_t *lu_gp;
+	t10_alua_lu_gp_member_t *lu_gp_mem, *local_lu_gp_mem;
+	t10_alua_tg_pt_gp_t *tg_pt_gp;
+	int primary;
+
+	if (core_alua_check_transition(new_state, &primary) != 0)
+		return -1;
+
+	local_lu_gp_mem = l_dev->dev_alua_lu_gp_mem;
+	spin_lock(&local_lu_gp_mem->lu_gp_mem_lock);
+	lu_gp = local_lu_gp_mem->lu_gp;
+	atomic_inc(&lu_gp->lu_gp_ref_cnt);
+	smp_mb__after_atomic_inc();
+	spin_unlock(&local_lu_gp_mem->lu_gp_mem_lock);
+	/*
+	 * For storage objects that are members of the 'default_lu_gp',
+	 * we only do transition on the passed *l_tp_pt_gp, and not
+	 * on all of the matching target port groups IDs in default_lu_gp.
+	 */
+	if (!(lu_gp->lu_gp_id)) {
+		/*
+		 * core_alua_do_transition_tg_pt() will always return
+		 * success.
+		 */
+		core_alua_do_transition_tg_pt(l_tg_pt_gp, l_port, l_nacl,
+					new_state, explict);
+		atomic_dec(&lu_gp->lu_gp_ref_cnt);
+		smp_mb__after_atomic_dec();
+		return 0;
+	}
+	/*
+	 * For all other LU groups aside from 'default_lu_gp', walk all of
+	 * the associated storage objects looking for a matching target port
+	 * group ID from the local target port group.
+	 */
+	spin_lock(&lu_gp->lu_gp_lock);
+	list_for_each_entry(lu_gp_mem, &lu_gp->lu_gp_mem_list,
+				lu_gp_mem_list) {
+
+		dev = lu_gp_mem->lu_gp_mem_dev;
+		su_dev = dev->se_sub_dev;
+		atomic_inc(&lu_gp_mem->lu_gp_mem_ref_cnt);
+		smp_mb__after_atomic_inc();
+		spin_unlock(&lu_gp->lu_gp_lock);
+		
+		spin_lock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
+		list_for_each_entry(tg_pt_gp,
+				&T10_ALUA(su_dev)->tg_pt_gps_list,
+				tg_pt_gp_list) {
+
+			if (!(tg_pt_gp->tg_pt_gp_valid_id))
+				continue;
+			/*
+			 * If the target behavior port asymmetric access state
+			 * is changed for any target port group accessiable via
+			 * a logical unit within a LU group, the target port
+			 * behavior group asymmetric access states for the same
+			 * target port group accessible via other logical units
+			 * in that LU group will also change.
+			 */
+			if (l_tg_pt_gp->tg_pt_gp_id != tg_pt_gp->tg_pt_gp_id)
+				continue;
+
+			if (l_tg_pt_gp == tg_pt_gp) {
+				port = l_port;
+				nacl = l_nacl;
+			} else {
+				port = NULL;
+				nacl = NULL;
+			}
+			atomic_inc(&tg_pt_gp->tg_pt_gp_ref_cnt);
+			smp_mb__after_atomic_inc();
+			spin_unlock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
+			/*
+			 * core_alua_do_transition_tg_pt() will always return
+			 * success.
+			 */
+			core_alua_do_transition_tg_pt(tg_pt_gp, port,
+					nacl, new_state, explict);
+
+			spin_lock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
+			atomic_dec(&tg_pt_gp->tg_pt_gp_ref_cnt);
+			smp_mb__after_atomic_dec();
+		}
+		spin_unlock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
+
+		spin_lock(&lu_gp->lu_gp_lock);
+		atomic_dec(&lu_gp_mem->lu_gp_mem_ref_cnt);
+		smp_mb__after_atomic_dec();
+	}
+	spin_unlock(&lu_gp->lu_gp_lock);
+
+	printk("Successfully processed LU Group: %s all ALUA TG PT Group IDs:"
+		" %hu %s transition to primary state: %s\n",
+		config_item_name(&lu_gp->lu_gp_group.cg_item),
+		l_tg_pt_gp->tg_pt_gp_id, (explict) ? "explict" : "implict",
+		core_alua_dump_state(new_state));
+
+	atomic_dec(&lu_gp->lu_gp_ref_cnt);
+	smp_mb__after_atomic_dec();
+	return 0;
+}
+
+int core_alua_set_tg_pt_secondary_state(
+	struct t10_alua_tg_pt_gp_member_s *tg_pt_gp_mem,
+	se_port_t *port,
+	int explict,
+	int offline)
+{
+	struct t10_alua_tg_pt_gp_s *tg_pt_gp;
+
+	spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
+	tg_pt_gp = tg_pt_gp_mem->tg_pt_gp;
+	if (!(tg_pt_gp)) {
+		spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
+		printk(KERN_ERR "Unable to complete secondary state"
+				" transition\n");
+		return -1;
+	}
+	/*
+	 * Set the secondary ALUA target port access state to OFFLINE
+	 * or release the previously secondary state for se_port_t
+	 */
+	if (offline)
+		atomic_set(&port->sep_tg_pt_secondary_offline, 1);
+	else
+		atomic_set(&port->sep_tg_pt_secondary_offline, 0);
+
+	port->sep_tg_pt_secondary_stat = (explict) ?
+			ALUA_STATUS_ALTERED_BY_EXPLICT_STPG :
+			ALUA_STATUS_ALTERED_BY_IMPLICT_ALUA;
+	spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
+
+	printk(KERN_INFO "Successful %s ALUA transition TG PT Group: %s ID: %hu"
+		" to secondary access state: %s\n", (explict) ? "explict" :
+		"implict", config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item),
+		tg_pt_gp->tg_pt_gp_id, (offline) ? "OFFLINE" : "ONLINE");
+
+	return 0;
+}
+
 t10_alua_lu_gp_t *core_alua_allocate_lu_gp(const char *name, int def_group)
 {
 	t10_alua_lu_gp_t *lu_gp;
@@ -141,7 +849,6 @@ t10_alua_lu_gp_t *core_alua_allocate_lu_gp(const char *name, int def_group)
 	INIT_LIST_HEAD(&lu_gp->lu_gp_mem_list);
 	spin_lock_init(&lu_gp->lu_gp_lock);
 	atomic_set(&lu_gp->lu_gp_ref_cnt, 0);
-	lu_gp->lu_gp_alua_access_state = ALUA_ACCESS_STATE_ACTIVE_OPTMIZED;
 
 	if (def_group) {
 		lu_gp->lu_gp_id = se_global->alua_lu_gps_counter++;;
@@ -156,6 +863,14 @@ int core_alua_set_lu_gp_id(t10_alua_lu_gp_t *lu_gp, u16 lu_gp_id)
 {
 	t10_alua_lu_gp_t *lu_gp_tmp;
 	u16 lu_gp_id_tmp;
+	/*
+	 * The lu_gp->lu_gp_id may only be set once..
+	 */
+	if (lu_gp->lu_gp_valid_id) {
+		printk(KERN_ERR "ALUA LU Group already has a valid ID,"
+			" ignoring request\n");
+		return -1;
+	}
 
 	spin_lock(&se_global->lu_gps_lock);
 	if (se_global->alua_lu_gps_count == 0x0000ffff) {
@@ -202,6 +917,7 @@ t10_alua_lu_gp_member_t *core_alua_allocate_lu_gp_mem(
 	}
 	INIT_LIST_HEAD(&lu_gp_mem->lu_gp_mem_list);
 	spin_lock_init(&lu_gp_mem->lu_gp_mem_lock);
+	atomic_set(&lu_gp_mem->lu_gp_mem_ref_cnt, 0);
 
 	lu_gp_mem->lu_gp_mem_dev = dev;
 	dev->dev_alua_lu_gp_mem = lu_gp_mem;
@@ -283,6 +999,9 @@ void core_alua_free_lu_gp_mem(se_device_t *dev)
 	if (!(lu_gp_mem))
 		return;
 
+	while (atomic_read(&lu_gp_mem->lu_gp_mem_ref_cnt))
+		msleep(10);
+
 	spin_lock(&lu_gp_mem->lu_gp_mem_lock);
 	lu_gp = lu_gp_mem->lu_gp;
 	if ((lu_gp)) {
@@ -358,7 +1077,10 @@ void __core_alua_drop_lu_gp_mem(
 	spin_unlock(&lu_gp->lu_gp_lock);
 }
 
-t10_alua_tg_pt_gp_t *core_alua_allocate_tg_pt_gp(const char *name, int def_group)
+t10_alua_tg_pt_gp_t *core_alua_allocate_tg_pt_gp(
+	se_subsystem_dev_t *su_dev,
+	const char *name,
+	int def_group)
 {
 	t10_alua_tg_pt_gp_t *tg_pt_gp;
 
@@ -371,36 +1093,62 @@ t10_alua_tg_pt_gp_t *core_alua_allocate_tg_pt_gp(const char *name, int def_group
 	INIT_LIST_HEAD(&tg_pt_gp->tg_pt_gp_mem_list);
 	spin_lock_init(&tg_pt_gp->tg_pt_gp_lock);
 	atomic_set(&tg_pt_gp->tg_pt_gp_ref_cnt, 0);
+	tg_pt_gp->tg_pt_gp_su_dev = su_dev;
 	tg_pt_gp->tg_pt_gp_alua_access_state =
 			ALUA_ACCESS_STATE_ACTIVE_OPTMIZED;
+	/*
+	 * Enable both explict and implict ALUA support by default
+	 */
+	tg_pt_gp->tg_pt_gp_alua_access_type =
+			TPGS_EXPLICT_ALUA | TPGS_IMPLICT_ALUA;
+	/*
+	 * Set the default Active/NonOptimized Delay in milliseconds
+	 */
+	tg_pt_gp->tg_pt_gp_nonop_delay_msecs = ALUA_DEFAULT_NONOP_DEFLAY_MSECS;
 
 	if (def_group) {
-		tg_pt_gp->tg_pt_gp_id = se_global->alua_tg_pt_gps_counter++;
+		spin_lock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
+		tg_pt_gp->tg_pt_gp_id =
+				T10_ALUA(su_dev)->alua_tg_pt_gps_counter++;
 		tg_pt_gp->tg_pt_gp_valid_id = 1;
-		se_global->alua_tg_pt_gps_count++;
+		T10_ALUA(su_dev)->alua_tg_pt_gps_count++;
+		list_add_tail(&tg_pt_gp->tg_pt_gp_list,
+			      &T10_ALUA(su_dev)->tg_pt_gps_list);
+		spin_unlock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
 	}
 
 	return tg_pt_gp;
 }
 
-int core_alua_set_tg_pt_gp_id(t10_alua_tg_pt_gp_t *tg_pt_gp, u16 tg_pt_gp_id)
+int core_alua_set_tg_pt_gp_id(
+	t10_alua_tg_pt_gp_t *tg_pt_gp,
+	u16 tg_pt_gp_id)
 {
+	se_subsystem_dev_t *su_dev = tg_pt_gp->tg_pt_gp_su_dev;
 	t10_alua_tg_pt_gp_t *tg_pt_gp_tmp;
 	u16 tg_pt_gp_id_tmp;
+	/*
+	 * The tg_pt_gp->tg_pt_gp_id may only be set once..
+	 */
+	if (tg_pt_gp->tg_pt_gp_valid_id) {
+		printk(KERN_ERR "ALUA TG PT Group already has a valid ID,"
+			" ignoring request\n");
+		return -1;
+	}
 
-	spin_lock(&se_global->tg_pt_gps_lock);
-	if (se_global->alua_tg_pt_gps_count == 0x0000ffff) {
-		printk(KERN_ERR "Maximum ALUA se_global->alua_tg_pt_gps_count:"
+	spin_lock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
+	if (T10_ALUA(su_dev)->alua_tg_pt_gps_count == 0x0000ffff) {
+		printk(KERN_ERR "Maximum ALUA alua_tg_pt_gps_count:"
 			" 0x0000ffff reached\n");
-		spin_unlock(&se_global->tg_pt_gps_lock);
+		spin_unlock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
 		kmem_cache_free(t10_alua_tg_pt_gp_cache, tg_pt_gp);
 		return -1;
 	}
 again:
 	tg_pt_gp_id_tmp = (tg_pt_gp_id != 0) ? tg_pt_gp_id :
-			se_global->alua_tg_pt_gps_counter++;
+			T10_ALUA(su_dev)->alua_tg_pt_gps_counter++;
 
-	list_for_each_entry(tg_pt_gp_tmp, &se_global->g_tg_pt_gps_list,
+	list_for_each_entry(tg_pt_gp_tmp, &T10_ALUA(su_dev)->tg_pt_gps_list,
 			tg_pt_gp_list) {
 		if (tg_pt_gp_tmp->tg_pt_gp_id == tg_pt_gp_id_tmp) {
 			if (!(tg_pt_gp_id))
@@ -408,16 +1156,17 @@ again:
 
 			printk(KERN_ERR "ALUA Target Port Group ID: %hu already"
 				" exists, ignoring request\n", tg_pt_gp_id);
-			spin_unlock(&se_global->tg_pt_gps_lock);
+			spin_unlock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
 			return -1;
 		}
 	}
 
 	tg_pt_gp->tg_pt_gp_id = tg_pt_gp_id_tmp;
 	tg_pt_gp->tg_pt_gp_valid_id = 1;
-	list_add_tail(&tg_pt_gp->tg_pt_gp_list, &se_global->g_tg_pt_gps_list);
-	se_global->alua_tg_pt_gps_count++;
-	spin_unlock(&se_global->tg_pt_gps_lock);
+	list_add_tail(&tg_pt_gp->tg_pt_gp_list,
+			&T10_ALUA(su_dev)->tg_pt_gps_list);
+	T10_ALUA(su_dev)->alua_tg_pt_gps_count++;
+	spin_unlock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
 
 	return 0;
 }
@@ -435,15 +1184,19 @@ t10_alua_tg_pt_gp_member_t *core_alua_allocate_tg_pt_gp_mem(
 	}
 	INIT_LIST_HEAD(&tg_pt_gp_mem->tg_pt_gp_mem_list);
 	spin_lock_init(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
+	atomic_set(&tg_pt_gp_mem->tg_pt_gp_mem_ref_cnt, 0);
 
 	tg_pt_gp_mem->tg_pt = port;
 	port->sep_alua_tg_pt_gp_mem = tg_pt_gp_mem;
+	atomic_set(&port->sep_tg_pt_gp_active, 1);
 
 	return tg_pt_gp_mem;
 }
 
-void core_alua_free_tg_pt_gp(t10_alua_tg_pt_gp_t *tg_pt_gp)
+void core_alua_free_tg_pt_gp(
+	t10_alua_tg_pt_gp_t *tg_pt_gp)
 {
+	se_subsystem_dev_t *su_dev = tg_pt_gp->tg_pt_gp_su_dev;
 	t10_alua_tg_pt_gp_member_t *tg_pt_gp_mem, *tg_pt_gp_mem_tmp;
 	/*
 	 * Once we have reached this point, config_item_put() has already
@@ -453,10 +1206,10 @@ void core_alua_free_tg_pt_gp(t10_alua_tg_pt_gp_t *tg_pt_gp)
 	 * no assications *OR* explict ALUA via SET_TARGET_PORT_GROUPS
 	 * can be made while we are releasing t10_alua_tg_pt_gp_t.
 	 */
-	spin_lock(&se_global->tg_pt_gps_lock);
+	spin_lock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
 	list_del(&tg_pt_gp->tg_pt_gp_list);
-	se_global->alua_tg_pt_gps_counter--;
-	spin_unlock(&se_global->tg_pt_gps_lock);
+	T10_ALUA(su_dev)->alua_tg_pt_gps_counter--;
+	spin_unlock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
 	/*
 	 * Allow a t10_alua_tg_pt_gp_member_t * referenced by
 	 * core_alua_get_tg_pt_gp_by_name() in
@@ -480,7 +1233,7 @@ void core_alua_free_tg_pt_gp(t10_alua_tg_pt_gp_t *tg_pt_gp)
 		spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
 		/*
 		 * tg_pt_gp_mem is assoicated with a single
-		 * se_portt->sep_alua_tg_pt_gp_mem, and is released via
+		 * se_port->sep_alua_tg_pt_gp_mem, and is released via
 		 * core_alua_free_tg_pt_gp_mem().
 		 *
 		 * If the passed tg_pt_gp does NOT match the default_tg_pt_gp,
@@ -488,9 +1241,9 @@ void core_alua_free_tg_pt_gp(t10_alua_tg_pt_gp_t *tg_pt_gp)
 		 * default_tg_pt_gp.
 		 */
 		spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
-		if (tg_pt_gp != se_global->default_tg_pt_gp) {
+		if (tg_pt_gp != T10_ALUA(su_dev)->default_tg_pt_gp) {
 			__core_alua_attach_tg_pt_gp_mem(tg_pt_gp_mem,
-					se_global->default_tg_pt_gp);
+					T10_ALUA(su_dev)->default_tg_pt_gp);
 		} else
 			tg_pt_gp_mem->tg_pt_gp = NULL;
 		spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
@@ -516,6 +1269,9 @@ void core_alua_free_tg_pt_gp_mem(se_port_t *port)
 	if (!(tg_pt_gp_mem))
 		return;
 
+	while (atomic_read(&tg_pt_gp_mem->tg_pt_gp_mem_ref_cnt))
+		msleep(10);
+
 	spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 	tg_pt_gp = tg_pt_gp_mem->tg_pt_gp;
 	if ((tg_pt_gp)) {
@@ -533,33 +1289,38 @@ void core_alua_free_tg_pt_gp_mem(se_port_t *port)
 	kmem_cache_free(t10_alua_tg_pt_gp_mem_cache, tg_pt_gp_mem);
 }
 
-t10_alua_tg_pt_gp_t *core_alua_get_tg_pt_gp_by_name(const char *name)
+t10_alua_tg_pt_gp_t *core_alua_get_tg_pt_gp_by_name(
+	se_subsystem_dev_t *su_dev,
+	const char *name)
 {
 	t10_alua_tg_pt_gp_t *tg_pt_gp;
 	struct config_item *ci;
 
-	spin_lock(&se_global->tg_pt_gps_lock);
-	list_for_each_entry(tg_pt_gp, &se_global->g_tg_pt_gps_list,
+	spin_lock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
+	list_for_each_entry(tg_pt_gp, &T10_ALUA(su_dev)->tg_pt_gps_list,
 			tg_pt_gp_list) {
 		if (!(tg_pt_gp->tg_pt_gp_valid_id))
 			continue;
 		ci = &tg_pt_gp->tg_pt_gp_group.cg_item;
 		if (!(strcmp(config_item_name(ci), name))) {
 			atomic_inc(&tg_pt_gp->tg_pt_gp_ref_cnt);
-			spin_unlock(&se_global->tg_pt_gps_lock);
+			spin_unlock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
 			return tg_pt_gp;
 		}
 	}
-	spin_unlock(&se_global->tg_pt_gps_lock);
+	spin_unlock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
 
 	return NULL;
 }
 
-void core_alua_put_tg_pt_gp_from_name(t10_alua_tg_pt_gp_t *tg_pt_gp)
+void core_alua_put_tg_pt_gp_from_name(
+	t10_alua_tg_pt_gp_t *tg_pt_gp)
 {
-	spin_lock(&se_global->tg_pt_gps_lock);
+	se_subsystem_dev_t *su_dev = tg_pt_gp->tg_pt_gp_su_dev;
+
+	spin_lock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
 	atomic_dec(&tg_pt_gp->tg_pt_gp_ref_cnt);
-	spin_unlock(&se_global->tg_pt_gps_lock);
+	spin_unlock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
 }
 
 /*
@@ -614,8 +1375,15 @@ ssize_t core_alua_show_tg_pt_gp_info(se_port_t *port, char *page)
 	if ((tg_pt_gp)) {
 		tg_pt_ci = &tg_pt_gp->tg_pt_gp_group.cg_item;
 		len += sprintf(page, "TG Port Alias: %s\nTG Port Group ID:"
-			" %hu\n", config_item_name(tg_pt_ci),
-			tg_pt_gp->tg_pt_gp_id);
+			" %hu\nTG Port Primary Access State: %s\nTG Port "
+			"Primary Access Status: %s\nTG Port Secondary Access"
+			" State: %s\nTG Port Secondary Access Status: %s\n",
+			config_item_name(tg_pt_ci), tg_pt_gp->tg_pt_gp_id,
+			core_alua_dump_state(tg_pt_gp->tg_pt_gp_alua_access_state),
+			core_alua_dump_status(tg_pt_gp->tg_pt_gp_alua_access_status),
+			(atomic_read(&port->sep_tg_pt_secondary_offline)) ?
+			"Offline" : "None",
+			core_alua_dump_status(port->sep_tg_pt_secondary_stat));
 	}
 	spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 
@@ -646,6 +1414,7 @@ ssize_t core_alua_store_tg_pt_gp_info(
 			config_item_name(&lun->lun_group.cg_item));
 		return -EINVAL;
 	}
+
 	if (count > TG_PT_GROUP_NAME_BUF) {
 		printk(KERN_ERR "ALUA Target Port Group alias too large!\n");
 		return -EINVAL;
@@ -662,7 +1431,8 @@ ssize_t core_alua_store_tg_pt_gp_info(
 		 * t10_alua_tg_pt_gp_t.  This reference is released with
 		 * core_alua_put_tg_pt_gp_from_name() below.
 		 */
-		tg_pt_gp_new = core_alua_get_tg_pt_gp_by_name(strstrip(buf));
+		tg_pt_gp_new = core_alua_get_tg_pt_gp_by_name(su_dev,
+					strstrip(buf));
 		if (!(tg_pt_gp_new))
 			return -ENODEV;
 	}
@@ -679,12 +1449,13 @@ ssize_t core_alua_store_tg_pt_gp_info(
 	if ((tg_pt_gp)) {
 		/*
 		 * Clearing an existing tg_pt_gp association, and replacing
-		 * with NULL
+		 * with the default_tg_pt_gp.
 		 */
 		if (!(tg_pt_gp_new)) {
-			printk(KERN_INFO "Target_Core_ConfigFS: Releasing"
+			printk(KERN_INFO "Target_Core_ConfigFS: Moving"
 				" %s/tpgt_%hu/%s from ALUA Target Port Group:"
-				" core/alua/tg_pt_gps/%s, ID: %hu\n",
+				" alua/%s, ID: %hu back to"
+				" default_tg_pt_gp\n",
 				TPG_TFO(tpg)->tpg_get_wwn(tpg),
 				TPG_TFO(tpg)->tpg_get_tag(tpg),
 				config_item_name(&lun->lun_group.cg_item),
@@ -693,6 +1464,8 @@ ssize_t core_alua_store_tg_pt_gp_info(
 				tg_pt_gp->tg_pt_gp_id);
 
 			__core_alua_drop_tg_pt_gp_mem(tg_pt_gp_mem, tg_pt_gp);
+			__core_alua_attach_tg_pt_gp_mem(tg_pt_gp_mem,
+					T10_ALUA(su_dev)->default_tg_pt_gp);
 			spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 
 			return count;
@@ -708,9 +1481,8 @@ ssize_t core_alua_store_tg_pt_gp_info(
 	 */
 	__core_alua_attach_tg_pt_gp_mem(tg_pt_gp_mem, tg_pt_gp_new);
 	spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
-
 	printk("Target_Core_ConfigFS: %s %s/tpgt_%hu/%s to ALUA Target Port"
-		" Group: core/alua/tg_pt_gps/%s, ID: %hu\n", (move) ?
+		" Group: alua/%s, ID: %hu\n", (move) ?
 		"Moving" : "Adding", TPG_TFO(tpg)->tpg_get_wwn(tpg),
 		TPG_TFO(tpg)->tpg_get_tag(tpg),
 		config_item_name(&lun->lun_group.cg_item),
@@ -722,6 +1494,155 @@ ssize_t core_alua_store_tg_pt_gp_info(
 }
 EXPORT_SYMBOL(core_alua_store_tg_pt_gp_info);
 
+ssize_t core_alua_show_access_type(
+	t10_alua_tg_pt_gp_t *tg_pt_gp,
+	char *page)
+{
+	if ((tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_EXPLICT_ALUA) &&
+	    (tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_IMPLICT_ALUA))
+		return sprintf(page, "Implict and Explict\n");
+	else if (tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_IMPLICT_ALUA)	
+		return sprintf(page, "Implict\n");
+	else if (tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_EXPLICT_ALUA)
+		return sprintf(page, "Explict\n");
+	else
+		return sprintf(page, "None\n");
+}
+
+ssize_t core_alua_store_access_type(
+	t10_alua_tg_pt_gp_t *tg_pt_gp,
+	const char *page,
+	size_t count)
+{
+	unsigned long tmp;
+	int ret;
+
+	ret = strict_strtoul(page, 0, &tmp);
+	if (ret < 0) {
+		printk(KERN_ERR "Unable to extract alua_access_type\n");
+		return -EINVAL;
+	}
+	if ((tmp != 0) && (tmp != 1) && (tmp != 2) && (tmp != 3)) {
+		printk(KERN_ERR "Illegal value for alua_access_type:"
+				" %lu\n", tmp);
+		return -EINVAL;
+	}
+	if (tmp == 3)
+		tg_pt_gp->tg_pt_gp_alua_access_type =
+			TPGS_IMPLICT_ALUA | TPGS_EXPLICT_ALUA;
+	else if (tmp == 2)	
+		tg_pt_gp->tg_pt_gp_alua_access_type = TPGS_EXPLICT_ALUA;
+	else if (tmp == 1)
+		tg_pt_gp->tg_pt_gp_alua_access_type = TPGS_IMPLICT_ALUA;
+	else
+		tg_pt_gp->tg_pt_gp_alua_access_type = 0;
+	
+	return count;
+}
+
+ssize_t core_alua_show_nonop_delay_msecs(
+	t10_alua_tg_pt_gp_t *tg_pt_gp,
+	char *page)
+{
+	return sprintf(page, "%d\n", tg_pt_gp->tg_pt_gp_nonop_delay_msecs);
+}
+
+ssize_t core_alua_store_nonop_delay_msecs(
+	t10_alua_tg_pt_gp_t *tg_pt_gp,
+	const char *page,
+	size_t count)
+{
+	unsigned long tmp;
+	int ret;
+
+	ret = strict_strtoul(page, 0, &tmp);
+	if (ret < 0) {
+		printk(KERN_ERR "Unable to extract nonop_delay_msecs\n");
+		return -EINVAL;
+	}
+	if (tmp > ALUA_MAX_NONOP_DELAY_MSECS) {
+		printk(KERN_ERR "Passed nonop_delay_msecs: %lu, exceeds"
+			" ALUA_MAX_NONOP_DELAY_MSECS: %d\n", tmp,
+			ALUA_MAX_NONOP_DELAY_MSECS);
+		return -EINVAL;
+	}
+	tg_pt_gp->tg_pt_gp_nonop_delay_msecs = (int)tmp;
+
+	return count;
+}
+
+ssize_t core_alua_show_preferred_bit(
+	t10_alua_tg_pt_gp_t *tg_pt_gp,
+	char *page)
+{
+	return sprintf(page, "%d\n", tg_pt_gp->tg_pt_gp_pref);
+}
+
+ssize_t core_alua_store_preferred_bit(
+	t10_alua_tg_pt_gp_t *tg_pt_gp,
+	const char *page,
+	size_t count)
+{
+	unsigned long tmp;
+	int ret;	
+
+	ret = strict_strtoul(page, 0, &tmp);
+	if (ret < 0) {
+		printk(KERN_ERR "Unable to extract preferred ALUA value\n");
+		return -EINVAL;
+	}
+	if ((tmp != 0) && (tmp != 1)) {
+		printk(KERN_ERR "Illegal value for preferred ALUA: %lu\n", tmp);
+		return -EINVAL;
+	}
+	tg_pt_gp->tg_pt_gp_pref = (int)tmp;
+
+	return count;
+}
+
+ssize_t core_alua_show_offline_bit(se_lun_t *lun, char *page)
+{
+	if (!(lun->lun_sep))
+		return -ENODEV;
+
+	return sprintf(page, "%d\n",
+		atomic_read(&lun->lun_sep->sep_tg_pt_secondary_offline));
+}
+EXPORT_SYMBOL(core_alua_show_offline_bit);
+
+ssize_t core_alua_store_offline_bit(se_lun_t *lun, const char *page, size_t count)
+{
+	t10_alua_tg_pt_gp_member_t *tg_pt_gp_mem;
+	unsigned long tmp;
+	int ret;
+
+	if (!(lun->lun_sep))
+		return -ENODEV;
+
+	ret = strict_strtoul(page, 0, &tmp);
+	if (ret < 0) {
+		printk(KERN_ERR "Unable to extract alua_tg_pt_offline value\n");
+		return -EINVAL;
+	}
+	if ((tmp != 0) && (tmp != 1)) {
+		printk(KERN_ERR "Illegal value for alua_tg_pt_offline: %lu\n", tmp);
+		return -EINVAL;
+	}
+	tg_pt_gp_mem = lun->lun_sep->sep_alua_tg_pt_gp_mem;
+	if (!(tg_pt_gp_mem)) {
+		printk(KERN_ERR "Unable to locate *tg_pt_gp_mem\n");
+		return -EINVAL;
+	}
+	
+	ret = core_alua_set_tg_pt_secondary_state(tg_pt_gp_mem,
+			lun->lun_sep, 0, (int)tmp);
+	if (ret < 0)
+		return -EINVAL;
+
+	return count;
+}
+EXPORT_SYMBOL(core_alua_store_offline_bit);
+
 int core_setup_alua(se_device_t *dev)
 {
 	se_subsystem_dev_t *su_dev = dev->se_sub_dev;
@@ -736,6 +1657,7 @@ int core_setup_alua(se_device_t *dev)
 	if ((TRANSPORT(dev)->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) &&
 	    !(DEV_ATTRIB(dev)->emulate_alua)) {
 		alua->alua_type = SPC_ALUA_PASSTHROUGH;
+		alua->alua_state_check = &core_alua_state_check_nop;
 		printk(KERN_INFO "%s: Using SPC_ALUA_PASSTHROUGH, no ALUA"
 			" emulation\n", TRANSPORT(dev)->name);
 		return 0;
@@ -756,6 +1678,7 @@ int core_setup_alua(se_device_t *dev)
 			return -1;
 
 		alua->alua_type = SPC3_ALUA_EMULATED;
+		alua->alua_state_check = &core_alua_state_check;
 		spin_lock(&lu_gp_mem->lu_gp_mem_lock);
 		__core_alua_attach_lu_gp_mem(lu_gp_mem,
 				se_global->default_lu_gp);
@@ -766,6 +1689,7 @@ int core_setup_alua(se_device_t *dev)
 			TRANSPORT(dev)->name);
 	} else {
 		alua->alua_type = SPC2_ALUA_DISABLED;
+		alua->alua_state_check = &core_alua_state_check_nop;
 		printk("%s: Disabling ALUA Emulation for SPC-2 device\n",
 				TRANSPORT(dev)->name);
 	}
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 46cc450..a088960 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -511,6 +511,7 @@ void core_update_device_list_for_node(
 	se_portal_group_t *tpg,
 	int enable)
 {
+	se_port_t *port = lun->lun_sep;
 	se_dev_entry_t *deve;
 
 	spin_lock_bh(&nacl->device_list_lock);
@@ -533,6 +534,11 @@ void core_update_device_list_for_node(
 		deve->attach_count++;
 #endif /* SNMP_SUPPORT */
 		spin_unlock_bh(&nacl->device_list_lock);
+
+		spin_lock_bh(&port->sep_alua_lock);
+		list_add_tail(&deve->alua_port_list, &port->sep_alua_list);
+		spin_unlock_bh(&port->sep_alua_lock);
+
 		return;
 	}
 	/*
@@ -548,6 +554,10 @@ void core_update_device_list_for_node(
 #endif /* SNMP_SUPPORT */
 	spin_unlock_bh(&nacl->device_list_lock);
 
+	spin_lock_bh(&port->sep_alua_lock);
+	list_del(&deve->alua_port_list);
+	spin_unlock_bh(&port->sep_alua_lock);
+
 	core_scsi3_free_pr_reg_from_nacl(lun->se_dev, nacl);
 	return;
 }
@@ -597,7 +607,10 @@ se_port_t *core_alloc_port(se_device_t *dev)
 		printk(KERN_ERR "Unable to allocate se_port_t\n");
 		return NULL;
 	}
+	INIT_LIST_HEAD(&port->sep_alua_list);
 	INIT_LIST_HEAD(&port->sep_list);
+	atomic_set(&port->sep_tg_pt_secondary_offline, 0);
+	spin_lock_init(&port->sep_alua_lock);
 
 	spin_lock(&dev->se_port_lock);
 	if (dev->dev_port_count == 0x0000ffff) {
@@ -664,11 +677,10 @@ void core_export_port(
 		}
 		spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 		__core_alua_attach_tg_pt_gp_mem(tg_pt_gp_mem,
-			se_global->default_tg_pt_gp);
+			T10_ALUA(su_dev)->default_tg_pt_gp);
 		spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
-
 		printk(KERN_INFO "%s/%s: Adding to default ALUA Target Port"
-			" Group: core/alua/tg_pt_gps/default_tg_pt_gp\n",
+			" Group: alua/default_tg_pt_gp\n",
 			TRANSPORT(dev)->name, TPG_TFO(tpg)->get_fabric_name());
 	}
 
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 8b39f95..b3624fc 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -250,6 +250,7 @@ static int core_create_device_list_for_node(se_node_acl_t *nacl)
 
 		atomic_set(&deve->ua_count, 0);
 		spin_lock_init(&deve->ua_lock);
+		INIT_LIST_HEAD(&deve->alua_port_list);
 		INIT_LIST_HEAD(&deve->ua_list);
 	}
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index b4a76ab..c69e0e1 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -252,7 +252,6 @@ int init_se_global(void)
 	}
 
 	INIT_LIST_HEAD(&global->g_lu_gps_list);
-	INIT_LIST_HEAD(&global->g_tg_pt_gps_list);
 	INIT_LIST_HEAD(&global->g_se_tpg_list);
 	INIT_LIST_HEAD(&global->g_hba_list);
 	INIT_LIST_HEAD(&global->g_se_dev_list);
@@ -260,7 +259,6 @@ int init_se_global(void)
 	spin_lock_init(&global->hba_lock);
 	spin_lock_init(&global->se_tpg_lock);
 	spin_lock_init(&global->lu_gps_lock);
-	spin_lock_init(&global->tg_pt_gps_lock);
 	spin_lock_init(&global->plugin_class_lock);
 
 	se_cmd_cache = kmem_cache_create("se_cmd_cache",
@@ -2070,6 +2068,7 @@ se_device_t *transport_add_device_to_core_hba(
 	INIT_LIST_HEAD(&dev->state_task_list);
 	spin_lock_init(&dev->execute_task_lock);
 	spin_lock_init(&dev->state_task_lock);
+	spin_lock_init(&dev->dev_alua_lock);
 	spin_lock_init(&dev->dev_reservation_lock);
 	spin_lock_init(&dev->dev_status_lock);
 	spin_lock_init(&dev->dev_status_thr_lock);
@@ -2705,7 +2704,7 @@ static void transport_generic_wait_for_tasks(se_cmd_t *, int, int);
 
 /*	transport_generic_allocate_tasks():
  *
- *	Called from the iSCSI RX Thread.
+ *	Called from fabric RX Thread.
  */
 int transport_generic_allocate_tasks(
 	se_cmd_t *cmd,
@@ -2813,8 +2812,14 @@ int transport_generic_allocate_tasks(
 		cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 		cmd->scsi_sense_reason = CHECK_CONDITION_UNIT_ATTENTION;
 		return -2;
+	case 9:
+		cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
+		cmd->scsi_sense_reason = CHECK_CONDITION_NOT_READY;
+		return -2;
 	default:
-		break;
+		cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
+		cmd->scsi_sense_reason = UNSUPPORTED_SCSI_OPCODE;
+		return -2;
 	}
 
 	return 0;
@@ -4117,6 +4122,7 @@ extern int transport_generic_emulate_inquiry(
 	se_port_t *port = NULL;
 	se_portal_group_t *tpg = NULL;
 	t10_alua_lu_gp_member_t *lu_gp_mem;
+	t10_alua_tg_pt_gp_t *tg_pt_gp;
 	t10_alua_tg_pt_gp_member_t *tg_pt_gp_mem;
 	unsigned char *buf = (unsigned char *) T_TASK(cmd)->t_task_buf;
 	unsigned char *cdb = T_TASK(cmd)->t_task_cdb;
@@ -4152,10 +4158,28 @@ extern int transport_generic_emulate_inquiry(
 			 */
 			buf[5]	= 0x80;
 			/*
-			 * Set TPGS field, see spc4r17 section 6.4.2 Table 135
+			 * Set TPGS field for explict and/or implict ALUA
+			 * access type and opteration.
+			 *
+			 * See spc4r17 section 6.4.2 Table 135
 			 */
-			buf[5] |= TPGS_IMPLICT_ALUA;
+			port = lun->lun_sep;
+			if (!(port))
+				goto after_tpgs;
+			tg_pt_gp_mem = port->sep_alua_tg_pt_gp_mem;
+			if (!(tg_pt_gp_mem))
+				goto after_tpgs;
+
+			spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
+			tg_pt_gp = tg_pt_gp_mem->tg_pt_gp;
+			if (!(tg_pt_gp)) {
+				spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
+				goto after_tpgs;
+			}
+			buf[5] |= tg_pt_gp->tg_pt_gp_alua_access_type;
+			spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 		}
+after_tpgs:
 		buf[7]		= 0x32; /* Sync=1 and CmdQue=1 */
 		/*
 		 * Do not include vendor, product, reversion info in INQUIRY
@@ -4329,7 +4353,6 @@ check_port:
 		port = lun->lun_sep;
 		if (port) {
 			t10_alua_lu_gp_t *lu_gp;
-			t10_alua_tg_pt_gp_t *tg_pt_gp;
 			u32 padding, scsi_name_len;
 			u16 lu_gp_id = 0;
 			u16 tg_pt_gp_id = 0;
@@ -4879,6 +4902,7 @@ static int transport_generic_cmd_sequencer(
 	se_subsystem_dev_t *su_dev = dev->se_sub_dev;
 	int ret = 0, sector_ret = 0;
 	u32 sectors = 0, size = 0, pr_reg_type = 0;
+	u8 alua_ascq = 0;
 	/*
 	 * Check for an existing UNIT ATTENTION condition
 	 */
@@ -4889,6 +4913,29 @@ static int transport_generic_cmd_sequencer(
 		return 8; /* UNIT ATTENTION */
 	}
 	/*
+	 * Check status of Asymmetric Logical Unit Assignment port
+	 */
+	ret = T10_ALUA(su_dev)->alua_state_check(cmd, cdb, &alua_ascq);
+	if (ret != 0) {
+		cmd->transport_wait_for_tasks = &transport_nop_wait_for_tasks;
+		transport_get_maps(cmd);
+		/*
+		 * Set SCSI additional sense code (ASC) to 'LUN Not Accessable';
+		 * The ALUA additional sense code qualifier (ASCQ) is determined
+		 * by the ALUA primary or secondary access state..
+		 */
+		if (ret > 0) {
+#if 0
+			printk(KERN_INFO "[%s]: ALUA TG Port not available,"
+				" SenseKey: NOT_READY, ASC/ASCQ: 0x04/0x%02x\n",
+				CMD_TFO(cmd)->get_fabric_name(), alua_ascq);
+#endif
+			transport_set_sense_codes(cmd, 0x04, alua_ascq);
+			return 9; /* NOT READY */
+		}
+		return 6; /* INVALID_CDB_FIELD */	
+	}
+	/*
 	 * Check status for SPC-3 Persistent Reservations
 	 */
 	if (T10_RES(su_dev)->t10_reservation_check(cmd, &pr_reg_type) != 0) {
@@ -5098,16 +5145,27 @@ static int transport_generic_cmd_sequencer(
 	case 0xa4:
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		if (TRANSPORT(dev)->get_device_type(dev) != TYPE_ROM) {
-			/* MAINTENANCE_OUT from SCC-2 */
+			/* MAINTENANCE_OUT from SCC-2
+			 *
+			 * Check for emulated MO_SET_TARGET_PGS.
+                         */
+                        if (cdb[1] == MO_SET_TARGET_PGS) {
+                                cmd->transport_emulate_cdb =
+                                (T10_ALUA(su_dev)->alua_type ==
+                                 SPC3_ALUA_EMULATED) ?
+                                &core_scsi3_emulate_set_target_port_groups :
+                                NULL;
+                        }
+
 			size = (cdb[6] << 24) | (cdb[7] << 16) |
 			       (cdb[8] << 8) | cdb[9];
 		} else  {
 			/* GPCMD_REPORT_KEY from multi media commands */
 			size = (cdb[8] << 8) + cdb[9];
 		}
-		CMD_ORIG_OBJ_API(cmd)->get_mem_SG(cmd->se_orig_obj_ptr, cmd);
+		CMD_ORIG_OBJ_API(cmd)->get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		transport_get_maps(cmd);
-		ret = 1;
+		ret = 2;
 		break;
 	case INQUIRY:
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
@@ -7028,6 +7086,28 @@ remove:
 	transport_generic_free_cmd(cmd, 0, 0, session_reinstatement);
 }
 
+int transport_get_sense_codes(
+	se_cmd_t *cmd,
+	u8 *asc,
+	u8 *ascq)
+{
+	*asc = cmd->scsi_asc;	
+	*ascq = cmd->scsi_ascq;
+	
+	return 0;
+}
+
+int transport_set_sense_codes(
+	se_cmd_t *cmd,
+	u8 asc,
+	u8 ascq)
+{
+	cmd->scsi_asc = asc;
+	cmd->scsi_ascq = ascq;
+
+	return 0;
+}
+
 int transport_send_check_condition_and_sense(
 	se_cmd_t *cmd,
 	u8 reason,
@@ -7164,6 +7244,15 @@ int transport_send_check_condition_and_sense(
 		buffer[offset+SPC_ASC_KEY_OFFSET] = asc;
 		buffer[offset+SPC_ASCQ_KEY_OFFSET] = ascq;
 		break;
+	case CHECK_CONDITION_NOT_READY:
+		/* CURRENT ERROR */
+		buffer[offset] = 0x70;
+		/* Not Ready */
+		buffer[offset+SPC_SENSE_KEY_OFFSET] = NOT_READY;
+		transport_get_sense_codes(cmd, &asc, &ascq);
+		buffer[offset+SPC_ASC_KEY_OFFSET] = asc;
+		buffer[offset+SPC_ASCQ_KEY_OFFSET] = ascq;
+		break;
 	case LOGICAL_UNIT_COMMUNICATION_FAILURE:
 	default:
 		/* CURRENT ERROR */
diff --git a/include/target/target_core_alua.h b/include/target/target_core_alua.h
index a98f8ad..0f191b4 100644
--- a/include/target/target_core_alua.h
+++ b/include/target/target_core_alua.h
@@ -9,7 +9,6 @@
 #define TPGS_NO_ALUA				0x00
 #define TPGS_IMPLICT_ALUA			0x10
 #define TPGS_EXPLICT_ALUA			0x20
-#define TPGS_EXPLICT_AND_IMPLICT_ALUA		0x40
 
 /*
  * ASYMMETRIC ACCESS STATE field
@@ -32,6 +31,21 @@
 #define ALUA_STATUS_ALTERED_BY_EXPLICT_STPG		0x01
 #define ALUA_STATUS_ALTERED_BY_IMPLICT_ALUA		0x02
 
+/*
+ * From spc4r17, Table D.1: ASC and ASCQ Assignement
+ */
+#define ASCQ_04H_ALUA_STATE_TRANSITION			0x0a
+#define ASCQ_04H_ALUA_TG_PT_STANDBY			0x0b
+#define ASCQ_04H_ALUA_TG_PT_UNAVAILABLE			0x0c
+#define ASCQ_04H_ALUA_OFFLINE				0x12
+
+/*
+ * Used as the default for Active/NonOptimized delay (in milliseconds)
+ * This can also be changed via configfs on a per target port group basis..
+ */
+#define ALUA_DEFAULT_NONOP_DEFLAY_MSECS			100
+#define ALUA_MAX_NONOP_DELAY_MSECS			10000 /* 10 seconds */
+
 extern se_global_t *se_global;
 
 extern struct kmem_cache *t10_alua_lu_gp_cache;
@@ -40,6 +54,19 @@ extern struct kmem_cache *t10_alua_tg_pt_gp_cache;
 extern struct kmem_cache *t10_alua_tg_pt_gp_mem_cache;
 
 extern int core_scsi3_emulate_report_target_port_groups(struct se_cmd_s *);
+extern int core_scsi3_emulate_set_target_port_groups(struct se_cmd_s *);
+extern int core_alua_check_transition(int, int *);
+extern int core_alua_check_nonop_delay(struct se_cmd_s *);
+extern int core_alua_do_transition_tg_pt(struct t10_alua_tg_pt_gp_s *,
+				struct se_port_s *, struct se_node_acl_s *,
+				int, int);
+extern int core_alua_do_port_transition(struct t10_alua_tg_pt_gp_s *,
+				struct se_device_s *, struct se_port_s *,
+				struct se_node_acl_s *, int, int);
+extern int core_alua_set_tg_pt_secondary_state(
+		struct t10_alua_tg_pt_gp_member_s *, se_port_t *, int, int);
+extern char *core_alua_dump_state(int);
+extern char *core_alua_dump_status(int);
 extern struct t10_alua_lu_gp_s *core_alua_allocate_lu_gp(const char *, int);
 extern int core_alua_set_lu_gp_id(struct t10_alua_lu_gp_s *, u16);
 extern struct t10_alua_lu_gp_member_s *core_alua_allocate_lu_gp_mem(
@@ -53,13 +80,15 @@ extern void __core_alua_attach_lu_gp_mem(struct t10_alua_lu_gp_member_s *,
 extern void __core_alua_drop_lu_gp_mem(struct t10_alua_lu_gp_member_s *,
 					struct t10_alua_lu_gp_s *);
 extern void core_alua_drop_lu_gp_dev(struct se_device_s *);
-extern struct t10_alua_tg_pt_gp_s *core_alua_allocate_tg_pt_gp(const char *, int);
+extern struct t10_alua_tg_pt_gp_s *core_alua_allocate_tg_pt_gp(
+			struct se_subsystem_dev_s *, const char *, int);
 extern int core_alua_set_tg_pt_gp_id(struct t10_alua_tg_pt_gp_s *, u16);
 extern struct t10_alua_tg_pt_gp_member_s *core_alua_allocate_tg_pt_gp_mem(
 					struct se_port_s *);
 extern void core_alua_free_tg_pt_gp(struct t10_alua_tg_pt_gp_s *);
 extern void core_alua_free_tg_pt_gp_mem(struct se_port_s *);
-extern struct t10_alua_tg_pt_gp_s *core_alua_get_tg_pt_gp_by_name(const char *);
+extern struct t10_alua_tg_pt_gp_s *core_alua_get_tg_pt_gp_by_name(
+				struct se_subsystem_dev_s *, const char *);
 extern void core_alua_put_tg_pt_gp_from_name(struct t10_alua_tg_pt_gp_s *);
 extern void __core_alua_attach_tg_pt_gp_mem(struct t10_alua_tg_pt_gp_member_s *,
 					struct t10_alua_tg_pt_gp_s *);
@@ -68,6 +97,18 @@ extern void __core_alua_drop_tg_pt_gp_mem(struct t10_alua_tg_pt_gp_member_s *,
 extern ssize_t core_alua_show_tg_pt_gp_info(struct se_port_s *, char *);
 extern ssize_t core_alua_store_tg_pt_gp_info(struct se_port_s *, const char *,
 						size_t);
+extern ssize_t core_alua_show_access_type(struct t10_alua_tg_pt_gp_s *, char *);
+extern ssize_t core_alua_store_access_type(struct t10_alua_tg_pt_gp_s *,
+					const char *, size_t);
+extern ssize_t core_alua_show_nonop_delay_msecs(struct t10_alua_tg_pt_gp_s *,
+						char *);
+extern ssize_t core_alua_store_nonop_delay_msecs(struct t10_alua_tg_pt_gp_s *,
+					const char *, size_t);
+extern ssize_t core_alua_show_preferred_bit(struct t10_alua_tg_pt_gp_s *, char *);
+extern ssize_t core_alua_store_preferred_bit(struct t10_alua_tg_pt_gp_s *,
+				const char *, size_t);
+extern ssize_t core_alua_show_offline_bit(struct se_lun_s *, char *);
+extern ssize_t core_alua_store_offline_bit(struct se_lun_s *, const char *, size_t);
 extern int core_setup_alua(struct se_device_s *);
 
 #endif /* TARGET_CORE_ALUA_H */
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 41aec3e..2e50408 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -160,6 +160,7 @@
 #define SCF_OVERFLOW_BIT                        0x00010000
 #define SCF_UNDERFLOW_BIT                       0x00020000
 #define SCF_SENT_DELAYED_TAS			0x00040000
+#define SCF_ALUA_NON_OPTIMIZED			0x00080000
 
 /* se_device_t->type */
 #define PSCSI					1
@@ -210,6 +211,7 @@
 #define WRITE_PROTECTED				0xc
 #define CHECK_CONDITION_ABORT_CMD		0xd
 #define CHECK_CONDITION_UNIT_ATTENTION		0xe
+#define CHECK_CONDITION_NOT_READY		0xf
 
 typedef struct se_obj_s {
 	atomic_t obj_access_count;
@@ -221,14 +223,26 @@ typedef enum {
 	SPC3_ALUA_EMULATED
 } t10_alua_index_t;
 
+struct se_cmd_s;
+
 typedef struct t10_alua_s {
 	t10_alua_index_t alua_type;
+	/* ALUA Target Port Group ID */
+	u16	alua_tg_pt_gps_counter;
+	u32	alua_tg_pt_gps_count;
+	spinlock_t tg_pt_gps_lock;
+	struct se_subsystem_dev_s *t10_sub_dev;
+	/* Used for default ALUA Target Port Group */
+	struct t10_alua_tg_pt_gp_s *default_tg_pt_gp;
+	/* Used for default ALUA Target Port Group ConfigFS group */
+	struct config_group alua_tg_pt_gps_group;
+	int (*alua_state_check)(struct se_cmd_s *, unsigned char *, u8 *);
+	struct list_head tg_pt_gps_list;
 } ____cacheline_aligned t10_alua_t;
 
 typedef struct t10_alua_lu_gp_s {
 	u16	lu_gp_id;
 	int	lu_gp_valid_id;
-	int	lu_gp_alua_access_state;
 	u32	lu_gp_members;
 	atomic_t lu_gp_shutdown;
 	atomic_t lu_gp_ref_cnt;
@@ -240,6 +254,7 @@ typedef struct t10_alua_lu_gp_s {
 
 typedef struct t10_alua_lu_gp_member_s {
 	int lu_gp_assoc;
+	atomic_t lu_gp_mem_ref_cnt;
 	spinlock_t lu_gp_mem_lock;
 	t10_alua_lu_gp_t *lu_gp;
 	struct se_device_s *lu_gp_mem_dev;
@@ -250,9 +265,14 @@ typedef struct t10_alua_tg_pt_gp_s {
 	u16	tg_pt_gp_id;
 	int	tg_pt_gp_valid_id;
 	int	tg_pt_gp_alua_access_state;
+	int	tg_pt_gp_alua_access_status;
+	int	tg_pt_gp_alua_access_type;
+	int	tg_pt_gp_nonop_delay_msecs;
+	int	tg_pt_gp_pref;
 	u32	tg_pt_gp_members;
 	atomic_t tg_pt_gp_ref_cnt;
 	spinlock_t tg_pt_gp_lock;
+	struct se_subsystem_dev_s *tg_pt_gp_su_dev;
 	struct config_group tg_pt_gp_group;
 	struct list_head tg_pt_gp_list;
 	struct list_head tg_pt_gp_mem_list;
@@ -260,6 +280,7 @@ typedef struct t10_alua_tg_pt_gp_s {
 
 typedef struct t10_alua_tg_pt_gp_member_s {
 	int tg_pt_gp_assoc;
+	atomic_t tg_pt_gp_mem_ref_cnt;
 	spinlock_t tg_pt_gp_mem_lock;
 	t10_alua_tg_pt_gp_t *tg_pt_gp;
 	struct se_port_s *tg_pt;
@@ -293,8 +314,6 @@ typedef enum {
 	SPC3_PERSISTENT_RESERVATIONS
 } t10_reservations_index_t;
 
-struct se_cmd_s;
-
 typedef struct t10_pr_registration_s {
 	unsigned char pr_iport[PR_APTPL_MAX_IPORT_LEN]; /* Used during APTPL metadata reading */
 	unsigned char pr_tport[PR_APTPL_MAX_TPORT_LEN]; /* Used during APTPL metadata reading */
@@ -481,8 +500,12 @@ typedef struct se_unmap_sg_s {
 typedef struct se_cmd_s {
 	/* SAM response code being sent to initiator */
 	u8			scsi_status;
+	u8			scsi_asc;
+	u8			scsi_ascq;
 	u8			scsi_sense_reason;
 	u16			scsi_sense_length;
+	/* Delay for ALUA Active/NonOptimized state access in milliseconds */
+	int			alua_nonop_delay;
 	int			data_direction;
 	/* Transport protocol dependent state */
 	int			t_state;
@@ -646,6 +669,7 @@ typedef struct se_dev_entry_s {
 	se_lun_acl_t		*se_lun_acl;
 	spinlock_t		ua_lock;
 	struct se_lun_s		*se_lun;
+	struct list_head	alua_port_list;
 	struct list_head	ua_list;
 }  ____cacheline_aligned se_dev_entry_t;
 
@@ -688,7 +712,7 @@ typedef struct se_subsystem_dev_s {
 	struct se_device_s *se_dev_ptr;
 	se_dev_attrib_t se_dev_attrib;
 	se_dev_snap_attrib_t se_snap_attrib;
-	/* T10 Asymmetric Logical Unit Assignment Information */
+	/* T10 Asymmetric Logical Unit Assignment for Target Ports */
 	t10_alua_t	t10_alua;
 	/* T10 Inquiry and VPD WWN Information */
 	t10_wwn_t	t10_wwn;
@@ -748,6 +772,7 @@ typedef struct se_device_s {
 	se_queue_obj_t		*dev_status_queue_obj;
 	spinlock_t		execute_task_lock;
 	spinlock_t		state_task_lock;
+	spinlock_t		dev_alua_lock;
 	spinlock_t		dev_reservation_lock;
 	spinlock_t		dev_state_lock;
 	spinlock_t		dev_status_lock;
@@ -850,14 +875,19 @@ typedef struct se_lun_s {
 typedef struct se_port_s {
 	/* RELATIVE TARGET PORT IDENTIFER */
 	u16		sep_rtpi;
+	int		sep_tg_pt_secondary_stat;
 #ifdef SNMP_SUPPORT
 	u32		sep_index;
 	scsi_port_stats_t sep_stats;
 #endif
 	/* Used for ALUA Target Port Groups membership */
+	atomic_t	sep_tg_pt_gp_active;
+	atomic_t	sep_tg_pt_secondary_offline;
+	spinlock_t	sep_alua_lock;
 	struct t10_alua_tg_pt_gp_member_s *sep_alua_tg_pt_gp_mem;
 	struct se_lun_s *sep_lun;
 	struct se_portal_group_s *sep_tpg;
+	struct list_head sep_alua_list;
 	struct list_head sep_list;
 } ____cacheline_aligned se_port_t;
 
@@ -888,28 +918,22 @@ typedef struct se_portal_group_s {
 
 typedef struct se_global_s {
 	u16			alua_lu_gps_counter;
-	u16			alua_tg_pt_gps_counter;
 	u32			in_shutdown;
 	u32			alua_lu_gps_count;
-	u32			alua_tg_pt_gps_count;
 	u32			g_hba_id_counter;
 	struct config_group	target_core_hbagroup;
 	struct config_group	alua_group;
 	struct config_group	alua_lu_gps_group;
-	struct config_group	alua_tg_pt_gps_group;
 	struct list_head	g_lu_gps_list;
-	struct list_head	g_tg_pt_gps_list;
 	struct list_head	g_se_tpg_list;
 	struct list_head	g_hba_list;
 	struct list_head	g_se_dev_list;
 	struct se_plugin_class_s *plugin_class_list;
 	t10_alua_lu_gp_t	*default_lu_gp;
-	t10_alua_tg_pt_gp_t	*default_tg_pt_gp;
 	spinlock_t		g_device_lock;
 	spinlock_t		hba_lock;
 	spinlock_t		se_tpg_lock;
 	spinlock_t		lu_gps_lock;
-	spinlock_t		tg_pt_gps_lock;
 	spinlock_t		plugin_class_lock;
 #ifdef DEBUG_DEV
 	spinlock_t		debug_dev_lock;
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index fb3dc21..ab84a7c 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -235,6 +235,8 @@ extern int transport_generic_remove(se_cmd_t *, int, int);
 extern int transport_lun_wait_for_tasks(se_cmd_t *, se_lun_t *);
 extern void transport_clear_lun_from_sessions(se_lun_t *);
 extern int transport_check_aborted_status(se_cmd_t *, int);
+extern int transport_get_sense_codes(se_cmd_t *, u8 *, u8 *);
+extern int transport_set_sense_codes(se_cmd_t *, u8, u8);
 extern int transport_send_check_condition_and_sense(se_cmd_t *, u8, int);
 extern void transport_send_task_abort(struct se_cmd_s *);
 extern void transport_release_cmd_to_pool(se_cmd_t *);
-- 
1.5.4.1



