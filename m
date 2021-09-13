Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D667C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 10:56:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AF7E61004
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 10:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239002AbhIMK5j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 06:57:39 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3771 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238366AbhIMK5i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Sep 2021 06:57:38 -0400
Received: from fraeml742-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H7NdQ73Yvz6H6kW;
        Mon, 13 Sep 2021 18:54:02 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml742-chm.china.huawei.com (10.206.15.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 13 Sep 2021 12:56:20 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 13 Sep 2021 11:56:18 +0100
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, John Garry <john.garry@huawei.com>
Subject: [PATCH v2] scsi: libsas: co-locate exports with symbols
Date:   Mon, 13 Sep 2021 18:51:36 +0800
Message-ID: <1631530296-32358-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It is standard practice to co-locate export declarations with the symbol
which is being exported. Or at least in the same file - see
sas_phy_reset().

Modify libsas to follow this practice consistently.

Signed-off-by: John Garry <john.garry@huawei.com>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
---
Changes since v1:
- Add RB tag from Jason (thanks!)

diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 80592f53017a..37cc92837fdf 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -147,6 +147,7 @@ int sas_register_ha(struct sas_ha_struct *sas_ha)
 
 	return error;
 }
+EXPORT_SYMBOL_GPL(sas_register_ha);
 
 static void sas_disable_events(struct sas_ha_struct *sas_ha)
 {
@@ -176,6 +177,7 @@ int sas_unregister_ha(struct sas_ha_struct *sas_ha)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(sas_unregister_ha);
 
 static int sas_get_linkerrors(struct sas_phy *phy)
 {
@@ -313,6 +315,7 @@ int sas_phy_reset(struct sas_phy *phy, int hard_reset)
 	}
 	return ret;
 }
+EXPORT_SYMBOL_GPL(sas_phy_reset);
 
 int sas_set_phy_speed(struct sas_phy *phy,
 		      struct sas_phy_linkrates *rates)
@@ -659,5 +662,3 @@ MODULE_LICENSE("GPL v2");
 module_init(sas_class_init);
 module_exit(sas_class_exit);
 
-EXPORT_SYMBOL_GPL(sas_register_ha);
-EXPORT_SYMBOL_GPL(sas_unregister_ha);
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 08ffb8788290..2bf37151623e 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -201,6 +201,7 @@ int sas_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	cmd->scsi_done(cmd);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(sas_queuecommand);
 
 static void sas_eh_finish_cmd(struct scsi_cmnd *cmd)
 {
@@ -511,6 +512,7 @@ int sas_eh_device_reset_handler(struct scsi_cmnd *cmd)
 
 	return FAILED;
 }
+EXPORT_SYMBOL_GPL(sas_eh_device_reset_handler);
 
 int sas_eh_target_reset_handler(struct scsi_cmnd *cmd)
 {
@@ -532,6 +534,7 @@ int sas_eh_target_reset_handler(struct scsi_cmnd *cmd)
 
 	return FAILED;
 }
+EXPORT_SYMBOL_GPL(sas_eh_target_reset_handler);
 
 /* Try to reset a device */
 static int try_to_reset_cmd_device(struct scsi_cmnd *cmd)
@@ -790,6 +793,7 @@ int sas_ioctl(struct scsi_device *sdev, unsigned int cmd, void __user *arg)
 
 	return -EINVAL;
 }
+EXPORT_SYMBOL_GPL(sas_ioctl);
 
 struct domain_device *sas_find_dev_by_rphy(struct sas_rphy *rphy)
 {
@@ -832,6 +836,7 @@ int sas_target_alloc(struct scsi_target *starget)
 	starget->hostdata = found_dev;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(sas_target_alloc);
 
 #define SAS_DEF_QD 256
 
@@ -860,6 +865,7 @@ int sas_slave_configure(struct scsi_device *scsi_dev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(sas_slave_configure);
 
 int sas_change_queue_depth(struct scsi_device *sdev, int depth)
 {
@@ -872,6 +878,7 @@ int sas_change_queue_depth(struct scsi_device *sdev, int depth)
 		depth = 1;
 	return scsi_change_queue_depth(sdev, depth);
 }
+EXPORT_SYMBOL_GPL(sas_change_queue_depth);
 
 int sas_bios_param(struct scsi_device *scsi_dev,
 			  struct block_device *bdev,
@@ -884,6 +891,7 @@ int sas_bios_param(struct scsi_device *scsi_dev,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(sas_bios_param);
 
 /*
  * Tell an upper layer that it needs to initiate an abort for a given task.
@@ -910,6 +918,7 @@ void sas_task_abort(struct sas_task *task)
 	else
 		blk_abort_request(scsi_cmd_to_rq(sc));
 }
+EXPORT_SYMBOL_GPL(sas_task_abort);
 
 int sas_slave_alloc(struct scsi_device *sdev)
 {
@@ -918,6 +927,7 @@ int sas_slave_alloc(struct scsi_device *sdev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(sas_slave_alloc);
 
 void sas_target_destroy(struct scsi_target *starget)
 {
@@ -929,6 +939,7 @@ void sas_target_destroy(struct scsi_target *starget)
 	starget->hostdata = NULL;
 	sas_put_device(found_dev);
 }
+EXPORT_SYMBOL_GPL(sas_target_destroy);
 
 #define SAS_STRING_ADDR_SIZE	16
 
@@ -956,15 +967,3 @@ int sas_request_addr(struct Scsi_Host *shost, u8 *addr)
 }
 EXPORT_SYMBOL_GPL(sas_request_addr);
 
-EXPORT_SYMBOL_GPL(sas_queuecommand);
-EXPORT_SYMBOL_GPL(sas_target_alloc);
-EXPORT_SYMBOL_GPL(sas_slave_configure);
-EXPORT_SYMBOL_GPL(sas_change_queue_depth);
-EXPORT_SYMBOL_GPL(sas_bios_param);
-EXPORT_SYMBOL_GPL(sas_task_abort);
-EXPORT_SYMBOL_GPL(sas_phy_reset);
-EXPORT_SYMBOL_GPL(sas_eh_device_reset_handler);
-EXPORT_SYMBOL_GPL(sas_eh_target_reset_handler);
-EXPORT_SYMBOL_GPL(sas_slave_alloc);
-EXPORT_SYMBOL_GPL(sas_target_destroy);
-EXPORT_SYMBOL_GPL(sas_ioctl);
-- 
2.26.2

