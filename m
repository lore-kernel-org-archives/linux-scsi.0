Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A046CCA9EA3
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 08:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8519221925
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 08:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442198AbfJRIRf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 04:17:35 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4726 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404268AbfJRIRe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Oct 2019 04:17:34 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B038C8FFBA145C611A77;
        Fri, 18 Oct 2019 16:17:29 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Fri, 18 Oct 2019
 16:17:22 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <bvanassche@acm.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <yanaijie@huawei.com>,
        <zhengbin13@huawei.com>
Subject: [PATCH v5 06/13] scsi: scsi_dh_emc: need to check the result of scsi_execute in send_trespass_cmd
Date:   Fri, 18 Oct 2019 16:24:24 +0800
Message-ID: <1571387071-28853-7-git-send-email-zhengbin13@huawei.com>
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
 drivers/scsi/device_handler/scsi_dh_emc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index caa685c..cf49378 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -267,7 +267,8 @@ static int send_trespass_cmd(struct scsi_device *sdev,
 			&sshdr, CLARIION_TIMEOUT * HZ, CLARIION_RETRIES,
 			req_flags, 0, NULL);
 	if (err) {
-		if (scsi_sense_valid(&sshdr))
+		if (driver_byte(err) == DRIVER_SENSE &&
+		    scsi_sense_valid(&sshdr))
 			res = trespass_endio(sdev, &sshdr);
 		else {
 			sdev_printk(KERN_INFO, sdev,
--
2.7.4

