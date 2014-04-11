From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 20/42] qla2xxx: Decrease pci access for response queue processing for ISPFX00.
Date: Fri, 11 Apr 2014 16:54:25 -0400
Message-ID: <1397249687-32666-21-git-send-email-saurav.kashyap@qlogic.com>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:2941 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754438AbaDKVcd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 17:32:33 -0400
In-Reply-To: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Armen Baloyan <armen.baloyan@qlogic.com>

Signed-off-by: Armen Baloyan <armen.baloyan@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 1801e5f..eb9be2e 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -2676,7 +2676,7 @@ qlafx00_process_response_queue(struct scsi_qla_host *vha,
 	uint16_t lreq_q_out = 0;
 
 	lreq_q_in = RD_REG_DWORD(rsp->rsp_q_in);
-	lreq_q_out = RD_REG_DWORD(rsp->rsp_q_out);
+	lreq_q_out = rsp->ring_index;
 
 	while (lreq_q_in != lreq_q_out) {
 		lptr = rsp->ring_ptr;
-- 
1.7.7

