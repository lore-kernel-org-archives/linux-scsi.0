From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod/Persistent_Reservations]: Add PROUT SA
	REGISTER_AND_MOVE support
Date: Tue, 04 Aug 2009 02:57:46 -0700
Message-ID: <1249379866.11105.91.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:43819 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932671AbZHDKE2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2009 06:04:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Joel Becker <joel.becker@oracle.com>, James Smart <James.Smart@Emulex.Com>, Philipp Reisner <philipp.reisner@linbit.com>

Greetings SCSI, cluster and configFS folks,

Below is a patch for PROUT REGISTER_AND_MOVE that I have been successfully testing with
sg_persist on Linux cluster clients.   I will be posting the target_core_mod/configFS code again for
review, so and I would apperciate any comments as this PR service action (or any of the PR code)
and this completes the final PROUT service action as defined by spc4r17.  This code has been
tested on lio-core-2.6.git/drivers/target code on v2.6.30, and I will be jumping to v2.6.31 very soon.

A huge thanks again to the sg_utils package for bringing all of the logic up,
thanks Doug!

Many thanks for your most valuable of time,

--nab

This patch adds exhaustive support for spc4r17 defined PROUT Service Action REGISTER_AND_MOVE
to the target_core_mod generic target engine in lio-core-2.6.git/drivers/target.  It adds complete
support for SCSI Initiator Device and Port Transport IDs in a fabric module independent manner
that uses configfs_depend_item() and configfs_undepend_item() from a target_core_mod registered fabric
module to access the struct configfs_subsystem group from struct target_core_fabric_ops->tf_subsys.

It also adds updates core_scsi3_emulate_pr_out() and core_scsi3_alloc_registration()
for handling the REGISTER_AND_MOVE parameter list and registration process to use existing
code in target_core_pr.c.

So far, the code has been tested on v2.6.30 in x86 HVM against two Open-iSCSI Initiators using
sg_persist --register-move for doing the reservation move using both iSCSI Initiator
device identifier (IQN) and iSCSI Initiator Port identifier (IQN+ISID).

Here is what it looks like in action with iSCSI Initiator Port TransportIDs.  On the first node,
(debian vm) the initial registration and reservation is created, and REGISTER_AND_MOVE happens..

debian# sg_persist --out --device /dev/sde --register --param-rk=0 --param-sark=0x1234  LIO-ORG  IBLOCK  3.0
  Peripheral device type: disk
debian# sg_persist --out --reserve -d /dev/sde --param-rk=0x1234 -T 5  LIO-ORG  IBLOCK  3.0
  Peripheral device type: disk
debian# sg_persist -vvv --out --register-move --relative-target-port 2 -d /dev/sde --param-rk=0x1234 --param-sark=0x5678ffff -X 45,0,0,34,69,71,6E,2E,31,39,39,36,2D,30,34,2E,64,65,2E,73,75,73,65,3A,30,31,3A,31,36,36,31,66,39,65,65,37,62,35,2C,69,2C,30,78,30,30,30,32,33,44,30,32,30,30,30,30,00
number of tranport-ids decoded from command line (or stdin): 1
  Decode given transport-ids:
      Transport Id of initiator:
        iSCSI world wide unique port id: iqn.1996-04.de.suse:01:1661f9ee7b5,i,0x00023D020000
open /dev/sde with flags=0x800
    inquiry cdb: 12 00 00 00 24 00
      duration=4 ms
  LIO-ORG  IBLOCK  3.0
  Peripheral device type: disk
open /dev/sde with flags=0x802
    Persistent Reservation Out cmd: 5f 07 00 00 00 00 00 00 50 00
    Persistent Reservation Out parameters:
 00     00 00 00 00 00 00 12 34  00 00 00 00 56 78 ff ff    .......4....Vx..
 10     00 00 00 02 00 00 00 38  45 00 00 34 69 71 6e 2e    .......8E..4iqn.
 20     31 39 39 36 2d 30 34 2e  64 65 2e 73 75 73 65 3a    1996-04.de.suse:
 30     30 31 3a 31 36 36 31 66  39 65 65 37 62 35 2c 69    01:1661f9ee7b5,i
 40     2c 30 78 30 30 30 32 33  44 30 32 30 30 30 30 00    ,0x00023D020000.
      duration=8 ms
PR out: 'register and move' command successful

and to REGISTER_AND_MOVE again back debian vm so reinstate the original reservation for the first
node from the second node (opensuse vm)

