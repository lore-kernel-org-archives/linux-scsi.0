Return-Path: <SRS0=RSbu=B6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30B0FC433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Aug 2020 18:14:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAEDD208C7
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Aug 2020 18:14:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qd5r04De"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgHTSOT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Aug 2020 14:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbgHTSOR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2020 14:14:17 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9FDDC061385;
        Thu, 20 Aug 2020 11:14:17 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id p14so2551217wmg.1;
        Thu, 20 Aug 2020 11:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hq9NJIrIHetIv+8ZmpoQGrS4jg1QkLt04qsY0F4sVgU=;
        b=Qd5r04DeY7+xT7tiXOhB1GIYKnSQf/0M1zwfsOJcbcUOxwu+/TLg6DVeGpr10KJdjq
         JgWR8jmmoTmnkEwfgS3DV/HJqQi4/bPVG1luMnos4gRDkLmeAwoyQsJ4lk9ftRXbmBaX
         QLCyjjtEGpVRfH0BWHxdt+BGmwkZHvvFaEoqeDu80vevOZSCxl+AkWMvjvKSvE5F++dv
         FugyjLXidUlLVL4KpDTAxJFDx2uMYMBCfYbAtUopsNb0310DLKYu56CO5JwEMLN5FnSO
         OsUorCqzsSlIFn7BnKgCIGA4sz65uenJT8jD3eYf30sWORxZEouANJhaU4eMRVkwNs1q
         uFHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hq9NJIrIHetIv+8ZmpoQGrS4jg1QkLt04qsY0F4sVgU=;
        b=sRA2G+yBehlNwAzPB6FQVrYYeVcPME/4sc79Ejt87Bj2aJX9AYN9qla7H2ipexSOL4
         rQI8551R/TLRDACW8yadw5LA0iwWu3oVoyuEe2qVOSjAZkCB/pI6wySenOv5LMijyv2c
         utCGKAcWTchL9crbXK9B4qX4G0tnNRC1opI9DGthctBVxTf3B70YngrdrD58Hs40eGa2
         l9HfunvjdxqnucjJlniubQ7t8XUWk1bKUuKvvZ4erJ2ADq3E6NgyBiOCvAQ3+Mh+Ai1U
         qEwPh5fQXhMWMwTeCqIQObAwKtTsYoneypiq6MXFr9bt4xjMsdH3CYEufI4ARfj8LyYQ
         r3IQ==
X-Gm-Message-State: AOAM532WX97UZfIt/0XLkO8TcrCAgPtYjOXksFZ6nMnyT+LLmR9r8+X1
        1GS7oXX53Q6GOi634OKzASE=
X-Google-Smtp-Source: ABdhPJwsj2mTHtO2vkobg4pVo9KBxN7sxwBHx9GxCi2/tYI7dIwaKFah6UY49305CyAZK3rA7aSnXg==
X-Received: by 2002:a1c:7f17:: with SMTP id a23mr82793wmd.28.1597947256403;
        Thu, 20 Aug 2020 11:14:16 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id p22sm5347045wmc.38.2020.08.20.11.14.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 11:14:15 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
To:     Bradley Grove <linuxdrivers@attotech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Alex Dewar <alex.dewar90@gmail.com>
Subject: [PATCH] scsi: esas2r: Remove unnecessary casts
Date:   Thu, 20 Aug 2020 19:14:11 +0100
Message-Id: <20200820181411.866057-1-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In a number of places in esas2r_ioctl.c, the void* returned from
pci_alloc_consistent() is cast unnecessarily. Remove casts.

Issue identified with Coccinelle.

Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
 drivers/scsi/esas2r/esas2r_ioctl.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r/esas2r_ioctl.c
index cc620f10eabc..08f4e43c7d9e 100644
--- a/drivers/scsi/esas2r/esas2r_ioctl.c
+++ b/drivers/scsi/esas2r/esas2r_ioctl.c
@@ -1548,11 +1548,10 @@ static int allocate_fw_buffers(struct esas2r_adapter *a, u32 length)
 
 	a->firmware.orig_len = length;
 
-	a->firmware.data = (u8 *)dma_alloc_coherent(&a->pcid->dev,
-						    (size_t)length,
-						    (dma_addr_t *)&a->firmware.
-						    phys,
-						    GFP_KERNEL);
+	a->firmware.data = dma_alloc_coherent(&a->pcid->dev,
+					      (size_t)length,
+					      (dma_addr_t *)&a->firmware.phys,
+					      GFP_KERNEL);
 
 	if (!a->firmware.data) {
 		esas2r_debug("buffer alloc failed!");
@@ -1895,11 +1894,11 @@ int esas2r_write_vda(struct esas2r_adapter *a, const char *buf, long off,
 
 	if (!a->vda_buffer) {
 		dma_addr_t dma_addr;
-		a->vda_buffer = (u8 *)dma_alloc_coherent(&a->pcid->dev,
-							 (size_t)
-							 VDA_MAX_BUFFER_SIZE,
-							 &dma_addr,
-							 GFP_KERNEL);
+		a->vda_buffer = dma_alloc_coherent(&a->pcid->dev,
+						   (size_t)
+						   VDA_MAX_BUFFER_SIZE,
+						   &dma_addr,
+						   GFP_KERNEL);
 
 		a->ppvda_buffer = dma_addr;
 	}
@@ -2064,11 +2063,10 @@ int esas2r_write_fs(struct esas2r_adapter *a, const char *buf, long off,
 re_allocate_buffer:
 			a->fs_api_buffer_size = length;
 
-			a->fs_api_buffer = (u8 *)dma_alloc_coherent(
-				&a->pcid->dev,
-				(size_t)a->fs_api_buffer_size,
-				(dma_addr_t *)&a->ppfs_api_buffer,
-				GFP_KERNEL);
+			a->fs_api_buffer = dma_alloc_coherent(&a->pcid->dev,
+							      (size_t)a->fs_api_buffer_size,
+							      (dma_addr_t *)&a->ppfs_api_buffer,
+							      GFP_KERNEL);
 		}
 	}
 
-- 
2.28.0

