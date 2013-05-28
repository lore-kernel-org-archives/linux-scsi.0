From: Joe Lawrence <Joe.Lawrence@stratus.com>
Subject: scsi_dh_emc: handle zero-senselen send_inquiry_cmd errors
Date: Tue, 28 May 2013 17:23:27 -0400 (EDT)
Message-ID: <alpine.DEB.2.02.1305281721250.25762@jlaw-desktop.mno.stratus.com>
References: <alpine.DEB.2.02.1305281713410.25762@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.stratus.com ([134.111.1.18]:58886 "EHLO
	mailhub5.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933814Ab3E1V1i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 May 2013 17:27:38 -0400
In-Reply-To: <alpine.DEB.2.02.1305281713410.25762@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Joe Lawrence <joe.lawrence@stratus.com>

>From c6645f639f7e7551c7a6f0aacee78e57ddd37bc1 Mon Sep 17 00:00:00 2001
From: Joe Lawrence <joe.lawrence@stratus.com>
Date: Tue, 28 May 2013 14:49:37 -0400
Subject: [PATCH 1/2] scsi_dh_emc: handle zero-senselen send_inquiry_cmd
 errors

The send_inquiry_cmd function may exit without setting senselen if
get_req fails.  Callers shouldn't assume senselen is set non-zero in
their failure checking.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/device_handler/scsi_dh_emc.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index e1c8be0..0438ed6 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -468,9 +468,12 @@ static int clariion_std_inquiry(struct scsi_device *sdev,
 	char *sp_model;
 
 	err = send_inquiry_cmd(sdev, 0, csdev);
-	if (err != SCSI_DH_OK && csdev->senselen) {
+	if (err != SCSI_DH_OK) {
 		struct scsi_sense_hdr sshdr;
 
+		if (!csdev->senselen)
+			goto out;
+
 		if (scsi_normalize_sense(csdev->sense, SCSI_SENSE_BUFFERSIZE,
 					 &sshdr)) {
 			sdev_printk(KERN_ERR, sdev, "%s: INQUIRY sense code "
@@ -507,9 +510,12 @@ static int clariion_send_inquiry(struct scsi_device *sdev,
 
 retry:
 	err = send_inquiry_cmd(sdev, 0xC0, csdev);
-	if (err != SCSI_DH_OK && csdev->senselen) {
+	if (err != SCSI_DH_OK) {
 		struct scsi_sense_hdr sshdr;
 
+		if (!csdev->senselen)
+			goto out;
+
 		err = scsi_normalize_sense(csdev->sense, SCSI_SENSE_BUFFERSIZE,
 					   &sshdr);
 		if (!err)
@@ -527,6 +533,7 @@ retry:
 	} else {
 		err = parse_sp_info_reply(sdev, csdev);
 	}
+out:
 	return err;
 }
 
-- 
1.7.10.4

