From: James Smart <james.smart@emulex.com>
Subject: [PATCH 10/14] lpfc: Fix crash in vport_delete.
Date: Mon, 20 Apr 2015 09:56:33 -0400
Message-ID: <55350591.9Fc1EMkA5gMJGTDK%james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.emulex.com ([138.239.224.99]:29298 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409AbbDTN5J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2015 09:57:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix crash in vport_delete.

We inadvertantly took the path to recreate the vport while in a
driver teardown path

Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_init.c      | 8 +++++++-
 drivers/scsi/lpfc/lpfc_nportdisc.c | 8 +++++++-
 drivers/scsi/lpfc/lpfc_vport.c     | 9 +++++----
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 6ab8312..14424e6 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4483,7 +4483,13 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba *phba,
 			lpfc_destroy_vport_work_array(phba, vports);
 		}
 
-		if (active_vlink_present) {
+		/*
+		 * Don't re-instantiate if vport is marked for deletion.
+		 * If we are here first then vport_delete is going to wait
+		 * for discovery to complete.
+		 */
+		if (!(vport->load_flag & FC_UNLOADING) &&
+					active_vlink_present) {
 			/*
 			 * If there are other active VLinks present,
 			 * re-instantiate the Vlink using FDISC.
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 4cb9882..09de640 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -661,7 +661,13 @@ lpfc_rcv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			lpfc_destroy_vport_work_array(phba, vports);
 		}
 
-		if (active_vlink_present) {
+		/*
+		 * Don't re-instantiate if vport is marked for deletion.
+		 * If we are here first then vport_delete is going to wait
+		 * for discovery to complete.
+		 */
+		if (!(vport->load_flag & FC_UNLOADING) &&
+					active_vlink_present) {
 			/*
 			 * If there are other active VLinks present,
 			 * re-instantiate the Vlink using FDISC.
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index a87ee33..7690126 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -567,8 +567,8 @@ int
 lpfc_vport_delete(struct fc_vport *fc_vport)
 {
 	struct lpfc_nodelist *ndlp = NULL;
-	struct Scsi_Host *shost = (struct Scsi_Host *) fc_vport->shost;
 	struct lpfc_vport *vport = *(struct lpfc_vport **)fc_vport->dd_data;
+	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba   *phba = vport->phba;
 	long timeout;
 	bool ns_ndlp_referenced = false;
@@ -645,8 +645,8 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 	}
 
 	/* Remove FC host and then SCSI host with the vport */
-	fc_remove_host(lpfc_shost_from_vport(vport));
-	scsi_remove_host(lpfc_shost_from_vport(vport));
+	fc_remove_host(shost);
+	scsi_remove_host(shost);
 
 	ndlp = lpfc_findnode_did(phba->pport, Fabric_DID);
 
@@ -772,7 +772,8 @@ skip_logo:
 		 * Completion of unreg_vpi (lpfc_mbx_cmpl_unreg_vpi)
 		 * does the scsi_host_put() to release the vport.
 		 */
-		if (lpfc_mbx_unreg_vpi(vport))
+		if (!(vport->vpi_state & LPFC_VPI_REGISTERED) ||
+				lpfc_mbx_unreg_vpi(vport))
 			scsi_host_put(shost);
 	} else
 		scsi_host_put(shost);
-- 
1.7.11.7

