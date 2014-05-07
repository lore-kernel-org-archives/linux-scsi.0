From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] lpfc: Add iotag memory barrier
Date: Wed, 07 May 2014 09:35:11 -0500
Message-ID: <201405071435.s47EZbMQ029755@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:39843 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaEGOgO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 May 2014 10:36:14 -0400
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Wed, 7 May 2014 08:36:14 -0600
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id C45171FF003D
	for <linux-scsi@vger.kernel.org>; Wed,  7 May 2014 08:36:11 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp08025.gho.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s47Ea3UC64749572
	for <linux-scsi@vger.kernel.org>; Wed, 7 May 2014 16:36:11 +0200
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s47EZbTv032288
	for <linux-scsi@vger.kernel.org>; Wed, 7 May 2014 08:35:38 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, james.smart@emulex.com, brking@linux.vnet.ibm.com


Add a memory barrier to ensure the valid bit is read before
any of the cqe payload is read. This fixes an issue seen
on Power where the cqe payload was getting loaded before
the valid bit. When this occurred, we saw an iotag out of
range error when a command completed, but since the iotag
looked invalid the command didn't get completed to scsi core.
Later we hit the command timeout, attempted to abort the command,
then waited for the aborted command to get returned. Since the
adapter already returned the command, we timeout waiting,
and end up escalating EEH all the way to host reset. This
patch fixes this issue.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/lpfc/lpfc_sli.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/scsi/lpfc/lpfc_sli.c~lpfc_iotag_barrier drivers/scsi/lpfc/lpfc_sli.c
--- linux/drivers/scsi/lpfc/lpfc_sli.c~lpfc_iotag_barrier	2014-05-07 09:28:23.000000000 -0500
+++ linux-bjking1/drivers/scsi/lpfc/lpfc_sli.c	2014-05-07 09:28:23.000000000 -0500
@@ -265,6 +265,7 @@ lpfc_sli4_eq_get(struct lpfc_queue *q)
 		return NULL;
 
 	q->hba_index = idx;
+	mb();
 	return eqe;
 }
 
@@ -370,6 +371,7 @@ lpfc_sli4_cq_get(struct lpfc_queue *q)
 
 	cqe = q->qe[q->hba_index].cqe;
 	q->hba_index = idx;
+	mb();
 	return cqe;
 }
 
_

