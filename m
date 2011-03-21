From: vikas.chaudhary@qlogic.com
Subject: [PATCH 08/13] qla4xxx: Add support for ql4xmaxqdepth command line parameter
Date: Mon, 21 Mar 2011 03:34:31 -0700
Message-ID: <1300703676-27398-8-git-send-email-vikas.chaudhary@qlogic.com>
References: <1300703676-27398-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:50837 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1752359Ab1CULBP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2011 07:01:15 -0400
In-Reply-To: <1300703676-27398-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, ravi.anand@qlogic.com, lalit.chandivade@qlogic.com, vikas.chaudhary@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

This provides the flexibility to modify the qdepth based on different
target devices to make the best use of system resources.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 277c45f..051c049 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -51,6 +51,11 @@ MODULE_PARM_DESC(ql4xenablemsix,
 		" 2 = enable MSI interrupt mechanism.");
 
 #define QL4_DEF_QDEPTH 32
+static int ql4xmaxqdepth = QL4_DEF_QDEPTH;
+module_param(ql4xmaxqdepth, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(ql4xmaxqdepth,
+		"Maximum queue depth to report for target devices.\n"
+		" Default: 32.");
 
 /*
  * SCSI host template entry points
@@ -1904,10 +1909,15 @@ static int qla4xxx_slave_alloc(struct scsi_device *sdev)
 {
 	struct iscsi_cls_session *sess = starget_to_session(sdev->sdev_target);
 	struct ddb_entry *ddb = sess->dd_data;
+	int queue_depth = QL4_DEF_QDEPTH;
 
 	sdev->hostdata = ddb;
 	sdev->tagged_supported = 1;
-	scsi_activate_tcq(sdev, QL4_DEF_QDEPTH);
+
+	if (ql4xmaxqdepth != 0 && ql4xmaxqdepth <= 0xffffU)
+		queue_depth = ql4xmaxqdepth;
+
+	scsi_activate_tcq(sdev, queue_depth);
 	return 0;
 }
 
-- 
1.7.3.2

