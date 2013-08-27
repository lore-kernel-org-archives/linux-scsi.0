From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 06/29] qla2xxx: Perform warm reset every 2 minutes if firmware load fails for ISPFX00.
Date: Tue, 27 Aug 2013 01:37:32 -0400
Message-ID: <1377581875-8574-7-git-send-email-saurav.kashyap@qlogic.com>
References: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:51754 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002Ab3H0GGg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Aug 2013 02:06:36 -0400
Received: from pps.filterd (m0000643.ppops.net [127.0.0.1])
	by mx0b-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id r7R63vVm012060
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:36 -0700
Received: from avcashub1.qlogic.com (avcashub2.qlogic.com [198.70.193.116])
	by mx0b-0016ce01.pphosted.com with ESMTP id 1e5gq13pa4-7
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:35 -0700
In-Reply-To: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Armen Baloyan <armen.baloyan@qlogic.com>

Signed-off-by: Armen Baloyan <armen.baloyan@qlogic.com>
Acked-by: Srinivasa Rao <srinivasa.rao@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mr.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 7136bf5..1aeb9e1 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1606,6 +1606,14 @@ qlafx00_abort_isp(scsi_qla_host_t *vha)
 
 		scsi_block_requests(vha->host);
 		qlafx00_abort_isp_cleanup(vha);
+	} else {
+		scsi_block_requests(vha->host);
+		clear_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+		vha->qla_stats.total_isp_aborts++;
+		ha->isp_ops->reset_chip(vha);
+		set_bit(FX00_RESET_RECOVERY, &vha->dpc_flags);
+		/* Clear the Interrupts */
+		QLAFX00_CLR_INTR_REG(ha, QLAFX00_HST_INT_STS_BITS);
 	}
 
 	ql_log(ql_log_info, vha, 0x0145,
-- 
1.7.7

