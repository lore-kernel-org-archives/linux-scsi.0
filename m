From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 4/5] aacraid:  remove scsi_remove_device
Date: Tue, 19 Sep 2006 09:00:18 -0700
Message-ID: <1158681618.2837.25.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:63138 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751808AbWISQAW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Sep 2006 12:00:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Received from Mark Salyzyn:

Until the system is stabilized, I am suggesting the enclosed
modification to prevent the driver from tickling the panic. Once sysfs
and friends are stabilized, the patch may be backed out. We have yet to
evaluate if we really want to relinquish existing Scsi Devices in any
case, holding on to them as configuration of arrays comes and goes makes
some sense as well. As a result, we have opted to pull the lines rather
than comment them in legacy.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

---

--- scsi-misc-aac.orig/drivers/scsi/aacraid/commsup.c	2006-09-12 09:49:31.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/commsup.c	2006-09-12 09:49:43.000000000 -0700
@@ -1033,13 +1033,7 @@
 	if (device) {
 		switch (device_config_needed) {
 		case DELETE:
-			scsi_remove_device(device);
-			break;
 		case CHANGE:
-			if (!dev->fsa_dev[container].valid) {
-				scsi_remove_device(device);
-				break;
-			}
 			scsi_rescan_device(&device->sdev_gendev);
 
 		default:

-- 
Mark Haverkamp <markh@osdl.org>

