From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [TCM/PR]: Add proper ALL_TG_PT=1 allocation support
Date: Tue, 23 Mar 2010 05:11:47 -0700
Message-ID: <1269346307-22944-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:20200 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752253Ab0CWL7L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Mar 2010 07:59:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, LIO-Target devel <linux-iscsi-target-dev@googlegroups.com>, Dave <wrightd@gmail.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds proper per target port allocation of t10_pr_registration_t to handle
the SPC4 defined ALL_TG_PT=1 feature bit using __core_scsi3_alloc_registration()
The ALL_TG_PT=1 logic had only working as expected across multiple target ports
the same I_T Nexus, so this patch adds proper support for doing ALL_TG_PT=1 across multiple
I_T Nexus for all target ports within the same underlying fabric module.

The main logic in __core_scsi3_alloc_registration() walks the se_device_t port list (
dev->dev_sep_list) and grabs a local reference via se_port_t->sep_tg_pt_ref_cnt, then
drops the port lock and walks se_port_t->sep_alua_list for the list of the SCSI Initiator
Node ACL MappedLUNs entries for the matching target port.  From there this patch uses the
existing reference logic in se_dev_entry_t->pr_ref_count and core_scsi3_lunacl_depend_item()
in order to make sure that the underlying configfs group for the destination MappedLUN (and
everything below) does not disappear before a successful PR registration with ALL_TG_PT=1
can be completed.

At this point the allocated ALL_TG_PT=1 registrations for I_T Nexus'es other than the one
that the original PROUT REGISTER was received on will be added to t10_pr_registration_t->pr_reg_atp_list,
and these PR registrations are added to se_device_t PR REG list by the existing calls to
__core_scsi3_add_registration().  From there __core_scsi3_add_registration() will walk to
pr_reg_atp_list and add each registration and drop any configfs group references with
core_scsi3_lunacl_undepend_item() that where created in __core_scsi3_alloc_registration()

This patch also adds proper exception path handling for ALL_TG_PT=1 failures with the
SPEC_I_PT=1 feature bit in core_scsi3_decode_spec_i_port().  Here is how a multi I_T Nexus
ALL_TG_PT=1 test case looks now between two SCSI Target Ports (LIO-Target iSCSI) across
two SCSI I_T Nexuses (iSCSI Sessions) using APTPL=1.

root@ubuntu:~# multipath -ll
<SNIP>
mpath4 (36001405a97e4ce21c0711de829b000c2) dm-2 LIO-ORG,IBLOCK
[size=1.5G][features=0][hwhandler=1 alua]
\_ round-robin 0 [prio=50][enabled]
 \_ 3:0:0:0 sde 8:64  [active][ready]
\_ round-robin 0 [prio=10][active]
 \_ 4:0:0:0 sdf 8:80  [active][ready]

root@ubuntu:~# lsscsi --transport
<SNIP>
[3:0:0:0]    disk    iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd,t,0x1  /dev/sde
[4:0:0:0]    disk    iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0,t,0x1  /dev/sdf

*) Call PROUT REGISTER with ALL_TG_PT=1 and APTPL=1 on SCSI RTPI=2 at /dev/sde

root@ubuntu:~# sg_persist -vvv --out -Y -Z --device /dev/sde --register --param-sark=0x1234ffff
open /dev/sde with flags=0x800
    inquiry cdb: 12 00 00 00 24 00
      duration=0 ms
  LIO-ORG  IBLOCK  3.1
  Peripheral device type: disk
open /dev/sde with flags=0x802
    Persistent Reservation Out cmd: 5f 00 00 00 00 00 00 00 18 00
    Persistent Reservation Out parameters:
 00     00 00 00 00 00 00 00 00  00 00 00 00 12 34 ff ff    .............4..
 10     00 00 00 00 05 00 00 00                             ........
      duration=8 ms
PR out: command (Register) successful

*) Call PROUT RESERVE on SCSI RPTI=1 at /dev/sdf

root@ubuntu:~# sg_persist -vvv --out --device /dev/sdf --reserve --param-rk=0x1234ffff -T 5
open /dev/sdf with flags=0x800
    inquiry cdb: 12 00 00 00 24 00
      duration=120 ms
  LIO-ORG  IBLOCK  3.1
  Peripheral device type: disk
