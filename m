Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9E76C433E9
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 15:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64697229CA
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 15:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732244AbhAKPWJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 10:22:09 -0500
Received: from comms.puri.sm ([159.203.221.185]:56912 "EHLO comms.puri.sm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731265AbhAKPWI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Jan 2021 10:22:08 -0500
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id 813A5DFD09;
        Mon, 11 Jan 2021 07:20:58 -0800 (PST)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id HZy-WhHIVYFO; Mon, 11 Jan 2021 07:20:57 -0800 (PST)
From:   Martin Kepplinger <martin.kepplinger@puri.sm>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        stern@rowland.harvard.edu, bvanassche@acm.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>
Subject: [PATCH 1/3] scsi: add expecting_media_change flag to error path
Date:   Mon, 11 Jan 2021 16:20:27 +0100
Message-Id: <20210111152029.28426-2-martin.kepplinger@puri.sm>
In-Reply-To: <20210111152029.28426-1-martin.kepplinger@puri.sm>
References: <20210111152029.28426-1-martin.kepplinger@puri.sm>
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SD Cardreaders (especially) sometimes lose the state during suspend
and deliver a "media changed" unit attention when really only a
(runtime) suspend/resume cycle has been done.

For such devices, I/O fails when runtime PM is enabled, see below.

Add a flag for drivers to use when this is expected. It's handled in the
scsi core error path and allows to use (runtime) PM when it has
not been possible before on said hardware.

The "downside" is that we rely more on users not to really change
the medium (SD card) *during* a runtime suspend/resume, i.e. when not
unmounting.

To enable runtime PM for an SD cardreader (here, device number 0:0:0:0),
do the following:

echo 0 > /sys/module/block/parameters/events_dfl_poll_msecs
echo 1000 > /sys/bus/scsi/devices/0:0:0:0/power/autosuspend_delay_ms
echo auto > /sys/bus/scsi/devices/0:0:0:0/power/control

Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
---
 drivers/scsi/scsi_error.c  | 36 +++++++++++++++++++++++++++++++-----
 include/scsi/scsi_device.h |  1 +
 2 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f11f51e2465f..f3b34c142088 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -573,6 +573,18 @@ int scsi_check_sense(struct scsi_cmnd *scmd)
 				return NEEDS_RETRY;
 			}
 		}
+		if (scmd->device->expecting_media_change) {
+			if (sshdr.asc == 0x28 && sshdr.ascq == 0x00) {
+				/*
+				 * clear the expecting_media_change in
+				 * scsi_decide_disposition() because we
+				 * need to catch possible "fail fast" overrides
+				 * that block readahead can cause.
+				 */
+				return NEEDS_RETRY;
+			}
+		}
+
 		/*
 		 * we might also expect a cc/ua if another LUN on the target
 		 * reported a UA with an ASC/ASCQ of 3F 0E -
@@ -1959,14 +1971,28 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	 * the request was not marked fast fail.  Note that above,
 	 * even if the request is marked fast fail, we still requeue
 	 * for queue congestion conditions (QUEUE_FULL or BUSY) */
-	if (scsi_cmd_retry_allowed(scmd) && !scsi_noretry_cmd(scmd)) {
-		return NEEDS_RETRY;
-	} else {
-		/*
-		 * no more retries - report this one back to upper level.
+	if (scsi_cmd_retry_allowed(scmd)) {
+		/* but scsi_noretry_cmd() cannot override the
+		 * expecting_media_change flag.
 		 */
+		if (!scsi_noretry_cmd(scmd) ||
+		    scmd->device->expecting_media_change) {
+			scmd->device->expecting_media_change = 0;
+			return NEEDS_RETRY;
+		}
+
+		/* Not marked fail fast, or marked but not expected.
+		 * Clear the flag too because it's meant for the
+		 * next UA only.
+		 */
+		scmd->device->expecting_media_change = 0;
 		return SUCCESS;
 	}
+
+	/*
+	 * no more retries - report this one back to upper level.
+	 */
+	return SUCCESS;
 }
 
 static void eh_lock_door_done(struct request *req, blk_status_t status)
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 1a5c9a3df6d6..ca2c3eb5830f 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -170,6 +170,7 @@ struct scsi_device {
 				 * this device */
 	unsigned expecting_cc_ua:1; /* Expecting a CHECK_CONDITION/UNIT_ATTN
 				     * because we did a bus reset. */
+	unsigned expecting_media_change:1; /* Expecting "media changed" UA */
 	unsigned use_10_for_rw:1; /* first try 10-byte read / write */
 	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
 	unsigned set_dbd_for_ms:1; /* Set "DBD" field in mode sense */
-- 
2.20.1

