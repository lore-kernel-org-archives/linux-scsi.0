From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 1/5] qla2xxx: Issue proper ISP callbacks during stop-firmware.
Date: Thu, 24 Jul 2008 08:31:46 -0700
Message-ID: <1216913510-14767-1-git-send-email-andrew.vasquez@qlogic.com>
References: <20080724153108.GI561@plap4-2.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:23068 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbYGXPbx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jul 2008 11:31:53 -0400
In-Reply-To: <20080724153108.GI561@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

As the original code would incorrectly call the non-ISP24xx/25xx
callbacks during recovery, a stop-firmware failure could result
in improper bit-banging of the RISC and in some cases manifest in
a NMI-watchdog trigger due to the RISC not coming out of its
reset state.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 44c0117..597ac20 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4038,8 +4038,8 @@ qla2x00_try_to_stop_firmware(scsi_qla_host_t *ha)
 	ret = qla2x00_stop_firmware(ha);
 	for (retries = 5; ret != QLA_SUCCESS && ret != QLA_FUNCTION_TIMEOUT &&
 	    retries ; retries--) {
-		qla2x00_reset_chip(ha);
-		if (qla2x00_chip_diag(ha) != QLA_SUCCESS)
+		ha->isp_ops->reset_chip(ha);
+		if (ha->isp_ops->chip_diag(ha) != QLA_SUCCESS)
 			continue;
 		if (qla2x00_setup_chip(ha) != QLA_SUCCESS)
 			continue;
-- 
1.6.0.rc0.42.g186458

