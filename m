Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16363C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 02:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E936B20885
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 02:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592446737;
	bh=n77+mRGJzhZkF3sMpgr1Vq43gLpGDv+qKc9vyAuvuic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=2ChTqZ/m3oQF/APMoDUV/FU1dfm+pm/RjyoZ3zpdeVvpr4oIcTYtGrXWKiY7yxZac
	 wp37xsgcL1P9pafK8JYg9KMfvgPfI0brT4HxHnkxXM2LR6PbqEUkKyCxYg4FUx9hWo
	 yIGRs0twsIi893n1zfwf6qVBNeOCjJGrp4tw8OxU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730150AbgFRBTc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 21:19:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:51192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729264AbgFRBT3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Jun 2020 21:19:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 516E921D90;
        Thu, 18 Jun 2020 01:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443167;
        bh=n77+mRGJzhZkF3sMpgr1Vq43gLpGDv+qKc9vyAuvuic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HFDccdtRBKIB85YX4gj/2jByiku7BFBWG23ma49olDgRD017yWo4bOvTqGuhgSOfM
         cWc71OduWIB+a/xCua82hmVp2JuZjoZD72CIGBVIhZQc6aEqcatR7mBU79MLNCo5MF
         WTer5qTLriFBvpufHAs5VqN5vzrmYPt4A+/Ldfi0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 132/266] scsi: target: loopback: Fix READ with data and sensebytes
Date:   Wed, 17 Jun 2020 21:14:17 -0400
Message-Id: <20200618011631.604574-132-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bodo Stroesser <bstroesser@ts.fujitsu.com>

[ Upstream commit c68a56736c129f5dd1632856956f9c3e04bae200 ]

We use tcm_loop with tape emulations running on tcmu.

In case application reads a short tape block with a longer READ, or a long
tape block with a short READ, according to SCC spec data has to be
tranferred _and_ sensebytes with ILI set and information field containing
the residual count. Similar problem also exists when using fixed block
size in READ.

Up to now tcm_loop is not prepared to handle sensebytes if input data is
provided, as in tcm_loop_queue_data_in() it only sets SAM_STAT_GOOD and, if
necessary, the residual count.

To fix the bug, the same handling for sensebytes as present in
tcm_loop_queue_status() must be done in tcm_loop_queue_data_in() also.

After adding this handling, the two function now are nearly identical, so I
created a single function with two wrappers.

Link: https://lore.kernel.org/r/20200428182617.32726-1-bstroesser@ts.fujitsu.com
Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/loopback/tcm_loop.c | 36 +++++++++++++-----------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 3305b47fdf53..16d5a4e117a2 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -545,32 +545,15 @@ static int tcm_loop_write_pending(struct se_cmd *se_cmd)
 	return 0;
 }
 
-static int tcm_loop_queue_data_in(struct se_cmd *se_cmd)
+static int tcm_loop_queue_data_or_status(const char *func,
+		struct se_cmd *se_cmd, u8 scsi_status)
 {
 	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
 				struct tcm_loop_cmd, tl_se_cmd);
 	struct scsi_cmnd *sc = tl_cmd->sc;
 
 	pr_debug("%s() called for scsi_cmnd: %p cdb: 0x%02x\n",
-		 __func__, sc, sc->cmnd[0]);
-
-	sc->result = SAM_STAT_GOOD;
-	set_host_byte(sc, DID_OK);
-	if ((se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT) ||
-	    (se_cmd->se_cmd_flags & SCF_UNDERFLOW_BIT))
-		scsi_set_resid(sc, se_cmd->residual_count);
-	sc->scsi_done(sc);
-	return 0;
-}
-
-static int tcm_loop_queue_status(struct se_cmd *se_cmd)
-{
-	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
-				struct tcm_loop_cmd, tl_se_cmd);
-	struct scsi_cmnd *sc = tl_cmd->sc;
-
-	pr_debug("%s() called for scsi_cmnd: %p cdb: 0x%02x\n",
-		 __func__, sc, sc->cmnd[0]);
+		 func, sc, sc->cmnd[0]);
 
 	if (se_cmd->sense_buffer &&
 	   ((se_cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) ||
@@ -581,7 +564,7 @@ static int tcm_loop_queue_status(struct se_cmd *se_cmd)
 		sc->result = SAM_STAT_CHECK_CONDITION;
 		set_driver_byte(sc, DRIVER_SENSE);
 	} else
-		sc->result = se_cmd->scsi_status;
+		sc->result = scsi_status;
 
 	set_host_byte(sc, DID_OK);
 	if ((se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT) ||
@@ -591,6 +574,17 @@ static int tcm_loop_queue_status(struct se_cmd *se_cmd)
 	return 0;
 }
 
+static int tcm_loop_queue_data_in(struct se_cmd *se_cmd)
+{
+	return tcm_loop_queue_data_or_status(__func__, se_cmd, SAM_STAT_GOOD);
+}
+
+static int tcm_loop_queue_status(struct se_cmd *se_cmd)
+{
+	return tcm_loop_queue_data_or_status(__func__,
+					     se_cmd, se_cmd->scsi_status);
+}
+
 static void tcm_loop_queue_tm_rsp(struct se_cmd *se_cmd)
 {
 	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
-- 
2.25.1

