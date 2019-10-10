Return-Path: <SRS0=UT6l=YD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7711C4360C
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 08:32:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B993720B7C
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 08:32:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="bYuLU9t8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733206AbfJJIcB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Oct 2019 04:32:01 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:62789 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729932AbfJJIcB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Oct 2019 04:32:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1570696320; x=1602232320;
  h=from:to:cc:subject:date:message-id;
  bh=8W9YAqRHao26ckZMHtY8ZQIxisHMTa8clE3FZOTy9bw=;
  b=bYuLU9t8aSLIguo/DFFrr4KC6w5S5fn17hzVb+716MFbb7Pl2QfSEj0G
   fg5SrEHpUlqFDckvw/nKbjv4LYZA0dPODzhXZZzL1CPGOEox2fr5o+wC/
   L/1Xf5J0Igcp4ywJUFzo7dAxOHE6hnScHu1HkEyYxyqqVpvGjuvaYWnHq
   hL/0JlR+7+zu3/9SF/XgBwOJkW4mRpG6MlPbnxb0VVKSysm6mKTHeAmH6
   hLM+2bmnjUveDXInHkp0jVel3A7WwzrtWs2pIIq2AQ2QIhSIG9Ku10EXh
   8GcHz1yqzTaw/bifsz/1H7MvJySFX6Qk95D2WuKp5N33bPS0azgk4V8pI
   Q==;
IronPort-SDR: 94sNE4nX6p87g2cS8k8/a66/E6F353brDST/PX09OsWlb/UBdZ4Cjg3HBCfcricISbGrmYXaUw
 DZEDCuLmzTcHh/t67eAzYMomPlCyCTDWH6Pn3d91Qml36HBDfBnwobmfY5GZONho+65QipH0TM
 nD10NCYGqAbD3gK2cMapsyHkDRmsF2L8M+2y0DzbygmIoe3ibuanWhmfzi9Q4Y9A73HZM8SOfa
 Pxjqv8H/5ClR8sb3d/yqjtn4rYYkKkrABFt8GmVENSgXXgdXfMtSPRvmDkVrlPLbuHfmVmJjTx
 CU8=
X-IronPort-AV: E=Sophos;i="5.67,279,1566835200"; 
   d="scan'208";a="121813444"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Oct 2019 16:32:00 +0800
IronPort-SDR: 8iv+4QwaUtZAGCG8TF7/iy32El7OuQLE7mvZHJQTn9TrnP/WEFy6wnw4Zf7PHmgpp2WdEhV0r0
 nnbYC3coY4l/arMkuQ3jMfzHaWpbQjv04cc0lQIbZBBDiWPShBUueHxlE/eh5b+jPny1YgxKIF
 fmyxUwmWoBRCzwKPIUHRKYPrgw5fMfkuA39buS5yYZuJp8+3l5ROqkaIRlRhqp6yRMtzQHqnQt
 ZGS0rgirwrxOKDifTnqM/ogxKQnBM57xPoAB8xd48xcTygCMQkqKRDnveWs6qzW4Y4sBeCYQGM
 ZIdIHdbwVdA11MJVXJm8l/Oh
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2019 01:27:58 -0700
IronPort-SDR: YGGVg2A3ajXG5P9aGPKXcTXZAn58ZT5AoLObNX3/PN6xmuOwHmzJGFdhowC/UQ6CHlGx9mGRos
 Bmup3igGRgjX5CcWsJliYp95BM4+8MTjnZoxmhPMEaOhgM4XoUGhRcUakx3Yixo83RcoZGoc6w
 YLlbFp/cNR3YT0ypgLBWUhcWjFWsmx9Vki1tQmseAGximYW9N/WjlTWUAXRTj7tjuCiSgPVRiT
 7bsHgsf3RYVsNa9EMUfTRKwu0ucMR/KmUfUyVOBe6wQ6GDc84Q8FdzNmMtfSb9hTdU+p/DTNbB
 EBc=
WDCIronportException: Internal
Received: from ile422988.sdcorp.global.sandisk.com ([10.0.231.246])
  by uls-op-cesaip01.wdc.com with ESMTP; 10 Oct 2019 01:31:58 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        linux-scsi@vger.kernel.org
Cc:     Avi Shchislowski <avi.shchislowski@wdc.com>,
        Alex Lemberg <alex.lemberg@wdc.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH] scsi: ufs-bsg: Wake the device before sending raw upiu commands
Date:   Thu, 10 Oct 2019 11:31:07 +0300
Message-Id: <1570696267-8487-1-git-send-email-avri.altman@wdc.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The scsi async probe process is calling blk_pm_runtime_init for each
lun, and then those request queues are monitored by the block layer pm
engine (blk-pm.c).  This is however, not the case for scsi-passthrough
queues, created by bsg_setup_queue().

So the ufs-bsg driver might send various commands, disregarding the pm
status of the device. This is wrong, regardless if its request queue is
pm-aware or not.

Fixes: df032bf27a41 (scsi: ufs: Add a bsg endpoint that supports UPIUs)

Signed-off-by: Avri Altman <avri.altman@wdc.com>
Reported-by:  Yuliy Izrailov <yuliy.izrailov@wdc.com>
---
 drivers/scsi/ufs/ufs_bsg.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
index a9344eb..dc2f6d2 100644
--- a/drivers/scsi/ufs/ufs_bsg.c
+++ b/drivers/scsi/ufs/ufs_bsg.c
@@ -98,6 +98,8 @@ static int ufs_bsg_request(struct bsg_job *job)
 
 	bsg_reply->reply_payload_rcv_len = 0;
 
+	pm_runtime_get_sync(hba->dev);
+
 	msgcode = bsg_request->msgcode;
 	switch (msgcode) {
 	case UPIU_TRANSACTION_QUERY_REQ:
@@ -135,6 +137,8 @@ static int ufs_bsg_request(struct bsg_job *job)
 		break;
 	}
 
+	pm_runtime_put_sync(hba->dev);
+
 	if (!desc_buff)
 		goto out;
 
-- 
2.7.4

