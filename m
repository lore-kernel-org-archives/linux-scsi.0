Return-Path: <SRS0=mSyi=4B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F5B6C352A4
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 01:33:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 676AE2467E
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 01:33:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hRfMXw/0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729440AbgBMBdY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 20:33:24 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:47362 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729285AbgBMBdY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Feb 2020 20:33:24 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01D1XC8F194556;
        Thu, 13 Feb 2020 01:33:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=VT4Lyh2ndVCjx6xxCG0MI00Ck29fOkVdwoWItPESSas=;
 b=hRfMXw/0E7pBfu0hXiKnLUtY0HROnFnCzj9TGv4wvtEKopLKXD8YaFRuesD2RXMyAnd6
 ogv4jwbMYS5OuXKFPonF9ROQQGBvLJlcAaRBvzuHtvhhd+8a6YftYLEBSgirDmjK0Ubn
 YhoCz/2vqoWcJgnNcdfW8jq2CtC3u5glG8zA6yKW/Fh/pt5jCHReZxvH+w3hDA8wJms3
 UxvIUjINzn0zb3ekI6kVyzjjxYP4vVOHUlyupbWY+oXqMaIZUFuOx5wNOGkeX6H2rLtN
 24oF+z94dkNgkzHjwCFDDstRlf7IRCV+rXVTeXqdbbe4PJF7Xoyz+YkB9UdBfhkfDl43 EA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2y2p3spdma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 13 Feb 2020 01:33:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01D1W4CT071776;
        Thu, 13 Feb 2020 01:33:21 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2y4k7xrjtn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Feb 2020 01:33:21 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01D1XLHU009082;
        Thu, 13 Feb 2020 01:33:21 GMT
Received: from viboo.us.oracle.com (/10.132.94.91)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Feb 2020 17:33:20 -0800
From:   Rajan Shanmugavelu <rajan.shanmugavelu@oracle.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        hmadhani@marvell.com, rjones@marvell.com
Cc:     rajan.shanmugavelu@oracle.com
Subject: [PATCH] qla2xxx: add ring buffer for tracing debug logs.
Date:   Wed, 12 Feb 2020 17:29:28 -0800
Message-Id: <1581557368-32080-1-git-send-email-rajan.shanmugavelu@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9529 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002130011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9529 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1011
 impostorscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002130011
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

    Having this log in a ringbuffer helps to diagnose qla2xxx driver and
    firmware issues instead of having it run again with extended_logging
    enabled saving cycles and hard to reproduce problem.

Signed-off-by: Rajan Shanmugavelu <rajan.shanmugavelu@oracle.com>
Signed-off-by: Joe Jin <joe.jin@oracle.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c | 23 ++++++++++++++++++++---
 include/trace/events/qla.h     | 39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+), 3 deletions(-)
 create mode 100644 include/trace/events/qla.h

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 30afc59..cf7f925 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -73,6 +73,8 @@
 #include "qla_def.h"
 
 #include <linux/delay.h>
+#define CREATE_TRACE_POINTS
+#include <trace/events/qla.h>
 
 static uint32_t ql_dbg_offset = 0x800;
 
@@ -2543,15 +2545,30 @@
 {
 	va_list va;
 	struct va_format vaf;
-
-	if (!ql_mask_match(level))
-		return;
+	char pbuf[64];
 
 	va_start(va, fmt);
 
 	vaf.fmt = fmt;
 	vaf.va = &va;
 
+	if (!ql_mask_match(level)) {
+		if (vha != NULL) {
+			const struct pci_dev *pdev = vha->hw->pdev;
+			/* <module-name> <msg-id>:<host> Message */
+			snprintf(pbuf, sizeof(pbuf), "%s [%s]-%04x:%ld: ",
+			    QL_MSGHDR, dev_name(&(pdev->dev)), id,
+			    vha->host_no);
+		} else {
+			snprintf(pbuf, sizeof(pbuf), "%s [%s]-%04x: : ",
+			    QL_MSGHDR, "0000:00:00.0", id);
+		}
+		pbuf[sizeof(pbuf) - 1] = 0;
+		trace_ql_dbg_log(pbuf, &vaf);
+		va_end(va);
+		return;
+	}
+
 	if (vha != NULL) {
 		const struct pci_dev *pdev = vha->hw->pdev;
 		/* <module-name> <pci-name> <msg-id>:<host> Message */
diff --git a/include/trace/events/qla.h b/include/trace/events/qla.h
new file mode 100644
index 00000000..b71f680
--- /dev/null
+++ b/include/trace/events/qla.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#if !defined(_TRACE_QLA_H_) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_QLA_H_
+
+#include <linux/tracepoint.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM qla
+
+#define QLA_MSG_MAX 256
+
+DECLARE_EVENT_CLASS(qla_log_event,
+	TP_PROTO(const char *buf,
+		struct va_format *vaf),
+
+	TP_ARGS(buf, vaf),
+
+	TP_STRUCT__entry(
+		__string(buf, buf)
+		__dynamic_array(char, msg, QLA_MSG_MAX)
+	),
+	TP_fast_assign(
+		__assign_str(buf, buf);
+		vsnprintf(__get_str(msg), QLA_MSG_MAX, vaf->fmt, *vaf->va);
+	),
+
+	TP_printk("%s %s", __get_str(buf), __get_str(msg))
+);
+
+DEFINE_EVENT(qla_log_event, ql_dbg_log,
+	TP_PROTO(const char *buf, struct va_format *vaf),
+	TP_ARGS(buf, vaf)
+);
+
+#endif /* _TRACE_QLA_H */
+
+#define TRACE_INCLUDE_FILE qla
+
+#include <trace/define_trace.h>
-- 
1.8.3.1

