From: Boaz Harrosh <bharrosh@panasas.com>
Subject: A theoretical problem in scsi_io_copletion and ACTION*_RETRY
Date: Mon, 04 Jan 2010 14:43:17 +0200
Message-ID: <4B41E265.4030907@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55726 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab0ADMnX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2010 07:43:23 -0500
Received: by bwz27 with SMTP id 27so9206725bwz.21
        for <linux-scsi@vger.kernel.org>; Mon, 04 Jan 2010 04:43:21 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

James hi.

There is a theoretical problem with the case of ACTION_RETRY / ACTION_DELAYED_RETRY

Since we are calling blk_end_request(...,good_bytes) regardless. We cannot just retry
if good_bytes != 0.

The proper returned sense and/or driver-result and/or  "good_bytes == 0" is a concerted
effort of target+LLD+ULD. I would like to check for that condition as below. If you
are absolutely sure this condition can never happen then I'd like to replace below with
a BUG_ON.

BTW:
In the case of "good_bytes == 0" there is no point in calling blk_end_request()
at all, (It's not going to do anything), so we might want to separate the code
to actually check for retries condition first only if "good_bytes == 0" and do
release_buffers plus farther processing if not.

Boaz

---
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 326b228..4cd6900 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -827,6 +827,12 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		action = ACTION_FAIL;
 	}
 
+	if (action >= ACTION_RETRY && good_bytes)
+		/* We cannot just retry if above blk_end_request advanced on
+		 * some good_bytes, so ACTION_REPREP
+		 */
+		action = ACTION_REPREP;
+
 do_action:
 	switch (action) {
 	case ACTION_FAIL:
