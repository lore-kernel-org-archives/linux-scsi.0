Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16148C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Dec 2021 11:26:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhLTL05 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Dec 2021 06:26:57 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:30076 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbhLTL0v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2021 06:26:51 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4JHcfR1z60z1DK9S;
        Mon, 20 Dec 2021 19:23:43 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Mon, 20 Dec 2021 19:26:49 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH v2 06/15] scsi: mvsas: Add spin_lock/unlock() to protect asd_sas_port->phy_list
Date:   Mon, 20 Dec 2021 19:21:29 +0800
Message-ID: <1639999298-244569-7-git-send-email-chenxiang66@hisilicon.com>
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

It lacks of spinlock phy_list_lock when using asd_sas_port->phy_list in
mvsas driver, so add spin_lock/unlock in those places.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/mvsas/mv_sas.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 31d1ea5a5dd2..1e52bc7febfa 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -67,8 +67,10 @@ static struct mvs_info *mvs_find_dev_mvi(struct domain_device *dev)
 
 	while (sha->sas_port[i]) {
 		if (sha->sas_port[i] == dev->port) {
+			spin_lock(&sha->sas_port[i]->phy_list_lock);
 			phy =  container_of(sha->sas_port[i]->phy_list.next,
 				struct asd_sas_phy, port_phy_el);
+			spin_unlock(&sha->sas_port[i]->phy_list_lock);
 			j = 0;
 			while (sha->sas_phy[j]) {
 				if (sha->sas_phy[j] == phy)
@@ -96,6 +98,8 @@ static int mvs_find_dev_phyno(struct domain_device *dev, int *phyno)
 	while (sha->sas_port[i]) {
 		if (sha->sas_port[i] == dev->port) {
 			struct asd_sas_phy *phy;
+
+			spin_lock(&sha->sas_port[i]->phy_list_lock);
 			list_for_each_entry(phy,
 				&sha->sas_port[i]->phy_list, port_phy_el) {
 				j = 0;
@@ -109,6 +113,7 @@ static int mvs_find_dev_phyno(struct domain_device *dev, int *phyno)
 				num++;
 				n++;
 			}
+			spin_unlock(&sha->sas_port[i]->phy_list_lock);
 			break;
 		}
 		i++;
-- 
2.33.0

