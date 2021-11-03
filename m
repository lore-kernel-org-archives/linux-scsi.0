Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16178C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 23:05:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 013D5611C1
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 23:05:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbhKCXHi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 19:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbhKCXHc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 19:07:32 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B199FC06120D;
        Wed,  3 Nov 2021 16:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=jpJTkSSNYfm8k3vCoroD+zdUZD7KBYacfLESdtV/dHo=; b=BR6/6HadR6sgfSI4wwyjD8/rbc
        Fj4CRBpG1Mha2EiXmy1tw6n9wRj/CJBhee52TTwsBYGpmk+iztyB641PJv1cbNLpgcjE/OqvkWVhJ
        GqFIOa+qpjIbSByGm+3t2bioiVwG8dp4KAtAwK8Q4sn0FZWF9i5m3RjEB5sboJjgtIidA4fy//Nn+
        EAdpQATSlVHd1LosIwIpWt2rANY0qzFVAWQzhvAoaZtFv96EWpXkz+HR/xs4j+zjTlXULCD+4sBhY
        F7Bc+fpVh0UKsAaq9eDyq2MyXlE/NYxhYf/mXyqlhPyF3gPtqPl6im7NPIxJxo06ZWlOCiyKyvfut
        EQ142/qw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miPJ8-006sed-Py; Wed, 03 Nov 2021 23:04:38 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     axboe@kernel.dk, hch@lst.de, penguin-kernel@i-love.sakura.ne.jp,
        dan.j.williams@intel.com, vishal.l.verma@intel.com,
        dave.jiang@intel.com, ira.weiny@intel.com, richard@nod.at,
        miquel.raynal@bootlin.com, vigneshr@ti.com, efremov@linux.com,
        song@kernel.org, martin.petersen@oracle.com, hare@suse.de,
        jack@suse.cz, ming.lei@redhat.com, tj@kernel.org, mcgrof@kernel.org
Cc:     linux-mtd@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Michael Schmitz <schmitzmic@gmail.com>
Subject: [PATCH v5 10/14] ataflop: remove ataflop_probe_lock mutex
Date:   Wed,  3 Nov 2021 16:04:33 -0700
Message-Id: <20211103230437.1639990-11-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103230437.1639990-1-mcgrof@kernel.org>
References: <20211103230437.1639990-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

Commit bf9c0538e485b591 ("ataflop: use a separate gendisk for each media
format") introduced ataflop_probe_lock mutex, but forgot to unlock the
mutex when atari_floppy_init() (i.e. module loading) succeeded. This will
result in double lock deadlock if ataflop_probe() is called. Also,
unregister_blkdev() must not be called from atari_floppy_init() with
ataflop_probe_lock held when atari_floppy_init() failed, for
ataflop_probe() waits for ataflop_probe_lock with major_names_lock held
(i.e. AB-BA deadlock).

__register_blkdev() needs to be called last in order to avoid calling
ataflop_probe() when atari_floppy_init() is about to fail, for memory for
completing already-started ataflop_probe() safely will be released as soon
as atari_floppy_init() released ataflop_probe_lock mutex.

As with commit 8b52d8be86d72308 ("loop: reorder loop_exit"),
unregister_blkdev() needs to be called first in order to avoid calling
ataflop_alloc_disk() from ataflop_probe() after del_gendisk() from
atari_floppy_exit().

By relocating __register_blkdev() / unregister_blkdev() as explained above,
we can remove ataflop_probe_lock mutex, for probe function and __exit
function are serialized by major_names_lock mutex.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: bf9c0538e485b591 ("ataflop: use a separate gendisk for each media format")
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>
---
 drivers/block/ataflop.c | 47 +++++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 20 deletions(-)

diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index d14bdc3589b2..170dd193cef6 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -2008,8 +2008,6 @@ static int ataflop_alloc_disk(unsigned int drive, unsigned int type)
 	return 0;
 }
 
-static DEFINE_MUTEX(ataflop_probe_lock);
-
 static void ataflop_probe(dev_t dev)
 {
 	int drive = MINOR(dev) & 3;
@@ -2020,14 +2018,32 @@ static void ataflop_probe(dev_t dev)
 
 	if (drive >= FD_MAX_UNITS || type >= NUM_DISK_MINORS)
 		return;
-	mutex_lock(&ataflop_probe_lock);
 	if (!unit[drive].disk[type]) {
 		if (ataflop_alloc_disk(drive, type) == 0) {
 			add_disk(unit[drive].disk[type]);
 			unit[drive].registered[type] = true;
 		}
 	}
-	mutex_unlock(&ataflop_probe_lock);
+}
+
+static void atari_floppy_cleanup(void)
+{
+	int i;
+	int type;
+
+	for (i = 0; i < FD_MAX_UNITS; i++) {
+		for (type = 0; type < NUM_DISK_MINORS; type++) {
+			if (!unit[i].disk[type])
+				continue;
+			del_gendisk(unit[i].disk[type]);
+			blk_cleanup_queue(unit[i].disk[type]->queue);
+			put_disk(unit[i].disk[type]);
+		}
+		blk_mq_free_tag_set(&unit[i].tag_set);
+	}
+
+	del_timer_sync(&fd_timer);
+	atari_stram_free(DMABuffer);
 }
 
 static void atari_cleanup_floppy_disk(struct atari_floppy_struct *fs)
@@ -2053,11 +2069,6 @@ static int __init atari_floppy_init (void)
 		/* Amiga, Mac, ... don't have Atari-compatible floppy :-) */
 		return -ENODEV;
 
-	mutex_lock(&ataflop_probe_lock);
-	ret = __register_blkdev(FLOPPY_MAJOR, "fd", ataflop_probe);
-	if (ret)
-		goto out_unlock;
-
 	for (i = 0; i < FD_MAX_UNITS; i++) {
 		memset(&unit[i].tag_set, 0, sizeof(unit[i].tag_set));
 		unit[i].tag_set.ops = &ataflop_mq_ops;
@@ -2113,7 +2124,12 @@ static int __init atari_floppy_init (void)
 	       UseTrackbuffer ? "" : "no ");
 	config_types();
 
-	return 0;
+	ret = __register_blkdev(FLOPPY_MAJOR, "fd", ataflop_probe);
+	if (ret) {
+		printk(KERN_ERR "atari_floppy_init: cannot register block device\n");
+		atari_floppy_cleanup();
+	}
+	return ret;
 
 err_out_dma:
 	atari_stram_free(DMABuffer);
@@ -2121,9 +2137,6 @@ static int __init atari_floppy_init (void)
 	while (--i >= 0)
 		atari_cleanup_floppy_disk(&unit[i]);
 
-	unregister_blkdev(FLOPPY_MAJOR, "fd");
-out_unlock:
-	mutex_unlock(&ataflop_probe_lock);
 	return ret;
 }
 
@@ -2168,14 +2181,8 @@ __setup("floppy=", atari_floppy_setup);
 
 static void __exit atari_floppy_exit(void)
 {
-	int i;
-
-	for (i = 0; i < FD_MAX_UNITS; i++)
-		atari_cleanup_floppy_disk(&unit[i]);
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
-
-	del_timer_sync(&fd_timer);
-	atari_stram_free( DMABuffer );
+	atari_floppy_cleanup();
 }
 
 module_init(atari_floppy_init)
-- 
2.33.0

