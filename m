From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 09/20] target: Remove custom debug macros in non-iscsi fabrics
Date: Fri,  8 Jul 2011 18:18:38 -0700
Message-ID: <1310174329-22228-10-git-send-email-agrover@redhat.com>
References: <1310078011-15504-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538Ab1GIBTA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Jul 2011 21:19:00 -0400
In-Reply-To: <1310078011-15504-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

pr_debug and dynamic debug messages are cool, we don't need specialized
debug infrastructure.

Use pr_err etc. instead of printk(KERN_ERR...).

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/loopback/Kconfig                   |    6 -
 drivers/target/loopback/tcm_loop.c                |   94 +++++-----
 drivers/target/loopback/tcm_loop.h                |    6 -
 drivers/target/tcm_fc/tcm_fc.h                    |   24 ---
 drivers/target/tcm_fc/tfc_cmd.c                   |   37 ++---
 drivers/target/tcm_fc/tfc_conf.c                  |   33 ++--
 drivers/target/tcm_fc/tfc_io.c                    |   22 ++--
 drivers/target/tcm_fc/tfc_sess.c                  |   18 +-
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_base.h     |    6 -
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c |  190 ++++++++++----------
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c   |   20 +-
 drivers/target/tcm_vhost/tcm_vhost_configfs.c     |   50 +++---
 drivers/target/tcm_vhost/tcm_vhost_fabric.c       |   10 +-
 drivers/target/tcm_vhost/tcm_vhost_scsi.c         |    8 +-
 14 files changed, 239 insertions(+), 285 deletions(-)

diff --git a/drivers/target/loopback/Kconfig b/drivers/target/loopback/Kconfig
index 57dcbc2..abe8ecb 100644
--- a/drivers/target/loopback/Kconfig
+++ b/drivers/target/loopback/Kconfig
@@ -3,9 +3,3 @@ config LOOPBACK_TARGET
 	help
 	  Say Y here to enable the TCM Virtual SAS target and Linux/SCSI LLD
 	  fabric loopback module.
-
-config LOOPBACK_TARGET_CDB_DEBUG
-	bool "TCM loopback fabric module CDB debug code"
-	depends on LOOPBACK_TARGET
-	help
-	  Say Y here to enable the TCM loopback fabric module CDB debug code
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 9e9a3a8..64d85ad 100644
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
@@ -1290,13 +1290,13 @@ struct se_wwn *tcm_loop_make_scsi_hba(
 		goto check_len;
 	}
 
