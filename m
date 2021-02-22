Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90133C433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 13:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CC4364DD0
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 13:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbhBVNcI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 08:32:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:47842 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231351AbhBVN3y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Feb 2021 08:29:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 807D6B0EA;
        Mon, 22 Feb 2021 13:24:16 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 26/31] scsi: libsas,hisi_sas,mvsas,pm8001: Allocate Scsi_cmd for slow task
Date:   Mon, 22 Feb 2021 14:24:00 +0100
Message-Id: <20210222132405.91369-27-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210222132405.91369-1-hare@suse.de>
References: <20210222132405.91369-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: John Garry <john.garry@huawei.com>

Allocate a Scsi_cmd for SAS slow tasks, so they can be accounted for in
the blk-mq layer.

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 56 ++++++++++++++++--------
 drivers/scsi/libsas/sas_expander.c    |  7 ++-
 drivers/scsi/libsas/sas_init.c        | 61 ++++++++++++++++++++++++---
 drivers/scsi/mvsas/mv_sas.c           |  5 ++-
 drivers/scsi/pm8001/pm8001_hwi.c      |  9 +++-
 drivers/scsi/pm8001/pm8001_sas.c      | 39 +++++++++++------
 drivers/scsi/pm8001/pm80xx_hwi.c      |  9 +++-
 include/scsi/libsas.h                 |  8 +++-
 8 files changed, 148 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index a979edfd9a78..6a69a90a1b82 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -15,6 +15,7 @@ static int hisi_sas_debug_issue_ssp_tmf(struct domain_device *device,
 static int
 hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
 			     struct domain_device *device,
+			     struct scsi_lun *lun,
 			     int abort_flag, int tag);
 static int hisi_sas_softreset_ata_disk(struct domain_device *device);
 static int hisi_sas_control_phy(struct asd_sas_phy *sas_phy, enum phy_func func,
@@ -1055,15 +1056,17 @@ static void hisi_sas_dev_gone(struct domain_device *device)
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
 	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
 	struct device *dev = hisi_hba->dev;
+	struct scsi_lun lun;
 	int ret = 0;
 
 	dev_info(dev, "dev[%d:%x] is gone\n",
 		 sas_dev->device_id, sas_dev->dev_type);
 
 	down(&hisi_hba->sem);
+	int_to_scsilun(0, &lun);
 	if (!test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags)) {
 		hisi_sas_internal_task_abort(hisi_hba, device,
-					     HISI_SAS_INT_ABT_DEV, 0);
+				&lun, HISI_SAS_INT_ABT_DEV, 0);
 
 		hisi_sas_dereg_device(hisi_hba, device);
 
