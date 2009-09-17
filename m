From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 17/20] cciss: fix some magic numbers in the raid-level decoding
Date: Thu, 17 Sep 2009 13:48:15 -0500
Message-ID: <20090917184815.15105.11105.stgit@beardog.cce.hp.com>
References: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760403AbZIQSsy@vger.kernel.org>
In-Reply-To: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, andrew.patterson@hp.com, mikem@beardog.cce.hp.com, scameron@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

cciss: fix some magic numbers in the raid-level decoding

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/block/cciss.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index a8684d0..84f15ec 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -254,8 +254,6 @@ static inline void removeQ(CommandList_struct *c)
 
 #include "cciss_scsi.c"		/* For SCSI tape support */
 
-#define RAID_UNKNOWN 6
-
 #ifdef CONFIG_PROC_FS
 
 /*
@@ -267,6 +265,7 @@ static inline void removeQ(CommandList_struct *c)
 static const char *raid_label[] = { "0", "4", "1(1+0)", "5", "5+1", "ADG",
 	"UNKNOWN"
 };
+#define RAID_UNKNOWN (sizeof(raid_label) / sizeof(raid_label[0])-1)
 
 static struct proc_dir_entry *proc_cciss;
 
@@ -340,7 +339,7 @@ static int cciss_seq_show(struct seq_file *seq, void *v)
 	vol_sz_frac *= 100;
 	sector_div(vol_sz_frac, ENG_GIG_FACTOR);
 
-	if (drv->raid_level > 5)
+	if (drv->raid_level < 0 || drv->raid_level > RAID_UNKNOWN)
 		drv->raid_level = RAID_UNKNOWN;
 	seq_printf(seq, "cciss/c%dd%d:"
 			"\t%4u.%02uGB\tRAID %s\n",
