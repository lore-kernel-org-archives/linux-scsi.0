Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AA1DC4167B
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Dec 2022 14:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236025AbiLMOtM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Dec 2022 09:49:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235766AbiLMOtE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2022 09:49:04 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BBCB5F63
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 06:49:00 -0800 (PST)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NWhF053pWzJqN8;
        Tue, 13 Dec 2022 22:48:04 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500004.china.huawei.com
 (7.192.104.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 13 Dec
 2022 22:48:57 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>, <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v2 3/5] scsi: libsas: remove useless dev_list delete in sas_ex_discover_end_dev()
Date:   Tue, 13 Dec 2022 23:09:40 +0800
Message-ID: <20221213150942.988371-4-yanaijie@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221213150942.988371-1-yanaijie@huawei.com>
References: <20221213150942.988371-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500004.china.huawei.com (7.192.104.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The domain device 'child' is allocated in sas_ex_discover_end_dev() and
never been added to dev_list. It used to be added to the dev_list in this
function. But after the following two fixes it is added to the disco_list
instead. So the list_del() and locking left is useless now.

Fixes: 87c8331fcf72 ("[SCSI] libsas: prevent domain rediscovery competing with ata error handling")
Fixes: 92625f9bff38 ("[SCSI] libsas: restore scan order")
Cc: John Garry <john.g.garry@oracle.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/libsas/sas_expander.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index a04cad620e93..29e1b93b0964 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -875,9 +875,6 @@ static struct domain_device *sas_ex_discover_end_dev(
  out_list_del:
 	sas_rphy_free(child->rphy);
 	list_del(&child->disco_list_node);
-	spin_lock_irq(&parent->port->dev_list_lock);
-	list_del(&child->dev_list_node);
-	spin_unlock_irq(&parent->port->dev_list_lock);
  out_free:
 	sas_port_delete(phy->port);
  out_err:
-- 
2.31.1

