Return-Path: <SRS0=XSNP=53=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CE35C2BBC7
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Apr 2020 23:23:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13D742084D
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Apr 2020 23:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586647380;
	bh=Oao4RgPcy2O10lDM921sA0JLlS9HRv7oxiB/C9Hl8Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=VsKfezg+Q3sVsQ/N0jZxuOp+z+H/sXHR6Un3Z1jSFZKeWDvCOZmxK/+UQK01AfSMq
	 qlyFfsZ4oMe8ZZ+8GfOfquHpgPMJxvi+UNFCK5a0r56YQOP3GfV8u+D5RjA4UtzHVn
	 YnwV9kskVOgUjhNGvmfkDKGQorzhbpO8YRuevvKA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728397AbgDKXNK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Apr 2020 19:13:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730345AbgDKXNJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 11 Apr 2020 19:13:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C75421835;
        Sat, 11 Apr 2020 23:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646790;
        bh=Oao4RgPcy2O10lDM921sA0JLlS9HRv7oxiB/C9Hl8Q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bvEMgHrNwbZus9izZ1iiPiFF4HfRmwi9zjPYv2shTC/fcAX1TeCcou2NyJxjJ9lkf
         OVaes0ieGQoD6f4+LLW1jdQUnyPoLr+JqorekFsTQBvEXlsusRHfoqkytH/m0iDK+V
         2WSmxssRPBr9FgdDidCp7WndWQN00p0Sdaelni7s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 54/66] scsi: qla2xxx: fix FW resource count values
Date:   Sat, 11 Apr 2020 19:11:51 -0400
Message-Id: <20200411231203.25933-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411231203.25933-1-sashal@kernel.org>
References: <20200411231203.25933-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit ce1ee122e0f048fc67c1259489f0802a28049bfd ]

This patch fixes issue where current and original exchanges count
were swapped for intiator and targets.

Also fix IOCB count for current and original which were swapped.

Link: https://lore.kernel.org/r/20200226224022.24518-9-hmadhani@marvell.com
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_dfs.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 0b190082aa8d9..4c917e43509a5 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -136,11 +136,11 @@ qla_dfs_fw_resource_cnt_show(struct seq_file *s, void *unused)
 	} else {
 		seq_puts(s, "FW Resource count\n\n");
 		seq_printf(s, "Original TGT exchg count[%d]\n", mb[1]);
-		seq_printf(s, "current TGT exchg count[%d]\n", mb[2]);
-		seq_printf(s, "original Initiator Exchange count[%d]\n", mb[3]);
-		seq_printf(s, "Current Initiator Exchange count[%d]\n", mb[6]);
-		seq_printf(s, "Original IOCB count[%d]\n", mb[7]);
-		seq_printf(s, "Current IOCB count[%d]\n", mb[10]);
+		seq_printf(s, "Current TGT exchg count[%d]\n", mb[2]);
+		seq_printf(s, "Current Initiator Exchange count[%d]\n", mb[3]);
+		seq_printf(s, "Original Initiator Exchange count[%d]\n", mb[6]);
+		seq_printf(s, "Current IOCB count[%d]\n", mb[7]);
+		seq_printf(s, "Original IOCB count[%d]\n", mb[10]);
 		seq_printf(s, "MAX VP count[%d]\n", mb[11]);
 		seq_printf(s, "MAX FCF count[%d]\n", mb[12]);
 		seq_printf(s, "Current free pageable XCB buffer cnt[%d]\n",
@@ -151,7 +151,6 @@ qla_dfs_fw_resource_cnt_show(struct seq_file *s, void *unused)
 		    mb[22]);
 		seq_printf(s, "Original Target fast XCB buffer cnt[%d]\n",
 		    mb[23]);
-
 	}
 
 	return 0;
-- 
2.20.1

