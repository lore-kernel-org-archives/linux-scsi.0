Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16F4CC433E9
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 11:21:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C735264E50
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 11:21:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233141AbhBHLVd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Feb 2021 06:21:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24430 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233002AbhBHLTG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2021 06:19:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612783060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=egzrPLCah6NX0TxFcJWMchtfOaE9giI/YcChA/2ws38=;
        b=URfmIixyb70qMlzwePA0XYsSatabFAUxvB9kBagZRbrDx1PaU95Il54XtlsWQtequfE507
        l7w/JI5aV6bhXnNPNWPCH4W001ASeS0Z7kZsdJALhEwFUOqYymCG7jo67UOTy2+CIBKRle
        +jLdWYoW6eT0Ey1XNtexwDIu27M/bME=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-sAzPkYxQPDmRKsHa611BoQ-1; Mon, 08 Feb 2021 06:17:38 -0500
X-MC-Unique: sAzPkYxQPDmRKsHa611BoQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E49E81966321;
        Mon,  8 Feb 2021 11:17:36 +0000 (UTC)
Received: from nangaparbat.redhat.com (unknown [10.40.193.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A3281002388;
        Mon,  8 Feb 2021 11:17:35 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        dgilbert@interlog.com
Subject: [PATCH] scsi: scsi_debug: fix a memory leak.
Date:   Mon,  8 Feb 2021 12:17:34 +0100
Message-Id: <20210208111734.34034-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The sdebug_q_arr pointer must be freed when the module is unloaded

# cat /sys/kernel/debug/kmemleak
unreferenced object 0xffff888e1cfb0000 (size 4096):
  comm "modprobe", pid 165555, jiffies 4325987516 (age 685.194s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000458f4f5d>] 0xffffffffc06702d9
    [<000000003edc4b1f>] do_one_initcall+0xe9/0x57d
    [<00000000da7d518c>] do_init_module+0x1d1/0x6f0
    [<000000009a6a9248>] load_module+0x36bd/0x4f50
    [<00000000ddb0c3ce>] __do_sys_init_module+0x1db/0x260
    [<000000009532db57>] do_syscall_64+0xa5/0x420
    [<000000002916b13d>] entry_SYSCALL_64_after_hwframe+0x6a/0xdf

Fixes: 87c715dcde633f4cc4690a24a240e838181e6a9d

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/scsi/scsi_debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 4a08c450b756..b6540b92f566 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6881,6 +6881,7 @@ static void __exit scsi_debug_exit(void)
 
 	sdebug_erase_all_stores(false);
 	xa_destroy(per_store_ap);
+	kfree(sdebug_q_arr);
 }
 
 device_initcall(scsi_debug_init);
-- 
2.29.2

