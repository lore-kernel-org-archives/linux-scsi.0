Return-Path: <SRS0=5ueY=ZC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F045C17440
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Nov 2019 03:08:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14D4A222C4
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Nov 2019 03:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573355281;
	bh=pf2pAqyeX+jV3FFFGFlVj7wA519RpuOPTu8xAEris6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=J6yChn2AgDKyu4VYmtZBYAv1he7cmk7m1T5S5PXywMqouJt9TAwrksOh1FLQuyFL3
	 3FHSSfUGzUW/JNjUE9fwv2UzaITLLkD+DnMMDHaGigVGQ7L4PmeEN58YfvcpkvJaDs
	 ReaFTQt3RWE+ErEHuD/6FVs8wYT6wZ1j6qXj8JEI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbfKJDHv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Nov 2019 22:07:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:46028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727737AbfKJCpL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 9 Nov 2019 21:45:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B357D21655;
        Sun, 10 Nov 2019 02:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353910;
        bh=pf2pAqyeX+jV3FFFGFlVj7wA519RpuOPTu8xAEris6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p2gB/c2ai5WMujliWQCX45Hf2JL6Eq0BjjsEV1U2BKfJdaXf9xdzuwa0sjceBaa/Z
         pQrd/2YdksXgR7O3I/NK0IlHzOfTf3nmZ8PFMTYAtxzzAuHnZXgSWt9qhtzxGBPW88
         VkCTVSnWwxg//T9JylEawr2isNPQQ79YikrEoHEQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 174/191] scsi: NCR5380: Don't call dsprintk() following reselection interrupt
Date:   Sat,  9 Nov 2019 21:39:56 -0500
Message-Id: <20191110024013.29782-174-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit 08267216b3f8aa5adc204bdccf8deb72c1cd7665 ]

The X3T9.2 specification (draft) says, under "6.1.4.1 RESELECTION",

    ... The reselected initiator shall then assert the BSY signal
    within a selection abort time of its most recent detection of being
    reselected; this is required for correct operation of the time-out
    procedure.

The selection abort time is only 200 us which may be insufficient time for a
printk() call. Move the diagnostics to the error paths.

Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/NCR5380.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 227ceb5197555..5c3ffb466bb10 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -2015,8 +2015,6 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 		return;
 	}
 
-	dsprintk(NDEBUG_RESELECTION, instance, "reselect\n");
-
 	/*
 	 * At this point, we have detected that our SCSI ID is on the bus,
 	 * SEL is true and BSY was false for at least one bus settle delay
@@ -2029,6 +2027,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_BSY);
 	if (NCR5380_poll_politely(hostdata,
 	                          STATUS_REG, SR_SEL, 0, 2 * HZ) < 0) {
+		shost_printk(KERN_ERR, instance, "reselect: !SEL timeout\n");
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		return;
 	}
@@ -2040,6 +2039,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 
 	if (NCR5380_poll_politely(hostdata,
 	                          STATUS_REG, SR_REQ, SR_REQ, 2 * HZ) < 0) {
+		shost_printk(KERN_ERR, instance, "reselect: REQ timeout\n");
 		do_abort(instance);
 		return;
 	}
-- 
2.20.1

