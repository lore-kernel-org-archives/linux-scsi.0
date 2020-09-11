Return-Path: <SRS0=m8O6=CU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B686AC433E2
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 09:11:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68A20208E4
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 09:11:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbgIKJLS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Sep 2020 05:11:18 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:11816 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725770AbgIKJLO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Sep 2020 05:11:14 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id EEB255CBC1CE88A99B7F;
        Fri, 11 Sep 2020 17:11:07 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Fri, 11 Sep 2020
 17:11:00 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <njavali@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] scsi: qla2xxx: remove unneeded variable 'rval'
Date:   Fri, 11 Sep 2020 17:10:21 +0800
Message-ID: <20200911091021.2937708-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This addresses the following coccinelle warning:

drivers/scsi/qla2xxx/qla_init.c:7112:5-9: Unneeded variable: "rval".
Return "QLA_SUCCESS" on line 7115

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 0bd04a62af83..df56ac8c3f00 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -7109,10 +7109,9 @@ qla24xx_reset_adapter(scsi_qla_host_t *vha)
 	unsigned long flags = 0;
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
-	int rval = QLA_SUCCESS;
 
 	if (IS_P3P_TYPE(ha))
-		return rval;
+		return QLA_SUCCESS;
 
 	vha->flags.online = 0;
 	ha->isp_ops->disable_intrs(ha);
@@ -7127,7 +7126,7 @@ qla24xx_reset_adapter(scsi_qla_host_t *vha)
 	if (IS_NOPOLLING_TYPE(ha))
 		ha->isp_ops->enable_intrs(ha);
 
-	return rval;
+	return QLA_SUCCESS;
 }
 
 /* On sparc systems, obtain port and node WWN from firmware
-- 
2.25.4

