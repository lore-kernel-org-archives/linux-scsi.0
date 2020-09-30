Return-Path: <SRS0=FF5A=DH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E14DFC47423
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 02:24:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6CA320936
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 02:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729902AbgI3CY2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Sep 2020 22:24:28 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:49600 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729798AbgI3CY1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Sep 2020 22:24:27 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id CE87A994562064576D92;
        Wed, 30 Sep 2020 10:24:25 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Wed, 30 Sep 2020
 10:24:18 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <njavali@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>
CC:     Ye Bin <yebin10@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH 1/3] scsi: qla2xxx: Fix inconsistent of format with argument type in tcm_qla2xxx.c
Date:   Wed, 30 Sep 2020 10:25:13 +0800
Message-ID: <20200930022515.2862532-2-yebin10@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200930022515.2862532-1-yebin10@huawei.com>
References: <20200930022515.2862532-1-yebin10@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix follow warnings:
[drivers/scsi/qla2xxx/tcm_qla2xxx.c:884]: (warning) %u in format string (no. 1)
	requires 'unsigned int' but the argument type is 'signed int'.
[drivers/scsi/qla2xxx/tcm_qla2xxx.c:885]: (warning) %u in format string (no. 1)
	requires 'unsigned int' but the argument type is 'signed int'.
[drivers/scsi/qla2xxx/tcm_qla2xxx.c:886]: (warning) %u in format string (no. 1)
	requires 'unsigned int' but the argument type is 'signed int'.
[drivers/scsi/qla2xxx/tcm_qla2xxx.c:887]: (warning) %u in format string (no. 1)
	requires 'unsigned int' but the argument type is 'signed int'.
[drivers/scsi/qla2xxx/tcm_qla2xxx.c:888]: (warning) %u in format string (no. 1)
	requires 'unsigned int' but the argument type is 'signed int'.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 44bfe162654a..61017acd3458 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -850,7 +850,7 @@ static ssize_t tcm_qla2xxx_tpg_attrib_##name##_show(			\
 	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,		\
 			struct tcm_qla2xxx_tpg, se_tpg);		\
 									\
-	return sprintf(page, "%u\n", tpg->tpg_attrib.name);	\
+	return sprintf(page, "%d\n", tpg->tpg_attrib.name);	\
 }									\
 									\
 static ssize_t tcm_qla2xxx_tpg_attrib_##name##_store(			\
-- 
2.25.4

