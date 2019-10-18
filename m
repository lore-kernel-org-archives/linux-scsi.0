Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAD48CA9EA1
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 08:17:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEEBE21925
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 08:17:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442191AbfJRIRf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 04:17:35 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4723 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404225AbfJRIRe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Oct 2019 04:17:34 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9D5A750AD73045A636D;
        Fri, 18 Oct 2019 16:17:29 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Fri, 18 Oct 2019
 16:17:21 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <bvanassche@acm.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <yanaijie@huawei.com>,
        <zhengbin13@huawei.com>
Subject: [PATCH v5 02/13] scsi: core: need to check the result of scsi_execute in scsi_test_unit_ready
Date:   Fri, 18 Oct 2019 16:24:20 +0800
Message-ID: <1571387071-28853-3-git-send-email-zhengbin13@huawei.com>
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
 drivers/scsi/scsi_lib.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5447738..2970190 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2216,6 +2216,9 @@ scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
 	do {
 		result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0, sshdr,
 					  timeout, 1, NULL);
+		if (driver_byte(result) != DRIVER_SENSE)
+			break;
+
 		if (sdev->removable && scsi_sense_valid(sshdr) &&
 		    sshdr->sense_key == UNIT_ATTENTION)
 			sdev->changed = 1;
--
2.7.4

