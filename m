Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C54FEC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Feb 2022 20:29:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244225AbiBCU33 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Feb 2022 15:29:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232458AbiBCU32 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2022 15:29:28 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337FFC061714;
        Thu,  3 Feb 2022 12:29:28 -0800 (PST)
Received: from bigeasy by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <sebastian@breakpoint.cc>)
        id 1nFijN-0003Hn-Ha; Thu, 03 Feb 2022 21:29:25 +0100
Date:   Thu, 3 Feb 2022 21:29:25 +0100
From:   Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v2 1/2] scsi: Add scsi_done_direct() for immediate completion.
Message-ID: <Yfw7JaszshmfYa1d@flow>
References: <20220201210954.570896-1-sebastian@breakpoint.cc>
 <20220201210954.570896-2-sebastian@breakpoint.cc>
 <c8402f76-7397-77c3-232c-c825c52ea826@acm.org>
 <YfwxJPUFCo5/55yI@flow>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YfwxJPUFCo5/55yI@flow>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add scsi_done_direct() which behaves like scsi_done() except that it
invokes blk_mq_complete_request_direct() in order to complete the
request.
Callers from process context can complete the request directly instead
waking ksoftirqd.

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
On 2022-02-03 20:46:44 [+0100], To Bart Van Assche wrote:
> 
> Let me see what I can do.

Something like this perhaps? The compiler not inline
scsi_done_internal() so we maybe provide scsi_done() / _direct() as
static inlines?

 drivers/scsi/scsi_lib.c  | 21 +++++++++++++++++++--
 include/scsi/scsi_cmnd.h |  1 +
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0a70aa763a961..a1c18ba5e8d38 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1625,8 +1625,10 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
 	return scsi_cmd_to_driver(cmd)->init_command(cmd);
 }
 
-void scsi_done(struct scsi_cmnd *cmd)
+static void scsi_done_internal(struct scsi_cmnd *cmd, bool complete_directly)
 {
+	struct request *req = scsi_cmd_to_rq(cmd);
+
 	switch (cmd->submitter) {
 	case SUBMITTED_BY_BLOCK_LAYER:
 		break;
@@ -1641,10 +1643,25 @@ void scsi_done(struct scsi_cmnd *cmd)
 	if (unlikely(test_and_set_bit(SCMD_STATE_COMPLETE, &cmd->state)))
 		return;
 	trace_scsi_dispatch_cmd_done(cmd);
-	blk_mq_complete_request(scsi_cmd_to_rq(cmd));
+
+	if (complete_directly)
+		blk_mq_complete_request_direct(req, scsi_complete);
+	else
+		blk_mq_complete_request(req);
+}
+
+void scsi_done(struct scsi_cmnd *cmd)
+{
+	scsi_done_internal(cmd, false);
 }
 EXPORT_SYMBOL(scsi_done);
 
+void scsi_done_direct(struct scsi_cmnd *cmd)
+{
+	scsi_done_internal(cmd, true);
+}
+EXPORT_SYMBOL(scsi_done_direct);
+
 static void scsi_mq_put_budget(struct request_queue *q, int budget_token)
 {
 	struct scsi_device *sdev = q->queuedata;
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 6794d7322cbde..ff1c4b51f7aef 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -168,6 +168,7 @@ static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
 }
 
 void scsi_done(struct scsi_cmnd *cmd);
+void scsi_done_direct(struct scsi_cmnd *cmd);
 
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
 
-- 
2.34.1

