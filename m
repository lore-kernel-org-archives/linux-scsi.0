Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30FBDCA90AF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 15:43:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDC44206B8
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 15:43:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="TPOowrM9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgELPnT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 May 2020 11:43:19 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.4]:39434 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726055AbgELPnT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 May 2020 11:43:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1589298193; i=@ts.fujitsu.com;
        bh=3EoYO4lNW+O/avFNsg26Hi/3he+lKDoaaAKLDCHeHQ4=;
        h=From:To:Cc:Subject:Date:Message-Id;
        b=TPOowrM9Fw5J/DGwJuaDBmoCljt+I7/SWjf9TZ2mRIDBNt5f6uzwzSdOUwOikKXlV
         orXC1OeuIHgPD5LbXCdp1qCg5a58LcYr1dqhtLqZb9OUtHyIusujKu3zW6oPiMqF2d
         efwFZggmdytgbExtX+EGoxTvLPEuOdUC+T9oDlSYkNe3osiO/BEo2VI2h7YVxzGSX8
         R8LV3zeiY839gKqTcr1n1wmjqO70LEBNNDjt6mHyT0VBCMRJeBEQxoEx7nAQU5ZECb
         3IUVx2AfiRl1kwUkE7t08bBtRVRSgxO1i01C3knNpQY7b0qMB/xFE7mekCgkSTLmCz
         //QKNBJBEacug==
Received: from [100.113.2.84] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-4.bemta.az-a.eu-central-1.aws.symcld.net id 12/CA-37389-114CABE5; Tue, 12 May 2020 15:43:13 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRWlGSWpSXmKPExsViZ8MRqit4ZFe
  cwY9Vchbd13ewWSw//o/JYv2RDYwWrUvfMjmweHx8eovF4/2+q2wenzfJBTBHsWbmJeVXJLBm
  fHk4gbHguV/F3ANSDYyzHbsYuTiEBCYzSmyZ/Jipi5EDyJnOKNHp0sXIycEmYCCxYtJ9FhBbR
  KBU4vnp1UwgNrOAnsS0f+vYQWxhgQCJJ9fngdWwCKhKrG5ewAxi8wrYSSw6/gosLiEgL9FxYD
  LLBEbOBYwMqxgtk4oy0zNKchMzc3QNDQx0DQ2NdQ10jQyM9RKrdBP1Ukt1k1PzSooSgbJ6ieX
  FesWVuck5KXp5qSWbGIHeTylkOL2D8eTy93qHGCU5mJREeVsm7IoT4kvKT6nMSCzOiC8qzUkt
  PsQow8GhJMHLcBgoJ1iUmp5akZaZAwxEmLQEB4+SCK/jIaA0b3FBYm5xZjpE6hSjLsfJVUsWM
  Qux5OXnpUqJ834BKRIAKcoozYMbAYuKS4yyUsK8jAwMDEI8BalFuZklqPKvGMU5GJWEeU+BTO
  HJzCuB2/QK6AgmoCMePt8GckRJIkJKqoEpbmnm2ZN6UxdvDs4+JOO3bEnv9YnvpbQnf1eOsCi
  JejXtTthWkXkMiW8fL70reW/vrpg7+cf958ycbLTV+BvTW8tHYo1qGp0O7xJM+Xvs9GQvnjVa
  xstinPwju6LW8snzEK3rlVMjX8jc/axw89L5+QrLW/ccPDjrw0zvK8YnIniOdxxSStApaTF1j
  1m/Mn3l4uhDnet6OotlI+NEm1lnu+yf38kwoyztcMoS4csy/T9t+g5Z9d6Yfb7b65xI0r5Fk2
  eK2XkGPyxruKFctSz5cfviDOtr84zWXmt++rRfLKxJTmwRf9rWN6y5bmX/xDMTWD955GY/TT2
  4LMm7aIp/qEn5w/WGynvlIvZWR1QqsRRnJBpqMRcVJwIAfnDF+gUDAAA=
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-29.tower-228.messagelabs.com!1589298192!1653286!1
X-Originating-IP: [62.60.8.85]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 9686 invoked from network); 12 May 2020 15:43:13 -0000
Received: from unknown (HELO mailhost4.uk.fujitsu.com) (62.60.8.85)
  by server-29.tower-228.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 12 May 2020 15:43:13 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost4.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 04CFh8xf023604;
        Tue, 12 May 2020 16:43:08 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 697F220671;
        Tue, 12 May 2020 17:43:05 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     martin.petersen@oracle.com, mchristi@redhat.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH] scsi: target: tcmu: userspace must not complete queued commands
