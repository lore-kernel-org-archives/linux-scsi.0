From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 5/14] qla2xxx: Perform implicit LOGO during fabric logout request.
Date: Mon, 29 Jan 2007 10:22:22 -0800
Message-ID: <11700949513460-git-send-email-andrew.vasquez@qlogic.com>
References: <20070129182124.GA26940@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:47719 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbXA2SWg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jan 2007 13:22:36 -0500
In-Reply-To: <20070129182124.GA26940@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

Similarly to previous LOGO requests on non-24xx hardware,
perform an implicit-LOGO as to avoid the potential 2 *
R_A_TOV delay which can result during an explicit-LOGO
request.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 077e578..7a70ead 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1713,7 +1713,7 @@ qla24xx_fabric_logout(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
 	lg->entry_count = 1;
 	lg->nport_handle = cpu_to_le16(loop_id);
 	lg->control_flags =
-	    __constant_cpu_to_le16(LCF_COMMAND_LOGO|LCF_EXPL_LOGO);
+	    __constant_cpu_to_le16(LCF_COMMAND_LOGO|LCF_IMPL_LOGO);
 	lg->port_id[0] = al_pa;
 	lg->port_id[1] = area;
 	lg->port_id[2] = domain;
-- 
1.5.0.rc2.gdbaa0

