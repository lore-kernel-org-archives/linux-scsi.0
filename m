Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECC93C4743C
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 09:34:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5B3E611C0
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 09:34:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhFGJgQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 05:36:16 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3161 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbhFGJgN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 05:36:13 -0400
Received: from fraeml715-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Fz7M30lkZz6G7L6;
        Mon,  7 Jun 2021 17:27:43 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml715-chm.china.huawei.com (10.206.15.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 11:34:21 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 10:34:18 +0100
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, Luo Jiaxing <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 4/5] scsi: hisi_sas: Reset controller for internal abort timeout
Date:   Mon, 7 Jun 2021 17:29:38 +0800
Message-ID: <1623058179-80434-5-git-send-email-john.garry@huawei.com>
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
fault, and needs to be reset to be recovered. However if a timeout occurs
during SCSI error handling, issuing a controller reset immediately may
conflict with the error handling.

To handle internal abort in these two scenarios, only queue the reset when
not in an error handling function. In the case of a timeout during error
handling, do nothing and rely on the inevitable ha nexus reset to reset
the controller.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 40 +++++++++++++++++----------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 37ccbc1103b3..0ad861aa5bb6 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -15,7 +15,7 @@ static int hisi_sas_debug_issue_ssp_tmf(struct domain_device *device,
 static int
 hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
 			     struct domain_device *device,
-			     int abort_flag, int tag);
+			     int abort_flag, int tag, bool rst_to_recover);
 static int hisi_sas_softreset_ata_disk(struct domain_device *device);
 static int hisi_sas_control_phy(struct asd_sas_phy *sas_phy, enum phy_func func,
 				void *funcdata);
@@ -1074,7 +1074,7 @@ static void hisi_sas_dev_gone(struct domain_device *device)
 	down(&hisi_hba->sem);
 	if (!test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags)) {
 		hisi_sas_internal_task_abort(hisi_hba, device,
-					     HISI_SAS_INT_ABT_DEV, 0);
+					     HISI_SAS_INT_ABT_DEV, 0, true);
 
 		hisi_sas_dereg_device(hisi_hba, device);
 
@@ -1516,7 +1516,8 @@ static void hisi_sas_terminate_stp_reject(struct hisi_hba *hisi_hba)
 			continue;
 
 		rc = hisi_sas_internal_task_abort(hisi_hba, device,
-						  HISI_SAS_INT_ABT_DEV, 0);
+						  HISI_SAS_INT_ABT_DEV, 0,
+						  false);
 		if (rc < 0)
 			dev_err(dev, "STP reject: abort dev failed %d\n", rc);
 	}