Date:   Tue, 12 May 2020 17:42:50 +0200
Message-Id: <20200512154250.12310-1-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When tcmu queues a new command - no matter whether in command
ring or in qfull_queue - a cmd_id from IDR udev->commands is
assigned to the command.

If userspaces sends a wrong command completion containing the
cmd_id of a command on the qfull_queue, tcmu_handle_completions()
finds the command in the IDR and calls tcmu_handle_completion()
for it. This might do some nasty things, because commands in
qfull_queue do not have a valid dbi list.

To fix this bug, we no longer add queued commands to the idr.
Instead the cmd_id is assign when a command is written to
the command ring.

Due to this change I had to adapt the source code at several
places where up to now an idr_for_each had been done.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_user.c | 154 ++++++++++++++++++--------------------
 1 file changed, 71 insertions(+), 83 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index f769bb1e3735..de75583b74c6 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -882,41 +882,24 @@ static inline size_t tcmu_cmd_get_cmd_size(struct tcmu_cmd *tcmu_cmd,
 	return command_size;
 }
 
-static int tcmu_setup_cmd_timer(struct tcmu_cmd *tcmu_cmd, unsigned int tmo,
-				struct timer_list *timer)
+static void tcmu_setup_cmd_timer(struct tcmu_cmd *tcmu_cmd, unsigned int tmo,
+				 struct timer_list *timer)
 {
-	struct tcmu_dev *udev = tcmu_cmd->tcmu_dev;
-	int cmd_id;
-
-	if (tcmu_cmd->cmd_id)
-		goto setup_timer;
-
-	cmd_id = idr_alloc(&udev->commands, tcmu_cmd, 1, USHRT_MAX, GFP_NOWAIT);
-	if (cmd_id < 0) {
-		pr_err("tcmu: Could not allocate cmd id.\n");
-		return cmd_id;
-	}
-	tcmu_cmd->cmd_id = cmd_id;
-
-	pr_debug("allocated cmd %u for dev %s tmo %lu\n", tcmu_cmd->cmd_id,
-		 udev->name, tmo / MSEC_PER_SEC);
-
-setup_timer:
 	if (!tmo)
-		return 0;
+		return;
 
 	tcmu_cmd->deadline = round_jiffies_up(jiffies + msecs_to_jiffies(tmo));
 	if (!timer_pending(timer))
 		mod_timer(timer, tcmu_cmd->deadline);
 
-	return 0;
+	pr_debug("Timeout set up for cmd %p, dev = %s, tmo = %lu\n", tcmu_cmd,
+		 tcmu_cmd->tcmu_dev->name, tmo / MSEC_PER_SEC);
 }
 
 static int add_to_qfull_queue(struct tcmu_cmd *tcmu_cmd)
 {
 	struct tcmu_dev *udev = tcmu_cmd->tcmu_dev;
 	unsigned int tmo;
-	int ret;
 
 	/*
 	 * For backwards compat if qfull_time_out is not set use
@@ -931,13 +914,11 @@ static int add_to_qfull_queue(struct tcmu_cmd *tcmu_cmd)
 	else
 		tmo = TCMU_TIME_OUT;
 
-	ret = tcmu_setup_cmd_timer(tcmu_cmd, tmo, &udev->qfull_timer);
-	if (ret)
-		return ret;
+	tcmu_setup_cmd_timer(tcmu_cmd, tmo, &udev->qfull_timer);
 
 	list_add_tail(&tcmu_cmd->queue_entry, &udev->qfull_queue);
-	pr_debug("adding cmd %u on dev %s to ring space wait queue\n",
-		 tcmu_cmd->cmd_id, udev->name);
+	pr_debug("adding cmd %p on dev %s to ring space wait queue\n",
+		 tcmu_cmd, udev->name);
 	return 0;
 }
 
@@ -959,7 +940,7 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	struct tcmu_mailbox *mb;
 	struct tcmu_cmd_entry *entry;
 	struct iovec *iov;
-	int iov_cnt, ret;
+	int iov_cnt, cmd_id;
 	uint32_t cmd_head;
 	uint64_t cdb_off;
 	bool copy_to_data_area;
@@ -1060,14 +1041,21 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	}
 	entry->req.iov_bidi_cnt = iov_cnt;
 
-	ret = tcmu_setup_cmd_timer(tcmu_cmd, udev->cmd_time_out,
-				   &udev->cmd_timer);
-	if (ret) {
-		tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cnt);
+	cmd_id = idr_alloc(&udev->commands, tcmu_cmd, 1, USHRT_MAX, GFP_NOWAIT);
+	if (cmd_id < 0) {
+		pr_err("tcmu: Could not allocate cmd id.\n");
 
+		tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cnt);
 		*scsi_err = TCM_OUT_OF_RESOURCES;
 		return -1;
 	}
+	tcmu_cmd->cmd_id = cmd_id;
+
+	pr_debug("allocated cmd id %u for cmd %p dev %s\n", tcmu_cmd->cmd_id,
+		 tcmu_cmd, udev->name);
+
+	tcmu_setup_cmd_timer(tcmu_cmd, udev->cmd_time_out, &udev->cmd_timer);
+
 	entry->hdr.cmd_id = tcmu_cmd->cmd_id;
 
 	/*
@@ -1279,50 +1267,39 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 	return handled;
 }
 
-static int tcmu_check_expired_cmd(int id, void *p, void *data)
+static void tcmu_check_expired_ring_cmd(struct tcmu_cmd *cmd)
 {
-	struct tcmu_cmd *cmd = p;
-	struct tcmu_dev *udev = cmd->tcmu_dev;
-	u8 scsi_status;
 	struct se_cmd *se_cmd;
-	bool is_running;
-
-	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags))
-		return 0;
 
 	if (!time_after(jiffies, cmd->deadline))
-		return 0;
+		return;
 
-	is_running = test_bit(TCMU_CMD_BIT_INFLIGHT, &cmd->flags);
+	set_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags);
+	list_del_init(&cmd->queue_entry);
 	se_cmd = cmd->se_cmd;
+	cmd->se_cmd = NULL;
 
-	if (is_running) {
-		/*
-		 * If cmd_time_out is disabled but qfull is set deadline
-		 * will only reflect the qfull timeout. Ignore it.
-		 */
-		if (!udev->cmd_time_out)
-			return 0;
+	pr_debug("Timing out inflight cmd %u on dev %s.\n",
+		 cmd->cmd_id, cmd->tcmu_dev->name);
 
-		set_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags);
-		/*
-		 * target_complete_cmd will translate this to LUN COMM FAILURE
-		 */
-		scsi_status = SAM_STAT_CHECK_CONDITION;
-		list_del_init(&cmd->queue_entry);
-		cmd->se_cmd = NULL;
-	} else {
-		list_del_init(&cmd->queue_entry);
-		idr_remove(&udev->commands, id);
-		tcmu_free_cmd(cmd);
-		scsi_status = SAM_STAT_TASK_SET_FULL;
-	}
+	target_complete_cmd(se_cmd, SAM_STAT_CHECK_CONDITION);
+}
 
