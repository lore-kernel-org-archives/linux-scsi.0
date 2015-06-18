From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/8] tcm_loop: Add SAS transport topology
Date: Thu, 18 Jun 2015 11:43:36 +0200
Message-ID: <1434620622-65391-3-git-send-email-hare@suse.de>
References: <1434620622-65391-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1434620622-65391-1-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

As tcm_loop emulates a SAS HBA it should not only
attach to the SAS transport template but also
populate the SAS device hierarchy.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/loopback/tcm_loop.c | 139 ++++++++++++++++++++++++++++++++-----
 drivers/target/loopback/tcm_loop.h |   3 +
 2 files changed, 125 insertions(+), 17 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 45ae3e4..7d436db 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -439,6 +439,9 @@ static int tcm_loop_driver_remove(struct device *dev)
 	tl_hba = to_tcm_loop_hba(dev);
 	sh = tl_hba->sh;
 
+	if (tl_hba->tl_proto_id == SCSI_PROTOCOL_SAS)
+		sas_remove_host(sh);
+
 	scsi_remove_host(sh);
 	scsi_host_put(sh);
 	return 0;
@@ -729,10 +732,18 @@ static int tcm_loop_port_link(
 	struct tcm_loop_hba *tl_hba = tl_tpg->tl_hba;
 
 	atomic_inc_mb(&tl_tpg->tl_tpg_port_count);
-	/*
-	 * Add Linux/SCSI struct scsi_device by HCTL
-	 */
-	scsi_add_device(tl_hba->sh, 0, tl_tpg->tl_tpgt, lun->unpacked_lun);
+	if (tl_hba->tl_proto_id != SCSI_PROTOCOL_SAS) {
+		/*
+		 * Add Linux/SCSI struct scsi_device by HCTL
+		 */
+		scsi_add_device(tl_hba->sh, 0,
+				tl_tpg->tl_tpgt, lun->unpacked_lun);
+	} else {
+		struct sas_rphy *rphy = tl_tpg->sas_rphy;
+
+		scsi_scan_target(&rphy->dev, 0, rphy->scsi_target_id,
+				 lun->unpacked_lun, 0);
+	}
 
 	pr_debug("TCM_Loop_ConfigFS: Port Link Successful\n");
 	return 0;
@@ -749,19 +760,21 @@ static void tcm_loop_port_unlink(
 	tl_tpg = container_of(se_tpg, struct tcm_loop_tpg, tl_se_tpg);
 	tl_hba = tl_tpg->tl_hba;
 
-	sd = scsi_device_lookup(tl_hba->sh, 0, tl_tpg->tl_tpgt,
-				se_lun->unpacked_lun);
-	if (!sd) {
-		pr_err("Unable to locate struct scsi_device for %d:%d:"
-			"%llu\n", 0, tl_tpg->tl_tpgt, se_lun->unpacked_lun);
-		return;
+	if (tl_hba->tl_proto_id != SCSI_PROTOCOL_SAS) {
+		sd = scsi_device_lookup(tl_hba->sh, 0, tl_tpg->tl_tpgt,
+					se_lun->unpacked_lun);
+		if (!sd) {
+			pr_err("Unable to locate struct scsi_device for %d:%d:"
+			       "%llu\n", 0, tl_tpg->tl_tpgt,
+			       se_lun->unpacked_lun);
+			return;
+		}
+		/*
+		 * Remove Linux/SCSI struct scsi_device by HCTL
+		 */
+		scsi_remove_device(sd);
+		scsi_device_put(sd);
 	}
-	/*
-	 * Remove Linux/SCSI struct scsi_device by HCTL
-	 */
-	scsi_remove_device(sd);
-	scsi_device_put(sd);
-
 	atomic_dec_mb(&tl_tpg->tl_tpg_port_count);
 
 	pr_debug("TCM_Loop_ConfigFS: Port Unlink Successful\n");
@@ -858,6 +871,33 @@ static int tcm_loop_make_nexus(
 	pr_debug("TCM_Loop_ConfigFS: Established I_T Nexus to emulated"
 		" %s Initiator Port: %s\n", tcm_loop_dump_proto_id(tl_hba),
 		name);
+
+	if (tl_hba->tl_proto_id == SCSI_PROTOCOL_SAS) {
+		struct Scsi_Host *sh = tl_hba->sh;
+		u64 sas_address;
+
+		if (kstrtoull(name, 16, &sas_address)) {
+			pr_err("Invalid SAS address %s\n", name);
+			return -ENODEV;
+		}
+		tl_nexus->sas_phy = sas_phy_alloc(&sh->shost_gendev,
+						  tl_tpg->tl_tpgt);
+		if (!tl_nexus->sas_phy) {
+			pr_err("Unable to allocate SAS host phy\n");
+			return -ENOMEM;
+		}
+		tl_nexus->sas_phy->identify.sas_address = sas_address;
+		tl_nexus->sas_phy->identify.phy_identifier = 0;
+		tl_nexus->sas_phy->identify.device_type = SAS_END_DEVICE;
+		tl_nexus->sas_phy->identify.initiator_port_protocols = SAS_PROTOCOL_STP|SAS_PROTOCOL_SMP;
+		if (sas_phy_add(tl_nexus->sas_phy)) {
+			sas_phy_free(tl_nexus->sas_phy);
+			tl_nexus->sas_phy = NULL;
+			pr_err("Unable to add SAS host phy\n");
+			return -ENODEV;
+		}
+		sas_port_add_phy(tl_tpg->sas_port, tl_nexus->sas_phy);
+	}
 	return 0;
 
 out:
@@ -886,6 +926,13 @@ static int tcm_loop_drop_nexus(
 		return -EPERM;
 	}
 
+	if (tl_nexus->sas_phy) {
+		sas_port_delete_phy(tpg->sas_port, tl_nexus->sas_phy);
+		sas_phy_delete(tl_nexus->sas_phy);
+		sas_phy_free(tl_nexus->sas_phy);
+		tl_nexus->sas_phy = NULL;
+	}
+
 	pr_debug("TCM_Loop_ConfigFS: Removing I_T Nexus to emulated"
 		" %s Initiator Port: %s\n", tcm_loop_dump_proto_id(tpg->tl_hba),
 		tl_nexus->se_sess->se_node_acl->initiatorname);
@@ -956,7 +1003,7 @@ static ssize_t tcm_loop_tpg_store_nexus(
 				tcm_loop_dump_proto_id(tl_hba));
 			return -EINVAL;
 		}
-		port_ptr = &i_port[0];
+		port_ptr = &i_port[4];
 		goto check_newline;
 	}
 	ptr = strstr(i_port, "fc.");
@@ -1089,6 +1136,48 @@ static struct se_portal_group *tcm_loop_make_naa_tpg(
 	if (ret < 0)
 		return ERR_PTR(-ENOMEM);
 
+	if (tl_hba->tl_proto_id == SCSI_PROTOCOL_SAS) {
+		struct Scsi_Host *sh = tl_hba->sh;
+		u64 sas_address;
+
+		tl_tpg->sas_port = sas_port_alloc(&sh->shost_gendev, tpgt);
+		if (!tl_tpg->sas_port) {
+			pr_err("Unable to allocate SAS port %ld\n", tpgt);
+			return ERR_PTR(-ENOMEM);
+		}
+		if ((sas_port_add(tl_tpg->sas_port))) {
+			sas_port_free(tl_tpg->sas_port);
+			tl_tpg->sas_port = NULL;
+			pr_err("Unable to add SAS port %ld\n", tpgt);
+			return ERR_PTR(-ENODEV);
+		}
+		if (kstrtoull(tl_hba->tl_wwn_address, 16, &sas_address)) {
+			pr_err("Invalid SAS address %s\n",
+			       tl_hba->tl_wwn_address);
+			sas_port_free(tl_tpg->sas_port);
+			tl_tpg->sas_port = NULL;
+			return ERR_PTR(-ENODEV);
+		}
+		tl_tpg->sas_rphy = sas_end_device_alloc(tl_tpg->sas_port);
+		if (!tl_tpg->sas_rphy) {
+			pr_err("Unable to allocate SAS end device\n");
+			sas_port_free(tl_tpg->sas_port);
+			tl_tpg->sas_port = NULL;
+			return ERR_PTR(-ENOMEM);
+		}
+		tl_tpg->sas_rphy->identify.sas_address = sas_address;
+		tl_tpg->sas_rphy->identify.phy_identifier = 0;
+		tl_tpg->sas_rphy->identify.device_type = SAS_END_DEVICE;
+		tl_tpg->sas_rphy->identify.target_port_protocols = SAS_PROTOCOL_STP|SAS_PROTOCOL_SMP;
+		if (sas_rphy_add(tl_tpg->sas_rphy)) {
+			sas_rphy_free(tl_tpg->sas_rphy);
+			tl_tpg->sas_rphy = NULL;
+			sas_port_free(tl_tpg->sas_port);
+			tl_tpg->sas_port = NULL;
+			pr_err("Unable to add SAS target phy\n");
+			return ERR_PTR(-ENODEV);
+		}
+	}
 	pr_debug("TCM_Loop_ConfigFS: Allocated Emulated %s"
 		" Target Port %s,t,0x%04lx\n", tcm_loop_dump_proto_id(tl_hba),
 		config_item_name(&wwn->wwn_group.cg_item), tpgt);
@@ -1107,10 +1196,25 @@ static void tcm_loop_drop_naa_tpg(
 
 	tl_hba = tl_tpg->tl_hba;
 	tpgt = tl_tpg->tl_tpgt;
+
+	if (tl_hba->tl_proto_id == SCSI_PROTOCOL_SAS)
+		sas_rphy_delete(tl_tpg->sas_rphy);
+
 	/*
 	 * Release the I_T Nexus for the Virtual SAS link if present
 	 */
 	tcm_loop_drop_nexus(tl_tpg);
+
+	if (tl_tpg->sas_rphy) {
+		sas_rphy_delete(tl_tpg->sas_rphy);
+		tl_tpg->sas_rphy = NULL;
+	}
+
+	if (tl_tpg->sas_port) {
+		sas_port_free(tl_tpg->sas_port);
+		tl_tpg->sas_port = NULL;
+	}
+
 	/*
 	 * Deregister the tl_tpg as a emulated SAS TCM Target Endpoint
 	 */
@@ -1150,6 +1254,7 @@ static struct se_wwn *tcm_loop_make_scsi_hba(
 	ptr = strstr(name, "naa.");
 	if (ptr) {
 		tl_hba->tl_proto_id = SCSI_PROTOCOL_SAS;
+		off = 4; /* Skip over "naa." */
 		goto check_len;
 	}
 	ptr = strstr(name, "fc.");
diff --git a/drivers/target/loopback/tcm_loop.h b/drivers/target/loopback/tcm_loop.h
index 4346462..2d4c22d 100644
--- a/drivers/target/loopback/tcm_loop.h
+++ b/drivers/target/loopback/tcm_loop.h
@@ -26,6 +26,7 @@ struct tcm_loop_nexus {
 	 * Pointer to TCM session for I_T Nexus
 	 */
 	struct se_session *se_sess;
+	struct sas_phy *sas_phy;
 };
 
 #define TCM_TRANSPORT_ONLINE 0
@@ -39,6 +40,8 @@ struct tcm_loop_tpg {
 	struct se_portal_group tl_se_tpg;
 	struct tcm_loop_hba *tl_hba;
 	struct tcm_loop_nexus *tl_nexus;
+	struct sas_port *sas_port;
+	struct sas_rphy *sas_rphy;
 };
 
 struct tcm_loop_hba {
-- 
1.8.5.2
