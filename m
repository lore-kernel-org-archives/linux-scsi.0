From: giridhar.malavali@qlogic.com
Subject: [PATCH 01/14] qla2xxx: Modified the driver to pass the residaul UNDERRUN status
Date: Wed, 29 Jul 2009 11:03:50 -0700
Message-ID: <1248890643-761-2-git-send-email-giridhar.malavali@qlogic.com>
References: <1248890643-761-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:35909 "EHLO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750895AbZG2SEE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 14:04:04 -0400
In-Reply-To: <1248890643-761-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Ravi Anand <ravi.anand@qlogic.com>

From: Ravi Anand <ravi.anand@qlogic.com>

to application for vendor specific commands.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 245e7af..f966d54 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1223,6 +1223,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 					cp->device->id, cp->device->lun, resid,
 					scsi_bufflen(cp)));
 
+				scsi_set_resid(cp, resid);
 				cp->result = DID_ERROR << 16;
 				break;
 			}
-- 
1.6.2.rc1.30.gd43c

