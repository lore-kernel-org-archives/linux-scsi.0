From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] sg: Remove an unused variable
Date: Fri, 30 Jan 2015 16:22:38 +0100
Message-ID: <54CBA1BE.20206@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0054.outbound.protection.outlook.com ([207.46.100.54]:46409
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750852AbbA3PWs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jan 2015 10:22:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

The 'data_dir' variable is not used in sg_common_write(), hence
remove this variable.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index b14f64c..a668c88 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -763,7 +763,7 @@ static int
 sg_common_write(Sg_fd * sfp, Sg_request * srp,
 		unsigned char *cmnd, int timeout, int blocking)
 {
-	int k, data_dir, at_head;
+	int k, at_head;
 	Sg_device *sdp = sfp->parentdp;
 	sg_io_hdr_t *hp = &srp->header;
 
@@ -793,21 +793,6 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 		return -ENODEV;
 	}
 
-	switch (hp->dxfer_direction) {
-	case SG_DXFER_TO_FROM_DEV:
-	case SG_DXFER_FROM_DEV:
-		data_dir = DMA_FROM_DEVICE;
-		break;
-	case SG_DXFER_TO_DEV:
-		data_dir = DMA_TO_DEVICE;
-		break;
-	case SG_DXFER_UNKNOWN:
-		data_dir = DMA_BIDIRECTIONAL;
-		break;
-	default:
-		data_dir = DMA_NONE;
-		break;
-	}
 	hp->duration = jiffies_to_msecs(jiffies);
 	if (hp->interface_id != '\0' &&	/* v3 (or later) interface */
 	    (SG_FLAG_Q_AT_TAIL & hp->flags))
-- 
2.1.4

