Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3820EC7EE2C
	for <linux-scsi@archiver.kernel.org>; Thu, 25 May 2023 18:46:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235290AbjEYSqC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 May 2023 14:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242732AbjEYSpU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 May 2023 14:45:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C69E2717;
        Thu, 25 May 2023 11:41:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6320C60B52;
        Thu, 25 May 2023 18:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4FCC4339E;
        Thu, 25 May 2023 18:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685040037;
        bh=P9Aoq5Ja1OS9F7yWNtSuaurV9h9sWdmec6R6/fv86m4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SU5Gdcu+UksTBaNzE2iXA5q5n8cNw3N3DGIMH+sbFujRKM8LjeRVGqrhb6Ovgwic7
         kFiJTSuNT+ioSDkdgtg5nRp0qb7iuX4NV5du1SdT9C2d2LuIrUfQ10vGUiO+12RcM5
         aqCk3+nAG1Wu6fG4CzXCyFBz9B6p10MxT3yDyI/ncnyAj7pSynyKETD5mg/rRg88Q4
         fA3dBMsqT6EycnmXyjePbMHfeeDJsYbnnYXdlfz6SGzaLI0LZhKNTQ0wLfnfrLE3SV
         BbFON6gAENyZhB3Ic2QicCbndN3zf/CUXCoLKa/jH+8VRlpAPcuMgPK+KgpzVPHIYX
         Ve+lGHkwYjVrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenchao Hao <haowenchao2@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 34/43] scsi: core: Decrease scsi_device's iorequest_cnt if dispatch failed
Date:   Thu, 25 May 2023 14:38:45 -0400
Message-Id: <20230525183854.1855431-34-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230525183854.1855431-1-sashal@kernel.org>
References: <20230525183854.1855431-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Wenchao Hao <haowenchao2@huawei.com>

[ Upstream commit 09e797c8641f6ad435c33ae24c223351197ea29a ]

If scsi_dispatch_cmd() failed, the SCSI command was not sent to the target,
scsi_queue_rq() would return BLK_STS_RESOURCE and the related request would
be requeued. The timeout of this request would not fire, no one would
increase iodone_cnt.

The above flow would result the iodone_cnt smaller than iorequest_cnt.  So
decrease the iorequest_cnt if dispatch failed to workaround the issue.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
Reported-by: Ming Lei <ming.lei@redhat.com>
Closes: https://lore.kernel.org/r/ZF+zB+bB7iqe0wGd@ovpn-8-17.pek2.redhat.com
Link: https://lore.kernel.org/r/20230515070156.1790181-3-haowenchao2@huawei.com
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_lib.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ef4361b2d1423..5525e6ffee537 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1476,6 +1476,7 @@ static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		 */
 		SCSI_LOG_MLQUEUE(3, scmd_printk(KERN_INFO, cmd,
 			"queuecommand : device blocked\n"));
+		atomic_dec(&cmd->device->iorequest_cnt);
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 	}
 
@@ -1508,6 +1509,7 @@ static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 	trace_scsi_dispatch_cmd_start(cmd);
 	rtn = host->hostt->queuecommand(host, cmd);
 	if (rtn) {
+		atomic_dec(&cmd->device->iorequest_cnt);
 		trace_scsi_dispatch_cmd_error(cmd, rtn);
 		if (rtn != SCSI_MLQUEUE_DEVICE_BUSY &&
 		    rtn != SCSI_MLQUEUE_TARGET_BUSY)
-- 
2.39.2

