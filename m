Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5DC2C43461
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 08:41:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E80D206D4
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 08:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729911AbgIJIll (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 04:41:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:49756 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730178AbgIJIlC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Sep 2020 04:41:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E5188B20B;
        Thu, 10 Sep 2020 08:41:16 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     James Smart <james.smart@broadcom.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH] lpfc: drop nodelist reference on error in lpfc_gen_req()
Date:   Thu, 10 Sep 2020 10:40:59 +0200
Message-Id: <20200910084059.138507-1-hare@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If we fail to issue the iocb in lpfc_gen_req() we need to drop
the nodelist reference.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/lpfc/lpfc_ct.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index ef2015fad2d5..c201686d3815 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -387,6 +387,8 @@ lpfc_gen_req(struct lpfc_vport *vport, struct lpfc_dmabuf *bmp,
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, geniocb, 0);
 
 	if (rc == IOCB_ERROR) {
+		geniocb->context_un.ndlp = NULL;
+		lpfc_nlp_put(ndlp);
 		lpfc_sli_release_iocbq(phba, geniocb);
 		return 1;
 	}
-- 
2.16.4

