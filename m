From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Wrong size information for devices with disabled read access
Date: Fri, 01 Sep 2006 15:50:23 +0200
Message-ID: <44F83A9F.6010502@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010200050804080903010200"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:19434 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S1751507AbWIANuZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Sep 2006 09:50:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------010200050804080903010200
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi James,

when accessing a device with disabled read access the capacity is set
somewhat arbitrary to 1GB. This makes it quite impossible for userspace
applications to detect this as an invalid capacity.
And it is inconsistent with other error conditions, where the capacity
is in fact set to 0.

Please apply.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstraße 5				+49 911 74053 688
90409 Nürnberg				http://www.suse.de

--------------010200050804080903010200
Content-Type: text/plain;
 name="sd-fix-unknown-size"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sd-fix-unknown-size"

Wrong size information for devices with disabled read access

When accessing a device with disabled read access the capacity is set
randomly to 1GB. This makes it impossible to userspace tools to detect
invalid device capacities.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>
Acked-by: Chris Mason <mason@suse.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 98bd3aa..638cff4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1215,7 +1215,7 @@ repeat:
 		/* Either no media are present but the drive didn't tell us,
 		   or they are present but the read capacity command fails */
 		/* sdkp->media_present = 0; -- not always correct */
-		sdkp->capacity = 0x200000; /* 1 GB - random */
+		sdkp->capacity = 0; /* unknown mapped to zero - as usual */
 
 		return;
 	} else if (the_result && longrc) {

--------------010200050804080903010200--
