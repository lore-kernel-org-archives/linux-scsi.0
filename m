Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FBF2C432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 04:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5701261075
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 04:38:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236047AbhHJEia (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 00:38:30 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:52986 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236408AbhHJEi2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Aug 2021 00:38:28 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A4aNdb008544
        for <linux-scsi@vger.kernel.org>; Mon, 9 Aug 2021 21:38:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=3blUEQefnlD7kWO9hFX3J6hycE6y7HRHpz2Jo7yQY2A=;
 b=b4qyAcDc01+QVbQ/rcDqHcCU4tq5NL5D8Fpn4T5XmpKBZiW0dP7KAnDjWTMTMVnMdrJI
 n4p/S5WSbDSSdP3pN5dZznoTjFl35rDt7omMNXciCWALtOY6mfF+RNkah/p4IHAjWVHE
 J8/ErMOauUbQfShK5DnFa7HK1tflCm4nwoFWqsM5TnsBFjA0Fm+jGVI38UarBpmd0gyS
 erBbVv2tkNCH6ZRPl93o5S8pBTn2VYv2VP88pMStB20BDpm7XJz0YGTZ4V/mQzuUYq9b
 YB8u9TRDhxNZqQ1h5Y+gTe0MBqJ1y8TafKqN133mue/K5dYkm6JzqV1IG/SFkMYCGj2g tg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3abfu2gf3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 21:38:06 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 9 Aug
 2021 21:38:04 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 9 Aug 2021 21:38:04 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id BEC043F709B;
        Mon,  9 Aug 2021 21:38:04 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 17A4c4vB001184;
        Mon, 9 Aug 2021 21:38:04 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 17A4c4DF001183;
        Mon, 9 Aug 2021 21:38:04 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 01/14] qla2xxx: Add host attribute to trigger MPI hang
Date:   Mon, 9 Aug 2021 21:37:07 -0700
Message-ID: <20210810043720.1137-2-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210810043720.1137-1-njavali@marvell.com>
References: <20210810043720.1137-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: tuVc4Nv3yLvmyP4GJ1fZ815ZqChrMpsn
X-Proofpoint-GUID: tuVc4Nv3yLvmyP4GJ1fZ815ZqChrMpsn
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-10_01:2021-08-06,2021-08-10 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

Add a mechanism to trigger MPI pause for debugging purpose.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 22191e9a04a0..4a0a5b4e688d 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1887,6 +1887,30 @@ qla2x00_port_speed_show(struct device *dev, struct device_attribute *attr,
 	return scnprintf(buf, PAGE_SIZE, "%s\n", spd[ha->link_data_rate]);
 }
 
+static ssize_t
+qla2x00_mpi_pause_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	int rval = 0;
+
+	if (sscanf(buf, "%d", &rval) != 1)
+		return -EINVAL;
+
+	ql_log(ql_log_warn, vha, 0x7089, "Pausing MPI...\n");
+
+	rval = qla83xx_wr_reg(vha, 0x002012d4, 0x30000001);
+
+	if (rval != QLA_SUCCESS) {
+		ql_log(ql_log_warn, vha, 0x708a, "Unable to pause MPI.\n");
+		count = 0;
+	}
+
+	return count;
+}
+
+static DEVICE_ATTR(mpi_pause, S_IWUSR, NULL, qla2x00_mpi_pause_store);
+
 /* ----- */
 
 static ssize_t
@@ -2482,6 +2506,7 @@ struct device_attribute *qla2x00_host_attrs[] = {
 	&dev_attr_fw_attr,
 	&dev_attr_dport_diagnostics,
 	&dev_attr_edif_doorbell,
+	&dev_attr_mpi_pause,
 	NULL, /* reserve for qlini_mode */
 	NULL, /* reserve for ql2xiniexchg */
 	NULL, /* reserve for ql2xexchoffld */
-- 
2.19.0.rc0

