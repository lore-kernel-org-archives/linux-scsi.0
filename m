Return-Path: <SRS0=dYxQ=BJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEF19C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 03:30:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA18722CA1
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 03:30:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbgG3Dan (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 23:30:43 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8297 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726367AbgG3Dan (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Jul 2020 23:30:43 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 73647A6AC142276B3404;
        Thu, 30 Jul 2020 11:30:41 +0800 (CST)
Received: from huawei.com (10.175.104.57) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Thu, 30 Jul 2020
 11:30:37 +0800
From:   Li Heng <liheng40@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <MPT-FusionLinux.pdl@broadcom.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH -next 2/3] scsi: Remove superfluous memset()
Date:   Thu, 30 Jul 2020 11:31:57 +0800
Message-ID: <1596079918-41115-3-git-send-email-liheng40@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1596079918-41115-1-git-send-email-liheng40@huawei.com>
References: <1596079918-41115-1-git-send-email-liheng40@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.104.57]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes coccicheck warning:

./drivers/scsi/qla2xxx/qla_mbx.c:4928:15-33: WARNING: dma_alloc_coherent use in els_cmd_map already zeroes out memory,  so memset is not needed

dma_alloc_coherent use in status already zeroes out memory, so memset is not needed

Signed-off-by: Li Heng <liheng40@huawei.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 7388343..14656da 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4933,8 +4933,6 @@ qla25xx_set_els_cmds_supported(scsi_qla_host_t *vha)
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 
-	memset(els_cmd_map, 0, ELS_CMD_MAP_SIZE);
-
 	/* List of Purex ELS */
 	cmd_opcode[0] = ELS_FPIN;
 	cmd_opcode[1] = ELS_RDP;
-- 
2.7.4