-	pr_debug("Timing out cmd %u on dev %s that is %s.\n",
-		 id, udev->name, is_running ? "inflight" : "queued");
+static void tcmu_check_expired_queue_cmd(struct tcmu_cmd *cmd)
+{
+	struct se_cmd *se_cmd;
 
-	target_complete_cmd(se_cmd, scsi_status);
-	return 0;
+	if (!time_after(jiffies, cmd->deadline))
+		return;
+
+	list_del_init(&cmd->queue_entry);
+	se_cmd = cmd->se_cmd;
+	tcmu_free_cmd(cmd);
+
+	pr_debug("Timing out queued cmd %p on dev %s.\n",
+		  cmd, cmd->tcmu_dev->name);
+
+	target_complete_cmd(se_cmd, SAM_STAT_TASK_SET_FULL);
 }
 
 static void tcmu_device_timedout(struct tcmu_dev *udev)
@@ -1407,16 +1384,15 @@ static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
 	return &udev->se_dev;
 }
 
-static bool run_qfull_queue(struct tcmu_dev *udev, bool fail)
+static void run_qfull_queue(struct tcmu_dev *udev, bool fail)
 {
 	struct tcmu_cmd *tcmu_cmd, *tmp_cmd;
 	LIST_HEAD(cmds);
-	bool drained = true;
 	sense_reason_t scsi_ret;
 	int ret;
 
 	if (list_empty(&udev->qfull_queue))
-		return true;
+		return;
 
 	pr_debug("running %s's cmdr queue forcefail %d\n", udev->name, fail);
 
@@ -1425,11 +1401,10 @@ static bool run_qfull_queue(struct tcmu_dev *udev, bool fail)
 	list_for_each_entry_safe(tcmu_cmd, tmp_cmd, &cmds, queue_entry) {
 		list_del_init(&tcmu_cmd->queue_entry);
 
-	        pr_debug("removing cmd %u on dev %s from queue\n",
-		         tcmu_cmd->cmd_id, udev->name);
+	        pr_debug("removing cmd %p on dev %s from queue\n",
+		         tcmu_cmd, udev->name);
 
 		if (fail) {
-			idr_remove(&udev->commands, tcmu_cmd->cmd_id);
 			/*
 			 * We were not able to even start the command, so
 			 * fail with busy to allow a retry in case runner
@@ -1444,10 +1419,8 @@ static bool run_qfull_queue(struct tcmu_dev *udev, bool fail)
 
 		ret = queue_cmd_ring(tcmu_cmd, &scsi_ret);
 		if (ret < 0) {
-		        pr_debug("cmd %u on dev %s failed with %u\n",
-			         tcmu_cmd->cmd_id, udev->name, scsi_ret);
-
-			idr_remove(&udev->commands, tcmu_cmd->cmd_id);
+		        pr_debug("cmd %p on dev %s failed with %u\n",
+			         tcmu_cmd, udev->name, scsi_ret);
 			/*
 			 * Ignore scsi_ret for now. target_complete_cmd
 			 * drops it.
@@ -1462,13 +1435,11 @@ static bool run_qfull_queue(struct tcmu_dev *udev, bool fail)
 			 * the queue
 			 */
 			list_splice_tail(&cmds, &udev->qfull_queue);
-			drained = false;
 			break;
 		}
 	}
 
 	tcmu_set_next_deadline(&udev->qfull_queue, &udev->qfull_timer);
-	return drained;
 }
 
 static int tcmu_irqcontrol(struct uio_info *info, s32 irq_on)
