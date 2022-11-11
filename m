Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F110AC4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Nov 2022 13:26:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbiKKN0U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Nov 2022 08:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiKKN0S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Nov 2022 08:26:18 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF03D60F3
        for <linux-scsi@vger.kernel.org>; Fri, 11 Nov 2022 05:26:17 -0800 (PST)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N7zx73DlSzRp9l;
        Fri, 11 Nov 2022 21:26:03 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 21:26:15 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 11 Nov
 2022 21:26:15 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <yangyingliang@huawei.com>
Subject: [PATCH] scsi: scsi_transport_sas: fix error handling in sas_port_add()
Date:   Fri, 11 Nov 2022 21:24:52 +0800
Message-ID: <20221111132452.2385508-1-yangyingliang@huawei.com>
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

In sas_port_add(), the return value of transport_add_device() is
not checked. As a result, it causes null-ptr-deref while removing
device, because transport_remove_device() is called to remove the
device that was not added.

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000108
pc : device_del+0x54/0x3d0
lr : device_del+0x37c/0x3d0
Call trace:
 device_del+0x54/0x3d0
 attribute_container_class_device_del+0x28/0x38
 transport_remove_classdev+0x6c/0x80
 attribute_container_device_trigger+0x108/0x110
 transport_remove_device+0x28/0x38
 sas_port_delete+0x110/0x148 [scsi_transport_sas]
 do_sas_phy_delete+0x78/0x80 [scsi_transport_sas]
 device_for_each_child+0x68/0xb0
 sas_remove_children+0x30/0x50 [scsi_transport_sas]
 sas_rphy_remove+0x38/0x78 [scsi_transport_sas]
 sas_port_delete+0x30/0x148 [scsi_transport_sas]
 do_sas_phy_delete+0x78/0x80 [scsi_transport_sas]
 device_for_each_child+0x68/0xb0
 sas_remove_children+0x30/0x50 [scsi_transport_sas]
 sas_remove_host+0x20/0x38 [scsi_transport_sas]
 scsih_remove+0xd8/0x420 [mpt3sas]

Fix this by checking and handling return value of transport_add_device()
in sas_port_add().

Fixes: 65c92b09acf0 ("[SCSI] scsi_transport_sas: introduce a sas_port entity")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/scsi/scsi_transport_sas.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index accc0afa8f77..e090486258a5 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -959,7 +959,11 @@ int sas_port_add(struct sas_port *port)
 	if (error)
 		return error;
 
-	transport_add_device(&port->dev);
+	error = transport_add_device(&port->dev);
+	if (error) {
+		device_del(&port->dev);
+		return error;
+	}
 	transport_configure_device(&port->dev);
 
 	return 0;
-- 
2.25.1

