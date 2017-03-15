From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 2/6] ipr: Remove redundant initialization
Date: Wed, 15 Mar 2017 16:58:37 -0500
Message-ID: <20170315215838.237B86A03B@b03ledav003.gho.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34194 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753360AbdCOV6n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Mar 2017 17:58:43 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v2FLsRpa072167
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2017 17:58:42 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0b-001b2d01.pphosted.com with ESMTP id 296nfxux4e-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2017 17:58:42 -0400
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
        Wed, 15 Mar 2017 17:58:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Removes some code in __ipr_eh_dev_reset which was modifying the
ipr_cmd done function. This should have already been setup at
command allocation time and if its since been changed, it means
we are in the ipr_erp* functions and need to wait for them to
complete and don't want to override that here.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_eh_dev_reset_unnecessary_reinit drivers/scsi/ipr.c
--- linux-2.6.git/drivers/scsi/ipr.c~ipr_eh_dev_reset_unnecessary_reinit	2017-03-13 15:53:29.636591281 -0500
+++ linux-2.6.git-bjking1/drivers/scsi/ipr.c	2017-03-13 15:53:29.642591257 -0500
@@ -5243,12 +5243,11 @@ static int __ipr_eh_dev_reset(struct scs
 		spin_lock(&hrrq->_lock);
 		list_for_each_entry(ipr_cmd, &hrrq->hrrq_pending_q, queue) {
 			if (ipr_cmd->ioarcb.res_handle == res->res_handle) {
-				if (ipr_cmd->scsi_cmd)
-					ipr_cmd->done = ipr_scsi_eh_done;
-				if (ipr_cmd->qc)
-					ipr_cmd->done = ipr_sata_eh_done;
-				if (ipr_cmd->qc &&
-				    !(ipr_cmd->qc->flags & ATA_QCFLAG_FAILED)) {
+				if (!ipr_cmd->qc)
+					continue;
+
+				ipr_cmd->done = ipr_sata_eh_done;
+				if (!(ipr_cmd->qc->flags & ATA_QCFLAG_FAILED)) {
 					ipr_cmd->qc->err_mask |= AC_ERR_TIMEOUT;
 					ipr_cmd->qc->flags |= ATA_QCFLAG_FAILED;
 				}
_
