Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C172E11C7;
	Sat, 21 Mar 2026 03:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774062667; cv=none; b=XpkwbqtcL37Nl8piwKMJUKWlHFiVnTBerFdTZKfB5GBlKITQFuxmlkaBDGtVlMPvi++PMXJIAFosJ1j9SPGBtnufQDQGVPpEyj7H5HfZ39A9JHCEnxt8GE79hQnnmdBm3S4Nm4oT3SnMeZqIg845oy2os+koDxFWYbcXNwDUyvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774062667; c=relaxed/simple;
	bh=0ogwjjHWIfpKc6oCyvigum4qqc2TSPDXXrtqUwbCr9A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OZbO7/v/XxK6LGmSVyZs/6giClAB5EhJilBVHqO32jV0eHJwNqrY1IsiJud2VP6I8hr14GEsiQj3wvgjEI6GyJAXwh2+00BtSMWNcaNw0e3CLInzoB6ZyDzMknz2Ls2kBHaKIQfwEL5iqFspAjDZWc+I4+amXZuP9Fa6z1YRTrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hbfdPEnI; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hbfdPEnI"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62KMabYD3922985;
	Sat, 21 Mar 2026 03:10:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=TZ8+fv9XMJL
	do1AnLRbsoB02Lp0OK50rDq0WWC93mdk=; b=hbfdPEnIUqwRcfL5B0T05ruze3x
	pJcACVCc2reDUhzPMm4Y14ACI+2vp6HzvNj4u0Vm0MaUmcvPg3lK3CF+rl81Ssc4
	/Om5ReILNB9QQzzpvn07DCzvje1bvA7T7C2KqjysPxBYLH80ItJ06JLU3ORjx+QH
	MCejVaM0yba82wJ9YnRog1nf5TBGvFKG/c66EaWlIQkKYZLSyQMJg3av27i/y1++
	eCOisUG6AdjwVy+MbjJCAxHVzLFul5QUJwPdF3q86i2+xHa/3uK3PQyNxmDkHlTL
	FciKO5vyasrUbTqQWV+K3OFnOr8Xe+nG44Kfd+ff1ilml3eyumACr2xb9EQ==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d1evr0cc6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 21 Mar 2026 03:10:42 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA03.qualcomm.com [127.0.0.1])
	by NALASPPMTA03.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 62L3AfBF011662;
	Sat, 21 Mar 2026 03:10:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA03.qualcomm.com (PPS) with ESMTPS id 4d05vf2s8m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 21 Mar 2026 03:10:41 +0000
Received: from NALASPPMTA03.qualcomm.com (NALASPPMTA03.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62L368HD006103;
	Sat, 21 Mar 2026 03:10:41 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA03.qualcomm.com (PPS) with ESMTPS id 62L3AfPH011649
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 21 Mar 2026 03:10:41 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 451EC5A8; Fri, 20 Mar 2026 20:10:41 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 03/12] scsi: ufs: core: Add UFS_HS_G6 and UFS_HS_GEAR_MAX to enum ufs_hs_gear_tag
Date: Fri, 20 Mar 2026 20:10:12 -0700
Message-Id: <20260321031021.1722459-4-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260321031021.1722459-1-can.guo@oss.qualcomm.com>
References: <20260321031021.1722459-1-can.guo@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: 25K6S_UiFmmq5QyhFVL6iXheSTIXkQKI
X-Authority-Analysis: v=2.4 cv=Xur3+FF9 c=1 sm=1 tr=0 ts=69be0c32 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=yx91gb_oNiZeI1HMLzn7:22 a=N54-gffFAAAA:8 a=EUspDBNiAAAA:8
 a=eBzKeFCim48PKetIR0oA:9
X-Proofpoint-GUID: 25K6S_UiFmmq5QyhFVL6iXheSTIXkQKI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIxMDAyNCBTYWx0ZWRfX3r5Dxhw/NXsV
 pQOU6esoFP/sh0iaClmYEJiw/1er+9HVKN4NW1KuVeLpCyOZaljfftc9ul/LvuAvY7DB7yxeCC9
 pOl8CHoJOrhu9+3NLcSeHFI2kwkmVs/8BXpbnjWY7mbtSV/hrfxLfEMKBdfD+VOfaxkii3LvKxK
 qP+GSc0XBcbbxR25oIeSvmDwVsciPii2G5H2SsN7k0xiGUWD0u2ogItj1iEee4HxDJWB5hdYeK4
 J6FxUH6fshdCKQndhUnHkUr8dqX6/gxhqzTvG6SK+23hJR3Hx808PbVU7/F0OKl8hVjaipLXtJj
 3pJHId1nPTyggGaoysKaJPHUZFZtIKbJbA3qnl3/xwku7i0ICSH++icbaEofEhgFxNMhAJ11Mxv
 SnRMl0tp7xKW0OaTF4rmcMl9lnTI2TaCvXdAfeCM0oXVa4OVQuAgzxuoY9KZ0AZIFeORZpj7tPW
 lVsaT6UzyF4y9WWFb+A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-21_01,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 clxscore=1015
 phishscore=0 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603210024

Add UFS_HS_G6 to enum ufs_hs_gear_tag. In addition, add UFS_HS_GEAR_MAX to
enum ufs_hs_gear_tag to facilitate iteration over valid High Speed Gears.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 include/ufs/unipro.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/ufs/unipro.h b/include/ufs/unipro.h
index 59de737490ca..71a5f643400c 100644
--- a/include/ufs/unipro.h
+++ b/include/ufs/unipro.h
@@ -233,7 +233,9 @@ enum ufs_hs_gear_tag {
 	UFS_HS_G2,		/* HS Gear 2 */
 	UFS_HS_G3,		/* HS Gear 3 */
 	UFS_HS_G4,		/* HS Gear 4 */
-	UFS_HS_G5		/* HS Gear 5 */
+	UFS_HS_G5,		/* HS Gear 5 */
+	UFS_HS_G6,		/* HS Gear 6 */
+	UFS_HS_GEAR_MAX = UFS_HS_G6,
 };
 
 enum ufs_lanes {
-- 
2.34.1

