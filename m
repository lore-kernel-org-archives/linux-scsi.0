Return-Path: <SRS0=k4K9=7A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A503EC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 16:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 771F0207E8
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 16:49:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="ob8v49Yf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgERQtZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 May 2020 12:49:25 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.3]:27761 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726958AbgERQtY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 May 2020 12:49:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1589820559; i=@ts.fujitsu.com;
        bh=R7lEWqTVs8cUAuOrsBnZo3pHsQ02geXIfMgiWHjruXE=;
        h=From:To:Cc:Subject:Date:Message-Id;
        b=ob8v49YfOAFG8/nq6QJPNfRNOjKwIT4brbeR0y56bOgTN8oKVeFNMm3yfSaDZR78Q
         ZNVqnfu02G8h6Ac3dF7LnW9xEJR2YJ5JqyRZ85/lXX07oJ1Mq0uQPsBtGyrfDvUO8N
         0q6wcR8hDhs+HYfqCASpVOeNacVmXAD2dbiQWBdjQOzUq/hFgwapOxM+wsEz+78Icn
         UtkRspDrqbxzzj94BVvPg+2C/F5SeGtwQTYvknT5QDFs7XTnFf16pTsR5FvTn5ANgn
         iyMH7kw4CXCScyIk5EpPzecx/b8z6bkAm+Ol2HXYy71GeXTDgqpM91Kcx3Jih7u1ly
         cowyhkuoZJNAg==
Received: from [100.113.3.197] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-3.bemta.az-a.eu-central-1.aws.symcld.net id E5/0F-40432-F8CB2CE5; Mon, 18 May 2020 16:49:19 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRWlGSWpSXmKPExsViZ8MRotu/51C
  cwTVti+7rO9gslh//x2Sx/sgGRovWpW+ZHFg8Pj69xeLxft9VNo/Pm+QCmKNYM/OS8isSWDOO
  Pu9gKtjjXzHn4n7GBsa7jl2MXBxCApMZJVqaW5ggnOmMEhNeTWPsYuTkYBMwkFgx6T4LiC0iU
  Crx/PRqJhCbWUBPYtq/dewgtrBAsMS0n8+YQWwWAVWJKX/+snUxcnDwCthJ7OqxBwlLCMhLdB
  yYzDKBkXMBI8MqRsukosz0jJLcxMwcXUMDA11DQ2NdY11DIyO9xCrdRL3UUt3k1LySokSgrF5
  iebFecWVuck6KXl5qySZGoP9TCpmrdjBeXP5e7xCjJAeTkihveMmhOCG+pPyUyozE4oz4otKc
  1OJDjDIcHEoSvHN2AeUEi1LTUyvSMnOAoQiTluDgURLhdQRJ8xYXJOYWZ6ZDpE4x6nKcXLVkE
  bMQS15+XqqUOO9qkCIBkKKM0jy4EbC4uMQoKyXMy8jAwCDEU5BalJtZgir/ilGcg1FJmDcOZA
  pPZl4J3KZXQEcwAR3henEfyBEliQgpqQamALf7XveW/L8Rptu77UJz6XHGm7kFipz6s3eECRY
  UVm0/Fi5w98Ek9T/y78T9u983/9ATKSzljkk02Jeg2ROYFiDL48+w8Od5VcuFL2ZtaO5W9577
  a/kH/ie9zbNernAtnvxHObP6vSUn48rk4OlThOaqVZhKt4ptK+vX/sdw2nSTm3tIeUHS4arus
  3O+OIj4vJzFeinImP3JoUb5pM8ML/bp5xyKSFq4mmHNm9bEuk+Ziq0Le32M9nPH8yz23ngj/G
  BG3tuDMfPqzHg9BUzZZGsWnxb7sqLi5uqWEqe8qLCqye/Edr58qC10xu7T100fA1bc7cviMLx
  QmPD7xGqdrTyKNxQ4Sg/5TIkNy1ZiKc5INNRiLipOBADe47DpBgMAAA==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-11.tower-226.messagelabs.com!1589820558!301473!1
X-Originating-IP: [62.60.8.84]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 9786 invoked from network); 18 May 2020 16:49:18 -0000
Received: from unknown (HELO mailhost3.uk.fujitsu.com) (62.60.8.84)
  by server-11.tower-226.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 18 May 2020 16:49:18 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost3.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 04IGnFHJ021289;
        Mon, 18 May 2020 17:49:15 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 0AB7D2067E;
        Mon, 18 May 2020 18:49:15 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     martin.petersen@oracle.com, mchristi@redhat.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH v2] scsi: target: tcmu: userspace must not complete queued commands
Date:   Mon, 18 May 2020 18:48:33 +0200
Message-Id: <20200518164833.12775-1-bstroesser@ts.fujitsu.com>
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

V2:
 - Changed name of new variable in
   check_timedout_devices() from "ucmd" to "cmd"

 drivers/target/target_core_user.c | 154 ++++++++++++++++++--------------------
 1 file changed, 71 insertions(+), 83 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index f769bb1e3735..985b9b68ffd3 100644
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
+	struct tcmu_cmd *cmd, *tmp_cmd;
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
+			list_for_each_entry_safe(cmd, tmp_cmd,
+			                         &udev->inflight_queue,
+			                         queue_entry) {
+				tcmu_check_expired_ring_cmd(cmd);
+			}
+			tcmu_set_next_deadline(&udev->inflight_queue,
+			                       &udev->cmd_timer);
+		}
+		list_for_each_entry_safe(cmd, tmp_cmd, &udev->qfull_queue,
+			                 queue_entry) {
+			tcmu_check_expired_queue_cmd(cmd);
+		}
 		tcmu_set_next_deadline(&udev->qfull_queue, &udev->qfull_timer);
 
 		mutex_unlock(&udev->cmdr_lock);
-- 
2.12.3