opensuse:~# sg_persist -vvv --out --register-move --relative-target-port 2 -d /dev/sdc --param-rk=0x5678ffff --param-sark=0x9999abcd -X 45,0,0,34,69,71,6E,2E,31,39,39,33,2D,30,38,2E,6F,72,67,2E,64,65,62,69,61,6E,3A,30,31,3A,32,64,61,64,66,39,32,64,30,65,66,2C,69,2C,30,78,30,30,30,32,33,44,30,31,30,30,30,30,00
number of tranport-ids decoded from command line (or stdin): 1
  Decode given transport-ids:
      Transport Id of initiator:
        iSCSI world wide unique port id: iqn.1993-08.org.debian:01:2dadf92d0ef,i,0x00023D0100
      Transport Id of initiator:
        FCP-2 World Wide Name:
 00     00 00 00 00 00 00 00 00                             ........
open /dev/sdc with flags=0x800
    inquiry cdb: 12 00 00 00 24 00
      duration=0 ms
  LIO-ORG  IBLOCK  3.0
  Peripheral device type: disk
open /dev/sdc with flags=0x802
    Persistent Reservation Out cmd: 5f 07 00 00 00 00 00 00 54 00
    Persistent Reservation Out parameters:
 00     00 00 00 00 56 78 ff ff  00 00 00 00 99 99 ab cd    ....Vx..........
 10     00 00 00 02 00 00 00 3c  45 00 00 34 69 71 6e 2e    .......<E..4iqn.
 20     31 39 39 33 2d 30 38 2e  6f 72 67 2e 64 65 62 69    1993-08.org.debi
 30     61 6e 3a 30 31 3a 32 64  61 64 66 39 32 64 30 65    an:01:2dadf92d0e
 40     66 2c 69 2c 30 78 30 30  30 32 33 44 30 31 30 30    f,i,0x00023D0100
 50     30 30 00 00                                         00..
      duration=4 ms
PR out: 'register and move' command successful

and what sg_persist --read-status output looks like:

debian# sg_persist --in --d /dev/sde --read-status
  Peripheral device type: disk
  PR generation=0x3
    Key=0x1234
      All target ports bit clear
      Relative port address: 0x2
      << Reservation holder >>
      scope: LU_SCOPE,  type: Write Exclusive, registrants only
      Transport Id of initiator:
        iSCSI world wide unique port id: iqn.1993-08.org.debian:01:2dadf92d0ef
    Key=0x5678ffff
      All target ports bit clear
      Relative port address: 0x2
      not reservation holder
      Transport Id of initiator:
        iSCSI world wide unique port id: iqn.1996-04.de.suse:01:1661f9ee7b5

and finally from the new lio-utils.git CLI using tcm_node.py --pr for a device_mapper LVM
exported at generic target_core_mod storage ports.

target# tcm_node --pr iblock_0/lvm_test0
SPC-3 Reservation: iSCSI Initiator: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 Reservation: Single Target Port registration
0x00000003
SPC-3 Reservation: iSCSI Target Node Endpoint: iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0
SPC-3 Reservation: Relative Port Identifer Tag: 2 iSCSI Portal Group Tag: 1 iSCSI Logical Unit: 0
SPC-3 PR Registrations:
iSCSI Node: iqn.1993-08.org.debian:01:2dadf92d0ef Key: 0x0000000000001234 PRgen: 0x00000002
iSCSI Node: iqn.1996-04.de.suse:01:1661f9ee7b5 Key: 0x000000005678ffff PRgen: 0x00000001
SPC-3 Reservation Type: Write Exclusive Access, Registrants Only

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_pr.c |  470 +++++++++++++++++++++++++++++++++++++--
 1 files changed, 447 insertions(+), 23 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index ce4b30b..7a0857a 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -37,6 +37,7 @@
 #include <target/target_core_device.h>
 #include <target/target_core_hba.h>
 #include <target/target_core_tmr.h>
+#include <target/target_core_tpg.h>
 #include <target/target_core_transport.h>
 #include <target/target_core_pr.h>
 #include <target/target_core_ua.h>
@@ -465,19 +466,25 @@ static int core_scsi3_legacy_release(se_cmd_t *cmd)
 	return core_scsi2_reservation_release(cmd);
 }
 
