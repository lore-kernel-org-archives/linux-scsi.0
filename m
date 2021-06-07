Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBB9CC47082
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 09:34:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B59C9611C1
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 09:34:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbhFGJgU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 05:36:20 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3162 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbhFGJgP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 05:36:15 -0400
Received: from fraeml710-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Fz7D75Pn4z6H6q6;
        Mon,  7 Jun 2021 17:21:43 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml710-chm.china.huawei.com (10.206.15.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 11:34:23 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 10:34:21 +0100
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, Luo Jiaxing <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 5/5] scsi: hisi_sas: Speed up error handling when internal abort timeout occurs
Date:   Mon, 7 Jun 2021 17:29:39 +0800
Message-ID: <1623058179-80434-6-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623058179-80434-1-git-send-email-john.garry@huawei.com>
References: <1623058179-80434-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

If an internal task abort timeout occurs, the controller has developed a
fault, and needs to be reset to be recovered.

When this occurs during error handling, the current policy is to allow
error handling to continue, and the inevitable nexus ha reset will handle
the required reset.

However various steps of error handling need to taken before this happens.
These also involve some level of HW interaction, which will also fail with
various timeouts.

Speed up this process by recording a HW fault bit for an internal abort
timeout - when this is set, just automatically error any HW interaction,
and essentially go straight to clear nexus ha (to reset the controller).

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      | 1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 8f2492d0d49e..436d174f2194 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -38,6 +38,7 @@
 #define HISI_SAS_RESET_BIT	0
 #define HISI_SAS_REJECT_CMD_BIT	1
 #define HISI_SAS_PM_BIT		2
+#define HISI_SAS_HW_FAULT_BIT	3
 #define HISI_SAS_MAX_COMMANDS (HISI_SAS_QUEUE_SLOTS)
 #define HISI_SAS_RESERVED_IPTT  96
 #define HISI_SAS_UNRESERVED_IPTT \
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 0ad861aa5bb6..3a903e8e0384 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1616,6 +1616,7 @@ static int hisi_sas_controller_reset(struct hisi_hba *hisi_hba)
 	}
 
 	hisi_sas_controller_reset_done(hisi_hba);
+	clear_bit(HISI_SAS_HW_FAULT_BIT, &hisi_hba->flags);
 	dev_info(dev, "controller reset complete\n");
 
 	return 0;
@@ -2079,6 +2080,9 @@ _hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
 	if (!hisi_hba->hw->prep_abort)
 		return TMF_RESP_FUNC_FAILED;
 
+	if (test_bit(HISI_SAS_HW_FAULT_BIT, &hisi_hba->flags))
+		return -EIO;
+
 	task = sas_alloc_slow_task(GFP_KERNEL);
 	if (!task)
 		return -ENOMEM;
@@ -2109,6 +2113,8 @@ _hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
 		if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
 			struct hisi_sas_slot *slot = task->lldd_task;
 
+			set_bit(HISI_SAS_HW_FAULT_BIT, &hisi_hba->flags);
+
 			if (slot) {
 				struct hisi_sas_cq *cq =
 					&hisi_hba->cq[slot->dlvry_queue];
-- 
2.26.2

