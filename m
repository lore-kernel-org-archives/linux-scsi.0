Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AF0FCA9ECF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 444952190F
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbfKDJCS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 04:02:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:57146 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727880AbfKDJCQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Nov 2019 04:02:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F140FB4AF;
        Mon,  4 Nov 2019 09:02:10 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 39/52] stex: use scsi_build_sense()
Date:   Mon,  4 Nov 2019 10:01:38 +0100
Message-Id: <20191104090151.129140-40-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191104090151.129140-1-hare@suse.de>
References: <20191104090151.129140-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_build_sense() to format the sense code.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/stex.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 33287b6bdf0e..b02251868cb9 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -398,11 +398,8 @@ static struct status_msg *stex_get_status(struct st_hba *hba)
 static void stex_invalid_field(struct scsi_cmnd *cmd,
 			       void (*done)(struct scsi_cmnd *))
 {
-	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
-
 	/* "Invalid field in cdb" */
-	scsi_build_sense_buffer(0, cmd->sense_buffer, ILLEGAL_REQUEST, 0x24,
-				0x0);
+	scsi_build_sense(cmd, 0, ILLEGAL_REQUEST, 0x24, 0x0);
 	done(cmd);
 }
 
-- 
2.16.4

