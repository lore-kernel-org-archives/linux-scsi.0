Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3839B2472B6;
	Sat,  6 Sep 2025 20:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757191019; cv=none; b=MaKFV0xgDoxG8l+wsL32D3GjOOHxWIur743wZEufT+PGDNEdXISlWet+VSHaFxonmT6qYyNpzNLaemK0KvifGholeFKT9yNkR80xofa4HgpEMB3WMrdTNpWfrPgh2raHpusWE675uBwxONHxOLtGNbucm4I5AwhDC5E/deuLyFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757191019; c=relaxed/simple;
	bh=ZMePIJxuRSyJ23Be1RKExOF9BYnRp024ORsGCfGtQdw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Jzq9r9YK28tMLus+4Llm0wJHpKCVzVvvmCB+WGoQMH4PYDk79xtv7Lx89oHqr4ICpfiqQkEzcnY4ZJAWuNATiAu9LgVhogDS4tflXCS36QlNRdprNp8fuiLHMVpA1tEKNAK2x+rGiQ/cZz3mh45bR+6T0E36h4wzbT3sXCQJuBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=c0IchnUX; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c0IchnUX"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 586KFrYD020386;
	Sat, 6 Sep 2025 20:36:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=PVQ8nas6Q7US5DZcPsLyNsL7w7XWy
	2uTCHh1GfyXG1Q=; b=c0IchnUXo+Bn/U1YqCgyZOtrowdvFRozNjbqikciyCVru
	C0DGES/0S/foRFtX/AUZJV1f6MBuhkuHPOIiYyB6VlHQ+rDxCHrlA1I1Cj21z0cg
	KwtqKUiVU/whGPGbBpH15Bda9N3gZprIZAhHL6+B8bSj18FYljP4izO/tHMDlEQt
	vNQC+jz1+6o9q+4yj64rSsYaeHKCWseMT66ktUKP5YCwVj5V1MRFfDlfiDePfvMF
	CFSCNygNBTKQBRITGCgDyqib2G4wbDNuwHusW6FzWgV/p0lxF46nE8xdJD7hLZOu
	N4Z0aIOpKYDeL7+jiSTcpuOIZ9AEuBumVWmTDLGiw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 490urar0ay-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 06 Sep 2025 20:36:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 586FXkgg002759;
	Sat, 6 Sep 2025 20:36:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bdd9j2y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 06 Sep 2025 20:36:40 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 586KadT1017849;
	Sat, 6 Sep 2025 20:36:40 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 490bdd9j2r-1;
	Sat, 06 Sep 2025 20:36:39 +0000
From: Alok Tiwari <alok.a.tiwari@oracle.com>
To: mani@kernel.org, quic_cang@quicinc.com, quic_asutoshd@quicinc.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: alok.a.tiwari@oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: ufs: mcq: Fix memory allocation checks for SQE and CQE
Date: Sat,  6 Sep 2025 13:36:18 -0700
Message-ID: <20250906203636.3103586-1-alok.a.tiwari@oracle.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-06_07,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=854 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509060202
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDE5OCBTYWx0ZWRfXyGKSyXTf83dj
 xbeGIiiC7FFok3tdQuyemoTojpuA6Gc9JBro+/zf11OWiLpI2t9FlTIZKsLuF3GZhFZzw7VL/9b
 zccnp6shncuKxepFBPpoOnuzuum45TW2jLQfWj+a6mTlGKY5usFX4d/1ddrn2OzUOBH/p5XOpEZ
 P4d3zJqoyi0naaGwZKc/hrw4uefEYio9Abghi6cVqst5AGZZ158I2XVIWyxS0vxCTqU4tNcTlfS
 4ZSu1AWG0k5x3luIytlw/DjIVSCy+433Qd3tnGYPN9FBHfR7syJak60HSCWHm10LjaBxW8YxUNR
 CRVGfrPmAyp/XT6Z9/siZRatzDMm3ZQ4le6YIymBIn8k0XmFuwjKxtNn8w6/UHx74c4O3iz55LQ
 hq9KdMTD4g/VTI3JlkJ78Gd/asnENQ==
X-Authority-Analysis: v=2.4 cv=T5GMT+KQ c=1 sm=1 tr=0 ts=68bc9b59 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=GesvECoXrJs119_16ZgA:9 cc=ntf
 awl=host:12069
X-Proofpoint-GUID: UBeI1EY29MpyxKejynzB5tV4EePlJDDS
X-Proofpoint-ORIG-GUID: UBeI1EY29MpyxKejynzB5tV4EePlJDDS

The previous checks incorrectly tested the DMA addresses returned
by dmam_alloc_coherent instead of the returned virtual addresses.
This could cause allocation failures to go unnoticed.

dmam_alloc_coherent returns the CPU address, not the DMA address.
Using DMA pointer for NULL check is incorrect.

Change checks to verify sqe_base_addr and cqe_base_addr instead of
sqe_dma_addr and cqe_dma_addr

Fixes: 4682abfae2eb ("scsi: ufs: core: mcq: Allocate memory for MCQ mode")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
---
 drivers/ufs/core/ufs-mcq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 1e50675772fe..cc88aaa106da 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -243,7 +243,7 @@ int ufshcd_mcq_memory_alloc(struct ufs_hba *hba)
 		hwq->sqe_base_addr = dmam_alloc_coherent(hba->dev, utrdl_size,
 							 &hwq->sqe_dma_addr,
 							 GFP_KERNEL);
-		if (!hwq->sqe_dma_addr) {
+		if (!hwq->sqe_base_addr) {
 			dev_err(hba->dev, "SQE allocation failed\n");
 			return -ENOMEM;
 		}
@@ -252,7 +252,7 @@ int ufshcd_mcq_memory_alloc(struct ufs_hba *hba)
 		hwq->cqe_base_addr = dmam_alloc_coherent(hba->dev, cqe_size,
 							 &hwq->cqe_dma_addr,
 							 GFP_KERNEL);
-		if (!hwq->cqe_dma_addr) {
+		if (!hwq->cqe_base_addr) {
 			dev_err(hba->dev, "CQE allocation failed\n");
 			return -ENOMEM;
 		}
-- 
2.50.1

