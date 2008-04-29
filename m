From: Tino Keitel <tino.keitel@gmx.de>
Subject: Hack to fix not working spindown over Firewire
Date: Wed, 30 Apr 2008 01:26:06 +0200
Message-ID: <20080429232606.GA14261@dose.home.local>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="h31gzZEtNLTqOjlF"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eazy.amigager.de ([213.239.192.238]:48740 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbYD2XZR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Apr 2008 19:25:17 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

I like the manage_start_stop feature of the SD driver to spin down the
hard disks (SATA and USB) during suspend. However, it didn't work with
my Firewire hard disk.

After some research I found out that I can spin down the disk with
sg_start --pc=2, and spin it up with sg_start --pc=1. I adopted this
into sd_start_stop_device() with the vendor name of the device
hardcoded (see the attached patch) and now my Firewire hard disk spins
down on suspend and spins up on resume.

Is there any chance to get this behaviour without such ugly changes to
the kernel? I had to make it conditional by checking the device as
otherwise the SATA disk reports an error.

Regards,
Tino

--h31gzZEtNLTqOjlF
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="start_stop_unit_set_power_condition_v2.diff"

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3cea17d..4d7dbd6 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1788,8 +1788,16 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 	struct scsi_device *sdp = sdkp->device;
 	int res;
 
-	if (start)
+	if (start) {
 		cmd[4] |= 1;	/* START */
+		if(!strncmp(sdp->vendor, "WDC WD32", 8)) {
+			cmd[4] |= (1 << 4); /* power condition */
+		}
+	} else {
+		if(!strncmp(sdp->vendor, "WDC WD32", 8)) {
+			cmd[4] |= (2 << 4); /* power condition */
+		}
+	}
 
 	if (!scsi_device_online(sdp))
 		return -ENODEV;

--h31gzZEtNLTqOjlF--
