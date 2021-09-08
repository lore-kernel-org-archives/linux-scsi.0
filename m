Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9645C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 16:47:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A10DA61154
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 16:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352207AbhIHQst (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 12:48:49 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:24682 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1352343AbhIHQss (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 12:48:48 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1889U3wR031640;
        Wed, 8 Sep 2021 09:47:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Wd84xUG+p+IoRN7Ss7VgxUk+hkMwZ8pn7uW2UOhhbrU=;
 b=SXhlUH4RsLm7qfLps/R6uKCZAyFcsv37Cyx9IVyTdXSYCzyV0agCCdg8/CDCVPm0l58g
 R4nBztJ9WGSNC0MAxNrV334xdH9b0rsUw/na4RgmKYrg3KrE2x1b5rxtt8W8iOuCqYM5
 BTvfy9deBWuCe8TKCtp/ZIH0Pwl4BuNgj3ab0Rg/cVMPvInmsjjXUZ/kIJtgUjFDVo/O
 pnWOjjLJtK/AYLBKRTTHIpk8ZncKiglS3jjdXejyxFu07cfHAKvg6W7Sfjt9sQfsQG58
 45yRe6AGpGr+5TnZlx6Ar9ynUJWl+zUB3d6ipW4E/pw6XbcN4z4EERaMeaPGN7eJVXpS zA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3axtka9te9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 08 Sep 2021 09:47:37 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 8 Sep
 2021 09:47:36 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 8 Sep 2021 09:47:35 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 55CC83F70B1;
        Wed,  8 Sep 2021 09:47:35 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 188GlUF9019291;
        Wed, 8 Sep 2021 09:47:30 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 188GlPRP019290;
        Wed, 8 Sep 2021 09:47:25 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <djeffery@redhat.com>,
        <loberman@redhat.com>
Subject: [PATCH v2 02/10] qla2xxx: Display 16G only as supported speeds for 3830c card
Date:   Wed, 8 Sep 2021 09:46:14 -0700
Message-ID: <20210908164622.19240-3-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210908164622.19240-1-njavali@marvell.com>
References: <20210908164622.19240-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: Uak5czOQvY5jJ1KW6X--kfenJ26F7Orm
X-Proofpoint-ORIG-GUID: Uak5czOQvY5jJ1KW6X--kfenJ26F7Orm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-08_06,2021-09-07_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

This card is unique and doesn't support lower speeds, hence
update the fdmi field to display 16G only.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_gs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index ebc8fdb0b43d..28b574e20ef3 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1537,7 +1537,8 @@ qla25xx_fdmi_port_speed_capability(struct qla_hw_data *ha)
 	}
 	if (IS_QLA2031(ha)) {
 		if ((ha->pdev->subsystem_vendor == 0x103C) &&
-		    (ha->pdev->subsystem_device == 0x8002)) {
+		    ((ha->pdev->subsystem_device == 0x8002) ||
+		    (ha->pdev->subsystem_device == 0x8086))) {
 			speeds = FDMI_PORT_SPEED_16GB;
 		} else {
 			speeds = FDMI_PORT_SPEED_16GB|FDMI_PORT_SPEED_8GB|
-- 
2.19.0.rc0

