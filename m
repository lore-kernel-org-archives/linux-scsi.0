From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/2] ipr: Don't log unnecessary 9084 error details
Date: Fri, 16 Sep 2016 16:51:36 -0500
Message-ID: <20160916215136.9E5F8124047@b01ledav002.gho.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41162 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755311AbcIPVvm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Sep 2016 17:51:42 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8GLlrNK040085
        for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2016 17:51:42 -0400
Received: from e19.ny.us.ibm.com (e19.ny.us.ibm.com [129.33.205.209])
        by mx0a-001b2d01.pphosted.com with ESMTP id 25gq68uug7-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2016 17:51:41 -0400
Received: from localhost
        by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
        Fri, 16 Sep 2016 17:51:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, krisman@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


A 9084 error gets logged by the ipr adapter when adapter raw mode
gets enabled. A bunch of unformatted hex data also gets logged
for this error, which is of little use, so let's avoid logging
it by default in order to avoid the log getting polluted with
useless data.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |    6 +++---
 drivers/scsi/ipr.h |    1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_9084 drivers/scsi/ipr.c
--- linux-2.6.git/drivers/scsi/ipr.c~ipr_9084	2016-09-06 21:01:10.423275926 -0500
+++ linux-2.6.git-bjking1/drivers/scsi/ipr.c	2016-09-09 16:03:44.639230433 -0500
@@ -493,15 +493,15 @@ struct ipr_error_table_t ipr_error_table
 	"9072: Link not operational transition"},
 	{0x066B8200, 0, IPR_DEFAULT_LOG_LEVEL,
 	"9032: Array exposed but still protected"},
-	{0x066B8300, 0, IPR_DEFAULT_LOG_LEVEL + 1,
+	{0x066B8300, 0, IPR_DEBUG_LOG_LEVEL,
 	"70DD: Device forced failed by disrupt device command"},
 	{0x066B9100, 0, IPR_DEFAULT_LOG_LEVEL,
 	"4061: Multipath redundancy level got better"},
 	{0x066B9200, 0, IPR_DEFAULT_LOG_LEVEL,
 	"4060: Multipath redundancy level got worse"},
-	{0x06808100, 0, IPR_DEFAULT_LOG_LEVEL,
+	{0x06808100, 0, IPR_DEBUG_LOG_LEVEL,
 	"9083: Device raw mode enabled"},
-	{0x06808200, 0, IPR_DEFAULT_LOG_LEVEL,
+	{0x06808200, 0, IPR_DEBUG_LOG_LEVEL,
 	"9084: Device raw mode disabled"},
 	{0x07270000, 0, 0,
 	"Failure due to other device"},
diff -puN drivers/scsi/ipr.h~ipr_9084 drivers/scsi/ipr.h
--- linux-2.6.git/drivers/scsi/ipr.h~ipr_9084	2016-09-09 16:01:52.072645477 -0500
+++ linux-2.6.git-bjking1/drivers/scsi/ipr.h	2016-09-09 16:02:27.685197801 -0500
@@ -1506,6 +1506,7 @@ struct ipr_ioa_cfg {
 	u8 log_level;
 #define IPR_MAX_LOG_LEVEL			4
 #define IPR_DEFAULT_LOG_LEVEL		2
+#define IPR_DEBUG_LOG_LEVEL		3
 
 #define IPR_NUM_TRACE_INDEX_BITS	8
 #define IPR_NUM_TRACE_ENTRIES		(1 << IPR_NUM_TRACE_INDEX_BITS)
_

