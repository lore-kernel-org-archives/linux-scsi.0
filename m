Return-Path: <SRS0=73BN=CK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37CD9C433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 14:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09A66206FA
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 14:50:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YBnrV5zE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbgIAOue (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Sep 2020 10:50:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30489 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728684AbgIAOud (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2020 10:50:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598971831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hk+nnrEUzdrG0gShwhTtnOjobtnKttAuNgJIu6TBvdo=;
        b=YBnrV5zEZJeE4fN8vK8dYkCBHYNyUUZ0bNSVSPbl9YB6PpJr5C5RzVJZ9NnEHXFDcJfUE4
        NIn1IohZ6FAeeKtZzEy9++0a5r5rXcAgkHb638ZEqPo1wKN0t9ULMRvfGcOacpa0nVn57H
        zyppWWYoDBdXgRRmP7D654EFIOoXX4Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-6ee6TuqmM5KlgxlK2Cejgg-1; Tue, 01 Sep 2020 10:50:29 -0400
X-MC-Unique: 6ee6TuqmM5KlgxlK2Cejgg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8193F10082E8;
        Tue,  1 Sep 2020 14:50:28 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.40.195.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 736E11002D52;
        Tue,  1 Sep 2020 14:50:27 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     sreekanth.reddy@broadcom.com, Sathya.Prakash@broadcom.com,
        suganath-prabu.subramani@broadcom.com
Subject: [PATCH] scsi: mpt3sas: Don't call disable_irq from IRQ poll handler
Date:   Tue,  1 Sep 2020 16:50:26 +0200
Message-Id: <20200901145026.12174-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

disable_irq might sleep, replace it with disable_irq_nosync,
for synchronisation is the 'irq_poll_scheduled' sufficient

Fixes: 320e77acb3 scsi: mpt3sas: Irq poll to avoid CPU hard lockups

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 96b78fdc6..a85c9672c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1732,7 +1732,7 @@ _base_irqpoll(struct irq_poll *irqpoll, int budget)
 	reply_q = container_of(irqpoll, struct adapter_reply_queue,
 			irqpoll);
 	if (reply_q->irq_line_enable) {
-		disable_irq(reply_q->os_irq);
+		disable_irq_nosync(reply_q->os_irq);
 		reply_q->irq_line_enable = false;
 	}
 	num_entries = _base_process_reply_queue(reply_q);
-- 
2.25.4

