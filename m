Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FA26C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 13:30:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33CD064E5C
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 13:30:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbhBVNac (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 08:30:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:47788 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231274AbhBVN2S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Feb 2021 08:28:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 643F8B02E;
        Mon, 22 Feb 2021 13:24:16 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 24/31] pm8001: use libsas-provided domain devices for SATA
Date:   Mon, 22 Feb 2021 14:23:58 +0100
Message-Id: <20210222132405.91369-25-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210222132405.91369-1-hare@suse.de>
References: <20210222132405.91369-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pm8001 driver assumes that libsas does not provide any domain
devices for SATA, which is actually not true.
So use the libsas-provided domain devices for SATA and don't
allocate private ones.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 14 +-------------
 drivers/scsi/pm8001/pm80xx_hwi.c | 15 +--------------
 2 files changed, 2 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 49bf2f70a470..3998fcd69acb 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1749,7 +1749,7 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
 	struct pm8001_ccb_info *ccb;
 	struct sas_task *task = NULL;
 	struct host_to_dev_fis fis;
-	struct domain_device *dev;
+	struct domain_device *dev = pm8001_ha_dev->sas_device;
 	struct inbound_queue_table *circularQ;
 	u32 opc = OPC_INB_SATA_HOST_OPSTART;
 
@@ -1768,17 +1768,6 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
 		return;
 	}
 
-	/* allocate domain device by ourselves as libsas
-	 * is not going to provide any
-	*/
-	dev = kzalloc(sizeof(struct domain_device), GFP_ATOMIC);
-	if (!dev) {
-		sas_free_task(task);
-		pm8001_tag_free(pm8001_ha, ccb_tag);
-		pm8001_dbg(pm8001_ha, FAIL,
-			   "Domain device cannot be allocated\n");
-		return;
-	}
 	task->dev = dev;
 	task->dev->lldd_dev = pm8001_ha_dev;
 
@@ -1810,7 +1799,6 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
 	if (res) {
 		sas_free_task(task);
 		pm8001_tag_free(pm8001_ha, ccb_tag);
-		kfree(dev);
 	}
 }
 
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 84315560e8e1..bc1929b230c4 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1824,7 +1824,7 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
 	struct pm8001_ccb_info *ccb;
 	struct sas_task *task = NULL;
 	struct host_to_dev_fis fis;
-	struct domain_device *dev;
+	struct domain_device *dev = pm8001_ha_dev->sas_device;
 	struct inbound_queue_table *circularQ;
 	u32 opc = OPC_INB_SATA_HOST_OPSTART;
 
@@ -1843,18 +1843,6 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
 		return;
 	}
 
-	/* allocate domain device by ourselves as libsas
-	 * is not going to provide any
-	*/
-	dev = kzalloc(sizeof(struct domain_device), GFP_ATOMIC);
-	if (!dev) {
-		sas_free_task(task);
-		pm8001_tag_free(pm8001_ha, ccb_tag);
-		pm8001_dbg(pm8001_ha, FAIL,
-			   "Domain device cannot be allocated\n");
-		return;
-	}
-
 	task->dev = dev;
 	task->dev->lldd_dev = pm8001_ha_dev;
 
@@ -1888,7 +1876,6 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
 	if (res) {
 		sas_free_task(task);
 		pm8001_tag_free(pm8001_ha, ccb_tag);
-		kfree(dev);
 	}
 }
 
-- 
2.29.2

