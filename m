From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 1/4] qla2xxx: Correct needless clean-up resets during shutdown.
Date: Thu, 28 Feb 2008 14:06:09 -0800
Message-ID: <1204236372-19080-1-git-send-email-andrew.vasquez@qlogic.com>
References: <20080228220509.GE18083@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:21373 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487AbYB1WG1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Feb 2008 17:06:27 -0500
In-Reply-To: <20080228220509.GE18083@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

There's no point in hitting the RISC with what will most
assuredly be an unsucessful reset of the RISC hardware if the
initial stop-firmware mailbox command fails with a time-out
status.  Instead, to avoid what could amount to a lengthy
stop-firmware/detect-failure/reset-risc loop, continue with
driver unloading and discard the stop-firmware requirement.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index d5c7853..4897663 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4022,7 +4022,8 @@ qla2x00_try_to_stop_firmware(scsi_qla_host_t *ha)
 		return;
 
 	ret = qla2x00_stop_firmware(ha);
-	for (retries = 5; ret != QLA_SUCCESS && retries ; retries--) {
+	for (retries = 5; ret != QLA_SUCCESS && ret != QLA_FUNCTION_TIMEOUT &&
+	    retries ; retries--) {
 		qla2x00_reset_chip(ha);
 		if (qla2x00_chip_diag(ha) != QLA_SUCCESS)
 			continue;
-- 
1.5.4.3.230.g2db511

