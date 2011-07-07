From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 08/20] target: Remove custom debug macros for pr_debug. Use pr_err().
Date: Thu,  7 Jul 2011 15:33:19 -0700
Message-ID: <1310078011-15504-9-git-send-email-agrover@redhat.com>
References: <1310078011-15504-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749Ab1GGWdp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Jul 2011 18:33:45 -0400
In-Reply-To: <1310078011-15504-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

pr_debug and dynamic debug can give us the flexibility to choose
debugprints in a more standard way than these macros.

Since these debug statements were seldom enabled, there was some bitrot
in their parameters, so those are also corrected.

Use pr_err etc. macros instead of printk(KERN_ERR..).

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_alua.c            |   96 +++---
 drivers/target/target_core_cdb.c             |   39 ++--
 drivers/target/target_core_configfs.c        |  258 ++++++++--------
 drivers/target/target_core_device.c          |  168 +++++-----
 drivers/target/target_core_fabric_configfs.c |   40 ++--
 drivers/target/target_core_fabric_lib.c      |    6 +-
 drivers/target/target_core_file.c            |   66 ++---
 drivers/target/target_core_hba.c             |   10 +-
 drivers/target/target_core_iblock.c          |   87 +++---
 drivers/target/target_core_pr.c              |  264 ++++++++--------
 drivers/target/target_core_pscsi.c           |  102 +++----
 drivers/target/target_core_rd.c              |  111 +++----
 drivers/target/target_core_stgt.c            |   52 ++--
 drivers/target/target_core_tmr.c             |   39 +--
 drivers/target/target_core_tpg.c             |   42 ++--
 drivers/target/target_core_transport.c       |  427 +++++++++-----------------
 drivers/target/target_core_ua.c              |    8 +-
 17 files changed, 821 insertions(+), 994 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 3f307dd..99fac95 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -175,21 +175,21 @@ int core_emulate_set_target_port_groups(struct se_cmd *cmd)
 	 */
 	l_tg_pt_gp_mem = l_port->sep_alua_tg_pt_gp_mem;
 	if (!(l_tg_pt_gp_mem)) {
-		printk(KERN_ERR "Unable to access l_port->sep_alua_tg_pt_gp_mem\n");
+		pr_err("Unable to access l_port->sep_alua_tg_pt_gp_mem\n");
 		return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
 	}
 	spin_lock(&l_tg_pt_gp_mem->tg_pt_gp_mem_lock);
 	l_tg_pt_gp = l_tg_pt_gp_mem->tg_pt_gp;
 	if (!(l_tg_pt_gp)) {
 		spin_unlock(&l_tg_pt_gp_mem->tg_pt_gp_mem_lock);
-		printk(KERN_ERR "Unable to access *l_tg_pt_gp_mem->tg_pt_gp\n");
+		pr_err("Unable to access *l_tg_pt_gp_mem->tg_pt_gp\n");
 		return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
 	}
 	rc = (l_tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_EXPLICT_ALUA);
 	spin_unlock(&l_tg_pt_gp_mem->tg_pt_gp_mem_lock);
 
 	if (!(rc)) {
-		printk(KERN_INFO "Unable to process SET_TARGET_PORT_GROUPS"
+		pr_debug("Unable to process SET_TARGET_PORT_GROUPS"
 				" while TPGS_EXPLICT_ALUA is disabled\n");
 		return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
 	}
@@ -500,7 +500,7 @@ static int core_alua_state_check(
 	 */
 	if (atomic_read(&port->sep_tg_pt_secondary_offline)) {
 		*alua_ascq = ASCQ_04H_ALUA_OFFLINE;
-		printk(KERN_INFO "ALUA: Got secondary offline status for local"
+		pr_debug("ALUA: Got secondary offline status for local"
 				" target port\n");
 		*alua_ascq = ASCQ_04H_ALUA_OFFLINE;
 		return 1;
@@ -542,7 +542,7 @@ static int core_alua_state_check(
 	 */
 	case ALUA_ACCESS_STATE_OFFLINE:
 	default:
-		printk(KERN_ERR "Unknown ALUA access state: 0x%02x\n",
+		pr_err("Unknown ALUA access state: 0x%02x\n",
 				out_alua_state);
 		return -EINVAL;
 	}
@@ -574,7 +574,7 @@ static int core_alua_check_transition(int state, int *primary)
 		*primary = 0;
 		break;
 	default:
-		printk(KERN_ERR "Unknown ALUA access state: 0x%02x\n", state);
+		pr_err("Unknown ALUA access state: 0x%02x\n", state);
 		return -EINVAL;
 	}
 
@@ -661,7 +661,7 @@ static int core_alua_write_tpg_metadata(
 
 	file = filp_open(path, flags, 0600);
 	if (IS_ERR(file) || !file || !file->f_dentry) {
-		printk(KERN_ERR "filp_open(%s) for ALUA metadata failed\n",
+		pr_err("filp_open(%s) for ALUA metadata failed\n",
 			path);
 		return -ENODEV;
 	}
@@ -675,7 +675,7 @@ static int core_alua_write_tpg_metadata(
 	set_fs(old_fs);
 
 	if (ret < 0) {
-		printk(KERN_ERR "Error writing ALUA metadata file: %s\n", path);
+		pr_err("Error writing ALUA metadata file: %s\n", path);
 		filp_close(file, NULL);
 		return -EIO;
 	}
@@ -814,7 +814,7 @@ static int core_alua_do_transition_tg_pt(
 	 */
 	atomic_set(&tg_pt_gp->tg_pt_gp_alua_access_state, new_state);
 
-	printk(KERN_INFO "Successful %s ALUA transition TG PT Group: %s ID: %hu"
+	pr_debug("Successful %s ALUA transition TG PT Group: %s ID: %hu"
 		" from primary access state %s to %s\n", (explict) ? "explict" :
 		"implict", config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item),
 		tg_pt_gp->tg_pt_gp_id, core_alua_dump_state(old_state),
@@ -846,7 +846,7 @@ int core_alua_do_port_transition(
 
 	md_buf = kzalloc(l_tg_pt_gp->tg_pt_gp_md_buf_len, GFP_KERNEL);
 	if (!(md_buf)) {
-		printk("Unable to allocate buf for ALUA metadata\n");
+		pr_err("Unable to allocate buf for ALUA metadata\n");
 		return -ENOMEM;
 	}
 
@@ -935,7 +935,7 @@ int core_alua_do_port_transition(
 	}
 	spin_unlock(&lu_gp->lu_gp_lock);
 
-	printk(KERN_INFO "Successfully processed LU Group: %s all ALUA TG PT"
+	pr_debug("Successfully processed LU Group: %s all ALUA TG PT"
 		" Group IDs: %hu %s transition to primary state: %s\n",
 		config_item_name(&lu_gp->lu_gp_group.cg_item),
 		l_tg_pt_gp->tg_pt_gp_id, (explict) ? "explict" : "implict",
@@ -997,7 +997,7 @@ static int core_alua_set_tg_pt_secondary_state(
 	tg_pt_gp = tg_pt_gp_mem->tg_pt_gp;
 	if (!(tg_pt_gp)) {
 		spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
-		printk(KERN_ERR "Unable to complete secondary state"
+		pr_err("Unable to complete secondary state"
 				" transition\n");
 		return -EINVAL;
 	}
@@ -1016,7 +1016,7 @@ static int core_alua_set_tg_pt_secondary_state(
 			ALUA_STATUS_ALTERED_BY_EXPLICT_STPG :
 			ALUA_STATUS_ALTERED_BY_IMPLICT_ALUA;
 
-	printk(KERN_INFO "Successful %s ALUA transition TG PT Group: %s ID: %hu"
+	pr_debug("Successful %s ALUA transition TG PT Group: %s ID: %hu"
 		" to secondary access state: %s\n", (explict) ? "explict" :
 		"implict", config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item),
 		tg_pt_gp->tg_pt_gp_id, (offline) ? "OFFLINE" : "ONLINE");
@@ -1035,7 +1035,7 @@ static int core_alua_set_tg_pt_secondary_state(
 	if (port->sep_tg_pt_secondary_write_md) {
 		md_buf = kzalloc(md_buf_len, GFP_KERNEL);
 		if (!(md_buf)) {
-			printk(KERN_ERR "Unable to allocate md_buf for"
+			pr_err("Unable to allocate md_buf for"
 				" secondary ALUA access metadata\n");
 			return -ENOMEM;
 		}
@@ -1057,7 +1057,7 @@ core_alua_allocate_lu_gp(const char *name, int def_group)
 
 	lu_gp = kmem_cache_zalloc(t10_alua_lu_gp_cache, GFP_KERNEL);
 	if (!(lu_gp)) {
-		printk(KERN_ERR "Unable to allocate struct t10_alua_lu_gp\n");
+		pr_err("Unable to allocate struct t10_alua_lu_gp\n");
 		return ERR_PTR(-ENOMEM);
 	}
 	INIT_LIST_HEAD(&lu_gp->lu_gp_node);
@@ -1082,14 +1082,14 @@ int core_alua_set_lu_gp_id(struct t10_alua_lu_gp *lu_gp, u16 lu_gp_id)
 	 * The lu_gp->lu_gp_id may only be set once..
 	 */
 	if (lu_gp->lu_gp_valid_id) {
-		printk(KERN_WARNING "ALUA LU Group already has a valid ID,"
+		pr_warn("ALUA LU Group already has a valid ID,"
 			" ignoring request\n");
 		return -EINVAL;
 	}
 
 	spin_lock(&lu_gps_lock);
 	if (alua_lu_gps_count == 0x0000ffff) {
-		printk(KERN_ERR "Maximum ALUA alua_lu_gps_count:"
+		pr_err("Maximum ALUA alua_lu_gps_count:"
 				" 0x0000ffff reached\n");
 		spin_unlock(&lu_gps_lock);
 		kmem_cache_free(t10_alua_lu_gp_cache, lu_gp);
@@ -1104,7 +1104,7 @@ again:
 			if (!(lu_gp_id))
 				goto again;
 
-			printk(KERN_WARNING "ALUA Logical Unit Group ID: %hu"
+			pr_warn("ALUA Logical Unit Group ID: %hu"
 				" already exists, ignoring request\n",
 				lu_gp_id);
 			spin_unlock(&lu_gps_lock);
@@ -1128,7 +1128,7 @@ core_alua_allocate_lu_gp_mem(struct se_device *dev)
 
 	lu_gp_mem = kmem_cache_zalloc(t10_alua_lu_gp_mem_cache, GFP_KERNEL);
 	if (!(lu_gp_mem)) {
-		printk(KERN_ERR "Unable to allocate struct t10_alua_lu_gp_member\n");
+		pr_err("Unable to allocate struct t10_alua_lu_gp_member\n");
 		return ERR_PTR(-ENOMEM);
 	}
 	INIT_LIST_HEAD(&lu_gp_mem->lu_gp_mem_list);
@@ -1302,7 +1302,7 @@ struct t10_alua_tg_pt_gp *core_alua_allocate_tg_pt_gp(
 
 	tg_pt_gp = kmem_cache_zalloc(t10_alua_tg_pt_gp_cache, GFP_KERNEL);
 	if (!(tg_pt_gp)) {
-		printk(KERN_ERR "Unable to allocate struct t10_alua_tg_pt_gp\n");
+		pr_err("Unable to allocate struct t10_alua_tg_pt_gp\n");
 		return NULL;
 	}
 	INIT_LIST_HEAD(&tg_pt_gp->tg_pt_gp_list);
@@ -1350,14 +1350,14 @@ int core_alua_set_tg_pt_gp_id(
 	 * The tg_pt_gp->tg_pt_gp_id may only be set once..
 	 */
 	if (tg_pt_gp->tg_pt_gp_valid_id) {
-		printk(KERN_WARNING "ALUA TG PT Group already has a valid ID,"
+		pr_warn("ALUA TG PT Group already has a valid ID,"
 			" ignoring request\n");
 		return -EINVAL;
 	}
 
 	spin_lock(&su_dev->t10_alua.tg_pt_gps_lock);
 	if (su_dev->t10_alua.alua_tg_pt_gps_count == 0x0000ffff) {
-		printk(KERN_ERR "Maximum ALUA alua_tg_pt_gps_count:"
+		pr_err("Maximum ALUA alua_tg_pt_gps_count:"
 			" 0x0000ffff reached\n");
 		spin_unlock(&su_dev->t10_alua.tg_pt_gps_lock);
 		kmem_cache_free(t10_alua_tg_pt_gp_cache, tg_pt_gp);
@@ -1373,7 +1373,7 @@ again:
 			if (!(tg_pt_gp_id))
 				goto again;
 
-			printk(KERN_ERR "ALUA Target Port Group ID: %hu already"
+			pr_err("ALUA Target Port Group ID: %hu already"
 				" exists, ignoring request\n", tg_pt_gp_id);
 			spin_unlock(&su_dev->t10_alua.tg_pt_gps_lock);
 			return -EINVAL;
@@ -1398,7 +1398,7 @@ struct t10_alua_tg_pt_gp_member *core_alua_allocate_tg_pt_gp_mem(
 	tg_pt_gp_mem = kmem_cache_zalloc(t10_alua_tg_pt_gp_mem_cache,
 				GFP_KERNEL);
 	if (!(tg_pt_gp_mem)) {
-		printk(KERN_ERR "Unable to allocate struct t10_alua_tg_pt_gp_member\n");
+		pr_err("Unable to allocate struct t10_alua_tg_pt_gp_member\n");
 		return ERR_PTR(-ENOMEM);
 	}
 	INIT_LIST_HEAD(&tg_pt_gp_mem->tg_pt_gp_mem_list);
@@ -1628,7 +1628,7 @@ ssize_t core_alua_store_tg_pt_gp_info(
 	lun = port->sep_lun;
 
 	if (su_dev->t10_alua.alua_type != SPC3_ALUA_EMULATED) {
-		printk(KERN_WARNING "SPC3_ALUA_EMULATED not enabled for"
+		pr_warn("SPC3_ALUA_EMULATED not enabled for"
 			" %s/tpgt_%hu/%s\n", tpg->se_tpg_tfo->tpg_get_wwn(tpg),
 			tpg->se_tpg_tfo->tpg_get_tag(tpg),
 			config_item_name(&lun->lun_group.cg_item));
@@ -1636,7 +1636,7 @@ ssize_t core_alua_store_tg_pt_gp_info(
 	}
 
 	if (count > TG_PT_GROUP_NAME_BUF) {
-		printk(KERN_ERR "ALUA Target Port Group alias too large!\n");
+		pr_err("ALUA Target Port Group alias too large!\n");
 		return -EINVAL;
 	}
 	memset(buf, 0, TG_PT_GROUP_NAME_BUF);
@@ -1660,7 +1660,7 @@ ssize_t core_alua_store_tg_pt_gp_info(
 	if (!(tg_pt_gp_mem)) {
 		if (tg_pt_gp_new)
 			core_alua_put_tg_pt_gp_from_name(tg_pt_gp_new);
-		printk(KERN_ERR "NULL struct se_port->sep_alua_tg_pt_gp_mem pointer\n");
+		pr_err("NULL struct se_port->sep_alua_tg_pt_gp_mem pointer\n");
 		return -EINVAL;
 	}
 
@@ -1672,7 +1672,7 @@ ssize_t core_alua_store_tg_pt_gp_info(
 		 * with the default_tg_pt_gp.
 		 */
 		if (!(tg_pt_gp_new)) {
-			printk(KERN_INFO "Target_Core_ConfigFS: Moving"
+			pr_debug("Target_Core_ConfigFS: Moving"
 				" %s/tpgt_%hu/%s from ALUA Target Port Group:"
 				" alua/%s, ID: %hu back to"
 				" default_tg_pt_gp\n",
@@ -1701,7 +1701,7 @@ ssize_t core_alua_store_tg_pt_gp_info(
 	 */
 	__core_alua_attach_tg_pt_gp_mem(tg_pt_gp_mem, tg_pt_gp_new);
 	spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
-	printk(KERN_INFO "Target_Core_ConfigFS: %s %s/tpgt_%hu/%s to ALUA"
+	pr_debug("Target_Core_ConfigFS: %s %s/tpgt_%hu/%s to ALUA"
 		" Target Port Group: alua/%s, ID: %hu\n", (move) ?
 		"Moving" : "Adding", tpg->se_tpg_tfo->tpg_get_wwn(tpg),
 		tpg->se_tpg_tfo->tpg_get_tag(tpg),
@@ -1738,11 +1738,11 @@ ssize_t core_alua_store_access_type(
 
 	ret = strict_strtoul(page, 0, &tmp);
 	if (ret < 0) {
-		printk(KERN_ERR "Unable to extract alua_access_type\n");
+		pr_err("Unable to extract alua_access_type\n");
 		return -EINVAL;
 	}
 	if ((tmp != 0) && (tmp != 1) && (tmp != 2) && (tmp != 3)) {
-		printk(KERN_ERR "Illegal value for alua_access_type:"
+		pr_err("Illegal value for alua_access_type:"
 				" %lu\n", tmp);
 		return -EINVAL;
 	}
@@ -1776,11 +1776,11 @@ ssize_t core_alua_store_nonop_delay_msecs(
 
 	ret = strict_strtoul(page, 0, &tmp);
 	if (ret < 0) {
-		printk(KERN_ERR "Unable to extract nonop_delay_msecs\n");
+		pr_err("Unable to extract nonop_delay_msecs\n");
 		return -EINVAL;
 	}
 	if (tmp > ALUA_MAX_NONOP_DELAY_MSECS) {
-		printk(KERN_ERR "Passed nonop_delay_msecs: %lu, exceeds"
+		pr_err("Passed nonop_delay_msecs: %lu, exceeds"
 			" ALUA_MAX_NONOP_DELAY_MSECS: %d\n", tmp,
 			ALUA_MAX_NONOP_DELAY_MSECS);
 		return -EINVAL;
@@ -1807,11 +1807,11 @@ ssize_t core_alua_store_trans_delay_msecs(
 
 	ret = strict_strtoul(page, 0, &tmp);
 	if (ret < 0) {
-		printk(KERN_ERR "Unable to extract trans_delay_msecs\n");
+		pr_err("Unable to extract trans_delay_msecs\n");
 		return -EINVAL;
 	}
 	if (tmp > ALUA_MAX_TRANS_DELAY_MSECS) {
-		printk(KERN_ERR "Passed trans_delay_msecs: %lu, exceeds"
+		pr_err("Passed trans_delay_msecs: %lu, exceeds"
 			" ALUA_MAX_TRANS_DELAY_MSECS: %d\n", tmp,
 			ALUA_MAX_TRANS_DELAY_MSECS);
 		return -EINVAL;
@@ -1838,11 +1838,11 @@ ssize_t core_alua_store_preferred_bit(
 
 	ret = strict_strtoul(page, 0, &tmp);
 	if (ret < 0) {
-		printk(KERN_ERR "Unable to extract preferred ALUA value\n");
+		pr_err("Unable to extract preferred ALUA value\n");
 		return -EINVAL;
 	}
 	if ((tmp != 0) && (tmp != 1)) {
-		printk(KERN_ERR "Illegal value for preferred ALUA: %lu\n", tmp);
+		pr_err("Illegal value for preferred ALUA: %lu\n", tmp);
 		return -EINVAL;
 	}
 	tg_pt_gp->tg_pt_gp_pref = (int)tmp;
@@ -1873,17 +1873,17 @@ ssize_t core_alua_store_offline_bit(
 
 	ret = strict_strtoul(page, 0, &tmp);
 	if (ret < 0) {
-		printk(KERN_ERR "Unable to extract alua_tg_pt_offline value\n");
+		pr_err("Unable to extract alua_tg_pt_offline value\n");
 		return -EINVAL;
 	}
 	if ((tmp != 0) && (tmp != 1)) {
-		printk(KERN_ERR "Illegal value for alua_tg_pt_offline: %lu\n",
+		pr_err("Illegal value for alua_tg_pt_offline: %lu\n",
 				tmp);
 		return -EINVAL;
 	}
 	tg_pt_gp_mem = lun->lun_sep->sep_alua_tg_pt_gp_mem;
 	if (!(tg_pt_gp_mem)) {
-		printk(KERN_ERR "Unable to locate *tg_pt_gp_mem\n");
+		pr_err("Unable to locate *tg_pt_gp_mem\n");
 		return -EINVAL;
 	}
 
@@ -1912,13 +1912,13 @@ ssize_t core_alua_store_secondary_status(
 
 	ret = strict_strtoul(page, 0, &tmp);
 	if (ret < 0) {
-		printk(KERN_ERR "Unable to extract alua_tg_pt_status\n");
+		pr_err("Unable to extract alua_tg_pt_status\n");
 		return -EINVAL;
 	}
 	if ((tmp != ALUA_STATUS_NONE) &&
 	    (tmp != ALUA_STATUS_ALTERED_BY_EXPLICT_STPG) &&
 	    (tmp != ALUA_STATUS_ALTERED_BY_IMPLICT_ALUA)) {
-		printk(KERN_ERR "Illegal value for alua_tg_pt_status: %lu\n",
+		pr_err("Illegal value for alua_tg_pt_status: %lu\n",
 				tmp);
 		return -EINVAL;
 	}
@@ -1945,11 +1945,11 @@ ssize_t core_alua_store_secondary_write_metadata(
 
 	ret = strict_strtoul(page, 0, &tmp);
 	if (ret < 0) {
-		printk(KERN_ERR "Unable to extract alua_tg_pt_write_md\n");
+		pr_err("Unable to extract alua_tg_pt_write_md\n");
 		return -EINVAL;
 	}
 	if ((tmp != 0) && (tmp != 1)) {
-		printk(KERN_ERR "Illegal value for alua_tg_pt_write_md:"
+		pr_err("Illegal value for alua_tg_pt_write_md:"
 				" %lu\n", tmp);
 		return -EINVAL;
 	}
@@ -1973,7 +1973,7 @@ int core_setup_alua(struct se_device *dev, int force_pt)
 	    !(dev->se_sub_dev->se_dev_attrib.emulate_alua)) || force_pt) {
 		alua->alua_type = SPC_ALUA_PASSTHROUGH;
 		alua->alua_state_check = &core_alua_state_check_nop;
-		printk(KERN_INFO "%s: Using SPC_ALUA_PASSTHROUGH, no ALUA"
+		pr_debug("%s: Using SPC_ALUA_PASSTHROUGH, no ALUA"
 			" emulation\n", dev->transport->name);
 		return 0;
 	}
@@ -1982,7 +1982,7 @@ int core_setup_alua(struct se_device *dev, int force_pt)
 	 * use emulated ALUA.
 	 */
 	if (dev->transport->get_device_rev(dev) >= SCSI_3) {
-		printk(KERN_INFO "%s: Enabling ALUA Emulation for SPC-3"
+		pr_debug("%s: Enabling ALUA Emulation for SPC-3"
 			" device\n", dev->transport->name);
 		/*
 		 * Associate this struct se_device with the default ALUA
@@ -1999,13 +1999,13 @@ int core_setup_alua(struct se_device *dev, int force_pt)
 				default_lu_gp);
 		spin_unlock(&lu_gp_mem->lu_gp_mem_lock);
 
-		printk(KERN_INFO "%s: Adding to default ALUA LU Group:"
+		pr_debug("%s: Adding to default ALUA LU Group:"
 			" core/alua/lu_gps/default_lu_gp\n",
 			dev->transport->name);
 	} else {
 		alua->alua_type = SPC2_ALUA_DISABLED;
 		alua->alua_state_check = &core_alua_state_check_nop;
-		printk(KERN_INFO "%s: Disabling ALUA Emulation for SPC-2"
+		pr_debug("%s: Disabling ALUA Emulation for SPC-2"
 			" device\n", dev->transport->name);
 	}
 
diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
index 6c9e53f..9511a9e 100644
--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -73,7 +73,7 @@ target_emulate_inquiry_std(struct se_cmd *cmd)
 	 * payload going back for EVPD=0
 	 */
 	if (cmd->data_length < 6) {
-		printk(KERN_ERR "SCSI Inquiry payload length: %u"
+		pr_err("SCSI Inquiry payload length: %u"
 			" too small for EVPD=0\n", cmd->data_length);
 		return -EINVAL;
 	}
@@ -503,14 +503,14 @@ target_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 		have_tp = 1;
 
 	if (cmd->data_length < (0x10 + 4)) {
-		printk(KERN_INFO "Received data_length: %u"
+		pr_debug("Received data_length: %u"
 			" too small for EVPD 0xb0\n",
 			cmd->data_length);
 		return -EINVAL;
 	}
 
 	if (have_tp && cmd->data_length < (0x3c + 4)) {
-		printk(KERN_INFO "Received data_length: %u"
+		pr_debug("Received data_length: %u"
 			" too small for TPE=1 EVPD 0xb0\n",
 			cmd->data_length);
 		have_tp = 0;
@@ -640,7 +640,7 @@ target_emulate_inquiry(struct se_cmd *cmd)
 	 * payload length left for the next outgoing EVPD metadata
 	 */
 	if (cmd->data_length < 4) {
-		printk(KERN_ERR "SCSI Inquiry payload length: %u"
+		pr_err("SCSI Inquiry payload length: %u"
 			" too small for EVPD=1\n", cmd->data_length);
 		return -EINVAL;
 	}
@@ -663,7 +663,7 @@ target_emulate_inquiry(struct se_cmd *cmd)
 	case 0xb2:
 		return target_emulate_evpd_b2(cmd, buf);
 	default:
-		printk(KERN_ERR "Unknown VPD Code: 0x%02x\n", cdb[2]);
+		pr_err("Unknown VPD Code: 0x%02x\n", cdb[2]);
 		transport_kunmap_first_data_page(cmd);
 		return -EINVAL;
 	}
@@ -875,7 +875,7 @@ target_emulate_modesense(struct se_cmd *cmd, int ten)
 		length += target_modesense_control(dev, &buf[offset+length]);
 		break;
 	default:
-		printk(KERN_ERR "Got Unknown Mode Page: 0x%02x\n",
+		pr_err("Got Unknown Mode Page: 0x%02x\n",
 				cdb[2] & 0x3f);
 		return PYX_TRANSPORT_UNKNOWN_MODE_PAGE;
 	}
@@ -930,7 +930,7 @@ target_emulate_request_sense(struct se_cmd *cmd)
 	u8 ua_asc = 0, ua_ascq = 0;
 
 	if (cdb[1] & 0x01) {
-		printk(KERN_ERR "REQUEST_SENSE description emulation not"
+		pr_err("REQUEST_SENSE description emulation not"
 			" supported\n");
 		return PYX_TRANSPORT_INVALID_CDB_FIELD;
 	}
@@ -1010,18 +1010,18 @@ target_emulate_unmap(struct se_task *task)
 	buf = transport_kmap_first_data_page(cmd);
 
 	ptr = &buf[offset];
-	printk(KERN_INFO "UNMAP: Sub: %s Using dl: %hu bd_dl: %hu size: %hu"
+	pr_debug("UNMAP: Sub: %s Using dl: %hu bd_dl: %hu size: %hu"
 		" ptr: %p\n", dev->transport->name, dl, bd_dl, size, ptr);
 
 	while (size) {
 		lba = get_unaligned_be64(&ptr[0]);
 		range = get_unaligned_be32(&ptr[8]);
-		printk(KERN_INFO "UNMAP: Using lba: %llu and range: %u\n",
+		pr_debug("UNMAP: Using lba: %llu and range: %u\n",
 				 (unsigned long long)lba, range);
 
 		ret = dev->transport->do_discard(dev, lba, range);
 		if (ret < 0) {
-			printk(KERN_ERR "blkdev_issue_discard() failed: %d\n",
+			pr_err("blkdev_issue_discard() failed: %d\n",
 					ret);
 			transport_kunmap_first_data_page(cmd);
 			return ret;
@@ -1066,12 +1066,12 @@ target_emulate_write_same(struct se_task *task, int write_same32)
 	else
 		range = (dev->transport->get_blocks(dev) - lba);
 
-	printk(KERN_INFO "WRITE_SAME UNMAP: LBA: %llu Range: %llu\n",
+	pr_debug("WRITE_SAME UNMAP: LBA: %llu Range: %llu\n",
 		 (unsigned long long)lba, (unsigned long long)range);
 
 	ret = dev->transport->do_discard(dev, lba, range);
 	if (ret < 0) {
-		printk(KERN_INFO "blkdev_issue_discard() failed for WRITE_SAME\n");
+		pr_debug("blkdev_issue_discard() failed for WRITE_SAME\n");
 		return ret;
 	}
 
@@ -1107,7 +1107,7 @@ transport_emulate_control_cdb(struct se_task *task)
 			ret = target_emulate_readcapacity_16(cmd);
 			break;
 		default:
-			printk(KERN_ERR "Unsupported SA: 0x%02x\n",
+			pr_err("Unsupported SA: 0x%02x\n",
 				cmd->t_task_cdb[1] & 0x1f);
 			return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
 		}
@@ -1117,7 +1117,7 @@ transport_emulate_control_cdb(struct se_task *task)
 		break;
 	case UNMAP:
 		if (!dev->transport->do_discard) {
-			printk(KERN_ERR "UNMAP emulation not supported for: %s\n",
+			pr_err("UNMAP emulation not supported for: %s\n",
 					dev->transport->name);
 			return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
 		}
@@ -1125,7 +1125,7 @@ transport_emulate_control_cdb(struct se_task *task)
 		break;
 	case WRITE_SAME_16:
 		if (!dev->transport->do_discard) {
-			printk(KERN_ERR "WRITE_SAME_16 emulation not supported"
+			pr_err("WRITE_SAME_16 emulation not supported"
 					" for: %s\n", dev->transport->name);
 			return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
 		}
@@ -1137,7 +1137,7 @@ transport_emulate_control_cdb(struct se_task *task)
 		switch (service_action) {
 		case WRITE_SAME_32:
 			if (!dev->transport->do_discard) {
-				printk(KERN_ERR "WRITE_SAME_32 SA emulation not"
+				pr_err("WRITE_SAME_32 SA emulation not"
 					" supported for: %s\n",
 					dev->transport->name);
 				return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
@@ -1145,7 +1145,7 @@ transport_emulate_control_cdb(struct se_task *task)
 			ret = target_emulate_write_same(task, 1);
 			break;
 		default:
-			printk(KERN_ERR "Unsupported VARIABLE_LENGTH_CMD SA:"
+			pr_err("Unsupported VARIABLE_LENGTH_CMD SA:"
 					" 0x%02x\n", service_action);
 			break;
 		}
@@ -1153,8 +1153,7 @@ transport_emulate_control_cdb(struct se_task *task)
 	case SYNCHRONIZE_CACHE:
 	case 0x91: /* SYNCHRONIZE_CACHE_16: */
 		if (!dev->transport->do_sync_cache) {
-			printk(KERN_ERR
-				"SYNCHRONIZE_CACHE emulation not supported"
+			pr_err("SYNCHRONIZE_CACHE emulation not supported"
 				" for: %s\n", dev->transport->name);
 			return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
 		}
@@ -1171,7 +1170,7 @@ transport_emulate_control_cdb(struct se_task *task)
 	case WRITE_FILEMARKS:
 		break;
 	default:
-		printk(KERN_ERR "Unsupported SCSI Opcode: 0x%02x for %s\n",
+		pr_err("Unsupported SCSI Opcode: 0x%02x for %s\n",
 			cmd->t_task_cdb[0], dev->transport->name);
 		return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
 	}
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 66603e1..bfabfd0 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -130,7 +130,7 @@ static struct config_group *target_core_register_fabric(
 	struct target_fabric_configfs *tf;
 	int ret;
 
-	printk(KERN_INFO "Target_Core_ConfigFS: REGISTER -> group: %p name:"
+	pr_debug("Target_Core_ConfigFS: REGISTER -> group: %p name:"
 			" %s\n", group, name);
 	/*
 	 * Ensure that TCM subsystem plugins are loaded at this point for
@@ -159,7 +159,7 @@ static struct config_group *target_core_register_fabric(
 		 */
 		ret = request_module("iscsi_target_mod");
 		if (ret < 0) {
-			printk(KERN_ERR "request_module() failed for"
+			pr_err("request_module() failed for"
 				" iscsi_target_mod.ko: %d\n", ret);
 			return ERR_PTR(-EINVAL);
 		}
@@ -172,7 +172,7 @@ static struct config_group *target_core_register_fabric(
 		 */
 		ret = request_module("tcm_loop");
 		if (ret < 0) {
-			printk(KERN_ERR "request_module() failed for"
+			pr_err("request_module() failed for"
 				" tcm_loop.ko: %d\n", ret);
 			return ERR_PTR(-EINVAL);
 		}
@@ -180,17 +180,17 @@ static struct config_group *target_core_register_fabric(
 
 	tf = target_core_get_fabric(name);
 	if (!(tf)) {
-		printk(KERN_ERR "target_core_get_fabric() failed for %s\n",
+		pr_err("target_core_get_fabric() failed for %s\n",
 			name);
 		return ERR_PTR(-EINVAL);
 	}
-	printk(KERN_INFO "Target_Core_ConfigFS: REGISTER -> Located fabric:"
+	pr_debug("Target_Core_ConfigFS: REGISTER -> Located fabric:"
 			" %s\n", tf->tf_name);
 	/*
 	 * On a successful target_core_get_fabric() look, the returned
 	 * struct target_fabric_configfs *tf will contain a usage reference.
 	 */
-	printk(KERN_INFO "Target_Core_ConfigFS: REGISTER tfc_wwn_cit -> %p\n",
+	pr_debug("Target_Core_ConfigFS: REGISTER tfc_wwn_cit -> %p\n",
 			&TF_CIT_TMPL(tf)->tfc_wwn_cit);
 
 	tf->tf_group.default_groups = tf->tf_default_groups;
@@ -202,14 +202,14 @@ static struct config_group *target_core_register_fabric(
 	config_group_init_type_name(&tf->tf_disc_group, "discovery_auth",
 			&TF_CIT_TMPL(tf)->tfc_discovery_cit);
 
-	printk(KERN_INFO "Target_Core_ConfigFS: REGISTER -> Allocated Fabric:"
+	pr_debug("Target_Core_ConfigFS: REGISTER -> Allocated Fabric:"
 			" %s\n", tf->tf_group.cg_item.ci_name);
 	/*
 	 * Setup tf_ops.tf_subsys pointer for usage with configfs_depend_item()
 	 */
 	tf->tf_ops.tf_subsys = tf->tf_subsys;
 	tf->tf_fabric = &tf->tf_group.cg_item;
-	printk(KERN_INFO "Target_Core_ConfigFS: REGISTER -> Set tf->tf_fabric"
+	pr_debug("Target_Core_ConfigFS: REGISTER -> Set tf->tf_fabric"
 			" for %s\n", name);
 
 	return &tf->tf_group;
@@ -228,18 +228,18 @@ static void target_core_deregister_fabric(
 	struct config_item *df_item;
 	int i;
 
-	printk(KERN_INFO "Target_Core_ConfigFS: DEREGISTER -> Looking up %s in"
+	pr_debug("Target_Core_ConfigFS: DEREGISTER -> Looking up %s in"
 		" tf list\n", config_item_name(item));
 
-	printk(KERN_INFO "Target_Core_ConfigFS: DEREGISTER -> located fabric:"
+	pr_debug("Target_Core_ConfigFS: DEREGISTER -> located fabric:"
 			" %s\n", tf->tf_name);
 	atomic_dec(&tf->tf_access_cnt);
 
-	printk(KERN_INFO "Target_Core_ConfigFS: DEREGISTER -> Releasing"
+	pr_debug("Target_Core_ConfigFS: DEREGISTER -> Releasing"
 			" tf->tf_fabric for %s\n", tf->tf_name);
 	tf->tf_fabric = NULL;
 
-	printk(KERN_INFO "Target_Core_ConfigFS: DEREGISTER -> Releasing ci"
+	pr_debug("Target_Core_ConfigFS: DEREGISTER -> Releasing ci"
 			" %s\n", config_item_name(item));
 
 	tf_group = &tf->tf_group;
@@ -307,15 +307,15 @@ struct target_fabric_configfs *target_fabric_configfs_init(
 	struct target_fabric_configfs *tf;
 
 	if (!(fabric_mod)) {
-		printk(KERN_ERR "Missing struct module *fabric_mod pointer\n");
+		pr_err("Missing struct module *fabric_mod pointer\n");
 		return ERR_PTR(-EINVAL);
 	}
 	if (!(name)) {
-		printk(KERN_ERR "Unable to locate passed fabric name\n");
+		pr_err("Unable to locate passed fabric name\n");
 		return ERR_PTR(-EINVAL);
 	}
 	if (strlen(name) >= TARGET_FABRIC_NAME_SIZE) {
-		printk(KERN_ERR "Passed name: %s exceeds TARGET_FABRIC"
+		pr_err("Passed name: %s exceeds TARGET_FABRIC"
 			"_NAME_SIZE\n", name);
 		return ERR_PTR(-EINVAL);
 	}
@@ -340,9 +340,9 @@ struct target_fabric_configfs *target_fabric_configfs_init(
 	list_add_tail(&tf->tf_list, &g_tf_list);
 	mutex_unlock(&g_tf_lock);
 
-	printk(KERN_INFO "<<<<<<<<<<<<<<<<<<<<<< BEGIN FABRIC API >>>>>>>>"
+	pr_debug("<<<<<<<<<<<<<<<<<<<<<< BEGIN FABRIC API >>>>>>>>"
 			">>>>>>>>>>>>>>\n");
-	printk(KERN_INFO "Initialized struct target_fabric_configfs: %p for"
+	pr_debug("Initialized struct target_fabric_configfs: %p for"
 			" %s\n", tf, tf->tf_name);
 	return tf;
 }
@@ -372,131 +372,131 @@ static int target_fabric_tf_ops_check(
 	struct target_core_fabric_ops *tfo = &tf->tf_ops;
 
 	if (!(tfo->get_fabric_name)) {
-		printk(KERN_ERR "Missing tfo->get_fabric_name()\n");
+		pr_err("Missing tfo->get_fabric_name()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->get_fabric_proto_ident)) {
-		printk(KERN_ERR "Missing tfo->get_fabric_proto_ident()\n");
+		pr_err("Missing tfo->get_fabric_proto_ident()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->tpg_get_wwn)) {
-		printk(KERN_ERR "Missing tfo->tpg_get_wwn()\n");
+		pr_err("Missing tfo->tpg_get_wwn()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->tpg_get_tag)) {
-		printk(KERN_ERR "Missing tfo->tpg_get_tag()\n");
+		pr_err("Missing tfo->tpg_get_tag()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->tpg_get_default_depth)) {
-		printk(KERN_ERR "Missing tfo->tpg_get_default_depth()\n");
+		pr_err("Missing tfo->tpg_get_default_depth()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->tpg_get_pr_transport_id)) {
-		printk(KERN_ERR "Missing tfo->tpg_get_pr_transport_id()\n");
+		pr_err("Missing tfo->tpg_get_pr_transport_id()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->tpg_get_pr_transport_id_len)) {
-		printk(KERN_ERR "Missing tfo->tpg_get_pr_transport_id_len()\n");
+		pr_err("Missing tfo->tpg_get_pr_transport_id_len()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->tpg_check_demo_mode)) {
-		printk(KERN_ERR "Missing tfo->tpg_check_demo_mode()\n");
+		pr_err("Missing tfo->tpg_check_demo_mode()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->tpg_check_demo_mode_cache)) {
-		printk(KERN_ERR "Missing tfo->tpg_check_demo_mode_cache()\n");
+		pr_err("Missing tfo->tpg_check_demo_mode_cache()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->tpg_check_demo_mode_write_protect)) {
-		printk(KERN_ERR "Missing tfo->tpg_check_demo_mode_write_protect()\n");
+		pr_err("Missing tfo->tpg_check_demo_mode_write_protect()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->tpg_check_prod_mode_write_protect)) {
-		printk(KERN_ERR "Missing tfo->tpg_check_prod_mode_write_protect()\n");
+		pr_err("Missing tfo->tpg_check_prod_mode_write_protect()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->tpg_alloc_fabric_acl)) {
-		printk(KERN_ERR "Missing tfo->tpg_alloc_fabric_acl()\n");
+		pr_err("Missing tfo->tpg_alloc_fabric_acl()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->tpg_release_fabric_acl)) {
-		printk(KERN_ERR "Missing tfo->tpg_release_fabric_acl()\n");
+		pr_err("Missing tfo->tpg_release_fabric_acl()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->tpg_get_inst_index)) {
-		printk(KERN_ERR "Missing tfo->tpg_get_inst_index()\n");
+		pr_err("Missing tfo->tpg_get_inst_index()\n");
 		return -EINVAL;
 	}
 	if (!tfo->release_cmd) {
-		printk(KERN_ERR "Missing tfo->release_cmd()\n");
+		pr_err("Missing tfo->release_cmd()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->shutdown_session)) {
-		printk(KERN_ERR "Missing tfo->shutdown_session()\n");
+		pr_err("Missing tfo->shutdown_session()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->close_session)) {
-		printk(KERN_ERR "Missing tfo->close_session()\n");
+		pr_err("Missing tfo->close_session()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->stop_session)) {
-		printk(KERN_ERR "Missing tfo->stop_session()\n");
+		pr_err("Missing tfo->stop_session()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->fall_back_to_erl0)) {
-		printk(KERN_ERR "Missing tfo->fall_back_to_erl0()\n");
+		pr_err("Missing tfo->fall_back_to_erl0()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->sess_logged_in)) {
-		printk(KERN_ERR "Missing tfo->sess_logged_in()\n");
+		pr_err("Missing tfo->sess_logged_in()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->sess_get_index)) {
-		printk(KERN_ERR "Missing tfo->sess_get_index()\n");
+		pr_err("Missing tfo->sess_get_index()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->write_pending)) {
-		printk(KERN_ERR "Missing tfo->write_pending()\n");
+		pr_err("Missing tfo->write_pending()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->write_pending_status)) {
-		printk(KERN_ERR "Missing tfo->write_pending_status()\n");
+		pr_err("Missing tfo->write_pending_status()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->set_default_node_attributes)) {
-		printk(KERN_ERR "Missing tfo->set_default_node_attributes()\n");
+		pr_err("Missing tfo->set_default_node_attributes()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->get_task_tag)) {
-		printk(KERN_ERR "Missing tfo->get_task_tag()\n");
+		pr_err("Missing tfo->get_task_tag()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->get_cmd_state)) {
-		printk(KERN_ERR "Missing tfo->get_cmd_state()\n");
+		pr_err("Missing tfo->get_cmd_state()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->queue_data_in)) {
-		printk(KERN_ERR "Missing tfo->queue_data_in()\n");
+		pr_err("Missing tfo->queue_data_in()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->queue_status)) {
-		printk(KERN_ERR "Missing tfo->queue_status()\n");
+		pr_err("Missing tfo->queue_status()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->queue_tm_rsp)) {
-		printk(KERN_ERR "Missing tfo->queue_tm_rsp()\n");
+		pr_err("Missing tfo->queue_tm_rsp()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->set_fabric_sense_len)) {
-		printk(KERN_ERR "Missing tfo->set_fabric_sense_len()\n");
+		pr_err("Missing tfo->set_fabric_sense_len()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->get_fabric_sense_len)) {
-		printk(KERN_ERR "Missing tfo->get_fabric_sense_len()\n");
+		pr_err("Missing tfo->get_fabric_sense_len()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->is_state_remove)) {
-		printk(KERN_ERR "Missing tfo->is_state_remove()\n");
+		pr_err("Missing tfo->is_state_remove()\n");
 		return -EINVAL;
 	}
 	/*
@@ -505,19 +505,19 @@ static int target_fabric_tf_ops_check(
 	 * target_core_fabric_configfs.c WWN+TPG group context code.
 	 */
 	if (!(tfo->fabric_make_wwn)) {
-		printk(KERN_ERR "Missing tfo->fabric_make_wwn()\n");
+		pr_err("Missing tfo->fabric_make_wwn()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->fabric_drop_wwn)) {
-		printk(KERN_ERR "Missing tfo->fabric_drop_wwn()\n");
+		pr_err("Missing tfo->fabric_drop_wwn()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->fabric_make_tpg)) {
-		printk(KERN_ERR "Missing tfo->fabric_make_tpg()\n");
+		pr_err("Missing tfo->fabric_make_tpg()\n");
 		return -EINVAL;
 	}
 	if (!(tfo->fabric_drop_tpg)) {
-		printk(KERN_ERR "Missing tfo->fabric_drop_tpg()\n");
+		pr_err("Missing tfo->fabric_drop_tpg()\n");
 		return -EINVAL;
 	}
 
@@ -538,12 +538,12 @@ int target_fabric_configfs_register(
 	int ret;
 
 	if (!(tf)) {
-		printk(KERN_ERR "Unable to locate target_fabric_configfs"
+		pr_err("Unable to locate target_fabric_configfs"
 			" pointer\n");
 		return -EINVAL;
 	}
 	if (!(tf->tf_subsys)) {
-		printk(KERN_ERR "Unable to target struct config_subsystem"
+		pr_err("Unable to target struct config_subsystem"
 			" pointer\n");
 		return -EINVAL;
 	}
@@ -551,7 +551,7 @@ int target_fabric_configfs_register(
 	if (ret < 0)
 		return ret;
 
-	printk(KERN_INFO "<<<<<<<<<<<<<<<<<<<<<< END FABRIC API >>>>>>>>>>>>"
+	pr_debug("<<<<<<<<<<<<<<<<<<<<<< END FABRIC API >>>>>>>>>>>>"
 		">>>>>>>>>>\n");
 	return 0;
 }
@@ -563,35 +563,35 @@ void target_fabric_configfs_deregister(
 	struct configfs_subsystem *su;
 
 	if (!(tf)) {
-		printk(KERN_ERR "Unable to locate passed target_fabric_"
+		pr_err("Unable to locate passed target_fabric_"
 			"configfs\n");
 		return;
 	}
 	su = tf->tf_subsys;
 	if (!(su)) {
-		printk(KERN_ERR "Unable to locate passed tf->tf_subsys"
+		pr_err("Unable to locate passed tf->tf_subsys"
 			" pointer\n");
 		return;
 	}
-	printk(KERN_INFO "<<<<<<<<<<<<<<<<<<<<<< BEGIN FABRIC API >>>>>>>>>>"
+	pr_debug("<<<<<<<<<<<<<<<<<<<<<< BEGIN FABRIC API >>>>>>>>>>"
 			">>>>>>>>>>>>\n");
 	mutex_lock(&g_tf_lock);
 	if (atomic_read(&tf->tf_access_cnt)) {
 		mutex_unlock(&g_tf_lock);
-		printk(KERN_ERR "Non zero tf->tf_access_cnt for fabric %s\n",
+		pr_err("Non zero tf->tf_access_cnt for fabric %s\n",
 			tf->tf_name);
 		BUG();
 	}
 	list_del(&tf->tf_list);
 	mutex_unlock(&g_tf_lock);
 
-	printk(KERN_INFO "Target_Core_ConfigFS: DEREGISTER -> Releasing tf:"
+	pr_debug("Target_Core_ConfigFS: DEREGISTER -> Releasing tf:"
 			" %s\n", tf->tf_name);
 	tf->tf_module = NULL;
 	tf->tf_subsys = NULL;
 	kfree(tf);
 
-	printk("<<<<<<<<<<<<<<<<<<<<<< END FABRIC API >>>>>>>>>>>>>>>>>"
+	pr_debug("<<<<<<<<<<<<<<<<<<<<<< END FABRIC API >>>>>>>>>>>>>>>>>"
 			">>>>>\n");
 }
 EXPORT_SYMBOL(target_fabric_configfs_deregister);
@@ -644,7 +644,7 @@ static ssize_t target_core_dev_store_attr_##_name(			\
 	ret = strict_strtoul(page, 0, &val);				\
 	if (ret < 0) {							\
 		spin_unlock(&se_dev->se_dev_lock);                      \
-		printk(KERN_ERR "strict_strtoul() failed with"		\
+		pr_err("strict_strtoul() failed with"		\
 			" ret: %d\n", ret);				\
 		return -EINVAL;						\
 	}								\
@@ -833,13 +833,13 @@ static ssize_t target_core_dev_wwn_store_attr_vpd_unit_serial(
 	 * VPD Unit Serial Number that OS dependent multipath can depend on.
 	 */
 	if (su_dev->su_dev_flags & SDF_FIRMWARE_VPD_UNIT_SERIAL) {
-		printk(KERN_ERR "Underlying SCSI device firmware provided VPD"
+		pr_err("Underlying SCSI device firmware provided VPD"
 			" Unit Serial, ignoring request\n");
 		return -EOPNOTSUPP;
 	}
 
 	if (strlen(page) >= INQUIRY_VPD_SERIAL_LEN) {
-		printk(KERN_ERR "Emulated VPD Unit Serial exceeds"
+		pr_err("Emulated VPD Unit Serial exceeds"
 		" INQUIRY_VPD_SERIAL_LEN: %d\n", INQUIRY_VPD_SERIAL_LEN);
 		return -EOVERFLOW;
 	}
@@ -852,7 +852,7 @@ static ssize_t target_core_dev_wwn_store_attr_vpd_unit_serial(
 	dev = su_dev->se_dev_ptr;
 	if ((dev)) {
 		if (atomic_read(&dev->dev_export_obj.obj_access_count)) {
-			printk(KERN_ERR "Unable to set VPD Unit Serial while"
+			pr_err("Unable to set VPD Unit Serial while"
 				" active %d $FABRIC_MOD exports exist\n",
 				atomic_read(&dev->dev_export_obj.obj_access_count));
 			return -EINVAL;
@@ -870,7 +870,7 @@ static ssize_t target_core_dev_wwn_store_attr_vpd_unit_serial(
 			"%s", strstrip(buf));
 	su_dev->su_dev_flags |= SDF_EMULATED_VPD_UNIT_SERIAL;
 
-	printk(KERN_INFO "Target_Core_ConfigFS: Set emulated VPD Unit Serial:"
+	pr_debug("Target_Core_ConfigFS: Set emulated VPD Unit Serial:"
 			" %s\n", su_dev->t10_wwn.unit_serial);
 
 	return count;
@@ -1454,7 +1454,7 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
 		return 0;
 
 	if (atomic_read(&dev->dev_export_obj.obj_access_count)) {
-		printk(KERN_INFO "Unable to process APTPL metadata while"
+		pr_debug("Unable to process APTPL metadata while"
 			" active fabric exports exist\n");
 		return -EINVAL;
 	}
@@ -1484,7 +1484,7 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
 				goto out;
 			}
 			if (strlen(i_port) >= PR_APTPL_MAX_IPORT_LEN) {
-				printk(KERN_ERR "APTPL metadata initiator_node="
+				pr_err("APTPL metadata initiator_node="
 					" exceeds PR_APTPL_MAX_IPORT_LEN: %d\n",
 					PR_APTPL_MAX_IPORT_LEN);
 				ret = -EINVAL;
@@ -1498,7 +1498,7 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
 				goto out;
 			}
 			if (strlen(isid) >= PR_REG_ISID_LEN) {
-				printk(KERN_ERR "APTPL metadata initiator_isid"
+				pr_err("APTPL metadata initiator_isid"
 					"= exceeds PR_REG_ISID_LEN: %d\n",
 					PR_REG_ISID_LEN);
 				ret = -EINVAL;
@@ -1513,7 +1513,7 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
 			}
 			ret = strict_strtoull(arg_p, 0, &tmp_ll);
 			if (ret < 0) {
-				printk(KERN_ERR "strict_strtoull() failed for"
+				pr_err("strict_strtoull() failed for"
 					" sa_res_key=\n");
 				goto out;
 			}
@@ -1559,7 +1559,7 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
 				goto out;
 			}
 			if (strlen(t_port) >= PR_APTPL_MAX_TPORT_LEN) {
-				printk(KERN_ERR "APTPL metadata target_node="
+				pr_err("APTPL metadata target_node="
 					" exceeds PR_APTPL_MAX_TPORT_LEN: %d\n",
 					PR_APTPL_MAX_TPORT_LEN);
 				ret = -EINVAL;
@@ -1584,13 +1584,13 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
 	}
 
 	if (!(i_port) || !(t_port) || !(sa_res_key)) {
-		printk(KERN_ERR "Illegal parameters for APTPL registration\n");
+		pr_err("Illegal parameters for APTPL registration\n");
 		ret = -EINVAL;
 		goto out;
 	}
 
 	if (res_holder && !(type)) {
-		printk(KERN_ERR "Illegal PR type: 0x%02x for reservation"
+		pr_err("Illegal PR type: 0x%02x for reservation"
 				" holder\n", type);
 		ret = -EINVAL;
 		goto out;
@@ -1676,7 +1676,7 @@ static ssize_t target_core_store_dev_control(
 	struct se_subsystem_api *t = hba->transport;
 
 	if (!(se_dev->se_dev_su_ptr)) {
-		printk(KERN_ERR "Unable to locate struct se_subsystem_dev>se"
+		pr_err("Unable to locate struct se_subsystem_dev>se"
 				"_dev_su_ptr\n");
 		return -EINVAL;
 	}
@@ -1712,7 +1712,7 @@ static ssize_t target_core_store_dev_alias(
 	ssize_t read_bytes;
 
 	if (count > (SE_DEV_ALIAS_LEN-1)) {
-		printk(KERN_ERR "alias count: %d exceeds"
+		pr_err("alias count: %d exceeds"
 			" SE_DEV_ALIAS_LEN-1: %u\n", (int)count,
 			SE_DEV_ALIAS_LEN-1);
 		return -EINVAL;
@@ -1722,7 +1722,7 @@ static ssize_t target_core_store_dev_alias(
 	read_bytes = snprintf(&se_dev->se_dev_alias[0], SE_DEV_ALIAS_LEN,
 			"%s", page);
 
-	printk(KERN_INFO "Target_Core_ConfigFS: %s/%s set alias: %s\n",
+	pr_debug("Target_Core_ConfigFS: %s/%s set alias: %s\n",
 		config_item_name(&hba->hba_group.cg_item),
 		config_item_name(&se_dev->se_dev_group.cg_item),
 		se_dev->se_dev_alias);
@@ -1758,7 +1758,7 @@ static ssize_t target_core_store_dev_udev_path(
 	ssize_t read_bytes;
 
 	if (count > (SE_UDEV_PATH_LEN-1)) {
-		printk(KERN_ERR "udev_path count: %d exceeds"
+		pr_err("udev_path count: %d exceeds"
 			" SE_UDEV_PATH_LEN-1: %u\n", (int)count,
 			SE_UDEV_PATH_LEN-1);
 		return -EINVAL;
@@ -1768,7 +1768,7 @@ static ssize_t target_core_store_dev_udev_path(
 	read_bytes = snprintf(&se_dev->se_dev_udev_path[0], SE_UDEV_PATH_LEN,
 			"%s", page);
 
-	printk(KERN_INFO "Target_Core_ConfigFS: %s/%s set udev_path: %s\n",
+	pr_debug("Target_Core_ConfigFS: %s/%s set udev_path: %s\n",
 		config_item_name(&hba->hba_group.cg_item),
 		config_item_name(&se_dev->se_dev_group.cg_item),
 		se_dev->se_dev_udev_path);
@@ -1797,12 +1797,12 @@ static ssize_t target_core_store_dev_enable(
 
 	ptr = strstr(page, "1");
 	if (!(ptr)) {
-		printk(KERN_ERR "For dev_enable ops, only valid value"
+		pr_err("For dev_enable ops, only valid value"
 				" is \"1\"\n");
 		return -EINVAL;
 	}
 	if ((se_dev->se_dev_ptr)) {
-		printk(KERN_ERR "se_dev->se_dev_ptr already set for storage"
+		pr_err("se_dev->se_dev_ptr already set for storage"
 				" object\n");
 		return -EEXIST;
 	}
@@ -1817,7 +1817,7 @@ static ssize_t target_core_store_dev_enable(
 		return -EINVAL;
 
 	se_dev->se_dev_ptr = dev;
-	printk(KERN_INFO "Target_Core_ConfigFS: Registered se_dev->se_dev_ptr:"
+	pr_debug("Target_Core_ConfigFS: Registered se_dev->se_dev_ptr:"
 		" %p\n", se_dev->se_dev_ptr);
 
 	return count;
@@ -1849,7 +1849,7 @@ static ssize_t target_core_show_alua_lu_gp(void *p, char *page)
 
 	lu_gp_mem = dev->dev_alua_lu_gp_mem;
 	if (!(lu_gp_mem)) {
-		printk(KERN_ERR "NULL struct se_device->dev_alua_lu_gp_mem"
+		pr_err("NULL struct se_device->dev_alua_lu_gp_mem"
 				" pointer\n");
 		return -EINVAL;
 	}
@@ -1884,13 +1884,13 @@ static ssize_t target_core_store_alua_lu_gp(
 		return -ENODEV;
 
 	if (su_dev->t10_alua.alua_type != SPC3_ALUA_EMULATED) {
-		printk(KERN_WARNING "SPC3_ALUA_EMULATED not enabled for %s/%s\n",
+		pr_warn("SPC3_ALUA_EMULATED not enabled for %s/%s\n",
 			config_item_name(&hba->hba_group.cg_item),
 			config_item_name(&su_dev->se_dev_group.cg_item));
 		return -EINVAL;
 	}
 	if (count > LU_GROUP_NAME_BUF) {
-		printk(KERN_ERR "ALUA LU Group Alias too large!\n");
+		pr_err("ALUA LU Group Alias too large!\n");
 		return -EINVAL;
 	}
 	memset(buf, 0, LU_GROUP_NAME_BUF);
@@ -1913,7 +1913,7 @@ static ssize_t target_core_store_alua_lu_gp(
 	if (!(lu_gp_mem)) {
 		if (lu_gp_new)
 			core_alua_put_lu_gp_from_name(lu_gp_new);
-		printk(KERN_ERR "NULL struct se_device->dev_alua_lu_gp_mem"
+		pr_err("NULL struct se_device->dev_alua_lu_gp_mem"
 				" pointer\n");
 		return -EINVAL;
 	}
@@ -1926,7 +1926,7 @@ static ssize_t target_core_store_alua_lu_gp(
 		 * with NULL
 		 */
 		if (!(lu_gp_new)) {
-			printk(KERN_INFO "Target_Core_ConfigFS: Releasing %s/%s"
+			pr_debug("Target_Core_ConfigFS: Releasing %s/%s"
 				" from ALUA LU Group: core/alua/lu_gps/%s, ID:"
 				" %hu\n",
 				config_item_name(&hba->hba_group.cg_item),
@@ -1951,7 +1951,7 @@ static ssize_t target_core_store_alua_lu_gp(
 	__core_alua_attach_lu_gp_mem(lu_gp_mem, lu_gp_new);
 	spin_unlock(&lu_gp_mem->lu_gp_mem_lock);
 
-	printk(KERN_INFO "Target_Core_ConfigFS: %s %s/%s to ALUA LU Group:"
+	pr_debug("Target_Core_ConfigFS: %s %s/%s to ALUA LU Group:"
 		" core/alua/lu_gps/%s, ID: %hu\n",
 		(move) ? "Moving" : "Adding",
 		config_item_name(&hba->hba_group.cg_item),
@@ -1995,7 +1995,7 @@ static void target_core_dev_release(struct config_item *item)
 	 *`echo 1 > $CONFIGFS/core/$HBA/$DEV/dev_enable`
 	 */
 	if (se_dev->se_dev_ptr) {
-		printk(KERN_INFO "Target_Core_ConfigFS: Calling se_free_"
+		pr_debug("Target_Core_ConfigFS: Calling se_free_"
 			"virtual_device() for se_dev_ptr: %p\n",
 			se_dev->se_dev_ptr);
 
@@ -2004,14 +2004,14 @@ static void target_core_dev_release(struct config_item *item)
 		/*
 		 * Release struct se_subsystem_dev->se_dev_su_ptr..
 		 */
-		printk(KERN_INFO "Target_Core_ConfigFS: Calling t->free_"
+		pr_debug("Target_Core_ConfigFS: Calling t->free_"
 			"device() for se_dev_su_ptr: %p\n",
 			se_dev->se_dev_su_ptr);
 
 		t->free_device(se_dev->se_dev_su_ptr);
 	}
 
-	printk(KERN_INFO "Target_Core_ConfigFS: Deallocating se_subsystem"
+	pr_debug("Target_Core_ConfigFS: Deallocating se_subsystem"
 			"_dev_t: %p\n", se_dev);
 	kfree(se_dev);
 }
@@ -2102,12 +2102,12 @@ static ssize_t target_core_alua_lu_gp_store_attr_lu_gp_id(
 
 	ret = strict_strtoul(page, 0, &lu_gp_id);
 	if (ret < 0) {
-		printk(KERN_ERR "strict_strtoul() returned %d for"
+		pr_err("strict_strtoul() returned %d for"
 			" lu_gp_id\n", ret);
 		return -EINVAL;
 	}
 	if (lu_gp_id > 0x0000ffff) {
-		printk(KERN_ERR "ALUA lu_gp_id: %lu exceeds maximum:"
+		pr_err("ALUA lu_gp_id: %lu exceeds maximum:"
 			" 0x0000ffff\n", lu_gp_id);
 		return -EINVAL;
 	}
@@ -2116,7 +2116,7 @@ static ssize_t target_core_alua_lu_gp_store_attr_lu_gp_id(
 	if (ret < 0)
 		return -EINVAL;
 
-	printk(KERN_INFO "Target_Core_ConfigFS: Set ALUA Logical Unit"
+	pr_debug("Target_Core_ConfigFS: Set ALUA Logical Unit"
 		" Group: core/alua/lu_gps/%s to ID: %hu\n",
 		config_item_name(&alua_lu_gp_cg->cg_item),
 		lu_gp->lu_gp_id);
@@ -2154,7 +2154,7 @@ static ssize_t target_core_alua_lu_gp_show_attr_members(
 		cur_len++; /* Extra byte for NULL terminator */
 
 		if ((cur_len + len) > PAGE_SIZE) {
-			printk(KERN_WARNING "Ran out of lu_gp_show_attr"
+			pr_warn("Ran out of lu_gp_show_attr"
 				"_members buffer\n");
 			break;
 		}
@@ -2218,7 +2218,7 @@ static struct config_group *target_core_alua_create_lu_gp(
 	config_group_init_type_name(alua_lu_gp_cg, name,
 			&target_core_alua_lu_gp_cit);
 
-	printk(KERN_INFO "Target_Core_ConfigFS: Allocated ALUA Logical Unit"
+	pr_debug("Target_Core_ConfigFS: Allocated ALUA Logical Unit"
 		" Group: core/alua/lu_gps/%s\n",
 		config_item_name(alua_lu_gp_ci));
 
@@ -2233,7 +2233,7 @@ static void target_core_alua_drop_lu_gp(
 	struct t10_alua_lu_gp *lu_gp = container_of(to_config_group(item),
 			struct t10_alua_lu_gp, lu_gp_group);
 
-	printk(KERN_INFO "Target_Core_ConfigFS: Releasing ALUA Logical Unit"
+	pr_debug("Target_Core_ConfigFS: Releasing ALUA Logical Unit"
 		" Group: core/alua/lu_gps/%s, ID: %hu\n",
 		config_item_name(item), lu_gp->lu_gp_id);
 	/*
@@ -2293,21 +2293,21 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_state(
 	int new_state, ret;
 
 	if (!(tg_pt_gp->tg_pt_gp_valid_id)) {
-		printk(KERN_ERR "Unable to do implict ALUA on non valid"
+		pr_err("Unable to do implict ALUA on non valid"
 			" tg_pt_gp ID: %hu\n", tg_pt_gp->tg_pt_gp_valid_id);
 		return -EINVAL;
 	}
 
 	ret = strict_strtoul(page, 0, &tmp);
 	if (ret < 0) {
-		printk("Unable to extract new ALUA access state from"
+		pr_err("Unable to extract new ALUA access state from"
 				" %s\n", page);
 		return -EINVAL;
 	}
 	new_state = (int)tmp;
 
 	if (!(tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_IMPLICT_ALUA)) {
-		printk(KERN_ERR "Unable to process implict configfs ALUA"
+		pr_err("Unable to process implict configfs ALUA"
 			" transition while TPGS_IMPLICT_ALUA is diabled\n");
 		return -EINVAL;
 	}
@@ -2339,7 +2339,7 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_status(
 	int new_status, ret;
 
 	if (!(tg_pt_gp->tg_pt_gp_valid_id)) {
-		printk(KERN_ERR "Unable to do set ALUA access status on non"
+		pr_err("Unable to do set ALUA access status on non"
 			" valid tg_pt_gp ID: %hu\n",
 			tg_pt_gp->tg_pt_gp_valid_id);
 		return -EINVAL;
@@ -2347,7 +2347,7 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_status(
 
 	ret = strict_strtoul(page, 0, &tmp);
 	if (ret < 0) {
-		printk(KERN_ERR "Unable to extract new ALUA access status"
+		pr_err("Unable to extract new ALUA access status"
 				" from %s\n", page);
 		return -EINVAL;
 	}
@@ -2356,7 +2356,7 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_status(
 	if ((new_status != ALUA_STATUS_NONE) &&
 	    (new_status != ALUA_STATUS_ALTERED_BY_EXPLICT_STPG) &&
 	    (new_status != ALUA_STATUS_ALTERED_BY_IMPLICT_ALUA)) {
-		printk(KERN_ERR "Illegal ALUA access status: 0x%02x\n",
+		pr_err("Illegal ALUA access status: 0x%02x\n",
 				new_status);
 		return -EINVAL;
 	}
@@ -2407,12 +2407,12 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_write_metadata(
 
 	ret = strict_strtoul(page, 0, &tmp);
 	if (ret < 0) {
-		printk(KERN_ERR "Unable to extract alua_write_metadata\n");
+		pr_err("Unable to extract alua_write_metadata\n");
 		return -EINVAL;
 	}
 
 	if ((tmp != 0) && (tmp != 1)) {
-		printk(KERN_ERR "Illegal value for alua_write_metadata:"
+		pr_err("Illegal value for alua_write_metadata:"
 			" %lu\n", tmp);
 		return -EINVAL;
 	}
@@ -2511,12 +2511,12 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_tg_pt_gp_id(
 
 	ret = strict_strtoul(page, 0, &tg_pt_gp_id);
 	if (ret < 0) {
-		printk(KERN_ERR "strict_strtoul() returned %d for"
+		pr_err("strict_strtoul() returned %d for"
 			" tg_pt_gp_id\n", ret);
 		return -EINVAL;
 	}
 	if (tg_pt_gp_id > 0x0000ffff) {
-		printk(KERN_ERR "ALUA tg_pt_gp_id: %lu exceeds maximum:"
+		pr_err("ALUA tg_pt_gp_id: %lu exceeds maximum:"
 			" 0x0000ffff\n", tg_pt_gp_id);
 		return -EINVAL;
 	}
@@ -2525,7 +2525,7 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_tg_pt_gp_id(
 	if (ret < 0)
 		return -EINVAL;
 
-	printk(KERN_INFO "Target_Core_ConfigFS: Set ALUA Target Port Group: "
+	pr_debug("Target_Core_ConfigFS: Set ALUA Target Port Group: "
 		"core/alua/tg_pt_gps/%s to ID: %hu\n",
 		config_item_name(&alua_tg_pt_gp_cg->cg_item),
 		tg_pt_gp->tg_pt_gp_id);
@@ -2566,7 +2566,7 @@ static ssize_t target_core_alua_tg_pt_gp_show_attr_members(
 		cur_len++; /* Extra byte for NULL terminator */
 
 		if ((cur_len + len) > PAGE_SIZE) {
-			printk(KERN_WARNING "Ran out of lu_gp_show_attr"
+			pr_warn("Ran out of lu_gp_show_attr"
 				"_members buffer\n");
 			break;
 		}
@@ -2641,7 +2641,7 @@ static struct config_group *target_core_alua_create_tg_pt_gp(
 	config_group_init_type_name(alua_tg_pt_gp_cg, name,
 			&target_core_alua_tg_pt_gp_cit);
 
-	printk(KERN_INFO "Target_Core_ConfigFS: Allocated ALUA Target Port"
+	pr_debug("Target_Core_ConfigFS: Allocated ALUA Target Port"
 		" Group: alua/tg_pt_gps/%s\n",
 		config_item_name(alua_tg_pt_gp_ci));
 
@@ -2655,7 +2655,7 @@ static void target_core_alua_drop_tg_pt_gp(
 	struct t10_alua_tg_pt_gp *tg_pt_gp = container_of(to_config_group(item),
 			struct t10_alua_tg_pt_gp, tg_pt_gp_group);
 
-	printk(KERN_INFO "Target_Core_ConfigFS: Releasing ALUA Target Port"
+	pr_debug("Target_Core_ConfigFS: Releasing ALUA Target Port"
 		" Group: alua/tg_pt_gps/%s, ID: %hu\n",
 		config_item_name(item), tg_pt_gp->tg_pt_gp_id);
 	/*
@@ -2746,7 +2746,7 @@ static struct config_group *target_core_make_subdev(
 
 	se_dev = kzalloc(sizeof(struct se_subsystem_dev), GFP_KERNEL);
 	if (!se_dev) {
-		printk(KERN_ERR "Unable to allocate memory for"
+		pr_err("Unable to allocate memory for"
 				" struct se_subsystem_dev\n");
 		goto unlock;
 	}
@@ -2782,7 +2782,7 @@ static struct config_group *target_core_make_subdev(
 	 */
 	se_dev->se_dev_su_ptr = t->allocate_virtdevice(hba, name);
 	if (!(se_dev->se_dev_su_ptr)) {
-		printk(KERN_ERR "Unable to locate subsystem dependent pointer"
+		pr_err("Unable to locate subsystem dependent pointer"
 			" from allocate_virtdevice()\n");
 		goto out;
 	}
@@ -2820,7 +2820,7 @@ static struct config_group *target_core_make_subdev(
 	tg_pt_gp_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
 				GFP_KERNEL);
 	if (!(tg_pt_gp_cg->default_groups)) {
-		printk(KERN_ERR "Unable to allocate tg_pt_gp_cg->"
+		pr_err("Unable to allocate tg_pt_gp_cg->"
 				"default_groups\n");
 		goto out;
 	}
@@ -2837,12 +2837,12 @@ static struct config_group *target_core_make_subdev(
 	dev_stat_grp->default_groups = kzalloc(sizeof(struct config_group) * 4,
 				GFP_KERNEL);
 	if (!dev_stat_grp->default_groups) {
-		printk(KERN_ERR "Unable to allocate dev_stat_grp->default_groups\n");
+		pr_err("Unable to allocate dev_stat_grp->default_groups\n");
 		goto out;
 	}
 	target_stat_setup_dev_default_groups(se_dev);
 
-	printk(KERN_INFO "Target_Core_ConfigFS: Allocated struct se_subsystem_dev:"
+	pr_debug("Target_Core_ConfigFS: Allocated struct se_subsystem_dev:"
 		" %p se_dev_su_ptr: %p\n", se_dev, se_dev->se_dev_su_ptr);
 
 	mutex_unlock(&hba->hba_access_mutex);
@@ -2975,13 +2975,13 @@ static ssize_t target_core_hba_store_attr_hba_mode(struct se_hba *hba,
 
 	ret = strict_strtoul(page, 0, &mode_flag);
 	if (ret < 0) {
-		printk(KERN_ERR "Unable to extract hba mode flag: %d\n", ret);
+		pr_err("Unable to extract hba mode flag: %d\n", ret);
 		return -EINVAL;
 	}
 
 	spin_lock(&hba->device_lock);
 	if (!(list_empty(&hba->hba_dev_list))) {
-		printk(KERN_ERR "Unable to set hba_mode with active devices\n");
+		pr_err("Unable to set hba_mode with active devices\n");
 		spin_unlock(&hba->device_lock);
 		return -EINVAL;
 	}
@@ -3040,7 +3040,7 @@ static struct config_group *target_core_call_addhbatotarget(
 
 	memset(buf, 0, TARGET_CORE_NAME_MAX_LEN);
 	if (strlen(name) >= TARGET_CORE_NAME_MAX_LEN) {
-		printk(KERN_ERR "Passed *name strlen(): %d exceeds"
+		pr_err("Passed *name strlen(): %d exceeds"
 			" TARGET_CORE_NAME_MAX_LEN: %d\n", (int)strlen(name),
 			TARGET_CORE_NAME_MAX_LEN);
 		return ERR_PTR(-ENAMETOOLONG);
@@ -3049,7 +3049,7 @@ static struct config_group *target_core_call_addhbatotarget(
 
 	str = strstr(buf, "_");
 	if (!(str)) {
-		printk(KERN_ERR "Unable to locate \"_\" for $SUBSYSTEM_PLUGIN_$HOST_ID\n");
+		pr_err("Unable to locate \"_\" for $SUBSYSTEM_PLUGIN_$HOST_ID\n");
 		return ERR_PTR(-EINVAL);
 	}
 	se_plugin_str = buf;
@@ -3069,7 +3069,7 @@ static struct config_group *target_core_call_addhbatotarget(
 
 	ret = strict_strtoul(str, 0, &plugin_dep_id);
 	if (ret < 0) {
-		printk(KERN_ERR "strict_strtoul() returned %d for"
+		pr_err("strict_strtoul() returned %d for"
 				" plugin_dep_id\n", ret);
 		return ERR_PTR(-EINVAL);
 	}
@@ -3122,7 +3122,7 @@ static int __init target_core_init_configfs(void)
 	struct t10_alua_lu_gp *lu_gp;
 	int ret;
 
-	printk(KERN_INFO "TARGET_CORE[0]: Loading Generic Kernel Storage"
+	pr_debug("TARGET_CORE[0]: Loading Generic Kernel Storage"
 		" Engine: %s on %s/%s on "UTS_RELEASE"\n",
 		TARGET_CORE_VERSION, utsname()->sysname, utsname()->machine);
 
@@ -3143,7 +3143,7 @@ static int __init target_core_init_configfs(void)
 	target_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
 				GFP_KERNEL);
 	if (!(target_cg->default_groups)) {
-		printk(KERN_ERR "Unable to allocate target_cg->default_groups\n");
+		pr_err("Unable to allocate target_cg->default_groups\n");
 		goto out_global;
 	}
 
@@ -3158,7 +3158,7 @@ static int __init target_core_init_configfs(void)
 	hba_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
 				GFP_KERNEL);
 	if (!(hba_cg->default_groups)) {
-		printk(KERN_ERR "Unable to allocate hba_cg->default_groups\n");
+		pr_err("Unable to allocate hba_cg->default_groups\n");
 		goto out_global;
 	}
 	config_group_init_type_name(&alua_group,
@@ -3173,7 +3173,7 @@ static int __init target_core_init_configfs(void)
 	alua_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
 			GFP_KERNEL);
 	if (!(alua_cg->default_groups)) {
-		printk(KERN_ERR "Unable to allocate alua_cg->default_groups\n");
+		pr_err("Unable to allocate alua_cg->default_groups\n");
 		goto out_global;
 	}
 
@@ -3192,7 +3192,7 @@ static int __init target_core_init_configfs(void)
 	lu_gp_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
 			GFP_KERNEL);
 	if (!(lu_gp_cg->default_groups)) {
-		printk(KERN_ERR "Unable to allocate lu_gp_cg->default_groups\n");
+		pr_err("Unable to allocate lu_gp_cg->default_groups\n");
 		goto out_global;
 	}
 
@@ -3206,11 +3206,11 @@ static int __init target_core_init_configfs(void)
 	 */
 	ret = configfs_register_subsystem(subsys);
 	if (ret < 0) {
-		printk(KERN_ERR "Error %d while registering subsystem %s\n",
+		pr_err("Error %d while registering subsystem %s\n",
 			ret, subsys->su_group.cg_item.ci_namebuf);
 		goto out_global;
 	}
-	printk(KERN_INFO "TARGET_CORE[0]: Initialized ConfigFS Fabric"
+	pr_debug("TARGET_CORE[0]: Initialized ConfigFS Fabric"
 		" Infrastructure: "TARGET_CORE_CONFIGFS_VERSION" on %s/%s"
 		" on "UTS_RELEASE"\n", utsname()->sysname, utsname()->machine);
 	/*
@@ -3290,7 +3290,7 @@ static void __exit target_core_exit_configfs(void)
 	core_alua_free_lu_gp(default_lu_gp);
 	default_lu_gp = NULL;
 
-	printk(KERN_INFO "TARGET_CORE[0]: Released ConfigFS Fabric"
+	pr_debug("TARGET_CORE[0]: Released ConfigFS Fabric"
 			" Infrastructure\n");
 
 	core_dev_release_virtual_lun0();
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 875d64f..097c286 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -85,7 +85,7 @@ int transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 		    (deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY)) {
 			se_cmd->scsi_sense_reason = TCM_WRITE_PROTECTED;
 			se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
-			printk("TARGET_CORE[%s]: Detected WRITE_PROTECTED LUN"
+			pr_err("TARGET_CORE[%s]: Detected WRITE_PROTECTED LUN"
 			       " Access for 0x%08x\n",
 			       se_cmd->se_tfo->get_fabric_name(),
 			       unpacked_lun);
@@ -118,7 +118,7 @@ int transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 		if (unpacked_lun != 0) {
 			se_cmd->scsi_sense_reason = TCM_NON_EXISTENT_LUN;
 			se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
-			printk("TARGET_CORE[%s]: Detected NON_EXISTENT_LUN"
+			pr_err("TARGET_CORE[%s]: Detected NON_EXISTENT_LUN"
 			       " Access for 0x%08x\n",
 			       se_cmd->se_tfo->get_fabric_name(),
 			       unpacked_lun);
@@ -205,7 +205,7 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 	spin_unlock_irq(&se_sess->se_node_acl->device_list_lock);
 
 	if (!se_lun) {
-		printk(KERN_INFO "TARGET_CORE[%s]: Detected NON_EXISTENT_LUN"
+		pr_debug("TARGET_CORE[%s]: Detected NON_EXISTENT_LUN"
 			" Access for 0x%08x\n",
 			se_cmd->se_tfo->get_fabric_name(),
 			unpacked_lun);
@@ -257,14 +257,14 @@ struct se_dev_entry *core_get_se_deve_from_rtpi(
 
 		lun = deve->se_lun;
 		if (!(lun)) {
-			printk(KERN_ERR "%s device entries device pointer is"
+			pr_err("%s device entries device pointer is"
 				" NULL, but Initiator has access.\n",
 				tpg->se_tpg_tfo->get_fabric_name());
 			continue;
 		}
 		port = lun->lun_sep;
 		if (!(port)) {
-			printk(KERN_ERR "%s device entries device pointer is"
+			pr_err("%s device entries device pointer is"
 				" NULL, but Initiator has access.\n",
 				tpg->se_tpg_tfo->get_fabric_name());
 			continue;
@@ -302,7 +302,7 @@ int core_free_device_list_for_node(
 			continue;
 
 		if (!deve->se_lun) {
-			printk(KERN_ERR "%s device entries device pointer is"
+			pr_err("%s device entries device pointer is"
 				" NULL, but Initiator has access.\n",
 				tpg->se_tpg_tfo->get_fabric_name());
 			continue;
@@ -396,14 +396,14 @@ int core_update_device_list_for_node(
 		 */
 		if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
 			if (deve->se_lun_acl != NULL) {
-				printk(KERN_ERR "struct se_dev_entry->se_lun_acl"
+				pr_err("struct se_dev_entry->se_lun_acl"
 					" already set for demo mode -> explict"
 					" LUN ACL transition\n");
 				spin_unlock_irq(&nacl->device_list_lock);
 				return -EINVAL;
 			}
 			if (deve->se_lun != lun) {
-				printk(KERN_ERR "struct se_dev_entry->se_lun does"
+				pr_err("struct se_dev_entry->se_lun does"
 					" match passed struct se_lun for demo mode"
 					" -> explict LUN ACL transition\n");
 				spin_unlock_irq(&nacl->device_list_lock);
@@ -503,7 +503,7 @@ static struct se_port *core_alloc_port(struct se_device *dev)
 
 	port = kzalloc(sizeof(struct se_port), GFP_KERNEL);
 	if (!(port)) {
-		printk(KERN_ERR "Unable to allocate struct se_port\n");
+		pr_err("Unable to allocate struct se_port\n");
 		return ERR_PTR(-ENOMEM);
 	}
 	INIT_LIST_HEAD(&port->sep_alua_list);
@@ -514,7 +514,7 @@ static struct se_port *core_alloc_port(struct se_device *dev)
 
 	spin_lock(&dev->se_port_lock);
 	if (dev->dev_port_count == 0x0000ffff) {
-		printk(KERN_WARNING "Reached dev->dev_port_count =="
+		pr_warn("Reached dev->dev_port_count =="
 				" 0x0000ffff\n");
 		spin_unlock(&dev->se_port_lock);
 		return ERR_PTR(-ENOSPC);
@@ -571,7 +571,7 @@ static void core_export_port(
 	if (su_dev->t10_alua.alua_type == SPC3_ALUA_EMULATED) {
 		tg_pt_gp_mem = core_alua_allocate_tg_pt_gp_mem(port);
 		if (IS_ERR(tg_pt_gp_mem) || !tg_pt_gp_mem) {
-			printk(KERN_ERR "Unable to allocate t10_alua_tg_pt"
+			pr_err("Unable to allocate t10_alua_tg_pt"
 					"_gp_member_t\n");
 			return;
 		}
@@ -579,7 +579,7 @@ static void core_export_port(
 		__core_alua_attach_tg_pt_gp_mem(tg_pt_gp_mem,
 			su_dev->t10_alua.default_tg_pt_gp);
 		spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
-		printk(KERN_INFO "%s/%s: Adding to default ALUA Target Port"
+		pr_debug("%s/%s: Adding to default ALUA Target Port"
 			" Group: alua/default_tg_pt_gp\n",
 			dev->transport->name, tpg->se_tpg_tfo->get_fabric_name());
 	}
@@ -665,7 +665,7 @@ int transport_core_report_lun_response(struct se_cmd *se_cmd)
 		break;
 
 	if (!(se_task)) {
-		printk(KERN_ERR "Unable to locate struct se_task for struct se_cmd\n");
+		pr_err("Unable to locate struct se_task for struct se_cmd\n");
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 	}
 
@@ -893,12 +893,12 @@ void se_dev_set_default_attribs(
 int se_dev_set_task_timeout(struct se_device *dev, u32 task_timeout)
 {
 	if (task_timeout > DA_TASK_TIMEOUT_MAX) {
-		printk(KERN_ERR "dev[%p]: Passed task_timeout: %u larger then"
+		pr_err("dev[%p]: Passed task_timeout: %u larger then"
 			" DA_TASK_TIMEOUT_MAX\n", dev, task_timeout);
 		return -EINVAL;
 	} else {
 		dev->se_sub_dev->se_dev_attrib.task_timeout = task_timeout;
-		printk(KERN_INFO "dev[%p]: Set SE Device task_timeout: %u\n",
+		pr_debug("dev[%p]: Set SE Device task_timeout: %u\n",
 			dev, task_timeout);
 	}
 
@@ -910,7 +910,7 @@ int se_dev_set_max_unmap_lba_count(
 	u32 max_unmap_lba_count)
 {
 	dev->se_sub_dev->se_dev_attrib.max_unmap_lba_count = max_unmap_lba_count;
-	printk(KERN_INFO "dev[%p]: Set max_unmap_lba_count: %u\n",
+	pr_debug("dev[%p]: Set max_unmap_lba_count: %u\n",
 			dev, dev->se_sub_dev->se_dev_attrib.max_unmap_lba_count);
 	return 0;
 }
@@ -921,7 +921,7 @@ int se_dev_set_max_unmap_block_desc_count(
 {
 	dev->se_sub_dev->se_dev_attrib.max_unmap_block_desc_count =
 		max_unmap_block_desc_count;
-	printk(KERN_INFO "dev[%p]: Set max_unmap_block_desc_count: %u\n",
+	pr_debug("dev[%p]: Set max_unmap_block_desc_count: %u\n",
 			dev, dev->se_sub_dev->se_dev_attrib.max_unmap_block_desc_count);
 	return 0;
 }
@@ -931,7 +931,7 @@ int se_dev_set_unmap_granularity(
 	u32 unmap_granularity)
 {
 	dev->se_sub_dev->se_dev_attrib.unmap_granularity = unmap_granularity;
-	printk(KERN_INFO "dev[%p]: Set unmap_granularity: %u\n",
+	pr_debug("dev[%p]: Set unmap_granularity: %u\n",
 			dev, dev->se_sub_dev->se_dev_attrib.unmap_granularity);
 	return 0;
 }
@@ -941,7 +941,7 @@ int se_dev_set_unmap_granularity_alignment(
 	u32 unmap_granularity_alignment)
 {
 	dev->se_sub_dev->se_dev_attrib.unmap_granularity_alignment = unmap_granularity_alignment;
-	printk(KERN_INFO "dev[%p]: Set unmap_granularity_alignment: %u\n",
+	pr_debug("dev[%p]: Set unmap_granularity_alignment: %u\n",
 			dev, dev->se_sub_dev->se_dev_attrib.unmap_granularity_alignment);
 	return 0;
 }
@@ -949,19 +949,19 @@ int se_dev_set_unmap_granularity_alignment(
 int se_dev_set_emulate_dpo(struct se_device *dev, int flag)
 {
 	if ((flag != 0) && (flag != 1)) {
-		printk(KERN_ERR "Illegal value %d\n", flag);
+		pr_err("Illegal value %d\n", flag);
 		return -EINVAL;
 	}
 	if (dev->transport->dpo_emulated == NULL) {
-		printk(KERN_ERR "dev->transport->dpo_emulated is NULL\n");
+		pr_err("dev->transport->dpo_emulated is NULL\n");
 		return -EINVAL;
 	}
 	if (dev->transport->dpo_emulated(dev) == 0) {
-		printk(KERN_ERR "dev->transport->dpo_emulated not supported\n");
+		pr_err("dev->transport->dpo_emulated not supported\n");
 		return -EINVAL;
 	}
 	dev->se_sub_dev->se_dev_attrib.emulate_dpo = flag;
-	printk(KERN_INFO "dev[%p]: SE Device Page Out (DPO) Emulation"
+	pr_debug("dev[%p]: SE Device Page Out (DPO) Emulation"
 			" bit: %d\n", dev, dev->se_sub_dev->se_dev_attrib.emulate_dpo);
 	return 0;
 }
@@ -969,19 +969,19 @@ int se_dev_set_emulate_dpo(struct se_device *dev, int flag)
 int se_dev_set_emulate_fua_write(struct se_device *dev, int flag)
 {
 	if ((flag != 0) && (flag != 1)) {
-		printk(KERN_ERR "Illegal value %d\n", flag);
+		pr_err("Illegal value %d\n", flag);
 		return -EINVAL;
 	}
 	if (dev->transport->fua_write_emulated == NULL) {
-		printk(KERN_ERR "dev->transport->fua_write_emulated is NULL\n");
+		pr_err("dev->transport->fua_write_emulated is NULL\n");
 		return -EINVAL;
 	}
 	if (dev->transport->fua_write_emulated(dev) == 0) {
-		printk(KERN_ERR "dev->transport->fua_write_emulated not supported\n");
+		pr_err("dev->transport->fua_write_emulated not supported\n");
 		return -EINVAL;
 	}
 	dev->se_sub_dev->se_dev_attrib.emulate_fua_write = flag;
-	printk(KERN_INFO "dev[%p]: SE Device Forced Unit Access WRITEs: %d\n",
+	pr_debug("dev[%p]: SE Device Forced Unit Access WRITEs: %d\n",
 			dev, dev->se_sub_dev->se_dev_attrib.emulate_fua_write);
 	return 0;
 }
@@ -989,19 +989,19 @@ int se_dev_set_emulate_fua_write(struct se_device *dev, int flag)
 int se_dev_set_emulate_fua_read(struct se_device *dev, int flag)
 {
 	if ((flag != 0) && (flag != 1)) {
-		printk(KERN_ERR "Illegal value %d\n", flag);
+		pr_err("Illegal value %d\n", flag);
 		return -EINVAL;
 	}
 	if (dev->transport->fua_read_emulated == NULL) {
-		printk(KERN_ERR "dev->transport->fua_read_emulated is NULL\n");
+		pr_err("dev->transport->fua_read_emulated is NULL\n");
 		return -EINVAL;
 	}
 	if (dev->transport->fua_read_emulated(dev) == 0) {
-		printk(KERN_ERR "dev->transport->fua_read_emulated not supported\n");
+		pr_err("dev->transport->fua_read_emulated not supported\n");
 		return -EINVAL;
 	}
 	dev->se_sub_dev->se_dev_attrib.emulate_fua_read = flag;
-	printk(KERN_INFO "dev[%p]: SE Device Forced Unit Access READs: %d\n",
+	pr_debug("dev[%p]: SE Device Forced Unit Access READs: %d\n",
 			dev, dev->se_sub_dev->se_dev_attrib.emulate_fua_read);
 	return 0;
 }
@@ -1009,19 +1009,19 @@ int se_dev_set_emulate_fua_read(struct se_device *dev, int flag)
 int se_dev_set_emulate_write_cache(struct se_device *dev, int flag)
 {
 	if ((flag != 0) && (flag != 1)) {
-		printk(KERN_ERR "Illegal value %d\n", flag);
+		pr_err("Illegal value %d\n", flag);
 		return -EINVAL;
 	}
 	if (dev->transport->write_cache_emulated == NULL) {
-		printk(KERN_ERR "dev->transport->write_cache_emulated is NULL\n");
+		pr_err("dev->transport->write_cache_emulated is NULL\n");
 		return -EINVAL;
 	}
 	if (dev->transport->write_cache_emulated(dev) == 0) {
-		printk(KERN_ERR "dev->transport->write_cache_emulated not supported\n");
+		pr_err("dev->transport->write_cache_emulated not supported\n");
 		return -EINVAL;
 	}
 	dev->se_sub_dev->se_dev_attrib.emulate_write_cache = flag;
-	printk(KERN_INFO "dev[%p]: SE Device WRITE_CACHE_EMULATION flag: %d\n",
+	pr_debug("dev[%p]: SE Device WRITE_CACHE_EMULATION flag: %d\n",
 			dev, dev->se_sub_dev->se_dev_attrib.emulate_write_cache);
 	return 0;
 }
@@ -1029,19 +1029,19 @@ int se_dev_set_emulate_write_cache(struct se_device *dev, int flag)
 int se_dev_set_emulate_ua_intlck_ctrl(struct se_device *dev, int flag)
 {
 	if ((flag != 0) && (flag != 1) && (flag != 2)) {
-		printk(KERN_ERR "Illegal value %d\n", flag);
+		pr_err("Illegal value %d\n", flag);
 		return -EINVAL;
 	}
 
 	if (atomic_read(&dev->dev_export_obj.obj_access_count)) {
-		printk(KERN_ERR "dev[%p]: Unable to change SE Device"
+		pr_err("dev[%p]: Unable to change SE Device"
 			" UA_INTRLCK_CTRL while dev_export_obj: %d count"
 			" exists\n", dev,
 			atomic_read(&dev->dev_export_obj.obj_access_count));
 		return -EINVAL;
 	}
 	dev->se_sub_dev->se_dev_attrib.emulate_ua_intlck_ctrl = flag;
-	printk(KERN_INFO "dev[%p]: SE Device UA_INTRLCK_CTRL flag: %d\n",
+	pr_debug("dev[%p]: SE Device UA_INTRLCK_CTRL flag: %d\n",
 		dev, dev->se_sub_dev->se_dev_attrib.emulate_ua_intlck_ctrl);
 
 	return 0;
@@ -1050,18 +1050,18 @@ int se_dev_set_emulate_ua_intlck_ctrl(struct se_device *dev, int flag)
 int se_dev_set_emulate_tas(struct se_device *dev, int flag)
 {
 	if ((flag != 0) && (flag != 1)) {
-		printk(KERN_ERR "Illegal value %d\n", flag);
+		pr_err("Illegal value %d\n", flag);
 		return -EINVAL;
 	}
 
 	if (atomic_read(&dev->dev_export_obj.obj_access_count)) {
-		printk(KERN_ERR "dev[%p]: Unable to change SE Device TAS while"
+		pr_err("dev[%p]: Unable to change SE Device TAS while"
 			" dev_export_obj: %d count exists\n", dev,
 			atomic_read(&dev->dev_export_obj.obj_access_count));
 		return -EINVAL;
 	}
 	dev->se_sub_dev->se_dev_attrib.emulate_tas = flag;
-	printk(KERN_INFO "dev[%p]: SE Device TASK_ABORTED status bit: %s\n",
+	pr_debug("dev[%p]: SE Device TASK_ABORTED status bit: %s\n",
 		dev, (dev->se_sub_dev->se_dev_attrib.emulate_tas) ? "Enabled" : "Disabled");
 
 	return 0;
@@ -1070,7 +1070,7 @@ int se_dev_set_emulate_tas(struct se_device *dev, int flag)
 int se_dev_set_emulate_tpu(struct se_device *dev, int flag)
 {
 	if ((flag != 0) && (flag != 1)) {
-		printk(KERN_ERR "Illegal value %d\n", flag);
+		pr_err("Illegal value %d\n", flag);
 		return -EINVAL;
 	}
 	/*
@@ -1078,12 +1078,12 @@ int se_dev_set_emulate_tpu(struct se_device *dev, int flag)
 	 * Discard supported is detected iblock_create_virtdevice().
 	 */
 	if (!(dev->se_sub_dev->se_dev_attrib.max_unmap_block_desc_count)) {
-		printk(KERN_ERR "Generic Block Discard not supported\n");
+		pr_err("Generic Block Discard not supported\n");
 		return -ENOSYS;
 	}
 
 	dev->se_sub_dev->se_dev_attrib.emulate_tpu = flag;
-	printk(KERN_INFO "dev[%p]: SE Device Thin Provisioning UNMAP bit: %d\n",
+	pr_debug("dev[%p]: SE Device Thin Provisioning UNMAP bit: %d\n",
 				dev, flag);
 	return 0;
 }
@@ -1091,7 +1091,7 @@ int se_dev_set_emulate_tpu(struct se_device *dev, int flag)
 int se_dev_set_emulate_tpws(struct se_device *dev, int flag)
 {
 	if ((flag != 0) && (flag != 1)) {
-		printk(KERN_ERR "Illegal value %d\n", flag);
+		pr_err("Illegal value %d\n", flag);
 		return -EINVAL;
 	}
 	/*
@@ -1099,12 +1099,12 @@ int se_dev_set_emulate_tpws(struct se_device *dev, int flag)
 	 * Discard supported is detected iblock_create_virtdevice().
 	 */
 	if (!(dev->se_sub_dev->se_dev_attrib.max_unmap_block_desc_count)) {
-		printk(KERN_ERR "Generic Block Discard not supported\n");
+		pr_err("Generic Block Discard not supported\n");
 		return -ENOSYS;
 	}
 
 	dev->se_sub_dev->se_dev_attrib.emulate_tpws = flag;
-	printk(KERN_INFO "dev[%p]: SE Device Thin Provisioning WRITE_SAME: %d\n",
+	pr_debug("dev[%p]: SE Device Thin Provisioning WRITE_SAME: %d\n",
 				dev, flag);
 	return 0;
 }
@@ -1112,11 +1112,11 @@ int se_dev_set_emulate_tpws(struct se_device *dev, int flag)
 int se_dev_set_enforce_pr_isids(struct se_device *dev, int flag)
 {
 	if ((flag != 0) && (flag != 1)) {
-		printk(KERN_ERR "Illegal value %d\n", flag);
+		pr_err("Illegal value %d\n", flag);
 		return -EINVAL;
 	}
 	dev->se_sub_dev->se_dev_attrib.enforce_pr_isids = flag;
-	printk(KERN_INFO "dev[%p]: SE Device enforce_pr_isids bit: %s\n", dev,
+	pr_debug("dev[%p]: SE Device enforce_pr_isids bit: %s\n", dev,
 		(dev->se_sub_dev->se_dev_attrib.enforce_pr_isids) ? "Enabled" : "Disabled");
 	return 0;
 }
@@ -1129,20 +1129,20 @@ int se_dev_set_queue_depth(struct se_device *dev, u32 queue_depth)
 	u32 orig_queue_depth = dev->queue_depth;
 
 	if (atomic_read(&dev->dev_export_obj.obj_access_count)) {
-		printk(KERN_ERR "dev[%p]: Unable to change SE Device TCQ while"
+		pr_err("dev[%p]: Unable to change SE Device TCQ while"
 			" dev_export_obj: %d count exists\n", dev,
 			atomic_read(&dev->dev_export_obj.obj_access_count));
 		return -EINVAL;
 	}
 	if (!(queue_depth)) {
-		printk(KERN_ERR "dev[%p]: Illegal ZERO value for queue"
+		pr_err("dev[%p]: Illegal ZERO value for queue"
 			"_depth\n", dev);
 		return -EINVAL;
 	}
 
 	if (dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) {
 		if (queue_depth > dev->se_sub_dev->se_dev_attrib.hw_queue_depth) {
-			printk(KERN_ERR "dev[%p]: Passed queue_depth: %u"
+			pr_err("dev[%p]: Passed queue_depth: %u"
 				" exceeds TCM/SE_Device TCQ: %u\n",
 				dev, queue_depth,
 				dev->se_sub_dev->se_dev_attrib.hw_queue_depth);
@@ -1151,7 +1151,7 @@ int se_dev_set_queue_depth(struct se_device *dev, u32 queue_depth)
 	} else {
 		if (queue_depth > dev->se_sub_dev->se_dev_attrib.queue_depth) {
 			if (queue_depth > dev->se_sub_dev->se_dev_attrib.hw_queue_depth) {
-				printk(KERN_ERR "dev[%p]: Passed queue_depth:"
+				pr_err("dev[%p]: Passed queue_depth:"
 					" %u exceeds TCM/SE_Device MAX"
 					" TCQ: %u\n", dev, queue_depth,
 					dev->se_sub_dev->se_dev_attrib.hw_queue_depth);
@@ -1166,7 +1166,7 @@ int se_dev_set_queue_depth(struct se_device *dev, u32 queue_depth)
 	else if (queue_depth < orig_queue_depth)
 		atomic_sub(orig_queue_depth - queue_depth, &dev->depth_left);
 
-	printk(KERN_INFO "dev[%p]: SE Device TCQ Depth changed to: %u\n",
+	pr_debug("dev[%p]: SE Device TCQ Depth changed to: %u\n",
 			dev, queue_depth);
 	return 0;
 }
@@ -1176,25 +1176,25 @@ int se_dev_set_max_sectors(struct se_device *dev, u32 max_sectors)
 	int force = 0; /* Force setting for VDEVS */
 
 	if (atomic_read(&dev->dev_export_obj.obj_access_count)) {
-		printk(KERN_ERR "dev[%p]: Unable to change SE Device"
+		pr_err("dev[%p]: Unable to change SE Device"
 			" max_sectors while dev_export_obj: %d count exists\n",
 			dev, atomic_read(&dev->dev_export_obj.obj_access_count));
 		return -EINVAL;
 	}
 	if (!(max_sectors)) {
-		printk(KERN_ERR "dev[%p]: Illegal ZERO value for"
+		pr_err("dev[%p]: Illegal ZERO value for"
 			" max_sectors\n", dev);
 		return -EINVAL;
 	}
 	if (max_sectors < DA_STATUS_MAX_SECTORS_MIN) {
-		printk(KERN_ERR "dev[%p]: Passed max_sectors: %u less than"
+		pr_err("dev[%p]: Passed max_sectors: %u less than"
 			" DA_STATUS_MAX_SECTORS_MIN: %u\n", dev, max_sectors,
 				DA_STATUS_MAX_SECTORS_MIN);
 		return -EINVAL;
 	}
 	if (dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) {
 		if (max_sectors > dev->se_sub_dev->se_dev_attrib.hw_max_sectors) {
-			printk(KERN_ERR "dev[%p]: Passed max_sectors: %u"
+			pr_err("dev[%p]: Passed max_sectors: %u"
 				" greater than TCM/SE_Device max_sectors:"
 				" %u\n", dev, max_sectors,
 				dev->se_sub_dev->se_dev_attrib.hw_max_sectors);
@@ -1203,14 +1203,14 @@ int se_dev_set_max_sectors(struct se_device *dev, u32 max_sectors)
 	} else {
 		if (!(force) && (max_sectors >
 				 dev->se_sub_dev->se_dev_attrib.hw_max_sectors)) {
-			printk(KERN_ERR "dev[%p]: Passed max_sectors: %u"
+			pr_err("dev[%p]: Passed max_sectors: %u"
 				" greater than TCM/SE_Device max_sectors"
 				": %u, use force=1 to override.\n", dev,
 				max_sectors, dev->se_sub_dev->se_dev_attrib.hw_max_sectors);
 			return -EINVAL;
 		}
 		if (max_sectors > DA_STATUS_MAX_SECTORS_MAX) {
-			printk(KERN_ERR "dev[%p]: Passed max_sectors: %u"
+			pr_err("dev[%p]: Passed max_sectors: %u"
 				" greater than DA_STATUS_MAX_SECTORS_MAX:"
 				" %u\n", dev, max_sectors,
 				DA_STATUS_MAX_SECTORS_MAX);
@@ -1219,7 +1219,7 @@ int se_dev_set_max_sectors(struct se_device *dev, u32 max_sectors)
 	}
 
 	dev->se_sub_dev->se_dev_attrib.max_sectors = max_sectors;
-	printk("dev[%p]: SE Device max_sectors changed to %u\n",
+	pr_debug("dev[%p]: SE Device max_sectors changed to %u\n",
 			dev, max_sectors);
 	return 0;
 }
@@ -1227,25 +1227,25 @@ int se_dev_set_max_sectors(struct se_device *dev, u32 max_sectors)
 int se_dev_set_optimal_sectors(struct se_device *dev, u32 optimal_sectors)
 {
 	if (atomic_read(&dev->dev_export_obj.obj_access_count)) {
-		printk(KERN_ERR "dev[%p]: Unable to change SE Device"
+		pr_err("dev[%p]: Unable to change SE Device"
 			" optimal_sectors while dev_export_obj: %d count exists\n",
 			dev, atomic_read(&dev->dev_export_obj.obj_access_count));
 		return -EINVAL;
 	}
 	if (dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) {
-		printk(KERN_ERR "dev[%p]: Passed optimal_sectors cannot be"
+		pr_err("dev[%p]: Passed optimal_sectors cannot be"
 				" changed for TCM/pSCSI\n", dev);
 		return -EINVAL;
 	}
 	if (optimal_sectors > dev->se_sub_dev->se_dev_attrib.max_sectors) {
-		printk(KERN_ERR "dev[%p]: Passed optimal_sectors %u cannot be"
+		pr_err("dev[%p]: Passed optimal_sectors %u cannot be"
 			" greater than max_sectors: %u\n", dev,
 			optimal_sectors, dev->se_sub_dev->se_dev_attrib.max_sectors);
 		return -EINVAL;
 	}
 
 	dev->se_sub_dev->se_dev_attrib.optimal_sectors = optimal_sectors;
-	printk(KERN_INFO "dev[%p]: SE Device optimal_sectors changed to %u\n",
+	pr_debug("dev[%p]: SE Device optimal_sectors changed to %u\n",
 			dev, optimal_sectors);
 	return 0;
 }
@@ -1253,7 +1253,7 @@ int se_dev_set_optimal_sectors(struct se_device *dev, u32 optimal_sectors)
 int se_dev_set_block_size(struct se_device *dev, u32 block_size)
 {
 	if (atomic_read(&dev->dev_export_obj.obj_access_count)) {
-		printk(KERN_ERR "dev[%p]: Unable to change SE Device block_size"
+		pr_err("dev[%p]: Unable to change SE Device block_size"
 			" while dev_export_obj: %d count exists\n", dev,
 			atomic_read(&dev->dev_export_obj.obj_access_count));
 		return -EINVAL;
@@ -1263,21 +1263,21 @@ int se_dev_set_block_size(struct se_device *dev, u32 block_size)
 	    (block_size != 1024) &&
 	    (block_size != 2048) &&
 	    (block_size != 4096)) {
-		printk(KERN_ERR "dev[%p]: Illegal value for block_device: %u"
+		pr_err("dev[%p]: Illegal value for block_device: %u"
 			" for SE device, must be 512, 1024, 2048 or 4096\n",
 			dev, block_size);
 		return -EINVAL;
 	}
 
 	if (dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) {
-		printk(KERN_ERR "dev[%p]: Not allowed to change block_size for"
+		pr_err("dev[%p]: Not allowed to change block_size for"
 			" Physical Device, use for Linux/SCSI to change"
 			" block_size for underlying hardware\n", dev);
 		return -EINVAL;
 	}
 
 	dev->se_sub_dev->se_dev_attrib.block_size = block_size;
-	printk(KERN_INFO "dev[%p]: SE Device block_size changed to %u\n",
+	pr_debug("dev[%p]: SE Device block_size changed to %u\n",
 			dev, block_size);
 	return 0;
 }
@@ -1292,7 +1292,7 @@ struct se_lun *core_dev_add_lun(
 	u32 lun_access = 0;
 
 	if (atomic_read(&dev->dev_access_obj.obj_access_count) != 0) {
-		printk(KERN_ERR "Unable to export struct se_device while dev_access_obj: %d\n",
+		pr_err("Unable to export struct se_device while dev_access_obj: %d\n",
 			atomic_read(&dev->dev_access_obj.obj_access_count));
 		return NULL;
 	}
@@ -1309,7 +1309,7 @@ struct se_lun *core_dev_add_lun(
 	if (core_tpg_post_addlun(tpg, lun_p, lun_access, dev) < 0)
 		return NULL;
 
-	printk(KERN_INFO "%s_TPG[%u]_LUN[%u] - Activated %s Logical Unit from"
+	pr_debug("%s_TPG[%u]_LUN[%u] - Activated %s Logical Unit from"
 		" CORE HBA: %u\n", tpg->se_tpg_tfo->get_fabric_name(),
 		tpg->se_tpg_tfo->tpg_get_tag(tpg), lun_p->unpacked_lun,
 		tpg->se_tpg_tfo->get_fabric_name(), hba->hba_id);
@@ -1350,7 +1350,7 @@ int core_dev_del_lun(
 
 	core_tpg_post_dellun(tpg, lun);
 
-	printk(KERN_INFO "%s_TPG[%u]_LUN[%u] - Deactivated %s Logical Unit from"
+	pr_debug("%s_TPG[%u]_LUN[%u] - Deactivated %s Logical Unit from"
 		" device object\n", tpg->se_tpg_tfo->get_fabric_name(),
 		tpg->se_tpg_tfo->tpg_get_tag(tpg), unpacked_lun,
 		tpg->se_tpg_tfo->get_fabric_name());
@@ -1364,7 +1364,7 @@ struct se_lun *core_get_lun_from_tpg(struct se_portal_group *tpg, u32 unpacked_l
 
 	spin_lock(&tpg->tpg_lun_lock);
 	if (unpacked_lun > (TRANSPORT_MAX_LUNS_PER_TPG-1)) {
-		printk(KERN_ERR "%s LUN: %u exceeds TRANSPORT_MAX_LUNS"
+		pr_err("%s LUN: %u exceeds TRANSPORT_MAX_LUNS"
 			"_PER_TPG-1: %u for Target Portal Group: %hu\n",
 			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
 			TRANSPORT_MAX_LUNS_PER_TPG-1,
@@ -1375,7 +1375,7 @@ struct se_lun *core_get_lun_from_tpg(struct se_portal_group *tpg, u32 unpacked_l
 	lun = &tpg->tpg_lun_list[unpacked_lun];
 
 	if (lun->lun_status != TRANSPORT_LUN_STATUS_FREE) {
-		printk(KERN_ERR "%s Logical Unit Number: %u is not free on"
+		pr_err("%s Logical Unit Number: %u is not free on"
 			" Target Portal Group: %hu, ignoring request.\n",
 			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
 			tpg->se_tpg_tfo->tpg_get_tag(tpg));
@@ -1397,7 +1397,7 @@ static struct se_lun *core_dev_get_lun(struct se_portal_group *tpg, u32 unpacked
 
 	spin_lock(&tpg->tpg_lun_lock);
 	if (unpacked_lun > (TRANSPORT_MAX_LUNS_PER_TPG-1)) {
-		printk(KERN_ERR "%s LUN: %u exceeds TRANSPORT_MAX_LUNS_PER"
+		pr_err("%s LUN: %u exceeds TRANSPORT_MAX_LUNS_PER"
 			"_TPG-1: %u for Target Portal Group: %hu\n",
 			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
 			TRANSPORT_MAX_LUNS_PER_TPG-1,
@@ -1408,7 +1408,7 @@ static struct se_lun *core_dev_get_lun(struct se_portal_group *tpg, u32 unpacked
 	lun = &tpg->tpg_lun_list[unpacked_lun];
 
 	if (lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE) {
-		printk(KERN_ERR "%s Logical Unit Number: %u is not active on"
+		pr_err("%s Logical Unit Number: %u is not active on"
 			" Target Portal Group: %hu, ignoring request.\n",
 			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
 			tpg->se_tpg_tfo->tpg_get_tag(tpg));
@@ -1430,7 +1430,7 @@ struct se_lun_acl *core_dev_init_initiator_node_lun_acl(
 	struct se_node_acl *nacl;
 
 	if (strlen(initiatorname) >= TRANSPORT_IQN_LEN) {
-		printk(KERN_ERR "%s InitiatorName exceeds maximum size.\n",
+		pr_err("%s InitiatorName exceeds maximum size.\n",
 			tpg->se_tpg_tfo->get_fabric_name());
 		*ret = -EOVERFLOW;
 		return NULL;
@@ -1442,7 +1442,7 @@ struct se_lun_acl *core_dev_init_initiator_node_lun_acl(
 	}
 	lacl = kzalloc(sizeof(struct se_lun_acl), GFP_KERNEL);
 	if (!(lacl)) {
-		printk(KERN_ERR "Unable to allocate memory for struct se_lun_acl.\n");
+		pr_err("Unable to allocate memory for struct se_lun_acl.\n");
 		*ret = -ENOMEM;
 		return NULL;
 	}
@@ -1466,7 +1466,7 @@ int core_dev_add_initiator_node_lun_acl(
 
 	lun = core_dev_get_lun(tpg, unpacked_lun);
 	if (!(lun)) {
-		printk(KERN_ERR "%s Logical Unit Number: %u is not active on"
+		pr_err("%s Logical Unit Number: %u is not active on"
 			" Target Portal Group: %hu, ignoring request.\n",
 			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
 			tpg->se_tpg_tfo->tpg_get_tag(tpg));
@@ -1493,7 +1493,7 @@ int core_dev_add_initiator_node_lun_acl(
 	smp_mb__after_atomic_inc();
 	spin_unlock(&lun->lun_acl_lock);
 
-	printk(KERN_INFO "%s_TPG[%hu]_LUN[%u->%u] - Added %s ACL for "
+	pr_debug("%s_TPG[%hu]_LUN[%u->%u] - Added %s ACL for "
 		" InitiatorNode: %s\n", tpg->se_tpg_tfo->get_fabric_name(),
 		tpg->se_tpg_tfo->tpg_get_tag(tpg), unpacked_lun, lacl->mapped_lun,
 		(lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) ? "RW" : "RO",
@@ -1532,7 +1532,7 @@ int core_dev_del_initiator_node_lun_acl(
 
 	lacl->se_lun = NULL;
 
-	printk(KERN_INFO "%s_TPG[%hu]_LUN[%u] - Removed ACL for"
+	pr_debug("%s_TPG[%hu]_LUN[%u] - Removed ACL for"
 		" InitiatorNode: %s Mapped LUN: %u\n",
 		tpg->se_tpg_tfo->get_fabric_name(),
 		tpg->se_tpg_tfo->tpg_get_tag(tpg), lun->unpacked_lun,
@@ -1545,7 +1545,7 @@ void core_dev_free_initiator_node_lun_acl(
 	struct se_portal_group *tpg,
 	struct se_lun_acl *lacl)
 {
-	printk("%s_TPG[%hu] - Freeing ACL for %s InitiatorNode: %s"
+	pr_debug("%s_TPG[%hu] - Freeing ACL for %s InitiatorNode: %s"
 		" Mapped LUN: %u\n", tpg->se_tpg_tfo->get_fabric_name(),
 		tpg->se_tpg_tfo->tpg_get_tag(tpg),
 		tpg->se_tpg_tfo->get_fabric_name(),
@@ -1572,7 +1572,7 @@ int core_dev_setup_virtual_lun0(void)
 
 	se_dev = kzalloc(sizeof(struct se_subsystem_dev), GFP_KERNEL);
 	if (!(se_dev)) {
-		printk(KERN_ERR "Unable to allocate memory for"
+		pr_err("Unable to allocate memory for"
 				" struct se_subsystem_dev\n");
 		ret = -ENOMEM;
 		goto out;
@@ -1595,7 +1595,7 @@ int core_dev_setup_virtual_lun0(void)
 
 	se_dev->se_dev_su_ptr = t->allocate_virtdevice(hba, "virt_lun0");
 	if (!(se_dev->se_dev_su_ptr)) {
-		printk(KERN_ERR "Unable to locate subsystem dependent pointer"
+		pr_err("Unable to locate subsystem dependent pointer"
 			" from allocate_virtdevice()\n");
 		ret = -ENOMEM;
 		goto out;
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 9183c86..38aec62 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -60,7 +60,7 @@ static void target_fabric_setup_##_name##_cit(struct target_fabric_configfs *tf)
 	cit->ct_group_ops = _group_ops;					\
 	cit->ct_attrs = _attrs;						\
 	cit->ct_owner = tf->tf_module;					\
-	printk("Setup generic %s\n", __stringify(_name));		\
+	pr_debug("Setup generic %s\n", __stringify(_name));		\
 }
 
 /* Start of tfc_tpg_mappedlun_cit */
@@ -81,7 +81,7 @@ static int target_fabric_mappedlun_link(
 	 * Ensure that the source port exists
 	 */
 	if (!(lun->lun_sep) || !(lun->lun_sep->sep_tpg)) {
-		printk(KERN_ERR "Source se_lun->lun_sep or lun->lun_sep->sep"
+		pr_err("Source se_lun->lun_sep or lun->lun_sep->sep"
 				"_tpg does not exist\n");
 		return -EINVAL;
 	}
@@ -96,12 +96,12 @@ static int target_fabric_mappedlun_link(
 	 * Make sure the SymLink is going to the same $FABRIC/$WWN/tpgt_$TPGT
 	 */
 	if (strcmp(config_item_name(wwn_ci), config_item_name(wwn_ci_s))) {
-		printk(KERN_ERR "Illegal Initiator ACL SymLink outside of %s\n",
+		pr_err("Illegal Initiator ACL SymLink outside of %s\n",
 			config_item_name(wwn_ci));
 		return -EINVAL;
 	}
 	if (strcmp(config_item_name(tpg_ci), config_item_name(tpg_ci_s))) {
-		printk(KERN_ERR "Illegal Initiator ACL Symlink outside of %s"
+		pr_err("Illegal Initiator ACL Symlink outside of %s"
 			" TPGT: %s\n", config_item_name(wwn_ci),
 			config_item_name(tpg_ci));
 		return -EINVAL;
@@ -202,7 +202,7 @@ static ssize_t target_fabric_mappedlun_store_write_protect(
 			TRANSPORT_LUNFLAGS_READ_WRITE,
 			lacl->se_lun_nacl);
 
-	printk(KERN_INFO "%s_ConfigFS: Changed Initiator ACL: %s"
+	pr_debug("%s_ConfigFS: Changed Initiator ACL: %s"
 		" Mapped LUN: %u Write Protect bit to %s\n",
 		se_tpg->se_tpg_tfo->get_fabric_name(),
 		lacl->initiatorname, lacl->mapped_lun, (op) ? "ON" : "OFF");
@@ -328,13 +328,13 @@ static struct config_group *target_fabric_make_mappedlun(
 
 	acl_ci = &group->cg_item;
 	if (!(acl_ci)) {
-		printk(KERN_ERR "Unable to locatel acl_ci\n");
+		pr_err("Unable to locatel acl_ci\n");
 		return NULL;
 	}
 
 	buf = kzalloc(strlen(name) + 1, GFP_KERNEL);
 	if (!(buf)) {
-		printk(KERN_ERR "Unable to allocate memory for name buf\n");
+		pr_err("Unable to allocate memory for name buf\n");
 		return ERR_PTR(-ENOMEM);
 	}
 	snprintf(buf, strlen(name) + 1, "%s", name);
@@ -342,7 +342,7 @@ static struct config_group *target_fabric_make_mappedlun(
 	 * Make sure user is creating iscsi/$IQN/$TPGT/acls/$INITIATOR/lun_$ID.
 	 */
 	if (strstr(buf, "lun_") != buf) {
-		printk(KERN_ERR "Unable to locate \"lun_\" from buf: %s"
+		pr_err("Unable to locate \"lun_\" from buf: %s"
 			" name: %s\n", buf, name);
 		ret = -EINVAL;
 		goto out;
@@ -367,7 +367,7 @@ static struct config_group *target_fabric_make_mappedlun(
 	lacl_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
 				GFP_KERNEL);
 	if (!lacl_cg->default_groups) {
-		printk(KERN_ERR "Unable to allocate lacl_cg->default_groups\n");
+		pr_err("Unable to allocate lacl_cg->default_groups\n");
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -383,7 +383,7 @@ static struct config_group *target_fabric_make_mappedlun(
 	ml_stat_grp->default_groups = kzalloc(sizeof(struct config_group) * 3,
 				GFP_KERNEL);
 	if (!ml_stat_grp->default_groups) {
-		printk(KERN_ERR "Unable to allocate ml_stat_grp->default_groups\n");
+		pr_err("Unable to allocate ml_stat_grp->default_groups\n");
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -477,7 +477,7 @@ static struct config_group *target_fabric_make_nodeacl(
 	struct config_group *nacl_cg;
 
 	if (!(tf->tf_ops.fabric_make_nodeacl)) {
-		printk(KERN_ERR "tf->tf_ops.fabric_make_nodeacl is NULL\n");
+		pr_err("tf->tf_ops.fabric_make_nodeacl is NULL\n");
 		return ERR_PTR(-ENOSYS);
 	}
 
@@ -575,7 +575,7 @@ static struct config_group *target_fabric_make_np(
 	struct se_tpg_np *se_tpg_np;
 
 	if (!(tf->tf_ops.fabric_make_np)) {
-		printk(KERN_ERR "tf->tf_ops.fabric_make_np is NULL\n");
+		pr_err("tf->tf_ops.fabric_make_np is NULL\n");
 		return ERR_PTR(-ENOSYS);
 	}
 
@@ -783,13 +783,13 @@ static int target_fabric_port_link(
 	tf = se_tpg->se_tpg_wwn->wwn_tf;
 
 	if (lun->lun_se_dev !=  NULL) {
-		printk(KERN_ERR "Port Symlink already exists\n");
+		pr_err("Port Symlink already exists\n");
 		return -EEXIST;
 	}
 
 	dev = se_dev->se_dev_ptr;
 	if (!(dev)) {
-		printk(KERN_ERR "Unable to locate struct se_device pointer from"
+		pr_err("Unable to locate struct se_device pointer from"
 			" %s\n", config_item_name(se_dev_ci));
 		ret = -ENODEV;
 		goto out;
@@ -798,7 +798,7 @@ static int target_fabric_port_link(
 	lun_p = core_dev_add_lun(se_tpg, dev->se_hba, dev,
 				lun->unpacked_lun);
 	if ((IS_ERR(lun_p)) || !(lun_p)) {
-		printk(KERN_ERR "core_dev_add_lun() failed\n");
+		pr_err("core_dev_add_lun() failed\n");
 		ret = -EINVAL;
 		goto out;
 	}
@@ -890,7 +890,7 @@ static struct config_group *target_fabric_make_lun(
 	int errno;
 
 	if (strstr(name, "lun_") != name) {
-		printk(KERN_ERR "Unable to locate \'_\" in"
+		pr_err("Unable to locate \'_\" in"
 				" \"lun_$LUN_NUMBER\"\n");
 		return ERR_PTR(-EINVAL);
 	}
@@ -905,7 +905,7 @@ static struct config_group *target_fabric_make_lun(
 	lun_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
 				GFP_KERNEL);
 	if (!lun_cg->default_groups) {
-		printk(KERN_ERR "Unable to allocate lun_cg->default_groups\n");
+		pr_err("Unable to allocate lun_cg->default_groups\n");
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -920,7 +920,7 @@ static struct config_group *target_fabric_make_lun(
 	port_stat_grp->default_groups =  kzalloc(sizeof(struct config_group) * 3,
 				GFP_KERNEL);
 	if (!port_stat_grp->default_groups) {
-		printk(KERN_ERR "Unable to allocate port_stat_grp->default_groups\n");
+		pr_err("Unable to allocate port_stat_grp->default_groups\n");
 		errno = -ENOMEM;
 		goto out;
 	}
@@ -1034,7 +1034,7 @@ static struct config_group *target_fabric_make_tpg(
 	struct se_portal_group *se_tpg;
 
 	if (!(tf->tf_ops.fabric_make_tpg)) {
-		printk(KERN_ERR "tf->tf_ops.fabric_make_tpg is NULL\n");
+		pr_err("tf->tf_ops.fabric_make_tpg is NULL\n");
 		return ERR_PTR(-ENOSYS);
 	}
 
@@ -1133,7 +1133,7 @@ static struct config_group *target_fabric_make_wwn(
 	struct se_wwn *wwn;
 
 	if (!(tf->tf_ops.fabric_make_wwn)) {
-		printk(KERN_ERR "tf->tf_ops.fabric_make_wwn is NULL\n");
+		pr_err("tf->tf_ops.fabric_make_wwn is NULL\n");
 		return ERR_PTR(-ENOSYS);
 	}
 
diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 1e193f3..ec40a33 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -386,7 +386,7 @@ char *iscsi_parse_pr_out_transport_id(
 	 *            Reserved
 	 */
 	if ((format_code != 0x00) && (format_code != 0x40)) {
-		printk(KERN_ERR "Illegal format code: 0x%02x for iSCSI"
+		pr_err("Illegal format code: 0x%02x for iSCSI"
 			" Initiator Transport ID\n", format_code);
 		return NULL;
 	}
@@ -406,7 +406,7 @@ char *iscsi_parse_pr_out_transport_id(
 			tid_len += padding;
 
 		if ((add_len + 4) != tid_len) {
-			printk(KERN_INFO "LIO-Target Extracted add_len: %hu "
+			pr_debug("LIO-Target Extracted add_len: %hu "
 				"does not match calculated tid_len: %u,"
 				" using tid_len instead\n", add_len+4, tid_len);
 			*out_tid_len = tid_len;
@@ -421,7 +421,7 @@ char *iscsi_parse_pr_out_transport_id(
 	if (format_code == 0x40) {
 		p = strstr((char *)&buf[4], ",i,0x");
 		if (!(p)) {
-			printk(KERN_ERR "Unable to locate \",i,0x\" seperator"
+			pr_err("Unable to locate \",i,0x\" seperator"
 				" for Initiator port identifier: %s\n",
 				(char *)&buf[4]);
 			return NULL;
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 55c7de6..a3d72ff 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -42,18 +42,6 @@
 
 #include "target_core_file.h"
 
-#if 1
-#define DEBUG_FD_CACHE(x...) printk(x)
-#else
-#define DEBUG_FD_CACHE(x...)
-#endif
-
-#if 1
-#define DEBUG_FD_FUA(x...) printk(x)
-#else
-#define DEBUG_FD_FUA(x...)
-#endif
-
 static struct se_subsystem_api fileio_template;
 
 /*	fd_attach_hba(): (Part of se_subsystem_api_t template)
@@ -66,7 +54,7 @@ static int fd_attach_hba(struct se_hba *hba, u32 host_id)
 
 	fd_host = kzalloc(sizeof(struct fd_host), GFP_KERNEL);
 	if (!(fd_host)) {
-		printk(KERN_ERR "Unable to allocate memory for struct fd_host\n");
+		pr_err("Unable to allocate memory for struct fd_host\n");
 		return -ENOMEM;
 	}
 
@@ -74,10 +62,10 @@ static int fd_attach_hba(struct se_hba *hba, u32 host_id)
 
 	hba->hba_ptr = fd_host;
 
-	printk(KERN_INFO "CORE_HBA[%d] - TCM FILEIO HBA Driver %s on Generic"
+	pr_debug("CORE_HBA[%d] - TCM FILEIO HBA Driver %s on Generic"
 		" Target Core Stack %s\n", hba->hba_id, FD_VERSION,
 		TARGET_CORE_MOD_VERSION);
-	printk(KERN_INFO "CORE_HBA[%d] - Attached FILEIO HBA: %u to Generic"
+	pr_debug("CORE_HBA[%d] - Attached FILEIO HBA: %u to Generic"
 		" MaxSectors: %u\n",
 		hba->hba_id, fd_host->fd_host_id, FD_MAX_SECTORS);
 
@@ -88,7 +76,7 @@ static void fd_detach_hba(struct se_hba *hba)
 {
 	struct fd_host *fd_host = hba->hba_ptr;
 
-	printk(KERN_INFO "CORE_HBA[%d] - Detached FILEIO HBA: %u from Generic"
+	pr_debug("CORE_HBA[%d] - Detached FILEIO HBA: %u from Generic"
 		" Target Core\n", hba->hba_id, fd_host->fd_host_id);
 
 	kfree(fd_host);
@@ -102,13 +90,13 @@ static void *fd_allocate_virtdevice(struct se_hba *hba, const char *name)
 
 	fd_dev = kzalloc(sizeof(struct fd_dev), GFP_KERNEL);
 	if (!(fd_dev)) {
-		printk(KERN_ERR "Unable to allocate memory for struct fd_dev\n");
+		pr_err("Unable to allocate memory for struct fd_dev\n");
 		return NULL;
 	}
 
 	fd_dev->fd_host = fd_host;
 
-	printk(KERN_INFO "FILEIO: Allocated fd_dev for %p\n", name);
+	pr_debug("FILEIO: Allocated fd_dev for %p\n", name);
 
 	return fd_dev;
 }
@@ -141,7 +129,7 @@ static struct se_device *fd_create_virtdevice(
 	set_fs(old_fs);
 
 	if (IS_ERR(dev_p)) {
-		printk(KERN_ERR "getname(%s) failed: %lu\n",
+		pr_err("getname(%s) failed: %lu\n",
 			fd_dev->fd_dev_name, IS_ERR(dev_p));
 		ret = PTR_ERR(dev_p);
 		goto fail;
@@ -164,12 +152,12 @@ static struct se_device *fd_create_virtdevice(
 
 	file = filp_open(dev_p, flags, 0600);
 	if (IS_ERR(file)) {
-		printk(KERN_ERR "filp_open(%s) failed\n", dev_p);
+		pr_err("filp_open(%s) failed\n", dev_p);
 		ret = PTR_ERR(file);
 		goto fail;
 	}
 	if (!file || !file->f_dentry) {
-		printk(KERN_ERR "filp_open(%s) failed\n", dev_p);
+		pr_err("filp_open(%s) failed\n", dev_p);
 		goto fail;
 	}
 	fd_dev->fd_file = file;
@@ -199,14 +187,14 @@ static struct se_device *fd_create_virtdevice(
 		fd_dev->fd_dev_size = (i_size_read(file->f_mapping->host) -
 				       fd_dev->fd_block_size);
 
-		printk(KERN_INFO "FILEIO: Using size: %llu bytes from struct"
+		pr_debug("FILEIO: Using size: %llu bytes from struct"
 			" block_device blocks: %llu logical_block_size: %d\n",
 			fd_dev->fd_dev_size,
 			div_u64(fd_dev->fd_dev_size, fd_dev->fd_block_size),
 			fd_dev->fd_block_size);
 	} else {
 		if (!(fd_dev->fbd_flags & FBDF_HAS_SIZE)) {
-			printk(KERN_ERR "FILEIO: Missing fd_dev_size="
+			pr_err("FILEIO: Missing fd_dev_size="
 				" parameter, and no backing struct"
 				" block_device\n");
 			goto fail;
@@ -231,7 +219,7 @@ static struct se_device *fd_create_virtdevice(
 	fd_dev->fd_dev_id = fd_host->fd_host_dev_id_count++;
 	fd_dev->fd_queue_depth = dev->queue_depth;
 
-	printk(KERN_INFO "CORE_FILE[%u] - Added TCM FILEIO Device ID: %u at %s,"
+	pr_debug("CORE_FILE[%u] - Added TCM FILEIO Device ID: %u at %s,"
 		" %llu total bytes\n", fd_host->fd_host_id, fd_dev->fd_dev_id,
 			fd_dev->fd_dev_name, fd_dev->fd_dev_size);
 
@@ -275,7 +263,7 @@ fd_alloc_task(struct se_cmd *cmd)
 
 	fd_req = kzalloc(sizeof(struct fd_request), GFP_KERNEL);
 	if (!(fd_req)) {
-		printk(KERN_ERR "Unable to allocate struct fd_request\n");
+		pr_err("Unable to allocate struct fd_request\n");
 		return NULL;
 	}
 
@@ -297,7 +285,7 @@ static int fd_do_readv(struct se_task *task)
 
 	iov = kzalloc(sizeof(struct iovec) * task->task_sg_nents, GFP_KERNEL);
 	if (!(iov)) {
-		printk(KERN_ERR "Unable to allocate fd_do_readv iov[]\n");
+		pr_err("Unable to allocate fd_do_readv iov[]\n");
 		return -ENOMEM;
 	}
 
@@ -319,14 +307,14 @@ static int fd_do_readv(struct se_task *task)
 	 */
 	if (S_ISBLK(fd->f_dentry->d_inode->i_mode)) {
 		if (ret < 0 || ret != task->task_size) {
-			printk(KERN_ERR "vfs_readv() returned %d,"
+			pr_err("vfs_readv() returned %d,"
 				" expecting %d for S_ISBLK\n", ret,
 				(int)task->task_size);
 			return (ret < 0 ? ret : -EINVAL);
 		}
 	} else {
 		if (ret < 0) {
-			printk(KERN_ERR "vfs_readv() returned %d for non"
+			pr_err("vfs_readv() returned %d for non"
 				" S_ISBLK\n", ret);
 			return ret;
 		}
@@ -348,7 +336,7 @@ static int fd_do_writev(struct se_task *task)
 
 	iov = kzalloc(sizeof(struct iovec) * task->task_sg_nents, GFP_KERNEL);
 	if (!(iov)) {
-		printk(KERN_ERR "Unable to allocate fd_do_writev iov[]\n");
+		pr_err("Unable to allocate fd_do_writev iov[]\n");
 		return -ENOMEM;
 	}
 
@@ -365,7 +353,7 @@ static int fd_do_writev(struct se_task *task)
 	kfree(iov);
 
 	if (ret < 0 || ret != task->task_size) {
-		printk(KERN_ERR "vfs_writev() returned %d\n", ret);
+		pr_err("vfs_writev() returned %d\n", ret);
 		return (ret < 0 ? ret : -EINVAL);
 	}
 
@@ -404,7 +392,7 @@ static void fd_emulate_sync_cache(struct se_task *task)
 
 	ret = vfs_fsync_range(fd_dev->fd_file, start, end, 1);
 	if (ret != 0)
-		printk(KERN_ERR "FILEIO: vfs_fsync_range() failed: %d\n", ret);
+		pr_err("FILEIO: vfs_fsync_range() failed: %d\n", ret);
 
 	if (!immed)
 		transport_complete_sync_cache(cmd, ret == 0);
@@ -449,12 +437,12 @@ static void fd_emulate_write_fua(struct se_cmd *cmd, struct se_task *task)
 	loff_t end = start + task->task_size;
 	int ret;
 
-	DEBUG_FD_CACHE("FILEIO: FUA WRITE LBA: %llu, bytes: %u\n",
+	pr_debug("FILEIO: FUA WRITE LBA: %llu, bytes: %u\n",
 			task->task_lba, task->task_size);
 
 	ret = vfs_fsync_range(fd_dev->fd_file, start, end, 1);
 	if (ret != 0)
-		printk(KERN_ERR "FILEIO: vfs_fsync_range() failed: %d\n", ret);
+		pr_err("FILEIO: vfs_fsync_range() failed: %d\n", ret);
 }
 
 static int fd_do_task(struct se_task *task)
@@ -548,7 +536,7 @@ static ssize_t fd_set_configfs_dev_params(
 			snprintf(fd_dev->fd_dev_name, FD_MAX_DEV_NAME,
 					"%s", arg_p);
 			kfree(arg_p);
-			printk(KERN_INFO "FILEIO: Referencing Path: %s\n",
+			pr_debug("FILEIO: Referencing Path: %s\n",
 					fd_dev->fd_dev_name);
 			fd_dev->fbd_flags |= FBDF_HAS_PATH;
 			break;
@@ -561,23 +549,23 @@ static ssize_t fd_set_configfs_dev_params(
 			ret = strict_strtoull(arg_p, 0, &fd_dev->fd_dev_size);
 			kfree(arg_p);
 			if (ret < 0) {
-				printk(KERN_ERR "strict_strtoull() failed for"
+				pr_err("strict_strtoull() failed for"
 						" fd_dev_size=\n");
 				goto out;
 			}
-			printk(KERN_INFO "FILEIO: Referencing Size: %llu"
+			pr_debug("FILEIO: Referencing Size: %llu"
 					" bytes\n", fd_dev->fd_dev_size);
 			fd_dev->fbd_flags |= FBDF_HAS_SIZE;
 			break;
 		case Opt_fd_buffered_io:
 			match_int(args, &arg);
 			if (arg != 1) {
-				printk(KERN_ERR "bogus fd_buffered_io=%d value\n", arg);
+				pr_err("bogus fd_buffered_io=%d value\n", arg);
 				ret = -EINVAL;
 				goto out;
 			}
 
-			printk(KERN_INFO "FILEIO: Using buffered I/O"
+			pr_debug("FILEIO: Using buffered I/O"
 				" operations for struct fd_dev\n");
 
 			fd_dev->fbd_flags |= FDBD_USE_BUFFERED_IO;
@@ -597,7 +585,7 @@ static ssize_t fd_check_configfs_dev_params(struct se_hba *hba, struct se_subsys
 	struct fd_dev *fd_dev = (struct fd_dev *) se_dev->se_dev_su_ptr;
 
 	if (!(fd_dev->fbd_flags & FBDF_HAS_PATH)) {
-		printk(KERN_ERR "Missing fd_dev_name=\n");
+		pr_err("Missing fd_dev_name=\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
index a83263d..9f133a8 100644
--- a/drivers/target/target_core_hba.c
+++ b/drivers/target/target_core_hba.c
@@ -60,7 +60,7 @@ int transport_subsystem_register(struct se_subsystem_api *sub_api)
 	mutex_lock(&subsystem_mutex);
 	list_for_each_entry(s, &subsystem_list, sub_api_list) {
 		if (!(strcmp(s->name, sub_api->name))) {
-			printk(KERN_ERR "%p is already registered with"
+			pr_err("%p is already registered with"
 				" duplicate name %s, unable to process"
 				" request\n", s, s->name);
 			mutex_unlock(&subsystem_mutex);
@@ -70,7 +70,7 @@ int transport_subsystem_register(struct se_subsystem_api *sub_api)
 	list_add_tail(&sub_api->sub_api_list, &subsystem_list);
 	mutex_unlock(&subsystem_mutex);
 
-	printk(KERN_INFO "TCM: Registered subsystem plugin: %s struct module:"
+	pr_debug("TCM: Registered subsystem plugin: %s struct module:"
 			" %p\n", sub_api->name, sub_api->owner);
 	return 0;
 }
@@ -110,7 +110,7 @@ core_alloc_hba(const char *plugin_name, u32 plugin_dep_id, u32 hba_flags)
 
 	hba = kzalloc(sizeof(*hba), GFP_KERNEL);
 	if (!hba) {
-		printk(KERN_ERR "Unable to allocate struct se_hba\n");
+		pr_err("Unable to allocate struct se_hba\n");
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -136,7 +136,7 @@ core_alloc_hba(const char *plugin_name, u32 plugin_dep_id, u32 hba_flags)
 	list_add_tail(&hba->hba_node, &hba_list);
 	spin_unlock(&hba_lock);
 
-	printk(KERN_INFO "CORE_HBA[%d] - Attached HBA to Generic Target"
+	pr_debug("CORE_HBA[%d] - Attached HBA to Generic Target"
 			" Core\n", hba->hba_id);
 
 	return hba;
@@ -162,7 +162,7 @@ core_delete_hba(struct se_hba *hba)
 	list_del(&hba->hba_node);
 	spin_unlock(&hba_lock);
 
-	printk(KERN_INFO "CORE_HBA[%d] - Detached HBA from Generic Target"
+	pr_debug("CORE_HBA[%d] - Detached HBA from Generic Target"
 			" Core\n", hba->hba_id);
 
 	if (hba->transport->owner)
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 86d2601..99f9e2f 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -47,12 +47,6 @@
 
 #include "target_core_iblock.h"
 
-#if 0
-#define DEBUG_IBLOCK(x...) printk(x)
-#else
-#define DEBUG_IBLOCK(x...)
-#endif
-
 static struct se_subsystem_api iblock_template;
 
 static void iblock_bio_done(struct bio *, int);
@@ -67,7 +61,7 @@ static int iblock_attach_hba(struct se_hba *hba, u32 host_id)
 
 	ib_host = kzalloc(sizeof(struct iblock_hba), GFP_KERNEL);
 	if (!(ib_host)) {
-		printk(KERN_ERR "Unable to allocate memory for"
+		pr_err("Unable to allocate memory for"
 				" struct iblock_hba\n");
 		return -ENOMEM;
 	}
@@ -76,11 +70,11 @@ static int iblock_attach_hba(struct se_hba *hba, u32 host_id)
 
 	hba->hba_ptr = ib_host;
 
-	printk(KERN_INFO "CORE_HBA[%d] - TCM iBlock HBA Driver %s on"
+	pr_debug("CORE_HBA[%d] - TCM iBlock HBA Driver %s on"
 		" Generic Target Core Stack %s\n", hba->hba_id,
 		IBLOCK_VERSION, TARGET_CORE_MOD_VERSION);
 
-	printk(KERN_INFO "CORE_HBA[%d] - Attached iBlock HBA: %u to Generic\n",
+	pr_debug("CORE_HBA[%d] - Attached iBlock HBA: %u to Generic\n",
 		hba->hba_id, ib_host->iblock_host_id);
 
 	return 0;
@@ -90,7 +84,7 @@ static void iblock_detach_hba(struct se_hba *hba)
 {
 	struct iblock_hba *ib_host = hba->hba_ptr;
 
-	printk(KERN_INFO "CORE_HBA[%d] - Detached iBlock HBA: %u from Generic"
+	pr_debug("CORE_HBA[%d] - Detached iBlock HBA: %u from Generic"
 		" Target Core\n", hba->hba_id, ib_host->iblock_host_id);
 
 	kfree(ib_host);
@@ -104,12 +98,12 @@ static void *iblock_allocate_virtdevice(struct se_hba *hba, const char *name)
 
 	ib_dev = kzalloc(sizeof(struct iblock_dev), GFP_KERNEL);
 	if (!(ib_dev)) {
-		printk(KERN_ERR "Unable to allocate struct iblock_dev\n");
+		pr_err("Unable to allocate struct iblock_dev\n");
 		return NULL;
 	}
 	ib_dev->ibd_host = ib_host;
 
-	printk(KERN_INFO  "IBLOCK: Allocated ib_dev for %s\n", name);
+	pr_debug( "IBLOCK: Allocated ib_dev for %s\n", name);
 
 	return ib_dev;
 }
@@ -129,7 +123,7 @@ static struct se_device *iblock_create_virtdevice(
 	int ret = -EINVAL;
 
 	if (!(ib_dev)) {
-		printk(KERN_ERR "Unable to locate struct iblock_dev parameter\n");
+		pr_err("Unable to locate struct iblock_dev parameter\n");
 		return ERR_PTR(ret);
 	}
 	memset(&dev_limits, 0, sizeof(struct se_dev_limits));
@@ -138,15 +132,15 @@ static struct se_device *iblock_create_virtdevice(
 	 */
 	ib_dev->ibd_bio_set = bioset_create(32, 64);
 	if (!(ib_dev->ibd_bio_set)) {
-		printk(KERN_ERR "IBLOCK: Unable to create bioset()\n");
+		pr_err("IBLOCK: Unable to create bioset()\n");
 		return ERR_PTR(-ENOMEM);
 	}
-	printk(KERN_INFO "IBLOCK: Created bio_set()\n");
+	pr_debug("IBLOCK: Created bio_set()\n");
 	/*
 	 * iblock_check_configfs_dev_params() ensures that ib_dev->ibd_udev_path
 	 * must already have been set in order for echo 1 > $HBA/$DEV/enable to run.
 	 */
-	printk(KERN_INFO  "IBLOCK: Claiming struct block_device: %s\n",
+	pr_debug( "IBLOCK: Claiming struct block_device: %s\n",
 			ib_dev->ibd_udev_path);
 
 	bd = blkdev_get_by_path(ib_dev->ibd_udev_path,
@@ -196,7 +190,7 @@ static struct se_device *iblock_create_virtdevice(
 		dev->se_sub_dev->se_dev_attrib.unmap_granularity_alignment =
 				q->limits.discard_alignment;
 
-		printk(KERN_INFO "IBLOCK: BLOCK Discard support available,"
+		pr_debug("IBLOCK: BLOCK Discard support available,"
 				" disabled by default\n");
 	}
 
@@ -236,7 +230,7 @@ iblock_alloc_task(struct se_cmd *cmd)
 
 	ib_req = kzalloc(sizeof(struct iblock_req), GFP_KERNEL);
 	if (!(ib_req)) {
-		printk(KERN_ERR "Unable to allocate memory for struct iblock_req\n");
+		pr_err("Unable to allocate memory for struct iblock_req\n");
 		return NULL;
 	}
 
@@ -348,7 +342,7 @@ static void iblock_emulate_sync_cache(struct se_task *task)
 	 */
 	ret = blkdev_issue_flush(ib_dev->ibd_bd, GFP_KERNEL, &error_sector);
 	if (ret != 0) {
-		printk(KERN_ERR "IBLOCK: block_issue_flush() failed: %d "
+		pr_err("IBLOCK: block_issue_flush() failed: %d "
 			" error_sector: %llu\n", ret,
 			(unsigned long long)error_sector);
 	}
@@ -412,8 +406,9 @@ static int iblock_do_task(struct se_task *task)
 	while (bio) {
 		nbio = bio->bi_next;
 		bio->bi_next = NULL;
-		DEBUG_IBLOCK("Calling submit_bio() task: %p bio: %p"
-			" bio->bi_sector: %llu\n", task, bio, bio->bi_sector);
+		pr_debug("Calling submit_bio() task: %p bio: %p"
+			" bio->bi_sector: %llu\n", task, bio,
+			 (unsigned long long)bio->bi_sector);
 
 		submit_bio(rw, bio);
 		bio = nbio;
@@ -483,7 +478,7 @@ static ssize_t iblock_set_configfs_dev_params(struct se_hba *hba,
 		switch (token) {
 		case Opt_udev_path:
 			if (ib_dev->ibd_bd) {
-				printk(KERN_ERR "Unable to set udev_path= while"
+				pr_err("Unable to set udev_path= while"
 					" ib_dev->ibd_bd exists\n");
 				ret = -EEXIST;
 				goto out;
@@ -496,14 +491,14 @@ static ssize_t iblock_set_configfs_dev_params(struct se_hba *hba,
 			snprintf(ib_dev->ibd_udev_path, SE_UDEV_PATH_LEN,
 					"%s", arg_p);
 			kfree(arg_p);
-			printk(KERN_INFO "IBLOCK: Referencing UDEV path: %s\n",
+			pr_debug("IBLOCK: Referencing UDEV path: %s\n",
 					ib_dev->ibd_udev_path);
 			ib_dev->ibd_flags |= IBDF_HAS_UDEV_PATH;
 			break;
 		case Opt_force:
 			match_int(args, &arg);
 			ib_dev->ibd_force = arg;
-			printk(KERN_INFO "IBLOCK: Set force=%d\n",
+			pr_debug("IBLOCK: Set force=%d\n",
 				ib_dev->ibd_force);
 			break;
 		default:
@@ -523,7 +518,7 @@ static ssize_t iblock_check_configfs_dev_params(
 	struct iblock_dev *ibd = se_dev->se_dev_su_ptr;
 
 	if (!(ibd->ibd_flags & IBDF_HAS_UDEV_PATH)) {
-		printk(KERN_ERR "Missing udev_path= parameters for IBLOCK\n");
+		pr_err("Missing udev_path= parameters for IBLOCK\n");
 		return -EINVAL;
 	}
 
@@ -583,14 +578,14 @@ static struct bio *iblock_get_bio(
 
 	bio = bio_alloc_bioset(GFP_NOIO, sg_num, ib_dev->ibd_bio_set);
 	if (!(bio)) {
-		printk(KERN_ERR "Unable to allocate memory for bio\n");
+		pr_err("Unable to allocate memory for bio\n");
 		*ret = PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
 		return NULL;
 	}
 
-	DEBUG_IBLOCK("Allocated bio: %p task_sg_num: %u using ibd_bio_set:"
-		" %p\n", bio, task->task_sg_num, ib_dev->ibd_bio_set);
-	DEBUG_IBLOCK("Allocated bio: %p task_size: %u\n", bio, task->task_size);
+	pr_debug("Allocated bio: %p task_sg_nents: %u using ibd_bio_set:"
+		" %p\n", bio, task->task_sg_nents, ib_dev->ibd_bio_set);
+	pr_debug("Allocated bio: %p task_size: %u\n", bio, task->task_size);
 
 	bio->bi_bdev = ib_dev->ibd_bd;
 	bio->bi_private = task;
@@ -599,8 +594,8 @@ static struct bio *iblock_get_bio(
 	bio->bi_sector = lba;
 	atomic_inc(&ib_req->ib_bio_cnt);
 
-	DEBUG_IBLOCK("Set bio->bi_sector: %llu\n", bio->bi_sector);
-	DEBUG_IBLOCK("Set ib_req->ib_bio_cnt: %d\n",
+	pr_debug("Set bio->bi_sector: %llu\n", (unsigned long long)bio->bi_sector);
+	pr_debug("Set ib_req->ib_bio_cnt: %d\n",
 			atomic_read(&ib_req->ib_bio_cnt));
 	return bio;
 }
@@ -629,7 +624,7 @@ static int iblock_map_task_SG(struct se_task *task)
 	else if (dev->se_sub_dev->se_dev_attrib.block_size == 512)
 		block_lba = task->task_lba;
 	else {
-		printk(KERN_ERR "Unsupported SCSI -> BLOCK LBA conversion:"
+		pr_err("Unsupported SCSI -> BLOCK LBA conversion:"
 				" %u\n", dev->se_sub_dev->se_dev_attrib.block_size);
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 	}
@@ -645,20 +640,20 @@ static int iblock_map_task_SG(struct se_task *task)
 	 * from task->task_sg -> struct scatterlist memory.
 	 */
 	for_each_sg(task->task_sg, sg, task->task_sg_nents, i) {
-		DEBUG_IBLOCK("task: %p bio: %p Calling bio_add_page(): page:"
+		pr_debug("task: %p bio: %p Calling bio_add_page(): page:"
 			" %p len: %u offset: %u\n", task, bio, sg_page(sg),
 				sg->length, sg->offset);
 again:
 		ret = bio_add_page(bio, sg_page(sg), sg->length, sg->offset);
 		if (ret != sg->length) {
 
-			DEBUG_IBLOCK("*** Set bio->bi_sector: %llu\n",
-					bio->bi_sector);
-			DEBUG_IBLOCK("** task->task_size: %u\n",
+			pr_debug("*** Set bio->bi_sector: %llu\n",
+				 (unsigned long long)bio->bi_sector);
+			pr_debug("** task->task_size: %u\n",
 					task->task_size);
-			DEBUG_IBLOCK("*** bio->bi_max_vecs: %u\n",
+			pr_debug("*** bio->bi_max_vecs: %u\n",
 					bio->bi_max_vecs);
-			DEBUG_IBLOCK("*** bio->bi_vcnt: %u\n",
+			pr_debug("*** bio->bi_vcnt: %u\n",
 					bio->bi_vcnt);
 
 			bio = iblock_get_bio(task, ib_req, ib_dev, &ret,
@@ -667,18 +662,18 @@ again:
 				goto fail;
 
 			tbio = tbio->bi_next = bio;
-			DEBUG_IBLOCK("-----------------> Added +1 bio: %p to"
+			pr_debug("-----------------> Added +1 bio: %p to"
 				" list, Going to again\n", bio);
 			goto again;
 		}
 		/* Always in 512 byte units for Linux/Block */
 		block_lba += sg->length >> IBLOCK_LBA_SHIFT;
 		sg_num--;
-		DEBUG_IBLOCK("task: %p bio-add_page() passed!, decremented"
+		pr_debug("task: %p bio-add_page() passed!, decremented"
 			" sg_num to %u\n", task, sg_num);
-		DEBUG_IBLOCK("task: %p bio_add_page() passed!, increased lba"
-				" to %llu\n", task, block_lba);
-		DEBUG_IBLOCK("task: %p bio_add_page() passed!, bio->bi_vcnt:"
+		pr_debug("task: %p bio_add_page() passed!, increased lba"
+			 " to %llu\n", task, (unsigned long long)block_lba);
+		pr_debug("task: %p bio_add_page() passed!, bio->bi_vcnt:"
 				" %u\n", task, bio->bi_vcnt);
 	}
 
@@ -728,7 +723,7 @@ static void iblock_bio_done(struct bio *bio, int err)
 		err = -EIO;
 
 	if (err != 0) {
-		printk(KERN_ERR "test_bit(BIO_UPTODATE) failed for bio: %p,"
+		pr_err("test_bit(BIO_UPTODATE) failed for bio: %p,"
 			" err: %d\n", bio, err);
 		/*
 		 * Bump the ib_bio_err_cnt and release bio.
@@ -746,8 +741,8 @@ static void iblock_bio_done(struct bio *bio, int err)
 		transport_complete_task(task, 0);
 		return;
 	}
-	DEBUG_IBLOCK("done[%p] bio: %p task_lba: %llu bio_lba: %llu err=%d\n",
-		task, bio, task->task_lba, bio->bi_sector, err);
+	pr_debug("done[%p] bio: %p task_lba: %llu bio_lba: %llu err=%d\n",
+		 task, bio, task->task_lba, (unsigned long long)bio->bi_sector, err);
 	/*
 	 * bio_put() will call iblock_bio_destructor() to release the bio back
 	 * to ibr->ib_bio_set.
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 81e50a5..42f26f8 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -142,7 +142,7 @@ static int core_scsi2_reservation_release(struct se_cmd *cmd)
 		dev->dev_res_bin_isid = 0;
 		dev->dev_flags &= ~DF_SPC2_RESERVATIONS_WITH_ISID;
 	}
-	printk(KERN_INFO "SCSI-2 Released reservation for %s LUN: %u ->"
+	pr_debug("SCSI-2 Released reservation for %s LUN: %u ->"
 		" MAPPED LUN: %u for %s\n", tpg->se_tpg_tfo->get_fabric_name(),
 		cmd->se_lun->unpacked_lun, cmd->se_deve->mapped_lun,
 		sess->se_node_acl->initiatorname);
@@ -159,7 +159,7 @@ static int core_scsi2_reservation_reserve(struct se_cmd *cmd)
 
 	if ((cmd->t_task_cdb[1] & 0x01) &&
 	    (cmd->t_task_cdb[1] & 0x02)) {
-		printk(KERN_ERR "LongIO and Obselete Bits set, returning"
+		pr_err("LongIO and Obselete Bits set, returning"
 				" ILLEGAL_REQUEST\n");
 		return PYX_TRANSPORT_ILLEGAL_REQUEST;
 	}
@@ -173,12 +173,12 @@ static int core_scsi2_reservation_reserve(struct se_cmd *cmd)
 	spin_lock(&dev->dev_reservation_lock);
 	if (dev->dev_reserved_node_acl &&
 	   (dev->dev_reserved_node_acl != sess->se_node_acl)) {
-		printk(KERN_ERR "SCSI-2 RESERVATION CONFLIFT for %s fabric\n",
+		pr_err("SCSI-2 RESERVATION CONFLIFT for %s fabric\n",
 			tpg->se_tpg_tfo->get_fabric_name());
-		printk(KERN_ERR "Original reserver LUN: %u %s\n",
+		pr_err("Original reserver LUN: %u %s\n",
 			cmd->se_lun->unpacked_lun,
 			dev->dev_reserved_node_acl->initiatorname);
-		printk(KERN_ERR "Current attempt - LUN: %u -> MAPPED LUN: %u"
+		pr_err("Current attempt - LUN: %u -> MAPPED LUN: %u"
 			" from %s \n", cmd->se_lun->unpacked_lun,
 			cmd->se_deve->mapped_lun,
 			sess->se_node_acl->initiatorname);
@@ -192,7 +192,7 @@ static int core_scsi2_reservation_reserve(struct se_cmd *cmd)
 		dev->dev_res_bin_isid = sess->sess_bin_isid;
 		dev->dev_flags |= DF_SPC2_RESERVATIONS_WITH_ISID;
 	}
-	printk(KERN_INFO "SCSI-2 Reserved %s LUN: %u -> MAPPED LUN: %u"
+	pr_debug("SCSI-2 Reserved %s LUN: %u -> MAPPED LUN: %u"
 		" for %s\n", tpg->se_tpg_tfo->get_fabric_name(),
 		cmd->se_lun->unpacked_lun, cmd->se_deve->mapped_lun,
 		sess->se_node_acl->initiatorname);
@@ -280,7 +280,7 @@ int core_scsi2_emulate_crh(struct se_cmd *cmd)
 	}
 
 	if (conflict) {
-		printk(KERN_ERR "Received legacy SPC-2 RESERVE/RELEASE"
+		pr_err("Received legacy SPC-2 RESERVE/RELEASE"
 			" while active SPC-3 registrations exist,"
 			" returning RESERVATION_CONFLICT\n");
 		return PYX_TRANSPORT_RESERVATION_CONFLICT;
@@ -412,7 +412,7 @@ static int core_scsi3_pr_seq_non_holder(
 			ret = (registered_nexus) ? 0 : 1;
 			break;
 		default:
-			printk(KERN_ERR "Unknown PERSISTENT_RESERVE_OUT service"
+			pr_err("Unknown PERSISTENT_RESERVE_OUT service"
 				" action: 0x%02x\n", cdb[1] & 0x1f);
 			return -EINVAL;
 		}
@@ -459,7 +459,7 @@ static int core_scsi3_pr_seq_non_holder(
 			ret = 0; /* Allowed */
 			break;
 		default:
-			printk(KERN_ERR "Unknown MI Service Action: 0x%02x\n",
+			pr_err("Unknown MI Service Action: 0x%02x\n",
 				(cdb[1] & 0x1f));
 			return -EINVAL;
 		}
@@ -483,7 +483,7 @@ static int core_scsi3_pr_seq_non_holder(
 	 */
 	if (!(ret) && !(other_cdb)) {
 #if 0
-		printk(KERN_INFO "Allowing explict CDB: 0x%02x for %s"
+		pr_debug("Allowing explict CDB: 0x%02x for %s"
 			" reservation holder\n", cdb[0],
 			core_scsi3_pr_dump_type(pr_reg_type));
 #endif
@@ -498,7 +498,7 @@ static int core_scsi3_pr_seq_non_holder(
 			/*
 			 * Conflict for write exclusive
 			 */
-			printk(KERN_INFO "%s Conflict for unregistered nexus"
+			pr_debug("%s Conflict for unregistered nexus"
 				" %s CDB: 0x%02x to %s reservation\n",
 				transport_dump_cmd_direction(cmd),
 				se_sess->se_node_acl->initiatorname, cdb[0],
@@ -516,7 +516,7 @@ static int core_scsi3_pr_seq_non_holder(
 			 */
 #if 0
 			if (!(registered_nexus)) {
-				printk(KERN_INFO "Allowing implict CDB: 0x%02x"
+				pr_debug("Allowing implict CDB: 0x%02x"
 					" for %s reservation on unregistered"
 					" nexus\n", cdb[0],
 					core_scsi3_pr_dump_type(pr_reg_type));
@@ -531,14 +531,14 @@ static int core_scsi3_pr_seq_non_holder(
 			 * allow commands from registered nexuses.
 			 */
 #if 0
-			printk(KERN_INFO "Allowing implict CDB: 0x%02x for %s"
+			pr_debug("Allowing implict CDB: 0x%02x for %s"
 				" reservation\n", cdb[0],
 				core_scsi3_pr_dump_type(pr_reg_type));
 #endif
 			return 0;
 		}
 	}
-	printk(KERN_INFO "%s Conflict for %sregistered nexus %s CDB: 0x%2x"
+	pr_debug("%s Conflict for %sregistered nexus %s CDB: 0x%2x"
 		" for %s reservation\n", transport_dump_cmd_direction(cmd),
 		(registered_nexus) ? "" : "un",
 		se_sess->se_node_acl->initiatorname, cdb[0],
@@ -625,14 +625,14 @@ static struct t10_pr_registration *__core_scsi3_do_alloc_registration(
 
 	pr_reg = kmem_cache_zalloc(t10_pr_reg_cache, GFP_ATOMIC);
 	if (!(pr_reg)) {
-		printk(KERN_ERR "Unable to allocate struct t10_pr_registration\n");
+		pr_err("Unable to allocate struct t10_pr_registration\n");
 		return NULL;
 	}
 
 	pr_reg->pr_aptpl_buf = kzalloc(su_dev->t10_pr.pr_aptpl_buf_len,
 					GFP_ATOMIC);
 	if (!(pr_reg->pr_aptpl_buf)) {
-		printk(KERN_ERR "Unable to allocate pr_reg->pr_aptpl_buf\n");
+		pr_err("Unable to allocate pr_reg->pr_aptpl_buf\n");
 		kmem_cache_free(t10_pr_reg_cache, pr_reg);
 		return NULL;
 	}
@@ -751,7 +751,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 			 */
 			ret = core_scsi3_lunacl_depend_item(deve_tmp);
 			if (ret < 0) {
-				printk(KERN_ERR "core_scsi3_lunacl_depend"
+				pr_err("core_scsi3_lunacl_depend"
 						"_item() failed\n");
 				atomic_dec(&port->sep_tg_pt_ref_cnt);
 				smp_mb__after_atomic_dec();
@@ -818,13 +818,13 @@ int core_scsi3_alloc_aptpl_registration(
 	struct t10_pr_registration *pr_reg;
 
 	if (!(i_port) || !(t_port) || !(sa_res_key)) {
-		printk(KERN_ERR "Illegal parameters for APTPL registration\n");
+		pr_err("Illegal parameters for APTPL registration\n");
 		return -EINVAL;
 	}
 
 	pr_reg = kmem_cache_zalloc(t10_pr_reg_cache, GFP_KERNEL);
 	if (!(pr_reg)) {
-		printk(KERN_ERR "Unable to allocate struct t10_pr_registration\n");
+		pr_err("Unable to allocate struct t10_pr_registration\n");
 		return -ENOMEM;
 	}
 	pr_reg->pr_aptpl_buf = kzalloc(pr_tmpl->pr_aptpl_buf_len, GFP_KERNEL);
@@ -869,7 +869,7 @@ int core_scsi3_alloc_aptpl_registration(
 	pr_reg->pr_res_holder = res_holder;
 
 	list_add_tail(&pr_reg->pr_reg_aptpl_list, &pr_tmpl->aptpl_reg_list);
-	printk(KERN_INFO "SPC-3 PR APTPL Successfully added registration%s from"
+	pr_debug("SPC-3 PR APTPL Successfully added registration%s from"
 			" metadata\n", (res_holder) ? "+reservation" : "");
 	return 0;
 }
@@ -891,12 +891,12 @@ static void core_scsi3_aptpl_reserve(
 	dev->dev_pr_res_holder = pr_reg;
 	spin_unlock(&dev->dev_reservation_lock);
 
-	printk(KERN_INFO "SPC-3 PR [%s] Service Action: APTPL RESERVE created"
+	pr_debug("SPC-3 PR [%s] Service Action: APTPL RESERVE created"
 		" new reservation holder TYPE: %s ALL_TG_PT: %d\n",
 		tpg->se_tpg_tfo->get_fabric_name(),
 		core_scsi3_pr_dump_type(pr_reg->pr_res_type),
 		(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
-	printk(KERN_INFO "SPC-3 PR [%s] RESERVE Node: %s%s\n",
+	pr_debug("SPC-3 PR [%s] RESERVE Node: %s%s\n",
 		tpg->se_tpg_tfo->get_fabric_name(), node_acl->initiatorname,
 		(prf_isid) ? &i_buf[0] : "");
 }
@@ -1006,19 +1006,19 @@ static void __core_scsi3_dump_registration(
 	prf_isid = core_pr_dump_initiator_port(pr_reg, &i_buf[0],
 				PR_REG_ISID_ID_LEN);
 
-	printk(KERN_INFO "SPC-3 PR [%s] Service Action: REGISTER%s Initiator"
+	pr_debug("SPC-3 PR [%s] Service Action: REGISTER%s Initiator"
 		" Node: %s%s\n", tfo->get_fabric_name(), (register_type == 2) ?
 		"_AND_MOVE" : (register_type == 1) ?
 		"_AND_IGNORE_EXISTING_KEY" : "", nacl->initiatorname,
 		(prf_isid) ? i_buf : "");
-	printk(KERN_INFO "SPC-3 PR [%s] registration on Target Port: %s,0x%04x\n",
+	pr_debug("SPC-3 PR [%s] registration on Target Port: %s,0x%04x\n",
 		 tfo->get_fabric_name(), tfo->tpg_get_wwn(se_tpg),
 		tfo->tpg_get_tag(se_tpg));
-	printk(KERN_INFO "SPC-3 PR [%s] for %s TCM Subsystem %s Object Target"
+	pr_debug("SPC-3 PR [%s] for %s TCM Subsystem %s Object Target"
 		" Port(s)\n",  tfo->get_fabric_name(),
 		(pr_reg->pr_reg_all_tg_pt) ? "ALL" : "SINGLE",
 		dev->transport->name);
-	printk(KERN_INFO "SPC-3 PR [%s] SA Res Key: 0x%016Lx PRgeneration:"
+	pr_debug("SPC-3 PR [%s] SA Res Key: 0x%016Lx PRgeneration:"
 		" 0x%08x  APTPL: %d\n", tfo->get_fabric_name(),
 		pr_reg->pr_res_key, pr_reg->pr_res_generation,
 		pr_reg->pr_reg_aptpl);
@@ -1236,7 +1236,7 @@ static int core_scsi3_check_implict_release(
 		  (!strcmp(pr_res_holder->pr_reg_nacl->initiatorname,
 			  pr_reg->pr_reg_nacl->initiatorname)) &&
 		  (pr_res_holder->pr_res_key == pr_reg->pr_res_key)) {
-		printk(KERN_ERR "SPC-3 PR: Unable to perform ALL_TG_PT=1"
+		pr_err("SPC-3 PR: Unable to perform ALL_TG_PT=1"
 			" UNREGISTER while existing reservation with matching"
 			" key 0x%016Lx is present from another SCSI Initiator"
 			" Port\n", pr_reg->pr_res_key);
@@ -1283,21 +1283,21 @@ static void __core_scsi3_free_registration(
 	 */
 	while (atomic_read(&pr_reg->pr_res_holders) != 0) {
 		spin_unlock(&pr_tmpl->registration_lock);
-		printk("SPC-3 PR [%s] waiting for pr_res_holders\n",
+		pr_debug("SPC-3 PR [%s] waiting for pr_res_holders\n",
 				tfo->get_fabric_name());
 		cpu_relax();
 		spin_lock(&pr_tmpl->registration_lock);
 	}
 
-	printk(KERN_INFO "SPC-3 PR [%s] Service Action: UNREGISTER Initiator"
+	pr_debug("SPC-3 PR [%s] Service Action: UNREGISTER Initiator"
 		" Node: %s%s\n", tfo->get_fabric_name(),
 		pr_reg->pr_reg_nacl->initiatorname,
 		(prf_isid) ? &i_buf[0] : "");
-	printk(KERN_INFO "SPC-3 PR [%s] for %s TCM Subsystem %s Object Target"
+	pr_debug("SPC-3 PR [%s] for %s TCM Subsystem %s Object Target"
 		" Port(s)\n", tfo->get_fabric_name(),
 		(pr_reg->pr_reg_all_tg_pt) ? "ALL" : "SINGLE",
 		dev->transport->name);
-	printk(KERN_INFO "SPC-3 PR [%s] SA Res Key: 0x%016Lx PRgeneration:"
+	pr_debug("SPC-3 PR [%s] SA Res Key: 0x%016Lx PRgeneration:"
 		" 0x%08x\n", tfo->get_fabric_name(), pr_reg->pr_res_key,
 		pr_reg->pr_res_generation);
 
@@ -1501,7 +1501,7 @@ static int core_scsi3_decode_spec_i_port(
 	 */
 	tidh_new = kzalloc(sizeof(struct pr_transport_id_holder), GFP_KERNEL);
 	if (!(tidh_new)) {
-		printk(KERN_ERR "Unable to allocate tidh_new\n");
+		pr_err("Unable to allocate tidh_new\n");
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 	}
 	INIT_LIST_HEAD(&tidh_new->dest_list);
@@ -1537,7 +1537,7 @@ static int core_scsi3_decode_spec_i_port(
 	tpdl |= buf[27] & 0xff;
 
 	if ((tpdl + 28) != cmd->data_length) {
-		printk(KERN_ERR "SPC-3 PR: Illegal tpdl: %u + 28 byte header"
+		pr_err("SPC-3 PR: Illegal tpdl: %u + 28 byte header"
 			" does not equal CDB data_length: %u\n", tpdl,
 			cmd->data_length);
 		ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
@@ -1586,7 +1586,7 @@ static int core_scsi3_decode_spec_i_port(
 
 			ret = core_scsi3_tpg_depend_item(tmp_tpg);
 			if (ret != 0) {
-				printk(KERN_ERR " core_scsi3_tpg_depend_item()"
+				pr_err(" core_scsi3_tpg_depend_item()"
 					" for tmp_tpg\n");
 				atomic_dec(&tmp_tpg->tpg_pr_ref_count);
 				smp_mb__after_atomic_dec();
@@ -1615,7 +1615,7 @@ static int core_scsi3_decode_spec_i_port(
 
 			ret = core_scsi3_nodeacl_depend_item(dest_node_acl);
 			if (ret != 0) {
-				printk(KERN_ERR "configfs_depend_item() failed"
+				pr_err("configfs_depend_item() failed"
 					" for dest_node_acl->acl_group\n");
 				atomic_dec(&dest_node_acl->acl_pr_ref_count);
 				smp_mb__after_atomic_dec();
@@ -1625,7 +1625,7 @@ static int core_scsi3_decode_spec_i_port(
 			}
 
 			dest_tpg = tmp_tpg;
-			printk(KERN_INFO "SPC-3 PR SPEC_I_PT: Located %s Node:"
+			pr_debug("SPC-3 PR SPEC_I_PT: Located %s Node:"
 				" %s Port RTPI: %hu\n",
 				dest_tpg->se_tpg_tfo->get_fabric_name(),
 				dest_node_acl->initiatorname, dest_rtpi);
@@ -1636,19 +1636,19 @@ static int core_scsi3_decode_spec_i_port(
 		spin_unlock(&dev->se_port_lock);
 
 		if (!(dest_tpg)) {
-			printk(KERN_ERR "SPC-3 PR SPEC_I_PT: Unable to locate"
+			pr_err("SPC-3 PR SPEC_I_PT: Unable to locate"
 					" dest_tpg\n");
 			ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 			goto out;
 		}
 #if 0
-		printk("SPC-3 PR SPEC_I_PT: Got %s data_length: %u tpdl: %u"
+		pr_debug("SPC-3 PR SPEC_I_PT: Got %s data_length: %u tpdl: %u"
 			" tid_len: %d for %s + %s\n",
 			dest_tpg->se_tpg_tfo->get_fabric_name(), cmd->data_length,
 			tpdl, tid_len, i_str, iport_ptr);
 #endif
 		if (tid_len > tpdl) {
-			printk(KERN_ERR "SPC-3 PR SPEC_I_PT: Illegal tid_len:"
+			pr_err("SPC-3 PR SPEC_I_PT: Illegal tid_len:"
 				" %u for Transport ID: %s\n", tid_len, ptr);
 			core_scsi3_nodeacl_undepend_item(dest_node_acl);
 			core_scsi3_tpg_undepend_item(dest_tpg);
@@ -1663,7 +1663,7 @@ static int core_scsi3_decode_spec_i_port(
 		dest_se_deve = core_get_se_deve_from_rtpi(dest_node_acl,
 					dest_rtpi);
 		if (!(dest_se_deve)) {
-			printk(KERN_ERR "Unable to locate %s dest_se_deve"
+			pr_err("Unable to locate %s dest_se_deve"
 				" from destination RTPI: %hu\n",
 				dest_tpg->se_tpg_tfo->get_fabric_name(),
 				dest_rtpi);
@@ -1676,7 +1676,7 @@ static int core_scsi3_decode_spec_i_port(
 
 		ret = core_scsi3_lunacl_depend_item(dest_se_deve);
 		if (ret < 0) {
-			printk(KERN_ERR "core_scsi3_lunacl_depend_item()"
+			pr_err("core_scsi3_lunacl_depend_item()"
 					" failed\n");
 			atomic_dec(&dest_se_deve->pr_ref_count);
 			smp_mb__after_atomic_dec();
@@ -1686,7 +1686,7 @@ static int core_scsi3_decode_spec_i_port(
 			goto out;
 		}
 #if 0
-		printk(KERN_INFO "SPC-3 PR SPEC_I_PT: Located %s Node: %s"
+		pr_debug("SPC-3 PR SPEC_I_PT: Located %s Node: %s"
 			" dest_se_deve mapped_lun: %u\n",
 			dest_tpg->se_tpg_tfo->get_fabric_name(),
 			dest_node_acl->initiatorname, dest_se_deve->mapped_lun);
@@ -1715,7 +1715,7 @@ static int core_scsi3_decode_spec_i_port(
 		tidh_new = kzalloc(sizeof(struct pr_transport_id_holder),
 				GFP_KERNEL);
 		if (!(tidh_new)) {
-			printk(KERN_ERR "Unable to allocate tidh_new\n");
+			pr_err("Unable to allocate tidh_new\n");
 			core_scsi3_lunacl_undepend_item(dest_se_deve);
 			core_scsi3_nodeacl_undepend_item(dest_node_acl);
 			core_scsi3_tpg_undepend_item(dest_tpg);
@@ -1795,7 +1795,7 @@ static int core_scsi3_decode_spec_i_port(
 		__core_scsi3_add_registration(cmd->se_dev, dest_node_acl,
 					dest_pr_reg, 0, 0);
 
-		printk(KERN_INFO "SPC-3 PR [%s] SPEC_I_PT: Successfully"
+		pr_debug("SPC-3 PR [%s] SPEC_I_PT: Successfully"
 			" registered Transport ID for Node: %s%s Mapped LUN:"
 			" %u\n", dest_tpg->se_tpg_tfo->get_fabric_name(),
 			dest_node_acl->initiatorname, (prf_isid) ?
@@ -1923,7 +1923,7 @@ static int __core_scsi3_update_aptpl_buf(
 		}
 
 		if ((len + strlen(tmp) >= pr_aptpl_buf_len)) {
-			printk(KERN_ERR "Unable to update renaming"
+			pr_err("Unable to update renaming"
 				" APTPL metadata\n");
 			spin_unlock(&su_dev->t10_pr.registration_lock);
 			return -EMSGSIZE;
@@ -1941,7 +1941,7 @@ static int __core_scsi3_update_aptpl_buf(
 			lun->lun_sep->sep_rtpi, lun->unpacked_lun, reg_count);
 
 		if ((len + strlen(tmp) >= pr_aptpl_buf_len)) {
-			printk(KERN_ERR "Unable to update renaming"
+			pr_err("Unable to update renaming"
 				" APTPL metadata\n");
 			spin_unlock(&su_dev->t10_pr.registration_lock);
 			return -EMSGSIZE;
@@ -1993,7 +1993,7 @@ static int __core_scsi3_write_aptpl_to_file(
 	memset(path, 0, 512);
 
 	if (strlen(&wwn->unit_serial[0]) >= 512) {
-		printk(KERN_ERR "WWN value for struct se_device does not fit"
+		pr_err("WWN value for struct se_device does not fit"
 			" into path buffer\n");
 		return -EMSGSIZE;
 	}
@@ -2001,7 +2001,7 @@ static int __core_scsi3_write_aptpl_to_file(
 	snprintf(path, 512, "/var/target/pr/aptpl_%s", &wwn->unit_serial[0]);
 	file = filp_open(path, flags, 0600);
 	if (IS_ERR(file) || !file || !file->f_dentry) {
-		printk(KERN_ERR "filp_open(%s) for APTPL metadata"
+		pr_err("filp_open(%s) for APTPL metadata"
 			" failed\n", path);
 		return (PTR_ERR(file) < 0 ? PTR_ERR(file) : -ENOENT);
 	}
@@ -2018,7 +2018,7 @@ static int __core_scsi3_write_aptpl_to_file(
 	set_fs(old_fs);
 
 	if (ret < 0) {
-		printk("Error writing APTPL metadata file: %s\n", path);
+		pr_debug("Error writing APTPL metadata file: %s\n", path);
 		filp_close(file, NULL);
 		return -EIO;
 	}
@@ -2089,7 +2089,7 @@ static int core_scsi3_emulate_pro_register(
 	int pr_holder = 0, ret = 0, type;
 
 	if (!(se_sess) || !(se_lun)) {
-		printk(KERN_ERR "SPC-3 PR: se_sess || struct se_lun is NULL!\n");
+		pr_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 	}
 	se_tpg = se_sess->se_tpg;
@@ -2107,7 +2107,7 @@ static int core_scsi3_emulate_pro_register(
 	pr_reg_e = core_scsi3_locate_pr_reg(dev, se_sess->se_node_acl, se_sess);
 	if (!(pr_reg_e)) {
 		if (res_key) {
-			printk(KERN_WARNING "SPC-3 PR: Reservation Key non-zero"
+			pr_warn("SPC-3 PR: Reservation Key non-zero"
 				" for SA REGISTER, returning CONFLICT\n");
 			return PYX_TRANSPORT_RESERVATION_CONFLICT;
 		}
@@ -2128,7 +2128,7 @@ static int core_scsi3_emulate_pro_register(
 					sa_res_key, all_tg_pt, aptpl,
 					ignore_key, 0);
 			if (ret != 0) {
-				printk(KERN_ERR "Unable to allocate"
+				pr_err("Unable to allocate"
 					" struct t10_pr_registration\n");
 				return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 			}
@@ -2152,7 +2152,7 @@ static int core_scsi3_emulate_pro_register(
 		if (!(aptpl)) {
 			pr_tmpl->pr_aptpl_active = 0;
 			core_scsi3_update_and_write_aptpl(cmd->se_dev, NULL, 0);
-			printk("SPC-3 PR: Set APTPL Bit Deactivated for"
+			pr_debug("SPC-3 PR: Set APTPL Bit Deactivated for"
 					" REGISTER\n");
 			return 0;
 		}
@@ -2169,7 +2169,7 @@ static int core_scsi3_emulate_pro_register(
 				pr_tmpl->pr_aptpl_buf_len);
 		if (!(ret)) {
 			pr_tmpl->pr_aptpl_active = 1;
-			printk("SPC-3 PR: Set APTPL Bit Activated for REGISTER\n");
+			pr_debug("SPC-3 PR: Set APTPL Bit Activated for REGISTER\n");
 		}
 
 		core_scsi3_put_pr_reg(pr_reg);
@@ -2183,7 +2183,7 @@ static int core_scsi3_emulate_pro_register(
 
 		if (!(ignore_key)) {
 			if (res_key != pr_reg->pr_res_key) {
-				printk(KERN_ERR "SPC-3 PR REGISTER: Received"
+				pr_err("SPC-3 PR REGISTER: Received"
 					" res_key: 0x%016Lx does not match"
 					" existing SA REGISTER res_key:"
 					" 0x%016Lx\n", res_key,
@@ -2193,7 +2193,7 @@ static int core_scsi3_emulate_pro_register(
 			}
 		}
 		if (spec_i_pt) {
-			printk(KERN_ERR "SPC-3 PR UNREGISTER: SPEC_I_PT"
+			pr_err("SPC-3 PR UNREGISTER: SPEC_I_PT"
 				" set while sa_res_key=0\n");
 			core_scsi3_put_pr_reg(pr_reg);
 			return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
@@ -2203,7 +2203,7 @@ static int core_scsi3_emulate_pro_register(
 		 * must also set ALL_TG_PT=1 in the incoming PROUT.
 		 */
 		if (pr_reg->pr_reg_all_tg_pt && !(all_tg_pt)) {
-			printk(KERN_ERR "SPC-3 PR UNREGISTER: ALL_TG_PT=1"
+			pr_err("SPC-3 PR UNREGISTER: ALL_TG_PT=1"
 				" registration exists, but ALL_TG_PT=1 bit not"
 				" present in received PROUT\n");
 			core_scsi3_put_pr_reg(pr_reg);
@@ -2216,7 +2216,7 @@ static int core_scsi3_emulate_pro_register(
 			pr_aptpl_buf = kzalloc(pr_tmpl->pr_aptpl_buf_len,
 						GFP_KERNEL);
 			if (!(pr_aptpl_buf)) {
-				printk(KERN_ERR "Unable to allocate"
+				pr_err("Unable to allocate"
 					" pr_aptpl_buf\n");
 				core_scsi3_put_pr_reg(pr_reg);
 				return PYX_TRANSPORT_LU_COMM_FAILURE;
@@ -2298,7 +2298,7 @@ static int core_scsi3_emulate_pro_register(
 			if (!(aptpl)) {
 				pr_tmpl->pr_aptpl_active = 0;
 				core_scsi3_update_and_write_aptpl(dev, NULL, 0);
-				printk("SPC-3 PR: Set APTPL Bit Deactivated"
+				pr_debug("SPC-3 PR: Set APTPL Bit Deactivated"
 						" for UNREGISTER\n");
 				return 0;
 			}
@@ -2308,7 +2308,7 @@ static int core_scsi3_emulate_pro_register(
 					pr_tmpl->pr_aptpl_buf_len);
 			if (!(ret)) {
 				pr_tmpl->pr_aptpl_active = 1;
-				printk("SPC-3 PR: Set APTPL Bit Activated"
+				pr_debug("SPC-3 PR: Set APTPL Bit Activated"
 						" for UNREGISTER\n");
 			}
 
@@ -2323,7 +2323,7 @@ static int core_scsi3_emulate_pro_register(
 			pr_reg->pr_res_generation = core_scsi3_pr_generation(
 							cmd->se_dev);
 			pr_reg->pr_res_key = sa_res_key;
-			printk("SPC-3 PR [%s] REGISTER%s: Changed Reservation"
+			pr_debug("SPC-3 PR [%s] REGISTER%s: Changed Reservation"
 				" Key for %s to: 0x%016Lx PRgeneration:"
 				" 0x%08x\n", cmd->se_tfo->get_fabric_name(),
 				(ignore_key) ? "_AND_IGNORE_EXISTING_KEY" : "",
@@ -2334,7 +2334,7 @@ static int core_scsi3_emulate_pro_register(
 				pr_tmpl->pr_aptpl_active = 0;
 				core_scsi3_update_and_write_aptpl(dev, NULL, 0);
 				core_scsi3_put_pr_reg(pr_reg);
-				printk("SPC-3 PR: Set APTPL Bit Deactivated"
+				pr_debug("SPC-3 PR: Set APTPL Bit Deactivated"
 						" for REGISTER\n");
 				return 0;
 			}
@@ -2344,7 +2344,7 @@ static int core_scsi3_emulate_pro_register(
 					pr_tmpl->pr_aptpl_buf_len);
 			if (!(ret)) {
 				pr_tmpl->pr_aptpl_active = 1;
-				printk("SPC-3 PR: Set APTPL Bit Activated"
+				pr_debug("SPC-3 PR: Set APTPL Bit Activated"
 						" for REGISTER\n");
 			}
 
@@ -2396,7 +2396,7 @@ static int core_scsi3_pro_reserve(
 	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
 
 	if (!(se_sess) || !(se_lun)) {
-		printk(KERN_ERR "SPC-3 PR: se_sess || struct se_lun is NULL!\n");
+		pr_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 	}
 	se_tpg = se_sess->se_tpg;
@@ -2407,7 +2407,7 @@ static int core_scsi3_pro_reserve(
 	pr_reg = core_scsi3_locate_pr_reg(cmd->se_dev, se_sess->se_node_acl,
 				se_sess);
 	if (!(pr_reg)) {
-		printk(KERN_ERR "SPC-3 PR: Unable to locate"
+		pr_err("SPC-3 PR: Unable to locate"
 			" PR_REGISTERED *pr_reg for RESERVE\n");
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 	}
@@ -2421,7 +2421,7 @@ static int core_scsi3_pro_reserve(
 	 * 	 registered with the logical unit for the I_T nexus; and
 	 */
 	if (res_key != pr_reg->pr_res_key) {
-		printk(KERN_ERR "SPC-3 PR RESERVE: Received res_key: 0x%016Lx"
+		pr_err("SPC-3 PR RESERVE: Received res_key: 0x%016Lx"
 			" does not match existing SA REGISTER res_key:"
 			" 0x%016Lx\n", res_key, pr_reg->pr_res_key);
 		core_scsi3_put_pr_reg(pr_reg);
@@ -2438,7 +2438,7 @@ static int core_scsi3_pro_reserve(
 	 * and that persistent reservation has a scope of LU_SCOPE.
 	 */
 	if (scope != PR_SCOPE_LU_SCOPE) {
-		printk(KERN_ERR "SPC-3 PR: Illegal SCOPE: 0x%02x\n", scope);
+		pr_err("SPC-3 PR: Illegal SCOPE: 0x%02x\n", scope);
 		core_scsi3_put_pr_reg(pr_reg);
 		return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 	}
@@ -2462,7 +2462,7 @@ static int core_scsi3_pro_reserve(
 		 */
 		if (pr_res_holder != pr_reg) {
 			struct se_node_acl *pr_res_nacl = pr_res_holder->pr_reg_nacl;
-			printk(KERN_ERR "SPC-3 PR: Attempted RESERVE from"
+			pr_err("SPC-3 PR: Attempted RESERVE from"
 				" [%s]: %s while reservation already held by"
 				" [%s]: %s, returning RESERVATION_CONFLICT\n",
 				cmd->se_tfo->get_fabric_name(),
@@ -2484,7 +2484,7 @@ static int core_scsi3_pro_reserve(
 		if ((pr_res_holder->pr_res_type != type) ||
 		    (pr_res_holder->pr_res_scope != scope)) {
 			struct se_node_acl *pr_res_nacl = pr_res_holder->pr_reg_nacl;
-			printk(KERN_ERR "SPC-3 PR: Attempted RESERVE from"
+			pr_err("SPC-3 PR: Attempted RESERVE from"
 				" [%s]: %s trying to change TYPE and/or SCOPE,"
 				" while reservation already held by [%s]: %s,"
 				" returning RESERVATION_CONFLICT\n",
@@ -2522,11 +2522,11 @@ static int core_scsi3_pro_reserve(
 	prf_isid = core_pr_dump_initiator_port(pr_reg, &i_buf[0],
 				PR_REG_ISID_ID_LEN);
 
-	printk(KERN_INFO "SPC-3 PR [%s] Service Action: RESERVE created new"
+	pr_debug("SPC-3 PR [%s] Service Action: RESERVE created new"
 		" reservation holder TYPE: %s ALL_TG_PT: %d\n",
 		cmd->se_tfo->get_fabric_name(), core_scsi3_pr_dump_type(type),
 		(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
-	printk(KERN_INFO "SPC-3 PR [%s] RESERVE Node: %s%s\n",
+	pr_debug("SPC-3 PR [%s] RESERVE Node: %s%s\n",
 			cmd->se_tfo->get_fabric_name(),
 			se_sess->se_node_acl->initiatorname,
 			(prf_isid) ? &i_buf[0] : "");
@@ -2537,7 +2537,7 @@ static int core_scsi3_pro_reserve(
 				&pr_reg->pr_aptpl_buf[0],
 				pr_tmpl->pr_aptpl_buf_len);
 		if (!(ret))
-			printk(KERN_INFO "SPC-3 PR: Updated APTPL metadata"
+			pr_debug("SPC-3 PR: Updated APTPL metadata"
 					" for RESERVE\n");
 	}
 
@@ -2564,7 +2564,7 @@ static int core_scsi3_emulate_pro_reserve(
 		ret = core_scsi3_pro_reserve(cmd, dev, type, scope, res_key);
 		break;
 	default:
-		printk(KERN_ERR "SPC-3 PR: Unknown Service Action RESERVE Type:"
+		pr_err("SPC-3 PR: Unknown Service Action RESERVE Type:"
 			" 0x%02x\n", type);
 		return PYX_TRANSPORT_INVALID_CDB_FIELD;
 	}
@@ -2593,12 +2593,12 @@ static void __core_scsi3_complete_pro_release(
 	 */
 	dev->dev_pr_res_holder = NULL;
 
-	printk(KERN_INFO "SPC-3 PR [%s] Service Action: %s RELEASE cleared"
+	pr_debug("SPC-3 PR [%s] Service Action: %s RELEASE cleared"
 		" reservation holder TYPE: %s ALL_TG_PT: %d\n",
 		tfo->get_fabric_name(), (explict) ? "explict" : "implict",
 		core_scsi3_pr_dump_type(pr_reg->pr_res_type),
 		(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
-	printk(KERN_INFO "SPC-3 PR [%s] RELEASE Node: %s%s\n",
+	pr_debug("SPC-3 PR [%s] RELEASE Node: %s%s\n",
 		tfo->get_fabric_name(), se_nacl->initiatorname,
 		(prf_isid) ? &i_buf[0] : "");
 	/*
@@ -2621,7 +2621,7 @@ static int core_scsi3_emulate_pro_release(
 	int ret, all_reg = 0;
 
 	if (!(se_sess) || !(se_lun)) {
-		printk(KERN_ERR "SPC-3 PR: se_sess || struct se_lun is NULL!\n");
+		pr_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 	}
 	/*
@@ -2629,7 +2629,7 @@ static int core_scsi3_emulate_pro_release(
 	 */
 	pr_reg = core_scsi3_locate_pr_reg(dev, se_sess->se_node_acl, se_sess);
 	if (!(pr_reg)) {
-		printk(KERN_ERR "SPC-3 PR: Unable to locate"
+		pr_err("SPC-3 PR: Unable to locate"
 			" PR_REGISTERED *pr_reg for RELEASE\n");
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 	}
@@ -2684,7 +2684,7 @@ static int core_scsi3_emulate_pro_release(
 	 *	  that is registered with the logical unit for the I_T nexus;
 	 */
 	if (res_key != pr_reg->pr_res_key) {
-		printk(KERN_ERR "SPC-3 PR RELEASE: Received res_key: 0x%016Lx"
+		pr_err("SPC-3 PR RELEASE: Received res_key: 0x%016Lx"
 			" does not match existing SA REGISTER res_key:"
 			" 0x%016Lx\n", res_key, pr_reg->pr_res_key);
 		spin_unlock(&dev->dev_reservation_lock);
@@ -2700,7 +2700,7 @@ static int core_scsi3_emulate_pro_release(
 	if ((pr_res_holder->pr_res_type != type) ||
 	    (pr_res_holder->pr_res_scope != scope)) {
 		struct se_node_acl *pr_res_nacl = pr_res_holder->pr_reg_nacl;
-		printk(KERN_ERR "SPC-3 PR RELEASE: Attempted to release"
+		pr_err("SPC-3 PR RELEASE: Attempted to release"
 			" reservation from [%s]: %s with different TYPE "
 			"and/or SCOPE  while reservation already held by"
 			" [%s]: %s, returning RESERVATION_CONFLICT\n",
@@ -2768,7 +2768,7 @@ write_aptpl:
 				&pr_reg->pr_aptpl_buf[0],
 				pr_tmpl->pr_aptpl_buf_len);
 		if (!(ret))
-			printk("SPC-3 PR: Updated APTPL metadata for RELEASE\n");
+			pr_debug("SPC-3 PR: Updated APTPL metadata for RELEASE\n");
 	}
 
 	core_scsi3_put_pr_reg(pr_reg);
@@ -2792,7 +2792,7 @@ static int core_scsi3_emulate_pro_clear(
 	pr_reg_n = core_scsi3_locate_pr_reg(cmd->se_dev,
 			se_sess->se_node_acl, se_sess);
 	if (!(pr_reg_n)) {
-		printk(KERN_ERR "SPC-3 PR: Unable to locate"
+		pr_err("SPC-3 PR: Unable to locate"
 			" PR_REGISTERED *pr_reg for CLEAR\n");
 			return PYX_TRANSPORT_LU_COMM_FAILURE;
 	}
@@ -2808,7 +2808,7 @@ static int core_scsi3_emulate_pro_clear(
 	 * 	   that is registered with the logical unit for the I_T nexus.
 	 */
 	if (res_key != pr_reg_n->pr_res_key) {
-		printk(KERN_ERR "SPC-3 PR REGISTER: Received"
+		pr_err("SPC-3 PR REGISTER: Received"
 			" res_key: 0x%016Lx does not match"
 			" existing SA REGISTER res_key:"
 			" 0x%016Lx\n", res_key, pr_reg_n->pr_res_key);
@@ -2851,12 +2851,12 @@ static int core_scsi3_emulate_pro_clear(
 	}
 	spin_unlock(&pr_tmpl->registration_lock);
 
-	printk(KERN_INFO "SPC-3 PR [%s] Service Action: CLEAR complete\n",
+	pr_debug("SPC-3 PR [%s] Service Action: CLEAR complete\n",
 		cmd->se_tfo->get_fabric_name());
 
 	if (pr_tmpl->pr_aptpl_active) {
 		core_scsi3_update_and_write_aptpl(cmd->se_dev, NULL, 0);
-		printk(KERN_INFO "SPC-3 PR: Updated APTPL metadata"
+		pr_debug("SPC-3 PR: Updated APTPL metadata"
 				" for CLEAR\n");
 	}
 
@@ -2895,12 +2895,12 @@ static void __core_scsi3_complete_pro_preempt(
 	pr_reg->pr_res_type = type;
 	pr_reg->pr_res_scope = scope;
 
-	printk(KERN_INFO "SPC-3 PR [%s] Service Action: PREEMPT%s created new"
+	pr_debug("SPC-3 PR [%s] Service Action: PREEMPT%s created new"
 		" reservation holder TYPE: %s ALL_TG_PT: %d\n",
 		tfo->get_fabric_name(), (abort) ? "_AND_ABORT" : "",
 		core_scsi3_pr_dump_type(type),
 		(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
-	printk(KERN_INFO "SPC-3 PR [%s] PREEMPT%s from Node: %s%s\n",
+	pr_debug("SPC-3 PR [%s] PREEMPT%s from Node: %s%s\n",
 		tfo->get_fabric_name(), (abort) ? "_AND_ABORT" : "",
 		nacl->initiatorname, (prf_isid) ? &i_buf[0] : "");
 	/*
@@ -2926,7 +2926,7 @@ static void core_scsi3_release_preempt_and_abort(
 		if (pr_reg_holder == pr_reg)
 			continue;
 		if (pr_reg->pr_res_holder) {
-			printk(KERN_WARNING "pr_reg->pr_res_holder still set\n");
+			pr_warn("pr_reg->pr_res_holder still set\n");
 			continue;
 		}
 
@@ -2978,7 +2978,7 @@ static int core_scsi3_pro_preempt(
 	pr_reg_n = core_scsi3_locate_pr_reg(cmd->se_dev, se_sess->se_node_acl,
 				se_sess);
 	if (!(pr_reg_n)) {
-		printk(KERN_ERR "SPC-3 PR: Unable to locate"
+		pr_err("SPC-3 PR: Unable to locate"
 			" PR_REGISTERED *pr_reg for PREEMPT%s\n",
 			(abort) ? "_AND_ABORT" : "");
 		return PYX_TRANSPORT_RESERVATION_CONFLICT;
@@ -2988,7 +2988,7 @@ static int core_scsi3_pro_preempt(
 		return PYX_TRANSPORT_RESERVATION_CONFLICT;
 	}
 	if (scope != PR_SCOPE_LU_SCOPE) {
-		printk(KERN_ERR "SPC-3 PR: Illegal SCOPE: 0x%02x\n", scope);
+		pr_err("SPC-3 PR: Illegal SCOPE: 0x%02x\n", scope);
 		core_scsi3_put_pr_reg(pr_reg_n);
 		return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 	}
@@ -3121,7 +3121,7 @@ static int core_scsi3_pro_preempt(
 					&pr_reg_n->pr_aptpl_buf[0],
 					pr_tmpl->pr_aptpl_buf_len);
 			if (!(ret))
-				printk(KERN_INFO "SPC-3 PR: Updated APTPL"
+				pr_debug("SPC-3 PR: Updated APTPL"
 					" metadata for  PREEMPT%s\n", (abort) ?
 					"_AND_ABORT" : "");
 		}
@@ -3257,7 +3257,7 @@ static int core_scsi3_pro_preempt(
 				&pr_reg_n->pr_aptpl_buf[0],
 				pr_tmpl->pr_aptpl_buf_len);
 		if (!(ret))
-			printk("SPC-3 PR: Updated APTPL metadata for PREEMPT"
+			pr_debug("SPC-3 PR: Updated APTPL metadata for PREEMPT"
 				"%s\n", (abort) ? "_AND_ABORT" : "");
 	}
 
@@ -3287,7 +3287,7 @@ static int core_scsi3_emulate_pro_preempt(
 				res_key, sa_res_key, abort);
 		break;
 	default:
-		printk(KERN_ERR "SPC-3 PR: Unknown Service Action PREEMPT%s"
+		pr_err("SPC-3 PR: Unknown Service Action PREEMPT%s"
 			" Type: 0x%02x\n", (abort) ? "_AND_ABORT" : "", type);
 		return PYX_TRANSPORT_INVALID_CDB_FIELD;
 	}
@@ -3322,7 +3322,7 @@ static int core_scsi3_emulate_pro_register_and_move(
 	unsigned char proto_ident;
 
 	if (!(se_sess) || !(se_lun)) {
-		printk(KERN_ERR "SPC-3 PR: se_sess || struct se_lun is NULL!\n");
+		pr_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 	}
 	memset(dest_iport, 0, 64);
@@ -3339,7 +3339,7 @@ static int core_scsi3_emulate_pro_register_and_move(
 	pr_reg = core_scsi3_locate_pr_reg(cmd->se_dev, se_sess->se_node_acl,
 				se_sess);
 	if (!(pr_reg)) {
-		printk(KERN_ERR "SPC-3 PR: Unable to locate PR_REGISTERED"
+		pr_err("SPC-3 PR: Unable to locate PR_REGISTERED"
 			" *pr_reg for REGISTER_AND_MOVE\n");
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 	}
@@ -3348,7 +3348,7 @@ static int core_scsi3_emulate_pro_register_and_move(
 	 * provided during this initiator's I_T nexus registration.
 	 */
 	if (res_key != pr_reg->pr_res_key) {
-		printk(KERN_WARNING "SPC-3 PR REGISTER_AND_MOVE: Received"
+		pr_warn("SPC-3 PR REGISTER_AND_MOVE: Received"
 			" res_key: 0x%016Lx does not match existing SA REGISTER"
 			" res_key: 0x%016Lx\n", res_key, pr_reg->pr_res_key);
 		core_scsi3_put_pr_reg(pr_reg);
@@ -3358,7 +3358,7 @@ static int core_scsi3_emulate_pro_register_and_move(
 	 * The service active reservation key needs to be non zero
 	 */
 	if (!(sa_res_key)) {
-		printk(KERN_WARNING "SPC-3 PR REGISTER_AND_MOVE: Received zero"
+		pr_warn("SPC-3 PR REGISTER_AND_MOVE: Received zero"
 			" sa_res_key\n");
 		core_scsi3_put_pr_reg(pr_reg);
 		return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
@@ -3380,7 +3380,7 @@ static int core_scsi3_emulate_pro_register_and_move(
 	buf = NULL;
 
 	if ((tid_len + 24) != cmd->data_length) {
-		printk(KERN_ERR "SPC-3 PR: Illegal tid_len: %u + 24 byte header"
+		pr_err("SPC-3 PR: Illegal tid_len: %u + 24 byte header"
 			" does not equal CDB data_length: %u\n", tid_len,
 			cmd->data_length);
 		core_scsi3_put_pr_reg(pr_reg);
@@ -3404,7 +3404,7 @@ static int core_scsi3_emulate_pro_register_and_move(
 
 		ret = core_scsi3_tpg_depend_item(dest_se_tpg);
 		if (ret != 0) {
-			printk(KERN_ERR "core_scsi3_tpg_depend_item() failed"
+			pr_err("core_scsi3_tpg_depend_item() failed"
 				" for dest_se_tpg\n");
 			atomic_dec(&dest_se_tpg->tpg_pr_ref_count);
 			smp_mb__after_atomic_dec();
@@ -3418,7 +3418,7 @@ static int core_scsi3_emulate_pro_register_and_move(
 	spin_unlock(&dev->se_port_lock);
 
 	if (!(dest_se_tpg) || (!dest_tf_ops)) {
-		printk(KERN_ERR "SPC-3 PR REGISTER_AND_MOVE: Unable to locate"
+		pr_err("SPC-3 PR REGISTER_AND_MOVE: Unable to locate"
 			" fabric ops from Relative Target Port Identifier:"
 			" %hu\n", rtpi);
 		core_scsi3_put_pr_reg(pr_reg);
@@ -3428,11 +3428,11 @@ static int core_scsi3_emulate_pro_register_and_move(
 	buf = transport_kmap_first_data_page(cmd);
 	proto_ident = (buf[24] & 0x0f);
 #if 0
-	printk("SPC-3 PR REGISTER_AND_MOVE: Extracted Protocol Identifier:"
+	pr_debug("SPC-3 PR REGISTER_AND_MOVE: Extracted Protocol Identifier:"
 			" 0x%02x\n", proto_ident);
 #endif
 	if (proto_ident != dest_tf_ops->get_fabric_proto_ident(dest_se_tpg)) {
-		printk(KERN_ERR "SPC-3 PR REGISTER_AND_MOVE: Received"
+		pr_err("SPC-3 PR REGISTER_AND_MOVE: Received"
 			" proto_ident: 0x%02x does not match ident: 0x%02x"
 			" from fabric: %s\n", proto_ident,
 			dest_tf_ops->get_fabric_proto_ident(dest_se_tpg),
@@ -3441,7 +3441,7 @@ static int core_scsi3_emulate_pro_register_and_move(
 		goto out;
 	}
 	if (dest_tf_ops->tpg_parse_pr_out_transport_id == NULL) {
-		printk(KERN_ERR "SPC-3 PR REGISTER_AND_MOVE: Fabric does not"
+		pr_err("SPC-3 PR REGISTER_AND_MOVE: Fabric does not"
 			" containg a valid tpg_parse_pr_out_transport_id"
 			" function pointer\n");
 		ret = PYX_TRANSPORT_LU_COMM_FAILURE;
@@ -3450,7 +3450,7 @@ static int core_scsi3_emulate_pro_register_and_move(
 	initiator_str = dest_tf_ops->tpg_parse_pr_out_transport_id(dest_se_tpg,
 			(const char *)&buf[24], &tmp_tid_len, &iport_ptr);
 	if (!(initiator_str)) {
-		printk(KERN_ERR "SPC-3 PR REGISTER_AND_MOVE: Unable to locate"
+		pr_err("SPC-3 PR REGISTER_AND_MOVE: Unable to locate"
 			" initiator_str from Transport ID\n");
 		ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 		goto out;
@@ -3459,7 +3459,7 @@ static int core_scsi3_emulate_pro_register_and_move(
 	transport_kunmap_first_data_page(cmd);
 	buf = NULL;
 
-	printk(KERN_INFO "SPC-3 PR [%s] Extracted initiator %s identifier: %s"
+	pr_debug("SPC-3 PR [%s] Extracted initiator %s identifier: %s"
 		" %s\n", dest_tf_ops->get_fabric_name(), (iport_ptr != NULL) ?
 		"port" : "device", initiator_str, (iport_ptr != NULL) ?
 		iport_ptr : "");
@@ -3478,14 +3478,14 @@ static int core_scsi3_emulate_pro_register_and_move(
 		goto after_iport_check;
 
 	if (!(iport_ptr) || !(pr_reg->isid_present_at_reg)) {
-		printk(KERN_ERR "SPC-3 PR REGISTER_AND_MOVE: TransportID: %s"
+		pr_err("SPC-3 PR REGISTER_AND_MOVE: TransportID: %s"
 			" matches: %s on received I_T Nexus\n", initiator_str,
 			pr_reg_nacl->initiatorname);
 		ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 		goto out;
 	}
 	if (!(strcmp(iport_ptr, pr_reg->pr_reg_isid))) {
-		printk(KERN_ERR "SPC-3 PR REGISTER_AND_MOVE: TransportID: %s %s"
+		pr_err("SPC-3 PR REGISTER_AND_MOVE: TransportID: %s %s"
 			" matches: %s %s on received I_T Nexus\n",
 			initiator_str, iport_ptr, pr_reg_nacl->initiatorname,
 			pr_reg->pr_reg_isid);
@@ -3506,7 +3506,7 @@ after_iport_check:
 	spin_unlock_bh(&dest_se_tpg->acl_node_lock);
 
 	if (!(dest_node_acl)) {
-		printk(KERN_ERR "Unable to locate %s dest_node_acl for"
+		pr_err("Unable to locate %s dest_node_acl for"
 			" TransportID%s\n", dest_tf_ops->get_fabric_name(),
 			initiator_str);
 		ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
@@ -3514,7 +3514,7 @@ after_iport_check:
 	}
 	ret = core_scsi3_nodeacl_depend_item(dest_node_acl);
 	if (ret != 0) {
-		printk(KERN_ERR "core_scsi3_nodeacl_depend_item() for"
+		pr_err("core_scsi3_nodeacl_depend_item() for"
 			" dest_node_acl\n");
 		atomic_dec(&dest_node_acl->acl_pr_ref_count);
 		smp_mb__after_atomic_dec();
@@ -3523,7 +3523,7 @@ after_iport_check:
 		goto out;
 	}
 #if 0
-	printk(KERN_INFO "SPC-3 PR REGISTER_AND_MOVE: Found %s dest_node_acl:"
+	pr_debug("SPC-3 PR REGISTER_AND_MOVE: Found %s dest_node_acl:"
 		" %s from TransportID\n", dest_tf_ops->get_fabric_name(),
 		dest_node_acl->initiatorname);
 #endif
@@ -3533,7 +3533,7 @@ after_iport_check:
 	 */
 	dest_se_deve = core_get_se_deve_from_rtpi(dest_node_acl, rtpi);
 	if (!(dest_se_deve)) {
-		printk(KERN_ERR "Unable to locate %s dest_se_deve from RTPI:"
+		pr_err("Unable to locate %s dest_se_deve from RTPI:"
 			" %hu\n",  dest_tf_ops->get_fabric_name(), rtpi);
 		ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 		goto out;
@@ -3541,7 +3541,7 @@ after_iport_check:
 
 	ret = core_scsi3_lunacl_depend_item(dest_se_deve);
 	if (ret < 0) {
-		printk(KERN_ERR "core_scsi3_lunacl_depend_item() failed\n");
+		pr_err("core_scsi3_lunacl_depend_item() failed\n");
 		atomic_dec(&dest_se_deve->pr_ref_count);
 		smp_mb__after_atomic_dec();
 		dest_se_deve = NULL;
@@ -3549,7 +3549,7 @@ after_iport_check:
 		goto out;
 	}
 #if 0
-	printk(KERN_INFO "SPC-3 PR REGISTER_AND_MOVE: Located %s node %s LUN"
+	pr_debug("SPC-3 PR REGISTER_AND_MOVE: Located %s node %s LUN"
 		" ACL for dest_se_deve->mapped_lun: %u\n",
 		dest_tf_ops->get_fabric_name(), dest_node_acl->initiatorname,
 		dest_se_deve->mapped_lun);
@@ -3561,7 +3561,7 @@ after_iport_check:
 	spin_lock(&dev->dev_reservation_lock);
 	pr_res_holder = dev->dev_pr_res_holder;
 	if (!(pr_res_holder)) {
-		printk(KERN_WARNING "SPC-3 PR REGISTER_AND_MOVE: No reservation"
+		pr_warn("SPC-3 PR REGISTER_AND_MOVE: No reservation"
 			" currently held\n");
 		spin_unlock(&dev->dev_reservation_lock);
 		ret = PYX_TRANSPORT_INVALID_CDB_FIELD;
@@ -3574,7 +3574,7 @@ after_iport_check:
 	 * 	Register behaviors for a REGISTER AND MOVE service action
 	 */
 	if (pr_res_holder != pr_reg) {
-		printk(KERN_WARNING "SPC-3 PR REGISTER_AND_MOVE: Calling I_T"
+		pr_warn("SPC-3 PR REGISTER_AND_MOVE: Calling I_T"
 			" Nexus is not reservation holder\n");
 		spin_unlock(&dev->dev_reservation_lock);
 		ret = PYX_TRANSPORT_RESERVATION_CONFLICT;
@@ -3591,7 +3591,7 @@ after_iport_check:
 	 */
 	if ((pr_res_holder->pr_res_type == PR_TYPE_WRITE_EXCLUSIVE_ALLREG) ||
 	    (pr_res_holder->pr_res_type == PR_TYPE_EXCLUSIVE_ACCESS_ALLREG)) {
-		printk(KERN_WARNING "SPC-3 PR REGISTER_AND_MOVE: Unable to move"
+		pr_warn("SPC-3 PR REGISTER_AND_MOVE: Unable to move"
 			" reservation for type: %s\n",
 			core_scsi3_pr_dump_type(pr_res_holder->pr_res_type));
 		spin_unlock(&dev->dev_reservation_lock);
@@ -3663,12 +3663,12 @@ after_iport_check:
 		dest_pr_reg->pr_res_generation = pr_tmpl->pr_generation++;
 	spin_unlock(&dev->dev_reservation_lock);
 
-	printk(KERN_INFO "SPC-3 PR [%s] Service Action: REGISTER_AND_MOVE"
+	pr_debug("SPC-3 PR [%s] Service Action: REGISTER_AND_MOVE"
 		" created new reservation holder TYPE: %s on object RTPI:"
 		" %hu  PRGeneration: 0x%08x\n", dest_tf_ops->get_fabric_name(),
 		core_scsi3_pr_dump_type(type), rtpi,
 		dest_pr_reg->pr_res_generation);
-	printk(KERN_INFO "SPC-3 PR Successfully moved reservation from"
+	pr_debug("SPC-3 PR Successfully moved reservation from"
 		" %s Fabric Node: %s%s -> %s Fabric Node: %s %s\n",
 		tf_ops->get_fabric_name(), pr_reg_nacl->initiatorname,
 		(prf_isid) ? &i_buf[0] : "", dest_tf_ops->get_fabric_name(),
@@ -3699,7 +3699,7 @@ after_iport_check:
 	if (!(aptpl)) {
 		pr_tmpl->pr_aptpl_active = 0;
 		core_scsi3_update_and_write_aptpl(cmd->se_dev, NULL, 0);
-		printk("SPC-3 PR: Set APTPL Bit Deactivated for"
+		pr_debug("SPC-3 PR: Set APTPL Bit Deactivated for"
 				" REGISTER_AND_MOVE\n");
 	} else {
 		pr_tmpl->pr_aptpl_active = 1;
@@ -3707,7 +3707,7 @@ after_iport_check:
 				&dest_pr_reg->pr_aptpl_buf[0],
 				pr_tmpl->pr_aptpl_buf_len);
 		if (!(ret))
-			printk("SPC-3 PR: Set APTPL Bit Activated for"
+			pr_debug("SPC-3 PR: Set APTPL Bit Activated for"
 					" REGISTER_AND_MOVE\n");
 	}
 
@@ -3754,7 +3754,7 @@ static int core_scsi3_emulate_pr_out(struct se_cmd *cmd, unsigned char *cdb)
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 
 	if (cmd->data_length < 24) {
-		printk(KERN_WARNING "SPC-PR: Received PR OUT parameter list"
+		pr_warn("SPC-PR: Received PR OUT parameter list"
 			" length too small: %u\n", cmd->data_length);
 		return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 	}
@@ -3802,7 +3802,7 @@ static int core_scsi3_emulate_pr_out(struct se_cmd *cmd, unsigned char *cdb)
 	 */
 	if (!(spec_i_pt) && ((cdb[1] & 0x1f) != PRO_REGISTER_AND_MOVE) &&
 	    (cmd->data_length != 24)) {
-		printk(KERN_WARNING "SPC-PR: Received PR OUT illegal parameter"
+		pr_warn("SPC-PR: Received PR OUT illegal parameter"
 			" list length: %u\n", cmd->data_length);
 		return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 	}
@@ -3836,7 +3836,7 @@ static int core_scsi3_emulate_pr_out(struct se_cmd *cmd, unsigned char *cdb)
 		return core_scsi3_emulate_pro_register_and_move(cmd, res_key,
 				sa_res_key, aptpl, unreg);
 	default:
-		printk(KERN_ERR "Unknown PERSISTENT_RESERVE_OUT service"
+		pr_err("Unknown PERSISTENT_RESERVE_OUT service"
 			" action: 0x%02x\n", cdb[1] & 0x1f);
 		return PYX_TRANSPORT_INVALID_CDB_FIELD;
 	}
@@ -3858,7 +3858,7 @@ static int core_scsi3_pri_read_keys(struct se_cmd *cmd)
 	u32 add_len = 0, off = 8;
 
 	if (cmd->data_length < 8) {
-		printk(KERN_ERR "PRIN SA READ_KEYS SCSI Data Length: %u"
+		pr_err("PRIN SA READ_KEYS SCSI Data Length: %u"
 			" too small\n", cmd->data_length);
 		return PYX_TRANSPORT_INVALID_CDB_FIELD;
 	}
@@ -3917,7 +3917,7 @@ static int core_scsi3_pri_read_reservation(struct se_cmd *cmd)
 	u32 add_len = 16; /* Hardcoded to 16 when a reservation is held. */
 
 	if (cmd->data_length < 8) {
-		printk(KERN_ERR "PRIN SA READ_RESERVATIONS SCSI Data Length: %u"
+		pr_err("PRIN SA READ_RESERVATIONS SCSI Data Length: %u"
 			" too small\n", cmd->data_length);
 		return PYX_TRANSPORT_INVALID_CDB_FIELD;
 	}
@@ -4000,7 +4000,7 @@ static int core_scsi3_pri_report_capabilities(struct se_cmd *cmd)
 	u16 add_len = 8; /* Hardcoded to 8. */
 
 	if (cmd->data_length < 6) {
-		printk(KERN_ERR "PRIN SA REPORT_CAPABILITIES SCSI Data Length:"
+		pr_err("PRIN SA REPORT_CAPABILITIES SCSI Data Length:"
 			" %u too small\n", cmd->data_length);
 		return PYX_TRANSPORT_INVALID_CDB_FIELD;
 	}
@@ -4061,7 +4061,7 @@ static int core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 	int format_code = 0;
 
 	if (cmd->data_length < 8) {
-		printk(KERN_ERR "PRIN SA READ_FULL_STATUS SCSI Data Length: %u"
+		pr_err("PRIN SA READ_FULL_STATUS SCSI Data Length: %u"
 			" too small\n", cmd->data_length);
 		return PYX_TRANSPORT_INVALID_CDB_FIELD;
 	}
@@ -4092,7 +4092,7 @@ static int core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 				se_tpg, se_nacl, pr_reg, &format_code);
 
 		if ((exp_desc_len + add_len) > cmd->data_length) {
-			printk(KERN_WARNING "SPC-3 PRIN READ_FULL_STATUS ran"
+			pr_warn("SPC-3 PRIN READ_FULL_STATUS ran"
 				" out of buffer: %d\n", cmd->data_length);
 			spin_lock(&pr_tmpl->registration_lock);
 			atomic_dec(&pr_reg->pr_res_holders);
@@ -4204,7 +4204,7 @@ static int core_scsi3_emulate_pr_in(struct se_cmd *cmd, unsigned char *cdb)
 	case PRI_READ_FULL_STATUS:
 		return core_scsi3_pri_read_full_status(cmd);
 	default:
-		printk(KERN_ERR "Unknown PERSISTENT_RESERVE_IN service"
+		pr_err("Unknown PERSISTENT_RESERVE_IN service"
 			" action: 0x%02x\n", cdb[1] & 0x1f);
 		return PYX_TRANSPORT_INVALID_CDB_FIELD;
 	}
@@ -4225,7 +4225,7 @@ int core_scsi3_emulate_pr(struct se_cmd *cmd)
 	 * CONFLICT status.
 	 */
 	if (dev->dev_flags & DF_SPC2_RESERVATIONS) {
-		printk(KERN_ERR "Received PERSISTENT_RESERVE CDB while legacy"
+		pr_err("Received PERSISTENT_RESERVE CDB while legacy"
 			" SPC-2 reservation is held, returning"
 			" RESERVATION_CONFLICT\n");
 		return PYX_TRANSPORT_RESERVATION_CONFLICT;
@@ -4264,7 +4264,7 @@ int core_setup_reservations(struct se_device *dev, int force_pt)
 		rest->res_type = SPC_PASSTHROUGH;
 		rest->pr_ops.t10_reservation_check = &core_pt_reservation_check;
 		rest->pr_ops.t10_seq_non_holder = &core_pt_seq_non_holder;
-		printk(KERN_INFO "%s: Using SPC_PASSTHROUGH, no reservation"
+		pr_debug("%s: Using SPC_PASSTHROUGH, no reservation"
 			" emulation\n", dev->transport->name);
 		return 0;
 	}
@@ -4276,14 +4276,14 @@ int core_setup_reservations(struct se_device *dev, int force_pt)
 		rest->res_type = SPC3_PERSISTENT_RESERVATIONS;
 		rest->pr_ops.t10_reservation_check = &core_scsi3_pr_reservation_check;
 		rest->pr_ops.t10_seq_non_holder = &core_scsi3_pr_seq_non_holder;
-		printk(KERN_INFO "%s: Using SPC3_PERSISTENT_RESERVATIONS"
+		pr_debug("%s: Using SPC3_PERSISTENT_RESERVATIONS"
 			" emulation\n", dev->transport->name);
 	} else {
 		rest->res_type = SPC2_RESERVATIONS;
 		rest->pr_ops.t10_reservation_check = &core_scsi2_reservation_check;
 		rest->pr_ops.t10_seq_non_holder =
 				&core_scsi2_reservation_seq_non_holder;
-		printk(KERN_INFO "%s: Using SPC2_RESERVATIONS emulation\n",
+		pr_debug("%s: Using SPC2_RESERVATIONS emulation\n",
 			dev->transport->name);
 	}
 
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 2c82b0a..04db999 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -66,7 +66,7 @@ static int pscsi_attach_hba(struct se_hba *hba, u32 host_id)
 
 	phv = kzalloc(sizeof(struct pscsi_hba_virt), GFP_KERNEL);
 	if (!(phv)) {
-		printk(KERN_ERR "Unable to allocate struct pscsi_hba_virt\n");
+		pr_err("Unable to allocate struct pscsi_hba_virt\n");
 		return -ENOMEM;
 	}
 	phv->phv_host_id = host_id;
@@ -74,10 +74,10 @@ static int pscsi_attach_hba(struct se_hba *hba, u32 host_id)
 
 	hba->hba_ptr = phv;
 
-	printk(KERN_INFO "CORE_HBA[%d] - TCM SCSI HBA Driver %s on"
+	pr_debug("CORE_HBA[%d] - TCM SCSI HBA Driver %s on"
 		" Generic Target Core Stack %s\n", hba->hba_id,
 		PSCSI_VERSION, TARGET_CORE_MOD_VERSION);
-	printk(KERN_INFO "CORE_HBA[%d] - Attached SCSI HBA to Generic\n",
+	pr_debug("CORE_HBA[%d] - Attached SCSI HBA to Generic\n",
 	       hba->hba_id);
 
 	return 0;
@@ -91,12 +91,12 @@ static void pscsi_detach_hba(struct se_hba *hba)
 	if (scsi_host) {
 		scsi_host_put(scsi_host);
 
-		printk(KERN_INFO "CORE_HBA[%d] - Detached SCSI HBA: %s from"
+		pr_debug("CORE_HBA[%d] - Detached SCSI HBA: %s from"
 			" Generic Target Core\n", hba->hba_id,
 			(scsi_host->hostt->name) ? (scsi_host->hostt->name) :
 			"Unknown");
 	} else
-		printk(KERN_INFO "CORE_HBA[%d] - Detached Virtual SCSI HBA"
+		pr_debug("CORE_HBA[%d] - Detached Virtual SCSI HBA"
 			" from Generic Target Core\n", hba->hba_id);
 
 	kfree(phv);
@@ -117,7 +117,7 @@ static int pscsi_pmode_enable_hba(struct se_hba *hba, unsigned long mode_flag)
 		phv->phv_lld_host = NULL;
 		phv->phv_mode = PHV_VIRUTAL_HOST_ID;
 
-		printk(KERN_INFO "CORE_HBA[%d] - Disabled pSCSI HBA Passthrough"
+		pr_debug("CORE_HBA[%d] - Disabled pSCSI HBA Passthrough"
 			" %s\n", hba->hba_id, (sh->hostt->name) ?
 			(sh->hostt->name) : "Unknown");
 
@@ -130,7 +130,7 @@ static int pscsi_pmode_enable_hba(struct se_hba *hba, unsigned long mode_flag)
 	 */
 	sh = scsi_host_lookup(phv->phv_host_id);
 	if (IS_ERR(sh)) {
-		printk(KERN_ERR "pSCSI: Unable to locate SCSI Host for"
+		pr_err("pSCSI: Unable to locate SCSI Host for"
 			" phv_host_id: %d\n", phv->phv_host_id);
 		return PTR_ERR(sh);
 	}
@@ -138,7 +138,7 @@ static int pscsi_pmode_enable_hba(struct se_hba *hba, unsigned long mode_flag)
 	phv->phv_lld_host = sh;
 	phv->phv_mode = PHV_LLD_SCSI_HOST_NO;
 
-	printk(KERN_INFO "CORE_HBA[%d] - Enabled pSCSI HBA Passthrough %s\n",
+	pr_debug("CORE_HBA[%d] - Enabled pSCSI HBA Passthrough %s\n",
 		hba->hba_id, (sh->hostt->name) ? (sh->hostt->name) : "Unknown");
 
 	return 1;
@@ -257,15 +257,15 @@ pscsi_get_inquiry_vpd_device_ident(struct scsi_device *sdev,
 		page_83 = &buf[off];
 		ident_len = page_83[3];
 		if (!ident_len) {
-			printk(KERN_ERR "page_83[3]: identifier"
+			pr_err("page_83[3]: identifier"
 					" length zero!\n");
 			break;
 		}
-		printk(KERN_INFO "T10 VPD Identifer Length: %d\n", ident_len);
+		pr_debug("T10 VPD Identifer Length: %d\n", ident_len);
 
 		vpd = kzalloc(sizeof(struct t10_vpd), GFP_KERNEL);
 		if (!vpd) {
-			printk(KERN_ERR "Unable to allocate memory for"
+			pr_err("Unable to allocate memory for"
 					" struct t10_vpd\n");
 			goto out;
 		}
@@ -317,7 +317,7 @@ static struct se_device *pscsi_add_device_to_list(
 	if (!sd->queue_depth) {
 		sd->queue_depth = PSCSI_DEFAULT_QUEUEDEPTH;
 
-		printk(KERN_ERR "Set broken SCSI Device %d:%d:%d"
+		pr_err("Set broken SCSI Device %d:%d:%d"
 			" queue_depth to %d\n", sd->channel, sd->id,
 				sd->lun, sd->queue_depth);
 	}
@@ -386,12 +386,12 @@ static void *pscsi_allocate_virtdevice(struct se_hba *hba, const char *name)
 
 	pdv = kzalloc(sizeof(struct pscsi_dev_virt), GFP_KERNEL);
 	if (!(pdv)) {
-		printk(KERN_ERR "Unable to allocate memory for struct pscsi_dev_virt\n");
+		pr_err("Unable to allocate memory for struct pscsi_dev_virt\n");
 		return NULL;
 	}
 	pdv->pdv_se_hba = hba;
 
-	printk(KERN_INFO "PSCSI: Allocated pdv: %p for %s\n", pdv, name);
+	pr_debug("PSCSI: Allocated pdv: %p for %s\n", pdv, name);
 	return pdv;
 }
 
@@ -412,7 +412,7 @@ static struct se_device *pscsi_create_type_disk(
 	u32 dev_flags = 0;
 
 	if (scsi_device_get(sd)) {
-		printk(KERN_ERR "scsi_device_get() failed for %d:%d:%d:%d\n",
+		pr_err("scsi_device_get() failed for %d:%d:%d:%d\n",
 			sh->host_no, sd->channel, sd->id, sd->lun);
 		spin_unlock_irq(sh->host_lock);
 		return NULL;
@@ -425,7 +425,7 @@ static struct se_device *pscsi_create_type_disk(
 	bd = blkdev_get_by_path(se_dev->se_dev_udev_path,
 				FMODE_WRITE|FMODE_READ|FMODE_EXCL, pdv);
 	if (IS_ERR(bd)) {
-		printk(KERN_ERR "pSCSI: blkdev_get_by_path() failed\n");
+		pr_err("pSCSI: blkdev_get_by_path() failed\n");
 		scsi_device_put(sd);
 		return NULL;
 	}
@@ -437,7 +437,7 @@ static struct se_device *pscsi_create_type_disk(
 		scsi_device_put(sd);
 		return NULL;
 	}
-	printk(KERN_INFO "CORE_PSCSI[%d] - Added TYPE_DISK for %d:%d:%d:%d\n",
+	pr_debug("CORE_PSCSI[%d] - Added TYPE_DISK for %d:%d:%d:%d\n",
 		phv->phv_host_id, sh->host_no, sd->channel, sd->id, sd->lun);
 
 	return dev;
@@ -459,7 +459,7 @@ static struct se_device *pscsi_create_type_rom(
 	u32 dev_flags = 0;
 
 	if (scsi_device_get(sd)) {
-		printk(KERN_ERR "scsi_device_get() failed for %d:%d:%d:%d\n",
+		pr_err("scsi_device_get() failed for %d:%d:%d:%d\n",
 			sh->host_no, sd->channel, sd->id, sd->lun);
 		spin_unlock_irq(sh->host_lock);
 		return NULL;
@@ -471,7 +471,7 @@ static struct se_device *pscsi_create_type_rom(
 		scsi_device_put(sd);
 		return NULL;
 	}
-	printk(KERN_INFO "CORE_PSCSI[%d] - Added Type: %s for %d:%d:%d:%d\n",
+	pr_debug("CORE_PSCSI[%d] - Added Type: %s for %d:%d:%d:%d\n",
 		phv->phv_host_id, scsi_device_type(sd->type), sh->host_no,
 		sd->channel, sd->id, sd->lun);
 
@@ -498,7 +498,7 @@ static struct se_device *pscsi_create_type_other(
 	if (!(dev))
 		return NULL;
 
-	printk(KERN_INFO "CORE_PSCSI[%d] - Added Type: %s for %d:%d:%d:%d\n",
+	pr_debug("CORE_PSCSI[%d] - Added Type: %s for %d:%d:%d:%d\n",
 		phv->phv_host_id, scsi_device_type(sd->type), sh->host_no,
 		sd->channel, sd->id, sd->lun);
 
@@ -518,7 +518,7 @@ static struct se_device *pscsi_create_virtdevice(
 	int legacy_mode_enable = 0;
 
 	if (!(pdv)) {
-		printk(KERN_ERR "Unable to locate struct pscsi_dev_virt"
+		pr_err("Unable to locate struct pscsi_dev_virt"
 				" parameter\n");
 		return ERR_PTR(-EINVAL);
 	}
@@ -528,7 +528,7 @@ static struct se_device *pscsi_create_virtdevice(
 	 */
 	if (!(sh)) {
 		if (phv->phv_mode == PHV_LLD_SCSI_HOST_NO) {
-			printk(KERN_ERR "pSCSI: Unable to locate struct"
+			pr_err("pSCSI: Unable to locate struct"
 				" Scsi_Host for PHV_LLD_SCSI_HOST_NO\n");
 			return ERR_PTR(-ENODEV);
 		}
@@ -537,7 +537,7 @@ static struct se_device *pscsi_create_virtdevice(
 		 * reference, we enforce that udev_path has been set
 		 */
 		if (!(se_dev->su_dev_flags & SDF_USING_UDEV_PATH)) {
-			printk(KERN_ERR "pSCSI: udev_path attribute has not"
+			pr_err("pSCSI: udev_path attribute has not"
 				" been set before ENABLE=1\n");
 			return ERR_PTR(-EINVAL);
 		}
@@ -549,7 +549,7 @@ static struct se_device *pscsi_create_virtdevice(
 		if (!(pdv->pdv_flags & PDF_HAS_VIRT_HOST_ID)) {
 			spin_lock(&hba->device_lock);
 			if (!(list_empty(&hba->hba_dev_list))) {
-				printk(KERN_ERR "pSCSI: Unable to set hba_mode"
+				pr_err("pSCSI: Unable to set hba_mode"
 					" with active devices\n");
 				spin_unlock(&hba->device_lock);
 				return ERR_PTR(-EEXIST);
@@ -565,14 +565,14 @@ static struct se_device *pscsi_create_virtdevice(
 		} else {
 			sh = scsi_host_lookup(pdv->pdv_host_id);
 			if (IS_ERR(sh)) {
-				printk(KERN_ERR "pSCSI: Unable to locate"
+				pr_err("pSCSI: Unable to locate"
 					" pdv_host_id: %d\n", pdv->pdv_host_id);
 				return (struct se_device *) sh;
 			}
 		}
 	} else {
 		if (phv->phv_mode == PHV_VIRUTAL_HOST_ID) {
-			printk(KERN_ERR "pSCSI: PHV_VIRUTAL_HOST_ID set while"
+			pr_err("pSCSI: PHV_VIRUTAL_HOST_ID set while"
 				" struct Scsi_Host exists\n");
 			return ERR_PTR(-EEXIST);
 		}
@@ -615,7 +615,7 @@ static struct se_device *pscsi_create_virtdevice(
 	}
 	spin_unlock_irq(sh->host_lock);
 
-	printk(KERN_ERR "pSCSI: Unable to locate %d:%d:%d:%d\n", sh->host_no,
+	pr_err("pSCSI: Unable to locate %d:%d:%d:%d\n", sh->host_no,
 		pdv->pdv_channel_id,  pdv->pdv_target_id, pdv->pdv_lun_id);
 
 	if (phv->phv_mode == PHV_VIRUTAL_HOST_ID)
@@ -730,7 +730,7 @@ after_mode_sense:
 
 		buf = sg_virt(&sg[0]);
 		if (!(buf)) {
-			printk(KERN_ERR "Unable to get buf for scatterlist\n");
+			pr_err("Unable to get buf for scatterlist\n");
 			goto after_mode_select;
 		}
 
@@ -767,7 +767,7 @@ pscsi_alloc_task(struct se_cmd *cmd)
 
 	pt = kzalloc(sizeof(struct pscsi_plugin_task), GFP_KERNEL);
 	if (!pt) {
-		printk(KERN_ERR "Unable to allocate struct pscsi_plugin_task\n");
+		pr_err("Unable to allocate struct pscsi_plugin_task\n");
 		return NULL;
 	}
 
@@ -780,7 +780,7 @@ pscsi_alloc_task(struct se_cmd *cmd)
 
 		pt->pscsi_cdb = kzalloc(scsi_command_size(cdb), GFP_KERNEL);
 		if (!(pt->pscsi_cdb)) {
-			printk(KERN_ERR "pSCSI: Unable to allocate extended"
+			pr_err("pSCSI: Unable to allocate extended"
 					" pt->pscsi_cdb\n");
 			kfree(pt);
 			return NULL;
@@ -838,7 +838,7 @@ static int pscsi_blk_get_request(struct se_task *task)
 			(task->task_data_direction == DMA_TO_DEVICE),
 			GFP_KERNEL);
 	if (!(pt->pscsi_req) || IS_ERR(pt->pscsi_req)) {
-		printk(KERN_ERR "PSCSI: blk_get_request() failed: %ld\n",
+		pr_err("PSCSI: blk_get_request() failed: %ld\n",
 				IS_ERR(pt->pscsi_req));
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 	}
@@ -936,7 +936,7 @@ static ssize_t pscsi_set_configfs_dev_params(struct se_hba *hba,
 		switch (token) {
 		case Opt_scsi_host_id:
 			if (phv->phv_mode == PHV_LLD_SCSI_HOST_NO) {
-				printk(KERN_ERR "PSCSI[%d]: Unable to accept"
+				pr_err("PSCSI[%d]: Unable to accept"
 					" scsi_host_id while phv_mode =="
 					" PHV_LLD_SCSI_HOST_NO\n",
 					phv->phv_host_id);
@@ -945,14 +945,14 @@ static ssize_t pscsi_set_configfs_dev_params(struct se_hba *hba,
 			}
 			match_int(args, &arg);
 			pdv->pdv_host_id = arg;
-			printk(KERN_INFO "PSCSI[%d]: Referencing SCSI Host ID:"
+			pr_debug("PSCSI[%d]: Referencing SCSI Host ID:"
 				" %d\n", phv->phv_host_id, pdv->pdv_host_id);
 			pdv->pdv_flags |= PDF_HAS_VIRT_HOST_ID;
 			break;
 		case Opt_scsi_channel_id:
 			match_int(args, &arg);
 			pdv->pdv_channel_id = arg;
-			printk(KERN_INFO "PSCSI[%d]: Referencing SCSI Channel"
+			pr_debug("PSCSI[%d]: Referencing SCSI Channel"
 				" ID: %d\n",  phv->phv_host_id,
 				pdv->pdv_channel_id);
 			pdv->pdv_flags |= PDF_HAS_CHANNEL_ID;
@@ -960,7 +960,7 @@ static ssize_t pscsi_set_configfs_dev_params(struct se_hba *hba,
 		case Opt_scsi_target_id:
 			match_int(args, &arg);
 			pdv->pdv_target_id = arg;
-			printk(KERN_INFO "PSCSI[%d]: Referencing SCSI Target"
+			pr_debug("PSCSI[%d]: Referencing SCSI Target"
 				" ID: %d\n", phv->phv_host_id,
 				pdv->pdv_target_id);
 			pdv->pdv_flags |= PDF_HAS_TARGET_ID;
@@ -968,7 +968,7 @@ static ssize_t pscsi_set_configfs_dev_params(struct se_hba *hba,
 		case Opt_scsi_lun_id:
 			match_int(args, &arg);
 			pdv->pdv_lun_id = arg;
-			printk(KERN_INFO "PSCSI[%d]: Referencing SCSI LUN ID:"
+			pr_debug("PSCSI[%d]: Referencing SCSI LUN ID:"
 				" %d\n", phv->phv_host_id, pdv->pdv_lun_id);
 			pdv->pdv_flags |= PDF_HAS_LUN_ID;
 			break;
@@ -991,7 +991,7 @@ static ssize_t pscsi_check_configfs_dev_params(
 	if (!(pdv->pdv_flags & PDF_HAS_CHANNEL_ID) ||
 	    !(pdv->pdv_flags & PDF_HAS_TARGET_ID) ||
 	    !(pdv->pdv_flags & PDF_HAS_LUN_ID)) {
-		printk(KERN_ERR "Missing scsi_channel_id=, scsi_target_id= and"
+		pr_err("Missing scsi_channel_id=, scsi_target_id= and"
 			" scsi_lun_id= parameters\n");
 		return -EINVAL;
 	}
@@ -1062,7 +1062,7 @@ static inline struct bio *pscsi_get_bio(int sg_num)
 	 */
 	bio = bio_kmalloc(GFP_KERNEL, sg_num);
 	if (!(bio)) {
-		printk(KERN_ERR "PSCSI: bio_kmalloc() failed\n");
+		pr_err("PSCSI: bio_kmalloc() failed\n");
 		return NULL;
 	}
 	bio->bi_end_io = pscsi_bi_endio;
@@ -1070,12 +1070,6 @@ static inline struct bio *pscsi_get_bio(int sg_num)
 	return bio;
 }
 
-#if 0
-#define DEBUG_PSCSI(x...) printk(x)
-#else
-#define DEBUG_PSCSI(x...)
-#endif
-
 static int __pscsi_map_task_SG(
 	struct se_task *task,
 	struct scatterlist *task_sg,
@@ -1106,14 +1100,14 @@ static int __pscsi_map_task_SG(
 	 * is ported to upstream SCSI passthrough functionality that accepts
 	 * struct scatterlist->page_link or struct page as a paraemeter.
 	 */
-	DEBUG_PSCSI("PSCSI: nr_pages: %d\n", nr_pages);
+	pr_debug("PSCSI: nr_pages: %d\n", nr_pages);
 
 	for_each_sg(task_sg, sg, task_sg_num, i) {
 		page = sg_page(sg);
 		off = sg->offset;
 		len = sg->length;
 
-		DEBUG_PSCSI("PSCSI: i: %d page: %p len: %d off: %d\n", i,
+		pr_debug("PSCSI: i: %d page: %p len: %d off: %d\n", i,
 			page, len, off);
 
 		while (len > 0 && data_len > 0) {
@@ -1133,7 +1127,7 @@ static int __pscsi_map_task_SG(
 				if (rw)
 					bio->bi_rw |= REQ_WRITE;
 
-				DEBUG_PSCSI("PSCSI: Allocated bio: %p,"
+				pr_debug("PSCSI: Allocated bio: %p,"
 					" dir: %s nr_vecs: %d\n", bio,
 					(rw) ? "rw" : "r", nr_vecs);
 				/*
@@ -1148,7 +1142,7 @@ static int __pscsi_map_task_SG(
 					tbio = tbio->bi_next = bio;
 			}
 
-			DEBUG_PSCSI("PSCSI: Calling bio_add_pc_page() i: %d"
+			pr_debug("PSCSI: Calling bio_add_pc_page() i: %d"
 				" bio: %p page: %p len: %d off: %d\n", i, bio,
 				page, len, off);
 
@@ -1157,11 +1151,11 @@ static int __pscsi_map_task_SG(
 			if (rc != bytes)
 				goto fail;
 
-			DEBUG_PSCSI("PSCSI: bio->bi_vcnt: %d nr_vecs: %d\n",
+			pr_debug("PSCSI: bio->bi_vcnt: %d nr_vecs: %d\n",
 				bio->bi_vcnt, nr_vecs);
 
 			if (bio->bi_vcnt > nr_vecs) {
-				DEBUG_PSCSI("PSCSI: Reached bio->bi_vcnt max:"
+				pr_debug("PSCSI: Reached bio->bi_vcnt max:"
 					" %d i: %d bio: %p, allocating another"
 					" bio\n", bio->bi_vcnt, i, bio);
 				/*
@@ -1191,7 +1185,7 @@ static int __pscsi_map_task_SG(
 		pt->pscsi_req = blk_make_request(pdv->pdv_sd->request_queue,
 					hbio, GFP_KERNEL);
 		if (!(pt->pscsi_req)) {
-			printk(KERN_ERR "pSCSI: blk_make_request() failed\n");
+			pr_err("pSCSI: blk_make_request() failed\n");
 			goto fail;
 		}
 		/*
@@ -1209,7 +1203,7 @@ static int __pscsi_map_task_SG(
 	pt->pscsi_req->next_rq = blk_make_request(pdv->pdv_sd->request_queue,
 					hbio, GFP_KERNEL);
 	if (!(pt->pscsi_req->next_rq)) {
-		printk(KERN_ERR "pSCSI: blk_make_request() failed for BIDI\n");
+		pr_err("pSCSI: blk_make_request() failed for BIDI\n");
 		goto fail;
 	}
 	pscsi_blk_init_request(task, pt, pt->pscsi_req->next_rq, 1);
@@ -1321,7 +1315,7 @@ static inline void pscsi_process_SAM_status(
 	task->task_scsi_status = status_byte(pt->pscsi_result);
 	if ((task->task_scsi_status)) {
 		task->task_scsi_status <<= 1;
-		printk(KERN_INFO "PSCSI Status Byte exception at task: %p CDB:"
+		pr_debug("PSCSI Status Byte exception at task: %p CDB:"
 			" 0x%02x Result: 0x%08x\n", task, pt->pscsi_cdb[0],
 			pt->pscsi_result);
 	}
@@ -1331,7 +1325,7 @@ static inline void pscsi_process_SAM_status(
 		transport_complete_task(task, (!task->task_scsi_status));
 		break;
 	default:
-		printk(KERN_INFO "PSCSI Host Byte exception at task: %p CDB:"
+		pr_debug("PSCSI Host Byte exception at task: %p CDB:"
 			" 0x%02x Result: 0x%08x\n", task, pt->pscsi_cdb[0],
 			pt->pscsi_result);
 		task->task_scsi_status = SAM_STAT_CHECK_CONDITION;
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 3fe3562..d9be7b4 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -46,9 +46,6 @@
 
 static struct se_subsystem_api rd_mcp_template;
 
-/* #define DEBUG_RAMDISK_MCP */
-/* #define DEBUG_RAMDISK_DR */
-
 /*	rd_attach_hba(): (Part of se_subsystem_api_t template)
  *
  *
@@ -59,7 +56,7 @@ static int rd_attach_hba(struct se_hba *hba, u32 host_id)
 
 	rd_host = kzalloc(sizeof(struct rd_host), GFP_KERNEL);
 	if (!(rd_host)) {
-		printk(KERN_ERR "Unable to allocate memory for struct rd_host\n");
+		pr_err("Unable to allocate memory for struct rd_host\n");
 		return -ENOMEM;
 	}
 
@@ -67,10 +64,10 @@ static int rd_attach_hba(struct se_hba *hba, u32 host_id)
 
 	hba->hba_ptr = rd_host;
 
-	printk(KERN_INFO "CORE_HBA[%d] - TCM Ramdisk HBA Driver %s on"
+	pr_debug("CORE_HBA[%d] - TCM Ramdisk HBA Driver %s on"
 		" Generic Target Core Stack %s\n", hba->hba_id,
 		RD_HBA_VERSION, TARGET_CORE_MOD_VERSION);
-	printk(KERN_INFO "CORE_HBA[%d] - Attached Ramdisk HBA: %u to Generic"
+	pr_debug("CORE_HBA[%d] - Attached Ramdisk HBA: %u to Generic"
 		" MaxSectors: %u\n", hba->hba_id,
 		rd_host->rd_host_id, RD_MAX_SECTORS);
 
@@ -81,7 +78,7 @@ static void rd_detach_hba(struct se_hba *hba)
 {
 	struct rd_host *rd_host = hba->hba_ptr;
 
-	printk(KERN_INFO "CORE_HBA[%d] - Detached Ramdisk HBA: %u from"
+	pr_debug("CORE_HBA[%d] - Detached Ramdisk HBA: %u from"
 		" Generic Target Core\n", hba->hba_id, rd_host->rd_host_id);
 
 	kfree(rd_host);
@@ -119,7 +116,7 @@ static void rd_release_device_space(struct rd_dev *rd_dev)
 		kfree(sg);
 	}
 
-	printk(KERN_INFO "CORE_RD[%u] - Released device space for Ramdisk"
+	pr_debug("CORE_RD[%u] - Released device space for Ramdisk"
 		" Device ID: %u, pages %u in %u tables total bytes %lu\n",
 		rd_dev->rd_host->rd_host_id, rd_dev->rd_dev_id, page_count,
 		rd_dev->sg_table_count, (unsigned long)page_count * PAGE_SIZE);
@@ -144,7 +141,7 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
 	struct scatterlist *sg;
 
 	if (rd_dev->rd_page_count <= 0) {
-		printk(KERN_ERR "Illegal page count: %u for Ramdisk device\n",
+		pr_err("Illegal page count: %u for Ramdisk device\n",
 			rd_dev->rd_page_count);
 		return -EINVAL;
 	}
@@ -154,7 +151,7 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
 
 	sg_table = kzalloc(sg_tables * sizeof(struct rd_dev_sg_table), GFP_KERNEL);
 	if (!(sg_table)) {
-		printk(KERN_ERR "Unable to allocate memory for Ramdisk"
+		pr_err("Unable to allocate memory for Ramdisk"
 			" scatterlist tables\n");
 		return -ENOMEM;
 	}
@@ -169,12 +166,12 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
 		sg = kzalloc(sg_per_table * sizeof(struct scatterlist),
 				GFP_KERNEL);
 		if (!(sg)) {
-			printk(KERN_ERR "Unable to allocate scatterlist array"
+			pr_err("Unable to allocate scatterlist array"
 				" for struct rd_dev\n");
 			return -ENOMEM;
 		}
 
-		sg_init_table((struct scatterlist *)&sg[0], sg_per_table);
+		sg_init_table(sg, sg_per_table);
 
 		sg_table[i].sg_table = sg;
 		sg_table[i].rd_sg_count = sg_per_table;
@@ -185,7 +182,7 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
 		for (j = 0; j < sg_per_table; j++) {
 			pg = alloc_pages(GFP_KERNEL, 0);
 			if (!(pg)) {
-				printk(KERN_ERR "Unable to allocate scatterlist"
+				pr_err("Unable to allocate scatterlist"
 					" pages for struct rd_dev_sg_table\n");
 				return -ENOMEM;
 			}
@@ -197,7 +194,7 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
 		total_sg_needed -= sg_per_table;
 	}
 
-	printk(KERN_INFO "CORE_RD[%u] - Built Ramdisk Device ID: %u space of"
+	pr_debug("CORE_RD[%u] - Built Ramdisk Device ID: %u space of"
 		" %u pages in %u tables\n", rd_dev->rd_host->rd_host_id,
 		rd_dev->rd_dev_id, rd_dev->rd_page_count,
 		rd_dev->sg_table_count);
@@ -215,7 +212,7 @@ static void *rd_allocate_virtdevice(
 
 	rd_dev = kzalloc(sizeof(struct rd_dev), GFP_KERNEL);
 	if (!(rd_dev)) {
-		printk(KERN_ERR "Unable to allocate memory for struct rd_dev\n");
+		pr_err("Unable to allocate memory for struct rd_dev\n");
 		return NULL;
 	}
 
@@ -272,7 +269,7 @@ static struct se_device *rd_create_virtdevice(
 	rd_dev->rd_dev_id = rd_host->rd_host_dev_id_count++;
 	rd_dev->rd_queue_depth = dev->queue_depth;
 
-	printk(KERN_INFO "CORE_RD[%u] - Added TCM %s Ramdisk Device ID: %u of"
+	pr_debug("CORE_RD[%u] - Added TCM %s Ramdisk Device ID: %u of"
 		" %u pages in %u tables, %lu total bytes\n",
 		rd_host->rd_host_id, (!rd_dev->rd_direct) ? "MEMCPY" :
 		"DIRECT", rd_dev->rd_dev_id, rd_dev->rd_page_count,
@@ -318,7 +315,7 @@ rd_alloc_task(struct se_cmd *cmd)
 
 	rd_req = kzalloc(sizeof(struct rd_request), GFP_KERNEL);
 	if (!rd_req) {
-		printk(KERN_ERR "Unable to allocate struct rd_request\n");
+		pr_err("Unable to allocate struct rd_request\n");
 		return NULL;
 	}
 	rd_req->rd_dev = cmd->se_dev->dev_ptr;
@@ -342,7 +339,7 @@ static struct rd_dev_sg_table *rd_get_sg_table(struct rd_dev *rd_dev, u32 page)
 			return sg_table;
 	}
 
-	printk(KERN_ERR "Unable to locate struct rd_dev_sg_table for page: %u\n",
+	pr_err("Unable to locate struct rd_dev_sg_table for page: %u\n",
 			page);
 
 	return NULL;
@@ -370,26 +367,26 @@ static int rd_MEMCPY_read(struct rd_request *req)
 	table_sg_end = (table->page_end_offset - req->rd_page);
 	sg_d = task->task_sg;
 	sg_s = &table->sg_table[req->rd_page - table->page_start_offset];
-#ifdef DEBUG_RAMDISK_MCP
-	printk(KERN_INFO "RD[%u]: Read LBA: %llu, Size: %u Page: %u, Offset:"
+
+	pr_debug("RD[%u]: Read LBA: %llu, Size: %u Page: %u, Offset:"
 		" %u\n", dev->rd_dev_id, task->task_lba, req->rd_size,
 		req->rd_page, req->rd_offset);
-#endif
+
 	src_offset = rd_offset;
 
 	while (req->rd_size) {
 		if ((sg_d[i].length - dst_offset) <
 		    (sg_s[j].length - src_offset)) {
 			length = (sg_d[i].length - dst_offset);
-#ifdef DEBUG_RAMDISK_MCP
-			printk(KERN_INFO "Step 1 - sg_d[%d]: %p length: %d"
+
+			pr_debug("Step 1 - sg_d[%d]: %p length: %d"
 				" offset: %u sg_s[%d].length: %u\n", i,
 				&sg_d[i], sg_d[i].length, sg_d[i].offset, j,
 				sg_s[j].length);
-			printk(KERN_INFO "Step 1 - length: %u dst_offset: %u"
+			pr_debug("Step 1 - length: %u dst_offset: %u"
 				" src_offset: %u\n", length, dst_offset,
 				src_offset);
-#endif
+
 			if (length > req->rd_size)
 				length = req->rd_size;
 
@@ -406,15 +403,15 @@ static int rd_MEMCPY_read(struct rd_request *req)
 			page_end = 0;
 		} else {
 			length = (sg_s[j].length - src_offset);
-#ifdef DEBUG_RAMDISK_MCP
-			printk(KERN_INFO "Step 2 - sg_d[%d]: %p length: %d"
+
+			pr_debug("Step 2 - sg_d[%d]: %p length: %d"
 				" offset: %u sg_s[%d].length: %u\n", i,
 				&sg_d[i], sg_d[i].length, sg_d[i].offset,
 				j, sg_s[j].length);
-			printk(KERN_INFO "Step 2 - length: %u dst_offset: %u"
+			pr_debug("Step 2 - length: %u dst_offset: %u"
 				" src_offset: %u\n", length, dst_offset,
 				src_offset);
-#endif
+
 			if (length > req->rd_size)
 				length = req->rd_size;
 
@@ -438,11 +435,10 @@ static int rd_MEMCPY_read(struct rd_request *req)
 
 		memcpy(dst, src, length);
 
-#ifdef DEBUG_RAMDISK_MCP
-		printk(KERN_INFO "page: %u, remaining size: %u, length: %u,"
+		pr_debug("page: %u, remaining size: %u, length: %u,"
 			" i: %u, j: %u\n", req->rd_page,
 			(req->rd_size - length), length, i, j);
-#endif
+
 		req->rd_size -= length;
 		if (!(req->rd_size))
 			return 0;
@@ -451,16 +447,14 @@ static int rd_MEMCPY_read(struct rd_request *req)
 			continue;
 
 		if (++req->rd_page <= table->page_end_offset) {
-#ifdef DEBUG_RAMDISK_MCP
-			printk(KERN_INFO "page: %u in same page table\n",
+			pr_debug("page: %u in same page table\n",
 				req->rd_page);
-#endif
 			continue;
 		}
-#ifdef DEBUG_RAMDISK_MCP
-		printk(KERN_INFO "getting new page table for page: %u\n",
+
+		pr_debug("getting new page table for page: %u\n",
 				req->rd_page);
-#endif
+
 		table = rd_get_sg_table(dev, req->rd_page);
 		if (!(table))
 			return -EINVAL;
@@ -493,26 +487,26 @@ static int rd_MEMCPY_write(struct rd_request *req)
 	table_sg_end = (table->page_end_offset - req->rd_page);
 	sg_d = &table->sg_table[req->rd_page - table->page_start_offset];
 	sg_s = task->task_sg;
-#ifdef DEBUG_RAMDISK_MCP
-	printk(KERN_INFO "RD[%d] Write LBA: %llu, Size: %u, Page: %u,"
+
+	pr_debug("RD[%d] Write LBA: %llu, Size: %u, Page: %u,"
 		" Offset: %u\n", dev->rd_dev_id, task->task_lba, req->rd_size,
 		req->rd_page, req->rd_offset);
-#endif
+
 	dst_offset = rd_offset;
 
 	while (req->rd_size) {
 		if ((sg_s[i].length - src_offset) <
 		    (sg_d[j].length - dst_offset)) {
 			length = (sg_s[i].length - src_offset);
-#ifdef DEBUG_RAMDISK_MCP
-			printk(KERN_INFO "Step 1 - sg_s[%d]: %p length: %d"
+
+			pr_debug("Step 1 - sg_s[%d]: %p length: %d"
 				" offset: %d sg_d[%d].length: %u\n", i,
 				&sg_s[i], sg_s[i].length, sg_s[i].offset,
 				j, sg_d[j].length);
-			printk(KERN_INFO "Step 1 - length: %u src_offset: %u"
+			pr_debug("Step 1 - length: %u src_offset: %u"
 				" dst_offset: %u\n", length, src_offset,
 				dst_offset);
-#endif
+
 			if (length > req->rd_size)
 				length = req->rd_size;
 
@@ -529,15 +523,15 @@ static int rd_MEMCPY_write(struct rd_request *req)
 			page_end = 0;
 		} else {
 			length = (sg_d[j].length - dst_offset);
-#ifdef DEBUG_RAMDISK_MCP
-			printk(KERN_INFO "Step 2 - sg_s[%d]: %p length: %d"
+
+			pr_debug("Step 2 - sg_s[%d]: %p length: %d"
 				" offset: %d sg_d[%d].length: %u\n", i,
 				&sg_s[i], sg_s[i].length, sg_s[i].offset,
 				j, sg_d[j].length);
-			printk(KERN_INFO "Step 2 - length: %u src_offset: %u"
+			pr_debug("Step 2 - length: %u src_offset: %u"
 				" dst_offset: %u\n", length, src_offset,
 				dst_offset);
-#endif
+
 			if (length > req->rd_size)
 				length = req->rd_size;
 
@@ -561,11 +555,10 @@ static int rd_MEMCPY_write(struct rd_request *req)
 
 		memcpy(dst, src, length);
 
-#ifdef DEBUG_RAMDISK_MCP
-		printk(KERN_INFO "page: %u, remaining size: %u, length: %u,"
+		pr_debug("page: %u, remaining size: %u, length: %u,"
 			" i: %u, j: %u\n", req->rd_page,
 			(req->rd_size - length), length, i, j);
-#endif
+
 		req->rd_size -= length;
 		if (!(req->rd_size))
 			return 0;
@@ -574,16 +567,14 @@ static int rd_MEMCPY_write(struct rd_request *req)
 			continue;
 
 		if (++req->rd_page <= table->page_end_offset) {
-#ifdef DEBUG_RAMDISK_MCP
-			printk(KERN_INFO "page: %u in same page table\n",
+			pr_debug("page: %u in same page table\n",
 				req->rd_page);
-#endif
 			continue;
 		}
-#ifdef DEBUG_RAMDISK_MCP
-		printk(KERN_INFO "getting new page table for page: %u\n",
+
+		pr_debug("getting new page table for page: %u\n",
 				req->rd_page);
-#endif
+
 		table = rd_get_sg_table(dev, req->rd_page);
 		if (!(table))
 			return -EINVAL;
@@ -670,7 +661,7 @@ static ssize_t rd_set_configfs_dev_params(
 		case Opt_rd_pages:
 			match_int(args, &arg);
 			rd_dev->rd_page_count = arg;
-			printk(KERN_INFO "RAMDISK: Referencing Page"
+			pr_debug("RAMDISK: Referencing Page"
 				" Count: %u\n", rd_dev->rd_page_count);
 			rd_dev->rd_flags |= RDF_HAS_PAGE_COUNT;
 			break;
@@ -688,7 +679,7 @@ static ssize_t rd_check_configfs_dev_params(struct se_hba *hba, struct se_subsys
 	struct rd_dev *rd_dev = se_dev->se_dev_su_ptr;
 
 	if (!(rd_dev->rd_flags & RDF_HAS_PAGE_COUNT)) {
-		printk(KERN_INFO "Missing rd_pages= parameter\n");
+		pr_debug("Missing rd_pages= parameter\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/target/target_core_stgt.c b/drivers/target/target_core_stgt.c
index 6ed843d..e5872ba 100644
--- a/drivers/target/target_core_stgt.c
+++ b/drivers/target/target_core_stgt.c
@@ -120,7 +120,7 @@ static int stgt_attach_hba(struct se_hba *hba, u32 host_id)
 
 	stgt_hba = kzalloc(sizeof(struct stgt_hba), GFP_KERNEL);
 	if (!(stgt_hba)) {
-		printk(KERN_ERR "Unable to allocate struct stgt_hba\n");
+		pr_err("Unable to allocate struct stgt_hba\n");
 		return -ENOMEM;
 	}
 	stgt_hba->se_hba = hba;
@@ -132,7 +132,7 @@ static int stgt_attach_hba(struct se_hba *hba, u32 host_id)
 
 	err = device_register(&stgt_hba->dev);
 	if (err) {
-		printk(KERN_ERR "device_register() for stgt_hba failed:"
+		pr_err("device_register() for stgt_hba failed:"
 				" %d\n", err);
 		return err;
 	}
@@ -153,7 +153,7 @@ static int stgt_lld_probe(struct device *dev)
 
 	sh = scsi_host_alloc(&stgt_driver_template, sizeof(stgt_hba));
 	if (!(sh)) {
-		printk(KERN_ERR "scsi_host_alloc() failed\n");
+		pr_err("scsi_host_alloc() failed\n");
 		return -ENOMEM;
 	}
 	hba = stgt_hba->se_hba;
@@ -169,7 +169,7 @@ static int stgt_lld_probe(struct device *dev)
 
 	err = scsi_add_host(sh, &stgt_hba->dev);
 	if (err) {
-		printk(KERN_ERR "scsi_add_host() failed with err: %d\n", err);
+		pr_err("scsi_add_host() failed with err: %d\n", err);
 		return err;
 	}
 
@@ -184,12 +184,12 @@ static int stgt_lld_probe(struct device *dev)
 
 	hba->hba_ptr = sh;
 
-	printk(KERN_INFO "CORE_HBA[%d] - TCM STGT HBA Driver %s on"
+	pr_debug("CORE_HBA[%d] - TCM STGT HBA Driver %s on"
 		" Generic Target Core Stack %s\n", hba->hba_id,
 		STGT_VERSION, TARGET_CORE_MOD_VERSION);
-	printk(KERN_INFO "CORE_HBA[%d] - %s\n", hba->hba_id, (sh->hostt->name) ?
+	pr_debug("CORE_HBA[%d] - %s\n", hba->hba_id, (sh->hostt->name) ?
 			(sh->hostt->name) : "Unknown");
-	printk(KERN_INFO "CORE_HBA[%d] - Attached STGT HBA to Generic"
+	pr_debug("CORE_HBA[%d] - Attached STGT HBA to Generic"
 		" MaxSectors: %hu\n",
 		hba->hba_id, max_sectors);
 
@@ -215,7 +215,7 @@ static void stgt_detach_hba(struct se_hba *hba)
 	struct Scsi_Host *scsi_host = hba->hba_ptr;
 	struct stgt_hba *stgt_hba = *(struct stgt_hba **)shost_priv(scsi_host);
 
-	printk(KERN_INFO "CORE_HBA[%d] - Detached STGT HBA: %s from"
+	pr_debug("CORE_HBA[%d] - Detached STGT HBA: %s from"
 		" Generic Target Core\n", hba->hba_id,
 		(scsi_host->hostt->name) ? (scsi_host->hostt->name) :
 		"Unknown");
@@ -230,12 +230,12 @@ static void *stgt_allocate_virtdevice(struct se_hba *hba, const char *name)
 
 	sdv = kzalloc(sizeof(struct stgt_dev_virt), GFP_KERNEL);
 	if (!(sdv)) {
-		printk(KERN_ERR "Unable to allocate memory for struct stgt_dev_virt\n");
+		pr_err("Unable to allocate memory for struct stgt_dev_virt\n");
 		return NULL;
 	}
 	sdv->sdv_se_hba = hba;
 
-	printk(KERN_INFO "STGT: Allocated sdv: %p for %s\n", sdv, name);
+	pr_debug("STGT: Allocated sdv: %p for %s\n", sdv, name);
 	return sdv;
 }
 
@@ -249,12 +249,12 @@ static struct se_device *stgt_create_virtdevice(
 	struct Scsi_Host *sh = hba->hba_ptr;
 
 	if (!(sdv)) {
-		printk(KERN_ERR "Unable to locate struct stgt_dev_virt"
+		pr_err("Unable to locate struct stgt_dev_virt"
 				" parameter\n");
 		return NULL;
 	}
 
-	printk(KERN_ERR "Unable to locate %d:%d:%d:%d\n", sh->host_no,
+	pr_err("Unable to locate %d:%d:%d:%d\n", sh->host_no,
 		sdv->sdv_channel_id,  sdv->sdv_target_id, sdv->sdv_lun_id);
 
 	return NULL;
@@ -311,7 +311,7 @@ stgt_alloc_task(struct se_cmd *cmd)
 
 	st = kzalloc(sizeof(struct stgt_plugin_task), GFP_KERNEL);
 	if (!st) {
-		printk(KERN_ERR "Unable to allocate struct stgt_plugin_task\n");
+		pr_err("Unable to allocate struct stgt_plugin_task\n");
 		return NULL;
 	}
 
@@ -332,7 +332,7 @@ static int stgt_do_task(struct se_task *task)
 	sc = scsi_host_get_command(sh, task->task_data_direction,
 				   GFP_KERNEL);
 	if (!sc) {
-		printk(KERN_ERR "Unable to allocate memory for struct"
+		pr_err("Unable to allocate memory for struct"
 			" scsi_cmnd\n");
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 	}
@@ -348,7 +348,7 @@ static int stgt_do_task(struct se_task *task)
 	err = scsi_tgt_queue_command(sc, itn_id, (struct scsi_lun *)&cmd->lun,
 			cmd->tag);
 	if (err) {
-		printk(KERN_INFO "scsi_tgt_queue_command() failed for sc:"
+		pr_debug("scsi_tgt_queue_command() failed for sc:"
 			" %p\n", sc);
 		scsi_host_put_command(sh, sc);
 	}
@@ -404,21 +404,21 @@ static ssize_t stgt_set_configfs_dev_params(struct se_hba *hba,
 		case Opt_scsi_channel_id:
 			match_int(args, &arg);
 			sdv->sdv_channel_id = arg;
-			printk(KERN_INFO "STGT[%d]: Referencing SCSI Channel"
+			pr_debug("STGT[%d]: Referencing SCSI Channel"
 				" ID: %d\n",  sh->host_no, sdv->sdv_channel_id);
 			sdv->sdv_flags |= PDF_HAS_CHANNEL_ID;
 			break;
 		case Opt_scsi_target_id:
 			match_int(args, &arg);
 			sdv->sdv_target_id = arg;
-			printk(KERN_INFO "STGT[%d]: Referencing SCSI Target"
+			pr_debug("STGT[%d]: Referencing SCSI Target"
 				" ID: %d\n", sh->host_no, sdv->sdv_target_id);
 			sdv->sdv_flags |= PDF_HAS_TARGET_ID;
 			break;
 		case Opt_scsi_lun_id:
 			match_int(args, &arg);
 			sdv->sdv_lun_id = arg;
-			printk(KERN_INFO "STGT[%d]: Referencing SCSI LUN ID:"
+			pr_debug("STGT[%d]: Referencing SCSI LUN ID:"
 				" %d\n", sh->host_no, sdv->sdv_lun_id);
 			sdv->sdv_flags |= PDF_HAS_LUN_ID;
 			break;
@@ -440,7 +440,7 @@ static ssize_t stgt_check_configfs_dev_params(
 	if (!(sdv->sdv_flags & PDF_HAS_CHANNEL_ID) ||
 	    !(sdv->sdv_flags & PDF_HAS_TARGET_ID) ||
 	    !(sdv->sdv_flags & PDF_HAS_TARGET_ID)) {
-		printk(KERN_ERR "Missing scsi_channel_id=, scsi_target_id= and"
+		pr_err("Missing scsi_channel_id=, scsi_target_id= and"
 			" scsi_lun_id= parameters\n");
 		return -1;
 	}
@@ -520,7 +520,7 @@ static inline void stgt_process_SAM_status(
 	task->task_scsi_status = status_byte(st->stgt_result);
 	if ((task->task_scsi_status)) {
 		task->task_scsi_status <<= 1;
-		printk(KERN_INFO "PSCSI Status Byte exception at task: %p CDB:"
+		pr_debug("PSCSI Status Byte exception at task: %p CDB:"
 			" 0x%02x Result: 0x%08x\n", task, st->stgt_cdb[0],
 			st->stgt_result);
 	}
@@ -530,7 +530,7 @@ static inline void stgt_process_SAM_status(
 		transport_complete_task(task, (!task->task_scsi_status));
 		break;
 	default:
-		printk(KERN_INFO "PSCSI Host Byte exception at task: %p CDB:"
+		pr_debug("PSCSI Host Byte exception at task: %p CDB:"
 			" 0x%02x Result: 0x%08x\n", task, st->stgt_cdb[0],
 			st->stgt_result);
 		task->task_scsi_status = SAM_STAT_CHECK_CONDITION;
@@ -556,11 +556,11 @@ static int stgt_transfer_response(struct scsi_cmnd *sc,
 	struct stgt_plugin_task *st = STGT_TASK(task);
 
 	if (!task) {
-		printk(KERN_ERR "struct se_task is NULL!\n");
+		pr_err("struct se_task is NULL!\n");
 		BUG();
 	}
 	if (!st) {
-		printk(KERN_ERR "struct stgt_plugin_task is NULL!\n");
+		pr_err("struct stgt_plugin_task is NULL!\n");
 		BUG();
 	}
 	st->stgt_result = sc->request->errors;
@@ -603,19 +603,19 @@ static int __init stgt_module_init(void)
 
 	ret = device_register(&stgt_primary);
 	if (ret) {
-		printk(KERN_ERR "device_register() failed for stgt_primary\n");
+		pr_err("device_register() failed for stgt_primary\n");
 		return ret;
 	}
 
 	ret = bus_register(&stgt_lld_bus);
 	if (ret) {
-		printk(KERN_ERR "bus_register() failed for stgt_ldd_bus\n");
+		pr_err("bus_register() failed for stgt_ldd_bus\n");
 		goto out_unregister_device;
 	}
 
 	ret = driver_register(&stgt_driverfs_driver);
 	if (ret) {
-		printk(KERN_ERR "driver_register() failed for"
+		pr_err("driver_register() failed for"
 			" stgt_driverfs_driver\n");
 		goto out_unregister_bus;
 	}
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index b95f090..219dbc8 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -41,13 +41,6 @@
 #include "target_core_alua.h"
 #include "target_core_pr.h"
 
-#define DEBUG_LUN_RESET
-#ifdef DEBUG_LUN_RESET
-#define DEBUG_LR(x...) printk(KERN_INFO x)
-#else
-#define DEBUG_LR(x...)
-#endif
-
 struct se_tmr_req *core_tmr_alloc_req(
 	struct se_cmd *se_cmd,
 	void *fabric_tmr_ptr,
@@ -58,7 +51,7 @@ struct se_tmr_req *core_tmr_alloc_req(
 	tmr = kmem_cache_zalloc(se_tmr_req_cache, (in_interrupt()) ?
 					GFP_ATOMIC : GFP_KERNEL);
 	if (!(tmr)) {
-		printk(KERN_ERR "Unable to allocate struct se_tmr_req\n");
+		pr_err("Unable to allocate struct se_tmr_req\n");
 		return ERR_PTR(-ENOMEM);
 	}
 	tmr->task_cmd = se_cmd;
@@ -141,13 +134,13 @@ int core_tmr_lun_reset(
 		tmr_nacl = tmr->task_cmd->se_sess->se_node_acl;
 		tmr_tpg = tmr->task_cmd->se_sess->se_tpg;
 		if (tmr_nacl && tmr_tpg) {
-			DEBUG_LR("LUN_RESET: TMR caller fabric: %s"
+			pr_debug("LUN_RESET: TMR caller fabric: %s"
 				" initiator port %s\n",
 				tmr_tpg->se_tpg_tfo->get_fabric_name(),
 				tmr_nacl->initiatorname);
 		}
 	}
-	DEBUG_LR("LUN_RESET: %s starting for [%s], tas: %d\n",
+	pr_debug("LUN_RESET: %s starting for [%s], tas: %d\n",
 		(preempt_and_abort_list) ? "Preempt" : "TMR",
 		dev->transport->name, tas);
 	/*
@@ -164,7 +157,7 @@ int core_tmr_lun_reset(
 
 		cmd = tmr_p->task_cmd;
 		if (!(cmd)) {
-			printk(KERN_ERR "Unable to locate struct se_cmd for TMR\n");
+			pr_err("Unable to locate struct se_cmd for TMR\n");
 			continue;
 		}
 		/*
@@ -189,7 +182,7 @@ int core_tmr_lun_reset(
 			spin_lock(&dev->se_tmr_lock);
 			continue;
 		}
-		DEBUG_LR("LUN_RESET: %s releasing TMR %p Function: 0x%02x,"
+		pr_debug("LUN_RESET: %s releasing TMR %p Function: 0x%02x,"
 			" Response: 0x%02x, t_state: %d\n",
 			(preempt_and_abort_list) ? "Preempt" : "", tmr_p,
 			tmr_p->function, tmr_p->response, cmd->t_state);
@@ -224,7 +217,7 @@ int core_tmr_lun_reset(
 	list_for_each_entry_safe(task, task_tmp, &dev->state_task_list,
 				t_state_list) {
 		if (!task->task_se_cmd) {
-			printk(KERN_ERR "task->task_se_cmd is NULL!\n");
+			pr_err("task->task_se_cmd is NULL!\n");
 			continue;
 		}
 		cmd = task->task_se_cmd;
@@ -248,14 +241,14 @@ int core_tmr_lun_reset(
 		spin_unlock_irqrestore(&dev->execute_task_lock, flags);
 
 		spin_lock_irqsave(&cmd->t_state_lock, flags);
-		DEBUG_LR("LUN_RESET: %s cmd: %p task: %p"
+		pr_debug("LUN_RESET: %s cmd: %p task: %p"
 			" ITT/CmdSN: 0x%08x/0x%08x, i_state: %d, t_state/"
 			"def_t_state: %d/%d cdb: 0x%02x\n",
 			(preempt_and_abort_list) ? "Preempt" : "", cmd, task,
 			cmd->se_tfo->get_task_tag(cmd), 0,
 			cmd->se_tfo->get_cmd_state(cmd), cmd->t_state,
 			cmd->deferred_t_state, cmd->t_task_cdb[0]);
-		DEBUG_LR("LUN_RESET: ITT[0x%08x] - pr_res_key: 0x%016Lx"
+		pr_debug("LUN_RESET: ITT[0x%08x] - pr_res_key: 0x%016Lx"
 			" t_task_cdbs: %d t_task_cdbs_left: %d"
 			" t_task_cdbs_sent: %d -- t_transport_active: %d"
 			" t_transport_stop: %d t_transport_sent: %d\n",
@@ -272,10 +265,10 @@ int core_tmr_lun_reset(
 			spin_unlock_irqrestore(
 				&cmd->t_state_lock, flags);
 
-			DEBUG_LR("LUN_RESET: Waiting for task: %p to shutdown"
+			pr_debug("LUN_RESET: Waiting for task: %p to shutdown"
 				" for dev: %p\n", task, dev);
 			wait_for_completion(&task->task_stop_comp);
-			DEBUG_LR("LUN_RESET Completed task: %p shutdown for"
+			pr_debug("LUN_RESET Completed task: %p shutdown for"
 				" dev: %p\n", task, dev);
 			spin_lock_irqsave(&cmd->t_state_lock, flags);
 			atomic_dec(&cmd->t_task_cdbs_left);
@@ -291,7 +284,7 @@ int core_tmr_lun_reset(
 		if (!(atomic_dec_and_test(&cmd->t_task_cdbs_ex_left))) {
 			spin_unlock_irqrestore(
 					&cmd->t_state_lock, flags);
-			DEBUG_LR("LUN_RESET: Skipping task: %p, dev: %p for"
+			pr_debug("LUN_RESET: Skipping task: %p, dev: %p for"
 				" t_task_cdbs_ex_left: %d\n", task, dev,
 				atomic_read(&cmd->t_task_cdbs_ex_left));
 
@@ -301,7 +294,7 @@ int core_tmr_lun_reset(
 		fe_count = atomic_read(&cmd->t_fe_count);
 
 		if (atomic_read(&cmd->t_transport_active)) {
-			DEBUG_LR("LUN_RESET: got t_transport_active = 1 for"
+			pr_debug("LUN_RESET: got t_transport_active = 1 for"
 				" task: %p, t_fe_count: %d dev: %p\n", task,
 				fe_count, dev);
 			atomic_set(&cmd->t_transport_aborted, 1);
@@ -312,7 +305,7 @@ int core_tmr_lun_reset(
 			spin_lock_irqsave(&dev->execute_task_lock, flags);
 			continue;
 		}
-		DEBUG_LR("LUN_RESET: Got t_transport_active = 0 for task: %p,"
+		pr_debug("LUN_RESET: Got t_transport_active = 0 for task: %p,"
 			" t_fe_count: %d dev: %p\n", task, fe_count, dev);
 		atomic_set(&cmd->t_transport_aborted, 1);
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
@@ -366,7 +359,7 @@ int core_tmr_lun_reset(
 		state = qr->state;
 		kfree(qr);
 
-		DEBUG_LR("LUN_RESET: %s from Device Queue: cmd: %p t_state:"
+		pr_debug("LUN_RESET: %s from Device Queue: cmd: %p t_state:"
 			" %d t_fe_count: %d\n", (preempt_and_abort_list) ?
 			"Preempt" : "", cmd, state,
 			atomic_read(&cmd->t_fe_count));
@@ -390,14 +383,14 @@ int core_tmr_lun_reset(
 		dev->dev_reserved_node_acl = NULL;
 		dev->dev_flags &= ~DF_SPC2_RESERVATIONS;
 		spin_unlock(&dev->dev_reservation_lock);
-		printk(KERN_INFO "LUN_RESET: SCSI-2 Released reservation\n");
+		pr_debug("LUN_RESET: SCSI-2 Released reservation\n");
 	}
 
 	spin_lock_irq(&dev->stats_lock);
 	dev->num_resets++;
 	spin_unlock_irq(&dev->stats_lock);
 
-	DEBUG_LR("LUN_RESET: %s for [%s] Complete\n",
+	pr_debug("LUN_RESET: %s for [%s] Complete\n",
 			(preempt_and_abort_list) ? "Preempt" : "TMR",
 			dev->transport->name);
 	return 0;
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 448129f..d2b0a67 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -72,7 +72,7 @@ static void core_clear_initiator_node_from_tpg(
 			continue;
 
 		if (!deve->se_lun) {
-			printk(KERN_ERR "%s device entries device pointer is"
+			pr_err("%s device entries device pointer is"
 				" NULL, but Initiator has access.\n",
 				tpg->se_tpg_tfo->get_fabric_name());
 			continue;
@@ -93,7 +93,7 @@ static void core_clear_initiator_node_from_tpg(
 		}
 
 		if (!acl) {
-			printk(KERN_ERR "Unable to locate struct se_lun_acl for %s,"
+			pr_err("Unable to locate struct se_lun_acl for %s,"
 				" mapped_lun: %u\n", nacl->initiatorname,
 				deve->mapped_lun);
 			spin_unlock(&lun->lun_acl_lock);
@@ -193,7 +193,7 @@ void core_tpg_add_node_to_devs(
 				lun_access = TRANSPORT_LUNFLAGS_READ_WRITE;
 		}
 
-		printk(KERN_INFO "TARGET_CORE[%s]->TPG[%u]_LUN[%u] - Adding %s"
+		pr_debug("TARGET_CORE[%s]->TPG[%u]_LUN[%u] - Adding %s"
 			" access for LUN in Demo Mode\n",
 			tpg->se_tpg_tfo->get_fabric_name(),
 			tpg->se_tpg_tfo->tpg_get_tag(tpg), lun->unpacked_lun,
@@ -216,7 +216,7 @@ static int core_set_queue_depth_for_node(
 	struct se_node_acl *acl)
 {
 	if (!acl->queue_depth) {
-		printk(KERN_ERR "Queue depth for %s Initiator Node: %s is 0,"
+		pr_err("Queue depth for %s Initiator Node: %s is 0,"
 			"defaulting to 1.\n", tpg->se_tpg_tfo->get_fabric_name(),
 			acl->initiatorname);
 		acl->queue_depth = 1;
@@ -237,7 +237,7 @@ static int core_create_device_list_for_node(struct se_node_acl *nacl)
 	nacl->device_list = kzalloc(sizeof(struct se_dev_entry) *
 				TRANSPORT_MAX_LUNS_PER_TPG, GFP_KERNEL);
 	if (!(nacl->device_list)) {
-		printk(KERN_ERR "Unable to allocate memory for"
+		pr_err("Unable to allocate memory for"
 			" struct se_node_acl->device_list\n");
 		return -ENOMEM;
 	}
@@ -307,7 +307,7 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
 	tpg->num_node_acls++;
 	spin_unlock_bh(&tpg->acl_node_lock);
 
-	printk("%s_TPG[%u] - Added DYNAMIC ACL with TCQ Depth: %d for %s"
+	pr_debug("%s_TPG[%u] - Added DYNAMIC ACL with TCQ Depth: %d for %s"
 		" Initiator Node: %s\n", tpg->se_tpg_tfo->get_fabric_name(),
 		tpg->se_tpg_tfo->tpg_get_tag(tpg), acl->queue_depth,
 		tpg->se_tpg_tfo->get_fabric_name(), initiatorname);
@@ -360,7 +360,7 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(
 	if ((acl)) {
 		if (acl->dynamic_node_acl) {
 			acl->dynamic_node_acl = 0;
-			printk(KERN_INFO "%s_TPG[%u] - Replacing dynamic ACL"
+			pr_debug("%s_TPG[%u] - Replacing dynamic ACL"
 				" for %s\n", tpg->se_tpg_tfo->get_fabric_name(),
 				tpg->se_tpg_tfo->tpg_get_tag(tpg), initiatorname);
 			spin_unlock_bh(&tpg->acl_node_lock);
@@ -375,7 +375,7 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(
 			goto done;
 		}
 
-		printk(KERN_ERR "ACL entry for %s Initiator"
+		pr_err("ACL entry for %s Initiator"
 			" Node %s already exists for TPG %u, ignoring"
 			" request.\n",  tpg->se_tpg_tfo->get_fabric_name(),
 			initiatorname, tpg->se_tpg_tfo->tpg_get_tag(tpg));
@@ -385,7 +385,7 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(
 	spin_unlock_bh(&tpg->acl_node_lock);
 
 	if (!(se_nacl)) {
-		printk("struct se_node_acl pointer is NULL\n");
+		pr_err("struct se_node_acl pointer is NULL\n");
 		return ERR_PTR(-EINVAL);
 	}
 	/*
@@ -425,7 +425,7 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(
 	spin_unlock_bh(&tpg->acl_node_lock);
 
 done:
-	printk(KERN_INFO "%s_TPG[%hu] - Added ACL with TCQ Depth: %d for %s"
+	pr_debug("%s_TPG[%hu] - Added ACL with TCQ Depth: %d for %s"
 		" Initiator Node: %s\n", tpg->se_tpg_tfo->get_fabric_name(),
 		tpg->se_tpg_tfo->tpg_get_tag(tpg), acl->queue_depth,
 		tpg->se_tpg_tfo->get_fabric_name(), initiatorname);
@@ -481,7 +481,7 @@ int core_tpg_del_initiator_node_acl(
 	core_clear_initiator_node_from_tpg(acl, tpg);
 	core_free_device_list_for_node(acl, tpg);
 
-	printk(KERN_INFO "%s_TPG[%hu] - Deleted ACL with TCQ Depth: %d for %s"
+	pr_debug("%s_TPG[%hu] - Deleted ACL with TCQ Depth: %d for %s"
 		" Initiator Node: %s\n", tpg->se_tpg_tfo->get_fabric_name(),
 		tpg->se_tpg_tfo->tpg_get_tag(tpg), acl->queue_depth,
 		tpg->se_tpg_tfo->get_fabric_name(), acl->initiatorname);
@@ -507,7 +507,7 @@ int core_tpg_set_initiator_node_queue_depth(
 	spin_lock_bh(&tpg->acl_node_lock);
 	acl = __core_tpg_get_initiator_node_acl(tpg, initiatorname);
 	if (!(acl)) {
-		printk(KERN_ERR "Access Control List entry for %s Initiator"
+		pr_err("Access Control List entry for %s Initiator"
 			" Node %s does not exists for TPG %hu, ignoring"
 			" request.\n", tpg->se_tpg_tfo->get_fabric_name(),
 			initiatorname, tpg->se_tpg_tfo->tpg_get_tag(tpg));
@@ -526,7 +526,7 @@ int core_tpg_set_initiator_node_queue_depth(
 			continue;
 
 		if (!force) {
-			printk(KERN_ERR "Unable to change queue depth for %s"
+			pr_err("Unable to change queue depth for %s"
 				" Initiator Node: %s while session is"
 				" operational.  To forcefully change the queue"
 				" depth and force session reinstatement"
@@ -586,7 +586,7 @@ int core_tpg_set_initiator_node_queue_depth(
 	if (init_sess)
 		tpg->se_tpg_tfo->close_session(init_sess);
 
-	printk(KERN_INFO "Successfuly changed queue depth to: %d for Initiator"
+	pr_debug("Successfuly changed queue depth to: %d for Initiator"
 		" Node: %s on %s Target Portal Group: %u\n", queue_depth,
 		initiatorname, tpg->se_tpg_tfo->get_fabric_name(),
 		tpg->se_tpg_tfo->tpg_get_tag(tpg));
@@ -645,7 +645,7 @@ int core_tpg_register(
 	se_tpg->tpg_lun_list = kzalloc((sizeof(struct se_lun) *
 				TRANSPORT_MAX_LUNS_PER_TPG), GFP_KERNEL);
 	if (!(se_tpg->tpg_lun_list)) {
-		printk(KERN_ERR "Unable to allocate struct se_portal_group->"
+		pr_err("Unable to allocate struct se_portal_group->"
 				"tpg_lun_list\n");
 		return -ENOMEM;
 	}
@@ -686,7 +686,7 @@ int core_tpg_register(
 	list_add_tail(&se_tpg->se_tpg_node, &tpg_list);
 	spin_unlock_bh(&tpg_lock);
 
-	printk(KERN_INFO "TARGET_CORE[%s]: Allocated %s struct se_portal_group for"
+	pr_debug("TARGET_CORE[%s]: Allocated %s struct se_portal_group for"
 		" endpoint: %s, Portal Tag: %u\n", tfo->get_fabric_name(),
 		(se_tpg->se_tpg_type == TRANSPORT_TPG_TYPE_NORMAL) ?
 		"Normal" : "Discovery", (tfo->tpg_get_wwn(se_tpg) == NULL) ?
@@ -700,7 +700,7 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
 {
 	struct se_node_acl *nacl, *nacl_tmp;
 
-	printk(KERN_INFO "TARGET_CORE[%s]: Deallocating %s struct se_portal_group"
+	pr_debug("TARGET_CORE[%s]: Deallocating %s struct se_portal_group"
 		" for endpoint: %s Portal Tag %u\n",
 		(se_tpg->se_tpg_type == TRANSPORT_TPG_TYPE_NORMAL) ?
 		"Normal" : "Discovery", se_tpg->se_tpg_tfo->get_fabric_name(),
@@ -749,7 +749,7 @@ struct se_lun *core_tpg_pre_addlun(
 	struct se_lun *lun;
 
 	if (unpacked_lun > (TRANSPORT_MAX_LUNS_PER_TPG-1)) {
-		printk(KERN_ERR "%s LUN: %u exceeds TRANSPORT_MAX_LUNS_PER_TPG"
+		pr_err("%s LUN: %u exceeds TRANSPORT_MAX_LUNS_PER_TPG"
 			"-1: %u for Target Portal Group: %u\n",
 			tpg->se_tpg_tfo->get_fabric_name(),
 			unpacked_lun, TRANSPORT_MAX_LUNS_PER_TPG-1,
@@ -760,7 +760,7 @@ struct se_lun *core_tpg_pre_addlun(
 	spin_lock(&tpg->tpg_lun_lock);
 	lun = &tpg->tpg_lun_list[unpacked_lun];
 	if (lun->lun_status == TRANSPORT_LUN_STATUS_ACTIVE) {
-		printk(KERN_ERR "TPG Logical Unit Number: %u is already active"
+		pr_err("TPG Logical Unit Number: %u is already active"
 			" on %s Target Portal Group: %u, ignoring request.\n",
 			unpacked_lun, tpg->se_tpg_tfo->get_fabric_name(),
 			tpg->se_tpg_tfo->tpg_get_tag(tpg));
@@ -808,7 +808,7 @@ struct se_lun *core_tpg_pre_dellun(
 	struct se_lun *lun;
 
 	if (unpacked_lun > (TRANSPORT_MAX_LUNS_PER_TPG-1)) {
-		printk(KERN_ERR "%s LUN: %u exceeds TRANSPORT_MAX_LUNS_PER_TPG"
+		pr_err("%s LUN: %u exceeds TRANSPORT_MAX_LUNS_PER_TPG"
 			"-1: %u for Target Portal Group: %u\n",
 			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
 			TRANSPORT_MAX_LUNS_PER_TPG-1,
@@ -819,7 +819,7 @@ struct se_lun *core_tpg_pre_dellun(
 	spin_lock(&tpg->tpg_lun_lock);
 	lun = &tpg->tpg_lun_list[unpacked_lun];
 	if (lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE) {
-		printk(KERN_ERR "%s Logical Unit Number: %u is not active on"
+		pr_err("%s Logical Unit Number: %u is not active on"
 			" Target Portal Group: %u, ignoring request.\n",
 			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
 			tpg->se_tpg_tfo->tpg_get_tag(tpg));
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 064a00b..895173c 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -59,132 +59,6 @@
 #include "target_core_scdb.h"
 #include "target_core_ua.h"
 
-/* #define DEBUG_CDB_HANDLER */
-#ifdef DEBUG_CDB_HANDLER
-#define DEBUG_CDB_H(x...) printk(KERN_INFO x)
-#else
-#define DEBUG_CDB_H(x...)
-#endif
-
-/* #define DEBUG_CMD_MAP */
-#ifdef DEBUG_CMD_MAP
-#define DEBUG_CMD_M(x...) printk(KERN_INFO x)
-#else
-#define DEBUG_CMD_M(x...)
-#endif
-
-/* #define DEBUG_MEM_ALLOC */
-#ifdef DEBUG_MEM_ALLOC
-#define DEBUG_MEM(x...) printk(KERN_INFO x)
-#else
-#define DEBUG_MEM(x...)
-#endif
-
-/* #define DEBUG_MEM2_ALLOC */
-#ifdef DEBUG_MEM2_ALLOC
-#define DEBUG_MEM2(x...) printk(KERN_INFO x)
-#else
-#define DEBUG_MEM2(x...)
-#endif
-
-/* #define DEBUG_SG_CALC */
-#ifdef DEBUG_SG_CALC
-#define DEBUG_SC(x...) printk(KERN_INFO x)
-#else
-#define DEBUG_SC(x...)
-#endif
-
-/* #define DEBUG_SE_OBJ */
-#ifdef DEBUG_SE_OBJ
-#define DEBUG_SO(x...) printk(KERN_INFO x)
-#else
-#define DEBUG_SO(x...)
-#endif
-
-/* #define DEBUG_CMD_VOL */
-#ifdef DEBUG_CMD_VOL
-#define DEBUG_VOL(x...) printk(KERN_INFO x)
-#else
-#define DEBUG_VOL(x...)
-#endif
-
-/* #define DEBUG_CMD_STOP */
-#ifdef DEBUG_CMD_STOP
-#define DEBUG_CS(x...) printk(KERN_INFO x)
-#else
-#define DEBUG_CS(x...)
-#endif
-
-/* #define DEBUG_PASSTHROUGH */
-#ifdef DEBUG_PASSTHROUGH
-#define DEBUG_PT(x...) printk(KERN_INFO x)
-#else
-#define DEBUG_PT(x...)
-#endif
-
-/* #define DEBUG_TASK_STOP */
-#ifdef DEBUG_TASK_STOP
-#define DEBUG_TS(x...) printk(KERN_INFO x)
-#else
-#define DEBUG_TS(x...)
-#endif
-
-/* #define DEBUG_TRANSPORT_STOP */
-#ifdef DEBUG_TRANSPORT_STOP
-#define DEBUG_TRANSPORT_S(x...) printk(KERN_INFO x)
-#else
-#define DEBUG_TRANSPORT_S(x...)
-#endif
-
-/* #define DEBUG_TASK_FAILURE */
-#ifdef DEBUG_TASK_FAILURE
-#define DEBUG_TF(x...) printk(KERN_INFO x)
-#else
-#define DEBUG_TF(x...)
-#endif
-
-/* #define DEBUG_DEV_OFFLINE */
-#ifdef DEBUG_DEV_OFFLINE
-#define DEBUG_DO(x...) printk(KERN_INFO x)
-#else
-#define DEBUG_DO(x...)
-#endif
-
-/* #define DEBUG_TASK_STATE */
-#ifdef DEBUG_TASK_STATE
-#define DEBUG_TSTATE(x...) printk(KERN_INFO x)
-#else
-#define DEBUG_TSTATE(x...)
-#endif
-
-/* #define DEBUG_STATUS_THR */
-#ifdef DEBUG_STATUS_THR
-#define DEBUG_ST(x...) printk(KERN_INFO x)
-#else
-#define DEBUG_ST(x...)
-#endif
-
-/* #define DEBUG_TASK_TIMEOUT */
-#ifdef DEBUG_TASK_TIMEOUT
-#define DEBUG_TT(x...) printk(KERN_INFO x)
-#else
-#define DEBUG_TT(x...)
-#endif
-
-/* #define DEBUG_GENERIC_REQUEST_FAILURE */
-#ifdef DEBUG_GENERIC_REQUEST_FAILURE
-#define DEBUG_GRF(x...) printk(KERN_INFO x)
-#else
-#define DEBUG_GRF(x...)
-#endif
-
-/* #define DEBUG_SAM_TASK_ATTRS */
-#ifdef DEBUG_SAM_TASK_ATTRS
-#define DEBUG_STA(x...) printk(KERN_INFO x)
-#else
-#define DEBUG_STA(x...)
-#endif
-
 static int sub_api_initialized;
 
 static struct kmem_cache *se_cmd_cache;
@@ -227,14 +101,14 @@ int init_se_kmem_caches(void)
 	se_cmd_cache = kmem_cache_create("se_cmd_cache",
 			sizeof(struct se_cmd), __alignof__(struct se_cmd), 0, NULL);
 	if (!(se_cmd_cache)) {
-		printk(KERN_ERR "kmem_cache_create for struct se_cmd failed\n");
+		pr_err("kmem_cache_create for struct se_cmd failed\n");
 		goto out;
 	}
 	se_tmr_req_cache = kmem_cache_create("se_tmr_cache",
 			sizeof(struct se_tmr_req), __alignof__(struct se_tmr_req),
 			0, NULL);
 	if (!(se_tmr_req_cache)) {
-		printk(KERN_ERR "kmem_cache_create() for struct se_tmr_req"
+		pr_err("kmem_cache_create() for struct se_tmr_req"
 				" failed\n");
 		goto out;
 	}
@@ -242,7 +116,7 @@ int init_se_kmem_caches(void)
 			sizeof(struct se_session), __alignof__(struct se_session),
 			0, NULL);
 	if (!(se_sess_cache)) {
-		printk(KERN_ERR "kmem_cache_create() for struct se_session"
+		pr_err("kmem_cache_create() for struct se_session"
 				" failed\n");
 		goto out;
 	}
@@ -250,14 +124,14 @@ int init_se_kmem_caches(void)
 			sizeof(struct se_ua), __alignof__(struct se_ua),
 			0, NULL);
 	if (!(se_ua_cache)) {
-		printk(KERN_ERR "kmem_cache_create() for struct se_ua failed\n");
+		pr_err("kmem_cache_create() for struct se_ua failed\n");
 		goto out;
 	}
 	t10_pr_reg_cache = kmem_cache_create("t10_pr_reg_cache",
 			sizeof(struct t10_pr_registration),
 			__alignof__(struct t10_pr_registration), 0, NULL);
 	if (!(t10_pr_reg_cache)) {
-		printk(KERN_ERR "kmem_cache_create() for struct t10_pr_registration"
+		pr_err("kmem_cache_create() for struct t10_pr_registration"
 				" failed\n");
 		goto out;
 	}
@@ -265,7 +139,7 @@ int init_se_kmem_caches(void)
 			sizeof(struct t10_alua_lu_gp), __alignof__(struct t10_alua_lu_gp),
 			0, NULL);
 	if (!(t10_alua_lu_gp_cache)) {
-		printk(KERN_ERR "kmem_cache_create() for t10_alua_lu_gp_cache"
+		pr_err("kmem_cache_create() for t10_alua_lu_gp_cache"
 				" failed\n");
 		goto out;
 	}
@@ -273,7 +147,7 @@ int init_se_kmem_caches(void)
 			sizeof(struct t10_alua_lu_gp_member),
 			__alignof__(struct t10_alua_lu_gp_member), 0, NULL);
 	if (!(t10_alua_lu_gp_mem_cache)) {
-		printk(KERN_ERR "kmem_cache_create() for t10_alua_lu_gp_mem_"
+		pr_err("kmem_cache_create() for t10_alua_lu_gp_mem_"
 				"cache failed\n");
 		goto out;
 	}
@@ -281,7 +155,7 @@ int init_se_kmem_caches(void)
 			sizeof(struct t10_alua_tg_pt_gp),
 			__alignof__(struct t10_alua_tg_pt_gp), 0, NULL);
 	if (!(t10_alua_tg_pt_gp_cache)) {
-		printk(KERN_ERR "kmem_cache_create() for t10_alua_tg_pt_gp_"
+		pr_err("kmem_cache_create() for t10_alua_tg_pt_gp_"
 				"cache failed\n");
 		goto out;
 	}
@@ -291,7 +165,7 @@ int init_se_kmem_caches(void)
 			__alignof__(struct t10_alua_tg_pt_gp_member),
 			0, NULL);
 	if (!(t10_alua_tg_pt_gp_mem_cache)) {
-		printk(KERN_ERR "kmem_cache_create() for t10_alua_tg_pt_gp_"
+		pr_err("kmem_cache_create() for t10_alua_tg_pt_gp_"
 				"mem_t failed\n");
 		goto out;
 	}
@@ -367,19 +241,19 @@ static int transport_subsystem_reqmods(void)
 
 	ret = request_module("target_core_iblock");
 	if (ret != 0)
-		printk(KERN_ERR "Unable to load target_core_iblock\n");
+		pr_err("Unable to load target_core_iblock\n");
 
 	ret = request_module("target_core_file");
 	if (ret != 0)
-		printk(KERN_ERR "Unable to load target_core_file\n");
+		pr_err("Unable to load target_core_file\n");
 
 	ret = request_module("target_core_pscsi");
 	if (ret != 0)
-		printk(KERN_ERR "Unable to load target_core_pscsi\n");
+		pr_err("Unable to load target_core_pscsi\n");
 
 	ret = request_module("target_core_stgt");
 	if (ret != 0)
-		printk(KERN_ERR "Unable to load target_core_stgt\n");
+		pr_err("Unable to load target_core_stgt\n");
 
 	return 0;
 }
@@ -407,7 +281,7 @@ struct se_session *transport_init_session(void)
 
 	se_sess = kmem_cache_zalloc(se_sess_cache, GFP_KERNEL);
 	if (!(se_sess)) {
-		printk(KERN_ERR "Unable to allocate struct se_session from"
+		pr_err("Unable to allocate struct se_session from"
 				" se_sess_cache\n");
 		return ERR_PTR(-ENOMEM);
 	}
@@ -461,7 +335,7 @@ void __transport_register_session(
 	}
 	list_add_tail(&se_sess->sess_list, &se_tpg->tpg_sess_list);
 
-	printk(KERN_INFO "TARGET_CORE[%s]: Registered fabric_sess_ptr: %p\n",
+	pr_debug("TARGET_CORE[%s]: Registered fabric_sess_ptr: %p\n",
 		se_tpg->se_tpg_tfo->get_fabric_name(), se_sess->fabric_sess_ptr);
 }
 EXPORT_SYMBOL(__transport_register_session);
@@ -554,7 +428,7 @@ void transport_deregister_session(struct se_session *se_sess)
 
 	transport_free_session(se_sess);
 
-	printk(KERN_INFO "TARGET_CORE[%s]: Deregistered fabric_sess\n",
+	pr_debug("TARGET_CORE[%s]: Deregistered fabric_sess\n",
 		se_tpg->se_tpg_tfo->get_fabric_name());
 }
 EXPORT_SYMBOL(transport_deregister_session);
@@ -581,8 +455,8 @@ static void transport_all_task_dev_remove_state(struct se_cmd *cmd)
 
 		spin_lock_irqsave(&dev->execute_task_lock, flags);
 		list_del(&task->t_state_list);
-		DEBUG_TSTATE("Removed ITT: 0x%08x dev: %p task[%p]\n",
-			CMD_TFO(cmd)->tfo_get_task_tag(cmd), dev, task);
+		pr_debug("Removed ITT: 0x%08x dev: %p task[%p]\n",
+			cmd->se_tfo->get_task_tag(cmd), dev, task);
 		spin_unlock_irqrestore(&dev->execute_task_lock, flags);
 
 		atomic_set(&task->task_state_active, 0);
@@ -611,9 +485,9 @@ static int transport_cmd_check_stop(
 	 * command for LUN shutdown purposes.
 	 */
 	if (atomic_read(&cmd->transport_lun_stop)) {
-		DEBUG_CS("%s:%d atomic_read(&cmd->transport_lun_stop)"
+		pr_debug("%s:%d atomic_read(&cmd->transport_lun_stop)"
 			" == TRUE for ITT: 0x%08x\n", __func__, __LINE__,
-			CMD_TFO(cmd)->get_task_tag(cmd));
+			cmd->se_tfo->get_task_tag(cmd));
 
 		cmd->deferred_t_state = cmd->t_state;
 		cmd->t_state = TRANSPORT_DEFERRED_CMD;
@@ -630,9 +504,9 @@ static int transport_cmd_check_stop(
 	 * this command for frontend exceptions.
 	 */
 	if (atomic_read(&cmd->t_transport_stop)) {
-		DEBUG_CS("%s:%d atomic_read(&cmd->t_transport_stop) =="
+		pr_debug("%s:%d atomic_read(&cmd->t_transport_stop) =="
 			" TRUE for ITT: 0x%08x\n", __func__, __LINE__,
-			CMD_TFO(cmd)->get_task_tag(cmd));
+			cmd->se_tfo->get_task_tag(cmd));
 
 		cmd->deferred_t_state = cmd->t_state;
 		cmd->t_state = TRANSPORT_DEFERRED_CMD;
@@ -711,7 +585,7 @@ check_lun:
 		list_del(&cmd->se_lun_node);
 		atomic_set(&cmd->transport_lun_active, 0);
 #if 0
-		printk(KERN_INFO "Removed ITT: 0x%08x from LUN LIST[%d]\n"
+		pr_debug("Removed ITT: 0x%08x from LUN LIST[%d]\n"
 			cmd->se_tfo->get_task_tag(cmd), lun->unpacked_lun);
 #endif
 	}
@@ -814,7 +688,7 @@ static void transport_remove_cmd_from_queue(struct se_cmd *cmd,
 	spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
 
 	if (atomic_read(&cmd->t_transport_queue_active)) {
-		printk(KERN_ERR "ITT: 0x%08x t_transport_queue_active: %d\n",
+		pr_err("ITT: 0x%08x t_transport_queue_active: %d\n",
 			cmd->se_tfo->get_task_tag(cmd),
 			atomic_read(&cmd->t_transport_queue_active));
 	}
@@ -855,7 +729,7 @@ void transport_complete_task(struct se_task *task, int success)
 	int t_state;
 	unsigned long flags;
 #if 0
-	printk(KERN_INFO "task: %p CDB: 0x%02x obj_ptr: %p\n", task,
+	pr_debug("task: %p CDB: 0x%02x obj_ptr: %p\n", task,
 			cmd->t_task_cdb[0], dev);
 #endif
 	if (dev)
@@ -978,9 +852,9 @@ static inline int transport_add_task_check_sam_attr(
 				&task_prev->t_execute_list :
 				&dev->execute_task_list);
 
-		DEBUG_STA("Set HEAD_OF_QUEUE for task CDB: 0x%02x"
+		pr_debug("Set HEAD_OF_QUEUE for task CDB: 0x%02x"
 				" in execution queue\n",
-				T_TASK(task->task_se_cmd)->t_task_cdb[0]);
+				task->task_se_cmd->t_task_cdb[0]);
 		return 1;
 	}
 	/*
@@ -1022,8 +896,8 @@ static void __transport_add_task_to_execute_queue(
 
 	atomic_set(&task->task_state_active, 1);
 
-	DEBUG_TSTATE("Added ITT: 0x%08x task[%p] to dev: %p\n",
-		CMD_TFO(task->task_se_cmd)->get_task_tag(task->task_se_cmd),
+	pr_debug("Added ITT: 0x%08x task[%p] to dev: %p\n",
+		task->task_se_cmd->se_tfo->get_task_tag(task->task_se_cmd),
 		task, dev);
 }
 
@@ -1044,8 +918,8 @@ static void transport_add_tasks_to_state_queue(struct se_cmd *cmd)
 		list_add_tail(&task->t_state_list, &dev->state_task_list);
 		atomic_set(&task->task_state_active, 1);
 
-		DEBUG_TSTATE("Added ITT: 0x%08x task[%p] to dev: %p\n",
-			CMD_TFO(task->task_se_cmd)->get_task_tag(
+		pr_debug("Added ITT: 0x%08x task[%p] to dev: %p\n",
+			task->task_se_cmd->se_tfo->get_task_tag(
 			task->task_se_cmd), task, dev);
 
 		spin_unlock(&dev->execute_task_lock);
@@ -1114,7 +988,7 @@ static void target_qf_do_work(struct work_struct *work)
 		smp_mb__after_atomic_dec();
 		spin_unlock_irq(&dev->qf_cmd_lock);
 
-		printk(KERN_INFO "Processing %s cmd: %p QUEUE_FULL in work queue"
+		pr_debug("Processing %s cmd: %p QUEUE_FULL in work queue"
 			" context: %s\n", cmd->se_tfo->get_fabric_name(), cmd,
 			(cmd->t_state == TRANSPORT_COMPLETE_OK) ? "COMPLETE_OK" :
 			(cmd->t_state == TRANSPORT_COMPLETE_QF_WP) ? "WRITE_PENDING"
@@ -1202,7 +1076,7 @@ static void transport_release_all_cmds(struct se_device *dev)
 		spin_unlock_irqrestore(&dev->dev_queue_obj.cmd_queue_lock,
 				flags);
 
-		printk(KERN_ERR "Releasing ITT: 0x%08x, i_state: %u,"
+		pr_err("Releasing ITT: 0x%08x, i_state: %u,"
 			" t_state: %u directly\n",
 			cmd->se_tfo->get_task_tag(cmd),
 			cmd->se_tfo->get_cmd_state(cmd), t_state);
@@ -1269,7 +1143,7 @@ void transport_dump_vpd_proto_id(
 	if (p_buf)
 		strncpy(p_buf, buf, p_buf_len);
 	else
-		printk(KERN_INFO "%s", buf);
+		pr_debug("%s", buf);
 }
 
 void
@@ -1319,7 +1193,7 @@ int transport_dump_vpd_assoc(
 	if (p_buf)
 		strncpy(p_buf, buf, p_buf_len);
 	else
-		printk("%s", buf);
+		pr_debug("%s", buf);
 
 	return ret;
 }
@@ -1379,7 +1253,7 @@ int transport_dump_vpd_ident_type(
 			return -EINVAL;
 		strncpy(p_buf, buf, p_buf_len);
 	} else {
-		printk("%s", buf);
+		pr_debug("%s", buf);
 	}
 
 	return ret;
@@ -1430,7 +1304,7 @@ int transport_dump_vpd_ident(
 	if (p_buf)
 		strncpy(p_buf, buf, p_buf_len);
 	else
-		printk("%s", buf);
+		pr_debug("%s", buf);
 
 	return ret;
 }
@@ -1487,7 +1361,7 @@ static void core_setup_task_attr_emulation(struct se_device *dev)
 	}
 
 	dev->dev_task_attr_type = SAM_TASK_ATTR_EMULATED;
-	DEBUG_STA("%s: Using SAM_TASK_ATTR_EMULATED for SPC: 0x%02x"
+	pr_debug("%s: Using SAM_TASK_ATTR_EMULATED for SPC: 0x%02x"
 		" device\n", dev->transport->name,
 		dev->transport->get_device_rev(dev));
 }
@@ -1499,32 +1373,32 @@ static void scsi_dump_inquiry(struct se_device *dev)
 	/*
 	 * Print Linux/SCSI style INQUIRY formatting to the kernel ring buffer
 	 */
-	printk("  Vendor: ");
+	pr_debug("  Vendor: ");
 	for (i = 0; i < 8; i++)
 		if (wwn->vendor[i] >= 0x20)
-			printk("%c", wwn->vendor[i]);
+			pr_debug("%c", wwn->vendor[i]);
 		else
-			printk(" ");
+			pr_debug(" ");
 
-	printk("  Model: ");
+	pr_debug("  Model: ");
 	for (i = 0; i < 16; i++)
 		if (wwn->model[i] >= 0x20)
-			printk("%c", wwn->model[i]);
+			pr_debug("%c", wwn->model[i]);
 		else
-			printk(" ");
+			pr_debug(" ");
 
-	printk("  Revision: ");
+	pr_debug("  Revision: ");
 	for (i = 0; i < 4; i++)
 		if (wwn->revision[i] >= 0x20)
-			printk("%c", wwn->revision[i]);
+			pr_debug("%c", wwn->revision[i]);
 		else
-			printk(" ");
+			pr_debug(" ");
 
-	printk("\n");
+	pr_debug("\n");
 
 	device_type = dev->transport->get_device_type(dev);
-	printk("  Type:   %s ", scsi_device_type(device_type));
-	printk("                 ANSI SCSI revision: %02x\n",
+	pr_debug("  Type:   %s ", scsi_device_type(device_type));
+	pr_debug("                 ANSI SCSI revision: %02x\n",
 				dev->transport->get_device_rev(dev));
 }
 
@@ -1543,7 +1417,7 @@ struct se_device *transport_add_device_to_core_hba(
 
 	dev = kzalloc(sizeof(struct se_device), GFP_KERNEL);
 	if (!(dev)) {
-		printk(KERN_ERR "Unable to allocate memory for se_dev_t\n");
+		pr_err("Unable to allocate memory for se_dev_t\n");
 		return NULL;
 	}
 
@@ -1613,7 +1487,7 @@ struct se_device *transport_add_device_to_core_hba(
 	dev->process_thread = kthread_run(transport_processing_thread, dev,
 					  "LIO_%s", dev->transport->name);
 	if (IS_ERR(dev->process_thread)) {
-		printk(KERN_ERR "Unable to create kthread: LIO_%s\n",
+		pr_err("Unable to create kthread: LIO_%s\n",
 			dev->transport->name);
 		goto out;
 	}
@@ -1631,7 +1505,7 @@ struct se_device *transport_add_device_to_core_hba(
 	 */
 	if (dev->transport->transport_type != TRANSPORT_PLUGIN_PHBA_PDEV) {
 		if (!inquiry_prod || !inquiry_rev) {
-			printk(KERN_ERR "All non TCM/pSCSI plugins require"
+			pr_err("All non TCM/pSCSI plugins require"
 				" INQUIRY consts\n");
 			goto out;
 		}
@@ -1695,7 +1569,7 @@ transport_generic_get_task(struct se_cmd *cmd,
 
 	task = dev->transport->alloc_task(cmd);
 	if (!task) {
-		printk(KERN_ERR "Unable to allocate struct se_task\n");
+		pr_err("Unable to allocate struct se_task\n");
 		return NULL;
 	}
 
@@ -1756,7 +1630,7 @@ static int transport_check_alloc_task_attr(struct se_cmd *cmd)
 		return 0;
 
 	if (cmd->sam_task_attr == MSG_ACA_TAG) {
-		DEBUG_STA("SAM Task Attribute ACA"
+		pr_debug("SAM Task Attribute ACA"
 			" emulation is not supported\n");
 		return -EINVAL;
 	}
@@ -1766,9 +1640,9 @@ static int transport_check_alloc_task_attr(struct se_cmd *cmd)
 	 */
 	cmd->se_ordered_id = atomic_inc_return(&cmd->se_dev->dev_ordered_id);
 	smp_mb__after_atomic_inc();
-	DEBUG_STA("Allocated se_ordered_id: %u for Task Attr: 0x%02x on %s\n",
+	pr_debug("Allocated se_ordered_id: %u for Task Attr: 0x%02x on %s\n",
 			cmd->se_ordered_id, cmd->sam_task_attr,
-			TRANSPORT(cmd->se_dev)->name);
+			cmd->se_dev->transport->name);
 	return 0;
 }
 
@@ -1809,7 +1683,7 @@ int transport_generic_allocate_tasks(
 	 * for VARIABLE_LENGTH_CMD
 	 */
 	if (scsi_command_size(cdb) > SCSI_MAX_VARLEN_CDB_SIZE) {
-		printk(KERN_ERR "Received SCSI CDB with command_size: %d that"
+		pr_err("Received SCSI CDB with command_size: %d that"
 			" exceeds SCSI_MAX_VARLEN_CDB_SIZE: %d\n",
 			scsi_command_size(cdb), SCSI_MAX_VARLEN_CDB_SIZE);
 		return -EINVAL;
@@ -1823,7 +1697,7 @@ int transport_generic_allocate_tasks(
 		cmd->t_task_cdb = kzalloc(scsi_command_size(cdb),
 						GFP_KERNEL);
 		if (!(cmd->t_task_cdb)) {
-			printk(KERN_ERR "Unable to allocate cmd->t_task_cdb"
+			pr_err("Unable to allocate cmd->t_task_cdb"
 				" %u > sizeof(cmd->__t_task_cdb): %lu ops\n",
 				scsi_command_size(cdb),
 				(unsigned long)sizeof(cmd->__t_task_cdb));
@@ -1869,7 +1743,7 @@ int transport_generic_handle_cdb(
 {
 	if (!cmd->se_lun) {
 		dump_stack();
-		printk(KERN_ERR "cmd->se_lun is NULL\n");
+		pr_err("cmd->se_lun is NULL\n");
 		return -EINVAL;
 	}
 
@@ -1887,12 +1761,12 @@ int transport_handle_cdb_direct(
 {
 	if (!cmd->se_lun) {
 		dump_stack();
-		printk(KERN_ERR "cmd->se_lun is NULL\n");
+		pr_err("cmd->se_lun is NULL\n");
 		return -EINVAL;
 	}
 	if (in_interrupt()) {
 		dump_stack();
-		printk(KERN_ERR "transport_generic_handle_cdb cannot be called"
+		pr_err("transport_generic_handle_cdb cannot be called"
 				" from interrupt context\n");
 		return -EINVAL;
 	}
@@ -1911,7 +1785,7 @@ int transport_generic_handle_cdb_map(
 {
 	if (!cmd->se_lun) {
 		dump_stack();
-		printk(KERN_ERR "cmd->se_lun is NULL\n");
+		pr_err("cmd->se_lun is NULL\n");
 		return -EINVAL;
 	}
 
@@ -1980,7 +1854,7 @@ static int transport_stop_tasks_for_cmd(struct se_cmd *cmd)
 	unsigned long flags;
 	int ret = 0;
 
-	DEBUG_TS("ITT[0x%08x] - Stopping tasks\n",
+	pr_debug("ITT[0x%08x] - Stopping tasks\n",
 		cmd->se_tfo->get_task_tag(cmd));
 
 	/*
@@ -1989,7 +1863,7 @@ static int transport_stop_tasks_for_cmd(struct se_cmd *cmd)
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	list_for_each_entry_safe(task, task_tmp,
 				&cmd->t_task_list, t_list) {
-		DEBUG_TS("task_no[%d] - Processing task %p\n",
+		pr_debug("task_no[%d] - Processing task %p\n",
 				task->task_no, task);
 		/*
 		 * If the struct se_task has not been sent and is not active,
@@ -2002,7 +1876,7 @@ static int transport_stop_tasks_for_cmd(struct se_cmd *cmd)
 			transport_remove_task_from_execute_queue(task,
 					task->se_dev);
 
-			DEBUG_TS("task_no[%d] - Removed from execute queue\n",
+			pr_debug("task_no[%d] - Removed from execute queue\n",
 				task->task_no);
 			spin_lock_irqsave(&cmd->t_state_lock, flags);
 			continue;
@@ -2017,10 +1891,10 @@ static int transport_stop_tasks_for_cmd(struct se_cmd *cmd)
 			spin_unlock_irqrestore(&cmd->t_state_lock,
 					flags);
 
-			DEBUG_TS("task_no[%d] - Waiting to complete\n",
+			pr_debug("task_no[%d] - Waiting to complete\n",
 				task->task_no);
 			wait_for_completion(&task->task_stop_comp);
-			DEBUG_TS("task_no[%d] - Stopped successfully\n",
+			pr_debug("task_no[%d] - Stopped successfully\n",
 				task->task_no);
 
 			spin_lock_irqsave(&cmd->t_state_lock, flags);
@@ -2029,7 +1903,7 @@ static int transport_stop_tasks_for_cmd(struct se_cmd *cmd)
 			atomic_set(&task->task_active, 0);
 			atomic_set(&task->task_stop, 0);
 		} else {
-			DEBUG_TS("task_no[%d] - Did nothing\n", task->task_no);
+			pr_debug("task_no[%d] - Did nothing\n", task->task_no);
 			ret++;
 		}
 
@@ -2051,18 +1925,18 @@ static void transport_generic_request_failure(
 {
 	int ret = 0;
 
-	DEBUG_GRF("-----[ Storage Engine Exception for cmd: %p ITT: 0x%08x"
+	pr_debug("-----[ Storage Engine Exception for cmd: %p ITT: 0x%08x"
 		" CDB: 0x%02x\n", cmd, cmd->se_tfo->get_task_tag(cmd),
 		cmd->t_task_cdb[0]);
-	DEBUG_GRF("-----[ i_state: %d t_state/def_t_state:"
+	pr_debug("-----[ i_state: %d t_state/def_t_state:"
 		" %d/%d transport_error_status: %d\n",
 		cmd->se_tfo->get_cmd_state(cmd),
 		cmd->t_state, cmd->deferred_t_state,
 		cmd->transport_error_status);
-	DEBUG_GRF("-----[ t_task_cdbs: %d t_task_cdbs_left: %d"
+	pr_debug("-----[ t_tasks: %d t_task_cdbs_left: %d"
 		" t_task_cdbs_sent: %d t_task_cdbs_ex_left: %d --"
 		" t_transport_active: %d t_transport_stop: %d"
-		" t_transport_sent: %d\n", cmd->t_task_cdbs,
+		" t_transport_sent: %d\n", cmd->t_task_list_num,
 		atomic_read(&cmd->t_task_cdbs_left),
 		atomic_read(&cmd->t_task_cdbs_sent),
 		atomic_read(&cmd->t_task_cdbs_ex_left),
@@ -2151,7 +2025,7 @@ static void transport_generic_request_failure(
 		 */
 		break;
 	default:
-		printk(KERN_ERR "Unknown transport error for CDB 0x%02x: %d\n",
+		pr_err("Unknown transport error for CDB 0x%02x: %d\n",
 			cmd->t_task_cdb[0],
 			cmd->transport_error_status);
 		cmd->scsi_sense_reason = TCM_UNSUPPORTED_SCSI_OPCODE;
@@ -2267,7 +2141,7 @@ static void transport_task_timeout_handler(unsigned long data)
 	struct se_cmd *cmd = task->task_se_cmd;
 	unsigned long flags;
 
-	DEBUG_TT("transport task timeout fired! task: %p cmd: %p\n", task, cmd);
+	pr_debug("transport task timeout fired! task: %p cmd: %p\n", task, cmd);
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	if (task->task_flags & TF_STOP) {
@@ -2280,7 +2154,7 @@ static void transport_task_timeout_handler(unsigned long data)
 	 * Determine if transport_complete_task() has already been called.
 	 */
 	if (!(atomic_read(&task->task_active))) {
-		DEBUG_TT("transport task: %p cmd: %p timeout task_active"
+		pr_debug("transport task: %p cmd: %p timeout task_active"
 				" == 0\n", task, cmd);
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		return;
@@ -2295,7 +2169,7 @@ static void transport_task_timeout_handler(unsigned long data)
 	task->task_scsi_status = 1;
 
 	if (atomic_read(&task->task_stop)) {
-		DEBUG_TT("transport task: %p cmd: %p timeout task_stop"
+		pr_debug("transport task: %p cmd: %p timeout task_stop"
 				" == 1\n", task, cmd);
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		complete(&task->task_stop_comp);
@@ -2303,12 +2177,12 @@ static void transport_task_timeout_handler(unsigned long data)
 	}
 
 	if (!(atomic_dec_and_test(&cmd->t_task_cdbs_left))) {
-		DEBUG_TT("transport task: %p cmd: %p timeout non zero"
+		pr_debug("transport task: %p cmd: %p timeout non zero"
 				" t_task_cdbs_left\n", task, cmd);
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		return;
 	}
-	DEBUG_TT("transport task: %p cmd: %p timeout ZERO t_task_cdbs_left\n",
+	pr_debug("transport task: %p cmd: %p timeout ZERO t_task_cdbs_left\n",
 			task, cmd);
 
 	cmd->t_state = TRANSPORT_COMPLETE_FAILURE;
@@ -2342,7 +2216,7 @@ static void transport_start_task_timer(struct se_task *task)
 	task->task_flags |= TF_RUNNING;
 	add_timer(&task->task_timer);
 #if 0
-	printk(KERN_INFO "Starting task timer for cmd: %p task: %p seconds:"
+	pr_debug("Starting task timer for cmd: %p task: %p seconds:"
 		" %d\n", task->task_se_cmd, task, timeout);
 #endif
 }
@@ -2409,7 +2283,7 @@ static inline int transport_execute_task_attr(struct se_cmd *cmd)
 	 if (cmd->sam_task_attr == MSG_HEAD_TAG) {
 		atomic_inc(&cmd->se_dev->dev_hoq_count);
 		smp_mb__after_atomic_inc();
-		DEBUG_STA("Added HEAD_OF_QUEUE for CDB:"
+		pr_debug("Added HEAD_OF_QUEUE for CDB:"
 			" 0x%02x, se_ordered_id: %u\n",
 			cmd->t_task_cdb[0],
 			cmd->se_ordered_id);
@@ -2423,7 +2297,7 @@ static inline int transport_execute_task_attr(struct se_cmd *cmd)
 		atomic_inc(&cmd->se_dev->dev_ordered_sync);
 		smp_mb__after_atomic_inc();
 
-		DEBUG_STA("Added ORDERED for CDB: 0x%02x to ordered"
+		pr_debug("Added ORDERED for CDB: 0x%02x to ordered"
 				" list, se_ordered_id: %u\n",
 				cmd->t_task_cdb[0],
 				cmd->se_ordered_id);
@@ -2457,7 +2331,7 @@ static inline int transport_execute_task_attr(struct se_cmd *cmd)
 				&cmd->se_dev->delayed_cmd_list);
 		spin_unlock(&cmd->se_dev->delayed_cmd_lock);
 
-		DEBUG_STA("Added CDB: 0x%02x Task Attr: 0x%02x to"
+		pr_debug("Added CDB: 0x%02x Task Attr: 0x%02x to"
 			" delayed CMD list, se_ordered_id: %u\n",
 			cmd->t_task_cdb[0], cmd->sam_task_attr,
 			cmd->se_ordered_id);
@@ -2783,7 +2657,7 @@ static inline u32 transport_get_size(
 			return sectors;
 	}
 #if 0
-	printk(KERN_INFO "Returning block_size: %u, sectors: %u == %u for"
+	pr_debug("Returning block_size: %u, sectors: %u == %u for"
 			" %s object\n", dev->se_sub_dev->se_dev_attrib.block_size, sectors,
 			dev->se_sub_dev->se_dev_attrib.block_size * sectors,
 			dev->transport->name);
@@ -2839,7 +2713,7 @@ static void transport_xor_callback(struct se_cmd *cmd)
 	 */
 	buf = kmalloc(cmd->data_length, GFP_KERNEL);
 	if (!(buf)) {
-		printk(KERN_ERR "Unable to allocate xor_callback buf\n");
+		pr_err("Unable to allocate xor_callback buf\n");
 		return;
 	}
 	/*
@@ -2903,14 +2777,14 @@ static int transport_get_sense_data(struct se_cmd *cmd)
 			continue;
 
 		if (!dev->transport->get_sense_buffer) {
-			printk(KERN_ERR "dev->transport->get_sense_buffer"
+			pr_err("dev->transport->get_sense_buffer"
 					" is NULL\n");
 			continue;
 		}
 
 		sense_buffer = dev->transport->get_sense_buffer(task);
 		if (!(sense_buffer)) {
-			printk(KERN_ERR "ITT[0x%08x]_TASK[%d]: Unable to locate"
+			pr_err("ITT[0x%08x]_TASK[%d]: Unable to locate"
 				" sense buffer for task with sense\n",
 				cmd->se_tfo->get_task_tag(cmd), task->task_no);
 			continue;
@@ -2927,7 +2801,7 @@ static int transport_get_sense_data(struct se_cmd *cmd)
 		cmd->scsi_sense_length =
 				(TRANSPORT_SENSE_BUFFER + offset);
 
-		printk(KERN_INFO "HBA_[%u]_PLUG[%s]: Set SAM STATUS: 0x%02x"
+		pr_debug("HBA_[%u]_PLUG[%s]: Set SAM STATUS: 0x%02x"
 				" and sense\n",
 			dev->se_hba->hba_id, dev->transport->name,
 				cmd->scsi_status);
@@ -2977,11 +2851,11 @@ static int transport_cmd_get_valid_sectors(struct se_cmd *cmd)
 
 	if ((cmd->t_task_lba + sectors) >
 	     transport_dev_end_lba(dev)) {
-		printk(KERN_ERR "LBA: %llu Sectors: %u exceeds"
+		pr_err("LBA: %llu Sectors: %u exceeds"
 			" transport_dev_end_lba(): %llu\n",
 			cmd->t_task_lba, sectors,
 			transport_dev_end_lba(dev));
-		printk(KERN_ERR "  We should return CHECK_CONDITION"
+		pr_err("  We should return CHECK_CONDITION"
 		       " but we don't yet\n");
 		return 0;
 	}
@@ -3032,7 +2906,7 @@ static int transport_generic_cmd_sequencer(
 		 */
 		if (ret > 0) {
 #if 0
-			printk(KERN_INFO "[%s]: ALUA TG Port not available,"
+			pr_debug("[%s]: ALUA TG Port not available,"
 				" SenseKey: NOT_READY, ASC/ASCQ: 0x04/0x%02x\n",
 				cmd->se_tfo->get_fabric_name(), alua_ascq);
 #endif
@@ -3213,7 +3087,7 @@ static int transport_generic_cmd_sequencer(
 				break;
 
 			if ((cdb[10] & 0x04) || (cdb[10] & 0x02)) {
-				printk(KERN_ERR "WRITE_SAME PBDATA and LBDATA"
+				pr_err("WRITE_SAME PBDATA and LBDATA"
 					" bits not supported for Block Discard"
 					" Emulation\n");
 				goto out_invalid_cdb_field;
@@ -3223,13 +3097,13 @@ static int transport_generic_cmd_sequencer(
 			 * tpws with the UNMAP=1 bit set.
 			 */
 			if (!(cdb[10] & 0x08)) {
-				printk(KERN_ERR "WRITE_SAME w/o UNMAP bit not"
+				pr_err("WRITE_SAME w/o UNMAP bit not"
 					" supported for Block Discard Emulation\n");
 				goto out_invalid_cdb_field;
 			}
 			break;
 		default:
-			printk(KERN_ERR "VARIABLE_LENGTH_CMD service action"
+			pr_err("VARIABLE_LENGTH_CMD service action"
 				" 0x%04x not supported\n", service_action);
 			goto out_unsupported_cdb;
 		}
@@ -3492,7 +3366,7 @@ static int transport_generic_cmd_sequencer(
 		 */
 		if (!(passthrough)) {
 			if ((cdb[1] & 0x04) || (cdb[1] & 0x02)) {
-				printk(KERN_ERR "WRITE_SAME PBDATA and LBDATA"
+				pr_err("WRITE_SAME PBDATA and LBDATA"
 					" bits not supported for Block Discard"
 					" Emulation\n");
 				goto out_invalid_cdb_field;
@@ -3502,7 +3376,7 @@ static int transport_generic_cmd_sequencer(
 			 * tpws with the UNMAP=1 bit set.
 			 */
 			if (!(cdb[1] & 0x08)) {
-				printk(KERN_ERR "WRITE_SAME w/o UNMAP bit not "
+				pr_err("WRITE_SAME w/o UNMAP bit not "
 					" supported for Block Discard Emulation\n");
 				goto out_invalid_cdb_field;
 			}
@@ -3538,7 +3412,7 @@ static int transport_generic_cmd_sequencer(
 		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
 		break;
 	default:
-		printk(KERN_WARNING "TARGET_CORE[%s]: Unsupported SCSI Opcode"
+		pr_warn("TARGET_CORE[%s]: Unsupported SCSI Opcode"
 			" 0x%02x, sending CHECK_CONDITION.\n",
 			cmd->se_tfo->get_fabric_name(), cdb[0]);
 		cmd->transport_wait_for_tasks = &transport_nop_wait_for_tasks;
@@ -3546,7 +3420,7 @@ static int transport_generic_cmd_sequencer(
 	}
 
 	if (size != cmd->data_length) {
-		printk(KERN_WARNING "TARGET_CORE[%s]: Expected Transfer Length:"
+		pr_warn("TARGET_CORE[%s]: Expected Transfer Length:"
 			" %u does not match SCSI CDB Length: %u for SAM Opcode:"
 			" 0x%02x\n", cmd->se_tfo->get_fabric_name(),
 				cmd->data_length, size, cdb[0]);
@@ -3554,7 +3428,7 @@ static int transport_generic_cmd_sequencer(
 		cmd->cmd_spdtl = size;
 
 		if (cmd->data_direction == DMA_TO_DEVICE) {
-			printk(KERN_ERR "Rejecting underflow/overflow"
+			pr_err("Rejecting underflow/overflow"
 					" WRITE data\n");
 			goto out_invalid_cdb_field;
 		}
@@ -3563,7 +3437,7 @@ static int transport_generic_cmd_sequencer(
 		 * type SCF_SCSI_DATA_SG_IO_CDB.
 		 */
 		if (!(ret) && (dev->se_sub_dev->se_dev_attrib.block_size != 512))  {
-			printk(KERN_ERR "Failing OVERFLOW/UNDERFLOW for LBA op"
+			pr_err("Failing OVERFLOW/UNDERFLOW for LBA op"
 				" CDB on non 512-byte sector setup subsystem"
 				" plugin: %s\n", dev->transport->name);
 			/* Returns CHECK_CONDITION + INVALID_CDB_FIELD */
@@ -3613,14 +3487,14 @@ static void transport_complete_task_attr(struct se_cmd *cmd)
 		atomic_dec(&dev->simple_cmds);
 		smp_mb__after_atomic_dec();
 		dev->dev_cur_ordered_id++;
-		DEBUG_STA("Incremented dev->dev_cur_ordered_id: %u for"
+		pr_debug("Incremented dev->dev_cur_ordered_id: %u for"
 			" SIMPLE: %u\n", dev->dev_cur_ordered_id,
 			cmd->se_ordered_id);
 	} else if (cmd->sam_task_attr == MSG_HEAD_TAG) {
 		atomic_dec(&dev->dev_hoq_count);
 		smp_mb__after_atomic_dec();
 		dev->dev_cur_ordered_id++;
-		DEBUG_STA("Incremented dev_cur_ordered_id: %u for"
+		pr_debug("Incremented dev_cur_ordered_id: %u for"
 			" HEAD_OF_QUEUE: %u\n", dev->dev_cur_ordered_id,
 			cmd->se_ordered_id);
 	} else if (cmd->sam_task_attr == MSG_ORDERED_TAG) {
@@ -3631,7 +3505,7 @@ static void transport_complete_task_attr(struct se_cmd *cmd)
 		spin_unlock(&dev->ordered_cmd_lock);
 
 		dev->dev_cur_ordered_id++;
-		DEBUG_STA("Incremented dev_cur_ordered_id: %u for ORDERED:"
+		pr_debug("Incremented dev_cur_ordered_id: %u for ORDERED:"
 			" %u\n", dev->dev_cur_ordered_id, cmd->se_ordered_id);
 	}
 	/*
@@ -3646,10 +3520,10 @@ static void transport_complete_task_attr(struct se_cmd *cmd)
 		list_del(&cmd_p->se_delayed_node);
 		spin_unlock(&dev->delayed_cmd_lock);
 
-		DEBUG_STA("Calling add_tasks() for"
+		pr_debug("Calling add_tasks() for"
 			" cmd_p: 0x%02x Task Attr: 0x%02x"
 			" Dormant -> Active, se_ordered_id: %u\n",
-			T_TASK(cmd_p)->t_task_cdb[0],
+			cmd_p->t_task_cdb[0],
 			cmd_p->sam_task_attr, cmd_p->se_ordered_id);
 
 		transport_add_tasks_from_cmd(cmd_p);
@@ -3818,7 +3692,7 @@ done:
 	return;
 
 queue_full:
-	printk(KERN_INFO "Handling complete_ok QUEUE_FULL: se_cmd: %p,"
+	pr_debug("Handling complete_ok QUEUE_FULL: se_cmd: %p,"
 		" data_direction: %d\n", cmd, cmd->data_direction);
 	transport_handle_queue_full(cmd, cmd->se_dev, transport_complete_qf);
 }
@@ -3843,7 +3717,7 @@ static void transport_free_dev_tasks(struct se_cmd *cmd)
 		if (task->se_dev)
 			task->se_dev->transport->free_task(task);
 		else
-			printk(KERN_ERR "task[%u] - task->se_dev is NULL\n",
+			pr_err("task[%u] - task->se_dev is NULL\n",
 				task->task_no);
 		spin_lock_irqsave(&cmd->t_state_lock, flags);
 	}
@@ -4186,19 +4060,19 @@ void transport_do_task_sg_chain(struct se_cmd *cmd)
 	cmd->t_tasks_sg_chained = sg_first;
 	cmd->t_tasks_sg_chained_no = chained_nents;
 
-	DEBUG_CMD_M("Setup cmd: %p cmd->t_tasks_sg_chained: %p and"
+	pr_debug("Setup cmd: %p cmd->t_tasks_sg_chained: %p and"
 		" t_tasks_sg_chained_no: %u\n", cmd, cmd->t_tasks_sg_chained,
 		cmd->t_tasks_sg_chained_no);
 
 	for_each_sg(cmd->t_tasks_sg_chained, sg,
 			cmd->t_tasks_sg_chained_no, i) {
 
-		DEBUG_CMD_M("SG[%d]: %p page: %p length: %d offset: %d\n",
+		pr_debug("SG[%d]: %p page: %p length: %d offset: %d\n",
 			i, sg, sg_page(sg), sg->length, sg->offset);
 		if (sg_is_chain(sg))
-			DEBUG_CMD_M("SG: %p sg_is_chain=1\n", sg);
+			pr_debug("SG: %p sg_is_chain=1\n", sg);
 		if (sg_is_last(sg))
-			DEBUG_CMD_M("SG: %p sg_is_last=1\n", sg);
+			pr_debug("SG: %p sg_is_last=1\n", sg);
 	}
 }
 EXPORT_SYMBOL(transport_do_task_sg_chain);
@@ -4492,7 +4366,7 @@ static int transport_generic_write_pending(struct se_cmd *cmd)
 	return PYX_TRANSPORT_WRITE_PENDING;
 
 queue_full:
-	printk(KERN_INFO "Handling write_pending QUEUE__FULL: se_cmd: %p\n", cmd);
+	pr_debug("Handling write_pending QUEUE__FULL: se_cmd: %p\n", cmd);
 	cmd->t_state = TRANSPORT_COMPLETE_QF_WP;
 	transport_handle_queue_full(cmd, cmd->se_dev,
 			transport_write_pending_qf);
@@ -4524,7 +4398,7 @@ void transport_generic_free_cmd(
 
 		if (cmd->se_lun) {
 #if 0
-			printk(KERN_INFO "cmd: %p ITT: 0x%08x contains"
+			pr_debug("cmd: %p ITT: 0x%08x contains"
 				" cmd->se_lun\n", cmd,
 				cmd->se_tfo->get_task_tag(cmd));
 #endif
@@ -4565,7 +4439,7 @@ static int transport_lun_wait_for_tasks(struct se_cmd *cmd, struct se_lun *lun)
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	if (atomic_read(&cmd->t_transport_stop)) {
 		atomic_set(&cmd->transport_lun_stop, 0);
-		DEBUG_TRANSPORT_S("ConfigFS ITT[0x%08x] - t_transport_stop =="
+		pr_debug("ConfigFS ITT[0x%08x] - t_transport_stop =="
 			" TRUE, skipping\n", cmd->se_tfo->get_task_tag(cmd));
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		transport_cmd_check_stop(cmd, 1, 0);
@@ -4578,13 +4452,13 @@ static int transport_lun_wait_for_tasks(struct se_cmd *cmd, struct se_lun *lun)
 
 	ret = transport_stop_tasks_for_cmd(cmd);
 
-	DEBUG_TRANSPORT_S("ConfigFS: cmd: %p t_task_cdbs: %d stop tasks ret:"
-			" %d\n", cmd, cmd->t_task_cdbs, ret);
+	pr_debug("ConfigFS: cmd: %p t_tasks: %d stop tasks ret:"
+			" %d\n", cmd, cmd->t_task_list_num, ret);
 	if (!ret) {
-		DEBUG_TRANSPORT_S("ConfigFS: ITT[0x%08x] - stopping cmd....\n",
+		pr_debug("ConfigFS: ITT[0x%08x] - stopping cmd....\n",
 				cmd->se_tfo->get_task_tag(cmd));
 		wait_for_completion(&cmd->transport_lun_stop_comp);
-		DEBUG_TRANSPORT_S("ConfigFS: ITT[0x%08x] - stopped cmd....\n",
+		pr_debug("ConfigFS: ITT[0x%08x] - stopped cmd....\n",
 				cmd->se_tfo->get_task_tag(cmd));
 	}
 	transport_remove_cmd_from_queue(cmd, &cmd->se_dev->dev_queue_obj);
@@ -4592,13 +4466,6 @@ static int transport_lun_wait_for_tasks(struct se_cmd *cmd, struct se_lun *lun)
 	return 0;
 }
 
-/* #define DEBUG_CLEAR_LUN */
-#ifdef DEBUG_CLEAR_LUN
-#define DEBUG_CLEAR_L(x...) printk(KERN_INFO x)
-#else
-#define DEBUG_CLEAR_L(x...)
-#endif
-
 static void __transport_clear_lun_from_sessions(struct se_lun *lun)
 {
 	struct se_cmd *cmd = NULL;
@@ -4620,7 +4487,7 @@ static void __transport_clear_lun_from_sessions(struct se_lun *lun)
 		 * progress for the iscsi_cmd_t.
 		 */
 		spin_lock(&cmd->t_state_lock);
-		DEBUG_CLEAR_L("SE_LUN[%d] - Setting cmd->transport"
+		pr_debug("SE_LUN[%d] - Setting cmd->transport"
 			"_lun_stop for  ITT: 0x%08x\n",
 			cmd->se_lun->unpacked_lun,
 			cmd->se_tfo->get_task_tag(cmd));
@@ -4630,7 +4497,7 @@ static void __transport_clear_lun_from_sessions(struct se_lun *lun)
 		spin_unlock_irqrestore(&lun->lun_cmd_lock, lun_flags);
 
 		if (!(cmd->se_lun)) {
-			printk(KERN_ERR "ITT: 0x%08x, [i,t]_state: %u/%u\n",
+			pr_err("ITT: 0x%08x, [i,t]_state: %u/%u\n",
 				cmd->se_tfo->get_task_tag(cmd),
 				cmd->se_tfo->get_cmd_state(cmd), cmd->t_state);
 			BUG();
@@ -4639,7 +4506,7 @@ static void __transport_clear_lun_from_sessions(struct se_lun *lun)
 		 * If the Storage engine still owns the iscsi_cmd_t, determine
 		 * and/or stop its context.
 		 */
-		DEBUG_CLEAR_L("SE_LUN[%d] - ITT: 0x%08x before transport"
+		pr_debug("SE_LUN[%d] - ITT: 0x%08x before transport"
 			"_lun_wait_for_tasks()\n", cmd->se_lun->unpacked_lun,
 			cmd->se_tfo->get_task_tag(cmd));
 
@@ -4648,7 +4515,7 @@ static void __transport_clear_lun_from_sessions(struct se_lun *lun)
 			continue;
 		}
 
-		DEBUG_CLEAR_L("SE_LUN[%d] - ITT: 0x%08x after transport_lun"
+		pr_debug("SE_LUN[%d] - ITT: 0x%08x after transport_lun"
 			"_wait_for_tasks(): SUCCESS\n",
 			cmd->se_lun->unpacked_lun,
 			cmd->se_tfo->get_task_tag(cmd));
@@ -4679,7 +4546,7 @@ check_cond:
 		 */
 		spin_lock_irqsave(&cmd->t_state_lock, cmd_flags);
 		if (atomic_read(&cmd->transport_lun_fe_stop)) {
-			DEBUG_CLEAR_L("SE_LUN[%d] - Detected FE stop for"
+			pr_debug("SE_LUN[%d] - Detected FE stop for"
 				" struct se_cmd: %p ITT: 0x%08x\n",
 				lun->unpacked_lun,
 				cmd, cmd->se_tfo->get_task_tag(cmd));
@@ -4691,7 +4558,7 @@ check_cond:
 			spin_lock_irqsave(&lun->lun_cmd_lock, lun_flags);
 			continue;
 		}
-		DEBUG_CLEAR_L("SE_LUN[%d] - ITT: 0x%08x finished processing\n",
+		pr_debug("SE_LUN[%d] - ITT: 0x%08x finished processing\n",
 			lun->unpacked_lun, cmd->se_tfo->get_task_tag(cmd));
 
 		spin_unlock_irqrestore(&cmd->t_state_lock, cmd_flags);
@@ -4717,7 +4584,7 @@ int transport_clear_lun_from_sessions(struct se_lun *lun)
 	kt = kthread_run(transport_clear_lun_thread, lun,
 			"tcm_cl_%u", lun->unpacked_lun);
 	if (IS_ERR(kt)) {
-		printk(KERN_ERR "Unable to start clear_lun thread\n");
+		pr_err("Unable to start clear_lun thread\n");
 		return PTR_ERR(kt);
 	}
 	wait_for_completion(&lun->lun_shutdown_comp);
@@ -4750,7 +4617,7 @@ static void transport_generic_wait_for_tasks(
 	 */
 	if (atomic_read(&cmd->transport_lun_stop)) {
 
-		DEBUG_TRANSPORT_S("wait_for_tasks: Stopping"
+		pr_debug("wait_for_tasks: Stopping"
 			" wait_for_completion(&cmd->t_tasktransport_lun_fe"
 			"_stop_comp); for ITT: 0x%08x\n",
 			cmd->se_tfo->get_task_tag(cmd));
@@ -4772,7 +4639,7 @@ static void transport_generic_wait_for_tasks(
 		 * struct se_cmd, now owns the structure and can be released through
 		 * normal means below.
 		 */
-		DEBUG_TRANSPORT_S("wait_for_tasks: Stopped"
+		pr_debug("wait_for_tasks: Stopped"
 			" wait_for_completion(&cmd->t_tasktransport_lun_fe_"
 			"stop_comp); for ITT: 0x%08x\n",
 			cmd->se_tfo->get_task_tag(cmd));
@@ -4785,7 +4652,7 @@ static void transport_generic_wait_for_tasks(
 
 	atomic_set(&cmd->t_transport_stop, 1);
 
-	DEBUG_TRANSPORT_S("wait_for_tasks: Stopping %p ITT: 0x%08x"
+	pr_debug("wait_for_tasks: Stopping %p ITT: 0x%08x"
 		" i_state: %d, t_state/def_t_state: %d/%d, t_transport_stop"
 		" = TRUE\n", cmd, cmd->se_tfo->get_task_tag(cmd),
 		cmd->se_tfo->get_cmd_state(cmd), cmd->t_state,
@@ -4801,7 +4668,7 @@ static void transport_generic_wait_for_tasks(
 	atomic_set(&cmd->t_transport_active, 0);
 	atomic_set(&cmd->t_transport_stop, 0);
 
-	DEBUG_TRANSPORT_S("wait_for_tasks: Stopped wait_for_compltion("
+	pr_debug("wait_for_tasks: Stopped wait_for_compltion("
 		"&cmd->t_transport_stop_comp) for ITT: 0x%08x\n",
 		cmd->se_tfo->get_task_tag(cmd));
 remove:
@@ -5013,7 +4880,7 @@ int transport_check_aborted_status(struct se_cmd *cmd, int send_status)
 		     (cmd->se_cmd_flags & SCF_SENT_DELAYED_TAS))
 			return 1;
 #if 0
-		printk(KERN_INFO "Sending delayed SAM_STAT_TASK_ABORTED"
+		pr_debug("Sending delayed SAM_STAT_TASK_ABORTED"
 			" status for CDB: 0x%02x ITT: 0x%08x\n",
 			cmd->t_task_cdb[0],
 			cmd->se_tfo->get_task_tag(cmd));
@@ -5045,7 +4912,7 @@ void transport_send_task_abort(struct se_cmd *cmd)
 	}
 	cmd->scsi_status = SAM_STAT_TASK_ABORTED;
 #if 0
-	printk(KERN_INFO "Setting SAM_STAT_TASK_ABORTED status for CDB: 0x%02x,"
+	pr_debug("Setting SAM_STAT_TASK_ABORTED status for CDB: 0x%02x,"
 		" ITT: 0x%08x\n", cmd->t_task_cdb[0],
 		cmd->se_tfo->get_task_tag(cmd));
 #endif
@@ -5083,7 +4950,7 @@ int transport_generic_do_tmr(struct se_cmd *cmd)
 		tmr->response = TMR_FUNCTION_REJECTED;
 		break;
 	default:
-		printk(KERN_ERR "Uknown TMR function: 0x%02x.\n",
+		pr_err("Uknown TMR function: 0x%02x.\n",
 				tmr->function);
 		tmr->response = TMR_FUNCTION_REJECTED;
 		break;
@@ -5128,7 +4995,7 @@ static void transport_processing_shutdown(struct se_device *dev)
 	spin_lock_irqsave(&dev->execute_task_lock, flags);
 	while ((task = transport_get_task_from_state_list(dev))) {
 		if (!task->task_se_cmd) {
-			printk(KERN_ERR "task->task_se_cmd is NULL!\n");
+			pr_err("task->task_se_cmd is NULL!\n");
 			continue;
 		}
 		cmd = task->task_se_cmd;
@@ -5137,18 +5004,18 @@ static void transport_processing_shutdown(struct se_device *dev)
 
 		spin_lock_irqsave(&cmd->t_state_lock, flags);
 
-		DEBUG_DO("PT: cmd: %p task: %p ITT/CmdSN: 0x%08x/0x%08x,"
-			" i_state/def_i_state: %d/%d, t_state/def_t_state:"
+		pr_debug("PT: cmd: %p task: %p ITT: 0x%08x,"
+			" i_state: %d, t_state/def_t_state:"
 			" %d/%d cdb: 0x%02x\n", cmd, task,
-			cmd->se_tfo->get_task_tag(cmd), cmd->cmd_sn,
-			cmd->se_tfo->get_cmd_state(cmd), cmd->deferred_i_state,
+			cmd->se_tfo->get_task_tag(cmd),
+			cmd->se_tfo->get_cmd_state(cmd),
 			cmd->t_state, cmd->deferred_t_state,
 			cmd->t_task_cdb[0]);
-		DEBUG_DO("PT: ITT[0x%08x] - t_task_cdbs: %d t_task_cdbs_left:"
+		pr_debug("PT: ITT[0x%08x] - t_tasks: %d t_task_cdbs_left:"
 			" %d t_task_cdbs_sent: %d -- t_transport_active: %d"
 			" t_transport_stop: %d t_transport_sent: %d\n",
 			cmd->se_tfo->get_task_tag(cmd),
-			cmd->t_task_cdbs,
+			cmd->t_task_list_num,
 			atomic_read(&cmd->t_task_cdbs_left),
 			atomic_read(&cmd->t_task_cdbs_sent),
 			atomic_read(&cmd->t_transport_active),
@@ -5160,10 +5027,10 @@ static void transport_processing_shutdown(struct se_device *dev)
 			spin_unlock_irqrestore(
 				&cmd->t_state_lock, flags);
 
-			DEBUG_DO("Waiting for task: %p to shutdown for dev:"
+			pr_debug("Waiting for task: %p to shutdown for dev:"
 				" %p\n", task, dev);
 			wait_for_completion(&task->task_stop_comp);
-			DEBUG_DO("Completed task: %p shutdown for dev: %p\n",
+			pr_debug("Completed task: %p shutdown for dev: %p\n",
 				task, dev);
 
 			spin_lock_irqsave(&cmd->t_state_lock, flags);
@@ -5181,7 +5048,7 @@ static void transport_processing_shutdown(struct se_device *dev)
 			spin_unlock_irqrestore(
 					&cmd->t_state_lock, flags);
 
-			DEBUG_DO("Skipping task: %p, dev: %p for"
+			pr_debug("Skipping task: %p, dev: %p for"
 				" t_task_cdbs_ex_left: %d\n", task, dev,
 				atomic_read(&cmd->t_task_cdbs_ex_left));
 
@@ -5190,7 +5057,7 @@ static void transport_processing_shutdown(struct se_device *dev)
 		}
 
 		if (atomic_read(&cmd->t_transport_active)) {
-			DEBUG_DO("got t_transport_active = 1 for task: %p, dev:"
+			pr_debug("got t_transport_active = 1 for task: %p, dev:"
 					" %p\n", task, dev);
 
 			if (atomic_read(&cmd->t_fe_count)) {
@@ -5220,7 +5087,7 @@ static void transport_processing_shutdown(struct se_device *dev)
 			spin_lock_irqsave(&dev->execute_task_lock, flags);
 			continue;
 		}
-		DEBUG_DO("Got t_transport_active = 0 for task: %p, dev: %p\n",
+		pr_debug("Got t_transport_active = 0 for task: %p, dev: %p\n",
 				task, dev);
 
 		if (atomic_read(&cmd->t_fe_count)) {
@@ -5253,7 +5120,7 @@ static void transport_processing_shutdown(struct se_device *dev)
 	 */
 	while ((cmd = transport_get_cmd_from_queue(&dev->dev_queue_obj))) {
 
-		DEBUG_DO("From Device Queue: cmd: %p t_state: %d\n",
+		pr_debug("From Device Queue: cmd: %p t_state: %d\n",
 				cmd, cmd->t_state);
 
 		if (atomic_read(&cmd->t_fe_count)) {
@@ -5307,7 +5174,7 @@ get_cmd:
 		switch (cmd->t_state) {
 		case TRANSPORT_NEW_CMD_MAP:
 			if (!(cmd->se_tfo->new_cmd_map)) {
-				printk(KERN_ERR "cmd->se_tfo->new_cmd_map is"
+				pr_err("cmd->se_tfo->new_cmd_map is"
 					" NULL for TRANSPORT_NEW_CMD_MAP\n");
 				BUG();
 			}
@@ -5358,7 +5225,7 @@ get_cmd:
 			transport_generic_write_pending(cmd);
 			break;
 		default:
-			printk(KERN_ERR "Unknown t_state: %d deferred_t_state:"
+			pr_err("Unknown t_state: %d deferred_t_state:"
 				" %d for ITT: 0x%08x i_state: %d on SE LUN:"
 				" %u\n", cmd->t_state, cmd->deferred_t_state,
 				cmd->se_tfo->get_task_tag(cmd),
diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index d28e9c4..dfa5664 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -102,7 +102,7 @@ int core_scsi3_ua_allocate(
 
 	ua = kmem_cache_zalloc(se_ua_cache, GFP_ATOMIC);
 	if (!(ua)) {
-		printk(KERN_ERR "Unable to allocate struct se_ua\n");
+		pr_err("Unable to allocate struct se_ua\n");
 		return -ENOMEM;
 	}
 	INIT_LIST_HEAD(&ua->ua_dev_list);
@@ -177,7 +177,7 @@ int core_scsi3_ua_allocate(
 	spin_unlock(&deve->ua_lock);
 	spin_unlock_irq(&nacl->device_list_lock);
 
-	printk(KERN_INFO "[%s]: Allocated UNIT ATTENTION, mapped LUN: %u, ASC:"
+	pr_debug("[%s]: Allocated UNIT ATTENTION, mapped LUN: %u, ASC:"
 		" 0x%02x, ASCQ: 0x%02x\n",
 		nacl->se_tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
 		asc, ascq);
@@ -264,7 +264,7 @@ void core_scsi3_ua_for_check_condition(
 	spin_unlock(&deve->ua_lock);
 	spin_unlock_irq(&nacl->device_list_lock);
 
-	printk(KERN_INFO "[%s]: %s UNIT ATTENTION condition with"
+	pr_debug("[%s]: %s UNIT ATTENTION condition with"
 		" INTLCK_CTRL: %d, mapped LUN: %u, got CDB: 0x%02x"
 		" reported ASC: 0x%02x, ASCQ: 0x%02x\n",
 		nacl->se_tpg->se_tpg_tfo->get_fabric_name(),
@@ -323,7 +323,7 @@ int core_scsi3_ua_clear_for_request_sense(
 	spin_unlock(&deve->ua_lock);
 	spin_unlock_irq(&nacl->device_list_lock);
 
-	printk(KERN_INFO "[%s]: Released UNIT ATTENTION condition, mapped"
+	pr_debug("[%s]: Released UNIT ATTENTION condition, mapped"
 		" LUN: %u, got REQUEST_SENSE reported ASC: 0x%02x,"
 		" ASCQ: 0x%02x\n", nacl->se_tpg->se_tpg_tfo->get_fabric_name(),
 		cmd->orig_fe_lun, *asc, *ascq);
-- 
1.7.1

