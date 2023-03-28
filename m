Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD5DCC76196
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Mar 2023 11:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbjC1LP4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Mar 2023 07:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbjC1LPz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Mar 2023 07:15:55 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E3A3AB8
        for <linux-scsi@vger.kernel.org>; Tue, 28 Mar 2023 04:15:53 -0700 (PDT)
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Pm6Tw5YL5z17Q8F;
        Tue, 28 Mar 2023 19:12:36 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm100004.china.huawei.com
 (7.192.105.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Tue, 28 Mar
 2023 19:15:50 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>, <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>,
        Xingui Yang <yangxingui@huawei.com>
Subject: [PATCH] scsi: libsas: abort all inflight requests when device is gone
Date:   Tue, 28 Mar 2023 19:15:24 +0800
Message-ID: <20230328111524.1657878-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm100004.china.huawei.com (7.192.105.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When a disk is removed with inflight IO, the userspace application need
to wait for 30 senconds(depends on the timeout configuration) to getback
from the kernel. Xingui tried to fix this issue by aborting the ata link
for SATA devices[1]. However this approach left the SAS devices unresolved.

This patch try to fix this issue by aborting all inflight requests while
the device is gone. This is implemented by itering the tagset.

[1] https://lore.kernel.org/lkml/234e04db-7539-07e4-a6b8-c6b05f78193d@opensource.wdc.com/T/

Cc: Xingui Yang <yangxingui@huawei.com>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/libsas/sas_discover.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 72fdb2e5d047..d2be67f348e0 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -360,8 +360,28 @@ static void sas_destruct_ports(struct asd_sas_port *port)
 	}
 }
 
+static bool sas_abort_cmd(struct request *req, void *data)
+{
+	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
+	struct domain_device *dev = data;
+
+	if (dev == cmd_to_domain_dev(cmd))
+		blk_abort_request(req);
+	return true;
+}
+
+static void sas_abort_domain_cmds(struct domain_device *dev)
+{
+	struct sas_ha_struct *sas_ha = dev->port->ha;
+	struct Scsi_Host *shost = sas_ha->core.shost;
+	blk_mq_tagset_busy_iter(&shost->tag_set, sas_abort_cmd, dev);
+}
+
 void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *dev)
 {
+	if (test_bit(SAS_DEV_GONE, &dev->state))
+		sas_abort_domain_cmds(dev);
+
 	if (!test_bit(SAS_DEV_DESTROY, &dev->state) &&
 	    !list_empty(&dev->disco_list_node)) {
 		/* this rphy never saw sas_rphy_add */
-- 
2.31.1

