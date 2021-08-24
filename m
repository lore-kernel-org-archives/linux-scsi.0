Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B91C432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 10:06:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDED6610A5
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 10:06:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236056AbhHXKGw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Aug 2021 06:06:52 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3685 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236063AbhHXKGk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Aug 2021 06:06:40 -0400
Received: from fraeml744-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Gv4Th1qXWz6F96r;
        Tue, 24 Aug 2021 18:04:40 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml744-chm.china.huawei.com (10.206.15.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 24 Aug 2021 12:05:55 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 24 Aug 2021 11:05:53 +0100
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 4/5] scsi: hisi_sas: Replace some del_timer() calls with del_timer_sync()
Date:   Tue, 24 Aug 2021 18:00:59 +0800
Message-ID: <1629799260-120116-5-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1629799260-120116-1-git-send-email-john.garry@huawei.com>
References: <1629799260-120116-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Some usage of del_timer() in the driver is potentially unsafe.

For when running the sas_task->slow_task timer in
hisi_sas_exec_internal_tmf_task(), execution may be blocked in function
hisi_sas_task_exec(); so it is possible that the timer is running when the
callback to disable the timer is running. This could be dangerous, as we
immediately release resources which the timer callback uses after disabling
the timer.

The same situation may be found at other sites, such as
_hisi_sas_internal_task_abort().

So change calls to del_timer() to del_timer_sync() as necessary, to ensure
any timer has finished when disabling.

Also remove calls to timer_pending() prior to del_timer() as it is not
necessary.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 12 +++++-------
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  6 +++---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  3 +--
 3 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index fec4db46c76c..bb1c8ef3a76f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1171,7 +1171,7 @@ static int hisi_sas_control_phy(struct asd_sas_phy *sas_phy, enum phy_func func,
 
 static void hisi_sas_task_done(struct sas_task *task)
 {
-	del_timer(&task->slow_task->timer);
+	del_timer_sync(&task->slow_task->timer);
 	complete(&task->slow_task->completion);
 }
 
@@ -1229,7 +1229,7 @@ static int hisi_sas_exec_internal_tmf_task(struct domain_device *device,
 		res = hisi_sas_task_exec(task, GFP_KERNEL, 1, tmf);
 
 		if (res) {
-			del_timer(&task->slow_task->timer);
+			del_timer_sync(&task->slow_task->timer);
 			dev_err(dev, "abort tmf: executing internal task failed: %d\n",
 				res);
 			goto ex_err;
@@ -1554,8 +1554,7 @@ void hisi_sas_controller_reset_prepare(struct hisi_hba *hisi_hba)
 	scsi_block_requests(shost);
 	hisi_hba->hw->wait_cmds_complete_timeout(hisi_hba, 100, 5000);
 
-	if (timer_pending(&hisi_hba->timer))
-		del_timer_sync(&hisi_hba->timer);
+	del_timer_sync(&hisi_hba->timer);
 
 	set_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags);
 }
@@ -2097,7 +2096,7 @@ _hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
 	res = hisi_sas_internal_abort_task_exec(hisi_hba, sas_dev->device_id,
 						task, abort_flag, tag, dq);
 	if (res) {
-		del_timer(&task->slow_task->timer);
+		del_timer_sync(&task->slow_task->timer);
 		dev_err(dev, "internal task abort: executing internal task failed: %d\n",
 			res);
 		goto exit;
@@ -2769,8 +2768,7 @@ int hisi_sas_remove(struct platform_device *pdev)
 	struct hisi_hba *hisi_hba = sha->lldd_ha;
 	struct Scsi_Host *shost = sha->core.shost;
 
-	if (timer_pending(&hisi_hba->timer))
-		del_timer(&hisi_hba->timer);
+	del_timer_sync(&hisi_hba->timer);
 
 	sas_unregister_ha(sha);
 	sas_remove_host(sha->core.shost);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index a5fc79b3f732..236cf65c2f97 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2368,18 +2368,18 @@ static void slot_complete_v2_hw(struct hisi_hba *hisi_hba,
 	case STAT_IO_COMPLETE:
 		/* internal abort command complete */
 		ts->stat = TMF_RESP_FUNC_SUCC;
-		del_timer(&slot->internal_abort_timer);
+		del_timer_sync(&slot->internal_abort_timer);
 		goto out;
 	case STAT_IO_NO_DEVICE:
 		ts->stat = TMF_RESP_FUNC_COMPLETE;
-		del_timer(&slot->internal_abort_timer);
+		del_timer_sync(&slot->internal_abort_timer);
 		goto out;
 	case STAT_IO_NOT_VALID:
 		/* abort single io, controller don't find
 		 * the io need to abort
 		 */
 		ts->stat = TMF_RESP_FUNC_FAILED;
-		del_timer(&slot->internal_abort_timer);
+		del_timer_sync(&slot->internal_abort_timer);
 		goto out;
 	default:
 		break;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index b137e5619da1..cbc6c2d86745 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -4830,8 +4830,7 @@ static void hisi_sas_v3_remove(struct pci_dev *pdev)
 	struct Scsi_Host *shost = sha->core.shost;
 
 	pm_runtime_get_noresume(dev);
-	if (timer_pending(&hisi_hba->timer))
-		del_timer(&hisi_hba->timer);
+	del_timer_sync(&hisi_hba->timer);
 
 	sas_unregister_ha(sha);
 	flush_workqueue(hisi_hba->wq);
-- 
2.26.2

