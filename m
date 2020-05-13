Return-Path: <SRS0=+pcl=63=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D02FEC433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 13 May 2020 21:36:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2D3F2054F
	for <linux-scsi@archiver.kernel.org>; Wed, 13 May 2020 21:36:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OpynUdj/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729410AbgEMVgb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 May 2020 17:36:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44053 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729392AbgEMVga (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 May 2020 17:36:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589405789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ByWLLIXWrua1rpkn2+ZI8vQo5UqpQKFPic9yOTP0TPg=;
        b=OpynUdj/Ra1f96HZ6//h+ZRrt3rXpr0faiJUfIyCWnq5801JRVpWdVJ3UKsBs6ozMVPWAQ
        CvN/HBOj8QfeVnuwRWcCQJYCA/QmNH5DCMETOxsx8Vs0Zyob/GlkM2GeZL5NKvg98XUGWM
        b0/HpTCPs2rUpqSHyxYQokwdJZP4Ng0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-cmAgnwGmMLCKn-2sKAAKaQ-1; Wed, 13 May 2020 17:36:28 -0400
X-MC-Unique: cmAgnwGmMLCKn-2sKAAKaQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83A6A1B18BC3;
        Wed, 13 May 2020 21:36:27 +0000 (UTC)
Received: from sulaco.redhat.com (unknown [10.3.128.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF3785D9E5;
        Wed, 13 May 2020 21:36:26 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: [RFC PATCH v2 4/7] buffer_io_error: Use dev_printk
Date:   Wed, 13 May 2020 16:36:18 -0500
Message-Id: <20200513213621.470411-5-tasleson@redhat.com>
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
 fs/buffer.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index b8d28370cfd7..e144f5bccd2f 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -133,10 +133,16 @@ __clear_page_buffers(struct page *page)
 
 static void buffer_io_error(struct buffer_head *bh, char *msg)
 {
-	if (!test_bit(BH_Quiet, &bh->b_state))
-		printk_ratelimited(KERN_ERR
+	if (!test_bit(BH_Quiet, &bh->b_state)) {
+		struct device *gendev;
+
+		gendev = (bh->b_bdev->bd_disk) ?
+			disk_to_dev(bh->b_bdev->bd_disk) : NULL;
+
+		dev_err_ratelimited(gendev,
 			"Buffer I/O error on dev %pg, logical block %llu%s\n",
 			bh->b_bdev, (unsigned long long)bh->b_blocknr, msg);
+	}
 }
 
 /*
-- 
2.25.4

