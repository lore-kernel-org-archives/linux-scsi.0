From: akpm@osdl.org
Subject: [patch 01/26] drivers/scsi/sd.c: fix uninitialized variable in handling medium errors
Date: Sun, 25 Jun 2006 01:58:41 -0700
Message-ID: <200606250858.k5P8wf0b021175@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:9109 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751217AbWFYI6s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Jun 2006 04:58:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, lkml@rtr.ca


From: Mark Lord <lkml@rtr.ca>

When scsi_get_sense_info_fld() fails (returns 0), it does NOT update the
value of first_err_block.  But sd_rw_intr() merrily continues to use that
variable regardless, possibly making incorrect decisions about retries and
the like.

This patch removes the randomness there, by using the first sector of the
request (SCpnt->request->sector) in such cases, instead of first_err_block.

Signed-off-by: Mark Lord <lkml@rtr.ca>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/sd.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/scsi/sd.c~drivers-scsi-sdc-fix-uninitialized-variable-in-handling-medium-errors drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~drivers-scsi-sdc-fix-uninitialized-variable-in-handling-medium-errors
+++ a/drivers/scsi/sd.c
@@ -959,6 +959,8 @@ static void sd_rw_intr(struct scsi_cmnd 
 			default:
 				break;
 			}
+			if (!info_valid)
+				error_sector = SCpnt->request->sector;
 
 			error_sector &= ~(block_sectors - 1);
 			good_bytes = (error_sector - SCpnt->request->sector) << 9;
_
