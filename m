From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/2] [Target_Core_Mod/Persistent_Reservations]: Add Specify
	Initiator Port Capable (SPEC_I_PT=1) support
Date: Sat, 08 Aug 2009 21:56:10 -0700
Message-ID: <1249793770.11105.235.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:47387 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751193AbZHIE4O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Aug 2009 00:56:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, James Smart <James.Smart@Emulex.Com>, Philipp Reisner <philipp.reisner@linbit.com>

Hello,

This patch adds exhaustive support for handling SPEC_I_PT=1 processing of fabric dependent
TransportIDs in PROUT SA REGISTER ops containing SCSI Initiator port/device identifiers as
defined by spc4r17.

The function core_scsi3_decode_spec_i_port() has been added and does atomic PROUT SA REGISTER
processing for fabric dependent TransportIDs using the newly provided __core_scsi3_alloc_registration()
and __core_scsi3_add_registration() using two loops and new structure named struct pr_transport_id_holder
for tracking TransportIDs.    core_scsi3_decode_spec_i_port() then uses a local scope struct list_head
tid_dest_list for doing the atomic PR registraton part.

This reason for this is because all SPEC_I_PT=1 Initiator Port registrations MUST be done atomically,
eg: either *ALL* TransportIDs perform their PR registrations successfully, or we need to fail without
making *ANY* registrations.  The original core_scsi3_alloc_registration() function now becomes a call
of both __core_scsi3_alloc_registration() and __core_scsi3_add_registration(), but keeps the same
function parameters as befre.

This patch also uses configfs_depend_item() for reference counting when accessing the remote
Initiator Port's data structures within target_core_mod, and are released with configfs_undepend_item()
after all calling __core_scsi3_add_registration() for a successfuly SPEC_I_PT=1 operation, or during
an exception condition.  This patch also updates a parameter in the function pointer
struct target_core_fabric_ops->tpg_parse_pr_out_transport_id() to return the fabric dependent
TransportID extracted length of passed identifier which is used by the first loop in
core_scsi3_decode_spec_i_port() how far to skip ahead to the next Transport ID.

This patch also updates core_scsi3_pri_report_capabilities() to return SIP_C: Specify
Initiator Ports Capable bit enabled, and adds a extra strict parameter list length check
in core_scsi3_emulate_pr_out() releated to non 24-byte PROUT Parameter list lengths that is
explictly mentioned in spc4r17.

