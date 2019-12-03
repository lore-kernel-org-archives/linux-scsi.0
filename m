Return-Path: <SRS0=KpyL=ZZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F258DC43215
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 22:37:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C130B207DD
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 22:37:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="QLk0ii/0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727644AbfLCWhK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Dec 2019 17:37:10 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:62040 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727637AbfLCWhJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Dec 2019 17:37:09 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB3MYZHs020259;
        Tue, 3 Dec 2019 14:37:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=uxeHBpREI7v5Yu8OfkleXzFVzPKfAKmRbxxQ2B/MmZY=;
 b=QLk0ii/0Rd96otQMO+N8oqcHJAGTnONTdJ1d9rCXZFX9Dw5r6ZwZP/gXVmhibBhtdyVz
 N/lxfyODT7YGPToxnWxGsK35pOlPrUJfSnmeiG51gKxd+6GeDJiW1/f4vaGuXAXgfuGP
 1NYGnOMURN6dRaFiG3zInNUwiQKZO04eNQheLNr4th92VBQ4lLUe1pHj+ZuR21Skq2g+
 lcR06q3Nq2HP0azFijDSNHQnBi1SXDz9YL5SSqJut+JqThVZ2Qb+zIJ+9JqD8eciYHr5
 E3l8W/k9Tw0Oid/YjwRA1GaVEH0/ImXjq4Lh/Int+yT4dhonqKZZeHVnFzs4pLrcXOpq Og== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2wnvgvh462-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 03 Dec 2019 14:37:06 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 3 Dec
 2019 14:37:00 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 3 Dec 2019 14:37:01 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id D1A093F7041;
        Tue,  3 Dec 2019 14:37:00 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xB3Mb0rV022148;
        Tue, 3 Dec 2019 14:37:00 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xB3Mb0S7022147;
        Tue, 3 Dec 2019 14:37:00 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 1/3] qla2xxx: Correctly retrieve and interprete active flash region
Date:   Tue, 3 Dec 2019 14:36:55 -0800
Message-ID: <20191203223657.22109-2-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20191203223657.22109-1-hmadhani@marvell.com>
References: <20191203223657.22109-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-03_07:2019-12-02,2019-12-03 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ISP27XX/28XX supports multiple flash regions. This patch fixes
issue where active flash region was not interpreted correctly
during secure flash update process.

Fixes: 5fa8774c7f38c ("scsi: qla2xxx: Add 28xx flash primary/secondary status/image mechanism")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Hernandez <mhernandez@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 1 +
 drivers/scsi/qla2xxx/qla_bsg.c  | 2 +-
 drivers/scsi/qla2xxx/qla_sup.c  | 6 +++---
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index ae97e2f310a3..d7e7043f9eab 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -178,6 +178,7 @@ qla2x00_sysfs_read_nvram(struct file *filp, struct kobject *kobj,
 
 	faddr = ha->flt_region_nvram;
 	if (IS_QLA28XX(ha)) {
+		qla28xx_get_aux_images(vha, &active_regions);
 		if (active_regions.aux.vpd_nvram == QLA27XX_SECONDARY_IMAGE)
 			faddr = ha->flt_region_nvram_sec;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 99f0a1a08143..cbaf178fc979 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2399,7 +2399,7 @@ qla2x00_get_flash_image_status(struct bsg_job *bsg_job)
 	struct qla_active_regions regions = { };
 	struct active_regions active_regions = { };
 
-	qla28xx_get_aux_images(vha, &active_regions);
+	qla27xx_get_active_image(vha, &active_regions);
 	regions.global_image = active_regions.global;
 
 	if (IS_QLA28XX(ha)) {
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index f2d5115b2d8d..b93a0d99e573 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -847,15 +847,15 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 				ha->flt_region_img_status_pri = start;
 			break;
 		case FLT_REG_IMG_SEC_27XX:
-			if (IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+			if (IS_QLA27XX(ha) || IS_QLA28XX(ha))
 				ha->flt_region_img_status_sec = start;
 			break;
 		case FLT_REG_FW_SEC_27XX:
-			if (IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+			if (IS_QLA27XX(ha) || IS_QLA28XX(ha))
 				ha->flt_region_fw_sec = start;
 			break;
 		case FLT_REG_BOOTLOAD_SEC_27XX:
-			if (IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+			if (IS_QLA27XX(ha) || IS_QLA28XX(ha))
 				ha->flt_region_boot_sec = start;
 			break;
 		case FLT_REG_AUX_IMG_PRI_28XX:
-- 
2.12.0

