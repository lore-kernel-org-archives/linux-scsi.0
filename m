Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 086C1C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 07:11:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E432B207ED
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 07:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgETHLO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 May 2020 03:11:14 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:41496 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726369AbgETHLO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 May 2020 03:11:14 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3ADEDEFA8291252DF4B1;
        Wed, 20 May 2020 15:11:12 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Wed, 20 May 2020 15:11:05 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <tj@kernel.org>, <martin.petersen@oracle.com>, <brking@us.ibm.com>,
        <john.garry@huawei.com>
CC:     <linux-ide@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linuxarm@huawei.com>, c00284940 <c00284940@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH] ata: libata: Remove unused parameter in function ata_sas_port_alloc()
Date:   Wed, 20 May 2020 15:07:22 +0800
Message-ID: <1589958442-70575-1-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: c00284940 <c00284940@huawei.com>

Input Parameter shost in function ata_sas_port_alloc() is not used, so
remove it.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/ata/libata-sata.c     | 4 +---
 drivers/scsi/ipr.c            | 2 +-
 drivers/scsi/libsas/sas_ata.c | 2 +-
 include/linux/libata.h        | 2 +-
 4 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index c16423e..a3c83fe 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1070,7 +1070,6 @@ EXPORT_SYMBOL_GPL(ata_scsi_change_queue_depth);
  *	port_alloc - Allocate port for a SAS attached SATA device
  *	@host: ATA host container for all SAS ports
  *	@port_info: Information from low-level host driver
- *	@shost: SCSI host that the scsi device is attached to
  *
  *	LOCKING:
  *	PCI/etc. bus probe sem.
@@ -1080,8 +1079,7 @@ EXPORT_SYMBOL_GPL(ata_scsi_change_queue_depth);
  */
 
 struct ata_port *ata_sas_port_alloc(struct ata_host *host,
-				    struct ata_port_info *port_info,
-				    struct Scsi_Host *shost)
+				    struct ata_port_info *port_info)
 {
 	struct ata_port *ap;
 
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 7d77997..331c41c 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4816,7 +4816,7 @@ static int ipr_target_alloc(struct scsi_target *starget)
 		if (!sata_port)
 			return -ENOMEM;
 
-		ap = ata_sas_port_alloc(&ioa_cfg->ata_host, &sata_port_info, shost);
+		ap = ata_sas_port_alloc(&ioa_cfg->ata_host, &sata_port_info);
 		if (ap) {
 			spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 			sata_port->ioa_cfg = ioa_cfg;
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 5d716d3..0cdfae9 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -549,7 +549,7 @@ int sas_ata_init(struct domain_device *found_dev)
 
 	ata_host_init(ata_host, ha->dev, &sas_sata_ops);
 
-	ap = ata_sas_port_alloc(ata_host, &sata_port_info, shost);
+	ap = ata_sas_port_alloc(ata_host, &sata_port_info);
 	if (!ap) {
 		pr_err("ata_sas_port_alloc failed.\n");
 		rc = -ENODEV;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 8bf5e59..5a6fb80 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1228,7 +1228,7 @@ extern int sata_link_scr_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 extern int ata_slave_link_init(struct ata_port *ap);
 extern void ata_sas_port_destroy(struct ata_port *);
 extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
-					   struct ata_port_info *, struct Scsi_Host *);
+					   struct ata_port_info *);
 extern void ata_sas_async_probe(struct ata_port *ap);
 extern int ata_sas_sync_probe(struct ata_port *ap);
 extern int ata_sas_port_init(struct ata_port *);
-- 
2.8.1

