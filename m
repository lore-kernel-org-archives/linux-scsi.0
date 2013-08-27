From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 17/29] qla2xxx: Send all AENs for ISPFx00 to above layers.
Date: Tue, 27 Aug 2013 01:37:43 -0400
Message-ID: <1377581875-8574-18-git-send-email-saurav.kashyap@qlogic.com>
References: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:51790 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752847Ab3H0GGp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Aug 2013 02:06:45 -0400
Received: from pps.filterd (m0000643.ppops.net [127.0.0.1])
	by mx0b-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id r7R64OiB012247
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:44 -0700
Received: from avcashub1.qlogic.com (avcashub1.qlogic.com [198.70.193.115])
	by mx0b-0016ce01.pphosted.com with ESMTP id 1e5gq13pa9-13
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:44 -0700
In-Reply-To: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Armen Baloyan <armen.baloyan@qlogic.com>

Signed-off-by: Armen Baloyan <armen.baloyan@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mr.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 85587de..ae1d00c6 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1734,6 +1734,10 @@ qlafx00_process_aen(struct scsi_qla_host *vha, struct qla_work_evt *evt)
 	aen_data = evt->u.aenfx.evtcode;
 
 	switch (evt->u.aenfx.evtcode) {
+	case QLAFX00_MBA_SHUTDOWN_RQSTD: /* FW shutdown pending */
+		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+		rval = qlafx00_driver_shutdown(vha, 10);
+		break;
 	case QLAFX00_MBA_PORT_UPDATE:		/* Port database update */
 		if (evt->u.aenfx.mbx[1] == 0) {
 			if (evt->u.aenfx.mbx[2] == 1) {
@@ -2920,8 +2924,6 @@ qlafx00_async_event(scsi_qla_host_t *vha)
 		    "Asynchronous critical temperature event received "
 		    "aenmb[0]: %x\n",
 		ha->aenmb[0]);
-		qlafx00_post_aenfx_work(vha, ha->aenmb[0],
-		    (uint32_t *)ha->aenmb, 1);
 		break;
 
 	default:
-- 
1.7.7

