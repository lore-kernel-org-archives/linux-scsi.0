Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB3F0C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 03:55:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388878AbiEFD7e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 May 2022 23:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388851AbiEFD7W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 May 2022 23:59:22 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69CED12AB1
        for <linux-scsi@vger.kernel.org>; Thu,  5 May 2022 20:55:37 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id j6so5248581pfe.13
        for <linux-scsi@vger.kernel.org>; Thu, 05 May 2022 20:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XO6QjupNFyPtXmjpMd71skiI90TCPe3nMuV/Fs5xeAI=;
        b=oqLSN7WLP9y0sIRa16KN+U56MscCngbYR+cbMo0is5leosxvHCC1oXIZGRB/K/hEfF
         tHrbgbxIW1HZki8PjGucO6bUTQu2zee1b8n9tcEHkCOFEIFhjcU6nwDciPvhgefqZYxp
         rad9NQudb1w2U4ndVGG30Hpv7ANCenE2UtJPKXAdRIoZAd86ST4+Cp5A/qnr1NYAOBak
         xsaS+DMwEDF5Z1nKmRpbOR2OD4uxYKNIS7IRnxV4ggHo6mriGwQ4Ewoyd8sL1M1vAry0
         WBJjtPZ9kZeuQhsTFqzfxP2dwO607NxTnMKF7xLl49HudhXvC1xdbYNtUB9n5X8Txl91
         tpBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XO6QjupNFyPtXmjpMd71skiI90TCPe3nMuV/Fs5xeAI=;
        b=7+mEbg1B4XPFlPgftgk9iJHEEFSCUtt7la59hzho71djVgokx9f4JNk7IJATq1wtWD
         pQWXIWW2rWzLhVeWKwPIlBc6E4QUnVDTAwDv885FneIZPuR7ruwp8thbF4PP8NuJyDOU
         /ur7KTaFtVmfMSMh9VLb2UlBtVgK8U2hlmj6xsvgqhIg1X8j20K7VoXqzx3rBZynWR22
         LB2xzNT0tutRYLul4aCuvX9hxfQzBekcoRzphu1RdbHcNa5Jkcqf1zR5zcUagex5YHY3
         Q3bzV628QEaQi2GLUvKH1Gsfk7tHaymPPFk/Atwhb1dTisETGxqYZDYSfSoc0o1tQDEm
         Dbcg==
X-Gm-Message-State: AOAM532yk5UK1uga6YPlf5m5QdtymUxf/gGiO99OzPK9F5e/oYFtCbJi
        7QBMTnPqT8ypBw9fnlLaHpy2Q1Zc240=
X-Google-Smtp-Source: ABdhPJzU9OYmvzxJWlhDvOj3w4jBlBCCIwXaWnGKt1RRi8JNR024fvvH/4kK+LSAk5VmPYYMNGi7pw==
X-Received: by 2002:a63:8b49:0:b0:3c6:1ec9:a018 with SMTP id j70-20020a638b49000000b003c61ec9a018mr1176854pge.451.1651809336808;
        Thu, 05 May 2022 20:55:36 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id ck3-20020a17090afe0300b001cd4989feebsm6065187pjb.55.2022.05.05.20.55.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 20:55:36 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Nigel Kirkland <nkirkland2304@gmail.com>
Subject: [PATCH 11/12] lpfc: Use sg_dma_address and sg_dma_len macros for NVMe I/O
Date:   Thu,  5 May 2022 20:55:18 -0700
Message-Id: <20220506035519.50908-12-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220506035519.50908-1-jsmart2021@gmail.com>
References: <20220506035519.50908-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

NVME I/O problems may be seen on IOMMU enabled platforms. Adapter I/O's
failing with transfer length mismatches.

The sg list processing routine for nvme I/O is accessing the sg entry
directly for the length and address fields. On some iommu platforms,
contigous mappings are compressed to the first sg entry with the sum
of the lengths set to the sg entry dma_length field. The length fields
are left for later use by the unmap call. As such, the driver didn't see
the actual dma_length value, just the first entries length value.
Drivers are to use the sg_dma_length and sg_dma_address macros to
reference the sg entry. The macros select the proper length field
(dma_length or length) to reference.

Fix the offending code to use the sg_dma_xxx macros.

Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 3aebd01e07fd..5385f4de5523 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1401,8 +1401,8 @@ lpfc_nvme_prep_io_dma(struct lpfc_vport *vport,
 				if ((nseg - 1) == i)
 					bf_set(lpfc_sli4_sge_last, sgl, 1);
 
-				physaddr = data_sg->dma_address;
-				dma_len = data_sg->length;
+				physaddr = sg_dma_address(data_sg);
+				dma_len = sg_dma_len(data_sg);
 				sgl->addr_lo = cpu_to_le32(
 							 putPaddrLow(physaddr));
 				sgl->addr_hi = cpu_to_le32(
-- 
2.26.2

