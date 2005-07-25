From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH RFC] fix mpt fustion cylinders calculation for large disks
Date: Mon, 25 Jul 2005 16:37:07 -0500
Message-ID: <1122327427.20669.9.camel@madmax.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:23226 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261508AbVGYVhT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2005 17:37:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsil.com, aebr@win.tue.nl, linux-scsi@vger.kernel.org

mptscsih will cast a sector_t to an int which is causing cylinders
to be zero in some cases. This patch just sets cylinders to the
max value when the capacity is over the limit that the geometry
struct can support. With the patch if access a large Fibre Channel
disk using Emulex on a 64 bit system I get the same values as mpt fusion,
but I am honestly not sure why mpt does their own geometry calculations
for this case in the first place so I am only sending this as a
RFC.

Also, I thought cylinders could be ignored by userspace but I am
not sure where I read this and cannot seem to find it, so
I ccd Andries who seems to post the most about such things
(chances are they said it and I am misquiting them).

Patch was made against the scsi-misc tree.

--- scsi-misc.sense/drivers/message/fusion/mptscsih.c.orig	2005-07-25 16:17:24.000000000 -0500
+++ scsi-misc.sense/drivers/message/fusion/mptscsih.c	2005-07-25 16:17:39.000000000 -0500
@@ -2107,12 +2107,17 @@ mptscsih_bios_param(struct scsi_device *
 	 * Handle extended translation size for logical drives
 	 * > 1Gb
 	 */
-	if ((ulong)capacity >= 0x200000) {
+	if (capacity >= 0x200000) {
 		heads = 255;
 		sectors = 63;
 		dummy = heads * sectors;
-		cylinders = capacity;
-		sector_div(cylinders,dummy);
+
+		if (capacity > 65535 * 63 * 255)
+			cylinders = 65535;
+		else {
+			cylinders = capacity;
+			sector_div(cylinders,dummy);
+		}
 	}
 
 	/* return result */


