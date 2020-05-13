Return-Path: <SRS0=+pcl=63=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3E50C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 13 May 2020 21:36:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D03282054F
	for <linux-scsi@archiver.kernel.org>; Wed, 13 May 2020 21:36:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HcixQ6k9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbgEMVgb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 May 2020 17:36:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57951 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728881AbgEMVg3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 May 2020 17:36:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589405789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UwIpCXRimK6nkSbPjNNgCftnS+rK1CtylodRWRJy1j4=;
        b=HcixQ6k9u2rnk8O2cYflMRNbMPjhQuz07hTWU7pis7d5kax7mbLVHr7SHe4Q4dGWumP7oO
        +z0VU7oORWG/argiWffOiijRPkBl+6PYJBqZK8lQpTa/0g+QurUu9fYsfLvcPLNAKp1R9c
        dmVyDW6m4qy5vKPCfgP58z/roqfuM4o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-aEQS2vveONa43IB6vSQRzw-1; Wed, 13 May 2020 17:36:27 -0400
X-MC-Unique: aEQS2vveONa43IB6vSQRzw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C9BC108BD0B;
        Wed, 13 May 2020 21:36:26 +0000 (UTC)
Received: from sulaco.redhat.com (unknown [10.3.128.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E358A5D9E5;
        Wed, 13 May 2020 21:36:25 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: [RFC PATCH v2 3/7] print_req_error: Use dev_printk
Date:   Wed, 13 May 2020 16:36:17 -0500
Message-Id: <20200513213621.470411-4-tasleson@redhat.com>
In-Reply-To: <20200513213621.470411-1-tasleson@redhat.com>
References: <20200513213621.470411-1-tasleson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Tony Asleson <tasleson@redhat.com>
---
 block/blk-core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 60dc9552ef8d..44bf92047031 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -213,12 +213,15 @@ EXPORT_SYMBOL_GPL(blk_status_to_errno);
 static void print_req_error(struct request *req, blk_status_t status,
 		const char *caller)
 {
+	struct device *dev;
 	int idx = (__force int)status;
 
 	if (WARN_ON_ONCE(idx >= ARRAY_SIZE(blk_errors)))
 		return;
 
-	printk_ratelimited(KERN_ERR
+	dev = (req->rq_disk) ? disk_to_dev(req->rq_disk) : NULL;
+
+	dev_err_ratelimited(dev,
 		"%s: %s error, dev %s, sector %llu op 0x%x:(%s) flags 0x%x "
 		"phys_seg %u prio class %u\n",
 		caller, blk_errors[idx].name,
-- 
2.25.4

