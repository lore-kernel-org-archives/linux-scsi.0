Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2AFFC433E6
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Mar 2021 05:34:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A4366195A
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Mar 2021 05:34:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbhCUFeX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Mar 2021 01:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbhCUFeO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Mar 2021 01:34:14 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAABDC061574;
        Sat, 20 Mar 2021 22:34:11 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id y5so5804867qkl.9;
        Sat, 20 Mar 2021 22:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=COfGU7c260yAUkv4ea+94i00EmAb9aHsLSbBlf+tYFI=;
        b=H+yW18kbmaTisMbwJY3R/jzTRtLoKP8S7m8m2gCSQhNGptl0msbeVpWQZcKuTOJ67D
         1XCx4sMdM436FWgjg0gTYORvrqy+L5YyP6X0bzQ9B8emXXf6IiT1LD/ol+Vd53/mgsD6
         7QzjWw+AVnA9DcnUdm4tROjWTHXR7re98WvSsPPFhm4cXYn8khsEv1XzBK2uXyCsLizC
         ScNO4NskfRvUIrbTVsb9boxj/s3dwmAIHAfun2WS8Ddq07iWyPHJZ8iExs5n2ygWzw5Z
         OV778sf3blAR1Fqi+LFWgAdIrdLuC4OX5NB0Vh32DeAmvK1oOSVhmcIYsuHwO+k1tlnM
         D9dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=COfGU7c260yAUkv4ea+94i00EmAb9aHsLSbBlf+tYFI=;
        b=LCk05D9pqtLh2Iix4gfZms8D15KTUXLYV6wRxi1oR4jfqqKbmGV55GnAPp/LENj4hn
         56Ymah1tB3YXI1rYZTl3uuxt+OyuMtp0LWnEVX8zZBBvz34voBeQ1AraUvgiNJ6B2q3p
         CmArv1luQ3vjxdsuk/w1p9JgaDX085Zd/0ZwRQ7WE+jPqu9wdaiylnvd4n45pRP2bMZ3
         81JAT4rbBTapAz2/blKifxSXx5UVdXcCEee1GO2epV6vb3EDU/Wc93d19aoV+NiXvHcS
         pGYUwS76KX4uCQuA8tfvLuux+yuaXoz8XEwmeCFSdzJFMcrBvl7mZSomlGDGartuFEZ1
         pw9Q==
X-Gm-Message-State: AOAM530cvJ2cOd+ryroTQM0o0MBjlunyx9JsG2D0c1NHaZU2M7ahFPYb
        WNM0lo6QXNnVQ9ukrTc+kms=
X-Google-Smtp-Source: ABdhPJynnpoaukR+VQRmLvvAuFKvlrtZMfwsOVfJNNbcex08v6sU6yKSYPx1LY+4RQ0s4kA8CtJD2Q==
X-Received: by 2002:a05:620a:1474:: with SMTP id j20mr5616369qkl.272.1616304850787;
        Sat, 20 Mar 2021 22:34:10 -0700 (PDT)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:f925:bb4b:54d2:533])
        by smtp.googlemail.com with ESMTPSA id z5sm8039176qkz.2.2021.03.20.22.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 22:34:10 -0700 (PDT)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Matthew Wilcox <willy@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>
Subject: [PATCH] scsi: sym53c8xx_2: Fix WARN_ON in __sym_mfree_dma
Date:   Sun, 21 Mar 2021 01:33:48 -0400
Message-Id: <20210321053347.312135-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This fix is similar to b36522150e5b. The WARN_ON is triggered due to
irq being disabled while dma_free_coherent expect it enabled.

[    1.501363] WARNING: CPU: 0 PID: 179 at kernel/dma/mapping.c:467 dma_free_attrs+0x38/0x50
[    1.503940] RIP: 0010:dma_free_attrs+0x38/0x50
[    1.509138] Call Trace:
[    1.509273]  ___free_dma_mem_cluster+0x60/0x90 [sym53c8xx]
[    1.509570]  __sym_mfree+0xb2/0xd0 [sym53c8xx]
[    1.509811]  __sym_mfree_dma+0x65/0xa0 [sym53c8xx]
[    1.510070]  sym_hcb_free+0x8b/0x1e0 [sym53c8xx]
[    1.510320]  sym_free_resources+0x5c/0x7e [sym53c8xx]
[    1.510592]  sym2_probe.cold+0x3e3/0x555 [sym53c8xx]

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 drivers/scsi/sym53c8xx_2/sym_malloc.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_malloc.c b/drivers/scsi/sym53c8xx_2/sym_malloc.c
index eb5c045c7c59..54ec7e7bf87f 100644
--- a/drivers/scsi/sym53c8xx_2/sym_malloc.c
+++ b/drivers/scsi/sym53c8xx_2/sym_malloc.c
@@ -321,20 +321,16 @@ void *__sym_calloc_dma(m_pool_ident_t dev_dmat, int size, char *name)
 
 void __sym_mfree_dma(m_pool_ident_t dev_dmat, void *m, int size, char *name)
 {
-	unsigned long flags;
 	m_pool_p mp;
 
-	spin_lock_irqsave(&sym53c8xx_lock, flags);
 	mp = ___get_dma_pool(dev_dmat);
 	if (!mp)
-		goto out;
+		return;
 	__sym_mfree(mp, m, size, name);
 #ifdef	SYM_MEM_FREE_UNUSED
 	if (!mp->nump)
 		___del_dma_pool(mp);
 #endif
- out:
-	spin_unlock_irqrestore(&sym53c8xx_lock, flags);
 }
 
 /*
-- 
2.25.1

