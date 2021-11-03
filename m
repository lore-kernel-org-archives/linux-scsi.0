Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D57D8C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 17:45:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFDAE60F90
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 17:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbhKCRsV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 13:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbhKCRsO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 13:48:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54510C061210;
        Wed,  3 Nov 2021 10:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=nUbriMtS0tMOBukXiTNklzBu+IR9/7LiW+J3IpcS0Gc=; b=ydjLH4U6deLdAtRXR3I22Mng7E
        CuOPi4Ljm40Kud5+zwMK7TJO+vTyc9gdtjypLwPKsg0DZxRGHizr5YIW27d7BeLTYKr3yd/kKB/My
        uO51rjMjoK9Edr7duzyx6+FWV0f/uSx2I6/4DhbOFgOwpPkQl4VuDHU9CKXJibLJMmEjJwxL/uOOO
        Mkp7P/DzkimXW4y2WE7tNREcg0THAaJPif/tjjui9F5B00fvLBbF/JHVgSMaIVeaEu4BQBKkrg0P7
        94OCiSH8Gm+zxqWyz1zgd0Z1xsz1So5NpnEJJ4i8H93zF3prwSgBZbuKShXwtFHEAedSx0X4XBEwH
        itqU25Yg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miKKA-005z5l-Lq; Wed, 03 Nov 2021 17:45:22 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     axboe@kernel.dk, hch@lst.de, penguin-kernel@i-love.sakura.ne.jp,
        dan.j.williams@intel.com, vishal.l.verma@intel.com,
        dave.jiang@intel.com, ira.weiny@intel.com, richard@nod.at,
        miquel.raynal@bootlin.com, vigneshr@ti.com, efremov@linux.com,
        song@kernel.org, martin.petersen@oracle.com, hare@suse.de,
        jack@suse.cz, ming.lei@redhat.com, tj@kernel.org, mcgrof@kernel.org
Cc:     linux-mtd@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 12/13] block: fix __register_blkdev() probe add_disk() failures
Date:   Wed,  3 Nov 2021 10:45:20 -0700
Message-Id: <20211103174521.1426407-13-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103174521.1426407-1-mcgrof@kernel.org>
References: <20211103174521.1426407-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

__register_blkdev() is used to register a probe callback, and
that callback is typically used to call add_disk(). Now that
we are able to capture errors for add_disk(), we need to fix
those probe calls where add_disk() fails and clean up resources.

We don't extend the probe call to return the error given:

1) we'd have to always special-case the case where the disk
   was already present, as otherwise concurrent requests to
   open an existing block device would fail, and this would be
   a userspace visible change
2) the error from ilookup() on blkdev_get_no_open() is sufficient
3) The only thing the probe call is used for is to support
   pre-devtmpfs, pre-udev semantics that want to create disks when
   their pre-created device node is accessed, and so we don't care
   for failures on probe there.

We expand documentation for the probe callback to ensure users
cleanup resources if add_disk() is used and to clarify this interface
may be removed in the future.

This fixes the ataflop and floppy driver uses of the probe call,
which lacked proper error handling for the add_disk() calls.

Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 block/genhd.c           |  5 ++++-
 drivers/block/ataflop.c | 12 +++++++++---
 drivers/block/floppy.c  | 11 +++++++++--
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 4ed87f25276a..8837a89242a2 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -213,7 +213,10 @@ void blkdev_show(struct seq_file *seqf, off_t offset)
  * @major: the requested major device number [1..BLKDEV_MAJOR_MAX-1]. If
  *         @major = 0, try to allocate any unused major number.
  * @name: the name of the new block device as a zero terminated string
- * @probe: allback that is called on access to any minor number of @major
+ * @probe: pre-devtmpfs / pre-udev callback used to create disks when their
+ *	   their pre-created device node is accessed. When a probe call
+ *	   uses add_disk() and it fails the driver must cleanup resources.
+ *	   This interface may soon be removed.
  *
  * The @name must be unique within the system.
  *
diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index 170dd193cef6..cce6615fe10a 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -2012,6 +2012,7 @@ static void ataflop_probe(dev_t dev)
 {
 	int drive = MINOR(dev) & 3;
 	int type  = MINOR(dev) >> 2;
+	int err = 0;
 
 	if (type)
 		type--;
@@ -2019,9 +2020,14 @@ static void ataflop_probe(dev_t dev)
 	if (drive >= FD_MAX_UNITS || type >= NUM_DISK_MINORS)
 		return;
 	if (!unit[drive].disk[type]) {
-		if (ataflop_alloc_disk(drive, type) == 0) {
-			add_disk(unit[drive].disk[type]);
-			unit[drive].registered[type] = true;
+		err = ataflop_alloc_disk(drive, type);
+		if (err == 0) {
+			err = add_disk(unit[drive].disk[type]);
+			if (err) {
+				blk_cleanup_disk(unit[drive].disk[type]);
+				unit[drive].disk[type] = NULL;
+			} else
+				unit[drive].registered[type] = true;
 		}
 	}
 }
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 3873e789478e..cebc11b74b1a 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4522,6 +4522,7 @@ static void floppy_probe(dev_t dev)
 {
 	unsigned int drive = (MINOR(dev) & 3) | ((MINOR(dev) & 0x80) >> 5);
 	unsigned int type = (MINOR(dev) >> 2) & 0x1f;
+	int err = 0;
 
 	if (drive >= N_DRIVE || !floppy_available(drive) ||
 	    type >= ARRAY_SIZE(floppy_type))
@@ -4529,8 +4530,14 @@ static void floppy_probe(dev_t dev)
 
 	mutex_lock(&floppy_probe_lock);
 	if (!disks[drive][type]) {
-		if (floppy_alloc_disk(drive, type) == 0)
-			add_disk(disks[drive][type]);
+		err = floppy_alloc_disk(drive, type);
+		if (err == 0) {
+			err = add_disk(disks[drive][type]);
+			if (err) {
+				blk_cleanup_disk(disks[drive][type]);
+				disks[drive][type] = NULL;
+			}
+		}
 	}
 	mutex_unlock(&floppy_probe_lock);
 }
-- 
2.33.0

