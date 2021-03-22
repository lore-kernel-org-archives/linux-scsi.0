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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C20DC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 00:30:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51F5A61943
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 00:30:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbhCVAaL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Mar 2021 20:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbhCVA3p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Mar 2021 20:29:45 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0789C061574;
        Sun, 21 Mar 2021 17:29:44 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id r14so11171526qtt.7;
        Sun, 21 Mar 2021 17:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B6SigcP6ulMq6zpC8NopiLuX8xkC2iqoMudeRKz2q1I=;
        b=Zp50KLfymywIXjuI4sBF/0J6Sjs4++oyXqR3N16MaXF2e9x5+hs2DJyKMHXm7eWfLA
         6COOxYgTwPWk3uV1LzH3qaEsKCLp16BHIz0Ow2qLdjksJHV1Cj5lwUil4iTLmwohAWnu
         WgKTOP4pSKsBJG36Ps42VfVNPpqfXF4Y3p5durjkK7EvBMlEa8n09U+rX3F1Jc7qLnSa
         o8R5Rag7NQ1W3KXfRx8n6bwbCmRJKtatS0Fu9/PXxpUHMCOVjjXTmggbeaGG3QBFNW3P
         V9hbbrLp40tYFo+lPDVS7xizugoEdep0Ot70dZ6xoQeqJ5H6wjWh6CdjOlA4FbZ9frjU
         uv9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B6SigcP6ulMq6zpC8NopiLuX8xkC2iqoMudeRKz2q1I=;
        b=bMaq7b6Jo1BT6VSI05TG30yIq4P1JdSnkzIGvZwtt3TLorcxHmC+ezOUsK4ULMRyFC
         NDUZGVnJzPr3zUiOJypwDIDb57sUI0gnUOdN9Ctqu4gNhW1j7muQXUakIc1rl4+G9+At
         jv97idFbeHSzuwdRch0ROG9q66kmMmuDfsi3JhtdoNpm/OzJ5qa++wF/ku2pZOy2Vb2/
         tHouE5UdwzGKaljSKg/aDoLThn2eiELgR8tldlxbzfafIYa2kczHIPIo1p6K6Z7B5KTF
         Sp6/7ucgthOUa51SoY1704ppTWL40UZataEHO1TNVG2Lo7bJdNSbVLH2/fqxBdT46flE
         RfLA==
X-Gm-Message-State: AOAM531h9vsUsplly76wQyBL+9Xf3fMbfhJzeSy3kY+0lOmY556vthrA
        TS5il0pNmXoNoNm6sutXFZvMklLLqS6jOw==
X-Google-Smtp-Source: ABdhPJwRSYDlrum2Xa6FwxzgJOELx1cYJ4xq2Lp7wgY7ih72DWZu3yfrZ5gykCijeT1vCK+2Q85NiA==
X-Received: by 2002:a05:622a:446:: with SMTP id o6mr7540783qtx.257.1616372984233;
        Sun, 21 Mar 2021 17:29:44 -0700 (PDT)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:f925:bb4b:54d2:533])
        by smtp.googlemail.com with ESMTPSA id j3sm9721373qki.84.2021.03.21.17.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 17:29:43 -0700 (PDT)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     ztong0001@gmail.com
Subject: [PATCH 2/2] scsi: myrb: fix null-ptr-dereference in myrb_probe
Date:   Sun, 21 Mar 2021 20:29:35 -0400
Message-Id: <20210322002936.1352871-3-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210322002936.1352871-1-ztong0001@gmail.com>
References: <20210322002936.1352871-1-ztong0001@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

cb->host should be initialized and set before it is used by the
following probe logic and the interrupt handler etc.

[    5.073493] BUG: kernel NULL pointer dereference, address: 00000000000002cc
[    5.075907] RIP: 0010:kobject_put+0x25/0x120
[    5.081572] Call Trace:
[    5.081720]  myrb_probe.cold+0x22/0xabc [myrb]
[    5.083510]  local_pci_probe+0x6f/0xb0

Fixes: 081ff398c56c ("scsi: myrb: Add Mylex RAID controller (block interface)")
Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 drivers/scsi/myrb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index ee33d97fb92c..7de49b869128 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -3512,6 +3512,7 @@ static struct myrb_hba *myrb_detect(struct pci_dev *pdev,
 	shost->max_cmd_len = 12;
 	shost->max_lun = 256;
 	cb = shost_priv(shost);
+	cb->host = shost;
 	mutex_init(&cb->dcmd_mutex);
 	mutex_init(&cb->dma_mutex);
 	cb->pdev = pdev;
-- 
2.25.1

