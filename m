Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C89F4C2BA19
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 07:23:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A71F021569
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 07:23:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="R9jsRlRy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgDWHXv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Apr 2020 03:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbgDWHXv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2020 03:23:51 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54C8C03C1AB
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2020 00:23:50 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id t63so5233194wmt.3
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2020 00:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=np3nzB74b6mNE2OsMR/DOSPMVbD8D/J0W6kdkLETr38=;
        b=R9jsRlRy7xiNEIispPtUzwY7RFwnG+Df5wAFe9GiEMgQREE7sYWCIBo74osYJLhkpu
         r21sx7JqeSFWZ2bKSOBJw3tQ0+SCKo+i+FINDG4wuLzb3HNgrEeN7jSG2O1wnWwLEpdL
         kxdB/LXUzP1Ry5OGJKc6Qv/1wWHA9Z9Q6Lr1k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=np3nzB74b6mNE2OsMR/DOSPMVbD8D/J0W6kdkLETr38=;
        b=MCh+nrlvwtFOW/BoYy88VBoisBIi9RZQo7U4drG3cKE2hS9xz2dwVwRrRs2cDMsNK6
         iETJ1LQevAFbiiOYEr/yiQ/OHzHm8dNizQN9wO7INlvP/crtNWCZw6KutD/kDzQuY1Mm
         gsMPSMR1NYDuISueIW+sS/jKHnVvoPOwoC2GuPt/mc9aY9KsN0BO/YO7aNmwML+71akC
         FN9tHsgn/eUK0VSDlhCWuTlEN+UspA/FnACPb6IwgOKYDO5TMvcfO/O+bAgFioazZmSk
         K2vagBnBxXbAKCiCM68nNBSlmhPoayvEGILBs99DZYOe+mTFgftMfaNJwcV0+/nRAGNW
         7mxw==
X-Gm-Message-State: AGi0Puaj1QKsEwu/dKzD5hCJjjVIjdrlHex9iWF36GJjHLEga8LlCGg4
        P7DVEp4+OHawkWFdxSemR7j5SUC8zclVf13G5wbRYQ2GWZt5adwWwf22C5pNFQWrHpDB1b4Oj9g
        iLa4idQoZwkrXv3SJRskqr/v/cgp0XKUjTQecp7r1SQhOsfAxW4aSAL5wWjx4jT3SOGr0rAgxN6
        /SsoT/KANiecLiiP+SZtxB
X-Google-Smtp-Source: APiQypIuIKLxGI5PjHwslKQbGnoQLKe3Nu5WnPLYnJwfjhBdyXno9tHrSzB9yQshVzly8OyOsGtsRA==
X-Received: by 2002:a1c:7d04:: with SMTP id y4mr2556228wmc.10.1587626629119;
        Thu, 23 Apr 2020 00:23:49 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id l4sm2336130wrw.25.2020.04.23.00.23.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Apr 2020 00:23:48 -0700 (PDT)
From:   Suganath Prabu <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     hch@infradead.org, Sathya.Prakash@broadcom.com,
        sreekanth.reddy@broadcom.com,
        Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Subject: [v2 2/5] mpt3sas: Rename function name is_MSB_are_same
Date:   Thu, 23 Apr 2020 03:23:13 -0400
Message-Id: <1587626596-1044-3-git-send-email-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587626596-1044-1-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1587626596-1044-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rename is_MSB_are_same() to mpt3sas_check_same_4gb_region()
for better readability.

Signed-off-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index b8679c2..f98c7f6 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4915,7 +4915,7 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 }
 
 /**
- * is_MSB_are_same - checks whether all reply queues in a set are
+ * mpt3sas_check_same_4gb_region - checks whether all reply queues in a set are
  *	having same upper 32bits in their base memory address.
  * @reply_pool_start_address: Base address of a reply queue set
  * @pool_sz: Size of single Reply Descriptor Post Queues pool size
@@ -4925,7 +4925,7 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
  */
 
 static int
-is_MSB_are_same(long reply_pool_start_address, u32 pool_sz)
+mpt3sas_check_same_4gb_region(long reply_pool_start_address, u32 pool_sz)
 {
 	long reply_pool_end_address;
 
@@ -5377,7 +5377,7 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
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

