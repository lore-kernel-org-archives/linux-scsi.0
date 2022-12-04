Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C390C4332F
	for <linux-scsi@archiver.kernel.org>; Sun,  4 Dec 2022 07:56:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiLDH4H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 4 Dec 2022 02:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiLDH4G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Dec 2022 02:56:06 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADAC3175AE
        for <linux-scsi@vger.kernel.org>; Sat,  3 Dec 2022 23:56:05 -0800 (PST)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NPzR03WsfzqSmX;
        Sun,  4 Dec 2022 15:51:56 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500004.china.huawei.com
 (7.192.104.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sun, 4 Dec
 2022 15:56:02 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>, <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 1/6] scsi: libsas: move sas_get_ata_command_set() up to save the declaration
Date:   Sun, 4 Dec 2022 16:16:38 +0800
Message-ID: <20221204081643.3835966-2-yanaijie@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221204081643.3835966-1-yanaijie@huawei.com>
References: <20221204081643.3835966-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500004.china.huawei.com (7.192.104.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is a sas_get_ata_command_set() declaration above sas_get_ata_info()
to make it compile ok. However this function is defined in the same file
below. So move it up to save the declaration.

Cc: John Garry <john.g.garry@oracle.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/libsas/sas_ata.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index f7439bf9cdc6..34009c330eb2 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -239,7 +239,19 @@ static struct sas_internal *dev_to_sas_internal(struct domain_device *dev)
 	return to_sas_internal(dev->port->ha->core.shost->transportt);
 }
 
-static int sas_get_ata_command_set(struct domain_device *dev);
+static int sas_get_ata_command_set(struct domain_device *dev)
+{
+	struct dev_to_host_fis *fis =
+		(struct dev_to_host_fis *) dev->frame_rcvd;
+	struct ata_taskfile tf;
+
+	if (dev->dev_type == SAS_SATA_PENDING)
+		return ATA_DEV_UNKNOWN;
+
+	ata_tf_from_fis((const u8 *)fis, &tf);
+
+	return ata_dev_classify(&tf);
+}
 
 int sas_get_ata_info(struct domain_device *dev, struct ex_phy *phy)
 {
@@ -637,20 +649,6 @@ void sas_ata_task_abort(struct sas_task *task)
 	complete(waiting);
 }
 
-static int sas_get_ata_command_set(struct domain_device *dev)
-{
-	struct dev_to_host_fis *fis =
-		(struct dev_to_host_fis *) dev->frame_rcvd;
-	struct ata_taskfile tf;
-
-	if (dev->dev_type == SAS_SATA_PENDING)
-		return ATA_DEV_UNKNOWN;
-
-	ata_tf_from_fis((const u8 *)fis, &tf);
-
-	return ata_dev_classify(&tf);
-}
-
 void sas_probe_sata(struct asd_sas_port *port)
 {
 	struct domain_device *dev, *n;
-- 
2.31.1

