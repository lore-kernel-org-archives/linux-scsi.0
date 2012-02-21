From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] qla2xxx: handle default case in
 qla2x00_request_firmware()
Date: Tue, 21 Feb 2012 10:29:40 +0300
Message-ID: <20120221072939.GB6896@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:27005 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab2BUH3v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Feb 2012 02:29:51 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-driver@qlogic.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

This silences a static checker warning.  Also we're always adding new
types of firmware, so it might fix a bug in real life some day.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 094af74..a2f9992 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4058,7 +4058,6 @@ qla2x00_request_firmware(scsi_qla_host_t *vha)
 	struct qla_hw_data *ha = vha->hw;
 	struct fw_blob *blob;
 
-	blob = NULL;
 	if (IS_QLA2100(ha)) {
 		blob = &qla_fw_blobs[FW_ISP21XX];
 	} else if (IS_QLA2200(ha)) {
@@ -4079,6 +4078,8 @@ qla2x00_request_firmware(scsi_qla_host_t *vha)
 		blob = &qla_fw_blobs[FW_ISP2031];
 	} else if (IS_QLA8031(ha)) {
 		blob = &qla_fw_blobs[FW_ISP8031];
+	} else {
+		return NULL;
 	}
 
 	mutex_lock(&qla_fw_lock);
