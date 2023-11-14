Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 374EFC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 21:41:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234072AbjKNVly (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Nov 2023 16:41:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbjKNVlv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Nov 2023 16:41:51 -0500
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCEAD2;
        Tue, 14 Nov 2023 13:41:48 -0800 (PST)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1cc3542e328so46247045ad.1;
        Tue, 14 Nov 2023 13:41:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699998108; x=1700602908;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/FFQa2e9BQic5MUNwTejV3XIteTNLmmrUor8s5RN+Kc=;
        b=PJ9A/xw9E84o2t+UDM/OB/dRbe0IM/G8S44VaAcVUlVXRsSI8TWA6vL8WLhRhQS6l5
         A1kkESu4F3DVmzQYk0zRGnW58wrs6j6ZRc6ZoyBe/M2sRfUAMmcqLv4cc5VOwRmAKbRW
         oUj4gZ0xNM3GXAjsGyEQq92Bd63MEvcixlKUKMPGmoi3sFsjVHWRLmM+TuM/0URQ+Lkx
         t/B3vJYev9dqv9SSSB0lNtW5j2Lsx66OIUDVfYTUYhjjUniYw7YRQjJnia2bZlEEUAYT
         CJlSHHEaXzFuPZyBAx8s2y/0fOQ7bXW1CnSJ2sL2svnWHQfYem3tVf2WxV4eLOmoEYeM
         4Lzw==
X-Gm-Message-State: AOJu0Yz4K8MZw66aKV/zc0CL9dDJ0wHVHoUpRQPuEHwEet1PvxZEKuxh
        yf+qOVKo1AzyVf7GplBN++w=
X-Google-Smtp-Source: AGHT+IER3ePTg/BeDrmersjmPt4kOAzVkMa6+a3RMV7Ao3IF71rzyhh2UkAIoi7BlrCvPobT9XK4pA==
X-Received: by 2002:a17:902:7241:b0:1cc:76c4:5144 with SMTP id c1-20020a170902724100b001cc76c45144mr3184479pll.12.1699998108060;
        Tue, 14 Nov 2023 13:41:48 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:2278:ad72:cefb:4d49])
        by smtp.gmail.com with ESMTPSA id o16-20020a170902d4d000b001c3267ae317sm6133926plg.165.2023.11.14.13.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 13:41:46 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
        Daejun Park <daejun7.park@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jan Kara <jack@suse.cz>,
        Christian Brauner <brauner@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v4 01/15] fs: Rename the kernel-internal data lifetime constants
Date:   Tue, 14 Nov 2023 13:40:56 -0800
Message-ID: <20231114214132.1486867-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231114214132.1486867-1-bvanassche@acm.org>
References: <20231114214132.1486867-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for supporting more data lifetimes by changing data lifetime
names into numeric constants.

Cc: Kanchan Joshi <joshi.k@samsung.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>
Suggested-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 fs/f2fs/segment.c  |  4 ++--
 fs/inode.c         |  2 +-
 include/linux/fs.h | 12 ++++++------
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 727d016318f9..098a574d8d84 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3281,9 +3281,9 @@ int f2fs_trim_fs(struct f2fs_sb_info *sbi, struct fstrim_range *range)
 int f2fs_rw_hint_to_seg_type(enum rw_hint hint)
 {
 	switch (hint) {
-	case WRITE_LIFE_SHORT:
+	case WRITE_LIFE_2:
 		return CURSEG_HOT_DATA;
-	case WRITE_LIFE_EXTREME:
+	case WRITE_LIFE_5:
 		return CURSEG_COLD_DATA;
 	default:
 		return CURSEG_WARM_DATA;
diff --git a/fs/inode.c b/fs/inode.c
index edcd8a61975f..7965d5e07012 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -175,7 +175,7 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	i_gid_write(inode, 0);
 	atomic_set(&inode->i_writecount, 0);
 	inode->i_size = 0;
-	inode->i_write_hint = WRITE_LIFE_NOT_SET;
+	inode->i_write_hint = WRITE_LIFE_0;
 	inode->i_blocks = 0;
 	inode->i_bytes = 0;
 	inode->i_generation = 0;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 98b7a7a8c42e..59f9de9df0fe 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -314,12 +314,12 @@ struct readahead_control;
  * Stored in struct inode as u8.
  */
 enum rw_hint {
-	WRITE_LIFE_NOT_SET	= 0,
-	WRITE_LIFE_NONE		= RWH_WRITE_LIFE_NONE,
-	WRITE_LIFE_SHORT	= RWH_WRITE_LIFE_SHORT,
-	WRITE_LIFE_MEDIUM	= RWH_WRITE_LIFE_MEDIUM,
-	WRITE_LIFE_LONG		= RWH_WRITE_LIFE_LONG,
-	WRITE_LIFE_EXTREME	= RWH_WRITE_LIFE_EXTREME,
+	WRITE_LIFE_0	= 0,
+	WRITE_LIFE_1	= RWH_WRITE_LIFE_NONE,
+	WRITE_LIFE_2	= RWH_WRITE_LIFE_SHORT,
+	WRITE_LIFE_3	= RWH_WRITE_LIFE_MEDIUM,
+	WRITE_LIFE_4	= RWH_WRITE_LIFE_LONG,
+	WRITE_LIFE_5	= RWH_WRITE_LIFE_EXTREME,
 };
 
 /* Match RWF_* bits to IOCB bits */
