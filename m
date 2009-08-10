From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/2] Target_Core_Mod/Persistent_Reservations]: Add APTPL
	feature support
Date: Mon, 10 Aug 2009 10:10:03 -0700
Message-ID: <1249924203.31984.0.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932363AbZHJRKY@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Joel Becker <joel.becker@oracle.com>, James Smart <James.Smart@Emulex.Com>, Philipp Reisner <philipp.reisner@linbit.com>, Florian Haas <florian.haas@linbit.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

This patch adds complete running support for persistent reservations feature:
Activate Persist across Target Power Loss (APTPL) against all of spc4r17
defined PROUT service actions.  This patch has been tested with PROUT service
actions REGISTER, RESERVE, RELEASE, CLEAR, PREEMPT_AND_ABORT and REGISTER_AND_MOVE
from a IBLOCK exported LVM dm block device on v2.6.31-rc5 x86 HVM.

This patch adds new functions core_scsi3_alloc_aptpl_registration() and
core_scsi3_aptpl_reserve() for handling the incoming PR APTPL metadata
from new target_core_mod/ConfigFS attributes.  These allocate and pre-register
the incoming persistent reservations metadata with target_core_mod, and
then proceeds to execute the PR operations as other different configfs operations
take place during normal target restart to bring up the fabric where the PR APTPL
metadata for each target_core_mod defined storage objects is re-read.

This patch also adds core_scsi3_check_aptpl_registration() that is called by TCM
Device Core code in core_dev_add_initiator_node_lun_acl() for making the final
association between the APTPL metadata registrations+reservation when the
SCSI Initiator LUN ACL (eg: iSCSI Initiator LUN ACL with lio_node.py --addlunacl)
is created during LIO-Target configfs bringup.  It also adds [__]core_scsi3_update_aptpl_buf(),
[__]core_scsi3_write_aptpl_to_file() for handling the writing out of metadata
from the dynamically allocated at registration time t10_pr_registration_t->pr_aptpl_buf
and out to struct file at /var/target/pr/aptpl_$T10_UNIT_SERIAL.

For PRIN service actions, it updates core_scsi3_pri_report_capabilities() to
support APTPL_C and APTPL_A feature bits.

Here is what it looks like as sg_persist operations after 2x REGISTER,
a RESERVE, then and PREEMPT_AND_ABORT, and REGISTER_AND_MOVE:

    target# tcm_node --prshowmd iblock_0/lvm_test0
    PR_REG_START: 0
    initiator_fabric=iSCSI
    initiator_node=iqn.1993-08.org.debian:01:2dadf92d0ef
    sa_res_key=1450770431
    res_holder=0
    res_all_tg_pt=0
    mapped_lun=0
    target_fabric=iSCSI
    target_node=iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd
    tpgt=1
    port_rtpi=1
    target_lun=0
    PR_REG_END: 0
    PR_REG_START: 1
    initiator_fabric=iSCSI
    initiator_node=iqn.1996-04.de.suse:01:1661f9ee7b5
    sa_res_key=1450770431
    res_holder=1
    res_type=05
    res_scope=00
    res_all_tg_pt=0
    mapped_lun=0
    target_fabric=iSCSI
    target_node=iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0
    tpgt=1
    port_rtpi=2
    target_lun=0
    PR_REG_END: 1

And from doing /etc/init.d/target restart at this point, the reload looks
like:

    target# tcm_node --pr iblock_0/lvm_test0
    APTPL Bit Status: Activated
    Ready to process PR APTPL metadata..
    SPC-3 Reservation: iSCSI Initiator: iqn.1996-04.de.suse:01:1661f9ee7b5
    SPC-3 Reservation: Single Target Port registration
    0x00000002
    SPC-3 Reservation: iSCSI Target Node Endpoint:
    iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0
    SPC-3 Reservation: Relative Port Identifer Tag: 2 iSCSI Portal Group Tag: 1
    iSCSI Logical Unit: 0
    SPC-3 PR Registrations:
    iSCSI Node: iqn.1993-08.org.debian:01:2dadf92d0ef Key: 0x000000005678ffff
    PRgen: 0x00000000
    iSCSI Node: iqn.1996-04.de.suse:01:1661f9ee7b5 Key: 0x000000005678ffff PRgen:
    0x00000001
    SPC-3 Reservation Type: Write Exclusive Access, Registrants Only
    SPC3_PERSISTENT_RESERVATIONS

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c |    6 +-
 drivers/target/target_core_pr.c     |  602 +++++++++++++++++++++++++++++++++--
 include/target/target_core_base.h   |   18 +
 include/target/target_core_pr.h     |   10 +
 4 files changed, 605 insertions(+), 31 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index fbdadb3..46cc450 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1380,7 +1380,11 @@ int core_dev_add_initiator_node_lun_acl(
 		TPG_TFO(tpg)->tpg_get_tag(tpg), unpacked_lun, lacl->mapped_lun,
 		(lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) ? "RW" : "RO",
 		lacl->initiatorname);
