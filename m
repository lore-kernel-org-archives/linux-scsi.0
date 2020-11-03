Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B7D5C388F2
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 11:56:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 352D3206F1
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 11:56:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgKCL4f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 06:56:35 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:6696 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbgKCL4f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2020 06:56:35 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CQStR0xXvz15QX0;
        Tue,  3 Nov 2020 19:56:31 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Tue, 3 Nov 2020 19:56:26 +0800
From:   Jing Xiangfeng <jingxiangfeng@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jingxiangfeng@huawei.com>
Subject: [PATCH] scsi: qla4xxx: Remove redundant assignment to variable rval
Date:   Tue, 3 Nov 2020 20:01:37 +0800
Message-ID: <20201103120137.109717-1-jingxiangfeng@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The variable rval has been initialized with 'QLA_ERROR'. The assignment
is redundant in an error path. So remove it.

Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 676778cbc550..aaccbf71dff5 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -686,7 +686,6 @@ static int qla4xxx_get_chap_by_index(struct scsi_qla_host *ha,
 
 	if (!ha->chap_list) {
 		ql4_printk(KERN_ERR, ha, "CHAP table cache is empty!\n");
-		rval = QLA_ERROR;
 		goto exit_get_chap;
 	}
 
@@ -698,14 +697,12 @@ static int qla4xxx_get_chap_by_index(struct scsi_qla_host *ha,
 
 	if (chap_index > max_chap_entries) {
 		ql4_printk(KERN_ERR, ha, "Invalid Chap index\n");
-		rval = QLA_ERROR;
 		goto exit_get_chap;
 	}
 
 	*chap_entry = (struct ql4_chap_table *)ha->chap_list + chap_index;
 	if ((*chap_entry)->cookie !=
 	     __constant_cpu_to_le16(CHAP_VALID_COOKIE)) {
-		rval = QLA_ERROR;
 		*chap_entry = NULL;
 	} else {
 		rval = QLA_SUCCESS;
-- 
2.17.1

