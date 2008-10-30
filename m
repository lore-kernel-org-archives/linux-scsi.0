From: Oliver Neukum <oliver@neukum.org>
Subject: [patch]liberal acceptance of 0x28 asc in sd.c
Date: Thu, 30 Oct 2008 13:09:41 +0100
Message-ID: <200810301309.41705.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:38820 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbYJ3MJl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2008 08:09:41 -0400
Received: from noname (p549A33C2.dip0.t-ipconnect.de [84.154.51.194])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: neukum_org@smtp-out.kontent.com)
	by smtp-out.kontent.com (Postfix) with ESMTP id C385C40053A3
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2008 13:09:39 +0100 (CET)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

>From reading the SCSI spec it seems that having the valid bit 0 (0x70
checked in scsi_sense_valid) should does not invalidate the ASC or ASQ.
[See page 37 of spc4r02.pdf].  It should only invalidate the INFORMATION
field. Therefore remove the sense_valid check from the USB quirk.

This is needed for a strange USB storage device.

Signed-off-by: Brandon Philips <bphilips@suse.de>
Signed-off-by: Oliver Neukum <oneukum@suse.de>

---

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e5e7d78..ac119a0 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1204,8 +1204,7 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 		 * Yes, this sense key/ASC combination shouldn't
 		 * occur here.  It's characteristic of these devices.
 		 */
-		} else if (sense_valid &&
-				sshdr.sense_key == UNIT_ATTENTION &&
+		} else if (sshdr.sense_key == UNIT_ATTENTION &&
 				sshdr.asc == 0x28) {
 			if (!spintime) {
 				spintime_expire = jiffies + 5 * HZ;