-
+	/*
+	 * Check to see if there are any existing persistent reservation APTPL
+	 * pre-registrations that need to be enabled for this LUN ACL..
+	 */
+	core_scsi3_check_aptpl_registration(lun->se_dev, tpg, lun, lacl);
 	return 0;
 }
 EXPORT_SYMBOL(core_dev_add_initiator_node_lun_acl);
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 1d345c6..252f1af 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -483,8 +483,10 @@ static t10_pr_registration_t *__core_scsi3_alloc_registration(
 	se_node_acl_t *nacl,
 	se_dev_entry_t *deve,
 	u64 sa_res_key,
-	int all_tg_pt)
+	int all_tg_pt,
+	int aptpl)
 {
+	se_subsystem_dev_t *su_dev = SU_DEV(dev);
 	t10_pr_registration_t *pr_reg;
 
 	pr_reg = kmem_cache_zalloc(t10_pr_reg_cache, GFP_ATOMIC);
@@ -493,19 +495,195 @@ static t10_pr_registration_t *__core_scsi3_alloc_registration(
 		return NULL;
 	}
 
+	pr_reg->pr_aptpl_buf = kzalloc(T10_RES(su_dev)->pr_aptpl_buf_len,
+					GFP_ATOMIC);
+	if (!(pr_reg->pr_aptpl_buf)) {
+		printk("Unable to allocate pr_reg->pr_aptpl_buf\n");
+		kmem_cache_free(t10_pr_reg_cache, pr_reg);
+		return NULL;
+	}
+
 	INIT_LIST_HEAD(&pr_reg->pr_reg_list);
 	INIT_LIST_HEAD(&pr_reg->pr_reg_abort_list);
+	INIT_LIST_HEAD(&pr_reg->pr_reg_aptpl_list);
 	atomic_set(&pr_reg->pr_res_holders, 0);
 	pr_reg->pr_reg_nacl = nacl;
 	pr_reg->pr_reg_deve = deve;
 	pr_reg->pr_res_mapped_lun = deve->mapped_lun;
+	pr_reg->pr_aptpl_target_lun = deve->se_lun->unpacked_lun;
 	pr_reg->pr_res_key = sa_res_key;
 	pr_reg->pr_reg_all_tg_pt = all_tg_pt;
+	pr_reg->pr_reg_aptpl = aptpl;
 	pr_reg->pr_reg_tg_pt_lun = deve->se_lun;
 
 	return pr_reg;
 }
 