Here is what it looks like in action doing a PROUT SA REGISTER with SPEC_I_PT: from a
local initiator port (debian) for a remote initiator port (opensuse) using sg_persist
from an Open-iSCSI Initiator:

	initiator# sg_persist -vvv --out --device /dev/sde --register --param-rk=0 --param-sark=0x1234ffff -T 5 -X  05,0,33,32,69,71,6E,2E,31,39,39,36,2D,30,34,2E,64,65,2E,73,75,73,65,3A,30,31,3A,31,36,36,31,66,39,65,65,37,62,35,00
	number of tranport-ids decoded from command line (or stdin): 1
	  Decode given transport-ids:
	      Transport Id of initiator:
	        iSCSI name: iqn.1996-04.de.suse:01:1661f9ee7b5
	open /dev/sde with flags=0x800
	    inquiry cdb: 12 00 00 00 24 00
	      duration=4 ms
	  LIO-ORG  IBLOCK  3.0
	  Peripheral device type: disk
	open /dev/sde with flags=0x802
	    Persistent Reservation Out cmd: 5f 00 05 00 00 00 00 00 44 00
	    Persistent Reservation Out parameters:
	 00     00 00 00 00 00 00 00 00  00 00 00 00 12 34 ff ff    .............4..
	 10     00 00 00 00 08 00 00 00  00 00 00 28 05 00 33 32    ...........(..32
	 20     69 71 6e 2e 31 39 39 36  2d 30 34 2e 64 65 2e 73    iqn.1996-04.de.s
	 30     75 73 65 3a 30 31 3a 31  36 36 31 66 39 65 65 37    use:01:1661f9ee7
	 40     62 35 00 00                                         b5..
	      duration=12 ms
	PR out: command (Register) successful

the TCM kernel buffer messages:

	LIO-Target Extracted add_len: 54 does not match calculated tid_len: 40, using tid_len instead
	SPC-3 PR [iSCSI] Service Action: REGISTER Initiator Node: iqn.1993-08.org.debian:01:2dadf92d0ef
	SPC-3 PR [iSCSI] for SINGLE TCM Subsystem iblock Object Target Port(s)
	SPC-3 PR [iSCSI] SA Res Key: 0x000000001234ffff PRgeneration: 0x00000000
	SPC-3 PR [iSCSI] SPEC_I_PT: Successfully registered Transport ID for Node: iqn.1993-08.org.debian:01:2dadf92d0ef Mapped LUN: 0
	SPC-3 PR [iSCSI] Service Action: REGISTER Initiator Node: iqn.1996-04.de.suse:01:1661f9ee7b5
	SPC-3 PR [iSCSI] for SINGLE TCM Subsystem iblock Object Target Port(s)
	SPC-3 PR [iSCSI] SA Res Key: 0x000000001234ffff PRgeneration: 0x00000001
	SPC-3 PR [iSCSI] SPEC_I_PT: Successfully registered Transport ID for Node: iqn.1996-04.de.suse:01:1661f9ee7b5 Mapped LUN: 0

and from the tcm_node --pr CLI op:

	initiator# tcm_node --pr iblock_0/lvm_test0
	No SPC-3 Reservation holder
	No SPC-3 Reservation holder
	0x00000002
	No SPC-3 Reservation holder
	SPC-3 PR Registrations:
	iSCSI Node: iqn.1993-08.org.debian:01:2dadf92d0ef Key: 0x000000001234ffff PRgen: 0x00000000
	iSCSI Node: iqn.1996-04.de.suse:01:1661f9ee7b5 Key: 0x000000001234ffff PRgen: 0x00000001
	No SPC-3 Reservation holder
	SPC3_PERSISTENT_RESERVATIONS

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_pr.c         |  445 +++++++++++++++++++++++++++++--
 include/target/target_core_fabric_ops.h |    2 +-
 2 files changed, 422 insertions(+), 25 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 7a0857a..1d345c6 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -30,6 +30,7 @@
 #include <linux/version.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
+#include <linux/list.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 
@@ -47,8 +48,19 @@
 
 #undef TARGET_CORE_PR_C
 
+/*
+ * Used for Specify Initiator Ports Capable Bit (SPEC_I_PT)
+ */
+struct pr_transport_id_holder {
+	int dest_local_nexus;
+	struct t10_pr_registration_s *dest_pr_reg;
+	struct se_node_acl_s *dest_node_acl;
+	struct se_dev_entry_s *dest_se_deve;
+	struct list_head dest_list;
+};
+
 static void __core_scsi3_complete_pro_release(se_device_t *, se_node_acl_t *,
-			t10_pr_registration_t *g, int);
+			t10_pr_registration_t *, int);
 
 int core_scsi2_reservation_seq_non_holder(
 	se_cmd_t *cmd,
@@ -466,28 +478,19 @@ static int core_scsi3_legacy_release(se_cmd_t *cmd)
 	return core_scsi2_reservation_release(cmd);
 }
 
