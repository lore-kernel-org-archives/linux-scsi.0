From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH] qla2xxx: Issue correct MBC_INITIALIZE_FIRMWARE command.
Date: Thu, 17 Jan 2008 09:02:19 -0800
Message-ID: <1200589340-19499-13-git-send-email-andrew.vasquez@qlogic.com>
References: <20080117165940.GA19033@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:20849 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbYAQRCf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 12:02:35 -0500
In-Reply-To: <20080117165940.GA19033@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

From: Seokmann Ju <seokmann.ju@qlogic.com>

There is a case where 54xx HBA loads MID firmware as it use 24xx
firmware. In this case, the driver should issue
MBC_MID_INITIALIZE FIRMWARE even though the HBA doesn't support
NPIV.  This patch make changes in the driver so that could behave
accordingly.

Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    4 +++-
 drivers/scsi/qla2xxx/qla_mbx.c  |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 7637fa7..d0633ca 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1193,7 +1193,9 @@ qla2x00_init_rings(scsi_qla_host_t *ha)
 
 	DEBUG(printk("scsi(%ld): Issue init firmware.\n", ha->host_no));
 
-	mid_init_cb->count = cpu_to_le16(ha->max_npiv_vports);
+	if (ha->flags.npiv_supported)
+		mid_init_cb->count = cpu_to_le16(ha->max_npiv_vports);
+
 	mid_init_cb->options = __constant_cpu_to_le16(BIT_1);
 
 	rval = qla2x00_init_firmware(ha, ha->init_cb_size);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 99d29ff..0c10c0b 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -980,7 +980,7 @@ qla2x00_init_firmware(scsi_qla_host_t *ha, uint16_t size)
 	DEBUG11(printk("qla2x00_init_firmware(%ld): entered.\n",
 	    ha->host_no));
 
-	if (ha->flags.npiv_supported)
+	if (ha->fw_attributes & BIT_2)
 		mcp->mb[0] = MBC_MID_INITIALIZE_FIRMWARE;
 	else
 		mcp->mb[0] = MBC_INITIALIZE_FIRMWARE;
-- 
1.5.4.rc3.14.g44397

