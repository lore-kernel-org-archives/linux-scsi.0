From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 18/22] qla2xxx: Only complete dcbx_comp and lb_portup_comp for virtual port index 0.
Date: Wed, 30 Oct 2013 03:38:25 -0400
Message-ID: <1383118709-5569-19-git-send-email-saurav.kashyap@qlogic.com>
References: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:2785 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752359Ab3J3IJw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Oct 2013 04:09:52 -0400
In-Reply-To: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 8e420e2..9bc86b9 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -323,7 +323,7 @@ qla81xx_idc_event(scsi_qla_host_t *vha, uint16_t aen, uint16_t descr)
 	case MBA_IDC_COMPLETE:
 		if (mb[1] >> 15) {
 			vha->hw->flags.idc_compl_status = 1;
-			if (vha->hw->notify_dcbx_comp)
+			if (vha->hw->notify_dcbx_comp && !vha->vp_idx)
 				complete(&vha->hw->dcbx_comp);
 		}
 		break;
@@ -794,7 +794,7 @@ skip_rio:
 			ql_dbg(ql_dbg_async, vha, 0x500d,
 			    "DCBX Completed -- %04x %04x %04x.\n",
 			    mb[1], mb[2], mb[3]);
-			if (ha->notify_dcbx_comp)
+			if (ha->notify_dcbx_comp && !vha->vp_idx)
 				complete(&ha->dcbx_comp);
 
 		} else
@@ -1068,7 +1068,7 @@ skip_rio:
 			}
 		}
 	case MBA_IDC_COMPLETE:
-		if (ha->notify_lb_portup_comp)
+		if (ha->notify_lb_portup_comp && !vha->vp_idx)
 			complete(&ha->lb_portup_comp);
 		/* Fallthru */
 	case MBA_IDC_TIME_EXT:
-- 
1.7.7

