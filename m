From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/6] qla2xxx: Use correct value for max vport in LOOP topology.
Date: Thu,  5 Mar 2009 11:07:01 -0800
Message-ID: <1236280025-89526-3-git-send-email-andrew.vasquez@qlogic.com>
References: <1236280025-89526-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:5602 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbZCETHK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2009 14:07:10 -0500
In-Reply-To: <1236280025-89526-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

Use minimum value for max vport during firmware initialization in LOOP
topology. Using max vport value from get resource count in LOOP topology
causes firmware initialization failure.

Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 9865017..14325c0 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1308,8 +1308,12 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 
 	DEBUG(printk("scsi(%ld): Issue init firmware.\n", vha->host_no));
 
-	if (ha->flags.npiv_supported)
+	if (ha->flags.npiv_supported) {
+		if (ha->operating_mode == LOOP)
+			ha->max_npiv_vports = MIN_MULTI_ID_FABRIC - 1;
 		mid_init_cb->count = cpu_to_le16(ha->max_npiv_vports);
+	}
+
 
 	mid_init_cb->options = __constant_cpu_to_le16(BIT_1);
 
-- 
1.6.2.rc0.55.g30aa4f