+int core_scsi3_alloc_aptpl_registration(
+	t10_reservation_template_t *pr_tmpl,
+	u64 sa_res_key,
+	unsigned char *i_port,
+	u32 mapped_lun,
+	unsigned char *t_port,
+	u16 tpgt,
+	u32 target_lun,
+	int res_holder, 
+	int all_tg_pt,
+	u8 type)
+{
+	t10_pr_registration_t *pr_reg;
+
+	if (!(i_port) || !(t_port) || !(sa_res_key)) {
+		printk(KERN_ERR "Illegal parameters for APTPL registration\n");
+		return -1;
+	}
+
+	pr_reg = kmem_cache_zalloc(t10_pr_reg_cache, GFP_KERNEL);
+	if (!(pr_reg)) {
+		printk(KERN_ERR "Unable to allocate t10_pr_registration_t\n");
+		return -1;
+	}
+	pr_reg->pr_aptpl_buf = kzalloc(pr_tmpl->pr_aptpl_buf_len, GFP_KERNEL);
+	
+	INIT_LIST_HEAD(&pr_reg->pr_reg_list);
+	INIT_LIST_HEAD(&pr_reg->pr_reg_abort_list);
+	INIT_LIST_HEAD(&pr_reg->pr_reg_aptpl_list);
+	atomic_set(&pr_reg->pr_res_holders, 0);
+	pr_reg->pr_reg_nacl = NULL;
+	pr_reg->pr_reg_deve = NULL;
+	pr_reg->pr_res_mapped_lun = mapped_lun;
+	pr_reg->pr_aptpl_target_lun = target_lun;
+	pr_reg->pr_res_key = sa_res_key;
+	pr_reg->pr_reg_all_tg_pt = all_tg_pt;
+	pr_reg->pr_reg_aptpl = 1;
+	pr_reg->pr_reg_tg_pt_lun = NULL;
+	pr_reg->pr_res_scope = 0; /* Always LUN_SCOPE */
+	pr_reg->pr_res_type = type;
+	/*
+	 * Copy the i_port and t_port information from caller.
+	 */
+	snprintf(pr_reg->pr_iport, PR_APTPL_MAX_IPORT_LEN, "%s", i_port);
+	snprintf(pr_reg->pr_tport, PR_APTPL_MAX_TPORT_LEN, "%s", t_port);
+	pr_reg->pr_reg_tpgt = tpgt;
+	/*
+	 * Set pr_res_holder from caller, the pr_reg who is the reservation
+	 * holder will get it's pointer set in core_scsi3_aptpl_reserve() once
+	 * the Initiator Node LUN ACL from the fabric module is created for
+	 * this registration.
+	 */
+	pr_reg->pr_res_holder = res_holder;
+
+	list_add_tail(&pr_reg->pr_reg_aptpl_list, &pr_tmpl->aptpl_reg_list);
+	printk("SPC-3 PR APTPL Successfully added registration%s from"
+			" metadata\n", (res_holder) ? "+reservation" : "");
+	return 0;
+}
+
+static void core_scsi3_aptpl_reserve(
+	se_device_t *dev,
+	se_portal_group_t *tpg,
+	se_node_acl_t *node_acl,
+	t10_pr_registration_t *pr_reg)
+{
+	spin_lock(&dev->dev_reservation_lock);
+	dev->dev_pr_res_holder = pr_reg;
+	spin_unlock(&dev->dev_reservation_lock);
+
+	printk(KERN_INFO "SPC-3 PR [%s] Service Action: APTPL RESERVE created"
+		" new reservation holder TYPE: %s ALL_TG_PT: %d\n",
+		TPG_TFO(tpg)->get_fabric_name(),
+		core_scsi3_pr_dump_type(pr_reg->pr_res_type),
+		(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
+	printk(KERN_INFO "SPC-3 PR [%s] RESERVE Node: %s\n",
+		TPG_TFO(tpg)->get_fabric_name(), node_acl->initiatorname);
+}
+
+static void __core_scsi3_add_registration(se_device_t *, se_node_acl_t *,
+				t10_pr_registration_t *, int, int);
+
+static int __core_scsi3_check_aptpl_registration(
+	se_device_t *dev,
+	se_portal_group_t *tpg,
+	se_lun_t *lun,
+	u32 target_lun,
+	se_node_acl_t *nacl,
+	se_dev_entry_t *deve)
+	
+{
+	t10_pr_registration_t *pr_reg, *pr_reg_tmp;
+	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
+	unsigned char i_port[PR_APTPL_MAX_IPORT_LEN];
+	unsigned char t_port[PR_APTPL_MAX_TPORT_LEN];
+	u16 tpgt;
+
+	memset(i_port, 0, PR_APTPL_MAX_IPORT_LEN);
+	memset(t_port, 0, PR_APTPL_MAX_TPORT_LEN);
+	/*
+	 * Copy Initiator Port information from se_node_acl_t
+	 */
+	snprintf(i_port, PR_APTPL_MAX_IPORT_LEN, "%s", nacl->initiatorname);
+	snprintf(t_port, PR_APTPL_MAX_TPORT_LEN, "%s",
+			TPG_TFO(tpg)->tpg_get_wwn(tpg));
+	tpgt = TPG_TFO(tpg)->tpg_get_tag(tpg);
+
+	spin_lock(&pr_tmpl->aptpl_reg_lock);
+	list_for_each_entry_safe(pr_reg, pr_reg_tmp, &pr_tmpl->aptpl_reg_list,
+				pr_reg_aptpl_list) {
+		if (!(strcmp(pr_reg->pr_iport, i_port)) &&
+		     (pr_reg->pr_res_mapped_lun == deve->mapped_lun) &&
+		    !(strcmp(pr_reg->pr_tport, t_port)) &&
+		     (pr_reg->pr_reg_tpgt == tpgt) &&
+		     (pr_reg->pr_aptpl_target_lun == target_lun)) {
+
+			pr_reg->pr_reg_nacl = nacl;
+			pr_reg->pr_reg_deve = deve;
+			pr_reg->pr_reg_tg_pt_lun = lun;
+
+			list_del(&pr_reg->pr_reg_aptpl_list);
+			spin_unlock(&pr_tmpl->aptpl_reg_lock);
+			/*
+			 * At this point all of the pointers in *pr_reg will
+			 * be setup, so go ahead and add the registration.
+			 */
+
+			__core_scsi3_add_registration(dev, nacl, pr_reg, 0, 0); 
+			/*
+			 * If this registration is the reservation holder,
+			 * make that happen now..
+			 */	
+			if (pr_reg->pr_res_holder)
+				core_scsi3_aptpl_reserve(dev, tpg, nacl, pr_reg);
+			/*
+			 * Reenable pr_aptpl_active to accept new metadata updates once
+			 * the SCSI device is active again..
+			 */
+			pr_tmpl->pr_aptpl_active = 1;
+
+			return 1;
+		}
+	}
+	spin_unlock(&pr_tmpl->aptpl_reg_lock);
+
+	return 0;
+}
+
+int core_scsi3_check_aptpl_registration(
+	se_device_t *dev,
+	se_portal_group_t *tpg,
+	se_lun_t *lun,
+	se_lun_acl_t *lun_acl)
+{
+	se_subsystem_dev_t *su_dev = SU_DEV(dev);
+	se_node_acl_t *nacl = lun_acl->se_lun_nacl;
+	se_dev_entry_t *deve = &nacl->device_list[lun_acl->mapped_lun];
+
+	if (T10_RES(su_dev)->res_type != SPC3_PERSISTENT_RESERVATIONS)
+		return 0;
+
+	return __core_scsi3_check_aptpl_registration(dev, tpg, lun,
+				lun->unpacked_lun, nacl, deve);	
+}
+
 /*
  * this function can be called with se_device_t->dev_reservation_lock
  * when register_move = 1
@@ -547,8 +725,9 @@ static void __core_scsi3_add_registration(
 		(pr_reg->pr_reg_all_tg_pt) ? "ALL" : "SINGLE",
 		TRANSPORT(dev)->name);
 	printk(KERN_INFO "SPC-3 PR [%s] SA Res Key: 0x%016Lx PRgeneration:"
-		" 0x%08x\n", tfo->get_fabric_name(), pr_reg->pr_res_key,
-		pr_reg->pr_res_generation);
+		" 0x%08x  APTPL: %d\n", tfo->get_fabric_name(),
+		pr_reg->pr_res_key, pr_reg->pr_res_generation,
+		pr_reg->pr_reg_aptpl);
 	spin_unlock(&pr_tmpl->registration_lock);
 
 	return;
@@ -560,13 +739,14 @@ static int core_scsi3_alloc_registration(
 	se_dev_entry_t *deve,
 	u64 sa_res_key,
 	int all_tg_pt,
+	int aptpl,
 	int register_type,
 	int register_move)
 {
 	t10_pr_registration_t *pr_reg;
 
 	pr_reg = __core_scsi3_alloc_registration(dev, nacl, deve,
-			sa_res_key, all_tg_pt);
+			sa_res_key, all_tg_pt, aptpl);
 	if (!(pr_reg))
 		return -1;
 
@@ -686,6 +866,7 @@ static void __core_scsi3_free_registration(
 	if (!(preempt_and_abort_list)) {
 		pr_reg->pr_reg_deve = NULL;
 		pr_reg->pr_reg_nacl = NULL;
+		kfree(pr_reg->pr_aptpl_buf);
 		kmem_cache_free(t10_pr_reg_cache, pr_reg);
 		return;
 	}
@@ -749,13 +930,23 @@ void core_scsi3_free_all_registrations(
 		__core_scsi3_free_registration(dev, pr_reg, NULL, 0);
 	}
 	spin_unlock(&pr_tmpl->registration_lock);
+
+	spin_lock(&pr_tmpl->aptpl_reg_lock);
+	list_for_each_entry_safe(pr_reg, pr_reg_tmp, &pr_tmpl->aptpl_reg_list,
+				pr_reg_aptpl_list) {
+		list_del(&pr_reg->pr_reg_aptpl_list);	
+		kfree(pr_reg->pr_aptpl_buf);
+		kmem_cache_free(t10_pr_reg_cache, pr_reg);
+	}
+	spin_unlock(&pr_tmpl->aptpl_reg_lock);
 }
 
 static int core_scsi3_decode_spec_i_port(
 	se_cmd_t *cmd,
 	se_portal_group_t *tpg,
 	u64 sa_res_key,
-	int all_tg_pt)
+	int all_tg_pt,
+	int aptpl)
 {
 	se_lun_t *lun = SE_LUN(cmd);
 	se_port_t *port = lun->lun_sep;
@@ -793,7 +984,7 @@ static int core_scsi3_decode_spec_i_port(
 
 	local_pr_reg = __core_scsi3_alloc_registration(SE_DEV(cmd),
                                 se_sess->se_node_acl, local_se_deve,
-                                sa_res_key, all_tg_pt);
+                                sa_res_key, all_tg_pt, aptpl);
 	if (!(local_pr_reg)) {
 		kfree(tidh_new);
 		return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -997,7 +1188,7 @@ static int core_scsi3_decode_spec_i_port(
 		 */
 		dest_pr_reg = __core_scsi3_alloc_registration(SE_DEV(cmd),
 				dest_node_acl, dest_se_deve,
-				sa_res_key, all_tg_pt);
+				sa_res_key, all_tg_pt, aptpl);
 		if (!(dest_pr_reg)) { 
 			configfs_undepend_item(TPG_TFO(tpg)->tf_subsys,
 				&dest_se_deve->se_lun_acl->se_lun_group.cg_item);
@@ -1069,6 +1260,7 @@ out:
 		list_del(&tidh->dest_list);
 		kfree(tidh);
 
+		kfree(dest_pr_reg->pr_aptpl_buf);
 		kmem_cache_free(t10_pr_reg_cache, dest_pr_reg);		
 		
 		if (dest_local_nexus)
@@ -1082,6 +1274,215 @@ out:
 	return ret;	
 }
 
+/*
+ * Called with se_device_t->dev_reservation_lock held
+ */
+static int __core_scsi3_update_aptpl_buf(
+	se_device_t *dev,
+	unsigned char *buf,
+	u32 pr_aptpl_buf_len,
+	int clear_aptpl_metadata)
+{
+	se_lun_t *lun;
+	se_portal_group_t *tpg;
+	se_subsystem_dev_t *su_dev = SU_DEV(dev);
+	t10_pr_registration_t *pr_reg;
+	unsigned char tmp[1024];
+	ssize_t len = 0;
+	int reg_count = 0;
+	
+	memset(buf, 0, pr_aptpl_buf_len);
+	/*
+	 * Called to clear metadata once APTPL has been deactivated.
+	 */
+	if (clear_aptpl_metadata) {
+		snprintf(buf, pr_aptpl_buf_len,
+				"No Registrations or Reservations\n");
+		return 0;
+	}
+	/*
+	 * Walk the registration list..
+	 */	
+	spin_lock(&T10_RES(su_dev)->registration_lock);
+	list_for_each_entry(pr_reg, &T10_RES(su_dev)->registration_list,
+			pr_reg_list) {
+	
+		memset(tmp, 0, 1024);
+		tpg = pr_reg->pr_reg_nacl->se_tpg;
+		lun = pr_reg->pr_reg_tg_pt_lun;
+		/*
+		 * Include special metadata if the pr_reg matches the
+		 * reservation holder.
+		 */
+		if (dev->dev_pr_res_holder == pr_reg) {
+			snprintf(tmp, 1024, "PR_REG_START: %d"
+				"\ninitiator_fabric=%s\n"
+				"initiator_node=%s\n"
+				"sa_res_key=%llu\n"
+				"res_holder=1\nres_type=%02x\n"
+				"res_scope=%02x\nres_all_tg_pt=%d\n"
+				"mapped_lun=%u\n", reg_count,
+				TPG_TFO(tpg)->get_fabric_name(),
+				pr_reg->pr_reg_nacl->initiatorname,
+				pr_reg->pr_res_key, pr_reg->pr_res_type,
+				pr_reg->pr_res_scope, pr_reg->pr_reg_all_tg_pt,
+				pr_reg->pr_res_mapped_lun);
+		} else {
+			snprintf(tmp, 1024, "PR_REG_START: %d\n"
+				"initiator_fabric=%s\ninitiator_node=%s\n"
+				"sa_res_key=%llu\nres_holder=0\n"
+				"res_all_tg_pt=%d\nmapped_lun=%u\n",
+				reg_count, TPG_TFO(tpg)->get_fabric_name(),
+				pr_reg->pr_reg_nacl->initiatorname,
+				pr_reg->pr_res_key, pr_reg->pr_reg_all_tg_pt,
+				pr_reg->pr_res_mapped_lun);
+		}
+
+		if ((len + strlen(tmp) > pr_aptpl_buf_len)) {
+			printk(KERN_ERR "Unable to update renaming"
+				" APTPL metadata\n");
+			spin_unlock(&T10_RES(su_dev)->registration_lock);
+			return -1;
+		}
+		len += sprintf(buf+len, "%s", tmp);
+
+		/*
+		 * Include information about the associated SCSI target port.
+		 */		
+		snprintf(tmp, 1024, "target_fabric=%s\ntarget_node=%s\n"
+			"tpgt=%hu\nport_rtpi=%hu\ntarget_lun=%u\nPR_REG_END: %d\n",
+			TPG_TFO(tpg)->get_fabric_name(),
+			TPG_TFO(tpg)->tpg_get_wwn(tpg),
+			TPG_TFO(tpg)->tpg_get_tag(tpg),
+			lun->lun_sep->sep_rtpi, lun->unpacked_lun, reg_count);
+
+		if ((len + strlen(tmp) > pr_aptpl_buf_len)) {
+			printk(KERN_ERR "Unable to update renaming"
+				" APTPL metadata\n");
+			spin_unlock(&T10_RES(su_dev)->registration_lock);
+			return -1;
+		}
+		len += sprintf(buf+len, "%s", tmp);
+		reg_count++;
+	}
+	spin_unlock(&T10_RES(su_dev)->registration_lock);
+
+	 if (!(reg_count))
+		len += sprintf(buf+len, "No Registrations or Reservations");
+
+	return 0;
+}
+
+static int core_scsi3_update_aptpl_buf(
+	se_device_t *dev,
+	unsigned char *buf,
+	u32 pr_aptpl_buf_len,
+	int clear_aptpl_metadata)
+{
+	int ret;
+
+	spin_lock(&dev->dev_reservation_lock);
+	ret = __core_scsi3_update_aptpl_buf(dev, buf, pr_aptpl_buf_len,
+				clear_aptpl_metadata);
+	spin_unlock(&dev->dev_reservation_lock);
+
+	return ret;
+}
+
+/*
+ * Called with se_device_t->aptpl_file_mutex held
+ */
+static int __core_scsi3_write_aptpl_to_file(
+	se_device_t *dev,
+	unsigned char *buf,
+	u32 pr_aptpl_buf_len)
+{
+	t10_wwn_t *wwn = &SU_DEV(dev)->t10_wwn;
+	struct file *file;
+	struct iovec iov[1];
+	mm_segment_t old_fs;
+	int flags = O_RDWR | O_CREAT | O_TRUNC;
+	char path[512];
+        int ret;
+
+	memset(iov, 0, sizeof(struct iovec));
+	memset(path, 0, 512);
+
+	if (strlen(&wwn->unit_serial[0]) > 512) {
+		printk(KERN_ERR "WWN value for se_device_t does not fit"
+			" into path buffer\n");
+		return -1;
+	}
+
+	snprintf(path, 512, "/var/target/pr/aptpl_%s", &wwn->unit_serial[0]);
+	file = filp_open(path, flags, 0600);
+	if (IS_ERR(file) || !file || !file->f_dentry) {
+		printk(KERN_ERR "filp_open(%s) for APTPL metadata"
+			" failed\n", path);
+		return -1;
+	}
+
+	iov[0].iov_base = &buf[0];
+	if (!(pr_aptpl_buf_len))
+		iov[0].iov_len = (strlen(&buf[0]) + 1); /* Add extra for NULL */
+	else
+		iov[0].iov_len = pr_aptpl_buf_len;
+
+	old_fs = get_fs();
+	set_fs(get_ds());
+	ret = vfs_writev(file, &iov[0], 1, &file->f_pos);
+	set_fs(old_fs);
+
+	if (ret < 0) {
+		printk("Error writing APTPL metadata file: %s\n", path);
+		filp_close(file, NULL);
+		return -1;
+	}
+	filp_close(file, NULL);	
+
+	return 0;
+}
+
+static int core_scsi3_update_and_write_aptpl(
+	se_device_t *dev,
+	unsigned char *in_buf,
+	u32 in_pr_aptpl_buf_len)
+{
+	unsigned char null_buf[64], *buf;
+	u32 pr_aptpl_buf_len;
+	int ret, clear_aptpl_metadata = 0;
+	/*
+	 * Can be called with a NULL pointer from PROUT service action CLEAR
+	 */
+	if (!(in_buf)) {
+		memset(null_buf, 0, 64);
+		buf = &null_buf[0];
+		/*
+		 * This will clear the APTPL metadata to:
+		 * "No Registrations or Reservations" status
+		 */
+		pr_aptpl_buf_len = 64;
+		clear_aptpl_metadata = 1;
+	} else {
+		buf = in_buf;
+		pr_aptpl_buf_len = in_pr_aptpl_buf_len;
+	}
+
+	ret = core_scsi3_update_aptpl_buf(dev, buf, pr_aptpl_buf_len,
+				clear_aptpl_metadata);
+	if (ret != 0)
+		return -1;
+	/*
+	 * __core_scsi3_write_aptpl_to_file() will call strlen()
+	 * on the passed buf to determine pr_aptpl_buf_len.
+	 */
+	ret = __core_scsi3_write_aptpl_to_file(dev, buf, 0);
+	if (ret != 0)
+		return -1;
+
+	return ret;
+}
+
 static int core_scsi3_emulate_pro_register(
 	se_cmd_t *cmd,
 	u64 res_key,
@@ -1098,6 +1499,7 @@ static int core_scsi3_emulate_pro_register(
 	se_portal_group_t *se_tpg;
 	t10_pr_registration_t *pr_reg, *pr_reg_p;
 	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
+	unsigned char *pr_aptpl_buf = NULL; /* Used for APTPL metadata w/ UNREGISTER */
 	int pr_holder = 0, ret = 0, type;
 
 	if (!(se_sess) || !(se_lun)) {
@@ -1106,12 +1508,6 @@ static int core_scsi3_emulate_pro_register(
 	}
 	se_tpg = se_sess->se_tpg;
 	se_deve = &se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
-
-	if (aptpl) {
-		printk(KERN_INFO "Activate Persistence across Target Power"
-			" Loss = 1 not implemented yet\n");
-		return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
-	}
 	/*
 	 * Follow logic from spc4r17 Section 5.7.7, Register Behaviors Table 47
 	 */
@@ -1135,7 +1531,8 @@ static int core_scsi3_emulate_pro_register(
 			 */
 			ret = core_scsi3_alloc_registration(SE_DEV(cmd),
 					se_sess->se_node_acl, se_deve,
-					sa_res_key, all_tg_pt, ignore_key, 0);
+					sa_res_key, all_tg_pt, aptpl,
+					ignore_key, 0);
 			if (ret != 0) {
 				printk(KERN_ERR "Unable to allocate"
 					" t10_pr_registration_t\n");
@@ -1151,10 +1548,38 @@ static int core_scsi3_emulate_pro_register(
 			 * TransportID provided SCSI Initiator Port/Device
 			 */
 			ret = core_scsi3_decode_spec_i_port(cmd, se_tpg,
-						sa_res_key, all_tg_pt);
+						sa_res_key, all_tg_pt, aptpl);
 			if (ret != 0)
 				return ret;
 		}
+		/*
+		 * Nothing left to do for the APTPL=0 case.
+		 */
+		if (!(aptpl)) {
+			pr_tmpl->pr_aptpl_active = 0;
+			core_scsi3_update_and_write_aptpl(SE_DEV(cmd), NULL, 0);
+			printk("SPC-3 PR: Set APTPL Bit Deactivated for"
+					" REGISTER\n");
+			return 0;
+		}
+		/*
+		 * Locate the newly allocated local I_T Nexus *pr_reg, and
+		 * update the APTPL metadata information using its
+		 * preallocated *pr_reg->pr_aptpl_buf.
+		 */
+		pr_reg = core_scsi3_locate_pr_reg(SE_DEV(cmd),
+				se_sess->se_node_acl);
+
+		ret = core_scsi3_update_and_write_aptpl(SE_DEV(cmd),
+				&pr_reg->pr_aptpl_buf[0],
+				pr_tmpl->pr_aptpl_buf_len);
+		if (!(ret)) {
+			pr_tmpl->pr_aptpl_active = 1;
+			printk("SPC-3 PR: Set APTPL Bit Activated for REGISTER\n");
+		}
+
+		core_scsi3_put_pr_reg(pr_reg);	
+		return ret;
 	} else {
 		/*
 		 * Locate the existing *pr_reg via se_node_acl_t pointers
@@ -1186,6 +1611,19 @@ static int core_scsi3_emulate_pro_register(
 			return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 		}
 		/*
+		 * Allocate APTPL metadata buffer used for UNREGISTER ops
+		 */
+		if (aptpl) {
+			pr_aptpl_buf = kzalloc(pr_tmpl->pr_aptpl_buf_len,
+						GFP_KERNEL);
+			if (!(pr_aptpl_buf)) {
+				printk(KERN_ERR "Unable to allocate"
+					" pr_aptpl_buf\n");
+				core_scsi3_put_pr_reg(pr_reg);
+				return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+			}
+		}
+		/*
 		 * sa_res_key=0 Unregister Reservation Key for registered I_T
 		 * Nexus sa_res_key=1 Change Reservation Key for registered I_T
 		 * Nexus.
@@ -1226,6 +1664,26 @@ static int core_scsi3_emulate_pro_register(
 				}
 			}
 			spin_unlock(&pr_tmpl->registration_lock);
+
+			if (!(aptpl)) {
+				pr_tmpl->pr_aptpl_active = 0;
+				core_scsi3_update_and_write_aptpl(dev, NULL, 0);
+				printk("SPC-3 PR: Set APTPL Bit Deactivated"
+						" for UNREGISTER\n");
+				return 0;
+			}
+
+			ret = core_scsi3_update_and_write_aptpl(dev,
+					&pr_aptpl_buf[0],
+					pr_tmpl->pr_aptpl_buf_len);
+			if (!(ret)) {
+				pr_tmpl->pr_aptpl_active = 1;
+				printk("SPC-3 PR: Set APTPL Bit Activated"
+						" for UNREGISTER\n");
+			}
+
+			kfree(pr_aptpl_buf);
+			return ret;
 		} else {
 			/*
 			 * Increment PRgeneration counter for se_device_t"
@@ -1245,7 +1703,6 @@ static int core_scsi3_emulate_pro_register(
 			core_scsi3_put_pr_reg(pr_reg);
 		}
 	}
-
 	return 0;
 }
 
@@ -1283,6 +1740,8 @@ static int core_scsi3_pro_reserve(
 	se_lun_t *se_lun = SE_LUN(cmd);
 	se_portal_group_t *se_tpg;
 	t10_pr_registration_t *pr_reg, *pr_res_holder;
+	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
+	int ret;
 
 	if (!(se_sess) || !(se_lun)) {
 		printk(KERN_ERR "SPC-3 PR: se_sess || se_lun_t is NULL!\n");
@@ -1429,6 +1888,14 @@ static int core_scsi3_pro_reserve(
 			se_sess->se_node_acl->initiatorname);
 	spin_unlock(&dev->dev_reservation_lock);
 
+	if (pr_tmpl->pr_aptpl_active) {
+		ret = core_scsi3_update_and_write_aptpl(SE_DEV(cmd),
+				&pr_reg->pr_aptpl_buf[0],
+				pr_tmpl->pr_aptpl_buf_len);
+		if (!(ret))
+			printk("SPC-3 PR: Updated APTPL metadata for RESERVE\n");
+	}
+
 	core_scsi3_put_pr_reg(pr_reg);
 	return 0;
 }
@@ -1500,6 +1967,7 @@ static int core_scsi3_emulate_pro_release(
 	se_lun_t *se_lun = SE_LUN(cmd);
 	t10_pr_registration_t *pr_reg, *pr_reg_p, *pr_res_holder;
 	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
+	int ret;
 
 	if (!(se_sess) || !(se_lun)) {
 		printk(KERN_ERR "SPC-3 PR: se_sess || se_lun_t is NULL!\n");
@@ -1634,6 +2102,14 @@ static int core_scsi3_emulate_pro_release(
 	}
 	spin_unlock(&pr_tmpl->registration_lock);
 
+	if (pr_tmpl->pr_aptpl_active) {
+	        ret = core_scsi3_update_and_write_aptpl(SE_DEV(cmd),
+				&pr_reg->pr_aptpl_buf[0],
+				pr_tmpl->pr_aptpl_buf_len);
+		if (!(ret))
+			printk("SPC-3 PR: Updated APTPL metadata for RELEASE\n");
+	}
+
 	core_scsi3_put_pr_reg(pr_reg);
 	return 0;
 }
@@ -1717,6 +2193,11 @@ static int core_scsi3_emulate_pro_clear(
 	printk(KERN_INFO "SPC-3 PR [%s] Service Action: CLEAR complete\n",
 		CMD_TFO(cmd)->get_fabric_name());
 
+	if (pr_tmpl->pr_aptpl_active) {
+		core_scsi3_update_and_write_aptpl(SE_DEV(cmd), NULL, 0);
+		printk("SPC-3 PR: Updated APTPL metadata for CLEAR\n");
+	}
+
 	core_scsi3_pr_generation(dev);
 	return 0;
 }
@@ -1783,6 +2264,7 @@ static void core_scsi3_release_preempt_and_abort(
 
 		pr_reg->pr_reg_deve = NULL;
 		pr_reg->pr_reg_nacl = NULL;
+		kfree(pr_reg->pr_aptpl_buf);
 		kmem_cache_free(t10_pr_reg_cache, pr_reg);
 	}
 }
@@ -1802,7 +2284,7 @@ int core_scsi3_check_cdb_abort_and_preempt(
 	return 1;
 }
 
-static int core_scsi3_emulate_pro_preempt(
+static int core_scsi3_pro_preempt(
 	se_cmd_t *cmd,
 	int type,
 	int scope,
@@ -1819,7 +2301,7 @@ static int core_scsi3_emulate_pro_preempt(
 	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
 	u32 pr_res_mapped_lun = 0;
 	int all_reg = 0, calling_it_nexus = 0, released_regs = 0;
-	int prh_type = 0, prh_scope = 0;
+	int prh_type = 0, prh_scope = 0, ret;
 
 	if (!(se_sess))
 		return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -1968,6 +2450,15 @@ static int core_scsi3_emulate_pro_preempt(
 		}
 		spin_unlock(&dev->dev_reservation_lock);
 
+		if (pr_tmpl->pr_aptpl_active) {
+			ret = core_scsi3_update_and_write_aptpl(SE_DEV(cmd),
+					&pr_reg_n->pr_aptpl_buf[0],
+					pr_tmpl->pr_aptpl_buf_len);
+			if (!(ret))
+				printk("SPC-3 PR: Updated APTPL metadata for"
+					" PREEMPT%s\n", (abort) ? "_AND_ABORT" : "");
+		}
+
 		core_scsi3_put_pr_reg(pr_reg_n);
 		core_scsi3_pr_generation(SE_DEV(cmd));
 		return 0;
@@ -2094,11 +2585,50 @@ static int core_scsi3_emulate_pro_preempt(
 						pr_reg_n);
 	}
 
+	if (pr_tmpl->pr_aptpl_active) {
+		ret = core_scsi3_update_and_write_aptpl(SE_DEV(cmd),
+				&pr_reg_n->pr_aptpl_buf[0],
+				pr_tmpl->pr_aptpl_buf_len);
+		if (!(ret))
+			printk("SPC-3 PR: Updated APTPL metadata for PREEMPT"
+				"%s\n", (abort) ? "_AND_ABORT" : "");
+	}
+
 	core_scsi3_put_pr_reg(pr_reg_n);
 	core_scsi3_pr_generation(SE_DEV(cmd));
 	return 0;
 }
 
+static int core_scsi3_emulate_pro_preempt(
+	se_cmd_t *cmd,
+	int type,
+	int scope,
+	u64 res_key,
+	u64 sa_res_key,
+	int abort)
+{
+	int ret = 0;
+
+	switch (type) {
+	case PR_TYPE_WRITE_EXCLUSIVE:
+	case PR_TYPE_EXCLUSIVE_ACCESS:
+	case PR_TYPE_WRITE_EXCLUSIVE_REGONLY:
+	case PR_TYPE_EXCLUSIVE_ACCESS_REGONLY:
+	case PR_TYPE_WRITE_EXCLUSIVE_ALLREG:
+	case PR_TYPE_EXCLUSIVE_ACCESS_ALLREG:
+		ret = core_scsi3_pro_preempt(cmd, type, scope,
+				res_key, sa_res_key, abort);
+		break;
+	default:
+		printk(KERN_ERR "SPC-3 PR: Unknown Service Action PREEMPT%s"
+			" Type: 0x%02x\n", (abort) ? "_AND_ABORT" : "", type);
+		return PYX_TRANSPORT_INVALID_CDB_FIELD;
+	}
+	
+	return ret;
+}
+
+
 static int core_scsi3_emulate_pro_register_and_move(
 	se_cmd_t *cmd,
 	u64 res_key,
@@ -2132,12 +2662,6 @@ static int core_scsi3_emulate_pro_register_and_move(
 	se_tpg = se_sess->se_tpg;
 	tf_ops = TPG_TFO(se_tpg);
 	se_deve = &se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
-
-	if (aptpl) {
-		printk(KERN_INFO "Activate Persistence across Target Power"
-			" Loss = 1 not implemented yet\n");
-		return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
-	}
 	/*
 	 * Follow logic from spc4r17 Section 5.7.8, Table 50 --
 	 *	Register behaviors for a REGISTER AND MOVE service action
@@ -2428,7 +2952,7 @@ static int core_scsi3_emulate_pro_register_and_move(
 	if (!(dest_se_deve->deve_flags & DEF_PR_REGISTERED)) {
 		ret = core_scsi3_alloc_registration(SE_DEV(cmd),
 				dest_node_acl, dest_se_deve,
-				sa_res_key, 0, 2, 1);
+				sa_res_key, 0, aptpl, 2, 1);
 		if (ret != 0) {
 			spin_unlock(&dev->dev_reservation_lock);
 			ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
@@ -2501,6 +3025,25 @@ static int core_scsi3_emulate_pro_register_and_move(
 	} else
 		core_scsi3_put_pr_reg(pr_reg);
 
+	/*
+	 * Clear the APTPL metadata if APTPL has been disabled, otherwise
+	 * write out the updated metadata to struct file for this SCSI device.
+	 */
+	if (!(aptpl)) {
+		pr_tmpl->pr_aptpl_active = 0;
+		core_scsi3_update_and_write_aptpl(SE_DEV(cmd), NULL, 0);
+		printk("SPC-3 PR: Set APTPL Bit Deactivated for"
+				" REGISTER_AND_MOVE\n");
+	} else {
+		pr_tmpl->pr_aptpl_active = 1;
+	        ret = core_scsi3_update_and_write_aptpl(SE_DEV(cmd),
+        	                &dest_pr_reg->pr_aptpl_buf[0],
+				pr_tmpl->pr_aptpl_buf_len);
+		if (!(ret))
+			printk("SPC-3 PR: Set APTPL Bit Activated for"
+					" REGISTER_AND_MOVE\n");
+	}
+
 	core_scsi3_put_pr_reg(dest_pr_reg);
 	return 0;
 out:
@@ -2771,6 +3314,8 @@ static int core_scsi3_pri_read_reservation(se_cmd_t *cmd)
  */
 static int core_scsi3_pri_report_capabilities(se_cmd_t *cmd)
 {
+	se_device_t *dev = SE_DEV(cmd);
+	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
 	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
 	u16 add_len = 8; /* Hardcoded to 8. */
 
@@ -2790,9 +3335,7 @@ static int core_scsi3_pri_report_capabilities(se_cmd_t *cmd)
 #endif
 	buf[2] |= 0x08; /* SIP_C: Specify Initiator Ports Capable bit */
 	buf[2] |= 0x04; /* ATP_C: All Target Ports Capable bit */
-#if 0
 	buf[2] |= 0x01; /* PTPL_C: Persistence across Target Power Loss bit */
-#endif
 	/*
 	 * We are filling in the PERSISTENT RESERVATION TYPE MASK below, so
 	 * set the TMV: Task Mask Valid bit.
@@ -2805,9 +3348,8 @@ static int core_scsi3_pri_report_capabilities(se_cmd_t *cmd)
 	/*
 	 * PTPL_A: Persistence across Target Power Loss Active bit
 	 */
-#if 0
-	buf[3] |= 0x01;
-#endif
+	if (pr_tmpl->pr_aptpl_active)
+		buf[3] |= 0x01;
 	/*
 	 * Setup the PERSISTENT RESERVATION TYPE MASK from Table 167
 	 */
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 580fa94..41aec3e 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -72,6 +72,11 @@
 #define SNAP_GROUP_LEN				128
 /* Used for se_dev_snap_attrib->lvc_size */
 #define SNAP_LVC_LEN				32
+/* Used by t10_reservation_template_s->pr_[i,t]_port[] */
+#define PR_APTPL_MAX_IPORT_LEN			256
+#define PR_APTPL_MAX_TPORT_LEN			256
+/* Used by t10_reservation_template_s->pr_aptpl_buf_len */
+#define PR_APTPL_BUF_LEN			8192
 
 /* used by PSCSI and iBlock Transport drivers */
 #define READ_BLOCK_LEN          		6
@@ -291,11 +296,18 @@ typedef enum {
 struct se_cmd_s;
 
 typedef struct t10_pr_registration_s {
+	unsigned char pr_iport[PR_APTPL_MAX_IPORT_LEN]; /* Used during APTPL metadata reading */
+	unsigned char pr_tport[PR_APTPL_MAX_TPORT_LEN]; /* Used during APTPL metadata reading */
+	unsigned char *pr_aptpl_buf; /* For writing out live meta data */
+	u16 pr_aptpl_rpti;
+	u16 pr_reg_tpgt;
 	int pr_reg_all_tg_pt; /* Reservation effects all target ports */
+	int pr_reg_aptpl; /* Activate Persistence across Target Power Loss */
 	int pr_res_holder;
 	int pr_res_type;
 	int pr_res_scope;
 	u32 pr_res_mapped_lun;
+	u32 pr_aptpl_target_lun;
 	u32 pr_res_generation;
 	u64 pr_res_key;
 	atomic_t pr_res_holders;
@@ -304,17 +316,23 @@ typedef struct t10_pr_registration_s {
 	struct se_lun_s *pr_reg_tg_pt_lun;
 	struct list_head pr_reg_list;
 	struct list_head pr_reg_abort_list;
+	struct list_head pr_reg_aptpl_list;
 } ____cacheline_aligned t10_pr_registration_t;
 
 typedef struct t10_reservation_template_s {
 	/* Reservation effects all target ports */
 	int pr_all_tg_pt;
+	/* Activate Persistence across Target Power Loss enabled for SCSI device */
+	int pr_aptpl_active;
+	u32 pr_aptpl_buf_len;
 	u32 pr_generation;
 	t10_reservations_index_t res_type;
 	spinlock_t registration_lock;
+	spinlock_t aptpl_reg_lock;
 	/* Reservation holder when pr_all_tg_pt=1 */
 	struct se_node_acl_s *pr_res_holder;
 	struct list_head registration_list;
+	struct list_head aptpl_reg_list;
 	int (*t10_reservation_check)(struct se_cmd_s *, u32 *);
 	int (*t10_reserve)(struct se_cmd_s *);
 	int (*t10_release)(struct se_cmd_s *);
diff --git a/include/target/target_core_pr.h b/include/target/target_core_pr.h
index 23d9e18..c791506 100644
--- a/include/target/target_core_pr.h
+++ b/include/target/target_core_pr.h
@@ -40,8 +40,18 @@
 #define PR_TYPE_WRITE_EXCLUSIVE_ALLREG		0x07
 #define PR_TYPE_EXCLUSIVE_ACCESS_ALLREG		0x08
 
+#define PR_APTPL_MAX_IPORT_LEN			256
+#define PR_APTPL_MAX_TPORT_LEN			256
+
 extern struct kmem_cache *t10_pr_reg_cache;
 
+extern int core_scsi3_alloc_aptpl_registration(
+			struct t10_reservation_template_s *, u64,
+			unsigned char *, u32, unsigned char *, u16, u32,
+			int, int, u8);
+extern int core_scsi3_check_aptpl_registration(struct se_device_s *,
+			struct se_portal_group_s *, struct se_lun_s *,
+			struct se_lun_acl_s *);
 extern void core_scsi3_free_pr_reg_from_nacl(struct se_device_s *,
 					     struct se_node_acl_s *);
 extern void core_scsi3_free_all_registrations(struct se_device_s *);
-- 
1.5.4.1
