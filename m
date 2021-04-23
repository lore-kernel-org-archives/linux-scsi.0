Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90C46C43461
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 11:40:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60A4D61139
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 11:40:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242381AbhDWLk7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Apr 2021 07:40:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:47132 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242259AbhDWLkj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Apr 2021 07:40:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 67754B1BE;
        Fri, 23 Apr 2021 11:39:55 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Bart van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 18/39] dc395: translate message bytes
Date:   Fri, 23 Apr 2021 13:39:23 +0200
Message-Id: <20210423113944.42672-19-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210423113944.42672-1-hare@suse.de>
References: <20210423113944.42672-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Drop message byte setting if the host byte is already set, and
translate message bytes into the related host bytes when evaluating
an overrun or underrun.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/dc395x.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 598448ece8d0..db88a250c5ff 100644
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
+			translate_msg_byte(cmd, srb->end_message);
 		} else if (srb->status & PARITY_ERROR) {
 			set_host_byte(cmd, DID_PARITY);
-			set_msg_byte(cmd, srb->end_message);
 		} else {	/* No error */
 
 			srb->adapter_status = 0;
-- 
2.29.2

