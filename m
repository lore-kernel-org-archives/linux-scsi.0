Return-Path: <SRS0=BT6k=WS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46D63C3A5A1
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 13:42:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 233FA233A2
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 13:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389217AbfHVNmU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Aug 2019 09:42:20 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:48596 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387649AbfHVNmU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Aug 2019 09:42:20 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id CECD0D3167181D4A5089;
        Thu, 22 Aug 2019 21:41:39 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Thu, 22 Aug 2019
 21:41:31 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <QLogic-Storage-Upstream@qlogic.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH 1/3] scsi: qla4xxx: remove set but not used variables 'data_size','poll','mask'
Date:   Thu, 22 Aug 2019 21:47:59 +0800
Message-ID: <1566481681-92765-2-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566481681-92765-1-git-send-email-zhengbin13@huawei.com>
References: <1566481681-92765-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/qla4xxx/ql4_nx.c: In function qla4_84xx_minidump_process_rddfe:
drivers/scsi/qla4xxx/ql4_nx.c:2648:23: warning: variable data_size set but not used [-Wunused-but-set-variable]
drivers/scsi/qla4xxx/ql4_nx.c: In function qla4_84xx_minidump_process_rdmdio:
drivers/scsi/qla4xxx/ql4_nx.c:2745:11: warning: variable poll set but not used [-Wunused-but-set-variable]
drivers/scsi/qla4xxx/ql4_nx.c: In function qla4_84xx_minidump_process_pollwr:
drivers/scsi/qla4xxx/ql4_nx.c:2816:47: warning: variable mask set but not used [-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/scsi/qla4xxx/ql4_nx.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 5a31877..85666fb 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -2645,7 +2645,7 @@ static uint32_t qla4_84xx_minidump_process_rddfe(struct scsi_qla_host *ha,
 	uint32_t addr1, addr2, value, data, temp, wrval;
 	uint8_t stride, stride2;
 	uint16_t count;
-	uint32_t poll, mask, data_size, modify_mask;
+	uint32_t poll, mask, modify_mask;
 	uint32_t wait_count = 0;
 	uint32_t *data_ptr = *d_ptr;
 	struct qla8044_minidump_entry_rddfe *rddfe;
@@ -2661,7 +2661,6 @@ static uint32_t qla4_84xx_minidump_process_rddfe(struct scsi_qla_host *ha,
 	poll = le32_to_cpu(rddfe->poll);
 	mask = le32_to_cpu(rddfe->mask);
 	modify_mask = le32_to_cpu(rddfe->modify_mask);
-	data_size = le32_to_cpu(rddfe->data_size);

 	addr2 = addr1 + stride;

@@ -2742,7 +2741,7 @@ static uint32_t qla4_84xx_minidump_process_rdmdio(struct scsi_qla_host *ha,
 	uint8_t stride1, stride2;
 	uint32_t addr3, addr4, addr5, addr6, addr7;
 	uint16_t count, loop_cnt;
-	uint32_t poll, mask;
+	uint32_t mask;
 	uint32_t *data_ptr = *d_ptr;
 	struct qla8044_minidump_entry_rdmdio *rdmdio;

@@ -2754,7 +2753,6 @@ static uint32_t qla4_84xx_minidump_process_rdmdio(struct scsi_qla_host *ha,
 	stride2 = le32_to_cpu(rdmdio->stride_2);
 	count = le32_to_cpu(rdmdio->count);

-	poll = le32_to_cpu(rdmdio->poll);
 	mask = le32_to_cpu(rdmdio->mask);
 	value2 = le32_to_cpu(rdmdio->value_2);

@@ -2813,7 +2811,7 @@ static uint32_t qla4_84xx_minidump_process_pollwr(struct scsi_qla_host *ha,
 				struct qla8xxx_minidump_entry_hdr *entry_hdr,
 				uint32_t **d_ptr)
 {
-	uint32_t addr1, addr2, value1, value2, poll, mask, r_value;
+	uint32_t addr1, addr2, value1, value2, poll, r_value;
 	struct qla8044_minidump_entry_pollwr *pollwr_hdr;
 	uint32_t wait_count = 0;
 	uint32_t rval = QLA_SUCCESS;
@@ -2825,7 +2823,6 @@ static uint32_t qla4_84xx_minidump_process_pollwr(struct scsi_qla_host *ha,
 	value2 = le32_to_cpu(pollwr_hdr->value_2);

 	poll = le32_to_cpu(pollwr_hdr->poll);
-	mask = le32_to_cpu(pollwr_hdr->mask);

 	while (wait_count < poll) {
 		ha->isp_ops->rd_reg_indirect(ha, addr1, &r_value);
--
2.7.4

