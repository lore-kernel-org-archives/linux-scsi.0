Return-Path: <SRS0=0GAJ=6C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23ED6C2BA19
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 07:09:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06C93221EA
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 07:09:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725887AbgDRHJW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Apr 2020 03:09:22 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:49104 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725843AbgDRHJV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 18 Apr 2020 03:09:21 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4C9D525A497137A7456F;
        Sat, 18 Apr 2020 15:09:18 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Sat, 18 Apr 2020 15:09:08 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     YueHaibing <yuehaibing@huawei.com>, <linux-scsi@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] scsi: bfa: Remove set but not used variable 'fchs'
Date:   Sat, 18 Apr 2020 07:10:57 +0000
Message-ID: <20200418071057.96699-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/bfa/bfa_svc.c: In function 'uf_recv':
drivers/scsi/bfa/bfa_svc.c:5520:17: warning:
 variable 'fchs' set but not used [-Wunused-but-set-variable]
  struct fchs_s *fchs;
                 ^

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/bfa/bfa_svc.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index d8a9e40fa257..0b7d2e8f4a66 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -5517,7 +5517,6 @@ uf_recv(struct bfa_s *bfa, struct bfi_uf_frm_rcvd_s *m)
 	struct bfa_uf_s *uf = &ufm->uf_list[uf_tag];
 	struct bfa_uf_buf_s *uf_buf;
 	uint8_t *buf;
-	struct fchs_s *fchs;
 
 	uf_buf = (struct bfa_uf_buf_s *)
 			bfa_mem_get_dmabuf_kva(ufm, uf_tag, uf->pb_len);
@@ -5526,8 +5525,6 @@ uf_recv(struct bfa_s *bfa, struct bfi_uf_frm_rcvd_s *m)
 	m->frm_len = be16_to_cpu(m->frm_len);
 	m->xfr_len = be16_to_cpu(m->xfr_len);
 
-	fchs = (struct fchs_s *)uf_buf;
-
 	list_del(&uf->qe);	/* dequeue from posted queue */
 
 	uf->data_ptr = buf;





