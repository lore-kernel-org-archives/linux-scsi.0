Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C1E9C4363A
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 03:39:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A5032158C
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 03:39:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=areca-com-tw.20150623.gappssmtp.com header.i=@areca-com-tw.20150623.gappssmtp.com header.b="0tF30+v9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505134AbgJ0DjP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 23:39:15 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:47019 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2505071AbgJ0DjP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2020 23:39:15 -0400
Received: by mail-pg1-f194.google.com with SMTP id n16so7227046pgv.13
        for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2020 20:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=LupE/J6VcTBMhjtEQjjbSyPrr1jGLP4woAI8/ZP2Aio=;
        b=0tF30+v9LcH8Hf77Y82B52LfDGR/JCo9+LQaJ2XQEcC5z9oGYZaGdRsMg88Fu2R7js
         l4kXUDyXXOPuLxzF58zzNC4rcw7dYZYzjAUJPlzEH9mXzfjKAg4tG0K8UPxH7Aea5DEB
         GhpCkIlzf51VHFnzbXru16SdLR3L8hOIDC+JCvIj8hxes0e/BS1xeHD3f2rYDX8cba8i
         6kHPAspZ7gxmk7i0a4DoZGb+NBTc22KbU664QWA+K+ZRJ+xgot4TW2vYOhOylXd7JpXy
         iWMUV3Y6GYgIFwtwWADbgvikXhrnKAdodIyjbyZwc3O2zYIsM1wwnkD0/UHTPdR/K46u
         T9sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=LupE/J6VcTBMhjtEQjjbSyPrr1jGLP4woAI8/ZP2Aio=;
        b=Drcpit0/qzBoh64Zy4hRjoSus+q/vAeFFDh94jxb8BjmnlDT1FPQxCl9/hbIrqfiBi
         scsqa/D5nntyADvwtN3lbXzb0YfOkWUzcjDRmhxAvqHAUcGjheGuhurbahAKcUi3VD9F
         uEqUJN+we5b9hf7NsxJAtNl1SsMVXUGSHIYxYEXUB4vUEFb9Xg37/R3TcuWlWyTKGvVm
         7dKcRvyqd72x1zj8XKH7lmPrmnsLebg1dzmdwYrNod1hdiC6PMc6qgr9mFnDN4Y4IbKd
         ARte/34+QmEM5pL9lZE0LaEu+Bx2MwrqZb4nCz4cp8WXHrkth9paIBB6AcpE4XwPBsZZ
         J8PA==
X-Gm-Message-State: AOAM533tINmk0gPxp9dLTwi95V0Fr7wFF7M/NV2wJAq7gO10OKjnCODO
        QFGJLOx9Ek6MspkcDQ59+x/b6w==
X-Google-Smtp-Source: ABdhPJxL2BTEjdugLbB8On3VBB10WG4v5IQYYWc1EtgUICfi+uK5W/KXh8U7yp8AusiQBMUHsg2Z0Q==
X-Received: by 2002:aa7:9a1b:0:b029:163:edfa:64a2 with SMTP id w27-20020aa79a1b0000b0290163edfa64a2mr418342pfj.70.1603769954732;
        Mon, 26 Oct 2020 20:39:14 -0700 (PDT)
Received: from centos78 (60-248-88-209.HINET-IP.hinet.net. [60.248.88.209])
        by smtp.gmail.com with ESMTPSA id k10sm187689pji.54.2020.10.26.20.39.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Oct 2020 20:39:14 -0700 (PDT)
Message-ID: <f3ec374cada762149911ff35e92a68a15a7d0327.camel@areca.com.tw>
Subject: [PATCH v2 2/2] scsi: arcmsr: Confirm getting a free ccb is in
 spin_lock circle
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Tue, 27 Oct 2020 11:39:13 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ching Huang <ching2048@areca.com.tw>

Confirm getting a free ccb is in spin_lock circle.

Signed-off-by: ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 7cfae1d..127fe50 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -3162,10 +3162,12 @@ message_out:
 
 static struct CommandControlBlock *arcmsr_get_freeccb(struct AdapterControlBlock *acb)
 {
-	struct list_head *head = &acb->ccb_free_list;
+	struct list_head *head;
 	struct CommandControlBlock *ccb = NULL;
 	unsigned long flags;
+
 	spin_lock_irqsave(&acb->ccblist_lock, flags);
+	head = &acb->ccb_free_list;
 	if (!list_empty(head)) {
 		ccb = list_entry(head->next, struct CommandControlBlock, list);
 		list_del_init(&ccb->list);

