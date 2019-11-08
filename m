Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1DFDFC6196
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 12:06:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0828215EA
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 12:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573214784;
	bh=uTKsTivW0RpecLbaYmvvG3ITNtocrjUSNEeJ/vh93D8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=nJMWhdM/47n51JYlwicpFmEqlQWqX4j+610I6U2MlR1H+dIgznLyQCgmgJaNvCXV+
	 6FvpTZHp4E7He9EHbuKFWUFQGY0kGh+2/MoBaeaWZPjah1xw2M/7g8OLODVwBV+Tho
	 8aynOHn644dBjWF4OxYcrK1inc2sa9n+Lm9eA8Uo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390075AbfKHMGX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 07:06:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:54552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389269AbfKHLlR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 8 Nov 2019 06:41:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D9C3222D1;
        Fri,  8 Nov 2019 11:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213277;
        bh=uTKsTivW0RpecLbaYmvvG3ITNtocrjUSNEeJ/vh93D8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pca/xqiWRctBggkXhUUfzFc3aUEWYVs98QzlKsaLB3b67UrtQ92YWq2DeE2xqIqsm
         ioQfZkcWKKidhU10M8ZoDsG7OZ16Z4vAIeUEO6qZDMZ3m+nQ9ixp8LyPkLlnte27NQ
         II1R3KgL14sRRPLXlcZv/WcHvjJmJP+3IzXxa4vk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <quinn.tran@cavium.com>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 138/205] scsi: qla2xxx: Fix iIDMA error
Date:   Fri,  8 Nov 2019 06:36:45 -0500
Message-Id: <20191108113752.12502-138-sashal@kernel.org>
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

From: Quinn Tran <quinn.tran@cavium.com>

[ Upstream commit 8d9bf0a9a268f7ca0b811d6e6a1fc783afa5c746 ]

When switch responds with error for Get Port Speed Command (GPSC), driver
should not proceed with telling FW about the speed of the remote port.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_gs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 34ff4bbc8de10..d611cf722244c 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3277,7 +3277,7 @@ static void qla24xx_async_gpsc_sp_done(void *s, int res)
 			ql_dbg(ql_dbg_disc, vha, 0x2019,
 			    "GPSC command unsupported, disabling query.\n");
 			ha->flags.gpsc_supported = 0;
-			res = QLA_SUCCESS;
+			goto done;
 		}
 	} else {
 		switch (be16_to_cpu(ct_rsp->rsp.gpsc.speed)) {
@@ -3310,7 +3310,6 @@ static void qla24xx_async_gpsc_sp_done(void *s, int res)
 		    be16_to_cpu(ct_rsp->rsp.gpsc.speeds),
 		    be16_to_cpu(ct_rsp->rsp.gpsc.speed));
 	}
-done:
 	memset(&ea, 0, sizeof(ea));
 	ea.event = FCME_GPSC_DONE;
 	ea.rc = res;
@@ -3318,6 +3317,7 @@ done:
 	ea.sp = sp;
 	qla2x00_fcport_event_handler(vha, &ea);
 
+done:
 	sp->free(sp);
 }
 
-- 
2.20.1

