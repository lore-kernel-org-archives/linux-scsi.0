Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6906CC64E7B
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 13:27:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1013D22202
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 13:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgLBN1H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 08:27:07 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:29420 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726556AbgLBN1H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 08:27:07 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B2DP5tP002247
        for <linux-scsi@vger.kernel.org>; Wed, 2 Dec 2020 05:26:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=R8S+8SYpSnZsHSL/Y7ZPCmeHCfxMyHhq4bdQUIUPPpM=;
 b=IkmAU+dCtsw47zL/XzhLsaSdRuHG1wL6fBFmo9WSh9zZ7ewHsmswjTT+JjWAgCGlT8fs
 +qVI+eWmaAOxTGL0nyPNdgPX3E6yAyteHJy7nhaFDR1ySh1yrhCMb8FOmjKTqt/yCuAh
 Vv5kkLDryoysYl3acSF41eJNUqoWZ2WHNVpA/NatOGFrK6FqWHmWylDiyuMmAIckWwXj
 2egU5pO8rBe+TnO1LDQrknB+sMZ+3a1qgSbqB10osii+w5GeoUty4OoM56xomaIj1iGm
 hkVepHSk8pAWQtye2gy3Dad3cv0RmRhSPz+4WYe01ZOoh0Q3GzeqVml8NAzLd+BqU6cU Rw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3568jf8fyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Dec 2020 05:26:26 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Dec
 2020 05:26:25 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Dec 2020 05:26:26 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id D11A43F703F;
        Wed,  2 Dec 2020 05:26:25 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0B2DQPjj020062;
        Wed, 2 Dec 2020 05:26:25 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0B2DQPqq020053;
        Wed, 2 Dec 2020 05:26:25 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 07/15] qla2xxx: Fix crash during driver load on big endian machines
Date:   Wed, 2 Dec 2020 05:23:04 -0800
Message-ID: <20201202132312.19966-8-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20201202132312.19966-1-njavali@marvell.com>
References: <20201202132312.19966-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_06:2020-11-30,2020-12-02 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

Crash stack:
	[576544.715489] Unable to handle kernel paging request for data at address 0xd00000000f970000
	[576544.715497] Faulting instruction address: 0xd00000000f880f64
	[576544.715503] Oops: Kernel access of bad area, sig: 11 [#1]
	[576544.715506] SMP NR_CPUS=2048 NUMA pSeries
	:
	[576544.715703] NIP [d00000000f880f64] .qla27xx_fwdt_template_valid+0x94/0x100 [qla2xxx]
	[576544.715722] LR [d00000000f7952dc] .qla24xx_load_risc_flash+0x2fc/0x590 [qla2xxx]
	[576544.715726] Call Trace:
	[576544.715731] [c0000004d0ffb000] [c0000006fe02c350] 0xc0000006fe02c350 (unreliable)
	[576544.715750] [c0000004d0ffb080] [d00000000f7952dc] .qla24xx_load_risc_flash+0x2fc/0x590 [qla2xxx]
	[576544.715770] [c0000004d0ffb170] [d00000000f7aa034] .qla81xx_load_risc+0x84/0x1a0 [qla2xxx]
	[576544.715789] [c0000004d0ffb210] [d00000000f79f7c8] .qla2x00_setup_chip+0xc8/0x910 [qla2xxx]
	[576544.715808] [c0000004d0ffb300] [d00000000f7a631c] .qla2x00_initialize_adapter+0x4dc/0xb00 [qla2xxx]
	[576544.715826] [c0000004d0ffb3e0] [d00000000f78ce28] .qla2x00_probe_one+0xf08/0x2200 [qla2xxx]

Fixes: f73cb695d3ec ("[SCSI] qla2xxx: Add support for ISP2071.")
Cc: stable@vger.kernel.org
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_tmpl.c | 9 +++++----
 drivers/scsi/qla2xxx/qla_tmpl.h | 2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index 84f4416d366f..a6bb1c0e2245 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -928,7 +928,8 @@ qla27xx_template_checksum(void *p, ulong size)
 static inline int
 qla27xx_verify_template_checksum(struct qla27xx_fwdt_template *tmp)
 {
-	return qla27xx_template_checksum(tmp, tmp->template_size) == 0;
+	return qla27xx_template_checksum(tmp,
+		le32_to_cpu(tmp->template_size)) == 0;
 }
 
 static inline int
@@ -944,7 +945,7 @@ qla27xx_execute_fwdt_template(struct scsi_qla_host *vha,
 	ulong len = 0;
 
 	if (qla27xx_fwdt_template_valid(tmp)) {
-		len = tmp->template_size;
+		len = le32_to_cpu(tmp->template_size);
 		tmp = memcpy(buf, tmp, len);
 		ql27xx_edit_template(vha, tmp);
 		qla27xx_walk_template(vha, tmp, buf, &len);
@@ -960,7 +961,7 @@ qla27xx_fwdt_calculate_dump_size(struct scsi_qla_host *vha, void *p)
 	ulong len = 0;
 
 	if (qla27xx_fwdt_template_valid(tmp)) {
-		len = tmp->template_size;
+		len = le32_to_cpu(tmp->template_size);
 		qla27xx_walk_template(vha, tmp, NULL, &len);
 	}
 
@@ -972,7 +973,7 @@ qla27xx_fwdt_template_size(void *p)
 {
 	struct qla27xx_fwdt_template *tmp = p;
 
-	return tmp->template_size;
+	return le32_to_cpu(tmp->template_size);
 }
 
 int
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.h b/drivers/scsi/qla2xxx/qla_tmpl.h
index c47184db5081..6e0987edfceb 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.h
+++ b/drivers/scsi/qla2xxx/qla_tmpl.h
@@ -12,7 +12,7 @@
 struct __packed qla27xx_fwdt_template {
 	__le32 template_type;
 	__le32 entry_offset;
-	uint32_t template_size;
+	__le32 template_size;
 	uint32_t count;		/* borrow field for running/residual count */
 
 	__le32 entry_count;
-- 
2.19.0.rc0