open /dev/sdf with flags=0x802
    Persistent Reservation Out cmd: 5f 01 05 00 00 00 00 00 18 00
    Persistent Reservation Out parameters:
 00     00 00 00 00 12 34 ff ff  00 00 00 00 00 00 00 00    .....4..........
 10     00 00 00 00 00 00 00 00                             ........
      duration=112 ms
PR out: command (Reserve) successful

*) PRIN READ_FULL_STATUS

root@ubuntu:~# sg_persist --in -s -d /dev/sde
  LIO-ORG  IBLOCK  3.1
  Peripheral device type: disk
  PR generation=0x2
    Key=0x1234ffff
      All target ports bit set
      not reservation holder
      Transport Id of initiator:
        iSCSI world wide unique port id: iqn.1993-08.org.debian:01:2dadf92d0ef
    Key=0x1234ffff
      All target ports bit set
      << Reservation holder >>
      scope: LU_SCOPE,  type: Write Exclusive, registrants only
      Transport Id of initiator:
        iSCSI world wide unique port id: iqn.1993-08.org.debian:01:2dadf92d0ef

*) TCM side kernel ring buffer output

SPC-3 PR [iSCSI] Service Action: REGISTER Initiator Node: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 PR [iSCSI] registration on Target Port: iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd,0x0001
SPC-3 PR [iSCSI] for ALL TCM Subsystem iblock Object Target Port(s)
SPC-3 PR [iSCSI] SA Res Key: 0x000000001234ffff PRgeneration: 0x00000000  APTPL: 1
SPC-3 PR [iSCSI] Service Action: REGISTER Initiator Node: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 PR [iSCSI] registration on Target Port: iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0,0x0001
SPC-3 PR [iSCSI] for ALL TCM Subsystem iblock Object Target Port(s)
SPC-3 PR [iSCSI] SA Res Key: 0x000000001234ffff PRgeneration: 0x00000001  APTPL: 1
SPC-3 PR: Set APTPL Bit Activated for REGISTER
SPC-3 PR [iSCSI] Service Action: RESERVE created new reservation holder TYPE: Write Exclusive Access, Registrants Only ALL_TG_PT: 1
SPC-3 PR [iSCSI] RESERVE Node: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 PR: Updated APTPL metadata for RESERVE

*) TCM side PR APTPL metadata for storage object backstore

