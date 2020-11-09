Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62BB3C388F7
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 16:59:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0B8D21D46
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 16:59:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="NOlERqMf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730704AbgKIQ67 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Nov 2020 11:58:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:57894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729776AbgKIQ67 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 9 Nov 2020 11:58:59 -0500
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E18720789;
        Mon,  9 Nov 2020 16:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604941139;
        bh=WGEcmPXvVRi61x7imWKMEdS2fqmM9HkxAxRybtdcPMQ=;
        h=From:To:Cc:Subject:Date:From;
        b=NOlERqMfSxbiWBVfsUqkHzGXJN7umYN+eZXwHi0RAx2g40ylf9gwggxhjCN2BJJ8R
         dYm2OYWPq82xFgNSTabN+Ldbj0mduIMM/kAcEBYWkhNBqPIUm1uP/nNtrSz7i9MYmt
         NO4x8wKOc65ZWBvIQYNNyi+xL1nwvrvpOpbM4dA4=
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH] f2fs: avoid unneeded data copy in f2fs_ioc_move_range()
Date:   Mon,  9 Nov 2020 08:58:57 -0800
Message-Id: <20201109165857.2115554-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.29.2.222.g5d2a92d10f8-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

Fields in struct f2fs_move_range won't change in f2fs_ioc_move_range(),
let's avoid copying this structure's data to userspace.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/file.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 52417a2e3f4f..22ae8ae0072f 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2898,12 +2898,6 @@ static int f2fs_ioc_move_range(struct file *filp, unsigned long arg)
 					range.pos_out, range.len);
 
 	mnt_drop_write_file(filp);
-	if (err)
-		goto err_out;
-
-	if (copy_to_user((struct f2fs_move_range __user *)arg,
-						&range, sizeof(range)))
-		err = -EFAULT;
 err_out:
 	fdput(dst);
 	return err;
-- 
2.29.2.222.g5d2a92d10f8-goog

