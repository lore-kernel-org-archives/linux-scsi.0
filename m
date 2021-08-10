Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA375C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 04:39:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1C7F60EBD
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 04:39:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234710AbhHJEj3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 00:39:29 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:6734 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235432AbhHJEj2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Aug 2021 00:39:28 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A4ag95008656
        for <linux-scsi@vger.kernel.org>; Mon, 9 Aug 2021 21:39:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=J75xVfpwR+KxD6gzW7a5xB94C7nOJToLZfph9JqYkBg=;
 b=DMlzoy2DPfOEh12rzfOnDrzL4hdddLk7MPYLnmYrfroLdi6lw2vLc0wdN5RfbDyEIYKZ
 BhNkPoUsKCKY0jkyZT0mdd0gsbsRadPbp48b+SR3MWQqTs6jHr2AxWXZiMHBpOfkywqA
 fKhSZtCDew4bhZyF2K9SVCxFoLKDt+MiPr7nSltNMP+959e/MN8H2idEaLc6EK2FNxlQ
 LTodzFvvJKNncZZEac17mRHOVDvYLwpJVrWXkWu96l1rwC6kmNCpLblNWkE663xLFmYn
 hBypFAAdWTq2il6P0wRdIUMO7we0OTVc/o0738yW7TLVPP0JDbcOCfLYzHRgomWBUh9D ZQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3abfu2gf7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 21:39:06 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 9 Aug
 2021 21:39:05 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 9 Aug 2021 21:39:05 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 6BB0F3F7044;
        Mon,  9 Aug 2021 21:39:05 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 17A4d5ZY001217;
        Mon, 9 Aug 2021 21:39:05 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 17A4d5lm001216;
        Mon, 9 Aug 2021 21:39:05 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 07/14] qla2xxx: fix port type info
Date:   Mon, 9 Aug 2021 21:37:13 -0700
Message-ID: <20210810043720.1137-8-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210810043720.1137-1-njavali@marvell.com>
References: <20210810043720.1137-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 2L2v86_4ctn6RpGTBFfWfcZoUYPvkKUR
X-Proofpoint-GUID: 2L2v86_4ctn6RpGTBFfWfcZoUYPvkKUR
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-10_01:2021-08-06,2021-08-10 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Over time, fcport->port_type became flag field. The flags within this field
were not defined properly. This caused external tools to read wrong info.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_def.h | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index c081bf1c7578..60702d066ed9 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2428,11 +2428,9 @@ struct mbx_24xx_entry {
  */
 typedef enum {
 	FCT_UNKNOWN,
-	FCT_RSCN,
-	FCT_SWITCH,
-	FCT_BROADCAST,
-	FCT_INITIATOR,
-	FCT_TARGET,
+	FCT_BROADCAST = 0x01,
+	FCT_INITIATOR = 0x02,
+	FCT_TARGET    = 0x04,
 	FCT_NVME_INITIATOR = 0x10,
 	FCT_NVME_TARGET = 0x20,
 	FCT_NVME_DISCOVERY = 0x40,
-- 
2.19.0.rc0

