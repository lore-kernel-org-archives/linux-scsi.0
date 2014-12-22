From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] scsi_debug: fix sanity check in resp_rsup_opcodes
Date: Mon, 22 Dec 2014 11:37:17 -0500
Message-ID: <549848BD.6060402@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070508050504000704040401"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:36811 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755058AbaLVQhZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Dec 2014 11:37:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, dcb314@hotmail.com

This is a multi-part message in MIME format.
--------------070508050504000704040401
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

David Binderman pointed out in this post:

http://marc.info/?l=linux-scsi&m=141924469523474&w=2

a sanity check that was flawed. See attached fix. Should
be applied to lk 3.19.0-rc1 and Christoph's branches.

ChangeLog:
     fix alloc_len sanity check in resp_rsup_opcodes()


---
  drivers/scsi/scsi_debug.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

--------------070508050504000704040401
Content-Type: text/x-patch;
 name="0001-scsi_debug-sanity-check-in-resp_rsup_opcodes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-scsi_debug-sanity-check-in-resp_rsup_opcodes.patch"

>From 89e7ac4920ef22943fe94112221ab3760dc3f763 Mon Sep 17 00:00:00 2001
From: Douglas Gilbert <dgilbert@interlog.com>
Date: Mon, 22 Dec 2014 10:16:55 -0500
Subject: [PATCH] scsi_debug sanity check in resp_rsup_opcodes

fix alloc_len sanity check in resp_rsup_opcodes()
---
 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 7b8b51b..63a2e1f 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1623,7 +1623,7 @@ resp_rsup_opcodes(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	req_opcode = cmd[3];
 	req_sa = get_unaligned_be16(cmd + 4);
 	alloc_len = get_unaligned_be32(cmd + 6);
-	if (alloc_len < 4 && alloc_len > 0xffff) {
+	if (alloc_len < 4 || alloc_len > 0xffff) {
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 6, -1);
 		return check_condition_result;
 	}
-- 
1.9.1


--------------070508050504000704040401--
