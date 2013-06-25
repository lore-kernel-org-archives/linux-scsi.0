From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 14/16] qla2xxx: Fix qla2xxx_check_risc_status().
Date: Tue, 25 Jun 2013 11:27:29 -0400
Message-ID: <1372174051-4211-15-git-send-email-saurav.kashyap@qlogic.com>
References: <1372174051-4211-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:27796 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752144Ab3FYPxw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jun 2013 11:53:52 -0400
Received: from mail204-tx2 (localhost [127.0.0.1])	by
 mail204-tx2-R.bigfish.com (Postfix) with ESMTP id C50911802F8	for
 <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2013 15:53:51 +0000 (UTC)
Received: from TX2EHSMHS009.bigfish.com (unknown [10.9.14.248])	by
 mail204-tx2.bigfish.com (Postfix) with ESMTP id 58546740059	for
 <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2013 15:53:50 +0000 (UTC)
In-Reply-To: <1372174051-4211-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

Change the 'rval' variable from QLA_FUNCTION_TIMEOUT into QLA_SUCCESS
before starting a loop that is only executed if rval is initialized
to QLA_SUCCESS. Coverity reported that loop as "dead code".

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index d2a4c75..2d8e7b8 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2485,6 +2485,7 @@ qla2xxx_check_risc_status(scsi_qla_host_t *vha)
 	if (rval == QLA_SUCCESS)
 		goto next_test;
 
+	rval = QLA_SUCCESS;
 	WRT_REG_DWORD(&reg->iobase_window, 0x0003);
 	for (cnt = 100; (RD_REG_DWORD(&reg->iobase_window) & BIT_0) == 0 &&
 	    rval == QLA_SUCCESS; cnt--) {
-- 
1.7.7


