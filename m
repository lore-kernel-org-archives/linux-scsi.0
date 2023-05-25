Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43CDCC7EE37
	for <linux-scsi@archiver.kernel.org>; Thu, 25 May 2023 18:52:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242950AbjEYSw0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 May 2023 14:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243114AbjEYSuC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 May 2023 14:50:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E7610F7;
        Thu, 25 May 2023 11:43:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 081C36491E;
        Thu, 25 May 2023 18:42:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3927C4339B;
        Thu, 25 May 2023 18:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685040138;
        bh=A26bl6n8M+GBGCuAhppbt1BjGA3qsnwVaz0FvlrNgqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qumGv2hQEW5aFQwOH8u/ad3TvJidaczWE7cHV0a179LDTQzfEmXUiG00nJMUQTOF/
         KElwGjk4YAxDlxR/iLr3/BARGXkcPnlQIbNdafvpK5XipsVPIMPWBceumFf34+cCjK
         HDY3Cp4h17OW8HKVmEyL3dULvwL86dQWi/TjcvkarrsXQcNeXt/b/BmxAXJs+BuniZ
         LGOG8qRyMQrnnZJE6ivBDaye/EKd7Xa5nuFxwEvOHjaSWrzJ5UzJQ8GQOmYGJKX3s/
         kfPVy3trCmN5JQfNZS/H/bxJ2RGXHx+C/XVE+/pvj6W1W7zYZ/qCgQR8M/nBLEyvH+
         qlc/VXZqVnQRA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenchao Hao <haowenchao2@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 25/31] scsi: core: Decrease scsi_device's iorequest_cnt if dispatch failed
Date:   Thu, 25 May 2023 14:40:56 -0400
Message-Id: <20230525184105.1909399-25-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230525184105.1909399-1-sashal@kernel.org>
References: <20230525184105.1909399-1-sashal@kernel.org>
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
index 6f3d29d16d1f4..99b90031500b2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1490,6 +1490,7 @@ static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		 */
 		SCSI_LOG_MLQUEUE(3, scmd_printk(KERN_INFO, cmd,
 			"queuecommand : device blocked\n"));
+		atomic_dec(&cmd->device->iorequest_cnt);
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 	}
 
@@ -1522,6 +1523,7 @@ static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 	trace_scsi_dispatch_cmd_start(cmd);
 	rtn = host->hostt->queuecommand(host, cmd);
 	if (rtn) {
+		atomic_dec(&cmd->device->iorequest_cnt);
 		trace_scsi_dispatch_cmd_error(cmd, rtn);
 		if (rtn != SCSI_MLQUEUE_DEVICE_BUSY &&
 		    rtn != SCSI_MLQUEUE_TARGET_BUSY)
-- 
2.39.2

