Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65666EB64DD
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Aug 2023 02:35:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbjHBCf4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Aug 2023 22:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjHBCf4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2023 22:35:56 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B3D1BF
        for <linux-scsi@vger.kernel.org>; Tue,  1 Aug 2023 19:35:55 -0700 (PDT)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RFwz53DdKzVjxX;
        Wed,  2 Aug 2023 10:34:09 +0800 (CST)
Received: from ubuntu1804.huawei.com (10.67.174.202) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 2 Aug 2023 10:35:53 +0800
From:   Zhu Wang <wangzhu9@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <kay.sievers@vrfy.org>, <tonyj@suse.de>, <gregkh@suse.de>,
        <linux-scsi@vger.kernel.org>, <bvanassche@acm.org>
CC:     <wangzhu9@huawei.com>
Subject: [PATCH -next v2] SCSI: fix possible memory leak while device_add() fails
Date:   Wed, 2 Aug 2023 10:35:21 +0800
Message-ID: <20230802023521.208194-1-wangzhu9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.174.202]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If device_add() returns error, the name allocated by dev_set_name() need
be freed. As comment of device_add() says, it should use put_device() to
decrease the reference count in the error path. So fix this by calling
put_device, then the name can be freed in kobject_cleanp().

Fixes: ee959b00c335 ("SCSI: convert struct class_device to struct device")
Signed-off-by: Zhu Wang <wangzhu9@huawei.com>

---
Changes in v2:
- Move the new put_device() call from under if to under err_out label.
---
 drivers/scsi/raid_class.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/raid_class.c b/drivers/scsi/raid_class.c
index 898a0bdf8df6..d9dd86a185f7 100644
--- a/drivers/scsi/raid_class.c
+++ b/drivers/scsi/raid_class.c
@@ -249,6 +249,7 @@ int raid_component_add(struct raid_template *r,struct device *raid_dev,
 
 err_out:
 	list_del(&rc->node);
+	put_device(&rc->dev);
 	rd->component_count--;
 	put_device(component_dev);
 	kfree(rc);
-- 
2.17.1