-/*
- * this function can be called with se_device_t->dev_reservation_lock
- * when register_move = 1
- */
-static int core_scsi3_alloc_registration(
+static t10_pr_registration_t *__core_scsi3_alloc_registration(
 	se_device_t *dev,
 	se_node_acl_t *nacl,
 	se_dev_entry_t *deve,
 	u64 sa_res_key,
-	int all_tg_pt,
-	int register_type,
-	int register_move)
+	int all_tg_pt)
 {
-	se_subsystem_dev_t *su_dev = SU_DEV(dev);
-	struct target_core_fabric_ops *tfo = nacl->se_tpg->se_tpg_tfo;
-	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
 	t10_pr_registration_t *pr_reg;
 
 	pr_reg = kmem_cache_zalloc(t10_pr_reg_cache, GFP_ATOMIC);
 	if (!(pr_reg)) {
 		printk(KERN_ERR "Unable to allocate t10_pr_registration_t\n");
-		return -1;
+		return NULL;
 	}
 
 	INIT_LIST_HEAD(&pr_reg->pr_reg_list);
@@ -500,6 +503,24 @@ static int core_scsi3_alloc_registration(
 	pr_reg->pr_reg_all_tg_pt = all_tg_pt;
 	pr_reg->pr_reg_tg_pt_lun = deve->se_lun;
 
+	return pr_reg;
+}
+
+/*
+ * this function can be called with se_device_t->dev_reservation_lock
+ * when register_move = 1
+ */
+static void __core_scsi3_add_registration(
+	se_device_t *dev,
+	se_node_acl_t *nacl,
+	t10_pr_registration_t *pr_reg,
+	int register_type,
+	int register_move)
+{
+	se_subsystem_dev_t *su_dev = SU_DEV(dev);
+	struct target_core_fabric_ops *tfo = nacl->se_tpg->se_tpg_tfo;
+	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
+
 	/*
 	 * Increment PRgeneration counter for se_device_t upon a successful
 	 * REGISTER, see spc4r17 section 6.3.2 READ_KEYS service action
@@ -515,8 +536,7 @@ static int core_scsi3_alloc_registration(
 
 	spin_lock(&pr_tmpl->registration_lock);
 	list_add_tail(&pr_reg->pr_reg_list, &pr_tmpl->registration_list);
-	deve->deve_flags |= DEF_PR_REGISTERED;
-	deve->pr_res_key = sa_res_key;
+	pr_reg->pr_reg_deve->deve_flags |= DEF_PR_REGISTERED;
 
 	printk(KERN_INFO "SPC-3 PR [%s] Service Action: REGISTER%s Initiator"
 		" Node: %s\n", tfo->get_fabric_name(), (register_type == 2) ?
@@ -531,9 +551,30 @@ static int core_scsi3_alloc_registration(
 		pr_reg->pr_res_generation);
 	spin_unlock(&pr_tmpl->registration_lock);
 
-	return 0;
+	return;
 }
 
+static int core_scsi3_alloc_registration(
+	se_device_t *dev,
+	se_node_acl_t *nacl,
+	se_dev_entry_t *deve,
+	u64 sa_res_key,
+	int all_tg_pt,
+	int register_type,
+	int register_move)
+{
+	t10_pr_registration_t *pr_reg;
+
+	pr_reg = __core_scsi3_alloc_registration(dev, nacl, deve,
+			sa_res_key, all_tg_pt);
+	if (!(pr_reg))
+		return -1;
+
+	__core_scsi3_add_registration(dev, nacl, pr_reg,
+			register_type, register_move);
+	return 0;
+}	
+
 static t10_pr_registration_t *core_scsi3_locate_pr_reg(
 	se_device_t *dev,
 	se_node_acl_t *nacl)
@@ -710,6 +751,337 @@ void core_scsi3_free_all_registrations(
 	spin_unlock(&pr_tmpl->registration_lock);
 }
 
+static int core_scsi3_decode_spec_i_port(
+	se_cmd_t *cmd,
+	se_portal_group_t *tpg,
+	u64 sa_res_key,
+	int all_tg_pt)
+{
+	se_lun_t *lun = SE_LUN(cmd);
+	se_port_t *port = lun->lun_sep;
+	se_session_t *se_sess = SE_SESS(cmd);
+	se_node_acl_t *dest_node_acl;
+	se_dev_entry_t *dest_se_deve = NULL, *local_se_deve;
+	t10_pr_registration_t *dest_pr_reg, *local_pr_reg;
+	struct list_head tid_dest_list;
+	struct pr_transport_id_holder *tidh_new, *tidh, *tidh_tmp;
+	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
+	unsigned char *ptr, *i_str = NULL;
+	char *iport_ptr = NULL, dest_iport[64];
+	u32 tpdl, tid_len = 0;
+	int ret, dest_local_nexus;
+
+	memset(dest_iport, 0, 64);
+	INIT_LIST_HEAD(&tid_dest_list);
+
+	local_se_deve = &se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
+	/*
+	 * Allocate a struct pr_transport_id_holder and setup the
+	 * local_node_acl and local_se_deve pointers and add to
+	 * struct list_head tid_dest_list for add registration
+	 * processing in the loop of tid_dest_list below.
+	 */
+	tidh_new = kzalloc(sizeof(struct pr_transport_id_holder),
+                                GFP_KERNEL);
+	if (!(tidh_new)) {
+		printk(KERN_ERR "Unable to allocate tidh_new\n");
+		return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	}
+	INIT_LIST_HEAD(&tidh_new->dest_list);
+	tidh_new->dest_node_acl = se_sess->se_node_acl;
+	tidh_new->dest_se_deve = local_se_deve;
+
+	local_pr_reg = __core_scsi3_alloc_registration(SE_DEV(cmd),
+                                se_sess->se_node_acl, local_se_deve,
+                                sa_res_key, all_tg_pt);
+	if (!(local_pr_reg)) {
+		kfree(tidh_new);
+		return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	}
+	tidh_new->dest_pr_reg = local_pr_reg;
+	/*
+	 * The local I_T nexus does not hold any configfs dependances,
+	 * so we set tid_h->dest_local_nexus=1 to prevent the
+	 * configfs_undepend_item() calls in the tid_dest_list loops below.
+	 */
+	tidh_new->dest_local_nexus = 1;
+	list_add_tail(&tidh_new->dest_list, &tid_dest_list);
+	/*
+	 * For a PERSISTENT RESERVE OUT specify initiator ports payload,
+	 * first extract TransportID Parameter Data Length, and make sure
+	 * the value matches up to the SCSI expected data transfer length.
+	 */
+	tpdl = (buf[24] & 0xff) << 24;
+	tpdl |= (buf[25] & 0xff) << 16;
+	tpdl |= (buf[26] & 0xff) << 8;
+	tpdl |= buf[27] & 0xff;
+
+	if ((tpdl + 28) != cmd->data_length) {
+		printk(KERN_ERR "SPC-3 PR: Illegal tpdl: %u + 28 byte header"
+			" does not equal CDB data_length: %u\n", tpdl,
+			cmd->data_length);
+		return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+	}
+	/*
+	 * struct target_fabric_core_ops->tpg_parse_pr_out_transport_id()
+	 * must exist to parse the fabric dependent transport IDs.
+	 */
+	if (TPG_TFO(tpg)->tpg_parse_pr_out_transport_id == NULL) {
+		printk(KERN_ERR "SPC-3 SPEC_I_PT: Fabric does not"
+			" containing a valid tpg_parse_pr_out_transport_id"
+			" function pointer\n");
+		return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	}
+	/*
+	 * Start processing the received transport IDs using the
+	 * receiving I_T Nexus portal's fabric dependent methods to
+	 * obtain the SCSI Initiator Port/Device Identifiers.
+	 */
+	ptr = &buf[28];
+
+	while (tpdl > 0) {
+		i_str = TPG_TFO(tpg)->tpg_parse_pr_out_transport_id(
+					(const char *)ptr, &tid_len,
+					&iport_ptr);
+		if (!(i_str)) {
+			printk(KERN_ERR "SPC-3 PR SPEC_I_PT: Unable to locate"
+				" i_str from Transport ID\n");
+			ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+			goto out;
+		}
+#if 0
+		printk("SPC-3 PR SPEC_I_PT: Got %s data_length: %u tpdl: %u"
+			" tid_len: %d for %s + %s\n",
+			TPG_TFO(tpg)->get_fabric_name(), cmd->data_length,
+			tpdl, tid_len, i_str, iport_ptr);
+#endif
+		if (tid_len > tpdl) {
+			printk(KERN_ERR "SPC-3 PR SPEC_I_PT: Illegal tid_len: %u"
+				" for Transport ID: %s\n", tid_len, ptr);
+			ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+			goto out;
+		}
+		/*
+		 * Locate the desination initiator ACL to be registered.		
+		 */
+		dest_node_acl = core_tpg_get_initiator_node_acl(tpg, i_str);
+		if (!(dest_node_acl)) {
+			printk(KERN_ERR "Unable to locate %s dest_node_acl"
+				" for TransportID: %s %s\n",
+				TPG_TFO(tpg)->get_fabric_name(),
+				i_str, (iport_ptr != NULL) ? iport_ptr : "");
+			ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+			goto out;
+		}
+
+		ret = configfs_depend_item(TPG_TFO(tpg)->tf_subsys,
+				&dest_node_acl->acl_group.cg_item);
+		if (ret != 0) {
+			printk(KERN_ERR "configfs_depend_item() failed for"
+				" dest_node_acl->acl_group\n");
+			ret = PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+			goto out;
+		}
+		/*
+		 * If the a SCSI Initiator Port identifier is presented, then
+		 * the SCSI nexus must be present and matching the provided
+		 * TransportID.  The active se_session_t pointer is available
+		 * from dest_node_acl->nacl_sess;
+		 */
+		if (iport_ptr != NULL) {
+			spin_lock(&dest_node_acl->nacl_sess_lock);
+			if (dest_node_acl->nacl_sess == NULL) {
+				printk(KERN_ERR "SPC-3 SPEC_I_PT: iport_ptr: %s"
+					" presented in Transport ID, but no "
+					" active nexus exists for %s Fabric"
+					" Node: %s\n", iport_ptr,
+					TPG_TFO(tpg)->get_fabric_name(),
+					dest_node_acl->initiatorname);
+				spin_unlock(&dest_node_acl->nacl_sess_lock);
+
+				configfs_undepend_item(TPG_TFO(tpg)->tf_subsys,
+					&dest_node_acl->acl_group.cg_item);
+
+				ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+				goto out;
+			}
+			TPG_TFO(tpg)->sess_get_initiator_wwn(
+					dest_node_acl->nacl_sess,
+					&dest_iport[0], 64);	
+			spin_unlock(&dest_node_acl->nacl_sess_lock);
+			
+			if (strcmp(dest_iport, iport_ptr)) {
+				printk(KERN_ERR "SPC-3 SPEC_I_PT: dest_iport:"
+					" %s and iport_ptr: %s do not match!\n",
+					dest_iport, iport_ptr);
+
+				configfs_undepend_item(TPG_TFO(tpg)->tf_subsys,
+					&dest_node_acl->acl_group.cg_item);
+
+				ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+				goto out;	
+			}
+		}
+		/*
+		 * Locate the desintation se_dev_entry_t pointer for the matching
+		 * RELATIVE TARGET PORT IDENTIFIER on the receiving I_T Nexus
+		 * Target Port.
+		 *
+		 * Note that core_get_se_deve_from_rtpi() will call
+		 * configfs_item_depend() on deve->se_lun_acl->se_lun_group.cg_item.
+		 */
+		dest_se_deve = core_get_se_deve_from_rtpi(dest_node_acl,
+					port->sep_rtpi);
+		if (!(dest_se_deve)) {
+			printk(KERN_ERR "Unable to locate %s dest_se_deve"
+				" from local RTPI: %hu\n",
+				TPG_TFO(tpg)->get_fabric_name(),
+				port->sep_rtpi);
+
+			configfs_undepend_item(TPG_TFO(tpg)->tf_subsys,
+				&dest_node_acl->acl_group.cg_item);
+			
+			ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+			goto out;
+		}
+#if 0
+		printk(KERN_INFO "SPC-3 PR SPEC_I_PT: Located %s Node: %s"
+			" dest_se_deve mapped_lun: %u\n",
+			TPG_TFO(tpg)->get_fabric_name(),
+			dest_node_acl->initiatorname, dest_se_deve->mapped_lun);
+#endif
+		/*
+		 * Skip any TransportIDs that already have a registration for
+		 * this target port.
+		 */
+		if (dest_se_deve->deve_flags & DEF_PR_REGISTERED) {
+			configfs_undepend_item(TPG_TFO(tpg)->tf_subsys,
+				&dest_se_deve->se_lun_acl->se_lun_group.cg_item);
+			configfs_undepend_item(TPG_TFO(tpg)->tf_subsys,
+				&dest_node_acl->acl_group.cg_item);
+			ptr += tid_len;
+			tpdl -= tid_len;
+			tid_len = 0;
+		}
+		/*
+		 * Allocate a struct pr_transport_id_holder and setup
+		 * the dest_node_acl and dest_se_deve pointers for the
+		 * loop below.
+		 */
+		tidh_new = kzalloc(sizeof(struct pr_transport_id_holder),
+				GFP_KERNEL);
+		if (!(tidh_new)) {
+			printk(KERN_ERR "Unable to allocate tidh_new\n");
+			ret = PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+			goto out;
+		}
+		INIT_LIST_HEAD(&tidh_new->dest_list);
+		tidh_new->dest_node_acl = dest_node_acl;
+		tidh_new->dest_se_deve = dest_se_deve;
+
+		/*
+		 * Allocate, but do NOT add the registration for the
+		 * TransportID referenced SCSI Initiator port.  This
+		 * done because of the following from spc4r17 in section
+		 * 6.14.3 wrt SPEC_I_PT:
+		 *
+		 * "If a registration fails for any initiator port (e.g., if th
+		 * logical unit does not have enough resources available to
+		 * hold the registration information), no registrations shall be
+		 * made, and the command shall be terminated with
+		 * CHECK CONDITION status."
+		 *
+		 * That means we call __core_scsi3_alloc_registration() here,
+		 * and then call __core_scsi3_add_registration() in the
+		 * 2nd loop which will never fail.
+		 */
+		dest_pr_reg = __core_scsi3_alloc_registration(SE_DEV(cmd),
+				dest_node_acl, dest_se_deve,
+				sa_res_key, all_tg_pt);
+		if (!(dest_pr_reg)) { 
+			configfs_undepend_item(TPG_TFO(tpg)->tf_subsys,
+				&dest_se_deve->se_lun_acl->se_lun_group.cg_item);
+			configfs_undepend_item(TPG_TFO(tpg)->tf_subsys,
+				&dest_node_acl->acl_group.cg_item);
+			ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+			goto out;
+		}
+		tidh_new->dest_pr_reg = dest_pr_reg;
+		list_add_tail(&tidh_new->dest_list, &tid_dest_list);
+
+		ptr += tid_len;
+		tpdl -= tid_len;
+		tid_len = 0;
+
+	}
+	/*
+	 * Go ahead and create a registrations from tid_dest_list for the
+	 * SPEC_I_PT provided TransportID for the *tidh referenced dest_node_acl
+	 * and dest_se_deve.
+	 *
+	 * The SA Reservation Key from the PROUT is set for the
+	 * registration, and ALL_TG_PT is also passed.  ALL_TG_PT=1
+	 * means that the TransportID Initiator port will be
+	 * registered on all of the target ports in the SCSI target device
+	 * ALL_TG_PT=0 means the registration will only be for the
+	 * SCSI target port the PROUT REGISTER with SPEC_I_PT=1
+	 * was received.
+	 */
+	list_for_each_entry_safe(tidh, tidh_tmp, &tid_dest_list, dest_list) {
+		dest_node_acl = tidh->dest_node_acl;
+		dest_se_deve = tidh->dest_se_deve;
+		dest_pr_reg = tidh->dest_pr_reg;
+		dest_local_nexus = tidh->dest_local_nexus;
+
+		list_del(&tidh->dest_list);
+		kfree(tidh);
+
+		__core_scsi3_add_registration(SE_DEV(cmd), dest_node_acl,
+					dest_pr_reg, 0, 0);
+
+		printk(KERN_INFO "SPC-3 PR [%s] SPEC_I_PT: Successfully"
+			" registered Transport ID for Node: %s Mapped LUN:"
+			" %u\n", TPG_TFO(tpg)->get_fabric_name(),
+				dest_node_acl->initiatorname,
+				dest_se_deve->mapped_lun);
+
+		if (dest_local_nexus)
+			continue;
+
+		configfs_undepend_item(TPG_TFO(tpg)->tf_subsys,
+			&dest_se_deve->se_lun_acl->se_lun_group.cg_item);
+		configfs_undepend_item(TPG_TFO(tpg)->tf_subsys,
+			&dest_node_acl->acl_group.cg_item);		
+	}
+
+	return 0;
+out:
+	/*
+	 * For the failure case, release everything from tid_dest_list
+	 * including *dest_pr_reg and the configfs dependances..
+	 */
+	list_for_each_entry_safe(tidh, tidh_tmp, &tid_dest_list, dest_list) {
+		dest_node_acl = tidh->dest_node_acl;
+		dest_se_deve = tidh->dest_se_deve;
+		dest_pr_reg = tidh->dest_pr_reg;
+		dest_local_nexus = tidh->dest_local_nexus;
+		
+		list_del(&tidh->dest_list);
+		kfree(tidh);
+
+		kmem_cache_free(t10_pr_reg_cache, dest_pr_reg);		
+		
+		if (dest_local_nexus)
+			continue;
+
+		configfs_undepend_item(TPG_TFO(tpg)->tf_subsys,
+			&dest_se_deve->se_lun_acl->se_lun_group.cg_item);
+		configfs_undepend_item(TPG_TFO(tpg)->tf_subsys,
+			&dest_node_acl->acl_group.cg_item);
+	}
+	return ret;	
+}
+
 static int core_scsi3_emulate_pro_register(
 	se_cmd_t *cmd,
 	u64 res_key,
@@ -771,13 +1143,17 @@ static int core_scsi3_emulate_pro_register(
 			}
 		} else {
 			/*
-			 * FIXME: Extract SCSI TransportID from Parameter list
-			 * and loop through parameter list while calling logic
-			 * from of core_scsi3_alloc_registration()
+			 * Register both the Initiator port that received
+			 * PROUT SA REGISTER + SPEC_I_PT=1 and extract SCSI
+			 * TransportID from Parameter list and loop through
+			 * fabric dependent parameter list while calling
+			 * logic from of core_scsi3_alloc_registration() for each
+			 * TransportID provided SCSI Initiator Port/Device
 			 */
-			printk("Specify Initiator Ports (SPEC_I_PT) = 1 not"
-					" implemented yet\n");
-			return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+			ret = core_scsi3_decode_spec_i_port(cmd, se_tpg,
+						sa_res_key, all_tg_pt);
+			if (ret != 0)
+				return ret;
 		}
 	} else {
 		/*
@@ -1875,7 +2251,13 @@ static int core_scsi3_emulate_pro_register_and_move(
 		goto out;
 	}
 	initiator_str = dest_tf_ops->tpg_parse_pr_out_transport_id(
-			(const char *)&buf[24], tid_len, &iport_ptr);
+			(const char *)&buf[24], NULL, &iport_ptr);
+	if (!(initiator_str)) {
+		printk(KERN_ERR "SPC-3 PR REGISTER_AND_MOVE: Unable to locate"
+			" initiator_str from Transport ID\n");
+		ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+		goto out;
+	}
 
 	printk(KERN_INFO "SPC-3 PR [%s] Extracted initiator %s identifier: %s"
 		" %s\n", dest_tf_ops->get_fabric_name(), (iport_ptr != NULL) ?
@@ -2194,6 +2576,21 @@ static int core_scsi3_emulate_pr_out(se_cmd_t *cmd, unsigned char *cdb)
 	if (spec_i_pt && ((cdb[1] & 0x1f) != PRO_REGISTER))
 		return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 	/*
+	 * From spc4r17 section 6.14:
+	 *
+	 * If the SPEC_I_PT bit is set to zero, the service action is not
+	 * REGISTER AND MOVE, and the parameter list length is not 24, then
+	 * the command shall be terminated with CHECK CONDITION status, with
+	 * the sense key set to ILLEGAL REQUEST, and the additional sense
+	 * code set to PARAMETER LIST LENGTH ERROR.
+	 */
+	if (!(spec_i_pt) && ((cdb[1] & 0x1f) != PRO_REGISTER_AND_MOVE) &&
+	    (cmd->data_length != 24)) {
+		printk(KERN_WARNING "SPC-PR: Recieved PR OUT illegal parameter"
+			" list length: %u\n", cmd->data_length);
+		return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+	}
+	/*
 	 * (core_scsi3_emulate_pro_* function parameters
 	 * are defined by spc4r17 Table 174:
 	 * PERSISTENT_RESERVE_OUT service actions and valid parameters.
@@ -2390,8 +2787,8 @@ static int core_scsi3_pri_report_capabilities(se_cmd_t *cmd)
 	 */
 #if 0
 	buf[2] |= 0x10; /* CRH: Compatible Reservation Hanlding bit. */
-	buf[2] |= 0x08; /* SIP_C: Specify Initiator Ports Capable bit */
 #endif
+	buf[2] |= 0x08; /* SIP_C: Specify Initiator Ports Capable bit */
 	buf[2] |= 0x04; /* ATP_C: All Target Ports Capable bit */
 #if 0
 	buf[2] |= 0x01; /* PTPL_C: Persistence across Target Power Loss bit */
diff --git a/include/target/target_core_fabric_ops.h b/include/target/target_core_fabric_ops.h
index 35c4bf9..b23a860 100644
--- a/include/target/target_core_fabric_ops.h
+++ b/include/target/target_core_fabric_ops.h
@@ -9,7 +9,7 @@ struct target_core_fabric_ops {
 				struct se_node_acl_s *, int *, unsigned char *);
 	u32 (*tpg_get_pr_transport_id_len)(struct se_portal_group_s *,
 				struct se_node_acl_s *, int *);
-	char *(*tpg_parse_pr_out_transport_id)(const char *, u32, char **);
+	char *(*tpg_parse_pr_out_transport_id)(const char *, u32 *, char **);
 	int (*tpg_check_demo_mode)(struct se_portal_group_s *);
 	int (*tpg_check_demo_mode_cache)(struct se_portal_group_s *);
 	int (*tpg_check_demo_mode_write_protect)(struct se_portal_group_s *);
-- 
1.5.4.1



