From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/2] SCSI-lpfc: One function call less in lpfc_bsg_hba_set_event()
 after error detection
Date: Thu, 05 Feb 2015 23:28:12 +0100
Message-ID: <54D3EE7C.8010005@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.so
 urceforge.net> <54D3EDDB.1050905@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54D3EDDB.1050905@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@emulex.com>, "James E. J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 5 Feb 2015 23:03:52 +0100

The kfree() function was called in two cases by the lpfc_bsg_hba_set_event()
function during error handling even if the passed variable "dd_data" contained
still a null pointer.

This implementation detail could be improved by the introduction of another
jump label.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 1af783a..b8074cf 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -1240,7 +1240,7 @@ lpfc_bsg_hba_set_event(struct fc_bsg_job *job)
 					"2617 Failed allocation of event "
 					"waiter\n");
 			rc = -ENOMEM;
-			goto job_error;
+			goto free_data;
 		}
 		dd_data->type = TYPE_EVT;
 		dd_data->set_job = NULL;
@@ -1260,8 +1260,9 @@ lpfc_bsg_hba_set_event(struct fc_bsg_job *job)
 	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 	return 0; /* call job done later */
 
-job_error:
+free_data:
 	kfree(dd_data);
+job_error:
 	job->dd_data = NULL;
 	return rc;
 }
-- 
2.2.2
