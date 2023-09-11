Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35E6EEE3F01
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 20:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237480AbjIKUvc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 16:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243296AbjIKREB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 13:04:01 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5525D127
        for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2023 10:03:57 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38BGBSOR014108
        for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2023 10:03:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=IOfpg9M/fCGwTTFuxVnywFTA6v0U0gh5rH/kKV1P8s4=;
 b=SXRxde8T4J0/rydpEZ6UouKmXXw5uba0hD9rTxnMjfmQo4s0SOZuZJgiT8nlZckioOO4
 TKT5IiMUQKZ28Mz+FPlO5zqLyaRfprL1T3/EgWNmDxBVCQhDv0cuXy6K7UK1INDoFyXX
 H41NIdmqG0PW6ku3SIKg4JnQ6E9PxhthzGDmpbZd+bLjHyZCfuPdjB/0Lv8d57eZ5tZ6
 jnZohuGOoNefPWqSARrGKjToulvwdwwZRBIMIWpa87AwX1e9nPMr+zv1aMM5Pd1Rwp+7
 GFY8oeSx9KadoWee2tNPFhvYbG1CbLdvmx0UEq4pC+1Z6ZC5rD/AlHleD42uQotI0od5 QA== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3t21k6k5ep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2023 10:03:57 -0700
Received: from twshared8019.08.ash9.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 11 Sep 2023 10:03:55 -0700
Received: by devvm715.rva0.facebook.com (Postfix, from userid 240176)
        id 84487292AEF67; Mon, 11 Sep 2023 10:03:46 -0700 (PDT)
From:   Michal Grzedzicki <mge@meta.com>
To:     Michal Grzedzicki <mge@meta.com>
CC:     <jinpu.wang@cloud.ionos.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] pm80xx: Use phy specific sas address when sending PHY_START command
Date:   Mon, 11 Sep 2023 10:03:39 -0700
Message-ID: <20230911170340.699533-1-mge@meta.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: fAge_Qm95GqQ-tv0ADr9mDOJ9ipbczI5
X-Proofpoint-ORIG-GUID: fAge_Qm95GqQ-tv0ADr9mDOJ9ipbczI5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-11_12,2023-09-05_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some cards have more than one sas addresses. Using incorrect
address causes communication issues with some devices like expanders.

Signed-off-by: Michal Grzedzicki <mge@meta.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index 33053db5a713..90069c7b1642 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4180,7 +4180,7 @@ pm8001_chip_phy_start_req(struct pm8001_hba_info *p=
m8001_ha, u8 phy_id)
 	payload.sas_identify.dev_type =3D SAS_END_DEVICE;
 	payload.sas_identify.initiator_bits =3D SAS_PROTOCOL_ALL;
 	memcpy(payload.sas_identify.sas_addr,
-		pm8001_ha->sas_addr, SAS_ADDR_SIZE);
+		&pm8001_ha->phy[phy_id].dev_sas_addr, SAS_ADDR_SIZE);
 	payload.sas_identify.phy_id =3D phy_id;
=20
 	return pm8001_mpi_build_cmd(pm8001_ha, 0, opcode, &payload,
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index f6857632dc7c..1b2c40b1381c 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4671,7 +4671,7 @@ pm80xx_chip_phy_start_req(struct pm8001_hba_info *p=
m8001_ha, u8 phy_id)
 	payload.sas_identify.dev_type =3D SAS_END_DEVICE;
 	payload.sas_identify.initiator_bits =3D SAS_PROTOCOL_ALL;
 	memcpy(payload.sas_identify.sas_addr,
-	  &pm8001_ha->sas_addr, SAS_ADDR_SIZE);
+		&pm8001_ha->phy[phy_id].dev_sas_addr, SAS_ADDR_SIZE);
 	payload.sas_identify.phy_id =3D phy_id;
=20
 	return pm8001_mpi_build_cmd(pm8001_ha, 0, opcode, &payload,
--=20
2.34.1

