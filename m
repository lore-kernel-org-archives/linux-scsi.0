From: Al Cooper <alcooperx@gmail.com>
Subject: [PATCH] scsi: Allow retry on UNIT_ATTENTION media changed if not CDROM drive
Date: Thu, 8 Jan 2015 17:33:53 -0500
Message-ID: <1420756433-11850-1-git-send-email-alcooperx@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:53085 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921AbbAHWzV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jan 2015 17:55:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, axboe@kernel.dk, linux-scsi@vger.kernel.org
Cc: Al Cooper <alcooperx@gmail.com>

Previous commit dfcf7775815504d13a1d273073810058caf84b9d added
a workaround for CD-ROM drives that were out of spec. This is causing
scsi_check_sense() to return an error instead of NEEDS_RETRY on
some USB thumb drives that return UNIT_ATTENTION Media Changed
(ASC/ASCQ 28/00) after resuming from S3. This can cause mounted
thumb drives to fail on the next access to the filesystem after
S3 resume. This is masked on many systems because udev/dbus event
handlers open the /dev/sd* device before filesystem access and the
open always retries the UNIT_ATTENTION. The fix is to limit the
original workaround to CDROM drives.

Signed-off-by: Al Cooper <alcooperx@gmail.com>
---
 drivers/scsi/scsi_error.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 8afb016..eee95d2 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -525,12 +525,13 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		 */
 		if (scmd->device->expecting_cc_ua) {
 			/*
-			 * Because some device does not queue unit
+			 * Because some CDROM drives do not queue unit
 			 * attentions correctly, we carefully check
 			 * additional sense code and qualifier so as
 			 * not to squash media change unit attention.
 			 */
-			if (sshdr.asc != 0x28 || sshdr.ascq != 0x00) {
+			if ((sdev->type != TYPE_ROM) ||
+				(sshdr.asc != 0x28 || sshdr.ascq != 0x00)) {
 				scmd->device->expecting_cc_ua = 0;
 				return NEEDS_RETRY;
 			}
-- 
1.9.0.138.g2de3478

