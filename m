From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] fix operation related to scsi_normalize_sense in target
 driver for EMC CLARiiON
Date: Tue, 16 Nov 2010 21:21:01 +0800
Message-ID: <AANLkTi=K4HcM0ZoMXG=D3EE0ERPJNjp24GHRg_LYstgZ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40791 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016Ab0KPNVD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2010 08:21:03 -0500
Received: by wwa36 with SMTP id 36so744195wwa.1
        for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2010 05:21:02 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The check of the result of scsi_normalize_sense is incorrect, since it
is up set down.

And it looks more like a typo.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/device_handler/scsi_dh_emc.c	2010-11-01
19:54:12.000000000 +0800
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c	2010-11-16
20:50:36.000000000 +0800
@@ -128,7 +128,7 @@ static int trespass_endio(struct scsi_de
 	int err = SCSI_DH_IO;
 	struct scsi_sense_hdr sshdr;

-	if (!scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE, &sshdr)) {
+	if (scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE, &sshdr)) {
 		sdev_printk(KERN_ERR, sdev, "%s: Found valid sense data 0x%2x, "
 			    "0x%2x, 0x%2x while sending CLARiiON trespass "
 			    "command.\n", CLARIION_NAME, sshdr.sense_key,
