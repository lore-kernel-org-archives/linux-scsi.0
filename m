Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD972CA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 08:17:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C22FA21925
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 08:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504793AbfJRIRk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 04:17:40 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4686 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2442192AbfJRIRh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Oct 2019 04:17:37 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C7F95E95AFB6B0DBA3E2;
        Fri, 18 Oct 2019 16:17:34 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Fri, 18 Oct 2019
 16:17:25 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <bvanassche@acm.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <yanaijie@huawei.com>,
        <zhengbin13@huawei.com>
Subject: [PATCH v5 13/13] scsi: ch: need to check whether sshdr is valid in ch_do_scsi
Date:   Fri, 18 Oct 2019 16:24:31 +0800
Message-ID: <1571387071-28853-14-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571387071-28853-1-git-send-email-zhengbin13@huawei.com>
References: <1571387071-28853-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Like sd_pr_command, before use sshdr, we need to check whether
sshdr is valid.

Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/scsi/ch.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 76751d6..dba6fe2 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -200,7 +200,7 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 				  buflength, &sshdr, timeout * HZ,
 				  MAX_RETRIES, NULL);

-	if (driver_byte(result) == DRIVER_SENSE) {
+	if (driver_byte(result) == DRIVER_SENSE && scsi_sense_valid(&sshdr)) {
 		if (debug)
 			scsi_print_sense_hdr(ch->device, ch->name, &sshdr);
 		errno = ch_find_errno(&sshdr);
@@ -212,7 +212,9 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 				goto retry;
 			break;
 		}
-	}
+	} else if (result)
+		errno = -EIO;
+
 	return errno;
 }

--
2.7.4

