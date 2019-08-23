Return-Path: <SRS0=qm3h=WT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03F3FC3A5A3
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 13:49:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB4AD22CE3
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 13:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393439AbfHWNtq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Aug 2019 09:49:46 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:37054 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391014AbfHWNtq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Aug 2019 09:49:46 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 14E9BEA417E13A549CD3;
        Fri, 23 Aug 2019 21:49:41 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Fri, 23 Aug 2019
 21:49:33 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH 1/2] scsi: csiostor: remove set but not used variables 'mc_bist_status_rdata_reg','edc_bist_status_rdata_reg'
Date:   Fri, 23 Aug 2019 21:56:03 +0800
Message-ID: <1566568564-55636-2-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566568564-55636-1-git-send-email-zhengbin13@huawei.com>
References: <1566568564-55636-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/csiostor/csio_hw_t5.c: In function csio_t5_mc_read:
drivers/scsi/csiostor/csio_hw_t5.c:151:11: warning: variable mc_bist_status_rdata_reg set but not used [-Wunused-but-set-variable]
drivers/scsi/csiostor/csio_hw_t5.c: In function csio_t5_edc_read:
drivers/scsi/csiostor/csio_hw_t5.c:199:38: warning: variable edc_bist_status_rdata_reg set but not used [-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/scsi/csiostor/csio_hw_t5.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_hw_t5.c b/drivers/scsi/csiostor/csio_hw_t5.c
index f24def6..1df8891 100644
--- a/drivers/scsi/csiostor/csio_hw_t5.c
+++ b/drivers/scsi/csiostor/csio_hw_t5.c
@@ -148,12 +148,11 @@ csio_t5_mc_read(struct csio_hw *hw, int idx, uint32_t addr, __be32 *data,
 {
 	int i;
 	uint32_t mc_bist_cmd_reg, mc_bist_cmd_addr_reg, mc_bist_cmd_len_reg;
-	uint32_t mc_bist_status_rdata_reg, mc_bist_data_pattern_reg;
+	uint32_t mc_bist_data_pattern_reg;

 	mc_bist_cmd_reg = MC_REG(MC_P_BIST_CMD_A, idx);
 	mc_bist_cmd_addr_reg = MC_REG(MC_P_BIST_CMD_ADDR_A, idx);
 	mc_bist_cmd_len_reg = MC_REG(MC_P_BIST_CMD_LEN_A, idx);
-	mc_bist_status_rdata_reg = MC_REG(MC_P_BIST_STATUS_RDATA_A, idx);
 	mc_bist_data_pattern_reg = MC_REG(MC_P_BIST_DATA_PATTERN_A, idx);

 	if (csio_rd_reg32(hw, mc_bist_cmd_reg) & START_BIST_F)
@@ -196,7 +195,7 @@ csio_t5_edc_read(struct csio_hw *hw, int idx, uint32_t addr, __be32 *data,
 {
 	int i;
 	uint32_t edc_bist_cmd_reg, edc_bist_cmd_addr_reg, edc_bist_cmd_len_reg;
-	uint32_t edc_bist_cmd_data_pattern, edc_bist_status_rdata_reg;
+	uint32_t edc_bist_cmd_data_pattern;

 /*
  * These macro are missing in t4_regs.h file.
@@ -208,7 +207,6 @@ csio_t5_edc_read(struct csio_hw *hw, int idx, uint32_t addr, __be32 *data,
 	edc_bist_cmd_addr_reg = EDC_REG_T5(EDC_H_BIST_CMD_ADDR_A, idx);
 	edc_bist_cmd_len_reg = EDC_REG_T5(EDC_H_BIST_CMD_LEN_A, idx);
 	edc_bist_cmd_data_pattern = EDC_REG_T5(EDC_H_BIST_DATA_PATTERN_A, idx);
-	edc_bist_status_rdata_reg = EDC_REG_T5(EDC_H_BIST_STATUS_RDATA_A, idx);
 #undef EDC_REG_T5
 #undef EDC_STRIDE_T5

--
2.7.4

