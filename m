Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39398C7EE2E
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 11:39:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240096AbjFGLjE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 07:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240074AbjFGLjA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 07:39:00 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4293E19BD
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jun 2023 04:38:59 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 357BJ2oP031500
        for <linux-scsi@vger.kernel.org>; Wed, 7 Jun 2023 04:38:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=jejcCBY6FRlisoQiYeM/TxMrGcPV2jORAsuufAnoIMI=;
 b=MIt7fOEg0fS2+r3yHLOQe0mO10VXmYJsdiK7ewoyBD58M4rE7CBuJ4PQFUapE7UMKPJk
 Hr3L4oHZb24LpQ2VBWOCa+zcawpNY+hlf44pkn83BprXtR+UFfQxxkwLTTnI5s/pr2E/
 hvwYbdICmikOZ23gMs7Kqp3ruU75FVO9z6KaSkI81Jn+ooKZk/9BTPXkBfV5O7vd77F6
 i2LRTdEdTdb2SJY3abjCRuHfMDKQp68RcrIeeJsmMHbtTRLEK+i70knhyjui2/QEWaFj
 coRhguelASKocB2WDAAwecacIM3L7A8Ys4E8deZVAwZCT7WhoOTCnE7/vL9C+KYcak7f zQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3r2a75aff2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jun 2023 04:38:58 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 7 Jun
 2023 04:38:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Wed, 7 Jun 2023 04:38:56 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id 581383F706F;
        Wed,  7 Jun 2023 04:38:54 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH v2 4/8] qla2xxx: klocwork - Check valid rport returned by fc_bsg_to_rport
Date:   Wed, 7 Jun 2023 17:08:39 +0530
Message-ID: <20230607113843.37185-5-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20230607113843.37185-1-njavali@marvell.com>
References: <20230607113843.37185-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: OMJ9pFwEWx5nohehg8SOxapPygAACU7b
X-Proofpoint-GUID: OMJ9pFwEWx5nohehg8SOxapPygAACU7b
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_06,2023-06-07_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Klocwork reported warning of rport maybe NULL
and will be dereferenced.
rport returned by call to fc_bsg_to_rport could
be NULL and dereferenced.

Check valid rport returned by fc_bsg_to_rport.

Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index dba7bba788d7..c928b27061a9 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -283,6 +283,10 @@ qla2x00_process_els(struct bsg_job *bsg_job)
 
 	if (bsg_request->msgcode == FC_BSG_RPT_ELS) {
 		rport = fc_bsg_to_rport(bsg_job);
+		if (!rport) {
+			rval = -ENOMEM;
+			goto done;
+		}
 		fcport = *(fc_port_t **) rport->dd_data;
 		host = rport_to_shost(rport);
 		vha = shost_priv(host);
-- 
2.23.1

