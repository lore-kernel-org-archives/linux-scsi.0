From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod/Persistent_Reservations]: Add support for
	PREEMPT_AND_ABORT SA
Date: Fri, 27 Mar 2009 01:46:32 -0700
Message-ID: <1238143592.4250.58.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:24308 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752795AbZC0Iqi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Mar 2009 04:46:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Alan Stern <stern@rowland.harvard.edu>, Douglas Gilbert <dgilbert@interlog.com>, Alasdair G Kergon <agk@redhat.com>, Philipp Reisner <philipp.reisner@linbit.com>, Ming Zhang <blackmagic02881@gmail.com>

Greetings all,

This patch adds support for the PROUT PREEMPT_AND_ABORT service action to
core_scsi3_emulate_pro_preempt() and core_tmr_lun_reset() using existing TAS
(TASK_ABORTED status) emulation.  The logic assigns the initiator port
provided pre-registered reservation key to allocated SCSI Task and Task Management
through logical unit ACLs in target_core_mod code.

This patch uses struct list_head preempt_and_abort_list inside of
core_scsi3_emulate_pro_preempt() to track PR registrations/reservation
data structure t10_pr_registration_t once it has been removed from the
se_device_t list, and before they get released back into struct kmem_cache
t10_pr_reg_cache in core_scsi3_release_preempt_and_abort().

These patches are made against lio-core-2.6.git/master and tested on
v2.6.29 x86 32-bit HVM using sg_persist and sg_request from sg3_utils.
The lio-core-2.6.git tree can be found at: 

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

So far, I have been primarily testing the following scenario, which is what
linux-cluster userspace in RHEL/CentOS (and everyone else) does with fence_scsi
today for their WRITE Exclusive, Registrants Only persistent
reservation setup.  Here is test setup I am using:

# The same /sys/kernel/config/target/core/$HBA/$DEV Linux LVM object mapped across
# two different LIO-Target iSCSI target ports
initiator# lsscsi --transport
[3:0:0:0]    disk    iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd,t,0x1  /dev/sde
[4:0:0:0]    disk    iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0,t,0x1  /dev/sdf

*) Initiator side using Open/iSCSI:

[  185.682972] scsi3 : iSCSI Initiator over TCP/IP
[  185.998817] scsi 3:0:0:0: Direct-Access     LIO-ORG  IBLOCK           3.0  PQ: 0 ANSI: 5
[  186.009172] sd 3:0:0:0: [sde] 128000 4096-byte hardware sectors (524 MB)
[  186.013274] sd 3:0:0:0: [sde] Write Protect is off
[  186.013286] sd 3:0:0:0: [sde] Mode Sense: 2f 00 00 00
[  186.034372] sd 3:0:0:0: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  186.045854] sd 3:0:0:0: [sde] 128000 4096-byte hardware sectors (524 MB)
[  186.054955] sd 3:0:0:0: [sde] Write Protect is off
[  186.054967] sd 3:0:0:0: [sde] Mode Sense: 2f 00 00 00
[  186.072648] sd 3:0:0:0: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  186.073401]  sde: unknown partition table
[  186.084108] sd 3:0:0:0: [sde] Attached SCSI disk
[  186.085052] sd 3:0:0:0: Attached scsi generic sg4 type 0
[  186.316470] alua: device handler registered
[  186.321957] sd 3:0:0:0: alua: supports implicit TPGS
[  186.326881] sd 3:0:0:0: alua: port group 00 rel port 02
[  186.331445] sd 3:0:0:0: alua: port group 00 state A supports tousNA
[  186.372696] sd 3:0:0:0: alua: port group 00 state A supports tousNA
[  188.204172] scsi4 : iSCSI Initiator over TCP/IP
[  188.481410] scsi 4:0:0:0: Direct-Access     LIO-ORG  IBLOCK           3.0  PQ: 0 ANSI: 5
[  188.489828] sd 4:0:0:0: [sdf] 128000 4096-byte hardware sectors (524 MB)
[  188.497081] sd 4:0:0:0: [sdf] Write Protect is off
[  188.497093] sd 4:0:0:0: [sdf] Mode Sense: 2f 00 00 00
[  188.512344] sd 4:0:0:0: [sdf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  188.525858] sd 4:0:0:0: [sdf] 128000 4096-byte hardware sectors (524 MB)
[  188.534314] sd 4:0:0:0: [sdf] Write Protect is off
[  188.534325] sd 4:0:0:0: [sdf] Mode Sense: 2f 00 00 00
[  188.550966] sd 4:0:0:0: [sdf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  188.557596]  sdf: unknown partition table

# Register both ports
initiator# sg_persist --out --register --param-sark=0x1234abcd -Y -v /dev/sde
initiator# sg_persist --out --register --param-sark=0x4567ffff -Y -v /dev/sdf
# Create a write exclusive, registrants only persistent reservation
initiator# sg_persist --out --reserve --param-rk=0x1234abcd --prout-type=5 -v /dev/sde

... Start running READ/WRITE I/O to /dev/sde ...

# Preempt the reservation on /dev/sdf using /dev/sde's reservation key..
initiator# sg_persist --out --preempt-abort --param-rk=0x4567ffff --param-sark=0x1234abcd --prout-type 5 -v /dev/sdf

[  199.570148] sd 3:0:0:0: reservation conflict
[  205.461349] sd 3:0:0:0: reservation conflict
[  205.462076] sd 3:0:0:0: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
[  205.462228] end_request: I/O error, dev sde, sector 384
[  205.480997] sd 3:0:0:0: reservation conflict
[  205.481013] sd 3:0:0:0: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK

# Re-Register on the port that has been preempted
initiator# sg_persist --out --register --param-sark=0x1234abcd -Y -v /dev/sde

... Start running READ/WRITE I/O to /dev/sdf ..

# Preempt the reservation on /dev/sde using /dev/sdf's reservation key..
initiator# sg_persist --out --preempt-abort --param-rk=0x1234abcd --param-sark=0x4567ffff --prout-type 5 -v /dev/sde

[  269.379004] sd 4:0:0:0: reservation conflict
[  269.379021] sd 4:0:0:0: [sdf] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
[  269.379030] end_request: I/O error, dev sdf, sector 1280
[  269.414193] sd 4:0:0:0: reservation conflict
[  269.414210] sd 4:0:0:0: [sdf] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
[  269.414219] end_request: I/O error, dev sdf, sector 1024

