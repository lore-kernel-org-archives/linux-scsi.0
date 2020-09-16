Return-Path: <SRS0=FSVS=CZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DBEFC433E2
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 02:26:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0301320BED
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 02:26:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgIPC0s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 22:26:48 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12713 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726200AbgIPC0p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Sep 2020 22:26:45 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 551856E4D75F669F6DB3;
        Wed, 16 Sep 2020 10:26:43 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Wed, 16 Sep 2020
 10:26:34 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <njavali@marvell.com>, <mrangankar@marvell.com>,
        <linux-scsi@vger.kernel.org>
CC:     Ye Bin <yebin10@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] scsi: qla4xxx: Delete unneeded variable 'status' in qla4xxx_process_ddb_changed
Date:   Wed, 16 Sep 2020 10:27:49 +0800
Message-ID: <20200916022749.348923-1-yebin10@huawei.com>
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

Fixes coccicheck warning:
drivers/scsi/qla4xxx/ql4_init.c:1173:5-11: Unneeded variable: "status". Return "QLA_ERROR" on line 1195

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 drivers/scsi/qla4xxx/ql4_init.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 4a7ef971a387..6444f4bb61b3 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -1170,7 +1170,6 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha,
 				uint32_t state, uint32_t conn_err)
 {
 	struct ddb_entry *ddb_entry;
-	int status = QLA_ERROR;
 
 	/* check for out of range index */
 	if (fw_ddb_index >= MAX_DDB_ENTRIES)
@@ -1192,7 +1191,7 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha,
 	ddb_entry->ddb_change(ha, fw_ddb_index, ddb_entry, state);
 
 exit_ddb_event:
-	return status;
+	return QLA_ERROR;
 }
 
 /**
-- 
2.25.4

