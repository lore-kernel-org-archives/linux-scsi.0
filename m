Return-Path: <SRS0=6k2I=4A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DC7BC352A4
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:45:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E8DB21734
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:45:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="YJYOizRG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729089AbgBLVpM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 16:45:12 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:63048 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728447AbgBLVpM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Feb 2020 16:45:12 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01CLduPL006513;
        Wed, 12 Feb 2020 13:45:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=WfadcTOgQAYKn5qQuSGccptIvyhIbQQjxxv0fIJ2zco=;
 b=YJYOizRGeqhClrYRf9VtgNTo8JVJ+5jlzJLBx7q9RNIg8Pt3cM6MwggqoduFMq9dc/VZ
 taSMl3foxnpkgbjiascFIQnI2utTsHaTim2WTTaKn12lKw5wuLhPLmKmu+3O2Dr+gFjI
 tqH3S7wfI4y3ZxwSamjnhHUTJSDyGsCi++mX0YsL8tkg5txEt3bJP3WJmSKn1ONO9gSE
 xfx9TELz8NN8rlb9w3cxt/HwfOkqUvY+8k10Cvd3qlCKIUCvOSbuZrgM+1VK97gfpawA
 sHSQQREGo3Imk8GmSq6vUcQCJ1YNQ7X379NS9EVOjNFeiz5nCVE/ENmGpBEl5sXGMv0J bA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2y4be2bpkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 12 Feb 2020 13:45:10 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 Feb
 2020 13:45:08 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 Feb 2020 13:45:08 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id B80413F703F;
        Wed, 12 Feb 2020 13:45:08 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01CLj8W7025620;
        Wed, 12 Feb 2020 13:45:08 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01CLj8UN025619;
        Wed, 12 Feb 2020 13:45:08 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 11/25] qla2xxx: Show correct port speed capabilities for RDP command
Date:   Wed, 12 Feb 2020 13:44:22 -0800
Message-ID: <20200212214436.25532-12-hmadhani@marvell.com>
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

This patch correctly displays Port speed capabiltiy and
current speed for RDP command.

Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 41 +++++++++++++++++++++++++++++++++++------
 1 file changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 4be99f13be42..dbbe20c7fbaf 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5762,13 +5762,39 @@ qla25xx_rdp_port_speed_capability(struct qla_hw_data *ha)
 	if (IS_CNA_CAPABLE(ha))
 		return RDP_PORT_SPEED_10GB;
 
-	if (IS_QLA27XX(ha)) {
-		if (FW_ABILITY_MAX_SPEED(ha) == FW_ABILITY_MAX_SPEED_32G)
-			return RDP_PORT_SPEED_32GB|RDP_PORT_SPEED_16GB|
-			       RDP_PORT_SPEED_8GB;
+	if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+		unsigned int speeds = 0;
 
-		return RDP_PORT_SPEED_16GB|RDP_PORT_SPEED_8GB|
-		       RDP_PORT_SPEED_4GB;
+		if (ha->max_supported_speed == 2) {
+			if (ha->min_supported_speed <= 6)
+				speeds |= RDP_PORT_SPEED_64GB;
+		}
+
+		if (ha->max_supported_speed == 2 ||
+		    ha->max_supported_speed == 1) {
+			if (ha->min_supported_speed <= 5)
+				speeds |= RDP_PORT_SPEED_32GB;
+		}
+
+		if (ha->max_supported_speed == 2 ||
+		    ha->max_supported_speed == 1 ||
+		    ha->max_supported_speed == 0) {
+			if (ha->min_supported_speed <= 4)
+				speeds |= RDP_PORT_SPEED_16GB;
+		}
+
+		if (ha->max_supported_speed == 1 ||
+		    ha->max_supported_speed == 0) {
+			if (ha->min_supported_speed <= 3)
+				speeds |= RDP_PORT_SPEED_8GB;
+		}
+
+		if (ha->max_supported_speed == 0) {
+			if (ha->min_supported_speed <= 2)
+				speeds |= RDP_PORT_SPEED_4GB;
+		}
+
+		return speeds;
 	}
 
 	if (IS_QLA2031(ha))
@@ -5814,6 +5840,9 @@ qla25xx_rdp_port_speed_currently(struct qla_hw_data *ha)
 	case PORT_SPEED_32GB:
 		return RDP_PORT_SPEED_32GB;
 
+	case PORT_SPEED_64GB:
+		return RDP_PORT_SPEED_64GB;
+
 	default:
 		return RDP_PORT_SPEED_UNKNOWN;
 	}
-- 
2.12.0

