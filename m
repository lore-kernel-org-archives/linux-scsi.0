Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 275A1C33CB3
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 17:52:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC1EE2469C
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 17:52:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S5utsg87"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404792AbgAPRwr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 12:52:47 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44320 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406142AbgAPRpP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2020 12:45:15 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00GHhjD9015177;
        Thu, 16 Jan 2020 17:45:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=g8JweAN4UuIU4RsGapSvTfes1SvP5NI0odYNg/+NuFA=;
 b=S5utsg87IzuVPXQ1mMJHduQf6RGdO0agkJSUA9VV89pQLzGkFrI5d984g+BZfe0WAXHI
 Bk7wfytlFGo1AFM0+295FKiPg9kDMPv4PRTQiWq4I2VhKZmkhrEHEtp0cnp0XQUddzuH
 L2Fmtizgk/4ni/a1Hef7yBLGr0+oBolMbV3G0abnFdMggQu+cDQEEzwp8uaoQfv9JwL1
 N8KKMU+eRB4iMFyIqK9uczD922UHZFHaxcYwBaqvLsZUiXk074nw0JugKpaX4ZsZ+Kd0
 WSmeluMvd/PbKls8yUSjwjUCNs/4rhtnhUVUKqhKj27a1ekV/fQBetoG23b1JSMt3T6H mg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2xf73yv2x7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 17:45:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00GHiF0Y047004;
        Thu, 16 Jan 2020 17:45:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2xj61mygbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 17:45:11 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00GHjBeX028205;
        Thu, 16 Jan 2020 17:45:11 GMT
Received: from viboo.us.oracle.com (/10.132.94.91)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jan 2020 09:45:11 -0800
From:   Rajan Shanmugavelu <rajan.shanmugavelu@oracle.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        srinivas.eeda@oracle.com, joe.jin@oracle.com,
        dick.kennedy@broadcom.com, laurie.barry@broadcom.com,
        james.smart@broadcom.com
Subject: [PATCH] lpfc: Gather lpfc debug logs using tracefs ringbuffer
Date:   Thu, 16 Jan 2020 09:44:25 -0800
Message-Id: <1579196665-13504-2-git-send-email-rajan.shanmugavelu@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1579196665-13504-1-git-send-email-rajan.shanmugavelu@oracle.com>
References: <1579196665-13504-1-git-send-email-rajan.shanmugavelu@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160143
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Having this log in a ringbuffer helps to diagnose lpfc driver and
firmware issues instead of having it run again with lpfc_verbose_log
enabled saving cycles and hard to reproduce problem.

Signed-off-by: Rajan Shanmugavelu <rajan.shanmugavelu@oracle.com>
Signed-off-by: Joe Jin <joe.jin@oracle.com>
---
 drivers/scsi/lpfc/lpfc_logmsg.h | 44 ++++++++++++++++++++++++++++-------------
 drivers/scsi/lpfc/lpfc_scsi.c   | 20 +++++++++++++++++++
 include/trace/events/lpfc.h     | 41 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 91 insertions(+), 14 deletions(-)
 create mode 100644 include/trace/events/lpfc.h

diff --git a/drivers/scsi/lpfc/lpfc_logmsg.h b/drivers/scsi/lpfc/lpfc_logmsg.h
index ea10f03..676ebe4 100644
--- a/drivers/scsi/lpfc/lpfc_logmsg.h
+++ b/drivers/scsi/lpfc/lpfc_logmsg.h
@@ -46,20 +46,36 @@
 #define LOG_NVME_IOERR  0x00800000      /* NVME IO Error events. */
 #define LOG_ALL_MSG	0xffffffff	/* LOG all messages */
 
