Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 855A8C433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 14:01:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60D6720738
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 14:01:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XmmS1R2D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbgGGOBL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 10:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728232AbgGGOBK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2020 10:01:10 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F70C08C5E1
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2020 07:01:10 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 22so43400995wmg.1
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jul 2020 07:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5akYiP5XbUbIIHU3yZTiMoBU1iltsAOw/hCtwfTaVJc=;
        b=XmmS1R2D9LdImdLyKuJbGDYLB/QYqj96CLTES0Hlurxb83iEVSOZjhC74NA3FNUelQ
         x3wmfifyk/fKrMiPve8zbbTsvCV7UcsUd0OxmveVMbfZwHXFFXHwDPeEzSChk1mVG4Wn
         v/FiUOq1EMMxM1DAtPF1xArvV707BeOj3E83i07QtyqPbhBYlv/MO2ydJxGqSbYoENE2
         /Y3K5hBOFPGk1oPCkuhHZ8pqhicPWsd+S3xOKp9cFFrb3L1tBG7goNQFL/EXHs7MhYTO
         /UzKa3qSDPe5HHpccqJfVZYdAKYVlTdKk0TfXV4htQ2UPmq+q71tTFVWoqyA1m/5QveK
         K14w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5akYiP5XbUbIIHU3yZTiMoBU1iltsAOw/hCtwfTaVJc=;
        b=t7bCuSfhMDVAOMAL9KkeVG7gmo5fAkbZC0u1uYjkq2zNW+nyDP6K2LBWyoWDY5zyRI
         aLhbAx95tVBjoRCikmw5N/4XxlT6c65sNkooZ3DTn6fTzvlGIsxTMP/TKR7/yvyjPPqL
         yRl0+OpY1zpe2lESrsUrxYIvza7HH+iNUgtD8F5WoTyWotGdQQVK2h+7iaIbI/B+JwAg
         maknt+3OoxP+ptdmp+ZQoV9fsTGBPAMv9OMoFys9/IkoW0WYUN5NQc6AqM8eT1ETzAPX
         6nfrGPwAJGAATCbi09IaQp1/cIV5Of3YRrnM0bEwVNGPMflo94uwF8x904D/U+tbaZQH
         lQMg==
X-Gm-Message-State: AOAM533oXDRpd2Q2rcELHWoGWPmT4N91+Ot1pdabOgPqgVXBXMcgg/C3
        8zArxYkQ8Xwfx3PNqmzlC7gcMXfsErw=
X-Google-Smtp-Source: ABdhPJwF1qF3Syu4cPqExQf8v8cF2iIj2GQcEkvKs7cauiEiajVIwpD26hksjr8q2pDY/chIhqABXg==
X-Received: by 2002:a1c:7916:: with SMTP id l22mr4167207wme.115.1594130469133;
        Tue, 07 Jul 2020 07:01:09 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id z25sm1102823wmk.28.2020.07.07.07.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 07:01:08 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Subject: [PATCH 08/10] scsi: pcmcia: nsp_cs: Remove unused variable 'dummy'
Date:   Tue,  7 Jul 2020 15:00:53 +0100
Message-Id: <20200707140055.2956235-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200707140055.2956235-1-lee.jones@linaro.org>
References: <20200707140055.2956235-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is no need to populate an unused variable, even if the read is required.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/pcmcia/nsp_cs.c: In function ‘nsp_cs_message’:
 drivers/scsi/pcmcia/nsp_cs.c:143:2: warning: function ‘nsp_cs_message’ might be a candidate for ‘gnu_printf’ format attribute [-Wsuggest-attribute=format]
 drivers/scsi/pcmcia/nsp_cs.c: In function ‘nsp_fifo_count’:
 drivers/scsi/pcmcia/nsp_cs.c:692:24: warning: variable ‘dummy’ set but not used [-Wunused-but-set-variable]

Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/pcmcia/nsp_cs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 57a78f84f97ab..8655ff1249bbc 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -690,14 +690,14 @@ static int nsp_fifo_count(struct scsi_cmnd *SCpnt)
 {
 	unsigned int base = SCpnt->device->host->io_port;
 	unsigned int count;
-	unsigned int l, m, h, dummy;
+	unsigned int l, m, h;
 
 	nsp_index_write(base, POINTERCLR, POINTER_CLEAR | ACK_COUNTER);
 
 	l     = nsp_index_read(base, TRANSFERCOUNT);
 	m     = nsp_index_read(base, TRANSFERCOUNT);
 	h     = nsp_index_read(base, TRANSFERCOUNT);
-	dummy = nsp_index_read(base, TRANSFERCOUNT); /* required this! */
+	nsp_index_read(base, TRANSFERCOUNT); /* required this! */
 
 	count = (h << 16) | (m << 8) | (l << 0);
 
-- 
2.25.1

