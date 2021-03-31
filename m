Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5845FC43461
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 16:51:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3594D6103E
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 16:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbhCaQuj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 12:50:39 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:21308 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233842AbhCaQue (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Mar 2021 12:50:34 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12VGelXl017896
        for <linux-scsi@vger.kernel.org>; Wed, 31 Mar 2021 09:50:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=dYhFcHj8oa3BbPS8N/vHx3SI0gB6qUdzBW6gN7ZXVgM=;
 b=D2yfP0jJcagpSIqBDYkwYXZZzi+7aUGVvcPwAuTDr/18mgwlFnomIExxGRlaOTqPYfrS
 UGDHB5VeQZtd/21T8oTeM7ZRQfK7ksT2yQcRPjv8ygLRQDz2eFfGfy2l9CNLQA0gLNSv
 0Dm9qpVhAIDX41ziQeUxB3zlqczv19GCmb6YcGrhBglC/1i8Cyw7Y9Em48LKN3EZsE6c
 vfPTmiC6P9Dh8jETb1IksHZ0XTX/ECIpeb56dMqk1sCvDF78mWdC4jTFylKFF2Cio963
 R568DcpiQJrMS72mFsxHltdcPe3P9ivHr+8mYFojQGORynH55K0hJOz828W1zNvtr9jx 5Q== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 37ma9w378w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 31 Mar 2021 09:50:33 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 31 Mar
 2021 09:50:30 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 31 Mar 2021 09:50:30 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 26C123F7045;
        Wed, 31 Mar 2021 09:50:30 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 12VGoUfH024770;
        Wed, 31 Mar 2021 09:50:30 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 12VGoT2D024768;
        Wed, 31 Mar 2021 09:50:29 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 2/2] qedf: use devlink to report errors and recovery
Date:   Wed, 31 Mar 2021 09:49:17 -0700
Message-ID: <20210331164917.24662-3-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210331164917.24662-1-jhasan@marvell.com>
References: <20210331164917.24662-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: IC_IcZbb-xD-NxoqAaVtI-j1hFcV-s8x
X-Proofpoint-ORIG-GUID: IC_IcZbb-xD-NxoqAaVtI-j1hFcV-s8x
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-31_08:2021-03-31,2021-03-31 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use devlink_health_report to push error indications.
We implement this in qede via callback function to make it possible
to reuse the same for other drivers sitting on top of qed in future.
Also, remove forcible recovery trigger and put it as a normal devlink
callback in qed module.

This allows user to enable/disable it via

    devlink health set pci/xxxx:xx:xx.x reporter fw_fatal auto_recover false
---
 drivers/scsi/qedf/qedf_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 6b6c3fd97798..ad125b0ff1de 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3859,8 +3859,9 @@ void qedf_schedule_hw_err_handler(void *dev, enum qed_hw_err_type err_type)
 		/* Prevent HW attentions from being reasserted */
 		qed_ops->common->attn_clr_enable(qedf->cdev, true);
 
-		if (qedf_enable_recovery)
-			qed_ops->common->recovery_process(qedf->cdev);
+		if (qedf_enable_recovery && qedf->devlink)
+			qed_ops->common->report_fatal_error(qedf->devlink,
+				err_type);
 
 		break;
 	default:
-- 
2.18.2

