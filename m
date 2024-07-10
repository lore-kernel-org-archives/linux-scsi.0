Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85127194A59
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jul 2024 17:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720631499; cv=none; b=uQBMwRE/Sv8tU//wDr+1L/h9ugJP6ADr2UJdYPVaXLcR5t/PLcUUGgaXd50N0mbWGvAW3aF7nsrvoNwg4uCJNIrhgfMyapui+wsrC597M+Kk3ignap5aBbBqx1FdCG1G5+6PlsHrelSkrvilcJmx3++JgzoUGio8u/nmA0ZbAdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720631499; c=relaxed/simple;
	bh=I8NYEZP478eRyfSnsIk+tkTEbyMes8rWaNdKYx54fBo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JMa/na3cOx2DyH9HOAyBNXwRVAFwH9A4BHYWBQR1pEGq8EIlObMBdeT0e7kSIxazv+ULSkcYSWShMhUWs7tclvzwcIaOQZjzkSXwWVXq0DvvQ87n9RFsY+9kmaSvXDiWFIUbRn31W6hjHoh5uXRNspKBtRj1XcDFW26oDRTEx3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=B6XGmTsL; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="B6XGmTsL"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46AGD31F017251;
	Wed, 10 Jul 2024 10:11:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=6
	PSLyPcmGEf03d8/zgN4e0TWBH8MGEdCGpuxTeniPVg=; b=B6XGmTsLA3dP45Qti
	UXs+u1K9xkJVDvPy81vmJR20fU7/KfxclSEZo6Sp2sSoBfJJbP1e/AwVDy7pDEDs
	PjTwl6MczMO8s5AzN6iXRr8+FODWzjCCMWT3pQjzADoNRz+bXWJS/5df9vQzmQ6F
	1vPgWgTW8L4Gc6wlVLqvE0ExeGvlb5uB93Uq8sQ3XH591cYyJyqatUKlacXcNJAq
	1AmSmh3vj45QZ+qPiwG5/qqGWuLHjlF3JWotIEcKZP7DEhK1ZlHAEA4zTeduWqFO
	gYg/tw9Rwmu4d3cFWhKFoB4o5Gy6JERjD/DFVDEYDsmHYxnOiPwixKjmRgOTwvTa
	6EWcQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 409wmd8axq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jul 2024 10:11:36 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 10 Jul 2024 10:11:34 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 10 Jul 2024 10:11:34 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 1EBD53F708F;
	Wed, 10 Jul 2024 10:11:31 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v2 08/11] qla2xxx: Fix optrom version displayed in FDMI
Date: Wed, 10 Jul 2024 22:40:54 +0530
Message-ID: <20240710171057.35066-9-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240710171057.35066-1-njavali@marvell.com>
References: <20240710171057.35066-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: ASsz1IMcyGiXUhD9dbIZn8Wpm8UFNYk8
X-Proofpoint-ORIG-GUID: ASsz1IMcyGiXUhD9dbIZn8Wpm8UFNYk8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-10_12,2024-07-10_01,2024-05-17_01

From: Shreyas Deodhar <sdeodhar@marvell.com>

Bios version was popluated for FDMI response. Systems with EFI
would show optrom version as 0.
EFI version is populated here and BIOS version is already displayed
under FDMI_HBA_BOOT_BIOS_NAME.

Cc: stable@vger.kernel.org
Signed-off-by: Shreyas Deodhar<sdeodhar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_gs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index e801cd9e2345..caa9a3cd2580 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1710,7 +1710,7 @@ qla2x00_hba_attributes(scsi_qla_host_t *vha, void *entries,
 	eiter->type = cpu_to_be16(FDMI_HBA_OPTION_ROM_VERSION);
 	alen = scnprintf(
 		eiter->a.orom_version, sizeof(eiter->a.orom_version),
-		"%d.%02d", ha->bios_revision[1], ha->bios_revision[0]);
+		"%d.%02d", ha->efi_revision[1], ha->efi_revision[0]);
 	alen += FDMI_ATTR_ALIGNMENT(alen);
 	alen += FDMI_ATTR_TYPELEN(eiter);
 	eiter->len = cpu_to_be16(alen);
-- 
2.23.1

