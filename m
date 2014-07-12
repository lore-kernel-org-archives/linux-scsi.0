From: michaelc@cs.wisc.edu
Subject: [PATCH 2/4] qla4xxx: fix get_host_stats error propagation
Date: Sat, 12 Jul 2014 15:51:49 -0500
Message-ID: <1405198311-64449-3-git-send-email-michaelc@cs.wisc.edu>
References: <1405198311-64449-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40869 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbaGLUwF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Jul 2014 16:52:05 -0400
Received: from localhost.localdomain (c-24-245-27-162.hsd1.mn.comcast.net [24.245.27.162])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id s6CKpvxJ007638
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 12 Jul 2014 15:52:04 -0500
In-Reply-To: <1405198311-64449-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

qla4xxx was not always returning -EXYZ error codes when
qla4xxx_get_host_stats failed.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Acked-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

---
 drivers/scsi/qla4xxx/ql4_os.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index c5d9564..b79b48c 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1050,6 +1050,7 @@ static int qla4xxx_get_host_stats(struct Scsi_Host *shost, char *buf, int len)
 	if (!ql_iscsi_stats) {
 		ql4_printk(KERN_ERR, ha,
 			   "Unable to allocate memory for iscsi stats\n");
+		ret = -ENOMEM;
 		goto exit_host_stats;
 	}
 
@@ -1058,6 +1059,7 @@ static int qla4xxx_get_host_stats(struct Scsi_Host *shost, char *buf, int len)
 	if (ret != QLA_SUCCESS) {
 		ql4_printk(KERN_ERR, ha,
 			   "Unable to retrieve iscsi stats\n");
+		ret = -EIO;
 		goto exit_host_stats;
 	}
 	host_stats->mactx_frames = le64_to_cpu(ql_iscsi_stats->mac_tx_frames);
-- 
1.7.1

