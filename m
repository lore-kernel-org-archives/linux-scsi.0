Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8782AC77B7A
	for <linux-scsi@archiver.kernel.org>; Thu, 18 May 2023 07:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjERH66 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 May 2023 03:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjERH64 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 May 2023 03:58:56 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CACA2693
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 00:58:56 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34HMFcTR013246
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 00:58:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=lyBGX0REEjHE8IqNlfVSKXXkCsxidg4NnY59Bbd49Lw=;
 b=ecYXybqUQTaG45+fh3e1qwLEiuD0Ifs/O/NWiILdCexa2WV8kC6HxQSEmlkBxYmI0R56
 Qnun+dCTTOagixE3HfIAZ7oEsEQfGaHILuQjoyaQTD/YB5PhOV70Vh+NepAg1/WG9o3p
 T/eOZTkCJ0ky1LX/bMt9ujK7J4DrgyiB/eMmahoGGXUP8wUD96lQ1UAybqbgsZhslFuN
 ZqAhVezHP3LQIaihKndR/ZxnPAbpFXZexVxzQnZFTbNKWtpW5vEKVBpe4L4W9cKGJebe
 dwMUjHuoZeivVLW4iKA8KT8YoTXev3FrYAKuh4qm0JPTvyCg4hodfILDdHcsCHIkDkjS yQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3qn7jb9rdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 00:58:55 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 18 May
 2023 00:58:54 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 18 May 2023 00:58:53 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id ECD0C3F7065;
        Thu, 18 May 2023 00:58:51 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH 3/8] qla2xxx: klocwork - Check for a valid fcport pointer
Date:   Thu, 18 May 2023 13:28:36 +0530
Message-ID: <20230518075841.40363-4-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20230518075841.40363-1-njavali@marvell.com>
References: <20230518075841.40363-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: tC8RDm_awYk0k9UNaCo7Dr-ZnUxyaF15
X-Proofpoint-ORIG-GUID: tC8RDm_awYk0k9UNaCo7Dr-ZnUxyaF15
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-18_05,2023-05-17_02,2023-02-09_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Klocwork reported warning of null pointer may be dereferenced.
The routine exits when sa_ctl is NULL and fcport is allocated after
the exit call thus causing NULL fcport pointer to dereference at the
time of exit.

Add a check for a valid fcport pointer at the time of exit.

Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_edif.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index ec0e20255bd3..14e314c12dd6 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -2411,7 +2411,8 @@ qla24xx_issue_sa_replace_iocb(scsi_qla_host_t *vha, struct qla_work_evt *e)
 	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	fcport->flags &= ~FCF_ASYNC_SENT;
 done:
-	fcport->flags &= ~FCF_ASYNC_ACTIVE;
+	if (fcport)
+		fcport->flags &= ~FCF_ASYNC_ACTIVE;
 	return rval;
 }
 
-- 
2.23.1

