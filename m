Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D912AC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 16:05:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3BBD20663
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 16:05:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="VjOkhfMl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725834AbgGOQFS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 12:05:18 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.115]:56057 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726820AbgGOQEd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Jul 2020 12:04:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1594829056; i=@ts.fujitsu.com;
        bh=njKgnlVsP2C9AT7Io1jysuyEan8v3y+kYvMV91SWmKk=;
        h=From:To:Cc:Subject:Date:Message-Id;
        b=VjOkhfMloLpaVrYDgKJNdUsyCtlOcwQ1Y3LZc+6MDtFx9wEjlGHtvB0mNbV8f1COb
         iMct6rT3pJ19ctxqcF7c2AHJupl/fXrQf6I1E4sWXAnnabag2jJcN6CNZbbHpGmWY/
         EiPlyEi45zEnbP76qcBP1ORgW4fIafl7yfjO1+UkbMdXmTu6kikxOABxHqyVDs8wqu
         1BgZYLVAPzmE7Rsn3tL7E8kHw7iUm43PBBbauO5CP6L0zZOZ8ZObYUa1v6HHhwccRL
         xUgR8MdIwf56bHj/duyOh0soXKx8jrq3F2ppkTIwRdgfGnEtNwGnadllzuoUtQ1jjr
         1bvQXFihQe07A==
Received: from [100.113.4.177] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-4.bemta.az-b.eu-central-1.aws.symcld.net id 35/4C-24114-FF82F0F5; Wed, 15 Jul 2020 16:04:15 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRWlGSWpSXmKPExsViZ8MRovtfgz/
  e4OweRYvu6zvYLJYf/8dk8XfSDVaL1qVvmRxYPD4+vcXi8XmTXABTFGtmXlJ+RQJrxoVvngVn
  VSsufnnE0sC4QqGLkYtDSGAyo8TShp3MEM50Ron9jb+Yuhg5OdgEDCRWTLrPApIQEVjDKLHyz
  jxmkASzgJ7EtH/r2EFsYQFHiQnT5oA1sAioSrzf/I8FxOYVsJOYfP40I4gtISAv0XFgMssERs
  4FjAyrGC2TijLTM0pyEzNzdA0NDHQNDY11zXQNLcz0Eqt0k/RSS3WTU/NKihKBsnqJ5cV6xZW
  5yTkpenmpJZsYgZ5PKWTbtYPx8+sPeocYJTmYlER5I5j544X4kvJTKjMSizPii0pzUosPMcpw
  cChJ8DKoA+UEi1LTUyvSMnOAQQiTluDgURLh1QZJ8xYXJOYWZ6ZDpE4xKkqJ815QA0oIgCQyS
  vPg2mCBf4lRVkqYl5GBgUGIpyC1KDezBFX+FaM4B6OSMG8xyHiezLwSuOmvgBYzAS3e+JkXZH
  FJIkJKqoGJ+WjfcVFllimGHQ48N2LXbVjK6J3q1HtGzWRRv+X79vnmFjZPfX2nNoYZneAUyJ7
  8Uva3l49GiajRjj8PLunnbhVxMIlfcEyNtUvOTGR1U8FxxYPbHrw6sn/Hng/L36sd09wTvy/j
  dDVra46gUcuJUxeabvu2bLPYwZe03LrQRMykvUp9uQzXh+j9M8IEf7j0rCqptE/tqrA8OjfU9
  dvDWQfFmmIen5C6XpZz/37EHTfNNWpFt7zSHt0p2eY31+5A2iqVgsdzop85lyxn7xdYrPSqXW
  Njxu09+6Y13ds5qbTMriaFT28Vh1jZUYs1CevWVIbUdpzyu6d6au1iszcFD8v+cMpOPtyy4Gr
  yTU0lluKMREMt5qLiRAAZAUJ99wIAAA==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-20.tower-238.messagelabs.com!1594829054!654744!1
X-Originating-IP: [62.60.8.84]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 19948 invoked from network); 15 Jul 2020 16:04:15 -0000
Received: from unknown (HELO mailhost3.uk.fujitsu.com) (62.60.8.84)
  by server-20.tower-238.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 15 Jul 2020 16:04:15 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost3.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06FG4Exk029131;
        Wed, 15 Jul 2020 17:04:14 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 6452220468;
        Wed, 15 Jul 2020 18:04:11 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH] scsi: target: loop: Fix handling of aborted TMRs
Date:   Wed, 15 Jul 2020 18:04:03 +0200
Message-Id: <20200715160403.12578-1-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If an ABORT_TASK TMR is aborted by a LUN_RESET, core calls
tcm_loop's aborted_task fabric callback for the ABORT_TASK.

The aborted_task callback is not prepared to handle aborted TMRs,
but is an empty function which is ok for aborted SCSI cmds only.
So it does not wake up tcm_loop_issue_tmr() sleeping in
wait_for_completion(). Therefore scmd_eh_abort_handler
hangs forever and we get the following messages:

INFO: task kworker/u48:1:31216 blocked for more than 3932 seconds.
      Tainted: G           OE     5.8.0-rc1+ #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/u48:1   D    0 31216      2 0x00004000
