Return-Path: <SRS0=WTMl=AV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C439C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jul 2020 10:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 472C420748
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jul 2020 10:49:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="j5AqKxI6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgGJKtL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jul 2020 06:49:11 -0400
Received: from mail3.bemta25.messagelabs.com ([195.245.230.84]:8142 "EHLO
        mail3.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727834AbgGJKss (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Jul 2020 06:48:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1594378124; i=@ts.fujitsu.com;
        bh=ovzdZWVboKUhNlzkplbxqJCfqX9OXFqspWfAsmRf0os=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=j5AqKxI6nvgV1mv7VmcN8yORexeypWf2nOLxUlerb5bIcEkRIYL3WDzggzx5yl/7i
         TmxVcTFjAugrBicMzOZ6kX6FLBS09qhr3BuEpnByow/ESQcD0T7CXBUvg61AVFHO3R
         +KtY3hSgxZ3xMcunh4BTGGyL8hg7UaWkar7PNcwFRUb+G5ZZREjfm959EB7OXMR1t0
         RS4r8IegmTMewzEyeBuy3Yue+dwR4bvGZFKfG2gSbvlCBKwxL6Mqa5GSkKZTujrlV3
         FE+zyGz9o6uojPI4NQm3gDIVhyiUuxn56ED3hgWhlnAYCdM+OOFLzKeNgH7dMFRyPq
         M4lo1cDaGHlUA==
Received: from [100.112.197.196] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-4.bemta.az-b.eu-west-1.aws.symcld.net id 58/DE-16187-B87480F5; Fri, 10 Jul 2020 10:48:43 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRWlGSWpSXmKPExsViZ8MxRbfbnSP
  eYO9NXYvu6zvYLJYf/8dk8XfSDVaL1qVvmRxYPD4+vcXi8XmTXABTFGtmXlJ+RQJrxo95T1gL
  VqpWXJsk2MB4WL6LkYtDSGAyo8SErjcsEM50Ron+ZV+Zuxg5OdgEDCRWTLoPlhARWMMosfLOP
  LAEs4CexLR/69hBbGEBL4lLnzvA4iwCqhKPn88Gi/MK2EncvtXJCGJLCMhLdByYzAJicwrYS+
  zv+gdmCwHV7Op7yDqBkXsBI8MqRoukosz0jJLcxMwcXUMDA11DQyNdQ0sLXUNzY73EKt0kvdR
  S3fLU4hJdQ73E8mK94src5JwUvbzUkk2MwDBJKTi2dgdjz5sPeocYJTmYlER5p31kjxfiS8pP
  qcxILM6ILyrNSS0+xCjDwaEkwSvlxhEvJFiUmp5akZaZAwxZmLQEB4+SCO98F6A0b3FBYm5xZ
  jpE6hSjopQ47z9noIQASCKjNA+uDRYnlxhlpYR5GRkYGIR4ClKLcjNLUOVfMYpzMCoJ80aDbO
  fJzCuBm/4KaDET0OKjHGwgi0sSEVJSDUzSdRZXr/yyOXTkd/T0Eo6A73e8uAUt9L/csqiUl/o
  m5LCnStRLZcpUOWueM28zQnf+Wmq+tjshYr/eann5ohNV1/qZPNrXP4z+Eve4fdrXS7y3lR8y
  XlZ0rI5ffvTgV26f99/XnDy/tfhguEbU1qmpnonRd6qUPs4UzZh8+aZ4f0CDjcDt2ZlLywJ0+
  pomvJJp0AhQe5uR8+PYArPjbRb5E9ZqTAy/aHpumvbRfL9tejPE1A5suXt1cTDbztr/n/0Esx
  jFZhmfrZhc4iV15rBYxv0b78xyF66VMI1OefOQ49k9xRdG/OpSc35JXgrcvn6e9N7Qc325Njx
  xCnE/JFc6tF2fX/3kxIR1p103O69SYinOSDTUYi4qTgQAu7xvcg4DAAA=
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-32.tower-285.messagelabs.com!1594378123!256596!1
X-Originating-IP: [62.60.8.148]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 26177 invoked from network); 10 Jul 2020 10:48:43 -0000
Received: from unknown (HELO mailhost1.uk.fujitsu.com) (62.60.8.148)
  by server-32.tower-285.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 10 Jul 2020 10:48:43 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost1.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06AAmg71006578;
        Fri, 10 Jul 2020 11:48:42 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 81D5C207D0;
        Fri, 10 Jul 2020 12:48:42 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH 6/8] scsi: target: tcmu: Fix and simplify timeout handling
