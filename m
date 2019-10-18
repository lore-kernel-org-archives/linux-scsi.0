Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46303CA9EA1
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 08:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DE9D21925
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 08:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404212AbfJRIRb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 04:17:31 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4724 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731008AbfJRIRb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Oct 2019 04:17:31 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A226A72041FC7C62A339;
        Fri, 18 Oct 2019 16:17:29 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Fri, 18 Oct 2019
 16:17:23 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <bvanassche@acm.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <yanaijie@huawei.com>,
        <zhengbin13@huawei.com>
Subject: [PATCH v5 08/13] scsi: scsi_dh_hp_sw: need to check the result of scsi_execute in hp_sw_tur,hp_sw_start_stop
Date:   Fri, 18 Oct 2019 16:24:26 +0800
Message-ID: <1571387071-28853-9-git-send-email-zhengbin13@huawei.com>
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
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 8acd4bb..be8c139 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -90,7 +90,8 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 	res = scsi_execute(sdev, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
 			HP_SW_TIMEOUT, HP_SW_RETRIES, req_flags, 0, NULL);
 	if (res) {
-		if (scsi_sense_valid(&sshdr))
+		if (driver_byte(res) == DRIVER_SENSE &&
+		    scsi_sense_valid(&sshdr))
 			ret = tur_done(sdev, h, &sshdr);
 		else {
 			sdev_printk(KERN_WARNING, sdev,
@@ -128,7 +129,8 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 	res = scsi_execute(sdev, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
 			HP_SW_TIMEOUT, HP_SW_RETRIES, req_flags, 0, NULL);
 	if (res) {
-		if (!scsi_sense_valid(&sshdr)) {
+		if (driver_byte(result) != DRIVER_SENSE ||
+		    !scsi_sense_valid(&sshdr)) {
 			sdev_printk(KERN_WARNING, sdev,
 				    "%s: sending start_stop_unit failed, "
 				    "no sense available\n", HP_SW_NAME);
--
2.7.4

