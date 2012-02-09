From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 24/29] qla2xxx: Cache swl during fabric discovery.
Date: Thu, 9 Feb 2012 11:15:56 -0800
Message-ID: <1328814961-21866-25-git-send-email-chad.dupuis@qlogic.com>
References: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:41846
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758473Ab2BITcY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:32:24 -0500
Received: from mail143-ch1 (localhost [127.0.0.1])	by
 mail143-ch1-R.bigfish.com (Postfix) with ESMTP id 65B5B4C0245	for
 <linux-scsi@vger.kernel.org>; Thu,  9 Feb 2012 19:32:13 +0000 (UTC)
In-Reply-To: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Rather than continuously allocating and freeing swl within the discovery
process, simply pre-allocate it the first time that it's needed, cache it
through the rest of the lifecycle of the driver and free it at module unload.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |    2 ++
 drivers/scsi/qla2xxx/qla_init.c |   12 +++++-------
 drivers/scsi/qla2xxx/qla_os.c   |    1 +
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 9d353ca..649748f 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2674,6 +2674,8 @@ struct qla_hw_data {
 	void		*async_pd;
 	dma_addr_t	async_pd_dma;
 
+	void		*swl;
+
 	/* These are used by mailbox operations. */
 	volatile uint16_t mailbox_out[MAILBOX_REGISTER_COUNT];
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index b28eb40..24b2d11 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3133,20 +3133,21 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 	rval = QLA_SUCCESS;
 
 	/* Try GID_PT to get device list, else GAN. */
-	swl = kcalloc(MAX_FIBRE_DEVICES, sizeof(sw_info_t), GFP_KERNEL);
+	if (!ha->swl)
+		ha->swl = kcalloc(MAX_FIBRE_DEVICES, sizeof(sw_info_t),
+		    GFP_KERNEL);
+	swl = ha->swl;
 	if (!swl) {
 		/*EMPTY*/
 		ql_dbg(ql_dbg_disc, vha, 0x2054,
 		    "GID_PT allocations failed, fallback on GA_NXT.\n");
 	} else {
+		memset(swl, 0, MAX_FIBRE_DEVICES * sizeof(sw_info_t));
 		if (qla2x00_gid_pt(vha, swl) != QLA_SUCCESS) {
-			kfree(swl);
 			swl = NULL;
 		} else if (qla2x00_gpn_id(vha, swl) != QLA_SUCCESS) {
-			kfree(swl);
 			swl = NULL;
 		} else if (qla2x00_gnn_id(vha, swl) != QLA_SUCCESS) {
-			kfree(swl);
 			swl = NULL;
 		} else if (ql2xiidmaenable &&
 		    qla2x00_gfpn_id(vha, swl) == QLA_SUCCESS) {
@@ -3164,7 +3165,6 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 	if (new_fcport == NULL) {
 		ql_log(ql_log_warn, vha, 0x205e,
 		    "Failed to allocate memory for fcport.\n");
-		kfree(swl);
 		return (QLA_MEMORY_ALLOC_FAILED);
 	}
 	new_fcport->flags |= (FCF_FABRIC_DEVICE | FCF_LOGIN_NEEDED);
@@ -3341,14 +3341,12 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 		if (new_fcport == NULL) {
 			ql_log(ql_log_warn, vha, 0x2066,
 			    "Memory allocation failed for fcport.\n");
-			kfree(swl);
 			return (QLA_MEMORY_ALLOC_FAILED);
 		}
 		new_fcport->flags |= (FCF_FABRIC_DEVICE | FCF_LOGIN_NEEDED);
 		new_fcport->d_id.b24 = nxt_d_id.b24;
 	}
 
-	kfree(swl);
 	kfree(new_fcport);
 
 	return (rval);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ffa3488..94ff3a5 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3280,6 +3280,7 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 	vfree(ha->optrom_buffer);
 	kfree(ha->nvram);
 	kfree(ha->npiv_info);
+	kfree(ha->swl);
 
 	ha->srb_mempool = NULL;
 	ha->ctx_mempool = NULL;
-- 
1.6.0.2


