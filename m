From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [RFC PATCH] ieee1394: sbp2: enable auto spin-up for all SBP-2 devices
Date: Mon, 7 Aug 2006 20:49:25 +0200 (CEST)
Message-ID: <tkrat.db366d887faf2254@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
Content-Disposition: INLINE
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: linux1394-devel@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a follow-up to patch "ieee1394: sbp2: enable auto spin-up for
Maxtor disks".  When I 'ejected' an OXUF922 based HDD from a Mac OS X
box, it was spun down by the Mac and did not spin up by itself when
attached to a Linux box right after that.  The first SCSI command that
required the bridge to access the drive ended in
sda:<6>sd 18:0:0:0: Device not ready: <6>: Current: sense key: Not Ready
    Additional sense: Logical unit not ready, initializing cmd. required

Therefore the flag which instructs scsi_mod to send START STOP UNIT with
START=1 ("make medium ready") after such a condition is now enabled
unconditionally for all FireWire storage devices.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c	2006-08-05 16:58:30.000000000 +0200
+++ linux/drivers/ieee1394/sbp2.c	2006-08-07 20:13:59.000000000 +0200
@@ -2451,6 +2451,7 @@ static int sbp2scsi_slave_alloc(struct s
 		(struct scsi_id_instance_data *)sdev->host->hostdata[0];
 
 	scsi_id->sdev = sdev;
+	sdev->allow_restart = 1;
 
 	if (scsi_id->workarounds & SBP2_WORKAROUND_INQUIRY_36)
 		sdev->inquiry_len = 36;
@@ -2473,9 +2474,6 @@ static int sbp2scsi_slave_configure(stru
 		sdev->fix_capacity = 1;
 	if (scsi_id->workarounds & SBP2_WORKAROUND_MODE_SENSE_6)
 		sdev->use_10_for_ms = 0;
-	if (scsi_id->ne->guid_vendor_id == 0x0010b9 && /* Maxtor's OUI */
-	    (sdev->type == TYPE_DISK || sdev->type == TYPE_RBC))
-		sdev->allow_restart = 1;
 	return 0;
 }
 



-------------------------------------------------------------------------
Using Tomcat but need to do more? Need to support web services, security?
Get stuff done quickly with pre-integrated technology to make your job easier
Download IBM WebSphere Application Server v.1.0.1 based on Apache Geronimo
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=120709&bid=263057&dat=121642
