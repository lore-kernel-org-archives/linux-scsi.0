Return-Path: <SRS0=hn0g=D4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DCAAC4363A
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 09:29:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFC7621D7B
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 09:29:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="fmRafxgp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389234AbgJUJ3S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Oct 2020 05:29:18 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50704 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389010AbgJUJ3S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Oct 2020 05:29:18 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09L9OcdF006663
        for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2020 02:29:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=K/zpgP4/VjdHmPi5DjZehl59Ihhn9EO3hB6U5Qc+oDU=;
 b=fmRafxgp0GcZYhdkxRvIh8JqfvRAYi0j/yCrxqX2qnhHL0JrYwMs9y3/5giCzostU3jB
 2ckQjj9QgD6IjI7sT/nNk8DH7udl2jYjNq4F8RcbsgApXjl0slQn3oHVB0FPKUMDL7E3
 cGPosFC2ZKM3+/J3FcQqygE/gq3Jku+PIn1WnjIPZFI7THbDrxXO4D40cbxyhbMJ2fs6
 Jk8Q9VpSIbOvflqOdAwIoypl2NK0LhW+8b+KjKnauhQelZ59eac8/OUjOjKT+42Niuy/
 UpskeOCnNstjqk1J8fRMouomofsbg0NEftDBng8nyvNt0Tv5azvh4qwW43qAotJRVC+H kw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 347wyqcmg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2020 02:29:17 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Oct
 2020 02:29:16 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Oct 2020 02:29:16 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id F2E793F7040;
        Wed, 21 Oct 2020 02:29:15 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 09L9TFlB022737;
        Wed, 21 Oct 2020 02:29:15 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 09L9TFK9022728;
        Wed, 21 Oct 2020 02:29:15 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v3 4/5] scsi: fc: Add mechanism to update FPIN signal statistics
Date:   Wed, 21 Oct 2020 02:27:14 -0700
Message-ID: <20201021092715.22669-5-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20201021092715.22669-1-njavali@marvell.com>
References: <20201021092715.22669-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-21_03:2020-10-20,2020-10-21 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Shyam Sundar <ssundar@marvell.com>

Add statistics for Congestion Signals that are delivered to the host as
interrupt signals, under fc_host_statistics.

Signed-off-by: Shyam Sundar <ssundar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/scsi_transport_fc.c | 5 +++++
 include/scsi/scsi_transport_fc.h | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 4dfa0e40d8e5..3f816ab1d845 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2100,6 +2100,9 @@ fc_host_statistic(fc_xid_not_found);
 fc_host_statistic(fc_xid_busy);
 fc_host_statistic(fc_seq_not_found);
 fc_host_statistic(fc_non_bls_resp);
+fc_host_statistic(cn_sig_warn);
+fc_host_statistic(cn_sig_alarm);
+
 
 #define fc_host_fpin_statistic(name)					\
 static ssize_t fc_host_fpinstat_##name(struct device *cd,		\
@@ -2182,6 +2185,8 @@ static struct attribute *fc_statistics_attrs[] = {
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

