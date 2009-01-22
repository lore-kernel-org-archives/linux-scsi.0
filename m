From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 03/12] qla2xxx: Ensure RISC-interrupt-enabled consistency for IS_NOPOLLING_TYPE() ISPs.
Date: Thu, 22 Jan 2009 09:45:30 -0800
Message-ID: <1232646339-32503-4-git-send-email-andrew.vasquez@qlogic.com>
References: <1232646339-32503-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:46489 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758708AbZAVRpl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jan 2009 12:45:41 -0500
In-Reply-To: <1232646339-32503-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Original code should work as well given qla24xx_reset_adapter()
is only called in extreme cases where the HBA is taken offline.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 9ad4d09..da9700f 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3562,6 +3562,9 @@ qla24xx_reset_adapter(scsi_qla_host_t *vha)
 	WRT_REG_DWORD(&reg->hccr, HCCRX_REL_RISC_PAUSE);
 	RD_REG_DWORD(&reg->hccr);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	if (IS_NOPOLLING_TYPE(ha))
+		ha->isp_ops->enable_intrs(ha);
 }
 
 /* On sparc systems, obtain port and node WWN from firmware
-- 
1.6.1.48.ge9b8