@@ -1652,6 +1623,8 @@ static void tcmu_dev_kref_release(struct kref *kref)
 		if (tcmu_check_and_free_pending_cmd(cmd) != 0)
 			all_expired = false;
 	}
+	if (!list_empty(&udev->qfull_queue))
+		all_expired = false;
 	idr_destroy(&udev->commands);
 	WARN_ON(!all_expired);
 
@@ -2037,9 +2010,6 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 	mutex_lock(&udev->cmdr_lock);
 
 	idr_for_each_entry(&udev->commands, cmd, i) {
-		if (!test_bit(TCMU_CMD_BIT_INFLIGHT, &cmd->flags))
-			continue;
-
 		pr_debug("removing cmd %u on dev %s from ring (is expired %d)\n",
 			  cmd->cmd_id, udev->name,
 			  test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags));
@@ -2077,6 +2047,8 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 
 	del_timer(&udev->cmd_timer);
 
+	run_qfull_queue(udev, false);
+
 	mutex_unlock(&udev->cmdr_lock);
 }
 
@@ -2698,6 +2670,7 @@ static void find_free_blocks(void)
 static void check_timedout_devices(void)
 {
 	struct tcmu_dev *udev, *tmp_dev;
+	struct tcmu_cmd *ucmd, *tmp_cmd;
 	LIST_HEAD(devs);
 
 	spin_lock_bh(&timed_out_udevs_lock);
@@ -2708,9 +2681,24 @@ static void check_timedout_devices(void)
 		spin_unlock_bh(&timed_out_udevs_lock);
 
 		mutex_lock(&udev->cmdr_lock);
-		idr_for_each(&udev->commands, tcmu_check_expired_cmd, NULL);
 
-		tcmu_set_next_deadline(&udev->inflight_queue, &udev->cmd_timer);
+		/*
+		 * If cmd_time_out is disabled but qfull is set deadline
+		 * will only reflect the qfull timeout. Ignore it.
+		 */
+		if (udev->cmd_time_out) {
+			list_for_each_entry_safe(ucmd, tmp_cmd,
+			                         &udev->inflight_queue,
+			                         queue_entry) {
+				tcmu_check_expired_ring_cmd(ucmd);
+			}
+			tcmu_set_next_deadline(&udev->inflight_queue,
+			                       &udev->cmd_timer);
+		}
+		list_for_each_entry_safe(ucmd, tmp_cmd, &udev->qfull_queue,
+			                 queue_entry) {
+			tcmu_check_expired_queue_cmd(ucmd);
+		}
 		tcmu_set_next_deadline(&udev->qfull_queue, &udev->qfull_timer);
 
 		mutex_unlock(&udev->cmdr_lock);
-- 
2.12.3

