Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CACEC761A6
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Mar 2023 01:56:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbjCSB4s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Mar 2023 21:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCSB4k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Mar 2023 21:56:40 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF92523121;
        Sat, 18 Mar 2023 18:56:38 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32J1lsdX014925;
        Sun, 19 Mar 2023 01:56:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=mFf2nVt2qaz7X8zKMdYCakppiUj1kCW6IhOw1vBQ90o=;
 b=qLH85COZEVtOCesDfugViiCe/ztnLMf+USijnxEV7cnZJS4cMJUrQGH1fxpjvgk2yJog
 1tqWMWOUKHpOFS7It51b1owVkUuC4jNf7qPck90S46jitTbEeL88s62KIiQAhPTObYo9
 TmdHWNfcdaQOnU7Vllac3i2OrENPta3TpCEWzUSVk7fx+4mAQZkRzGn0ud/UI5TqPDCb
 c94/zjyah7g9fiHcqIyH2gpW+k0d9ZBOxyRIm+oosIEkt3Z70ppcVAYBKAhJXTNQIQ18
 PEyb8ft/jeTBhS3i0n5Bbiyf4rEglEu2p5z9jT0nd7wpQA1bwK5NhYTJYxrp3cpVYNOS +Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd433h5hs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 19 Mar 2023 01:56:36 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32INoVYT030404;
        Sun, 19 Mar 2023 01:56:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pd3raaues-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 19 Mar 2023 01:56:36 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32J1uO5S014254;
        Sun, 19 Mar 2023 01:56:35 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-118-173.vpn.oracle.com [10.154.118.173])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3pd3raauaw-8;
        Sun, 19 Mar 2023 01:56:35 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        d.bogdanov@yadro.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 7/9] scsi: target: Fix multiple LUN_RESET handling
Date:   Sat, 18 Mar 2023 20:56:18 -0500
Message-Id: <20230319015620.96006-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230319015620.96006-1-michael.christie@oracle.com>
References: <20230319015620.96006-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-18_16,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxlogscore=972 mlxscore=0 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303190014
X-Proofpoint-ORIG-GUID: lF4YNaBa7vAo0gu_OsGFhR7J-VHaScg1
X-Proofpoint-GUID: lF4YNaBa7vAo0gu_OsGFhR7J-VHaScg1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This fixes a bug where an initiator thinks a LUN_RESET has cleaned
up running commands when it hasn't. The bug was added in:

commit 51ec502a3266 ("target: Delete tmr from list before processing")

The problem occurs when:

1. We have N IO cmds running in the target layer spread over 2 sessions.
2. The initiator sends a LUN_RESET for each session.
3. session1's LUN_RESET loops over all the running commands from both
sessions and moves them to its local drain_task_list.
4. session2's LUN_RESET does not see the LUN_RESET from session1 because
the commit above has it remove itself. session2 also does not see any
commands since the other reset moved them off the state lists.
5. sessions2's LUN_RESET will then complete with a successful response.
6. sessions2's inititor believes the running commands on its session are
now cleaned up due to the successful response and cleans up the running
commands from its side. It then restarts them.
7. The commands do eventually complete on the backend and the target
starts to return aborted task statuses for them. The initiator will
either throw a invalid ITT error or might accidentally lookup a new task
if the ITT has been reallocated already.

This fixes the bug by reverting the patch, and serializes the execution of
LUN_RESETs and Preempt and Aborts.

The patch also prevents us from waiting on LUN_RESETs in
core_tmr_drain_tmr_list, because it turns out the original patch fixed a
bug that was not mentioned. For LUN_RESET1 core_tmr_drain_tmr_list can see
a second LUN_RESET and wait on it. Then the second reset will run
core_tmr_drain_tmr_list and see the first reset and wait on it resulting
in a deadlock.

Fixes: 51ec502a3266 ("target: Delete tmr from list before processing")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_device.c |  1 +
 drivers/target/target_core_tmr.c    | 26 +++++++++++++++++++++++---
 include/target/target_core_base.h   |  1 +
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index f6e58410ec3f..aeb03136773d 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -782,6 +782,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	spin_lock_init(&dev->t10_alua.lba_map_lock);
 
 	INIT_WORK(&dev->delayed_cmd_work, target_do_delayed_work);
+	mutex_init(&dev->lun_reset_mutex);
 
 	dev->t10_wwn.t10_dev = dev;
 	/*
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 2b95b4550a63..4718db628222 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -188,14 +188,23 @@ static void core_tmr_drain_tmr_list(
 	 * LUN_RESET tmr..
 	 */
 	spin_lock_irqsave(&dev->se_tmr_lock, flags);
-	if (tmr)
-		list_del_init(&tmr->tmr_list);
 	list_for_each_entry_safe(tmr_p, tmr_pp, &dev->dev_tmr_list, tmr_list) {
+		if (tmr_p == tmr)
+			continue;
+
 		cmd = tmr_p->task_cmd;
 		if (!cmd) {
 			pr_err("Unable to locate struct se_cmd for TMR\n");
 			continue;
 		}
+
+		/*
+		 * We only execute one LUN_RESET at a time so we can't wait
+		 * on them below.
+		 */
+		if (tmr_p->function == TMR_LUN_RESET)
+			continue;
+
 		/*
 		 * If this function was called with a valid pr_res_key
 		 * parameter (eg: for PROUT PREEMPT_AND_ABORT service action
@@ -379,14 +388,25 @@ int core_tmr_lun_reset(
 				tmr_nacl->initiatorname);
 		}
 	}
+
+
+	/*
+	 * We only allow one reset or preempt and abort to execute at a time
+	 * to prevent one call from claiming all the cmds causing a second
+	 * call from returning while cmds it should have waited on are still
+	 * running.
+	 */
+	mutex_lock(&dev->lun_reset_mutex);
+
 	pr_debug("LUN_RESET: %s starting for [%s], tas: %d\n",
 		(preempt_and_abort_list) ? "Preempt" : "TMR",
 		dev->transport->name, tas);
-
 	core_tmr_drain_tmr_list(dev, tmr, preempt_and_abort_list);
 	core_tmr_drain_state_list(dev, prout_cmd, tmr_sess, tas,
 				preempt_and_abort_list);
 
+	mutex_unlock(&dev->lun_reset_mutex);
+
 	/*
 	 * Clear any legacy SPC-2 reservation when called during
 	 * LOGICAL UNIT RESET
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index bd299790e99c..8cc42ad65c92 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -872,6 +872,7 @@ struct se_device {
 	struct rcu_head		rcu_head;
 	int			queue_cnt;
 	struct se_device_queue	*queues;
+	struct mutex		lun_reset_mutex;
 };
 
 struct target_opcode_descriptor {
-- 
2.25.1

