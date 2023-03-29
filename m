Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E41AC74A5B
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Mar 2023 12:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjC2Mo2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Mar 2023 08:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjC2Mo1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Mar 2023 08:44:27 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 546B8F4
        for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2023 05:44:26 -0700 (PDT)
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PmmPb18cqzgZj1;
        Wed, 29 Mar 2023 20:41:07 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm100004.china.huawei.com
 (7.192.105.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Wed, 29 Mar
 2023 20:44:23 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>, <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>,
        Xingui Yang <yangxingui@huawei.com>
Subject: [PATCH v2] scsi: libsas: abort all inflight requests when device is gone
Date:   Wed, 29 Mar 2023 20:43:57 +0800
Message-ID: <20230329124357.3746533-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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

 v1->v2:
   1. Rename sas_abort_domain_cmds() to sas_abort_device_scsi_cmds().
   2. Don't do the aborting for expanders and for devices not completely initialinzed.
   3. Add a comment to explain why we need to abort these commands.

 drivers/scsi/libsas/sas_discover.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 72fdb2e5d047..8c6afe724944 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -360,6 +360,33 @@ static void sas_destruct_ports(struct asd_sas_port *port)
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
+static void sas_abort_device_scsi_cmds(struct domain_device *dev)
+{
+	struct sas_ha_struct *sas_ha = dev->port->ha;
+	struct Scsi_Host *shost = sas_ha->core.shost;
+
+	if (dev_is_expander(dev->dev_type))
+		return;
+
+	/*
+	 * For removed device with active IOs, the user space applications have
+	 * to spend very long time waiting for the timeout. This is not
+	 * necessary because a removed device will not return the IOs.
+	 * Abort the inflight IOs here so that EH can be quickly kicked in.
+	 */
+	blk_mq_tagset_busy_iter(&shost->tag_set, sas_abort_cmd, dev);
+}
+
 void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *dev)
 {
 	if (!test_bit(SAS_DEV_DESTROY, &dev->state) &&
@@ -372,6 +399,8 @@ void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *dev)
 	}
 
 	if (!test_and_set_bit(SAS_DEV_DESTROY, &dev->state)) {
+		if (test_bit(SAS_DEV_GONE, &dev->state))
+			sas_abort_device_scsi_cmds(dev);
 		sas_rphy_unlink(dev->rphy);
 		list_move_tail(&dev->disco_list_node, &port->destroy_list);
 	}
-- 
2.31.1