Date:   Fri, 10 Jul 2020 12:48:15 +0200
Message-Id: <20200710104817.19462-7-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
References: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During cmd timeout handling in check_timedout_devices() due to
a race it can happen, that tcmu_set_next_deadline() does not
start a timer as expected:
 1) Either tcmu_check_expired_ring_cmd() checks the
    inflight_queue or tcmu_check_expired_queue_cmd() checks the
    qfull_queue while jiffies has the value X
 2) At the end of the check the queue contains one remaining
    command with deadline X (time_after(X, X) is false and
    thus the command is not handled as being timed out).
 3) After tcmu_check_expired_xxxxx_cmd() a timer interrupt
    happens and jiffies is incremented to X+1.
 4) Now tcmu_set_next_deadline() is called, but it skips
    the command, since time_after(X+1, X) is true. Therefore
    tcmu_set_next_deadline() finds no new deadline and stops
    the timer, which it shouldn't.

Since commands that time out are removed from inflight_queue
or qfull_queue, we don't need the check with time_after() in
tcmu_set_next_deadline(), but can use the deadline from the
first cmd in the queue.

Additionally I replaced the remaining time_after() calls in
tcmu_check_expired_xxxxx_cmd() with time_after_eq(), because
it is not useful to set the timeout to deadline, but then check
for jiffies being greater than deadline.

Next I simplified the end of tcmu_handle_completions() and
changed the check for no more pending commands from
 "mb->cmd_tail == mb->cmd_head"
to
 "idr_is_empty(&udev->commands)"
because the old check doesn't work correctly if paddings or in
the future TMRs are in the ring.

Finally tcmu_set_next_deadline() was shifted in the source as
preparation for later implementation of tmr_notify callback.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_user.c | 59 +++++++++++++++------------------------
 1 file changed, 23 insertions(+), 36 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 7a27e838a7d3..6adf4e7cc00b 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1129,6 +1129,18 @@ tcmu_queue_cmd(struct se_cmd *se_cmd)
 	return scsi_ret;
 }
 
+static void tcmu_set_next_deadline(struct list_head *queue,
+				   struct timer_list *timer)
+{
+	struct tcmu_cmd *cmd;
+
+	if (!list_empty(queue)) {
+		cmd = list_first_entry(queue, struct tcmu_cmd, queue_entry);
+		mod_timer(timer, cmd->deadline);
+	} else
+		del_timer(timer);
+}
+
 static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *entry)
 {
 	struct se_cmd *se_cmd = cmd->se_cmd;
@@ -1196,25 +1208,6 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 	tcmu_free_cmd(cmd);
 }
 
-static void tcmu_set_next_deadline(struct list_head *queue,
-				   struct timer_list *timer)
-{
-	struct tcmu_cmd *tcmu_cmd, *tmp_cmd;
-	unsigned long deadline = 0;
-
-	list_for_each_entry_safe(tcmu_cmd, tmp_cmd, queue, queue_entry) {
-		if (!time_after(jiffies, tcmu_cmd->deadline)) {
-			deadline = tcmu_cmd->deadline;
-			break;
-		}
-	}
-
-	if (deadline)
-		mod_timer(timer, deadline);
-	else
-		del_timer(timer);
-}
-
 static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 {
 	struct tcmu_mailbox *mb;
@@ -1267,22 +1260,16 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 		handled++;
 	}
 
-	if (mb->cmd_tail == mb->cmd_head) {
-		/* no more pending commands */
-		del_timer(&udev->cmd_timer);
-
-		if (list_empty(&udev->qfull_queue)) {
-			/*
-			 * no more pending or waiting commands so try to
-			 * reclaim blocks if needed.
-			 */
-			if (atomic_read(&global_db_count) >
-			    tcmu_global_max_blocks)
-				schedule_delayed_work(&tcmu_unmap_work, 0);
-		}
-	} else if (udev->cmd_time_out) {
-		tcmu_set_next_deadline(&udev->inflight_queue, &udev->cmd_timer);
+	if (atomic_read(&global_db_count) > tcmu_global_max_blocks &&
+	    idr_is_empty(&udev->commands) && list_empty(&udev->qfull_queue)) {
+		/*
+		 * Allocated blocks exceeded global block limit, currently no
+		 * more pending or waiting commands so try to reclaim blocks.
+		 */
+		schedule_delayed_work(&tcmu_unmap_work, 0);
 	}
+	if (udev->cmd_time_out)
+		tcmu_set_next_deadline(&udev->inflight_queue, &udev->cmd_timer);
 
 	return handled;
 }
@@ -1291,7 +1278,7 @@ static void tcmu_check_expired_ring_cmd(struct tcmu_cmd *cmd)
 {
 	struct se_cmd *se_cmd;
 
-	if (!time_after(jiffies, cmd->deadline))
+	if (!time_after_eq(jiffies, cmd->deadline))
 		return;
 
 	set_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags);
@@ -1310,7 +1297,7 @@ static void tcmu_check_expired_queue_cmd(struct tcmu_cmd *cmd)
 {
 	struct se_cmd *se_cmd;
 
-	if (!time_after(jiffies, cmd->deadline))
+	if (!time_after_eq(jiffies, cmd->deadline))
 		return;
 
 	pr_debug("Timing out queued cmd %p on dev %s.\n",
-- 
2.12.3

