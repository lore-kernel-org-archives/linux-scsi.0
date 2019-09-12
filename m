Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD5F8C4CEC5
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 15:20:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2FEA2081B
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 15:20:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="HqSyUNw2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733034AbfILPUN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Sep 2019 11:20:13 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:34536 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732699AbfILPUN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Sep 2019 11:20:13 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8CFFK5C029086;
        Thu, 12 Sep 2019 08:20:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=WRtbKm8J0uekj9KkiUqJoFEDXEFdAz6ncYByKPeWGK0=;
 b=HqSyUNw2kWIoAe2+c77wplyfzPKZknlHAjvi/GpPoaVDGjxAtsiTawK8vRQDP09PMyXv
 tQBzCJ2hYrKARnygBk6m7mMu8nGrq3B5qeqpgPZPOEx44JFb3xcDqhkjOVkhRTUoUEQN
 t/WGuyAdDae8l7Z98EaiNZc9dC5t9oc6qTwZjjtpAjPl3yasr5RdjWT8pXJJ2nLbCfox
 XInS5IroKgGhwQDpM+ShygNo5BLjXR87CJnBj5fjXRFr3zwqQur8qeh7CRQa+caOSRzq
 Q4eP26r21yLAViRFlJaebGJYeEI1tUbr7Glk1KZyvpRWTBEcoAe4GrR3L4l3fsPAkvbg Aw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2uxshkfynf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 12 Sep 2019 08:20:11 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 12 Sep
 2019 08:20:10 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Thu, 12 Sep 2019 08:20:10 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 347073F7040;
        Thu, 12 Sep 2019 08:20:10 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x8CFKA4C002589;
        Thu, 12 Sep 2019 08:20:10 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x8CFKADk002588;
        Thu, 12 Sep 2019 08:20:10 -0700
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 07/14] qla2xxx: Fix Nport ID display value
Date:   Thu, 12 Sep 2019 08:19:42 -0700
Message-ID: <20190912151949.2348-8-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190912151949.2348-1-hmadhani@marvell.com>
References: <20190912151949.2348-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-12_08:2019-09-11,2019-09-12 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

For N2N, the NPort ID is assigned by driver in the PLOGI ELS.
According to FW Spec the byte order for SID is not the same as
DID.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 1886de92034c..5c279449ca1c 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2696,9 +2696,10 @@ qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 	els_iocb->port_id[0] = sp->fcport->d_id.b.al_pa;
 	els_iocb->port_id[1] = sp->fcport->d_id.b.area;
 	els_iocb->port_id[2] = sp->fcport->d_id.b.domain;
-	els_iocb->s_id[0] = vha->d_id.b.al_pa;
-	els_iocb->s_id[1] = vha->d_id.b.area;
-	els_iocb->s_id[2] = vha->d_id.b.domain;
+	/* For SID the byte order is different than DID */
+	els_iocb->s_id[1] = vha->d_id.b.al_pa;
+	els_iocb->s_id[2] = vha->d_id.b.area;
+	els_iocb->s_id[0] = vha->d_id.b.domain;
 	els_iocb->control_flags = 0;
 
 	if (elsio->u.els_logo.els_cmd == ELS_DCMD_PLOGI) {
-- 
2.12.0

