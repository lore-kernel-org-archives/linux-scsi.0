From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] fix retries of scsi device in scsi library
Date: Sat, 6 Nov 2010 19:36:53 +0800
Message-ID: <AANLkTink9T7-b7V_9EAToPrGSWAmK9s+G7d5Ybxc+srr@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44463 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab0KFLgz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Nov 2010 07:36:55 -0400
Received: by wwb39 with SMTP id 39so2287905wwb.1
        for <linux-scsi@vger.kernel.org>; Sat, 06 Nov 2010 04:36:54 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The computation of retries for sdev is not correct since it is less
than what the caller asks.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/scsi_lib.c	2010-09-13 07:07:38.000000000 +0800
+++ b/drivers/scsi/scsi_lib.c	2010-11-06 19:34:18.000000000 +0800
@@ -2000,7 +2000,7 @@ scsi_test_unit_ready(struct scsi_device
 		    sshdr->sense_key == UNIT_ATTENTION)
 			sdev->changed = 1;
 	} while (scsi_sense_valid(sshdr) &&
-		 sshdr->sense_key == UNIT_ATTENTION && --retries);
+		 sshdr->sense_key == UNIT_ATTENTION && retries--);

 	if (!sshdr)
 		/* could not allocate sense buffer, so can't process it */
