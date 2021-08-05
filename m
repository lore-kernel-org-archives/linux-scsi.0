Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C7C2C4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 10:24:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 675CF610A2
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 10:24:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240238AbhHEKZL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 06:25:11 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39104 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239963AbhHEKZK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 06:25:10 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 175AC5fK010038
        for <linux-scsi@vger.kernel.org>; Thu, 5 Aug 2021 03:24:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=eGPrUtfiK+0IFjEz+CLrOplnKzsrsa5/e2IkZ2lajUk=;
 b=NbFsWDMWQr6pyVK89T6c+JiELcj+3/cMRbgIDrP3Vpeyg1y9puyS6dh870tzZNBbfuFd
 IWMX3DCJ8MVmn69lqvFr9vGDbsxqhKV5aX3LxybS9JFGU/DKheodfCLhsCjRsm7UQp9s
 p69p7kKqiCvskvVv6aa0Q+isy9AeE392pSxwbSY1+xtJpTu7bKSMQaJQNCTR6NE9Ux8v
 GRIJoBWPqagTMivcopidxvEUnOJBcGt/XlqFA7T4yTBgqm8lYmiUYnD/iLK/DTT+2Mf4
 mksDb8f2EIkRc/wkU22ALdhRWMNhNpSLZwtT3YPKPPK92W9Ppsm5qpT7xmNwa//hVOgh aw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3a8bkb8e01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 03:24:56 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 5 Aug
 2021 03:24:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 5 Aug 2021 03:24:55 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 93FBF3F705D;
        Thu,  5 Aug 2021 03:24:55 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 175AOtVl020303;
        Thu, 5 Aug 2021 03:24:55 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 175AOtwJ020302;
        Thu, 5 Aug 2021 03:24:55 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 11/14] qla2xxx: Changes to support kdump kernel
Date:   Thu, 5 Aug 2021 03:20:02 -0700
Message-ID: <20210805102005.20183-12-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210805102005.20183-1-njavali@marvell.com>
References: <20210805102005.20183-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: pvRpp0rzc-mxekakXPhuNhxQTYIzkdh1
X-Proofpoint-ORIG-GUID: pvRpp0rzc-mxekakXPhuNhxQTYIzkdh1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-05_03:2021-08-05,2021-08-05 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

Don't allocate fw dump for kexec kernel.
Allocate single Q for kexec kernel.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index df42849e7ccc..d899f814c1ae 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -14,6 +14,7 @@
 #include <linux/slab.h>
 #include <linux/blk-mq-pci.h>
 #include <linux/refcount.h>
+#include <linux/crash_dump.h>
 
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
@@ -2839,6 +2840,11 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			return ret;
 	}
 
+	if (is_kdump_kernel()) {
+		ql2xmqsupport = 0;
+		ql2xallocfwdump = 0;
+	}
+
 	/* This may fail but that's ok */
 	pci_enable_pcie_error_reporting(pdev);
 
-- 
2.19.0.rc0

