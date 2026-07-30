Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD3E43A7FF
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 16:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427239; cv=none; b=a7oFLEGTe6iy9NK50ufjDp7Q9CZr45awoGT0iUGEBf6FgsCyARCPlcwCT/XSXtOwQqkrhYca1mYiiT5XXhoWQAYDTA3iHT07VR5+EwIqFvEufrD26r4GRwApxDwMTSxaVZnS1P7Aujm2Rvup8dveIqOK7YKERtMC+/yxE8pTxjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427239; c=relaxed/simple;
	bh=S7jTX1FBmooG8fKZttfHvmIV2w/DywDPji7ueOAatSA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VE2H7hjcjXbr/q27vCF6wZyf6CiXAVFTRvMeps6sk63u+z1Ux5Nf6vGks7vX8xbdqEtIichMECNX26nB0jLa75O3hpC30tDBU69BA10XcZVb/fi4BfsKLvwKNNXdkRPKjZjrzu33+5gz7mWzBPvK+33zKVNwucZzPGN310YM1fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Mf1Dunpn; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Mf1Dunpn"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFV1HI1299575;
	Thu, 30 Jul 2026 09:00:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=f
	+AO2dOBVZ5LUBoa2Lzndw6+nB72kMPEgIcmf4iuWik=; b=Mf1Dunpn96LFAxM9A
	GP0PDYYguTL2rko+nOSU9/OvjM/J8Nf1Nia36L0Vf1C5dMUtkPTfi2pUxQMOWl57
	DkaKW7bG/q5TrD1SCP6Cz3+y/2xJoNxFm++mDg66Vldl0ptA9DBdpjFKPJeF8dce
	hO0E+hpH3/q57F22XVGa01HJ2VoRsmgRlR3XiPvyP2yNVdOmoet/RmGfljwkL6PP
	phdUDF21rIZzHuIoyWWu6IOExyxGK53MXvF39afhOd0triJ2vqvMxu8rtZ1fHFWl
	c43l0NS7my5u0OZmCjfGvf2gRBheJM2rRbT1zJPXYNZGXTX6l934m36p5VAQgaTD
	wdqFw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fq0f08cgr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 09:00:34 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 30 Jul 2026 09:00:34 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 30 Jul 2026 09:00:33 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 8A26C3F704A;
	Thu, 30 Jul 2026 09:00:31 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 33/33] scsi: qla2xxx: Update version to 12.00.00.2607b2
Date: Thu, 30 Jul 2026 21:28:38 +0530
Message-ID: <20260730155838.2119230-34-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260730155838.2119230-1-njavali@marvell.com>
References: <20260730155838.2119230-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: jDGZG-W1tIHknun8xctSJJAoi0jPPAL6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX8J/qGlyHQhDN
 3mw72GHHJfA6clD31caLEFCJbsu6HAzI/e6F7qKfnHh5Dz5bI+178xrOcrKb9aVwDyDD1aDgiZp
 qkY6d/37w3VcG4+QVE5M7vxhYNZKT4ErRxRndu7d9qDwbccIEJb0no2/oCu7qNLxwnhW+wK6Gw2
 nTnVA79s0p9dd+6AeaQUemelX5d/Kg59jr9WFNWBExrIfXiwfRHugp37YbTRYuPRiWT1nT3lYdB
 QcWhuMPf9WstaMZPsGLjEgfKxLGBVdUa4FQtAuVNNL+46bq3cFhELWHVgsgydmlWJ9WWTWtpaB0
 MX283fineQSqEdRACo9HxZ2jbjFc/i7t4RJ9J069nOq8UEJJDqxJTFgqvT26ACqymPps5nSnMxv
 Ac/j1dnHql8sY+uWHltY8laR1NOqjZIveSoXo7g2ZyCHuwUWCjHyXMTGFw3RGMHFEVN1LWHLn28
 RCiWwS+0Js9seE4RScQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX07wWBdClwzgN
 hKHr3m7UJHYSxTrW0dOv4P7oRRpFO2gSCIPkxMC8OPjlWw3HLZ/KffTPZvb4lnhMytCOsSPXuZs
 fwfirfWUrDtxEbYxsmdPgkOuKhGmkcY=
X-Authority-Analysis: v=2.4 cv=NOLlPU6g c=1 sm=1 tr=0 ts=6a6b7522 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=ATVFy8JbdY1Zzb2G2p4A:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: jDGZG-W1tIHknun8xctSJJAoi0jPPAL6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 1c0b01d70350..ef9dc88221c9 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -6,7 +6,7 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "12.00.00.2607b1"
+#define QLA2XXX_VERSION      "12.00.00.2607b2"
 
 #define QLA_DRIVER_MAJOR_VER	12
 #define QLA_DRIVER_MINOR_VER	00
-- 
2.47.3

