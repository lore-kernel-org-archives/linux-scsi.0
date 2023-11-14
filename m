Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0421C4167B
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 21:42:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234094AbjKNVmO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Nov 2023 16:42:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234092AbjKNVmM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Nov 2023 16:42:12 -0500
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF49D5;
        Tue, 14 Nov 2023 13:42:05 -0800 (PST)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1cc3c51f830so47310305ad.1;
        Tue, 14 Nov 2023 13:42:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699998125; x=1700602925;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qNyo/5GtfbZEm3qkTN5J6CCReaJlJFArmEnNenmgc8I=;
        b=vLyI7K0qXkZLhsIxpJahj2pBWkIrMHKTNKA/bSZ5dhHX8TKXjtv52HPYqemWOAMOmk
         NjOCZJfnTH0KVgkCj4m4X1gIQIH2bQwtGDEajGuoTiztyKn111iCGD6Svp1JU8m1Fpyo
         59+XJjaLHFDZeDffJiZn3bwy3AdfYvMbVYBdNd4MSbru9HDSf6dgfKhroK4ubU/ecZGX
         rpkD6BmE11eR2uCw55OC19qxoHC51D1b8CAynRBbsSw2TleRY5IHmig52eyRW5uEQNwb
         Vn6/YS6reFGb0wIfPy0tv+ix8ZRTL8I149N0PF7Y5nT5ILso8PVc2+QkDLGwmZKVyx+X
         tgBQ==
X-Gm-Message-State: AOJu0YzECy6kIn7KS5hoC567bvoBvAZHQftAf1C5d4gP23Pr4cEpCGrl
        bcaN1dKYhdJJ9lHcQCcwxxJhEzgewuRzrA==
X-Google-Smtp-Source: AGHT+IFZMWVmvT1GgsNdUHNh34MuHVJFEJpVpgN7PNROe8hk5e76XAse98jqIWZBy28ErTQQ6ejmoA==
X-Received: by 2002:a17:902:ea10:b0:1cc:51ca:52e5 with SMTP id s16-20020a170902ea1000b001cc51ca52e5mr3882941plg.44.1699998124694;
        Tue, 14 Nov 2023 13:42:04 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:2278:ad72:cefb:4d49])
        by smtp.gmail.com with ESMTPSA id o16-20020a170902d4d000b001c3267ae317sm6133926plg.165.2023.11.14.13.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 13:42:04 -0800 (PST)
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
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v4 02/15] fs: Move enum rw_hint into a new header file
Date:   Tue, 14 Nov 2023 13:40:57 -0800
Message-ID: <20231114214132.1486867-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231114214132.1486867-1-bvanassche@acm.org>
References: <20231114214132.1486867-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move enum rw_hint into a new header file to prepare for using this data
type in the block layer. Add the attribute __packed to reduce the space
occupied by instances of this data type from four bytes to one byte.
Change the data type of i_write_hint from u8 into enum rw_hint. Change
the RWH_* constants into literal constants to prevent that
<uapi/linux/fcntl.h> would have to be included.

Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 fs/f2fs/f2fs.h          |  1 +
 fs/fcntl.c              |  1 +
 fs/inode.c              |  1 +
 include/linux/fs.h      | 16 ++--------------
 include/linux/rw_hint.h | 20 ++++++++++++++++++++
 5 files changed, 25 insertions(+), 14 deletions(-)
 create mode 100644 include/linux/rw_hint.h

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 9043cedfa12b..8e0c66a6b097 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -24,6 +24,7 @@
 #include <linux/blkdev.h>
 #include <linux/quotaops.h>
 #include <linux/part_stat.h>
+#include <linux/rw_hint.h>
 #include <crypto/hash.h>
 
 #include <linux/fscrypt.h>
diff --git a/fs/fcntl.c b/fs/fcntl.c
index c80a6acad742..880828e14420 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -27,6 +27,7 @@
 #include <linux/memfd.h>
 #include <linux/compat.h>
 #include <linux/mount.h>
+#include <linux/rw_hint.h>
 
 #include <linux/poll.h>
 #include <asm/siginfo.h>
diff --git a/fs/inode.c b/fs/inode.c
index 7965d5e07012..e9ae2199d67b 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -20,6 +20,7 @@
 #include <linux/ratelimit.h>
 #include <linux/list_lru.h>
 #include <linux/iversion.h>
+#include <linux/rw_hint.h>
 #include <trace/events/writeback.h>
 #include "internal.h"
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 59f9de9df0fe..a08014b68d6e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -43,6 +43,7 @@
 #include <linux/cred.h>
 #include <linux/mnt_idmapping.h>
 #include <linux/slab.h>
+#include <linux/rw_hint.h>
 
 #include <asm/byteorder.h>
 #include <uapi/linux/fs.h>
@@ -309,19 +310,6 @@ struct address_space;
 struct writeback_control;
 struct readahead_control;
 
-/*
- * Write life time hint values.
- * Stored in struct inode as u8.
- */
-enum rw_hint {
-	WRITE_LIFE_0	= 0,
-	WRITE_LIFE_1	= RWH_WRITE_LIFE_NONE,
-	WRITE_LIFE_2	= RWH_WRITE_LIFE_SHORT,
-	WRITE_LIFE_3	= RWH_WRITE_LIFE_MEDIUM,
-	WRITE_LIFE_4	= RWH_WRITE_LIFE_LONG,
-	WRITE_LIFE_5	= RWH_WRITE_LIFE_EXTREME,
-};
-
 /* Match RWF_* bits to IOCB bits */
 #define IOCB_HIPRI		(__force int) RWF_HIPRI
 #define IOCB_DSYNC		(__force int) RWF_DSYNC
@@ -677,7 +665,7 @@ struct inode {
 	spinlock_t		i_lock;	/* i_blocks, i_bytes, maybe i_size */
 	unsigned short          i_bytes;
 	u8			i_blkbits;
-	u8			i_write_hint;
+	enum rw_hint		i_write_hint;
 	blkcnt_t		i_blocks;
 
 #ifdef __NEED_I_SIZE_ORDERED
diff --git a/include/linux/rw_hint.h b/include/linux/rw_hint.h
new file mode 100644
index 000000000000..f172efb09655
--- /dev/null
+++ b/include/linux/rw_hint.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_RW_HINT_H
+#define _LINUX_RW_HINT_H
+
+#include <linux/build_bug.h>
+#include <linux/compiler_attributes.h>
+
+/* Block storage write lifetime hint values. */
+enum rw_hint {
+	WRITE_LIFE_0	= 0, /* RWH_WRITE_LIFE_NOT_SET */
+	WRITE_LIFE_1	= 1, /* RWH_WRITE_LIFE_NONE */
+	WRITE_LIFE_2	= 2, /* RWH_WRITE_LIFE_SHORT */
+	WRITE_LIFE_3	= 3, /* RWH_WRITE_LIFE_MEDIUM */
+	WRITE_LIFE_4	= 4, /* RWH_WRITE_LIFE_LONG */
+	WRITE_LIFE_5	= 5, /* RWH_WRITE_LIFE_EXTREME */
+} __packed;
+
+static_assert(sizeof(enum rw_hint) == 1);
+
+#endif /* _LINUX_RW_HINT_H */
