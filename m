From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 15/20] cciss: Don't check h->busy_initializing in cciss_open().
Date: Thu, 17 Sep 2009 13:48:05 -0500
Message-ID: <20090917184805.15105.58449.stgit@beardog.cce.hp.com>
References: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:46650 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760160AbZIQSrg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2009 14:47:36 -0400
In-Reply-To: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, andrew.patterson@hp.com, mikem@beardog.cce.hp.com, scameron@beardog.cce.hp.com

Don't check h->busy_initializing in cciss_open().  Open won't be
called before things are ready, but h->busy_initializing won't be
unset until after the initial rebuild_lun_table is finished.  But,
to read the partitions, cciss_open will be called for each logical
drive during rebuild_lun_table.  If cciss_open checks h->busy_initializing,
then the reading of the partition information during the initial
rebuild_lun_table will fail, which is especially bad news if it
happens to be your boot device.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/block/cciss.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 56eeb68..0ff665e 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -829,7 +829,7 @@ static int cciss_open(struct block_device *bdev, fmode_t mode)
 	printk(KERN_DEBUG "cciss_open %s\n", bdev->bd_disk->disk_name);
 #endif				/* CCISS_DEBUG */
 
-	if (host->busy_initializing || drv->busy_configuring)
+	if (drv->busy_configuring)
 		return -EBUSY;
 	/*
 	 * Root is allowed to open raw volume zero even if it's not configured

