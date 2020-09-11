Return-Path: <SRS0=m8O6=CU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20896C433E2
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 18:01:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C955A221EE
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 18:01:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CMpAaEcx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725813AbgIKSBG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Sep 2020 14:01:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30553 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725794AbgIKSBF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Sep 2020 14:01:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599847264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xgQuGnAtCJW2lSv+isKvnoUt38ZjQfV86/V9pnD/Fcc=;
        b=CMpAaEcxlIguNHWHKs0HjVgQ46ZOzAzRHdfstqdA18QObKSWtOA6rb5bZzSzOkhbudooT1
        zjFol0lWn89Yat+CMdm2XHIM92VUdkkxQO21Kl6HUbCF9GBoXEi33QeAB04ocfczIiZ6Np
        yTtnSm8w4bH7Uc5WQ8AMNbGWEEzYfIY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-71-JeXcl_iDO9SFOgiO5BV34w-1; Fri, 11 Sep 2020 14:01:01 -0400
X-MC-Unique: JeXcl_iDO9SFOgiO5BV34w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 766EC80EF9D;
        Fri, 11 Sep 2020 18:01:00 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.40.193.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6439719C78;
        Fri, 11 Sep 2020 18:00:58 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, sathya.prakash@broadcom.com
Subject: [PATCH] mpt3sas: a small correction in _base_process_reply_queue
Date:   Fri, 11 Sep 2020 20:00:57 +0200
Message-Id: <20200911180057.14633-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is no need to compute module a simple comparision
is good enough.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index a67749c8f4ab..ea51fd04e3f1 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1627,7 +1627,7 @@ _base_process_reply_queue(struct adapter_reply_queue *reply_q)
 		 * So that FW can find enough entries to post the Reply
 		 * Descriptors in the reply descriptor post queue.
 		 */
-		if (!base_mod64(completed_cmds, ioc->thresh_hold)) {
+		if (completed_cmds >= ioc->thresh_hold) {
 			if (ioc->combined_reply_queue) {
 				writel(reply_q->reply_post_host_index |
 						((msix_index  & 7) <<
-- 
2.25.4

