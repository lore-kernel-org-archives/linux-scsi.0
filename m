Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8D9EC47080
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 17:23:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A49E6613AE
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 17:23:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234506AbhFARYx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 13:24:53 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52330 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234009AbhFARYx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 13:24:53 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 151HGjqd008965
        for <linux-scsi@vger.kernel.org>; Tue, 1 Jun 2021 10:23:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=1szamPOfKg26/29aRvSx1PXoZkNsUiB45TV9dziTc8I=;
 b=f9u6MU1XQQTGBJOFYvvz7nfvVRHhVO3G55PpJvzSatHSP/2PJUEYQC0wOaEusmGX4es+
 uZNCVlJcxhdC8Yr0rExW6bq8TfWdT8gez23tJrRfdf7JK2EEdz7yNFwTcgstkdgW0YG4
 90RXZtAShjWRKlvpUkecc1Et8PbCNRg3cW2IdcwfNh2SQ+RdrZDNwLrgAob0ETJfWOpC
 GGHyqoDnEusQ2p6a8ZVLwDOILJwANUMIiJas8SPOgKNQkeylHTmRTjBABKxm381mIjPQ
 WT2yO3M3w2XbiHkNjmlTuC32iuRZztaqAIez7LX+xnVJhdJvm6nzB1sYDx7Q4A/DatSr rQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 38vtnjd8kc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 01 Jun 2021 10:23:11 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 1 Jun
 2021 10:23:09 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 1 Jun 2021 10:23:09 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 218B73F703F;
        Tue,  1 Jun 2021 10:23:09 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 151HN8W2032001;
        Tue, 1 Jun 2021 10:23:08 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 151HN88d031992;
        Tue, 1 Jun 2021 10:23:08 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 2/2] libfc: Corrected the condition check and invalid argument passed
Date:   Tue, 1 Jun 2021 10:21:56 -0700
Message-ID: <20210601172156.31942-3-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210601172156.31942-1-jhasan@marvell.com>
References: <20210601172156.31942-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: kbgL8zHyAGj3bMcT-mDNONwcVpxaib-M
X-Proofpoint-ORIG-GUID: kbgL8zHyAGj3bMcT-mDNONwcVpxaib-M
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-01_08:2021-06-01,2021-06-01 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

 -In correct condition check was leading to data corruption
  and so the invalid argument.

Signed-off-by: Javed Hasan <jhasan@marvell.com>

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

