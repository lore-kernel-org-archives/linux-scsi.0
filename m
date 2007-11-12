From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 1/4] qla2xxx: Don't explicitly read mbx registers while processing a system-error.
Date: Mon, 12 Nov 2007 10:30:57 -0800
Message-ID: <1194892260-27318-1-git-send-email-andrew.vasquez@qlogic.com>
References: <20071112182950.GC20765@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:33196 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbXKLSbV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Nov 2007 13:31:21 -0500
In-Reply-To: <20071112182950.GC20765@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Callers of qla2x00_async_event() already populate the mb[] array
upon invocation, doing so via the appropriate mailbox register
accessors.  The stale codes removed are leftover-bits kept during
the FWI2 transition.  Though relatively benign, the extra-reads
are not valid for FWI2 boards (ISP24xx and above) and peek into
the incorrect regions of registers.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 1104bd2..343af39 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -347,10 +347,6 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		break;
 
 	case MBA_SYSTEM_ERR:		/* System Error */
-		mb[1] = RD_MAILBOX_REG(ha, reg, 1);
-		mb[2] = RD_MAILBOX_REG(ha, reg, 2);
-		mb[3] = RD_MAILBOX_REG(ha, reg, 3);
-
 		qla_printk(KERN_INFO, ha,
 		    "ISP System Error - mbx1=%xh mbx2=%xh mbx3=%xh.\n",
 		    mb[1], mb[2], mb[3]);
-- 
1.5.3.5.643.g40e25

