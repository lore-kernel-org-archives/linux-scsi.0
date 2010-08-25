From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 26/30] ext4: do not send discards as barriers
Date: Wed, 25 Aug 2010 17:47:43 +0200
Message-ID: <1282751267-3530-27-git-send-email-tj@kernel.org>
References: <1282751267-3530-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1282751267-3530-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>

ext4 already uses synchronous discards, no need to add I/O barriers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/ext4/mballoc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index df44b34..a22bfef 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2567,7 +2567,7 @@ static inline void ext4_issue_discard(struct super_block *sb,
 	trace_ext4_discard_blocks(sb,
 			(unsigned long long) discard_block, count);
 	ret = sb_issue_discard(sb, discard_block, count, GFP_NOFS,
-			       BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
+			       BLKDEV_IFL_WAIT);
 	if (ret == EOPNOTSUPP) {
 		ext4_warning(sb, "discard not supported, disabling");
 		clear_opt(EXT4_SB(sb)->s_mount_opt, DISCARD);
-- 
1.7.1

