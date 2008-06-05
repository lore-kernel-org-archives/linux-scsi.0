From: michaelc@cs.wisc.edu
Subject: [PATCH 7/7] scsi: Support fail fast bits
Date: Wed,  4 Jun 2008 20:41:46 -0500
Message-ID: <1212630106-13413-8-git-send-email-michaelc@cs.wisc.edu>
References: <1212630106-13413-1-git-send-email-michaelc@cs.wisc.edu>
	<1212630106-13413-2-git-send-email-michaelc@cs.wisc.edu>
	<1212630106-13413-3-git-send-email-michaelc@cs.wisc.edu>
	<1212630106-13413-4-git-send-email-michaelc@cs.wisc.edu>
	<1212630106-13413-5-git-send-email-michaelc@cs.wisc.edu>
	<1212630106-13413-6-git-send-email-michaelc@cs.wisc.edu>
	<1212630106-13413-7-git-send-email-michaelc@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1212630106-13413-7-git-send-email-michaelc@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

This converts scsi decide disposition to handle to the different
types of failfast that can be requested.

I was not sure if some of these were device or driver or transport
errors. For example I made DID_PARITY a device error, but I thought
maybe this could be a device or transport error. Also DID_ERROR seems
to be used for lots of different errors, so I was not sure how
to classify it.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_error.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d257210..555085a 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1288,6 +1288,7 @@ static void scsi_eh_offline_sdevs(struct list_head *work_q,
 int scsi_decide_disposition(struct scsi_cmnd *scmd)
 {
 	int rtn;
+	int retry_flag = 0;
 
 	/*
 	 * if the device is offline, then we clearly just pass the result back
@@ -1337,6 +1338,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 * and not get stuck in a loop.
 		 */
 	case DID_SOFT_ERROR:
+		retry_flag = REQ_FAILFAST_DRIVER;
 		goto maybe_retry;
 	case DID_IMM_RETRY:
 		return NEEDS_RETRY;
@@ -1368,10 +1370,13 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 			 * lower down
 			 */
 			break;
-		/* fallthrough */
-
+		retry_flag = REQ_FAILFAST_DRIVER;
+		goto maybe_retry;
 	case DID_BUS_BUSY:
+		retry_flag = REQ_FAILFAST_TRANSPORT;
+		goto maybe_retry;
 	case DID_PARITY:
+		retry_flag = REQ_FAILFAST_DEV;
 		goto maybe_retry;
 	case DID_TIME_OUT:
 		/*
@@ -1420,8 +1425,10 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		return SUCCESS;
 	case CHECK_CONDITION:
 		rtn = scsi_check_sense(scmd);
-		if (rtn == NEEDS_RETRY)
+		if (rtn == NEEDS_RETRY) {
+			retry_flag = REQ_FAILFAST_DEV;
 			goto maybe_retry;
+		}
 		/* if rtn == FAILED, we have no sense information;
 		 * returning FAILED will wake the error handler thread
 		 * to collect the sense and redo the decide
@@ -1451,8 +1458,8 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	 * the request was not marked fast fail.  Note that above,
 	 * even if the request is marked fast fail, we still requeue
 	 * for queue congestion conditions (QUEUE_FULL or BUSY) */
-	if ((++scmd->retries) <= scmd->allowed
-	    && !blk_noretry_request(scmd->request)) {
+	if ((++scmd->retries) <= scmd->allowed &&
+	    !(scmd->request->cmd_flags & retry_flag)) {
 		return NEEDS_RETRY;
 	} else {
 		/*
-- 
1.5.4.1
