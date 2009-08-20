From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [cciss: PATCH 13/17] Silence noisy per-disk messages output by
	cciss_read_capacity
Date: Thu, 20 Aug 2009 10:18:49 -0500
Message-ID: <20090820151849.22833.23607.stgit@beardog.cce.hp.com>
References: <20090820151648.22833.14168.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754800AbZHTPSt@vger.kernel.org>
In-Reply-To: <20090820151648.22833.14168.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, axboe@kernel.dk, andrew.patterson@hp.com, mikem@c18-ss-1-lb.cnet.com, scameron@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

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
 
