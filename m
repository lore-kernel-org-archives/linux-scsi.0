From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/6] scsi_scan: Fixup scsilun_to_int()
Date: Sat, 31 May 2014 11:01:18 +0200
Message-ID: <1401526878-119472-7-git-send-email-hare@suse.de>
References: <1401526878-119472-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47218 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671AbaEaJBX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 31 May 2014 05:01:23 -0400
In-Reply-To: <1401526878-119472-1-git-send-email-hare@suse.de>
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

Suggested-by: Doug Gilbert <dgilbert@interlog.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_scan.c | 29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index fa57a04..42843ec 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1263,25 +1263,23 @@ static void scsi_sequential_lun_scan(struct scsi_target *starget,
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
  **/
 u64 scsilun_to_int(struct scsi_lun *scsilun)
 {
-	int i;
-	u64 lun;
+	const unsigned char * cp;
+	uint64_t res;
 
-	lun = 0;
-	for (i = 0; i < sizeof(lun); i += 2)
-		lun = lun | (((scsilun->scsi_lun[i] << 8) |
-			      scsilun->scsi_lun[i + 1]) << (i * 8));
-	return lun;
+	res = (scsilun->scsi_lun[6] << 8) + scsilun->scsi_lun[7];
+	for (cp = scsilun->scsi_lun + 4; cp >= scsilun->scsi_lun; cp -= 2) {
+		res <<= 16;
+		res += (*cp << 8) + *(cp + 1);
+	}
+	return res;
 }
 EXPORT_SYMBOL(scsilun_to_int);
 
@@ -1294,13 +1292,10 @@ EXPORT_SYMBOL(scsilun_to_int);
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
+ *     scsi_lun of : struct scsi_lun of: d2 04 0b 03 00 00 00 00
  *
  **/
 void int_to_scsilun(u64 lun, struct scsi_lun *scsilun)
-- 
1.7.12.4

