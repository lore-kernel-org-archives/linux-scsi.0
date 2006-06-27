From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [RFT PATCH] ieee1394: sbp2: enable auto spin-up for Maxtor disks
Date: Tue, 27 Jun 2006 22:54:12 +0200 (CEST)
Message-ID: <tkrat.4b47e93f15c0a533@s5r6.in-berlin.de>
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
Cc: linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

At least Maxtor OneTouch III require a "start stop unit" command after
auto spin-down before the next access can proceed.  This patch activates
the responsible code in scsi_mod for all Maxtor SBP-2 disks.
https://bugzilla.novell.com/show_bug.cgi?id=183011

Maybe that should be done for all SBP-2 disks, but better be cautious.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
Applicable to Linux 2.6.17 and 2.6.17-mm2,  can be easily adapted to
older kernels.  Sorry for the cross-post but I need testers.  I don't
have Maxtor enclosures (affected or unaffected) and none of my
FireWire disks needs this patch.

Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c	2006-06-27 22:13:23.000000000 +0200
+++ linux/drivers/ieee1394/sbp2.c	2006-06-27 22:20:48.000000000 +0200
@@ -2516,6 +2516,9 @@ static int sbp2scsi_slave_configure(stru
 		sdev->skip_ms_page_8 = 1;
 	if (scsi_id->workarounds & SBP2_WORKAROUND_FIX_CAPACITY)
 		sdev->fix_capacity = 1;
+	if (scsi_id->ne->guid_vendor_id == 0x0010b9 && /* Maxtor's OUI */
+	    (sdev->type == TYPE_DISK || sdev->type == TYPE_RBC))
+		sdev->allow_restart = 1;
 	return 0;
 }
 



Using Tomcat but need to do more? Need to support web services, security?
Get stuff done quickly with pre-integrated technology to make your job easier
Download IBM WebSphere Application Server v.1.0.1 based on Apache Geronimo
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=120709&bid=263057&dat=121642
