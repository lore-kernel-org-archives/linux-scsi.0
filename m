From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 18/32] scsi/scsi_tgt_lib: scsi_tgtd isn't used in memory reclaim path
Date: Mon,  3 Jan 2011 14:49:41 +0100
Message-ID: <1294062595-30097-19-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1294062595-30097-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, FUJITA Tomonori <tomof@acm.org>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Workqueue scsi_tgtd isn't used during memory reclaim.  Convert to
alloc_workqueue() without WQ_MEM_RECLAIM.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: FUJITA Tomonori <tomof@acm.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org
---
Only compile tested.  Please feel free to take it into the subsystem
tree or simply ack - I'll route it through the wq tree.

Thanks.

 drivers/scsi/scsi_tgt_lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index c399be9..f672820 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -629,7 +629,7 @@ static int __init scsi_tgt_init(void)
 	if (!scsi_tgt_cmd_cache)
 		return -ENOMEM;
 
-	scsi_tgtd = create_workqueue("scsi_tgtd");
+	scsi_tgtd = alloc_workqueue("scsi_tgtd", 0, 1);
 	if (!scsi_tgtd) {
 		err = -ENOMEM;
 		goto free_kmemcache;
-- 
1.7.1