target:~/lio-core-2.6.git# cat /var/target/pr/aptpl_a97e4ce21c0711de829b000c2943d57b
PR_REG_START: 0
initiator_fabric=iSCSI
initiator_node=iqn.1993-08.org.debian:01:2dadf92d0ef
sa_res_key=305463295
res_holder=0
res_all_tg_pt=4
mapped_lun=0
target_fabric=iSCSI
target_node=iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd
tpgt=1
port_rtpi=2
target_lun=0
PR_REG_END: 0
PR_REG_START: 1
initiator_fabric=iSCSI
initiator_node=iqn.1993-08.org.debian:01:2dadf92d0ef
sa_res_key=305463295
res_holder=1
res_type=05
res_scope=00
res_all_tg_pt=4
mapped_lun=0
target_fabric=iSCSI
target_node=iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0
tpgt=1
port_rtpi=1
target_lun=0
PR_REG_END: 1

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
Reported-by: Dave <wrightd@gmail.com>
---
 drivers/target/target_core_device.c |    9 ++
 drivers/target/target_core_pr.c     |  237 +++++++++++++++++++++++++++++++----
 include/target/target_core_base.h   |    4 +
 3 files changed, 224 insertions(+), 26 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index c6a8eda..b0cbf8d 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -752,6 +752,15 @@ void core_export_port(
  */
 void core_release_port(se_device_t *dev, se_port_t *port)
 {
+	/*
+	 * Wait for any port reference for PR ALL_TG_PT=1 operation
+	 * to complete in __core_scsi3_alloc_registration()
+	 */
+	spin_unlock(&dev->se_port_lock);
+	if (atomic_read(&port->sep_tg_pt_ref_cnt))
+		msleep(100);
+	spin_lock(&dev->se_port_lock);
+
 	core_alua_free_tg_pt_gp_mem(port);
 
 	list_del(&port->sep_list);
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 67fff09..9e3838f 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -568,7 +568,7 @@ static int core_scsi3_pr_reservation_check(
 	return ret;
 }
 
-static t10_pr_registration_t *__core_scsi3_alloc_registration(
+static t10_pr_registration_t *__core_scsi3_do_alloc_registration(
 	se_device_t *dev,
 	se_node_acl_t *nacl,
 	se_dev_entry_t *deve,
@@ -596,6 +596,8 @@ static t10_pr_registration_t *__core_scsi3_alloc_registration(
 	INIT_LIST_HEAD(&pr_reg->pr_reg_list);
 	INIT_LIST_HEAD(&pr_reg->pr_reg_abort_list);
 	INIT_LIST_HEAD(&pr_reg->pr_reg_aptpl_list);
+	INIT_LIST_HEAD(&pr_reg->pr_reg_atp_list);
+	INIT_LIST_HEAD(&pr_reg->pr_reg_atp_mem_list);
 	atomic_set(&pr_reg->pr_res_holders, 0);
 	pr_reg->pr_reg_nacl = nacl;
 	pr_reg->pr_reg_deve = deve;
@@ -609,6 +611,143 @@ static t10_pr_registration_t *__core_scsi3_alloc_registration(
 	return pr_reg;
 }
 
+static int core_scsi3_lunacl_depend_item(se_dev_entry_t *);
+static void core_scsi3_lunacl_undepend_item(se_dev_entry_t *);
+
+/*
+ * Function used for handling PR registrations for ALL_TG_PT=1 and ALL_TG_PT=0
+ * modes.
+ */
+static t10_pr_registration_t *__core_scsi3_alloc_registration(
+	se_device_t *dev,
+	se_node_acl_t *nacl,
+	se_dev_entry_t *deve,
+	u64 sa_res_key,
+	int all_tg_pt,
+	int aptpl)
+{
+	se_dev_entry_t *deve_tmp;
+	se_node_acl_t *nacl_tmp;
+	se_port_t *port, *port_tmp;
+	struct target_core_fabric_ops *tfo = nacl->se_tpg->se_tpg_tfo;
+	t10_pr_registration_t *pr_reg, *pr_reg_atp, *pr_reg_tmp, *pr_reg_tmp_safe;
+	int ret;
+	/*
+	 * Create a registration for the I_T Nexus upon which the
+	 * PROUT REGISTER was received.
+	 */
+	pr_reg = __core_scsi3_do_alloc_registration(dev, nacl, deve,
+			sa_res_key, all_tg_pt, aptpl);
+	if (!(pr_reg))
+		return NULL;
+	/*
+	 * Return pointer to pr_reg for ALL_TG_PT=0
+	 */
+	if (!(all_tg_pt))
+		return pr_reg;
+	/*
+	 * Create list of matching SCSI Initiator Port registrations
+	 * for ALL_TG_PT=1
+	 */
+	spin_lock(&dev->se_port_lock);
+	list_for_each_entry_safe(port, port_tmp, &dev->dev_sep_list, sep_list) {
+		atomic_inc(&port->sep_tg_pt_ref_cnt);
+		smp_mb__after_atomic_inc();
+		spin_unlock(&dev->se_port_lock);
+
+		spin_lock_bh(&port->sep_alua_lock);
+		list_for_each_entry(deve_tmp, &port->sep_alua_list,
+					alua_port_list) {
+			/*
+			 * This pointer will be NULL for demo mode MappedLUNs
+			 * that have not been make explict via a ConfigFS
+			 * MappedLUN group for the SCSI Initiator Node ACL.
+			 */
+			if (!(deve_tmp->se_lun_acl))
+				continue;
+
+			nacl_tmp = deve_tmp->se_lun_acl->se_lun_nacl;
+			/*
+			 * Skip the matching se_node_acl_t that is allocated
+			 * above..
+			 */
+			if (nacl == nacl_tmp)
+				continue;
+			/*
+			 * Only perform PR registrations for target ports on
+			 * the same fabric module as the REGISTER w/ ALL_TG_PT=1			
+			 * arrived.
+			 */
+			if (tfo != nacl_tmp->se_tpg->se_tpg_tfo)
+				continue;
+			/*
+			 * Look for a matching Initiator Node ACL in ASCII format
+			 */
+			if (strcmp(nacl->initiatorname, nacl_tmp->initiatorname))
+				continue;
+
+			atomic_inc(&deve_tmp->pr_ref_count);
+			smp_mb__after_atomic_inc();
+			spin_unlock_bh(&port->sep_alua_lock);
+			/*
+			 * Grab a configfs group dependency that is released
+			 * for the exception path at label out: below, or upon
+			 * completion of adding ALL_TG_PT=1 registrations in
+			 * __core_scsi3_add_registration()
+			 */
+			ret = core_scsi3_lunacl_depend_item(deve_tmp);
+			if (ret < 0) {
+				printk(KERN_ERR "core_scsi3_lunacl_depend"
+						"_item() failed\n");
+				atomic_dec(&port->sep_tg_pt_ref_cnt);
+				smp_mb__after_atomic_dec();
+				atomic_dec(&deve_tmp->pr_ref_count);
+				smp_mb__after_atomic_dec();
+				goto out;
+			}
+			/*
+			 * Located a matching SCSI Initiator Port on a different
+			 * port, allocate the pr_reg_atp and attach it to the
+			 * pr_reg->pr_reg_atp_list that will be processed once
+			 * the original *pr_reg is processed in
+			 * __core_scsi3_add_registration()
+			 */
+			pr_reg_atp = __core_scsi3_do_alloc_registration(dev,
+						nacl_tmp, deve_tmp, sa_res_key,
+						all_tg_pt, aptpl);
+			if (!(pr_reg_atp)) {
+				atomic_dec(&port->sep_tg_pt_ref_cnt);
+				smp_mb__after_atomic_dec();
+				atomic_dec(&deve_tmp->pr_ref_count);
+				smp_mb__after_atomic_dec();
+				core_scsi3_lunacl_undepend_item(deve_tmp);
+				goto out;
+			}
+
+			list_add_tail(&pr_reg_atp->pr_reg_atp_mem_list,
+				      &pr_reg->pr_reg_atp_list);
+			spin_lock_bh(&port->sep_alua_lock);
+		}
+		spin_unlock_bh(&port->sep_alua_lock);
+
+		spin_lock(&dev->se_port_lock);
+		atomic_dec(&port->sep_tg_pt_ref_cnt);
+		smp_mb__after_atomic_dec();
+	}
+	spin_unlock(&dev->se_port_lock);
+
+	return pr_reg;
+out:
+	list_for_each_entry_safe(pr_reg_tmp, pr_reg_tmp_safe,
+			&pr_reg->pr_reg_atp_list, pr_reg_atp_mem_list) {
+		list_del(&pr_reg_tmp->pr_reg_atp_mem_list);
+		core_scsi3_lunacl_undepend_item(pr_reg_tmp->pr_reg_deve);
+		kmem_cache_free(t10_pr_reg_cache, pr_reg_tmp);
+	}
+	kmem_cache_free(t10_pr_reg_cache, pr_reg);
+	return NULL;
+}
+
 int core_scsi3_alloc_aptpl_registration(
 	t10_reservation_template_t *pr_tmpl,
 	u64 sa_res_key,
@@ -638,6 +777,8 @@ int core_scsi3_alloc_aptpl_registration(
 	INIT_LIST_HEAD(&pr_reg->pr_reg_list);
 	INIT_LIST_HEAD(&pr_reg->pr_reg_abort_list);
 	INIT_LIST_HEAD(&pr_reg->pr_reg_aptpl_list);
+	INIT_LIST_HEAD(&pr_reg->pr_reg_atp_list);
+	INIT_LIST_HEAD(&pr_reg->pr_reg_atp_mem_list);
 	atomic_set(&pr_reg->pr_res_holders, 0);
 	pr_reg->pr_reg_nacl = NULL;
 	pr_reg->pr_reg_deve = NULL;
@@ -774,6 +915,32 @@ int core_scsi3_check_aptpl_registration(
 				lun->unpacked_lun, nacl, deve);
 }
 
+static void __core_scsi3_dump_registration(
+	struct target_core_fabric_ops *tfo,
+	se_device_t *dev,
+	se_node_acl_t *nacl,
+	t10_pr_registration_t *pr_reg,
+	int register_type)
+{
+	se_portal_group_t *se_tpg = nacl->se_tpg;
+
+	printk(KERN_INFO "SPC-3 PR [%s] Service Action: REGISTER%s Initiator"
+		" Node: %s\n", tfo->get_fabric_name(), (register_type == 2) ?
+		"_AND_MOVE" : (register_type == 1) ?
+		"_AND_IGNORE_EXISTING_KEY" : "", nacl->initiatorname);
+	printk(KERN_INFO "SPC-3 PR [%s] registration on Target Port: %s,0x%04x\n",
+		 tfo->get_fabric_name(), tfo->tpg_get_wwn(se_tpg),
+		tfo->tpg_get_tag(se_tpg));
+	printk(KERN_INFO "SPC-3 PR [%s] for %s TCM Subsystem %s Object Target"
+		" Port(s)\n",  tfo->get_fabric_name(),
+		(pr_reg->pr_reg_all_tg_pt) ? "ALL" : "SINGLE",
+		TRANSPORT(dev)->name);
+	printk(KERN_INFO "SPC-3 PR [%s] SA Res Key: 0x%016Lx PRgeneration:"
+		" 0x%08x  APTPL: %d\n", tfo->get_fabric_name(),
+		pr_reg->pr_res_key, pr_reg->pr_res_generation,
+		pr_reg->pr_reg_aptpl);
+}
+
 /*
  * this function can be called with se_device_t->dev_reservation_lock
  * when register_move = 1
@@ -787,6 +954,7 @@ static void __core_scsi3_add_registration(
 {
 	se_subsystem_dev_t *su_dev = SU_DEV(dev);
 	struct target_core_fabric_ops *tfo = nacl->se_tpg->se_tpg_tfo;
+	t10_pr_registration_t *pr_reg_tmp, *pr_reg_tmp_safe;
 	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
 
 	/*
@@ -806,21 +974,38 @@ static void __core_scsi3_add_registration(
 	list_add_tail(&pr_reg->pr_reg_list, &pr_tmpl->registration_list);
 	pr_reg->pr_reg_deve->deve_flags |= DEF_PR_REGISTERED;
 
-	printk(KERN_INFO "SPC-3 PR [%s] Service Action: REGISTER%s Initiator"
-		" Node: %s\n", tfo->get_fabric_name(), (register_type == 2) ?
-		"_AND_MOVE" : (register_type == 1) ?
-		"_AND_IGNORE_EXISTING_KEY" : "", nacl->initiatorname);
-	printk(KERN_INFO "SPC-3 PR [%s] for %s TCM Subsystem %s Object Target"
-		" Port(s)\n",  tfo->get_fabric_name(),
-		(pr_reg->pr_reg_all_tg_pt) ? "ALL" : "SINGLE",
-		TRANSPORT(dev)->name);
-	printk(KERN_INFO "SPC-3 PR [%s] SA Res Key: 0x%016Lx PRgeneration:"
-		" 0x%08x  APTPL: %d\n", tfo->get_fabric_name(),
-		pr_reg->pr_res_key, pr_reg->pr_res_generation,
-		pr_reg->pr_reg_aptpl);
+	__core_scsi3_dump_registration(tfo, dev, nacl, pr_reg, register_type);
 	spin_unlock(&pr_tmpl->registration_lock);
+	/*
+	 * Skip extra processing for ALL_TG_PT=0 or REGISTER_AND_MOVE.
+	 */
+	if (!(pr_reg->pr_reg_all_tg_pt) || (register_move))
+		return;
+	/*
+	 * Walk pr_reg->pr_reg_atp_list and add registrations for ALL_TG_PT=1
+	 * allocated in __core_scsi3_alloc_registration()
+	 */
+	list_for_each_entry_safe(pr_reg_tmp, pr_reg_tmp_safe,
+			&pr_reg->pr_reg_atp_list, pr_reg_atp_mem_list) {
+		list_del(&pr_reg_tmp->pr_reg_atp_mem_list);
+
+		pr_reg_tmp->pr_res_generation = core_scsi3_pr_generation(dev);
 
-	return;
+		spin_lock(&pr_tmpl->registration_lock);
+		list_add_tail(&pr_reg_tmp->pr_reg_list,
+			      &pr_tmpl->registration_list);
+		pr_reg_tmp->pr_reg_deve->deve_flags |= DEF_PR_REGISTERED;
+
+		__core_scsi3_dump_registration(tfo, dev,
+				pr_reg_tmp->pr_reg_nacl, pr_reg_tmp,
+				register_type);
+		spin_unlock(&pr_tmpl->registration_lock);
+		/*
+		 * Drop configfs group dependency reference from
+		 * __core_scsi3_alloc_registration()
+		 */
+		core_scsi3_lunacl_undepend_item(pr_reg_tmp->pr_reg_deve);
+	}
 }
 
 static int core_scsi3_alloc_registration(
@@ -1134,6 +1319,7 @@ static int core_scsi3_decode_spec_i_port(
 	se_node_acl_t *dest_node_acl;
 	se_dev_entry_t *dest_se_deve = NULL, *local_se_deve;
 	t10_pr_registration_t *dest_pr_reg, *local_pr_reg;
+	t10_pr_registration_t *pr_reg_tmp, *pr_reg_tmp_safe;
 	struct list_head tid_dest_list;
 	struct pr_transport_id_holder *tidh_new, *tidh, *tidh_tmp;
 	struct target_core_fabric_ops *tmp_tf_ops;
@@ -1503,6 +1689,17 @@ out:
 
 		list_del(&tidh->dest_list);
 		kfree(tidh);
+		/*
+		 * Release any extra ALL_TG_PT=1 registrations for
+		 * the SPEC_I_PT=1 case.
+		 */
+		list_for_each_entry_safe(pr_reg_tmp, pr_reg_tmp_safe,
+				&dest_pr_reg->pr_reg_atp_list,
+				pr_reg_atp_mem_list) {
+			list_del(&pr_reg_tmp->pr_reg_atp_mem_list);
+			core_scsi3_lunacl_undepend_item(pr_reg_tmp->pr_reg_deve);
+			kmem_cache_free(t10_pr_reg_cache, pr_reg_tmp);
+		}
 
 		kfree(dest_pr_reg->pr_aptpl_buf);
 		kmem_cache_free(t10_pr_reg_cache, dest_pr_reg);
@@ -2003,18 +2200,6 @@ static int core_scsi3_pro_reserve(
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 	}
 	/*
-	 * For a given ALL_TG_PT=0 PR registration, a recevied PR reserve must
-	 * be on the same matching se_portal_group_t + se_lun_t.
-	 */
-	if (!(pr_reg->pr_reg_all_tg_pt) &&
-	     (pr_reg->pr_reg_tg_pt_lun != se_lun)) {
-		printk(KERN_ERR "SPC-3 PR: Unable to handle RESERVE because"
-			" ALL_TG_PT=0 and RESERVE was not received on same"
-			" target port as REGISTER\n");
-		core_scsi3_put_pr_reg(pr_reg);
-		return PYX_TRANSPORT_RESERVATION_CONFLICT;
-	}
-	/*
 	 * From spc4r17 Section 5.7.9: Reserving:
 	 *
 	 * An application client creates a persistent reservation by issuing
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index b6e4f0a..04741ae 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -361,6 +361,8 @@ typedef struct t10_pr_registration_s {
 	struct list_head pr_reg_list;
 	struct list_head pr_reg_abort_list;
 	struct list_head pr_reg_aptpl_list;
+	struct list_head pr_reg_atp_list;
+	struct list_head pr_reg_atp_mem_list;
 } ____cacheline_aligned t10_pr_registration_t;
 
 typedef struct t10_reservation_template_s {
@@ -929,6 +931,8 @@ typedef struct se_port_s {
 	/* Used for ALUA Target Port Groups membership */
 	atomic_t	sep_tg_pt_gp_active;
 	atomic_t	sep_tg_pt_secondary_offline;
+	/* Used for PR ALL_TG_PT=1 */
+	atomic_t	sep_tg_pt_ref_cnt;
 	spinlock_t	sep_alua_lock;
 	struct mutex	sep_tg_pt_md_mutex;
 	struct t10_alua_tg_pt_gp_member_s *sep_alua_tg_pt_gp_mem;
-- 
1.5.6.5

