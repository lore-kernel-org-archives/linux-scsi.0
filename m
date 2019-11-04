Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65B91CA9ED5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4141E20656
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbfKDJCR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 04:02:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:57280 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726100AbfKDJCP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Nov 2019 04:02:15 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E7C76B4AD;
        Mon,  4 Nov 2019 09:02:10 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 21/52] initio: use standard SAM status definitions
Date:   Mon,  4 Nov 2019 10:01:20 +0100
Message-Id: <20191104090151.129140-22-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191104090151.129140-1-hare@suse.de>
References: <20191104090151.129140-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use standard SAM status definitions and drop the
driver-defined ones.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/initio.c | 2 +-
 drivers/scsi/initio.h | 5 -----
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 41fd64c9c8e9..d1430a39fe46 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -1077,7 +1077,7 @@ static int tulip_main(struct initio_host * host)
 
 		/* Walk the list of completed SCBs */
 		while ((scb = initio_find_done_scb(host)) != NULL) {	/* find done entry */
-			if (scb->tastat == INI_QUEUE_FULL) {
+			if (scb->tastat == SAM_STAT_TASK_SET_FULL) {
 				host->max_tags[scb->target] =
 				    host->act_tags[scb->target] - 1;
 				scb->tastat = 0;
diff --git a/drivers/scsi/initio.h b/drivers/scsi/initio.h
index 219b901bdc25..61bae14fee9e 100644
--- a/drivers/scsi/initio.h
+++ b/drivers/scsi/initio.h
@@ -428,11 +428,6 @@ struct scsi_ctrl_blk {
 #define HOST_SCSI_RST   0x1B
 #define HOST_DEV_RST    0x1C
 
-/* Error Codes for SCB_TaStat */
-#define TARGET_CHKCOND  0x02
-#define TARGET_BUSY     0x08
-#define INI_QUEUE_FULL	0x28
-
 /* SCSI MESSAGE */
 #define MSG_COMP        0x00
 #define MSG_EXTEND      0x01
-- 
2.16.4

