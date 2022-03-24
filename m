Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EEFEC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Mar 2022 13:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350553AbiCXNro (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Mar 2022 09:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350545AbiCXNrn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Mar 2022 09:47:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 88CD788B27
        for <linux-scsi@vger.kernel.org>; Thu, 24 Mar 2022 06:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648129568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JqOZHd3EFckCXhqkJIHF1g/3I/hDC+yFZg3NskSZhts=;
        b=T7RubHUqkyFKyPI9PMKKNKPHPtphjNZGubl2Fo+VrFvxooeBJVza/7wglIAEQv0SBZ9+py
        wYVDoTLDb2WlBdgLp5yMIon5BvaGR9a0gqUxXbitBLK2WFN+3f+T4c2bIjGigNrbyZObSc
        E7ebMSMfzzj7qnFEr8qPr4bA1cxLnzs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-10-kRqwimtUMUmW7fJ7m-cE5w-1; Thu, 24 Mar 2022 09:46:05 -0400
X-MC-Unique: kRqwimtUMUmW7fJ7m-cE5w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A03C48041AE;
        Thu, 24 Mar 2022 13:46:04 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.40.193.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F160400F738;
        Thu, 24 Mar 2022 13:46:03 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     hch@infradead.org
Subject: [PATCH] scsi_logging: fix a BUG
Date:   Thu, 24 Mar 2022 14:46:03 +0100
Message-Id: <20220324134603.28463-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The request_queue may be NULL in a request, for example when it comes
from scsi_ioctl_reset.
Check it before before use.

Fixes: f3fa33acca9f ("block: remove the ->rq_disk field in struct request")

Reported-by: Changhui Zhong <czhong@redhat.com>
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/scsi_logging.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
index 1f8f80b2dbfc..a9f8de5e9639 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -30,7 +30,7 @@ static inline const char *scmd_name(const struct scsi_cmnd *scmd)
 {
 	struct request *rq = scsi_cmd_to_rq((struct scsi_cmnd *)scmd);
 
-	if (!rq->q->disk)
+	if (!rq->q || !rq->q->disk)
 		return NULL;
 	return rq->q->disk->disk_name;
 }
-- 
2.35.1

