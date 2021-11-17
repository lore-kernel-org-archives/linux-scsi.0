Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AEB9C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 02:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8370961C12
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 02:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbhKQCxS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 21:53:18 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:27140 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232697AbhKQCxK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2021 21:53:10 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Hv6mN4m79z1DJRj;
        Wed, 17 Nov 2021 10:47:48 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Wed, 17 Nov 2021 10:50:11 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 10/15] scsi: libsas: Add a flag SAS_HA_RESUMING of sas_ha
Date:   Wed, 17 Nov 2021 10:45:03 +0800
Message-ID: <1637117108-230103-11-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
References: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Add a flag SAS_HA_RESUMING and use it to indicate the process of resuming
sas_ha.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Reviewed-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/libsas/sas_init.c | 2 ++
 include/scsi/libsas.h          | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 974c4a305ece..069e40fc8411 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -362,6 +362,7 @@ void sas_prep_resume_ha(struct sas_ha_struct *ha)
 	int i;
 
 	set_bit(SAS_HA_REGISTERED, &ha->state);
+	set_bit(SAS_HA_RESUMING, &ha->state);
 
 	/* clear out any stale link events/data from the suspension path */
 	for (i = 0; i < ha->num_phys; i++) {
@@ -443,6 +444,7 @@ static void _sas_resume_ha(struct sas_ha_struct *ha, bool drain)
 	scsi_unblock_requests(ha->core.shost);
 	if (drain)
 		sas_drain_work(ha);
+	clear_bit(SAS_HA_RESUMING, &ha->state);
 
 	/* send event PORTE_BROADCAST_RCVD to identify some new inserted
 	 * disks for expander
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index a795a2d9e5b1..698f2032807b 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -356,6 +356,7 @@ enum sas_ha_state {
 	SAS_HA_DRAINING,
 	SAS_HA_ATA_EH_ACTIVE,
 	SAS_HA_FROZEN,
+	SAS_HA_RESUMING,
 };
 
 struct sas_ha_struct {
-- 
2.33.0