-	printk(KERN_ERR "Unable to locate prefix for emulated Target Port:"
+	pr_err("Unable to locate prefix for emulated Target Port:"
 			" %s\n", name);
 	return ERR_PTR(-EINVAL);
 
 check_len:
 	if (strlen(name) >= TL_WWN_ADDR_LEN) {
-		printk(KERN_ERR "Emulated NAA %s Address: %s, exceeds"
+		pr_err("Emulated NAA %s Address: %s, exceeds"
 			" max: %d\n", name, tcm_loop_dump_proto_id(tl_hba),
 			TL_WWN_ADDR_LEN);
 		kfree(tl_hba);
@@ -1315,7 +1315,7 @@ check_len:
 
 	sh = tl_hba->sh;
 	tcm_loop_hba_no_cnt++;
-	printk(KERN_INFO "TCM_Loop_ConfigFS: Allocated emulated Target"
+	pr_debug("TCM_Loop_ConfigFS: Allocated emulated Target"
 		" %s Address: %s at Linux/SCSI Host ID: %d\n",
 		tcm_loop_dump_proto_id(tl_hba), name, sh->host_no);
 
@@ -1338,7 +1338,7 @@ void tcm_loop_drop_scsi_hba(
 	 */
 	device_unregister(&tl_hba->dev);
 
-	printk(KERN_INFO "TCM_Loop_ConfigFS: Deallocated emulated Target"
+	pr_debug("TCM_Loop_ConfigFS: Deallocated emulated Target"
 		" SAS Address: %s at Linux/SCSI Host ID: %d\n",
 		config_item_name(&wwn->wwn_group.cg_item), host_no);
 }
@@ -1374,7 +1374,7 @@ static int tcm_loop_register_configfs(void)
 	 */
 	fabric = target_fabric_configfs_init(THIS_MODULE, "loopback");
 	if (IS_ERR(fabric)) {
-		printk(KERN_ERR "tcm_loop_register_configfs() failed!\n");
+		pr_err("tcm_loop_register_configfs() failed!\n");
 		return PTR_ERR(fabric);
 	}
 	/*
@@ -1465,7 +1465,7 @@ static int tcm_loop_register_configfs(void)
 	 */
 	ret = target_fabric_configfs_register(fabric);
 	if (ret < 0) {
-		printk(KERN_ERR "target_fabric_configfs_register() for"
+		pr_err("target_fabric_configfs_register() for"
 				" TCM_Loop failed!\n");
 		target_fabric_configfs_free(fabric);
 		return -1;
@@ -1474,7 +1474,7 @@ static int tcm_loop_register_configfs(void)
 	 * Setup our local pointer to *fabric.
 	 */
 	tcm_loop_fabric_configfs = fabric;
-	printk(KERN_INFO "TCM_LOOP[0] - Set fabric ->"
+	pr_debug("TCM_LOOP[0] - Set fabric ->"
 			" tcm_loop_fabric_configfs\n");
 	return 0;
 }
@@ -1486,7 +1486,7 @@ static void tcm_loop_deregister_configfs(void)
 
 	target_fabric_configfs_deregister(tcm_loop_fabric_configfs);
 	tcm_loop_fabric_configfs = NULL;
-	printk(KERN_INFO "TCM_LOOP[0] - Cleared"
+	pr_debug("TCM_LOOP[0] - Cleared"
 				" tcm_loop_fabric_configfs\n");
 }
 
@@ -1499,7 +1499,7 @@ static int __init tcm_loop_fabric_init(void)
 				__alignof__(struct tcm_loop_cmd),
 				0, NULL);
 	if (!tcm_loop_cmd_cache) {
-		printk(KERN_ERR "kmem_cache_create() for"
+		pr_err("kmem_cache_create() for"
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
index d0405e0..334d3b2 100644
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
-#define FT_DEBUG(mask, fmt, args...) 					\
-	do {								\
-		if (ft_debug_logging & (mask))				\
-			printk(KERN_INFO "tcm_fc: %s: " fmt, 		\
-			       __func__, ##args);			\
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
index c45f4c2..cbb3858 100644
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
@@ -405,7 +402,7 @@ static void ft_send_tm(struct ft_cmd *cmd)
 			 * since "unable to  handle TMR request because failed
 			 * to get to LUN"
 			 */
-			FT_TM_DBG("Failed to get LUN for TMR func %d, "
+			pr_debug("Failed to get LUN for TMR func %d, "
 				"se_cmd %p, unpacked_lun %d\n",
 				tm_func, &cmd->se_cmd, cmd->lun);
 			ft_dump_cmd(cmd, __func__);
@@ -434,15 +431,15 @@ static void ft_send_tm(struct ft_cmd *cmd)
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
@@ -478,7 +475,7 @@ int ft_queue_tm_resp(struct se_cmd *se_cmd)
 		code = FCP_TMF_FAILED;
 		break;
 	}
-	FT_TM_DBG("tmr fn %d resp %d fcp code %d\n",
+	pr_debug("tmr fn %d resp %d fcp code %d\n",
 		  tmr->function, tmr->response, code);
 	ft_send_resp_code(cmd, code);
 	return 0;
@@ -506,7 +503,7 @@ static void ft_recv_cmd(struct ft_sess *sess, struct fc_frame *fp)
 	return;
 
 busy:
-	FT_IO_DBG("cmd or seq allocation failure - sending BUSY\n");
+	pr_debug("cmd or seq allocation failure - sending BUSY\n");
 	ft_send_resp_status(lport, fp, SAM_STAT_BUSY, 0);
 	fc_frame_free(fp);
 	ft_sess_put(sess);		/* undo get from lookup */
@@ -531,7 +528,7 @@ void ft_recv_req(struct ft_sess *sess, struct fc_frame *fp)
 	case FC_RCTL_DD_DATA_DESC:	/* transfer ready */
 	case FC_RCTL_ELS4_REQ:		/* SRR, perhaps */
 	default:
-		printk(KERN_INFO "%s: unhandled frame r_ctl %x\n",
+		pr_debug("%s: unhandled frame r_ctl %x\n",
 		       __func__, fh->fh_r_ctl);
 		fc_frame_free(fp);
 		ft_sess_put(sess);	/* undo get from lookup */
@@ -626,7 +623,7 @@ static void ft_send_cmd(struct ft_cmd *cmd)
 
 	ret = transport_generic_allocate_tasks(se_cmd, cmd->cdb);
 
-	FT_IO_DBG("r_ctl %x alloc task ret %d\n", fh->fh_r_ctl, ret);
+	pr_debug("r_ctl %x alloc task ret %d\n", fh->fh_r_ctl, ret);
 	ft_dump_cmd(cmd, __func__);
 
 	if (ret == -ENOMEM) {
@@ -657,7 +654,7 @@ err:
  */
 static void ft_exec_req(struct ft_cmd *cmd)
 {
-	FT_IO_DBG("cmd state %x\n", cmd->state);
+	pr_debug("cmd state %x\n", cmd->state);
 	switch (cmd->state) {
 	case FC_CMD_ST_NEW:
 		ft_send_cmd(cmd);
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index e47e7e7..98eb96c 100644
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
@@ -580,7 +580,7 @@ int ft_register_configfs(void)
 	 */
 	fabric = target_fabric_configfs_init(THIS_MODULE, "fc");
 	if (IS_ERR(fabric)) {
-		printk(KERN_INFO "%s: target_fabric_configfs_init() failed!\n",
+		pr_debug("%s: target_fabric_configfs_init() failed!\n",
 		       __func__);
 		return PTR_ERR(fabric);
 	}
@@ -607,10 +607,9 @@ int ft_register_configfs(void)
 	 */
 	ret = target_fabric_configfs_register(fabric);
 	if (ret < 0) {
-		FT_CONF_DBG("target_fabric_configfs_register() for"
+		pr_debug("target_fabric_configfs_register() for"
 			    " FC Target failed!\n");
-		printk(KERN_INFO
-		       "%s: target_fabric_configfs_register() failed!\n",
+		pr_debug("%s: target_fabric_configfs_register() failed!\n",
 		       __func__);
 		target_fabric_configfs_free(fabric);
 		return -1;
diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index c1552cf..a8ef64a 100644
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
@@ -176,12 +177,11 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
 		error = lport->tt.seq_send(lport, cmd->seq, fp);
 		if (error) {
 			/* XXX For now, initiator will retry */
-			if (printk_ratelimit())
-				printk(KERN_ERR "%s: Failed to send frame %p, "
-						"xid <0x%x>, remaining <0x%zx>, "
-						"lso_max <0x%x>\n",
-						__func__, fp, ep->xid,
-						remaining, lport->lso_max);
+			pr_err_ratelimited("%s: Failed to send frame %p, "
+					   "xid <0x%x>, remaining <0x%zx>, "
+					   "lso_max <0x%x>\n",
+					   __func__, fp, ep->xid,
+					   remaining, lport->lso_max);
 		}
 	}
 	return ft_queue_status(se_cmd);
@@ -222,10 +222,10 @@ void ft_recv_write_data(struct ft_cmd *cmd, struct fc_frame *fp)
 	 */
 	buf = fc_frame_payload_get(fp, 1);
 	if (cmd->was_ddp_setup && buf) {
-		printk(KERN_INFO "%s: When DDP was setup, not expected to"
-				 "receive frame with payload, Payload shall be"
-				 "copied directly to buffer instead of coming "
-				 "via. legacy receive queues\n", __func__);
+		pr_err("%s: When DDP was setup, not expected to"
+		       "receive frame with payload, Payload shall be"
+		       "copied directly to buffer instead of coming "
+		       "via. legacy receive queues\n", __func__);
 		BUG_ON(buf);
 	}
 
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
diff --git a/drivers/target/tcm_qla2xxx/tcm_qla2xxx_base.h b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_base.h
index a89a567..bb7c497 100644
--- a/drivers/target/tcm_qla2xxx/tcm_qla2xxx_base.h
+++ b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_base.h
@@ -8,12 +8,6 @@
 
 #include "qla_target.h"
 
-#if 0
-#define DEBUG_QLA_TGT_SESS_MAP(x...)	printk(KERN_INFO x)
-#else
-#define DEBUG_QLA_TGT_SESS_MAP(x...)
-#endif
-
 struct tcm_qla2xxx_nacl {
 	/* From libfc struct fc_rport->port_id */
 	u16 nport_id;
diff --git a/drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c
index af81122..1e2093b 100644
--- a/drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c
+++ b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c
@@ -79,7 +79,7 @@ static int tcm_qla2xxx_setup_nacl_from_rport(
 		if (rport_wwnn != rport->node_name)
 			continue;
 
-		DEBUG_QLA_TGT_SESS_MAP("Located existing rport_wwpn and rport->node_name:"
+		pr_debug("Located existing rport_wwpn and rport->node_name:"
 			" 0x%016LX, port_id: 0x%04x\n", rport->node_name,
 			rport->port_id);
 		domain = (rport->port_id >> 16) & 0xff;
@@ -87,21 +87,21 @@ static int tcm_qla2xxx_setup_nacl_from_rport(
 		al_pa = rport->port_id & 0xff;
 		nacl->nport_id = rport->port_id;
 
-		DEBUG_QLA_TGT_SESS_MAP("fc_rport domain: 0x%02x area: 0x%02x al_pa: %02x\n",
+		pr_debug("fc_rport domain: 0x%02x area: 0x%02x al_pa: %02x\n",
 				domain, area, al_pa);
 		spin_unlock_irqrestore(sh->host_lock, flags);
 
 
 		spin_lock_irqsave(&vha->hw->hardware_lock, flags);
 		d = (struct tcm_qla2xxx_fc_domain *)&lport->lport_fcport_map[domain];
-		DEBUG_QLA_TGT_SESS_MAP("Using d: %p for domain: 0x%02x\n", d, domain);
+		pr_debug("Using d: %p for domain: 0x%02x\n", d, domain);
 		a = &d->areas[area];
-		DEBUG_QLA_TGT_SESS_MAP("Using a: %p for area: 0x%02x\n", a, area);
+		pr_debug("Using a: %p for area: 0x%02x\n", a, area);
 		p = &a->al_pas[al_pa];
-		DEBUG_QLA_TGT_SESS_MAP("Using p: %p for al_pa: 0x%02x\n", p, al_pa);
+		pr_debug("Using p: %p for al_pa: 0x%02x\n", p, al_pa);
 
 		p->se_nacl = se_nacl;
-		DEBUG_QLA_TGT_SESS_MAP("Setting p->se_nacl to se_nacl: %p for WWNN: 0x%016LX,"
+		pr_debug("Setting p->se_nacl to se_nacl: %p for WWNN: 0x%016LX,"
 			" port_id: 0x%04x\n", se_nacl, rport_wwnn,
 			nacl->nport_id);
 		spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
@@ -134,18 +134,18 @@ int tcm_qla2xxx_clear_nacl_from_fcport_map(
 	area = (nacl->nport_id >> 8) & 0xff;
 	al_pa = nacl->nport_id & 0xff;
 
-	DEBUG_QLA_TGT_SESS_MAP("fc_rport domain: 0x%02x area: 0x%02x al_pa: %02x\n",
+	pr_debug("fc_rport domain: 0x%02x area: 0x%02x al_pa: %02x\n",
 			domain, area, al_pa);
 
 	d = (struct tcm_qla2xxx_fc_domain *)&lport->lport_fcport_map[domain];
-	DEBUG_QLA_TGT_SESS_MAP("Using d: %p for domain: 0x%02x\n", d, domain);
+	pr_debug("Using d: %p for domain: 0x%02x\n", d, domain);
 	a = &d->areas[area];
-	DEBUG_QLA_TGT_SESS_MAP("Using a: %p for area: 0x%02x\n", a, area);
+	pr_debug("Using a: %p for area: 0x%02x\n", a, area);
 	p = &a->al_pas[al_pa];
-	DEBUG_QLA_TGT_SESS_MAP("Using p: %p for al_pa: 0x%02x\n", p, al_pa);
+	pr_debug("Using p: %p for al_pa: 0x%02x\n", p, al_pa);
 
 	p->se_nacl = NULL;
-	DEBUG_QLA_TGT_SESS_MAP("Clearing p->se_nacl to se_nacl: %p for WWNN: 0x%016LX,"
+	pr_debug("Clearing p->se_nacl to se_nacl: %p for WWNN: 0x%016LX,"
 		" port_id: 0x%04x\n", se_nacl, nacl->nport_wwnn,
 		nacl->nport_id);
 
@@ -241,7 +241,7 @@ static ssize_t tcm_qla2xxx_tpg_attrib_store_##name(			\
 									\
 	ret = strict_strtoul(page, 0, &val);				\
 	if (ret < 0) {							\
-		printk(KERN_ERR "strict_strtoul() failed with"		\
+		pr_err("strict_strtoul() failed with"		\
 				" ret: %d\n", ret);			\
 		return -EINVAL;						\
 	}								\
@@ -259,7 +259,7 @@ static int tcm_qla2xxx_set_attrib_##_name(				\
 	struct tcm_qla2xxx_tpg_attrib *a = &tpg->tpg_attrib;		\
 									\
 	if ((val != 0) && (val != 1)) {					\
-		printk(KERN_ERR "Illegal boolean value %lu\n", val);	\
+		pr_err("Illegal boolean value %lu\n", val);	\
                 return -EINVAL;						\
 	}								\
 									\
@@ -335,7 +335,7 @@ static ssize_t tcm_qla2xxx_tpg_store_enable(
 
 	op = simple_strtoul(page, &endptr, 0);
 	if ((op != 1) && (op != 0)) {
-		printk(KERN_ERR "Illegal value for tpg_enable: %u\n", op);
+		pr_err("Illegal value for tpg_enable: %u\n", op);
 		return -EINVAL;
 	}
 
@@ -344,7 +344,7 @@ static ssize_t tcm_qla2xxx_tpg_store_enable(
 		qla_tgt_enable_vha(vha);
 	} else {
 		if (!ha->qla_tgt) {
-			printk(KERN_ERR "truct qla_hw_data *ha->qla_tgt is NULL\n");
+			pr_err("truct qla_hw_data *ha->qla_tgt is NULL\n");
 			return -ENODEV;
 		}
 		atomic_set(&tpg->lport_tpg_enabled, 0);
@@ -378,14 +378,14 @@ static struct se_portal_group *tcm_qla2xxx_make_tpg(
 		return ERR_PTR(-EINVAL);
 	
 	if ((lport->qla_npiv_vp == NULL) && (tpgt != 1)) {
-		printk(KERN_ERR "In non NPIV mode, a single TPG=1 is used for"
+		pr_err("In non NPIV mode, a single TPG=1 is used for"
 			" HW port mappings\n");
 		return ERR_PTR(-ENOSYS);
 	}
 
 	tpg = kzalloc(sizeof(struct tcm_qla2xxx_tpg), GFP_KERNEL);
 	if (!(tpg)) {
-		printk(KERN_ERR "Unable to allocate struct tcm_qla2xxx_tpg\n");
+		pr_err("Unable to allocate struct tcm_qla2xxx_tpg\n");
 		return ERR_PTR(-ENOMEM);
 	}
 	tpg->lport = lport;
@@ -455,7 +455,7 @@ static struct se_portal_group *tcm_qla2xxx_npiv_make_tpg(
 
 	tpg = kzalloc(sizeof(struct tcm_qla2xxx_tpg), GFP_KERNEL);
 	if (!(tpg)) {
-		printk(KERN_ERR "Unable to allocate struct tcm_qla2xxx_tpg\n");
+		pr_err("Unable to allocate struct tcm_qla2xxx_tpg\n");
 		return ERR_PTR(-ENOMEM);
 	}
 	tpg->lport = lport;
@@ -489,7 +489,7 @@ static struct qla_tgt_sess *tcm_qla2xxx_find_sess_by_s_id(
 
 	lport = (struct tcm_qla2xxx_lport *)ha->target_lport_ptr;
 	if (!lport) {
-		printk(KERN_ERR "Unable to locate struct tcm_qla2xxx_lport\n");
+		pr_err("Unable to locate struct tcm_qla2xxx_lport\n");
 		dump_stack();
 		return NULL;
 	}
@@ -498,28 +498,28 @@ static struct qla_tgt_sess *tcm_qla2xxx_find_sess_by_s_id(
 	area = s_id[1];
 	al_pa = s_id[2];
 
-	DEBUG_QLA_TGT_SESS_MAP("find_sess_by_s_id: 0x%02x area: 0x%02x al_pa: %02x\n",
+	pr_debug("find_sess_by_s_id: 0x%02x area: 0x%02x al_pa: %02x\n",
 			domain, area, al_pa);
 
 	d = (struct tcm_qla2xxx_fc_domain *)&lport->lport_fcport_map[domain];
-	DEBUG_QLA_TGT_SESS_MAP("Using d: %p for domain: 0x%02x\n", d, domain);
+	pr_debug("Using d: %p for domain: 0x%02x\n", d, domain);
 	a = &d->areas[area];
-	DEBUG_QLA_TGT_SESS_MAP("Using a: %p for area: 0x%02x\n", a, area);
+	pr_debug("Using a: %p for area: 0x%02x\n", a, area);
 	p = &a->al_pas[al_pa];
-	DEBUG_QLA_TGT_SESS_MAP("Using p: %p for al_pa: 0x%02x\n", p, al_pa);
+	pr_debug("Using p: %p for al_pa: 0x%02x\n", p, al_pa);
 
 	se_nacl = p->se_nacl;
 	if (!se_nacl) {
-		DEBUG_QLA_TGT_SESS_MAP("Unable to locate s_id: 0x%02x area: 0x%02x"
+		pr_debug("Unable to locate s_id: 0x%02x area: 0x%02x"
 			" al_pa: %02x\n", domain, area, al_pa);
 		return NULL;
 	}
-	DEBUG_QLA_TGT_SESS_MAP("find_sess_by_s_id: located se_nacl: %p,"
+	pr_debug("find_sess_by_s_id: located se_nacl: %p,"
 		" initiatorname: %s\n", se_nacl, se_nacl->initiatorname);
 
 	nacl = container_of(se_nacl, struct tcm_qla2xxx_nacl, se_node_acl);
 	if (!nacl->qla_tgt_sess) {
-		printk(KERN_ERR "Unable to locate struct qla_tgt_sess\n");
+		pr_err("Unable to locate struct qla_tgt_sess\n");
 		return NULL;
 	}
 
@@ -546,19 +546,19 @@ static void tcm_qla2xxx_set_sess_by_s_id(
 	domain = s_id[0];
 	area = s_id[1];
 	al_pa = s_id[2];
-	DEBUG_QLA_TGT_SESS_MAP("set_sess_by_s_id: domain 0x%02x area: 0x%02x al_pa: %02x\n",
+	pr_debug("set_sess_by_s_id: domain 0x%02x area: 0x%02x al_pa: %02x\n",
 			domain, area, al_pa);
 
 	d = (struct tcm_qla2xxx_fc_domain *)&lport->lport_fcport_map[domain];
-	DEBUG_QLA_TGT_SESS_MAP("Using d: %p for domain: 0x%02x\n", d, domain);
+	pr_debug("Using d: %p for domain: 0x%02x\n", d, domain);
 	a = &d->areas[area];
-	DEBUG_QLA_TGT_SESS_MAP("Using a: %p for area: 0x%02x\n", a, area);
+	pr_debug("Using a: %p for area: 0x%02x\n", a, area);
 	p = &a->al_pas[al_pa];
-	DEBUG_QLA_TGT_SESS_MAP("Using p: %p for al_pa: 0x%02x\n", p, al_pa);
+	pr_debug("Using p: %p for al_pa: 0x%02x\n", p, al_pa);
 
 	saved_nacl = p->se_nacl;
 	if (!saved_nacl) {
-		DEBUG_QLA_TGT_SESS_MAP("Setting up new p->se_nacl to new_se_nacl\n");
+		pr_debug("Setting up new p->se_nacl to new_se_nacl\n");
 		p->se_nacl = new_se_nacl;
 		qla_tgt_sess->se_sess = se_sess;
 		nacl->qla_tgt_sess = qla_tgt_sess;
@@ -567,13 +567,13 @@ static void tcm_qla2xxx_set_sess_by_s_id(
 
 	if (nacl->qla_tgt_sess) {
 		if (new_se_nacl == NULL) {
-			DEBUG_QLA_TGT_SESS_MAP("Clearing existing nacl->qla_tgt_sess"
+			pr_debug("Clearing existing nacl->qla_tgt_sess"
 					" and p->se_nacl\n");
 			p->se_nacl = NULL;
 			nacl->qla_tgt_sess = NULL;
 			return;
 		}
-		DEBUG_QLA_TGT_SESS_MAP("Replacing existing nacl->qla_tgt_sess and"
+		pr_debug("Replacing existing nacl->qla_tgt_sess and"
 				" p->se_nacl\n");
 		p->se_nacl = new_se_nacl;
 		qla_tgt_sess->se_sess = se_sess;
@@ -582,18 +582,18 @@ static void tcm_qla2xxx_set_sess_by_s_id(
 	}
 
 	if (new_se_nacl == NULL) {
-		DEBUG_QLA_TGT_SESS_MAP("Clearing existing p->se_nacl\n");
+		pr_debug("Clearing existing p->se_nacl\n");
 		p->se_nacl = NULL;
 		return;
 	}
 
-	DEBUG_QLA_TGT_SESS_MAP("Replacing existing p->se_nacl w/o active"
+	pr_debug("Replacing existing p->se_nacl w/o active"
 				" nacl->qla_tgt_sess\n");
 	p->se_nacl = new_se_nacl;
 	qla_tgt_sess->se_sess = se_sess;
 	nacl->qla_tgt_sess = qla_tgt_sess;
 
-	DEBUG_QLA_TGT_SESS_MAP("Setup nacl->qla_tgt_sess %p by s_id for se_nacl: %p,"
+	pr_debug("Setup nacl->qla_tgt_sess %p by s_id for se_nacl: %p,"
 		" initiatorname: %s\n", nacl->qla_tgt_sess, new_se_nacl,
 		new_se_nacl->initiatorname);
 }
@@ -613,18 +613,18 @@ static struct qla_tgt_sess *tcm_qla2xxx_find_sess_by_loop_id(
 
 	lport = (struct tcm_qla2xxx_lport *)ha->target_lport_ptr;
 	if (!lport) {
-		printk(KERN_ERR "Unable to locate struct tcm_qla2xxx_lport\n");
+		pr_err("Unable to locate struct tcm_qla2xxx_lport\n");
 		dump_stack();
 		return NULL;
 	}
 
-	DEBUG_QLA_TGT_SESS_MAP("find_sess_by_loop_id: Using loop_id: 0x%04x\n", loop_id);
+	pr_debug("find_sess_by_loop_id: Using loop_id: 0x%04x\n", loop_id);
 
 	fc_loopid = (struct tcm_qla2xxx_fc_loopid *)&lport->lport_loopid_map[loop_id];
 
 	se_nacl = fc_loopid->se_nacl;
 	if (!se_nacl) {
-		DEBUG_QLA_TGT_SESS_MAP("Unable to locate se_nacl by loop_id:"
+		pr_debug("Unable to locate se_nacl by loop_id:"
 				" 0x%04x\n", loop_id);
 		return NULL;
 	}
@@ -632,7 +632,7 @@ static struct qla_tgt_sess *tcm_qla2xxx_find_sess_by_loop_id(
 	nacl = container_of(se_nacl, struct tcm_qla2xxx_nacl, se_node_acl);
 
 	if (!nacl->qla_tgt_sess) {
-		printk(KERN_ERR "Unable to locate struct qla_tgt_sess\n");
+		pr_err("Unable to locate struct qla_tgt_sess\n");
 		return NULL;
 	}
 
@@ -653,13 +653,13 @@ static void tcm_qla2xxx_set_sess_by_loop_id(
 	struct se_node_acl *saved_nacl;
 	struct tcm_qla2xxx_fc_loopid *fc_loopid;
 
-	DEBUG_QLA_TGT_SESS_MAP("set_sess_by_loop_id: Using loop_id: 0x%04x\n", loop_id);
+	pr_debug("set_sess_by_loop_id: Using loop_id: 0x%04x\n", loop_id);
 
 	fc_loopid = (struct tcm_qla2xxx_fc_loopid *)&lport->lport_loopid_map[loop_id];
 
 	saved_nacl = fc_loopid->se_nacl;
 	if (!saved_nacl) {
-		DEBUG_QLA_TGT_SESS_MAP("Setting up new fc_loopid->se_nacl"
+		pr_debug("Setting up new fc_loopid->se_nacl"
 				" to new_se_nacl\n");
 		fc_loopid->se_nacl = new_se_nacl;
 		if (qla_tgt_sess->se_sess != se_sess)
@@ -671,14 +671,14 @@ static void tcm_qla2xxx_set_sess_by_loop_id(
 
 	if (nacl->qla_tgt_sess) {
 		if (new_se_nacl == NULL) {
-			DEBUG_QLA_TGT_SESS_MAP("Clearing nacl->qla_tgt_sess and"
+			pr_debug("Clearing nacl->qla_tgt_sess and"
 					" fc_loopid->se_nacl\n");
 			fc_loopid->se_nacl = NULL;
 			nacl->qla_tgt_sess = NULL;
 			return;
 		}
 
-		DEBUG_QLA_TGT_SESS_MAP("Replacing existing nacl->qla_tgt_sess and"
+		pr_debug("Replacing existing nacl->qla_tgt_sess and"
 				" fc_loopid->se_nacl\n");
 		fc_loopid->se_nacl = new_se_nacl;
 		if (qla_tgt_sess->se_sess != se_sess)
@@ -689,12 +689,12 @@ static void tcm_qla2xxx_set_sess_by_loop_id(
 	}
 
 	if (new_se_nacl == NULL) {
-		DEBUG_QLA_TGT_SESS_MAP("Clearing fc_loopid->se_nacl\n");
+		pr_debug("Clearing fc_loopid->se_nacl\n");
 		fc_loopid->se_nacl = NULL;
 		return;
 	}
 
-	DEBUG_QLA_TGT_SESS_MAP("Replacing existing fc_loopid->se_nacl w/o"
+	pr_debug("Replacing existing fc_loopid->se_nacl w/o"
 			" active nacl->qla_tgt_sess\n");
 	fc_loopid->se_nacl = new_se_nacl;
 	if (qla_tgt_sess->se_sess != se_sess)
@@ -702,7 +702,7 @@ static void tcm_qla2xxx_set_sess_by_loop_id(
 	if (nacl->qla_tgt_sess != qla_tgt_sess)
 		nacl->qla_tgt_sess = qla_tgt_sess;
 
-	DEBUG_QLA_TGT_SESS_MAP("Setup nacl->qla_tgt_sess %p by loop_id for se_nacl: %p,"
+	pr_debug("Setup nacl->qla_tgt_sess %p by loop_id for se_nacl: %p,"
 		" initiatorname: %s\n", nacl->qla_tgt_sess, new_se_nacl,
 		new_se_nacl->initiatorname);
 }
@@ -719,7 +719,7 @@ static void tcm_qla2xxx_free_session(struct qla_tgt_sess *sess)
 
 	se_sess = sess->se_sess;
 	if (!se_sess) {
-		printk(KERN_ERR "struct qla_tgt_sess->se_sess is NULL\n");
+		pr_err("struct qla_tgt_sess->se_sess is NULL\n");
 		dump_stack();
 		return;
 	}
@@ -728,7 +728,7 @@ static void tcm_qla2xxx_free_session(struct qla_tgt_sess *sess)
 
 	lport = (struct tcm_qla2xxx_lport *)ha->target_lport_ptr;
 	if (!lport) {
-		printk(KERN_ERR "Unable to locate struct tcm_qla2xxx_lport\n");
+		pr_err("Unable to locate struct tcm_qla2xxx_lport\n");
 		dump_stack();
 		return;
 	}
@@ -780,7 +780,7 @@ static int tcm_qla2xxx_check_initiator_node_acl(
 
 	lport = (struct tcm_qla2xxx_lport *)ha->target_lport_ptr;
 	if (!lport) {
-		printk(KERN_ERR "Unable to locate struct tcm_qla2xxx_lport\n");
+		pr_err("Unable to locate struct tcm_qla2xxx_lport\n");
 		dump_stack();
 		return -EINVAL;
 	}
@@ -789,14 +789,14 @@ static int tcm_qla2xxx_check_initiator_node_acl(
 	 */
 	tpg = lport->tpg_1;
 	if (!tpg) {
-		printk(KERN_ERR "Unable to lcoate struct tcm_qla2xxx_lport->tpg_1\n");
+		pr_err("Unable to lcoate struct tcm_qla2xxx_lport->tpg_1\n");
 		return -EINVAL;
 	}
 	se_tpg = &tpg->se_tpg;
 
 	se_sess = transport_init_session();
 	if (!se_sess) {
-		printk(KERN_ERR "Unable to initialize struct se_session\n");
+		pr_err("Unable to initialize struct se_session\n");
 		return -ENOMEM;
 	}
 	/*
@@ -860,19 +860,19 @@ static int tcm_qla2xxx_init_lport(
 	lport->lport_fcport_map = vmalloc(
 			sizeof(struct tcm_qla2xxx_fc_domain) * 256);
 	if (!(lport->lport_fcport_map)) {
-		printk(KERN_ERR "Unable to allocate lport_fcport_map of %lu"
+		pr_err("Unable to allocate lport_fcport_map of %lu"
 			" bytes\n", sizeof(struct tcm_qla2xxx_fc_domain) * 256);
 		return -ENOMEM;
 	}
 	memset(lport->lport_fcport_map, 0,
 			sizeof(struct tcm_qla2xxx_fc_domain) * 256);
-	printk(KERN_INFO "qla2xxx: Allocated lport_fcport_map of %lu bytes\n",
+	pr_debug("qla2xxx: Allocated lport_fcport_map of %lu bytes\n",
 			sizeof(struct tcm_qla2xxx_fc_domain) * 256);
 
 	lport->lport_loopid_map = vmalloc(sizeof(struct tcm_qla2xxx_fc_loopid) *
 				65536);
 	if (!(lport->lport_loopid_map)) {
-		printk(KERN_ERR "Unable to allocate lport->lport_loopid_map"
+		pr_err("Unable to allocate lport->lport_loopid_map"
 			" of %lu bytes\n", sizeof(struct tcm_qla2xxx_fc_loopid)
 			* 65536);
 		vfree(lport->lport_fcport_map);
@@ -880,7 +880,7 @@ static int tcm_qla2xxx_init_lport(
 	}
 	memset(lport->lport_loopid_map, 0, sizeof(struct tcm_qla2xxx_fc_loopid)
 			* 65536);
-	printk(KERN_INFO "qla2xxx: Allocated lport_loopid_map of %lu bytes\n",
+	pr_debug("qla2xxx: Allocated lport_loopid_map of %lu bytes\n",
 			sizeof(struct tcm_qla2xxx_fc_loopid) * 65536);
 	/*
 	 * Setup local pointer to vha, NPIV VP pointer (if present) and
@@ -917,7 +917,7 @@ static struct se_wwn *tcm_qla2xxx_make_lport(
 
 	lport = kzalloc(sizeof(struct tcm_qla2xxx_lport), GFP_KERNEL);
 	if (!(lport)) {
-		printk(KERN_ERR "Unable to allocate struct tcm_qla2xxx_lport\n");
+		pr_err("Unable to allocate struct tcm_qla2xxx_lport\n");
 		return ERR_PTR(-ENOMEM);
 	}
 	lport->lport_wwpn = wwpn;
@@ -941,7 +941,7 @@ static struct se_wwn *tcm_qla2xxx_make_lport(
 
 		spin_lock_irqsave(&ha->hardware_lock, flags);
 		if (host->active_mode & MODE_TARGET) {
-			printk(KERN_INFO "MODE_TARGET already active on qla2xxx"
+			pr_debug("MODE_TARGET already active on qla2xxx"
 					"(%d)\n",  host->host_no);
 			spin_unlock_irqrestore(&ha->hardware_lock, flags);
 			continue;
@@ -949,33 +949,33 @@ static struct se_wwn *tcm_qla2xxx_make_lport(
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 		if (!scsi_host_get(host)) {
-			printk(KERN_ERR "Unable to scsi_host_get() for"
+			pr_err("Unable to scsi_host_get() for"
 				" qla2xxx scsi_host\n");
 			ret = -EINVAL;
 			goto out;
 		}
 
-		printk("qla2xxx HW vha->node_name: ");
+		pr_debug("qla2xxx HW vha->node_name: ");
 		for (i = 0; i < 8; i++)
-			printk("%02x ", vha->node_name[i]);
-		printk("\n");
+			pr_debug("%02x ", vha->node_name[i]);
+		pr_debug("\n");
 
-		printk("qla2xxx HW vha->port_name: ");
+		pr_debug("qla2xxx HW vha->port_name: ");
 		for (i = 0; i < 8; i++)
-			printk("%02x ", vha->port_name[i]);
-		printk("\n");
+			pr_debug("%02x ", vha->port_name[i]);
+		pr_debug("\n");
 
-		printk("qla2xxx passed configfs WWPN: ");
+		pr_debug("qla2xxx passed configfs WWPN: ");
 		put_unaligned_be64(wwpn, b);
 		for (i = 0; i < 8; i++)
-			printk("%02x ", b[i]);
-		printk("\n");
+			pr_debug("%02x ", b[i]);
+		pr_debug("\n");
 
 		if (memcmp(vha->port_name, b, 8)) {
 			scsi_host_put(host);
 			continue;
 		}
-		printk("qla2xxx: Found matching HW WWPN: %s for lport\n", name);
+		pr_debug("qla2xxx: Found matching HW WWPN: %s for lport\n", name);
 		ret = tcm_qla2xxx_init_lport(lport, vha, NULL);
 		break;
 	}
@@ -1041,7 +1041,7 @@ static struct se_wwn *tcm_qla2xxx_npiv_make_lport(
 
 	lport = kzalloc(sizeof(struct tcm_qla2xxx_lport), GFP_KERNEL);
 	if (!(lport)) {
-		printk(KERN_ERR "Unable to allocate struct tcm_qla2xxx_lport"
+		pr_err("Unable to allocate struct tcm_qla2xxx_lport"
 				" for NPIV\n");
 		return ERR_PTR(-ENOMEM);
 	}
@@ -1068,7 +1068,7 @@ static struct se_wwn *tcm_qla2xxx_npiv_make_lport(
 
 		spin_lock_irqsave(&ha->hardware_lock, flags);
 		if (host->active_mode & MODE_TARGET) {
-			printk(KERN_INFO "MODE_TARGET already active on qla2xxx"
+			pr_debug("MODE_TARGET already active on qla2xxx"
 					"(%d)\n",  host->host_no);
 			spin_unlock_irqrestore(&ha->hardware_lock, flags);
 			continue;
@@ -1076,33 +1076,33 @@ static struct se_wwn *tcm_qla2xxx_npiv_make_lport(
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 		if (!scsi_host_get(host)) {
-			printk(KERN_ERR "Unable to scsi_host_get() for"
+			pr_err("Unable to scsi_host_get() for"
 				" qla2xxx scsi_host\n");
 			ret = -EINVAL;
 			goto out;
 		}
 
-		printk("qla2xxx HW vha->node_name: ");
+		pr_debug("qla2xxx HW vha->node_name: ");
 		for (i = 0; i < 8; i++)
-			printk("%02x ", vha->node_name[i]);
-		printk("\n");
+			pr_debug("%02x ", vha->node_name[i]);
+		pr_debug("\n");
 
-		printk("qla2xxx HW vha->port_name: ");
+		pr_debug("qla2xxx HW vha->port_name: ");
 		for (i = 0; i < 8; i++)
-			printk("%02x ", vha->port_name[i]);
-		printk("\n");
+			pr_debug("%02x ", vha->port_name[i]);
+		pr_debug("\n");
 
-		printk("qla2xxx passed configfs NPIV WWPN: ");
+		pr_debug("qla2xxx passed configfs NPIV WWPN: ");
 		put_unaligned_be64(npiv_wwpn, b);
 		for (i = 0; i < 8; i++)
-			printk("%02x ", b[i]);
-		printk("\n");
+			pr_debug("%02x ", b[i]);
+		pr_debug("\n");
 
-		printk("qla2xxx passed configfs NPIV WWNN: ");
+		pr_debug("qla2xxx passed configfs NPIV WWNN: ");
 		put_unaligned_be64(npiv_wwnn, b2);
 		for (i = 0; i < 8; i++)
-			printk("%02x ", b2[i]);
-		printk("\n");
+			pr_debug("%02x ", b2[i]);
+		pr_debug("\n");
 
 		spin_lock_irqsave(&ha->vport_slock, flags);
 		list_for_each_entry(npiv_vp, &ha->vp_list, list) {
@@ -1116,7 +1116,7 @@ static struct se_wwn *tcm_qla2xxx_npiv_make_lport(
 #warning FIXME: Need to add atomic_inc(&npiv_vp->vref_count) before dropping ha->vport_slock..?
 			spin_unlock_irqrestore(&ha->vport_slock, flags);
 
-			printk("qla2xxx_npiv: Found matching NPIV WWPN+WWNN: %s "
+			pr_debug("qla2xxx_npiv: Found matching NPIV WWPN+WWNN: %s "
 					" for lport\n", name);
 			tcm_qla2xxx_init_lport(lport, vha, npiv_vp);
 			/*
@@ -1134,7 +1134,7 @@ static struct se_wwn *tcm_qla2xxx_npiv_make_lport(
 			/* we only allow support on Channel 0 !!! */
 			vport = fc_vport_create(host, 0, &vid);
 			if (!vport) {
-				printk(KERN_ERR "fc_vport_create() failed for"
+				pr_err("fc_vport_create() failed for"
 						" NPIV tcm_qla2xxx\n");
 				scsi_host_put(host);
 				ret = -EINVAL;
@@ -1301,7 +1301,7 @@ static int tcm_qla2xxx_register_configfs(void)
 	struct target_fabric_configfs *fabric, *npiv_fabric;
 	int ret;
 
-	printk(KERN_INFO "TCM QLOGIC QLA2XXX fabric module %s on %s/%s"
+	pr_debug("TCM QLOGIC QLA2XXX fabric module %s on %s/%s"
 		" on "UTS_RELEASE"\n", TCM_QLA2XXX_VERSION, utsname()->sysname,
 		utsname()->machine);
 	/*
@@ -1309,7 +1309,7 @@ static int tcm_qla2xxx_register_configfs(void)
 	 */
 	fabric = target_fabric_configfs_init(THIS_MODULE, "qla2xxx");
 	if (!(fabric)) {
-		printk(KERN_ERR "target_fabric_configfs_init() failed\n");
+		pr_err("target_fabric_configfs_init() failed\n");
 		return -ENOMEM;
 	}
 	/*
@@ -1337,7 +1337,7 @@ static int tcm_qla2xxx_register_configfs(void)
 	 */
 	ret = target_fabric_configfs_register(fabric);
 	if (ret < 0) {
-		printk(KERN_ERR "target_fabric_configfs_register() failed"
+		pr_err("target_fabric_configfs_register() failed"
 				" for TCM_QLA2XXX\n");
 		return ret;
 	}
@@ -1345,14 +1345,14 @@ static int tcm_qla2xxx_register_configfs(void)
 	 * Setup our local pointer to *fabric
 	 */
 	tcm_qla2xxx_fabric_configfs = fabric;	
-	printk(KERN_INFO "TCM_QLA2XXX[0] - Set fabric -> tcm_qla2xxx_fabric_configfs\n");
+	pr_debug("TCM_QLA2XXX[0] - Set fabric -> tcm_qla2xxx_fabric_configfs\n");
 
 	/*
 	 * Register the top level struct config_item_type for NPIV with TCM core
 	 */
 	npiv_fabric = target_fabric_configfs_init(THIS_MODULE, "qla2xxx_npiv");
 	if (!(npiv_fabric)) {
-		printk(KERN_ERR "target_fabric_configfs_init() failed\n");
+		pr_err("target_fabric_configfs_init() failed\n");
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -1377,7 +1377,7 @@ static int tcm_qla2xxx_register_configfs(void)
 	 */
 	ret = target_fabric_configfs_register(npiv_fabric);
 	if (ret < 0) {
-		printk(KERN_ERR "target_fabric_configfs_register() failed"
+		pr_err("target_fabric_configfs_register() failed"
 				" for TCM_QLA2XXX\n");
 		goto out;;
 	}
@@ -1385,7 +1385,7 @@ static int tcm_qla2xxx_register_configfs(void)
 	 * Setup our local pointer to *npiv_fabric
 	 */
 	tcm_qla2xxx_npiv_fabric_configfs = npiv_fabric;
-	printk(KERN_INFO "TCM_QLA2XXX[0] - Set fabric -> tcm_qla2xxx_npiv_fabric_configfs\n");
+	pr_debug("TCM_QLA2XXX[0] - Set fabric -> tcm_qla2xxx_npiv_fabric_configfs\n");
 
 	return 0;
 out:
@@ -1402,11 +1402,11 @@ static void tcm_qla2xxx_deregister_configfs(void)
 
 	target_fabric_configfs_deregister(tcm_qla2xxx_fabric_configfs);
 	tcm_qla2xxx_fabric_configfs = NULL;
-	printk(KERN_INFO "TCM_QLA2XXX[0] - Cleared tcm_qla2xxx_fabric_configfs\n");
+	pr_debug("TCM_QLA2XXX[0] - Cleared tcm_qla2xxx_fabric_configfs\n");
 
 	target_fabric_configfs_deregister(tcm_qla2xxx_npiv_fabric_configfs);
 	tcm_qla2xxx_npiv_fabric_configfs = NULL;
-	printk(KERN_INFO "TCM_QLA2XXX[0] - Cleared tcm_qla2xxx_npiv_fabric_configfs\n");
+	pr_debug("TCM_QLA2XXX[0] - Cleared tcm_qla2xxx_npiv_fabric_configfs\n");
 }
 
 static int __init tcm_qla2xxx_init(void)
diff --git a/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c
index 4dacc1d..9055366 100644
--- a/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c
+++ b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c
@@ -106,7 +106,7 @@ ssize_t tcm_qla2xxx_parse_wwn(const char *name, u64 *wwn, int strict)
 	}
 	err = 4;
 fail:
-	printk(KERN_INFO "err %u len %zu pos %u byte %u\n",
+	pr_debug("err %u len %zu pos %u byte %u\n",
 			err, cp - name, pos, byte);
 	return -1;
 }
@@ -358,7 +358,7 @@ struct se_node_acl *tcm_qla2xxx_alloc_fabric_acl(struct se_portal_group *se_tpg)
 
 	nacl = kzalloc(sizeof(struct tcm_qla2xxx_nacl), GFP_KERNEL);
 	if (!(nacl)) {
-		printk(KERN_ERR "Unable to alocate struct tcm_qla2xxx_nacl\n");
+		pr_err("Unable to alocate struct tcm_qla2xxx_nacl\n");
 		return NULL;
 	}
 
@@ -427,7 +427,7 @@ void tcm_qla2xxx_release_cmd(struct se_cmd *se_cmd)
 		return;
 
 	while (atomic_read(&cmd->cmd_stop_free) != 1) {
-		printk(KERN_WARNING "Hit atomic_read(&cmd->cmd_stop_free)=1"
+		pr_warn("Hit atomic_read(&cmd->cmd_stop_free)=1"
 				" in tcm_qla2xxx_release_cmd\n");
 		cpu_relax();
 	}
@@ -440,7 +440,7 @@ int tcm_qla2xxx_shutdown_session(struct se_session *se_sess)
 	struct qla_tgt_sess *sess = se_sess->fabric_sess_ptr;
 
 	if (!sess) {
-		printk("se_sess->fabric_sess_ptr is NULL\n");
+		pr_err("se_sess->fabric_sess_ptr is NULL\n");
 		dump_stack();
 		return 0;
 	}
@@ -457,7 +457,7 @@ void tcm_qla2xxx_close_session(struct se_session *se_sess)
 	unsigned long flags;
 
 	if (!sess) {
-		printk(KERN_ERR "se_sess->fabric_sess_ptr is NULL\n");
+		pr_err("se_sess->fabric_sess_ptr is NULL\n");
 		dump_stack();
 		return;
 	}
@@ -476,7 +476,7 @@ void tcm_qla2xxx_stop_session(struct se_session *se_sess, int sess_sleep , int c
 	unsigned long flags;
 
 	if (!sess) {
-		printk(KERN_ERR "se_sess->fabric_sess_ptr is NULL\n");
+		pr_err("se_sess->fabric_sess_ptr is NULL\n");
 		dump_stack();
 		return;
 	}
@@ -518,7 +518,7 @@ int tcm_qla2xxx_write_pending(struct se_cmd *se_cmd)
 		cmd->sg_cnt = se_cmd->t_tasks_sg_chained_no;
 		cmd->sg = se_cmd->t_tasks_sg_chained;
 	} else {
-		printk(KERN_ERR "Unknown se_cmd_flags: 0x%08x in"
+		pr_err("Unknown se_cmd_flags: 0x%08x in"
 			" tcm_qla2xxx_write_pending()\n", se_cmd->se_cmd_flags);
 		BUG();
 	}
@@ -566,13 +566,13 @@ int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 
 	sess = cmd->sess;
 	if (!sess) {
-		printk(KERN_ERR "Unable to locate struct qla_tgt_sess from qla_tgt_cmd\n");
+		pr_err("Unable to locate struct qla_tgt_sess from qla_tgt_cmd\n");
 		return -EINVAL;
 	}
 
 	se_sess = sess->se_sess;
 	if (!se_sess) {
-		printk(KERN_ERR "Unable to locate active struct se_session\n");
+		pr_err("Unable to locate active struct se_session\n");
 		return -EINVAL;
 	}
 	se_tpg = se_sess->se_tpg;
@@ -756,7 +756,7 @@ int tcm_qla2xxx_queue_tm_rsp(struct se_cmd *se_cmd)
 	struct qla_tgt_mgmt_cmd *mcmd = container_of(se_cmd,
 				struct qla_tgt_mgmt_cmd, se_cmd);
 
-	printk("queue_tm_rsp: mcmd: %p func: 0x%02x response: 0x%02x\n",
+	pr_debug("queue_tm_rsp: mcmd: %p func: 0x%02x response: 0x%02x\n",
 			mcmd, se_tmr->function, se_tmr->response);
 	/*
 	 * Do translation between TCM TM response codes and
diff --git a/drivers/target/tcm_vhost/tcm_vhost_configfs.c b/drivers/target/tcm_vhost/tcm_vhost_configfs.c
index 6ef5cf0..2230dc3 100644
--- a/drivers/target/tcm_vhost/tcm_vhost_configfs.c
+++ b/drivers/target/tcm_vhost/tcm_vhost_configfs.c
@@ -153,7 +153,7 @@ static int tcm_vhost_make_nexus(
 	mutex_lock(&tv_tpg->tv_tpg_mutex);
 	if (tv_tpg->tpg_nexus) {
 		mutex_unlock(&tv_tpg->tv_tpg_mutex);
-		printk(KERN_INFO "tv_tpg->tpg_nexus already exists\n");
+		pr_debug("tv_tpg->tpg_nexus already exists\n");
 		return -EEXIST;
 	}
 	se_tpg = &tv_tpg->se_tpg;
@@ -161,7 +161,7 @@ static int tcm_vhost_make_nexus(
 	tv_nexus = kzalloc(sizeof(struct tcm_vhost_nexus), GFP_KERNEL);
 	if (!tv_nexus) {
 		mutex_unlock(&tv_tpg->tv_tpg_mutex);
-		printk(KERN_ERR "Unable to allocate struct tcm_vhost_nexus\n");
+		pr_err("Unable to allocate struct tcm_vhost_nexus\n");
 		return -ENOMEM;
 	}
 	/*
@@ -182,7 +182,7 @@ static int tcm_vhost_make_nexus(
 				se_tpg, (unsigned char *)name);
 	if (!tv_nexus->tvn_se_sess->se_node_acl) {
 		mutex_unlock(&tv_tpg->tv_tpg_mutex);
-		printk(KERN_INFO "core_tpg_check_initiator_node_acl() failed"
+		pr_debug("core_tpg_check_initiator_node_acl() failed"
 				" for %s\n", name);
 		transport_free_session(tv_nexus->tvn_se_sess);
 		kfree(tv_nexus);
@@ -221,20 +221,20 @@ static int tcm_vhost_drop_nexus(
 
 	if (atomic_read(&tpg->tv_tpg_port_count)) {
 		mutex_unlock(&tpg->tv_tpg_mutex);
-		printk(KERN_ERR "Unable to remove TCM_vHost I_T Nexus with"
+		pr_err("Unable to remove TCM_vHost I_T Nexus with"
 			" active TPG port count: %d\n",
 			atomic_read(&tpg->tv_tpg_port_count));
 		return -EPERM;
 	}
 
 	if (atomic_read(&tpg->tv_tpg_vhost_count)) {
-		printk(KERN_ERR "Unable to remove TCM_vHost I_T Nexus with"
+		pr_err("Unable to remove TCM_vHost I_T Nexus with"
 			" active TPG vhost count: %d\n",
 			atomic_read(&tpg->tv_tpg_vhost_count));
 		return -EPERM;
 	}
 
-	printk(KERN_INFO "TCM_vHost_ConfigFS: Removing I_T Nexus to emulated"
+	pr_debug("TCM_vHost_ConfigFS: Removing I_T Nexus to emulated"
 		" %s Initiator Port: %s\n", tcm_vhost_dump_proto_id(tpg->tport),
 		tv_nexus->tvn_se_sess->se_node_acl->initiatorname);
 	/*
@@ -293,7 +293,7 @@ static ssize_t tcm_vhost_tpg_store_nexus(
 	 * tcm_vhost_make_nexus().
 	 */
 	if (strlen(page) > TCM_VHOST_NAMELEN) {
-		printk(KERN_ERR "Emulated NAA Sas Address: %s, exceeds"
+		pr_err("Emulated NAA Sas Address: %s, exceeds"
 				" max: %d\n", page, TCM_VHOST_NAMELEN);
 		return -EINVAL;
 	}
@@ -302,7 +302,7 @@ static ssize_t tcm_vhost_tpg_store_nexus(
 	ptr = strstr(i_port, "naa.");
 	if (ptr) {
 		if (tport_wwn->tport_proto_id != SCSI_PROTOCOL_SAS) {
-			printk(KERN_ERR "Passed SAS Initiator Port %s does not"
+			pr_err("Passed SAS Initiator Port %s does not"
 				" match target port protoid: %s\n", i_port,
 				tcm_vhost_dump_proto_id(tport_wwn));
 			return -EINVAL;
@@ -313,7 +313,7 @@ static ssize_t tcm_vhost_tpg_store_nexus(
 	ptr = strstr(i_port, "fc.");
 	if (ptr) {
 		if (tport_wwn->tport_proto_id != SCSI_PROTOCOL_FCP) {
-			printk(KERN_ERR "Passed FCP Initiator Port %s does not"
+			pr_err("Passed FCP Initiator Port %s does not"
 				" match target port protoid: %s\n", i_port,
 				tcm_vhost_dump_proto_id(tport_wwn));
 			return -EINVAL;
@@ -324,7 +324,7 @@ static ssize_t tcm_vhost_tpg_store_nexus(
 	ptr = strstr(i_port, "iqn.");
 	if (ptr) {
 		if (tport_wwn->tport_proto_id != SCSI_PROTOCOL_ISCSI) {
-			printk(KERN_ERR "Passed iSCSI Initiator Port %s does not"
+			pr_err("Passed iSCSI Initiator Port %s does not"
 				" match target port protoid: %s\n", i_port,
 				tcm_vhost_dump_proto_id(tport_wwn));
 			return -EINVAL;
@@ -332,7 +332,7 @@ static ssize_t tcm_vhost_tpg_store_nexus(
 		port_ptr = &i_port[0];
 		goto check_newline;
 	}
-	printk(KERN_ERR "Unable to locate prefix for emulated Initiator Port:"
+	pr_err("Unable to locate prefix for emulated Initiator Port:"
 			" %s\n", i_port);
 	return -EINVAL;
 	/*
@@ -384,7 +384,7 @@ static ssize_t tcm_vhost_tpg_store_dev_index(
 	tv_nexus = tv_tpg->tpg_nexus;
 	if (!tv_nexus) {
 		mutex_unlock(&tv_tpg->tv_tpg_mutex);
-		printk(KERN_INFO "No active tcm_vhost_nexus exists for"
+		pr_debug("No active tcm_vhost_nexus exists for"
 				" this TPG\n");
 		return -ENODEV;
 	}
@@ -394,7 +394,7 @@ static ssize_t tcm_vhost_tpg_store_dev_index(
 	if (!strncmp(page, "NULL", 4)) {
 		if (!tv_nexus->tvn_dev_index) {
 			mutex_unlock(&tv_tpg->tv_tpg_mutex);
-			printk(KERN_INFO "No active tvn_dev_index association"
+			pr_debug("No active tvn_dev_index association"
 					" exists\n");
 			return -ENODEV;
 		}
@@ -419,7 +419,7 @@ static ssize_t tcm_vhost_tpg_store_dev_index(
 	 */
 	ret = strict_strtoul(page, 0, &dev_index);
 	if (ret < 0) {
-		printk(KERN_ERR "strict_strtoul() returned %d for"
+		pr_err("strict_strtoul() returned %d for"
 				" dev_index\n", ret);
 		mutex_unlock(&tv_tpg->tv_tpg_mutex);
 		return -EINVAL;
@@ -468,7 +468,7 @@ static struct se_portal_group *tcm_vhost_make_tpg(
 
 	tpg = kzalloc(sizeof(struct tcm_vhost_tpg), GFP_KERNEL);
 	if (!(tpg)) {
-		printk(KERN_ERR "Unable to allocate struct tcm_vhost_tpg");
+		pr_err("Unable to allocate struct tcm_vhost_tpg");
 		return ERR_PTR(-ENOMEM);
 	}
 	mutex_init(&tpg->tv_tpg_mutex);
@@ -524,7 +524,7 @@ static struct se_wwn *tcm_vhost_make_tport(
 
 	tport = kzalloc(sizeof(struct tcm_vhost_tport), GFP_KERNEL);
 	if (!(tport)) {
-		printk(KERN_ERR "Unable to allocate struct tcm_vhost_tport");
+		pr_err("Unable to allocate struct tcm_vhost_tport");
 		return ERR_PTR(-ENOMEM);
 	}
 	tport->tport_wwpn = wwpn;
@@ -550,13 +550,13 @@ static struct se_wwn *tcm_vhost_make_tport(
 		goto check_len;
 	}
 
-	printk(KERN_ERR "Unable to locate prefix for emulated Target Port:"
+	pr_err("Unable to locate prefix for emulated Target Port:"
 			" %s\n", name);
 	return ERR_PTR(-EINVAL);
 
 check_len:
 	if (strlen(name) > TCM_VHOST_NAMELEN) {
-		printk(KERN_ERR "Emulated %s Address: %s, exceeds"
+		pr_err("Emulated %s Address: %s, exceeds"
 			" max: %d\n", name, tcm_vhost_dump_proto_id(tport),
 			TCM_VHOST_NAMELEN);
 		kfree(tport);
@@ -564,7 +564,7 @@ check_len:
 	}
 	snprintf(&tport->tport_name[0], TCM_VHOST_NAMELEN, "%s", &name[off]);
 
-	printk(KERN_INFO "TCM_VHost_ConfigFS: Allocated emulated Target"
+	pr_debug("TCM_VHost_ConfigFS: Allocated emulated Target"
 		" %s Address: %s\n", tcm_vhost_dump_proto_id(tport), name);
 
 	return &tport->tport_wwn;
@@ -575,7 +575,7 @@ static void tcm_vhost_drop_tport(struct se_wwn *wwn)
 	struct tcm_vhost_tport *tport = container_of(wwn,
 				struct tcm_vhost_tport, tport_wwn);
 
-	printk(KERN_INFO "TCM_VHost_ConfigFS: Deallocating emulated Target"
+	pr_debug("TCM_VHost_ConfigFS: Deallocating emulated Target"
 		" %s Address: %s\n", tcm_vhost_dump_proto_id(tport),
 		config_item_name(&wwn->wwn_group.cg_item));
 
@@ -654,7 +654,7 @@ static int tcm_vhost_register_configfs(void)
 	struct target_fabric_configfs *fabric;
 	int ret;
 
-	printk(KERN_INFO "TCM_VHOST fabric module %s on %s/%s"
+	pr_debug("TCM_VHOST fabric module %s on %s/%s"
 		" on "UTS_RELEASE"\n",TCM_VHOST_VERSION, utsname()->sysname,
 		utsname()->machine);
 	/*
@@ -662,7 +662,7 @@ static int tcm_vhost_register_configfs(void)
 	 */
 	fabric = target_fabric_configfs_init(THIS_MODULE, "vhost");
 	if (!(fabric)) {
-		printk(KERN_ERR "target_fabric_configfs_init() failed\n");
+		pr_err("target_fabric_configfs_init() failed\n");
 		return -ENOMEM;
 	}
 	/*
@@ -686,7 +686,7 @@ static int tcm_vhost_register_configfs(void)
 	 */
 	ret = target_fabric_configfs_register(fabric);
 	if (ret < 0) {
-		printk(KERN_ERR "target_fabric_configfs_register() failed"
+		pr_err("target_fabric_configfs_register() failed"
 				" for TCM_VHOST\n");
 		return ret;
 	}
@@ -694,7 +694,7 @@ static int tcm_vhost_register_configfs(void)
 	 * Setup our local pointer to *fabric
 	 */
 	tcm_vhost_fabric_configfs = fabric;
-	printk(KERN_INFO "TCM_VHOST[0] - Set fabric -> tcm_vhost_fabric_configfs\n");
+	pr_debug("TCM_VHOST[0] - Set fabric -> tcm_vhost_fabric_configfs\n");
 	return 0;
 };
 
@@ -705,7 +705,7 @@ static void tcm_vhost_deregister_configfs(void)
 
 	target_fabric_configfs_deregister(tcm_vhost_fabric_configfs);
 	tcm_vhost_fabric_configfs = NULL;
-	printk(KERN_INFO "TCM_VHOST[0] - Cleared tcm_vhost_fabric_configfs\n");
+	pr_debug("TCM_VHOST[0] - Cleared tcm_vhost_fabric_configfs\n");
 };
 
 static int __init tcm_vhost_init(void)
diff --git a/drivers/target/tcm_vhost/tcm_vhost_fabric.c b/drivers/target/tcm_vhost/tcm_vhost_fabric.c
index e9e0e6a..286c719 100644
--- a/drivers/target/tcm_vhost/tcm_vhost_fabric.c
+++ b/drivers/target/tcm_vhost/tcm_vhost_fabric.c
@@ -76,7 +76,7 @@ u8 tcm_vhost_get_fabric_proto_ident(struct se_portal_group *se_tpg)
 	case SCSI_PROTOCOL_ISCSI:
 		return iscsi_get_fabric_proto_ident(se_tpg);
 	default:
-		printk(KERN_ERR "Unknown tport_proto_id: 0x%02x, using"
+		pr_err("Unknown tport_proto_id: 0x%02x, using"
 			" SAS emulation\n", tport->tport_proto_id);
 		break;
 	}
@@ -127,7 +127,7 @@ u32 tcm_vhost_get_pr_transport_id(
 		return iscsi_get_pr_transport_id(se_tpg, se_nacl, pr_reg,
 					format_code, buf);
 	default:
-		printk(KERN_ERR "Unknown tport_proto_id: 0x%02x, using"
+		pr_err("Unknown tport_proto_id: 0x%02x, using"
 			" SAS emulation\n", tport->tport_proto_id);
 		break;	
 	}
@@ -157,7 +157,7 @@ u32 tcm_vhost_get_pr_transport_id_len(
 		return iscsi_get_pr_transport_id_len(se_tpg, se_nacl, pr_reg,
 					format_code);
 	default:
-		printk(KERN_ERR "Unknown tport_proto_id: 0x%02x, using"
+		pr_err("Unknown tport_proto_id: 0x%02x, using"
 			" SAS emulation\n", tport->tport_proto_id);
 		break;
 	}
@@ -187,7 +187,7 @@ char *tcm_vhost_parse_pr_out_transport_id(
 		return iscsi_parse_pr_out_transport_id(se_tpg, buf, out_tid_len,
 					port_nexus_ptr);
 	default:
-		printk(KERN_ERR "Unknown tport_proto_id: 0x%02x, using"
+		pr_err("Unknown tport_proto_id: 0x%02x, using"
 			" SAS emulation\n", tport->tport_proto_id);
 		break;
 	}
@@ -202,7 +202,7 @@ struct se_node_acl *tcm_vhost_alloc_fabric_acl(struct se_portal_group *se_tpg)
 
 	nacl = kzalloc(sizeof(struct tcm_vhost_nacl), GFP_KERNEL);
 	if (!(nacl)) {
-		printk(KERN_ERR "Unable to alocate struct tcm_vhost_nacl\n");
+		pr_err("Unable to alocate struct tcm_vhost_nacl\n");
 		return NULL;
 	}
 
diff --git a/drivers/target/tcm_vhost/tcm_vhost_scsi.c b/drivers/target/tcm_vhost/tcm_vhost_scsi.c
index 45e4dd7..691c45b 100644
--- a/drivers/target/tcm_vhost/tcm_vhost_scsi.c
+++ b/drivers/target/tcm_vhost/tcm_vhost_scsi.c
@@ -52,14 +52,14 @@ static struct tcm_vhost_cmd *vhost_scsi_allocate_cmd(
 
 	tv_nexus = tv_tpg->tpg_nexus;
 	if (!tv_nexus) {
-		printk(KERN_ERR "Unable to locate active struct tcm_vhost_nexus\n");
+		pr_err("Unable to locate active struct tcm_vhost_nexus\n");
 		return ERR_PTR(-EIO);
 	}
 	se_sess = tv_nexus->tvn_se_sess;
 
 	tv_cmd = kzalloc(sizeof(struct tcm_vhost_cmd), GFP_ATOMIC);
 	if (!tv_cmd) {
-		printk(KERN_ERR "Unable to allocate struct tcm_vhost_cmd\n");
+		pr_err("Unable to allocate struct tcm_vhost_cmd\n");
 		return ERR_PTR(-ENOMEM);
 	}
 	tv_cmd->tvc_tag = v_header->tag;
@@ -144,7 +144,7 @@ static void vhost_scsi_handle_vq(struct vhost_scsi *vs)
 		 * hardcoded max for t
 		 */
 		if (scsi_command_size(cdb) > TCM_VHOST_MAX_CDB_SIZE) {
-			printk(KERN_ERR "Received SCSI CDB with command_size:"
+			pr_err("Received SCSI CDB with command_size:"
 				" %d that exceeds SCSI_MAX_VARLEN_CDB_SIZE: %d\n",
 				scsi_command_size(cdb), TCM_VHOST_MAX_CDB_SIZE);
 			break;
@@ -294,7 +294,7 @@ static int vhost_scsi_clear_endpoint(
 	if (strcmp(tv_tport->tport_name, t->vhost_wwpn) ||
 	    (tv_tpg->tport_tpgt != t->vhost_tpgt)) {
 		mutex_unlock(&vq->mutex);
-		printk(KERN_WARNING "tv_tport->tport_name: %s, tv_tpg->tport_tpgt: %hu"
+		pr_warn("tv_tport->tport_name: %s, tv_tpg->tport_tpgt: %hu"
 			" does not match t->vhost_wwpn: %s, t->vhost_tpgt: %hu\n",
 			tv_tport->tport_name, tv_tpg->tport_tpgt,
 			t->vhost_wwpn, t->vhost_tpgt);
-- 
1.7.1

