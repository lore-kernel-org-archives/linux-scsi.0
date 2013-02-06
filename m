From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 60/77] scsi/bfa: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:32 -0800
Message-ID: <1360179649-22465-61-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Krishna C Gudipati <kgudipat@brocade.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Krishna C Gudipati <kgudipat@brocade.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/bfa/bfad_im.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 8f92732..5864f98 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -523,20 +523,13 @@ bfad_im_scsi_host_alloc(struct bfad_s *bfad, struct bfad_im_port_s *im_port,
 	int error = 1;
 
 	mutex_lock(&bfad_mutex);
-	if (!idr_pre_get(&bfad_im_port_index, GFP_KERNEL)) {
+	error = idr_alloc(&bfad_im_port_index, im_port, 0, 0, GFP_KERNEL);
+	if (error < 0) {
 		mutex_unlock(&bfad_mutex);
-		printk(KERN_WARNING "idr_pre_get failure\n");
+		printk(KERN_WARNING "idr_alloc failure\n");
 		goto out;
 	}
-
-	error = idr_get_new(&bfad_im_port_index, im_port,
-					 &im_port->idr_id);
-	if (error) {
-		mutex_unlock(&bfad_mutex);
-		printk(KERN_WARNING "idr_get_new failure\n");
-		goto out;
-	}
-
+	im_port->idr_id = error;
 	mutex_unlock(&bfad_mutex);
 
 	im_port->shost = bfad_scsi_host_alloc(im_port, bfad);
-- 
1.8.1
