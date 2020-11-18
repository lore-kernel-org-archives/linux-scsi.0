Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 099CCC63777
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 14:13:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B709924698
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 14:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbgKRONU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Nov 2020 09:13:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60063 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgKRONU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2020 09:13:20 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kfOCx-0005v8-3O; Wed, 18 Nov 2020 14:13:15 +0000
From:   Colin King <colin.king@canonical.com>
To:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] scsi: lpfc: Fix memory leak on lcb_context
Date:   Wed, 18 Nov 2020 14:13:14 +0000
Message-Id: <20201118141314.462471-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently there is an error return path that neglects to free the
allocation for lcb_context.  Fix this by adding a new error free
exit path that kfree's lcb_context before returning.  Use this new
kfree exit path in another exit error path that also kfree's the same
object, allowing a line of code to be removed.

Addresses-Coverity: ("Resource leak")
Fixes: 4430f7fd09ec ("scsi: lpfc: Rework locations of ndlp reference taking")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 03f47d1b21fe..0d3271b4c130 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -6515,18 +6515,20 @@ lpfc_els_rcv_lcb(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	lcb_context->ndlp = lpfc_nlp_get(ndlp);
 	if (!lcb_context->ndlp) {
 		rjt_err = LSRJT_UNABLE_TPC;
-		goto rjt;
+		goto rjt_free;
 	}
 
 	if (lpfc_sli4_set_beacon(vport, lcb_context, state)) {
 		lpfc_printf_vlog(ndlp->vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "0193 failed to send mail box");
-		kfree(lcb_context);
 		lpfc_nlp_put(ndlp);
 		rjt_err = LSRJT_UNABLE_TPC;
-		goto rjt;
+		goto rjt_free;
 	}
 	return 0;
+
+rjt_free:
+	kfree(lcb_context);
 rjt:
 	memset(&stat, 0, sizeof(stat));
 	stat.un.b.lsRjtRsnCode = rjt_err;
-- 
2.28.0

