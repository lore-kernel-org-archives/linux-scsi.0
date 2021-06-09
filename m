Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE97BC48BCD
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 07:16:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C80DC61002
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 07:16:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235943AbhFIHSg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 03:18:36 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3916 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232746AbhFIHSf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 03:18:35 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G0JHN0mXlz6tqB;
        Wed,  9 Jun 2021 15:13:36 +0800 (CST)
Received: from dggpeml500020.china.huawei.com (7.185.36.88) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 15:16:39 +0800
Received: from huawei.com (10.175.127.227) by dggpeml500020.china.huawei.com
 (7.185.36.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 9 Jun 2021
 15:16:39 +0800
From:   Baokun Li <libaokun1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <yangjihong1@huawei.com>, <yukuai3@huawei.com>,
        <libaokun1@huawei.com>, <linux-scsi@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH -next v2] scsi: bfa: Use list_move_tail instead of list_del/list_add_tail in bfa_svc.c
Date:   Wed, 9 Jun 2021 15:25:48 +0800
Message-ID: <20210609072548.1357835-1-libaokun1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500020.china.huawei.com (7.185.36.88)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Using list_move_tail() instead of list_del() + list_add_tail() in bfa_svc.c.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
---
V1->V2:
	CC mailist

 drivers/scsi/bfa/bfa_svc.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 4e3cef02f10f..ae31a0605efe 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -1572,8 +1572,7 @@ bfa_lps_login_rsp(struct bfa_s *bfa, struct bfi_lps_login_rsp_s *rsp)
 		break;
 	}
 
-	list_del(&lps->qe);
-	list_add_tail(&lps->qe, &mod->lps_active_q);
+	list_move_tail(&lps->qe, &mod->lps_active_q);
 	bfa_sm_send_event(lps, BFA_LPS_SM_FWRSP);
 }
 
@@ -1594,8 +1593,7 @@ bfa_lps_no_res(struct bfa_lps_s *first_lps, u8 count)
 		lps = (struct bfa_lps_s *)qe;
 		bfa_trc(bfa, lps->bfa_tag);
 		lps->status = first_lps->status;
-		list_del(&lps->qe);
-		list_add_tail(&lps->qe, &mod->lps_active_q);
+		list_move_tail(&lps->qe, &mod->lps_active_q);
 		bfa_sm_send_event(lps, BFA_LPS_SM_FWRSP);
 		qe = qe_next;
 		count--;
@@ -1651,8 +1649,7 @@ bfa_lps_free(struct bfa_lps_s *lps)
 	struct bfa_lps_mod_s	*mod = BFA_LPS_MOD(lps->bfa);
 
 	lps->lp_pid = 0;
-	list_del(&lps->qe);
-	list_add_tail(&lps->qe, &mod->lps_free_q);
+	list_move_tail(&lps->qe, &mod->lps_free_q);
 }
 
 /*
@@ -1679,8 +1676,7 @@ bfa_lps_send_login(struct bfa_lps_s *lps)
 	m->auth_en	= lps->auth_en;
 
 	bfa_reqq_produce(lps->bfa, lps->reqq, m->mh);
-	list_del(&lps->qe);
-	list_add_tail(&lps->qe, &mod->lps_login_q);
+	list_move_tail(&lps->qe, &mod->lps_login_q);
 }
 
 /*
@@ -4877,8 +4873,7 @@ bfa_rport_free(struct bfa_rport_s *rport)
 	struct bfa_rport_mod_s *mod = BFA_RPORT_MOD(rport->bfa);
 
 	WARN_ON(!bfa_q_is_on_q(&mod->rp_active_q, rport));
-	list_del(&rport->qe);
-	list_add_tail(&rport->qe, &mod->rp_free_q);
+	list_move_tail(&rport->qe, &mod->rp_free_q);
 }
 
 static bfa_boolean_t

