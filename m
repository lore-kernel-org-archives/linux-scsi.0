Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A28AC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 02:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2902F61B73
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 02:50:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbhKQCxO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 21:53:14 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:27138 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbhKQCxJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2021 21:53:09 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Hv6mN19cNz1DJVY;
        Wed, 17 Nov 2021 10:47:48 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Wed, 17 Nov 2021 10:50:10 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 07/15] scsi: libsas: Send event PORTE_BROADCAST_RCVD for valid ports
Date:   Wed, 17 Nov 2021 10:45:00 +0800
Message-ID: <1637117108-230103-8-git-send-email-chenxiang66@hisilicon.com>
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

If inserting a new disk for expander, the disk will not be revalidated
as the topology is not re-scanned during the resume process. So send event
PORTE_BROADCAST_RCVD to identify some new inserted disks for expander.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Reviewed-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/libsas/sas_init.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 43509d139241..974c4a305ece 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -387,6 +387,30 @@ static int phys_suspended(struct sas_ha_struct *ha)
 	return rc;
 }
 
+static void sas_resume_insert_broadcast_ha(struct sas_ha_struct *ha)
+{
+	int i;
+
+	for (i = 0; i < ha->num_phys; i++) {
+		struct asd_sas_port *port = ha->sas_port[i];
+		struct domain_device *dev = port->port_dev;
+
+		if (dev && dev_is_expander(dev->dev_type)) {
+			struct asd_sas_phy *first_phy;
+
+			spin_lock(&port->phy_list_lock);
+			first_phy = list_first_entry_or_null(
+				&port->phy_list, struct asd_sas_phy,
+				port_phy_el);
+			spin_unlock(&port->phy_list_lock);
+
+			if (first_phy)
+				sas_notify_port_event(first_phy,
+					PORTE_BROADCAST_RCVD, GFP_KERNEL);
+		}
+	}
+}
+
 static void _sas_resume_ha(struct sas_ha_struct *ha, bool drain)
 {
 	const unsigned long tmo = msecs_to_jiffies(25000);
@@ -419,6 +443,11 @@ static void _sas_resume_ha(struct sas_ha_struct *ha, bool drain)
 	scsi_unblock_requests(ha->core.shost);
 	if (drain)
 		sas_drain_work(ha);
+
+	/* send event PORTE_BROADCAST_RCVD to identify some new inserted
+	 * disks for expander
+	 */
+	sas_resume_insert_broadcast_ha(ha);
 }
 
 void sas_resume_ha(struct sas_ha_struct *ha)
-- 
2.33.0

