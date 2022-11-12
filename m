Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3CC6C433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Nov 2022 09:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234540AbiKLJpK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Nov 2022 04:45:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234533AbiKLJpJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Nov 2022 04:45:09 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C50D2D3
        for <linux-scsi@vger.kernel.org>; Sat, 12 Nov 2022 01:45:07 -0800 (PST)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N8VzQ019qz15Lwl;
        Sat, 12 Nov 2022 17:44:49 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 12 Nov 2022 17:45:06 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 12 Nov
 2022 17:45:05 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <hare@suse.de>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <yangyingliang@huawei.com>
Subject: [PATCH] scsi: fcoe: fix possible name leak when device_register() fails
Date:   Sat, 12 Nov 2022 17:43:10 +0800
Message-ID: <20221112094310.3633291-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If device_register() returns error, the name allocated by
dev_set_name() need be freed. As comment of device_register()
says, it should use put_device() to give up the reference in
the error path. So fix this by calling put_device(), then the
name can be freed in kobject_cleanup().

The 'fcf' is freed in fcoe_fcf_device_release(), so the kfree()
in the error path can be removed.

The 'ctlr' is freed in fcoe_ctlr_device_release(), so don't use
the error label, just return NULL after calling put_device().

Fixes: 9a74e884ee71 ("[SCSI] libfcoe: Add fcoe_sysfs")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/scsi/fcoe/fcoe_sysfs.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
index af658aa38fed..6260aa5ea6af 100644
--- a/drivers/scsi/fcoe/fcoe_sysfs.c
+++ b/drivers/scsi/fcoe/fcoe_sysfs.c
@@ -830,14 +830,15 @@ struct fcoe_ctlr_device *fcoe_ctlr_device_add(struct device *parent,
 
 	dev_set_name(&ctlr->dev, "ctlr_%d", ctlr->id);
 	error = device_register(&ctlr->dev);
-	if (error)
-		goto out_del_q2;
+	if (error) {
+		destroy_workqueue(ctlr->devloss_work_q);
+		destroy_workqueue(ctlr->work_q);
+		put_device(&ctlr->dev);
+		return NULL;
+	}
 
 	return ctlr;
 
-out_del_q2:
-	destroy_workqueue(ctlr->devloss_work_q);
-	ctlr->devloss_work_q = NULL;
 out_del_q:
 	destroy_workqueue(ctlr->work_q);
 	ctlr->work_q = NULL;
@@ -1036,16 +1037,16 @@ struct fcoe_fcf_device *fcoe_fcf_device_add(struct fcoe_ctlr_device *ctlr,
 	fcf->selected = new_fcf->selected;
 
 	error = device_register(&fcf->dev);
-	if (error)
-		goto out_del;
+	if (error) {
+		put_device(&fcf->dev);
+		goto out;
+	}
 
 	fcf->state = FCOE_FCF_STATE_CONNECTED;
 	list_add_tail(&fcf->peers, &ctlr->fcfs);
 
 	return fcf;
 
-out_del:
-	kfree(fcf);
 out:
 	return NULL;
 }
-- 
2.25.1

