Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20612C4332F
	for <linux-scsi@archiver.kernel.org>; Sun,  4 Dec 2022 07:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiLDH4K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 4 Dec 2022 02:56:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiLDH4H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Dec 2022 02:56:07 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D456E17888
        for <linux-scsi@vger.kernel.org>; Sat,  3 Dec 2022 23:56:06 -0800 (PST)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NPzVw01rvz15N1r;
        Sun,  4 Dec 2022 15:55:19 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500004.china.huawei.com
 (7.192.104.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sun, 4 Dec
 2022 15:56:04 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>, <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 4/6] scsi: libsas: remove useless dev_list delete in sas_ex_discover_end_dev()
Date:   Sun, 4 Dec 2022 16:16:41 +0800
Message-ID: <20221204081643.3835966-5-yanaijie@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221204081643.3835966-1-yanaijie@huawei.com>
References: <20221204081643.3835966-1-yanaijie@huawei.com>
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
never been added to dev_list. So remove the useless list_del() and
related locks.

Cc: John Garry <john.g.garry@oracle.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/libsas/sas_expander.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index a8af723fab3c..82ea7560a888 100644
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

