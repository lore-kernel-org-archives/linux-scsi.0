From: akpm@osdl.org
Subject: [patch 02/31] drivers/scsi/sd.c: fix uninitialized variable in handling medium errors
Date: Thu, 08 Jun 2006 22:23:29 -0700
Message-ID: <200606090523.k595NTB3032231@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:60636 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965152AbWFIFXe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jun 2006 01:23:34 -0400
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
--- devel/drivers/scsi/sd.c~drivers-scsi-sdc-fix-uninitialized-variable-in-handling-medium-errors	2006-06-01 20:41:49.000000000 -0700
+++ devel-akpm/drivers/scsi/sd.c	2006-06-01 20:41:49.000000000 -0700
@@ -959,6 +959,8 @@ static void sd_rw_intr(struct scsi_cmnd 
 			default:
 				break;
 			}
+			if (!info_valid)
+				error_sector = SCpnt->request->sector;
 
 			error_sector &= ~(block_sectors - 1);
 			good_bytes = (error_sector - SCpnt->request->sector) << 9;
_
