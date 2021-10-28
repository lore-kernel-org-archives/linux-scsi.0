Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2B30C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 03:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3B4160EBD
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 03:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhJ1Dob (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 23:44:31 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:65102 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229704AbhJ1Dob (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 23:44:31 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19S3ZpNK027063
        for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2021 03:42:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2021-07-09; bh=3D157uS4gI0Bz2Mx7stR/HCsqSH7HRhhAnwEoYuMkrg=;
 b=bHfBKw0u4yOJ+H4kA950PgO0tkjofF93f9EtfI2ESro0UmWVxY1gbEbsjyQGbBLcb+zy
 JpnWywRLBNqaXr3JeZsdbCbp3BU5Kuz4qMzK3oL9c2NbSg43ZoLTl+rRbG2NOTESJm0o
 EmQZSY8BqffUZLoXRgXqRk3ziE5Tdr9vZFqUjIwuQJcZINbwtNuMWS19Jud6UIrUQqhN
 YrLQ4Rbaw88Z4T7OPOQBp0ak4wIwaY7eKOpV1WkJB8iFxPE2uARTKoDyiGn0K6lPSBLI
 v7yxZKGh3dQXlk/XXSQ8Rs0yemCZcYGo4hXSeTBag6+dRoMnW84s9m/tyjnWSW/QPmyP /g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3byedagy34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2021 03:42:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19S3Zas7193265
        for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2021 03:42:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3bx4gdpetw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2021 03:42:03 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19S3g3qN013445
        for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2021 03:42:03 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3bx4gdpesc-1;
        Thu, 28 Oct 2021 03:42:03 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: mpt3sas: Fix reference tag handling for WRITE_INSERT
Date:   Wed, 27 Oct 2021 23:42:02 -0400
Message-Id: <20211028034202.24225-1-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: JXpemLnfQHgjsgWJhGt00AkHoIdhfRUj
X-Proofpoint-GUID: JXpemLnfQHgjsgWJhGt00AkHoIdhfRUj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Testing revealed a problem with how the reference tag was handled for
a WRITE_INSERT operation. The SCSI_PROT_REF_CHECK flag is not set when
the controller is asked to generate the protection information
(i.e. not DIX). And as a result the initial reference tag would not be
set in the WRITE_INSERT case.

Separate handling of the REF_CHECK and REF_INCREMENT flags to align
with both the DIX spec and the MPI implementation.

Fixes: b3e2c72af1d5 ("scsi: mpt3sas: Use the proper SCSI midlayer interfaces for PI")
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 344c4322480e..cee7170beae8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -5065,9 +5065,12 @@ _scsih_setup_eedp(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 	if (scmd->prot_flags & SCSI_PROT_GUARD_CHECK)
 		eedp_flags |= MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD;
 
-	if (scmd->prot_flags & SCSI_PROT_REF_CHECK) {
-		eedp_flags |= MPI2_SCSIIO_EEDPFLAGS_INC_PRI_REFTAG |
-			MPI2_SCSIIO_EEDPFLAGS_CHECK_REFTAG;
+	if (scmd->prot_flags & SCSI_PROT_REF_CHECK)
+		eedp_flags |= MPI2_SCSIIO_EEDPFLAGS_CHECK_REFTAG;
+
+	if (scmd->prot_flags & SCSI_PROT_REF_INCREMENT) {
+		eedp_flags |= MPI2_SCSIIO_EEDPFLAGS_INC_PRI_REFTAG;
+
 		mpi_request->CDB.EEDP32.PrimaryReferenceTag =
 			cpu_to_be32(scsi_prot_ref_tag(scmd));
 	}
-- 
2.32.0

