From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 093/103] target: Remove custom debug macros in non-iscsi fabrics
Date: Thu, 21 Jul 2011 07:05:25 +0000
Message-ID: <1311231935-24635-94-git-send-email-nab@linux-iscsi.org>
References: <1311231935-24635-90-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:51674 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab1GUH3Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jul 2011 03:29:24 -0400
In-Reply-To: <1311231935-24635-90-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

pr_debug and dynamic debug messages are cool, we don't need specialized
debug infrastructure.

Use pr_err etc. instead of printk(KERN_ERR...).

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/loopback/Kconfig    |    6 --
 drivers/target/loopback/tcm_loop.c |   94 ++++++++++++++++++------------------
 drivers/target/loopback/tcm_loop.h |    6 --
 drivers/target/tcm_fc/tcm_fc.h     |   24 ---------
 drivers/target/tcm_fc/tfc_cmd.c    |   37 +++++++--------
 drivers/target/tcm_fc/tfc_conf.c   |   33 ++++++-------
 drivers/target/tcm_fc/tfc_io.c     |    8 ++--
 drivers/target/tcm_fc/tfc_sess.c   |   18 ++++----
 8 files changed, 92 insertions(+), 134 deletions(-)

diff --git a/drivers/target/loopback/Kconfig b/drivers/target/loopback/Kconfig
index 1bd6a65..c750d44 100644
--- a/drivers/target/loopback/Kconfig
+++ b/drivers/target/loopback/Kconfig
@@ -4,9 +4,3 @@ config LOOPBACK_TARGET
 	help
 	  Say M here to enable the TCM Virtual SAS target and Linux/SCSI LLD
 	  fabric loopback module.
