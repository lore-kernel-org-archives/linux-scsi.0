Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60BB7C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 23:10:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F26A2067D
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 23:10:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OlhESj0u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgG2XKR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 19:10:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50769 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727083AbgG2XKQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 19:10:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596064215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=l32mWubXGRR/Zng5Gr0kfCxTExssTQX+E6N7LsbyXH0=;
        b=OlhESj0ubZ9URoamcseZ8ES4rcnO3Dp5AkEcPFEKLp5/k1WO519fPUQkJhz88ANBPjmtNf
        kX/eYMztMCnj7azxcacNWw4yScW7ozOD4ku/l4GwBzvLb18H81dJAS3+2MENdhNjFA+slk
        8CXryxFPdETHGNb37aUbfjAsoHRNUfE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-fTk2GrWSPZmm4Ol_zaETvQ-1; Wed, 29 Jul 2020 19:10:13 -0400
X-MC-Unique: fTk2GrWSPZmm4Ol_zaETvQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B04A1B18BC0;
        Wed, 29 Jul 2020 23:10:12 +0000 (UTC)
Received: from emilne.bos.redhat.com (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3BBA771925;
        Wed, 29 Jul 2020 23:10:12 +0000 (UTC)
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     james.smart@broadcom.com
Subject: [PATCH] scsi: lpfc: nvmet: avoid hang / use-after-free again when destroying targetport
Date:   Wed, 29 Jul 2020 19:10:11 -0400
Message-Id: <20200729231011.13240-1-emilne@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We cannot wait on a completion object in the lpfc_nvme_targetport structure
in the _destroy_targetport() code path because the NVMe/fc transport will
free that structure immediately after the .targetport_delete() callback.
This results in a use-after-free, and a crash if slub_debug=FZPU is enabled.

An earlier fix put put the completion on the stack, but commit 2a0fb340fcc8
("scsi: lpfc: Correct localport timeout duration error") subsequently changed
the code to reference the completion through a pointer in the object rather
than the local stack variable.  Fix this by using the stack variable directly.

Fixes: 2a0fb340fcc8 ("scsi: lpfc: Correct localport timeout duration error")
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 88760416a8cb..fcd9d4c2f1ee 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -2112,7 +2112,7 @@ lpfc_nvmet_destroy_targetport(struct lpfc_hba *phba)
 		}
 		tgtp->tport_unreg_cmp = &tport_unreg_cmp;
 		nvmet_fc_unregister_targetport(phba->targetport);
-		if (!wait_for_completion_timeout(tgtp->tport_unreg_cmp,
+		if (!wait_for_completion_timeout(&tport_unreg_cmp,
 					msecs_to_jiffies(LPFC_NVMET_WAIT_TMO)))
 			lpfc_printf_log(phba, KERN_ERR, LOG_NVME,
 					"6179 Unreg targetport x%px timeout "
-- 
2.18.1

