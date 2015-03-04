From: Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH 2/2] bnx2fc: bnx2fc_io.c: match wait_for_completion_timeout return type
Date: Wed,  4 Mar 2015 09:27:17 -0500
Message-ID: <1425479238-11519-1-git-send-email-hofrat@osadl.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
List-Id: linux-scsi@vger.kernel.org

return type of wait_for_completion_timeout is unsigned long not int. An
appropriately named variable of type unsigned long is added and the
assignments fixed up.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

The was only compile tested with x86_64_defconfig + SCSI_LOWLEVEL
CONFIG_SCSI_FC_ATTRS=m, CONFIG_LIBFC=m, CONFIG_LIBFCOE=m,
CONFIG_SCSI_BNX2X_FCOE=m

Patch is against 4.0-rc2 (localversion-next is -next-20150304)

 drivers/scsi/bnx2fc/bnx2fc_io.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 9ecca85..77f8c1e 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -703,6 +703,7 @@ static int bnx2fc_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
 	struct fcp_cmnd *fcp_cmnd;
 	int task_idx, index;
 	int rc = SUCCESS;
+	unsigned long time_left;
 	u16 xid;
 	u32 sid, did;
 	unsigned long start = jiffies;
@@ -810,7 +811,7 @@ retry_tmf:
 	bnx2fc_ring_doorbell(tgt);
 	spin_unlock_bh(&tgt->tgt_lock);
 
-	rc = wait_for_completion_timeout(&io_req->tm_done,
+	time_left = wait_for_completion_timeout(&io_req->tm_done,
 					 BNX2FC_TM_TIMEOUT * HZ);
 	spin_lock_bh(&tgt->tgt_lock);
 
@@ -824,17 +825,17 @@ retry_tmf:
 		io_req->wait_for_comp = 1;
 		bnx2fc_initiate_cleanup(io_req);
 		spin_unlock_bh(&tgt->tgt_lock);
-		rc = wait_for_completion_timeout(&io_req->tm_done,
+		time_left = wait_for_completion_timeout(&io_req->tm_done,
 						 BNX2FC_FW_TIMEOUT);
 		spin_lock_bh(&tgt->tgt_lock);
 		io_req->wait_for_comp = 0;
-		if (!rc)
+		if (!time_left)
 			kref_put(&io_req->refcount, bnx2fc_cmd_release);
 	}
 
 	spin_unlock_bh(&tgt->tgt_lock);
 
-	if (!rc) {
+	if (!time_left) {
 		BNX2FC_TGT_DBG(tgt, "task mgmt command failed...\n");
 		rc = FAILED;
 	} else {
-- 
1.7.10.4
