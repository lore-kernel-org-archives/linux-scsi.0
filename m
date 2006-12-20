From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 2/6] bsg: minor cleanups
Date: Wed, 20 Dec 2006 14:43:00 +0900
Message-ID: <20061220144300Y.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:60937 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932986AbWLTFnE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Dec 2006 00:43:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jens.axboe@oracle.com, dougg@torque.net

This just kills linux/config.h and dprintk warnings.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 724b693..53a09a5 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -16,7 +16,6 @@
  *	  seperated right now.
  *
  */
-#include <linux/config.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/file.h>
@@ -347,8 +346,8 @@ static void bsg_rq_end_io(struct request
 	struct bsg_device *bd = bc->bd;
 	unsigned long flags;
 
-	dprintk("%s: finished rq %p bio %p, bc %p offset %ld stat %d\n",
-			bd->name, rq, bc, bc->bio, bc - bd->cmd_map, uptodate);
+	dprintk("%s: finished rq %p bc %p, bio %p offset %d stat %d\n",
+		bd->name, rq, bc, bc->bio, bc - bd->cmd_map, uptodate);
 
 	bc->hdr.duration = jiffies_to_msecs(jiffies - bc->hdr.duration);
 
@@ -562,7 +561,7 @@ bsg_read(struct file *file, char __user
 	int ret;
 	ssize_t bytes_read;
 
-	dprintk("%s: read %lu bytes\n", bd->name, count);
+	dprintk("%s: read %Zd bytes\n", bd->name, count);
 
 	bsg_set_block(bd, file);
 	bytes_read = 0;
@@ -642,7 +641,7 @@ bsg_write(struct file *file, const char
 	ssize_t bytes_read;
 	int ret;
 
-	dprintk("%s: write %lu bytes\n", bd->name, count);
+	dprintk("%s: write %Zd bytes\n", bd->name, count);
 
 	bsg_set_block(bd, file);
 	bsg_set_write_perm(bd, file);
@@ -657,7 +656,7 @@ bsg_write(struct file *file, const char
 	if (!bytes_read || (bytes_read && err_block_err(ret)))
 		bytes_read = ret;
 
-	dprintk("%s: returning %lu\n", bd->name, bytes_read);
+	dprintk("%s: returning %Zd\n", bd->name, bytes_read);
 	return bytes_read;
 }
 
@@ -768,7 +767,7 @@ #endif
 
 	strncpy(bd->name, disk->disk_name, sizeof(bd->name) - 1);
 	dprintk("bound to <%s>, max queue %d\n",
-		format_dev_t(buf, i->i_rdev), bd->max_queue);
+		format_dev_t(buf, inode->i_rdev), bd->max_queue);
 
 	mutex_unlock(&bsg_mutex);
 	return bd;
-- 
1.4.3.2

