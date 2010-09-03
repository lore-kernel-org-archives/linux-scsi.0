From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 32/41] nilfs2: replace barriers with explicit
	flush / FUA usage
Date: Fri,  3 Sep 2010 12:29:47 +0200
Message-ID: <1283509796-1510-33-git-send-email-tj@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>

Switch to the WRITE_FLUSH_FUA flag for log writes, remove the EOPNOTSUPP
detection for barriers and stop setting the barrier flag for discards.

tj: nilfs is now fixed to wait for discard completion.  Updated this
    patch accordingly and dropped warning about it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/nilfs2/super.c     |   10 +---------
 fs/nilfs2/the_nilfs.c |    7 ++-----
 2 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 9222633..faa5078 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -178,17 +178,9 @@ static int nilfs_sync_super(struct nilfs_sb_info *sbi, int flag)
 
  retry:
 	set_buffer_dirty(nilfs->ns_sbh[0]);
-
 	if (nilfs_test_opt(sbi, BARRIER)) {
 		err = __sync_dirty_buffer(nilfs->ns_sbh[0],
-					  WRITE_SYNC | WRITE_BARRIER);
-		if (err == -EOPNOTSUPP) {
-			nilfs_warning(sbi->s_super, __func__,
-				      "barrier-based sync failed. "
-				      "disabling barriers\n");
-			nilfs_clear_opt(sbi, BARRIER);
-			goto retry;
-		}
+					  WRITE_SYNC | WRITE_FLUSH_FUA);
 	} else {
 		err = sync_dirty_buffer(nilfs->ns_sbh[0]);
 	}
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 4317f17..400b2ca 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -774,9 +774,7 @@ int nilfs_discard_segments(struct the_nilfs *nilfs, __u64 *segnump,
 			ret = blkdev_issue_discard(nilfs->ns_bdev,
 						   start * sects_per_block,
 						   nblocks * sects_per_block,
-						   GFP_NOFS,
-						   BLKDEV_IFL_WAIT |
-						   BLKDEV_IFL_BARRIER);
+						   GFP_NOFS, BLKDEV_IFL_WAIT);
 			if (ret < 0)
 				return ret;
 			nblocks = 0;
@@ -786,8 +784,7 @@ int nilfs_discard_segments(struct the_nilfs *nilfs, __u64 *segnump,
 		ret = blkdev_issue_discard(nilfs->ns_bdev,
 					   start * sects_per_block,
 					   nblocks * sects_per_block,
-					   GFP_NOFS,
-					  BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
+					   GFP_NOFS, BLKDEV_IFL_WAIT);
 	return ret;
 }
 
-- 
1.7.1
