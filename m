Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DF18C43464
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 02:52:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C09E235F8
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 02:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600397541;
	bh=R0cYLuCf/RXxmg0SWDR4nzFewjhj6tgTJf0VaNdYvKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=CpyGVV41CsWNL2cts8l1no2fEzYYqd6wpe9FNza2ibIS5OZ0gcTsG9Q8UW5BoVmrC
	 xfTpaOhjRgpWy5kgHs5oBQBCiWNAsNAHbYe5g6DneK4LMLecQBbqoWmnS2aNvtgr3P
	 pWFBatb1QPxg5C8Tnqg+15JakwikccwHMeifuiv8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbgIRCwU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 22:52:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728064AbgIRCIT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Sep 2020 22:08:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83BEA2395C;
        Fri, 18 Sep 2020 02:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394892;
        bh=R0cYLuCf/RXxmg0SWDR4nzFewjhj6tgTJf0VaNdYvKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hNXSfAGCsjV0mL9F7TEB5Rk1saFLl/mP1nkoskHtTOOlx9aaS2Ec0oT8sPnTMmGmn
         5A+JKF6+78ESTDFxaLUNf/Z82WuBH46ldnGpPjsiCrUGdScQhLxbH3klqLu5SkpD0F
         +Q3Hk5UjwhfFjRbeN/PBmQnwyUE9Rafrx74aTQto=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Balsundar P <balsundar.p@microsemi.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 007/206] scsi: aacraid: fix illegal IO beyond last LBA
Date:   Thu, 17 Sep 2020 22:04:43 -0400
Message-Id: <20200918020802.2065198-7-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Balsundar P <balsundar.p@microsemi.com>

[ Upstream commit c86fbe484c10b2cd1e770770db2d6b2c88801c1d ]

The driver fails to handle data when read or written beyond device reported
LBA, which triggers kernel panic

Link: https://lore.kernel.org/r/1571120524-6037-2-git-send-email-balsundar.p@microsemi.com
Signed-off-by: Balsundar P <balsundar.p@microsemi.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/aacraid/aachba.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 6e356325d8d98..54717fb84a54c 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -2481,13 +2481,13 @@ static int aac_read(struct scsi_cmnd * scsicmd)
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
 			SAM_STAT_CHECK_CONDITION;
 		set_sense(&dev->fsa_dev[cid].sense_data,
-			  HARDWARE_ERROR, SENCODE_INTERNAL_TARGET_FAILURE,
+			  ILLEGAL_REQUEST, SENCODE_LBA_OUT_OF_RANGE,
 			  ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0);
 		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
 		       min_t(size_t, sizeof(dev->fsa_dev[cid].sense_data),
 			     SCSI_SENSE_BUFFERSIZE));
 		scsicmd->scsi_done(scsicmd);
-		return 1;
+		return 0;
 	}
 
 	dprintk((KERN_DEBUG "aac_read[cpu %d]: lba = %llu, t = %ld.\n",
@@ -2573,13 +2573,13 @@ static int aac_write(struct scsi_cmnd * scsicmd)
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
 			SAM_STAT_CHECK_CONDITION;
 		set_sense(&dev->fsa_dev[cid].sense_data,
-			  HARDWARE_ERROR, SENCODE_INTERNAL_TARGET_FAILURE,
+			  ILLEGAL_REQUEST, SENCODE_LBA_OUT_OF_RANGE,
 			  ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0);
 		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
 		       min_t(size_t, sizeof(dev->fsa_dev[cid].sense_data),
 			     SCSI_SENSE_BUFFERSIZE));
 		scsicmd->scsi_done(scsicmd);
-		return 1;
+		return 0;
 	}
 
 	dprintk((KERN_DEBUG "aac_write[cpu %d]: lba = %llu, t = %ld.\n",
-- 
2.25.1

