From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/4] scsi_scan: Fixup scsilun_to_int()
Date: Wed, 20 Feb 2013 14:47:11 +0100
Message-ID: <1361368034-54444-2-git-send-email-hare@suse.de>
References: <1361368034-54444-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49193 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935493Ab3BTNrU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Feb 2013 08:47:20 -0500
In-Reply-To: <1361368034-54444-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <jbottomley@parallels.com>, Jeremy Linton <jlinton@tributary.com>, Robert Elliott <Elliott@hp.com>, Bart Van Assche <bvanassche@acm.org>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>

scsilun_to_int() has an error which prevents it from generating
correct LUN numbers for 64bit values.
Also we should remove the misleading comment about portions of
the LUN being ignored; the initiator should treat the LUN as
an opaque value.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_scan.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3e58b22..4f315f5 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1228,14 +1228,11 @@ static void scsi_sequential_lun_scan(struct scsi_target *starget,
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
+ *     Given a struct scsi_lun of: 0a 04 0b 03 00 00 00 00, this function
+ *     returns the integer: 0x0b030a04
  **/
 int scsilun_to_int(struct scsi_lun *scsilun)
 {
@@ -1244,7 +1241,7 @@ int scsilun_to_int(struct scsi_lun *scsilun)
 
 	lun = 0;
 	for (i = 0; i < sizeof(lun); i += 2)
-		lun = lun | (((scsilun->scsi_lun[i] << 8) |
+		lun = lun | (((scsilun->scsi_lun[i] << ((i + 1) * 8)) |
 			      scsilun->scsi_lun[i + 1]) << (i * 8));
 	return lun;
 }
-- 
1.7.4.2

