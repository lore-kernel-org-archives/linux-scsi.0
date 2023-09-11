Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69819EE3F00
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 20:51:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236197AbjIKUvM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 16:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243294AbjIKRD6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 13:03:58 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E893127
        for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2023 10:03:54 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38BGBJ1L013538
        for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2023 10:03:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=V3jmQO6lm/Fik2gbNmDLJuXzSPZHZ8U9ZHR6J/IYPsk=;
 b=W5faw5A/XAF2wiYgzjERaokzBiqIBkPSszG4K8s8IdXSqNeR3ld19iet1Su9UfSC0keZ
 Xm0VSLzeQCuKsLZfLo99sYjuCpxySLDgoDIEtTsBNdP1TaIZbTNoBL/BE0FjF26WHt8D
 7FKNqwTbzo0ApuljFhrN7kU0DOrfua8Pq9JkuVo3BGW/1sirJbKx2apFKumhBRGJAJ7w
 izYng4ZtJ4fSTKBda3/kwlVzPQSVqeSJ2AAubPWTIJR/Onv3rE6vybgv2Nat/uXMgXPj
 NQ9ekI/ZMOgRqGXIZb9X5N2xYTPGAawr1frvJ6mTxUKR47QO5NOQmq7BA3dt+bfmErJY Pw== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3t21ju33qv-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2023 10:03:53 -0700
Received: from twshared2388.07.ash9.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 11 Sep 2023 10:03:52 -0700
Received: by devvm715.rva0.facebook.com (Postfix, from userid 240176)
        id 04794292AEF84; Mon, 11 Sep 2023 10:03:48 -0700 (PDT)
From:   Michal Grzedzicki <mge@meta.com>
To:     Michal Grzedzicki <mge@meta.com>
CC:     <jinpu.wang@cloud.ionos.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] pm80xx: Avoid leaking tags when processing OPC_INB_SET_CONTROLLER_CONFIG command
Date:   Mon, 11 Sep 2023 10:03:40 -0700
Message-ID: <20230911170340.699533-2-mge@meta.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230911170340.699533-1-mge@meta.com>
References: <20230911170340.699533-1-mge@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Q5VFq9h5Rd-GomgehAfRO9ZHoktTVN-N
X-Proofpoint-GUID: Q5VFq9h5Rd-GomgehAfRO9ZHoktTVN-N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-11_12,2023-09-05_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Tags allocated for OPC_INB_SET_CONTROLLER_CONFIG command need to be freed
when we receive the response.

Signed-off-by: Michal Grzedzicki <mge@meta.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index 1b2c40b1381c..3afd9443c425 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3671,10 +3671,12 @@ static int mpi_set_controller_config_resp(struct =
pm8001_hba_info *pm8001_ha,
 			(struct set_ctrl_cfg_resp *)(piomb + 4);
 	u32 status =3D le32_to_cpu(pPayload->status);
 	u32 err_qlfr_pgcd =3D le32_to_cpu(pPayload->err_qlfr_pgcd);
+	u32 tag =3D le32_to_cpu(pPayload->tag);
=20
 	pm8001_dbg(pm8001_ha, MSG,
 		   "SET CONTROLLER RESP: status 0x%x qlfr_pgcd 0x%x\n",
 		   status, err_qlfr_pgcd);
+	pm8001_tag_free(pm8001_ha, tag);
=20
 	return 0;
 }
--=20
2.34.1