@@ -1191,12 +1194,21 @@ static int hisi_sas_exec_internal_tmf_task(struct domain_device *device,
 {
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
 	struct hisi_hba *hisi_hba = sas_dev->hisi_hba;
+	struct sas_ha_struct *sha = &hisi_hba->sha;
 	struct device *dev = hisi_hba->dev;
 	struct sas_task *task;
 	int res, retry;
 
 	for (retry = 0; retry < TASK_RETRY; retry++) {
-		task = sas_alloc_slow_task(GFP_KERNEL);
+		struct scsilun lun;
+
+		int_to_scsilun(0, &lun);
+		if (!dev_is_sata) {
+			struct sas_ssp_task ssp_task = parameter;
+
+			memcpy(lun.scsi_lun, ssp_task.LUN, 8);
+		}
+		task = sas_alloc_slow_task(sha, device, &lun, GFP_KERNEL);
 		if (!task)
 			return -ENOMEM;
 
@@ -1494,7 +1506,9 @@ static void hisi_sas_terminate_stp_reject(struct hisi_hba *hisi_hba)
 {
 	struct device *dev = hisi_hba->dev;
 	int port_no, rc, i;
+	struct scsi_lun lun;
 
+	int_to_scsilun(0, &lun);
 	for (i = 0; i < HISI_SAS_MAX_DEVICES; i++) {
 		struct hisi_sas_device *sas_dev = &hisi_hba->devices[i];
 		struct domain_device *device = sas_dev->sas_device;
@@ -1503,7 +1517,7 @@ static void hisi_sas_terminate_stp_reject(struct hisi_hba *hisi_hba)
 			continue;
 
 		rc = hisi_sas_internal_task_abort(hisi_hba, device,
-						  HISI_SAS_INT_ABT_DEV, 0);
+				&lun, HISI_SAS_INT_ABT_DEV, 0);
 		if (rc < 0)
 			dev_err(dev, "STP reject: abort dev failed %d\n", rc);
 	}
@@ -1653,7 +1667,7 @@ static int hisi_sas_abort_task(struct sas_task *task)
 						  &tmf_task);
 
 		rc2 = hisi_sas_internal_task_abort(hisi_hba, device,
-						   HISI_SAS_INT_ABT_CMD, tag);
+				&lun, HISI_SAS_INT_ABT_CMD, tag);
 		if (rc2 < 0) {
 			dev_err(dev, "abort task: internal abort (%d)\n", rc2);
 			return TMF_RESP_FUNC_FAILED;
@@ -1673,9 +1687,9 @@ static int hisi_sas_abort_task(struct sas_task *task)
 	} else if (task->task_proto & SAS_PROTOCOL_SATA ||
 		task->task_proto & SAS_PROTOCOL_STP) {
 		if (task->dev->dev_type == SAS_SATA_DEV) {
+			int_to_scsilun(0, &lun);
 			rc = hisi_sas_internal_task_abort(hisi_hba, device,
-							  HISI_SAS_INT_ABT_DEV,
-							  0);
+					&lun, HISI_SAS_INT_ABT_DEV, 0);
 			if (rc < 0) {
 				dev_err(dev, "abort task: internal abort failed\n");
 				goto out;
@@ -1689,8 +1703,9 @@ static int hisi_sas_abort_task(struct sas_task *task)
 		u32 tag = slot->idx;
 		struct hisi_sas_cq *cq = &hisi_hba->cq[slot->dlvry_queue];
 
+		int_to_scsilun(0, &lun);
 		rc = hisi_sas_internal_task_abort(hisi_hba, device,
-						  HISI_SAS_INT_ABT_CMD, tag);
+				&lun, HISI_SAS_INT_ABT_CMD, tag);
 		if (((rc < 0) || (rc == TMF_RESP_FUNC_FAILED)) &&
 					task->lldd_task) {
 			/*
@@ -1716,7 +1731,7 @@ static int hisi_sas_abort_task_set(struct domain_device *device, u8 *lun)
 	int rc;
 
 	rc = hisi_sas_internal_task_abort(hisi_hba, device,
-					  HISI_SAS_INT_ABT_DEV, 0);
+			(struct scsi_lun *)lun, HISI_SAS_INT_ABT_DEV, 0);
 	if (rc < 0) {
 		dev_err(dev, "abort task set: internal abort rc=%d\n", rc);
 		return TMF_RESP_FUNC_FAILED;
@@ -1804,10 +1819,12 @@ static int hisi_sas_I_T_nexus_reset(struct domain_device *device)
 {
 	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
 	struct device *dev = hisi_hba->dev;
+	struct scsi_lun lun;
 	int rc;
 
+	int_to_scsilun(0, &lun);
 	rc = hisi_sas_internal_task_abort(hisi_hba, device,
-					  HISI_SAS_INT_ABT_DEV, 0);
+			&lun, HISI_SAS_INT_ABT_DEV, 0);
 	if (rc < 0) {
 		dev_err(dev, "I_T nexus reset: internal abort (%d)\n", rc);
 		return TMF_RESP_FUNC_FAILED;
@@ -1837,7 +1854,7 @@ static int hisi_sas_lu_reset(struct domain_device *device, u8 *lun)
 
 	/* Clear internal IO and then lu reset */
 	rc = hisi_sas_internal_task_abort(hisi_hba, device,
-					  HISI_SAS_INT_ABT_DEV, 0);
+			(struct scsi_lun *)lun, HISI_SAS_INT_ABT_DEV, 0);
 	if (rc < 0) {
 		dev_err(dev, "lu_reset: internal abort failed\n");
 		goto out;
@@ -2018,6 +2035,7 @@ hisi_sas_internal_abort_task_exec(struct hisi_hba *hisi_hba, int device_id,
  * abort command for single IO command or a device
  * @hisi_hba: host controller struct
  * @device: domain device
+ * @lun: logical unit number
  * @abort_flag: mode of operation, device or single IO
  * @tag: tag of IO to be aborted (only relevant to single
  *       IO mode)
@@ -2025,12 +2043,15 @@ hisi_sas_internal_abort_task_exec(struct hisi_hba *hisi_hba, int device_id,
  */
 static int
 _hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
-			      struct domain_device *device, int abort_flag,
-			      int tag, struct hisi_sas_dq *dq)
+			      struct domain_device *device,
+			      struct scsi_lun *lun,
+			      int abort_flag, int tag,
+			      struct hisi_sas_dq *dq)
 {
-	struct sas_task *task;
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
+	struct sas_ha_struct *sha = &hisi_hba->sha;
 	struct device *dev = hisi_hba->dev;
+	struct sas_task *task;
 	int res;
 
 	/*
@@ -2042,7 +2063,8 @@ _hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
 	if (!hisi_hba->hw->prep_abort)
 		return TMF_RESP_FUNC_FAILED;
 
-	task = sas_alloc_slow_task(GFP_KERNEL);
+	task = sas_alloc_slow_task(sha, device,
+				   (struct scsi_lun *)lun, GFP_KERNEL);
 	if (!task)
 		return -ENOMEM;
 
@@ -2115,6 +2137,7 @@ _hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
 static int
 hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
 			     struct domain_device *device,
+			     struct scsi_lun *lun,
 			     int abort_flag, int tag)
 {
 	struct hisi_sas_slot *slot;
@@ -2127,7 +2150,7 @@ hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
 		slot = &hisi_hba->slot_info[tag];
 		dq = &hisi_hba->dq[slot->dlvry_queue];
 		return _hisi_sas_internal_task_abort(hisi_hba, device,
-						     abort_flag, tag, dq);
+				lun, abort_flag, tag, dq);
 	case HISI_SAS_INT_ABT_DEV:
 		for (i = 0; i < hisi_hba->cq_nvecs; i++) {
 			struct hisi_sas_cq *cq = &hisi_hba->cq[i];
@@ -2137,8 +2160,7 @@ hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
 				continue;
 			dq = &hisi_hba->dq[i];
 			rc = _hisi_sas_internal_task_abort(hisi_hba, device,
-							   abort_flag, tag,
-							   dq);
+					lun, abort_flag, tag, dq);
 			if (rc)
 				return rc;
 		}
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 8d6bcc19359f..9e4a7c85a037 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -56,9 +56,12 @@ static int smp_execute_task_sg(struct domain_device *dev,
 {
 	int res, retry;
 	struct sas_task *task = NULL;
+	struct sas_ha_struct *ha = dev->port->ha;
 	struct sas_internal *i =
-		to_sas_internal(dev->port->ha->core.shost->transportt);
+		to_sas_internal(ha->core.shost->transportt);
+	struct scsi_lun lun;
 
+	int_to_scsilun(0, &lun);
 	mutex_lock(&dev->ex_dev.cmd_mutex);
 	for (retry = 0; retry < 3; retry++) {
 		if (test_bit(SAS_DEV_GONE, &dev->state)) {
@@ -66,7 +69,7 @@ static int smp_execute_task_sg(struct domain_device *dev,
 			break;
 		}
 
-		task = sas_alloc_slow_task(GFP_KERNEL);
+		task = sas_alloc_slow_task(ha, dev, &lun, GFP_KERNEL);
 		if (!task) {
 			res = -ENOMEM;
 			break;
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 2b0f98ca6ec3..9d0448b76a2f 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -14,6 +14,7 @@
 #include <scsi/sas_ata.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
+#include <scsi/scsi_tcq.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_sas.h>
 
@@ -37,16 +38,36 @@ struct sas_task *sas_alloc_task(gfp_t flags)
 }
 EXPORT_SYMBOL_GPL(sas_alloc_task);
 
-struct sas_task *sas_alloc_slow_task(gfp_t flags)
+struct sas_task *sas_alloc_slow_task(struct sas_ha_struct *ha,
+				     struct domain_device *dev,
+				     struct scsi_lun *lun, gfp_t flags)
 {
 	struct sas_task *task = sas_alloc_task(flags);
-	struct sas_task_slow *slow = kmalloc(sizeof(*slow), flags);
+	struct Scsi_Host *shost = ha->core.shost;
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
+	if (shost->nr_reserved_cmds) {
+		struct scsi_device *sdev;
+
+		if (dev && dev->starget) {
+			sdev = scsi_device_lookup_by_target(dev->starget,
+						    scsilun_to_int(lun));
+			if (!sdev)
+				goto out_err_scmd;
+		} else
+			sdev = ha->core.shost_dev;
+		slow->scmd = scsi_get_internal_cmd(sdev, DMA_BIDIRECTIONAL,
+						   REQ_NOWAIT);
+		if (!slow->scmd)
+			goto out_err_scmd;
+		ASSIGN_SAS_TASK(slow->scmd, task);
 	}
 
 	task->slow_task = slow;
@@ -55,13 +76,31 @@ struct sas_task *sas_alloc_slow_task(gfp_t flags)
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
+			struct scsi_cmnd *scmd = task->slow_task->scmd;
+
+			if (scmd) {
+				ASSIGN_SAS_TASK(scmd, NULL);
+				scsi_put_internal_cmd(scmd);
+			}
+			kfree(task->slow_task);
+		}
 		kmem_cache_free(sas_task_cache, task);
 	}
 }
@@ -95,6 +134,7 @@ void sas_hash_addr(u8 *hashed, const u8 *sas_addr)
 
 int sas_register_ha(struct sas_ha_struct *sas_ha)
 {
+	struct Scsi_Host *shost = sas_ha->core.shost;
 	char name[64];
 	int error = 0;
 
@@ -111,6 +151,13 @@ int sas_register_ha(struct sas_ha_struct *sas_ha)
 
 	sas_ha->event_thres = SAS_PHY_SHUTDOWN_THRES;
 
+	if (shost->nr_reserved_cmds) {
+		sas_ha->core.shost_dev = scsi_get_host_dev(shost);
+		if (!sas_ha->core.shost_dev) {
+			pr_notice("couldn't register sas host device\n");
+			return -ENOMEM;
+		}
+	}
 	error = sas_register_phys(sas_ha);
 	if (error) {
 		pr_notice("couldn't register sas phys:%d\n", error);
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 543b435f4c8c..99bdb88b3e86 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1278,13 +1278,16 @@ static int mvs_exec_internal_tmf_task(struct domain_device *dev,
 				      u8 *lun, struct mvs_tmf_task *tmf)
 {
 	int res, retry;
+	struct sas_ha_struct *ha = dev->port->ha;
 	struct sas_task *task = NULL;
+	struct scsi_lun scsilun;
 
 	if (!(dev->tproto & SAS_PROTOCOL_SSP))
 		return TMF_RESP_FUNC_ESUPP;
 
+	memcpy(scsilun.scsi_lun, lun, 8);
 	for (retry = 0; retry < 3; retry++) {
-		task = sas_alloc_slow_task(GFP_KERNEL);
+		task = sas_alloc_slow_task(ha, dev, &scsilun, GFP_KERNEL);
 		if (!task)
 			return -ENOMEM;
 
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 3998fcd69acb..105962b0c815 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1701,6 +1701,7 @@ static void pm8001_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 	struct task_abort_req task_abort;
 	struct inbound_queue_table *circularQ;
 	u32 opc = OPC_INB_SATA_ABORT;
+	struct scsi_lun lun;
 	int ret;
 
 	if (!pm8001_ha_dev) {
@@ -1708,7 +1709,9 @@ static void pm8001_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 		return;
 	}
 
-	task = sas_alloc_slow_task(GFP_ATOMIC);
+	int_to_scsilun(0, &lun);
+	task = sas_alloc_slow_task(pm8001_ha->sas, pm8001_ha_dev->sas_device,
+				   &lun, GFP_ATOMIC);
 
 	if (!task) {
 		pm8001_dbg(pm8001_ha, FAIL, "cannot allocate task\n");
@@ -1752,8 +1755,10 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
 	struct domain_device *dev = pm8001_ha_dev->sas_device;
 	struct inbound_queue_table *circularQ;
 	u32 opc = OPC_INB_SATA_HOST_OPSTART;
+	struct scsi_lun lun;;
 
-	task = sas_alloc_slow_task(GFP_ATOMIC);
+	int_to_scsilun(0, &lun);
+	task = sas_alloc_slow_task(pm8001_ha->sas, dev, &lun, GFP_ATOMIC);
 
 	if (!task) {
 		pm8001_dbg(pm8001_ha, FAIL, "cannot allocate task !!!\n");
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 01e91347eb41..b1f12d671611 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -717,7 +717,9 @@ static int pm8001_exec_internal_tmf_task(struct domain_device *dev,
 		return TMF_RESP_FUNC_ESUPP;
 
 	for (retry = 0; retry < 3; retry++) {
-		task = sas_alloc_slow_task(GFP_KERNEL);
+		task = sas_alloc_slow_task(pm8001_ha->sas,
+					   pm8001_dev->sas_device,
+					   (struct scsi_lun *)lun, GFP_KERNEL);
 		if (!task)
 			return -ENOMEM;
 
@@ -791,7 +793,7 @@ static int pm8001_exec_internal_tmf_task(struct domain_device *dev,
 
 static int
 pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
-	struct pm8001_device *pm8001_dev, u32 flag,
+	struct pm8001_device *pm8001_dev, u8 *lun, u32 flag,
 	u32 task_tag)
 {
 	struct domain_device *dev = pm8001_dev->sas_device;
@@ -801,7 +803,8 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
 	struct sas_task *task = NULL;
 
 	for (retry = 0; retry < 3; retry++) {
-		task = sas_alloc_slow_task(GFP_KERNEL);
+		task = sas_alloc_slow_task(pm8001_ha->sas, dev,
+					   (struct scsi_lun *)lun, GFP_KERNEL);
 		if (!task)
 			return -ENOMEM;
 
@@ -875,13 +878,15 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 	spin_lock_irqsave(&pm8001_ha->lock, flags);
 	if (pm8001_dev) {
 		u32 device_id = pm8001_dev->device_id;
+		struct scsi_lun lun;
 
+		int_to_scsilun(0, &lun);
 		pm8001_dbg(pm8001_ha, DISC, "found dev[%d:%x] is gone.\n",
 			   pm8001_dev->device_id, pm8001_dev->dev_type);
 		if (atomic_read(&pm8001_dev->running_req)) {
 			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 			pm8001_exec_internal_task_abort(pm8001_ha,
-				pm8001_dev, 1, 0);
+				pm8001_dev, lun.scsi_lun, 1, 0);
 			while (atomic_read(&pm8001_dev->running_req))
 				msleep(20);
 			spin_lock_irqsave(&pm8001_ha->lock, flags);
@@ -991,6 +996,9 @@ int pm8001_I_T_nexus_reset(struct domain_device *dev)
 	phy = sas_get_local_phy(dev);
 
 	if (dev_is_sata(dev)) {
+		struct scsi_lun lun;
+
+		int_to_scsilun(0, &lun);
 		if (scsi_is_sas_phy_local(phy)) {
 			rc = 0;
 			goto out;
@@ -1005,7 +1013,7 @@ int pm8001_I_T_nexus_reset(struct domain_device *dev)
 		}
 		msleep(2000);
 		rc = pm8001_exec_internal_task_abort(pm8001_ha,
-			pm8001_dev, 1, 0);
+			pm8001_dev, lun.scsi_lun, 1, 0);
 		if (rc) {
 			pm8001_dbg(pm8001_ha, EH, "task abort failed %x\n"
 				   "with rc %d\n", pm8001_dev->device_id, rc);
@@ -1032,7 +1040,9 @@ int pm8001_I_T_nexus_event_handler(struct domain_device *dev)
 	struct pm8001_device *pm8001_dev;
 	struct pm8001_hba_info *pm8001_ha;
 	struct sas_phy *phy;
+	struct scsi_lun lun;
 
+	int_to_scsilun(0, &lun);
 	if (!dev || !dev->lldd_dev)
 		return -1;
 
@@ -1051,7 +1061,7 @@ int pm8001_I_T_nexus_event_handler(struct domain_device *dev)
 		}
 		/* send internal ssp/sata/smp abort command to FW */
 		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev,
-						     1, 0);
+						     lun.scsi_lun, 1, 0);
 		msleep(100);
 
 		/* deregister the target device */
@@ -1067,7 +1077,7 @@ int pm8001_I_T_nexus_event_handler(struct domain_device *dev)
 	} else {
 		/* send internal ssp/sata/smp abort command to FW */
 		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev,
-						     1, 0);
+						     lun.scsi_lun, 1, 0);
 		msleep(100);
 
 		/* deregister the target device */
