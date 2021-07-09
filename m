Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A285C07E99
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 08:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 820B1613C7
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 08:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbhGIINv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 04:13:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55957 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231347AbhGIINu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 04:13:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625818267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hXmytCtIBRT+jdUWTLU3ov1fJoDR09oz6V0WpXtS98E=;
        b=aA/YuJIYqt04NufBlCDW1G65eXEMYryIGCPbs0b5FctqIM3n8g+V//sAGqfaYuQzcGdTu/
        Bt8voD86GhMqDHjlSB42V+DuIhqdW4ofTKbheJ9R8HaDO5n9eF8rxQKqNeGcKtDbirxE9v
        JPB14zgmklnC/sXI1mdVddVvJKYVzJo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155--4UUOZOFPY66i2jwlLzNhg-1; Fri, 09 Jul 2021 04:11:05 -0400
X-MC-Unique: -4UUOZOFPY66i2jwlLzNhg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C0591084F40;
        Fri,  9 Jul 2021 08:11:03 +0000 (UTC)
Received: from localhost (ovpn-13-13.pek2.redhat.com [10.72.13.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F9FF100EBAD;
        Fri,  9 Jul 2021 08:10:58 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>, Daniel Wagner <dwagner@suse.de>,
        Wen Xiong <wenxiong@us.ibm.com>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        Keith Busch <kbusch@kernel.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 04/10] scsi: replace blk_mq_pci_map_queues with blk_mq_dev_map_queues
Date:   Fri,  9 Jul 2021 16:09:59 +0800
Message-Id: <20210709081005.421340-5-ming.lei@redhat.com>
In-Reply-To: <20210709081005.421340-1-ming.lei@redhat.com>
References: <20210709081005.421340-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace blk_mq_pci_map_queues with blk_mq_dev_map_queues which is more
generic from blk-mq viewpoint, so we can unify all map queue via
blk_mq_dev_map_queues().

Meantime we can pass 'use_manage_irq' info to blk-mq via
blk_mq_dev_map_queues(), this info needn't be 100% accurate, and what
we need is that true has to be passed in if the hba really uses managed
irq.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c    | 21 ++++++++++-----------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    |  5 +++--
 drivers/scsi/megaraid/megaraid_sas_base.c |  4 +++-
 drivers/scsi/mpi3mr/mpi3mr_os.c           |  9 +++++----
 drivers/scsi/mpt3sas/mpt3sas_scsih.c      |  6 ++++--
 drivers/scsi/qla2xxx/qla_os.c             |  4 +++-
 drivers/scsi/scsi_priv.h                  |  9 +++++++++
 drivers/scsi/smartpqi/smartpqi_init.c     |  7 +++++--
 8 files changed, 42 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 49d2723ef34c..4d3a698e2e4c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3547,6 +3547,14 @@ static struct device_attribute *host_attrs_v2_hw[] = {
 	NULL
 };
 
+static inline const struct cpumask *hisi_hba_get_queue_affinity(
+		void *dev_data, int offset, int idx)
+{
+	struct hisi_hba *hba = dev_data;
+
+	return irq_get_affinity_mask(hba->irq_map[offset + idx]);
+}
+
 static int map_queues_v2_hw(struct Scsi_Host *shost)
 {
 	struct hisi_hba *hisi_hba = shost_priv(shost);
@@ -3554,17 +3562,8 @@ static int map_queues_v2_hw(struct Scsi_Host *shost)
 	const struct cpumask *mask;
 	unsigned int queue, cpu;
 
-	for (queue = 0; queue < qmap->nr_queues; queue++) {
-		mask = irq_get_affinity_mask(hisi_hba->irq_map[96 + queue]);
-		if (!mask)
-			continue;
-
-		for_each_cpu(cpu, mask)
-			qmap->mq_map[cpu] = qmap->queue_offset + queue;
-	}
-
-	return 0;
-
+	return blk_mq_dev_map_queues(qmap, hisi_hba, 96,
+			hisi_hba_get_queue_affinity, false, true);
 }
 
 static struct scsi_host_template sht_v2_hw = {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 5c3b1dfcb37c..f4370c43ba05 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3132,8 +3132,9 @@ static int hisi_sas_map_queues(struct Scsi_Host *shost)
 	struct hisi_hba *hisi_hba = shost_priv(shost);
 	struct blk_mq_queue_map *qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
 
-	return blk_mq_pci_map_queues(qmap, hisi_hba->pci_dev,
-				     BASE_VECTORS_V3_HW);
+	return blk_mq_dev_map_queues(qmap, hisi_hba->pci_dev,
+				     BASE_VECTORS_V3_HW,
+				     scsi_pci_get_queue_affinity, false, true);
 }
 
 static struct scsi_host_template sht_v3_hw = {
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index ec10b2497310..1bb3d522e305 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -47,6 +47,7 @@
 #include <scsi/scsi_dbg.h>
 #include "megaraid_sas_fusion.h"
 #include "megaraid_sas.h"
+#include "../scsi_priv.h"
 
 /*
  * Number of sectors per IO command
@@ -3185,7 +3186,8 @@ static int megasas_map_queues(struct Scsi_Host *shost)
 	map = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
 	map->nr_queues = instance->msix_vectors - offset;
 	map->queue_offset = 0;
-	blk_mq_pci_map_queues(map, instance->pdev, offset);
+	blk_mq_dev_map_queues(map, instance->pdev, offset,
+			scsi_pci_get_queue_affinity, false, true);
 	qoff += map->nr_queues;
 	offset += map->nr_queues;
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 40676155e62d..7eed125ec66b 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2787,17 +2787,18 @@ static int mpi3mr_bios_param(struct scsi_device *sdev,
  * mpi3mr_map_queues - Map queues callback handler
  * @shost: SCSI host reference
  *
- * Call the blk_mq_pci_map_queues with from which operational
+ * Call the blk_mq_dev_map_queues with from which operational
  * queue the mapping has to be done
  *
- * Return: return of blk_mq_pci_map_queues
+ * Return: return of blk_mq_dev_map_queues
  */
 static int mpi3mr_map_queues(struct Scsi_Host *shost)
 {
 	struct mpi3mr_ioc *mrioc = shost_priv(shost);
 
-	return blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
-	    mrioc->pdev, mrioc->op_reply_q_offset);
+	return blk_mq_dev_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
+	    mrioc->pdev, mrioc->op_reply_q_offset,
+	    scsi_pci_get_queue_affinity, false, true);
 }
 
 /**
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 866d118f7931..dded3cfa1115 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -57,6 +57,7 @@
 #include <linux/blk-mq-pci.h>
 #include <asm/unaligned.h>
 
+#include "../scsi_priv.h"
 #include "mpt3sas_base.h"
 
 #define RAID_CHANNEL 1
@@ -11784,8 +11785,9 @@ static int scsih_map_queues(struct Scsi_Host *shost)
 	if (ioc->shost->nr_hw_queues == 1)
 		return 0;
 
-	return blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
-	    ioc->pdev, ioc->high_iops_queues);
+	return blk_mq_dev_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
+	    ioc->pdev, ioc->high_iops_queues, scsi_pci_get_queue_affinity,
+	    false, true);
 }
 
 /* shost template for SAS 2.0 HBA devices */
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 4eab564ea6a0..dc8c27052382 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -21,6 +21,7 @@
 #include <scsi/scsi_transport_fc.h>
 
 #include "qla_target.h"
