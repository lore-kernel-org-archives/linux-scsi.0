Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7A5181330
	for <linux-scsi@vger.kernel.org>; Tue, 18 Jun 2024 13:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718717901; cv=none; b=G06v/ISS93tJia2OSljqlLHF0cAeW+7kDOpNccTI9q1ltdTG/oUSon7wnDZO5icGvUBVXJORKniibUfKOZMUx5Pa7AtSMIZHCvIBaoH3F0+lpT0UZ+XVBIRX+XE7cYCZBIQWdsCvFW4GSE5iLtyPY3MRytxvVrdDuQxdlsOiQm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718717901; c=relaxed/simple;
	bh=I8NYEZP478eRyfSnsIk+tkTEbyMes8rWaNdKYx54fBo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EYjSHTLjwc6OAg7+jWqIDXhkHdJ3Jjv4dskxKkpyLNvg9MuxqcfrQpa+3f3R0qaADvx37TtlHTsG7efvNo3dyEMCFEUs6gXtYlRoea7Fzq26xhO/vqFpfa8kZmltsNcvATaazux/F9ved6fzcFugNuckFBSI+8gkA7Je/k1WPKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=kZ3AIsgI; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="kZ3AIsgI"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45IBgQBw015588;
	Tue, 18 Jun 2024 06:38:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=6
	PSLyPcmGEf03d8/zgN4e0TWBH8MGEdCGpuxTeniPVg=; b=kZ3AIsgIar2iS9noA
	8dwBM9pm2zGfNs7TzoInUCSw/WIq/eB+i1UCHBaBzuQVqoOmVPNqp4AL1O3mSz3c
	GjJCob0ePAjx5zDaQzGp+TIXZ0zHvoJALWouPcp5CtkcNlb8lQp0zezbtm0Op7eE
	u/u0ZdAZvKoR2fMOVjc6JtawmQdkLj98sYf3/Mwbdtl9V0dVs9PHFTsLs1L7Re2m
	zCvBKKvLzXiI7UVY6p+wer8u7wDnilcI8Mgn4I4ASoiO4OQTeE+XAzkcY1KrqsgU
	bSreInIcrfxKqNh6JIMsBCVm13Nu4BoFZCs6r28Cr94KluWdtyskN/gjvmQhcw1C
	amxwQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3yu0nwt3pv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Jun 2024 06:38:17 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 18 Jun 2024 06:38:15 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Tue, 18 Jun 2024 06:38:15 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 653223F706D;
	Tue, 18 Jun 2024 06:38:13 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 08/11] qla2xxx: Fix optrom version displayed in FDMI
Date: Tue, 18 Jun 2024 19:07:36 +0530
Message-ID: <20240618133739.35456-9-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240618133739.35456-1-njavali@marvell.com>
References: <20240618133739.35456-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: hHJW9Smoi2nMkZeFq9LAOQiT41deyIwS
X-Proofpoint-ORIG-GUID: hHJW9Smoi2nMkZeFq9LAOQiT41deyIwS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-18_02,2024-06-17_01,2024-05-17_01

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

