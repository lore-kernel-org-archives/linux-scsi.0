Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F44ECCA47E
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jun 2022 10:38:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243296AbiFIKiH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jun 2022 06:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243062AbiFIKhM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jun 2022 06:37:12 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59AD2178B4;
        Thu,  9 Jun 2022 03:36:47 -0700 (PDT)
Received: from fraeml705-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LJgTr1tZMz67cT1;
        Thu,  9 Jun 2022 18:35:28 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml705-chm.china.huawei.com (10.206.15.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Thu, 9 Jun 2022 12:36:45 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 9 Jun 2022 11:36:42 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <damien.lemoal@opensource.wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <brking@us.ibm.com>, <hare@suse.de>, <hch@lst.de>
CC:     <linux-block@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
Subject: [PATCH RFC v2 15/18] scsi: libsas: Queue TMF commands as requests
Date:   Thu, 9 Jun 2022 18:29:16 +0800
Message-ID: <1654770559-101375-16-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1654770559-101375-1-git-send-email-john.garry@huawei.com>
References: <1654770559-101375-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Like what we did with SMP commands, send TMF commands through the block
layer.

In future we can now also take advantage of the block layer request
timeout handling.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/libsas/sas_scsi_host.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index f0566f4512b2..520c301e4319 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -1059,18 +1059,27 @@ int sas_execute_tmf(struct domain_device *device, void *parameter,
 	struct sas_task *task;
 	struct sas_internal *i =
 		to_sas_internal(device->port->ha->core.shost->transportt);
-	struct sas_ha_struct *ha = device->port->ha;
 	int res, retry;
-
+	struct request *rq;
+	struct sas_ha_struct *ha = device->port->ha;
 
 	for (retry = 0; retry < TASK_RETRY; retry++) {
+		struct scsi_cmnd *scmd;
+
 		task = sas_alloc_slow_task(ha, GFP_KERNEL);
-		if (!task)
-			return -ENOMEM;
+		if (!task) {
+			res = -ENOMEM;
+			break;
+		}
 
 		task->dev = device;
 		task->task_proto = device->tproto;
 
+		rq = sas_rq_from_task(task);
+
+		scmd = blk_mq_rq_to_pdu(rq);
+		ASSIGN_SAS_TASK(scmd, task);
+
 		if (dev_is_sata(device)) {
 			task->ata_task.device_control_reg_update = 1;
 			if (force_phy_id >= 0) {
@@ -1082,20 +1091,15 @@ int sas_execute_tmf(struct domain_device *device, void *parameter,
 			memcpy(&task->ssp_task, parameter, para_len);
 		}
 
-		task->task_done = sas_task_internal_done;
+		task->task_done = sas_task_complete_internal;
 		task->tmf = tmf;
 
 		task->slow_task->timer.function = sas_task_internal_timedout;
 		task->slow_task->timer.expires = jiffies + TASK_TIMEOUT;
 		add_timer(&task->slow_task->timer);
 
-		res = i->dft->lldd_execute_task(task, GFP_KERNEL);
-		if (res) {
-			del_timer_sync(&task->slow_task->timer);
-			pr_err("executing TMF task failed %016llx (%d)\n",
-			       SAS_ADDR(device->sas_addr), res);
-			break;
-		}
+		rq->end_io = sas_blk_end_sync_rq;
+		blk_execute_rq_nowait(rq, true);
 
 		wait_for_completion(&task->slow_task->completion);
 
-- 
2.26.2

