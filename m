From: vikas.chaudhary@qlogic.com
Subject: [PATCH 01/13] qla4xxx: cleanup qla4xxx_initialize_ddb_list()
Date: Mon, 21 Mar 2011 03:34:24 -0700
Message-ID: <1300703676-27398-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:46170 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753099Ab1CUKtP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2011 06:49:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, ravi.anand@qlogic.com, lalit.chandivade@qlogic.com, vikas.chaudhary@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Remove process all aen code from qla4xxx_initialize_ddb_list()
as DPC activities should be done in DPC only.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_init.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 1629c48..22fc57e 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -1013,13 +1013,6 @@ static int qla4xxx_initialize_ddb_list(struct scsi_qla_host *ha)
 	if ((status = qla4xxx_build_ddb_list(ha)) == QLA_ERROR)
 		return status;
 
-	/*
-	 * Targets can come online after the inital discovery, so processing
-	 * the aens here will catch them.
-	 */
-	if (test_and_clear_bit(DPC_AEN, &ha->dpc_flags))
-		qla4xxx_process_aen(ha, PROCESS_ALL_AENS);
-
 	return status;
 }
 
-- 
1.7.3.2