@@ -1671,7 +1672,8 @@ static int hisi_sas_abort_task(struct sas_task *task)
 						  &tmf_task);
 
 		rc2 = hisi_sas_internal_task_abort(hisi_hba, device,
-						   HISI_SAS_INT_ABT_CMD, tag);
+						   HISI_SAS_INT_ABT_CMD, tag,
+						   false);
 		if (rc2 < 0) {
 			dev_err(dev, "abort task: internal abort (%d)\n", rc2);
 			return TMF_RESP_FUNC_FAILED;
@@ -1693,7 +1695,7 @@ static int hisi_sas_abort_task(struct sas_task *task)
 		if (task->dev->dev_type == SAS_SATA_DEV) {
 			rc = hisi_sas_internal_task_abort(hisi_hba, device,
 							  HISI_SAS_INT_ABT_DEV,
-							  0);
+							  0, false);
 			if (rc < 0) {
 				dev_err(dev, "abort task: internal abort failed\n");
 				goto out;
@@ -1708,7 +1710,8 @@ static int hisi_sas_abort_task(struct sas_task *task)
 		struct hisi_sas_cq *cq = &hisi_hba->cq[slot->dlvry_queue];
 
 		rc = hisi_sas_internal_task_abort(hisi_hba, device,
-						  HISI_SAS_INT_ABT_CMD, tag);
+						  HISI_SAS_INT_ABT_CMD, tag,
+						  false);
 		if (((rc < 0) || (rc == TMF_RESP_FUNC_FAILED)) &&
 					task->lldd_task) {
 			/*
@@ -1734,7 +1737,7 @@ static int hisi_sas_abort_task_set(struct domain_device *device, u8 *lun)
 	int rc;
 
 	rc = hisi_sas_internal_task_abort(hisi_hba, device,
-					  HISI_SAS_INT_ABT_DEV, 0);
+					  HISI_SAS_INT_ABT_DEV, 0, false);
 	if (rc < 0) {
 		dev_err(dev, "abort task set: internal abort rc=%d\n", rc);
 		return TMF_RESP_FUNC_FAILED;
@@ -1828,7 +1831,7 @@ static int hisi_sas_I_T_nexus_reset(struct domain_device *device)
 	int rc;
 
 	rc = hisi_sas_internal_task_abort(hisi_hba, device,
-					  HISI_SAS_INT_ABT_DEV, 0);
+					  HISI_SAS_INT_ABT_DEV, 0, false);
 	if (rc < 0) {
 		dev_err(dev, "I_T nexus reset: internal abort (%d)\n", rc);
 		return TMF_RESP_FUNC_FAILED;
@@ -1858,7 +1861,7 @@ static int hisi_sas_lu_reset(struct domain_device *device, u8 *lun)
 
 	/* Clear internal IO and then lu reset */
 	rc = hisi_sas_internal_task_abort(hisi_hba, device,
-					  HISI_SAS_INT_ABT_DEV, 0);
+					  HISI_SAS_INT_ABT_DEV, 0, false);
 	if (rc < 0) {
 		dev_err(dev, "lu_reset: internal abort failed\n");
 		goto out;
@@ -2054,11 +2057,13 @@ hisi_sas_internal_abort_task_exec(struct hisi_hba *hisi_hba, int device_id,
  * @tag: tag of IO to be aborted (only relevant to single
  *       IO mode)
  * @dq: delivery queue for this internal abort command
+ * @rst_to_recover: If rst_to_recover set, queue a controller
+ *		    reset if an internal abort times out.
  */
 static int
 _hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
 			      struct domain_device *device, int abort_flag,
-			      int tag, struct hisi_sas_dq *dq)
+			      int tag, struct hisi_sas_dq *dq, bool rst_to_recover)
 {
 	struct sas_task *task;
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
@@ -2114,7 +2119,13 @@ _hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
 				synchronize_irq(cq->irq_no);
 				slot->task = NULL;
 			}
-			dev_err(dev, "internal task abort: timeout and not done.\n");
+
+			if (rst_to_recover) {
+				dev_err(dev, "internal task abort: timeout and not done. Queuing reset.\n");
+				queue_work(hisi_hba->wq, &hisi_hba->rst_work);
+			} else {
+				dev_err(dev, "internal task abort: timeout and not done.\n");
+			}
 
 			res = -EIO;
 			goto exit;
@@ -2147,7 +2158,7 @@ _hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
 static int
 hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
 			     struct domain_device *device,
-			     int abort_flag, int tag)
+			     int abort_flag, int tag, bool rst_to_recover)
 {
 	struct hisi_sas_slot *slot;
 	struct device *dev = hisi_hba->dev;
@@ -2159,7 +2170,8 @@ hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
 		slot = &hisi_hba->slot_info[tag];
 		dq = &hisi_hba->dq[slot->dlvry_queue];
 		return _hisi_sas_internal_task_abort(hisi_hba, device,
-						     abort_flag, tag, dq);
+						     abort_flag, tag, dq,
+						     rst_to_recover);
 	case HISI_SAS_INT_ABT_DEV:
 		for (i = 0; i < hisi_hba->cq_nvecs; i++) {
 			struct hisi_sas_cq *cq = &hisi_hba->cq[i];
@@ -2170,7 +2182,7 @@ hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
 			dq = &hisi_hba->dq[i];
 			rc = _hisi_sas_internal_task_abort(hisi_hba, device,
 							   abort_flag, tag,
-							   dq);
+							   dq, rst_to_recover);
 			if (rc)
 				return rc;
 		}
-- 
2.26.2

