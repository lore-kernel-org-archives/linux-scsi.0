Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53DF4C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 08:31:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24A59600EF
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 08:31:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235235AbhD0IcP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 04:32:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:49680 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235180AbhD0IcB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 04:32:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7D40BB122;
        Tue, 27 Apr 2021 08:31:06 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 19/40] dc395: translate message bytes
Date:   Tue, 27 Apr 2021 10:30:25 +0200
Message-Id: <20210427083046.31620-20-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210427083046.31620-1-hare@suse.de>
References: <20210427083046.31620-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Drop message byte setting if the host byte is already set, and
translate message bytes into the related host bytes when evaluating
an overrun or underrun.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/dc395x.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 598448ece8d0..24c7cefb0b78 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -3226,7 +3226,6 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		}
 		dprintkdbg(DBG_0, "srb_done: AUTO_REQSENSE2\n");
 
-		set_msg_byte(cmd, srb->end_message);
 		set_status_byte(cmd, SAM_STAT_CHECK_CONDITION);
 
 		goto ckc_e;
@@ -3260,7 +3259,6 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		} else {
 			srb->adapter_status = 0;
 			set_host_byte(cmd, DID_ERROR);
-			set_msg_byte(cmd, srb->end_message);
 			set_status_byte(cmd, status);
 		}
 	} else {
@@ -3270,10 +3268,9 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		status = srb->adapter_status;
 		if (status & H_OVER_UNDER_RUN) {
 			srb->target_status = 0;
-			set_msg_byte(cmd, srb->end_message);
+			scsi_msg_to_host_byte(cmd, srb->end_message);
 		} else if (srb->status & PARITY_ERROR) {
 			set_host_byte(cmd, DID_PARITY);
-			set_msg_byte(cmd, srb->end_message);
 		} else {	/* No error */
 
 			srb->adapter_status = 0;
-- 
2.29.2

