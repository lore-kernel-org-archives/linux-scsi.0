From: Joe Jin <joe.jin@oracle.com>
Subject: [patch] qla2xxx: use F/W calculated residual length.
Date: Tue, 1 Dec 2009 09:37:20 +0800
Message-ID: <20091201013720.GA15068@joejin-pc.cn.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:49864 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbZLABif (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Nov 2009 20:38:35 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, gurudas.pai@oracle.com, kate.zhang@oracle.com, joe.jin@oracle.com

Hi,

When comp_status is CS_DATA_OVERRUN, residual length calculated by F/W,
but when comp_status is CS_COMMPLETE, residual length just set to residual
count, at here calculated residual length may via F/W?

Please review.

Signed-off-by: Joe Jin <joe.jin@oracle.com>
CC: Andrew Vasquez <andrew.vasquez@qlogic.com>

---
 qla_isr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index b20a716..4d1d410 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1398,7 +1398,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 			break;
 		}
 		if (scsi_status & (SS_RESIDUAL_UNDER | SS_RESIDUAL_OVER)) {
-			resid = resid_len;
+			resid = IS_FWI2_CAPABLE(ha) ? fw_resid_len : resid_len;
 			scsi_set_resid(cp, resid);
 
 			if (!lscsi_status &&


