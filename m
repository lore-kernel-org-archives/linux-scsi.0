Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5956C4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 13:54:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C369A60F57
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 13:54:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240755AbhHMNyf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Aug 2021 09:54:35 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3647 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240678AbhHMNye (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Aug 2021 09:54:34 -0400
Received: from fraeml736-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GmQ4h4Dl2z6GBx3;
        Fri, 13 Aug 2021 21:53:24 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml736-chm.china.huawei.com (10.206.15.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 13 Aug 2021 15:54:06 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 13 Aug 2021 14:54:03 +0100
From:   John Garry <john.garry@huawei.com>
To:     <satishkh@cisco.com>, <sebaddel@cisco.com>, <kartilak@cisco.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hare@suse.de>, <hch@lst.de>, <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 1/3] scsi: wd719: Stop using scsi_cmnd.tag
Date:   Fri, 13 Aug 2021 21:49:11 +0800
Message-ID: <1628862553-179450-2-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1628862553-179450-1-git-send-email-john.garry@huawei.com>
References: <1628862553-179450-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_cmd_to_rq(cmd)->tag instead.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/wd719x.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index edc8a139a60d..622aec075aba 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -466,14 +466,16 @@ static int wd719x_abort(struct scsi_cmnd *cmd)
 	unsigned long flags;
 	struct wd719x_scb *scb = scsi_cmd_priv(cmd);
 	struct wd719x *wd = shost_priv(cmd->device->host);
+	struct device *dev = &wd->pdev->dev;
 
-	dev_info(&wd->pdev->dev, "abort command, tag: %x\n", cmd->tag);
+	dev_info(dev, "abort command, tag: %x\n", scsi_cmd_to_rq(cmd)->tag);
 
-	action = /*cmd->tag ? WD719X_CMD_ABORT_TAG : */WD719X_CMD_ABORT;
+	action = /*tag ? WD719X_CMD_ABORT_TAG : */WD719X_CMD_ABORT;
 
 	spin_lock_irqsave(wd->sh->host_lock, flags);
 	result = wd719x_direct_cmd(wd, action, cmd->device->id,
-				   cmd->device->lun, cmd->tag, scb->phys, 0);
+				   cmd->device->lun, scsi_cmd_to_rq(cmd)->tag,
+				   scb->phys, 0);
 	wd719x_finish_cmd(scb, DID_ABORT);
 	spin_unlock_irqrestore(wd->sh->host_lock, flags);
 	if (result)
-- 
2.26.2

