Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A59CC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 14:00:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D370C23103
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 14:00:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbhAYN6Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Jan 2021 08:58:16 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:51366 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729180AbhAYN5Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jan 2021 08:57:16 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10P8Z3mL017485;
        Mon, 25 Jan 2021 08:44:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=TawASkgzxobqNycAxeq1iSH/tMCNfK27y/lI3OlEpqw=;
 b=NSmJLY2ju6/YudQrJGQxyjpXAWhKkaEI+J3HgQHVbbEicRmtcJpQ/rrkuf5z4Dw0q5Vc
 Q3rQIOR0T3rn1B+6j/L3RiCoZpE8WI9BwvV0P1qhmiPL77QCkTY/E2SaLKPUURVrVOCt
 07Ns4HGLYmsE9PvnVSHJxjh+eLNrdUsKFwnZkpqt+d8gP8o/9oMP5IdOZkYsEZ/qfVRX
 o6Ry35Sf9EXAb+U1/47REYGx+1VAGQ5y1LWUYMrjH0Go3WisKUF2gWfABi0hhAWz4ctz
 kLmsRJAFqTrihRfQO2xTAY5Ol6OlP3mqu4uoXUIVZkcl4KG48YcC0UFlXev87/URX0uF Aw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 3689aacaw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Jan 2021 08:44:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10P8YwkF062347;
        Mon, 25 Jan 2021 08:44:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 368wck9nu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Jan 2021 08:44:45 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10P8ifZJ019858;
        Mon, 25 Jan 2021 08:44:42 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 25 Jan 2021 00:44:41 -0800
Date:   Mon, 25 Jan 2021 11:44:34 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     James Smart <james.smart@broadcom.com>
Cc:     Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@steeleye.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: lpfc: Fix ancient double free
Message-ID: <YA6E8rO51hE56SVw@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9874 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101250051
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9874 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1011 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101250051
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The "pmb" pointer is freed at the start of the function and then freed
again in the error handling code.

Fixes: 92d7f7b0cde3 ("[SCSI] lpfc: NPIV: add NPIV support on top of SLI-3")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index f890b5b7e6ca..48ca4a612f80 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1155,13 +1155,14 @@ lpfc_mbx_cmpl_local_config_link(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	struct lpfc_vport *vport = pmb->vport;
 	LPFC_MBOXQ_t *sparam_mb;
 	struct lpfc_dmabuf *sparam_mp;
+	u16 status = pmb->u.mb.mbxStatus;
 	int rc;
 
-	if (pmb->u.mb.mbxStatus)
-		goto out;
-
 	mempool_free(pmb, phba->mbox_mem_pool);
 
+	if (status)
+		goto out;
+
 	/* don't perform discovery for SLI4 loopback diagnostic test */
 	if ((phba->sli_rev == LPFC_SLI_REV4) &&
 	    !(phba->hba_flag & HBA_FCOE_MODE) &&
@@ -1224,12 +1225,10 @@ lpfc_mbx_cmpl_local_config_link(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 
 out:
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-			 "0306 CONFIG_LINK mbxStatus error x%x "
-			 "HBA state x%x\n",
-			 pmb->u.mb.mbxStatus, vport->port_state);
-sparam_out:
-	mempool_free(pmb, phba->mbox_mem_pool);
+			 "0306 CONFIG_LINK mbxStatus error x%x HBA state x%x\n",
+			 status, vport->port_state);
 
+sparam_out:
 	lpfc_linkdown(phba);
 
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-- 
2.29.2

