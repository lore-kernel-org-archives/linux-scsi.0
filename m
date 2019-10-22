Return-Path: <SRS0=5qjn=YP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3093CA9EA0
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Oct 2019 19:36:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8611C214B2
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Oct 2019 19:36:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="nKDJbWIm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388081AbfJVTgy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Oct 2019 15:36:54 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:29566 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731806AbfJVTgy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Oct 2019 15:36:54 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9MJXSf7027747;
        Tue, 22 Oct 2019 12:36:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=XwVs91KWKhW+wWr5yph0TIzknryv1igNCvvk0Sr9wuU=;
 b=nKDJbWImu14UUoKFDsoy63cUwzYwQinSDi9fj5FQlae1vyf02sZVL8JWZxFoM1eRCb9J
 YOw8TJ9qCd+U8YZKFL3YnBsoze5UUOOhxJ+gzA1o0Gi1KxtXswidH5ap2MKW7nZkRj0d
 qDlxN88g6shjMZ5jIHCJJpEAOpmFVfLmguHTNE7KfbplMbz7Ol+12VpMt3GjKEeg008P
 X9kguHrKVAgy/84dvlMeFPCJQVqOMERNBAs3NUJ2Uv3/88c6eQsvr0ibOP/tpkaLB9K1
 AxBoz5mHNLYwsJTCcwjFWQ0vbwR6WuwczApmqT3uD/lqnJwQMFpKq6CCz4/6OPpsVMKg xw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2vsyjha14e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 22 Oct 2019 12:36:51 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 22 Oct
 2019 12:36:50 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 22 Oct 2019 12:36:50 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id A94FC3F703F;
        Tue, 22 Oct 2019 12:36:50 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x9MJaoAI007119;
        Tue, 22 Oct 2019 12:36:50 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x9MJaogS007118;
        Tue, 22 Oct 2019 12:36:50 -0700
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 2/2] qla2xxx: Fix partial flash write of MBI
Date:   Tue, 22 Oct 2019 12:36:43 -0700
Message-ID: <20191022193643.7076-3-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20191022193643.7076-1-hmadhani@marvell.com>
References: <20191022193643.7076-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-22_06:2019-10-22,2019-10-22 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

For new adapter with multiple flash regions to write to, current code
allows FW & Boot regions to be written, while other regions are blocked
via sysfs. The fix is to block all flash read/write through sysfs
interface.

Fixes: e81d1bcbde06 ("scsi: qla2xxx: Further limit FLASH region write access from SysFS")
Cc: stable@vger.kernel.org # 5.2
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Girish Basrur <gbasrur@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 8b3015361428..8705ca6395e4 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -440,9 +440,6 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 		valid = 0;
 		if (ha->optrom_size == OPTROM_SIZE_2300 && start == 0)
 			valid = 1;
-		else if (start == (ha->flt_region_boot * 4) ||
-		    start == (ha->flt_region_fw * 4))
-			valid = 1;
 		else if (IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha))
 			valid = 1;
 		if (!valid) {
@@ -489,8 +486,10 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 		    "Writing flash region -- 0x%x/0x%x.\n",
 		    ha->optrom_region_start, ha->optrom_region_size);
 
-		ha->isp_ops->write_optrom(vha, ha->optrom_buffer,
+		rval = ha->isp_ops->write_optrom(vha, ha->optrom_buffer,
 		    ha->optrom_region_start, ha->optrom_region_size);
+		if (rval)
+			rval = -EIO;
 		break;
 	default:
 		rval = -EINVAL;
-- 
2.12.0

