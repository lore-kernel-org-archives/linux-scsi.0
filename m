From: "Seymour, Shane M" <shane.seymour@hp.com>
Subject: [PATCH] hpsa: non-zero LUNs of multi-LUN devices missing on some
 Smart Arrays
Date: Tue, 7 Jul 2015 08:43:51 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB44432C86@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:26457 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742AbbGGIor convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2015 04:44:47 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "don.brace@pmcs.com" <don.brace@pmcs.com>
Cc: "James Bottomley (JBottomley@Odin.com)" <JBottomley@Odin.com>, "storagedev@pmcs.com" <storagedev@pmcs.com>, ISS StorageDev <iss_storagedev@hp.com>


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

Signed-off-by: Shane Seymour <shane.seymour@hp.com>
---
Testing was done on RHEL 6.5 with hpsa driver version 3.4.10-120
and the below patch is the forward ported upstream patch since
the issue exists there as well.
--- a/drivers/scsi/hpsa.c	2015-07-06 19:48:22.224804233 -0500
+++ b/drivers/scsi/hpsa.c	2015-07-06 21:16:31.496444001 -0500
@@ -1083,17 +1083,19 @@ static int hpsa_scsi_add_entry(struct ct
 
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
