Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 528A1C433ED
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 09:22:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19D2B61105
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 09:22:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234652AbhDBJWP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Apr 2021 05:22:15 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15469 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhDBJWP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Apr 2021 05:22:15 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FBZJk11jBzyNjd;
        Fri,  2 Apr 2021 17:20:06 +0800 (CST)
Received: from huawei.com (10.175.103.91) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.498.0; Fri, 2 Apr 2021
 17:22:10 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <target-devel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
CC:     <martin.petersen@oracle.com>
Subject: [PATCH -next] scsi: target: iscsi: Switch to kmemdup_nul()
Date:   Fri, 2 Apr 2021 17:25:17 +0800
Message-ID: <20210402092517.2445595-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use kmemdup_nul() helper instead of open-coding to
simplify the code.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/target/iscsi/iscsi_target_nego.c       | 4 +---
 drivers/target/iscsi/iscsi_target_parameters.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 151e2949bb75..9a4a632f631d 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -1082,14 +1082,12 @@ int iscsi_target_locate_portal(
 	login_req = (struct iscsi_login_req *) login->req;
 	payload_length = ntoh24(login_req->dlength);
 
-	tmpbuf = kzalloc(payload_length + 1, GFP_KERNEL);
+	tmpbuf = kmemdup_nul(login->req_buf, payload_length, GFP_KERNEL);
 	if (!tmpbuf) {
 		pr_err("Unable to allocate memory for tmpbuf.\n");
 		return -1;
 	}
 
-	memcpy(tmpbuf, login->req_buf, payload_length);
-	tmpbuf[payload_length] = '\0';
 	start = tmpbuf;
 	end = (start + payload_length);
 
diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 7a461fbb1566..6bc3aaf655fc 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -1357,14 +1357,12 @@ int iscsi_decode_text_input(
 	struct iscsi_param_list *param_list = conn->param_list;
 	char *tmpbuf, *start = NULL, *end = NULL;
 
-	tmpbuf = kzalloc(length + 1, GFP_KERNEL);
+	tmpbuf = kmemdup_nul(textbuf, length, GFP_KERNEL);
 	if (!tmpbuf) {
 		pr_err("Unable to allocate %u + 1 bytes for tmpbuf.\n", length);
 		return -ENOMEM;
 	}
 
-	memcpy(tmpbuf, textbuf, length);
-	tmpbuf[length] = '\0';
 	start = tmpbuf;
 	end = (start + length);
 
-- 
2.25.1

