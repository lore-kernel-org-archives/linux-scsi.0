Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA3ACC4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 06:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbiKDGsQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 02:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbiKDGrs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 02:47:48 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A912B1B8
        for <linux-scsi@vger.kernel.org>; Thu,  3 Nov 2022 23:47:44 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4N3WML5wYbzJnSw;
        Fri,  4 Nov 2022 14:44:46 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 4 Nov 2022 14:47:42 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 4 Nov
 2022 14:47:42 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-scsi@vger.kernel.org>
CC:     Yang Yingliang <yangyingliang@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: libsas: fix error handling in sas_register_phys()
Date:   Fri, 4 Nov 2022 14:46:08 +0800
Message-ID: <20221104064608.1902235-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If sas_phy_alloc() returns error in sas_register_phys(), the phys that
have been added are not deleted, so the memory of them are leaked, also,
this leads the list of phy_attr_cont is not empty, it tiggers a BUG while
calling sas_release_transport() in hisi_sas_exit() when removing module.

kernel BUG at ./include/linux/transport_class.h:92!
CPU: 8 PID: 38014 Comm: rmmod Kdump: loaded Not tainted 6.1.0-rc1+ #176
Hardware name: Huawei TaiShan 2280 /BC11SPCD, BIOS 1.58 10/24/2018
pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : sas_release_transport+0x78/0x84 [scsi_transport_sas]
lr : sas_release_transport+0x2c/0x84 [scsi_transport_sas]
Call trace:
 sas_release_transport+0x78/0x84 [scsi_transport_sas]
 hisi_sas_exit+0x1c/0x9a8 [hisi_sas_main]
 __arm64_sys_delete_module+0x19c/0x358

Fix this by deleting the phys that have been added if sas_phy_alloc()
returns error.

Besides, if sas_phy_add() fails in sas_register_phys(), the phy->dev
is not added to the klist_children of shost_gendev, so the phy can not
be delete in sas_remove_children(), the phy and name memory allocated
in sas_phy_alloc() are leaked.

Fix this by checking and handling return value of sas_phy_add() in
sas_register_phys(), call sas_phy_free() in the error path.

Fixes: 2908d778ab3e ("[SCSI] aic94xx: new driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/scsi/libsas/sas_phy.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libsas/sas_phy.c b/drivers/scsi/libsas/sas_phy.c
index a0d592d11dfb..84853576eb78 100644
--- a/drivers/scsi/libsas/sas_phy.c
+++ b/drivers/scsi/libsas/sas_phy.c
@@ -115,6 +115,7 @@ static void sas_phye_shutdown(struct work_struct *work)
 
 int sas_register_phys(struct sas_ha_struct *sas_ha)
 {
+	int ret;
 	int i;
 
 	/* Now register the phys. */
@@ -132,8 +133,10 @@ int sas_register_phys(struct sas_ha_struct *sas_ha)
 		phy->frame_rcvd_size = 0;
 
 		phy->phy = sas_phy_alloc(&sas_ha->core.shost->shost_gendev, i);
-		if (!phy->phy)
-			return -ENOMEM;
+		if (!phy->phy) {
+			ret = -ENOMEM;
+			goto err_out;
+		}
 
 		phy->phy->identify.initiator_port_protocols =
 			phy->iproto;
@@ -146,10 +149,20 @@ int sas_register_phys(struct sas_ha_struct *sas_ha)
 		phy->phy->maximum_linkrate = SAS_LINK_RATE_UNKNOWN;
 		phy->phy->negotiated_linkrate = SAS_LINK_RATE_UNKNOWN;
 
-		sas_phy_add(phy->phy);
+		ret = sas_phy_add(phy->phy);
+		if (ret) {
+			sas_phy_free(phy->phy);
+			goto err_out;
+		}
 	}
 
 	return 0;
+
+err_out:
+	while (i--)
+		sas_phy_delete(sas_ha->sas_phy[i]->phy);
+
+	return ret;
 }
 
 const work_func_t sas_phy_event_fns[PHY_NUM_EVENTS] = {
-- 
2.25.1

