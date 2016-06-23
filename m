From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH} SCSI: fix new bug in scsi_dev_info_list string matching
Date: Thu, 23 Jun 2016 15:05:26 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1606231454380.1334-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:44878 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750876AbcFWTF2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jun 2016 15:05:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Wilfried Klaebe <linux-kernel@lebenslange-mailadresse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>

Commit b704f70ce200 ("SCSI: fix bug in scsi_dev_info_list matching")
changed the way vendor- and model-string matching was carried out in
the routine that looks up entries in a SCSI devinfo list.  The new
matching code failed to take into account the case of a maximum-length
string; in such cases it could end up testing for a terminating '\0'
byte beyond the end of the memory allocated to the string.  This
out-of-bounds bug was detected by UBSAN.

I don't know if anybody has actually encountered this bug.  The
symptom would be that a device entry in the blacklist might not be
matched properly if it contained an 8-character vendor name or a
16-character model name.  Such entries certainly exist in
scsi_static_device_list.

This patch fixes the problem by adding a check for a maximum-length
string before the '\0' test.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Fixes: b704f70ce200 ("SCSI: fix bug in scsi_dev_info_list matching")
Tested-by: Wilfried Klaebe <linux-kernel@lebenslange-mailadresse.de>
CC: <stable@vger.kernel.org>

---


[as1804]


 drivers/scsi/scsi_devinfo.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: usb-4.x/drivers/scsi/scsi_devinfo.c
===================================================================
--- usb-4.x.orig/drivers/scsi/scsi_devinfo.c
+++ usb-4.x/drivers/scsi/scsi_devinfo.c
@@ -429,7 +429,7 @@ static struct scsi_dev_info_list *scsi_d
 	 * here, and we don't know what device it is
 	 * trying to work with, leave it as-is.
 	 */
-	vmax = 8;	/* max length of vendor */
+	vmax = sizeof(devinfo->vendor);
 	vskip = vendor;
 	while (vmax > 0 && *vskip == ' ') {
 		vmax--;
@@ -439,7 +439,7 @@ static struct scsi_dev_info_list *scsi_d
 	while (vmax > 0 && vskip[vmax - 1] == ' ')
 		--vmax;
 
-	mmax = 16;	/* max length of model */
+	mmax = sizeof(devinfo->model);
 	mskip = model;
 	while (mmax > 0 && *mskip == ' ') {
 		mmax--;
@@ -455,10 +455,12 @@ static struct scsi_dev_info_list *scsi_d
 			 * Behave like the older version of get_device_flags.
 			 */
 			if (memcmp(devinfo->vendor, vskip, vmax) ||
-					devinfo->vendor[vmax])
+					(vmax < sizeof(devinfo->vendor) &&
+						devinfo->vendor[vmax]))
 				continue;
 			if (memcmp(devinfo->model, mskip, mmax) ||
-					devinfo->model[mmax])
+					(mmax < sizeof(devinfo->model) &&
+						devinfo->model[mmax]))
 				continue;
 			return devinfo;
 		} else {

