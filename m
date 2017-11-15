From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: aacraid: remove unused variable managed_request_id
Date: Wed, 15 Nov 2017 16:53:41 +0000
Message-ID: <20171115165341.20042-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:57747 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932101AbdKOQxr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Nov 2017 11:53:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Variable managed_request_id is being assigned but it is never read,
hence it is redundant and can be removed. Cleans up clang warning:

drivers/scsi/aacraid/linit.c:706:5: warning: Value stored to
'managed_request_id' is never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/aacraid/linit.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index c9252b138c1f..3677beff9c17 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -690,7 +690,6 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
 		struct aac_hba_tm_req *tmf;
 		int status;
 		u64 address;
-		__le32 managed_request_id;
 
 		pr_err("%s: Host adapter abort request (%d,%d,%d,%d)\n",
 		 AAC_DRIVERNAME,
@@ -703,8 +702,6 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
 				(fib->flags & FIB_CONTEXT_FLAG_NATIVE_HBA) &&
 				(fib->callback_data == cmd)) {
 				found = 1;
-				managed_request_id = ((struct aac_hba_cmd_req *)
-					fib->hw_fib_va)->request_id;
 				break;
 			}
 		}
-- 
2.14.1
