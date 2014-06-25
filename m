From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/6] scsi_scan: Fixup scsilun_to_int()
Date: Wed, 25 Jun 2014 13:20:27 +0200
Message-ID: <1403695227-106944-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36938 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755990AbaFYLUb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2014 07:20:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>, Bart van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@infradead.org>

scsilun_to_int() has an error which prevents it from generating
correct LUN numbers for 64bit values.
Also we should remove the misleading comment about portions of
the LUN being ignored; the initiator should treat the LUN as
an opaque value.
And, finally, the example given should use the correct
prefix (here: extended flat space addressing scheme).

This patch includes the modifications suggested by
Bart van Assche.

Cc: Bart van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: James Bottomley <jbottomley@parallels.com>
---
 drivers/scsi/scsi_scan.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index fa57a04..553e1c7 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1263,14 +1263,15 @@ static void scsi_sequential_lun_scan(struct scsi_target *starget,
  *     truncation before using this function.
  *
  * Notes:
- *     The struct scsi_lun is assumed to be four levels, with each level
- *     effectively containing a SCSI byte-ordered (big endian) short; the
- *     addressing bits of each level are ignored (the highest two bits).
  *     For a description of the LUN format, post SCSI-3 see the SCSI
  *     Architecture Model, for SCSI-3 see the SCSI Controller Commands.
  *
- *     Given a struct scsi_lun of: 0a 04 0b 03 00 00 00 00, this function returns
- *     the integer: 0x0b030a04
+ *     Given a struct scsi_lun of: d2 04 0b 03 00 00 00 00, this function
+ *     returns the integer: 0x0b03d204
+ *
+ *     This encoding will return a standard integer LUN for LUNs smaller
+ *     than 256, which typically use a single level LUN structure with
+ *     addressing method 0.
  **/
 u64 scsilun_to_int(struct scsi_lun *scsilun)
 {
@@ -1279,8 +1280,8 @@ u64 scsilun_to_int(struct scsi_lun *scsilun)
 
 	lun = 0;
 	for (i = 0; i < sizeof(lun); i += 2)
-		lun = lun | (((scsilun->scsi_lun[i] << 8) |
-			      scsilun->scsi_lun[i + 1]) << (i * 8));
+		lun = lun | (((u64)scsilun->scsi_lun[i] << ((i + 1) *8)) |
+			     ((u64)scsilun->scsi_lun[i + 1] << (i * 8)));
 	return lun;
 }
 EXPORT_SYMBOL(scsilun_to_int);
@@ -1294,13 +1295,10 @@ EXPORT_SYMBOL(scsilun_to_int);
  *     Reverts the functionality of the scsilun_to_int, which packed
  *     an 8-byte lun value into an int. This routine unpacks the int
  *     back into the lun value.
- *     Note: the scsilun_to_int() routine does not truly handle all
- *     8bytes of the lun value. This functions restores only as much
- *     as was set by the routine.
  *
  * Notes:
- *     Given an integer : 0x0b030a04,  this function returns a
- *     scsi_lun of : struct scsi_lun of: 0a 04 0b 03 00 00 00 00
+ *     Given an integer : 0x0b03d204,  this function returns a
+ *     struct scsi_lun of: d2 04 0b 03 00 00 00 00
  *
  **/
 void int_to_scsilun(u64 lun, struct scsi_lun *scsilun)
-- 
1.7.12.4

