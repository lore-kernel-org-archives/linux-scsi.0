From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 3/6] target: tcm_loop: Combine substrings for 26 messages
Date: Mon, 11 Dec 2017 11:44:29 +0100
Message-ID: <d1780912-f71c-4527-6dd7-0d4d734446c7@users.sourceforge.net>
References: <42f13f0c-ae1d-ec1e-fd9d-62dd15aeba8c@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <42f13f0c-ae1d-ec1e-fd9d-62dd15aeba8c@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 11 Dec 2017 10:40:23 +0100

The script "checkpatch.pl" pointed information out like the following.

WARNING: quoted string split across lines

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/loopback/tcm_loop.c | 120 ++++++++++++++++---------------------
 1 file changed, 52 insertions(+), 68 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 60e4185e7508..d91109c1c4ae 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -123,8 +123,8 @@ static void tcm_loop_submission_work(struct work_struct *work)
 	}
 	tl_nexus = tl_tpg->tl_nexus;
 	if (!tl_nexus) {
-		scmd_printk(KERN_ERR, sc, "TCM_Loop I_T Nexus"
-				" does not exist\n");
+		scmd_printk(KERN_ERR, sc,
+			    "TCM_Loop I_T Nexus does not exist\n");
 		set_host_byte(sc, DID_ERROR);
 		goto out_done;
 	}
