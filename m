Return-Path: <SRS0=xqUt=CC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 930E6C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 19:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67EC92078D
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 19:05:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgHXTE6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Aug 2020 15:04:58 -0400
Received: from comms.puri.sm ([159.203.221.185]:38226 "EHLO comms.puri.sm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726413AbgHXTE5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Aug 2020 15:04:57 -0400
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id A8C79DFB28;
        Mon, 24 Aug 2020 12:04:26 -0700 (PDT)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id nZAS46TPgg2p; Mon, 24 Aug 2020 12:04:24 -0700 (PDT)
From:   Martin Kepplinger <martin.kepplinger@puri.sm>
To:     stern@rowland.harvard.edu, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>
Subject: [PATCH] scsi: add expecting_media_change flag to error path
Date:   Mon, 24 Aug 2020 21:04:00 +0200
Message-Id: <20200824190400.12339-1-martin.kepplinger@puri.sm>
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SD Cardreaders (especially) sometimes lose the state during suspend
and deliver a "media changed" unit attention when really only a
(runtime) suspend/resume cycle has been done.

Add a flag for drivers to use when this is expected. It's handled in the
scsi core error path and allows to use (runtime) PM when it has
no been possible before on said hardware.

The "downside" is that we rely more on users not to really change
the medium (SD card) *during* a simple suspend/resume, i.e. when not
unmounting.

How to *use* this flag remains an open problem but for testing (if you
get "media changed" UA errors when runtime PM enabled as described below),
simply do to /drivers/scsi/sd.c

@@ -3648,6 +3648,8 @@ static int sd_resume(struct device *dev)
	if (!sdkp)      /* E.g.: runtime resume at the start of sd_probe() */
		return 0;

+       sdkp->device->expecting_media_change = 1;
+
	if (!sdkp->device->manage_start_stop)
		return 0;

To enable runtime PM for SD cardreader (here, device number 0:0:0:0),
do the following:

echo 0 > /sys/module/block/parameters/events_dfl_poll_msecs
echo 1000 > /sys/bus/scsi/devices/0:0:0:0/power/autosuspend_delay_ms
echo auto > /sys/bus/scsi/devices/0:0:0:0/power/control

Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
---


If you don't want to merge a flag without any user, I understand that
but we can add a user (sysfs setting to opt-in?) once we agree on
what it does, right?

Since this patch solves my specific problem, I'd appreciate any more
feedback and hope we can find a solution that works for everyone.

thanks a lot,
                               martin


 drivers/scsi/scsi_error.c  | 31 ++++++++++++++++++++++++++++---
 include/scsi/scsi_device.h |  1 +
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 7d3571a2bd89..c99390a5dc31 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -565,6 +565,18 @@ int scsi_check_sense(struct scsi_cmnd *scmd)
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
@@ -1944,9 +1956,22 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	 * the request was not marked fast fail.  Note that above,
 	 * even if the request is marked fast fail, we still requeue
 	 * for queue congestion conditions (QUEUE_FULL or BUSY) */
-	if ((++scmd->retries) <= scmd->allowed
-	    && !scsi_noretry_cmd(scmd)) {
-		return NEEDS_RETRY;
+	if ((++scmd->retries) <= scmd->allowed) {
+		/* but scsi_noretry_cmd() cannot override the
+		 * expecting_media_change flag.
+		 */
+		if (!scsi_noretry_cmd(scmd) ||
+		    scmd->device->expecting_media_change) {
+			scmd->device->expecting_media_change = 0;
+			return NEEDS_RETRY;
+		} else {
+			/* Not marked fail fast, or marked but not expected.
+			 * Clear the flag too because it's meant for the
+			 * next UA only.
+			 */
+			scmd->device->expecting_media_change = 0;
+			return SUCCESS;
+		}
 	} else {
 		/*
 		 * no more retries - report this one back to upper level.
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index bc5909033d13..4a67b06742ba 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -169,6 +169,7 @@ struct scsi_device {
 				 * this device */
 	unsigned expecting_cc_ua:1; /* Expecting a CHECK_CONDITION/UNIT_ATTN
 				     * because we did a bus reset. */
+	unsigned expecting_media_change:1; /* Expecting "media changed" UA */
 	unsigned use_10_for_rw:1; /* first try 10-byte read / write */
 	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
 	unsigned set_dbd_for_ms:1; /* Set "DBD" field in mode sense */
-- 
2.20.1

