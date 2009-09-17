From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 13/20] cciss: Silence noisy per-disk messages output by
	cciss_read_capacity
Date: Thu, 17 Sep 2009 13:47:55 -0500
Message-ID: <20090917184755.15105.46098.stgit@beardog.cce.hp.com>
References: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:46604 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbZIQSr0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2009 14:47:26 -0400
In-Reply-To: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, andrew.patterson@hp.com, mikem@beardog.cce.hp.com, scameron@beardog.cce.hp.com

Silence noisy per-disk messages output by cciss_read_capacity

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/block/cciss.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index a4cb041..239c4f5 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -2601,8 +2601,6 @@ static void cciss_geometry_inquiry(int ctlr, int logvol,
 	} else {		/* Get geometry failed */
 		printk(KERN_WARNING "cciss: reading geometry failed\n");
 	}
-	printk(KERN_INFO "      heads=%d, sectors=%d, cylinders=%d\n\n",
-	       drv->heads, drv->sectors, drv->cylinders);
 }
 
 static void
@@ -2636,9 +2634,6 @@ cciss_read_capacity(int ctlr, int logvol, int withirq, sector_t *total_size,
 		*total_size = 0;
 		*block_size = BLOCK_SIZE;
 	}
-	if (*total_size != 0)
-		printk(KERN_INFO "      blocks= %llu block_size= %d\n",
-		(unsigned long long)*total_size+1, *block_size);
 	kfree(buf);
 }
 

