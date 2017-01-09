From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH] ibmvscsis: Fix srp_transfer_data fail return code
Date: Mon,  9 Jan 2017 10:21:20 -0600
Message-ID: <1483978880-93705-1-git-send-email-bryantly@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: nab@linux-iscsi.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, Bart.VanAssche@sandisk.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, "Bryant G. Ly" <bgly@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

From: "Bryant G. Ly" <bgly@us.ibm.com>

If srp_transfer_data fails within ibmvscsis_write_pending, then
the most likely scenario is that the client timed out the op and
removed the TCE mapping. Thus it will loop forever retrying the
op that is pretty much guaranteed to fail forever. A better return
code would be EIO instead of EAGAIN.

Cc: stable@vger.kernel.org
Reported-by: Steven Royer <seroyer@linux.vnet.ibm.com>
Tested-by: Steven Royer <seroyer@linux.vnet.ibm.com>
Signed-off-by: Bryant G. Ly <bgly@us.ibm.com>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 3d3768a..8fb5c54 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3585,7 +3585,7 @@ static int ibmvscsis_write_pending(struct se_cmd *se_cmd)
 			       1, 1);
 	if (rc) {
 		pr_err("srp_transfer_data() failed: %d\n", rc);
-		return -EAGAIN;
+		return -EIO;
 	}
 	/*
 	 * We now tell TCM to add this WRITE CDB directly into the TCM storage
-- 
2.5.4 (Apple Git-61)
