Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3656FC433C1
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 04:48:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0384B61994
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 04:48:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbhCWErq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 00:47:46 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:3508 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229494AbhCWEr0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Mar 2021 00:47:26 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12N4jHEP021058
        for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2021 21:47:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=GpR+dn1ng9HBamFxgHspzc41PuLW7koFIiYK0ryM5QA=;
 b=R2K4m9PvaL9C6W8PWUcUezLxUtnyHy5zYiQVZFkbdYBtnIqUON7xqlrppxGn8DqLgELY
 50O2QdNI8trK5z5ghW0yr1TMO6paqAGsIAW1DIk7Bu18mmx5jwWq2ML4+5+bDo1Ul0Qx
 /Aj8GuOa3NGdY0P62HvZNo3dd96Q2qSA5Dyre+H2/1F0LmqNM2Fl482/QtLa0FRvFtBt
 D90itHaJLPOmTv+bF0PXw91ipIkghHtN5bjIm8AVbHpHEhNU0a+scIeVcWNBKaCRDklA
 tyxfkoC1MMBIW18g6RInMaFatAW7ZHCsFx2MTVpfVjovFQifDuatd1PgD5qAeSFtP3jW Hw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 37dgjnyh1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2021 21:47:25 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Mar
 2021 21:47:23 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Mar 2021 21:47:23 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 76C2A3F703F;
        Mon, 22 Mar 2021 21:47:23 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 12N4lNVO026773;
        Mon, 22 Mar 2021 21:47:23 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 12N4lNan026772;
        Mon, 22 Mar 2021 21:47:23 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 10/11] qla2xxx: include AER debug mask to default
Date:   Mon, 22 Mar 2021 21:42:56 -0700
Message-ID: <20210323044257.26664-11-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210323044257.26664-1-njavali@marvell.com>
References: <20210323044257.26664-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-23_01:2021-03-22,2021-03-23 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Use PCIe AER debug mask as default.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_dbg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index 2e59e75c62b5..9eb708e5e22e 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -308,7 +308,7 @@ struct qla2xxx_fw_dump {
 };
 
 #define QL_MSGHDR "qla2xxx"
-#define QL_DBG_DEFAULT1_MASK    0x1e400000
+#define QL_DBG_DEFAULT1_MASK    0x1e600000
 
 #define ql_log_fatal		0 /* display fatal errors */
 #define ql_log_warn		1 /* display critical errors */
-- 
2.19.0.rc0

