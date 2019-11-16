Return-Path: <SRS0=ZMHN=ZI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 767E7C43215
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 03:47:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57D5E2073C
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 03:47:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbfKPDrk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Nov 2019 22:47:40 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:35240 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727290AbfKPDrk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Nov 2019 22:47:40 -0500
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id 749262A71A; Fri, 15 Nov 2019 22:47:39 -0500 (EST)
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "Michael Schmitz" <schmitzmic@gmail.com>,
        "Ondrej Zary" <linux@zary.sk>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <1f26ead9dd0dc053fcd27979d69a7ca74b6589b4.1573875417.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH] NCR5380: Call scsi_set_resid() on command completion
Date:   Sat, 16 Nov 2019 14:36:57 +1100
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Most NCR5380 drivers calculate the residual for every data transfer.
(A few drivers just set it to zero.) Pass this quantity back to the
scsi mid-layer on command completion.

Cc: Michael Schmitz <schmitzmic@gmail.com>
Cc: Ondrej Zary <linux@zary.sk>
Reviewed-and-tested-by: Michael Schmitz <schmitzmic@gmail.com>
Tested-by: Ondrej Zary <linux@zary.sk>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/NCR5380.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index d4401c768a0c..3ea2557e7938 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -175,6 +175,19 @@ static inline void advance_sg_buffer(struct scsi_cmnd *cmd)
 	}
 }
 
+static inline void set_resid_from_SCp(struct scsi_cmnd *cmd)
+{
+	int resid = cmd->SCp.this_residual;
+	struct scatterlist *s = cmd->SCp.buffer;
+
+	if (s)
+		while (!sg_is_last(s)) {
+			s = sg_next(s);
+			resid += s->length;
+		}
+	scsi_set_resid(cmd, resid);
+}
+
 /**
  * NCR5380_poll_politely2 - wait for two chip register values
  * @hostdata: host private data
@@ -1807,6 +1820,8 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 					cmd->result |= cmd->SCp.Status;
 					cmd->result |= cmd->SCp.Message << 8;
 
+					set_resid_from_SCp(cmd);
+
 					if (cmd->cmnd[0] == REQUEST_SENSE)
 						complete_cmd(instance, cmd);
 					else {
-- 
2.23.0

