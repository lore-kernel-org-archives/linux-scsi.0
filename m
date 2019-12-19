Return-Path: <SRS0=QEZ7=2J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 179DBC43603
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 12:39:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD431222C2
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 12:39:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfLSMjb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Dec 2019 07:39:31 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7720 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726695AbfLSMjb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Dec 2019 07:39:31 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 37A06C7F05F082D0DDA9;
        Thu, 19 Dec 2019 20:39:28 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Thu, 19 Dec 2019 20:39:18 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <yanaijie@huawei.com>, <chenxiang66@hisilicon.com>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v2] scsi: libsas: Tidy SAS address print format
Date:   Thu, 19 Dec 2019 20:35:57 +0800
Message-ID: <1576758957-227350-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently we use a mixture of %016llx, %llx, and %16llx when printing a
SAS address.

Since the most significant nibble of the SAS address is always 5 - as per
standard - this formatting is not so important; but some fake SAS
addresses for SATA devices may not be. And we have mangled/invalid
address to consider also. And it's better to be consistent in the code, so
use a fixed format.

The SAS address is a fixed size at 64b, so we want to 0 byte extend to 16
nibbles, so use %016llx globally.

Also make some prints to be explicitly hex, and tidy some whitespace issue.

Signed-off-by: John Garry <john.garry@huawei.com>
--
v2: reword commit message

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index e9e00740f7ca..c5a828a041e0 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -137,7 +137,7 @@ static void sas_ata_task_done(struct sas_task *task)
 	} else {
 		ac = sas_to_ata_err(stat);
 		if (ac) {
-			pr_warn("%s: SAS error %x\n", __func__, stat->stat);
+			pr_warn("%s: SAS error 0x%x\n", __func__, stat->stat);
 			/* We saw a SAS error. Send a vague error. */
 			if (!link->sactive) {
 				qc->err_mask = ac;
diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index f47b4b281b14..fef58185a644 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -170,7 +170,7 @@ int sas_notify_lldd_dev_found(struct domain_device *dev)
 
 	res = i->dft->lldd_dev_found(dev);
 	if (res) {
-		pr_warn("driver on host %s cannot handle device %llx, error:%d\n",
+		pr_warn("driver on host %s cannot handle device %016llx, error:%d\n",
 			dev_name(sas_ha->dev),
 			SAS_ADDR(dev->sas_addr), res);
 	}
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 9fdb9c9fbda4..ab671cdd4cfb 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -500,7 +500,7 @@ static int sas_ex_general(struct domain_device *dev)
 		ex_assign_report_general(dev, rg_resp);
 
 		if (dev->ex_dev.configuring) {
-			pr_debug("RG: ex %llx self-configuring...\n",
+			pr_debug("RG: ex %016llx self-configuring...\n",
 				 SAS_ADDR(dev->sas_addr));
 			schedule_timeout_interruptible(5*HZ);
 		} else
@@ -881,7 +881,7 @@ static struct domain_device *sas_ex_discover_end_dev(
 
 		res = sas_discover_end_dev(child);
 		if (res) {
-			pr_notice("sas_discover_end_dev() for device %16llx at %016llx:%02d returned 0x%x\n",
+			pr_notice("sas_discover_end_dev() for device %016llx at %016llx:%02d returned 0x%x\n",
 				  SAS_ADDR(child->sas_addr),
 				  SAS_ADDR(parent->sas_addr), phy_id, res);
 			goto out_list_del;
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 01f1738ce6df..1f1d01901978 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -107,7 +107,7 @@ static inline void sas_smp_host_handler(struct bsg_job *job,
 
 static inline void sas_fail_probe(struct domain_device *dev, const char *func, int err)
 {
-	pr_warn("%s: for %s device %16llx returned %d\n",
+	pr_warn("%s: for %s device %016llx returned %d\n",
 		func, dev->parent ? "exp-attached" :
 		"direct-attached",
 		SAS_ADDR(dev->sas_addr), err);
diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index 7c86fd248129..19cf418928fa 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -165,7 +165,7 @@ static void sas_form_port(struct asd_sas_phy *phy)
 	}
 	sas_port_add_phy(port->port, phy->phy);
 
-	pr_debug("%s added to %s, phy_mask:0x%x (%16llx)\n",
+	pr_debug("%s added to %s, phy_mask:0x%x (%016llx)\n",
 		 dev_name(&phy->phy->dev), dev_name(&port->port->dev),
 		 port->phy_mask,
 		 SAS_ADDR(port->attached_sas_addr));
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index bec83eb8ab87..9e0975e55c27 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -330,7 +330,7 @@ static int sas_recover_lu(struct domain_device *dev, struct scsi_cmnd *cmd)
 
 	int_to_scsilun(cmd->device->lun, &lun);
 
-	pr_notice("eh: device %llx LUN %llx has the task\n",
+	pr_notice("eh: device %016llx LUN 0x%llx has the task\n",
 		  SAS_ADDR(dev->sas_addr),
 		  cmd->device->lun);
 
@@ -615,7 +615,7 @@ static void sas_eh_handle_sas_errors(struct Scsi_Host *shost, struct list_head *
  reset:
 			tmf_resp = sas_recover_lu(task->dev, cmd);
 			if (tmf_resp == TMF_RESP_FUNC_COMPLETE) {
-				pr_notice("dev %016llx LU %llx is recovered\n",
+				pr_notice("dev %016llx LU 0x%llx is recovered\n",
 					  SAS_ADDR(task->dev),
 					  cmd->device->lun);
 				sas_eh_finish_cmd(cmd);
@@ -666,7 +666,7 @@ static void sas_eh_handle_sas_errors(struct Scsi_Host *shost, struct list_head *
 			 * of effort could recover from errors.  Quite
 			 * possibly the HA just disappeared.
 			 */
-			pr_err("error from  device %llx, LUN %llx couldn't be recovered in any way\n",
+			pr_err("error from device %016llx, LUN 0x%llx couldn't be recovered in any way\n",
 			       SAS_ADDR(task->dev->sas_addr),
 			       cmd->device->lun);
 
@@ -851,7 +851,7 @@ int sas_slave_configure(struct scsi_device *scsi_dev)
 	if (scsi_dev->tagged_supported) {
 		scsi_change_queue_depth(scsi_dev, SAS_DEF_QD);
 	} else {
-		pr_notice("device %llx, LUN %llx doesn't support TCQ\n",
+		pr_notice("device %016llx, LUN 0x%llx doesn't support TCQ\n",
 			  SAS_ADDR(dev->sas_addr), scsi_dev->lun);
 		scsi_change_queue_depth(scsi_dev, 1);
 	}
diff --git a/drivers/scsi/libsas/sas_task.c b/drivers/scsi/libsas/sas_task.c
index 1ded7d85027e..e2d42593ce52 100644
--- a/drivers/scsi/libsas/sas_task.c
+++ b/drivers/scsi/libsas/sas_task.c
@@ -27,7 +27,7 @@ void sas_ssp_task_response(struct device *dev, struct sas_task *task,
 		memcpy(tstat->buf, iu->sense_data, tstat->buf_valid_size);
 
 		if (iu->status != SAM_STAT_CHECK_CONDITION)
-			dev_warn(dev, "dev %llx sent sense data, but stat(%x) is not CHECK CONDITION\n",
+			dev_warn(dev, "dev %016llx sent sense data, but stat(0x%x) is not CHECK CONDITION\n",
 				 SAS_ADDR(task->dev->sas_addr), iu->status);
 	}
 	else
-- 
2.17.1