and so on..

So far, things are looking good on the lio-core-2.6.git side, however I am able to trigger a BUG() from
time to time in Open/iSCSI Initiator when returning include/scsi/scsi.h:SAM_STAT_TASK_ABORTED when TAS=1 in
target_core_mod/ConfigFS, but other than that things are looking good with small amounts of outstanding CDBs
being preempted and aborted.  Sometimes the Open/iSCSI client side does a bus reset (restart the iSCSI session)
instead of processing TASK_ABORTED status (which appear to be getting sent from target_core_mod), not sure if
this is related to the BUG() that is triggered or not (will CC Open-iSCSI list).

*) Target side using lio-core-2.6.git on v2.6.29:

<SNIP>

SPC-3 PR [iSCSI] Service Action: REGISTER Initiator Node: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 PR [iSCSI] for ALL TCM Subsystem iblock Object Target Port(s)
SPC-3 PR [iSCSI] SA Res Key: 0x000000001234abcd PRgeneration: 0x00000013
SPC-3 PR [iSCSI] Service Action: implict RELEASE cleared reservation holder TYPE: Write Exclusive Access, Registrants Only ALL_TG_PT: 1
SPC-3 PR [iSCSI] RELEASE Node: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 PR [iSCSI] Service Action: UNREGISTER Initiator Node: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 PR [iSCSI] for ALL TCM Subsystem iblock Object Target Port(s)
SPC-3 PR [iSCSI] SA Res Key: 0x000000004567ffff PRgeneration: 0x00000011
[iSCSI]: Allocated UNIT ATTENTION, mapped LUN: 0, ASC: 0x2a, ASCQ: 0x03
SPC-3 PR [iSCSI] Service Action: PREEMPT_AND_ABORT created new reservation holder TYPE: Write Exclusive Access, Registrants Only ALL_TG_PT: 1
SPC-3 PR [iSCSI] PREEMPT_AND_ABORT from Node: iqn.1993-08.org.debian:01:2dadf92d0ef
LUN_RESET: Preempt starting for [iblock], tas: 1
LUN_RESET: Preempt cmd: d3b5a300 task: d3193200 ITT/CmdSN: 0x2b000010/0x00000000, i_state: 1, t_state/def_t_state: 243/0 cdb: 0x2a
LUN_RESET: ITT[0x2b000010] - pr_res_key: 0x000000004567ffff t_task_cdbs: 1 t_task_cdbs_left: 1 t_task_cdbs_sent: 0 -- t_transport_active: 0 t_transport_stop: 0 t_transport_sent: 0
LUN_RESET: Got t_transport_active = 0 for task: d3193200, t_fe_count: 1 dev: dec3f000
LUN_RESET: Preempt for [iblock] Complete
[iSCSI]: Releasing UNIT ATTENTION condition with INTLCK_CTRL: 0, mapped LUN: 0, got CDB: 0x2a reported ASC: 0x2a, ASCQ: 0x03
Conflict for WRITE CDB: 0x2a to Write Exclusive Access, Registrants Only reservation
Conflict for WRITE CDB: 0x2a to Write Exclusive Access, Registrants Only reservation
Conflict for WRITE CDB: 0x2a to Write Exclusive Access, Registrants Only reservation



Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

---
 drivers/lio-core/target_core_base.h      |    4 +
 drivers/lio-core/target_core_device.c    |    2 +
 drivers/lio-core/target_core_pr.c        |  201 +++++++++++++++++++++---------
 drivers/lio-core/target_core_pr.h        |    2 +
 drivers/lio-core/target_core_tmr.c       |  164 +++++++++++++++++-------
 drivers/lio-core/target_core_tmr.h       |    3 +-
 drivers/lio-core/target_core_transport.c |    8 +-
 7 files changed, 270 insertions(+), 114 deletions(-)

