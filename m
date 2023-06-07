Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0833EC77B7A
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 11:39:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240350AbjFGLjB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 07:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239248AbjFGLi6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 07:38:58 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0911730
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jun 2023 04:38:56 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 357BJ4p1031514
        for <linux-scsi@vger.kernel.org>; Wed, 7 Jun 2023 04:38:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=5nkASTIqk8AB/F341bpDn9STBvBqOPhEuLTK1T0HABQ=;
 b=HCqkOmQlrh5ZkQe+jcHpPSLuYRVnvECqUQQpBtpJ97wYZsS2KakSc3lk7kWCgeopRU0N
 fS9hF3S2zXf8a8Ndhn8ZlO/JWXTyyuZhD0DGdFA7o+KoeHLK7UcDRvJBfsOYpU2vtTeH
 pPPh+uufRQrNVSyG0Fo+CrDZBf0h9T41B+hyE9nI5223iwda8nnq8OB9JfYrruYotE2j
 s8UvxkOOV+R1fNXqkr0YSdwVBsz3p8IkqPLyxY0RTzmdiGruq6zR6savTWK+GXTATWF+
 YBZuhR0K0qEnRBYaZaOA18+R9J+/7zsSmKfRvppGZPv0yFq4tTxeTD4pW+2fwkaSkOrc Yg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3r2a75aff0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jun 2023 04:38:56 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 7 Jun
 2023 04:38:53 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Wed, 7 Jun 2023 04:38:53 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id 17D2E3F7045;
        Wed,  7 Jun 2023 04:38:51 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH v2 3/8] qla2xxx: klocwork - avoid fcport pointer dereference
Date:   Wed, 7 Jun 2023 17:08:38 +0530
Message-ID: <20230607113843.37185-4-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20230607113843.37185-1-njavali@marvell.com>
References: <20230607113843.37185-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: DLw3fLAuA6rHX7KhGx_CS1aFAC9Gjql-
X-Proofpoint-GUID: DLw3fLAuA6rHX7KhGx_CS1aFAC9Gjql-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_06,2023-06-07_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Klocwork reported warning of null pointer may be dereferenced.
The routine exits when sa_ctl is NULL and fcport is allocated after
the exit call thus causing NULL fcport pointer to dereference at the
time of exit.

To avoid fcport pointer dereference, exit the routine when
sa_ctl is NULL.

Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
v2:
- Exit the routine if sa_ctl is NULL.

 drivers/scsi/qla2xxx/qla_edif.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index ec0e20255bd3..26e6b3e3af43 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -2361,8 +2361,8 @@ qla24xx_issue_sa_replace_iocb(scsi_qla_host_t *vha, struct qla_work_evt *e)
 	if (!sa_ctl) {
 		ql_dbg(ql_dbg_edif, vha, 0x70e6,
 		    "sa_ctl allocation failed\n");
-		rval =  -ENOMEM;
-		goto done;
+		rval = -ENOMEM;
+		return rval;
 	}
 
 	fcport = sa_ctl->fcport;
-- 
2.23.1

