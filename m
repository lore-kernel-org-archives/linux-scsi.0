Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D90DEEB64DA
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 09:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233279AbjGLJHF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 05:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233226AbjGLJGR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 05:06:17 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F8F1FC7
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 02:05:59 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36C7Grvm029333
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 02:05:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=KS279KLLAZwyt27gA45jpEnh0IhyqGkiEl7vew/fMpU=;
 b=UD8akieKE5FoqGy93PQeN1veEXLFLk3jbhPPtbF71//mnALRqWJTrzTV0UNGEV2cg+4y
 hfgCvspcTzQrgJ8SDxMPWhtDI9TXesnPM9ucM5CsLWuK6uicNqjnkUdvP0O4Zhdxtogj
 UG5f8OWcQ1PNG5ipD3I8J9ZDbqVx2sAX12/oWVA1FmecCq5LLxZNHqC59kUHsrx33St3
 J+v3mbM1kZgow6Yt3wNeLqupYsRLpeeKCO10LOdhZN2bcZ8NSZqFy+v/q7T789krQumZ
 AIGXpcsehVWf46kfRcZw7o1KXi+QKmD3Z9zHFrYLWtiTNeFw0xGeMKlbam3palnzzHtJ fw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3rsb7rb0gv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 02:05:59 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 12 Jul
 2023 02:05:58 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Wed, 12 Jul 2023 02:05:57 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id 3521B3F7053;
        Wed, 12 Jul 2023 02:05:55 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH 09/10] qla2xxx: fix inconsistent TMF timeout
Date:   Wed, 12 Jul 2023 14:35:34 +0530
Message-ID: <20230712090535.34894-10-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20230712090535.34894-1-njavali@marvell.com>
References: <20230712090535.34894-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: hdjtAd6_fOjrNeOHSEYSs9oTGT1s3nDy
X-Proofpoint-ORIG-GUID: hdjtAd6_fOjrNeOHSEYSs9oTGT1s3nDy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-12_06,2023-07-11_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Different behavior were experienced of session being
torn down vs not, when TMF is timed out. When FW detects
the time out, the session is torn down.  When driver detects
the time out, the session is not torn down.

Allow TMF error to return to upper layer without session
tear down.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index eb8480a0d7b0..aba39127474a 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2543,7 +2543,6 @@ qla24xx_tm_iocb_entry(scsi_qla_host_t *vha, struct req_que *req, void *tsk)
 	case CS_PORT_BUSY:
 	case CS_INCOMPLETE:
 	case CS_PORT_UNAVAILABLE:
-	case CS_TIMEOUT:
 	case CS_RESET:
 		if (atomic_read(&fcport->state) == FCS_ONLINE) {
 			ql_dbg(ql_dbg_disc, fcport->vha, 0x3021,
-- 
2.23.1

