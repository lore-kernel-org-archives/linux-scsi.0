From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: [PATCH 09/22] zfcp: fix missing trace records for early returns in TMF eh handlers
Date: Fri, 28 Jul 2017 12:30:55 +0200
Message-ID: <ebf9c5300284d4a530896a90e3ee1eec7ef1ed63.1501085249.git.bblock@linux.vnet.ibm.com>
References: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
In-Reply-To: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
References: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
Sender: stable-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Steffen Maier <maier@linux.vnet.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, stable@vger.kernel.org, Benjamin Block <bblock@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

From: Steffen Maier <maier@linux.vnet.ibm.com>

For problem determination we need to see that we were in scsi_eh
as well as whether and why we were successful or not.

The following commits introduced new early returns without adding
a trace record:

v2.6.35 commit a1dbfddd02d2
("[SCSI] zfcp: Pass return code from fc_block_scsi_eh to scsi eh")
on fc_block_scsi_eh() returning != 0 which is FAST_IO_FAIL,

v2.6.30 commit 63caf367e1c9
("[SCSI] zfcp: Improve reliability of SCSI eh handlers in zfcp")
on not having gotten an FSF request after the maximum number of retry
attempts and thus could not issue a TMF and has to return FAILED.

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Fixes: a1dbfddd02d2 ("[SCSI] zfcp: Pass return code from fc_block_scsi_eh to scsi eh")
Fixes: 63caf367e1c9 ("[SCSI] zfcp: Improve reliability of SCSI eh handlers in zfcp")
Cc: <stable@vger.kernel.org> #2.6.38+
Reviewed-by: Benjamin Block <bblock@linux.vnet.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_scsi.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 4c9ac55d053d..ec3ddd1d31d5 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -273,8 +273,10 @@ static int zfcp_task_mgmt_function(struct scsi_cmnd *scpnt, u8 tm_flags)
 
 		zfcp_erp_wait(adapter);
 		ret = fc_block_scsi_eh(scpnt);
-		if (ret)
+		if (ret) {
+			zfcp_dbf_scsi_devreset("fiof", scpnt, tm_flags, NULL);
 			return ret;
+		}
 
 		if (!(atomic_read(&adapter->status) &
 		      ZFCP_STATUS_COMMON_RUNNING)) {
@@ -282,8 +284,10 @@ static int zfcp_task_mgmt_function(struct scsi_cmnd *scpnt, u8 tm_flags)
 			return SUCCESS;
 		}
 	}
-	if (!fsf_req)
+	if (!fsf_req) {
+		zfcp_dbf_scsi_devreset("reqf", scpnt, tm_flags, NULL);
 		return FAILED;
+	}
 
 	wait_for_completion(&fsf_req->completion);
 
-- 
2.11.2
