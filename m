From: giridhar.malavali@qlogic.com
Subject: [PATCH 08/17] qla2xxx: Make the FC port capability mutual exclusive.
Date: Fri, 28 May 2010 15:08:22 -0700
Message-ID: <1275084511-95266-9-git-send-email-giridhar.malavali@qlogic.com>
References: <1275084511-95266-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:52691 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1752750Ab0E1WId (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2010 18:08:33 -0400
In-Reply-To: <1275084511-95266-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

In case of both target and initiator capabilities reported by fc port,
the fc port port capability is made mutualy exclusive with priority given
for target capabilities.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index e51fc5f..8a60872 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1133,9 +1133,9 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 			fcport->port_type = FCT_TARGET;
 			if (iop[0] & BIT_8)
 				fcport->flags |= FCF_FCP2_DEVICE;
-		}
-		if (iop[0] & BIT_5)
+		} else if (iop[0] & BIT_5)
 			fcport->port_type = FCT_INITIATOR;
+
 		if (logio->io_parameter[7] || logio->io_parameter[8])
 			fcport->supported_classes |= FC_COS_CLASS2;
 		if (logio->io_parameter[9] || logio->io_parameter[10])
-- 
1.6.2.rc1.30.gd43c

