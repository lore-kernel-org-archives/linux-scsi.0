Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76D01C47095
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 07:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5562A61352
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 07:12:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237101AbhFIHOv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 03:14:51 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:5462 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235698AbhFIHOv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 03:14:51 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G0JCK1mDZzZfb2;
        Wed,  9 Jun 2021 15:10:05 +0800 (CST)
Received: from dggpeml500020.china.huawei.com (7.185.36.88) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 15:12:54 +0800
Received: from huawei.com (10.175.127.227) by dggpeml500020.china.huawei.com
 (7.185.36.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 9 Jun 2021
 15:12:53 +0800
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
Subject: [PATCH -next v2] [SCSI] bfa: Use list_move_tail instead of list_del/list_add_tail in bfa_fcpim.c
Date:   Wed, 9 Jun 2021 15:22:02 +0800
Message-ID: <20210609072202.1352890-1-libaokun1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500020.china.huawei.com (7.185.36.88)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Using list_move_tail() instead of list_del() + list_add_tail() in bfa_fcpim.c.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
---
V1->V2:
	CC mailist

 drivers/scsi/bfa/bfa_fcpim.c | 37 +++++++++---------------
 1 file changed, 13 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index 7ad22288071b..a5eeb8a59afe 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -83,8 +83,7 @@ enum bfa_itnim_event {
  *  BFA IOIM related definitions
  */
 #define bfa_ioim_move_to_comp_q(__ioim) do {				\
-	list_del(&(__ioim)->qe);					\
-	list_add_tail(&(__ioim)->qe, &(__ioim)->fcpim->ioim_comp_q);	\
+	list_move_tail(&(__ioim)->qe, &(__ioim)->fcpim->ioim_comp_q);	\
 } while (0)
 
 
@@ -1023,8 +1022,7 @@ bfa_itnim_cleanup(struct bfa_itnim_s *itnim)
 		 * Move IO to a cleanup queue from active queue so that a later
 		 * TM will not pickup this IO.
 		 */
-		list_del(&ioim->qe);
-		list_add_tail(&ioim->qe, &itnim->io_cleanup_q);
+		list_move_tail(&ioim->qe, &itnim->io_cleanup_q);
 
 		bfa_wc_up(&itnim->wc);
 		bfa_ioim_cleanup(ioim);
@@ -1509,15 +1507,13 @@ bfa_ioim_sm_uninit(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		if (!bfa_itnim_is_online(ioim->itnim)) {
 			if (!bfa_itnim_hold_io(ioim->itnim)) {
 				bfa_sm_set_state(ioim, bfa_ioim_sm_hcb);
-				list_del(&ioim->qe);
-				list_add_tail(&ioim->qe,
-					&ioim->fcpim->ioim_comp_q);
+				list_move_tail(&ioim->qe,
+					       &ioim->fcpim->ioim_comp_q);
 				bfa_cb_queue(ioim->bfa, &ioim->hcb_qe,
 						__bfa_cb_ioim_pathtov, ioim);
 			} else {
-				list_del(&ioim->qe);
-				list_add_tail(&ioim->qe,
-					&ioim->itnim->pending_q);
+				list_move_tail(&ioim->qe,
+					       &ioim->itnim->pending_q);
 			}
 			break;
 		}
@@ -2044,8 +2040,7 @@ bfa_ioim_sm_hcb_free(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 	switch (event) {
 	case BFA_IOIM_SM_HCB:
 		bfa_sm_set_state(ioim, bfa_ioim_sm_resfree);
-		list_del(&ioim->qe);
-		list_add_tail(&ioim->qe, &ioim->fcpim->ioim_resfree_q);
+		list_move_tail(&ioim->qe, &ioim->fcpim->ioim_resfree_q);
 		break;
 
 	case BFA_IOIM_SM_FREE:
@@ -2672,14 +2667,12 @@ bfa_ioim_notify_cleanup(struct bfa_ioim_s *ioim)
 	 * Move IO from itnim queue to fcpim global queue since itnim will be
 	 * freed.
 	 */
-	list_del(&ioim->qe);
-	list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
+	list_move_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
 
 	if (!ioim->iosp->tskim) {
 		if (ioim->fcpim->delay_comp && ioim->itnim->iotov_active) {
 			bfa_cb_dequeue(&ioim->hcb_qe);
-			list_del(&ioim->qe);
-			list_add_tail(&ioim->qe, &ioim->itnim->delay_comp_q);
+			list_move_tail(&ioim->qe, &ioim->itnim->delay_comp_q);
 		}
 		bfa_itnim_iodone(ioim->itnim);
 	} else
@@ -2723,8 +2716,7 @@ bfa_ioim_delayed_comp(struct bfa_ioim_s *ioim, bfa_boolean_t iotov)
 	 * Move IO to fcpim global queue since itnim will be
 	 * freed.
 	 */
-	list_del(&ioim->qe);
-	list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
+	list_move_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
 }
 
 
@@ -3318,8 +3310,7 @@ bfa_tskim_gather_ios(struct bfa_tskim_s *tskim)
 		cmnd = (struct scsi_cmnd *) ioim->dio;
 		int_to_scsilun(cmnd->device->lun, &scsilun);
 		if (bfa_tskim_match_scope(tskim, scsilun)) {
-			list_del(&ioim->qe);
-			list_add_tail(&ioim->qe, &tskim->io_q);
+			list_move_tail(&ioim->qe, &tskim->io_q);
 		}
 	}
 
@@ -3331,8 +3322,7 @@ bfa_tskim_gather_ios(struct bfa_tskim_s *tskim)
 		cmnd = (struct scsi_cmnd *) ioim->dio;
 		int_to_scsilun(cmnd->device->lun, &scsilun);
 		if (bfa_tskim_match_scope(tskim, scsilun)) {
-			list_del(&ioim->qe);
-			list_add_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
+			list_move_tail(&ioim->qe, &ioim->fcpim->ioim_comp_q);
 			bfa_ioim_tov(ioim);
 		}
 	}
@@ -3576,8 +3566,7 @@ void
 bfa_tskim_free(struct bfa_tskim_s *tskim)
 {
 	WARN_ON(!bfa_q_is_on_q_func(&tskim->itnim->tsk_q, &tskim->qe));
-	list_del(&tskim->qe);
-	list_add_tail(&tskim->qe, &tskim->fcpim->tskim_free_q);
+	list_move_tail(&tskim->qe, &tskim->fcpim->tskim_free_q);
 }
 
 /*

