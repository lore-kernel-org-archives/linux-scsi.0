From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 10/11] hpsa: fix issues with multilun devices
Date: Sat, 18 Jul 2015 11:13:09 -0500
Message-ID: <20150718161309.31955.77228.stgit@brunhilda>
References: <20150718160245.31955.16794.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t2354.austin.hp.com ([15.217.128.53]:57544 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbbGRQP0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jul 2015 12:15:26 -0400
In-Reply-To: <20150718160245.31955.16794.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hp.com
Cc: linux-scsi@vger.kernel.org

From: shane.seymour <shane.seymour@hp.com>

A regression was introduced into the hpsa driver a while back so
non-zero LUNs of multi-LUN devices may no longer be presented via
a SAS based Smart Array. I have not done a bisection to discover
the change that caused it.

The CISS firmware specification (available on sourceforge)
defines an 8 byte lunid that describes devices that the Smart
Array can see/present to the system. The current code in the hpsa
driver attempts to find matches for non-zero LUNs with LUN 0 for
a bus/target by zeroing out byte 4 of the lunid and find a match.

This method is sufficient for SCSI based Smart Arrays because
byte 5 is always 0. For SAS based Smart arrays byte 5 of the
lunid contains the path number for a multipath device and
either one or two bits (the documentation does not define how
many bits are used but it appears it may be one only) that
indicate if the given path number in byte 5 must always be
used to access that device. Byte 5 may not always be zero.

The following are lunids (spaces added for clarity) for a
MSL2024 single drive library connected via a H241 Smart Array:

00 00 00 00 01 00 00 01 (changer)
00 00 00 00 00 80 00 01 (tape)

In the 4th byte (counting from 0) you can see that the tape
is LUN 0 and the changer is LUN 1. The 0x80 set in the 5th byte
for the tape drive means the driver should force access to
path 0 (the library in this case was connected to one path only
anyway).

After the changes we can see the following in the dmesg output:

scsi 0:3:0:0: RAID              HP       H241             1.18 \
PQ: 0 ANSI: 5
scsi 0:2:0:0: Sequential-Access HP       Ultrium 6-SCSI   354W \
PQ: 0 ANSI: 6
scsi 0:2:0:1: Medium Changer    HP       MSL G3 Series    8.70 \
PQ: 0 ANSI: 5

Showing that the changer is correctly identified as LUN 1 of
bus 2 target 0. Before the change the changer device is not seen.

Suggested-by: shane.seymour <shane.seymour@hp.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c72e900..a3077e9 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1187,17 +1187,19 @@ static int hpsa_scsi_add_entry(struct ctlr_info *h, int hostno,
 
 	/* This is a non-zero lun of a multi-lun device.
 	 * Search through our list and find the device which
-	 * has the same 8 byte LUN address, excepting byte 4.
+	 * has the same 8 byte LUN address, excepting byte 4 and 5.
 	 * Assign the same bus and target for this new LUN.
 	 * Use the logical unit number from the firmware.
 	 */
 	memcpy(addr1, device->scsi3addr, 8);
 	addr1[4] = 0;
+	addr1[5] = 0;
 	for (i = 0; i < n; i++) {
 		sd = h->dev[i];
 		memcpy(addr2, sd->scsi3addr, 8);
 		addr2[4] = 0;
-		/* differ only in byte 4? */
+		addr2[5] = 0;
+		/* differ only in byte 4 and 5? */
 		if (memcmp(addr1, addr2, 8) == 0) {
 			device->bus = sd->bus;
 			device->target = sd->target;

