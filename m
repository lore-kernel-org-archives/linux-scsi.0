From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 2/3] qdio: base support for hardware data router with zfcp
Date: Mon, 15 Aug 2011 14:40:31 +0200
Message-ID: <20110815124058.793878315@linux.vnet.ibm.com>
References: <20110815124029.627237499@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:37208 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab1HOMlV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Aug 2011 08:41:21 -0400
Content-Disposition: inline; filename=3.2/701-qdio-data-router.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

FICON Express8S supports hardware data router, which requires an
adapted qdio request format.
This part 1/2 provides the qdio base required for exploitation in
zfcp.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
---

 arch/s390/include/asm/qdio.h  |    5 +++++
 drivers/s390/cio/qdio_main.c  |   11 ++++++++---
 drivers/s390/cio/qdio_setup.c |    1 +
 3 files changed, 14 insertions(+), 3 deletions(-)

--- a/arch/s390/include/asm/qdio.h
+++ b/arch/s390/include/asm/qdio.h
@@ -46,6 +46,8 @@ struct qdesfmt0 {
 	u32	 : 16;
 } __attribute__ ((packed));
 
+#define QDR_AC_MULTI_BUFFER_ENABLE 0x01
+
 /**
  * struct qdr - queue description record (QDR)
  * @qfmt: queue format
@@ -222,6 +224,8 @@ struct slsb {
 	u8 val[QDIO_MAX_BUFFERS_PER_Q];
 } __attribute__ ((packed, aligned(256)));
 
+#define CHSC_AC2_MULTI_BUFFER_AVAILABLE	0x0080
+#define CHSC_AC2_MULTI_BUFFER_ENABLED	0x0040
 #define CHSC_AC2_DATA_DIV_AVAILABLE	0x0010
 #define CHSC_AC2_DATA_DIV_ENABLED	0x0002
 
@@ -287,6 +291,7 @@ typedef void qdio_handler_t(struct ccw_d
 struct qdio_initialize {
 	struct ccw_device *cdev;
 	unsigned char q_format;
+	unsigned char qdr_ac;
 	unsigned char adapter_name[8];
 	unsigned int qib_param_field_format;
 	unsigned char *qib_param_field;
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -156,7 +156,8 @@ again:
 		DBF_ERROR("%3d%3d%2d", count, tmp_count, nr);
 		q->handler(q->irq_ptr->cdev,
 			   QDIO_ERROR_ACTIVATE_CHECK_CONDITION,
-			   0, -1, -1, q->irq_ptr->int_parm);
+			   q->nr, q->first_to_kick, count,
+			   q->irq_ptr->int_parm);
 		return 0;
 	}
 	return count - tmp_count;
@@ -202,7 +203,8 @@ again:
 		DBF_ERROR("%3d%3d%2d", count, tmp_count, nr);
 		q->handler(q->irq_ptr->cdev,
 			   QDIO_ERROR_ACTIVATE_CHECK_CONDITION,
-			   0, -1, -1, q->irq_ptr->int_parm);
+			   q->nr, q->first_to_kick, count,
+			   q->irq_ptr->int_parm);
 		return 0;
 	}
 	WARN_ON(tmp_count);
@@ -927,6 +929,7 @@ static void qdio_handle_activate_check(s
 {
 	struct qdio_irq *irq_ptr = cdev->private->qdio_data;
 	struct qdio_q *q;
+	int count;
 
 	DBF_ERROR("%4x ACT CHECK", irq_ptr->schid.sch_no);
 	DBF_ERROR("intp :%lx", intparm);
@@ -940,8 +943,10 @@ static void qdio_handle_activate_check(s
 		dump_stack();
 		goto no_handler;
 	}
+
+	count = sub_buf(q->first_to_check, q->first_to_kick);
 	q->handler(q->irq_ptr->cdev, QDIO_ERROR_ACTIVATE_CHECK_CONDITION,
-		   0, -1, -1, irq_ptr->int_parm);
+		   q->nr, q->first_to_kick, count, irq_ptr->int_parm);
 no_handler:
 	qdio_set_state(irq_ptr, QDIO_IRQ_STATE_STOPPED);
 }
--- a/drivers/s390/cio/qdio_setup.c
+++ b/drivers/s390/cio/qdio_setup.c
@@ -345,6 +345,7 @@ static void setup_qdr(struct qdio_irq *i
 	int i;
 
 	irq_ptr->qdr->qfmt = qdio_init->q_format;
+	irq_ptr->qdr->ac = qdio_init->qdr_ac;
 	irq_ptr->qdr->iqdcnt = qdio_init->no_input_qs;
 	irq_ptr->qdr->oqdcnt = qdio_init->no_output_qs;
 	irq_ptr->qdr->iqdsz = sizeof(struct qdesfmt0) / 4; /* size in words */

