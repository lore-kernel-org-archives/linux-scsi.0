From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 08/10] qla4xxx: Initialize hardware queue for ISP40XX
Date: Mon, 24 Feb 2014 22:07:03 -0500
Message-ID: <1393297625-928-9-git-send-email-vikas.chaudhary@qlogic.com>
References: <1393297625-928-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:47505 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752210AbaBYDnx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Feb 2014 22:43:53 -0500
In-Reply-To: <1393297625-928-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Issue:
System crash while target discovery for ISP40XX

Root cause:
Function qla4xxx_init_rings() is not called for ISP40XX

Fix:
Call function qla4xxx_init_rings() for ISP40XX from
qla4xxx_start_firmware().

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 7dda1a0..6f12f85 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -890,6 +890,8 @@ int qla4xxx_start_firmware(struct scsi_qla_host *ha)
 	if (status == QLA_SUCCESS) {
 		if (test_and_clear_bit(AF_GET_CRASH_RECORD, &ha->flags))
 			qla4xxx_get_crash_record(ha);
+
+		qla4xxx_init_rings(ha);
 	} else {
 		DEBUG(printk("scsi%ld: %s: Firmware has NOT started\n",
 			     ha->host_no, __func__));
-- 
1.8.2.GIT

