From: Tino Keitel <tino.keitel@gmx.de>
Subject: Re: Clean patch to fix not working spindown over Firewire
Date: Fri, 9 May 2008 22:16:36 +0200
Message-ID: <20080509201635.GA20189@dose.home.local>
References: <20080429232606.GA14261@dose.home.local> <481874BD.5010807@s5r6.in-berlin.de> <481875E4.6040606@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="+QahgC5+KEYLbs62"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eazy.amigager.de ([213.239.192.238]:45968 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbYEIUPt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 May 2008 16:15:49 -0400
Content-Disposition: inline
In-Reply-To: <481875E4.6040606@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 30, 2008 at 15:36:36 +0200, Stefan Richter wrote:

[...]

> PS:
> If it works for all RBC devices (it should according to the spec...) &&
> your ICY Box exposes itself as RBC device (it should do so), then we
> don't need any changes to struct scsi_device and to sbp2/ firewire-sbp2.

Do you mean something like in the attached (untested) patch?

Regards,
Tino

--+QahgC5+KEYLbs62
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="start_stop_unit_set_power_condition_v3.diff"

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 01cefbb..6b927f6 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1787,8 +1787,13 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 	struct scsi_device *sdp = sdkp->device;
 	int res;
 
-	if (start)
+	if (start) {
 		cmd[4] |= 1;	/* START */
+		/* active power condition */
+		cmd[4] |= (sdp->type == TYPE_RBC) ? (1 << 4) : 0; 
+	} else
+		/* standby power condition */
+		cmd[4] |= (sdp->type == TYPE_RBC) ? (3 << 4) : 0 ; 
 
 	if (!scsi_device_online(sdp))
 		return -ENODEV;

--+QahgC5+KEYLbs62--
