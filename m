From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 13/13] scsi: remove scsi_noretry_cmd
Date: Mon, 22 Sep 2008 09:33:42 -0700
Message-ID: <1222101222-15079-14-git-send-email-andmike@linux.vnet.ibm.com>
References: <1222101222-15079-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:49854 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbYIVQeM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Sep 2008 12:34:12 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m8MGY9ge020925
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 12:34:10 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m8MGY932191652
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 10:34:09 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m8MMY98p005629
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 16:34:09 -0600
Received: from localhost.localdomain (desktop-andmike.beaverton.ibm.com [9.47.22.92])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m8MMXlYV003971
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 16:34:09 -0600
In-Reply-To: <1222101222-15079-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Remove scsi_noretry_cmd as new method of encoding information
in disposition status is being used.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
---
 drivers/scsi/scsi_error.c |   34 ----------------------------------
 drivers/scsi/scsi_lib.c   |    2 +-
 drivers/scsi/scsi_priv.h  |    1 -
 3 files changed, 1 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index a0f4123..61b3001 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1220,40 +1220,6 @@ static void scsi_eh_offline_sdevs(struct list_head *work_q,
 }
 
 /**
- * scsi_noretry_cmd - determinte if command should be failed fast
- * @scmd:	SCSI cmd to examine.
- */
-int scsi_noretry_cmd(struct scsi_cmnd *scmd)
-{
-	switch (host_byte(scmd->result)) {
-	case DID_OK:
-		break;
-	case DID_BUS_BUSY:
-		return blk_failfast_transport(scmd->request);
-	case DID_PARITY:
-		return blk_failfast_dev(scmd->request);
-	case DID_ERROR:
-		if (msg_byte(scmd->result) == COMMAND_COMPLETE &&
-		    status_byte(scmd->result) == RESERVATION_CONFLICT)
-			return 0;
-		/* fall through */
-	case DID_SOFT_ERROR:
-		return blk_failfast_driver(scmd->request);
-	}
-
-	switch (status_byte(scmd->result)) {
-	case CHECK_CONDITION:
-		/*
-		 * assume caller has checked sense and determinted
-		 * the check condition was retryable.
-		 */
-		return blk_failfast_dev(scmd->request);
-	}
-
-	return 0;
-}
-
-/**
  * scsi_decide_disposition - Disposition a cmd on return from LLD.
  * @scmd:	SCSI cmd to examine.
  *
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8f09407..3553f38 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -757,7 +757,7 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
 			leftover = req->data_len;
 
 		/* kill remainder if no retrys */
-		if (error && scsi_noretry_cmd(cmd))
+		if (error && blk_noretry_request(req))
 			blk_end_request(req, error, leftover);
 		else {
 			if (requeue) {
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 0de6769..f32ec80 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -59,7 +59,6 @@ void scsi_eh_ready_devs(struct Scsi_Host *shost,
 			struct list_head *done_q);
 int scsi_eh_get_sense(struct list_head *work_q,
 		      struct list_head *done_q);
-int scsi_noretry_cmd(struct scsi_cmnd *scmd);
 
 /* scsi_lib.c */
 extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
-- 
1.5.5.1

