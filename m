From: madhu.iyengar@qlogic.com
Subject: [PATCH 5/7] qla2xxx: Cover UNDERRUN case where SCSI status is set.
Date: Fri,  3 Sep 2010 14:57:04 -0700
Message-ID: <1283551026-3886-6-git-send-email-madhu.iyengar@qlogic.com>
References: <1283551026-3886-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:42966 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1757626Ab0ICWDH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Sep 2010 18:03:07 -0400
In-Reply-To: <1283551026-3886-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: nkmi@yahoo.com

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

Currently, if target sets the SCSI Status (with Check condition)
and there is no FCP residual bit set then driver  does not check
for dropped frame.  This could lead to data corruption.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 6982ba7..28f65be 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1706,19 +1706,20 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 				cp->result = DID_ERROR << 16;
 				break;
 			}
-		} else if (!lscsi_status) {
+		} else {
 			DEBUG2(qla_printk(KERN_INFO, ha,
 			    "scsi(%ld:%d:%d) Dropped frame(s) detected (0x%x "
 			    "of 0x%x bytes).\n", vha->host_no, cp->device->id,
 			    cp->device->lun, resid, scsi_bufflen(cp)));
 
-			cp->result = DID_ERROR << 16;
-			break;
+			cp->result = DID_ERROR << 16 | lscsi_status;
+			goto check_scsi_status;
 		}
 
 		cp->result = DID_OK << 16 | lscsi_status;
 		logit = 0;
 
+check_scsi_status:
 		/*
 		 * Check to see if SCSI Status is non zero. If so report SCSI
 		 * Status.
-- 
1.6.0.2

