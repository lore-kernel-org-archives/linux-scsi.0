From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/30] block/loop: implement REQ_FLUSH/FUA support
Date: Wed, 25 Aug 2010 17:47:31 +0200
Message-ID: <1282751267-3530-15-git-send-email-tj@kernel.org>
References: <1282751267-3530-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1282751267-3530-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, hch@l
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Deprecate REQ_HARDBARRIER and implement REQ_FLUSH/FUA instead.  Also,
instead of checking file->f_op->fsync() directly, look at the value of
vfs_fsync() and ignore -EINVAL return.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/block/loop.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 953d1e1..5d27bc6 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -477,17 +477,17 @@ static int do_bio_filebacked(struct loop_device *lo, struct bio *bio)
 	pos = ((loff_t) bio->bi_sector << 9) + lo->lo_offset;
 
 	if (bio_rw(bio) == WRITE) {
-		bool barrier = (bio->bi_rw & REQ_HARDBARRIER);
 		struct file *file = lo->lo_backing_file;
 
-		if (barrier) {
-			if (unlikely(!file->f_op->fsync)) {
-				ret = -EOPNOTSUPP;
-				goto out;
-			}
+		/* REQ_HARDBARRIER is deprecated */
+		if (bio->bi_rw & REQ_HARDBARRIER) {
+			ret = -EOPNOTSUPP;
+			goto out;
+		}
 
+		if (bio->bi_rw & REQ_FLUSH) {
 			ret = vfs_fsync(file, 0);
-			if (unlikely(ret)) {
+			if (unlikely(ret && ret != -EINVAL)) {
 				ret = -EIO;
 				goto out;
 			}
@@ -495,9 +495,9 @@ static int do_bio_filebacked(struct loop_device *lo, struct bio *bio)
 
 		ret = lo_send(lo, bio, pos);
 
-		if (barrier && !ret) {
+		if ((bio->bi_rw & REQ_FUA) && !ret) {
 			ret = vfs_fsync(file, 0);
-			if (unlikely(ret))
+			if (unlikely(ret && ret != -EINVAL))
 				ret = -EIO;
 		}
 	} else
-- 
1.7.1
