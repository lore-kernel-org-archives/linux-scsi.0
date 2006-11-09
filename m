From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Convert jiffies to msecs in scsi_ioctl()
Date: Thu, 09 Nov 2006 11:55:41 +0100
Message-ID: <4553092D.70102@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000305010102060802000408"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:62918 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S932497AbWKIKzm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Nov 2006 05:55:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------000305010102060802000408
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hi all,

The attached patch fixes the conversion from jiffies to msecs in
scsi_ioctl(). The current code works if HZ=1000, but will lead to 
incorrect timeout settings for other values.

Please apply.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstraße 5				+49 911 74053 688
90409 Nürnberg				http://www.suse.de

--------------000305010102060802000408
Content-Type: text/plain;
 name="scsi-ioctl-convert-jiffies-to-msecs"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi-ioctl-convert-jiffies-to-msecs"

Fix conversion from jiffies to msecs for sg_io()

Use the proper conversion function for convert jiffies to msecs in
sg_io().

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 2dc3264..ac63964 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -304,7 +304,7 @@ static int sg_io(struct file *file, requ
 	if (rq->bio)
 		blk_queue_bounce(q, &rq->bio);
 
-	rq->timeout = (hdr->timeout * HZ) / 1000;
+	rq->timeout = jiffies_to_msecs(hdr->timeout);
 	if (!rq->timeout)
 		rq->timeout = q->sg_timeout;
 	if (!rq->timeout)
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c

--------------000305010102060802000408--
