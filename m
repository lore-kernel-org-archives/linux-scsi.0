Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA797C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 02:51:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236990AbiGHCvM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 22:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236851AbiGHCvL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 22:51:11 -0400
Received: from ssh248.corpemail.net (ssh248.corpemail.net [210.51.61.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 969E074785;
        Thu,  7 Jul 2022 19:51:09 -0700 (PDT)
Received: from ([60.208.111.195])
        by ssh248.corpemail.net ((D)) with ASMTP (SSL) id CZH00103;
        Fri, 08 Jul 2022 10:51:03 +0800
Received: from localhost.localdomain (10.200.104.97) by
 jtjnmail201612.home.langchao.com (10.100.2.12) with Microsoft SMTP Server id
 15.1.2507.9; Fri, 8 Jul 2022 10:51:03 +0800
From:   Bo Liu <liubo03@inspur.com>
To:     <hare@suse.de>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Bo Liu <liubo03@inspur.com>
Subject: [PATCH] scsi: fcoe: Check dev_set_name() return value
Date:   Thu, 7 Jul 2022 22:50:58 -0400
Message-ID: <20220708025058.5120-1-liubo03@inspur.com>
X-Mailer: git-send-email 2.18.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.200.104.97]
tUid:   20227081051037baf487b1b735b92fc05a9c5eab610c5
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It's possible that dev_set_name() returns -ENOMEM, catch and handle this.

Signed-off-by: Bo Liu <liubo03@inspur.com>
---
 drivers/scsi/fcoe/fcoe_sysfs.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
index af658aa38fed..4da331cfc108 100644
--- a/drivers/scsi/fcoe/fcoe_sysfs.c
+++ b/drivers/scsi/fcoe/fcoe_sysfs.c
@@ -828,7 +828,10 @@ struct fcoe_ctlr_device *fcoe_ctlr_device_add(struct device *parent,
 	if (!ctlr->devloss_work_q)
 		goto out_del_q;
 
-	dev_set_name(&ctlr->dev, "ctlr_%d", ctlr->id);
+	error = dev_set_name(&ctlr->dev, "ctlr_%d", ctlr->id);
+	if (error)
+		goto out_del_q2;
+
 	error = device_register(&ctlr->dev);
 	if (error)
 		goto out_del_q2;
@@ -1024,7 +1027,9 @@ struct fcoe_fcf_device *fcoe_fcf_device_add(struct fcoe_ctlr_device *ctlr,
 
 	fcf->dev_loss_tmo = ctlr->fcf_dev_loss_tmo;
 
-	dev_set_name(&fcf->dev, "fcf_%d", fcf->id);
+	error = dev_set_name(&fcf->dev, "fcf_%d", fcf->id);
+	if (error)
+		goto out_del;
 
 	fcf->fabric_name = new_fcf->fabric_name;
 	fcf->switch_name = new_fcf->switch_name;
-- 
2.27.0

