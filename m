Return-Path: <SRS0=8X05=DC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7806FC4363D
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 16:19:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CC352311D
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 16:19:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WfS2ojw6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729538AbgIYQTt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Sep 2020 12:19:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51174 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729534AbgIYQTs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Sep 2020 12:19:48 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601050787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=josTUHWqNyzesA2exKGBBZWjajhUHsqLRfrpS+k19OQ=;
        b=WfS2ojw6JESgTsa2y87aPwxj0OJJiSxQlMqu0u9/4JQDIzTj54E1h4R7Co4n5c9xcY8rT8
        1kqZE04HJUyWDI84uzpDQoKJBgei3GGjw/3skwKF9q3yB4tYFvn8buyVhElOQ+1WNHt8KW
        iiKkJSr/F9QBHsQLbSFAWjzHfyZ661E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-IyxQ6YfPNM-NvfhphXgtww-1; Fri, 25 Sep 2020 12:19:45 -0400
X-MC-Unique: IyxQ6YfPNM-NvfhphXgtww-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 723AB8712FD;
        Fri, 25 Sep 2020 16:19:44 +0000 (UTC)
Received: from sulaco.redhat.com (unknown [10.10.110.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A3D385D9DC;
        Fri, 25 Sep 2020 16:19:43 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: [v5 12/12] buffer_io_error: Use durable_name_printk_ratelimited
Date:   Fri, 25 Sep 2020 11:19:29 -0500
Message-Id: <20200925161929.1136806-13-tasleson@redhat.com>
In-Reply-To: <20200925161929.1136806-1-tasleson@redhat.com>
References: <20200925161929.1136806-1-tasleson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace printk_ratelimited with one that adds the key/value
durable name to log entry.

Signed-off-by: Tony Asleson <tasleson@redhat.com>
---
 fs/buffer.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 64fe82ec65ff..5c4e5b4c82dd 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -125,10 +125,17 @@ EXPORT_SYMBOL(__wait_on_buffer);
 
 static void buffer_io_error(struct buffer_head *bh, char *msg)
 {
-	if (!test_bit(BH_Quiet, &bh->b_state))
-		printk_ratelimited(KERN_ERR
-			"Buffer I/O error on dev %pg, logical block %llu%s\n",
-			bh->b_bdev, (unsigned long long)bh->b_blocknr, msg);
+	struct device *gendev;
+
+	if (test_bit(BH_Quiet, &bh->b_state))
+		return;
+
+	gendev = bh->b_bdev->bd_disk ?
+		disk_to_dev(bh->b_bdev->bd_disk) : NULL;
+
+	durable_name_printk_ratelimited(KERN_ERR, gendev,
+		"Buffer I/O error on dev %pg, logical block %llu%s\n",
+		bh->b_bdev, (unsigned long long)bh->b_blocknr, msg);
 }
 
 /*
-- 
2.26.2

