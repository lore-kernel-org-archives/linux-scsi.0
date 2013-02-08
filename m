From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 17/23] qla2xxx: Correct list-iteration bug in Report-ID Acquisition codes.
Date: Fri,  8 Feb 2013 01:57:58 -0500
Message-ID: <1360306684-8286-18-git-send-email-saurav.kashyap@qlogic.com>
References: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:60165 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1760000Ab3BHHTM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Feb 2013 02:19:12 -0500
In-Reply-To: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Code in qla24xx_report_id_acquisition() incorrectly assumed that
upon completion of list iteration (with no match), the 'pos'
(vp) variable passed to list_for_each_entry() would be set to
NULL.  In this context, if the firmware were to return an
unrecognized vp_idx, the follow-on assignments to vp-members
could result in corruption of the structure.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 2b6782d..dc0fe52 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3141,6 +3141,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 	struct qla_hw_data *ha = vha->hw;
 	scsi_qla_host_t *vp;
 	unsigned long   flags;
+	int found;
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x10b6,
 	    "Entered %s.\n", __func__);
@@ -3176,13 +3177,17 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 			return;
 		}
 
+		found = 0;
 		spin_lock_irqsave(&ha->vport_slock, flags);
-		list_for_each_entry(vp, &ha->vp_list, list)
-			if (vp_idx == vp->vp_idx)
+		list_for_each_entry(vp, &ha->vp_list, list) {
+			if (vp_idx == vp->vp_idx) {
+				found = 1;
 				break;
+			}
+		}
 		spin_unlock_irqrestore(&ha->vport_slock, flags);
 
-		if (!vp)
+		if (!found)
 			return;
 
 		vp->d_id.b.domain = rptid_entry->port_id[2];
-- 
1.7.7

