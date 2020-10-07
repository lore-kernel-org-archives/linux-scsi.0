Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5412BC4363C
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 07:31:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D58DB207EA
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 07:31:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=areca-com-tw.20150623.gappssmtp.com header.i=@areca-com-tw.20150623.gappssmtp.com header.b="xys4W4yp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727717AbgJGHbr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 03:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbgJGHbr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 03:31:47 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC467C061755
        for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2020 00:31:45 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 22so837364pgv.6
        for <linux-scsi@vger.kernel.org>; Wed, 07 Oct 2020 00:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=6hV7PJClGfgaN5TCcjKdtC8dZqi0TjTnFZSL7SHtRuk=;
        b=xys4W4ypmtRSJhPuvzq7s7axuVnaIiwpBUAUfnpo3KP7OiUS7EPpweAu0+QNIy7gz/
         m92F1Mns/2D+LivzbQ2pD7lHWvB/JlX+EF0I2p45tDKi+friRCqi0MIjWrVC+808yT3t
         kHPVF5iCy9mdBMqHcbawN7bJVWaE7KaMxDxEiVMUXRxh1UVwYS+jInOLOPm5bOt19K02
         nY5JJxDFJGHStYdVzRLX9mlwU/NY+QwLjVMxzdObGqnz2RgKHtBlffpiTHquToIFrAov
         dedhuUoSNf6n6/Bip5VawgAr8tjh9ORsGVM3Ka3ZPHXZlYcnDOHcfI7ejuh9IaAq+3tA
         pvqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=6hV7PJClGfgaN5TCcjKdtC8dZqi0TjTnFZSL7SHtRuk=;
        b=AF7nCuWSW6eBmpYHd+EdkQFmxKU+IIwCVLPTwOcW+qIu9DSpF/RF/knumY2GE08azv
         PLO1vfPDTMBltH2DKB7duKBY1Z0RP2XeVkO9Sd4fpyyfk0+322HM5dCoTQtT4FRLN8bX
         sv7nofoukrlLxwtwWu+ougtS5fUjvNN40UYrPABjS1rz2IZsM+XBDKq2wT3rZQtyLk1i
         73Cp9F0e8NdpGlA8Dc2R6p5jy+uRrXGWjqiwt8904y0mGjYPgBmC9KBqdWV88g6Lv/jP
         13fn5EkLByffEmYsPL/f80tldMDNwgUhW0ggQsI3tmf1rSotB2u3tvpS8mmJVCJDtG+m
         CErw==
X-Gm-Message-State: AOAM532wfxLm+DmIHsc8mSQFPgngUr4322ioahv0vXj0aKXg8K2LsQwo
        G4ahJJUZMzXWVPL805sNhflsUw==
X-Google-Smtp-Source: ABdhPJzkvpBvMcshEG/PBntDPZnKQ0S/7L3SIzNxi8KvQ81B4ZFVi+qGVidyehgCG3ndaMOz6HyKpQ==
X-Received: by 2002:a63:5663:: with SMTP id g35mr1917905pgm.163.1602055905370;
        Wed, 07 Oct 2020 00:31:45 -0700 (PDT)
Received: from centos78 (60-248-88-209.HINET-IP.hinet.net. [60.248.88.209])
        by smtp.gmail.com with ESMTPSA id o17sm1224263pji.30.2020.10.07.00.31.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Oct 2020 00:31:44 -0700 (PDT)
Message-ID: <fd826c8ec91cfc49a17eb107a2e81087dfcde3cb.camel@areca.com.tw>
Subject: [PATCH v3 2/2] scsi: arcmsr: use round_up() instead of logical
 operation
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Wed, 07 Oct 2020 15:31:44 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ching Huang <ching2048@areca.com.tw>

Use round_up() instead of logical operation.

Reported-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 55d85c9..1e358d9 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -644,13 +644,12 @@ static void arcmsr_hbaF_assign_regAddr(struct AdapterControlBlock *acb)
 	struct MessageUnit_F __iomem *pmuF;
 
 	memset(acb->dma_coherent2, 0xff, acb->completeQ_size);
-	acb->message_wbuffer = (uint32_t *)((((unsigned long)acb->dma_coherent2 +
-		acb->completeQ_size + 3) >> 2) << 2);
+	acb->message_wbuffer = (uint32_t *)round_up((unsigned long)acb->dma_coherent2 +
+		acb->completeQ_size, 4);
 	acb->message_rbuffer = ((void *)acb->message_wbuffer) + 0x100;
 	acb->msgcode_rwbuffer = ((void *)acb->message_wbuffer) + 0x200;
 	memset((void *)acb->message_wbuffer, 0, MESG_RW_BUFFER_SIZE);
-	host_buffer_dma = ((acb->dma_coherent_handle2 + acb->completeQ_size +
-		3) >> 2) << 2;
+	host_buffer_dma = round_up(acb->dma_coherent_handle2 + acb->completeQ_size, 4);
 	pmuF = acb->pmuF;
 	/* host buffer low address, bit0:1 all buffer active */
 	writel(lower_32_bits(host_buffer_dma | 1), &pmuF->inbound_msgaddr0);

