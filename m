Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A73ACA9ED3
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A00120656
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbfKDJCS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 04:02:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:57258 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728097AbfKDJCP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Nov 2019 04:02:15 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C2F4AB4A4;
        Mon,  4 Nov 2019 09:02:10 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/52] megaraid_mboxi: use standard SAM status codes
Date:   Mon,  4 Nov 2019 10:01:10 +0100
Message-Id: <20191104090151.129140-12-hare@suse.de>
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
 drivers/scsi/megaraid/megaraid_mbox.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index f6ac819e6e96..dc58c5ff31e4 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -1577,7 +1577,7 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct scsi_cmnd *scp, int *busy)
 				scp->sense_buffer[0] = 0x70;
 				scp->sense_buffer[2] = ILLEGAL_REQUEST;
 				scp->sense_buffer[12] = MEGA_INVALID_FIELD_IN_CDB;
-				scp->result = CHECK_CONDITION << 1;
+				scp->result = SAM_STAT_CHECK_CONDITION;
 				return NULL;
 			}
 
@@ -2302,7 +2302,7 @@ megaraid_mbox_dpc(unsigned long devp)
 						14);
 
 				scp->result = DRIVER_SENSE << 24 |
-					DID_OK << 16 | CHECK_CONDITION << 1;
+					DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
 			}
 			else {
 				if (mbox->cmd == MBOXCMD_EXTPTHRU) {
@@ -2312,11 +2312,11 @@ megaraid_mbox_dpc(unsigned long devp)
 
 					scp->result = DRIVER_SENSE << 24 |
 						DID_OK << 16 |
-						CHECK_CONDITION << 1;
+						SAM_STAT_CHECK_CONDITION;
 				} else {
 					scp->sense_buffer[0] = 0x70;
 					scp->sense_buffer[2] = ABORTED_COMMAND;
-					scp->result = CHECK_CONDITION << 1;
+					scp->result = SAM_STAT_CHECK_CONDITION;
 				}
 			}
 			break;
@@ -2334,7 +2334,7 @@ megaraid_mbox_dpc(unsigned long devp)
 			 */
 			if (scp->cmnd[0] == TEST_UNIT_READY) {
 				scp->result = DID_ERROR << 16 |
-					RESERVATION_CONFLICT << 1;
+					SAM_STAT_RESERVATION_CONFLICT;
 			}
 			else
 			/*
@@ -2345,7 +2345,7 @@ megaraid_mbox_dpc(unsigned long devp)
 					 scp->cmnd[0] == RELEASE)) {
 
 				scp->result = DID_ERROR << 16 |
-					RESERVATION_CONFLICT << 1;
+					SAM_STAT_RESERVATION_CONFLICT;
 			}
 			else {
 				scp->result = DID_BAD_TARGET << 16 | status;
-- 
2.16.4

