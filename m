Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA44EFA372C
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 11:41:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B91A722459
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 11:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573213285;
	bh=8QGmzeogi6k2oblfvGFyTdoWO5OoMRPbPTDlYihF9qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=SRSQrxVO0szvPC0D5xpAPpmE7yKRH2bfN/Hpz8m9QkP+rm8zmn8L5YWCvCLe7mbm7
	 NDePYoN/iDBwjGojq3VMO23HAPJXm+G8fIeHO9daGKHkcq/IJ9TSOPH53AzeC3gEUR
	 PUDkVFqohjy9uI3UKX3mCNMTGBgGQSdP5B7tgBzo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389425AbfKHLlY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 06:41:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:54668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389383AbfKHLlX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 8 Nov 2019 06:41:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E616E222CF;
        Fri,  8 Nov 2019 11:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213282;
        bh=8QGmzeogi6k2oblfvGFyTdoWO5OoMRPbPTDlYihF9qw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GtGrG4MLY1S/Mtn6JNMljWULqjgMi/pnnQYyYubXbTaliM9qb+wFE66ik0N6gU9sT
         dQdjC3d3KgXLpY1LZwFWOFHZvZ33UEuhuemIrQAPpsA42UhDI8q2S6QPX5mp6QCcm0
         kDbOG9LMZHqwjwrsVXZB9FHDvRP5VwIgCVoQqQ20=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sawan Chandak <sawan.chandak@cavium.com>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 143/205] scsi: qla2xxx: Check for Register disconnect
Date:   Fri,  8 Nov 2019 06:36:50 -0500
Message-Id: <20191108113752.12502-143-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Sawan Chandak <sawan.chandak@cavium.com>

[ Upstream commit f99c5d294b3653e6ae563eaac5db5b4138afe31c ]

During adapter shutdown process check for register disconnect before
proceeding to call PCI functions.

Signed-off-by: Sawan Chandak <sawan.chandak@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index bfbdec61b3c6e..cb7f4d59343f0 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1744,6 +1744,7 @@ __qla2x00_abort_all_cmds(struct qla_qpair *qp, int res)
 				    !ha->flags.eeh_busy &&
 				    (!test_bit(ABORT_ISP_ACTIVE,
 					&vha->dpc_flags)) &&
+				    !qla2x00_isp_reg_stat(ha) &&
 				    (sp->type == SRB_SCSI_CMD)) {
 					/*
 					 * Don't abort commands in
-- 
2.20.1

