From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 03/19] qla2xxx: Limit iIDMA speed adjustments.
Date: Thu, 20 Sep 2007 14:07:34 -0700
Message-ID: <1190322470-15543-3-git-send-email-andrew.vasquez@qlogic.com>
References: <20070920210422.GE8456@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:11180 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbXITVHl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Sep 2007 17:07:41 -0400
In-Reply-To: <20070920210422.GE8456@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Do not adjust the iIDMA speed on ports which have a faster
link-speed than the HBA itself.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 083997c..45da947 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2126,15 +2126,9 @@ qla2x00_iidma_fcport(scsi_qla_host_t *ha, fc_port_t *fcport)
 	if (!IS_IIDMA_CAPABLE(ha))
 		return;
 
-	if (fcport->fp_speed == PORT_SPEED_UNKNOWN) {
-		DEBUG2(printk("scsi(%ld): %02x%02x%02x%02x%02x%02x%02x%02x -- "
-		    "unsupported FM port operating speed.\n",
-		    ha->host_no, fcport->port_name[0], fcport->port_name[1],
-		    fcport->port_name[2], fcport->port_name[3],
-		    fcport->port_name[4], fcport->port_name[5],
-		    fcport->port_name[6], fcport->port_name[7]));
+	if (fcport->fp_speed == PORT_SPEED_UNKNOWN ||
+	    fcport->fp_speed > ha->link_data_rate)
 		return;
-	}
 
 	rval = qla2x00_set_idma_speed(ha, fcport->loop_id, fcport->fp_speed,
 	    mb);
-- 
1.5.3.2.80.g077d6f

