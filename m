Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93B15C47096
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 09:57:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C650613EE
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 09:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhFCJ7g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 05:59:36 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:24582 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229719AbhFCJ7f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2021 05:59:35 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1539oSh5001459
        for <linux-scsi@vger.kernel.org>; Thu, 3 Jun 2021 02:57:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=yEFHMCVplFFJKULmDcc+I+02SLJs6iW0txc9V44VMtc=;
 b=GM9JZ8Art3Q6pH86JVmpHdWJ8fLEugnjosId2bm+5uXXl1p7nkxY0bbk3tKOj1ftVWf5
 QBQocqhB65Q9Czi48aaeFDTyonIUhXhRz4xNO/qjq9RTkL01m6nNvhFv4uuXopnm+lJc
 detVam1nLAYkyb7n9NV3oWp7rjso2FD74bKsJMn60Pu/YT519HVtdSnL7DNk7tR3QeQk
 Ak4fHDvcNb/RZgcFUor5OEZtNyQMRs4OdyZetCclCk3Zl7q9O4a1Z30dVF5qD072skFh
 kqaJTpQm8iLTqiWSUQVZfexH3MYFjFvyKkQrPGbSKCMeO8ApGmzGQPoTIWIwq/34xsT2 qw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 38xe7xu4rn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 03 Jun 2021 02:57:51 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 02:57:50 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Jun 2021 02:57:50 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id DACEC3F703F;
        Thu,  3 Jun 2021 02:57:49 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 1539vnKx007370;
        Thu, 3 Jun 2021 02:57:49 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 1539vnYs007369;
        Thu, 3 Jun 2021 02:57:49 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 2/2] libfc: Corrected the condition check and invalid argument passed
Date:   Thu, 3 Jun 2021 02:56:37 -0700
Message-ID: <20210603095637.7319-3-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210603095637.7319-1-jhasan@marvell.com>
References: <20210603095637.7319-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: U5R9LFh_7OjgpXsJ8Vz_pbuHI9WOrVvF
X-Proofpoint-GUID: U5R9LFh_7OjgpXsJ8Vz_pbuHI9WOrVvF
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-03_06:2021-06-02,2021-06-03 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

 -In correct condition check was leading to data corruption
  and so the invalid argument.

Fixes: 8fd9efca86d0 ("scsi: libfc: Work around -Warray-bounds warning")
Signed-off-by: Javed Hasan <jhasan@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/libfc/fc_encode.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_encode.h b/drivers/scsi/libfc/fc_encode.h
index 602c97a651bc..9ea4ceadb559 100644
--- a/drivers/scsi/libfc/fc_encode.h
+++ b/drivers/scsi/libfc/fc_encode.h
@@ -166,9 +166,11 @@ static inline int fc_ct_ns_fill(struct fc_lport *lport,
 static inline void fc_ct_ms_fill_attr(struct fc_fdmi_attr_entry *entry,
 				    const char *in, size_t len)
 {
-	int copied = strscpy(entry->value, in, len);
-	if (copied > 0)
-		memset(entry->value, copied, len - copied);
+	int copied;
+
+	copied = strscpy((char *)&entry->value, in, len);
+	if (copied > 0 && (copied + 1) < len)
+		memset((entry->value + copied + 1), 0, len - copied - 1);
 }
 
 /**
-- 
2.26.2

