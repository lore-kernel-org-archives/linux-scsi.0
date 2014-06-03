From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/6] scsi_scan: Fixup scsilun_to_int()
Date: Tue,  3 Jun 2014 10:58:57 +0200
Message-ID: <1401785937-43581-7-git-send-email-hare@suse.de>
References: <1401785937-43581-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35684 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbaFCI67 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jun 2014 04:58:59 -0400
In-Reply-To: <1401785937-43581-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

scsilun_to_int() has an error which prevents it from generating
correct LUN numbers for 64bit values.
Also we should remove the misleading comment about portions of
the LUN being ignored; the initiator should treat the LUN as
an opaque value.
And, finally, the example given should use the correct
prefix (here: extended flat space addressing scheme).

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: James Bottomley <jbottomley@parallels.com>
---
 drivers/scsi/scsi_scan.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index fa57a04..27d7956 100644
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
@@ -1279,7 +1280,7 @@ u64 scsilun_to_int(struct scsi_lun *scsilun)
 
 	lun = 0;
 	for (i = 0; i < sizeof(lun); i += 2)
-		lun = lun | (((scsilun->scsi_lun[i] << 8) |
+		lun = lun | (((scsilun->scsi_lun[i] << ((i + 1) *8)) |
 			      scsilun->scsi_lun[i + 1]) << (i * 8));
 	return lun;
 }
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

