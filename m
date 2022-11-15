Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4071C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Nov 2022 03:18:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237344AbiKODSX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Nov 2022 22:18:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbiKODSP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Nov 2022 22:18:15 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92C81A23F;
        Mon, 14 Nov 2022 19:18:13 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NBBFX3fdSz15MNp;
        Tue, 15 Nov 2022 11:17:52 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 11:18:12 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 15 Nov
 2022 11:18:11 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <rafael@kernel.org>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
Subject: [PATCH v2] drivers: base: transport_class: fix resource leak when transport_add_device() fails
Date:   Tue, 15 Nov 2022 11:16:38 +0800
Message-ID: <20221115031638.3816551-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The normal call sequence of using transport class is:

Add path:
transport_setup_device()
  transport_setup_classdev()  // call sas_host_setup() here
transport_add_device()	      // if fails, need call transport_destroy_device()
transport_configure_device()

Remove path:
transport_remove_device()
  transport_remove_classdev  // call sas_host_remove() here
transport_destroy_device()

If transport_add_device() fails, need call transport_destroy_device()
to free memory, but in this case, ->remove() is not called, and the
resources allocated in ->setup() are leaked. So fix these leaks by
calling ->remove() in transport_add_class_device() if it returns error.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
v1 -> v2:
  Add check if sysfs_create_group() is error.
---
 drivers/base/transport_class.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/base/transport_class.c b/drivers/base/transport_class.c
index ccc86206e508..09ee2a1e35bb 100644
--- a/drivers/base/transport_class.c
+++ b/drivers/base/transport_class.c
@@ -155,12 +155,27 @@ static int transport_add_class_device(struct attribute_container *cont,
 				      struct device *dev,
 				      struct device *classdev)
 {
+	struct transport_class *tclass = class_to_transport_class(cont->class);
 	int error = attribute_container_add_class_device(classdev);
 	struct transport_container *tcont = 
 		attribute_container_to_transport_container(cont);
 
-	if (!error && tcont->statistics)
+	if (error)
+		goto err_remove;
+
+	if (tcont->statistics) {
 		error = sysfs_create_group(&classdev->kobj, tcont->statistics);
+		if (error)
+			goto err_del;
+	}
+
+	return 0;
+
+err_del:
+	attribute_container_class_device_del(classdev);
+err_remove:
+	if (tclass->remove)
+		tclass->remove(tcont, dev, classdev);
 
 	return error;
 }
-- 
2.25.1

