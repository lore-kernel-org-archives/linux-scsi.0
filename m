Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DB1AC4332F
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Nov 2022 07:18:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiKEHS5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Nov 2022 03:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiKEHSy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Nov 2022 03:18:54 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA2842BE9
        for <linux-scsi@vger.kernel.org>; Sat,  5 Nov 2022 00:18:49 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N48402R9TzmVgC;
        Sat,  5 Nov 2022 15:18:40 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 5 Nov 2022 15:18:48 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 5 Nov
 2022 15:18:47 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <yangyingliang@huawei.com>
Subject: [PATCH] scsi: libsas: fix error handling in sas_phy_add()
Date:   Sat, 5 Nov 2022 15:17:25 +0800
Message-ID: <20221105071725.2313316-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If transport_add_device() fails in sas_phy_add(), but it's not handled,
it will lead kernel crash because of trying to delete not added device
in transport_remove_device() called from sas_remove_host().

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000108
CPU: 61 PID: 42829 Comm: rmmod Kdump: loaded Tainted: G        W          6.1.0-rc1+ #173
pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : device_del+0x54/0x3d0
lr : device_del+0x37c/0x3d0
Call trace:
 device_del+0x54/0x3d0
 attribute_container_class_device_del+0x28/0x38
 transport_remove_classdev+0x6c/0x80
 attribute_container_device_trigger+0x108/0x110
 transport_remove_device+0x28/0x38
 sas_phy_delete+0x30/0x60 [scsi_transport_sas]
 do_sas_phy_delete+0x6c/0x80 [scsi_transport_sas]
 device_for_each_child+0x68/0xb0
 sas_remove_children+0x40/0x50 [scsi_transport_sas]
 sas_remove_host+0x20/0x38 [scsi_transport_sas]
 hisi_sas_remove+0x40/0x68 [hisi_sas_main]
 hisi_sas_v2_remove+0x20/0x30 [hisi_sas_v2_hw]
 platform_remove+0x2c/0x60

Fix this by checking and handling return value of transport_add_device()
in sas_phy_add(). transport_destroy_device() has been called in sas_phy_free()
in the error path, so it's no need to call it here.

Fixes: c7ebbbce366c ("[SCSI] SAS transport class")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/scsi/scsi_transport_sas.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 2f88c61216ee..cb364a7c6097 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -723,8 +723,11 @@ int sas_phy_add(struct sas_phy *phy)
 
 	error = device_add(&phy->dev);
 	if (!error) {
-		transport_add_device(&phy->dev);
-		transport_configure_device(&phy->dev);
+		error = transport_add_device(&phy->dev);
+		if (!error)
+			transport_configure_device(&phy->dev);
+		else
+			device_del(&phy->dev);
 	}
 
 	return error;
-- 
2.25.1

