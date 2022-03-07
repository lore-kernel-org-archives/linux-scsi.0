Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BBFAC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Mar 2022 11:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242111AbiCGLbM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 06:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242085AbiCGLbC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 06:31:02 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1241028E1C
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 03:18:44 -0800 (PST)
X-UUID: b4b65282214a439aad2746082a62a926-20220307
X-UUID: b4b65282214a439aad2746082a62a926-20220307
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 314915228; Mon, 07 Mar 2022 19:18:39 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Mon, 7 Mar 2022 19:18:38 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 7 Mar 2022 19:18:38 +0800
From:   <peter.wang@mediatek.com>
To:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
        <powen.kao@mediatek.com>, <qilin.tan@mediatek.com>,
        <lin.gui@mediatek.com>, <mikebi@micron.com>, <beanhuo@micron.com>
Subject: [PATCH v1] scsi: ufs: scsi_get_lba error fix by check cmd opcode
Date:   Mon, 7 Mar 2022 19:17:52 +0800
Message-ID: <20220307111752.10465-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

When ufs init without scmd->device->sector_size set,
scsi_get_lba will get a wrong shift number and ubsan error.
shift exponent 4294967286 is too large for 64-bit type
'sector_t' (aka 'unsigned long long')
Call scsi_get_lba only when opcode is READ_10/WRITE_10/UNMAP.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/scsi/ufs/ufshcd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9349557b8a01..3c4caee8fb93 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -367,7 +367,7 @@ static void ufshcd_add_uic_command_trace(struct ufs_hba *hba,
 static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 				     enum ufs_trace_str_t str_t)
 {
-	u64 lba;
+	u64 lba = 0;
 	u8 opcode = 0, group_id = 0;
 	u32 intr, doorbell;
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
@@ -384,7 +384,6 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 		return;
 
 	opcode = cmd->cmnd[0];
-	lba = scsi_get_lba(cmd);
 
 	if (opcode == READ_10 || opcode == WRITE_10) {
 		/*
@@ -392,6 +391,7 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 		 */
 		transfer_len =
 		       be32_to_cpu(lrbp->ucd_req_ptr->sc.exp_data_transfer_len);
+		lba = scsi_get_lba(cmd);
 		if (opcode == WRITE_10)
 			group_id = lrbp->cmd->cmnd[6];
 	} else if (opcode == UNMAP) {
@@ -399,6 +399,7 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 		 * The number of Bytes to be unmapped beginning with the lba.
 		 */
 		transfer_len = blk_rq_bytes(rq);
+		lba = scsi_get_lba(cmd);
 	}
 
 	intr = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
-- 
2.18.0

