From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 4/7] scsi: Export some scsi_eh_* functions
Date: Fri, 26 Jan 2007 14:08:49 -0800
Message-ID: <20070126220849.20198.16076.stgit@elm3a70.beaverton.ibm.com>
References: <20070126220834.20198.21100.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:47754 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965380AbXAZWG6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Jan 2007 17:06:58 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0QM6u07032053
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2007 17:06:56 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0QM6uNO248000
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2007 17:06:56 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0QM6urE012455
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2007 17:06:56 -0500
In-Reply-To: <20070126220834.20198.21100.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


Export a couple of functions from scsi_error that are needed to handle
failed SCSI commands from the SAS EH.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/scsi_error.c |   12 +++++++-----
 drivers/scsi/scsi_priv.h  |    5 +++++
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 2ecb6ff..4935e67 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -672,8 +672,8 @@ EXPORT_SYMBOL(scsi_eh_finish_cmd);
  *    XXX: Long term this code should go away, but that needs an audit of
  *         all LLDDs first.
  **/
-static int scsi_eh_get_sense(struct list_head *work_q,
-			     struct list_head *done_q)
+int scsi_eh_get_sense(struct list_head *work_q,
+		      struct list_head *done_q)
 {
 	struct scsi_cmnd *scmd, *next;
 	int rtn;
@@ -715,6 +715,7 @@ static int scsi_eh_get_sense(struct list
 
 	return list_empty(work_q);
 }
+EXPORT_SYMBOL(scsi_eh_get_sense);
 
 /**
  * scsi_try_to_abort_cmd - Ask host to abort a running command.
@@ -1411,9 +1412,9 @@ static void scsi_restart_operations(stru
  * @eh_done_q:	list_head for processed commands.
  *
  **/
-static void scsi_eh_ready_devs(struct Scsi_Host *shost,
-			       struct list_head *work_q,
-			       struct list_head *done_q)
+void scsi_eh_ready_devs(struct Scsi_Host *shost,
+			struct list_head *work_q,
+			struct list_head *done_q)
 {
 	if (!scsi_eh_stu(shost, work_q, done_q))
 		if (!scsi_eh_bus_device_reset(shost, work_q, done_q))
@@ -1421,6 +1422,7 @@ static void scsi_eh_ready_devs(struct Sc
 				if (!scsi_eh_host_reset(work_q, done_q))
 					scsi_eh_offline_sdevs(work_q, done_q);
 }
+EXPORT_SYMBOL(scsi_eh_ready_devs);
 
 /**
  * scsi_eh_flush_done_q - finish processed commands or retry them.
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index d4faa19..ee8efe8 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -57,6 +57,11 @@ extern int scsi_error_handler(void *host
 extern int scsi_decide_disposition(struct scsi_cmnd *cmd);
 extern void scsi_eh_wakeup(struct Scsi_Host *shost);
 extern int scsi_eh_scmd_add(struct scsi_cmnd *, int);
+void scsi_eh_ready_devs(struct Scsi_Host *shost,
+			struct list_head *work_q,
+			struct list_head *done_q);
+int scsi_eh_get_sense(struct list_head *work_q,
+		      struct list_head *done_q);
 
 /* scsi_lib.c */
 extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
