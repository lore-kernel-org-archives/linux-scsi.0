From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 32/32] isd200.c - use of scsi_data_buffer
Date: Wed, 17 Oct 2007 20:32:03 +0200
Message-ID: <47165523.3090903@panasas.com>
References: <47164306.6090702@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:27758 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757302AbXJQSdJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 14:33:09 -0400
In-Reply-To: <47164306.6090702@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <tomof@acm.org>, Matthew Wilcox <matthew@wil.cx>, Matthew Dharm <mdharm-scsi@one-e>
Cc: Benny Halevy <bhalevy@panasas.com>, Pete Wyckoff <pw@osc.edu>


  - This driver still bags on scsi_cmnd IO members, so need changing

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/usb/storage/isd200.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index a624b4e..15e844d 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -415,14 +415,14 @@ static void isd200_set_srb(struct isd200_info *info,
 		sg_init_one(&info->sg, buff, bufflen);
 
 	srb->sc_data_direction = dir;
-	srb->request_buffer = buff ? &info->sg : NULL;
-	srb->request_bufflen = bufflen;
-	srb->use_sg = buff ? 1 : 0;
+	srb->sdb.sglist = buff ? &info->sg : NULL;
+	srb->sdb.length = bufflen;
+	srb->sdb.sg_count = buff ? 1 : 0;
 }
 
 static void isd200_srb_set_bufflen(struct scsi_cmnd *srb, unsigned bufflen)
 {
-	srb->request_bufflen = bufflen;
+	srb->sdb.length = bufflen;
 }
 
 
-- 
1.5.3.1


