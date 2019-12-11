Return-Path: <SRS0=S2y6=2B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50FB5C2D0C7
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 15:35:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E86324658
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 15:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576078547;
	bh=hem3ebfjLNtne7dQ8qxpZB4aD9lv/NFaA3OZLHfUMIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=njgCWwlKLPZlgnyJmiEfAKLZL1aYHL0m0BGUq2YaRUHD3ecLOMrwhF4XuNMfAUMLi
	 g9FG7GD20OHjFf9KAq2mPVmGHmBls9YhR/I2Mt/uGICYFCHplcKMygBuNjJlSggCaP
	 RdilzSueadY9+gwaAva+Y4inyQmwGyxja1T6e7c4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387571AbfLKPfq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Dec 2019 10:35:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:44948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733091AbfLKPfp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Dec 2019 10:35:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA34522B48;
        Wed, 11 Dec 2019 15:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078544;
        bh=hem3ebfjLNtne7dQ8qxpZB4aD9lv/NFaA3OZLHfUMIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oEXtlU0gc69RLA2tQuvFfBp2P8pZWgsXQnHl5XgMivCfNrXtuxbnRCOLlvJ2Tz4lk
         K3Yl3zRvDHs+sPJ8ML6DfBfycWpvKS8MxU+U+VeOKG6bj1HnKbSq28ecy9A/UT2hYS
         q90ZSIRBqz22TJ8JhoupRd4FLpIr4MdoqKS0UxJ4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     peter chang <dpf@google.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Deepak Ukey <deepak.ukey@microchip.com>,
        Viswas G <Viswas.G@microchip.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, pmchba@pmcs.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 32/42] scsi: pm80xx: Fix for SATA device discovery
Date:   Wed, 11 Dec 2019 10:35:00 -0500
Message-Id: <20191211153510.23861-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211153510.23861-1-sashal@kernel.org>
References: <20191211153510.23861-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: peter chang <dpf@google.com>

[ Upstream commit ce21c63ee995b7a8b7b81245f2cee521f8c3c220 ]

Driver was missing complete() call in mpi_sata_completion which result in
SATA abort error handling timing out. That causes the device to be left in
the in_recovery state so subsequent commands sent to the device fail and
the OS removes access to it.

Link: https://lore.kernel.org/r/20191114100910.6153-2-deepak.ukey@microchip.com
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: peter chang <dpf@google.com>
Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 9edd61c063a1a..df5f0bc295875 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -2368,6 +2368,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			pm8001_printk("task 0x%p done with io_status 0x%x"
 			" resp 0x%x stat 0x%x but aborted by upper layer!\n",
 			t, status, ts->resp, ts->stat));
+		if (t->slow_task)
+			complete(&t->slow_task->completion);
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-- 
2.20.1

