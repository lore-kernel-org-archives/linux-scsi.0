From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH] fc_transport: remove explicit calls to
	scsi_target_unblock() from terminate_rport_io() callbacks.
Date: Fri, 11 Jul 2008 11:17:48 -0700
Message-ID: <20080711181748.GC55164@plap4-2.local>
References: <20080710235458.GQ29099@plap4-2.local> <1215734163-40825-2-git-send-email-andrew.vasquez@qlogic.com> <48779934.8020000@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:38710 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbYGKSRu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jul 2008 14:17:50 -0400
Content-Disposition: inline
In-Reply-To: <48779934.8020000@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Seokmann Ju <seokmann.ju@qlogic.com>, James Smart <james.smart@emulex.com>, Brian King <brking@linux.vnet.ibm.com>

Recent work in the transport
(http://marc.info/?l=linux-scsi&m=121263015008613&w=2) centralizes an
'unblock' operation on an rports scsi-target after the
terminate_rport_io() callback.

Cc: James Smart <james.smart@emulex.com>
Cc: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
	On Fri, 11 Jul 2008, Mike Christie wrote:

	> Andrew Vasquez wrote:
	>> +
	>> +static void
	>> +qla2x00_terminate_rport_io(struct fc_rport *rport)
	>> +{
	>> +	fc_port_t *fcport = *(fc_port_t **)rport->dd_data;
	>> +
	>> +	qla2x00_abort_fcport_cmds(fcport);
	>> +	scsi_target_unblock(&rport->dev);
	>
	> I sent a patch so the unblock is always done by the fc class.
	> http://marc.info/?l=linux-scsi&m=121263015008613&w=2
	>
	> Could we do that instead so qlogic and emulex and all other drivers behave 
	> the same?

	And here's a patch to drop the explicit calls to scsi_target_unblock()
	from current fc-tranport consumers with a terminate_rport_io()
	callback.

	BTW: I don't see the patchset in scsi-misc-2.6.git.

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index eb702b9..4c6c6a9 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2002,7 +2002,6 @@ static void ibmvfc_terminate_rport_io(struct fc_rport *rport)
 	} else
 		ibmvfc_issue_fc_host_lip(shost);
 
-	scsi_target_unblock(&rport->dev);
 	LEAVE;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index a98d11b..f6f50a7 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -89,12 +89,6 @@ lpfc_terminate_rport_io(struct fc_rport *rport)
 			ndlp->nlp_sid, 0, LPFC_CTX_TGT);
 	}
 
-	/*
-	 * A device is normally blocked for rediscovery and unblocked when
-	 * devloss timeout happens.  In case a vport is removed or driver
-	 * unloaded before devloss timeout happens, we need to unblock here.
-	 */
-	scsi_target_unblock(&rport->dev);
 	return;
 }
 
