Return-Path: <SRS0=xWhZ=DN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE37CC46466
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Oct 2020 07:26:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6609A2083B
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Oct 2020 07:26:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=areca-com-tw.20150623.gappssmtp.com header.i=@areca-com-tw.20150623.gappssmtp.com header.b="eUM1Oz7S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbgJFH0q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 03:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbgJFH0q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2020 03:26:46 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53217C061755
        for <linux-scsi@vger.kernel.org>; Tue,  6 Oct 2020 00:26:46 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id y14so7493892pgf.12
        for <linux-scsi@vger.kernel.org>; Tue, 06 Oct 2020 00:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:mime-version
         :content-transfer-encoding;
        bh=8rz1KkWtlGOhoU1TY+rLGSPISx+mjnHN8lk/rmGsedo=;
        b=eUM1Oz7S4AwJEUhE+p370iJdONenCO4m9eJageChF8Cr7raAmgtom0pQTvGNwmgSyr
         JYIRg7DpI0TX+eqskhQ5djzFOvDWqiPtzVdckjrSw0pw9bSzPDUhltbIYZcffWqOp0q+
         nTKCzFPWHWRYs91BfH8XeQX4x5QIBk0wnn3yA6WzP7WEmfNygdRk63bTJx+xXVgVJxMx
         HA/Wz9VBbRbZKo7bN655TGkan3eNRQ1IELwnpgHVDnbD9OPviTCTeiBEggfZ1brrNJoy
         WPRxTpJzK+ytVSG8Tp4wZlOKCVg4+0Y5XwNDhH9vwaTWj/r3JwuuHrs0dmmkzo4MSX09
         6e2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:mime-version
         :content-transfer-encoding;
        bh=8rz1KkWtlGOhoU1TY+rLGSPISx+mjnHN8lk/rmGsedo=;
        b=tWuB9fzhMqssF5Zb8aPgLZY/DWkR3KLQJjiiv8aMEwmPRtBaYOVSXGIkPO6YPcsXW1
         Z1Uzhg4CSXtY7bJcokmeUXO27I/6DwUpY8Ig02lxcGGvPRN7yzJylpkjopXnAHTIisKJ
         x4t+QjEQmQQaUhHYwhiosU/Nqbf1FrJbO5IW7YFquODdLInpqnz7usIw/TJ9oArAC6xF
         YJmJFhYPJ8jop2wNvgdryw4qIpsjBPd7PRzt+O7w7HdADKUPcWTXkdkYgE2ThykKoodY
         Or9NOM8EYYAHNvWnqgx6nT/DPySiVR4piizY5LT/3kRrr5Zz+JbPnot1ud9TyfkdQ8qv
         zAZQ==
X-Gm-Message-State: AOAM531p/pI/+mrQ4yipoSEkTWKuxWZ/OtZ/iTSfC7gnC47D5TonvK6A
        EIPp801amZcA3zepyXz/ebsHBw==
X-Google-Smtp-Source: ABdhPJzXTRB9wEwwSQzinG5SgAEEw38/Y4CNdR2ICpLw2C6FaC3TE0gmbKfY8G3FWkF3ozy+vpQi8w==
X-Received: by 2002:a62:1d57:0:b029:152:47a7:e04b with SMTP id d84-20020a621d570000b029015247a7e04bmr3534927pfd.48.1601969205902;
        Tue, 06 Oct 2020 00:26:45 -0700 (PDT)
Received: from centos78 (60-248-88-209.HINET-IP.hinet.net. [60.248.88.209])
        by smtp.gmail.com with ESMTPSA id c187sm2533925pfc.0.2020.10.06.00.26.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Oct 2020 00:26:45 -0700 (PDT)
Message-ID: <cbc8c0c56bc82f2abe61f3259ddc6f8c8c9ca53b.camel@areca.com.tw>
Subject: PATCH 1/1] scsi: arcmsr: fix warning: right shift count >= width of
 type
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc:     kbuild test robot <lkp@intel.com>
Date:   Tue, 06 Oct 2020 15:26:44 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ching Huang <ching2048@areca.com.tw>

Fix warning: right shift count >= width of type.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index be6fb72..d13d672 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -655,7 +655,7 @@ static void arcmsr_hbaF_assign_regAddr(struct AdapterControlBlock *acb)
 	/* host buffer low address, bit0:1 all buffer active */
 	writel((uint32_t)(host_buffer_dma | 1), &pmuF->inbound_msgaddr0);
 	/* host buffer high address */
-	writel((uint32_t)(host_buffer_dma >> 32), &pmuF->inbound_msgaddr1);
+	writel(dma_addr_hi32(host_buffer_dma), &pmuF->inbound_msgaddr1);
 	/* set host buffer physical address */
 	writel(ARCMSR_HBFMU_DOORBELL_SYNC1, &pmuF->iobound_doorbell);
 }
@@ -4083,7 +4083,7 @@ static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)
 		acb->msgcode_rwbuffer[4] = acb->ccbsize;
 		dma_coherent_handle = acb->dma_coherent_handle2;
 		cdb_phyaddr = (uint32_t)dma_coherent_handle;
-		cdb_phyaddr_hi32 = (uint32_t)(dma_coherent_handle >> 32);
+		cdb_phyaddr_hi32 = dma_addr_hi32(dma_coherent_handle);
 		acb->msgcode_rwbuffer[5] = cdb_phyaddr;
 		acb->msgcode_rwbuffer[6] = cdb_phyaddr_hi32;
 		acb->msgcode_rwbuffer[7] = acb->completeQ_size;


