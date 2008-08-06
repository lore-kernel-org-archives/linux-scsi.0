From: Hugh Dickins <hugh@veritas.com>
Subject: [PATCH][SCS] sd: Read Capacity if (16) fails
Date: Wed, 6 Aug 2008 15:06:21 +0100 (BST)
Message-ID: <Pine.LNX.4.64.0808061500450.1109@blonde.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:35121 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754AbYHFOGk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Aug 2008 10:06:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Commit e0597d70012c82e16ee152270a55d89d8bf66693 (sd: Identify DIF protection
type and application tag ownership) says that if a disk is formatted with
Inquiry bit PROTECT=1, it is required to support Read Capacity(16).  But my
SD cards, accessed by builtin cardreader and generic USB storage, disagree.

Therefore fall back to the familiar Read Capacity if Read Capacity(16) fails:
without even showing the "failed" message since I expect this will be common.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
Or is USB storage missing something to support Read Capacity(16)?

 drivers/scsi/sd.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- 2.6.27-rc2/drivers/scsi/sd.c	2008-07-29 04:24:38.000000000 +0100
+++ linux/drivers/scsi/sd.c	2008-08-06 08:53:13.000000000 +0100
@@ -1287,6 +1287,7 @@ sd_read_capacity(struct scsi_disk *sdkp,
 	int sector_size = 0;
 	/* Force READ CAPACITY(16) when PROTECT=1 */
 	int longrc = scsi_device_protection(sdkp->device) ? 1 : 0;
+	int tried_both = 0;
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	struct scsi_device *sdp = sdkp->device;
@@ -1341,6 +1342,10 @@ repeat:
 		return;
 	} else if (the_result && longrc) {
 		/* READ CAPACITY(16) has been failed */
+		if (!tried_both++) {
+			longrc = 0;
+			goto repeat;
+		}
 		sd_printk(KERN_NOTICE, sdkp, "READ CAPACITY(16) failed\n");
 		sd_print_result(sdkp, the_result);
 		sd_printk(KERN_NOTICE, sdkp, "Use 0xffffffff as device size\n");
@@ -1357,6 +1362,7 @@ repeat:
 			if(sizeof(sdkp->capacity) > 4) {
 				sd_printk(KERN_NOTICE, sdkp, "Very big device. "
 					  "Trying to use READ CAPACITY(16).\n");
+				tried_both++;
 				longrc = 1;
 				goto repeat;
 			}
