Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32FC3C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Nov 2022 09:34:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbiKBJeI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Nov 2022 05:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbiKBJeH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Nov 2022 05:34:07 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B7B1F608
        for <linux-scsi@vger.kernel.org>; Wed,  2 Nov 2022 02:34:06 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N2MCY26JDzbc3P;
        Wed,  2 Nov 2022 17:34:01 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 17:34:05 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 2 Nov
 2022 17:34:04 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-scsi@vger.kernel.org>
CC:     Yang Yingliang <yangyingliang@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: scsi_transport_fc: fix possible memory leak
Date:   Wed, 2 Nov 2022 17:32:51 +0800
Message-ID: <20221102093251.4407-1-yangyingliang@huawei.com>
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

Afer commit 1fa5ae857bb1 ("driver core: get rid of struct device's
bus_id string array"), the name of device is allocated dynamically,
it need be freed if device_add(dev) returns error, as comment of
device_add() says, it should call put_device() to drop the reference
on error.

Fix it by calling put_device(dev) so that the name can be freed in
kobject_cleanup(). In fc_rport_dev_release() and fc_vport_dev_release(),
it will put refcount of dev->parent and free the port, so the release
code of them in error path can be removed.

Fixes: 1fa5ae857bb1 ("driver core: get rid of struct device's bus_id string array")
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/scsi/scsi_transport_fc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 8934160c4a33..97f62db0ad31 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3129,8 +3129,7 @@ fc_remote_port_create(struct Scsi_Host *shost, int channel,
 	list_del(&rport->peers);
 	scsi_host_put(shost);			/* for fc_host->rport list */
 	spin_unlock_irqrestore(shost->host_lock, flags);
-	put_device(dev->parent);
-	kfree(rport);
+	put_device(dev);
 	return NULL;
 }
 
@@ -3930,8 +3929,7 @@ fc_vport_setup(struct Scsi_Host *shost, int channel, struct device *pdev,
 	scsi_host_put(shost);			/* for fc_host->vport list */
 	fc_host->npiv_vports_inuse--;
 	spin_unlock_irqrestore(shost->host_lock, flags);
-	put_device(dev->parent);
-	kfree(vport);
+	put_device(dev);
 
 	return error;
 }
-- 
2.25.1

