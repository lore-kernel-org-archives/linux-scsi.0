From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 03/29] qla2xxx: Fix incorrect test after list_for_each_entry() exits.
Date: Tue, 27 Aug 2013 01:37:29 -0400
Message-ID: <1377581875-8574-4-git-send-email-saurav.kashyap@qlogic.com>
References: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:51747 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752675Ab3H0GGe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Aug 2013 02:06:34 -0400
Received: from pps.filterd (m0000643.ppops.net [127.0.0.1])
	by mx0b-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id r7R63vVi012060
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:33 -0700
Received: from avcashub1.qlogic.com (avcashub2.qlogic.com [198.70.193.116])
	by mx0b-0016ce01.pphosted.com with ESMTP id 1e5gq13pa4-3
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:33 -0700
In-Reply-To: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

list_for_each_entry() never leaves the iterator pointing to null.

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index ffcad26..fb5bd6e 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1266,6 +1266,7 @@ qla24xx_iidma(struct fc_bsg_job *bsg_job)
 	int rval = 0;
 	struct qla_port_param *port_param = NULL;
 	fc_port_t *fcport = NULL;
+	int found = 0;
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
 	uint8_t *rsp_ptr = NULL;
 
@@ -1288,10 +1289,12 @@ qla24xx_iidma(struct fc_bsg_job *bsg_job)
 		if (memcmp(port_param->fc_scsi_addr.dest_addr.wwpn,
 			fcport->port_name, sizeof(fcport->port_name)))
 			continue;
+
+		found = 1;
 		break;
 	}
 
-	if (!fcport) {
+	if (!found) {
 		ql_log(ql_log_warn, vha, 0x7049,
 		    "Failed to find port.\n");
 		return -EINVAL;
-- 
1.7.7