Workqueue: scsi_tmf_14 scmd_eh_abort_handler [scsi_mod]
Call Trace:
 __schedule+0x2aa/0x6d0
 schedule+0x42/0xb0
 schedule_timeout+0x1ba/0x280
 ? __queue_work+0x13b/0x3d0
 ? kmem_cache_alloc_trace+0x1e6/0x200
 wait_for_completion+0x7f/0xd0
 tcm_loop_issue_tmr.isra.10+0xc1/0x110 [tcm_loop]
 tcm_loop_abort_task+0x3d/0x50 [tcm_loop]
 scmd_eh_abort_handler+0x91/0x230 [scsi_mod]
 process_one_work+0x166/0x370
 worker_thread+0x49/0x3e0
 ? rescuer_thread+0x320/0x320
 kthread+0xfc/0x130
 ? kthread_bind+0x10/0x10
 ret_from_fork+0x22/0x30

Fix:
After calling the aborted_task callback the core immediately
releases the se_cmd that represents the ABORT_TASK. The woken
up thread (tcm_loop_issue_tmr) therefore must not access se_cmd
and tl_cmd in case of aborted TMRs.

So I changed aborted_task and queue_tm_rsp to transfer result
code from se_cmd to tcm_loop_issue_tmr's stack and added the
missing wake_up() to aborted_task.
Now tcm_loop_issue_tmr after waking up no longer accesses se_cmd
and tl_cmd. Therefore tcm_loop_issue_tmr no longer needs to call
target_put_sess_cmd and flag TARGET_SCF_ACK_KREF is no longer
needed in se_cmd.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/loopback/tcm_loop.c | 39 ++++++++++++++++++++++----------------
 drivers/target/loopback/tcm_loop.h |  4 +++-
 2 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 16d5a4e117a2..0968bc8b6640 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -199,6 +199,7 @@ static int tcm_loop_issue_tmr(struct tcm_loop_tpg *tl_tpg,
 	struct tcm_loop_nexus *tl_nexus;
 	struct tcm_loop_cmd *tl_cmd;
 	int ret = TMR_FUNCTION_FAILED, rc;
+	DECLARE_COMPLETION_ONSTACK(compl);
 
 	/*
 	 * Locate the tl_nexus and se_sess pointers
@@ -213,26 +214,23 @@ static int tcm_loop_issue_tmr(struct tcm_loop_tpg *tl_tpg,
 	if (!tl_cmd)
 		return ret;
 
-	init_completion(&tl_cmd->tmr_done);
+	tl_cmd->is_tmr = true;
+	tl_cmd->tmr_done = &compl;
+	tl_cmd->tmr_result = &ret;
 
 	se_cmd = &tl_cmd->tl_se_cmd;
 	se_sess = tl_tpg->tl_nexus->se_sess;
 
 	rc = target_submit_tmr(se_cmd, se_sess, tl_cmd->tl_sense_buf, lun,
-			       NULL, tmr, GFP_KERNEL, task,
-			       TARGET_SCF_ACK_KREF);
-	if (rc < 0)
-		goto release;
-	wait_for_completion(&tl_cmd->tmr_done);
-	ret = se_cmd->se_tmr_req->response;
-	target_put_sess_cmd(se_cmd);
+			       NULL, tmr, GFP_KERNEL, task, 0);
+	if (rc < 0) {
+		kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
+		return ret;
+	}
 
-out:
-	return ret;
+	wait_for_completion(tl_cmd->tmr_done);
 
-release:
-	kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
-	goto out;
+	return ret;
 }
 
 static int tcm_loop_abort_task(struct scsi_cmnd *sc)
@@ -590,13 +588,22 @@ static void tcm_loop_queue_tm_rsp(struct se_cmd *se_cmd)
 	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
 				struct tcm_loop_cmd, tl_se_cmd);
 
-	/* Wake up tcm_loop_issue_tmr(). */
-	complete(&tl_cmd->tmr_done);
+	/* Set tmr result and wake up tcm_loop_issue_tmr(). */
+	*tl_cmd->tmr_result = se_cmd->se_tmr_req->response;
+	complete(tl_cmd->tmr_done);
 }
 
 static void tcm_loop_aborted_task(struct se_cmd *se_cmd)
 {
-	return;
+	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
+				struct tcm_loop_cmd, tl_se_cmd);
+
+	if (!tl_cmd->is_tmr)
+		return;
+
+	/* Set tmr result and wake up tcm_loop_issue_tmr(). */
+	*tl_cmd->tmr_result = TMR_FUNCTION_REJECTED;
+	complete(tl_cmd->tmr_done);
 }
 
 static char *tcm_loop_dump_proto_id(struct tcm_loop_hba *tl_hba)
diff --git a/drivers/target/loopback/tcm_loop.h b/drivers/target/loopback/tcm_loop.h
index d3110909a213..e7615b9f5ed1 100644
--- a/drivers/target/loopback/tcm_loop.h
+++ b/drivers/target/loopback/tcm_loop.h
@@ -17,7 +17,9 @@ struct tcm_loop_cmd {
 	/* The TCM I/O descriptor that is accessed via container_of() */
 	struct se_cmd tl_se_cmd;
 	struct work_struct work;
-	struct completion tmr_done;
+	struct completion *tmr_done;
+	bool is_tmr;
+	int *tmr_result;
 	/* Sense buffer that will be mapped into outgoing status */
 	unsigned char tl_sense_buf[TRANSPORT_SENSE_BUFFER];
 };
-- 
2.12.3

