Return-Path: <SRS0=JIM3=DF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C2E3C2D0A8
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 05:51:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32577207E8
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 05:51:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="hgOu47YS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgI1FvO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Sep 2020 01:51:14 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:37908 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725308AbgI1FvN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Sep 2020 01:51:13 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08S5pCKU007923
        for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2020 22:51:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=y7pofbHXrH6BAB6LGph4lxdTXIJe5OCGfyLRcKH0hHE=;
 b=hgOu47YSO1hv9oUqeC2ov90+rPxHJTdMwnbBFfJ+1DJv3P5r8YD6UriRMLXvcv7kQXPH
 akoakTG7kLUdhWpChHoDzk8I6H+7Ztr6zHYgYETYXp3IZGpiylrRdZJCXhPC/BKbpVeW
 jDHTf/h08UWmMTMpf38VmTI1/yVCcO+JbMmJDva1jj0FDz15vArjZuP+OLzEhI3+JNqo
 dLNKkw0XyftWjdhtr1jvT7Tex0j2XAUXfKb/823qymZsPQATKmcgNEkkj8agKrgTg2ss
 6piNsjOdoj0WBxHymxOrRuyIcyFhDflmTziaLozRnJp0+qVHpupgCoIxVnvV09TNOxvA Sg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 33teem5sdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2020 22:51:13 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 27 Sep
 2020 22:51:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 27 Sep 2020 22:51:12 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 0533A3F703F;
        Sun, 27 Sep 2020 22:51:11 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 08S5pBcj003997;
        Sun, 27 Sep 2020 22:51:11 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 08S5pBL3003996;
        Sun, 27 Sep 2020 22:51:11 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 1/7] qla2xxx: Correct the check for sscanf return value
Date:   Sun, 27 Sep 2020 22:50:17 -0700
Message-ID: <20200928055023.3950-2-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200928055023.3950-1-njavali@marvell.com>
References: <20200928055023.3950-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-28_05:2020-09-24,2020-09-28 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

Since the version string is modified sscanf returns 4 instead of 6.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_tmpl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index 8dc82cfd38b2..591df89a4d13 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -906,8 +906,8 @@ qla27xx_driver_info(struct qla27xx_fwdt_template *tmp)
 	uint8_t v[] = { 0, 0, 0, 0, 0, 0 };
 
 	WARN_ON_ONCE(sscanf(qla2x00_version_str,
-			    "%hhu.%hhu.%hhu.%hhu.%hhu.%hhu",
-			    v+0, v+1, v+2, v+3, v+4, v+5) != 6);
+			    "%hhu.%hhu.%hhu.%hhu",
+			    v + 0, v + 1, v + 2, v + 3) != 4);
 
 	tmp->driver_info[0] = cpu_to_le32(
 		v[3] << 24 | v[2] << 16 | v[1] << 8 | v[0]);
-- 
2.19.0.rc0

