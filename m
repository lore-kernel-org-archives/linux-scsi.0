From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 0/5] SCSI and FireWire: fix/add START STOP UNIT for SBP-2
 disks
Date: Mon, 19 May 2008 19:18:21 +0200 (CEST)
Message-ID: <tkrat.965082c1d133478f@s5r6.in-berlin.de>
References: <20080429232606.GA14261@dose.home.local>
 <481874BD.5010807@s5r6.in-berlin.de>
 <20080507180042.GA32629@dose.home.local>
 <tkrat.327b59f1366f8ea0@s5r6.in-berlin.de>
 <tkrat.635f52f7035be2bc@s5r6.in-berlin.de>
 <tkrat.5cf7605228f0006a@s5r6.in-berlin.de>
 <20080516062315.GA4350@dose.home.local>
 <tkrat.ad2cb91dd8644559@s5r6.in-berlin.de>
 <20080518173511.GA14742@dose.home.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:54382 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222AbYESRT2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2008 13:19:28 -0400
In-Reply-To: <20080518173511.GA14742@dose.home.local>
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tino Keitel <tino.keitel@gmx.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

>> Tino Keitel wrote:
>>> I applied all patches, and tried it on my system with a SATA, USB and
>>> Firewire disk. All disks spun down at suspend, and spun up again at
>>> resume.

OK, I now added your Tested-by.  I also added a short comment to the
change in sd_start_stop_device(), as quoted below, and enqueued this
stuff in

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git sbp2-spindown

I also made these changes visible in the branch of linux1394-2.6.git
which is pulled into -next.  Shortlog and diffstat is

Stefan Richter (5):
      scsi: sd: optionally set power condition in START STOP UNIT
      firewire: fw-sbp2: fix spindown for PL-3507 and TSB42AA9 firmwares
      ieee1394: sbp2: fix spindown for PL-3507 and TSB42AA9 firmwares
      firewire: fw-sbp2: spin disks down on suspend and shutdown
      ieee1394: sbp2: spin disks down on suspend and shutdown

 drivers/firewire/fw-sbp2.c |   25 +++++++++++++++++++++++--
 drivers/ieee1394/sbp2.c    |   22 ++++++++++++++++++++--
 drivers/ieee1394/sbp2.h    |    1 +
 drivers/scsi/sd.c          |    5 +++++
 include/scsi/scsi_device.h |    1 +
 5 files changed, 50 insertions(+), 4 deletions(-)

James, do you agree to the scsi_device.h + sd.c patch?  And will you
pick it up eventually or should I keep it?  I would submit this and the
depending 4 FireWire patches after 2.6.26 was released --- although the
first 3 patches could also go to Linus before 2.6.26.

Here is the updated first patch:


Date: Sun, 11 May 2008 00:34:07 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: scsi: sd: optionally set power condition in START STOP UNIT

Adds a new scsi_device flag, start_stop_pwr_cond:  If enabled, the sd
driver will not send plain START STOP UNIT commands but ones with the
power condition field set to 3 (standby) or 1 (active) respectively.

Some FireWire disk firmwares do not stop the motor if power condition is
zero.  Or worse, they become unresponsive after a START STOP UNIT with
power condition = 0 and start = 0.

http://lkml.org/lkml/2008/4/29/704

This patch only adds the necessary code to sd_mod but doesn't activate
it.  Follow-up patches to the FireWire drivers will add detection of
affected devices and enable the code for them.

I did not add power condition values to scsi_error.c::scsi_eh_try_stu()
for now.  The three firmwares which suffer from above mentioned problems
do not need START STOP UNIT in the error handler, and they are not
adversely affected by START STOP UNIT with power condition = 0 and start
= 1 (like scsi_eh_try_stu() sends it if scsi_device.allow_restart is
enabled).

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Tested-by: Tino Keitel <tino.keitel@gmx.de>
---
 drivers/scsi/sd.c          |    5 +++++
 include/scsi/scsi_device.h |    1 +
 2 files changed, 6 insertions(+)

Index: linux/drivers/scsi/sd.c
===================================================================
--- linux.orig/drivers/scsi/sd.c
+++ linux/drivers/scsi/sd.c
@@ -1115,6 +1115,8 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 				cmd[1] = 1;	/* Return immediately */
 				memset((void *) &cmd[2], 0, 8);
 				cmd[4] = 1;	/* Start spin cycle */
+				if (sdkp->device->start_stop_pwr_cond)
+					cmd[4] |= 1 << 4;
 				scsi_execute_req(sdkp->device, cmd, DMA_NONE,
 						 NULL, 0, &sshdr,
 						 SD_TIMEOUT, SD_MAX_RETRIES);
@@ -1781,6 +1783,9 @@ static int sd_start_stop_device(struct s
 	if (start)
 		cmd[4] |= 1;	/* START */
 
+	if (sdp->start_stop_pwr_cond)
+		cmd[4] |= start ? 1 << 4 : 3 << 4;	/* Active or Standby */
+
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
Index: linux/include/scsi/scsi_device.h
===================================================================
--- linux.orig/include/scsi/scsi_device.h
+++ linux/include/scsi/scsi_device.h
@@ -134,6 +134,7 @@ struct scsi_device {
 	unsigned no_start_on_add:1;	/* do not issue start on add */
 	unsigned allow_restart:1; /* issue START_UNIT in error handler */
 	unsigned manage_start_stop:1;	/* Let HLD (sd) manage start/stop */
+	unsigned start_stop_pwr_cond:1;	/* Set power cond. in START_STOP_UNIT */
 	unsigned no_uld_attach:1; /* disable connecting to upper level drivers */
 	unsigned select_no_atn:1;
 	unsigned fix_capacity:1;	/* READ_CAPACITY is too high by 1 */

-- 
Stefan Richter
-=====-==--- -=-= =--==
http://arcgraph.de/sr/

