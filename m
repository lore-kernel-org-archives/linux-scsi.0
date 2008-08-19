From: michaelc@cs.wisc.edu
Subject: [PATCH 2/9] fc drivers: remove scsi_target_unblock calls in terminate callbacks
Date: Tue, 19 Aug 2008 18:45:24 -0500
Message-ID: <1219189531-5243-3-git-send-email-michaelc@cs.wisc.edu>
References: <1219189531-5243-1-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-2-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758AbYHSXpo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Aug 2008 19:45:44 -0400
In-Reply-To: <1219189531-5243-2-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jens.axboe@oracle.com
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

The fc class now calls scsi_target_unblock after calling the
terminate callback, so this patch removes the calls from the
drivers.

This patch was made over scsi-misc which has the ibmvfc driver.
It is also made over the latest qlogic patchset, which added
a terminate callback
patchset:
http://marc.info/?l=linux-scsi&m=121573412422984&w=2
patch with callabck addition
http://marc.info/?l=linux-scsi&m=121573444523292&w=2

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/ibmvscsi/ibmvfc.c   |    2 --
 drivers/scsi/lpfc/lpfc_hbadisc.c |    8 --------
 drivers/scsi/qla2xxx/qla_attr.c  |    1 -
 3 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index ae560bc..a3744fd 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2024,8 +2024,6 @@ static void ibmvfc_terminate_rport_io(struct fc_rport *rport)
 		spin_unlock_irqrestore(shost->host_lock, flags);
 	} else
 		ibmvfc_issue_fc_host_lip(shost);
-
-	scsi_target_unblock(&rport->dev);
 	LEAVE;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index a98d11b..aaf398e 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -88,14 +88,6 @@ lpfc_terminate_rport_io(struct fc_rport *rport)
 			&phba->sli.ring[phba->sli.fcp_ring],
 			ndlp->nlp_sid, 0, LPFC_CTX_TGT);
 	}
-
-	/*
-	 * A device is normally blocked for rediscovery and unblocked when
-	 * devloss timeout happens.  In case a vport is removed or driver
-	 * unloaded before devloss timeout happens, we need to unblock here.
-	 */
-	scsi_target_unblock(&rport->dev);
-	return;
 }
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 7a4409a..b98ef66 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -993,7 +993,6 @@ qla2x00_terminate_rport_io(struct fc_rport *rport)
 	fc_port_t *fcport = *(fc_port_t **)rport->dd_data;
 
 	qla2x00_abort_fcport_cmds(fcport);
-	scsi_target_unblock(&rport->dev);
 }
 
 static int
-- 
1.5.4.1

