From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: dpt_i2o scan fix for 2.4.* kernels
Date: Tue, 8 Jun 2004 08:46:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189FD238E7@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:24551 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S265195AbUFHMqo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jun 2004 08:46:44 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id i58CkiX13806
	for <linux-scsi@vger.kernel.org>; Tue, 8 Jun 2004 05:46:44 -0700
Received: from otce2k03.adaptec.com (otce2k03.adaptec.com [10.12.1.72])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id i58Ckho18597
	for <linux-scsi@vger.kernel.org>; Tue, 8 Jun 2004 05:46:43 -0700
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch fixes a problem in the dpt_i2o driver that resulted from the
initial scan re-using the scsi_device structure without resetting the
hostdata portion back to zero. Duplicate devices would show up at ghost
target ids. I have *not* checked if this similar behavior is observed in
the 2.6.* kernels.

This fix also adds a scan for lun holes and spoofs back a 0x7F inquiry
response for those holes to permit proper target discovery. This portion
of the `patch' is appropriate for both 2.4.* and 2.6.* kernel variants
of this driver (+/-).

Sincerely -- Mark Salyzyn

--- /tmp/dpt_i2o/dpt_i2o.c	Tue Jun  1 09:02:48 2004
+++ dpt_i2o/dpt_i2o.c	Sat Jun  5 14:04:12 2004
@@ -453,15 +563,29 @@
 
 	// TODO if the cmd->device if offline then I may need to issue a
bus rescan
 	// followed by a get_lct to see if the device is there anymore
-	if((pDev = (struct adpt_device*) (cmd->device->hostdata)) ==
NULL) {
+	if(((pDev = (struct adpt_device*) (cmd->device->hostdata)) ==
NULL)
+	 || ((cmd->cmnd[0] == INQUIRY)
+	  && ((pDev->scsi_channel != cmd->device->channel)
+	   || (pDev->scsi_id != cmd->device->id)
+	   || (pDev->scsi_lun != cmd->device->lun)))) {
 		/*
 		 * First command request for this device.  Set up a
pointer
 		 * to the device structure.  This should be a
TEST_UNIT_READY
 		 * command from scan_scsis_single.
 		 */
 		if ((pDev = adpt_find_device(pHba,
(u32)cmd->device->channel, (u32)cmd->device->id, (u32)cmd->device->lun))
== NULL) {
+	 		if (cmd->cmnd[0] == INQUIRY) {
+				int lun = cmd->device->lun;
+				while (lun < pHba->host->max_lun) {
+					if (adpt_find_device(pHba,
(u32)cmd->device->channel, (u32)cmd->device->id, lun) != NULL) {
+			  			((u8*)cmd->buffer)[0] =
0x7F;
+						cmd->result = (DID_OK <<
16);
+						cmd->scsi_done(cmd);
+						return 0;
+					}
+					++lun;
+				}
+			}
-			// TODO: if any luns are at this bus, scsi id
then fake a TEST_UNIT_READY and INQUIRY response 
-			// with type 7F (for all luns less than the max
for this bus,id) so the lun scan will continue.
 			cmd->result = (DID_NO_CONNECT << 16);
 			cmd->scsi_done(cmd);
 			return 0;
