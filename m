Return-Path: <SRS0=dbdl=37=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9E5FC352A3
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Feb 2020 10:18:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CBEB20842
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Feb 2020 10:18:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="BwMvL4o+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbgBKKSn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Feb 2020 05:18:43 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44859 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727937AbgBKKSn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Feb 2020 05:18:43 -0500
Received: by mail-wr1-f68.google.com with SMTP id m16so11510206wrx.11
        for <linux-scsi@vger.kernel.org>; Tue, 11 Feb 2020 02:18:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ceTzC1RintI5CmICMnDnTZeomZMfOO9jOu2pkhPb5OE=;
        b=BwMvL4o+XPnPue+PkE2busjItqqz0ghQyKNbHyKO3B/DD1qxvR0ad/RfMm1ByLDYd5
         WkYtquDItXXkopnuDrJT6szO1s2Uvc8zjFd3i+YSy3+cXV2Sf36kT/77f6ERy0hIhql5
         gusYdHkMoH9tflocGo0fXW4/5ONbbBnOukv6g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ceTzC1RintI5CmICMnDnTZeomZMfOO9jOu2pkhPb5OE=;
        b=oSEyKbV6E0j5zJEFflkIyJUjImhA8ss2bvva3fh6atlRbADMaK60mHsAdEEd0ttVgI
         oPDK3rYxI7Dek7pRP+Q5W59RtKWwlwUbkPbyajgPuhAjM+SpELQs5HOaKLGNfWBoZfvd
         U3PkKJqDTR3Hy7fDl/W581+vtfPY2y/WPxvOH3gxW9Q9+9M2/SJSBP+FL3Fx67Us0pXp
         G5IVyWPCtrLqLFdB9pj036/kxllcqvnOrPXh8RKs7Um8KKXZ+/XiGeaaIyQ6we1pqH01
         omsGr3R8ZtTDRn2VsKg5U70PwwR4m2jge1wH7qT02EViV7UG3xgK6nREVdPEsNZ2htz3
         WAag==
X-Gm-Message-State: APjAAAVLchnrTtisY5yZJ6FGLmTJrBE9Xd04Z1v3c/eu7MLiKf3E/kxJ
        sfYLsk97k7IQpmwgsudzLWCfYJdA2xdcr51PN9Rsit0Dn7v7+Xa2VSc+QGpqYPTtpvm3x4J6ect
        7fGGJpNGfOrXXvINWBD9gbHZmD0kDxYVOKslJEq+3VkD0j6KSkRkHLldIthR1jE9Z624ysM9nvI
        qt2y5mgAQ+gALnvkKxPPKRopw=
X-Google-Smtp-Source: APXvYqy75Q3gh4z7RRW08BNYoBI0GND07VTYfauoBPL8wR2P8X0eQo4fv4bQDTw8sFHgD0Eu5AVJ0g==
X-Received: by 2002:a5d:4d04:: with SMTP id z4mr8457165wrt.157.1581416320523;
        Tue, 11 Feb 2020 02:18:40 -0800 (PST)
Received: from dhcp-10-123-20-55.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id f65sm3058895wmf.29.2020.02.11.02.18.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Feb 2020 02:18:39 -0800 (PST)
From:   suganath-prabu.subramani@broadcom.com
To:     linux-scsi@vger.kernel.org
Cc:     sreekanth.reddy@broadcom.com, kashyap.desai@broadcom.com,
        sathya.prakash@broadcom.com, martin.petersen@oracle.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 2/5] mpt3sas: Rename function name is_MSB_are_same
Date:   Tue, 11 Feb 2020 05:18:10 -0500
Message-Id: <1581416293-41610-3-git-send-email-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1581416293-41610-1-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1581416293-41610-1-git-send-email-suganath-prabu.subramani@broadcom.com>
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
index 18c5045..4718b86 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4922,7 +4922,7 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 }
 
 /**
- * is_MSB_are_same - checks whether all reply queues in a set are
+ * mpt3sas_check_same_4gb_region - checks whether all reply queues in a set are
  *	having same upper 32bits in their base memory address.
  * @reply_pool_start_address: Base address of a reply queue set
  * @pool_sz: Size of single Reply Descriptor Post Queues pool size
@@ -4932,7 +4932,7 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
  */
 
 static int
-is_MSB_are_same(long reply_pool_start_address, u32 pool_sz)
+mpt3sas_check_same_4gb_region(long reply_pool_start_address, u32 pool_sz)
 {
 	long reply_pool_end_address;
 
@@ -5384,7 +5384,7 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
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

