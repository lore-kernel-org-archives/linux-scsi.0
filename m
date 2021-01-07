Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C56C433E6
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 11:44:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E66202333C
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 11:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbhAGLo3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 06:44:29 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10116 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbhAGLo3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 06:44:29 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DBPVf1MTKz15pGG;
        Thu,  7 Jan 2021 19:42:50 +0800 (CST)
Received: from [10.174.178.6] (10.174.178.6) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.498.0; Thu, 7 Jan 2021
 19:43:39 +0800
From:   lijinlin <lijinlin3@huawei.com>
Subject: scsi: Add diagnostic log for scsi device reset
To:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linfeilong@huawei.com>, <liuzhiqiang26@huawei.com>
Message-ID: <c391120e-897a-0ee1-d01a-0defe504d6df@huawei.com>
Date:   Thu, 7 Jan 2021 19:43:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.6]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: lijinlin <lijinlin3@huawei.com>

For enhancing diagnosis capability when scsi device reset£¬we direct print
these logs which are infrequently printed, and add disk name to logs.

logs as follow:
[  550.268049] sd 3:0:0:0: [sdc] Sending device reset
[  550.268053] sd 3:0:0:0: [sdc] Sending target reset
[  550.268055] sd 3:0:0:0: [sdc] Sending bus reset
[  550.268056] sd 3:0:0:0: [sdc] Sending host reset

Signed-off-by: lijinlin <lijinlin3@huawei.com>
---
 drivers/scsi/scsi_error.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f11f51e..3e62ade 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1507,9 +1507,10 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 		if (!bdr_scmd)
 			continue;
 
-		SCSI_LOG_ERROR_RECOVERY(3,
+		if (bdr_scmd->request && bdr_scmd->request->rq_disk)
 			sdev_printk(KERN_INFO, sdev,
-				     "%s: Sending BDR\n", current->comm));
+				     "[%s] Sending device reset\n",
+				     bdr_scmd->request->rq_disk->disk_name);
 		rtn = scsi_try_bus_device_reset(bdr_scmd);
 		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
 			if (!scsi_device_online(sdev) ||
@@ -1570,10 +1571,10 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 		scmd = list_entry(tmp_list.next, struct scsi_cmnd, eh_entry);
 		id = scmd_id(scmd);
 
-		SCSI_LOG_ERROR_RECOVERY(3,
-			shost_printk(KERN_INFO, shost,
-				     "%s: Sending target reset to target %d\n",
-				     current->comm, id));
+		if (scmd->device && scmd->request && scmd->request->rq_disk)
+			sdev_printk(KERN_INFO, scmd->device,
+				     "[%s] Sending target reset\n",
+				     scmd->request->rq_disk->disk_name);
 		rtn = scsi_try_target_reset(scmd);
 		if (rtn != SUCCESS && rtn != FAST_IO_FAIL)
 			SCSI_LOG_ERROR_RECOVERY(3,
@@ -1644,10 +1645,11 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 
 		if (!chan_scmd)
 			continue;
-		SCSI_LOG_ERROR_RECOVERY(3,
-			shost_printk(KERN_INFO, shost,
-				     "%s: Sending BRST chan: %d\n",
-				     current->comm, channel));
+		if (chan_scmd->device && chan_scmd->request
+			&& chan_scmd->request->rq_disk)
+			sdev_printk(KERN_INFO, chan_scmd->device,
+				     "[%s] Sending bus reset\n",
+				     chan_scmd->request->rq_disk->disk_name);
 		rtn = scsi_try_bus_reset(chan_scmd);
 		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
 			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
@@ -1688,11 +1690,10 @@ static int scsi_eh_host_reset(struct Scsi_Host *shost,
 		scmd = list_entry(work_q->next,
 				  struct scsi_cmnd, eh_entry);
 
-		SCSI_LOG_ERROR_RECOVERY(3,
-			shost_printk(KERN_INFO, shost,
-				     "%s: Sending HRST\n",
-				     current->comm));
-
+		if (scmd->device && scmd->request && scmd->request->rq_disk)
+			sdev_printk(KERN_INFO, scmd->device,
+				     "[%s] Sending host reset\n",
+				     scmd->request->rq_disk->disk_name);
 		rtn = scsi_try_host_reset(scmd);
 		if (rtn == SUCCESS) {
 			list_splice_init(work_q, &check_list);
-- 
1.8.3.1

