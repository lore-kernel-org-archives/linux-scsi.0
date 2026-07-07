Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D713B27466A
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403755; cv=none; b=nVycJB3B1WJga5zAjfJTZf+Q37MLik2IZhnZPboeciocUAA1CDk05hLIULkAlDBBGaTz21Pd2fG5hQna2nEtZ2GqJdzlOhJEMLUvqmCU0cw58uEYvr3CkUgljPNdgQJa8SHGeoW+hY2fO6j+R7T/BrDgy6cxsk17h3UaW5FSYwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403755; c=relaxed/simple;
	bh=O5knRtT+d97oCfAoqril+LE95roCfgFhwer7GA3+d2k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sviN9caro7xbL6ig/F8JsgrZvGF9ErTTU1aSc+D8j2dNqyz5zOsPvn6LTo41VaivNDf197oau4bgYy8ayK9v1zvioU6LOGxi0M4zT+duNBmhCpDPop7R24UCFHEGbZDMV6szIQRkUbsk4fP/NrsqLxLXg7LVjsyYEmcULk1xPmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=dHLfxqdG; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="dHLfxqdG"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 667481ij872746;
	Mon, 6 Jul 2026 22:55:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=e
	2A8NhhoajjTOzRyvwUE8lXT41UBpCY22R46x4J7zlI=; b=dHLfxqdGDKpBNmmV+
	DTZmQuwGfcPda4X/gXTeRibRXAeSFmw+typXD52rLliOaXTAm8BG4WBD+P0IDbMJ
	ku9kMcDcOvxtkbbv3Xjt/Qij6Rcfwizy7/xCOeXWvRh26rc3wSn8pfmHbTu0iw+x
	+wxM2OQx3O2uL/B+CIGwJKjnIzC+I1Phyd0zhU+4I3THZLxuNZNVA/KqCAmFxTsG
	1VghAgwJyiwDyk9fA7m3Z2opbTU4G8srdcvtUBcg2Up/pO6dYeeQ0cNKLjCdHVWc
	Z9iYPs4UOh6OlO6seqBs5f5wgi+5zbVYkzIyjEUAWN0bydTPceDq5sanulj6zsGs
	fbCiQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f8f9waa18-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:55:51 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:55:50 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:55:50 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 118B23F7066;
	Mon,  6 Jul 2026 22:55:47 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 17/88] scsi: qla2xxx: Enable init_firmware mailbox for 29xx
Date: Tue, 7 Jul 2026 11:23:24 +0530
Message-ID: <20260707055435.2680300-18-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260707055435.2680300-1-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: fEfAagTyZstyn65-Y8FvTXwPk4NMRrO0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1MyBTYWx0ZWRfXyjHlhEoDEIWJ
 4g0wcQ0GbZ18v1py/jYNJiu/+Z//+Cwtt+CDE7OdkvNnjpidY0PxZ6vSNbHW08HMa8lUKZ/dsyQ
 p5v7bIgpT+bsqbWR/Jbe6VZl3Dn7xR4gd93ATqtMhFo0AI6ki2dAyIp5lurEmtAyBslu45FZd3W
 AV0AXahYxfbaaGz2Jiq63rSokGE+m7U/mBCxXf2BiFbrJd956L3RJgDz7YaksQ8Wg8b+2ToBGQh
 +jQ+gLqVPscYF0brPpTDWbrk+/A95TCv84H0bNBi1yGZLv7G3URwrVc7AIO22P8MNskHbGlnWuM
 UZzxqMBbE9nNckmWGx2tFdlcFwVE9j+3cAnoV4QtQNjJWaejdtqLIofGTGhUUxOMjNpLXE+ykJ8
 SP3ETNgnTnHqf/1tND2Zb7N2GzzkIZcBCchbXx6GVpE3CUoEUNvwLm9APKiVNgg2FqplJOxpCIA
 HcjK+v4KmAdRxMTzs2A==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1MyBTYWx0ZWRfX/vA9mtW/PbtJ
 XWVpJmK27qHv/EJCcAylve2pUFPWi9iyQ9nLFnUsjZsXp1hRvgSEzqiXHJh7mSBZRWj6xQS153P
 3IHCgfhQPV2VLwJY/lr43TkuwYjfj9U=
X-Proofpoint-GUID: fEfAagTyZstyn65-Y8FvTXwPk4NMRrO0
X-Authority-Analysis: v=2.4 cv=SY/HsPRu c=1 sm=1 tr=0 ts=6a4c94e7 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=D95N2Pj2omZygidu6DcA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

The init_firmware mailbox command needs 29xx adapter support for reading
back SFP information via mb3 and for validating SFP status on successful
firmware initialization. Add IS_QLA29XX() checks alongside the existing
27xx/28xx checks.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 3fc08120fdf1..9c78aa66e12b 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1968,7 +1968,7 @@ qla2x00_init_firmware(scsi_qla_host_t *vha, uint16_t size)
 
 	/* 1 and 2 should normally be captured. */
 	mcp->in_mb = MBX_2|MBX_1|MBX_0;
-	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
+	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha))
 		/* mb3 is additional info about the installed SFP. */
 		mcp->in_mb  |= MBX_3;
 	mcp->buf_size = size;
@@ -1992,7 +1992,7 @@ qla2x00_init_firmware(scsi_qla_host_t *vha, uint16_t size)
 			    0x0104d, ha->ex_init_cb, sizeof(*ha->ex_init_cb));
 		}
 	} else {
-		if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+		if (IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
 			if (mcp->mb[2] == 6 || mcp->mb[3] == 2)
 				ql_dbg(ql_dbg_mbx, vha, 0x119d,
 				    "Invalid SFP/Validation Failed\n");
-- 
2.47.3