-
-config LOOPBACK_TARGET_CDB_DEBUG
-	bool "TCM loopback fabric module CDB debug code"
-	depends on LOOPBACK_TARGET
-	help
-	  Say Y here to enable the TCM loopback fabric module CDB debug code
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 99603bc..aa2d6799 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -79,7 +79,7 @@ static struct se_cmd *tcm_loop_allocate_core_cmd(
 
 	tl_cmd = kmem_cache_zalloc(tcm_loop_cmd_cache, GFP_ATOMIC);
 	if (!tl_cmd) {
-		printk(KERN_ERR "Unable to allocate struct tcm_loop_cmd\n");
+		pr_err("Unable to allocate struct tcm_loop_cmd\n");
 		set_host_byte(sc, DID_ERROR);
 		return NULL;
 	}
@@ -281,7 +281,7 @@ static int tcm_loop_queuecommand(
 	struct tcm_loop_hba *tl_hba;
 	struct tcm_loop_tpg *tl_tpg;
 
-	TL_CDB_DEBUG("tcm_loop_queuecommand() %d:%d:%d:%d got CDB: 0x%02x"
+	pr_debug("tcm_loop_queuecommand() %d:%d:%d:%d got CDB: 0x%02x"
 		" scsi_buf_len: %u\n", sc->device->host->host_no,
 		sc->device->id, sc->device->channel, sc->device->lun,
 		sc->cmnd[0], scsi_bufflen(sc));
@@ -331,7 +331,7 @@ static int tcm_loop_device_reset(struct scsi_cmnd *sc)
 	 */
 	tl_nexus = tl_hba->tl_nexus;
 	if (!tl_nexus) {
-		printk(KERN_ERR "Unable to perform device reset without"
+		pr_err("Unable to perform device reset without"
 				" active I_T Nexus\n");
 		return FAILED;
 	}
@@ -344,13 +344,13 @@ static int tcm_loop_device_reset(struct scsi_cmnd *sc)
 
 	tl_cmd = kmem_cache_zalloc(tcm_loop_cmd_cache, GFP_KERNEL);
 	if (!tl_cmd) {
-		printk(KERN_ERR "Unable to allocate memory for tl_cmd\n");
+		pr_err("Unable to allocate memory for tl_cmd\n");
 		return FAILED;
 	}
 
 	tl_tmr = kzalloc(sizeof(struct tcm_loop_tmr), GFP_KERNEL);
 	if (!tl_tmr) {
-		printk(KERN_ERR "Unable to allocate memory for tl_tmr\n");
+		pr_err("Unable to allocate memory for tl_tmr\n");
 		goto release;
 	}
 	init_waitqueue_head(&tl_tmr->tl_tmr_wait);
@@ -435,7 +435,7 @@ static int tcm_loop_driver_probe(struct device *dev)
 	sh = scsi_host_alloc(&tcm_loop_driver_template,
 			sizeof(struct tcm_loop_hba));
 	if (!sh) {
-		printk(KERN_ERR "Unable to allocate struct scsi_host\n");
+		pr_err("Unable to allocate struct scsi_host\n");
 		return -ENODEV;
 	}
 	tl_hba->sh = sh;
@@ -454,7 +454,7 @@ static int tcm_loop_driver_probe(struct device *dev)
 
 	error = scsi_add_host(sh, &tl_hba->dev);
 	if (error) {
-		printk(KERN_ERR "%s: scsi_add_host failed\n", __func__);
+		pr_err("%s: scsi_add_host failed\n", __func__);
 		scsi_host_put(sh);
 		return -ENODEV;
 	}
@@ -495,7 +495,7 @@ static int tcm_loop_setup_hba_bus(struct tcm_loop_hba *tl_hba, int tcm_loop_host
 
 	ret = device_register(&tl_hba->dev);
 	if (ret) {
-		printk(KERN_ERR "device_register() failed for"
+		pr_err("device_register() failed for"
 				" tl_hba->dev: %d\n", ret);
 		return -ENODEV;
 	}
@@ -513,24 +513,24 @@ static int tcm_loop_alloc_core_bus(void)
 
 	tcm_loop_primary = root_device_register("tcm_loop_0");
 	if (IS_ERR(tcm_loop_primary)) {
-		printk(KERN_ERR "Unable to allocate tcm_loop_primary\n");
+		pr_err("Unable to allocate tcm_loop_primary\n");
 		return PTR_ERR(tcm_loop_primary);
 	}
 
 	ret = bus_register(&tcm_loop_lld_bus);
 	if (ret) {
-		printk(KERN_ERR "bus_register() failed for tcm_loop_lld_bus\n");
+		pr_err("bus_register() failed for tcm_loop_lld_bus\n");
 		goto dev_unreg;
 	}
 
 	ret = driver_register(&tcm_loop_driverfs);
 	if (ret) {
-		printk(KERN_ERR "driver_register() failed for"
+		pr_err("driver_register() failed for"
 				"tcm_loop_driverfs\n");
 		goto bus_unreg;
 	}
 
-	printk(KERN_INFO "Initialized TCM Loop Core Bus\n");
+	pr_debug("Initialized TCM Loop Core Bus\n");
 	return ret;
 
 bus_unreg:
@@ -546,7 +546,7 @@ static void tcm_loop_release_core_bus(void)
 	bus_unregister(&tcm_loop_lld_bus);
 	root_device_unregister(tcm_loop_primary);
 
-	printk(KERN_INFO "Releasing TCM Loop Core BUS\n");
+	pr_debug("Releasing TCM Loop Core BUS\n");
 }
 
 static char *tcm_loop_get_fabric_name(void)
@@ -574,7 +574,7 @@ static u8 tcm_loop_get_fabric_proto_ident(struct se_portal_group *se_tpg)
 	case SCSI_PROTOCOL_ISCSI:
 		return iscsi_get_fabric_proto_ident(se_tpg);
 	default:
-		printk(KERN_ERR "Unknown tl_proto_id: 0x%02x, using"
+		pr_err("Unknown tl_proto_id: 0x%02x, using"
 			" SAS emulation\n", tl_hba->tl_proto_id);
 		break;
 	}
@@ -630,7 +630,7 @@ static u32 tcm_loop_get_pr_transport_id(
 		return iscsi_get_pr_transport_id(se_tpg, se_nacl, pr_reg,
 					format_code, buf);
 	default:
-		printk(KERN_ERR "Unknown tl_proto_id: 0x%02x, using"
+		pr_err("Unknown tl_proto_id: 0x%02x, using"
 			" SAS emulation\n", tl_hba->tl_proto_id);
 		break;
 	}
@@ -660,7 +660,7 @@ static u32 tcm_loop_get_pr_transport_id_len(
 		return iscsi_get_pr_transport_id_len(se_tpg, se_nacl, pr_reg,
 					format_code);
 	default:
-		printk(KERN_ERR "Unknown tl_proto_id: 0x%02x, using"
+		pr_err("Unknown tl_proto_id: 0x%02x, using"
 			" SAS emulation\n", tl_hba->tl_proto_id);
 		break;
 	}
@@ -694,7 +694,7 @@ static char *tcm_loop_parse_pr_out_transport_id(
 		return iscsi_parse_pr_out_transport_id(se_tpg, buf, out_tid_len,
 					port_nexus_ptr);
 	default:
-		printk(KERN_ERR "Unknown tl_proto_id: 0x%02x, using"
+		pr_err("Unknown tl_proto_id: 0x%02x, using"
 			" SAS emulation\n", tl_hba->tl_proto_id);
 		break;
 	}
@@ -743,7 +743,7 @@ static struct se_node_acl *tcm_loop_tpg_alloc_fabric_acl(
 
 	tl_nacl = kzalloc(sizeof(struct tcm_loop_nacl), GFP_KERNEL);
 	if (!tl_nacl) {
-		printk(KERN_ERR "Unable to allocate struct tcm_loop_nacl\n");
+		pr_err("Unable to allocate struct tcm_loop_nacl\n");
 		return NULL;
 	}
 
@@ -853,7 +853,7 @@ static int tcm_loop_queue_data_in(struct se_cmd *se_cmd)
 				struct tcm_loop_cmd, tl_se_cmd);
 	struct scsi_cmnd *sc = tl_cmd->sc;
 
-	TL_CDB_DEBUG("tcm_loop_queue_data_in() called for scsi_cmnd: %p"
+	pr_debug("tcm_loop_queue_data_in() called for scsi_cmnd: %p"
 		     " cdb: 0x%02x\n", sc, sc->cmnd[0]);
 
 	sc->result = SAM_STAT_GOOD;
@@ -868,7 +868,7 @@ static int tcm_loop_queue_status(struct se_cmd *se_cmd)
 				struct tcm_loop_cmd, tl_se_cmd);
 	struct scsi_cmnd *sc = tl_cmd->sc;
 
-	TL_CDB_DEBUG("tcm_loop_queue_status() called for scsi_cmnd: %p"
+	pr_debug("tcm_loop_queue_status() called for scsi_cmnd: %p"
 			" cdb: 0x%02x\n", sc, sc->cmnd[0]);
 
 	if (se_cmd->sense_buffer &&
@@ -943,7 +943,7 @@ static int tcm_loop_port_link(
 	 */
 	scsi_add_device(tl_hba->sh, 0, tl_tpg->tl_tpgt, lun->unpacked_lun);
 
-	printk(KERN_INFO "TCM_Loop_ConfigFS: Port Link Successful\n");
+	pr_debug("TCM_Loop_ConfigFS: Port Link Successful\n");
 	return 0;
 }
 
@@ -961,7 +961,7 @@ static void tcm_loop_port_unlink(
 	sd = scsi_device_lookup(tl_hba->sh, 0, tl_tpg->tl_tpgt,
 				se_lun->unpacked_lun);
 	if (!sd) {
-		printk(KERN_ERR "Unable to locate struct scsi_device for %d:%d:"
+		pr_err("Unable to locate struct scsi_device for %d:%d:"
 			"%d\n", 0, tl_tpg->tl_tpgt, se_lun->unpacked_lun);
 		return;
 	}
@@ -974,7 +974,7 @@ static void tcm_loop_port_unlink(
 	atomic_dec(&tl_tpg->tl_tpg_port_count);
 	smp_mb__after_atomic_dec();
 
-	printk(KERN_INFO "TCM_Loop_ConfigFS: Port Unlink Successful\n");
+	pr_debug("TCM_Loop_ConfigFS: Port Unlink Successful\n");
 }
 
 /* End items for tcm_loop_port_cit */
@@ -991,14 +991,14 @@ static int tcm_loop_make_nexus(
 	int ret = -ENOMEM;
 
 	if (tl_tpg->tl_hba->tl_nexus) {
-		printk(KERN_INFO "tl_tpg->tl_hba->tl_nexus already exists\n");
+		pr_debug("tl_tpg->tl_hba->tl_nexus already exists\n");
 		return -EEXIST;
 	}
 	se_tpg = &tl_tpg->tl_se_tpg;
 
 	tl_nexus = kzalloc(sizeof(struct tcm_loop_nexus), GFP_KERNEL);
 	if (!tl_nexus) {
-		printk(KERN_ERR "Unable to allocate struct tcm_loop_nexus\n");
+		pr_err("Unable to allocate struct tcm_loop_nexus\n");
 		return -ENOMEM;
 	}
 	/*
@@ -1027,7 +1027,7 @@ static int tcm_loop_make_nexus(
 	__transport_register_session(se_tpg, tl_nexus->se_sess->se_node_acl,
 			tl_nexus->se_sess, tl_nexus);
 	tl_tpg->tl_hba->tl_nexus = tl_nexus;
-	printk(KERN_INFO "TCM_Loop_ConfigFS: Established I_T Nexus to emulated"
+	pr_debug("TCM_Loop_ConfigFS: Established I_T Nexus to emulated"
 		" %s Initiator Port: %s\n", tcm_loop_dump_proto_id(tl_hba),
 		name);
 	return 0;
@@ -1053,13 +1053,13 @@ static int tcm_loop_drop_nexus(
 		return -ENODEV;
 
 	if (atomic_read(&tpg->tl_tpg_port_count)) {
-		printk(KERN_ERR "Unable to remove TCM_Loop I_T Nexus with"
+		pr_err("Unable to remove TCM_Loop I_T Nexus with"
 			" active TPG port count: %d\n",
 			atomic_read(&tpg->tl_tpg_port_count));
 		return -EPERM;
 	}
 
-	printk(KERN_INFO "TCM_Loop_ConfigFS: Removing I_T Nexus to emulated"
+	pr_debug("TCM_Loop_ConfigFS: Removing I_T Nexus to emulated"
 		" %s Initiator Port: %s\n", tcm_loop_dump_proto_id(tl_hba),
 		tl_nexus->se_sess->se_node_acl->initiatorname);
 	/*
@@ -1115,7 +1115,7 @@ static ssize_t tcm_loop_tpg_store_nexus(
 	 * tcm_loop_make_nexus()
 	 */
 	if (strlen(page) >= TL_WWN_ADDR_LEN) {
-		printk(KERN_ERR "Emulated NAA Sas Address: %s, exceeds"
+		pr_err("Emulated NAA Sas Address: %s, exceeds"
 				" max: %d\n", page, TL_WWN_ADDR_LEN);
 		return -EINVAL;
 	}
@@ -1124,7 +1124,7 @@ static ssize_t tcm_loop_tpg_store_nexus(
 	ptr = strstr(i_port, "naa.");
 	if (ptr) {
 		if (tl_hba->tl_proto_id != SCSI_PROTOCOL_SAS) {
-			printk(KERN_ERR "Passed SAS Initiator Port %s does not"
+			pr_err("Passed SAS Initiator Port %s does not"
 				" match target port protoid: %s\n", i_port,
 				tcm_loop_dump_proto_id(tl_hba));
 			return -EINVAL;
@@ -1135,7 +1135,7 @@ static ssize_t tcm_loop_tpg_store_nexus(
 	ptr = strstr(i_port, "fc.");
 	if (ptr) {
 		if (tl_hba->tl_proto_id != SCSI_PROTOCOL_FCP) {
-			printk(KERN_ERR "Passed FCP Initiator Port %s does not"
+			pr_err("Passed FCP Initiator Port %s does not"
 				" match target port protoid: %s\n", i_port,
 				tcm_loop_dump_proto_id(tl_hba));
 			return -EINVAL;
@@ -1146,7 +1146,7 @@ static ssize_t tcm_loop_tpg_store_nexus(
 	ptr = strstr(i_port, "iqn.");
 	if (ptr) {
 		if (tl_hba->tl_proto_id != SCSI_PROTOCOL_ISCSI) {
-			printk(KERN_ERR "Passed iSCSI Initiator Port %s does not"
+			pr_err("Passed iSCSI Initiator Port %s does not"
 				" match target port protoid: %s\n", i_port,
 				tcm_loop_dump_proto_id(tl_hba));
 			return -EINVAL;
@@ -1154,7 +1154,7 @@ static ssize_t tcm_loop_tpg_store_nexus(
 		port_ptr = &i_port[0];
 		goto check_newline;
 	}
-	printk(KERN_ERR "Unable to locate prefix for emulated Initiator Port:"
+	pr_err("Unable to locate prefix for emulated Initiator Port:"
 			" %s\n", i_port);
 	return -EINVAL;
 	/*
@@ -1194,7 +1194,7 @@ struct se_portal_group *tcm_loop_make_naa_tpg(
 
 	tpgt_str = strstr(name, "tpgt_");
 	if (!tpgt_str) {
-		printk(KERN_ERR "Unable to locate \"tpgt_#\" directory"
+		pr_err("Unable to locate \"tpgt_#\" directory"
 				" group\n");
 		return ERR_PTR(-EINVAL);
 	}
@@ -1202,7 +1202,7 @@ struct se_portal_group *tcm_loop_make_naa_tpg(
 	tpgt = (unsigned short int) simple_strtoul(tpgt_str, &end_ptr, 0);
 
 	if (tpgt >= TL_TPGS_PER_HBA) {
-		printk(KERN_ERR "Passed tpgt: %hu exceeds TL_TPGS_PER_HBA:"
+		pr_err("Passed tpgt: %hu exceeds TL_TPGS_PER_HBA:"
 				" %u\n", tpgt, TL_TPGS_PER_HBA);
 		return ERR_PTR(-EINVAL);
 	}
@@ -1218,7 +1218,7 @@ struct se_portal_group *tcm_loop_make_naa_tpg(
 	if (ret < 0)
 		return ERR_PTR(-ENOMEM);
 
-	printk(KERN_INFO "TCM_Loop_ConfigFS: Allocated Emulated %s"
+	pr_debug("TCM_Loop_ConfigFS: Allocated Emulated %s"
 		" Target Port %s,t,0x%04x\n", tcm_loop_dump_proto_id(tl_hba),
 		config_item_name(&wwn->wwn_group.cg_item), tpgt);
 
@@ -1245,7 +1245,7 @@ void tcm_loop_drop_naa_tpg(
 	 */
 	core_tpg_deregister(se_tpg);
 
-	printk(KERN_INFO "TCM_Loop_ConfigFS: Deallocated Emulated %s"
+	pr_debug("TCM_Loop_ConfigFS: Deallocated Emulated %s"
 		" Target Port %s,t,0x%04x\n", tcm_loop_dump_proto_id(tl_hba),
 		config_item_name(&wwn->wwn_group.cg_item), tpgt);
 }
@@ -1266,7 +1266,7 @@ struct se_wwn *tcm_loop_make_scsi_hba(
 
 	tl_hba = kzalloc(sizeof(struct tcm_loop_hba), GFP_KERNEL);
 	if (!tl_hba) {
-		printk(KERN_ERR "Unable to allocate struct tcm_loop_hba\n");
+		pr_err("Unable to allocate struct tcm_loop_hba\n");
 		return ERR_PTR(-ENOMEM);
 	}
 	/*
@@ -1286,7 +1286,7 @@ struct se_wwn *tcm_loop_make_scsi_hba(
 	}
 	ptr = strstr(name, "iqn.");
 	if (!ptr) {
-		printk(KERN_ERR "Unable to locate prefix for emulated Target "
+		pr_err("Unable to locate prefix for emulated Target "
 				"Port: %s\n", name);
 		ret = -EINVAL;
 		goto out;
@@ -1295,7 +1295,7 @@ struct se_wwn *tcm_loop_make_scsi_hba(
 
 check_len:
 	if (strlen(name) >= TL_WWN_ADDR_LEN) {
-		printk(KERN_ERR "Emulated NAA %s Address: %s, exceeds"
+		pr_err("Emulated NAA %s Address: %s, exceeds"
 			" max: %d\n", name, tcm_loop_dump_proto_id(tl_hba),
 			TL_WWN_ADDR_LEN);
 		ret = -EINVAL;
@@ -1314,7 +1314,7 @@ check_len:
 
 	sh = tl_hba->sh;
 	tcm_loop_hba_no_cnt++;
-	printk(KERN_INFO "TCM_Loop_ConfigFS: Allocated emulated Target"
+	pr_debug("TCM_Loop_ConfigFS: Allocated emulated Target"
 		" %s Address: %s at Linux/SCSI Host ID: %d\n",
 		tcm_loop_dump_proto_id(tl_hba), name, sh->host_no);
 
@@ -1337,7 +1337,7 @@ void tcm_loop_drop_scsi_hba(
 	 */
 	device_unregister(&tl_hba->dev);
 
-	printk(KERN_INFO "TCM_Loop_ConfigFS: Deallocated emulated Target"
+	pr_debug("TCM_Loop_ConfigFS: Deallocated emulated Target"
 		" SAS Address: %s at Linux/SCSI Host ID: %d\n",
 		config_item_name(&wwn->wwn_group.cg_item), host_no);
 }
@@ -1373,7 +1373,7 @@ static int tcm_loop_register_configfs(void)
 	 */
 	fabric = target_fabric_configfs_init(THIS_MODULE, "loopback");
 	if (IS_ERR(fabric)) {
-		printk(KERN_ERR "tcm_loop_register_configfs() failed!\n");
+		pr_err("tcm_loop_register_configfs() failed!\n");
 		return PTR_ERR(fabric);
 	}
 	/*
@@ -1464,7 +1464,7 @@ static int tcm_loop_register_configfs(void)
 	 */
 	ret = target_fabric_configfs_register(fabric);
 	if (ret < 0) {
-		printk(KERN_ERR "target_fabric_configfs_register() for"
+		pr_err("target_fabric_configfs_register() for"
 				" TCM_Loop failed!\n");
 		target_fabric_configfs_free(fabric);
 		return -1;
@@ -1473,7 +1473,7 @@ static int tcm_loop_register_configfs(void)
 	 * Setup our local pointer to *fabric.
 	 */
 	tcm_loop_fabric_configfs = fabric;
-	printk(KERN_INFO "TCM_LOOP[0] - Set fabric ->"
+	pr_debug("TCM_LOOP[0] - Set fabric ->"
 			" tcm_loop_fabric_configfs\n");
 	return 0;
 }
@@ -1485,7 +1485,7 @@ static void tcm_loop_deregister_configfs(void)
 
 	target_fabric_configfs_deregister(tcm_loop_fabric_configfs);
 	tcm_loop_fabric_configfs = NULL;
-	printk(KERN_INFO "TCM_LOOP[0] - Cleared"
+	pr_debug("TCM_LOOP[0] - Cleared"
 				" tcm_loop_fabric_configfs\n");
 }
 
@@ -1498,7 +1498,7 @@ static int __init tcm_loop_fabric_init(void)
 				__alignof__(struct tcm_loop_cmd),
 				0, NULL);
 	if (!tcm_loop_cmd_cache) {
-		printk(KERN_ERR "kmem_cache_create() for"
+		pr_debug("kmem_cache_create() for"
 			" tcm_loop_cmd_cache failed\n");
 		return -ENOMEM;
 	}
diff --git a/drivers/target/loopback/tcm_loop.h b/drivers/target/loopback/tcm_loop.h
index 7e9f7ab..6b76c7a 100644
--- a/drivers/target/loopback/tcm_loop.h
+++ b/drivers/target/loopback/tcm_loop.h
@@ -16,12 +16,6 @@
  */
 #define TL_SCSI_MAX_CMD_LEN		32
 
-#ifdef CONFIG_LOOPBACK_TARGET_CDB_DEBUG
-# define TL_CDB_DEBUG(x...)		printk(KERN_INFO x)
-#else
-# define TL_CDB_DEBUG(x...)
-#endif
-
 struct tcm_loop_cmd {
 	/* State of Linux/SCSI CDB+Data descriptor */
 	u32 sc_cmd_state;
diff --git a/drivers/target/tcm_fc/tcm_fc.h b/drivers/target/tcm_fc/tcm_fc.h
index 8d26779..f7fff7e 100644
--- a/drivers/target/tcm_fc/tcm_fc.h
+++ b/drivers/target/tcm_fc/tcm_fc.h
@@ -23,30 +23,6 @@
 #define FT_TPG_NAMELEN 32	/* max length of TPG name */
 #define FT_LUN_NAMELEN 32	/* max length of LUN name */
 
-/*
- * Debug options.
- */
-#define FT_DEBUG_CONF	0x01	/* configuration messages */
-#define	FT_DEBUG_SESS	0x02	/* session messages */
-#define	FT_DEBUG_TM	0x04	/* TM operations */
-#define	FT_DEBUG_IO	0x08	/* I/O commands */
-#define	FT_DEBUG_DATA	0x10	/* Data transfer */
-
-extern unsigned int ft_debug_logging;	/* debug options */
-
-#define FT_DEBUG(mask, fmt, args...)					\
-	do {								\
-		if (ft_debug_logging & (mask))				\
-			printk(KERN_INFO "tcm_fc: %s: " fmt,		\
-				__func__, ##args);			\
-	} while (0)
-
-#define	FT_CONF_DBG(fmt, args...)	FT_DEBUG(FT_DEBUG_CONF, fmt, ##args)
-#define	FT_SESS_DBG(fmt, args...)	FT_DEBUG(FT_DEBUG_SESS, fmt, ##args)
-#define	FT_TM_DBG(fmt, args...)		FT_DEBUG(FT_DEBUG_TM, fmt, ##args)
-#define	FT_IO_DBG(fmt, args...)		FT_DEBUG(FT_DEBUG_IO, fmt, ##args)
-#define	FT_DATA_DBG(fmt, args...)	FT_DEBUG(FT_DEBUG_DATA, fmt, ##args)
-
 struct ft_transport_id {
 	__u8	format;
 	__u8	__resvd1[7];
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 9365e539..a9e9a31 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -62,22 +62,19 @@ void ft_dump_cmd(struct ft_cmd *cmd, const char *caller)
 	struct scatterlist *sg;
 	int count;
 
-	if (!(ft_debug_logging & FT_DEBUG_IO))
-		return;
-
 	se_cmd = &cmd->se_cmd;
-	printk(KERN_INFO "%s: cmd %p state %d sess %p seq %p se_cmd %p\n",
+	pr_debug("%s: cmd %p state %d sess %p seq %p se_cmd %p\n",
 		caller, cmd, cmd->state, cmd->sess, cmd->seq, se_cmd);
-	printk(KERN_INFO "%s: cmd %p cdb %p\n",
+	pr_debug("%s: cmd %p cdb %p\n",
 		caller, cmd, cmd->cdb);
-	printk(KERN_INFO "%s: cmd %p lun %d\n", caller, cmd, cmd->lun);
+	pr_debug("%s: cmd %p lun %d\n", caller, cmd, cmd->lun);
 
-	printk(KERN_INFO "%s: cmd %p data_nents %u len %u se_cmd_flags <0x%x>\n",
+	pr_debug("%s: cmd %p data_nents %u len %u se_cmd_flags <0x%x>\n",
 		caller, cmd, se_cmd->t_data_nents,
 	       se_cmd->data_length, se_cmd->se_cmd_flags);
 
 	for_each_sg(se_cmd->t_data_sg, sg, se_cmd->t_data_nents, count)
-		printk(KERN_INFO "%s: cmd %p sg %p page %p "
+		pr_debug("%s: cmd %p sg %p page %p "
 			"len 0x%x off 0x%x\n",
 			caller, cmd, sg,
 			sg_page(sg), sg->length, sg->offset);
@@ -85,7 +82,7 @@ void ft_dump_cmd(struct ft_cmd *cmd, const char *caller)
 	sp = cmd->seq;
 	if (sp) {
 		ep = fc_seq_exch(sp);
-		printk(KERN_INFO "%s: cmd %p sid %x did %x "
+		pr_debug("%s: cmd %p sid %x did %x "
 			"ox_id %x rx_id %x seq_id %x e_stat %x\n",
 			caller, cmd, ep->sid, ep->did, ep->oxid, ep->rxid,
 			sp->id, ep->esb_stat);
@@ -321,7 +318,7 @@ static void ft_recv_seq(struct fc_seq *sp, struct fc_frame *fp, void *arg)
 	case FC_RCTL_DD_SOL_CTL:	/* transfer ready */
 	case FC_RCTL_DD_DATA_DESC:	/* transfer ready */
 	default:
-		printk(KERN_INFO "%s: unhandled frame r_ctl %x\n",
+		pr_debug("%s: unhandled frame r_ctl %x\n",
 		       __func__, fh->fh_r_ctl);
 		fc_frame_free(fp);
 		transport_generic_free_cmd(&cmd->se_cmd, 0, 0);
@@ -346,7 +343,7 @@ static void ft_send_resp_status(struct fc_lport *lport,
 	struct fcp_resp_rsp_info *info;
 
 	fh = fc_frame_header_get(rx_fp);
-	FT_IO_DBG("FCP error response: did %x oxid %x status %x code %x\n",
+	pr_debug("FCP error response: did %x oxid %x status %x code %x\n",
 		  ntoh24(fh->fh_s_id), ntohs(fh->fh_ox_id), status, code);
 	len = sizeof(*fcp);
 	if (status == SAM_STAT_GOOD)
@@ -416,15 +413,15 @@ static void ft_send_tm(struct ft_cmd *cmd)
 		 * FCP4r01 indicates having a combination of
 		 * tm_flags set is invalid.
 		 */
-		FT_TM_DBG("invalid FCP tm_flags %x\n", fcp->fc_tm_flags);
+		pr_debug("invalid FCP tm_flags %x\n", fcp->fc_tm_flags);
 		ft_send_resp_code(cmd, FCP_CMND_FIELDS_INVALID);
 		return;
 	}
 
-	FT_TM_DBG("alloc tm cmd fn %d\n", tm_func);
+	pr_debug("alloc tm cmd fn %d\n", tm_func);
 	tmr = core_tmr_alloc_req(&cmd->se_cmd, cmd, tm_func);
 	if (!tmr) {
-		FT_TM_DBG("alloc failed\n");
+		pr_debug("alloc failed\n");
 		ft_send_resp_code(cmd, FCP_TMF_FAILED);
 		return;
 	}
@@ -439,7 +436,7 @@ static void ft_send_tm(struct ft_cmd *cmd)
 			 * since "unable to  handle TMR request because failed
 			 * to get to LUN"
 			 */
-			FT_TM_DBG("Failed to get LUN for TMR func %d, "
+			pr_debug("Failed to get LUN for TMR func %d, "
 				  "se_cmd %p, unpacked_lun %d\n",
 				  tm_func, &cmd->se_cmd, cmd->lun);
 			ft_dump_cmd(cmd, __func__);
@@ -490,7 +487,7 @@ int ft_queue_tm_resp(struct se_cmd *se_cmd)
 		code = FCP_TMF_FAILED;
 		break;
 	}
-	FT_TM_DBG("tmr fn %d resp %d fcp code %d\n",
+	pr_debug("tmr fn %d resp %d fcp code %d\n",
 		  tmr->function, tmr->response, code);
 	ft_send_resp_code(cmd, code);
 	return 0;
@@ -518,7 +515,7 @@ static void ft_recv_cmd(struct ft_sess *sess, struct fc_frame *fp)
 	return;
 
 busy:
-	FT_IO_DBG("cmd or seq allocation failure - sending BUSY\n");
+	pr_debug("cmd or seq allocation failure - sending BUSY\n");
 	ft_send_resp_status(lport, fp, SAM_STAT_BUSY, 0);
 	fc_frame_free(fp);
 	ft_sess_put(sess);		/* undo get from lookup */
@@ -543,7 +540,7 @@ void ft_recv_req(struct ft_sess *sess, struct fc_frame *fp)
 	case FC_RCTL_DD_DATA_DESC:	/* transfer ready */
 	case FC_RCTL_ELS4_REQ:		/* SRR, perhaps */
 	default:
-		printk(KERN_INFO "%s: unhandled frame r_ctl %x\n",
+		pr_debug("%s: unhandled frame r_ctl %x\n",
 		       __func__, fh->fh_r_ctl);
 		fc_frame_free(fp);
 		ft_sess_put(sess);	/* undo get from lookup */
@@ -642,7 +639,7 @@ static void ft_send_cmd(struct ft_cmd *cmd)
 
 	ret = transport_generic_allocate_tasks(se_cmd, cmd->cdb);
 
-	FT_IO_DBG("r_ctl %x alloc task ret %d\n", fh->fh_r_ctl, ret);
+	pr_debug("r_ctl %x alloc task ret %d\n", fh->fh_r_ctl, ret);
 	ft_dump_cmd(cmd, __func__);
 
 	if (ret == -ENOMEM) {
@@ -672,7 +669,7 @@ err:
  */
 static void ft_exec_req(struct ft_cmd *cmd)
 {
-	FT_IO_DBG("cmd state %x\n", cmd->state);
+	pr_debug("cmd state %x\n", cmd->state);
 	switch (cmd->state) {
 	case FC_CMD_ST_NEW:
 		ft_send_cmd(cmd);
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index ec9e40d..d63e3dd 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -106,7 +106,7 @@ static ssize_t ft_parse_wwn(const char *name, u64 *wwn, int strict)
 	}
 	err = 4;
 fail:
-	FT_CONF_DBG("err %u len %zu pos %u byte %u\n",
+	pr_debug("err %u len %zu pos %u byte %u\n",
 		    err, cp - name, pos, byte);
 	return -1;
 }
@@ -216,7 +216,7 @@ static struct se_node_acl *ft_add_acl(
 	u64 wwpn;
 	u32 q_depth;
 
-	FT_CONF_DBG("add acl %s\n", name);
+	pr_debug("add acl %s\n", name);
 	tpg = container_of(se_tpg, struct ft_tpg, se_tpg);
 
 	if (ft_parse_wwn(name, &wwpn, 1) < 0)
@@ -239,11 +239,11 @@ static void ft_del_acl(struct se_node_acl *se_acl)
 	struct ft_node_acl *acl = container_of(se_acl,
 				struct ft_node_acl, se_node_acl);
 
-	FT_CONF_DBG("del acl %s\n",
+	pr_debug("del acl %s\n",
 		config_item_name(&se_acl->acl_group.cg_item));
 
 	tpg = container_of(se_tpg, struct ft_tpg, se_tpg);
-	FT_CONF_DBG("del acl %p se_acl %p tpg %p se_tpg %p\n",
+	pr_debug("del acl %p se_acl %p tpg %p se_tpg %p\n",
 		    acl, se_acl, tpg, &tpg->se_tpg);
 
 	core_tpg_del_initiator_node_acl(&tpg->se_tpg, se_acl, 1);
@@ -260,11 +260,11 @@ struct ft_node_acl *ft_acl_get(struct ft_tpg *tpg, struct fc_rport_priv *rdata)
 	spin_lock_bh(&se_tpg->acl_node_lock);
 	list_for_each_entry(se_acl, &se_tpg->acl_node_list, acl_list) {
 		acl = container_of(se_acl, struct ft_node_acl, se_node_acl);
-		FT_CONF_DBG("acl %p port_name %llx\n",
+		pr_debug("acl %p port_name %llx\n",
 			acl, (unsigned long long)acl->node_auth.port_name);
 		if (acl->node_auth.port_name == rdata->ids.port_name ||
 		    acl->node_auth.node_name == rdata->ids.node_name) {
-			FT_CONF_DBG("acl %p port_name %llx matched\n", acl,
+			pr_debug("acl %p port_name %llx matched\n", acl,
 				    (unsigned long long)rdata->ids.port_name);
 			found = acl;
 			/* XXX need to hold onto ACL */
@@ -281,10 +281,10 @@ struct se_node_acl *ft_tpg_alloc_fabric_acl(struct se_portal_group *se_tpg)
 
 	acl = kzalloc(sizeof(*acl), GFP_KERNEL);
 	if (!acl) {
-		printk(KERN_ERR "Unable to allocate struct ft_node_acl\n");
+		pr_err("Unable to allocate struct ft_node_acl\n");
 		return NULL;
 	}
-	FT_CONF_DBG("acl %p\n", acl);
+	pr_debug("acl %p\n", acl);
 	return &acl->se_node_acl;
 }
 
@@ -294,7 +294,7 @@ static void ft_tpg_release_fabric_acl(struct se_portal_group *se_tpg,
 	struct ft_node_acl *acl = container_of(se_acl,
 				struct ft_node_acl, se_node_acl);
 
-	FT_CONF_DBG(KERN_INFO "acl %p\n", acl);
+	pr_debug("acl %p\n", acl);
 	kfree(acl);
 }
 
@@ -311,7 +311,7 @@ static struct se_portal_group *ft_add_tpg(
 	unsigned long index;
 	int ret;
 
-	FT_CONF_DBG("tcm_fc: add tpg %s\n", name);
+	pr_debug("tcm_fc: add tpg %s\n", name);
 
 	/*
 	 * Name must be "tpgt_" followed by the index.
@@ -354,7 +354,7 @@ static void ft_del_tpg(struct se_portal_group *se_tpg)
 {
 	struct ft_tpg *tpg = container_of(se_tpg, struct ft_tpg, se_tpg);
 
-	FT_CONF_DBG("del tpg %s\n",
+	pr_debug("del tpg %s\n",
 		    config_item_name(&tpg->se_tpg.tpg_group.cg_item));
 
 	kthread_stop(tpg->thread);
@@ -412,7 +412,7 @@ static struct se_wwn *ft_add_lport(
 	struct ft_lport_acl *old_lacl;
 	u64 wwpn;
 
-	FT_CONF_DBG("add lport %s\n", name);
+	pr_debug("add lport %s\n", name);
 	if (ft_parse_wwn(name, &wwpn, 1) < 0)
 		return NULL;
 	lacl = kzalloc(sizeof(*lacl), GFP_KERNEL);
@@ -441,7 +441,7 @@ static void ft_del_lport(struct se_wwn *wwn)
 	struct ft_lport_acl *lacl = container_of(wwn,
 				struct ft_lport_acl, fc_lport_wwn);
 
-	FT_CONF_DBG("del lport %s\n",
+	pr_debug("del lport %s\n",
 			config_item_name(&wwn->wwn_group.cg_item));
 	mutex_lock(&ft_lport_lock);
 	list_del(&lacl->list);
@@ -581,7 +581,7 @@ int ft_register_configfs(void)
 	 */
 	fabric = target_fabric_configfs_init(THIS_MODULE, "fc");
 	if (IS_ERR(fabric)) {
-		printk(KERN_INFO "%s: target_fabric_configfs_init() failed!\n",
+		pr_err("%s: target_fabric_configfs_init() failed!\n",
 		       __func__);
 		return PTR_ERR(fabric);
 	}
@@ -608,11 +608,8 @@ int ft_register_configfs(void)
 	 */
 	ret = target_fabric_configfs_register(fabric);
 	if (ret < 0) {
-		FT_CONF_DBG("target_fabric_configfs_register() for"
+		pr_debug("target_fabric_configfs_register() for"
 			    " FC Target failed!\n");
-		printk(KERN_INFO
-		       "%s: target_fabric_configfs_register() failed!\n",
-		       __func__);
 		target_fabric_configfs_free(fabric);
 		return -1;
 	}
diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index 3563a90..11e6483 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -39,6 +39,7 @@
 #include <linux/configfs.h>
 #include <linux/ctype.h>
 #include <linux/hash.h>
+#include <linux/ratelimit.h>
 #include <asm/unaligned.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
@@ -176,8 +177,7 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
 		error = lport->tt.seq_send(lport, cmd->seq, fp);
 		if (error) {
 			/* XXX For now, initiator will retry */
-			if (printk_ratelimit())
-				printk(KERN_ERR "%s: Failed to send frame %p, "
+			pr_err_ratelimited("%s: Failed to send frame %p, "
 						"xid <0x%x>, remaining %zu, "
 						"lso_max <0x%x>\n",
 						__func__, fp, ep->xid,
@@ -222,7 +222,7 @@ void ft_recv_write_data(struct ft_cmd *cmd, struct fc_frame *fp)
 	 */
 	buf = fc_frame_payload_get(fp, 1);
 	if (cmd->was_ddp_setup && buf) {
-		printk(KERN_INFO "%s: When DDP was setup, not expected to"
+		pr_debug("%s: When DDP was setup, not expected to"
 				 "receive frame with payload, Payload shall be"
 				 "copied directly to buffer instead of coming "
 				 "via. legacy receive queues\n", __func__);
@@ -260,7 +260,7 @@ void ft_recv_write_data(struct ft_cmd *cmd, struct fc_frame *fp)
 			 * this point, but just in case if required in future
 			 * for debugging or any other purpose
 			 */
-			printk(KERN_ERR "%s: Received frame with TSI bit not"
+			pr_err("%s: Received frame with TSI bit not"
 					" being SET, dropping the frame, "
 					"cmd->sg <%p>, cmd->sg_cnt <0x%x>\n",
 					__func__, cmd->sg, cmd->sg_cnt);
diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 7491e21..fbcbb3d 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -198,13 +198,13 @@ static struct ft_sess *ft_sess_get(struct fc_lport *lport, u32 port_id)
 		if (sess->port_id == port_id) {
 			kref_get(&sess->kref);
 			rcu_read_unlock();
-			FT_SESS_DBG("port_id %x found %p\n", port_id, sess);
+			pr_debug("port_id %x found %p\n", port_id, sess);
 			return sess;
 		}
 	}
 out:
 	rcu_read_unlock();
-	FT_SESS_DBG("port_id %x not found\n", port_id);
+	pr_debug("port_id %x not found\n", port_id);
 	return NULL;
 }
 
@@ -240,7 +240,7 @@ static struct ft_sess *ft_sess_create(struct ft_tport *tport, u32 port_id,
 	hlist_add_head_rcu(&sess->hash, head);
 	tport->sess_count++;
 
-	FT_SESS_DBG("port_id %x sess %p\n", port_id, sess);
+	pr_debug("port_id %x sess %p\n", port_id, sess);
 
 	transport_register_session(&tport->tpg->se_tpg, &acl->se_node_acl,
 				   sess->se_sess, sess);
@@ -314,7 +314,7 @@ int ft_sess_shutdown(struct se_session *se_sess)
 {
 	struct ft_sess *sess = se_sess->fabric_sess_ptr;
 
-	FT_SESS_DBG("port_id %x\n", sess->port_id);
+	pr_debug("port_id %x\n", sess->port_id);
 	return 1;
 }
 
@@ -335,7 +335,7 @@ void ft_sess_close(struct se_session *se_sess)
 		mutex_unlock(&ft_lport_lock);
 		return;
 	}
-	FT_SESS_DBG("port_id %x\n", port_id);
+	pr_debug("port_id %x\n", port_id);
 	ft_sess_unhash(sess);
 	mutex_unlock(&ft_lport_lock);
 	transport_deregister_session_configfs(se_sess);
@@ -348,7 +348,7 @@ void ft_sess_stop(struct se_session *se_sess, int sess_sleep, int conn_sleep)
 {
 	struct ft_sess *sess = se_sess->fabric_sess_ptr;
 
-	FT_SESS_DBG("port_id %x\n", sess->port_id);
+	pr_debug("port_id %x\n", sess->port_id);
 }
 
 int ft_sess_logged_in(struct se_session *se_sess)
@@ -458,7 +458,7 @@ static int ft_prli(struct fc_rport_priv *rdata, u32 spp_len,
 	mutex_lock(&ft_lport_lock);
 	ret = ft_prli_locked(rdata, spp_len, rspp, spp);
 	mutex_unlock(&ft_lport_lock);
-	FT_SESS_DBG("port_id %x flags %x ret %x\n",
+	pr_debug("port_id %x flags %x ret %x\n",
 	       rdata->ids.port_id, rspp ? rspp->spp_flags : 0, ret);
 	return ret;
 }
@@ -518,11 +518,11 @@ static void ft_recv(struct fc_lport *lport, struct fc_frame *fp)
 	struct ft_sess *sess;
 	u32 sid = fc_frame_sid(fp);
 
-	FT_SESS_DBG("sid %x\n", sid);
+	pr_debug("sid %x\n", sid);
 
 	sess = ft_sess_get(lport, sid);
 	if (!sess) {
-		FT_SESS_DBG("sid %x sess lookup failed\n", sid);
+		pr_debug("sid %x sess lookup failed\n", sid);
 		/* TBD XXX - if FCP_CMND, send PRLO */
 		fc_frame_free(fp);
 		return;
-- 
1.7.6

