Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F367444BCBC;
	Fri, 27 Feb 2026 16:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772208536; cv=none; b=HUoM63iStiiihvG1X8QXpakSxcX8VbdTH1Q6WB3YbIDkk09MX5MeP4sbjMD76sMcYpq3kRMmLU//+fLNcp8Xm5l49jjmQ0+c2/eLxi8Zl0Qm5bDyKYdyJ+txeDeFVSbiYWZYRvx64hgRsiYaLnOkZvY4EYoN7aN9Y4EvSBi2bJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772208536; c=relaxed/simple;
	bh=aZDjQzXjLCM3ky+djtvzdXv9R1WFRzycOW8WOOKmOTE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nKhit9cx5dq/5J5Sg0S3lSBZHXrmgCmfgl2gccAXIvpiaYz58h6g0ELmVUeLBgnzoaMbZxHR8TYxFB9Jozi3B3zm+6G8gHy6eaymzQ5zhqjhglqFomFuWPdD3oHYDQfaSDNU0HOL/OdtvUr+Jow63MJcx2TSHGm4szX68qnpX1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HyKcg5de; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HyKcg5de"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61REa7Nq1595163;
	Fri, 27 Feb 2026 16:08:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=/6sLYanh5Rc
	SU5g5POu/9B5+O4PpDSruG0y2miJrtp0=; b=HyKcg5de1f4CGEjGC66yc7vZML2
	YuUmAPn1Bn28eZKE4jHMuFc9UaufSk+SPfbvPIxhMrFZ16MVDVRX1AOXL+Q1Hxo+
	Ug2JsY1mTBkK15WMt6St1WQ9AKoteJej4Qr/aYy4WgPD7kw9DAq2r7y3zEUyrEPl
	6dmBVwofXiaFDT9+2m6GItO6nKfvhoKxFL5bg+hqoyCTNHyLOrG2dOx5x6eCzdYu
	c2nxuA+nDc8AMS3hiqIMbSseypEZJMJysSm3axtYevzR5v6PDgn6FzROlQuXdR71
	zQgeKbaKoJ+5P5Zu9WLAsON9pL15wh9uY0E547bB/G72DOBkV6v/KgD5KaQ==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cjuur3p4q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Feb 2026 16:08:34 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA02.qualcomm.com [127.0.0.1])
	by NALASPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 61RG8XbK013716;
	Fri, 27 Feb 2026 16:08:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 4cjqhmvrq2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Feb 2026 16:08:33 +0000
Received: from NALASPPMTA02.qualcomm.com (NALASPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 61RG8W5j013707;
	Fri, 27 Feb 2026 16:08:33 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 61RG8Wuk013703
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Feb 2026 16:08:32 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 83BF25A0; Fri, 27 Feb 2026 08:08:32 -0800 (PST)
From: Can Guo <can.guo@oss.qualcomm.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 03/11] scsi: ufs: core: Add UFS_HS_G6 and UFS_HS_GEAR_MAX to enum ufs_hs_gear_tag
Date: Fri, 27 Feb 2026 08:08:00 -0800
Message-Id: <20260227160809.2620598-4-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260227160809.2620598-1-can.guo@oss.qualcomm.com>
References: <20260227160809.2620598-1-can.guo@oss.qualcomm.com>
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
X-Proofpoint-GUID: 5YTSrRUR6dPdEpMse3aRpLCK7LNIdrU-
X-Authority-Analysis: v=2.4 cv=PN8COPqC c=1 sm=1 tr=0 ts=69a1c182 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8 a=eBzKeFCim48PKetIR0oA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI3MDE0NCBTYWx0ZWRfX4Zv56zdvcuxd
 yvswTmMTIWvsXWzZudL46GPKonLsjPfZTF1UC/EWAByxOlepUJcuTJCWYASizdv38AkqSLu2dyQ
 5yg62Jsm3IRET1Cu834OchlapMh1GwWG8y44asuqx8lMfo+jlakxZwdg8MxoN1BaLtCE5BS5diw
 s0A9YzSun/gEERvycgfXBXxXSUwuH8oH19bfiqpTbsJ4IlttUVehxVVjAEDDES1pLlX1RbRmyVX
 lv/lwRnVBo/EHlQDiSKEWt8E+LwWiHV0VfkUXer83CcILUkUISk5VpLQaIqMIGx/Dmq2xPcqHIs
 hssq9huYccSfwC4IxbOfAVuRHZHxjDmkb1Rh9bFqJHJ5m/s4Iy1jx+VMDCqQ/gpbEfZ2C6E0qpw
 akWp60LEu+l7wKl+qfQJ+UiOTTEBz2G/3cRmzyR3+/fHMJYn4dldEXi7fLqjw5a1f7Y6IYNeSr9
 4IohwUO8EVxwqsBQQQQ==
X-Proofpoint-ORIG-GUID: 5YTSrRUR6dPdEpMse3aRpLCK7LNIdrU-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-27_03,2026-02-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 clxscore=1015 lowpriorityscore=0
 adultscore=0 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2602270144

Add UFS_HS_G6 to enum ufs_hs_gear_tag. In addition, add UFS_HS_GEAR_MAX to
enum ufs_hs_gear_tag to facilitate iteration over valid High Speed Gears.

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

