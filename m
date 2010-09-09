From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] tcm/alua: Cleanups for target_core_alua.c
Date: Wed,  8 Sep 2010 17:03:35 -0700
Message-ID: <1283990615-19590-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp102.sbc.mail.mud.yahoo.com ([68.142.198.201]:44153 "HELO
	smtp102.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751385Ab0IIADj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2010 20:03:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings all,

This patch contains a number of recommended cleanups to target_core_alua.c from
Konrad Rzeszutek Wilk discussed here:  http://marc.info/?l=linux-scsi&m=128398980011957&w=2

This includes the following changes:

	*) Rename core_scsi3_emulate_report_target_port_groups() -> core_emulate_report_target_port_groups()
	*) Rename core_scsi3_emulate_set_target_port_groups() -> core_emulate_set_target_port_groups()
	*) Convert 'return -1' to proper PYX_TRANSPORT in core_emulate_set_target_port_groups()
	*) Remove core_alua_state_optimized() NOP
	*) Convert CDB usage of 0xa3 -> MAINTENANCE_IN
	*) Convert CDB usage of 0xa4 -> MAINTENANCE_OUT
	*) Add proper comments and -E* return codes for core_alua_state_check()
	*) Add defines for local buffer lengths in core_alua_update_tpg_primary_metadata()
	*) Add proper -E* return codes for core_alua_do_port_transition()
	*) Add defines for local buffer lengths in core_alua_update_tpg_secondary_metadata()
	*) Convert core_alua_allocate_lu_gp() failures to return ERR_PTR()
	*) Convert a number of printks() to use the proper dmesg run level
	*) Convert core_alua_free_lu_gp(), core_alua_free_lu_gp_mem(), core_alua_free_tg_pt_gp()
	   and core_alua_free_tg_pt_gp_mem() usage of msleep(10) to cpu_relax().
	*) Convert struct t10_alua_lu_gp_member->lu_gp_assoc to bitfield
	*) Convert struct t10_alua_tg_pt_gp_member->tg_pt_gp_assoc to bitfield.

Thanks again to Konrad Rzeszutek Wilk for his comments!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_alua.c      |  129 +++++++++++++++++---------------
 drivers/target/target_core_alua.h      |   14 +++-
 drivers/target/target_core_configfs.c  |    4 +-
 drivers/target/target_core_transport.c |    4 +-
 include/target/target_core_base.h      |    4 +-
 5 files changed, 85 insertions(+), 70 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index f7ee15d..32f6fb6 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -46,14 +46,15 @@
  *
  * See spc4r17 section 6.27
  */
