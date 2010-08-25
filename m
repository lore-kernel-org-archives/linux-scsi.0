From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 27/30] fat: do not send discards as barriers
Date: Wed, 25 Aug 2010 17:47:44 +0200
Message-ID: <1282751267-3530-28-git-send-email-tj@kernel.org>
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
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>

fat already uses synchronous discards, no need to add I/O barriers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/fat/fatent.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index 3a56a82..f9a0b7a 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -579,7 +579,7 @@ int fat_free_clusters(struct inode *inode, int cluster)
 					fat_clus_to_blknr(sbi, first_cl),
 					nr_clus * sbi->sec_per_clus,
 					GFP_NOFS,
-					BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
+					BLKDEV_IFL_WAIT);
 
 				first_cl = cluster;
 			}
-- 
1.7.1
