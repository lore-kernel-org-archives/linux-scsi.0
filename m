Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AD67C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 02:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29400619EC
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 02:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbhKQCxP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 21:53:15 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:27136 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232690AbhKQCxJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2021 21:53:09 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Hv6mM6lRVz1DJRB;
        Wed, 17 Nov 2021 10:47:47 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Wed, 17 Nov 2021 10:50:10 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 05/15] scsi: hisi_sas: Fix some issues related to asd_sas_port->phy_list
Date:   Wed, 17 Nov 2021 10:44:58 +0800
Message-ID: <1637117108-230103-6-git-send-email-chenxiang66@hisilicon.com>
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

Most places that use asd_sas_port->phy_list are protected by spinlock
asd_sas_port->phy_list_lock, but there are some places which lack of it
in hisi_sas driver, so add it in function hisi_sas_refresh_port_id() when
accessing asd_sas_port->phy_list. But it has a risk that list mutates while
dropping the lock at the same time in function
hisi_sas_send_ata_reset_each_phy(), so read asd_sas_port->phy_mask
instead of accessing asd_sas_port->phy_list to avoid the risk.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Acked-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 305d6282845a..44c888e0afd7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1427,11 +1427,13 @@ static void hisi_sas_refresh_port_id(struct hisi_hba *hisi_hba)
 		sas_port = device->port;
 		port = to_hisi_sas_port(sas_port);
 
+		spin_lock(&sas_port->phy_list_lock);
 		list_for_each_entry(sas_phy, &sas_port->phy_list, port_phy_el)
 			if (state & BIT(sas_phy->id)) {
 				phy = sas_phy->lldd_phy;
 				break;
 			}
+		spin_unlock(&sas_port->phy_list_lock);
 
 		if (phy) {
 			port->id = phy->port_id;
@@ -1508,22 +1510,25 @@ static void hisi_sas_send_ata_reset_each_phy(struct hisi_hba *hisi_hba,
 	struct ata_link *link;
 	u8 fis[20] = {0};
 	u32 state;
+	int i;
 
 	state = hisi_hba->hw->get_phys_state(hisi_hba);
-	list_for_each_entry(sas_phy, &sas_port->phy_list, port_phy_el) {
+	for (i = 0; i < hisi_hba->n_phy; i++) {
 		if (!(state & BIT(sas_phy->id)))
 			continue;
+		if (!(sas_port->phy_mask & BIT(i)))
+			continue;
 
 		ata_for_each_link(link, ap, EDGE) {
 			int pmp = sata_srst_pmp(link);
 
-			tmf_task.phy_id = sas_phy->id;
+			tmf_task.phy_id = i;
 			hisi_sas_fill_ata_reset_cmd(link->device, 1, pmp, fis);
 			rc = hisi_sas_exec_internal_tmf_task(device, fis, s,
 							     &tmf_task);
 			if (rc != TMF_RESP_FUNC_COMPLETE) {
 				dev_err(dev, "phy%d ata reset failed rc=%d\n",
-					sas_phy->id, rc);
+					i, rc);
 				break;
 			}
 		}
-- 
2.33.0

