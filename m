Return-Path: <SRS0=xqUt=CC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85B0AC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 16:38:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D6A523101
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 16:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598287115;
	bh=a4AFxIIbHQK9Lqw9oBlSp8gM0Wf/4JFV3vGKeiNeUr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ns3li8j8M5kN15MEvkn9nWe/dURp06OnLQ9od32hofSCdc7X6SO7hdEXCIlmxNhEi
	 RpkEuC5u8KFKkwNB3LNKEapvSvrYk+1Eo7M+UqFRxK8r99aWCzjemncvgqVYz0qvcL
	 KUoVAC1+aJluabMTboXUrILwO2wIMGHb5+A/PY2I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbgHXQia (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Aug 2020 12:38:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728417AbgHXQiI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Aug 2020 12:38:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7EBA23109;
        Mon, 24 Aug 2020 16:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598287046;
        bh=a4AFxIIbHQK9Lqw9oBlSp8gM0Wf/4JFV3vGKeiNeUr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JfM11/p1+8wywJG7ddZlJgBEzALchWUgPRkRFNZ+bQ1rp1D+Ij0e3OXYWKh+9arLI
         2DTVIEWqyLSsXF5JB3T2Idjm3JJLyEeHdPrnHgJ904dAm4AYPA7qVT1QuOASqJT0cD
         T7Bm6UouZ+gQsN5GbsAcJNdWHAC2yC3uZE/JSJzE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 37/54] scsi: qla2xxx: Flush all sessions on zone disable
Date:   Mon, 24 Aug 2020 12:36:16 -0400
Message-Id: <20200824163634.606093-37-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163634.606093-1-sashal@kernel.org>
References: <20200824163634.606093-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit 10ae30ba664822f62de169a61628e31c999c7cc8 ]

On Zone Disable, certain switches would ignore all commands. This causes
timeout for both switch scan command and abort of that command. On
detection of this condition, all sessions will be shutdown.

Link: https://lore.kernel.org/r/20200806111014.28434-2-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_gs.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index df670fba2ab8a..c6b6a3250312e 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3736,6 +3736,18 @@ static void qla2x00_async_gpnft_gnnft_sp_done(srb_t *sp, int res)
 		unsigned long flags;
 		const char *name = sp->name;
 
+		if (res == QLA_OS_TIMER_EXPIRED) {
+			/* switch is ignoring all commands.
+			 * This might be a zone disable behavior.
+			 * This means we hit 64s timeout.
+			 * 22s GPNFT + 44s Abort = 64s
+			 */
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+			       "%s: Switch Zone check please .\n",
+			       name);
+			qla2x00_mark_all_devices_lost(vha);
+		}
+
 		/*
 		 * We are in an Interrupt context, queue up this
 		 * sp for GNNFT_DONE work. This will allow all
-- 
2.25.1

