From: akpm@osdl.org
Subject: [patch 26/30] scsi: fix sense key MEDIUM ERROR processing and retry
Date: Mon, 04 Dec 2006 15:18:42 -0800
Message-ID: <200612042319.kB4NJpnD008810@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56774 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967782AbWLDXT6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Dec 2006 18:19:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, ltuikov@yahoo.com

From: Luben Tuikov <ltuikov@yahoo.com>

- If the device reports an uncorrectable MEDIUM ERROR, such as SK MEDIUM
  ERROR, ASC UNRECOVERED READ ERR, AMNF DATA FIELD or RECORD NOT FOUND,
  then: In scsi_check_sense() return SUCCESS so as to not retry -- the
  error is uncorrectable -- this speeds up total processing time.

- In scsi_io_completion(), retry if and only if there was at least one
  byte completed, i.e.  good_bytes != 0.  If good_bytes == 0, don't try to
  retry.

Without this patch, SCSI Core gets hung reading sector 0 forever, for
example when reading the partition table of a (newly discovered) device.


Here is what happens: sector 0 is broken -- the device cannot read the media
at that location.  The device properly returns a certain type of uncorrectable
MEDIUM ERROR (ASC: UNRECOVERABLE READ ERR).

SCSI Core loops around its retries (which this patch fixes) and eventually
gives up and sends it for "completion".  This is what happens when
scsi_check_sense() returns NEEDS_RETRY to scsi_decide_disposition() to
scsi_softirq().  The first chunk of the patch fixes this.

We end up in scsi_io_completion(), where good_bytes = 0, and result =
0x08000002 (DRIVER SENSE and CHECK CONDITION).

This statement in scsi_io_completion() causes the infinite retry loop:

   if (scsi_end_request(cmd, 1, good_bytes, !!result) == NULL)
         return;

substitute to get: scsi_end_request(cmd, uptodate=1, uptodate bytes=0,
retry=1) Yeah, but it doesn't make sense to call scsi_end_request() with
uptodate=1 and uptodate bytes = 0.  This causes the infinite retry, since the
code tries to re-read the whole xfer size (0 bytes were uptodate and retry=1),
from the bad media.

That is, we want to set uptodate=1 iff there was at least 1 byte up to date. 
Else if nothing was read, uptodate bytes = 0, then we should pass uptodate =
0, uptodate_bytes = total xfer, to mean the whole xfer is not uptodate; and
retry iff there was no error.  (This is the very bottom of the function.)


Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/scsi_error.c |    5 +++++
 drivers/scsi/scsi_lib.c   |    3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/scsi_error.c~fix-sense-key-medium-error-processing-and-retry drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c~fix-sense-key-medium-error-processing-and-retry
+++ a/drivers/scsi/scsi_error.c
@@ -359,6 +359,11 @@ static int scsi_check_sense(struct scsi_
 		return SUCCESS;
 
 	case MEDIUM_ERROR:
+		if (sshdr.asc == 0x11 || /* UNRECOVERED READ ERR */
+		    sshdr.asc == 0x13 || /* AMNF DATA FIELD */
+		    sshdr.asc == 0x14) { /* RECORD NOT FOUND */
+			return SUCCESS;
+		}
 		return NEEDS_RETRY;
 
 	case HARDWARE_ERROR:
diff -puN drivers/scsi/scsi_lib.c~fix-sense-key-medium-error-processing-and-retry drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c~fix-sense-key-medium-error-processing-and-retry
+++ a/drivers/scsi/scsi_lib.c
@@ -871,7 +871,8 @@ void scsi_io_completion(struct scsi_cmnd
 	 * are leftovers and there is some kind of error
 	 * (result != 0), retry the rest.
 	 */
-	if (scsi_end_request(cmd, 1, good_bytes, result == 0) == NULL)
+	if (good_bytes &&
+	    scsi_end_request(cmd, 1, good_bytes, result == 0) == NULL)
 		return;
 
 	/* good_bytes = 0, or (inclusive) there were leftovers and
_