+#include "../scsi_priv.h"
 
 /*
  * Driver version
@@ -7696,7 +7697,8 @@ static int qla2xxx_map_queues(struct Scsi_Host *shost)
 	if (USER_CTRL_IRQ(vha->hw) || !vha->hw->mqiobase)
 		rc = blk_mq_map_queues(qmap);
 	else
-		rc = blk_mq_pci_map_queues(qmap, vha->hw->pdev, vha->irq_offset);
+		rc = blk_mq_dev_map_queues(qmap, vha->hw->pdev, vha->irq_offset,
+				scsi_pci_get_queue_affinity, false, true);
 	return rc;
 }
 
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 75d6f23e4fff..cc1bd9ce6e2c 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -6,6 +6,7 @@
 #include <linux/async.h>
 #include <scsi/scsi_device.h>
 #include <linux/sbitmap.h>
+#include <linux/pci.h>
 
 struct request_queue;
 struct request;
@@ -190,4 +191,12 @@ extern int scsi_device_max_queue_depth(struct scsi_device *sdev);
 
 #define SCSI_DEVICE_BLOCK_MAX_TIMEOUT	600	/* units in seconds */
 
+static inline const struct cpumask *scsi_pci_get_queue_affinity(
+		void *dev_data, int offset, int queue)
+{
+	struct pci_dev *pdev = dev_data;
+
+	return pci_irq_get_affinity(pdev, offset + queue);
+}
+
 #endif /* _SCSI_PRIV_H */
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index dcc0b9618a64..fd66260061c1 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -26,6 +26,7 @@
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_transport_sas.h>
 #include <asm/unaligned.h>
+#include "../scsi_priv.h"
 #include "smartpqi.h"
 #include "smartpqi_sis.h"
 
@@ -6104,8 +6105,10 @@ static int pqi_map_queues(struct Scsi_Host *shost)
 {
 	struct pqi_ctrl_info *ctrl_info = shost_to_hba(shost);
 
-	return blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
-					ctrl_info->pci_dev, 0);
+	return blk_mq_dev_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
+					ctrl_info->pci_dev, 0,
+					scsi_pci_get_queue_affinity, false,
+					true);
 }
 
 static int pqi_slave_configure(struct scsi_device *sdev)
-- 
2.31.1

