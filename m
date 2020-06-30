Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADECBC433E3
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 10:47:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83D7A207E8
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 10:47:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="kZrVo/5i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732660AbgF3Kru (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 06:47:50 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.113]:15403 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732583AbgF3Krr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Jun 2020 06:47:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1593514060; i=@ts.fujitsu.com;
        bh=pYNo6yKo57bY/EY4E2BdwIp9O/+3AvXWNSsi/zzHTFg=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=kZrVo/5i1YACpZU/NkIsnLPSS0X6MYaCXl7OcZ20iwIP3jRXotZoDqJrYJd95uu6v
         /UtTU/XEkgYtOVfpk6Eu3xV6hd3E/hiaJggoBifFohkVYd8mt72sU5U1jrTN8/yeoZ
         3CSCVt8JYGCQmMKMFL4QlAj/cXeAFN0cK8/IhWab9Wjd7Kuy/9H1QAXgGkOxBFOQEx
         Y17Y7G/iU3moUf9BUKa+pjQze/rwhfHVrt+kkDS6b2wvgbf7pRyKXwErkhFR9EcYfe
         otxkp2aPlj38c9/WwnX2TYzi5ACRN+G43gMWaID23FHkJWhwRVQYfetQBM+V4JsVG/
         O8lD/WzaoOxMw==
Received: from [100.113.4.241] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-2.bemta.az-b.eu-central-1.aws.symcld.net id 30/2D-49188-C481BFE5; Tue, 30 Jun 2020 10:47:40 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRWlGSWpSXmKPExsViZ8MxVddb4ne
  cwevbVhbd13ewWSw//o/J4u+kG6wWrUvfMjmweHx8eovF4/MmuQCmKNbMvKT8igTWjKdb37EV
  rFStePTlDFMD42H5LkZODiGByYwSu7YWdjFyAdnTGSWm/H/JBJJgEzCQWDHpPgtIQkRgDaPEy
  jvzmEESzAJ6EtP+rWMHsYUF/CS23HnECmKzCKhK7HrznQ3E5hWwk5jec4kFxJYQkJfoODAZzO
  YUsJdYe/g0C8RmO4m1m2eyTWDkXsDIsIrRMqkoMz2jJDcxM0fX0MBA19DQWNdU18jEUC+xSjd
  JL7VUNzk1r6QoESirl1herFdcmZuck6KXl1qyiREYKCmFrB93MB56/UHvEKMkB5OSKO+9f7/i
  hPiS8lMqMxKLM+KLSnNSiw8xynBwKEnwPhX/HSckWJSanlqRlpkDDFqYtAQHj5II736QNG9xQ
  WJucWY6ROoUo6KUOO9KMaCEAEgiozQPrg0WKZcYZaWEeRkZGBiEeApSi3IzS1DlXzGKczAqCf
  MmgIznycwrgZv+CmgxE9Dia1q/QBaXJCKkpBqY5t879Xvrjz01Wv4xSekfzTx9myQKf2V2mz5
  Ubz16TrDg7L0V+jG/Ts2YdGmrxNIYvdNHjq/h6e9kXP16l4/g1i6bIPmd1+dueHhSUk7i+KNM
  7fc8NzyU6l9bPuZbdE4k285QaA7D7MuidzyPMy9ar5Ejnn/uf+t3/fqlL6rrO9qkCxOC1G+md
  l6p2Jp3Oqnfe/MLvSNiKmwN/k4KcxsE5WIO1HQq3eM5ZyJx3N9Hgm39tl3dzpsTVlrdN53Zk3
  b2iEryJ3XnPwGqy5SY937hstvMMffAyr/BS2bemTm1cF4jR5SRitpllxydjZs5i+fWVi3VqTu
  xb67f1qBpHdOK1x+4Fm2pxyG20ciMY4eKEktxRqKhFnNRcSIA8evLdQ8DAAA=
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-24.tower-238.messagelabs.com!1593514059!1349444!1
X-Originating-IP: [62.60.8.149]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 27593 invoked from network); 30 Jun 2020 10:47:39 -0000
Received: from unknown (HELO mailhost2.uk.fujitsu.com) (62.60.8.149)
  by server-24.tower-238.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 30 Jun 2020 10:47:39 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost2.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 05UAlYOx004488;
        Tue, 30 Jun 2020 11:47:35 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 77FEA20AD8;
        Tue, 30 Jun 2020 12:47:33 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [RFC PATCH 6/8] scsi: target: tcmu: Fix and simplify timeout handling
Date:   Tue, 30 Jun 2020 12:47:07 +0200
Message-Id: <20200630104709.23066-7-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200630104709.23066-1-bstroesser@ts.fujitsu.com>
References: <20200630104709.23066-1-bstroesser@ts.fujitsu.com>
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
index f10d8d182ed9..89f38355a2ab 100644
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

