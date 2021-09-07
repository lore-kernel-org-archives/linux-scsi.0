Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C904C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 04:07:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D89D610A3
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 04:07:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbhIGEIP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Sep 2021 00:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbhIGEIO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2021 00:08:14 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF95AC061575;
        Mon,  6 Sep 2021 21:07:08 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id f11-20020a17090aa78b00b0018e98a7cddaso1181723pjq.4;
        Mon, 06 Sep 2021 21:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eoAtwz/HI/43X/dImzE2MSr2lE2uK0vvPjZTO/+eO94=;
        b=nkBZzaoGaVDLDtJbh82aWdYllxxJ0jwYm7q+0OQTUS6OJFNBhtDnSmC75Hiuk2T87y
         6KHWCQCC9IA6ZnnCNER/D32f9M7QiINiDjQvAazh2KvJbX+ytN0bqr0/R4VQ4Ot3LwMs
         SWbJMgIGGIa690jvX8/zACeO3qw3Ak16LK0fU1nDB0AJWfZq5XajX6MHMvrSl1tPvhFf
         /sH8z5lgk11mFljz/q3yNPxTJcvHQd8qAZs27cQMgV61CfqMeQHNvINKdpg0VZRzUiWj
         NE+uTj64sPJCWUQ8USGSgfj/JGsbM6nfoJm9BykLkZpkAWg1u5P+yACXXiLi1I2nZqNw
         hvlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eoAtwz/HI/43X/dImzE2MSr2lE2uK0vvPjZTO/+eO94=;
        b=YXrFBX7fIFA4KUFFsTOPjzHd7j7vGrAUyhswDk8ZzNkYxRcxVTHOG3uIKLmwkBKBBm
         LJqhb9FWV7V0kDl8w6xwA8ugmXzsfhfQ5krggI95BK6raohAXauOBu5HgX/MIhUM57UO
         oaHqWAeQYTQ6nxBgLWFHatzF3TpCTL2XM90MIubqYdMiNqUNUtNvJrDlASn1jNLOMKrt
         pngiFSMoxI75yDJe3CFjOFHPFqbw15WrZs3udq20ci9UKDg/deVhzP+kVyRYLXXNIgdg
         CgjWoNgzVQNIzAPZFy23l+dEbx+p0NlmhEJJj5oNtijyNljf+vO0a2nGqpZYULHZ38Hl
         W9AQ==
X-Gm-Message-State: AOAM532ggaY0PWp5cS5Y7Gfq11geupejyJrJw+1UQ45VSJuGC8tuqbZj
        z0917BelCR5uasFAhzYflDE=
X-Google-Smtp-Source: ABdhPJyNXtUK0r5C3DcP4PQzsZ1BeRfL99Edo04uZhTP+/8ItWPRQ8jsT4QqI0YFb621wNZSj+L1Hg==
X-Received: by 2002:a17:90a:d98f:: with SMTP id d15mr2445084pjv.81.1630987628198;
        Mon, 06 Sep 2021 21:07:08 -0700 (PDT)
Received: from tong-desktop.local (99-105-211-126.lightspeed.sntcca.sbcglobal.net. [99.105.211.126])
        by smtp.googlemail.com with ESMTPSA id b7sm8894873pfl.195.2021.09.06.21.07.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 21:07:07 -0700 (PDT)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        dc395x@twibble.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>
Subject: [PATCH v1] scsi: dc395: fix error case unwinding
Date:   Mon,  6 Sep 2021 21:07:02 -0700
Message-Id: <20210907040702.1846409-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

dc395x_init_one()->adapter_init() might fail. In this case, the acb
is already clean up by adapter_init(), no need to do that in
adapter_uninit(acb) again.

[    1.252251] dc395x: adapter init failed
[    1.254900] RIP: 0010:adapter_uninit+0x94/0x170 [dc395x]
[    1.260307] Call Trace:
[    1.260442]  dc395x_init_one.cold+0x72a/0x9bb [dc395x]

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 drivers/scsi/dc395x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 24c7cefb0b78..1c79e6c27163 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -4618,6 +4618,7 @@ static int dc395x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	/* initialise the adapter and everything we need */
  	if (adapter_init(acb, io_port_base, io_port_len, irq)) {
 		dprintkl(KERN_INFO, "adapter init failed\n");
+		acb = NULL;
 		goto fail;
 	}
 
-- 
2.25.1

