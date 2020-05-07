Return-Path: <SRS0=AKtJ=6V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 502DEC38A24
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 14:28:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 117CB208DB
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 14:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588861722;
	bh=yECwZmYvnmWb9rCcZYE6vRcGIgNGoAKZPtn/KzfGO88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=WLAHcmFf85dFKsEWXNCup7CKrUJ0bp7qjsGuQCNQLRurm2O7/xY5BfhEFEsOex0SE
	 Fv4CTCbzN4TKkaZszvsMYhpeyw0TXonhB/HYPMVmTLaTzuow96usAgwpoxIRG2V6xm
	 QexlDL8xQDEQdist/1ME7ifv3e3SxbH9TsFIbxkI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbgEGO2l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 10:28:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728201AbgEGO2k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 May 2020 10:28:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 292652145D;
        Thu,  7 May 2020 14:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861720;
        bh=yECwZmYvnmWb9rCcZYE6vRcGIgNGoAKZPtn/KzfGO88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c9whM9U0Ubnx/KDiPhwYtnEJCQ2yP7o1rTdGbj5EkpZiQvBwCRmql6fl3OoszLwYu
         z8GusWGyqFtUjQv5AhA5hbydslfQTJ7hH9E6UK9cISwLbSwOxLk1ksakbARXWeCKAy
         GUs+9AHJgdITBFbUW2ZIy7MAdP+F9gdC03ZzVsTg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Wilck <mwilck@suse.com>, Arun Easi <aeasi@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 07/35] scsi: qla2xxx: check UNLOADING before posting async work
Date:   Thu,  7 May 2020 10:28:01 -0400
Message-Id: <20200507142830.26239-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142830.26239-1-sashal@kernel.org>
References: <20200507142830.26239-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

[ Upstream commit 5a263892d7d0b4fe351363f8d1a14c6a75955475 ]

qlt_free_session_done() tries to post async PRLO / LOGO, and waits for the
completion of these async commands. If UNLOADING is set, this is doomed to
timeout, because the async logout command will never complete.

The only way to avoid waiting pointlessly is to fail posting these commands
in the first place if the driver is in UNLOADING state.  In general,
posting any command should be avoided when the driver is UNLOADING.

With this patch, "rmmod qla2xxx" completes without noticeable delay.

Link: https://lore.kernel.org/r/20200421204621.19228-3-mwilck@suse.com
Fixes: 45235022da99 ("scsi: qla2xxx: Fix driver unload by shutting down chip")
Acked-by: Arun Easi <aeasi@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7c588c5b5f6e3..03d272a09e26d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4857,6 +4857,9 @@ qla2x00_alloc_work(struct scsi_qla_host *vha, enum qla_work_type type)
 	struct qla_work_evt *e;
 	uint8_t bail;
 
+	if (test_bit(UNLOADING, &vha->dpc_flags))
+		return NULL;
+
 	QLA_VHA_MARK_BUSY(vha, bail);
 	if (bail)
 		return NULL;
-- 
2.20.1

