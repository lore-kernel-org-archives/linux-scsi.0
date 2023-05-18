Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEBD7C77B7A
	for <linux-scsi@archiver.kernel.org>; Thu, 18 May 2023 07:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjERH7H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 May 2023 03:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjERH67 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 May 2023 03:58:59 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7DE2698
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 00:58:58 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34HMFhQ6013340
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 00:58:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=jejcCBY6FRlisoQiYeM/TxMrGcPV2jORAsuufAnoIMI=;
 b=NMwJNLH3sWegmfdCejKSwyZ0i866kf4NEhLfuZbMuI6T9oOTN2B9QXn+sGTwj6jPjTEm
 W8wMlVOur+pB98VBlwNYwBmoYcYbqIZyTnLodtEKFfJ9XHaDy8iAH2V/AgfQjxyIQ20z
 DKM1FfVePeLUMQZngWptKbr76SOIjXY54/hX6zcTS6gRa4dSnLkIn6Spd8QBkVmoBMJb
 vBOt5DCKN8xF90zxo37/3e4Igvcg3Jv3eF+zgyNAi3u8bbh5oRECyFvQMmYee1xccStC
 wvPGK9Bv18GoSLZiQX4UltgcTIIsmwkdlEPqnuAkkhLHW85mYvL+SJ5diKnRNQl9MPMI 8g== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3qn7jb9rdy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 00:58:58 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 18 May
 2023 00:58:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 18 May 2023 00:58:56 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id 8C65E3F7066;
        Thu, 18 May 2023 00:58:54 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH 4/8] qla2xxx: klocwork - Check valid rport returned by fc_bsg_to_rport
Date:   Thu, 18 May 2023 13:28:37 +0530
Message-ID: <20230518075841.40363-5-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20230518075841.40363-1-njavali@marvell.com>
References: <20230518075841.40363-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: ZAsNYP67JlGcxk0-PBDP0rH-z2uIdmII
X-Proofpoint-ORIG-GUID: ZAsNYP67JlGcxk0-PBDP0rH-z2uIdmII
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-18_05,2023-05-17_02,2023-02-09_01
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

