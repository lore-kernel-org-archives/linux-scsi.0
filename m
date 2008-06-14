From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH resend] scsi: sd: optionally set power condition in START STOP
	UNIT
Date: Sat, 14 Jun 2008 14:45:59 +0200 (CEST)
Message-ID: <tkrat.e11d1535986dbc62@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
Content-Disposition: INLINE
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

James,

this is a reminder that linux1394-2.6.git currently tramples on SCSI
territory with the following small patch.  The patch has already been in
my -next branch for a while, and hence in Stephen's linux-next tree,
without causing trouble.  I intend to submit it to Linus after 2.6.26
unless you want to do so yourself. I have four firewire-specific patches
which depend on this sd patch.

Please pick up the patch or ACK or NAK it at your discretion.


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

Index: linux-2.6.26-rc2/drivers/scsi/sd.c
===================================================================
--- linux-2.6.26-rc2.orig/drivers/scsi/sd.c
+++ linux-2.6.26-rc2/drivers/scsi/sd.c
@@ -1124,6 +1124,8 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 				cmd[1] = 1;	/* Return immediately */
 				memset((void *) &cmd[2], 0, 8);
 				cmd[4] = 1;	/* Start spin cycle */
+				if (sdkp->device->start_stop_pwr_cond)
+					cmd[4] |= 1 << 4;
 				scsi_execute_req(sdkp->device, cmd, DMA_NONE,
 						 NULL, 0, &sshdr,
 						 SD_TIMEOUT, SD_MAX_RETRIES);
@@ -1790,6 +1792,9 @@ static int sd_start_stop_device(struct s
 	if (start)
 		cmd[4] |= 1;	/* START */
 
+	if (sdp->start_stop_pwr_cond)
+		cmd[4] |= start ? 1 << 4 : 3 << 4;	/* Active or Standby */
+
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
Index: linux-2.6.26-rc2/include/scsi/scsi_device.h
===================================================================
--- linux-2.6.26-rc2.orig/include/scsi/scsi_device.h
+++ linux-2.6.26-rc2/include/scsi/scsi_device.h
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
-=====-==--- -==- -===-
http://arcgraph.de/sr/


-------------------------------------------------------------------------
Check out the new SourceForge.net Marketplace.
It's the best place to buy or sell services for
just about anything Open Source.
http://sourceforge.net/services/buy/index.php
