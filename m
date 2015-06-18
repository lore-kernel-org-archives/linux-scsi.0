From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/8] tcm_loop: Remove SAS vestigies
Date: Thu, 18 Jun 2015 11:43:37 +0200
Message-ID: <1434620622-65391-4-git-send-email-hare@suse.de>
References: <1434620622-65391-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54707 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963AbbFRJnp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Jun 2015 05:43:45 -0400
In-Reply-To: <1434620622-65391-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>

tcm_loop is able to emulate several protocols, so remove last
vestigies of the SAS protocol.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/loopback/tcm_loop.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 7d436db..d77caf5 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -535,7 +535,7 @@ static inline struct tcm_loop_tpg *tl_tpg(struct se_portal_group *se_tpg)
 static char *tcm_loop_get_endpoint_wwn(struct se_portal_group *se_tpg)
 {
 	/*
-	 * Return the passed NAA identifier for the SAS Target Port
+	 * Return the passed NAA identifier for the Target Port
 	 */
 	return &tl_tpg(se_tpg)->tl_hba->tl_wwn_address[0];
 }
@@ -864,7 +864,7 @@ static int tcm_loop_make_nexus(
 		transport_free_session(tl_nexus->se_sess);
 		goto out;
 	}
-	/* Now, register the SAS I_T Nexus as active. */
+	/* Now, register the I_T Nexus as active. */
 	transport_register_session(se_tpg, tl_nexus->se_sess->se_node_acl,
 			tl_nexus->se_sess, tl_nexus);
 	tl_tpg->tl_nexus = tl_nexus;
@@ -937,7 +937,7 @@ static int tcm_loop_drop_nexus(
 		" %s Initiator Port: %s\n", tcm_loop_dump_proto_id(tpg->tl_hba),
 		tl_nexus->se_sess->se_node_acl->initiatorname);
 	/*
-	 * Release the SCSI I_T Nexus to the emulated SAS Target Port
+	 * Release the SCSI I_T Nexus to the emulated Target Port
 	 */
 	transport_deregister_session(tl_nexus->se_sess);
 	tpg->tl_nexus = NULL;
@@ -1130,7 +1130,7 @@ static struct se_portal_group *tcm_loop_make_naa_tpg(
 	tl_tpg->tl_hba = tl_hba;
 	tl_tpg->tl_tpgt = tpgt;
 	/*
-	 * Register the tl_tpg as a emulated SAS TCM Target Endpoint
+	 * Register the tl_tpg as a emulated TCM Target Endpoint
 	 */
 	ret = core_tpg_register(wwn, &tl_tpg->tl_se_tpg, tl_hba->tl_proto_id);
 	if (ret < 0)
@@ -1201,7 +1201,7 @@ static void tcm_loop_drop_naa_tpg(
 		sas_rphy_delete(tl_tpg->sas_rphy);
 
 	/*
-	 * Release the I_T Nexus for the Virtual SAS link if present
+	 * Release the I_T Nexus for the Virtual target link if present
 	 */
 	tcm_loop_drop_nexus(tl_tpg);
 
@@ -1216,7 +1216,7 @@ static void tcm_loop_drop_naa_tpg(
 	}
 
 	/*
-	 * Deregister the tl_tpg as a emulated SAS TCM Target Endpoint
+	 * Deregister the tl_tpg as a emulated TCM Target Endpoint
 	 */
 	core_tpg_deregister(se_tpg);
 
@@ -1310,8 +1310,9 @@ static void tcm_loop_drop_scsi_hba(
 				struct tcm_loop_hba, tl_hba_wwn);
 
 	pr_debug("TCM_Loop_ConfigFS: Deallocating emulated Target"
-		" SAS Address: %s at Linux/SCSI Host ID: %d\n",
-		tl_hba->tl_wwn_address, tl_hba->sh->host_no);
+		" %s Address: %s at Linux/SCSI Host ID: %d\n",
+		tcm_loop_dump_proto_id(tl_hba), tl_hba->tl_wwn_address,
+		tl_hba->sh->host_no);
 	/*
 	 * Call device_unregister() on the original tl_hba->dev.
 	 * tcm_loop_fabric_scsi.c:tcm_loop_release_adapter() will
-- 
1.8.5.2

