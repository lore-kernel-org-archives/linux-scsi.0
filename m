From: akpm@osdl.org
Subject: [patch 02/20] drivers/scsi/sd.c: fix uninitialized variable in handling medium errors
Date: Thu, 27 Apr 2006 02:32:56 -0700
Message-ID: <200604270934.k3R9YOId025431@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:61391 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965031AbWD0Je3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Apr 2006 05:34:29 -0400
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
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/sd.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/scsi/sd.c~drivers-scsi-sdc-fix-uninitialized-variable-in-handling-medium-errors drivers/scsi/sd.c
--- 25/drivers/scsi/sd.c~drivers-scsi-sdc-fix-uninitialized-variable-in-handling-medium-errors	Wed Apr 26 15:16:25 2006
+++ 25-akpm/drivers/scsi/sd.c	Wed Apr 26 15:16:25 2006
@@ -959,6 +959,8 @@ static void sd_rw_intr(struct scsi_cmnd 
 			default:
 				break;
 			}
+			if (!info_valid)
+				error_sector = SCpnt->request->sector;
 
 			error_sector &= ~(block_sectors - 1);
 			good_bytes = (error_sector - SCpnt->request->sector) << 9;
_