+/*
+ * this function can be called with se_device_t->dev_reservation_lock
+ * when register_move = 1
+ */
 static int core_scsi3_alloc_registration(
 	se_device_t *dev,
 	se_node_acl_t *nacl,
 	se_dev_entry_t *deve,
 	u64 sa_res_key,
 	int all_tg_pt,
-	int ignore_key)
+	int register_type,
+	int register_move)
 {
+	se_subsystem_dev_t *su_dev = SU_DEV(dev);
 	struct target_core_fabric_ops *tfo = nacl->se_tpg->se_tpg_tfo;
 	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
 	t10_pr_registration_t *pr_reg;
 
-	pr_reg = kmem_cache_zalloc(t10_pr_reg_cache, GFP_KERNEL);
+	pr_reg = kmem_cache_zalloc(t10_pr_reg_cache, GFP_ATOMIC);
 	if (!(pr_reg)) {
 		printk(KERN_ERR "Unable to allocate t10_pr_registration_t\n");
 		return -1;
@@ -496,8 +503,15 @@ static int core_scsi3_alloc_registration(
 	/*
 	 * Increment PRgeneration counter for se_device_t upon a successful
 	 * REGISTER, see spc4r17 section 6.3.2 READ_KEYS service action
+	 * 
+	 * Also, when register_move = 1 for PROUT REGISTER_AND_MOVE service
+	 * action, the se_device_t->dev_reservation_lock will already be held,
+	 * so we do not call core_scsi3_pr_generation() which grabs the lock
+	 * for the REGISTER.
 	 */
-	pr_reg->pr_res_generation = core_scsi3_pr_generation(dev);
+	pr_reg->pr_res_generation = (register_move) ?
+			T10_RES(su_dev)->pr_generation++ :
+			core_scsi3_pr_generation(dev);
 
 	spin_lock(&pr_tmpl->registration_lock);
 	list_add_tail(&pr_reg->pr_reg_list, &pr_tmpl->registration_list);
@@ -505,7 +519,8 @@ static int core_scsi3_alloc_registration(
 	deve->pr_res_key = sa_res_key;
 
 	printk(KERN_INFO "SPC-3 PR [%s] Service Action: REGISTER%s Initiator"
-		" Node: %s\n", tfo->get_fabric_name(), (ignore_key) ?
+		" Node: %s\n", tfo->get_fabric_name(), (register_type == 2) ?
+		"_AND_MOVE" : (register_type == 1) ?
 		"_AND_IGNORE_EXISTING_KEY" : "", nacl->initiatorname);
 	printk(KERN_INFO "SPC-3 PR [%s] for %s TCM Subsystem %s Object Target"
 		" Port(s)\n",  tfo->get_fabric_name(),
@@ -748,7 +763,7 @@ static int core_scsi3_emulate_pro_register(
 			 */
 			ret = core_scsi3_alloc_registration(SE_DEV(cmd),
 					se_sess->se_node_acl, se_deve,
-					sa_res_key, all_tg_pt, ignore_key);
+					sa_res_key, all_tg_pt, ignore_key, 0);
 			if (ret != 0) {
 				printk(KERN_ERR "Unable to allocate"
 					" t10_pr_registration_t\n");
@@ -773,7 +788,6 @@ static int core_scsi3_emulate_pro_register(
 		if (!(pr_reg)) {
 			printk(KERN_ERR "SPC-3 PR: Unable to locate"
 				" PR_REGISTERED *pr_reg for REGISTER\n");
-			core_scsi3_put_pr_reg(pr_reg);
 			return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		}
 		type = pr_reg->pr_res_type;
@@ -1709,18 +1723,416 @@ static int core_scsi3_emulate_pro_preempt(
 	return 0;
 }
 
-#if 0
 static int core_scsi3_emulate_pro_register_and_move(
 	se_cmd_t *cmd,
-	int type,
-	int scope,
 	u64 res_key,
-	u64 sa_res_key)
+	u64 sa_res_key,
+	int aptpl,
+	int unreg)
 {
-	core_scsi3_pr_generation(SE_DEV(cmd));
+	se_session_t *se_sess = SE_SESS(cmd);
+	se_device_t *dev = SE_DEV(cmd);
+	se_dev_entry_t *se_deve, *dest_se_deve = NULL;
+	se_lun_t *se_lun = SE_LUN(cmd);
+	se_node_acl_t *pr_res_nacl, *pr_reg_nacl, *dest_node_acl = NULL;
+	se_port_t *se_port;
+	se_portal_group_t *se_tpg, *dest_se_tpg = NULL;
+	struct target_core_fabric_ops *dest_tf_ops = NULL, *tf_ops;
+	t10_pr_registration_t *pr_reg, *pr_res_holder, *dest_pr_reg;
+	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
+	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
+	unsigned char *initiator_str;
+	char *iport_ptr = NULL, dest_iport[64];
+	u32 tid_len;
+	int new_reg = 0, type, scope, ret;
+	unsigned short rtpi;
+	unsigned char proto_ident;
+
+	if (!(se_sess) || !(se_lun)) {
+		printk(KERN_ERR "SPC-3 PR: se_sess || se_lun_t is NULL!\n");
+		return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	}
+	memset(dest_iport, 0, 64);
+	se_tpg = se_sess->se_tpg;
+	tf_ops = TPG_TFO(se_tpg);
+	se_deve = &se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
+
+	if (aptpl) {
+		printk(KERN_INFO "Activate Persistence across Target Power"
+			" Loss = 1 not implemented yet\n");
+		return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+	}
+	/*
+	 * Follow logic from spc4r17 Section 5.7.8, Table 50 --
+	 *	Register behaviors for a REGISTER AND MOVE service action
+	 */
+	if (!(se_deve->deve_flags & DEF_PR_REGISTERED)) {
+		printk(KERN_WARNING "SPC-3 PR: Received REGISTER_AND_MOVE SA"
+				" from unregistered nexus\n");
+		return PYX_TRANSPORT_RESERVATION_CONFLICT;	
+	}
+	/*
+	 * Locate the existing *pr_reg via se_node_acl_t pointers
+	 */
+	pr_reg = core_scsi3_locate_pr_reg(SE_DEV(cmd), se_sess->se_node_acl);
+	if (!(pr_reg)) {
+		printk(KERN_ERR "SPC-3 PR: Unable to locate PR_REGISTERED"
+			" *pr_reg for REGISTER_AND_MOVE\n");
+		return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	}
+	/*
+	 * The provided reservation key much match the existing reservation key
+	 * provided during this initiator's I_T nexus registration.
+	 */	
+	if (res_key != pr_reg->pr_res_key) {
+		printk(KERN_WARNING "SPC-3 PR REGISTER_AND_MOVE: Received"
+			" res_key: 0x%016Lx does not match existing SA REGISTER"
+			" res_key: 0x%016Lx\n", res_key, pr_reg->pr_res_key);
+		core_scsi3_put_pr_reg(pr_reg);
+		return PYX_TRANSPORT_RESERVATION_CONFLICT;
+	}
+	/*
+	 * The service active reservation key needs to be non zero
+	 */
+	if (!(sa_res_key)) {
+		printk(KERN_WARNING "SPC-3 PR REGISTER_AND_MOVE: Received zero"
+			" sa_res_key\n");
+		core_scsi3_put_pr_reg(pr_reg);
+		return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+	}
+	/*
+	 * Determine the Relative Target Port Identifier where the reservation
+	 * will be moved to for the TransportID containing SCSI initiator WWN
+	 * information.
+	 */
+	rtpi = (buf[18] & 0xff) << 8;
+	rtpi |= buf[19] & 0xff;
+	tid_len = (buf[20] & 0xff) << 24;
+	tid_len |= (buf[21] & 0xff) << 16;
+	tid_len |= (buf[22] & 0xff) << 8;
+	tid_len |= buf[23] & 0xff;
+
+	if ((tid_len + 24) != cmd->data_length) {
+		printk(KERN_ERR "SPC-3 PR: Illegal tid_len: %u + 24 byte header"
+			" does not equal CDB data_length: %u\n", tid_len,
+			cmd->data_length);
+		core_scsi3_put_pr_reg(pr_reg);
+		return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+	}
+
+	spin_lock(&dev->se_port_lock);
+	list_for_each_entry(se_port, &dev->dev_sep_list, sep_list) {
+		if (se_port->sep_rtpi != rtpi)
+			continue;
+		dest_se_tpg = se_port->sep_tpg;
+		if (!(dest_se_tpg))
+			continue;
+		dest_tf_ops = TPG_TFO(dest_se_tpg);
+		if (!(dest_tf_ops))
+			continue;
+		spin_unlock(&dev->se_port_lock);
+
+		ret = configfs_depend_item(dest_tf_ops->tf_subsys,
+				&dest_se_tpg->tpg_group.cg_item);
+		if (ret != 0) {
+			printk(KERN_ERR "configfs_depend_item() failed for"
+				" dest_se_tpg->tpg_group\n");
+			core_scsi3_put_pr_reg(pr_reg);
+			return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		}
+
+		spin_lock(&dev->se_port_lock);
+		break;
+	}
+	spin_unlock(&dev->se_port_lock);
+
+	if (!(dest_se_tpg) || (!dest_tf_ops)) {
+		printk(KERN_ERR "SPC-3 PR REGISTER_AND_MOVE: Unable to locate"
+			" fabric ops from Relative Target Port Identifier:"
+			" %hu\n", rtpi);
+		core_scsi3_put_pr_reg(pr_reg);
+		return PYX_TRANSPORT_INVALID_PARAMETER_LIST;	
+	}
+	proto_ident = (buf[24] & 0x0f);
+#if 0
+	printk("SPC-3 PR REGISTER_AND_MOVE: Extracted Protocol Identifier:"
+			" 0x%02x\n", proto_ident);
+#endif
+	if (proto_ident != dest_tf_ops->get_fabric_proto_ident()) {
+		printk(KERN_ERR "SPC-3 PR REGISTER_AND_MOVE: Received"
+			" proto_ident: 0x%02x does not match ident: 0x%02x"
+			" from fabric: %s\n", proto_ident,
+			dest_tf_ops->get_fabric_proto_ident(),
+			dest_tf_ops->get_fabric_name());
+		ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+		goto out;
+	}
+	if (dest_tf_ops->tpg_parse_pr_out_transport_id == NULL) {
+		printk(KERN_ERR "SPC-3 PR REGISTER_AND_MOVE: Fabric does not"
+			" containg a valid tpg_parse_pr_out_transport_id"
+			" function pointer\n");
+		ret = PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		goto out;
+	}
+	initiator_str = dest_tf_ops->tpg_parse_pr_out_transport_id(
+			(const char *)&buf[24], tid_len, &iport_ptr);
+
+	printk(KERN_INFO "SPC-3 PR [%s] Extracted initiator %s identifier: %s"
+		" %s\n", dest_tf_ops->get_fabric_name(), (iport_ptr != NULL) ?
+		"port" : "device", initiator_str, (iport_ptr != NULL) ?
+		iport_ptr : "");
+	/*
+	 * If a PERSISTENT RESERVE OUT command with a REGISTER AND MOVE service
+	 * action specifies a TransportID that is the same as the initiator port
+	 * of the I_T nexus on which the command received, then the command shall
+	 * be terminated with CHECK CONDITION status, with the sense key set to
+	 * ILLEGAL REQUEST, and the additional sense code set to INVALID FIELD
+	 * IN PARAMETER LIST.
+	 */
+	pr_reg_nacl = pr_reg->pr_reg_nacl;
+	if (!(strcmp(initiator_str, pr_reg_nacl->initiatorname))) {
+		printk(KERN_ERR "SPC-3 PR REGISTER_AND_MOVE: TransportID: %s"
+			" matches: %s on received I_T Nexus\n", initiator_str,
+			pr_reg_nacl->initiatorname);
+		ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;	
+		goto out;
+	}
+	/*
+	 * Locate the destination se_node_acl_t from the received Transport ID
+	 */
+        dest_node_acl = core_tpg_get_initiator_node_acl(dest_se_tpg,
+                                        initiator_str);
+        if (!(dest_node_acl)) {
+                printk(KERN_ERR "Unable to locate %s dest_node_acl for"
+			" TransportID%s\n", dest_tf_ops->get_fabric_name(),
+			initiator_str);
+		ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+		goto out;
+        }
+	ret = configfs_depend_item(dest_tf_ops->tf_subsys,
+				&dest_node_acl->acl_group.cg_item);
+	if (ret != 0) {
+		printk(KERN_ERR "configfs_depend_item() failed for"
+			" dest_node_acl->acl_group\n");		
+		ret = PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		dest_node_acl = NULL;
+		goto out;
+	}
+#if 0
+	printk(KERN_INFO "SPC-3 PR REGISTER_AND_MOVE: Found %s dest_node_acl:"
+		" %s from TransportID\n", dest_tf_ops->get_fabric_name(),
+		dest_node_acl->initiatorname);
+#endif
+	/*
+	 * If the a SCSI Initiator Port identifier is presented, then
+	 * the SCSI nexus must be present and matching the provided
+	 * TransportID.  The active se_session_t pointer is available
+	 * from dest_node_acl->nacl_sess;
+	 */
+	if (iport_ptr != NULL) {
+		spin_lock(&dest_node_acl->nacl_sess_lock);
+		if (dest_node_acl->nacl_sess == NULL) {
+			printk(KERN_ERR "SPC-3 PR REGISTER_AND_MOVE: "
+				"iport_ptr: %s presented in Transport ID,"
+				" but no active nexus exists for %s Fabric"
+				" Node: %s\n", iport_ptr,
+				dest_tf_ops->get_fabric_name(),
+				dest_node_acl->initiatorname);
+			spin_unlock(&dest_node_acl->nacl_sess_lock);
+			ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+			goto out;
+		}
+		TPG_TFO(se_tpg)->sess_get_initiator_wwn(
+					dest_node_acl->nacl_sess,
+					&dest_iport[0], 64);
+		spin_unlock(&dest_node_acl->nacl_sess_lock);
+
+		if (strcmp(dest_iport, iport_ptr)) {
+			printk(KERN_ERR "SPC-3 PR REGISTER_AND_MOVE:"
+				" dest_iport: %s and iport_ptr: %s do not"
+				" match!\n", dest_iport, iport_ptr);
+			ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+			goto out;
+		}
+	}
+	/*
+	 * Locate the se_dev_entry_t pointer for the matching RELATIVE TARGET
+	 * PORT IDENTIFIER.  core_get_se_deve_from_rtpi() will call
+	 * configfs_item_depend() on deve->se_lun_acl->se_lun_group.cg_item
+	 */
+	dest_se_deve = core_get_se_deve_from_rtpi(dest_node_acl, rtpi);
+	if (!(dest_se_deve)) {
+		printk(KERN_ERR "Unable to locate %s dest_se_deve from RTPI:"
+			" %hu\n",  dest_tf_ops->get_fabric_name(), rtpi);
+		ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+		goto out;
+	}
+#if 0
+	printk(KERN_INFO "SPC-3 PR REGISTER_AND_MOVE: Located %s node %s LUN"
+		" ACL for dest_se_deve->mapped_lun: %u\n",
+		dest_tf_ops->get_fabric_name(), dest_node_acl->initiatorname,
+		dest_se_deve->mapped_lun);
+#endif
+	/*
+	 * A persistent reservation needs to already existing in order to
+	 * successfully complete the REGISTER_AND_MOVE service action..
+	 */
+	spin_lock(&dev->dev_reservation_lock);
+	pr_res_holder = dev->dev_pr_res_holder;
+	if (!(pr_res_holder)) {
+		printk(KERN_WARNING "SPC-3 PR REGISTER_AND_MOVE: No reservation"
+			" currently held\n");
+		spin_unlock(&dev->dev_reservation_lock);
+		ret = PYX_TRANSPORT_INVALID_CDB_FIELD;
+		goto out;
+	}
+	/*
+	 * The received on I_T Nexus must be the reservation holder.
+	 *
+	 * From spc4r17 section 5.7.8  Table 50 --
+	 * 	Register behaviors for a REGISTER AND MOVE service action
+	 */
+	if (pr_res_holder != pr_reg) {
+		printk(KERN_WARNING "SPC-3 PR REGISTER_AND_MOVE: Calling I_T"
+			" Nexus is not reservation holder\n");
+		spin_unlock(&dev->dev_reservation_lock);
+		ret = PYX_TRANSPORT_RESERVATION_CONFLICT;
+		goto out;
+	}
+	/* 
+	 * From spc4r17 section 5.7.8: registering and moving reservation
+	 *
+	 * If a PERSISTENT RESERVE OUT command with a REGISTER AND MOVE service
+	 * action is received and the established persistent reservation is a
+	 * Write Exclusive - All Registrants type or Exclusive Access -
+	 * All Registrants type reservation, then the command shall be completed
+	 * with RESERVATION CONFLICT status.
+	 */
+	if ((pr_res_holder->pr_res_type == PR_TYPE_WRITE_EXCLUSIVE_ALLREG) ||
+	    (pr_res_holder->pr_res_type == PR_TYPE_EXCLUSIVE_ACCESS_ALLREG)) {
+		printk(KERN_WARNING "SPC-3 PR REGISTER_AND_MOVE: Unable to move"
+			" reservation for type: %s\n",
+			core_scsi3_pr_dump_type(pr_res_holder->pr_res_type));
+		spin_unlock(&dev->dev_reservation_lock);
+		ret = PYX_TRANSPORT_RESERVATION_CONFLICT;
+		goto out;
+	}
+	pr_res_nacl = pr_res_holder->pr_reg_nacl;
+	/*
+	 * b) Ignore the contents of the (received) SCOPE and TYPE fields;
+	 */
+	type = pr_res_holder->pr_res_type;
+	scope = pr_res_holder->pr_res_type;
+	/*
+	 * c) Associate the reservation key specified in the SERVICE ACTION
+	 *    RESERVATION KEY field with the I_T nexus specified as the
+	 *    destination of the register and move, where:
+	 *    A) The I_T nexus is specified by the TransportID and the
+	 *	 RELATIVE TARGET PORT IDENTIFIER field (see 6.14.4); and
+	 *    B) Regardless of the TransportID format used, the association for
+	 *       the initiator port is based on either the initiator port name
+	 *       (see 3.1.71) on SCSI transport protocols where port names are
+	 *       required or the initiator port identifier (see 3.1.70) on SCSI
+	 *       transport protocols where port names are not required;
+	 * d) Register the reservation key specified in the SERVICE ACTION
+	 *    RESERVATION KEY field;
+	 * e) Retain the reservation key specified in the SERVICE ACTION
+	 *    RESERVATION KEY field and associated information;
+	 *
+	 * Also, It is not an error for a REGISTER AND MOVE service action to
+	 * register an I_T nexus that is already registered with the same
+	 * reservation key or a different reservation key.
+	 */
+	if (!(dest_se_deve->deve_flags & DEF_PR_REGISTERED)) {
+		ret = core_scsi3_alloc_registration(SE_DEV(cmd),
+				dest_node_acl, dest_se_deve,
+				sa_res_key, 0, 2, 1);
+		if (ret != 0) {
+			spin_unlock(&dev->dev_reservation_lock);
+			ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+			goto out;
+		}
+		new_reg = 1;
+	}
+	/*
+	 * Locate the Destination registration where the reservation
+	 * is being moved.
+	 */
+	dest_pr_reg = core_scsi3_locate_pr_reg(dev, dest_node_acl);
+	if (!(dest_pr_reg)) {
+		printk(KERN_ERR "Unable to locate dest_pr_reg for"
+			" REGISTERED I_T Nexus for %s\n", initiator_str);
+		spin_unlock(&dev->dev_reservation_lock);
+		ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+		goto out;
+	}
+	/*
+	 * f) Release the persistent reservation for the persistent reservation
+	 *    holder (i.e., the I_T nexus on which the
+	 */
+	__core_scsi3_complete_pro_release(dev, pr_res_nacl,
+			dev->dev_pr_res_holder, 0);
+	/*
+	 * g) Move the persistent reservation to the specified I_T nexus using
+	 *    the same scope and type as the persistent reservation released in
+	 *    item f); and
+	 */
+	dev->dev_pr_res_holder = dest_pr_reg;
+	dest_pr_reg->pr_res_holder = 1;	
+	dest_pr_reg->pr_res_type = type;
+	pr_reg->pr_res_scope = scope;
+	/*
+	 * Increment PRGeneration for existing registrations..
+	 */
+	if (!(new_reg))
+		dest_pr_reg->pr_res_generation = pr_tmpl->pr_generation++;
+	spin_unlock(&dev->dev_reservation_lock);
+
+	printk(KERN_INFO "SPC-3 PR [%s] Service Action: REGISTER_AND_MOVE"
+		" created new reservation holder TYPE: %s on object RTPI:"
+		" %hu  PRGeneration: 0x%08x\n", dest_tf_ops->get_fabric_name(),
+		core_scsi3_pr_dump_type(type), rtpi,
+		dest_pr_reg->pr_res_generation);
+	printk(KERN_INFO "SPC-3 PR Successfully moved reservation from"
+		" %s Fabric Node: %s -> %s Fabric Node: %s %s\n",
+		tf_ops->get_fabric_name(), pr_reg_nacl->initiatorname,
+		dest_tf_ops->get_fabric_name(), dest_node_acl->initiatorname,
+		(iport_ptr != NULL) ? iport_ptr : "");
+	/*
+	 * It is now safe to release configfs group dependencies for destination
+	 * of Transport ID Initiator Device/Port Identifier
+	 */
+	configfs_undepend_item(dest_tf_ops->tf_subsys,
+			&dest_se_deve->se_lun_acl->se_lun_group.cg_item);
+	configfs_undepend_item(dest_tf_ops->tf_subsys,
+			&dest_node_acl->acl_group.cg_item);
+	configfs_undepend_item(dest_tf_ops->tf_subsys,
+			&dest_se_tpg->tpg_group.cg_item);
+	/*
+	 * h) If the UNREG bit is set to one, unregister (see 5.7.11.3) the I_T
+	 * nexus on which PERSISTENT RESERVE OUT command was received.
+	 */
+	if (unreg) {
+		spin_lock(&pr_tmpl->registration_lock);
+		__core_scsi3_free_registration(dev, pr_reg, NULL, 1);
+		spin_unlock(&pr_tmpl->registration_lock);
+	} else
+		core_scsi3_put_pr_reg(pr_reg);
+
+	core_scsi3_put_pr_reg(dest_pr_reg);
 	return 0;
+out:
+	if (dest_se_deve)
+		configfs_undepend_item(dest_tf_ops->tf_subsys,
+			&dest_se_deve->se_lun_acl->se_lun_group.cg_item);
+	if (dest_node_acl)
+		configfs_undepend_item(dest_tf_ops->tf_subsys,
+				&dest_node_acl->acl_group.cg_item);
+	configfs_undepend_item(dest_tf_ops->tf_subsys,
+			&dest_se_tpg->tpg_group.cg_item);
+	core_scsi3_put_pr_reg(pr_reg);
+	return ret;	
 }
-#endif
 
 static unsigned long long core_scsi3_extract_reservation_key(unsigned char *cdb)
 {
@@ -1739,8 +2151,8 @@ static int core_scsi3_emulate_pr_out(se_cmd_t *cmd, unsigned char *cdb)
 {
 	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
 	u64 res_key, sa_res_key;
-	int scope, type, spec_i_pt, all_tg_pt, aptpl;
-
+	int sa, scope, type, aptpl;
+	int spec_i_pt = 0, all_tg_pt = 0, unreg = 0;
 	/*
 	 * FIXME: A NULL se_session_t pointer means an this is not coming from
 	 * a $FABRIC_MOD's nexus, but from internal passthrough ops.
@@ -1748,9 +2160,15 @@ static int core_scsi3_emulate_pr_out(se_cmd_t *cmd, unsigned char *cdb)
 	if (!(SE_SESS(cmd)))
 		return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
+	if (cmd->data_length < 24) {
+		printk(KERN_WARNING "SPC-PR: Recieved PR OUT parameter list"
+			" length too small: %u\n", cmd->data_length);	
+		return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+	}
 	/*
 	 * From the PERSISTENT_RESERVE_OUT command descriptor block (CDB)
 	 */
+	sa = (cdb[1] & 0x1f);
 	scope = (cdb[2] & 0xf0);
 	type = (cdb[2] & 0x0f);
 	/*
@@ -1758,10 +2176,18 @@ static int core_scsi3_emulate_pr_out(se_cmd_t *cmd, unsigned char *cdb)
 	 */
 	res_key = core_scsi3_extract_reservation_key(&buf[0]);
 	sa_res_key = core_scsi3_extract_reservation_key(&buf[8]);
-	spec_i_pt = (buf[20] & 0x08);
-	all_tg_pt = (buf[20] & 0x04);
-	aptpl = (buf[20] & 0x01);
-
+	/*
+	 * REGISTER_AND_MOVE uses a different SA parameter list containing
+	 * SCSI TransportIDs.
+	 */
+	if (sa != PRO_REGISTER_AND_MOVE) {
+		spec_i_pt = (buf[20] & 0x08);
+		all_tg_pt = (buf[20] & 0x04);
+		aptpl = (buf[20] & 0x01);
+	} else {
+		aptpl = (buf[17] & 0x01);
+		unreg = (buf[17] & 0x02);
+	}
 	/*
 	 * SPEC_I_PT=1 is only valid for Service action: REGISTER
 	 */
@@ -1772,7 +2198,7 @@ static int core_scsi3_emulate_pr_out(se_cmd_t *cmd, unsigned char *cdb)
 	 * are defined by spc4r17 Table 174:
 	 * PERSISTENT_RESERVE_OUT service actions and valid parameters.
 	 */
-	switch (cdb[1] & 0x1f) {
+	switch (sa) {
 	case PRO_REGISTER:
 		return core_scsi3_emulate_pro_register(cmd,
 			res_key, sa_res_key, aptpl, all_tg_pt, spec_i_pt, 0);
@@ -1793,11 +2219,9 @@ static int core_scsi3_emulate_pr_out(se_cmd_t *cmd, unsigned char *cdb)
 	case PRO_REGISTER_AND_IGNORE_EXISTING_KEY:
 		return core_scsi3_emulate_pro_register(cmd,
 			0, sa_res_key, aptpl, all_tg_pt, spec_i_pt, 1);
-#if 0
 	case PRO_REGISTER_AND_MOVE:
-		return core_scsi3_emulate_pro_register_and_move(cmd,
-			type, scope, res_key, sa_res_key);
-#endif
+		return core_scsi3_emulate_pro_register_and_move(cmd, res_key,
+				sa_res_key, aptpl, unreg);
 	default:
 		printk(KERN_ERR "Unknown PERSISTENT_RESERVE_OUT service"
 			" action: 0x%02x\n", cdb[1] & 0x1f);
-- 
1.5.4.1



