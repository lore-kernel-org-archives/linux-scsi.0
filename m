From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 05/11] scsi: ufs: increase the scsi query response timeout
Date: Wed, 23 Nov 2016 16:31:52 -0800
Message-ID: <1479947512-7096-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: Subhash Jadavani <subhashj@codeaurora.org>, "open list:UNIVERSAL FLASH STORAGE HOST
        CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

It is found thats UFS device may take longer than 30ms to respond to
query requests and in this case we might run into following scenario:

1. UFS host SW sends a query request to UFS device to read an attribute
   value. SW uses tag #31 for this purpose.
2. UFS host SW waits for 30ms to get the query response (and doorbell
   to be cleared by UFS host HW).
3. UFS device doesn't respond back within 30ms hence UFS host SW times
   out waiting for the query response.
4. UFS host SW clears the tag#31 from UTRLCLR register.
5. UFS host SW waits until UFS host HW to clear tag#31 from the doorbell
   register.
6. UFS host SW retries the same query request on same tag#31 (sends a query
   request to device to read an attribute value).
7. UFS host HW gets the query response from the device but this was
   intended as a query response for the 1st query request sent (step-1).
8. Now UFS device sends another query response to host (for query request
   sent @step-6).

Now there are 2 issues that could happen with above scenario:
1. UFS device should have actually responded back with only one query
   response but it is found that device may respond back with 2 query
   responses.
2. If UFS device responds back with 2 resposes on same tag, host HW/SW
   behaviour isn't predictable.

To avoid running into above scenario, we would basically allow device
to take longer (upto 1.5 seconds) for query response.

Reviewed-by: Gilad Broner <gbroner@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d6e87dc..393f6d5 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -59,15 +59,9 @@
 #define NOP_OUT_TIMEOUT    30 /* msecs */
 
 /* Query request retries */
-#define QUERY_REQ_RETRIES 10
+#define QUERY_REQ_RETRIES 3
 /* Query request timeout */
-#define QUERY_REQ_TIMEOUT 30 /* msec */
-/*
- * Query request timeout for fDeviceInit flag
- * fDeviceInit query response time for some devices is too large that default
- * QUERY_REQ_TIMEOUT may not be enough for such devices.
- */
-#define QUERY_FDEVICEINIT_REQ_TIMEOUT 600 /* msec */
+#define QUERY_REQ_TIMEOUT 1500 /* 1.5 seconds */
 
 /* Task management command timeout */
 #define TM_CMD_TIMEOUT	100 /* msecs */
@@ -1842,9 +1836,6 @@ int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 		goto out_unlock;
 	}
 
-	if (idn == QUERY_FLAG_IDN_FDEVICEINIT)
-		timeout = QUERY_FDEVICEINIT_REQ_TIMEOUT;
-
 	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY, timeout);
 
 	if (err) {
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
