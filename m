Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9F15C12002
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jul 2021 10:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1A2161009
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jul 2021 10:43:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235695AbhGUKCU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jul 2021 06:02:20 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:57208
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238369AbhGUJNj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Jul 2021 05:13:39 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 8BD6A3F238;
        Wed, 21 Jul 2021 09:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1626861232;
        bh=p/DaE49HtSJc8DATGd5z1NK4RO1z1sryXKeYkhdtVe8=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=Ilo4q+cyfE+JGWjlrdvxQQwIbRJ/OO1bRio3mYGdcXj3Wjok3c9bcGsh5kDsM07M8
         yM5UdZTEd+mBoTrLs8fEFpmEwHM6c0a7JLzeJZS9yJzDGa/7FC/QQfs2KPeD6MT9Mi
         CqzP5qkGgeFk2Z1ajkC3J8oqUan2l4WFwkrq7qjVHpSpkPEPb9DZN+th4Hds82UvCK
         yTW4GXw8A67sh2eq8gS6EuN4eb3YgvVX012unnBkx1JhFkk/Ac8b286mZjYx/2JqDz
         KgTFXZ5epydx+ih533t8VmqeJkIOQzD4Zatswyd7unQqz1jUZvE2mNj1fkVfCuqSXs
         9BI04pTxuaNYQ==
From:   Colin King <colin.king@canonical.com>
To:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: lpfc: remove redundant assignment to pointer pcmd
Date:   Wed, 21 Jul 2021 10:53:50 +0100
Message-Id: <20210721095350.41564-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The pointer pcmd is being initialized with a value that is never
read, the assignment is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index c34240819d92..47dd13719901 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -10129,8 +10129,6 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		bf_set(wqe_ebde_cnt, &wqe->xmit_els_rsp.wqe_com, 0);
 		bf_set(wqe_rsp_temp_rpi, &wqe->xmit_els_rsp,
 		       phba->sli4_hba.rpi_ids[ndlp->nlp_rpi]);
-		pcmd = (uint32_t *) (((struct lpfc_dmabuf *)
-					iocbq->context2)->virt);
 		if (phba->fc_topology == LPFC_TOPOLOGY_LOOP) {
 				bf_set(els_rsp64_sp, &wqe->xmit_els_rsp, 1);
 				bf_set(els_rsp64_sid, &wqe->xmit_els_rsp,
-- 
2.31.1

