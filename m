Return-Path: <SRS0=0Ioj=2H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA296C43603
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 22:09:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BF1B20716
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 22:09:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="RWtMEd8G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfLQWJN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Dec 2019 17:09:13 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:45518 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726556AbfLQWJN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Dec 2019 17:09:13 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBHM5aBt029957;
        Tue, 17 Dec 2019 14:07:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=IUka29qwhztT1nUBqWIbDf81UosVHYReXaM1smVJh/I=;
 b=RWtMEd8GeVIuyOezDc7LfrcsBDqTxJAaddy5OJ+8PCoJwb6jFcHIA3Ruhy8JoYBN9pK9
 +hoYRAYMOQCPwm5iUbAfsnzfL47oglE+FVWsqZvgbTeIkss7cqXumDTMkv95mSdH+yl/
 Te+xzash3lfld2lmE+ZNnLIjtTzSi5+lreUUM01GhTxExHN4Nzf1Rv48WoMPoFwN5d1E
 JJ8tbt+vHZXSTyKWCDrenhCIZA8/J4rc5fvMHMXyQ/0QdhJ8ZtY+CA/eCkbzVigkwfFI
 IreKnZ3TQ12Pfx8KU46WW1zhFQyS7BIS0C5qs0hJGzbRwgZLNMBSHx/CTCNEDTgJqzAu 6w== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2wxn0wm22h-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 17 Dec 2019 14:07:12 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 17 Dec
 2019 14:06:47 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 17 Dec 2019 14:06:48 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 1AF4D3F703F;
        Tue, 17 Dec 2019 14:06:48 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xBHM6lVE028167;
        Tue, 17 Dec 2019 14:06:47 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xBHM6lXm028166;
        Tue, 17 Dec 2019 14:06:47 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 10/14] qla2xxx: Consolidate fabric scan
Date:   Tue, 17 Dec 2019 14:06:13 -0800
Message-ID: <20191217220617.28084-11-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20191217220617.28084-1-hmadhani@marvell.com>
References: <20191217220617.28084-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-17_04:2019-12-17,2019-12-17 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

consolidate scan for fabric loop and fabric topologies
into a single scan.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 77e54e7a31d6..4f849b12b546 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4939,12 +4939,8 @@ qla2x00_configure_loop(scsi_qla_host_t *vha)
 	qla2x00_get_data_rate(vha);
 
 	/* Determine what we need to do */
-	if (ha->current_topology == ISP_CFG_FL &&
-	    (test_bit(LOCAL_LOOP_UPDATE, &flags))) {
-
-		set_bit(RSCN_UPDATE, &flags);
-
-	} else if (ha->current_topology == ISP_CFG_F &&
+	if ((ha->current_topology == ISP_CFG_FL ||
+	    ha->current_topology == ISP_CFG_F) &&
 	    (test_bit(LOCAL_LOOP_UPDATE, &flags))) {
 
 		set_bit(RSCN_UPDATE, &flags);
-- 
2.12.0

