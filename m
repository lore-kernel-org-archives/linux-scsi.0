Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35975C18E5C
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:31:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1012B215A4
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:31:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbgCJQbs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 12:31:48 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11207 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727250AbgCJQbo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Mar 2020 12:31:44 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6938612D4A4279D1EED7;
        Wed, 11 Mar 2020 00:30:38 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 11 Mar 2020 00:30:31 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hare@suse.de>,
        <ming.lei@redhat.com>, <bvanassche@acm.org>, <hch@infradead.org>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH RFC v2 23/24] scsi: libsas: aic94xx: hisi_sas: mvsas: pm8001: Allocate Scsi_cmd for slow task
Date:   Wed, 11 Mar 2020 00:25:49 +0800
Message-ID: <1583857550-12049-24-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
References: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allocate a Scsi_cmd for SAS slow tasks, so they can be accounted for in
the blk-mq layer.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c |  8 +++---
 drivers/scsi/libsas/sas_expander.c    |  3 ++-
 drivers/scsi/libsas/sas_init.c        | 36 +++++++++++++++++++++------
 drivers/scsi/mvsas/mv_sas.c           |  2 +-
 drivers/scsi/pm8001/pm8001_hwi.c      |  4 +--
 drivers/scsi/pm8001/pm8001_sas.c      |  4 +--
 drivers/scsi/pm8001/pm80xx_hwi.c      |  4 +--
 include/scsi/libsas.h                 |  4 ++-
 8 files changed, 46 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 9a6deb21fe4d..c7951ac8b075 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1182,12 +1182,13 @@ static int hisi_sas_exec_internal_tmf_task(struct domain_device *device,
 {
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
 	struct hisi_hba *hisi_hba = sas_dev->hisi_hba;
+	struct sas_ha_struct *sha = &hisi_hba->sha;
 	struct device *dev = hisi_hba->dev;
 	struct sas_task *task;
 	int res, retry;
 
 	for (retry = 0; retry < TASK_RETRY; retry++) {
-		task = sas_alloc_slow_task(GFP_KERNEL);
+		task = sas_alloc_slow_task(GFP_KERNEL, sha);
 		if (!task)
 			return -ENOMEM;
 
@@ -2022,9 +2023,10 @@ _hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
 			      struct domain_device *device, int abort_flag,
 			      int tag, struct hisi_sas_dq *dq)
 {
-	struct sas_task *task;
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
+	struct sas_ha_struct *sha = &hisi_hba->sha;
 	struct device *dev = hisi_hba->dev;
+	struct sas_task *task;
 	int res;
 
 	/*
@@ -2036,7 +2038,7 @@ _hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
 	if (!hisi_hba->hw->prep_abort)
 		return TMF_RESP_FUNC_FAILED;
 
-	task = sas_alloc_slow_task(GFP_KERNEL);
+	task = sas_alloc_slow_task(GFP_KERNEL, sha);
 	if (!task)
 		return -ENOMEM;
 
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index ab671cdd4cfb..24626acc6a11 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -56,6 +56,7 @@ static int smp_execute_task_sg(struct domain_device *dev,
 {
 	int res, retry;
 	struct sas_task *task = NULL;
+	struct sas_ha_struct *sha = dev->port->ha;
 	struct sas_internal *i =
 		to_sas_internal(dev->port->ha->core.shost->transportt);
 
@@ -66,7 +67,7 @@ static int smp_execute_task_sg(struct domain_device *dev,
 			break;
 		}
 
-		task = sas_alloc_slow_task(GFP_KERNEL);
+		task = sas_alloc_slow_task(GFP_KERNEL, sha);
 		if (!task) {
 			res = -ENOMEM;
 			break;
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 21c43b18d5d5..493caaf50a12 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -14,6 +14,7 @@
 #include <scsi/sas_ata.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
+#include <scsi/scsi_tcq.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_sas.h>
 
@@ -37,16 +38,23 @@ struct sas_task *sas_alloc_task(gfp_t flags)
 }
 EXPORT_SYMBOL_GPL(sas_alloc_task);
 
-struct sas_task *sas_alloc_slow_task(gfp_t flags)
+struct sas_task *sas_alloc_slow_task(gfp_t flags, struct sas_ha_struct *sha)
 {
 	struct sas_task *task = sas_alloc_task(flags);
-	struct sas_task_slow *slow = kmalloc(sizeof(*slow), flags);
+	struct Scsi_Host *shost = sha->core.shost;
+	struct sas_task_slow *slow;
 
-	if (!task || !slow) {
-		if (task)
-			kmem_cache_free(sas_task_cache, task);
-		kfree(slow);
+	if (!task)
 		return NULL;
+
+	slow = kzalloc(sizeof(*slow), flags);
+	if (!slow)
+		goto out_err_slow;
+
+	if (shost->reserved_cmd_q) {
+		slow->scmd = scsi_get_reserved_cmd(shost);
+		if (!slow->scmd)
+			goto out_err_scmd;
 	}
 
 	task->slow_task = slow;
@@ -55,13 +63,27 @@ struct sas_task *sas_alloc_slow_task(gfp_t flags)
 	init_completion(&slow->completion);
 
 	return task;
+
+out_err_scmd:
+	kfree(slow);
+out_err_slow:
+	kmem_cache_free(sas_task_cache, task);
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(sas_alloc_slow_task);
 
 void sas_free_task(struct sas_task *task)
 {
 	if (task) {
-		kfree(task->slow_task);
+		/*
+		 * It could be good to just introduce separate sas_free_slow_task() to
+		 * avoid the following in the fastpath.
+		 */
+		if (task->slow_task) {
+			if (task->slow_task->scmd)
+				scsi_put_reserved_cmd(task->slow_task->scmd);
+			kfree(task->slow_task);
+		}
 		kmem_cache_free(sas_task_cache, task);
 	}
 }
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index a920eced92ec..2ef37d634c22 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1283,7 +1283,7 @@ static int mvs_exec_internal_tmf_task(struct domain_device *dev,
 	struct sas_task *task = NULL;
 
 	for (retry = 0; retry < 3; retry++) {
-		task = sas_alloc_slow_task(GFP_KERNEL);
+		task = sas_alloc_slow_task(GFP_KERNEL, dev->port->ha);
 		if (!task)
 			return -ENOMEM;
 
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 2328ff1349ac..e9d759f64b3b 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1743,7 +1743,7 @@ static void pm8001_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 		return;
 	}
 
-	task = sas_alloc_slow_task(GFP_ATOMIC);
+	task = sas_alloc_slow_task(GFP_ATOMIC, pm8001_ha->sas);
 
 	if (!task) {
 		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("cannot "
@@ -1789,7 +1789,7 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
 	struct inbound_queue_table *circularQ;
 	u32 opc = OPC_INB_SATA_HOST_OPSTART;
 
-	task = sas_alloc_slow_task(GFP_ATOMIC);
+	task = sas_alloc_slow_task(GFP_ATOMIC, pm8001_ha->sas);
 
 	if (!task) {
 		PM8001_FAIL_DBG(pm8001_ha,
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index b7cbc312843e..ac41a907447d 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -718,7 +718,7 @@ static int pm8001_exec_internal_tmf_task(struct domain_device *dev,
 	DECLARE_COMPLETION_ONSTACK(completion_setstate);
 
 	for (retry = 0; retry < 3; retry++) {
-		task = sas_alloc_slow_task(GFP_KERNEL);
+		task = sas_alloc_slow_task(GFP_KERNEL, pm8001_ha->sas);
 		if (!task)
 			return -ENOMEM;
 
@@ -805,7 +805,7 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
 	struct sas_task *task = NULL;
 
 	for (retry = 0; retry < 3; retry++) {
-		task = sas_alloc_slow_task(GFP_KERNEL);
+		task = sas_alloc_slow_task(GFP_KERNEL, pm8001_ha->sas);
 		if (!task)
 			return -ENOMEM;
 
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index d1d95f1a2c6a..e09e8d54f4f1 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1625,7 +1625,7 @@ static void pm80xx_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 		return;
 	}
 
-	task = sas_alloc_slow_task(GFP_ATOMIC);
+	task = sas_alloc_slow_task(GFP_ATOMIC, pm8001_ha->sas);
 
 	if (!task) {
 		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("cannot "
@@ -1676,7 +1676,7 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
 	struct inbound_queue_table *circularQ;
 	u32 opc = OPC_INB_SATA_HOST_OPSTART;
 
-	task = sas_alloc_slow_task(GFP_ATOMIC);
+	task = sas_alloc_slow_task(GFP_ATOMIC, pm8001_ha->sas);
 
 	if (!task) {
 		PM8001_FAIL_DBG(pm8001_ha,
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 4e2d61e8fb1e..25c0f0b94d27 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -608,6 +608,7 @@ struct sas_task_slow {
 	struct timer_list     timer;
 	struct completion     completion;
 	struct sas_task       *task;
+	struct scsi_cmnd      *scmd;
 };
 
 #define SAS_TASK_STATE_PENDING      1
@@ -617,7 +618,8 @@ struct sas_task_slow {
 #define SAS_TASK_AT_INITIATOR       16
 
 extern struct sas_task *sas_alloc_task(gfp_t flags);
-extern struct sas_task *sas_alloc_slow_task(gfp_t flags);
+extern struct sas_task *sas_alloc_slow_task(gfp_t flags,
+					    struct sas_ha_struct *sha);
 extern void sas_free_task(struct sas_task *task);
 
 struct sas_domain_function_template {
-- 
2.17.1

