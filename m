From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Another fix for suspend i/o - validate dev state
	before transition
Date: Fri, 10 Dec 2004 22:48:42 -0600
Message-ID: <1102740522.5181.8.camel@mulgrave>
References: <0B1E13B586976742A7599D71A6AC733C02F279@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:57828 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261826AbULKEsv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Dec 2004 23:48:51 -0500
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C02F279@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-11-17 at 13:39 -0500, James.Smart@Emulex.Com wrote:
> The block/unblock patch reports stack dumps and illegal transitions when the driver continues to call block or unblock after the device has failed (moved into offline state due to i/o error, etc). The LLDD/transport is unaware of the sdev transition, so it doesn't know better.

> This patch has the internal device block/unblock routines validate the state transition before invoking it.

Well, my basic problem with this is that the idea of the state model is
to consolidate the allowed transitions in a single place.  Having the
calling routines second guess the transitions rather defeats that
purpose.

If the only problem with the current scheme is the somewhat scary
verbosity then we can shut it up by making the message part of the
logging infrastructure.

How about the attached (ERROR_RECOVERY is the closest log function I can
find which seems to fit the bill).

James

===== scsi_lib.c 1.140 vs edited =====
--- 1.140/drivers/scsi/scsi_lib.c	2004-11-28 06:12:22 -06:00
+++ edited/scsi_lib.c	2004-12-10 22:44:53 -06:00
@@ -1710,11 +1710,12 @@
 	return 0;
 
  illegal:
-	dev_printk(KERN_ERR, &sdev->sdev_gendev,
-		   "Illegal state transition %s->%s\n",
-		   scsi_device_state_name(oldstate),
-		   scsi_device_state_name(state));
-	WARN_ON(1);
+	SCSI_LOG_ERROR_RECOVERY(1, 
+				dev_printk(KERN_ERR, &sdev->sdev_gendev,
+					   "Illegal state transition %s->%s\n",
+					   scsi_device_state_name(oldstate),
+					   scsi_device_state_name(state))
+				);
 	return -EINVAL;
 }
 EXPORT_SYMBOL(scsi_device_set_state);


