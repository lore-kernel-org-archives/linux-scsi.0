Return-Path: <SRS0=tLTu=A4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56493C433E4
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 09:09:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F9A0206F4
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 09:09:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgGQJJA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jul 2020 05:09:00 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:47242 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725864AbgGQJJA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Jul 2020 05:09:00 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id DC150A3F52CDA90B959A;
        Fri, 17 Jul 2020 17:08:57 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Fri, 17 Jul 2020
 17:08:50 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC:     <bvanassche@acm.org>, <sashal@kernel.org>,
        Ye Bin <yebin10@huawei.com>
Subject: [PATCH] scsi: Delete unnecessary allocate buffer for every loop when print command
Date:   Fri, 17 Jul 2020 17:09:21 +0800
Message-ID: <20200717090921.29243-2-yebin10@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200717090921.29243-1-yebin10@huawei.com>
References: <20200717090921.29243-1-yebin10@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We can allocate buffer once, and reuse it. There is unnecessary allocate
 buffer for every loop.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 drivers/scsi/scsi_logging.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
index c91fa3feb930..8ea44c6595ef 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -205,13 +205,9 @@ void scsi_print_command(struct scsi_cmnd *cmd)
 		/* Print opcode in one line and use separate lines for CDB */
 		off += scnprintf(logbuf + off, logbuf_len - off, "\n");
 		dev_printk(KERN_INFO, &cmd->device->sdev_gendev, "%s", logbuf);
-		scsi_log_release_buffer(logbuf);
 		for (k = 0; k < cmd->cmd_len; k += 16) {
 			size_t linelen = min(cmd->cmd_len - k, 16);
 
-			logbuf = scsi_log_reserve_buffer(&logbuf_len);
-			if (!logbuf)
-				break;
 			off = sdev_format_header(logbuf, logbuf_len,
 						 scmd_name(cmd),
 						 cmd->request->tag);
@@ -224,9 +220,8 @@ void scsi_print_command(struct scsi_cmnd *cmd)
 			}
 			dev_printk(KERN_INFO, &cmd->device->sdev_gendev, "%s",
 				   logbuf);
-			scsi_log_release_buffer(logbuf);
 		}
-		return;
+		goto out;
 	}
 	if (!WARN_ON(off > logbuf_len - 49)) {
 		off += scnprintf(logbuf + off, logbuf_len - off, " ");
@@ -236,6 +231,7 @@ void scsi_print_command(struct scsi_cmnd *cmd)
 	}
 out_printk:
 	dev_printk(KERN_INFO, &cmd->device->sdev_gendev, "%s", logbuf);
+out:
 	scsi_log_release_buffer(logbuf);
 }
 EXPORT_SYMBOL(scsi_print_command);
-- 
2.25.4