@@ -1095,8 +1105,8 @@ int pm8001_lu_reset(struct domain_device *dev, u8 *lun)
 	DECLARE_COMPLETION_ONSTACK(completion_setstate);
 	if (dev_is_sata(dev)) {
 		struct sas_phy *phy = sas_get_local_phy(dev);
-		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev,
-			1, 0);
+		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,
+			lun, 1, 0);
 		rc = sas_phy_reset(phy, 1);
 		sas_put_local_phy(phy);
 		pm8001_dev->setds_completion = &completion_setstate;
@@ -1211,9 +1221,10 @@ int pm8001_abort_task(struct sas_task *task)
 						   &tmf_task);
 		if (rc == TMF_RESP_FUNC_SUCC)
 			pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev,
-				0, tag);
+				lun.scsi_lun, 0, tag);
 	} else if (task->task_proto & SAS_PROTOCOL_SATA ||
 		task->task_proto & SAS_PROTOCOL_STP) {
+		memset(lun.scsi_lun, 0, sizeof(lun.scsi_lun));
 		if (pm8001_ha->chip_id == chip_8006) {
 			DECLARE_COMPLETION_ONSTACK(completion_reset);
 			DECLARE_COMPLETION_ONSTACK(completion);
@@ -1280,7 +1291,7 @@ int pm8001_abort_task(struct sas_task *task)
 			 * going to free the task.
 			 */
 			ret = pm8001_exec_internal_task_abort(pm8001_ha,
-				pm8001_dev, 1, tag);
+				pm8001_dev, lun.scsi_lun, 1, tag);
 			if (ret)
 				goto out;
 			ret = wait_for_completion_timeout(
@@ -1297,13 +1308,15 @@ int pm8001_abort_task(struct sas_task *task)
 			wait_for_completion(&completion);
 		} else {
 			rc = pm8001_exec_internal_task_abort(pm8001_ha,
-				pm8001_dev, 0, tag);
+				pm8001_dev, lun.scsi_lun, 0, tag);
 		}
 		rc = TMF_RESP_FUNC_COMPLETE;
 	} else if (task->task_proto & SAS_PROTOCOL_SMP) {
 		/* SMP */
+
+		int_to_scsilun(0, &lun);
 		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev,
-			0, tag);
+			lun.scsi_lun, 0, tag);
 
 	}
 out:
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index bc1929b230c4..03bfb4d72895 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1772,6 +1772,7 @@ static void pm80xx_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 	struct task_abort_req task_abort;
 	struct inbound_queue_table *circularQ;
 	u32 opc = OPC_INB_SATA_ABORT;
