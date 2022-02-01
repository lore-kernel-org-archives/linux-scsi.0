Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9974C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 21:10:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241079AbiBAVKN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Feb 2022 16:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiBAVKM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2022 16:10:12 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A8F5C061714;
        Tue,  1 Feb 2022 13:10:12 -0800 (PST)
Received: from localhost ([127.0.0.1] helo=flow.W.breakpoint.cc)
        by Chamillionaire.breakpoint.cc with esmtp (Exim 4.92)
        (envelope-from <sebastian@breakpoint.cc>)
        id 1nF0Pg-0006wn-Uh; Tue, 01 Feb 2022 22:10:09 +0100
From:   Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To:     linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH 1/2] scsi: Add scsi_done_direct() for immediate completion.
Date:   Tue,  1 Feb 2022 22:09:53 +0100
Message-Id: <20220201210954.570896-2-sebastian@breakpoint.cc>
In-Reply-To: <20220201210954.570896-1-sebastian@breakpoint.cc>
References: <20220201210954.570896-1-sebastian@breakpoint.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Breakpoint-Spam-Score: -1.0
X-Breakpoint-Spam-Level: -
X-Breakpoint-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
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
 drivers/scsi/scsi_lib.c  | 27 +++++++++++++++++++++++----
 include/scsi/scsi_cmnd.h |  1 +
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0a70aa763a961..778ef6d09616f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1625,26 +1625,45 @@ static blk_status_t scsi_prepare_cmd(struct request=
 *req)
 	return scsi_cmd_to_driver(cmd)->init_command(cmd);
 }
=20
-void scsi_done(struct scsi_cmnd *cmd)
+static bool scsi_done_need_blk_compl(struct scsi_cmnd *cmd)
 {
 	switch (cmd->submitter) {
 	case SUBMITTED_BY_BLOCK_LAYER:
 		break;
 	case SUBMITTED_BY_SCSI_ERROR_HANDLER:
-		return scsi_eh_done(cmd);
+		scsi_eh_done(cmd);
+		return false;
 	case SUBMITTED_BY_SCSI_RESET_IOCTL:
-		return;
+		return false;
 	}
=20
 	if (unlikely(blk_should_fake_timeout(scsi_cmd_to_rq(cmd)->q)))
-		return;
+		return false;
 	if (unlikely(test_and_set_bit(SCMD_STATE_COMPLETE, &cmd->state)))
+		return false;
+	return true;
+}
+
+void scsi_done(struct scsi_cmnd *cmd)
+{
+	if (!scsi_done_need_blk_compl(cmd))
 		return;
+
 	trace_scsi_dispatch_cmd_done(cmd);
 	blk_mq_complete_request(scsi_cmd_to_rq(cmd));
 }
 EXPORT_SYMBOL(scsi_done);
=20
+void scsi_done_direct(struct scsi_cmnd *cmd)
+{
+	if (!scsi_done_need_blk_compl(cmd))
+		return;
+
+	trace_scsi_dispatch_cmd_done(cmd);
+	blk_mq_complete_request_direct(scsi_cmd_to_rq(cmd), scsi_complete);
+}
+EXPORT_SYMBOL(scsi_done_direct);
+
 static void scsi_mq_put_budget(struct request_queue *q, int budget_token)
 {
 	struct scsi_device *sdev =3D q->queuedata;
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 6794d7322cbde..ff1c4b51f7aef 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -168,6 +168,7 @@ static inline struct scsi_driver *scsi_cmd_to_driver(st=
ruct scsi_cmnd *cmd)
 }
=20
 void scsi_done(struct scsi_cmnd *cmd);
+void scsi_done_direct(struct scsi_cmnd *cmd);
=20
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
=20
--=20
2.34.1

