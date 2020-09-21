Return-Path: <SRS0=3eE7=C6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88DA8C4346E
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Sep 2020 18:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4520F21D91
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Sep 2020 18:48:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tSXtYzpV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbgIUSso (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 14:48:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52032 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgIUSsn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2020 14:48:43 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08LIj7cn036706;
        Mon, 21 Sep 2020 18:48:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=dRWoBIwR+gO68igjnDsYw5R5fDp8FVYwOq2frGt4QxI=;
 b=tSXtYzpViWKLdl/eV8Ds74F+K7LPksYnzPvGNdMI2PGskwH5M3KU/jwX/ILPqCa1YiZe
 KTL6IfnqVKpkUEjN/SGjhRrtQxWV4NqJ/AJUjfLWtLbRPZa0qENcGsL14CohWJAUOtJU
 7KTRZVaFDUo1OZoPcazeLs9Qrlt1FLtQQrFv7oq7hW7OM2BncEKVTi8WLIQCAstCCRKd
 u9eB1rL8/BnnF2W4HfYhYHb5x9VyJyymaoFevPQmObIH7x7jNwjJmv+/REyRlnnKL7b6
 fNSz/IvgcPh7TesY4+TupLkk2vTfzW3qjZa1J2T5ndYSFqVnzcIQMgE19fU06DIB/3bW lQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33n9xkr2w5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 21 Sep 2020 18:48:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08LIkJPu173998;
        Mon, 21 Sep 2020 18:48:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33nurrag43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Sep 2020 18:48:39 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08LImbhe030867;
        Mon, 21 Sep 2020 18:48:38 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Sep 2020 11:48:37 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH 1/2] scsi: Add limitless cmd retry support
Date:   Mon, 21 Sep 2020 13:48:28 -0500
Message-Id: <1600714109-6178-2-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600714109-6178-1-git-send-email-michael.christie@oracle.com>
References: <1600714109-6178-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009210135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 priorityscore=1501 adultscore=0 spamscore=0 clxscore=1015
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009210135
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The next patch allows users to configure disk scsi cmd retries from
-1 up to a ULD specific value where -1 means infinite retries.

This patch adds infinite retry support to scsi-ml by just combining
common checks for retries into some helper functions, and then
checking for the -1/SCSI_CMD_RETRIES_NO_LIMIT.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_error.c | 21 +++++++++++++++------
 drivers/scsi/scsi_lib.c   | 29 +++++++++++++++++++----------
 drivers/scsi/scsi_priv.h  |  1 +
 3 files changed, 35 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 927b1e641842..8d237152581f 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -116,6 +116,14 @@ static int scsi_host_eh_past_deadline(struct Scsi_Host *shost)
 	return 1;
 }
 
+static bool scsi_cmd_retry_allowed(struct scsi_cmnd *cmd)
+{
+	if (cmd->allowed == SCSI_CMD_RETRIES_NO_LIMIT)
+		return true;
+
+	return (++cmd->retries <= cmd->allowed);
+}
+
 /**
  * scmd_eh_abort_handler - Handle command aborts
  * @work:	command to be aborted.
@@ -151,7 +159,7 @@ scmd_eh_abort_handler(struct work_struct *work)
 						    "eh timeout, not retrying "
 						    "aborted command\n"));
 			} else if (!scsi_noretry_cmd(scmd) &&
-			    (++scmd->retries <= scmd->allowed)) {
+				   scsi_cmd_retry_allowed(scmd)) {
 				SCSI_LOG_ERROR_RECOVERY(3,
 					scmd_printk(KERN_WARNING, scmd,
 						    "retry aborted command\n"));
@@ -1268,7 +1276,10 @@ int scsi_eh_get_sense(struct list_head *work_q,
 			 * finished with the sense data, so set
 			 * retries to the max allowed to ensure it
 			 * won't get reissued */
-			scmd->retries = scmd->allowed;
+			if (scmd->allowed == SCSI_CMD_RETRIES_NO_LIMIT)
+				scmd->retries = scmd->allowed = 1;
+			else
+				scmd->retries = scmd->allowed;
 		else if (rtn != NEEDS_RETRY)
 			continue;
 
