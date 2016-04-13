From: mchristi@redhat.com
Subject: [PATCH 36/42] ide cd: do not set REQ_WRITE on requests.
Date: Wed, 13 Apr 2016 14:36:22 -0500
Message-ID: <1460576188-5751-37-git-send-email-mchristi@redhat.com>
References: <1460576188-5751-1-git-send-email-mchristi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460576188-5751-1-git-send-email-mchristi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

The block layer will set the correct READ/WRITE operation flags/fields
when creating a request, so there is not need for drivers to set the
REQ_WRITE flag.

This patch is compile tested only.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/ide/ide-cd_ioctl.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/ide/ide-cd_ioctl.c b/drivers/ide/ide-cd_ioctl.c
index 474173e..5887a7a 100644
--- a/drivers/ide/ide-cd_ioctl.c
+++ b/drivers/ide/ide-cd_ioctl.c
@@ -459,9 +459,6 @@ int ide_cdrom_packet(struct cdrom_device_info *cdi,
 	   layer. the packet must be complete, as we do not
 	   touch it at all. */
 
-	if (cgc->data_direction == CGC_DATA_WRITE)
-		flags |= REQ_WRITE;
-
 	if (cgc->sense)
 		memset(cgc->sense, 0, sizeof(struct request_sense));
 
-- 
2.7.2
