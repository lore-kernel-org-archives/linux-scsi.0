Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AB69CA9ED7
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF28020656
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbfKDJCO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 04:02:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:57146 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727327AbfKDJCN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Nov 2019 04:02:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5D9E0B2CB;
        Mon,  4 Nov 2019 09:02:10 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/52] 3w-xxxx: use standard SAM status codes
Date:   Mon,  4 Nov 2019 10:01:06 +0100
Message-Id: <20191104090151.129140-8-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191104090151.129140-1-hare@suse.de>
References: <20191104090151.129140-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use standard SAM status codes and omit the explicit shift to convert
from linux-specific ones.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/3w-xxxx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 2b1e0d503020..79eca8f1fd05 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -429,7 +429,7 @@ static int tw_decode_sense(TW_Device_Extension *tw_dev, int request_id, int fill
 					/* Additional sense code qualifier */
 					tw_dev->srb[request_id]->sense_buffer[13] = tw_sense_table[i][3];
 
-					tw_dev->srb[request_id]->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
+					tw_dev->srb[request_id]->result = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
 					return TW_ISR_DONT_RESULT; /* Special case for isr to not over-write result */
 				}
 			}
@@ -2164,7 +2164,7 @@ static irqreturn_t tw_interrupt(int irq, void *dev_instance)
 				/* If error, command failed */
 				if (error == 1) {
 					/* Ask for a host reset */
-					tw_dev->srb[request_id]->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
+					tw_dev->srb[request_id]->result = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
 				}
 
 				/* Now complete the io */
-- 
2.16.4