@@ -1944,8 +1955,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	 * the request was not marked fast fail.  Note that above,
 	 * even if the request is marked fast fail, we still requeue
 	 * for queue congestion conditions (QUEUE_FULL or BUSY) */
-	if ((++scmd->retries) <= scmd->allowed
-	    && !scsi_noretry_cmd(scmd)) {
+	if (scsi_cmd_retry_allowed(scmd) && !scsi_noretry_cmd(scmd)) {
 		return NEEDS_RETRY;
 	} else {
 		/*
@@ -2091,8 +2101,7 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
 		list_del_init(&scmd->eh_entry);
 		if (scsi_device_online(scmd->device) &&
-		    !scsi_noretry_cmd(scmd) &&
-		    (++scmd->retries <= scmd->allowed)) {
+		    !scsi_noretry_cmd(scmd) && scsi_cmd_retry_allowed(scmd)) {
 			SCSI_LOG_ERROR_RECOVERY(3,
 				scmd_printk(KERN_INFO, scmd,
 					     "%s: flush retry cmd\n",
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 06056e9ec333..37b953553362 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -653,6 +653,23 @@ static void scsi_io_completion_reprep(struct scsi_cmnd *cmd,
 	scsi_mq_requeue_cmd(cmd);
 }
 
+static bool scsi_cmd_runtime_exceeced(struct scsi_cmnd *cmd)
+{
+	struct request *req = cmd->request;
+	unsigned long wait_for;
+
+	if (cmd->allowed == SCSI_CMD_RETRIES_NO_LIMIT)
+		return false;
+
+	wait_for = (cmd->allowed + 1) * req->timeout;
+	if (time_before(cmd->jiffies_at_alloc + wait_for, jiffies)) {
+		scmd_printk(KERN_ERR, cmd, "timing out command, waited %lus\n",
+			    wait_for/HZ);
+		return true;
+	}
+	return false;
+}
+
 /* Helper for scsi_io_completion() when special action required. */
 static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 {
@@ -661,7 +678,6 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 	int level = 0;
 	enum {ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
 	      ACTION_DELAYED_RETRY} action;
-	unsigned long wait_for = (cmd->allowed + 1) * req->timeout;
 	struct scsi_sense_hdr sshdr;
 	bool sense_valid;
 	bool sense_current = true;      /* false implies "deferred sense" */
@@ -766,8 +782,7 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 	} else
 		action = ACTION_FAIL;
 
-	if (action != ACTION_FAIL &&
-	    time_before(cmd->jiffies_at_alloc + wait_for, jiffies))
+	if (action != ACTION_FAIL && scsi_cmd_runtime_exceeced(cmd))
 		action = ACTION_FAIL;
 
 	switch (action) {
@@ -1440,7 +1455,6 @@ static bool scsi_mq_lld_busy(struct request_queue *q)
 static void scsi_softirq_done(struct request *rq)
 {
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
-	unsigned long wait_for = (cmd->allowed + 1) * rq->timeout;
 	int disposition;
 
 	INIT_LIST_HEAD(&cmd->eh_entry);
@@ -1450,13 +1464,8 @@ static void scsi_softirq_done(struct request *rq)
 		atomic_inc(&cmd->device->ioerr_cnt);
 
 	disposition = scsi_decide_disposition(cmd);
-	if (disposition != SUCCESS &&
-	    time_before(cmd->jiffies_at_alloc + wait_for, jiffies)) {
-		scmd_printk(KERN_ERR, cmd,
-			    "timing out command, waited %lus\n",
-			    wait_for/HZ);
+	if (disposition != SUCCESS && scsi_cmd_runtime_exceeced(cmd))
 		disposition = SUCCESS;
-	}
 
 	scsi_log_completion(cmd, disposition);
 
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 22b6585e28b4..f8c46cc82e9f 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -15,6 +15,7 @@ struct scsi_host_template;
 struct Scsi_Host;
 struct scsi_nl_hdr;
 
+#define SCSI_CMD_RETRIES_NO_LIMIT -1
 
 /*
  * Scsi Error Handler Flags
-- 
2.18.2

