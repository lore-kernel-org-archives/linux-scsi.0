Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72F23C8300B
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 09:56:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BFB1214D8
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 09:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgD3J4O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 05:56:14 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3399 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726404AbgD3J4N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 05:56:13 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 42939D7958846926E965;
        Thu, 30 Apr 2020 17:56:11 +0800 (CST)
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Thu, 30 Apr 2020 17:56:03 +0800
From:   Zou Wei <zou_wei@huawei.com>
To:     <aacraid@microsemi.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zou Wei <zou_wei@huawei.com>
Subject: [PATCH -next] scsi: aacraid: Make some symbols static
Date:   Thu, 30 Apr 2020 18:02:12 +0800
Message-ID: <1588240932-69020-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following sparse warnings:

drivers/scsi/aacraid/linit.c:867:6: warning:
symbol 'aac_tmf_callback' was not declared. Should it be static?
drivers/scsi/aacraid/linit.c:1081:5: warning:
symbol 'aac_eh_host_reset' was not declared. Should it be static?
drivers/scsi/aacraid/commsup.c:2354:5: warning:
symbol 'aac_send_safw_hostttime' was not declared. Should it be static?
drivers/scsi/aacraid/commsup.c:2383:5: warning:
symbol 'aac_send_hosttime' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
---
 drivers/scsi/aacraid/commsup.c | 4 ++--
 drivers/scsi/aacraid/linit.c   | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index ddd73f6..8ee4e1a 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -2351,7 +2351,7 @@ static int aac_send_wellness_command(struct aac_dev *dev, char *wellness_str,
 	goto out;
 }
 
-int aac_send_safw_hostttime(struct aac_dev *dev, struct timespec64 *now)
+static int aac_send_safw_hostttime(struct aac_dev *dev, struct timespec64 *now)
 {
 	struct tm cur_tm;
 	char wellness_str[] = "<HW>TD\010\0\0\0\0\0\0\0\0\0DW\0\0ZZ";
@@ -2380,7 +2380,7 @@ int aac_send_safw_hostttime(struct aac_dev *dev, struct timespec64 *now)
 	return ret;
 }
 
-int aac_send_hosttime(struct aac_dev *dev, struct timespec64 *now)
+static int aac_send_hosttime(struct aac_dev *dev, struct timespec64 *now)
 {
 	int ret = -ENOMEM;
 	struct fib *fibptr;
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index a0a2b3a..a308e86 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -864,7 +864,7 @@ static u8 aac_eh_tmf_hard_reset_fib(struct aac_hba_map_info *info,
        return HBA_IU_TYPE_SATA_REQ;
 }
 
-void aac_tmf_callback(void *context, struct fib *fibptr)
+static void aac_tmf_callback(void *context, struct fib *fibptr)
 {
 	struct aac_hba_resp *err =
 		&((struct aac_native_hba *)fibptr->hw_fib_va)->resp.err;
@@ -1078,7 +1078,7 @@ static int aac_eh_bus_reset(struct scsi_cmnd* cmd)
  *	@scsi_cmd:	SCSI command block causing the reset
  *
  */
-int aac_eh_host_reset(struct scsi_cmnd *cmd)
+static int aac_eh_host_reset(struct scsi_cmnd *cmd)
 {
 	struct scsi_device * dev = cmd->device;
 	struct Scsi_Host * host = dev->host;
-- 
2.6.2

