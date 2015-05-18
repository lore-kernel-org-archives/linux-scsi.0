From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/12] target: Convert se_node_acl->device_list[] to
	RCU hlist
Date: Mon, 18 May 2015 10:01:55 +0200
Message-ID: <20150518080155.GA6451@lst.de>
References: <1431422736-29125-1-git-send-email-nab@daterainc.com> <1431422736-29125-2-git-send-email-nab@daterainc.com> <20150513063555.GA21770@lst.de> <1431506771.26897.78.camel@haakon3.risingtidesystems.com> <20150517165142.GA17217@lst.de> <1431933444.24645.7.camel@haakon3.risingtidesystems.com> <20150518074102.GA6157@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150518074102.GA6157@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, May 18, 2015 at 09:41:02AM +0200, Christoph Hellwig wrote:
> > Here's a first pass at this along with kref + completion conversion for
> > the special case PR ALL_TGT_PT=1 pointer dereference.
> 
> Btw, I started hacking up a patch to merge se_port and t10_alua_tg_pt_gp_member
> in se_lun, which seems even better as it closes all kinds of other
> races.  Can you keep this one back for now, I'll send out that patch
> ASAP after finishing some testing.

Ok, testing showed that the baseline (your for-next tree from yesterday)
already doesn't work for tcm_loop and probably any generated nodeacl case,
and gets a:

[   12.830576] kernel BUG at ../drivers/target/target_core_device.c:337!

I've also looked over your patch and found at least two issues with it:

 - given that core_dev_unexport clears ->lun_se_dev all the callers
   in the stats code still need to check for it being zero
 - the 64-bit stats still need a lock protecting them, or made atomics.
   The same issue already applies with the base RCU patches for the counters
   in the se_dev_entry, btw.

Anyway, below is my patch, which I think will be very useful as it
closes all kinds of races by merging the structures.  Applying rcu
lookups for ->lun_se_dev and removign the busy loop for the refcount
would be a good next step on top of that.


diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 80b43a7..05db56a 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -43,11 +43,13 @@
 static sense_reason_t core_alua_check_transition(int state, int valid,
 						 int *primary);
 static int core_alua_set_tg_pt_secondary_state(
-		struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem,
-		struct se_port *port, int explicit, int offline);
+		struct se_lun *lun, int explicit, int offline);
 
 static char *core_alua_dump_state(int state);
 
+static void __target_attach_tg_pt_gp(struct se_lun *lun,
+		struct t10_alua_tg_pt_gp *tg_pt_gp);
+
 static u16 alua_lu_gps_counter;
 static u32 alua_lu_gps_count;
 
