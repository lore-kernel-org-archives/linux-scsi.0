Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77CC5C77B6C
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Apr 2023 11:10:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjDMLKD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Apr 2023 07:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbjDMLKC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Apr 2023 07:10:02 -0400
X-Greylist: delayed 120 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 13 Apr 2023 04:09:53 PDT
Received: from mail.nfschina.com (unknown [42.101.60.195])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 133477D9C;
        Thu, 13 Apr 2023 04:09:52 -0700 (PDT)
Received: from localhost.localdomain (unknown [180.167.10.98])
        by mail.nfschina.com (Maildata Gateway V2.8.8) with ESMTPA id 50B0318010E345;
        Thu, 13 Apr 2023 19:07:38 +0800 (CST)
X-MD-Sfrom: liqiong@nfschina.com
X-MD-SrcIP: 180.167.10.98
From:   Li Qiong <liqiong@nfschina.com>
To:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Qiong <liqiong@nfschina.com>
Subject: [PATCH 1/4] scsi: qla2xxx: Remove unnecessary (void*) conversions
Date:   Thu, 13 Apr 2023 19:06:41 +0800
Message-Id: <20230413110641.3760-1-liqiong@nfschina.com>
X-Mailer: git-send-email 2.11.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

No need to cast (void*) pointer to other type.

Signed-off-by: Li Qiong <liqiong@nfschina.com>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 648e8f798606..93996bd70380 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -100,7 +100,7 @@ static int qla_nvme_alloc_queue(struct nvme_fc_local_port *lport,
 	if (qidx)
 		qidx--;
 
-	vha = (struct scsi_qla_host *)lport->private;
+	vha = lport->private;
 	ha = vha->hw;
 
 	ql_log(ql_log_info, vha, 0x2104,
@@ -141,7 +141,7 @@ static int qla_nvme_alloc_queue(struct nvme_fc_local_port *lport,
 static void qla_nvme_release_fcp_cmd_kref(struct kref *kref)
 {
 	struct srb *sp = container_of(kref, struct srb, cmd_kref);
-	struct nvme_private *priv = (struct nvme_private *)sp->priv;
+	struct nvme_private *priv = sp->priv;
 	struct nvmefc_fcp_req *fd;
 	struct srb_iocb *nvme;
 	unsigned long flags;
@@ -173,7 +173,7 @@ static void qla_nvme_release_fcp_cmd_kref(struct kref *kref)
 static void qla_nvme_release_ls_cmd_kref(struct kref *kref)
 {
 	struct srb *sp = container_of(kref, struct srb, cmd_kref);
-	struct nvme_private *priv = (struct nvme_private *)sp->priv;
+	struct nvme_private *priv = sp->priv;
 	struct nvmefc_ls_req *fd;
 	unsigned long flags;
 
-- 
2.11.0

