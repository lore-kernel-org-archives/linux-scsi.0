From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/4] qla2xxx: Correct discrepancies during OVERRUN handling on FWI2-capable cards.
Date: Thu, 28 Feb 2008 14:06:10 -0800
Message-ID: <1204236372-19080-2-git-send-email-andrew.vasquez@qlogic.com>
References: <20080228220509.GE18083@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:21364 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758687AbYB1WGZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Feb 2008 17:06:25 -0500
In-Reply-To: <20080228220509.GE18083@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

For recent ISPs, software must detect OVERRUN conditions by
checking the SS_RESIDUAL_OVER bit during CS_COMPLETE handling.
Update the driver to perform this check, which is consistent with
what earlier firmwares did by explicitly cracking open the
FCP_RSP statuses and returning an CS_DATA_OVERRUN.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 14e6f22..f033703 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -958,6 +958,11 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 		}
 	}
 
+	/* Check for overrun. */
+	if (IS_FWI2_CAPABLE(ha) && comp_status == CS_COMPLETE &&
+	    scsi_status & SS_RESIDUAL_OVER)
+		comp_status = CS_DATA_OVERRUN;
+
 	/*
 	 * Based on Host and scsi status generate status code for Linux
 	 */
-- 
1.5.4.3.230.g2db511

