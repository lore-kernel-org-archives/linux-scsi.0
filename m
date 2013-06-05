From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 08/10] qla2xxx: Fix qla2xxx_check_risc_status()
Date: Wed, 05 Jun 2013 15:08:29 +0200
Message-ID: <51AF384D.2060209@acm.org>
References: <51AF36BF.3030602@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:34589 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab3FENIa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jun 2013 09:08:30 -0400
In-Reply-To: <51AF36BF.3030602@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>

Change the 'rval' variable from QLA_FUNCTION_TIMEOUT into QLA_SUCCESS
before starting a loop that is only executed if rval is initialized
to QLA_SUCCESS. Coverity reported that loop as "dead code".

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 259d920..bd0e2fa 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2495,6 +2495,7 @@ qla2xxx_check_risc_status(scsi_qla_host_t *vha)
 	if (rval == QLA_SUCCESS)
 		goto next_test;
 
+	rval = QLA_SUCCESS;
 	WRT_REG_DWORD(&reg->iobase_window, 0x0003);
 	for (cnt = 100; (RD_REG_DWORD(&reg->iobase_window) & BIT_0) == 0 &&
 	    rval == QLA_SUCCESS; cnt--) {
-- 
1.7.10.4

