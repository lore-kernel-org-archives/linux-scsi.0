From: madhu.iyengar@qlogic.com
Subject: [PATCH 03/14] qla2xxx: Populate FCP_PRIO location for no *FLT* case
Date: Tue, 21 Dec 2010 16:00:16 -0800
Message-ID: <1292976027-12034-4-git-send-email-madhu.iyengar@qlogic.com>
References: <1292976027-12034-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36147 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1752970Ab0LVADX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Dec 2010 19:03:23 -0500
In-Reply-To: <1292976027-12034-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_sup.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 76de957..2207062 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -669,6 +669,13 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 		def = 1;
 	else if (IS_QLA81XX(ha))
 		def = 2;
+
+	/* Assign FCP prio region since older adapters may not have FLT, or
+	   FCP prio region in it's FLT.
+	 */
+	ha->flt_region_fcp_prio = ha->flags.port0 ?
+	    fcp_prio_cfg0[def] : fcp_prio_cfg1[def];
+
 	ha->flt_region_flt = flt_addr;
 	wptr = (uint16_t *)req->ring;
 	flt = (struct qla_flt_header *)req->ring;
@@ -696,10 +703,6 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 		goto no_flash_data;
 	}
 
-	/* Assign FCP prio region since older FLT's may not have it */
-	ha->flt_region_fcp_prio = ha->flags.port0 ?
-	    fcp_prio_cfg0[def] : fcp_prio_cfg1[def];
-
 	loc = locations[1];
 	cnt = le16_to_cpu(flt->length) / sizeof(struct qla_flt_region);
 	for ( ; cnt; cnt--, region++) {
-- 
1.6.0.2

