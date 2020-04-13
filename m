Return-Path: <SRS0=9ymf=55=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C00C2BA19
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 11:35:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30AA42073E
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 11:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbgDMLfS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 07:35:18 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:58936 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728960AbgDMLfR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Apr 2020 07:35:17 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E76FF3C5A2E54BFF94E0;
        Mon, 13 Apr 2020 19:35:11 +0800 (CST)
Received: from huawei.com (10.175.102.37) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Mon, 13 Apr 2020
 19:35:03 +0800
From:   Li Bin <huawei.libin@huawei.com>
To:     <dgilbert@interlog.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huawei.libin@huawei.com>, <xiexiuqi@huawei.com>
Subject: [PATCH] scsi: sg: add sg_remove_request in sg_common_write
Date:   Mon, 13 Apr 2020 19:29:21 +0800
Message-ID: <1586777361-17339-1-git-send-email-huawei.libin@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the dxfer_len is greater than 256M that the request is invalid,
it should call sg_remove_request in sg_common_write.

Fixes: f930c7043663 ("scsi: sg: only check for dxfer_len greater than 256M")
Signed-off-by: Li Bin <huawei.libin@huawei.com>
---
 drivers/scsi/sg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 4e6af592..9c0ee19 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -793,8 +793,10 @@ static int get_sg_io_pack_id(int *pack_id, void __user *buf, size_t count)
 			"sg_common_write:  scsi opcode=0x%02x, cmd_size=%d\n",
 			(int) cmnd[0], (int) hp->cmd_len));
 
-	if (hp->dxfer_len >= SZ_256M)
+	if (hp->dxfer_len >= SZ_256M) {
+		sg_remove_request(sfp, srp);
 		return -EINVAL;
+	}
 
 	k = sg_start_req(srp, cmnd);
 	if (k) {
-- 
1.7.12.4

