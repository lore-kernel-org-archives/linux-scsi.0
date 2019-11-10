Return-Path: <SRS0=5ueY=ZC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F30DCC43331
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Nov 2019 02:45:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDA8221655
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Nov 2019 02:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573353908;
	bh=h74CyComC6k5V4ED1SOpCza5IBa+Ykwmr9amfdKUrkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=HeTquLyta52VFMgYOtvuHH/QhaHw8WMCJpz/ibHYMfi/KkToK5CQAdis3vi4v3fgZ
	 Xwf5DAAIIz1ly3H5VjDLwaxcppqeZtvxvj66sl4ccNJL8AQ0N4ktN4LM+WbrYkatvw
	 50I1BH1sIBmnobwc1uavzVUgqSotbU1dYGpgoJCU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728736AbfKJCpH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Nov 2019 21:45:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:45844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727533AbfKJCpG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 9 Nov 2019 21:45:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3350721848;
        Sun, 10 Nov 2019 02:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353905;
        bh=h74CyComC6k5V4ED1SOpCza5IBa+Ykwmr9amfdKUrkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cvowxg3e62dcU+CfKGcOPnHHOPlFcS4KGJMnf6gDLG72hT6b6IHwPIWyQj364BtD7
         2NocAG5WuA/tQIEu9EMg30K7Po2fqxzOf8LszwDMWxYnXlzA5b1ZMt9/lTRdFGyu1w
         I+PJk/a+wso4pmhdobeCa8Tkol26hYexHHTTruXM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 170/191] scsi: NCR5380: Withhold disconnect privilege for REQUEST SENSE
Date:   Sat,  9 Nov 2019 21:39:52 -0500
Message-Id: <20191110024013.29782-170-sashal@kernel.org>
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

[ Upstream commit 7c8ed783c2faa1e3f741844ffac41340338ea0f4 ]

This is mostly needed because an AztecMonster II target has been observed
disconnecting REQUEST SENSE commands and then failing to reselect properly.

Suggested-by: Michael Schmitz <schmitzmic@gmail.com>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/NCR5380.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index d600d3e94ba4a..144bb0c2b3064 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -938,6 +938,8 @@ static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 	int len;
 	int err;
 	bool ret = true;
+	bool can_disconnect = instance->irq != NO_IRQ &&
+			      cmd->cmnd[0] != REQUEST_SENSE;
 
 	NCR5380_dprint(NDEBUG_ARBITRATION, instance);
 	dsprintk(NDEBUG_ARBITRATION, instance, "starting arbitration, id = %d\n",
@@ -1157,7 +1159,7 @@ static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 
 	dsprintk(NDEBUG_SELECTION, instance, "target %d selected, going into MESSAGE OUT phase.\n",
 	         scmd_id(cmd));
-	tmp[0] = IDENTIFY(((instance->irq == NO_IRQ) ? 0 : 1), cmd->device->lun);
+	tmp[0] = IDENTIFY(can_disconnect, cmd->device->lun);
 
 	len = 1;
 	data = tmp;
-- 
2.20.1