diff --git a/drivers/lio-core/target_core_base.h b/drivers/lio-core/target_core_base.h
index 5849a1f..5935d9b 100644
--- a/drivers/lio-core/target_core_base.h
+++ b/drivers/lio-core/target_core_base.h
@@ -294,6 +294,7 @@ typedef struct t10_pr_registration_s {
 	struct se_dev_entry_s *pr_reg_deve;
 	struct se_lun_s *pr_reg_tg_pt_lun;
 	struct list_head pr_reg_list;
+	struct list_head pr_reg_abort_list;
 } t10_pr_registration_t;
 
 typedef struct t10_reservation_template_s {
@@ -472,6 +473,8 @@ typedef struct se_cmd_s {
 	u32			iov_data_count;
 	/* Number of iovecs allocated for iscsi_cmd_t->iov_data */
 	u32			orig_iov_data_count;
+	/* Persistent Reservation key */
+	u64			pr_res_key;
 	atomic_t                transport_sent;
 	/* Used for sense data */
 	void			*sense_buffer;
@@ -604,6 +607,7 @@ typedef struct se_dev_entry_s {
 	u32			last_byte_count;
 	u32			total_cmds;
 	u32			total_bytes;
+	u64			pr_res_key;
 #ifdef SNMP_SUPPORT
 	u64			creation_time;
 	u32			attach_count;
diff --git a/drivers/lio-core/target_core_device.c b/drivers/lio-core/target_core_device.c
index 95ab18d..a3db481 100644
--- a/drivers/lio-core/target_core_device.c
+++ b/drivers/lio-core/target_core_device.c
@@ -266,6 +266,7 @@ extern int __transport_get_lun_for_cmd(
 		deve->deve_cmds++;
 
 		se_lun = se_cmd->se_lun = deve->se_lun;
+		se_cmd->pr_res_key = deve->pr_res_key;
 		se_cmd->orig_fe_lun = unpacked_lun;
 		se_cmd->se_orig_obj_api = SE_LUN(se_cmd)->lun_obj_api;
 		se_cmd->se_orig_obj_ptr = SE_LUN(se_cmd)->lun_type_ptr;
@@ -346,6 +347,7 @@ extern int transport_get_lun_for_tmr(
 	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
 		se_lun = se_cmd->se_lun = se_tmr->tmr_lun = deve->se_lun;
 		dev = se_tmr->tmr_dev = se_lun->se_dev;
+		se_cmd->pr_res_key = deve->pr_res_key;
 		se_cmd->orig_fe_lun = unpacked_lun;
 		se_cmd->se_orig_obj_api = SE_LUN(se_cmd)->lun_obj_api;
 		se_cmd->se_orig_obj_ptr = SE_LUN(se_cmd)->lun_type_ptr;
diff --git a/drivers/lio-core/target_core_pr.c b/drivers/lio-core/target_core_pr.c
index f55c59d..0f4772e 100644
--- a/drivers/lio-core/target_core_pr.c
+++ b/drivers/lio-core/target_core_pr.c
@@ -36,6 +36,7 @@
 #include <target_core_base.h>
 #include <target_core_device.h>
 #include <target_core_hba.h>
+#include <target_core_tmr.h>
 #include <target_core_transport.h>
 #include <target_core_pr.h>
 #include <target_core_ua.h>
@@ -368,12 +369,14 @@ static int core_scsi3_pr_seq_non_holder(
 			 * as we expect registered non-reservation holding
 			 * nexuses to issue CDBs.
 			 */
+#if 0
 			if (!(registered_nexus)) {
 				printk(KERN_INFO "Allowing implict CDB: 0x%02x"
 					" for %s reservation on unregistered"
 					" nexus\n", cdb[0],
 					core_scsi3_pr_dump_type(pr_reg_type));
 			}
+#endif
 			return 0;
 		}
 	} else if (all_reg) {
@@ -431,6 +434,7 @@ static int core_scsi3_pr_reservation_check(
 		return 0;
 	}
 	*pr_reg_type = dev->dev_pr_res_holder->pr_res_type;
+	cmd->pr_res_key = dev->dev_pr_res_holder->pr_res_key;
 	ret = (dev->dev_pr_res_holder->pr_reg_nacl != sess->se_node_acl) ?
 		-1 : 0;
 	spin_unlock(&dev->dev_reservation_lock);
@@ -473,6 +477,7 @@ static int core_scsi3_alloc_registration(
 	}
 
 	INIT_LIST_HEAD(&pr_reg->pr_reg_list);
+	INIT_LIST_HEAD(&pr_reg->pr_reg_abort_list);
 	atomic_set(&pr_reg->pr_res_holders, 0);
 	pr_reg->pr_reg_nacl = nacl;
 	pr_reg->pr_reg_deve = deve;
@@ -490,6 +495,7 @@ static int core_scsi3_alloc_registration(
 	spin_lock(&pr_tmpl->registration_lock);
 	list_add_tail(&pr_reg->pr_reg_list, &pr_tmpl->registration_list);
 	deve->deve_flags |= DEF_PR_REGISTERED;
+	deve->pr_res_key = sa_res_key;
 
 	printk(KERN_INFO "SPC-3 PR [%s] Service Action: REGISTER%s Initiator"
 		" Node: %s\n", tfo->get_fabric_name(), (ignore_key) ?
@@ -573,6 +579,7 @@ static int core_scsi3_check_implict_release(
 static void __core_scsi3_free_registration(
 	se_device_t *dev,
 	t10_pr_registration_t *pr_reg,
+	struct list_head *preempt_and_abort_list,
 	int dec_holders)
 {
 	struct target_core_fabric_ops *tfo =
@@ -580,6 +587,7 @@ static void __core_scsi3_free_registration(
 	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
 
 	pr_reg->pr_reg_deve->deve_flags &= ~DEF_PR_REGISTERED;
+	pr_reg->pr_reg_deve->pr_res_key = 0;
 	list_del(&pr_reg->pr_reg_list);
 	/*
 	 * Caller accessing *pr_reg using core_scsi3_locate_pr_reg(),
@@ -612,9 +620,17 @@ static void __core_scsi3_free_registration(
 		" 0x%08x\n", tfo->get_fabric_name(), pr_reg->pr_res_key,
 		pr_reg->pr_res_generation);
 
-	pr_reg->pr_reg_deve = NULL;
-	pr_reg->pr_reg_nacl = NULL;
-	kmem_cache_free(t10_pr_reg_cache, pr_reg);
+	if (!(preempt_and_abort_list)) {
+		pr_reg->pr_reg_deve = NULL;
+		pr_reg->pr_reg_nacl = NULL;
+		kmem_cache_free(t10_pr_reg_cache, pr_reg);
+		return;
+	}
+	/*
+	 * For PREEMPT_AND_ABORT, the list of *pr_reg in preempt_and_abort_list
+	 * are released once the ABORT_TASK_SET has completed..
+	 */
+	list_add_tail(&pr_reg->pr_reg_abort_list, preempt_and_abort_list);
 }
 
 void core_scsi3_free_pr_reg_from_nacl(
@@ -643,7 +659,7 @@ void core_scsi3_free_pr_reg_from_nacl(
 		if (pr_reg->pr_reg_nacl != nacl)
 			continue;
 
-		__core_scsi3_free_registration(dev, pr_reg, 0);
+		__core_scsi3_free_registration(dev, pr_reg, NULL, 0);
 	}
 	spin_unlock(&pr_tmpl->registration_lock);
 }
@@ -667,7 +683,7 @@ void core_scsi3_free_all_registrations(
 	list_for_each_entry_safe(pr_reg, pr_reg_tmp,
 			&pr_tmpl->registration_list, pr_reg_list) {
 
-		__core_scsi3_free_registration(dev, pr_reg, 0);
+		__core_scsi3_free_registration(dev, pr_reg, NULL, 0);
 	}
 	spin_unlock(&pr_tmpl->registration_lock);
 }
@@ -785,7 +801,8 @@ static int core_scsi3_emulate_pro_register(
 			/*
 			 * Release the calling I_T Nexus registration now..
 			 */
-			__core_scsi3_free_registration(SE_DEV(cmd), pr_reg, 1);
+			__core_scsi3_free_registration(SE_DEV(cmd), pr_reg,
+							NULL, 1);
 			/*
 			 * From spc4r17, section 5.7.11.3 Unregistering
 			 *
@@ -1285,7 +1302,8 @@ static int core_scsi3_emulate_pro_clear(
 		calling_it_nexus = (pr_reg_n == pr_reg) ? 1 : 0;
 		pr_reg_nacl = pr_reg->pr_reg_nacl;
 		pr_res_mapped_lun = pr_reg->pr_res_mapped_lun;
-		__core_scsi3_free_registration(dev, pr_reg, calling_it_nexus);
+		__core_scsi3_free_registration(dev, pr_reg, NULL,
+					calling_it_nexus);
 		/*
 		 * e) Establish a unit attention condition for the initiator
 		 *    port associated with every registered I_T nexus other
@@ -1312,8 +1330,10 @@ static int core_scsi3_emulate_pro_clear(
 static void __core_scsi3_complete_pro_preempt(
 	se_device_t *dev,
 	t10_pr_registration_t *pr_reg,
+	struct list_head *preempt_and_abort_list,
 	int type,
-	int scope)
+	int scope,
+	int abort)
 {
 	se_node_acl_t *nacl = pr_reg->pr_reg_nacl;
 	struct target_core_fabric_ops *tfo = nacl->se_tpg->se_tpg_tfo;
@@ -1329,12 +1349,60 @@ static void __core_scsi3_complete_pro_preempt(
 	pr_reg->pr_res_type = type;
 	pr_reg->pr_res_scope = scope;
 
-	printk(KERN_INFO "SPC-3 PR [%s] Service Action: PREEMPT created new"
+	printk(KERN_INFO "SPC-3 PR [%s] Service Action: PREEMPT%s created new"
 		" reservation holder TYPE: %s ALL_TG_PT: %d\n",
-		tfo->get_fabric_name(), core_scsi3_pr_dump_type(type),
+		tfo->get_fabric_name(), (abort) ? "_AND_ABORT" : "",
+		core_scsi3_pr_dump_type(type),
 		(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
-	printk(KERN_INFO "SPC-3 PR [%s] PREEMPT from Node: %s\n",
-		tfo->get_fabric_name(), nacl->initiatorname);
+	printk(KERN_INFO "SPC-3 PR [%s] PREEMPT%s from Node: %s\n",
+		tfo->get_fabric_name(), (abort) ? "_AND_ABORT" : "",
+		nacl->initiatorname);
+	/*
+	 * For PREEMPT_AND_ABORT, add the preempting reservation's
+	 * t10_pr_registration_t to the list that will be compared
+	 * against received CDBs..
+	 */
+	if (preempt_and_abort_list)
+		list_add_tail(&pr_reg->pr_reg_abort_list,
+				preempt_and_abort_list);
+}
+
+static void core_scsi3_release_preempt_and_abort(
+	struct list_head *preempt_and_abort_list,
+	t10_pr_registration_t *pr_reg_holder)
+{
+	t10_pr_registration_t *pr_reg, *pr_reg_tmp;
+
+	list_for_each_entry_safe(pr_reg, pr_reg_tmp, preempt_and_abort_list,
+				pr_reg_abort_list) {
+
+		list_del(&pr_reg->pr_reg_abort_list);
+		if (pr_reg_holder == pr_reg)
+			continue;
+		if (pr_reg->pr_res_holder) {
+			printk(KERN_WARNING "pr_reg->pr_res_holder still set\n");
+			continue;
+		}
+
+		pr_reg->pr_reg_deve = NULL;
+		pr_reg->pr_reg_nacl = NULL;
+		kmem_cache_free(t10_pr_reg_cache, pr_reg);
+	}
+}
+
+int core_scsi3_check_cdb_abort_and_preempt(
+	struct list_head *preempt_and_abort_list,
+	se_cmd_t *cmd)
+{
+	t10_pr_registration_t *pr_reg, *pr_reg_tmp;
+
+	list_for_each_entry_safe(pr_reg, pr_reg_tmp, preempt_and_abort_list,
+				pr_reg_abort_list) {
+		if (pr_reg->pr_res_key == cmd->pr_res_key)
+			return 0;
+	}
+
+	return 1;
 }
 
 static int core_scsi3_emulate_pro_preempt(
@@ -1342,13 +1410,15 @@ static int core_scsi3_emulate_pro_preempt(
 	int type,
 	int scope,
 	u64 res_key,
-	u64 sa_res_key)
+	u64 sa_res_key,
+	int abort)
 {
 	se_device_t *dev = SE_DEV(cmd);
 	se_dev_entry_t *se_deve;
 	se_lun_t *se_lun = SE_LUN(cmd);
 	se_node_acl_t *pr_reg_nacl;
 	se_session_t *se_sess = SE_SESS(cmd);
+	struct list_head preempt_and_abort_list;
 	t10_pr_registration_t *pr_reg, *pr_reg_tmp, *pr_reg_n, *pr_res_holder;
 	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
 	u32 pr_res_mapped_lun = 0;
@@ -1365,7 +1435,8 @@ static int core_scsi3_emulate_pro_preempt(
 	pr_reg_n = core_scsi3_locate_pr_reg(SE_DEV(cmd), se_sess->se_node_acl);
 	if (!(pr_reg_n)) {
 		printk(KERN_ERR "SPC-3 PR: Unable to locate"
-			" PR_REGISTERED *pr_reg for PREEMPT\n");
+			" PR_REGISTERED *pr_reg for PREEMPT%s\n",
+			(abort) ? "_AND_ABORT" : "");
 		return PYX_TRANSPORT_RESERVATION_CONFLICT;
 	}
 	if (pr_reg_n->pr_res_key != res_key) {
@@ -1377,6 +1448,7 @@ static int core_scsi3_emulate_pro_preempt(
 		core_scsi3_put_pr_reg(pr_reg_n);
 		return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 	}
+	INIT_LIST_HEAD(&preempt_and_abort_list);
 
 	spin_lock(&dev->dev_reservation_lock);
 	pr_res_holder = dev->dev_pr_res_holder;
@@ -1434,7 +1506,8 @@ static int core_scsi3_emulate_pro_preempt(
 				pr_reg_nacl = pr_reg->pr_reg_nacl;
 				pr_res_mapped_lun = pr_reg->pr_res_mapped_lun;
 				__core_scsi3_free_registration(dev, pr_reg,
-							calling_it_nexus);
+					(abort) ? &preempt_and_abort_list :
+						NULL, calling_it_nexus);
 				released_regs++;
 			} else {
 				/*
@@ -1460,7 +1533,9 @@ static int core_scsi3_emulate_pro_preempt(
 
 				pr_reg_nacl = pr_reg->pr_reg_nacl;
 				pr_res_mapped_lun = pr_reg->pr_res_mapped_lun;
-				__core_scsi3_free_registration(dev, pr_reg, 0);
+				__core_scsi3_free_registration(dev, pr_reg,
+					(abort) ? &preempt_and_abort_list :
+						NULL, 0);
 				released_regs++;
 			}
 			if (!(calling_it_nexus))
@@ -1486,9 +1561,15 @@ static int core_scsi3_emulate_pro_preempt(
 		 * with a zero SA rservation key, preempt the existing
 		 * reservation with the new PR type and scope.
 		 */
-		if (pr_res_holder && all_reg && !(sa_res_key))
+		if (pr_res_holder && all_reg && !(sa_res_key)) {
 			__core_scsi3_complete_pro_preempt(dev, pr_reg_n,
-					type, scope);
+				(abort) ? &preempt_and_abort_list : NULL,
+				type, scope, abort);
+
+			if (abort)
+				core_scsi3_release_preempt_and_abort(
+					&preempt_and_abort_list, pr_reg_n);
+		}
 		spin_unlock(&dev->dev_reservation_lock);
 
 		core_scsi3_put_pr_reg(pr_reg_n);
@@ -1499,32 +1580,21 @@ static int core_scsi3_emulate_pro_preempt(
 	 * The PREEMPTing SA reservation key matches that of the
 	 * existing persistent reservation, first, we check if
 	 * we are preempting our own reservation.
+	 * From spc4r17, section 5.7.11.4.3 Preempting
+	 * persistent reservations and registration handling
+	 *
+	 * If an all registrants persistent reservation is not
+	 * present, it is not an error for the persistent
+	 * reservation holder to preempt itself (i.e., a
+	 * PERSISTENT RESERVE OUT with a PREEMPT service action
+	 * or a PREEMPT AND ABORT service action with the
+	 * SERVICE ACTION RESERVATION KEY value equal to the
+	 * persistent reservation holder's reservation key that
+	 * is received from the persistent reservation holder).
+	 * In that case, the device server shall establish the
+	 * new persistent reservation and maintain the
+	 * registration.
 	 */
-	if (pr_reg_n == pr_res_holder) {
-		/*
-		 * From spc4r17, section 5.7.11.4.3 Preempting
-		 * persistent reservations and registration handling
-		 *
-		 * If an all registrants persistent reservation is not
-		 * present, it is not an error for the persistent
-		 * reservation holder to preempt itself (i.e., a
-		 * PERSISTENT RESERVE OUT with a PREEMPT service action
-		 * or a PREEMPT AND ABORT service action with the
-		 * SERVICE ACTION RESERVATION KEY value equal to the
-		 * persistent reservation holder's reservation key that
-		 * is received from the persistent reservation holder).
-		 * In that case, the device server shall establish the
-		 * new persistent reservation and maintain the
-		 * registration.
-		 */
-		__core_scsi3_complete_pro_preempt(dev, pr_reg_n,
-				type, scope);
-		spin_unlock(&dev->dev_reservation_lock);
-
-		core_scsi3_put_pr_reg(pr_reg_n);
-		core_scsi3_pr_generation(SE_DEV(cmd));
-		return 0;
-	}
 	prh_type = pr_res_holder->pr_res_type;
 	prh_scope = pr_res_holder->pr_res_scope;
 	/*
@@ -1536,7 +1606,9 @@ static int core_scsi3_emulate_pro_preempt(
 	 * a) Release the persistent reservation for the holder
 	 *    identified by the SERVICE ACTION RESERVATION KEY field;
 	 */
-	__core_scsi3_complete_pro_release(dev, pr_res_holder->pr_reg_nacl,
+	if (pr_reg_n != pr_res_holder)
+		__core_scsi3_complete_pro_release(dev,
+				pr_res_holder->pr_reg_nacl,
 				dev->dev_pr_res_holder, 0);
 	/*
 	 * b) Remove the registrations for all I_T nexuses identified
@@ -1562,6 +1634,7 @@ static int core_scsi3_emulate_pro_preempt(
 		pr_reg_nacl = pr_reg->pr_reg_nacl;
 		pr_res_mapped_lun = pr_reg->pr_res_mapped_lun;
 		__core_scsi3_free_registration(dev, pr_reg,
+				(abort) ? &preempt_and_abort_list : NULL,
 				calling_it_nexus);
 		/*
 		 * e) Establish a unit attention condition for the initiator
@@ -1577,7 +1650,9 @@ static int core_scsi3_emulate_pro_preempt(
 	 * c) Establish a persistent reservation for the preempting
 	 *    I_T nexus using the contents of the SCOPE and TYPE fields;
 	 */
-	__core_scsi3_complete_pro_preempt(dev, pr_reg_n, type, scope);
+	__core_scsi3_complete_pro_preempt(dev, pr_reg_n,
+			(abort) ? &preempt_and_abort_list : NULL,
+			type, scope, abort);
 	/*
 	 * d) Process tasks as defined in 5.7.1;
 	 * e) See above..
@@ -1594,7 +1669,7 @@ static int core_scsi3_emulate_pro_preempt(
 	if ((prh_type != type) || (prh_scope != scope)) {
 		spin_lock(&pr_tmpl->registration_lock);
 		list_for_each_entry_safe(pr_reg, pr_reg_tmp,
-			&pr_tmpl->registration_list, pr_reg_list) {
+				&pr_tmpl->registration_list, pr_reg_list) {
 
 			calling_it_nexus = (pr_reg_n == pr_reg) ? 1 : 0;
 			if (calling_it_nexus)
@@ -1607,23 +1682,27 @@ static int core_scsi3_emulate_pro_preempt(
 		spin_unlock(&pr_tmpl->registration_lock);
 	}
 	spin_unlock(&dev->dev_reservation_lock);
+	/*
+	 * Call LUN_RESET logic upon list of t10_pr_registration_t,
+	 * All received CDBs for the matching existing reservation and
+	 * registrations undergo ABORT_TASK logic.
+	 *
+	 * From there, core_scsi3_release_preempt_and_abort() will
+	 * release every registration in the list (which have already
+	 * been removed from the primary pr_reg list), except the
+	 * new persistent reservation holder, the calling Initiator Port.
+	 */
+	if (abort) {
+		core_tmr_lun_reset(dev, NULL, &preempt_and_abort_list, cmd);
+		core_scsi3_release_preempt_and_abort(&preempt_and_abort_list,
+						pr_reg_n);
+	}
 
 	core_scsi3_put_pr_reg(pr_reg_n);
 	core_scsi3_pr_generation(SE_DEV(cmd));
 	return 0;
 }
 
-static int core_scsi3_emulate_pro_preempt_and_abort(
-	se_cmd_t *cmd,
-	int type,
-	int scope,
-	u64 res_key,
-	u64 sa_res_key)
-{
-	core_scsi3_pr_generation(SE_DEV(cmd));
-	return 0;
-}
-
 static int core_scsi3_emulate_pro_register_and_move(
 	se_cmd_t *cmd,
 	int type,
@@ -1699,12 +1778,10 @@ static int core_scsi3_emulate_pr_out(se_cmd_t *cmd, unsigned char *cdb)
 		return core_scsi3_emulate_pro_clear(cmd, res_key);
 	case PRO_PREEMPT:
 		return core_scsi3_emulate_pro_preempt(cmd, type, scope,
-					res_key, sa_res_key);
-#if 0
+					res_key, sa_res_key, 0);
 	case PRO_PREEMPT_AND_ABORT:
-		return core_scsi3_emulate_pro_preempt_and_abort(cmd,
-			type, scope, res_key, sa_res_key);
-#endif
+		return core_scsi3_emulate_pro_preempt(cmd, type, scope,
+					res_key, sa_res_key, 1);
 	case PRO_REGISTER_AND_IGNORE_EXISTING_KEY:
 		return core_scsi3_emulate_pro_register(cmd,
 			0, sa_res_key, aptpl, all_tg_pt, spec_i_pt, 1);
diff --git a/drivers/lio-core/target_core_pr.h b/drivers/lio-core/target_core_pr.h
index 9003ebb..23d9e18 100644
--- a/drivers/lio-core/target_core_pr.h
+++ b/drivers/lio-core/target_core_pr.h
@@ -46,6 +46,8 @@ extern void core_scsi3_free_pr_reg_from_nacl(struct se_device_s *,
 					     struct se_node_acl_s *);
 extern void core_scsi3_free_all_registrations(struct se_device_s *);
 extern unsigned char *core_scsi3_pr_dump_type(int);
+extern int core_scsi3_check_cdb_abort_and_preempt(struct list_head *,
+						  struct se_cmd_s *);
 extern int core_scsi3_emulate_pr(struct se_cmd_s *);
 extern int core_setup_reservations(struct se_device_s *);
 
diff --git a/drivers/lio-core/target_core_tmr.c b/drivers/lio-core/target_core_tmr.c
index 531b135..577dc6a 100644
--- a/drivers/lio-core/target_core_tmr.c
+++ b/drivers/lio-core/target_core_tmr.c
@@ -29,12 +29,14 @@
 #include <linux/version.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
+#include <linux/list.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 
 #include <target_core_base.h>
 #include <target_core_device.h>
 #include <target_core_hba.h>
+#include <target_core_pr.h>
 #include <target_core_seobj.h>
 #include <target_core_tmr.h>
 #include <target_core_transport.h>
@@ -93,16 +95,21 @@ void core_tmr_release_req(
 	spin_unlock(&dev->se_tmr_lock);
 }
 
-int core_tmr_lun_reset(se_device_t *dev, se_tmr_req_t *tmr)
+int core_tmr_lun_reset(
+	se_device_t *dev,
+	se_tmr_req_t *tmr,
+	struct list_head *preempt_and_abort_list,
+	se_cmd_t *prout_cmd)
 {
 	se_cmd_t *cmd;
-	se_queue_req_t *qr;
+	se_queue_req_t *qr, *qr_tmp;
 	se_node_acl_t *tmr_nacl = NULL;
 	se_portal_group_t *tmr_tpg = NULL;
+	se_queue_obj_t *qobj = dev->dev_queue_obj;
 	se_tmr_req_t *tmr_p, *tmr_pp;
-	se_task_t *task;
+	se_task_t *task, *task_tmp;
 	unsigned long flags;
-	int state, tas;
+	int fe_count, state, tas;
 	/*
 	 * TASK_ABORTED status bit, this is configurable via ConfigFS
 	 * se_device_t attributes.  spc4r17 section 7.4.6 Control mode page
@@ -119,7 +126,7 @@ int core_tmr_lun_reset(se_device_t *dev, se_tmr_req_t *tmr)
 	 * Determine if this se_tmr is coming from a $FABRIC_MOD
 	 * or se_device_t passthrough..
 	 */
-	if (tmr->task_cmd && tmr->task_cmd->se_sess) {
+	if (tmr && tmr->task_cmd && tmr->task_cmd->se_sess) {
 		tmr_nacl = tmr->task_cmd->se_sess->se_node_acl;
 		tmr_tpg = tmr->task_cmd->se_sess->se_tpg;
 		if (tmr_nacl && tmr_tpg) {
@@ -129,8 +136,9 @@ int core_tmr_lun_reset(se_device_t *dev, se_tmr_req_t *tmr)
 				tmr_nacl->initiatorname);
 		}
 	}
-	DEBUG_LR("LUN_RESET: TMR: %p starting for [%s], tas: %d\n", tmr,
-			TRANSPORT(dev)->name, tas);
+	DEBUG_LR("LUN_RESET: %s starting for [%s], tas: %d\n",
+		(preempt_and_abort_list) ? "Preempt" : "TMR",
+		TRANSPORT(dev)->name, tas);
 	/*
 	 * Release all pending and outgoing TMRs aside from the received
 	 * LUN_RESET tmr..
@@ -148,10 +156,20 @@ int core_tmr_lun_reset(se_device_t *dev, se_tmr_req_t *tmr)
 			printk(KERN_ERR "Unable to locate se_cmd_t for TMR\n");
 			continue;
 		}
+		/*
+		 * If this function was called with a valid pr_res_key
+		 * parameter (eg: for PROUT PREEMPT_AND_ABORT service action
+		 * skip non regisration key matching TMRs.
+		 */
+		if ((preempt_and_abort_list != NULL) &&
+		    (core_scsi3_check_cdb_abort_and_preempt(
+					preempt_and_abort_list, cmd) != 0))
+			continue;
 		spin_unlock(&dev->se_tmr_lock);
 
-		DEBUG_LR("LUN_RESET: Releasing TMR %p Function: 0x%02x,"
-			" Response: 0x%02x, t_state: %d\n", tmr_p,
+		DEBUG_LR("LUN_RESET: %s releasing TMR %p Function: 0x%02x,"
+			" Response: 0x%02x, t_state: %d\n",
+			(preempt_and_abort_list) ? "Preempt" : "", tmr_p,
 			tmr_p->function, tmr_p->response, cmd->t_state);
 
 		transport_cmd_finish_abort_tmr(cmd);
@@ -180,7 +198,8 @@ int core_tmr_lun_reset(se_device_t *dev, se_tmr_req_t *tmr)
 	 * in the Control Mode Page.
 	 */
 	spin_lock_irqsave(&dev->execute_task_lock, flags);
-	while ((task = transport_get_task_from_state_list(dev))) {
+	list_for_each_entry_safe(task, task_tmp, &dev->state_task_list,
+				t_state_list) {
 		if (!(TASK_CMD(task))) {
 			printk(KERN_ERR "TASK_CMD(task) is NULL!\n");
 			continue;
@@ -193,19 +212,36 @@ int core_tmr_lun_reset(se_device_t *dev, se_tmr_req_t *tmr)
 				CMD_TFO(cmd)->get_task_tag(cmd));
 			continue;
 		}
+		/*
+		 * For PREEMPT_AND_ABORT usage, only process commands
+		 * with a matching reservation key.
+		 */
+		if ((preempt_and_abort_list != NULL) &&
+		    (core_scsi3_check_cdb_abort_and_preempt(
+					preempt_and_abort_list, cmd) != 0))
+			continue;
+		/*
+		 * Not aborting PROUT PREEMPT_AND_ABORT CDB..
+		 */
+		if (prout_cmd == cmd)
+			continue;
+
+		list_del(&task->t_state_list);
+		atomic_set(&task->task_state_active, 0);
 		spin_unlock_irqrestore(&dev->execute_task_lock, flags);
 
 		spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
-		DEBUG_LR("LUN_RESET: cmd: %p task: %p ITT/CmdSN: 0x%08x/0x%08x"
-			", i_state: %d, t_state/def_t_state: %d/%d cdb:"
-			" 0x%02x\n", cmd, task, CMD_TFO(cmd)->get_task_tag(cmd),
+		DEBUG_LR("LUN_RESET: %s cmd: %p task: %p ITT/CmdSN: 0x%08x/"
+			"0x%08x, i_state: %d, t_state/def_t_state: %d/%d cdb:"
+			" 0x%02x\n", (preempt_and_abort_list) ? "Preempt" : "",
+			cmd, task, CMD_TFO(cmd)->get_task_tag(cmd),
 			0, CMD_TFO(cmd)->get_cmd_state(cmd), cmd->t_state,
 			cmd->deferred_t_state, T_TASK(cmd)->t_task_cdb[0]);
-		DEBUG_LR("LUN_RESET: ITT[0x%08x] - t_task_cdbs: %d"
-			" t_task_cdbs_left: %d t_task_cdbs_sent: %d --"
-			" t_transport_active: %d t_transport_stop: %d"
-			" t_transport_sent: %d\n",
-			CMD_TFO(cmd)->get_task_tag(cmd),
+		DEBUG_LR("LUN_RESET: ITT[0x%08x] - pr_res_key: 0x%016Lx"
+			" t_task_cdbs: %d t_task_cdbs_left: %d"
+			" t_task_cdbs_sent: %d -- t_transport_active: %d"
+			" t_transport_stop: %d t_transport_sent: %d\n",
+			CMD_TFO(cmd)->get_task_tag(cmd), cmd->pr_res_key,
 			T_TASK(cmd)->t_task_cdbs,
 			atomic_read(&T_TASK(cmd)->t_task_cdbs_left),
 			atomic_read(&T_TASK(cmd)->t_task_cdbs_sent),
@@ -241,49 +277,44 @@ int core_tmr_lun_reset(se_device_t *dev, se_tmr_req_t *tmr)
 			spin_lock_irqsave(&dev->execute_task_lock, flags);
 			continue;
 		}
+		fe_count = atomic_read(&T_TASK(cmd)->t_fe_count);
 
 		if (atomic_read(&T_TASK(cmd)->t_transport_active)) {
 			DEBUG_LR("LUN_RESET: got t_transport_active = 1 for"
-				" task: %p, dev: %p\n", task, dev);
-
-			if (atomic_read(&T_TASK(cmd)->t_fe_count)) {
-				spin_unlock_irqrestore(
-					&T_TASK(cmd)->t_state_lock, flags);
+				" task: %p, t_fe_count: %d dev: %p\n", task,
+				fe_count, dev);
+			spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock,
+						flags);
+			if (fe_count) {
 				/*
 				 * TASK ABORTED status (TAS) bit support
 				 */
-				if ((tmr_nacl == cmd->se_sess->se_node_acl) ||
+				if (((tmr_nacl != NULL) &&
+				     (tmr_nacl == cmd->se_sess->se_node_acl)) ||
 				     tas)
 					transport_send_task_abort(cmd);
 				transport_cmd_finish_abort(cmd, 0);
-			} else {
-				spin_unlock_irqrestore(
-					&T_TASK(cmd)->t_state_lock, flags);
-
+			} else
 				transport_cmd_finish_abort(cmd, 1);
-			}
 
 			spin_lock_irqsave(&dev->execute_task_lock, flags);
 			continue;
 		}
 		DEBUG_LR("LUN_RESET: Got t_transport_active = 0 for task: %p,"
-			" dev: %p\n", task, dev);
+			" t_fe_count: %d dev: %p\n", task, fe_count, dev);
+		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
 
-		if (atomic_read(&T_TASK(cmd)->t_fe_count)) {
-			spin_unlock_irqrestore(
-				&T_TASK(cmd)->t_state_lock, flags);
+		if (fe_count) {
 			/*
 			 * TASK ABORTED status (TAS) bit support
 			 */
-			if ((tmr_nacl == cmd->se_sess->se_node_acl) || tas)
+			if (((tmr_nacl != NULL) &&
+			    (tmr_nacl == cmd->se_sess->se_node_acl)) || tas)
 				transport_send_task_abort(cmd);
 			transport_cmd_finish_abort(cmd, 0);
-		} else {
-			spin_unlock_irqrestore(
-				&T_TASK(cmd)->t_state_lock, flags);
-
+		} else
 			transport_cmd_finish_abort(cmd, 1);
-		}
+
 		spin_lock_irqsave(&dev->execute_task_lock, flags);
 	}
 	spin_unlock_irqrestore(&dev->execute_task_lock, flags);
@@ -295,35 +326,70 @@ int core_tmr_lun_reset(se_device_t *dev, se_tmr_req_t *tmr)
 	 * TASK_ABORTED status, if there is an outstanding $FABRIC_MOD
 	 * reference, otherwise the se_cmd_t is released.
 	 */
-	spin_lock_irqsave(&dev->dev_queue_obj->cmd_queue_lock, flags);
-	while ((qr = __transport_get_qr_from_queue(dev->dev_queue_obj))) {
-		spin_unlock_irqrestore(
-			&dev->dev_queue_obj->cmd_queue_lock, flags);
+	spin_lock_irqsave(&qobj->cmd_queue_lock, flags);
+	list_for_each_entry_safe(qr, qr_tmp, &qobj->qobj_list, qr_list) {
 		cmd = (se_cmd_t *)qr->cmd;
+		if (!(cmd)) {
+			/*
+			 * Skip these for non PREEMPT_AND_ABORT usage..
+			 */
+			if (preempt_and_abort_list != NULL)
+				continue;
+
+			atomic_dec(&qobj->queue_cnt);
+			list_del(&qr->qr_list);
+			kfree(qr);
+			continue;
+		}
+		/*
+		 * For PREEMPT_AND_ABORT usage, only process commands
+		 * with a matching reservation key.
+		 */
+		if ((preempt_and_abort_list != NULL) &&
+		    (core_scsi3_check_cdb_abort_and_preempt(
+					preempt_and_abort_list, cmd) != 0))
+			continue;
+		/*
+		 * Not aborting PROUT PREEMPT_AND_ABORT CDB..
+		 */
+		if (prout_cmd == cmd)
+			continue;
+
+		atomic_dec(&T_TASK(cmd)->t_transport_queue_active);
+		atomic_dec(&qobj->queue_cnt);
+		list_del(&qr->qr_list);
+		spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
+
 		state = qr->state;
 		kfree(qr);
 
-		DEBUG_LR("LUN_RESET: From Device Queue: cmd: %p t_state: %d\n",
-				cmd, state);
+		DEBUG_LR("LUN_RESET: %s from Device Queue: cmd: %p t_state:"
+			" %d t_fe_count: %d\n", (preempt_and_abort_list) ?
+			"Preempt" : "", cmd, state,
+			atomic_read(&T_TASK(cmd)->t_fe_count));
 
 		if (atomic_read(&T_TASK(cmd)->t_fe_count)) {
 			/*
 			 * TASK ABORTED status (TAS) bit support
 			 */
-			if ((tmr_nacl == cmd->se_sess->se_node_acl) || tas)
+			if (((tmr_nacl != NULL) &&
+			     (tmr_nacl == cmd->se_sess->se_node_acl)) ||
+			      tas)
 				transport_send_task_abort(cmd);
 			transport_cmd_finish_abort(cmd, 0);
 		} else
 			transport_cmd_finish_abort(cmd, 1);
 
-		spin_lock_irqsave(&dev->dev_queue_obj->cmd_queue_lock, flags);
+		spin_lock_irqsave(&qobj->cmd_queue_lock, flags);
 	}
-	spin_unlock_irqrestore(&dev->dev_queue_obj->cmd_queue_lock, flags);
+	spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
 
 	spin_lock(&dev->stats_lock);
 	dev->num_resets++;
 	spin_unlock(&dev->stats_lock);
 
-	DEBUG_LR("LUN_RESET: TMR for [%s] Complete\n", TRANSPORT(dev)->name);
+	DEBUG_LR("LUN_RESET: %s for [%s] Complete\n",
+			(preempt_and_abort_list) ? "Preempt" : "TMR",
+			TRANSPORT(dev)->name);
 	return 0;
 }
diff --git a/drivers/lio-core/target_core_tmr.h b/drivers/lio-core/target_core_tmr.h
index 3786f1b..c649b92 100644
--- a/drivers/lio-core/target_core_tmr.h
+++ b/drivers/lio-core/target_core_tmr.h
@@ -37,6 +37,7 @@ extern struct kmem_cache *se_tmr_req_cache;
 
 extern struct se_tmr_req_s *core_tmr_alloc_req(struct se_cmd_s *, void *, u8);
 extern void core_tmr_release_req(struct se_tmr_req_s *);
-extern int core_tmr_lun_reset(struct se_device_s *, struct se_tmr_req_s *);
+extern int core_tmr_lun_reset(struct se_device_s *, struct se_tmr_req_s *,
+				struct list_head *, struct se_cmd_s *);
 
 #endif /* TARGET_CORE_TMR_H */
diff --git a/drivers/lio-core/target_core_transport.c b/drivers/lio-core/target_core_transport.c
index 4c4a489..4132da1 100644
--- a/drivers/lio-core/target_core_transport.c
+++ b/drivers/lio-core/target_core_transport.c
@@ -7357,7 +7357,11 @@ EXPORT_SYMBOL(transport_send_check_condition_and_sense);
 void transport_send_task_abort(se_cmd_t *cmd)
 {
 	cmd->scsi_status = SAM_STAT_TASK_ABORTED;
-
+#if 0
+	printk(KERN_INFO "Setting SAM_STAT_TASK_ABORTED status for CDB: 0x%02x,"
+		" ITT: 0x%08x\n", T_TASK(cmd)->t_task_cdb[0],
+		CMD_TFO(cmd)->get_task_tag(cmd));
+#endif
 	if (!(cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH))
 		CMD_TFO(cmd)->queue_status(cmd);
 }
@@ -7384,7 +7388,7 @@ int transport_generic_do_tmr(se_cmd_t *cmd)
 		tmr->response = TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED;
 		break;
 	case LUN_RESET:
-		ret = core_tmr_lun_reset(dev, tmr);
+		ret = core_tmr_lun_reset(dev, tmr, NULL, NULL);
 		tmr->response = (!ret) ? TMR_FUNCTION_COMPLETE :
 					 TMR_FUNCTION_REJECTED;
 		break;
-- 
1.5.4.1



