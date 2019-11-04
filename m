Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45E2BCA9ED3
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C2C020656
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbfKDJCb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 04:02:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:57252 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728255AbfKDJCR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Nov 2019 04:02:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5B13DB4BC;
        Mon,  4 Nov 2019 09:02:11 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/52] megaraid: use standard SAM status codes
Date:   Mon,  4 Nov 2019 10:01:09 +0100
Message-Id: <20191104090151.129140-11-hare@suse.de>
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
 drivers/scsi/megaraid.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index ff6d4aa92421..21e190c38b97 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1581,7 +1581,7 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 
 				cmd->result = (DRIVER_SENSE << 24) |
 					(DID_OK << 16) |
-					(CHECK_CONDITION << 1);
+					SAM_STAT_CHECK_CONDITION;
 			}
 			else {
 				if (mbox->m_out.cmd == MEGA_MBOXCMD_EXTPTHRU) {
@@ -1591,11 +1591,11 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 
 					cmd->result = (DRIVER_SENSE << 24) |
 						(DID_OK << 16) |
-						(CHECK_CONDITION << 1);
+						SAM_STAT_CHECK_CONDITION;
 				} else {
 					cmd->sense_buffer[0] = 0x70;
 					cmd->sense_buffer[2] = ABORTED_COMMAND;
-					cmd->result |= (CHECK_CONDITION << 1);
+					cmd->result |= SAM_STAT_CHECK_CONDITION;
 				}
 			}
 			break;
@@ -1613,7 +1613,7 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 			 */
 			if( cmd->cmnd[0] == TEST_UNIT_READY ) {
 				cmd->result |= (DID_ERROR << 16) |
-					(RESERVATION_CONFLICT << 1);
+					SAM_STAT_RESERVATION_CONFLICT;
 			}
 			else
 			/*
@@ -1625,7 +1625,7 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 					 cmd->cmnd[0] == RELEASE) ) {
 
 				cmd->result |= (DID_ERROR << 16) |
-					(RESERVATION_CONFLICT << 1);
+					SAM_STAT_RESERVATION_CONFLICT;
 			}
 			else
 #endif
-- 
2.16.4