@@ -145,9 +147,8 @@ sense_reason_t
 target_emulate_report_target_port_groups(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
-	struct se_port *port;
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
-	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem;
+	struct se_lun *lun;
 	unsigned char *buf;
 	u32 rd_len = 0, off;
 	int ext_hdr = (cmd->t_task_cdb[1] & 0x20);
@@ -222,9 +223,8 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
 		rd_len += 8;
 
 		spin_lock(&tg_pt_gp->tg_pt_gp_lock);
-		list_for_each_entry(tg_pt_gp_mem, &tg_pt_gp->tg_pt_gp_mem_list,
-				tg_pt_gp_mem_list) {
-			port = tg_pt_gp_mem->tg_pt;
+		list_for_each_entry(lun, &tg_pt_gp->tg_pt_gp_lun_list,
+				lun_tg_pt_gp_link) {
 			/*
 			 * Start Target Port descriptor format
 			 *
@@ -234,8 +234,8 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
 			/*
 			 * Set RELATIVE TARGET PORT IDENTIFIER
 			 */
-			buf[off++] = ((port->sep_rtpi >> 8) & 0xff);
-			buf[off++] = (port->sep_rtpi & 0xff);
+			buf[off++] = ((lun->lun_rtpi >> 8) & 0xff);
+			buf[off++] = (lun->lun_rtpi & 0xff);
 			rd_len += 4;
 		}
 		spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
@@ -259,15 +259,11 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
 		 * this CDB was received upon to determine this value individually
 		 * for ALUA target port group.
 		 */
-		port = cmd->se_lun->lun_sep;
-		tg_pt_gp_mem = port->sep_alua_tg_pt_gp_mem;
-		if (tg_pt_gp_mem) {
-			spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
-			tg_pt_gp = tg_pt_gp_mem->tg_pt_gp;
-			if (tg_pt_gp)
-				buf[5] = tg_pt_gp->tg_pt_gp_implicit_trans_secs;
-			spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
-		}
+		spin_lock(&cmd->se_lun->lun_tg_pt_gp_lock);
+		tg_pt_gp = cmd->se_lun->lun_tg_pt_gp;
+		if (tg_pt_gp)
+			buf[5] = tg_pt_gp->tg_pt_gp_implicit_trans_secs;
+		spin_unlock(&cmd->se_lun->lun_tg_pt_gp_lock);
 	}
 	transport_kunmap_data_sg(cmd);
 
@@ -284,10 +280,9 @@ sense_reason_t
 target_emulate_set_target_port_groups(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
-	struct se_port *port, *l_port = cmd->se_lun->lun_sep;
+	struct se_lun *l_lun = cmd->se_lun;
 	struct se_node_acl *nacl = cmd->se_sess->se_node_acl;
 	struct t10_alua_tg_pt_gp *tg_pt_gp = NULL, *l_tg_pt_gp;
-	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem, *l_tg_pt_gp_mem;
 	unsigned char *buf;
 	unsigned char *ptr;
 	sense_reason_t rc = TCM_NO_SENSE;
@@ -295,9 +290,6 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 	int alua_access_state, primary = 0, valid_states;
 	u16 tg_pt_id, rtpi;
 
-	if (!l_port)
-		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-
 	if (cmd->data_length < 4) {
 		pr_warn("SET TARGET PORT GROUPS parameter list length %u too"
 			" small\n", cmd->data_length);
@@ -312,21 +304,16 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 	 * Determine if explicit ALUA via SET_TARGET_PORT_GROUPS is allowed
 	 * for the local tg_pt_gp.
 	 */
-	l_tg_pt_gp_mem = l_port->sep_alua_tg_pt_gp_mem;
-	if (!l_tg_pt_gp_mem) {
-		pr_err("Unable to access l_port->sep_alua_tg_pt_gp_mem\n");
-		rc = TCM_UNSUPPORTED_SCSI_OPCODE;
-		goto out;
-	}
-	spin_lock(&l_tg_pt_gp_mem->tg_pt_gp_mem_lock);
-	l_tg_pt_gp = l_tg_pt_gp_mem->tg_pt_gp;
+	spin_lock(&l_lun->lun_tg_pt_gp_lock);
+	l_tg_pt_gp = l_lun->lun_tg_pt_gp;
 	if (!l_tg_pt_gp) {
-		spin_unlock(&l_tg_pt_gp_mem->tg_pt_gp_mem_lock);
-		pr_err("Unable to access *l_tg_pt_gp_mem->tg_pt_gp\n");
+		spin_unlock(&l_lun->lun_tg_pt_gp_lock);
+		pr_err("Unable to access l_lun->tg_pt_gp\n");
 		rc = TCM_UNSUPPORTED_SCSI_OPCODE;
 		goto out;
 	}
-	spin_unlock(&l_tg_pt_gp_mem->tg_pt_gp_mem_lock);
+	// XXX: keep referencing l_tg_pt_gp without a references
+	spin_unlock(&l_lun->lun_tg_pt_gp_lock);
 
 	if (!(l_tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_EXPLICIT_ALUA)) {
 		pr_debug("Unable to process SET_TARGET_PORT_GROUPS"
@@ -396,7 +383,7 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 				spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
 
 				if (!core_alua_do_port_transition(tg_pt_gp,
-						dev, l_port, nacl,
+						dev, l_lun, nacl,
 						alua_access_state, 1))
 					found = true;
 
@@ -406,6 +393,8 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 			}
 			spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
 		} else {
+			struct se_lun *lun;
+
 			/*
 			 * Extract the RELATIVE TARGET PORT IDENTIFIER to identify
 			 * the Target Port in question for the the incoming
@@ -417,17 +406,16 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 			 * for the struct se_device storage object.
 			 */
 			spin_lock(&dev->se_port_lock);
-			list_for_each_entry(port, &dev->dev_sep_list,
-							sep_list) {
-				if (port->sep_rtpi != rtpi)
+			list_for_each_entry(lun, &dev->dev_sep_list,
+							lun_dev_link) {
+				if (lun->lun_rtpi != rtpi)
 					continue;
 
-				tg_pt_gp_mem = port->sep_alua_tg_pt_gp_mem;
-
+				// XXX: racy unlock
 				spin_unlock(&dev->se_port_lock);
 
 				if (!core_alua_set_tg_pt_secondary_state(
-						tg_pt_gp_mem, port, 1, 1))
+						lun, 1, 1))
 					found = true;
 
 				spin_lock(&dev->se_port_lock);
@@ -696,9 +684,7 @@ target_alua_state_check(struct se_cmd *cmd)
 	struct se_device *dev = cmd->se_dev;
 	unsigned char *cdb = cmd->t_task_cdb;
 	struct se_lun *lun = cmd->se_lun;
-	struct se_port *port = lun->lun_sep;
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
-	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem;
 	int out_alua_state, nonop_delay_msecs;
 
 	if (dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE)
@@ -706,33 +692,27 @@ target_alua_state_check(struct se_cmd *cmd)
 	if (dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV)
 		return 0;
 
-	if (!port)
-		return 0;
 	/*
 	 * First, check for a struct se_port specific secondary ALUA target port
 	 * access state: OFFLINE
 	 */
-	if (atomic_read(&port->sep_tg_pt_secondary_offline)) {
+	if (atomic_read(&lun->lun_tg_pt_secondary_offline)) {
 		pr_debug("ALUA: Got secondary offline status for local"
 				" target port\n");
 		set_ascq(cmd, ASCQ_04H_ALUA_OFFLINE);
 		return TCM_CHECK_CONDITION_NOT_READY;
 	}
-	 /*
-	 * Second, obtain the struct t10_alua_tg_pt_gp_member pointer to the
-	 * ALUA target port group, to obtain current ALUA access state.
-	 * Otherwise look for the underlying struct se_device association with
-	 * a ALUA logical unit group.
-	 */
-	tg_pt_gp_mem = port->sep_alua_tg_pt_gp_mem;
-	if (!tg_pt_gp_mem)
+
+	if (!lun->lun_tg_pt_gp)
 		return 0;
 
-	spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
-	tg_pt_gp = tg_pt_gp_mem->tg_pt_gp;
+	spin_lock(&lun->lun_tg_pt_gp_lock);
+	tg_pt_gp = lun->lun_tg_pt_gp;
 	out_alua_state = atomic_read(&tg_pt_gp->tg_pt_gp_alua_access_state);
 	nonop_delay_msecs = tg_pt_gp->tg_pt_gp_nonop_delay_msecs;
-	spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
+
+	// XXX: keeps using tg_pt_gp witout reference after unlock
+	spin_unlock(&lun->lun_tg_pt_gp_lock);
 	/*
 	 * Process ALUA_ACCESS_STATE_ACTIVE_OPTIMIZED in a separate conditional
 	 * statement so the compiler knows explicitly to check this case first.
@@ -764,7 +744,7 @@ target_alua_state_check(struct se_cmd *cmd)
 		break;
 	/*
 	 * OFFLINE is a secondary ALUA target port group access state, that is
-	 * handled above with struct se_port->sep_tg_pt_secondary_offline=1
+	 * handled above with struct se_lun->lun_tg_pt_secondary_offline=1
 	 */
 	case ALUA_ACCESS_STATE_OFFLINE:
 	default:
@@ -906,10 +886,6 @@ int core_alua_check_nonop_delay(
 }
 EXPORT_SYMBOL(core_alua_check_nonop_delay);
 
-/*
- * Called with tg_pt_gp->tg_pt_gp_md_mutex or tg_pt_gp_mem->sep_tg_pt_md_mutex
- *
- */
 static int core_alua_write_tpg_metadata(
 	const char *path,
 	unsigned char *md_buf,
@@ -971,16 +947,14 @@ static void core_alua_do_transition_tg_pt_work(struct work_struct *work)
 		struct t10_alua_tg_pt_gp, tg_pt_gp_transition_work.work);
 	struct se_device *dev = tg_pt_gp->tg_pt_gp_dev;
 	struct se_dev_entry *se_deve;
+	struct se_lun *lun;
 	struct se_lun_acl *lacl;
-	struct se_port *port;
-	struct t10_alua_tg_pt_gp_member *mem;
 	bool explicit = (tg_pt_gp->tg_pt_gp_alua_access_status ==
 			 ALUA_STATUS_ALTERED_BY_EXPLICIT_STPG);
 
 	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
-	list_for_each_entry(mem, &tg_pt_gp->tg_pt_gp_mem_list,
-				tg_pt_gp_mem_list) {
-		port = mem->tg_pt;
+	list_for_each_entry(lun, &tg_pt_gp->tg_pt_gp_lun_list,
+				lun_tg_pt_gp_link) {
 		/*
 		 * After an implicit target port asymmetric access state
 		 * change, a device server shall establish a unit attention
@@ -995,12 +969,11 @@ static void core_alua_do_transition_tg_pt_work(struct work_struct *work)
 		 * every I_T nexus other than the I_T nexus on which the SET
 		 * TARGET PORT GROUPS command
 		 */
-		atomic_inc_mb(&mem->tg_pt_gp_mem_ref_cnt);
+		atomic_inc_mb(&lun->lun_active);
 		spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
 
-		spin_lock_bh(&port->sep_alua_lock);
-		list_for_each_entry(se_deve, &port->sep_alua_list,
-					alua_port_list) {
+		spin_lock_bh(&lun->lun_deve_lock);
+		list_for_each_entry(se_deve, &lun->lun_deve_list, lun_link) {
 			lacl = se_deve->se_lun_acl;
 			/*
 			 * se_deve->se_lun_acl pointer may be NULL for a
@@ -1013,18 +986,18 @@ static void core_alua_do_transition_tg_pt_work(struct work_struct *work)
 			     ALUA_STATUS_ALTERED_BY_EXPLICIT_STPG) &&
 			   (tg_pt_gp->tg_pt_gp_alua_nacl != NULL) &&
 			    (tg_pt_gp->tg_pt_gp_alua_nacl == lacl->se_lun_nacl) &&
-			   (tg_pt_gp->tg_pt_gp_alua_port != NULL) &&
-			    (tg_pt_gp->tg_pt_gp_alua_port == port))
+			   (tg_pt_gp->tg_pt_gp_alua_lun != NULL) &&
+			    (tg_pt_gp->tg_pt_gp_alua_lun == lun))
 				continue;
 
 			core_scsi3_ua_allocate(lacl->se_lun_nacl,
 				se_deve->mapped_lun, 0x2A,
 				ASCQ_2AH_ASYMMETRIC_ACCESS_STATE_CHANGED);
 		}
-		spin_unlock_bh(&port->sep_alua_lock);
+		spin_unlock_bh(&lun->lun_deve_lock);
 
 		spin_lock(&tg_pt_gp->tg_pt_gp_lock);
-		atomic_dec_mb(&mem->tg_pt_gp_mem_ref_cnt);
+		atomic_dec_mb(&lun->lun_active);
 	}
 	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
 	/*
@@ -1142,7 +1115,7 @@ static int core_alua_do_transition_tg_pt(
 int core_alua_do_port_transition(
 	struct t10_alua_tg_pt_gp *l_tg_pt_gp,
 	struct se_device *l_dev,
-	struct se_port *l_port,
+	struct se_lun *l_lun,
 	struct se_node_acl *l_nacl,
 	int new_state,
 	int explicit)
@@ -1172,7 +1145,7 @@ int core_alua_do_port_transition(
 		 * core_alua_do_transition_tg_pt() will always return
 		 * success.
 		 */
-		l_tg_pt_gp->tg_pt_gp_alua_port = l_port;
+		l_tg_pt_gp->tg_pt_gp_alua_lun = l_lun;
 		l_tg_pt_gp->tg_pt_gp_alua_nacl = l_nacl;
 		rc = core_alua_do_transition_tg_pt(l_tg_pt_gp,
 						   new_state, explicit);
@@ -1211,10 +1184,10 @@ int core_alua_do_port_transition(
 				continue;
 
 			if (l_tg_pt_gp == tg_pt_gp) {
-				tg_pt_gp->tg_pt_gp_alua_port = l_port;
+				tg_pt_gp->tg_pt_gp_alua_lun = l_lun;
 				tg_pt_gp->tg_pt_gp_alua_nacl = l_nacl;
 			} else {
-				tg_pt_gp->tg_pt_gp_alua_port = NULL;
+				tg_pt_gp->tg_pt_gp_alua_lun = NULL;
 				tg_pt_gp->tg_pt_gp_alua_nacl = NULL;
 			}
 			atomic_inc_mb(&tg_pt_gp->tg_pt_gp_ref_cnt);
@@ -1251,22 +1224,20 @@ int core_alua_do_port_transition(
 	return rc;
 }
 
-/*
- * Called with tg_pt_gp_mem->sep_tg_pt_md_mutex held
- */
-static int core_alua_update_tpg_secondary_metadata(
-	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem,
-	struct se_port *port)
+static int core_alua_update_tpg_secondary_metadata(struct se_lun *lun)
 {
+	struct se_portal_group *se_tpg = lun->lun_tpg;
 	unsigned char *md_buf;
-	struct se_portal_group *se_tpg = port->sep_tpg;
 	char path[ALUA_METADATA_PATH_LEN], wwn[ALUA_SECONDARY_METADATA_WWN_LEN];
 	int len, rc;
 
+	mutex_lock(&lun->lun_tg_pt_md_mutex);
+
 	md_buf = kzalloc(ALUA_MD_BUF_LEN, GFP_KERNEL);
 	if (!md_buf) {
 		pr_err("Unable to allocate buf for ALUA metadata\n");
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto out_unlock;
 	}
 
 	memset(path, 0, ALUA_METADATA_PATH_LEN);
@@ -1281,32 +1252,33 @@ static int core_alua_update_tpg_secondary_metadata(
 
 	len = snprintf(md_buf, ALUA_MD_BUF_LEN, "alua_tg_pt_offline=%d\n"
 			"alua_tg_pt_status=0x%02x\n",
-			atomic_read(&port->sep_tg_pt_secondary_offline),
-			port->sep_tg_pt_secondary_stat);
+			atomic_read(&lun->lun_tg_pt_secondary_offline),
+			lun->lun_tg_pt_secondary_stat);
 
 	snprintf(path, ALUA_METADATA_PATH_LEN, "/var/target/alua/%s/%s/lun_%u",
 			se_tpg->se_tpg_tfo->get_fabric_name(), wwn,
-			port->sep_lun->unpacked_lun);
+			lun->unpacked_lun);
 
 	rc = core_alua_write_tpg_metadata(path, md_buf, len);
 	kfree(md_buf);
 
+out_unlock:
+	mutex_unlock(&lun->lun_tg_pt_md_mutex);
 	return rc;
 }
 
 static int core_alua_set_tg_pt_secondary_state(
-	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem,
-	struct se_port *port,
+	struct se_lun *lun,
 	int explicit,
 	int offline)
 {
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
 	int trans_delay_msecs;
 
-	spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
-	tg_pt_gp = tg_pt_gp_mem->tg_pt_gp;
+	spin_lock(&lun->lun_tg_pt_gp_lock);
+	tg_pt_gp = lun->lun_tg_pt_gp;
 	if (!tg_pt_gp) {
-		spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
+		spin_unlock(&lun->lun_tg_pt_gp_lock);
 		pr_err("Unable to complete secondary state"
 				" transition\n");
 		return -EINVAL;
@@ -1314,14 +1286,14 @@ static int core_alua_set_tg_pt_secondary_state(
 	trans_delay_msecs = tg_pt_gp->tg_pt_gp_trans_delay_msecs;
 	/*
 	 * Set the secondary ALUA target port access state to OFFLINE
-	 * or release the previously secondary state for struct se_port
+	 * or release the previously secondary state for struct se_lun
 	 */
 	if (offline)
-		atomic_set(&port->sep_tg_pt_secondary_offline, 1);
+		atomic_set(&lun->lun_tg_pt_secondary_offline, 1);
 	else
-		atomic_set(&port->sep_tg_pt_secondary_offline, 0);
+		atomic_set(&lun->lun_tg_pt_secondary_offline, 0);
 
-	port->sep_tg_pt_secondary_stat = (explicit) ?
+	lun->lun_tg_pt_secondary_stat = (explicit) ?
 			ALUA_STATUS_ALTERED_BY_EXPLICIT_STPG :
 			ALUA_STATUS_ALTERED_BY_IMPLICIT_ALUA;
 
@@ -1330,7 +1302,7 @@ static int core_alua_set_tg_pt_secondary_state(
 		"implicit", config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item),
 		tg_pt_gp->tg_pt_gp_id, (offline) ? "OFFLINE" : "ONLINE");
 
-	spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
+	spin_unlock(&lun->lun_tg_pt_gp_lock);
 	/*
 	 * Do the optional transition delay after we set the secondary
 	 * ALUA access state.
@@ -1341,11 +1313,8 @@ static int core_alua_set_tg_pt_secondary_state(
 	 * See if we need to update the ALUA fabric port metadata for
 	 * secondary state and status
 	 */
-	if (port->sep_tg_pt_secondary_write_md) {
-		mutex_lock(&port->sep_tg_pt_md_mutex);
-		core_alua_update_tpg_secondary_metadata(tg_pt_gp_mem, port);
-		mutex_unlock(&port->sep_tg_pt_md_mutex);
-	}
+	if (lun->lun_tg_pt_secondary_write_md)
+		core_alua_update_tpg_secondary_metadata(lun);
 
 	return 0;
 }
@@ -1699,7 +1668,7 @@ struct t10_alua_tg_pt_gp *core_alua_allocate_tg_pt_gp(struct se_device *dev,
 		return NULL;
 	}
 	INIT_LIST_HEAD(&tg_pt_gp->tg_pt_gp_list);
-	INIT_LIST_HEAD(&tg_pt_gp->tg_pt_gp_mem_list);
+	INIT_LIST_HEAD(&tg_pt_gp->tg_pt_gp_lun_list);
 	mutex_init(&tg_pt_gp->tg_pt_gp_md_mutex);
 	spin_lock_init(&tg_pt_gp->tg_pt_gp_lock);
 	atomic_set(&tg_pt_gp->tg_pt_gp_ref_cnt, 0);
@@ -1793,32 +1762,11 @@ again:
 	return 0;
 }
 
-struct t10_alua_tg_pt_gp_member *core_alua_allocate_tg_pt_gp_mem(
-	struct se_port *port)
-{
-	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem;
-
-	tg_pt_gp_mem = kmem_cache_zalloc(t10_alua_tg_pt_gp_mem_cache,
-				GFP_KERNEL);
-	if (!tg_pt_gp_mem) {
-		pr_err("Unable to allocate struct t10_alua_tg_pt_gp_member\n");
-		return ERR_PTR(-ENOMEM);
-	}
-	INIT_LIST_HEAD(&tg_pt_gp_mem->tg_pt_gp_mem_list);
-	spin_lock_init(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
-	atomic_set(&tg_pt_gp_mem->tg_pt_gp_mem_ref_cnt, 0);
-
-	tg_pt_gp_mem->tg_pt = port;
-	port->sep_alua_tg_pt_gp_mem = tg_pt_gp_mem;
-
-	return tg_pt_gp_mem;
-}
-
 void core_alua_free_tg_pt_gp(
 	struct t10_alua_tg_pt_gp *tg_pt_gp)
 {
 	struct se_device *dev = tg_pt_gp->tg_pt_gp_dev;
-	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem, *tg_pt_gp_mem_tmp;
+	struct se_lun *lun, *next;
 
 	/*
 	 * Once we have reached this point, config_item_put() has already
@@ -1849,30 +1797,24 @@ void core_alua_free_tg_pt_gp(
 	 * struct se_port.
 	 */
 	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
-	list_for_each_entry_safe(tg_pt_gp_mem, tg_pt_gp_mem_tmp,
-			&tg_pt_gp->tg_pt_gp_mem_list, tg_pt_gp_mem_list) {
-		if (tg_pt_gp_mem->tg_pt_gp_assoc) {
-			list_del(&tg_pt_gp_mem->tg_pt_gp_mem_list);
-			tg_pt_gp->tg_pt_gp_members--;
-			tg_pt_gp_mem->tg_pt_gp_assoc = 0;
-		}
+	list_for_each_entry_safe(lun, next,
+			&tg_pt_gp->tg_pt_gp_lun_list, lun_tg_pt_gp_link) {
+		list_del_init(&lun->lun_tg_pt_gp_link);
+		tg_pt_gp->tg_pt_gp_members--;
+
 		spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
 		/*
-		 * tg_pt_gp_mem is associated with a single
-		 * se_port->sep_alua_tg_pt_gp_mem, and is released via
-		 * core_alua_free_tg_pt_gp_mem().
-		 *
 		 * If the passed tg_pt_gp does NOT match the default_tg_pt_gp,
 		 * assume we want to re-associate a given tg_pt_gp_mem with
 		 * default_tg_pt_gp.
 		 */
-		spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
+		spin_lock(&lun->lun_tg_pt_gp_lock);
 		if (tg_pt_gp != dev->t10_alua.default_tg_pt_gp) {
-			__core_alua_attach_tg_pt_gp_mem(tg_pt_gp_mem,
+			__target_attach_tg_pt_gp(lun,
 					dev->t10_alua.default_tg_pt_gp);
 		} else
-			tg_pt_gp_mem->tg_pt_gp = NULL;
-		spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
+			lun->lun_tg_pt_gp = NULL;
+		spin_unlock(&lun->lun_tg_pt_gp_lock);
 
 		spin_lock(&tg_pt_gp->tg_pt_gp_lock);
 	}
@@ -1881,35 +1823,6 @@ void core_alua_free_tg_pt_gp(
 	kmem_cache_free(t10_alua_tg_pt_gp_cache, tg_pt_gp);
 }
 
-void core_alua_free_tg_pt_gp_mem(struct se_port *port)
-{
-	struct t10_alua_tg_pt_gp *tg_pt_gp;
-	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem;
-
-	tg_pt_gp_mem = port->sep_alua_tg_pt_gp_mem;
-	if (!tg_pt_gp_mem)
-		return;
-
-	while (atomic_read(&tg_pt_gp_mem->tg_pt_gp_mem_ref_cnt))
-		cpu_relax();
-
-	spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
-	tg_pt_gp = tg_pt_gp_mem->tg_pt_gp;
-	if (tg_pt_gp) {
-		spin_lock(&tg_pt_gp->tg_pt_gp_lock);
-		if (tg_pt_gp_mem->tg_pt_gp_assoc) {
-			list_del(&tg_pt_gp_mem->tg_pt_gp_mem_list);
-			tg_pt_gp->tg_pt_gp_members--;
-			tg_pt_gp_mem->tg_pt_gp_assoc = 0;
-		}
-		spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
-		tg_pt_gp_mem->tg_pt_gp = NULL;
-	}
-	spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
-
-	kmem_cache_free(t10_alua_tg_pt_gp_mem_cache, tg_pt_gp_mem);
-}
-
 static struct t10_alua_tg_pt_gp *core_alua_get_tg_pt_gp_by_name(
 		struct se_device *dev, const char *name)
 {
@@ -1943,50 +1856,58 @@ static void core_alua_put_tg_pt_gp_from_name(
 	spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
 }
 
-/*
- * Called with struct t10_alua_tg_pt_gp_member->tg_pt_gp_mem_lock held
- */
-void __core_alua_attach_tg_pt_gp_mem(
-	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem,
-	struct t10_alua_tg_pt_gp *tg_pt_gp)
+static void __target_attach_tg_pt_gp(struct se_lun *lun,
+		struct t10_alua_tg_pt_gp *tg_pt_gp)
 {
+	assert_spin_locked(&lun->lun_tg_pt_gp_lock);
+
 	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
-	tg_pt_gp_mem->tg_pt_gp = tg_pt_gp;
-	tg_pt_gp_mem->tg_pt_gp_assoc = 1;
-	list_add_tail(&tg_pt_gp_mem->tg_pt_gp_mem_list,
-			&tg_pt_gp->tg_pt_gp_mem_list);
+	lun->lun_tg_pt_gp = tg_pt_gp;
+	list_add_tail(&lun->lun_tg_pt_gp_link, &tg_pt_gp->tg_pt_gp_lun_list);
 	tg_pt_gp->tg_pt_gp_members++;
 	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
 }
 
-/*
- * Called with struct t10_alua_tg_pt_gp_member->tg_pt_gp_mem_lock held
- */
-static void __core_alua_drop_tg_pt_gp_mem(
-	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem,
-	struct t10_alua_tg_pt_gp *tg_pt_gp)
+void target_attach_tg_pt_gp(struct se_lun *lun,
+		struct t10_alua_tg_pt_gp *tg_pt_gp)
+{
+	spin_lock(&lun->lun_tg_pt_gp_lock);
+	__target_attach_tg_pt_gp(lun, tg_pt_gp);
+	spin_unlock(&lun->lun_tg_pt_gp_lock);
+}
+
+static void __target_detach_tg_pt_gp(struct se_lun *lun,
+		struct t10_alua_tg_pt_gp *tg_pt_gp)
 {
+	assert_spin_locked(&lun->lun_tg_pt_gp_lock);
+
 	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
-	list_del(&tg_pt_gp_mem->tg_pt_gp_mem_list);
-	tg_pt_gp_mem->tg_pt_gp = NULL;
-	tg_pt_gp_mem->tg_pt_gp_assoc = 0;
+	list_del_init(&lun->lun_tg_pt_gp_link);
 	tg_pt_gp->tg_pt_gp_members--;
 	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
+
+	lun->lun_tg_pt_gp = NULL;
 }
 
-ssize_t core_alua_show_tg_pt_gp_info(struct se_port *port, char *page)
+void target_detach_tg_pt_gp(struct se_lun *lun)
+{
+	struct t10_alua_tg_pt_gp *tg_pt_gp;
+
+	spin_lock(&lun->lun_tg_pt_gp_lock);
+	tg_pt_gp = lun->lun_tg_pt_gp;
+	if (tg_pt_gp)
+		__target_detach_tg_pt_gp(lun, tg_pt_gp);
+	spin_unlock(&lun->lun_tg_pt_gp_lock);
+}
+
+ssize_t core_alua_show_tg_pt_gp_info(struct se_lun *lun, char *page)
 {
 	struct config_item *tg_pt_ci;
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
-	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem;
 	ssize_t len = 0;
 
-	tg_pt_gp_mem = port->sep_alua_tg_pt_gp_mem;
-	if (!tg_pt_gp_mem)
-		return len;
-
-	spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
-	tg_pt_gp = tg_pt_gp_mem->tg_pt_gp;
+	spin_lock(&lun->lun_tg_pt_gp_lock);
+	tg_pt_gp = lun->lun_tg_pt_gp;
 	if (tg_pt_gp) {
 		tg_pt_ci = &tg_pt_gp->tg_pt_gp_group.cg_item;
 		len += sprintf(page, "TG Port Alias: %s\nTG Port Group ID:"
@@ -1998,34 +1919,29 @@ ssize_t core_alua_show_tg_pt_gp_info(struct se_port *port, char *page)
 					&tg_pt_gp->tg_pt_gp_alua_access_state)),
 			core_alua_dump_status(
 				tg_pt_gp->tg_pt_gp_alua_access_status),
-			(atomic_read(&port->sep_tg_pt_secondary_offline)) ?
+			atomic_read(&lun->lun_tg_pt_secondary_offline) ?
 			"Offline" : "None",
-			core_alua_dump_status(port->sep_tg_pt_secondary_stat));
+			core_alua_dump_status(lun->lun_tg_pt_secondary_stat));
 	}
-	spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
+	spin_unlock(&lun->lun_tg_pt_gp_lock);
 
 	return len;
 }
 
 ssize_t core_alua_store_tg_pt_gp_info(
-	struct se_port *port,
+	struct se_lun *lun,
 	const char *page,
 	size_t count)
 {
-	struct se_portal_group *tpg;
-	struct se_lun *lun;
-	struct se_device *dev = port->sep_lun->lun_se_dev;
+	struct se_portal_group *tpg = lun->lun_tpg;
+	struct se_device *dev = lun->lun_se_dev;
 	struct t10_alua_tg_pt_gp *tg_pt_gp = NULL, *tg_pt_gp_new = NULL;
-	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem;
 	unsigned char buf[TG_PT_GROUP_NAME_BUF];
 	int move = 0;
 
-	tpg = port->sep_tpg;
-	lun = port->sep_lun;
-
-	tg_pt_gp_mem = port->sep_alua_tg_pt_gp_mem;
-	if (!tg_pt_gp_mem)
-		return 0;
+	if (dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV ||
+	    (dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE))
+		return -ENODEV;
 
 	if (count > TG_PT_GROUP_NAME_BUF) {
 		pr_err("ALUA Target Port Group alias too large!\n");
@@ -2049,8 +1965,8 @@ ssize_t core_alua_store_tg_pt_gp_info(
 			return -ENODEV;
 	}
 
-	spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
-	tg_pt_gp = tg_pt_gp_mem->tg_pt_gp;
+	spin_lock(&lun->lun_tg_pt_gp_lock);
+	tg_pt_gp = lun->lun_tg_pt_gp;
 	if (tg_pt_gp) {
 		/*
 		 * Clearing an existing tg_pt_gp association, and replacing
@@ -2068,24 +1984,19 @@ ssize_t core_alua_store_tg_pt_gp_info(
 					&tg_pt_gp->tg_pt_gp_group.cg_item),
 				tg_pt_gp->tg_pt_gp_id);
 
-			__core_alua_drop_tg_pt_gp_mem(tg_pt_gp_mem, tg_pt_gp);
-			__core_alua_attach_tg_pt_gp_mem(tg_pt_gp_mem,
+			__target_detach_tg_pt_gp(lun, tg_pt_gp);
+			__target_attach_tg_pt_gp(lun,
 					dev->t10_alua.default_tg_pt_gp);
-			spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
+			spin_unlock(&lun->lun_tg_pt_gp_lock);
 
 			return count;
 		}
-		/*
-		 * Removing existing association of tg_pt_gp_mem with tg_pt_gp
-		 */
-		__core_alua_drop_tg_pt_gp_mem(tg_pt_gp_mem, tg_pt_gp);
+		__target_detach_tg_pt_gp(lun, tg_pt_gp);
 		move = 1;
 	}
-	/*
-	 * Associate tg_pt_gp_mem with tg_pt_gp_new.
-	 */
-	__core_alua_attach_tg_pt_gp_mem(tg_pt_gp_mem, tg_pt_gp_new);
-	spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
+
+	__target_attach_tg_pt_gp(lun, tg_pt_gp_new);
+	spin_unlock(&lun->lun_tg_pt_gp_lock);
 	pr_debug("Target_Core_ConfigFS: %s %s/tpgt_%hu/%s to ALUA"
 		" Target Port Group: alua/%s, ID: %hu\n", (move) ?
 		"Moving" : "Adding", tpg->se_tpg_tfo->tpg_get_wwn(tpg),
@@ -2268,11 +2179,8 @@ ssize_t core_alua_store_preferred_bit(
 
 ssize_t core_alua_show_offline_bit(struct se_lun *lun, char *page)
 {
-	if (!lun->lun_sep)
-		return -ENODEV;
-
 	return sprintf(page, "%d\n",
-		atomic_read(&lun->lun_sep->sep_tg_pt_secondary_offline));
+		atomic_read(&lun->lun_tg_pt_secondary_offline));
 }
 
 ssize_t core_alua_store_offline_bit(
@@ -2280,11 +2188,12 @@ ssize_t core_alua_store_offline_bit(
 	const char *page,
 	size_t count)
 {
-	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem;
+	struct se_device *dev = lun->lun_se_dev;
 	unsigned long tmp;
 	int ret;
 
-	if (!lun->lun_sep)
+	if (dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV ||
+	    (dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE))
 		return -ENODEV;
 
 	ret = kstrtoul(page, 0, &tmp);
@@ -2297,14 +2206,8 @@ ssize_t core_alua_store_offline_bit(
 				tmp);
 		return -EINVAL;
 	}
-	tg_pt_gp_mem = lun->lun_sep->sep_alua_tg_pt_gp_mem;
-	if (!tg_pt_gp_mem) {
-		pr_err("Unable to locate *tg_pt_gp_mem\n");
-		return -EINVAL;
-	}
 
-	ret = core_alua_set_tg_pt_secondary_state(tg_pt_gp_mem,
-			lun->lun_sep, 0, (int)tmp);
+	ret = core_alua_set_tg_pt_secondary_state(lun, 0, (int)tmp);
 	if (ret < 0)
 		return -EINVAL;
 
@@ -2315,7 +2218,7 @@ ssize_t core_alua_show_secondary_status(
 	struct se_lun *lun,
 	char *page)
 {
-	return sprintf(page, "%d\n", lun->lun_sep->sep_tg_pt_secondary_stat);
+	return sprintf(page, "%d\n", lun->lun_tg_pt_secondary_stat);
 }
 
 ssize_t core_alua_store_secondary_status(
@@ -2338,7 +2241,7 @@ ssize_t core_alua_store_secondary_status(
 				tmp);
 		return -EINVAL;
 	}
-	lun->lun_sep->sep_tg_pt_secondary_stat = (int)tmp;
+	lun->lun_tg_pt_secondary_stat = (int)tmp;
 
 	return count;
 }
@@ -2347,8 +2250,7 @@ ssize_t core_alua_show_secondary_write_metadata(
 	struct se_lun *lun,
 	char *page)
 {
-	return sprintf(page, "%d\n",
-			lun->lun_sep->sep_tg_pt_secondary_write_md);
+	return sprintf(page, "%d\n", lun->lun_tg_pt_secondary_write_md);
 }
 
 ssize_t core_alua_store_secondary_write_metadata(
@@ -2369,7 +2271,7 @@ ssize_t core_alua_store_secondary_write_metadata(
 				" %lu\n", tmp);
 		return -EINVAL;
 	}
-	lun->lun_sep->sep_tg_pt_secondary_write_md = (int)tmp;
+	lun->lun_tg_pt_secondary_write_md = (int)tmp;
 
 	return count;
 }
diff --git a/drivers/target/target_core_alua.h b/drivers/target/target_core_alua.h
index 0a7d65e..9b250f9 100644
--- a/drivers/target/target_core_alua.h
+++ b/drivers/target/target_core_alua.h
@@ -85,7 +85,6 @@
 extern struct kmem_cache *t10_alua_lu_gp_cache;
 extern struct kmem_cache *t10_alua_lu_gp_mem_cache;
 extern struct kmem_cache *t10_alua_tg_pt_gp_cache;
-extern struct kmem_cache *t10_alua_tg_pt_gp_mem_cache;
 extern struct kmem_cache *t10_alua_lba_map_cache;
 extern struct kmem_cache *t10_alua_lba_map_mem_cache;
 
@@ -94,7 +93,7 @@ extern sense_reason_t target_emulate_set_target_port_groups(struct se_cmd *);
 extern sense_reason_t target_emulate_report_referrals(struct se_cmd *);
 extern int core_alua_check_nonop_delay(struct se_cmd *);
 extern int core_alua_do_port_transition(struct t10_alua_tg_pt_gp *,
-				struct se_device *, struct se_port *,
+				struct se_device *, struct se_lun *,
 				struct se_node_acl *, int, int);
 extern char *core_alua_dump_status(int);
 extern struct t10_alua_lba_map *core_alua_allocate_lba_map(
@@ -117,14 +116,11 @@ extern void core_alua_drop_lu_gp_dev(struct se_device *);
 extern struct t10_alua_tg_pt_gp *core_alua_allocate_tg_pt_gp(
 			struct se_device *, const char *, int);
 extern int core_alua_set_tg_pt_gp_id(struct t10_alua_tg_pt_gp *, u16);
-extern struct t10_alua_tg_pt_gp_member *core_alua_allocate_tg_pt_gp_mem(
-					struct se_port *);
 extern void core_alua_free_tg_pt_gp(struct t10_alua_tg_pt_gp *);
-extern void core_alua_free_tg_pt_gp_mem(struct se_port *);
-extern void __core_alua_attach_tg_pt_gp_mem(struct t10_alua_tg_pt_gp_member *,
-					struct t10_alua_tg_pt_gp *);
-extern ssize_t core_alua_show_tg_pt_gp_info(struct se_port *, char *);
-extern ssize_t core_alua_store_tg_pt_gp_info(struct se_port *, const char *,
+extern void target_detach_tg_pt_gp(struct se_lun *);
+extern void target_attach_tg_pt_gp(struct se_lun *, struct t10_alua_tg_pt_gp *);
+extern ssize_t core_alua_show_tg_pt_gp_info(struct se_lun *, char *);
+extern ssize_t core_alua_store_tg_pt_gp_info(struct se_lun *, const char *,
 						size_t);
 extern ssize_t core_alua_show_access_type(struct t10_alua_tg_pt_gp *, char *);
 extern ssize_t core_alua_store_access_type(struct t10_alua_tg_pt_gp *,
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 30d0504..4ada522 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2889,21 +2889,16 @@ static ssize_t target_core_alua_tg_pt_gp_show_attr_members(
 	struct t10_alua_tg_pt_gp *tg_pt_gp,
 	char *page)
 {
-	struct se_port *port;
-	struct se_portal_group *tpg;
 	struct se_lun *lun;
-	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem;
 	ssize_t len = 0, cur_len;
 	unsigned char buf[TG_PT_GROUP_NAME_BUF];
 
 	memset(buf, 0, TG_PT_GROUP_NAME_BUF);
 
 	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
-	list_for_each_entry(tg_pt_gp_mem, &tg_pt_gp->tg_pt_gp_mem_list,
-			tg_pt_gp_mem_list) {
-		port = tg_pt_gp_mem->tg_pt;
-		tpg = port->sep_tpg;
-		lun = port->sep_lun;
+	list_for_each_entry(lun, &tg_pt_gp->tg_pt_gp_lun_list,
+			lun_tg_pt_gp_link) {
+		struct se_portal_group *tpg = lun->lun_tpg;
 
 		cur_len = snprintf(buf, TG_PT_GROUP_NAME_BUF, "%s/%s/tpgt_%hu"
 			"/%s\n", tpg->se_tpg_tfo->get_fabric_name(),
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 2f4c8fa..83c9ffe 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -117,8 +117,8 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 		    (se_cmd->data_direction != DMA_NONE))
 			return TCM_WRITE_PROTECTED;
 
-		se_lun = &se_sess->se_tpg->tpg_virt_lun0;
-		se_cmd->se_lun = &se_sess->se_tpg->tpg_virt_lun0;
+		se_lun = se_sess->se_tpg->tpg_virt_lun0;
+		se_cmd->se_lun = se_sess->se_tpg->tpg_virt_lun0;
 		se_cmd->orig_fe_lun = 0;
 		se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
 
@@ -303,7 +303,6 @@ int core_enable_device_list_for_node(
 	struct se_node_acl *nacl,
 	struct se_portal_group *tpg)
 {
-	struct se_port *port = lun->lun_sep;
 	struct se_dev_entry *orig, *new;
 
 	new = kzalloc(sizeof(*new), GFP_KERNEL);
@@ -315,8 +314,8 @@ int core_enable_device_list_for_node(
 	new->se_node_acl = nacl;
 	atomic_set(&new->ua_count, 0);
 	spin_lock_init(&new->ua_lock);
-	INIT_LIST_HEAD(&new->alua_port_list);
 	INIT_LIST_HEAD(&new->ua_list);
+	INIT_LIST_HEAD(&new->lun_link);
 
 	new->mapped_lun = mapped_lun;
 	kref_init(&new->pr_kref);
@@ -341,10 +340,10 @@ int core_enable_device_list_for_node(
 		hlist_add_head_rcu(&new->link, &nacl->lun_entry_hlist);
 		mutex_unlock(&nacl->lun_entry_mutex);
 
-		spin_lock_bh(&port->sep_alua_lock);
-		list_del(&orig->alua_port_list);
-		list_add_tail(&new->alua_port_list, &port->sep_alua_list);
-		spin_unlock_bh(&port->sep_alua_lock);
+		spin_lock_bh(&lun->lun_deve_lock);
+		list_del(&orig->lun_link);
+		list_add_tail(&new->lun_link, &lun->lun_deve_list);
+		spin_unlock_bh(&lun->lun_deve_lock);
 
 		kref_put(&orig->pr_kref, target_pr_kref_release);
 		wait_for_completion(&orig->pr_comp);
@@ -358,9 +357,9 @@ int core_enable_device_list_for_node(
 	hlist_add_head_rcu(&new->link, &nacl->lun_entry_hlist);
 	mutex_unlock(&nacl->lun_entry_mutex);
 
-	spin_lock_bh(&port->sep_alua_lock);
-	list_add_tail(&new->alua_port_list, &port->sep_alua_list);
-	spin_unlock_bh(&port->sep_alua_lock);
+	spin_lock_bh(&lun->lun_deve_lock);
+	list_add_tail(&new->lun_link, &lun->lun_deve_list);
+	spin_unlock_bh(&lun->lun_deve_lock);
 
 	return 0;
 }
@@ -374,23 +373,22 @@ void core_disable_device_list_for_node(
 	struct se_node_acl *nacl,
 	struct se_portal_group *tpg)
 {
-	struct se_port *port = lun->lun_sep;
 	/*
 	 * If the MappedLUN entry is being disabled, the entry in
-	 * port->sep_alua_list must be removed now before clearing the
+	 * lun->lun_deve_list must be removed now before clearing the
 	 * struct se_dev_entry pointers below as logic in
 	 * core_alua_do_transition_tg_pt() depends on these being present.
 	 *
 	 * deve->se_lun_acl will be NULL for demo-mode created LUNs
 	 * that have not been explicitly converted to MappedLUNs ->
-	 * struct se_lun_acl, but we remove deve->alua_port_list from
-	 * port->sep_alua_list. This also means that active UAs and
+	 * struct se_lun_acl, but we remove deve->lun_link from
+	 * lun->lun_deve_list. This also means that active UAs and
 	 * NodeACL context specific PR metadata for demo-mode
 	 * MappedLUN *deve will be released below..
 	 */
-	spin_lock_bh(&port->sep_alua_lock);
-	list_del(&orig->alua_port_list);
-	spin_unlock_bh(&port->sep_alua_lock);
+	spin_lock_bh(&lun->lun_deve_lock);
+	list_del(&orig->lun_link);
+	spin_unlock_bh(&lun->lun_deve_lock);
 	/*
 	 * Disable struct se_dev_entry LUN ACL mapping
 	 */
@@ -438,27 +436,16 @@ void core_clear_lun_from_tpg(struct se_lun *lun, struct se_portal_group *tpg)
 	mutex_unlock(&tpg->acl_node_mutex);
 }
 
-static struct se_port *core_alloc_port(struct se_device *dev)
+int core_alloc_rtpi(struct se_lun *lun, struct se_device *dev)
 {
-	struct se_port *port, *port_tmp;
-
-	port = kzalloc(sizeof(struct se_port), GFP_KERNEL);
-	if (!port) {
-		pr_err("Unable to allocate struct se_port\n");
-		return ERR_PTR(-ENOMEM);
-	}
-	INIT_LIST_HEAD(&port->sep_alua_list);
-	INIT_LIST_HEAD(&port->sep_list);
-	atomic_set(&port->sep_tg_pt_secondary_offline, 0);
-	spin_lock_init(&port->sep_alua_lock);
-	mutex_init(&port->sep_tg_pt_md_mutex);
+	struct se_lun *tmp;
 
 	spin_lock(&dev->se_port_lock);
-	if (dev->dev_port_count == 0x0000ffff) {
+	if (dev->export_count == 0x0000ffff) {
 		pr_warn("Reached dev->dev_port_count =="
 				" 0x0000ffff\n");
 		spin_unlock(&dev->se_port_lock);
-		return ERR_PTR(-ENOSPC);
+		return -ENOSPC;
 	}
 again:
 	/*
@@ -473,134 +460,22 @@ again:
 	 * 2h        Relative port 2, historically known as port B
 	 * 3h to FFFFh    Relative port 3 through 65 535
 	 */
-	port->sep_rtpi = dev->dev_rpti_counter++;
-	if (!port->sep_rtpi)
+	lun->lun_rtpi = dev->dev_rpti_counter++;
+	if (!lun->lun_rtpi)
 		goto again;
 
-	list_for_each_entry(port_tmp, &dev->dev_sep_list, sep_list) {
+	list_for_each_entry(tmp, &dev->dev_sep_list, lun_dev_link) {
 		/*
 		 * Make sure RELATIVE TARGET PORT IDENTIFIER is unique
 		 * for 16-bit wrap..
 		 */
-		if (port->sep_rtpi == port_tmp->sep_rtpi)
+		if (lun->lun_rtpi == tmp->lun_rtpi)
 			goto again;
 	}
 	spin_unlock(&dev->se_port_lock);
-
-	return port;
-}
-
-static void core_export_port(
-	struct se_device *dev,
-	struct se_portal_group *tpg,
-	struct se_port *port,
-	struct se_lun *lun)
-{
-	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem = NULL;
-
-	spin_lock(&dev->se_port_lock);
-	spin_lock(&lun->lun_sep_lock);
-	port->sep_tpg = tpg;
-	port->sep_lun = lun;
-	lun->lun_sep = port;
-	spin_unlock(&lun->lun_sep_lock);
-
-	list_add_tail(&port->sep_list, &dev->dev_sep_list);
-	spin_unlock(&dev->se_port_lock);
-
-	if (dev->transport->transport_type != TRANSPORT_PLUGIN_PHBA_PDEV &&
-	    !(dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE)) {
-		tg_pt_gp_mem = core_alua_allocate_tg_pt_gp_mem(port);
-		if (IS_ERR(tg_pt_gp_mem) || !tg_pt_gp_mem) {
-			pr_err("Unable to allocate t10_alua_tg_pt"
-					"_gp_member_t\n");
-			return;
-		}
-		spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
-		__core_alua_attach_tg_pt_gp_mem(tg_pt_gp_mem,
-			dev->t10_alua.default_tg_pt_gp);
-		spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
-		pr_debug("%s/%s: Adding to default ALUA Target Port"
-			" Group: alua/default_tg_pt_gp\n",
-			dev->transport->name, tpg->se_tpg_tfo->get_fabric_name());
-	}
-
-	dev->dev_port_count++;
-	port->sep_index = port->sep_rtpi; /* RELATIVE TARGET PORT IDENTIFIER */
-}
-
-/*
- *	Called with struct se_device->se_port_lock spinlock held.
- */
-static void core_release_port(struct se_device *dev, struct se_port *port)
-	__releases(&dev->se_port_lock) __acquires(&dev->se_port_lock)
-{
-	/*
-	 * Wait for any port reference for PR ALL_TG_PT=1 operation
-	 * to complete in __core_scsi3_alloc_registration()
-	 */
-	spin_unlock(&dev->se_port_lock);
-	if (atomic_read(&port->sep_tg_pt_ref_cnt))
-		cpu_relax();
-	spin_lock(&dev->se_port_lock);
-
-	core_alua_free_tg_pt_gp_mem(port);
-
-	list_del(&port->sep_list);
-	dev->dev_port_count--;
-	kfree(port);
-}
-
-int core_dev_export(
-	struct se_device *dev,
-	struct se_portal_group *tpg,
-	struct se_lun *lun)
-{
-	struct se_hba *hba = dev->se_hba;
-	struct se_port *port;
-
-	port = core_alloc_port(dev);
-	if (IS_ERR(port))
-		return PTR_ERR(port);
-
-	lun->lun_se_dev = dev;
-	lun->lun_rtpi = port->sep_rtpi;
-
-	spin_lock(&hba->device_lock);
-	dev->export_count++;
-	spin_unlock(&hba->device_lock);
-
-	core_export_port(dev, tpg, port, lun);
 	return 0;
 }
 
-void core_dev_unexport(
-	struct se_device *dev,
-	struct se_portal_group *tpg,
-	struct se_lun *lun)
-{
-	struct se_hba *hba = dev->se_hba;
-	struct se_port *port = lun->lun_sep;
-
-	spin_lock(&lun->lun_sep_lock);
-	if (lun->lun_se_dev == NULL) {
-		spin_unlock(&lun->lun_sep_lock);
-		return;
-	}
-	spin_unlock(&lun->lun_sep_lock);
-
-	spin_lock(&dev->se_port_lock);
-	core_release_port(dev, port);
-	spin_unlock(&dev->se_port_lock);
-
-	spin_lock(&hba->device_lock);
-	dev->export_count--;
-	spin_unlock(&hba->device_lock);
-
-	lun->lun_sep = NULL;
-	lun->lun_se_dev = NULL;
-}
-
 static void se_release_vpd_for_dev(struct se_device *dev)
 {
 	struct t10_vpd *vpd, *vpd_tmp;
@@ -762,10 +637,10 @@ int core_dev_add_initiator_node_lun_acl(
 }
 
 int core_dev_del_initiator_node_lun_acl(
-	struct se_portal_group *tpg,
 	struct se_lun *lun,
 	struct se_lun_acl *lacl)
 {
+	struct se_portal_group *tpg = lun->lun_tpg;
 	struct se_node_acl *nacl;
 	struct se_dev_entry *deve;
 
@@ -910,6 +785,10 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	init_completion(&xcopy_lun->lun_shutdown_comp);
 	spin_lock_init(&xcopy_lun->lun_sep_lock);
 	init_completion(&xcopy_lun->lun_ref_comp);
+	INIT_LIST_HEAD(&xcopy_lun->lun_deve_list);
+	INIT_LIST_HEAD(&xcopy_lun->lun_dev_link);
+	mutex_init(&xcopy_lun->lun_tg_pt_md_mutex);
+	xcopy_lun->lun_tpg = &xcopy_pt_tpg;
 
 	return dev;
 }
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index a0e2946..16bfa2d 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -91,12 +91,11 @@ static int target_fabric_mappedlun_link(
 	/*
 	 * Ensure that the source port exists
 	 */
-	if (!lun->lun_sep || !lun->lun_sep->sep_tpg) {
-		pr_err("Source se_lun->lun_sep or lun->lun_sep->sep"
-				"_tpg does not exist\n");
+	if (!lun->lun_se_dev) {
+		pr_err("Source se_lun->lun_se_dev does not exist\n");
 		return -EINVAL;
 	}
-	se_tpg = lun->lun_sep->sep_tpg;
+	se_tpg = lun->lun_tpg;
 
 	nacl_ci = &lun_acl_ci->ci_parent->ci_group->cg_item;
 	tpg_ci = &nacl_ci->ci_group->cg_item;
@@ -150,9 +149,8 @@ static int target_fabric_mappedlun_unlink(
 			struct se_lun_acl, se_lun_group);
 	struct se_lun *lun = container_of(to_config_group(lun_ci),
 			struct se_lun, lun_group);
-	struct se_portal_group *se_tpg = lun->lun_sep->sep_tpg;
 
-	return core_dev_del_initiator_node_lun_acl(se_tpg, lun, lacl);
+	return core_dev_del_initiator_node_lun_acl(lun, lacl);
 }
 
 CONFIGFS_EATTR_STRUCT(target_fabric_mappedlun, se_lun_acl);
@@ -643,10 +641,10 @@ static ssize_t target_fabric_port_show_attr_alua_tg_pt_gp(
 	struct se_lun *lun,
 	char *page)
 {
-	if (!lun || !lun->lun_sep)
+	if (!lun || !lun->lun_se_dev)
 		return -ENODEV;
 
-	return core_alua_show_tg_pt_gp_info(lun->lun_sep, page);
+	return core_alua_show_tg_pt_gp_info(lun, page);
 }
 
 static ssize_t target_fabric_port_store_attr_alua_tg_pt_gp(
@@ -654,10 +652,10 @@ static ssize_t target_fabric_port_store_attr_alua_tg_pt_gp(
 	const char *page,
 	size_t count)
 {
-	if (!lun || !lun->lun_sep)
+	if (!lun || !lun->lun_se_dev)
 		return -ENODEV;
 
-	return core_alua_store_tg_pt_gp_info(lun->lun_sep, page, count);
+	return core_alua_store_tg_pt_gp_info(lun, page, count);
 }
 
 TCM_PORT_ATTR(alua_tg_pt_gp, S_IRUGO | S_IWUSR);
@@ -669,7 +667,7 @@ static ssize_t target_fabric_port_show_attr_alua_tg_pt_offline(
 	struct se_lun *lun,
 	char *page)
 {
-	if (!lun || !lun->lun_sep)
+	if (!lun || !lun->lun_se_dev)
 		return -ENODEV;
 
 	return core_alua_show_offline_bit(lun, page);
@@ -680,7 +678,7 @@ static ssize_t target_fabric_port_store_attr_alua_tg_pt_offline(
 	const char *page,
 	size_t count)
 {
-	if (!lun || !lun->lun_sep)
+	if (!lun || !lun->lun_se_dev)
 		return -ENODEV;
 
 	return core_alua_store_offline_bit(lun, page, count);
@@ -695,7 +693,7 @@ static ssize_t target_fabric_port_show_attr_alua_tg_pt_status(
 	struct se_lun *lun,
 	char *page)
 {
-	if (!lun || !lun->lun_sep)
+	if (!lun || !lun->lun_se_dev)
 		return -ENODEV;
 
 	return core_alua_show_secondary_status(lun, page);
@@ -706,7 +704,7 @@ static ssize_t target_fabric_port_store_attr_alua_tg_pt_status(
 	const char *page,
 	size_t count)
 {
-	if (!lun || !lun->lun_sep)
+	if (!lun || !lun->lun_se_dev)
 		return -ENODEV;
 
 	return core_alua_store_secondary_status(lun, page, count);
@@ -721,7 +719,7 @@ static ssize_t target_fabric_port_show_attr_alua_tg_pt_write_md(
 	struct se_lun *lun,
 	char *page)
 {
-	if (!lun || !lun->lun_sep)
+	if (!lun || !lun->lun_se_dev)
 		return -ENODEV;
 
 	return core_alua_show_secondary_write_metadata(lun, page);
@@ -732,7 +730,7 @@ static ssize_t target_fabric_port_store_attr_alua_tg_pt_write_md(
 	const char *page,
 	size_t count)
 {
-	if (!lun || !lun->lun_sep)
+	if (!lun || !lun->lun_se_dev)
 		return -ENODEV;
 
 	return core_alua_store_secondary_write_metadata(lun, page, count);
@@ -811,7 +809,7 @@ static int target_fabric_port_unlink(
 {
 	struct se_lun *lun = container_of(to_config_group(lun_ci),
 				struct se_lun, lun_group);
-	struct se_portal_group *se_tpg = lun->lun_sep->sep_tpg;
+	struct se_portal_group *se_tpg = lun->lun_tpg;
 	struct target_fabric_configfs *tf = se_tpg->se_tpg_wwn->wwn_tf;
 
 	if (tf->tf_ops->fabric_pre_unlink) {
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index beb1c3e..187fd24 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -21,6 +21,7 @@ extern struct t10_alua_lu_gp *default_lu_gp;
 extern struct mutex g_device_mutex;
 extern struct list_head g_device_list;
 
+int	core_alloc_rtpi(struct se_lun *lun, struct se_device *dev);
 struct se_dev_entry *core_get_se_deve_from_rtpi(struct se_node_acl *, u16);
 void	target_pr_kref_release(struct kref *);
 void	core_free_device_list_for_node(struct se_node_acl *,
@@ -32,10 +33,6 @@ int	core_enable_device_list_for_node(struct se_lun *, struct se_lun_acl *,
 void	core_disable_device_list_for_node(struct se_lun *, struct se_dev_entry *,
 		struct se_node_acl *, struct se_portal_group *);
 void	core_clear_lun_from_tpg(struct se_lun *, struct se_portal_group *);
-int	core_dev_export(struct se_device *, struct se_portal_group *,
-		struct se_lun *);
-void	core_dev_unexport(struct se_device *, struct se_portal_group *,
-		struct se_lun *);
 int	core_dev_add_lun(struct se_portal_group *, struct se_device *,
 		struct se_lun *lun);
 void	core_dev_del_lun(struct se_portal_group *, struct se_lun *);
@@ -43,8 +40,8 @@ struct se_lun_acl *core_dev_init_initiator_node_lun_acl(struct se_portal_group *
 		struct se_node_acl *, u32, int *);
 int	core_dev_add_initiator_node_lun_acl(struct se_portal_group *,
 		struct se_lun_acl *, struct se_lun *lun, u32);
-int	core_dev_del_initiator_node_lun_acl(struct se_portal_group *,
-		struct se_lun *, struct se_lun_acl *);
+int	core_dev_del_initiator_node_lun_acl(struct se_lun *,
+		struct se_lun_acl *);
 void	core_dev_free_initiator_node_lun_acl(struct se_portal_group *,
 		struct se_lun_acl *lacl);
 int	core_dev_setup_virtual_lun0(void);
@@ -119,4 +116,7 @@ void	target_stat_setup_dev_default_groups(struct se_device *);
 void	target_stat_setup_port_default_groups(struct se_lun *);
 void	target_stat_setup_mappedlun_default_groups(struct se_lun_acl *);
 
+/* target_core_xcopy.c */
+extern struct se_portal_group xcopy_pt_tpg;
+
 #endif /* TARGET_CORE_INTERNAL_H */
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index cee2b31..413ba16 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -641,7 +641,7 @@ static struct t10_pr_registration *__core_scsi3_do_alloc_registration(
 	pr_reg->pr_reg_deve = deve;
 	pr_reg->pr_res_mapped_lun = mapped_lun;
 	pr_reg->pr_aptpl_target_lun = lun->unpacked_lun;
-	pr_reg->tg_pt_sep_rtpi = lun->lun_sep->sep_rtpi;
+	pr_reg->tg_pt_sep_rtpi = lun->lun_rtpi;
 	pr_reg->pr_res_key = sa_res_key;
 	pr_reg->pr_reg_all_tg_pt = all_tg_pt;
 	pr_reg->pr_reg_aptpl = aptpl;
@@ -678,7 +678,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 {
 	struct se_dev_entry *deve_tmp;
 	struct se_node_acl *nacl_tmp;
-	struct se_port *port, *port_tmp;
+	struct se_lun *lun_tmp, *next;
 	const struct target_core_fabric_ops *tfo = nacl->se_tpg->se_tpg_tfo;
 	struct t10_pr_registration *pr_reg, *pr_reg_atp, *pr_reg_tmp, *pr_reg_tmp_safe;
 	int ret;
@@ -701,13 +701,12 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 	 * for ALL_TG_PT=1
 	 */
 	spin_lock(&dev->se_port_lock);
-	list_for_each_entry_safe(port, port_tmp, &dev->dev_sep_list, sep_list) {
-		atomic_inc_mb(&port->sep_tg_pt_ref_cnt);
+	list_for_each_entry_safe(lun_tmp, next, &dev->dev_sep_list, lun_dev_link) {
+		atomic_inc_mb(&lun_tmp->lun_active);
 		spin_unlock(&dev->se_port_lock);
 
-		spin_lock_bh(&port->sep_alua_lock);
-		list_for_each_entry(deve_tmp, &port->sep_alua_list,
-					alua_port_list) {
+		spin_lock_bh(&lun_tmp->lun_deve_lock);
+		list_for_each_entry(deve_tmp, &lun_tmp->lun_deve_list, lun_link) {
 			/*
 			 * This pointer will be NULL for demo mode MappedLUNs
 			 * that have not been make explicit via a ConfigFS
@@ -737,7 +736,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 				continue;
 
 			kref_get(&deve_tmp->pr_kref);
-			spin_unlock_bh(&port->sep_alua_lock);
+			spin_unlock_bh(&lun_tmp->lun_deve_lock);
 			/*
 			 * Grab a configfs group dependency that is released
 			 * for the exception path at label out: below, or upon
@@ -748,7 +747,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 			if (ret < 0) {
 				pr_err("core_scsi3_lunacl_depend"
 						"_item() failed\n");
-				atomic_dec_mb(&port->sep_tg_pt_ref_cnt);
+				atomic_dec_mb(&lun->lun_active);
 				kref_put(&deve_tmp->pr_kref, target_pr_kref_release);
 				goto out;
 			}
@@ -764,19 +763,19 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 						deve_tmp, deve_tmp->mapped_lun,
 						NULL, sa_res_key, all_tg_pt, aptpl);
 			if (!pr_reg_atp) {
-				atomic_dec_mb(&port->sep_tg_pt_ref_cnt);
+				atomic_dec_mb(&lun_tmp->lun_active);
 				core_scsi3_lunacl_undepend_item(deve_tmp);
 				goto out;
 			}
 
 			list_add_tail(&pr_reg_atp->pr_reg_atp_mem_list,
 				      &pr_reg->pr_reg_atp_list);
-			spin_lock_bh(&port->sep_alua_lock);
+			spin_lock_bh(&lun_tmp->lun_deve_lock);
 		}
-		spin_unlock_bh(&port->sep_alua_lock);
+		spin_unlock_bh(&lun_tmp->lun_deve_lock);
 
 		spin_lock(&dev->se_port_lock);
-		atomic_dec_mb(&port->sep_tg_pt_ref_cnt);
+		atomic_dec_mb(&lun_tmp->lun_active);
 	}
 	spin_unlock(&dev->se_port_lock);
 
@@ -930,7 +929,7 @@ static int __core_scsi3_check_aptpl_registration(
 		     (pr_reg->pr_aptpl_target_lun == target_lun)) {
 
 			pr_reg->pr_reg_nacl = nacl;
-			pr_reg->tg_pt_sep_rtpi = lun->lun_sep->sep_rtpi;
+			pr_reg->tg_pt_sep_rtpi = lun->lun_rtpi;
 
 			list_del(&pr_reg->pr_reg_aptpl_list);
 			spin_unlock(&pr_tmpl->aptpl_reg_lock);
@@ -1460,7 +1459,6 @@ core_scsi3_decode_spec_i_port(
 	int aptpl)
 {
 	struct se_device *dev = cmd->se_dev;
-	struct se_port *tmp_port;
 	struct se_portal_group *dest_tpg = NULL, *tmp_tpg;
 	struct se_session *se_sess = cmd->se_sess;
 	struct se_node_acl *dest_node_acl = NULL;
@@ -1545,14 +1543,14 @@ core_scsi3_decode_spec_i_port(
 	ptr = &buf[28];
 
 	while (tpdl > 0) {
+		struct se_lun *tmp_lun;
+
 		proto_ident = (ptr[0] & 0x0f);
 		dest_tpg = NULL;
 
 		spin_lock(&dev->se_port_lock);
-		list_for_each_entry(tmp_port, &dev->dev_sep_list, sep_list) {
-			tmp_tpg = tmp_port->sep_tpg;
-			if (!tmp_tpg)
-				continue;
+		list_for_each_entry(tmp_lun, &dev->dev_sep_list, lun_dev_link) {
+			tmp_tpg = tmp_lun->lun_tpg;
 
 			/*
 			 * Look for the matching proto_ident provided by
@@ -1560,7 +1558,7 @@ core_scsi3_decode_spec_i_port(
 			 */
 			if (tmp_tpg->proto_id != proto_ident)
 				continue;
-			dest_rtpi = tmp_port->sep_rtpi;
+			dest_rtpi = tmp_lun->lun_rtpi;
 
 			i_str = target_parse_pr_out_transport_id(tmp_tpg,
 					(const char *)ptr, &tid_len, &iport_ptr);
@@ -3109,9 +3107,8 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	struct se_session *se_sess = cmd->se_sess;
 	struct se_device *dev = cmd->se_dev;
 	struct se_dev_entry *dest_se_deve = NULL;
-	struct se_lun *se_lun = cmd->se_lun;
+	struct se_lun *se_lun = cmd->se_lun, *tmp_lun;
 	struct se_node_acl *pr_res_nacl, *pr_reg_nacl, *dest_node_acl = NULL;
-	struct se_port *se_port;
 	struct se_portal_group *se_tpg, *dest_se_tpg = NULL;
 	const struct target_core_fabric_ops *dest_tf_ops = NULL, *tf_ops;
 	struct t10_pr_registration *pr_reg, *pr_res_holder, *dest_pr_reg;
@@ -3196,12 +3193,10 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	}
 
 	spin_lock(&dev->se_port_lock);
-	list_for_each_entry(se_port, &dev->dev_sep_list, sep_list) {
-		if (se_port->sep_rtpi != rtpi)
-			continue;
-		dest_se_tpg = se_port->sep_tpg;
-		if (!dest_se_tpg)
+	list_for_each_entry(tmp_lun, &dev->dev_sep_list, lun_dev_link) {
+		if (tmp_lun->lun_rtpi != rtpi)
 			continue;
+		dest_se_tpg = tmp_lun->lun_tpg;
 		dest_tf_ops = dest_se_tpg->se_tpg_tfo;
 		if (!dest_tf_ops)
 			continue;
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index d882eea..53d781c 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -37,10 +37,9 @@
 #include "target_core_ua.h"
 #include "target_core_xcopy.h"
 
-static void spc_fill_alua_data(struct se_port *port, unsigned char *buf)
+static void spc_fill_alua_data(struct se_lun *lun, unsigned char *buf)
 {
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
-	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem;
 
 	/*
 	 * Set SCCS for MAINTENANCE_IN + REPORT_TARGET_PORT_GROUPS.
@@ -53,17 +52,11 @@ static void spc_fill_alua_data(struct se_port *port, unsigned char *buf)
 	 *
 	 * See spc4r17 section 6.4.2 Table 135
 	 */
-	if (!port)
-		return;
-	tg_pt_gp_mem = port->sep_alua_tg_pt_gp_mem;
-	if (!tg_pt_gp_mem)
-		return;
-
-	spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
-	tg_pt_gp = tg_pt_gp_mem->tg_pt_gp;
+	spin_lock(&lun->lun_tg_pt_gp_lock);
+	tg_pt_gp = lun->lun_tg_pt_gp;
 	if (tg_pt_gp)
 		buf[5] |= tg_pt_gp->tg_pt_gp_alua_access_type;
-	spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
+	spin_unlock(&lun->lun_tg_pt_gp_lock);
 }
 
 sense_reason_t
@@ -94,7 +87,7 @@ spc_emulate_inquiry_std(struct se_cmd *cmd, unsigned char *buf)
 	/*
 	 * Enable SCCS and TPGS fields for Emulated ALUA
 	 */
-	spc_fill_alua_data(lun->lun_sep, buf);
+	spc_fill_alua_data(lun, buf);
 
 	/*
 	 * Set Third-Party Copy (3PC) bit to indicate support for EXTENDED_COPY
@@ -181,11 +174,9 @@ spc_emulate_evpd_83(struct se_cmd *cmd, unsigned char *buf)
 {
 	struct se_device *dev = cmd->se_dev;
 	struct se_lun *lun = cmd->se_lun;
-	struct se_port *port = NULL;
 	struct se_portal_group *tpg = NULL;
 	struct t10_alua_lu_gp_member *lu_gp_mem;
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
-	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem;
 	unsigned char *prod = &dev->t10_wwn.model[0];
 	u32 prod_len;
 	u32 unit_serial_len, off = 0;
@@ -267,18 +258,15 @@ check_t10_vend_desc:
 	/* Header size for Designation descriptor */
 	len += (id_len + 4);
 	off += (id_len + 4);
-	/*
-	 * struct se_port is only set for INQUIRY VPD=1 through $FABRIC_MOD
-	 */
-	port = lun->lun_sep;
-	if (port) {
+
+	if (1) {
 		struct t10_alua_lu_gp *lu_gp;
 		u32 padding, scsi_name_len, scsi_target_len;
 		u16 lu_gp_id = 0;
 		u16 tg_pt_gp_id = 0;
 		u16 tpgt;
 
-		tpg = port->sep_tpg;
+		tpg = lun->lun_tpg;
 		/*
 		 * Relative target port identifer, see spc4r17
 		 * section 7.7.3.7
@@ -298,8 +286,8 @@ check_t10_vend_desc:
 		/* Skip over Obsolete field in RTPI payload
 		 * in Table 472 */
 		off += 2;
-		buf[off++] = ((port->sep_rtpi >> 8) & 0xff);
-		buf[off++] = (port->sep_rtpi & 0xff);
+		buf[off++] = ((lun->lun_rtpi >> 8) & 0xff);
+		buf[off++] = (lun->lun_rtpi & 0xff);
 		len += 8; /* Header size + Designation descriptor */
 		/*
 		 * Target port group identifier, see spc4r17
@@ -308,18 +296,14 @@ check_t10_vend_desc:
 		 * Get the PROTOCOL IDENTIFIER as defined by spc4r17
 		 * section 7.5.1 Table 362
 		 */
-		tg_pt_gp_mem = port->sep_alua_tg_pt_gp_mem;
-		if (!tg_pt_gp_mem)
-			goto check_lu_gp;
-
-		spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
-		tg_pt_gp = tg_pt_gp_mem->tg_pt_gp;
+		spin_lock(&lun->lun_tg_pt_gp_lock);
+		tg_pt_gp = lun->lun_tg_pt_gp;
 		if (!tg_pt_gp) {
-			spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
+			spin_unlock(&lun->lun_tg_pt_gp_lock);
 			goto check_lu_gp;
 		}
 		tg_pt_gp_id = tg_pt_gp->tg_pt_gp_id;
-		spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
+		spin_unlock(&lun->lun_tg_pt_gp_lock);
 
 		buf[off] = tpg->proto_id << 4;
 		buf[off++] |= 0x1; /* CODE SET == Binary */
@@ -694,7 +678,7 @@ static sense_reason_t
 spc_emulate_inquiry(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
-	struct se_portal_group *tpg = cmd->se_lun->lun_sep->sep_tpg;
+	struct se_portal_group *tpg = cmd->se_lun->lun_tpg;
 	unsigned char *rbuf;
 	unsigned char *cdb = cmd->t_task_cdb;
 	unsigned char *buf;
@@ -708,7 +692,7 @@ spc_emulate_inquiry(struct se_cmd *cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
-	if (dev == tpg->tpg_virt_lun0.lun_se_dev)
+	if (dev == tpg->tpg_virt_lun0->lun_se_dev)
 		buf[0] = 0x3f; /* Not connected */
 	else
 		buf[0] = dev->transport->get_device_type(dev);
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 7b7b524..5127c67 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -106,7 +106,7 @@ static ssize_t target_stat_scsi_dev_show_attr_ports(
 	struct se_device *dev =
 		container_of(sgrps, struct se_device, dev_stat_grps);
 
-	return snprintf(page, PAGE_SIZE, "%u\n", dev->dev_port_count);
+	return snprintf(page, PAGE_SIZE, "%u\n", dev->export_count);
 }
 DEV_STAT_SCSI_DEV_ATTR_RO(ports);
 
@@ -542,19 +542,13 @@ static ssize_t target_stat_scsi_port_show_attr_inst(
 	struct se_port_stat_grps *pgrps, char *page)
 {
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
-	struct se_port *sep;
-	struct se_device *dev = lun->lun_se_dev;
-	struct se_hba *hba;
-	ssize_t ret;
+	struct se_device *dev;
+	ssize_t ret = -ENODEV;
 
 	spin_lock(&lun->lun_sep_lock);
-	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
-	}
-	hba = dev->se_hba;
-	ret = snprintf(page, PAGE_SIZE, "%u\n", hba->hba_index);
+	dev = lun->lun_se_dev;
+	if (dev)
+		ret = snprintf(page, PAGE_SIZE, "%u\n", dev->se_hba->hba_index);
 	spin_unlock(&lun->lun_sep_lock);
 	return ret;
 }
@@ -564,17 +558,13 @@ static ssize_t target_stat_scsi_port_show_attr_dev(
 	struct se_port_stat_grps *pgrps, char *page)
 {
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
-	struct se_port *sep;
-	struct se_device *dev = lun->lun_se_dev;
-	ssize_t ret;
+	struct se_device *dev;
+	ssize_t ret = -ENODEV;
 
 	spin_lock(&lun->lun_sep_lock);
-	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
-	}
-	ret = snprintf(page, PAGE_SIZE, "%u\n", dev->dev_index);
+	dev = lun->lun_se_dev;
+	if (dev)
+		ret = snprintf(page, PAGE_SIZE, "%u\n", dev->dev_index);
 	spin_unlock(&lun->lun_sep_lock);
 	return ret;
 }
@@ -584,16 +574,11 @@ static ssize_t target_stat_scsi_port_show_attr_indx(
 	struct se_port_stat_grps *pgrps, char *page)
 {
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
-	struct se_port *sep;
-	ssize_t ret;
+	ssize_t ret = -ENODEV;
 
 	spin_lock(&lun->lun_sep_lock);
-	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
-	}
-	ret = snprintf(page, PAGE_SIZE, "%u\n", sep->sep_index);
+	if (lun->lun_se_dev)
+		ret = snprintf(page, PAGE_SIZE, "%u\n", lun->lun_rtpi);
 	spin_unlock(&lun->lun_sep_lock);
 	return ret;
 }
@@ -603,20 +588,15 @@ static ssize_t target_stat_scsi_port_show_attr_role(
 	struct se_port_stat_grps *pgrps, char *page)
 {
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
-	struct se_device *dev = lun->lun_se_dev;
-	struct se_port *sep;
-	ssize_t ret;
-
-	if (!dev)
-		return -ENODEV;
+	struct se_device *dev;
+	ssize_t ret = -ENODEV;
 
 	spin_lock(&lun->lun_sep_lock);
-	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
+	dev = lun->lun_se_dev;
+	if (dev) {
+		ret = snprintf(page, PAGE_SIZE, "%s%u\n", "Device",
+				dev->dev_index);
 	}
-	ret = snprintf(page, PAGE_SIZE, "%s%u\n", "Device", dev->dev_index);
 	spin_unlock(&lun->lun_sep_lock);
 	return ret;
 }
@@ -626,17 +606,13 @@ static ssize_t target_stat_scsi_port_show_attr_busy_count(
 	struct se_port_stat_grps *pgrps, char *page)
 {
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
-	struct se_port *sep;
-	ssize_t ret;
+	ssize_t ret = -ENODEV;
 
 	spin_lock(&lun->lun_sep_lock);
-	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
+	if (lun->lun_se_dev) {
+		/* FIXME: scsiPortBusyStatuses  */
+		ret = snprintf(page, PAGE_SIZE, "%u\n", 0);
 	}
-	/* FIXME: scsiPortBusyStatuses  */
-	ret = snprintf(page, PAGE_SIZE, "%u\n", 0);
 	spin_unlock(&lun->lun_sep_lock);
 	return ret;
 }
@@ -685,19 +661,13 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_inst(
 	struct se_port_stat_grps *pgrps, char *page)
 {
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
-	struct se_device *dev = lun->lun_se_dev;
-	struct se_port *sep;
-	struct se_hba *hba;
-	ssize_t ret;
+	struct se_device *dev;
+	ssize_t ret = -ENODEV;
 
 	spin_lock(&lun->lun_sep_lock);
-	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
-	}
-	hba = dev->se_hba;
-	ret = snprintf(page, PAGE_SIZE, "%u\n", hba->hba_index);
+	dev = lun->lun_se_dev;
+	if (dev)
+		ret = snprintf(page, PAGE_SIZE, "%u\n", dev->se_hba->hba_index);
 	spin_unlock(&lun->lun_sep_lock);
 	return ret;
 }
@@ -707,17 +677,13 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_dev(
 	struct se_port_stat_grps *pgrps, char *page)
 {
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
-	struct se_device *dev = lun->lun_se_dev;
-	struct se_port *sep;
-	ssize_t ret;
+	struct se_device *dev;
+	ssize_t ret = -ENODEV;
 
 	spin_lock(&lun->lun_sep_lock);
-	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
-	}
-	ret = snprintf(page, PAGE_SIZE, "%u\n", dev->dev_index);
+	dev = lun->lun_se_dev;
+	if (dev)
+		ret = snprintf(page, PAGE_SIZE, "%u\n", dev->dev_index);
 	spin_unlock(&lun->lun_sep_lock);
 	return ret;
 }
@@ -727,16 +693,11 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_indx(
 	struct se_port_stat_grps *pgrps, char *page)
 {
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
-	struct se_port *sep;
-	ssize_t ret;
+	ssize_t ret = -ENODEV;
 
 	spin_lock(&lun->lun_sep_lock);
-	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
-	}
-	ret = snprintf(page, PAGE_SIZE, "%u\n", sep->sep_index);
+	if (lun->lun_se_dev)
+		ret = snprintf(page, PAGE_SIZE, "%u\n", lun->lun_rtpi);
 	spin_unlock(&lun->lun_sep_lock);
 	return ret;
 }
@@ -746,20 +707,14 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_name(
 	struct se_port_stat_grps *pgrps, char *page)
 {
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
-	struct se_port *sep;
-	struct se_portal_group *tpg;
-	ssize_t ret;
+	ssize_t ret = -ENODEV;
 
 	spin_lock(&lun->lun_sep_lock);
-	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
+	if (lun->lun_se_dev) {
+		ret = snprintf(page, PAGE_SIZE, "%sPort#%u\n",
+			lun->lun_tpg->se_tpg_tfo->get_fabric_name(),
+			lun->lun_rtpi);
 	}
-	tpg = sep->sep_tpg;
-
-	ret = snprintf(page, PAGE_SIZE, "%sPort#%u\n",
-		tpg->se_tpg_tfo->get_fabric_name(), sep->sep_index);
 	spin_unlock(&lun->lun_sep_lock);
 	return ret;
 }
@@ -769,23 +724,11 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_port_index(
 	struct se_port_stat_grps *pgrps, char *page)
 {
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
-	struct se_port *sep;
-	struct se_portal_group *tpg;
-	ssize_t ret;
-
-	spin_lock(&lun->lun_sep_lock);
-	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
-	}
-	tpg = sep->sep_tpg;
+	struct se_portal_group *tpg = lun->lun_tpg;
 
-	ret = snprintf(page, PAGE_SIZE, "%s%s%d\n",
+	return snprintf(page, PAGE_SIZE, "%s%s%d\n",
 		tpg->se_tpg_tfo->tpg_get_wwn(tpg), "+t+",
 		tpg->se_tpg_tfo->tpg_get_tag(tpg));
-	spin_unlock(&lun->lun_sep_lock);
-	return ret;
 }
 DEV_STAT_SCSI_TGT_PORT_ATTR_RO(port_index);
 
@@ -793,18 +736,12 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_in_cmds(
 	struct se_port_stat_grps *pgrps, char *page)
 {
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
-	struct se_port *sep;
 	ssize_t ret;
 
 	spin_lock(&lun->lun_sep_lock);
-	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
-	}
-
-	ret = snprintf(page, PAGE_SIZE, "%llu\n", sep->sep_stats.cmd_pdus);
+	ret = snprintf(page, PAGE_SIZE, "%llu\n", lun->lun_stats.cmd_pdus);
 	spin_unlock(&lun->lun_sep_lock);
+
 	return ret;
 }
 DEV_STAT_SCSI_TGT_PORT_ATTR_RO(in_cmds);
@@ -813,18 +750,11 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_write_mbytes(
 	struct se_port_stat_grps *pgrps, char *page)
 {
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
-	struct se_port *sep;
 	ssize_t ret;
 
 	spin_lock(&lun->lun_sep_lock);
-	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
-	}
-
 	ret = snprintf(page, PAGE_SIZE, "%u\n",
-			(u32)(sep->sep_stats.rx_data_octets >> 20));
+			(u32)(lun->lun_stats.rx_data_octets >> 20));
 	spin_unlock(&lun->lun_sep_lock);
 	return ret;
 }
@@ -834,18 +764,11 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_read_mbytes(
 	struct se_port_stat_grps *pgrps, char *page)
 {
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
-	struct se_port *sep;
 	ssize_t ret;
 
 	spin_lock(&lun->lun_sep_lock);
-	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
-	}
-
 	ret = snprintf(page, PAGE_SIZE, "%u\n",
-			(u32)(sep->sep_stats.tx_data_octets >> 20));
+			(u32)(lun->lun_stats.tx_data_octets >> 20));
 	spin_unlock(&lun->lun_sep_lock);
 	return ret;
 }
@@ -854,21 +777,8 @@ DEV_STAT_SCSI_TGT_PORT_ATTR_RO(read_mbytes);
 static ssize_t target_stat_scsi_tgt_port_show_attr_hs_in_cmds(
 	struct se_port_stat_grps *pgrps, char *page)
 {
-	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
-	struct se_port *sep;
-	ssize_t ret;
-
-	spin_lock(&lun->lun_sep_lock);
-	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
-	}
-
 	/* FIXME: scsiTgtPortHsInCommands */
-	ret = snprintf(page, PAGE_SIZE, "%u\n", 0);
-	spin_unlock(&lun->lun_sep_lock);
-	return ret;
+	return snprintf(page, PAGE_SIZE, "%u\n", 0);
 }
 DEV_STAT_SCSI_TGT_PORT_ATTR_RO(hs_in_cmds);
 
@@ -921,20 +831,13 @@ static ssize_t target_stat_scsi_transport_show_attr_inst(
 	struct se_port_stat_grps *pgrps, char *page)
 {
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
-	struct se_device *dev = lun->lun_se_dev;
-	struct se_port *sep;
-	struct se_hba *hba;
-	ssize_t ret;
+	struct se_device *dev;
+	ssize_t ret = -ENODEV;
 
 	spin_lock(&lun->lun_sep_lock);
-	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
-	}
-
-	hba = dev->se_hba;
-	ret = snprintf(page, PAGE_SIZE, "%u\n", hba->hba_index);
+	dev = lun->lun_se_dev;
+	if (dev)
+		ret = snprintf(page, PAGE_SIZE, "%u\n", dev->se_hba->hba_index);
 	spin_unlock(&lun->lun_sep_lock);
 	return ret;
 }
@@ -944,22 +847,10 @@ static ssize_t target_stat_scsi_transport_show_attr_device(
 	struct se_port_stat_grps *pgrps, char *page)
 {
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
-	struct se_port *sep;
-	struct se_portal_group *tpg;
-	ssize_t ret;
 
-	spin_lock(&lun->lun_sep_lock);
-	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
-	}
-	tpg = sep->sep_tpg;
 	/* scsiTransportType */
-	ret = snprintf(page, PAGE_SIZE, "scsiTransport%s\n",
-			tpg->se_tpg_tfo->get_fabric_name());
-	spin_unlock(&lun->lun_sep_lock);
-	return ret;
+	return snprintf(page, PAGE_SIZE, "scsiTransport%s\n",
+				lun->lun_tpg->se_tpg_tfo->get_fabric_name());
 }
 DEV_STAT_SCSI_TRANSPORT_ATTR_RO(device);
 
@@ -967,21 +858,10 @@ static ssize_t target_stat_scsi_transport_show_attr_indx(
 	struct se_port_stat_grps *pgrps, char *page)
 {
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
-	struct se_port *sep;
-	struct se_portal_group *tpg;
-	ssize_t ret;
+	struct se_portal_group *tpg = lun->lun_tpg;
 
-	spin_lock(&lun->lun_sep_lock);
-	sep = lun->lun_sep;
-	if (!sep) {
-		spin_unlock(&lun->lun_sep_lock);
-		return -ENODEV;
-	}
-	tpg = sep->sep_tpg;
-	ret = snprintf(page, PAGE_SIZE, "%u\n",
-			tpg->se_tpg_tfo->tpg_get_inst_index(tpg));
-	spin_unlock(&lun->lun_sep_lock);
-	return ret;
+	return snprintf(page, PAGE_SIZE, "%u\n",
+				tpg->se_tpg_tfo->tpg_get_inst_index(tpg));
 }
 DEV_STAT_SCSI_TRANSPORT_ATTR_RO(indx);
 
@@ -989,19 +869,17 @@ static ssize_t target_stat_scsi_transport_show_attr_dev_name(
 	struct se_port_stat_grps *pgrps, char *page)
 {
 	struct se_lun *lun = container_of(pgrps, struct se_lun, port_stat_grps);
-	struct se_device *dev = lun->lun_se_dev;
-	struct se_port *sep;
-	struct se_portal_group *tpg;
+	struct se_portal_group *tpg = lun->lun_tpg;
+	struct se_device *dev;
 	struct t10_wwn *wwn;
 	ssize_t ret;
 
 	spin_lock(&lun->lun_sep_lock);
-	sep = lun->lun_sep;
-	if (!sep) {
+	dev = lun->lun_se_dev;
+	if (!dev) {
 		spin_unlock(&lun->lun_sep_lock);
 		return -ENODEV;
 	}
-	tpg = sep->sep_tpg;
 	wwn = &dev->t10_wwn;
 	/* scsiTransportDevName */
 	ret = snprintf(page, PAGE_SIZE, "%s+%s\n",
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index e5c45c3..1de502c 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -40,6 +40,7 @@
 #include <target/target_core_fabric.h>
 
 #include "target_core_internal.h"
+#include "target_core_alua.h"
 #include "target_core_pr.h"
 
 extern struct se_device *g_lun0_dev;
@@ -483,34 +484,14 @@ static void core_tpg_lun_ref_release(struct percpu_ref *ref)
 	complete(&lun->lun_ref_comp);
 }
 
-static int core_tpg_setup_virtual_lun0(struct se_portal_group *se_tpg)
-{
-	/* Set in core_dev_setup_virtual_lun0() */
-	struct se_device *dev = g_lun0_dev;
-	struct se_lun *lun = &se_tpg->tpg_virt_lun0;
-	u32 lun_access = TRANSPORT_LUNFLAGS_READ_ONLY;
-	int ret;
-
-	lun->unpacked_lun = 0;
-	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
-	atomic_set(&lun->lun_acl_count, 0);
-	init_completion(&lun->lun_shutdown_comp);
-	spin_lock_init(&lun->lun_sep_lock);
-	init_completion(&lun->lun_ref_comp);
-
-	ret = core_tpg_add_lun(se_tpg, lun, lun_access, dev);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
 int core_tpg_register(
 	const struct target_core_fabric_ops *tfo,
 	struct se_wwn *se_wwn,
 	struct se_portal_group *se_tpg,
 	int proto_id)
 {
+	int ret;
+
 	INIT_HLIST_HEAD(&se_tpg->tpg_lun_hlist);
 	se_tpg->proto_id = proto_id;
 	se_tpg->se_tpg_tfo = tfo;
@@ -524,8 +505,16 @@ int core_tpg_register(
 	mutex_init(&se_tpg->acl_node_mutex);
 
 	if (se_tpg->proto_id >= 0) {
-		if (core_tpg_setup_virtual_lun0(se_tpg) < 0)
-			return -ENOMEM;
+		se_tpg->tpg_virt_lun0 = core_tpg_alloc_lun(se_tpg, 0);
+		if (IS_ERR(se_tpg->tpg_virt_lun0))
+			return PTR_ERR(se_tpg->tpg_virt_lun0);
+
+		ret = core_tpg_add_lun(se_tpg, se_tpg->tpg_virt_lun0,
+				TRANSPORT_LUNFLAGS_READ_ONLY, g_lun0_dev);
+		if (ret < 0) {
+			kfree(se_tpg->tpg_virt_lun0);
+			return ret;
+		}
 	}
 
 	spin_lock_bh(&tpg_lock);
@@ -576,8 +565,10 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
 		kfree(nacl);
 	}
 
-	if (se_tpg->proto_id >= 0)
-		core_tpg_remove_lun(se_tpg, &se_tpg->tpg_virt_lun0);
+	if (se_tpg->proto_id >= 0) {
+		core_tpg_remove_lun(se_tpg, se_tpg->tpg_virt_lun0);
+		kfree_rcu(se_tpg->tpg_virt_lun0, rcu_head);
+	}
 
 	return 0;
 }
@@ -610,6 +601,15 @@ struct se_lun *core_tpg_alloc_lun(
 	init_completion(&lun->lun_shutdown_comp);
 	spin_lock_init(&lun->lun_sep_lock);
 	init_completion(&lun->lun_ref_comp);
+	INIT_LIST_HEAD(&lun->lun_deve_list);
+	INIT_LIST_HEAD(&lun->lun_dev_link);
+	atomic_set(&lun->lun_tg_pt_secondary_offline, 0);
+	spin_lock_init(&lun->lun_deve_lock);
+	mutex_init(&lun->lun_tg_pt_md_mutex);
+	INIT_LIST_HEAD(&lun->lun_tg_pt_gp_link);
+	spin_lock_init(&lun->lun_tg_pt_gp_lock);
+	atomic_set(&lun->lun_active, 0);
+	lun->lun_tpg = tpg;
 
 	return lun;
 }
@@ -625,33 +625,65 @@ int core_tpg_add_lun(
 	ret = percpu_ref_init(&lun->lun_ref, core_tpg_lun_ref_release, 0,
 			      GFP_KERNEL);
 	if (ret < 0)
-		return ret;
+		goto out;
 
-	ret = core_dev_export(dev, tpg, lun);
-	if (ret < 0) {
-		percpu_ref_exit(&lun->lun_ref);
-		return ret;
-	}
+	ret = core_alloc_rtpi(lun, dev);
+	if (ret) 
+		goto out_kill_ref;
+
+	if (dev->transport->transport_type != TRANSPORT_PLUGIN_PHBA_PDEV &&
+	    !(dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE))
+		target_attach_tg_pt_gp(lun, dev->t10_alua.default_tg_pt_gp);
 
 	mutex_lock(&tpg->tpg_lun_mutex);
+
+	spin_lock(&lun->lun_sep_lock);
+	lun->lun_se_dev = dev;
+	spin_unlock(&lun->lun_sep_lock);
+
+	spin_lock(&dev->se_port_lock);
+	dev->export_count++;
+	list_add_tail(&lun->lun_dev_link, &dev->dev_sep_list);
+	spin_unlock(&dev->se_port_lock);
+
 	lun->lun_access = lun_access;
 	lun->lun_status = TRANSPORT_LUN_STATUS_ACTIVE;
 	hlist_add_head_rcu(&lun->link, &tpg->tpg_lun_hlist);
+
 	mutex_unlock(&tpg->tpg_lun_mutex);
 
 	return 0;
+
+out_kill_ref:
+	percpu_ref_exit(&lun->lun_ref);
+out:
+	return ret;
 }
 
 void core_tpg_remove_lun(
 	struct se_portal_group *tpg,
 	struct se_lun *lun)
 {
+	struct se_device *dev = lun->lun_se_dev;
+
 	core_clear_lun_from_tpg(lun, tpg);
 	transport_clear_lun_ref(lun);
 
-	core_dev_unexport(lun->lun_se_dev, tpg, lun);
-
 	mutex_lock(&tpg->tpg_lun_mutex);
+	if (lun->lun_se_dev) {
+		while (atomic_read(&lun->lun_active))
+			cpu_relax();
+
+		target_detach_tg_pt_gp(lun);
+
+		spin_lock(&dev->se_port_lock);
+		list_del(&lun->lun_dev_link);
+		dev->export_count--;
+		spin_unlock(&dev->se_port_lock);
+
+		lun->lun_se_dev = NULL;
+	}
+
 	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
 	hlist_del_rcu(&lun->link);
 	mutex_unlock(&tpg->tpg_lun_mutex);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 645a061..fac46db 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -60,7 +60,6 @@ struct kmem_cache *t10_pr_reg_cache;
 struct kmem_cache *t10_alua_lu_gp_cache;
 struct kmem_cache *t10_alua_lu_gp_mem_cache;
 struct kmem_cache *t10_alua_tg_pt_gp_cache;
-struct kmem_cache *t10_alua_tg_pt_gp_mem_cache;
 struct kmem_cache *t10_alua_lba_map_cache;
 struct kmem_cache *t10_alua_lba_map_mem_cache;
 
@@ -119,16 +118,6 @@ int init_se_kmem_caches(void)
 				"cache failed\n");
 		goto out_free_lu_gp_mem_cache;
 	}
-	t10_alua_tg_pt_gp_mem_cache = kmem_cache_create(
-			"t10_alua_tg_pt_gp_mem_cache",
-			sizeof(struct t10_alua_tg_pt_gp_member),
-			__alignof__(struct t10_alua_tg_pt_gp_member),
-			0, NULL);
-	if (!t10_alua_tg_pt_gp_mem_cache) {
-		pr_err("kmem_cache_create() for t10_alua_tg_pt_gp_"
-				"mem_t failed\n");
-		goto out_free_tg_pt_gp_cache;
-	}
 	t10_alua_lba_map_cache = kmem_cache_create(
 			"t10_alua_lba_map_cache",
 			sizeof(struct t10_alua_lba_map),
@@ -136,7 +125,7 @@ int init_se_kmem_caches(void)
 	if (!t10_alua_lba_map_cache) {
 		pr_err("kmem_cache_create() for t10_alua_lba_map_"
 				"cache failed\n");
-		goto out_free_tg_pt_gp_mem_cache;
+		goto out_free_tg_pt_gp_cache;
 	}
 	t10_alua_lba_map_mem_cache = kmem_cache_create(
 			"t10_alua_lba_map_mem_cache",
@@ -159,8 +148,6 @@ out_free_lba_map_mem_cache:
 	kmem_cache_destroy(t10_alua_lba_map_mem_cache);
 out_free_lba_map_cache:
 	kmem_cache_destroy(t10_alua_lba_map_cache);
-out_free_tg_pt_gp_mem_cache:
-	kmem_cache_destroy(t10_alua_tg_pt_gp_mem_cache);
 out_free_tg_pt_gp_cache:
 	kmem_cache_destroy(t10_alua_tg_pt_gp_cache);
 out_free_lu_gp_mem_cache:
@@ -186,7 +173,6 @@ void release_se_kmem_caches(void)
 	kmem_cache_destroy(t10_alua_lu_gp_cache);
 	kmem_cache_destroy(t10_alua_lu_gp_mem_cache);
 	kmem_cache_destroy(t10_alua_tg_pt_gp_cache);
-	kmem_cache_destroy(t10_alua_tg_pt_gp_mem_cache);
 	kmem_cache_destroy(t10_alua_lba_map_cache);
 	kmem_cache_destroy(t10_alua_lba_map_mem_cache);
 }
@@ -1277,8 +1263,7 @@ target_setup_cmd_from_cdb(struct se_cmd *cmd, unsigned char *cdb)
 	cmd->se_cmd_flags |= SCF_SUPPORTED_SAM_OPCODE;
 
 	spin_lock(&cmd->se_lun->lun_sep_lock);
-	if (cmd->se_lun->lun_sep)
-		cmd->se_lun->lun_sep->sep_stats.cmd_pdus++;
+	cmd->se_lun->lun_stats.cmd_pdus++;
 	spin_unlock(&cmd->se_lun->lun_sep_lock);
 	return 0;
 }
@@ -2077,10 +2062,8 @@ queue_rsp:
 	switch (cmd->data_direction) {
 	case DMA_FROM_DEVICE:
 		spin_lock(&cmd->se_lun->lun_sep_lock);
-		if (cmd->se_lun->lun_sep) {
-			cmd->se_lun->lun_sep->sep_stats.tx_data_octets +=
+		cmd->se_lun->lun_stats.tx_data_octets +=
 					cmd->data_length;
-		}
 		spin_unlock(&cmd->se_lun->lun_sep_lock);
 		/*
 		 * Perform READ_STRIP of PI using software emulation when
@@ -2105,20 +2088,15 @@ queue_rsp:
 		break;
 	case DMA_TO_DEVICE:
 		spin_lock(&cmd->se_lun->lun_sep_lock);
-		if (cmd->se_lun->lun_sep) {
-			cmd->se_lun->lun_sep->sep_stats.rx_data_octets +=
-				cmd->data_length;
-		}
+		cmd->se_lun->lun_stats.rx_data_octets += cmd->data_length;
 		spin_unlock(&cmd->se_lun->lun_sep_lock);
 		/*
 		 * Check if we need to send READ payload for BIDI-COMMAND
 		 */
 		if (cmd->se_cmd_flags & SCF_BIDI) {
 			spin_lock(&cmd->se_lun->lun_sep_lock);
-			if (cmd->se_lun->lun_sep) {
-				cmd->se_lun->lun_sep->sep_stats.tx_data_octets +=
-					cmd->data_length;
-			}
+			cmd->se_lun->lun_stats.tx_data_octets +=
+				cmd->data_length;
 			spin_unlock(&cmd->se_lun->lun_sep_lock);
 			ret = cmd->se_tfo->queue_data_in(cmd);
 			if (ret == -EAGAIN || ret == -ENOMEM)
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 3556a9d..49111d3 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -348,8 +348,7 @@ struct xcopy_pt_cmd {
 	unsigned char sense_buffer[TRANSPORT_SENSE_BUFFER];
 };
 
-static struct se_port xcopy_pt_port;
-static struct se_portal_group xcopy_pt_tpg;
+struct se_portal_group xcopy_pt_tpg;
 static struct se_session xcopy_pt_sess;
 static struct se_node_acl xcopy_pt_nacl;
 
@@ -439,17 +438,11 @@ int target_xcopy_setup_pt(void)
 		return -ENOMEM;
 	}
 
-	memset(&xcopy_pt_port, 0, sizeof(struct se_port));
-	INIT_LIST_HEAD(&xcopy_pt_port.sep_alua_list);
-	INIT_LIST_HEAD(&xcopy_pt_port.sep_list);
-	mutex_init(&xcopy_pt_port.sep_tg_pt_md_mutex);
-
 	memset(&xcopy_pt_tpg, 0, sizeof(struct se_portal_group));
 	INIT_LIST_HEAD(&xcopy_pt_tpg.se_tpg_node);
 	INIT_LIST_HEAD(&xcopy_pt_tpg.acl_node_list);
 	INIT_LIST_HEAD(&xcopy_pt_tpg.tpg_sess_list);
 
-	xcopy_pt_port.sep_tpg = &xcopy_pt_tpg;
 	xcopy_pt_tpg.se_tpg_tfo = &xcopy_pt_tfo;
 
 	memset(&xcopy_pt_nacl, 0, sizeof(struct se_node_acl));
@@ -490,10 +483,6 @@ static void target_xcopy_setup_pt_port(
 		 */
 		if (remote_port) {
 			xpt_cmd->remote_port = remote_port;
-			pt_cmd->se_lun->lun_sep = &xcopy_pt_port;
-			pr_debug("Setup emulated remote DEST xcopy_pt_port: %p to"
-				" cmd->se_lun->lun_sep for X-COPY data PUSH\n",
-				pt_cmd->se_lun->lun_sep);
 		} else {
 			pt_cmd->se_lun = ec_cmd->se_lun;
 			pt_cmd->se_dev = ec_cmd->se_dev;
@@ -513,10 +502,6 @@ static void target_xcopy_setup_pt_port(
 		 */
 		if (remote_port) {
 			xpt_cmd->remote_port = remote_port;
-			pt_cmd->se_lun->lun_sep = &xcopy_pt_port;
-			pr_debug("Setup emulated remote SRC xcopy_pt_port: %p to"
-				" cmd->se_lun->lun_sep for X-COPY data PULL\n",
-				pt_cmd->se_lun->lun_sep);
 		} else {
 			pt_cmd->se_lun = ec_cmd->se_lun;
 			pt_cmd->se_dev = ec_cmd->se_dev;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 86c0c5c..83c4d62 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -310,22 +310,13 @@ struct t10_alua_tg_pt_gp {
 	struct se_device *tg_pt_gp_dev;
 	struct config_group tg_pt_gp_group;
 	struct list_head tg_pt_gp_list;
-	struct list_head tg_pt_gp_mem_list;
-	struct se_port *tg_pt_gp_alua_port;
+	struct list_head tg_pt_gp_lun_list;
+	struct se_lun *tg_pt_gp_alua_lun;
 	struct se_node_acl *tg_pt_gp_alua_nacl;
 	struct delayed_work tg_pt_gp_transition_work;
 	struct completion *tg_pt_gp_transition_complete;
 };
 
-struct t10_alua_tg_pt_gp_member {
-	bool tg_pt_gp_assoc;
-	atomic_t tg_pt_gp_mem_ref_cnt;
-	spinlock_t tg_pt_gp_mem_lock;
-	struct t10_alua_tg_pt_gp *tg_pt_gp;
-	struct se_port *tg_pt;
-	struct list_head tg_pt_gp_mem_list;
-};
-
 struct t10_vpd {
 	unsigned char device_identifier[INQUIRY_VPD_DEVICE_IDENTIFIER_LEN];
 	int protocol_identifier_set;
@@ -655,7 +646,7 @@ struct se_dev_entry {
 	spinlock_t		ua_lock;
 	struct se_lun __rcu	*se_lun;
 	unsigned long		pr_reg;
-	struct list_head	alua_port_list;
+	struct list_head	lun_link;
 	struct list_head	ua_list;
 	struct hlist_node	link;
 	struct rcu_head		rcu_head;
@@ -703,7 +694,14 @@ struct se_port_stat_grps {
 	struct config_group scsi_transport_group;
 };
 
+struct scsi_port_stats {
+       u64     cmd_pdus;
+       u64     tx_data_octets;
+       u64     rx_data_octets;
+};
+
 struct se_lun {
+	/* RELATIVE TARGET PORT IDENTIFER */
 	u16			lun_rtpi;
 #define SE_LUN_LINK_MAGIC			0xffff7771
 	u32			lun_link_magic;
@@ -716,11 +714,29 @@ struct se_lun {
 	spinlock_t		lun_sep_lock;
 	struct completion	lun_shutdown_comp;
 	struct se_device	*lun_se_dev;
-	struct se_port		*lun_sep;
+
+	struct list_head	lun_deve_list;
+	spinlock_t		lun_deve_lock;
+
+	/* ALUA state */
+	int			lun_tg_pt_secondary_stat;
+	int			lun_tg_pt_secondary_write_md;
+	atomic_t		lun_tg_pt_secondary_offline;
+	struct mutex		lun_tg_pt_md_mutex;
+
+	/* ALUA target port group linkage */
+	struct list_head	lun_tg_pt_gp_link;
+	struct t10_alua_tg_pt_gp *lun_tg_pt_gp;
+	spinlock_t		lun_tg_pt_gp_lock;
+
+	atomic_t		lun_active;
+	struct se_portal_group	*lun_tpg;
+	struct scsi_port_stats	lun_stats;
 	struct config_group	lun_group;
 	struct se_port_stat_grps port_stat_grps;
 	struct completion	lun_ref_comp;
 	struct percpu_ref	lun_ref;
+	struct list_head	lun_dev_link;
 	struct hlist_node	link;
 	struct rcu_head		rcu_head;
 };
@@ -745,7 +761,6 @@ struct se_device {
 #define DF_EMULATED_VPD_UNIT_SERIAL		0x00000004
 #define DF_USING_UDEV_PATH			0x00000008
 #define DF_USING_ALIAS				0x00000010
-	u32			dev_port_count;
 	/* Physical device queue depth */
 	u32			queue_depth;
 	/* Used for SPC-2 reservations enforce of ISIDs */
@@ -762,7 +777,7 @@ struct se_device {
 	atomic_t		dev_ordered_id;
 	atomic_t		dev_ordered_sync;
 	atomic_t		dev_qf_count;
-	int			export_count;
+	u32			export_count;
 	spinlock_t		delayed_cmd_lock;
 	spinlock_t		execute_task_lock;
 	spinlock_t		dev_reservation_lock;
@@ -829,32 +844,6 @@ struct se_hba {
 	struct target_backend	*backend;
 };
 
-struct scsi_port_stats {
-       u64     cmd_pdus;
-       u64     tx_data_octets;
-       u64     rx_data_octets;
-};
-
-struct se_port {
-	/* RELATIVE TARGET PORT IDENTIFER */
-	u16		sep_rtpi;
-	int		sep_tg_pt_secondary_stat;
-	int		sep_tg_pt_secondary_write_md;
-	u32		sep_index;
-	struct scsi_port_stats sep_stats;
-	/* Used for ALUA Target Port Groups membership */
-	atomic_t	sep_tg_pt_secondary_offline;
-	/* Used for PR ALL_TG_PT=1 */
-	atomic_t	sep_tg_pt_ref_cnt;
-	spinlock_t	sep_alua_lock;
-	struct mutex	sep_tg_pt_md_mutex;
-	struct t10_alua_tg_pt_gp_member *sep_alua_tg_pt_gp_mem;
-	struct se_lun *sep_lun;
-	struct se_portal_group *sep_tpg;
-	struct list_head sep_alua_list;
-	struct list_head sep_list;
-};
-
 struct se_tpg_np {
 	struct se_portal_group *tpg_np_parent;
 	struct config_group	tpg_np_group;
@@ -880,7 +869,7 @@ struct se_portal_group {
 	/* linked list for initiator ACL list */
 	struct list_head	acl_node_list;
 	struct hlist_head	tpg_lun_hlist;
-	struct se_lun		tpg_virt_lun0;
+	struct se_lun		*tpg_virt_lun0;
 	/* List of TCM sessions associated wth this TPG */
 	struct list_head	tpg_sess_list;
 	/* Pointer to $FABRIC_MOD dependent code */
