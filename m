From: vikas.chaudhary@qlogic.com
Subject: [PATCH 03/11] qla4xxx: Fix verify boot idx correctly
Date: Mon, 13 Feb 2012 18:30:42 +0530
Message-ID: <1329138050-1042-4-git-send-email-vikas.chaudhary@qlogic.com>
References: <1329138050-1042-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:4171
	"HELO magana.localdomain" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1756608Ab2BMNJy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Feb 2012 08:09:54 -0500
In-Reply-To: <1329138050-1042-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, ravi.anand@qlogic.com, lalit.chandivade@qlogic.com, vikas.chaudhary@qlogic.com

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

qla4xxx_verify_boot_idx can falsely report a DDB to be boot target
if ha->pri_ddb_idx and ha->sec_ddb_idx are not initialized correctly.
What this could cause is if there is DDB entry in FLash at index 0, then
qla4xxx_verify_boot_idx would return wrong result as ha->pri_ddb_idx is not
set correctly. Fixed the qla4xxx_get_boot_info to set the ha->pri_ddb_idx and
ha->sec_ddb_idx correctly.

Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 089443a..a9ff05e 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3463,12 +3463,11 @@ static int get_fw_boot_info(struct scsi_qla_host *ha, uint16_t ddb_index[])
 			  " target ID %d\n", __func__, ddb_index[0],
 			  ddb_index[1]));
 
-	ha->pri_ddb_idx = ddb_index[0];
-	ha->sec_ddb_idx = ddb_index[1];
-
 exit_boot_info_free:
 	dma_free_coherent(&ha->pdev->dev, size, buf, buf_dma);
 exit_boot_info:
+	ha->pri_ddb_idx = ddb_index[0];
+	ha->sec_ddb_idx = ddb_index[1];
 	return ret;
 }
 
-- 
1.7.8.247.g10f4e

