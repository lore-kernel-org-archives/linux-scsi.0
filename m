Return-Path: <SRS0=9vL1=57=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD191C2BB55
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 13:25:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89B7820575
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 13:25:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="LR5wpxHd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2636090AbgDONZu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Apr 2020 09:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2636099AbgDONZq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Apr 2020 09:25:46 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD10C061A0C
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2020 06:25:46 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id np9so6760306pjb.4
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2020 06:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=a/CWPPj4MI+kHBELayo3V/QyFpobDIWGzFV3aDT8VfQ=;
        b=LR5wpxHd4G+gJRYQqdT7vdsj9OnFWFuWGeP0yn3SWC3kjRp/M8rAJ9hW+AhilIjIyz
         c2LxL2OfD367P8AzaeIifCZeK0JMnEoeoQPNCTsSc+7iAUMf7QCfm6aLDsYHEjtRTUcQ
         XTGESrXyizhk1V+h2hOue0dUtQiE3+cEJgu+Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=a/CWPPj4MI+kHBELayo3V/QyFpobDIWGzFV3aDT8VfQ=;
        b=SEhPAACSrxTyq5VqffANKHfBKM221kubEztb7oetjcA5KT/ILBx/8Ph9bbu/gx27OB
         iW1p/S6k2r4zNiQA7jbxXGNV9fagrU0tty4C7ajjwdlk/1HNWUflI7awj1f4+2HpzJvv
         Pr0CgGvYIRRC5FtBXun2eMzHj+Uy6vs+qzzRmdfZQtIZX2of3juB00PhSJeZlWuVRNrN
         /MJigLQxYEF2fkCdH//PoFlRG2QALV9GvY/MV+TgHmwXIOcIYlLZE/dYsRwMfh2C64XE
         DbfikCzRdt5q8xgJjN70wo+GeIAkbc03gK/kilGVHPEJnNfeEXsra/C+dDVaO3m5KbjM
         +VBA==
X-Gm-Message-State: AGi0PuZ40XklQ0uZylntIh15o+xgvlNSD45K6bcWZkGwMauJ4PJVGwQ1
        0TFe6O95o6t1FySdQ+xi1AwR0fbcCQm0MrbbgnqYMGmppa5CayVKA0AeryGJz2krISaCS/ANgSQ
        Q+njqD349B42BPXJ3qa6sSxPzdZDXBUKf79WoUncm429pREy4foXVc/q785asLykVltOlCYiNoT
        VEeFWQnzyB0+jW9A9Rbzg8
X-Google-Smtp-Source: APiQypImjpCEa/WtMJCTEuYWeSZtYTLaGZAKfBCUyKfB+moMxmjH4f5zSReDX7r6IOFhvibgnXjDng==
X-Received: by 2002:a17:902:ba89:: with SMTP id k9mr4846263pls.199.1586957145727;
        Wed, 15 Apr 2020 06:25:45 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id x186sm13715556pfb.151.2020.04.15.06.25.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Apr 2020 06:25:45 -0700 (PDT)
From:   Suganath Prabu <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     hch@infradead.org, Sathya.Prakash@broadcom.com,
        sreekanth.reddy@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [v1 2/5] mpt3sas: Rename function name is_MSB_are_same
Date:   Wed, 15 Apr 2020 09:25:22 -0400
Message-Id: <1586957125-19460-3-git-send-email-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1586957125-19460-1-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1586957125-19460-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>

Renamed is_MSB_are_same() to mpt3sas_check_same_4gb_region()
for better readability.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 8e937c8..7f7b5af 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4920,7 +4920,7 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 }
 
 /**
- * is_MSB_are_same - checks whether all reply queues in a set are
+ * mpt3sas_check_same_4gb_region - checks whether all reply queues in a set are
  *	having same upper 32bits in their base memory address.
  * @reply_pool_start_address: Base address of a reply queue set
  * @pool_sz: Size of single Reply Descriptor Post Queues pool size
@@ -4930,7 +4930,7 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
  */
 
 static int
-is_MSB_are_same(long reply_pool_start_address, u32 pool_sz)
+mpt3sas_check_same_4gb_region(long reply_pool_start_address, u32 pool_sz)
 {
 	long reply_pool_end_address;
 
@@ -5382,7 +5382,7 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	 * Actual requirement is not alignment, but we need start and end of
 	 * DMA address must have same upper 32 bit address.
 	 */
-	if (!is_MSB_are_same((long)ioc->sense, sz)) {
+	if (!mpt3sas_check_same_4gb_region((long)ioc->sense, sz)) {
 		//Release Sense pool & Reallocate
 		dma_pool_free(ioc->sense_dma_pool, ioc->sense, ioc->sense_dma);
 		dma_pool_destroy(ioc->sense_dma_pool);
-- 
1.8.3.1

