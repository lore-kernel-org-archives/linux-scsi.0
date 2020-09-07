Return-Path: <SRS0=wipa=CQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D069CC43461
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 07:46:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AFF121481
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 07:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgIGHqc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Sep 2020 03:46:32 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:45658 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727835AbgIGHqI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Sep 2020 03:46:08 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 536D46BEB3307514F75B;
        Mon,  7 Sep 2020 15:46:07 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Mon, 7 Sep 2020
 15:45:59 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <mdr@sgi.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <yanaijie@huawei.com>, <tbogendoerfer@suse.de>,
        <linux-scsi@vger.kernel.org>
CC:     Hulk Robot <hulkci@huawei.com>
Subject: [PATCH 2/4] scsi: qla1280: remove set but not used variable in qla1280_nvram_config()
Date:   Mon, 7 Sep 2020 15:45:16 +0800
Message-ID: <20200907074518.2326360-3-yanaijie@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200907074518.2326360-1-yanaijie@huawei.com>
References: <20200907074518.2326360-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This addresses the following gcc warning with "make W=1":

drivers/scsi/qla1280.c: In function ‘qla1280_nvram_config’:
drivers/scsi/qla1280.c:2188:36: warning: variable ‘ddma_conf’ set but
not used [-Wunused-but-set-variable]
 2188 |   uint16_t hwrev, cfg1, cdma_conf, ddma_conf;
      |                                    ^~~~~~~~~

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/qla1280.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 42c68bd98fa5..72f92733e75f 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -2184,13 +2184,12 @@ qla1280_nvram_config(struct scsi_qla_host *ha)
 		nv->cntr_flags_1.disable_loading_risc_code;
 
 	if (IS_ISP1040(ha)) {
-		uint16_t hwrev, cfg1, cdma_conf, ddma_conf;
+		uint16_t hwrev, cfg1, cdma_conf;
 
 		hwrev = RD_REG_WORD(&reg->cfg_0) & ISP_CFG0_HWMSK;
 
 		cfg1 = RD_REG_WORD(&reg->cfg_1) & ~(BIT_4 | BIT_5 | BIT_6);
 		cdma_conf = RD_REG_WORD(&reg->cdma_cfg);
-		ddma_conf = RD_REG_WORD(&reg->ddma_cfg);
 
 		/* Busted fifo, says mjacob. */
 		if (hwrev != ISP_CFG0_1040A)
-- 
2.25.4

