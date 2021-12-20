Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A061C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Dec 2021 11:26:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbhLTL05 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Dec 2021 06:26:57 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:15945 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231792AbhLTL0v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2021 06:26:51 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JHcfR1YXgzZdjt;
        Mon, 20 Dec 2021 19:23:43 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Mon, 20 Dec 2021 19:26:49 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH v2 07/15] scsi: libsas: Insert PORTE_BROADCAST_RCVD event for resuming host
Date:   Mon, 20 Dec 2021 19:21:30 +0800
Message-ID: <1639999298-244569-8-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1639999298-244569-1-git-send-email-chenxiang66@hisilicon.com>
References: <1639999298-244569-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

If a new disk is inserted through an expander when the host was suspended,
they will not necessarily be detected as the topology is not re-scanned
during resume.
To detect possible changes in topology during suspension, insert a
PORTE_BROADCAST_RCVD event per port when resuming to trigger a 
revalidation.

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

