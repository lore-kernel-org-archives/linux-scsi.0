From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 22/42] drivers/scsi/lpfc: Adjust confusing if indentation
Date: Thu, 5 Aug 2010 22:23:34 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1008052223170.31692@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:57766 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932964Ab0HEUXh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Aug 2010 16:23:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In lpfc_init.c, the call to lpfc_destroy_vport_work_array only has an
effect if vports is not NULL, so move it into the if branch that it is
already aligned with.

In lpfc_vport.c, ndlp has already been tested, so it is only useful to test
it again in the if branch that it is already aligned with.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r disable braces4@
position p1,p2;
statement S1,S2;
@@

(
if (...) { ... }
|
if (...) S1@p1 S2@p2
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

if (p1[0].column == p2[0].column):
  cocci.print_main("branch",p1)
  cocci.print_secs("after",p2)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/lpfc/lpfc_init.c  |    3 ++-
 drivers/scsi/lpfc/lpfc_vport.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 2786ee3..6f4bd5e 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2368,7 +2368,7 @@ lpfc_online(struct lpfc_hba *phba)
 	}
 
 	vports = lpfc_create_vport_work_array(phba);
-	if (vports != NULL)
+	if (vports != NULL) {
 		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
 			struct Scsi_Host *shost;
 			shost = lpfc_shost_from_vport(vports[i]);
@@ -2381,6 +2381,7 @@ lpfc_online(struct lpfc_hba *phba)
 			spin_unlock_irq(shost->host_lock);
 		}
 		lpfc_destroy_vport_work_array(phba, vports);
+	}
 
 	lpfc_unblock_mgmt_io(phba);
 	return 0;
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index 1655507..8420d19 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -690,11 +690,12 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 			/* Indicate free memory when release */
 			NLP_SET_FREE_REQ(ndlp);
 		} else {
-			if (!NLP_CHK_NODE_ACT(ndlp))
+			if (!NLP_CHK_NODE_ACT(ndlp)) {
 				ndlp = lpfc_enable_node(vport, ndlp,
 						NLP_STE_UNUSED_NODE);
 				if (!ndlp)
 					goto skip_logo;
+			}
 
 			/* Remove ndlp from vport npld list */
 			lpfc_dequeue_node(vport, ndlp);
