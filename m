Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F267BC433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Nov 2022 13:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbiKCNBg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Nov 2022 09:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbiKCNB0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Nov 2022 09:01:26 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91AF11C27
        for <linux-scsi@vger.kernel.org>; Thu,  3 Nov 2022 06:01:16 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N33fR149nzRnsb;
        Thu,  3 Nov 2022 20:56:15 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 21:01:14 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 3 Nov
 2022 21:01:14 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-scsi@vger.kernel.org>
CC:     Yang Yingliang <yangyingliang@huawei.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/2] scsi: snic: fix possible memory leak in snic_tgt_create()
Date:   Thu, 3 Nov 2022 20:59:37 +0800
Message-ID: <20221103125938.124819-2-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221103125938.124819-1-yangyingliang@huawei.com>
References: <20221103125938.124819-1-yangyingliang@huawei.com>
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

The device name allocated by dev_set_name() in snic_tgt_create() needs be
freed if device_add(&tgt->dev) returns error, as comment of device_add()
says, it should call put_device() to drop the reference on error.

Fix it by calling put_device(&rc->dev), so that the name can be freed in
kobject_cleanup(). The 'tgt' is freed in snic_tgt_dev_release(), so kfree()
in error path can be removed.

Fixes: c8806b6c9e82 ("snic: driver for Cisco SCSI HBA")
Cc: Karan Tilak Kumar <kartilak@cisco.com>
Cc: Sesidhar Baddela <sebaddel@cisco.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/scsi/snic/snic_disc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/snic/snic_disc.c b/drivers/scsi/snic/snic_disc.c
index 9b2b5f8c23b9..031c27d8510f 100644
--- a/drivers/scsi/snic/snic_disc.c
+++ b/drivers/scsi/snic/snic_disc.c
@@ -304,10 +304,8 @@ snic_tgt_create(struct snic *snic, struct snic_tgt_id *tgtid)
 			      ret);
 
 		put_device(&snic->shost->shost_gendev);
-		kfree(tgt);
-		tgt = NULL;
-
-		return tgt;
+		put_device(&tgt->dev);
+		return NULL;
 	}
 
 	SNIC_HOST_INFO(snic->shost, "Scanning %s.\n", dev_name(&tgt->dev));
-- 
2.25.1

