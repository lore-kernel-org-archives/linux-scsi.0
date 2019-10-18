Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E5CBCA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 08:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D78E21925
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 08:17:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442202AbfJRIRh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 04:17:37 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4729 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2442167AbfJRIRg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Oct 2019 04:17:36 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B9506A84C06E339B6573;
        Fri, 18 Oct 2019 16:17:29 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Fri, 18 Oct 2019
 16:17:21 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <bvanassche@acm.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <yanaijie@huawei.com>,
        <zhengbin13@huawei.com>
Subject: [PATCH v5 01/13] scsi: core: need to check the result of scsi_execute in scsi_report_opcode
Date:   Fri, 18 Oct 2019 16:24:19 +0800
Message-ID: <1571387071-28853-2-git-send-email-zhengbin13@huawei.com>
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

Like sd_pr_command, before use sshdr, we need to check the result
of scsi_execute.

Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/scsi/scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 4f76841..15d1fe9 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -509,7 +509,7 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
 	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer, len,
 				  &sshdr, 30 * HZ, 3, NULL);

-	if (result && scsi_sense_valid(&sshdr) &&
+	if (driver_byte(result) == DRIVER_SENSE && scsi_sense_valid(&sshdr) &&
 	    sshdr.sense_key == ILLEGAL_REQUEST &&
 	    (sshdr.asc == 0x20 || sshdr.asc == 0x24) && sshdr.ascq == 0x00)
 		return -EINVAL;
--
2.7.4

