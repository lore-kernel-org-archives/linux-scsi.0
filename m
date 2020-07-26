Return-Path: <SRS0=zfIH=BF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFED6C4345F
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 15:35:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFCA02070B
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 15:35:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="U2QWPRO6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbgGZPfz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Jul 2020 11:35:55 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.116]:53232 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727936AbgGZPfw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 26 Jul 2020 11:35:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1595777748; i=@ts.fujitsu.com;
        bh=nFFQEN/Ep7H634q/N416zmClyutQqyDZoaXtEC5dMsk=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=U2QWPRO6GoMD1O4sjsgcTeFRZQCpKG9TCyDkSzWsrdL8xroaXigepUS37g2cPq1mr
         gPLVczrkh0iSUb3Qnsbz7zHT1LFfqBySCxqcBZ6CVJZQHkfE4TjiDhPZVNBGhbegX6
         3Q7el7uJ28bESpAuwqrX0zWlIxjQqOyrBFLCF3JRhnRpRiKwJV3bLND4Hiu7oQVy7+
         pl4SChkZTbtfBs+RAeEr8/RazGMEHQkXyARLitPOARJZoHThDKf1zZYlXyQZf2WThr
         uHNzeVCDAtGAY4vvuW0KRElWSr147B+o4kamBRRyrX0r1nspWMX5NiFnnZlqmuwoKV
         MqS9VmT/NaJMQ==
Received: from [100.113.7.116] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-5.bemta.az-b.eu-central-1.aws.symcld.net id D1/60-08547-3D2AD1F5; Sun, 26 Jul 2020 15:35:47 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRWlGSWpSXmKPExsViZ8MRqnt5kWy
  8wePHkhbd13ewWSw//o/J4u+kG6wWrUvfMjmweHx8eovF4/MmuQCmKNbMvKT8igTWjGc3PjEV
  rFStWP9zN2MD42H5LkYuDiGByYwS66//ZoJwpjNKrLk0l6WLkZODTcBAYsWk+ywgCRGBNYwSK
  +/MYwZJMAvoSUz7t44dxBYW8JXovvSBDcRmEVCVeHjvDxOIzStgJ7Hq0FxWEFtCQF6i48BksK
  GcAvYSG+d+AJsjBFSzbNMB9gmM3AsYGVYxWiYVZaZnlOQmZuboGhoY6BoaGuuaA1mmeolVukl
  6qaW6yal5JUWJQFm9xPJiveLK3OScFL281JJNjMBQSSlkz9zBOPnNB71DjJIcTEqivAZTZOOF
  +JLyUyozEosz4otKc1KLDzHKcHAoSfBeXQiUEyxKTU+tSMvMAYYtTFqCg0dJhHcOSJq3uCAxt
  zgzHSJ1ilFRSpy3HyQhAJLIKM2Da4PFyiVGWSlhXkYGBgYhnoLUotzMElT5V4ziHIxKwrxWIF
  N4MvNK4Ka/AlrMBLTY/ZIkyOKSRISUVANTcf3PlrA37a9y7ZkaFXxPqnK2tjU2/1jH9NVpX1H
  RJPlGszv71+1ktpc8vO8S3wT1myri0bMTD13+t/xzU8Uy1e6WTJ+qMJdU1c55CWtftvUkGqe9
  rets+SDb7yHz8cvxSRXREm+zL89mStjbdUj48tKU10GfO57/POLae3721eOTD11eGLbI0EUpt
  iczzX9XpPVdHYZaq8d7digbsbpafWFin/T8cusKhgdTmt47Pp9Xvet4x7/V2oaM0UJsTxyt64
  6d55OdtbZS7EK1+eft0y78ZGfYZ3l98dyJUb92vvE6M0Wq/9P2zIMFj5act2p5KVfZUmHRs0I
  34uLN8Jigo6u5a4/dOqFw69yDJh07JZbijERDLeai4kQAbuX3vRADAAA=
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-14.tower-238.messagelabs.com!1595777746!637983!1
X-Originating-IP: [62.60.8.85]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 3264 invoked from network); 26 Jul 2020 15:35:47 -0000
Received: from unknown (HELO mailhost4.uk.fujitsu.com) (62.60.8.85)
  by server-14.tower-238.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 26 Jul 2020 15:35:47 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost4.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06QFZkRA006464;
        Sun, 26 Jul 2020 16:35:46 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 516F5206B3;
        Sun, 26 Jul 2020 17:35:37 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH v3 6/8] scsi: target: tcmu: Fix and simplify timeout handling
Date:   Sun, 26 Jul 2020 17:35:08 +0200
Message-Id: <20200726153510.13077-7-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200726153510.13077-1-bstroesser@ts.fujitsu.com>
References: <20200726153510.13077-1-bstroesser@ts.fujitsu.com>
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
index eb68c5fee7b7..bddd40f07929 100644
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

