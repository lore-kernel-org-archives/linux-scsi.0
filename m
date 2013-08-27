From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 16/29] qla2xxx: Add changes in initialization for ISPFX00 cards with BIOS
Date: Tue, 27 Aug 2013 01:37:42 -0400
Message-ID: <1377581875-8574-17-git-send-email-saurav.kashyap@qlogic.com>
References: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:51801 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752777Ab3H0GGr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Aug 2013 02:06:47 -0400
Received: from pps.filterd (m0000643.ppops.net [127.0.0.1])
	by mx0b-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id r7R63vVu012060
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:47 -0700
Received: from avcashub1.qlogic.com (avcashub2.qlogic.com [198.70.193.116])
	by mx0b-0016ce01.pphosted.com with ESMTP id 1e5gq13pa4-15
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:47 -0700
In-Reply-To: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Armen Baloyan <armen.baloyan@qlogic.com>

Signed-off-by: Armen Baloyan <armen.baloyan@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    1 +
 drivers/scsi/qla2xxx/qla_mr.c  |   11 +++++++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 0aa1bea..d6eefb8 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -643,6 +643,7 @@ struct device_reg_fx00 {
 	uint32_t initval6;		/* C8 */
 	uint32_t initval7;		/* CC */
 	uint32_t fwheartbeat;		/* D0 */
+	uint32_t pseudoaen;		/* D4 */
 };
 
 
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index f4c5d74..85587de 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -941,12 +941,23 @@ qlafx00_init_fw_ready(scsi_qla_host_t *vha)
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_fx00 __iomem *reg = &ha->iobase->ispfx00;
 	uint32_t aenmbx, aenmbx7 = 0;
+	uint32_t pseudo_aen;
 	uint32_t state[5];
 	bool done = false;
 
 	/* 30 seconds wait - Adjust if required */
 	wait_time = 30;
 
+	pseudo_aen = RD_REG_DWORD(&reg->pseudoaen);
+	if (pseudo_aen == 1) {
+		aenmbx7 = RD_REG_DWORD(&reg->initval7);
+		ha->mbx_intr_code = MSW(aenmbx7);
+		ha->rqstq_intr_code = LSW(aenmbx7);
+		rval = qlafx00_driver_shutdown(vha, 10);
+		if (rval != QLA_SUCCESS)
+			qlafx00_soft_reset(vha);
+	}
+
 	/* wait time before firmware ready */
 	wtime = jiffies + (wait_time * HZ);
 	do {
-- 
1.7.7

