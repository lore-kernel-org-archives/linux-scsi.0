Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B816FC433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 09:57:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 795C621D7A
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 09:57:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="i3QG/1Nf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbgIHJ5y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 05:57:54 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44820 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728973AbgIHJ5x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 05:57:53 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0889p2mQ008211;
        Tue, 8 Sep 2020 02:57:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=FkhiKUErK7yQSMGTzeorgJ2U9rEJ7JaxU0gwXMkv+Jo=;
 b=i3QG/1NfzSa43T7Y/uGZTW1zlYJcHcx8Wvo4PGH9s1HxZI1F6A/yEvnxtQ1Q65K5QGkX
 8GUJzRMOYAS+p7Bskg/AQ3XJk+zY7rJSRy822RXQSc8Xs4X5NvgG0pN2wXEOAyypaNbz
 muiib2BSQ3gcbpgOoPOJgXWSHIXEtLkKXb3wPIp5+7T/gfJSlQPRGNxsV9YusUEP9nQ2
 BTsEuBY8hNyN9HJUqublmi61xiMIJvfBVkqLmlXerUnbHNe1YqWlHQ96cZGEkFdePzBc
 4oVo6DISF26aJdCJHKLr53Kuhc94Ql/xx3u1llljYX/OFfPNWmddvYXlIOu30r16RmiI UA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 33ccvr1ts5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 02:57:48 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Sep
 2020 02:57:47 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Sep
 2020 02:57:46 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Sep 2020 02:57:46 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 013563F703F;
        Tue,  8 Sep 2020 02:57:45 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0889vjqo026868;
        Tue, 8 Sep 2020 02:57:45 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0889vjwD026867;
        Tue, 8 Sep 2020 02:57:45 -0700
From:   Manish Rangankar <mrangankar@marvell.com>
To:     <martin.petersen@oracle.com>, <lduncan@suse.com>,
        <cleech@redhat.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 1/8] qedi: Use qed count from set_fp_int in msix allocation.
Date:   Tue, 8 Sep 2020 02:56:50 -0700
Message-ID: <20200908095657.26821-2-mrangankar@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200908095657.26821-1-mrangankar@marvell.com>
References: <20200908095657.26821-1-mrangankar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_05:2020-09-08,2020-09-08 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To avoid unnecessary vector allocation when number of fast-path
queues are less then available msix vectors, use return count
from module qed->set_fp_int.

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
---
 drivers/scsi/qedi/qedi.h      | 1 +
 drivers/scsi/qedi/qedi_main.c | 9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qedi/qedi.h b/drivers/scsi/qedi/qedi.h
index 9498279ae80d..9c19ec9dc682 100644
--- a/drivers/scsi/qedi/qedi.h
+++ b/drivers/scsi/qedi/qedi.h
@@ -305,6 +305,7 @@ struct qedi_ctx {
 	u32 max_sqes;
 	u8 num_queues;
 	u32 max_active_conns;
+	s32 msix_count;
 
 	struct iscsi_cid_queue cid_que;
 	struct qedi_endpoint **ep_tbl;
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 6f038ae5efca..e1ec22d7d699 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1357,7 +1357,7 @@ static int qedi_request_msix_irq(struct qedi_ctx *qedi)
 	u16 idx;
 
 	cpu = cpumask_first(cpu_online_mask);
-	for (i = 0; i < qedi->int_info.msix_cnt; i++) {
+	for (i = 0; i < qedi->msix_count; i++) {
 		idx = i * qedi->dev_info.common.num_hwfns +
 			  qedi_ops->common->get_affin_hwfn_idx(qedi->cdev);
 
@@ -1387,7 +1387,12 @@ static int qedi_setup_int(struct qedi_ctx *qedi)
 {
 	int rc = 0;
 
-	rc = qedi_ops->common->set_fp_int(qedi->cdev, num_online_cpus());
+	rc = qedi_ops->common->set_fp_int(qedi->cdev, qedi->num_queues);
+	if (rc < 0)
+		goto exit_setup_int;
+
+	qedi->msix_count = rc;
+
 	rc = qedi_ops->common->get_fp_int(qedi->cdev, &qedi->int_info);
 	if (rc)
 		goto exit_setup_int;
-- 
2.25.0

