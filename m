From: Dan Carpenter <error27@gmail.com>
Subject: [patch] [SCSI] target: checking for NULL instead of IS_ERR
Date: Sat, 15 Jan 2011 17:03:00 +0300
Message-ID: <20110115140300.GC2721@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

blkdev_get_by_path() returns an ERR_PTR() or error and it doesn't return
a NULL.  It looks like this bug would be easy to trigger by mistake.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index c6e0d75..3456135 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -154,7 +154,7 @@ static struct se_device *iblock_create_virtdevice(
 
 	bd = blkdev_get_by_path(ib_dev->ibd_udev_path,
 				FMODE_WRITE|FMODE_READ|FMODE_EXCL, ib_dev);
-	if (!(bd))
+	if (IS_ERR(bd))
 		goto failed;
 	/*
 	 * Setup the local scope queue_limits from struct request_queue->limits
