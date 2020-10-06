Return-Path: <SRS0=xWhZ=DN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09178C41604
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Oct 2020 06:18:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B32EA20797
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Oct 2020 06:18:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="GhFcC/JY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgJFGSS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 02:18:18 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35200 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726118AbgJFGSS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2020 02:18:18 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09665fcB016600
        for <linux-scsi@vger.kernel.org>; Mon, 5 Oct 2020 23:18:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=B78UKhWJSe3XgIVZUzrH9JRlZ6M9cqYWOEhMOSwC/mI=;
 b=GhFcC/JYg3sAEUu6oyweH7kZv0sBTozRFMrBIwhHwpxCB8QxNviCsvRndIkevcPnjNfy
 hdASBfr8MyhgWkSz+NF6PFI7fPEK3FwmejTyBmlwA/+w9Si4ngf5qN2dzdAcddFxOyB4
 GhBkSxyXRFK/5XcFIIVcWvmfWpTSCdbTzryyOL+Ze/8fRyEDXcvZC5LgikqqZKkt1Uql
 ewN6IlqnXw+RWIx0cuxdBDKabvTq+cm4yPm5GBT9+xfsr9Z4yXOR/bS0CcnofxjIM+MN
 YIikbklyUNaDtfqi3Cj3hO/DrC9InqwRz1CknMVW/J/3d8OoZvsnH6wbhM4WH8+dG5VN zg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 33xpnpr0a0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 05 Oct 2020 23:18:17 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 5 Oct
 2020 23:18:16 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 5 Oct 2020 23:18:16 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 841453F703F;
        Mon,  5 Oct 2020 23:18:16 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0966IGx4028741;
        Mon, 5 Oct 2020 23:18:16 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0966IGf7028740;
        Mon, 5 Oct 2020 23:18:16 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 4/5] scsi: fc: Add mechanism to update FPIN signal statistics
Date:   Mon, 5 Oct 2020 23:16:14 -0700
Message-ID: <20201006061615.28674-5-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20201006061615.28674-1-njavali@marvell.com>
References: <20201006061615.28674-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-06_02:2020-10-06,2020-10-06 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Shyam Sundar <ssundar@marvell.com>

Add statistics for Congestion Signals that are delivered to the host as
interrupt signals, under fc_host_statistics.

Signed-off-by: Shyam Sundar <ssundar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/scsi_transport_fc.c | 5 +++++
 include/scsi/scsi_transport_fc.h | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 3db7eb674cda..f3296b23d193 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2129,6 +2129,9 @@ fc_host_statistic(fc_xid_not_found);
 fc_host_statistic(fc_xid_busy);
 fc_host_statistic(fc_seq_not_found);
 fc_host_statistic(fc_non_bls_resp);
+fc_host_statistic(cn_sig_warn);
+fc_host_statistic(cn_sig_alarm);
+
 
 #define fc_host_fpin_statistic(name)					\
 static ssize_t fc_host_fpinstat_##name(struct device *cd,		\
@@ -2211,6 +2214,8 @@ static struct attribute *fc_statistics_attrs[] = {
 	&device_attr_host_fc_xid_busy.attr,
 	&device_attr_host_fc_seq_not_found.attr,
 	&device_attr_host_fc_non_bls_resp.attr,
+	&device_attr_host_cn_sig_warn.attr,
+	&device_attr_host_cn_sig_alarm.attr,
 	&device_attr_host_reset_statistics.attr,
 	&device_attr_host_fpin_dn.attr,
 	&device_attr_host_fpin_dn_unknown.attr,
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index a636c1986e22..c759b29e46c7 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -468,6 +468,9 @@ struct fc_host_statistics {
 	u64 fc_seq_not_found;		/* seq is not found for exchange */
 	u64 fc_non_bls_resp;		/* a non BLS response frame with
 					   a sequence responder in new exch */
+	/* Host Congestion Signals */
+	u64 cn_sig_warn;
+	u64 cn_sig_alarm;
 };
 
 
-- 
2.19.0.rc0

