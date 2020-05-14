Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11341C433E4
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 19:02:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC3DE2065F
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 19:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589482944;
	bh=Uiy3VQeypLsAQY+/YaG/683+rhD9rnz4IxkD2LlG6TI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=R2iMUPV965ngzcEv67DUqAjZ/aFCfAPuvF5y3j9dSc9Q1fbxxLohwQxxEG6A3QdiI
	 jnjP4rfH9URwvdjdwcS+A7AO4v0imzW3Hah3Vo9q2suB84vs30eGKmbsepRR04NRiF
	 i5/RAZ9meKwI2MQ54t3AubkABflUESSigeqx4N0w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729786AbgENTCU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 15:02:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729306AbgENSzJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 May 2020 14:55:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3D4920820;
        Thu, 14 May 2020 18:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482508;
        bh=Uiy3VQeypLsAQY+/YaG/683+rhD9rnz4IxkD2LlG6TI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vSL0wf+R8MUQlQqSioDFVNjlYMZoQXv21UVx+3B7OcbGqoB6eZx2p6f1Xt0nqniBS
         q44awcLG/0Dzan2H4YRGMiffLIxMIz+BC3xlaol36P0tdnLy2fhdMusQEOk0FARksL
         otb1ZraeK/3RmM2vHUPVtFyBmLou66b0Y2Z2Z4+o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arun Easi <aeasi@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 09/39] scsi: qla2xxx: Fix hang when issuing nvme disconnect-all in NPIV
Date:   Thu, 14 May 2020 14:54:26 -0400
Message-Id: <20200514185456.21060-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185456.21060-1-sashal@kernel.org>
References: <20200514185456.21060-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

[ Upstream commit 45a76264c26fd8cfd0c9746196892d9b7e2657ee ]

In NPIV environment, a NPIV host may use a queue pair created by base host
or other NPIVs, so the check for a queue pair created by this NPIV is not
correct, and can cause an abort to fail, which in turn means the NVME
command not returned.  This leads to hang in nvme_fc layer in
nvme_fc_delete_association() which waits for all I/Os to be returned, which
is seen as hang in the application.

Link: https://lore.kernel.org/r/20200331104015.24868-3-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 5e8ae510aef80..9d9737114dcf0 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2998,7 +2998,7 @@ qla24xx_abort_command(srb_t *sp)
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x108c,
 	    "Entered %s.\n", __func__);
 
-	if (vha->flags.qpairs_available && sp->qpair)
+	if (sp->qpair)
 		req = sp->qpair->req;
 
 	if (ql2xasynctmfenable)
-- 
2.20.1

