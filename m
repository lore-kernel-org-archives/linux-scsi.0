From: giridhar.malavali@qlogic.com
Subject: [PATCH 06/12] qla2xxx: Fix endian issues on PPC platfrom for NPIV.
Date: Fri, 31 Jul 2009 15:09:28 -0700
Message-ID: <1249078174-1957-7-git-send-email-giridhar.malavali@qlogic.com>
References: <1249078174-1957-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36793 "EHLO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753081AbZGaWJk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jul 2009 18:09:40 -0400
In-Reply-To: <1249078174-1957-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

VP IDX need to be converted to proper endian for NPIV
to work on PPC platforms.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index fe69f30..8fcd99e 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2746,7 +2746,8 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 	if (rptid_entry->format == 0) {
 		DEBUG15(printk("%s:format 0 : scsi(%ld) number of VPs setup %d,"
 			" number of VPs acquired %d\n", __func__, vha->host_no,
-			MSB(rptid_entry->vp_count), LSB(rptid_entry->vp_count)));
+			MSB(le16_to_cpu(rptid_entry->vp_count)),
+			LSB(le16_to_cpu(rptid_entry->vp_count))));
 		DEBUG15(printk("%s primary port id %02x%02x%02x\n", __func__,
 			rptid_entry->port_id[2], rptid_entry->port_id[1],
 			rptid_entry->port_id[0]));
-- 
1.6.2.rc1.30.gd43c

