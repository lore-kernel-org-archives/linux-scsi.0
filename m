Return-Path: <SRS0=Icgp=EG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DED0CC4742C
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Oct 2020 02:17:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A174E22245
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Oct 2020 02:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbgJaCLT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Oct 2020 22:11:19 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6674 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgJaCLT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2020 22:11:19 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CNN2Z01vnz15MJr;
        Sat, 31 Oct 2020 10:11:18 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Sat, 31 Oct 2020 10:11:07 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     Nilesh Javali <njavali@marvell.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Qinglang Miao" <miaoqinglang@huawei.com>
Subject: [PATCH] scsi: qla2xxx: add missing iounmap() on error in qlafx00_iospace_config
Date:   Sat, 31 Oct 2020 10:16:53 +0800
Message-ID: <20201031021653.186554-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add the missing iounmap() before return from qlafx00_iospace_config
in the error handling case when os failed to do ioremap for ha->iobase.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
---
 drivers/scsi/qla2xxx/qla_mr.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index ca7306685..c6fcd47de 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -798,13 +798,13 @@ qlafx00_iospace_config(struct qla_hw_data *ha)
 		ql_log_pci(ql_log_warn, ha->pdev, 0x0129,
 		    "region #2 not an MMIO resource (%s), aborting\n",
 		    pci_name(ha->pdev));
-		goto iospace_error_exit;
+		goto ha_iobase_exit;
 	}
 	if (pci_resource_len(ha->pdev, 2) < BAR2_LEN_FX00) {
 		ql_log_pci(ql_log_warn, ha->pdev, 0x012a,
 		    "Invalid PCI mem BAR2 region size (%s), aborting\n",
 			pci_name(ha->pdev));
-		goto iospace_error_exit;
+		goto ha_iobase_exit;
 	}
 
 	ha->iobase =
@@ -812,7 +812,7 @@ qlafx00_iospace_config(struct qla_hw_data *ha)
 	if (!ha->iobase) {
 		ql_log_pci(ql_log_fatal, ha->pdev, 0x012b,
 		    "cannot remap MMIO (%s), aborting\n", pci_name(ha->pdev));
-		goto iospace_error_exit;
+		goto ha_iobase_exit;
 	}
 
 	/* Determine queue resources */
@@ -824,6 +824,8 @@ qlafx00_iospace_config(struct qla_hw_data *ha)
 
 	return 0;
 
+ha_iobase_exit:
+	iounmap(ha->cregbase);
 iospace_error_exit:
 	return -ENOMEM;
 }
-- 
2.23.0