-int core_scsi3_emulate_report_target_port_groups(struct se_cmd *cmd)
+int core_emulate_report_target_port_groups(struct se_cmd *cmd)
 {
 	struct se_subsystem_dev *su_dev = SE_DEV(cmd)->se_sub_dev;
 	struct se_port *port;
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
 	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem;
 	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
-	u32 rd_len = 0, off = 4;
+	u32 rd_len = 0, off = 4; /* Skip over RESERVED area to first
+				    Target port group descriptor */
 
 	spin_lock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
 	list_for_each_entry(tg_pt_gp, &T10_ALUA(su_dev)->tg_pt_gps_list,
@@ -135,7 +136,7 @@ int core_scsi3_emulate_report_target_port_groups(struct se_cmd *cmd)
  *
  * See spc4r17 section 6.35
  */
-int core_scsi3_emulate_set_target_port_groups(struct se_cmd *cmd)
+int core_emulate_set_target_port_groups(struct se_cmd *cmd)
 {
 	struct se_device *dev = SE_DEV(cmd);
 	struct se_subsystem_dev *su_dev = SE_DEV(cmd)->se_sub_dev;
@@ -146,31 +147,31 @@ int core_scsi3_emulate_set_target_port_groups(struct se_cmd *cmd)
 	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
 	unsigned char *ptr = &buf[4]; /* Skip over RESERVED area in header */
 	u32 len = 4; /* Skip over RESERVED area in header */
-	int alua_access_state, primary = 0, ret;
+	int alua_access_state, primary = 0, rc;
 	u16 tg_pt_id, rtpi;
 
 	if (!(l_port))
-		return -1;
+		return PYX_TRANSPORT_LU_COMM_FAILURE;
 	/*
 	 * Determine if explict ALUA via SET_TARGET_PORT_GROUPS is allowed
 	 * for the local tg_pt_gp.
 	 */
 	l_tg_pt_gp_mem = l_port->sep_alua_tg_pt_gp_mem;
 	if (!(l_tg_pt_gp_mem)) {
-		printk(KERN_ERR "Unable to access *l_tg_pt_gp_mem\n");
+		printk(KERN_ERR "Unable to access l_port->sep_alua_tg_pt_gp_mem\n");
 		return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
 	}
 	spin_lock(&l_tg_pt_gp_mem->tg_pt_gp_mem_lock);
 	l_tg_pt_gp = l_tg_pt_gp_mem->tg_pt_gp;
 	if (!(l_tg_pt_gp)) {
 		spin_unlock(&l_tg_pt_gp_mem->tg_pt_gp_mem_lock);
-		printk(KERN_ERR "Unable to access *l_l_tg_pt_gp\n");
+		printk(KERN_ERR "Unable to access *l_tg_pt_gp_mem->tg_pt_gp\n");
 		return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
 	}
-	ret = (l_tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_EXPLICT_ALUA);
+	rc = (l_tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_EXPLICT_ALUA);
 	spin_unlock(&l_tg_pt_gp_mem->tg_pt_gp_mem_lock);
 
-	if (!(ret)) {
+	if (!(rc)) {
 		printk(KERN_INFO "Unable to process SET_TARGET_PORT_GROUPS"
 				" while TPGS_EXPLICT_ALUA is disabled\n");
 		return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
@@ -183,8 +184,8 @@ int core_scsi3_emulate_set_target_port_groups(struct se_cmd *cmd)
 		 * the state is a primary or secondary target port asymmetric
 		 * access state.
 		 */
-		ret = core_alua_check_transition(alua_access_state, &primary);
-		if (ret != 0) {
+		rc = core_alua_check_transition(alua_access_state, &primary);
+		if (rc != 0) {
 			/*
 			 * If the SET TARGET PORT GROUPS attempts to establish
 			 * an invalid combination of target port asymmetric
@@ -197,7 +198,7 @@ int core_scsi3_emulate_set_target_port_groups(struct se_cmd *cmd)
 			 */
 			return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 		}
-		ret = -1;
+		rc = -1;
 		/*
 		 * If the ASYMMETRIC ACCESS STATE field (see table 267)
 		 * specifies a primary target port asymmetric access state,
@@ -232,7 +233,7 @@ int core_scsi3_emulate_set_target_port_groups(struct se_cmd *cmd)
 				smp_mb__after_atomic_inc();
 				spin_unlock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
 
-				ret = core_alua_do_port_transition(tg_pt_gp,
+				rc = core_alua_do_port_transition(tg_pt_gp,
 						dev, l_port, nacl,
 						alua_access_state, 1);
 
@@ -246,9 +247,14 @@ int core_scsi3_emulate_set_target_port_groups(struct se_cmd *cmd)
 			 * If not matching target port group ID can be located
 			 * throw an exception with ASCQ: INVALID_PARAMETER_LIST
 			 */
-			if (ret != 0)
+			if (rc != 0)
 				return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 		} else {
+			/*
+			 * Extact the RELATIVE TARGET PORT IDENTIFIER to identify
+			 * the Target Port in question for the the incoming
+			 * SET_TARGET_PORT_GROUPS op.
+			 */
 			rtpi = ((ptr[2] << 8) & 0xff);
 			rtpi |= (ptr[3] & 0xff);
 			/*
@@ -264,7 +270,7 @@ int core_scsi3_emulate_set_target_port_groups(struct se_cmd *cmd)
 				tg_pt_gp_mem = port->sep_alua_tg_pt_gp_mem;
 				spin_unlock(&dev->se_port_lock);
 
-				ret = core_alua_set_tg_pt_secondary_state(
+				rc = core_alua_set_tg_pt_secondary_state(
 						tg_pt_gp_mem, port, 1, 1);
 
 				spin_lock(&dev->se_port_lock);
@@ -276,7 +282,7 @@ int core_scsi3_emulate_set_target_port_groups(struct se_cmd *cmd)
 			 * be located, throw an exception with ASCQ:
 			 * INVALID_PARAMETER_LIST
 			 */
-			if (ret != 0)
+			if (rc != 0)
 				return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 		}
 
@@ -287,18 +293,6 @@ int core_scsi3_emulate_set_target_port_groups(struct se_cmd *cmd)
 	return 0;
 }
 
-static inline int core_alua_state_optimized(
-	struct se_cmd *cmd,
-	unsigned char *cdb,
-	u8 *alua_ascq)
-{
-	/*
-	 * For the Optimized ALUA access state case, we want to process the
-	 * incoming fabric cmd ASAP..
-	 */
-	return 0;
-}
-
 static inline int core_alua_state_nonoptimized(
 	struct se_cmd *cmd,
 	unsigned char *cdb,
@@ -333,7 +327,7 @@ static inline int core_alua_state_standby(
 	case REPORT_LUNS:
 	case RECEIVE_DIAGNOSTIC:
 	case SEND_DIAGNOSTIC:
-	case 0xa3:
+	case MAINTENANCE_IN:
 		switch (cdb[1]) {
 		case MI_REPORT_TARGET_PGS:
 			return 0;
@@ -341,7 +335,7 @@ static inline int core_alua_state_standby(
 			*alua_ascq = ASCQ_04H_ALUA_TG_PT_STANDBY;
 			return 1;
 		}
-	case 0xa4:
+	case MAINTENANCE_OUT:
 		switch (cdb[1]) {
 		case MO_SET_TARGET_PGS:
 			return 0;
@@ -375,7 +369,7 @@ static inline int core_alua_state_unavailable(
 	switch (cdb[0]) {
 	case INQUIRY:
 	case REPORT_LUNS:
-	case 0xa3:
+	case MAINTENANCE_IN:
 		switch (cdb[1]) {
 		case MI_REPORT_TARGET_PGS:
 			return 0;
@@ -383,7 +377,7 @@ static inline int core_alua_state_unavailable(
 			*alua_ascq = ASCQ_04H_ALUA_TG_PT_UNAVAILABLE;
 			return 1;
 		}
-	case 0xa4:
+	case MAINTENANCE_OUT:
 		switch (cdb[1]) {
 		case MO_SET_TARGET_PGS:
 			return 0;
@@ -415,7 +409,7 @@ static inline int core_alua_state_transition(
 	switch (cdb[0]) {
 	case INQUIRY:
 	case REPORT_LUNS:
-	case 0xa3:
+	case MAINTENANCE_IN:
 		switch (cdb[1]) {
 		case MI_REPORT_TARGET_PGS:
 			return 0;
@@ -437,6 +431,8 @@ static inline int core_alua_state_transition(
 
 /*
  * Used for alua_type SPC_ALUA_PASSTHROUGH and SPC2_ALUA_DISABLED
+ * in transport_cmd_sequencer().  This function is assigned to
+ * struct t10_alua *->state_check() in core_setup_alua()
  */
 int core_alua_state_check_nop(
 	struct se_cmd *cmd,
@@ -447,7 +443,16 @@ int core_alua_state_check_nop(
 }
 
 /*
- * Used for alua_type SPC3_ALUA_EMULATED
+ * Used for alua_type SPC3_ALUA_EMULATED in transport_cmd_sequencer().
+ * This function is assigned to struct t10_alua *->state_check() in
+ * core_setup_alua()
+ *
+ * Also, this function can return three different return codes to
+ * signal transport_generic_cmd_sequencer()
+ *
+ * return 1: Is used to signal LUN not accecsable, and TGCS_CHECK_CONDITION_NOT_READY
+ * return 0: Used to signal success
+ * reutrn -1: Used to signal failure, and TGCS_INVALID_CDB_FIELD
  */
 int core_alua_state_check(
 	struct se_cmd *cmd,
@@ -488,9 +493,11 @@ int core_alua_state_check(
 	/*
 	 * Process ALUA_ACCESS_STATE_ACTIVE_OPTMIZED in a seperate conditional
 	 * statement so the complier knows explictly to check this case first.
+	 * For the Optimized ALUA access state case, we want to process the
+	 * incoming fabric cmd ASAP..
 	 */
 	if (out_alua_state == ALUA_ACCESS_STATE_ACTIVE_OPTMIZED)
-		return core_alua_state_optimized(cmd, cdb, alua_ascq);
+		return 0;
 
 	switch (out_alua_state) {
 	case ALUA_ACCESS_STATE_ACTIVE_NON_OPTIMIZED:
@@ -629,7 +636,7 @@ int core_alua_write_tpg_metadata(
 	if (IS_ERR(file) || !file || !file->f_dentry) {
 		printk(KERN_ERR "filp_open(%s) for ALUA metadata failed\n",
 			path);
-		return -1;
+		return -ENODEV;
 	}
 
 	iov[0].iov_base = &md_buf[0];
@@ -643,7 +650,7 @@ int core_alua_write_tpg_metadata(
 	if (ret < 0) {
 		printk(KERN_ERR "Error writing ALUA metadata file: %s\n", path);
 		filp_close(file, NULL);
-		return -1;
+		return -EIO;
 	}
 	filp_close(file, NULL);
 
@@ -660,10 +667,10 @@ int core_alua_update_tpg_primary_metadata(
 {
 	struct se_subsystem_dev *su_dev = tg_pt_gp->tg_pt_gp_su_dev;
 	struct t10_wwn *wwn = &su_dev->t10_wwn;
-	char path[512];
+	char path[ALUA_METADATA_PATH_LEN];
 	int len;
 
-	memset(path, 0, 512);
+	memset(path, 0, ALUA_METADATA_PATH_LEN);
 
 	len = snprintf(md_buf, tg_pt_gp->tg_pt_gp_md_buf_len,
 			"tg_pt_gp_id=%hu\n"
@@ -672,8 +679,8 @@ int core_alua_update_tpg_primary_metadata(
 			tg_pt_gp->tg_pt_gp_id, primary_state,
 			tg_pt_gp->tg_pt_gp_alua_access_status);
 
-	snprintf(path, 512, "/var/target/alua/tpgs_%s/%s",
-		&wwn->unit_serial[0],
+	snprintf(path, ALUA_METADATA_PATH_LEN,
+		"/var/target/alua/tpgs_%s/%s", &wwn->unit_serial[0],
 		config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item));
 
 	return core_alua_write_tpg_metadata(path, md_buf, len);
@@ -808,12 +815,12 @@ int core_alua_do_port_transition(
 	int primary;
 
 	if (core_alua_check_transition(new_state, &primary) != 0)
-		return -1;
+		return -EINVAL;
 
 	md_buf = kzalloc(l_tg_pt_gp->tg_pt_gp_md_buf_len, GFP_KERNEL);
 	if (!(md_buf)) {
 		printk("Unable to allocate buf for ALUA metadata\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	local_lu_gp_mem = l_dev->dev_alua_lu_gp_mem;
@@ -923,17 +930,17 @@ int core_alua_update_tpg_secondary_metadata(
 	u32 md_buf_len)
 {
 	struct se_portal_group *se_tpg = port->sep_tpg;
-	char path[512], wwn[1024];
+	char path[ALUA_METADATA_PATH_LEN], wwn[ALUA_SECONDARY_METADATA_WWN_LEN];
 	int len;
 
-	memset(path, 0, 512);
-	memset(wwn, 0, 1024);
+	memset(path, 0, ALUA_METADATA_PATH_LEN);
+	memset(wwn, 0, ALUA_SECONDARY_METADATA_WWN_LEN);
 
-	len = snprintf(wwn, 512, "%s",
+	len = snprintf(wwn, ALUA_SECONDARY_METADATA_WWN_LEN, "%s",
 			TPG_TFO(se_tpg)->tpg_get_wwn(se_tpg));
 
 	if (TPG_TFO(se_tpg)->tpg_get_tag != NULL)
-		snprintf(wwn+len, 1024-len, "+%hu",
+		snprintf(wwn+len, ALUA_SECONDARY_METADATA_WWN_LEN-len, "+%hu",
 				TPG_TFO(se_tpg)->tpg_get_tag(se_tpg));
 
 	len = snprintf(md_buf, md_buf_len, "alua_tg_pt_offline=%d\n"
@@ -941,7 +948,7 @@ int core_alua_update_tpg_secondary_metadata(
 			atomic_read(&port->sep_tg_pt_secondary_offline),
 			port->sep_tg_pt_secondary_stat);
 
-	snprintf(path, 512, "/var/target/alua/%s/%s/lun_%u",
+	snprintf(path, ALUA_METADATA_PATH_LEN, "/var/target/alua/%s/%s/lun_%u",
 			TPG_TFO(se_tpg)->get_fabric_name(), wwn,
 			port->sep_lun->unpacked_lun);
 
@@ -1023,7 +1030,7 @@ struct t10_alua_lu_gp *core_alua_allocate_lu_gp(const char *name, int def_group)
 	lu_gp = kmem_cache_zalloc(t10_alua_lu_gp_cache, GFP_KERNEL);
 	if (!(lu_gp)) {
 		printk(KERN_ERR "Unable to allocate struct t10_alua_lu_gp\n");
-		return NULL;
+		return ERR_PTR(-ENOMEM);;
 	}
 	INIT_LIST_HEAD(&lu_gp->lu_gp_list);
 	INIT_LIST_HEAD(&lu_gp->lu_gp_mem_list);
@@ -1047,7 +1054,7 @@ int core_alua_set_lu_gp_id(struct t10_alua_lu_gp *lu_gp, u16 lu_gp_id)
 	 * The lu_gp->lu_gp_id may only be set once..
 	 */
 	if (lu_gp->lu_gp_valid_id) {
-		printk(KERN_ERR "ALUA LU Group already has a valid ID,"
+		printk(KERN_WARNING "ALUA LU Group already has a valid ID,"
 			" ignoring request\n");
 		return -1;
 	}
@@ -1069,7 +1076,7 @@ again:
 			if (!(lu_gp_id))
 				goto again;
 
-			printk(KERN_ERR "ALUA Logical Unit Group ID: %hu"
+			printk(KERN_WARNING "ALUA Logical Unit Group ID: %hu"
 				" already exists, ignoring request\n",
 				lu_gp_id);
 			spin_unlock(&se_global->lu_gps_lock);
@@ -1128,7 +1135,7 @@ void core_alua_free_lu_gp(struct t10_alua_lu_gp *lu_gp)
 	 * released with core_alua_put_lu_gp_from_name()
 	 */
 	while (atomic_read(&lu_gp->lu_gp_ref_cnt))
-		msleep(10);
+		cpu_relax();
 	/*
 	 * Release reference to struct t10_alua_lu_gp * from all associated
 	 * struct se_device.
@@ -1181,7 +1188,7 @@ void core_alua_free_lu_gp_mem(struct se_device *dev)
 		return;
 
 	while (atomic_read(&lu_gp_mem->lu_gp_mem_ref_cnt))
-		msleep(10);
+		cpu_relax();
 
 	spin_lock(&lu_gp_mem->lu_gp_mem_lock);
 	lu_gp = lu_gp_mem->lu_gp;
@@ -1315,7 +1322,7 @@ int core_alua_set_tg_pt_gp_id(
 	 * The tg_pt_gp->tg_pt_gp_id may only be set once..
 	 */
 	if (tg_pt_gp->tg_pt_gp_valid_id) {
-		printk(KERN_ERR "ALUA TG PT Group already has a valid ID,"
+		printk(KERN_WARNING "ALUA TG PT Group already has a valid ID,"
 			" ignoring request\n");
 		return -1;
 	}
@@ -1401,7 +1408,7 @@ void core_alua_free_tg_pt_gp(
 	 * to be released with core_alua_put_tg_pt_gp_from_name().
 	 */
 	while (atomic_read(&tg_pt_gp->tg_pt_gp_ref_cnt))
-		msleep(10);
+		cpu_relax();
 	/*
 	 * Release reference to struct t10_alua_tg_pt_gp from all associated
 	 * struct se_port.
@@ -1454,7 +1461,7 @@ void core_alua_free_tg_pt_gp_mem(struct se_port *port)
 		return;
 
 	while (atomic_read(&tg_pt_gp_mem->tg_pt_gp_mem_ref_cnt))
-		msleep(10);
+		cpu_relax();
 
 	spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 	tg_pt_gp = tg_pt_gp_mem->tg_pt_gp;
@@ -1667,8 +1674,8 @@ ssize_t core_alua_store_tg_pt_gp_info(
 	 */
 	__core_alua_attach_tg_pt_gp_mem(tg_pt_gp_mem, tg_pt_gp_new);
 	spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
-	printk("Target_Core_ConfigFS: %s %s/tpgt_%hu/%s to ALUA Target Port"
-		" Group: alua/%s, ID: %hu\n", (move) ?
+	printk(KERN_INFO "Target_Core_ConfigFS: %s %s/tpgt_%hu/%s to ALUA"
+		" Target Port Group: alua/%s, ID: %hu\n", (move) ?
 		"Moving" : "Adding", TPG_TFO(tpg)->tpg_get_wwn(tpg),
 		TPG_TFO(tpg)->tpg_get_tag(tpg),
 		config_item_name(&lun->lun_group.cg_item),
@@ -1978,8 +1985,8 @@ int core_setup_alua(struct se_device *dev, int force_pt)
 	} else {
 		alua->alua_type = SPC2_ALUA_DISABLED;
 		alua->alua_state_check = &core_alua_state_check_nop;
-		printk("%s: Disabling ALUA Emulation for SPC-2 device\n",
-				TRANSPORT(dev)->name);
+		printk(KERN_INFO "%s: Disabling ALUA Emulation for SPC-2"
+			" device\n", TRANSPORT(dev)->name);
 	}
 
 	return 0;
diff --git a/drivers/target/target_core_alua.h b/drivers/target/target_core_alua.h
index 9362643..827f425 100644
--- a/drivers/target/target_core_alua.h
+++ b/drivers/target/target_core_alua.h
@@ -51,7 +51,15 @@
  */
 #define ALUA_DEFAULT_TRANS_DELAY_MSECS			0
 #define ALUA_MAX_TRANS_DELAY_MSECS			30000 /* 30 seconds */
-
+/*
+ * Used by core_alua_update_tpg_primary_metadata() and
+ * core_alua_update_tpg_secondary_metadata()
+ */
+#define ALUA_METADATA_PATH_LEN				512
+/*
+ * Used by core_alua_update_tpg_secondary_metadata()
+ */
+#define ALUA_SECONDARY_METADATA_WWN_LEN			256
 
 extern struct se_global *se_global;
 
@@ -60,8 +68,8 @@ extern struct kmem_cache *t10_alua_lu_gp_mem_cache;
 extern struct kmem_cache *t10_alua_tg_pt_gp_cache;
 extern struct kmem_cache *t10_alua_tg_pt_gp_mem_cache;
 
-extern int core_scsi3_emulate_report_target_port_groups(struct se_cmd *);
-extern int core_scsi3_emulate_set_target_port_groups(struct se_cmd *);
+extern int core_emulate_report_target_port_groups(struct se_cmd *);
+extern int core_emulate_set_target_port_groups(struct se_cmd *);
 extern int core_alua_check_transition(int, int *);
 extern int core_alua_check_nonop_delay(struct se_cmd *);
 extern int core_alua_do_transition_tg_pt(struct t10_alua_tg_pt_gp *,
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 1d5ea7d..f66ac33 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2250,7 +2250,7 @@ static struct config_group *target_core_alua_create_lu_gp(
 	struct config_item *alua_lu_gp_ci = NULL;
 
 	lu_gp = core_alua_allocate_lu_gp(name, 0);
-	if (!(lu_gp))
+	if (IS_ERR(lu_gp))
 		return NULL;
 
 	alua_lu_gp_cg = &lu_gp->lu_gp_group;
@@ -3199,7 +3199,7 @@ int target_core_init_configfs(void)
 	 * Add core/alua/lu_gps/default_lu_gp
 	 */
 	lu_gp = core_alua_allocate_lu_gp("default_lu_gp", 1);
-	if (!(lu_gp))
+	if (IS_ERR(lu_gp))
 		goto out_global;
 
 	lu_gp_cg = &se_global->alua_lu_gps_group;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index b53ca99..9e7582b 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -5447,7 +5447,7 @@ static int transport_generic_cmd_sequencer(
 				cmd->transport_emulate_cdb =
 				(T10_ALUA(su_dev)->alua_type ==
 				 SPC3_ALUA_EMULATED) ?
-				&core_scsi3_emulate_report_target_port_groups :
+				&core_emulate_report_target_port_groups :
 				NULL;
 			}
 			size = (cdb[6] << 24) | (cdb[7] << 16) |
@@ -5547,7 +5547,7 @@ static int transport_generic_cmd_sequencer(
 				cmd->transport_emulate_cdb =
 				(T10_ALUA(su_dev)->alua_type ==
 					SPC3_ALUA_EMULATED) ?
-				&core_scsi3_emulate_set_target_port_groups :
+				&core_emulate_set_target_port_groups :
 				NULL;
 			}
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 70a67e1..3c14037 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -239,7 +239,7 @@ struct t10_alua_lu_gp {
 } ____cacheline_aligned;
 
 struct t10_alua_lu_gp_member {
-	int lu_gp_assoc;
+	int lu_gp_assoc:1;
 	atomic_t lu_gp_mem_ref_cnt;
 	spinlock_t lu_gp_mem_lock;
 	struct t10_alua_lu_gp *lu_gp;
@@ -271,7 +271,7 @@ struct t10_alua_tg_pt_gp {
 } ____cacheline_aligned;
 
 struct t10_alua_tg_pt_gp_member {
-	int tg_pt_gp_assoc;
+	int tg_pt_gp_assoc:1;
 	atomic_t tg_pt_gp_mem_ref_cnt;
 	spinlock_t tg_pt_gp_mem_lock;
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
-- 
1.5.6.5

