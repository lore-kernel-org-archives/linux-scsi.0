From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] retry with missing data for INQUIRY
Date: Fri, 5 Dec 2008 11:21:46 +0900
Message-ID: <20081205112146Z.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:37623 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083AbYLECV7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2008 21:21:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: orjan.nordlund@gmail.com, stern@rowland.harvard.edu
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

This depends on the following patch, adds residual argument to
scsi_execute and scsi_execute_req:

http://marc.info/?l=linux-scsi&m=122836830920741&w=2


With the above patch, we can fix the Thecus N2050 storage device
problem more cleanly, which was solved by Alan's patch:

http://marc.info/?l=linux-scsi&m=122513368301598&w=2


This patch is intended to replace Alan's patch in scsi-misc. Needs to
drop his patch, and then apply the above 'residual' patch and this.

I don't have the Thecus N2050 storage device so I changed the iSCSI
target code to simulate the wired INQUIRY behavior and tested this
patch. It would be nice to test this patch with the real hardware.

I prepared a patch for v2.6.28-rc7 to enable you to test this patch
easily:

http://www.kernel.org/pub/linux/kernel/people/tomo/misc/usb-workaround.diff


Thanks,

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] retry with missing data for INQUIRY

This patch changes scsi_probe_lun() to retry INQUIRY if the device has
actually sent back any INQUIRY data,

This enables the Thecus N2050 storage device to work better. The
firmware on that device starts up strangely; it sends no data in
response to the initial INQUIRY, and it sends the INQUIRY information
in response to the followup REQUEST SENSE. But after that it works
better, so retrying the INQUIRY is enough to get it going.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_scan.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 6963d52..18486b5 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -573,6 +573,8 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 
 	/* Each pass gets up to three chances to ignore Unit Attention */
 	for (count = 0; count < 3; ++count) {
+		int resid;
+
 		memset(scsi_cmd, 0, 6);
 		scsi_cmd[0] = INQUIRY;
 		scsi_cmd[4] = (unsigned char) try_inquiry_len;
@@ -582,7 +584,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		result = scsi_execute_req(sdev,  scsi_cmd, DMA_FROM_DEVICE,
 					  inq_result, try_inquiry_len, &sshdr,
 					  HZ / 2 + HZ * scsi_inq_timeout, 3,
-					  NULL);
+					  &resid);
 
 		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: INQUIRY %s "
 				"with code 0x%x\n",
@@ -603,6 +605,14 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 				    (sshdr.ascq == 0))
 					continue;
 			}
+		} else {
+			/*
+			 * if nothing was transferred, we try
+			 * again. It's a workaround for some USB
+			 * devices.
+			 */
+			if (resid == try_inquiry_len)
+				continue;
 		}
 		break;
 	}
-- 
1.5.5.GIT

