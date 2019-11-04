Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81800CA9ED4
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60E8720656
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbfKDJCP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 04:02:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:57164 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727880AbfKDJCO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Nov 2019 04:02:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 69CFAB30D;
        Mon,  4 Nov 2019 09:02:10 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/52] gdth: use standard SAM status codes
Date:   Mon,  4 Nov 2019 10:01:11 +0100
Message-Id: <20191104090151.129140-13-hare@suse.de>
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
 drivers/scsi/gdth.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index fe03410268e6..d23e277c1b85 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -1677,7 +1677,7 @@ static void gdth_next(gdth_ha_str *ha)
                 memset((char*)nscp->sense_buffer,0,16);
                 nscp->sense_buffer[0] = 0x70;
                 nscp->sense_buffer[2] = NOT_READY;
-                nscp->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
+		nscp->result = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
                 if (!nscp_cmndinfo->wait_for_completion)
                     nscp_cmndinfo->wait_for_completion++;
                 else
@@ -1722,7 +1722,7 @@ static void gdth_next(gdth_ha_str *ha)
                     memset((char*)nscp->sense_buffer,0,16);
                     nscp->sense_buffer[0] = 0x70;
                     nscp->sense_buffer[2] = UNIT_ATTENTION;
-                    nscp->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
+		    nscp->result = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
                     if (!nscp_cmndinfo->wait_for_completion)
                         nscp_cmndinfo->wait_for_completion++;
                     else
@@ -1774,7 +1774,7 @@ static void gdth_next(gdth_ha_str *ha)
                     memset((char*)nscp->sense_buffer,0,16);
                     nscp->sense_buffer[0] = 0x70;
                     nscp->sense_buffer[2] = UNIT_ATTENTION;
-                    nscp->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
+		    nscp->result = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
                     if (!nscp_cmndinfo->wait_for_completion)
                         nscp_cmndinfo->wait_for_completion++;
                     else
@@ -2802,7 +2802,7 @@ static int gdth_sync_event(gdth_ha_str *ha, int service, u8 index,
                 memset((char*)scp->sense_buffer,0,16);
                 scp->sense_buffer[0] = 0x70;
                 scp->sense_buffer[2] = NOT_READY;
-                scp->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
+		scp->result = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
             } else if (service == CACHESERVICE) {
                 if (ha->status == S_CACHE_UNKNOWN &&
                     (ha->hdr[t].cluster_type & 
@@ -2812,11 +2812,11 @@ static int gdth_sync_event(gdth_ha_str *ha, int service, u8 index,
                 }
                 memset((char*)scp->sense_buffer,0,16);
                 if (ha->status == (u16)S_CACHE_RESERV) {
-                    scp->result = (DID_OK << 16) | (RESERVATION_CONFLICT << 1);
+                    scp->result = (DID_OK << 16) | SAM_STAT_RESERVATION_CONFLICT;
                 } else {
                     scp->sense_buffer[0] = 0x70;
                     scp->sense_buffer[2] = NOT_READY;
-                    scp->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
+                    scp->result = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
                 }
                 if (!cmndinfo->internal_command) {
                     ha->dvr.size = sizeof(ha->dvr.eu.sync);
-- 
2.16.4

