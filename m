From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 9/12]  qla2xxx: Use midlayer's int_to_scsilun() function.
Date: Thu, 13 Oct 2005 16:17:04 -0700 (PDT)
Message-ID: <20051013231704.27191.38698.sendpatchset@plap.qlogic.com>
References: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:46248 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S932535AbVJMXRE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Oct 2005 19:17:04 -0400
In-Reply-To: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

While populating command type 6 and 7 IOCBs.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_iocb.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

applies-to: fe8002ebcdf0c4c12e193b17cd64cc67b5a01bf5
95b166d4587c82ed5e261d9e7e8c7675ef808fff
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index ae63f8e..f13ddac 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -826,8 +826,7 @@ qla24xx_start_scsi(srb_t *sp)
 	cmd_pkt->port_id[1] = sp->fcport->d_id.b.area;
 	cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
 
-	cmd_pkt->lun[1] = LSB(sp->cmd->device->lun);
-	cmd_pkt->lun[2] = MSB(sp->cmd->device->lun);
+	int_to_scsilun(sp->cmd->device->lun, (struct scsi_lun *)cmd_pkt->lun);
 
 	/* Update tagged queuing modifier -- default is TSK_SIMPLE (0). */
 	if (scsi_populate_tag_msg(cmd, tag)) {
---
0.99.8.GIT

-- 
Andrew Vasquez
