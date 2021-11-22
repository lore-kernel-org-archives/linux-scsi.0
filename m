Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CA66C31D97
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 13:06:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234876AbhKVNJy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 08:09:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239505AbhKVNJw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 08:09:52 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEEE3C061574;
        Mon, 22 Nov 2021 05:06:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=5Uyy5PbhZA8/zW/oA9H4mT4sKjL/uHAgooK2z96GrOM=; b=UcBDa9TdjfLH0zIqU872yu7Uzr
        u+zixTWPA1XCbeLZQwonFMZspRhn7i9dEDkudUleUe1myxK6HQtlphPwGOXqbzG1GIvq/LtTSF0Dt
        rT6pkuoUuuh9gPwvyHL6+0OP0SygwzOyMuB5L7bGShlEPnOMs71Hrzb4l3yqrqXayQmL5+KjMB+dw
        ZxDNXEM36wPRc3Jk8XsTXTbtkNNH0WFVwrW6Sj58ZJu4mwQcy7FWSvCyN7RcNt0M+jhDVGP7r9kBO
        J7LzBmqlsT319AbQoPEJUNu/g/up/npXhjPHCcXYOVCu17EVw5B6mviToAG6wTQ7lBBUYzbdut80Y
        3YqyecoQ==;
Received: from [2001:4bb8:180:22b2:9649:4579:dcf9:9fb2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mp91v-00CrtQ-11; Mon, 22 Nov 2021 13:06:43 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>, linux-block@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 13/14] block: cleanup the GENHD_FL_* definitions
Date:   Mon, 22 Nov 2021 14:06:24 +0100
Message-Id: <20211122130625.1136848-14-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211122130625.1136848-1-hch@lst.de>
References: <20211122130625.1136848-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Switch to an enum and tidy up the documentation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/genhd.h | 32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index b8ced80178d64..6906a45bc761a 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -39,28 +39,24 @@ struct partition_meta_info {
 /**
  * DOC: genhd capability flags
  *
- * ``GENHD_FL_REMOVABLE`` (0x0001): indicates that the block device
- * gives access to removable media.
- * When set, the device remains present even when media is not
- * inserted.
- * Must not be set for devices which are removed entirely when the
+ * ``GENHD_FL_REMOVABLE``: indicates that the block device gives access to
+ * removable media.  When set, the device remains present even when media is not
+ * inserted.  Shall not be set for devices which are removed entirely when the
  * media is removed.
  *
- * ``GENHD_FL_NO_PART`` (0x0200): partition support is disabled.
- * The kernel will not scan for partitions from add_disk, and users
- * can't add partitions manually.
+ * ``GENHD_FL_HIDDEN``: the block device is hidden; it doesn't produce events,
+ * doesn't appear in sysfs, and can't be opened from userspace or using
+ * blkdev_get*. Used for the underlying components of multipath devices.
+ *
+ * ``GENHD_FL_NO_PART``: partition support is disabled.  The kernel will not
+ * scan for partitions from add_disk, and users can't add partitions manually.
  *
- * ``GENHD_FL_HIDDEN`` (0x0400): the block device is hidden; it
- * doesn't produce events, doesn't appear in sysfs, and doesn't have
- * an associated ``bdev``.
- * Implies ``GENHD_FL_NO_PART``.
- * Used for multipath devices.
  */
-#define GENHD_FL_REMOVABLE			0x0001
-/* 2 is unused (used to be GENHD_FL_DRIVERFS) */
-/* 4 is unused (used to be GENHD_FL_MEDIA_CHANGE_NOTIFY) */
-#define GENHD_FL_NO_PART			0x0200
-#define GENHD_FL_HIDDEN				0x0400
+enum {
+	GENHD_FL_REMOVABLE			= 1 << 0,
+	GENHD_FL_HIDDEN				= 1 << 1,
+	GENHD_FL_NO_PART			= 1 << 2,
+};
 
 enum {
 	DISK_EVENT_MEDIA_CHANGE			= 1 << 0, /* media changed */
-- 
2.30.2