+	struct scsi_lun lun;
 	int ret;
 
 	if (!pm8001_ha_dev) {
@@ -1779,7 +1780,9 @@ static void pm80xx_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 		return;
 	}
 
-	task = sas_alloc_slow_task(GFP_ATOMIC);
+	int_to_scsilun(0, &lun);
+	task = sas_alloc_slow_task(pm8001_ha->sas,pm8001_ha_dev->sas_device,
+				   &lun, GFP_ATOMIC);
 
 	if (!task) {
 		pm8001_dbg(pm8001_ha, FAIL, "cannot allocate task\n");
@@ -1827,8 +1830,10 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
 	struct domain_device *dev = pm8001_ha_dev->sas_device;
 	struct inbound_queue_table *circularQ;
 	u32 opc = OPC_INB_SATA_HOST_OPSTART;
+	struct scsi_lun lun;
 
-	task = sas_alloc_slow_task(GFP_ATOMIC);
+	int_to_scsilun(0, &lun);
+	task = sas_alloc_slow_task(pm8001_ha->sas, dev, &lun, GFP_ATOMIC);
 
 	if (!task) {
 		pm8001_dbg(pm8001_ha, FAIL, "cannot allocate task !!!\n");
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 3a024eced38c..9b8c06a8329a 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -349,7 +349,7 @@ struct asd_sas_phy {
 
 struct scsi_core {
 	struct Scsi_Host *shost;
-
+	struct scsi_device *shost_dev;
 };
 
 enum sas_ha_state {
@@ -605,6 +605,7 @@ struct sas_task_slow {
 	struct timer_list     timer;
 	struct completion     completion;
 	struct sas_task       *task;
+	struct scsi_cmnd      *scmd;
 };
 
 #define SAS_TASK_STATE_PENDING      1
@@ -614,7 +615,10 @@ struct sas_task_slow {
 #define SAS_TASK_AT_INITIATOR       16
 
 extern struct sas_task *sas_alloc_task(gfp_t flags);
-extern struct sas_task *sas_alloc_slow_task(gfp_t flags);
+extern struct sas_task *sas_alloc_slow_task(struct sas_ha_struct *ha,
+					    struct domain_device *dev,
+					    struct scsi_lun *lun,
+					    gfp_t flags);
 extern void sas_free_task(struct sas_task *task);
 
 struct sas_domain_function_template {
-- 
2.29.2

