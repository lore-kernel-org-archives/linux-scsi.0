From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull 2/2] FireWire updates post 2.6.26 (with a few lines of SCSI
	in it)
Date: Tue, 15 Jul 2008 21:33:39 +0200 (CEST)
Message-ID: <tkrat.898af704693a539b@s5r6.in-berlin.de>
References: <tkrat.ca57fe6c5cf3640c@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.ca57fe6c5cf3640c@s5r6.in-berlin.de>
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
To: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Linus, please pull from the sbp2-spindown branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git sbp2-spindown

to receive the following IEEE 1394/ FireWire subsystem updates.
James has been polled for ACK or NAK or take-over of the SCSI bit
three times or so.

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


Start of the series, prerequisite for the rest:

commit d2886ea368a67704ecc13e69075f18a9d74cb12b
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun May 11 00:34:07 2008 +0200

    scsi: sd: optionally set power condition in START STOP UNIT
    
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

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 01cefbb..d53312c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1124,6 +1124,8 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 				cmd[1] = 1;	/* Return immediately */
 				memset((void *) &cmd[2], 0, 8);
 				cmd[4] = 1;	/* Start spin cycle */
+				if (sdkp->device->start_stop_pwr_cond)
+					cmd[4] |= 1 << 4;
 				scsi_execute_req(sdkp->device, cmd, DMA_NONE,
 						 NULL, 0, &sshdr,
 						 SD_TIMEOUT, SD_MAX_RETRIES);
@@ -1790,6 +1792,9 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 	if (start)
 		cmd[4] |= 1;	/* START */
 
+	if (sdp->start_stop_pwr_cond)
+		cmd[4] |= start ? 1 << 4 : 3 << 4;	/* Active or Standby */
+
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index f6a9fe0..00b7876 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
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
-=====-==--- -=== -====
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
Build the coolest Linux based applications with Moblin SDK & win great prizes
Grand prize is a trip for two to an Open Source event anywhere in the world
http://moblin-contest.org/redirect.php?banner_id=100&url=/
