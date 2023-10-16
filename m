Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 416B1CDB465
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Oct 2023 12:16:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233644AbjJPMP7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 08:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232995AbjJPMPy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 08:15:54 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD04E8E
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2023 05:15:50 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 6F81921C59;
        Mon, 16 Oct 2023 12:15:49 +0000 (UTC)
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 21A2C2D158;
        Mon, 16 Oct 2023 12:15:49 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 2D37051EBDFA; Mon, 16 Oct 2023 14:15:49 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/9] scsi: set host byte after EH completed
Date:   Mon, 16 Oct 2023 14:15:38 +0200
Message-Id: <20231016121542.111501-6-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231016121542.111501-1-hare@suse.de>
References: <20231016121542.111501-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++++++++++
Authentication-Results: smtp-out1.suse.de;
        dkim=none;
        dmarc=none;
        spf=softfail (smtp-out1.suse.de: 149.44.160.134 is neither permitted nor denied by domain of hare@suse.de) smtp.mailfrom=hare@suse.de
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [14.49 / 50.00];
         ARC_NA(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         NEURAL_SPAM_SHORT(2.00)[1.000];
         MIME_GOOD(-0.10)[text/plain];
         DMARC_NA(0.20)[suse.de];
         BROKEN_CONTENT_TYPE(1.50)[];
         R_SPF_SOFTFAIL(0.60)[~all:c];
         RCPT_COUNT_FIVE(0.00)[5];
         TO_MATCH_ENVRCPT_SOME(0.00)[];
         VIOLATED_DIRECT_SPF(3.50)[];
         MX_GOOD(-0.01)[];
         NEURAL_SPAM_LONG(3.00)[1.000];
         MID_CONTAINS_FROM(1.00)[];
         RWL_MAILSPIKE_GOOD(0.00)[149.44.160.134:from];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         R_DKIM_NA(0.20)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2]
X-Rspamd-Queue-Id: 6F81921C59
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When SCSI EH completes we should be setting the host byte to
DID_ABORT, DID_RESET, or DID_TRANSPORT_DISRUPTED to inform
the caller that some EH processing has happened.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 826bc7f4d59f..cdbad217d013 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1262,9 +1262,10 @@ scsi_eh_action(struct scsi_cmnd *scmd, enum scsi_disposition rtn)
 }
 
 /**
- * scsi_eh_finish_cmd - Handle a cmd that eh is finished with.
+ * __scsi_eh_finish_cmd - Handle a cmd that eh is finished with.
  * @scmd:	Original SCSI cmd that eh has finished.
  * @done_q:	Queue for processed commands.
+ * @host_byte:	Host byte of the command status to be set
  *
  * Notes:
  *    We don't want to use the normal command completion while we are are
@@ -1273,10 +1274,18 @@ scsi_eh_action(struct scsi_cmnd *scmd, enum scsi_disposition rtn)
  *    keep a list of pending commands for final completion, and once we
  *    are ready to leave error handling we handle completion for real.
  */
-void scsi_eh_finish_cmd(struct scsi_cmnd *scmd, struct list_head *done_q)
+void __scsi_eh_finish_cmd(struct scsi_cmnd *scmd, struct list_head *done_q,
+			int host_byte)
 {
+	if (host_byte)
+		set_host_byte(scmd, host_byte);
 	list_move_tail(&scmd->eh_entry, done_q);
 }
+
+void scsi_eh_finish_cmd(struct scsi_cmnd *scmd, struct list_head *done_q)
+{
+	__scsi_eh_finish_cmd(scmd, done_q, DID_OK);
+}
 EXPORT_SYMBOL(scsi_eh_finish_cmd);
 
 /**
@@ -1451,7 +1460,8 @@ static int scsi_eh_test_devices(struct list_head *cmd_list,
 				if (finish_cmds &&
 				    (try_stu ||
 				     scsi_eh_action(scmd, SUCCESS) == SUCCESS))
-					scsi_eh_finish_cmd(scmd, done_q);
+					__scsi_eh_finish_cmd(scmd, done_q,
+							     DID_RESET);
 				else
 					list_move_tail(&scmd->eh_entry, work_q);
 			}
@@ -1600,8 +1610,9 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 							 work_q, eh_entry) {
 					if (scmd->device == sdev &&
 					    scsi_eh_action(scmd, rtn) != FAILED)
-						scsi_eh_finish_cmd(scmd,
-								   done_q);
+						__scsi_eh_finish_cmd(scmd,
+								     done_q,
+								     DID_RESET);
 				}
 			}
 		} else {
@@ -1671,7 +1682,8 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 			if (rtn == SUCCESS)
 				list_move_tail(&scmd->eh_entry, &check_list);
 			else if (rtn == FAST_IO_FAIL)
-				scsi_eh_finish_cmd(scmd, done_q);
+				__scsi_eh_finish_cmd(scmd, done_q,
+						     DID_TRANSPORT_DISRUPTED);
 			else
 				/* push back on work queue for further processing */
 				list_move(&scmd->eh_entry, work_q);
@@ -1736,8 +1748,9 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 				if (channel == scmd_channel(scmd)) {
 					if (rtn == FAST_IO_FAIL)
-						scsi_eh_finish_cmd(scmd,
-								   done_q);
+						__scsi_eh_finish_cmd(scmd,
+								     done_q,
+								     DID_TRANSPORT_DISRUPTED);
 					else
 						list_move_tail(&scmd->eh_entry,
 							       &check_list);
@@ -1780,9 +1793,9 @@ static int scsi_eh_host_reset(struct Scsi_Host *shost,
 		if (rtn == SUCCESS) {
 			list_splice_init(work_q, &check_list);
 		} else if (rtn == FAST_IO_FAIL) {
-			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
-					scsi_eh_finish_cmd(scmd, done_q);
-			}
+			list_for_each_entry_safe(scmd, next, work_q, eh_entry)
+				__scsi_eh_finish_cmd(scmd, done_q,
+						     DID_TRANSPORT_DISRUPTED);
 		} else {
 			SCSI_LOG_ERROR_RECOVERY(3,
 				shost_printk(KERN_INFO, shost,
-- 
2.35.3

