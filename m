From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 18/30] block: pass gfp_mask and flags to sb_issue_discard
Date: Wed, 25 Aug 2010 17:47:35 +0200
Message-ID: <1282751267-3530-19-git-send-email-tj@kernel.org>
References: <1282751267-3530-1-git-send-email-tj@kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1282751267-3530-1-git-send-email-tj@kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>

We'll need to get rid of the BLKDEV_IFL_BARRIER flag, and to facilitate
that and to make the interface less confusing pass all flags explicitly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/ext4/mballoc.c      |    3 ++-
 fs/fat/fatent.c        |    4 +++-
 include/linux/blkdev.h |   11 +++++------
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 4b4ad4b..df44b34 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2566,7 +2566,8 @@ static inline void ext4_issue_discard(struct super_block *sb,
 	discard_block = block + ext4_group_first_block_no(sb, block_group);
 	trace_ext4_discard_blocks(sb,
 			(unsigned long long) discard_block, count);
-	ret = sb_issue_discard(sb, discard_block, count);
+	ret = sb_issue_discard(sb, discard_block, count, GFP_NOFS,
+			       BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
 	if (ret == EOPNOTSUPP) {
 		ext4_warning(sb, "discard not supported, disabling");
 		clear_opt(EXT4_SB(sb)->s_mount_opt, DISCARD);
diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index 81184d3..3a56a82 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -577,7 +577,9 @@ int fat_free_clusters(struct inode *inode, int cluster)
 
 				sb_issue_discard(sb,
 					fat_clus_to_blknr(sbi, first_cl),
-					nr_clus * sbi->sec_per_clus);
+					nr_clus * sbi->sec_per_clus,
+					GFP_NOFS,
+					BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
 
 				first_cl = cluster;
 			}
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8ef705f..6b305eb 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -881,13 +881,12 @@ extern int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags);
 extern int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 			sector_t nr_sects, gfp_t gfp_mask, unsigned long flags);
-static inline int sb_issue_discard(struct super_block *sb,
-				   sector_t block, sector_t nr_blocks)
+static inline int sb_issue_discard(struct super_block *sb, sector_t block,
+		sector_t nr_blocks, gfp_t gfp_mask, unsigned long flags)
 {
-	block <<= (sb->s_blocksize_bits - 9);
-	nr_blocks <<= (sb->s_blocksize_bits - 9);
-	return blkdev_issue_discard(sb->s_bdev, block, nr_blocks, GFP_NOFS,
-				   BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
+	return blkdev_issue_discard(sb->s_bdev, block << (sb->s_blocksize_bits - 9),
+				    nr_blocks << (sb->s_blocksize_bits - 9),
+				    gfp_mask, flags);
 }
 
 extern int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm);
-- 
1.7.1

