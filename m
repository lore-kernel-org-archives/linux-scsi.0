From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 23/32] scsi: use %*pb[l] to print bitmaps including cpumasks and nodemasks
Date: Sat, 24 Jan 2015 09:03:29 -0500
Message-ID: <1422108218-25398-24-git-send-email-tj@kernel.org>
References: <1422108218-25398-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1422108218-25398-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

* map_show()'s return value is too high by one and the function could
  modify beyond the end of the buffer when the formatted text is long
  enough.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Please wait till the forementioned patches are merged to mainline
before applying to subsystem trees.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi_debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 7b8b51b..37b63a6 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4536,10 +4536,10 @@ static ssize_t map_show(struct device_driver *ddp, char *buf)
 		return scnprintf(buf, PAGE_SIZE, "0-%u\n",
 				 sdebug_store_sectors);
 
-	count = bitmap_scnlistprintf(buf, PAGE_SIZE, map_storep, map_size);
-
+	count = scnprintf(buf, PAGE_SIZE - 1, "%*pbl",
+			  (int)map_size, map_storep);
 	buf[count++] = '\n';
-	buf[count++] = 0;
+	buf[count] = '\0';
 
 	return count;
 }
-- 
2.1.0
