Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8430629993D;
	Sun,  8 Mar 2026 15:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772982881; cv=none; b=FNy9QnrCJfp6dzLMvH2frcjTFvo4un4qK5Di5jv+J5wvw+IOpQr8yhXAGJ95E921RvMq06ZyDJdywQL0af6MpxLad+kTSX/Gs249ZTeNHUq0KgDHq16+1H+owv2cr9GB+zP6KgVfW1/gUIoCcsAYorTWs0q/Q+ipzMlJF+heHW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772982881; c=relaxed/simple;
	bh=2EiAHRh4WHqXp5ZRvyvN8uc239qcdfNDmlBNYyJvrJY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HDjn6hp+J6+QvxXw/i6bhMWRxfeceM2U9QQNSiZvGokZ1QJ1OHLFXifcJ83Je7omZ+W4r5DwDpdD6R/qa4EGvH05Dw4mMHEPQvx0lovN9AZvTAUvmugXbi+gzVSU3gzQIaxtRf27WX/CgUTKvwGWGWy0+j1VVfDpmDXfNTiO7Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=c2DURbJv; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="c2DURbJv"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 628AnngE1559607;
	Sun, 8 Mar 2026 15:14:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=L4lmWn+BV/U
	aGj7pzqLjIYgrRSfOyLZRnLyjaDUFu10=; b=c2DURbJvb2S1lwsevps7+y2ds71
	P3IOyKRpcbB1rtS4MWbvy0zC4Pe3a3rvug4HRDfTyMuPjiza7HUwx4s9ycF+8+/3
	/T/vUtmKADm5q+2kheWKcxvuTzp3B8+SpRTaxtFKg2DTY79fX7UTdQE6JFSKYZRj
	fc16d4ff/qNfIe3pW7hivNl8uHbkaBbY11k+fSJQTuqH7OMoSwIwwz45frVGGeuT
	38sf9htvzxAWfRyFCS9TG9x3ZXhWaoBsGuRs0bsvzIdnLZB3vf9xsNuoqYfPnA6b
	QjcBTvIe+HXXQYvwoT8YXi5M/6obIZEvXWYBBBImMEmmwUk8VfKWqLB1DEQ==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4crbkxtrjy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 08 Mar 2026 15:14:29 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA02.qualcomm.com [127.0.0.1])
	by NALASPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 628FESXm020258;
	Sun, 8 Mar 2026 15:14:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 4crd45jvav-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 08 Mar 2026 15:14:28 +0000
Received: from NALASPPMTA02.qualcomm.com (NALASPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 628FERTv020251;
	Sun, 8 Mar 2026 15:14:28 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 628FER9C020250
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 08 Mar 2026 15:14:27 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id A37735A2; Sun,  8 Mar 2026 08:14:27 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 03/12] scsi: ufs: core: Add UFS_HS_G6 and UFS_HS_GEAR_MAX to enum ufs_hs_gear_tag
Date: Sun,  8 Mar 2026 08:14:00 -0700
Message-Id: <20260308151409.3779137-4-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260308151409.3779137-1-can.guo@oss.qualcomm.com>
References: <20260308151409.3779137-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA4MDE0MCBTYWx0ZWRfX2WQ6tXGvQYHs
 eEXCeNaMv18zcGWIGmI3dScTtys+AI42paCiNiENA345ITL/x34n1X22kvV3BCTQpJNjiRYVEE4
 4hm0H2+NZbBqFV6mMyWrEfyWfcw3zOmHtpBi3/uxZxVrOiFMIq6CZMmMGXrORwCYmdGUZU/bVFH
 I7uvfI47zyiUnsuZgma1ucyMu5YyZOn8S/KdDhe423nZ5JpOPskuZ/rEx7zb0OjB2rRVKjPobWs
 zM36xDBk7mfmvKW+xeYdcU/aERHRevEiEwWPIclAABbb8agOUEKccqpm3P6JUZ9RAauLpvVqzfO
 UiO4xY5T+iGXgkRHHCqiqbuOq8hwKs5ZPoFPksj/8ARNspF5zJjHF/eTOoNE1Dd2XSeBMCU+M0O
 MXx+h1pQjrkWp224VzsZXQyMFYKevPZSGfUBOzxTd0wjm+HySktDha5h2LRcDI0PsIgpTulV46U
 6LOa9BdutKmAWHw0epw==
X-Proofpoint-ORIG-GUID: qK-ObrKpdYNwrFlUICRGt6ktSMvbX03d
X-Proofpoint-GUID: qK-ObrKpdYNwrFlUICRGt6ktSMvbX03d
X-Authority-Analysis: v=2.4 cv=LOprgZW9 c=1 sm=1 tr=0 ts=69ad9255 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=3WHJM1ZQz_JShphwDgj5:22 a=N54-gffFAAAA:8 a=EUspDBNiAAAA:8
 a=eBzKeFCim48PKetIR0oA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-08_04,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 malwarescore=0 adultscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603080140

Add UFS_HS_G6 to enum ufs_hs_gear_tag. In addition, add UFS_HS_GEAR_MAX to
enum ufs_hs_gear_tag to facilitate iteration over valid High Speed Gears.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 include/ufs/unipro.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/ufs/unipro.h b/include/ufs/unipro.h
index 59de737490ca..eccb45d3b86c 100644
--- a/include/ufs/unipro.h
+++ b/include/ufs/unipro.h
@@ -233,7 +233,9 @@ enum ufs_hs_gear_tag {
 	UFS_HS_G2,		/* HS Gear 2 */
 	UFS_HS_G3,		/* HS Gear 3 */
 	UFS_HS_G4,		/* HS Gear 4 */
-	UFS_HS_G5		/* HS Gear 5 */
+	UFS_HS_G5,		/* HS Gear 5 */
+	UFS_HS_G6,		/* HS Gear 6 */
+	UFS_HS_GEAR_MAX,
 };
 
 enum ufs_lanes {
-- 
2.34.1

