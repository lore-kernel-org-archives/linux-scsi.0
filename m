Return-Path: <SRS0=6k2I=4A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD19C352A4
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFB63206DB
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:47:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="jKRQk3Kr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbgBLVr2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 16:47:28 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40406 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728185AbgBLVr2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Feb 2020 16:47:28 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01CLexG6001688;
        Wed, 12 Feb 2020 13:45:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=8RQlu/XfMHk8Dj8n3xDzE251DWgHDlOTc2CJln8oZjI=;
 b=jKRQk3KrRcIb82WXcCyggsEssBVykXbIFg/Ek/meqUCY9StIXSoBpx4T437ty7SiW0mk
 gOc1Y+N/d0JjPla8XzKVMg3AF+sqySK1LdBFTrphsXCCYaLQG2nBl0aCAMkPi8ve/p4D
 +pf8lDvs+hAd3LHE/AXvf6I7MODXQYxc/jVp1QmXedFjcr+Og0aWngxc3Uz7PKdGaMvF
 Y5rzsIg3EOXD2Bwv4msWp+TSqH0yT2qdJcntsrdM7h7xlbGidNwqxygibGb61qdjcou1
 rWgiZqwMEjCQ1Xr9J0rIEgzpyvhLOmpa2aWUktEjdaltVNxNx4MdS+0wdXlfiIyIQeAt LQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2y4j5jt50c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 12 Feb 2020 13:45:27 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 Feb
 2020 13:45:25 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 Feb 2020 13:45:24 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 089F63F7040;
        Wed, 12 Feb 2020 13:45:25 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01CLjOQ3025640;
        Wed, 12 Feb 2020 13:45:24 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01CLjO5t025639;
        Wed, 12 Feb 2020 13:45:24 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 16/25] qla2xxx: Use endian macros to assign static fields in fwdump header
Date:   Wed, 12 Feb 2020 13:44:27 -0800
Message-ID: <20200212214436.25532-17-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200212214436.25532-1-hmadhani@marvell.com>
References: <20200212214436.25532-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-12_10:2020-02-12,2020-02-12 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@cavium.com>

This takes care of big endian architectures.

Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_tmpl.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index 5b0c057def2b..6aeb1c3fb7a8 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -870,7 +870,7 @@ qla27xx_walk_template(struct scsi_qla_host *vha,
 static void
 qla27xx_time_stamp(struct qla27xx_fwdt_template *tmp)
 {
-	tmp->capture_timestamp = jiffies;
+	tmp->capture_timestamp = cpu_to_le32(jiffies);
 }
 
 static void
@@ -882,9 +882,10 @@ qla27xx_driver_info(struct qla27xx_fwdt_template *tmp)
 			    "%hhu.%hhu.%hhu.%hhu.%hhu.%hhu",
 			    v+0, v+1, v+2, v+3, v+4, v+5) != 6);
 
-	tmp->driver_info[0] = v[3] << 24 | v[2] << 16 | v[1] << 8 | v[0];
-	tmp->driver_info[1] = v[5] << 8 | v[4];
-	tmp->driver_info[2] = 0x12345678;
+	tmp->driver_info[0] = cpu_to_le32(
+		v[3] << 24 | v[2] << 16 | v[1] << 8 | v[0]);
+	tmp->driver_info[1] = cpu_to_le32(v[5] << 8 | v[4]);
+	tmp->driver_info[2] = __constant_cpu_to_le32(0x12345678);
 }
 
 static void
@@ -894,10 +895,10 @@ qla27xx_firmware_info(struct scsi_qla_host *vha,
 	tmp->firmware_version[0] = vha->hw->fw_major_version;
 	tmp->firmware_version[1] = vha->hw->fw_minor_version;
 	tmp->firmware_version[2] = vha->hw->fw_subminor_version;
-	tmp->firmware_version[3] =
-	    vha->hw->fw_attributes_h << 16 | vha->hw->fw_attributes;
-	tmp->firmware_version[4] =
-	    vha->hw->fw_attributes_ext[1] << 16 | vha->hw->fw_attributes_ext[0];
+	tmp->firmware_version[3] = cpu_to_le32(
+		vha->hw->fw_attributes_h << 16 | vha->hw->fw_attributes);
+	tmp->firmware_version[4] = cpu_to_le32(
+	  vha->hw->fw_attributes_ext[1] << 16 | vha->hw->fw_attributes_ext[0]);
 }
 
 static void
-- 
2.12.0

