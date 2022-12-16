Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8152AC4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Dec 2022 03:36:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiLPDgJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Dec 2022 22:36:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiLPDgH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Dec 2022 22:36:07 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9ADD6564;
        Thu, 15 Dec 2022 19:36:06 -0800 (PST)
Received: from dggpemm500012.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NYF605SPLzJpPf;
        Fri, 16 Dec 2022 11:32:24 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpemm500012.china.huawei.com (7.185.36.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 16 Dec 2022 11:36:04 +0800
From:   Xingui Yang <yangxingui@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <john.g.garry@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <yangxingui@huawei.com>,
        <prime.zeng@hisilicon.com>, <kangfenglong@huawei.com>
Subject: [PATCH] scsi: libsas: Directly kick-off EH when ATA device fell off
Date:   Fri, 16 Dec 2022 03:29:36 +0000
Message-ID: <20221216032936.17841-1-yangxingui@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500012.china.huawei.com (7.185.36.89)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the ATA device fell off, call sas_ata_device_link_abort() directly and
mark all outstanding QCs as failed and kick-off EH Immediately. This avoids
having to wait for block layer timeouts.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
---
 drivers/scsi/libsas/sas_discover.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index d5bc1314c341..bd22741daa99 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -362,6 +362,11 @@ static void sas_destruct_ports(struct asd_sas_port *port)
 
 void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *dev)
 {
+	if (test_bit(SAS_DEV_GONE, &dev->state) &&
+	    (dev->dev_type == SAS_SATA_DEV ||
+	    (dev->tproto & SAS_PROTOCOL_STP)))
+		sas_ata_device_link_abort(dev, false);
+
 	if (!test_bit(SAS_DEV_DESTROY, &dev->state) &&
 	    !list_empty(&dev->disco_list_node)) {
 		/* this rphy never saw sas_rphy_add */
-- 
2.17.1

