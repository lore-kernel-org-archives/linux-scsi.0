From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 16/22] qla2xxx: Use the correct mailbox registers when acknowledging an IDC request on ISP8044.
Date: Wed, 30 Oct 2013 03:38:23 -0400
Message-ID: <1383118709-5569-17-git-send-email-saurav.kashyap@qlogic.com>
References: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:24496 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752608Ab3J3IJx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Oct 2013 04:09:53 -0400
In-Reply-To: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 0b1b297..8e420e2 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -298,11 +298,18 @@ qla81xx_idc_event(scsi_qla_host_t *vha, uint16_t aen, uint16_t descr)
 		{ "Complete", "Request Notification", "Time Extension" };
 	int rval;
 	struct device_reg_24xx __iomem *reg24 = &vha->hw->iobase->isp24;
+	struct device_reg_82xx __iomem *reg82 = &vha->hw->iobase->isp82;
 	uint16_t __iomem *wptr;
 	uint16_t cnt, timeout, mb[QLA_IDC_ACK_REGS];
 
 	/* Seed data -- mailbox1 -> mailbox7. */
-	wptr = (uint16_t __iomem *)&reg24->mailbox1;
+	if (IS_QLA81XX(vha->hw) || IS_QLA83XX(vha->hw))
+		wptr = (uint16_t __iomem *)&reg24->mailbox1;
+	else if (IS_QLA8044(vha->hw))
+		wptr = (uint16_t __iomem *)&reg82->mailbox_out[1];
+	else
+		return;
+
 	for (cnt = 0; cnt < QLA_IDC_ACK_REGS; cnt++, wptr++)
 		mb[cnt] = RD_REG_WORD(wptr);
 
-- 
1.7.7

