Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB7136E48E
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 10:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780309819; cv=none; b=hadyH4YkaHLCLCiRxCDHMEwClIgtIFJD+A2PxfOl/tiPbzMylxtOIm5lUKZWoTOXWfkbX1GNXGkUHDIses5Kdf3O3IQRdGzCSiPgb1E7C7e3m0fOE6zqHR8A7ktoJRl88by9BiVoD0E9DV/OnhqiZuLUexIbOLrvvkyQ9TgknBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780309819; c=relaxed/simple;
	bh=XvxCZdbHAG9baIW4oqLiulh3gGKzi+y4Qayx1XjzpQA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BznOsqZ6BWhmJ0pgIq+sPs7XMtRWJ3DabVsmLQgJHqtjcm30hL040fIuNdQspb3vnP9g3bTnqx3vn9owRZ3R7fBzL6UueZoL/r/QgxRSd9M/gH5tLcNyGVWWtCzf30jHIeW4+JxH4PtPFfHJBrnF1OcKH3Qb7nwawPnjpGdrljw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=JMMjjAqM; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="JMMjjAqM"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64VNFGG52822621;
	Mon, 1 Jun 2026 03:30:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=v
	e0ZW2w8OJb1gsgBJ7qPOUy3d494zDPcZFpbxxqi8bQ=; b=JMMjjAqMD8mi6CmNN
	syJYnclihz9eTgTz7St++FXnlEpVr/SAo9Kk2BR99iT6oX1Kgg5pAIX7RJnM3koc
	EVllmNR8DgNKYH0WIhMmX5EFYmkHk+JEJSPqrOujPFTj5iO1nZ4ia6vwbsu+dhN4
	2NpzIWZ3YAKfZ/YXoKVcua7bQwDBk2l7YdxRv/vX8gahYrFZfokEclhSLGJLHGIC
	Nct/8fG9Jgt8z8YipxYE7Wkmf0xAh/AoM9VuOd9z1bcyY5R/bj/qLfqZXl7iIEop
	Kj2Nc+BhwsEsWkkSLrWwvmVjNmvtnZNWMeJjz/XaJuGF4TlTbtalrcYuyFphi+fs
	WNqiA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4egm56jyd4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 03:30:14 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Jun 2026 03:30:14 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Jun 2026 03:30:14 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id B78B33F705A;
	Mon,  1 Jun 2026 03:30:11 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 19/44] scsi: qla2xxx: Enable init_firmware mailbox for 29xx
Date: Mon, 1 Jun 2026 15:58:28 +0530
Message-ID: <20260601102853.328426-20-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260601102853.328426-1-njavali@marvell.com>
References: <20260601102853.328426-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: _yh5sf5ItUJppmso4s4Sd-KeVKYzznQj
X-Proofpoint-ORIG-GUID: _yh5sf5ItUJppmso4s4Sd-KeVKYzznQj
X-Authority-Analysis: v=2.4 cv=ZeYt8MVA c=1 sm=1 tr=0 ts=6a1d5f36 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=w4u3DM5DpjbWQMeeTYQA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDEwNSBTYWx0ZWRfX/eSydH8v87HK
 LLJxtR+SN2bMHZBW1+IrdzsvRF5QBFXhF0f1c2XSX075Wx3KLJ2FMd7l5NIQPWCr9cKt76H7Wcy
 f679RxIelo1KhOspELSpwNLD6J5ei4ueX+MVol+zaak++/+seXD1HcwQYsjwnBhsqUb2bezULKZ
 8GP5QVCdrg4hRAx7wz4EP0eLLkks8J35mqUHgsJM9FsdZXZoaba7lHXzOFSok7oQt7yP6P1GuwI
 fOcpDwkIslRunjX62lAVWIBlWcUxJi4+FHUAx+lOLZBc7E7pKo2h61K7Qk8q99DMNQjMJ9X4r0l
 1xDyvlCjAMGi8SLVDKPeHrYRpAVwk/7DlHM19ALuKLibZn7CNVwd2Jl4GqZGv7VBOSe51PjmWAA
 FX1Dh13wB9vgPNVpy7GOGln1nXH2WobwAsmIW5+G5iZXpPe4X+rfn0Q2PutVLdaOxSp3g9bA7GC
 Kp8BfvczSkmOyIIuPQA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_03,2026-05-28_03,2025-10-01_01

The init_firmware mailbox command needs 29xx adapter support for reading
back SFP information via mb3 and for validating SFP status on successful
firmware initialization. Add IS_QLA29XX() checks alongside the existing
27xx/28xx checks.

Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index b89201c29df4..735240405ad8 100644
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

