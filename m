From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/3] qla2xxx: Properly re-enable EFT support after an ISP abort.
Date: Wed, 23 Aug 2006 14:54:55 -0700
Message-ID: <11563700961130-git-send-email-andrew.vasquez@qlogic.com>
References: <20060823215248.GG4069@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:45555 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S965231AbWHWVzA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Aug 2006 17:55:00 -0400
In-Reply-To: <20060823215248.GG4069@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Software must explicitely re-enable extended firmware tracing
after any ISP abort condition.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 9758dba..8596491 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3063,6 +3063,7 @@ qla2x00_update_fcports(scsi_qla_host_t *
 int
 qla2x00_abort_isp(scsi_qla_host_t *ha)
 {
+	int rval;
 	unsigned long flags = 0;
 	uint16_t       cnt;
 	srb_t          *sp;
@@ -3119,6 +3120,16 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 
 			ha->isp_abort_cnt = 0;
 			clear_bit(ISP_ABORT_RETRY, &ha->dpc_flags);
+
+			if (ha->eft) {
+				rval = qla2x00_trace_control(ha, TC_ENABLE,
+				    ha->eft_dma, EFT_NUM_BUFFERS);
+				if (rval) {
+					qla_printk(KERN_WARNING, ha,
+					    "Unable to reinitialize EFT "
+					    "(%d).\n", rval);
+				}
+			}
 		} else {	/* failed the ISP abort */
 			ha->flags.online = 1;
 			if (test_bit(ISP_ABORT_RETRY, &ha->dpc_flags)) {
-- 
1.4.2.g44c10

