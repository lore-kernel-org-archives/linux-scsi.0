Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FE6DC4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Dec 2021 11:26:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbhLTL0w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Dec 2021 06:26:52 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:30142 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbhLTL0u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2021 06:26:50 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4JHcgL6v6kz8vyT;
        Mon, 20 Dec 2021 19:24:30 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Mon, 20 Dec 2021 19:26:49 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH v2 05/15] scsi: hisi_sas: Fix some issues related to asd_sas_port->phy_list
Date:   Mon, 20 Dec 2021 19:21:28 +0800
Message-ID: <1639999298-244569-6-git-send-email-chenxiang66@hisilicon.com>
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
index ad64ccd41420..051092e294f7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1428,11 +1428,13 @@ static void hisi_sas_refresh_port_id(struct hisi_hba *hisi_hba)
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
@@ -1509,22 +1511,25 @@ static void hisi_sas_send_ata_reset_each_phy(struct hisi_hba *hisi_hba,
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

