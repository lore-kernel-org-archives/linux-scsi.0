From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: introduce a quirk for false cache reporting
Date: Wed, 10 Aug 2016 22:40:29 -0400
Message-ID: <yq18tw4rpsy.fsf@sermon.lab.mkp.net>
References: <1470657309-9564-1-git-send-email-oneukum@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29233 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203AbcHKCli (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Aug 2016 22:41:38 -0400
In-Reply-To: <1470657309-9564-1-git-send-email-oneukum@suse.com> (Oliver
	Neukum's message of "Mon, 8 Aug 2016 13:55:09 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.com>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com

>>>>> "Oliver" == Oliver Neukum <oneukum@suse.com> writes:

Oliver> Some SATA to USB bridges fail to cooperate with some drives
Oliver> resulting in no cache being present being reported to the
Oliver> host. That causes the host to skip sending a command to
Oliver> synchronize caches. That causes data loss when the drive is
Oliver> powered down.

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index a6c346d..392d166 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -179,6 +179,7 @@ struct scsi_device {
 	unsigned try_rc_10_first:1;	/* Try READ_CAPACACITY_10 first */
 	unsigned is_visible:1;	/* is the device visible in sysfs */
 	unsigned wce_default_on:1;	/* Cache is ON by default */
+	unsigned always_sync:1;		/* synchronize cache in every case*/
 	unsigned no_dif:1;	/* T10 PI (DIF) should be disabled */
 	unsigned broken_fua:1;		/* Don't set FUA bit */
 	unsigned lun_in_cdb:1;		/* Store LUN bits in CDB[1] */

I must be missing something. How is always_sync different from just
setting wce_default_on?

-- 
Martin K. Petersen	Oracle Linux Engineering
