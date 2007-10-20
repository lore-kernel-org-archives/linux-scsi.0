From: michaelc@cs.wisc.edu
Subject: [PATCH 05/10] have block/scsi_ioctl user GFP_NOIO
Date: Sat, 20 Oct 2007 00:44:39 -0500
Message-ID: <11928590871678-git-send-email-michaelc@cs.wisc.edu>
References: <11928590843394-git-send-email-michaelc@cs.wisc.edu>
	<1192859085521-git-send-email-michaelc@cs.wisc.edu>
	<11928590862112-git-send-email-michaelc@cs.wisc.edu>
	<11928590861021-git-send-email-michaelc@cs.wisc.edu>
	<11928590871413-git-send-email-michaelc@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <11928590871413-git-send-email-michaelc@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-scsi@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com
Cc: Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

Because user spaces uses block/scsi_ioctl for path testing and to
readd devices, we cannot use GFP_KERNEL.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 block/scsi_ioctl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index bf97b22..adb3fc9 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -315,7 +315,7 @@ static int sg_io(struct file *file, struct request_queue *q,
 			break;
 		}
 
-	rq = blk_get_request(q, writing ? WRITE : READ, GFP_KERNEL);
+	rq = blk_get_request(q, writing ? WRITE : READ, GFP_NOIO);
 	if (!rq)
 		return -ENOMEM;
 
@@ -348,7 +348,7 @@ static int sg_io(struct file *file, struct request_queue *q,
 		kfree(iov);
 	} else if (hdr->dxfer_len)
 		ret = blk_rq_setup_transfer(NULL, rq, hdr->dxferp,
-					    hdr->dxfer_len, GFP_KERNEL);
+					    hdr->dxfer_len, GFP_NOIO);
 
 	if (ret)
 		goto out;
-- 
1.5.1.2