@@ -177,10 +177,10 @@ static int tcm_loop_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
 {
 	struct tcm_loop_cmd *tl_cmd;
 
-	pr_debug("tcm_loop_queuecommand() %d:%d:%d:%llu got CDB: 0x%02x"
-		" scsi_buf_len: %u\n", sc->device->host->host_no,
-		sc->device->id, sc->device->channel, sc->device->lun,
-		sc->cmnd[0], scsi_bufflen(sc));
+	pr_debug("%s() %d:%d:%d:%llu got CDB: 0x%02x scsi_buf_len: %u\n",
+		 __func__, sc->device->host->host_no, sc->device->id,
+		 sc->device->channel, sc->device->lun, sc->cmnd[0],
+		 scsi_bufflen(sc));
 
 	tl_cmd = kmem_cache_zalloc(tcm_loop_cmd_cache, GFP_ATOMIC);
 	if (!tl_cmd) {
@@ -214,8 +214,7 @@ static int tcm_loop_issue_tmr(struct tcm_loop_tpg *tl_tpg,
 	 */
 	tl_nexus = tl_tpg->tl_nexus;
 	if (!tl_nexus) {
-		pr_err("Unable to perform device reset without"
-				" active I_T Nexus\n");
+		pr_err("Unable to perform device reset without active I_T Nexus\n");
 		return ret;
 	}
 
@@ -295,8 +294,7 @@ static int tcm_loop_target_reset(struct scsi_cmnd *sc)
 	 */
 	tl_hba = *(struct tcm_loop_hba **)shost_priv(sc->device->host);
 	if (!tl_hba) {
-		pr_err("Unable to perform device reset without"
-				" active I_T Nexus\n");
+		pr_err("Unable to perform device reset without active I_T Nexus\n");
 		return FAILED;
 	}
 	/*
@@ -414,8 +412,7 @@ static int tcm_loop_setup_hba_bus(struct tcm_loop_hba *tl_hba, int tcm_loop_host
 
 	ret = device_register(&tl_hba->dev);
 	if (ret) {
-		pr_err("device_register() failed for"
-				" tl_hba->dev: %d\n", ret);
+		pr_err("device_register() failed for tl_hba->dev: %d\n", ret);
 		return -ENODEV;
 	}
 
@@ -444,8 +441,7 @@ static int tcm_loop_alloc_core_bus(void)
 
 	ret = driver_register(&tcm_loop_driverfs);
 	if (ret) {
-		pr_err("driver_register() failed for"
-				"tcm_loop_driverfs\n");
+		pr_err("driver_register() failed for tcm_loop_driverfs\n");
 		goto bus_unreg;
 	}
 
@@ -584,8 +580,8 @@ static int tcm_loop_queue_data_in(struct se_cmd *se_cmd)
 				struct tcm_loop_cmd, tl_se_cmd);
 	struct scsi_cmnd *sc = tl_cmd->sc;
 
-	pr_debug("tcm_loop_queue_data_in() called for scsi_cmnd: %p"
-		     " cdb: 0x%02x\n", sc, sc->cmnd[0]);
+	pr_debug("%s() called for scsi_cmnd: %p cdb: 0x%02x\n",
+		 __func__, sc, sc->cmnd[0]);
 
 	sc->result = SAM_STAT_GOOD;
 	set_host_byte(sc, DID_OK);
@@ -602,8 +598,8 @@ static int tcm_loop_queue_status(struct se_cmd *se_cmd)
 				struct tcm_loop_cmd, tl_se_cmd);
 	struct scsi_cmnd *sc = tl_cmd->sc;
 
-	pr_debug("tcm_loop_queue_status() called for scsi_cmnd: %p"
-			" cdb: 0x%02x\n", sc, sc->cmnd[0]);
+	pr_debug("%s() called for scsi_cmnd: %p cdb: 0x%02x\n",
+		 __func__, sc, sc->cmnd[0]);
 
 	if (se_cmd->sense_buffer &&
 	   ((se_cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) ||
@@ -688,8 +684,8 @@ static void tcm_loop_port_unlink(
 	sd = scsi_device_lookup(tl_hba->sh, 0, tl_tpg->tl_tpgt,
 				se_lun->unpacked_lun);
 	if (!sd) {
-		pr_err("Unable to locate struct scsi_device for %d:%d:"
-			"%llu\n", 0, tl_tpg->tl_tpgt, se_lun->unpacked_lun);
+		pr_err("Unable to locate struct scsi_device for %d:%d:%llu\n",
+		       0, tl_tpg->tl_tpgt, se_lun->unpacked_lun);
 		return;
 	}
 	/*
@@ -782,9 +778,8 @@ static int tcm_loop_make_nexus(
 		return ret;
 	}
 
-	pr_debug("TCM_Loop_ConfigFS: Established I_T Nexus to emulated"
-		" %s Initiator Port: %s\n", tcm_loop_dump_proto_id(tl_hba),
-		name);
+	pr_debug("TCM_Loop_ConfigFS: Established I_T Nexus to emulated %s Initiator Port: %s\n",
+		 tcm_loop_dump_proto_id(tl_hba), name);
 	return 0;
 }
 
@@ -803,15 +798,14 @@ static int tcm_loop_drop_nexus(
 		return -ENODEV;
 
 	if (atomic_read(&tpg->tl_tpg_port_count)) {
-		pr_err("Unable to remove TCM_Loop I_T Nexus with"
-			" active TPG port count: %d\n",
-			atomic_read(&tpg->tl_tpg_port_count));
+		pr_err("Unable to remove TCM_Loop I_T Nexus with active TPG port count: %d\n",
+		       atomic_read(&tpg->tl_tpg_port_count));
 		return -EPERM;
 	}
 
-	pr_debug("TCM_Loop_ConfigFS: Removing I_T Nexus to emulated"
-		" %s Initiator Port: %s\n", tcm_loop_dump_proto_id(tpg->tl_hba),
-		tl_nexus->se_sess->se_node_acl->initiatorname);
+	pr_debug("TCM_Loop_ConfigFS: Removing I_T Nexus to emulated %s Initiator Port: %s\n",
+		 tcm_loop_dump_proto_id(tpg->tl_hba),
+		 tl_nexus->se_sess->se_node_acl->initiatorname);
 	/*
 	 * Release the SCSI I_T Nexus to the emulated Target Port
 	 */
@@ -863,8 +857,8 @@ static ssize_t tcm_loop_tpg_nexus_store(struct config_item *item,
 	 * tcm_loop_make_nexus()
 	 */
 	if (strlen(page) >= TL_WWN_ADDR_LEN) {
-		pr_err("Emulated NAA Sas Address: %s, exceeds"
-				" max: %d\n", page, TL_WWN_ADDR_LEN);
+		pr_err("Emulated NAA Sas Address: %s, exceeds max: %d\n",
+		       page, TL_WWN_ADDR_LEN);
 		return -EINVAL;
 	}
 	snprintf(&i_port[0], TL_WWN_ADDR_LEN, "%s", page);
@@ -872,9 +866,8 @@ static ssize_t tcm_loop_tpg_nexus_store(struct config_item *item,
 	ptr = strstr(i_port, "naa.");
 	if (ptr) {
 		if (tl_hba->tl_proto_id != SCSI_PROTOCOL_SAS) {
-			pr_err("Passed SAS Initiator Port %s does not"
-				" match target port protoid: %s\n", i_port,
-				tcm_loop_dump_proto_id(tl_hba));
+			pr_err("Passed SAS Initiator Port %s does not match target port protoid: %s\n",
+			       i_port, tcm_loop_dump_proto_id(tl_hba));
 			return -EINVAL;
 		}
 		port_ptr = &i_port[0];
@@ -883,9 +876,8 @@ static ssize_t tcm_loop_tpg_nexus_store(struct config_item *item,
 	ptr = strstr(i_port, "fc.");
 	if (ptr) {
 		if (tl_hba->tl_proto_id != SCSI_PROTOCOL_FCP) {
-			pr_err("Passed FCP Initiator Port %s does not"
-				" match target port protoid: %s\n", i_port,
-				tcm_loop_dump_proto_id(tl_hba));
+			pr_err("Passed FCP Initiator Port %s does not match target port protoid: %s\n",
+			       i_port, tcm_loop_dump_proto_id(tl_hba));
 			return -EINVAL;
 		}
 		port_ptr = &i_port[3]; /* Skip over "fc." */
@@ -894,16 +886,15 @@ static ssize_t tcm_loop_tpg_nexus_store(struct config_item *item,
 	ptr = strstr(i_port, "iqn.");
 	if (ptr) {
 		if (tl_hba->tl_proto_id != SCSI_PROTOCOL_ISCSI) {
-			pr_err("Passed iSCSI Initiator Port %s does not"
-				" match target port protoid: %s\n", i_port,
-				tcm_loop_dump_proto_id(tl_hba));
+			pr_err("Passed iSCSI Initiator Port %s does not match target port protoid: %s\n",
+			       i_port, tcm_loop_dump_proto_id(tl_hba));
 			return -EINVAL;
 		}
 		port_ptr = &i_port[0];
 		goto check_newline;
 	}
-	pr_err("Unable to locate prefix for emulated Initiator Port:"
-			" %s\n", i_port);
+	pr_err("Unable to locate prefix for emulated Initiator Port: %s\n",
+	       i_port);
 	return -EINVAL;
 	/*
 	 * Clear any trailing newline for the NAA WWN
@@ -1005,16 +996,15 @@ static struct se_portal_group *tcm_loop_make_naa_tpg(
 	unsigned long tpgt;
 
 	if (strstr(name, "tpgt_") != name) {
-		pr_err("Unable to locate \"tpgt_#\" directory"
-				" group\n");
+		pr_err("Unable to locate \"tpgt_#\" directory group\n");
 		return ERR_PTR(-EINVAL);
 	}
 	if (kstrtoul(name+5, 10, &tpgt))
 		return ERR_PTR(-EINVAL);
 
 	if (tpgt >= TL_TPGS_PER_HBA) {
-		pr_err("Passed tpgt: %lu exceeds TL_TPGS_PER_HBA:"
-				" %u\n", tpgt, TL_TPGS_PER_HBA);
+		pr_err("Passed tpgt: %lu exceeds TL_TPGS_PER_HBA: %u\n",
+		       tpgt, TL_TPGS_PER_HBA);
 		return ERR_PTR(-EINVAL);
 	}
 	tl_tpg = &tl_hba->tl_hba_tpgs[tpgt];
@@ -1027,10 +1017,9 @@ static struct se_portal_group *tcm_loop_make_naa_tpg(
 	if (ret < 0)
 		return ERR_PTR(-ENOMEM);
 
-	pr_debug("TCM_Loop_ConfigFS: Allocated Emulated %s"
-		" Target Port %s,t,0x%04lx\n", tcm_loop_dump_proto_id(tl_hba),
-		config_item_name(&wwn->wwn_group.cg_item), tpgt);
-
+	pr_debug("TCM_Loop_ConfigFS: Allocated Emulated %s Target Port %s,t,0x%04lx\n",
+		 tcm_loop_dump_proto_id(tl_hba),
+		 config_item_name(&wwn->wwn_group.cg_item), tpgt);
 	return &tl_tpg->tl_se_tpg;
 }
 
@@ -1057,9 +1046,9 @@ static void tcm_loop_drop_naa_tpg(
 	tl_tpg->tl_hba = NULL;
 	tl_tpg->tl_tpgt = 0;
 
-	pr_debug("TCM_Loop_ConfigFS: Deallocated Emulated %s"
-		" Target Port %s,t,0x%04x\n", tcm_loop_dump_proto_id(tl_hba),
-		config_item_name(&wwn->wwn_group.cg_item), tpgt);
+	pr_debug("TCM_Loop_ConfigFS: Deallocated Emulated %s Target Port %s,t,0x%04x\n",
+		 tcm_loop_dump_proto_id(tl_hba),
+		 config_item_name(&wwn->wwn_group.cg_item), tpgt);
 }
 
 /* End items for tcm_loop_naa_cit */
@@ -1097,8 +1086,8 @@ static struct se_wwn *tcm_loop_make_scsi_hba(
 	}
 	ptr = strstr(name, "iqn.");
 	if (!ptr) {
-		pr_err("Unable to locate prefix for emulated Target "
-				"Port: %s\n", name);
+		pr_err("Unable to locate prefix for emulated Target Port: %s\n",
+		       name);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -1106,9 +1095,8 @@ static struct se_wwn *tcm_loop_make_scsi_hba(
 
 check_len:
 	if (strlen(name) >= TL_WWN_ADDR_LEN) {
-		pr_err("Emulated NAA %s Address: %s, exceeds"
-			" max: %d\n", name, tcm_loop_dump_proto_id(tl_hba),
-			TL_WWN_ADDR_LEN);
+		pr_err("Emulated NAA %s Address: %s, exceeds max: %d\n",
+		       name, tcm_loop_dump_proto_id(tl_hba), TL_WWN_ADDR_LEN);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -1125,10 +1113,8 @@ static struct se_wwn *tcm_loop_make_scsi_hba(
 
 	sh = tl_hba->sh;
 	tcm_loop_hba_no_cnt++;
-	pr_debug("TCM_Loop_ConfigFS: Allocated emulated Target"
-		" %s Address: %s at Linux/SCSI Host ID: %d\n",
-		tcm_loop_dump_proto_id(tl_hba), name, sh->host_no);
-
+	pr_debug("TCM_Loop_ConfigFS: Allocated emulated Target %s Address: %s at Linux/SCSI Host ID: %d\n",
+		 tcm_loop_dump_proto_id(tl_hba), name, sh->host_no);
 	return &tl_hba->tl_hba_wwn;
 out:
 	kfree(tl_hba);
@@ -1141,10 +1127,9 @@ static void tcm_loop_drop_scsi_hba(
 	struct tcm_loop_hba *tl_hba = container_of(wwn,
 				struct tcm_loop_hba, tl_hba_wwn);
 
-	pr_debug("TCM_Loop_ConfigFS: Deallocating emulated Target"
-		" %s Address: %s at Linux/SCSI Host ID: %d\n",
-		tcm_loop_dump_proto_id(tl_hba), tl_hba->tl_wwn_address,
-		tl_hba->sh->host_no);
+	pr_debug("TCM_Loop_ConfigFS: Deallocating emulated Target %s Address: %s at Linux/SCSI Host ID: %d\n",
+		 tcm_loop_dump_proto_id(tl_hba), tl_hba->tl_wwn_address,
+		 tl_hba->sh->host_no);
 	/*
 	 * Call device_unregister() on the original tl_hba->dev.
 	 * tcm_loop_fabric_scsi.c:tcm_loop_release_adapter() will
@@ -1217,8 +1202,7 @@ static int __init tcm_loop_fabric_init(void)
 				__alignof__(struct tcm_loop_cmd),
 				0, NULL);
 	if (!tcm_loop_cmd_cache) {
-		pr_debug("kmem_cache_create() for"
-			" tcm_loop_cmd_cache failed\n");
+		pr_debug("kmem_cache_create() for tcm_loop_cmd_cache failed\n");
 		goto out_destroy_workqueue;
 	}
 
-- 
2.15.1