-#define lpfc_printf_vlog(vport, level, mask, fmt, arg...) \
-do { \
-	{ if (((mask) & (vport)->cfg_log_verbose) || (level[1] <= '3')) \
-		dev_printk(level, &((vport)->phba->pcidev)->dev, "%d:(%d):" \
-			   fmt, (vport)->phba->brd_no, vport->vpi, ##arg); } \
+void lpfc_log_ringbuf(struct device *dev, const char *fmt, ...);
+
+#define lpfc_printf_vlog(vport, level, mask, fmt, arg...)		\
+do {									\
+	{								\
+	if (((mask) & (vport)->cfg_log_verbose) || (level[1] <= '3')) { \
+		dev_printk(level, &((vport)->phba->pcidev)->dev,	\
+			"%d:(%d):" fmt, (vport)->phba->brd_no,		\
+			vport->vpi, ##arg);				\
+	} else {							\
+		lpfc_log_ringbuf(&((vport)->phba->pcidev)->dev,		\
+			"%d:(%d):" fmt, (vport)->phba->brd_no,		\
+			vport->vpi, ##arg);				\
+	}								\
+	}								\
 } while (0)
 
-#define lpfc_printf_log(phba, level, mask, fmt, arg...) \
-do { \
-	{ uint32_t log_verbose = (phba)->pport ? \
-				 (phba)->pport->cfg_log_verbose : \
-				 (phba)->cfg_log_verbose; \
-	  if (((mask) & log_verbose) || (level[1] <= '3')) \
-		dev_printk(level, &((phba)->pcidev)->dev, "%d:" \
-			   fmt, phba->brd_no, ##arg); \
-	} \
+#define lpfc_printf_log(phba, level, mask, fmt, arg...)			\
+do {									\
+	{								\
+	uint32_t log_verbose = (phba)->pport ?				\
+		(phba)->pport->cfg_log_verbose :			\
+		(phba)->cfg_log_verbose;				\
+	if (((mask) & log_verbose) || (level[1] <= '3')) {		\
+		dev_printk(level, &((phba)->pcidev)->dev, "%d:"		\
+			fmt, phba->brd_no, ##arg);			\
+	} else {							\
+		lpfc_log_ringbuf(&((phba)->pcidev)->dev, "%d:"		\
+			fmt, phba->brd_no, ##arg);			\
+	}								\
+	}								\
 } while (0)
+
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 6ba4a74..d8256e6 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -37,6 +37,7 @@
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_transport_fc.h>
 
+
 #include "lpfc_version.h"
 #include "lpfc_hw4.h"
 #include "lpfc_hw.h"
@@ -52,6 +53,8 @@
 
 #define LPFC_RESET_WAIT  2
 #define LPFC_ABORT_WAIT  2
+#define CREATE_TRACE_POINTS
+#include <trace/events/lpfc.h>
 
 int _dump_buf_done = 1;
 
@@ -5927,3 +5930,20 @@ struct scsi_host_template lpfc_vport_template = {
 	.change_queue_depth	= scsi_change_queue_depth,
 	.track_queue_depth	= 1,
 };
+
+
+/*
+ * Helper function declaration.
+ */
+void lpfc_log_ringbuf(struct device *dev, const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	trace_lpfc_dbg_log(dev, &vaf);
+	va_end(args);
+}
diff --git a/include/trace/events/lpfc.h b/include/trace/events/lpfc.h
new file mode 100644
index 00000000..4cba505
--- /dev/null
+++ b/include/trace/events/lpfc.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM lpfc
+
+#if !defined(_TRACE_LPFC_H_) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_LPFC_H_
+
+#include <linux/tracepoint.h>
+
+/* Max debug message length */
+#define LPFC_MSG_MAX 256
+
+DECLARE_EVENT_CLASS(lpfc_log_event,
+	TP_PROTO(struct device *dev, struct va_format *vaf),
+
+	TP_ARGS(dev, vaf),
+
+	TP_STRUCT__entry(
+		__string(dname, dev_name(dev))
+		__dynamic_array(char, msg, LPFC_MSG_MAX)
+	),
+
+	TP_fast_assign(
+		__assign_str(dname, dev_name(dev));
+		vsnprintf(__get_str(msg), LPFC_MSG_MAX,
+			vaf->fmt, *vaf->va);
+	),
+
+	TP_printk("%s: %s", __get_str(dname), __get_str(msg))
+);
+
+DEFINE_EVENT(lpfc_log_event, lpfc_dbg_log,
+	TP_PROTO(struct device *dev, struct va_format *vaf),
+	TP_ARGS(dev, vaf)
+);
+
+#endif /* _TRACE_LPFC_H */
+
+#define TRACE_INCLUDE_FILE lpfc
+
+#include <trace/define_trace.h>
-- 
1.8.3.1

