Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1E84C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 08:59:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A06886192E
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 08:59:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbhC2I71 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 04:59:27 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:32852 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235903AbhC2I5B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Mar 2021 04:57:01 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12T8sREu008737;
        Mon, 29 Mar 2021 01:56:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=guyWDUet9kdolZ4pp51JCDSe2/2exxaR/rOjSaS0xHM=;
 b=DrrRbuIBSJZSKa1S3A/IM1BSRSBvzeSNsapF6tVOHZGrA5Pp9+hYtXXinKVEMo4Hz6OM
 oyswDztqSM3cnT9y35jeEVMhfybvVkUaR+e3+iA5XkObjGuQcmQApWvRIhLjghXXwPwf
 ii4GvMu/hrWHbpP5fSY5/sNh7U1ubCDRMp6asK6DAT3+CmyWZ4lmopOMf6dA4HRPReh0
 1IdWNM9mFx8kYWyqiH9wf2wDCkRGuvNeWpthOlEifNkE1ryoH1p3lZJidFWNUhf21y4a
 TPoN6C4+VPbznxNttanChXxNwIJSO7bIw0lhK2PPIleWNzUb1n/h3pFk+Yu/xswVCFxa NA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 37k63b8vsw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 01:56:56 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Mar
 2021 01:56:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 29 Mar 2021 01:56:55 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 5E6F73F703F;
        Mon, 29 Mar 2021 01:56:55 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 12T8utiD004483;
        Mon, 29 Mar 2021 01:56:55 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 12T8ut60004474;
        Mon, 29 Mar 2021 01:56:55 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <loberman@redhat.com>
Subject: [PATCH v2 10/12] qla2xxx: include AER debug mask to default
Date:   Mon, 29 Mar 2021 01:52:27 -0700
Message-ID: <20210329085229.4367-11-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210329085229.4367-1-njavali@marvell.com>
References: <20210329085229.4367-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: YylQPdxJi5MoKR5zVdeiH2VDYgahTN0Z
X-Proofpoint-GUID: YylQPdxJi5MoKR5zVdeiH2VDYgahTN0Z
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_04:2021-03-26,2021-03-29 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Use PCIe AER debug mask as default.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
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

