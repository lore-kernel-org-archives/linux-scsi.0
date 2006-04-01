From: Doug Maxey <dwm@maxeymade.com>
Subject: Re: [CMT 03/16] qla4xxx: driver review ql4_dbg.h
Date: Sat, 01 Apr 2006 02:34:39 -0600
Message-ID: <200604010834.k318YdjK004650@falcon30.maxeymade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:57058 "EHLO
	falcon30.maxeymade.com") by vger.kernel.org with ESMTP
	id S1751479AbWDAIeu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Apr 2006 03:34:50 -0500
In-reply-to: 200604010418.k314Iqam008288@falcon30.maxeymade.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>


Lots of unused macros.

Comment at the end regarding use of void*.

++doug
--
diff --git a/drivers/scsi/qla4xxx/ql4_dbg.h b/drivers/scsi/qla4xxx/ql4_dbg.h
new file mode 100644
index 0000000..d9a8fa9
--- /dev/null
+++ b/drivers/scsi/qla4xxx/ql4_dbg.h
@@ -0,0 +1,64 @@
+/*
+ * QLogic iSCSI HBA Driver
+ * Copyright (c)  2003-2006 QLogic Corporation
+ *
+ * See LICENSE.qla4xxx for copyright and licensing details.
+ */
+
+/*
+ * Driver debug definitions.
+ */
+/* #define QL_DEBUG  */			/* DEBUG messages */
+/* #define QL_DEBUG_LEVEL_3  */		/* Output function tracing */
+/* #define QL_DEBUG_LEVEL_4  */
+/* #define QL_DEBUG_LEVEL_5  */
+/* #define QL_DEBUG_LEVEL_9  */
+
+#define QL_DEBUG_LEVEL_2	/* ALways enable error messagess */
+#if defined(QL_DEBUG)
+#define DEBUG(x)   do {x;} while (0);
+#else
+#define DEBUG(x)	do {} while (0);
+#endif
+
+#if defined(QL_DEBUG_LEVEL_2)
+#define DEBUG2(x)      do {if(extended_error_logging == 2) x;} while (0);
+#define DEBUG2_3(x)   do {x;} while (0);
+#else				/*  */
+#define DEBUG2(x)	do {} while (0);
+#endif				/*  */
+
+#if defined(QL_DEBUG_LEVEL_3)
+#define DEBUG3(x)      do {if(extended_error_logging == 3) x;} while (0);
+#else				/*  */
+#define DEBUG3(x)	do {} while (0);
+#if !defined(QL_DEBUG_LEVEL_2)
+#define DEBUG2_3(x)	do {} while (0);

-ENOTUSED

+#endif				/*  */
+#endif				/*  */
+#if defined(QL_DEBUG_LEVEL_4)
+#define DEBUG4(x)	do {x;} while (0);
+#else				/*  */
+#define DEBUG4(x)	do {} while (0);
+#endif				/*  */

-ENOTUSED

+
+#if defined(QL_DEBUG_LEVEL_5)
+#define DEBUG5(x)	do {x;} while (0);
+#else				/*  */
+#define DEBUG5(x)	do {} while (0);
+#endif				/*  */
+
+#if defined(QL_DEBUG_LEVEL_9)
+#define DEBUG9(x)	do {x;} while (0);
+#else				/*  */
+#define DEBUG9(x)	do {} while (0);
+#endif				/*  */

-ENOTUSED

+
+/*
+ *  Debug Print Routines.
+ */
+void qla4xxx_print_scsi_cmd(struct scsi_cmnd *cmd);
+void __dump_registers(scsi_qla_host_t * ha);
+void qla4xxx_dump_mbox_registers(scsi_qla_host_t * ha);
+void qla4xxx_dump_registers(scsi_qla_host_t * ha);
+void qla4xxx_dump_buffer(uint8_t * b, uint32_t size);

'b' could also be a void*.

