Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C04FBC4363C
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 07:26:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 617D220870
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 07:26:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=areca-com-tw.20150623.gappssmtp.com header.i=@areca-com-tw.20150623.gappssmtp.com header.b="oxZ9aBBp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbgJGH0y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 03:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbgJGH0x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 03:26:53 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8004C0613D2
        for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2020 00:26:53 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id a1so618141pjd.1
        for <linux-scsi@vger.kernel.org>; Wed, 07 Oct 2020 00:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=FPB7OOQl4IYhU+HU218GOVBRq9NfyKJiihhmcpJ2Hao=;
        b=oxZ9aBBpkvOvdgr2CrqMxbh+tb9oWDoEjkUWOAV7zx1x45otIdu0jTGj6y6nkL9WfS
         83ncVldNuP0AIzasgpAL+hE8845xe6QEViCK5skmnbfjgNKKJtLikVLMaRix0RT4L/Hb
         Rpgmrcn23wZnkmsolZ5xRGGEc5PyosU1awEHsTwHrDUSxKR9zRV6VPVAp1QpaFwtJEbg
         v1fiA1kn21yUceRFI3MQkAvxIiTafFcxx32ICjJ9qlWxd2x8cFZnjuBT4obe/P2mrA+r
         KUUSZ1LURs7GGAvF6yaE1zNfMwIViXeeSpK8qS2NYX+4qy7v8lNDF/h2MPTySi+u0LQF
         9iGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=FPB7OOQl4IYhU+HU218GOVBRq9NfyKJiihhmcpJ2Hao=;
        b=gjGttESLGRdPtE068mK717pqjVq8Viu55lPU3r5xi/qIETWxH78UpAChoH+BHhl339
         xpLuQXBiD0Rny//GjsT47yAQS1M6Myy5SAmyLdFoTzmD7PbLzdtdk5NXNDkomNc46Z/9
         pfKFDaGjRWeJJMVDJLGDcoGo98fltgfQHKzwPCVgnrr4c6kyWfQ7en9ICfoUBENYrhGT
         Iyi7vye7GUiXCd2J3CNID44aCaxWJmxgbdpYjC2r3rRnxl9BzRRq7TYGQ+xv5GuW9qwD
         NZTeNvUpl+7+XsFLPnUmAsN4UJLVPAzI4zspqfM1NyQHAIToUInZTZMrfmWV/7/FdTz9
         zPzw==
X-Gm-Message-State: AOAM530VC4kIOGDh4L4DQ9ujYaIG+NY7K87zOdZOvAWV3ftUmK/STHAZ
        04DasJOmOjy1vxEoPO5Hfb53Rg==
X-Google-Smtp-Source: ABdhPJwAi4sXCxn4b1gEkyDCnbA9nQFAQCJhRdmvlBsdMzYZrTzT1FL5quT1Kgb5UMe2aahzbCj2Ww==
X-Received: by 2002:a17:90a:5c83:: with SMTP id r3mr1767359pji.112.1602055613222;
        Wed, 07 Oct 2020 00:26:53 -0700 (PDT)
Received: from centos78 (60-248-88-209.HINET-IP.hinet.net. [60.248.88.209])
        by smtp.gmail.com with ESMTPSA id s11sm1844594pgm.36.2020.10.07.00.26.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Oct 2020 00:26:52 -0700 (PDT)
Message-ID: <7dc957d8e16d04cb9605bef10e474acc52235190.camel@areca.com.tw>
Subject: [PATCH v3 1/2] scsi: arcmsr: Use upper_32_bits() instead of
 dma_addr_hi32()
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Wed, 07 Oct 2020 15:26:52 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ching Huang <ching2048@areca.com.tw>

Use upper_32_bits() instead of dma_addr_hi32().

Signed-off-by: ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index d13d672..55d85c9 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -653,9 +653,9 @@ static void arcmsr_hbaF_assign_regAddr(struct AdapterControlBlock *acb)
 		3) >> 2) << 2;
 	pmuF = acb->pmuF;
 	/* host buffer low address, bit0:1 all buffer active */
-	writel((uint32_t)(host_buffer_dma | 1), &pmuF->inbound_msgaddr0);
+	writel(lower_32_bits(host_buffer_dma | 1), &pmuF->inbound_msgaddr0);
 	/* host buffer high address */
-	writel(dma_addr_hi32(host_buffer_dma), &pmuF->inbound_msgaddr1);
+	writel(upper_32_bits(host_buffer_dma), &pmuF->inbound_msgaddr1);
 	/* set host buffer physical address */
 	writel(ARCMSR_HBFMU_DOORBELL_SYNC1, &pmuF->iobound_doorbell);
 }
@@ -4057,11 +4057,8 @@ static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)
 		writel(cdb_phyaddr, &reg->msgcode_rwbuffer[2]);
 		writel(cdb_phyaddr_hi32, &reg->msgcode_rwbuffer[3]);
 		writel(acb->ccbsize, &reg->msgcode_rwbuffer[4]);
-		dma_coherent_handle = acb->dma_coherent_handle2;
-		cdb_phyaddr = (uint32_t)(dma_coherent_handle & 0xffffffff);
-		cdb_phyaddr_hi32 = (uint32_t)((dma_coherent_handle >> 16) >> 16);
-		writel(cdb_phyaddr, &reg->msgcode_rwbuffer[5]);
-		writel(cdb_phyaddr_hi32, &reg->msgcode_rwbuffer[6]);
+		writel(lower_32_bits(acb->dma_coherent_handle2), &reg->msgcode_rwbuffer[5]);
+		writel(upper_32_bits(acb->dma_coherent_handle2), &reg->msgcode_rwbuffer[6]);
 		writel(acb->ioqueue_size, &reg->msgcode_rwbuffer[7]);
 		writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, &reg->inbound_msgaddr0);
 		acb->out_doorbell ^= ARCMSR_HBEMU_DRV2IOP_MESSAGE_CMD_DONE;
@@ -4081,11 +4078,8 @@ static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)
 		acb->msgcode_rwbuffer[2] = cdb_phyaddr;
 		acb->msgcode_rwbuffer[3] = cdb_phyaddr_hi32;
 		acb->msgcode_rwbuffer[4] = acb->ccbsize;
-		dma_coherent_handle = acb->dma_coherent_handle2;
-		cdb_phyaddr = (uint32_t)dma_coherent_handle;
-		cdb_phyaddr_hi32 = dma_addr_hi32(dma_coherent_handle);
-		acb->msgcode_rwbuffer[5] = cdb_phyaddr;
-		acb->msgcode_rwbuffer[6] = cdb_phyaddr_hi32;
+		acb->msgcode_rwbuffer[5] = lower_32_bits(acb->dma_coherent_handle2);
+		acb->msgcode_rwbuffer[6] = upper_32_bits(acb->dma_coherent_handle2);
 		acb->msgcode_rwbuffer[7] = acb->completeQ_size;
 		writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, &reg->inbound_msgaddr0);
 		acb->out_doorbell ^= ARCMSR_HBEMU_DRV2IOP_MESSAGE_CMD_DONE;

