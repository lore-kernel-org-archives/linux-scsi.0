Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B271481640;
	Tue, 25 Aug 2026 14:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787669546; cv=none; b=av0QXQ4yBr6cXkDLpY2iGjEW4LtvIh7RuRq1ZNcWxkMmlb7xgWD1O56Y7SMpeOXy//q7P971angfpV7iy5OjF0fQ9VIcwSe74KX3BZ6acANSXs1yQw0O9En+NuQiWBmVAJhBgk/woNcBo+M7rC59zmLuI1NJV2ImroZZcBxt/TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787669546; c=relaxed/simple;
	bh=n1qWup3fo4sdCWXoJHVANxGMm1HtIhJ7F6ijv75k05g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OxQ/JZDu9aK12f9klGG/ABN9pvoxAOOZp2RmMQ0eY/MRiYzDquJuNhYdtURQmD2s5gCs3jDuZIZAwhWTBzeIdkhmwVwSg+a6Rrb43wXjPpmHd8bEnj5jygrMWHgRIP1Znd9AngJCgKWG2wyXXvVnsuvlAn1XBa4YVUVx2m4ocTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dgJU34bq; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dgJU34bq"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67PEUrZ62243835;
	Tue, 25 Aug 2026 14:52:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=ZE4Oqi0uKAF1XyYvgzHLLbtNy8lAEfVVlQP
	V+VELdrQ=; b=dgJU34bqmvGFE0ogkEGnyM28CXr6HX07GYUnjtVGOyeDKr2SDxO
	TnBvXDFbVJ4UJ++Qa22L6hPaISkeOeirnnBquw207+fUWMOAanzeyui9LM7x6OGV
	5dmr8g9FgqEcQWYQOq4KyD7X+L+xRh6F8n/Kpri9wTda+ReE7OrBdWu1aYEYetd+
	2kZo11C43fnoalbRXBvN/wnrCX/mceBhCQnpO77T+APr3oSdfBYA+OLZa372l8ha
	9RW/ZaN4dtXzIJm6++FGb6t/nmz5Z/29F73YQuwHM+iar7jqrcwPH4OhQrYYdO6q
	gZ5gqKwFUAH/zRswB6ygW0OjWt226bl/VAA==
Received: from apblrppmta02.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g96abt1m4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Aug 2026 14:52:09 +0000 (GMT)
Received: from pps.filterd (APBLRPPMTA02.qualcomm.com [127.0.0.1])
	by APBLRPPMTA02.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 67PEq6Ce006114;
	Tue, 25 Aug 2026 14:52:06 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by APBLRPPMTA02.qualcomm.com (PPS) with ESMTPS id 4g74uk182t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Aug 2026 14:52:06 +0000 (GMT)
Received: from APBLRPPMTA02.qualcomm.com (APBLRPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 67PEq61S006109;
	Tue, 25 Aug 2026 14:52:06 GMT
Received: from hu-devc-hyd-u22-c.qualcomm.com ([10.213.101.157])
	by APBLRPPMTA02.qualcomm.com (PPS) with ESMTPS id 67PEq6OT006105
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Aug 2026 14:52:06 +0000 (GMT)
Received: by hu-devc-hyd-u22-c.qualcomm.com (Postfix, from userid 2342877)
	id 4A60C64A; Tue, 25 Aug 2026 20:22:05 +0530 (+0530)
From: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
To: mani@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, konrad.dybcio@oss.qualcomm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Subject: [PATCH V2 0/2] ufs: ufs-qcom: Fixes and optimizations for Qualcomm UFS Controller
Date: Tue, 25 Aug 2026 20:22:01 +0530
Message-Id: <20260825145203.265579-1-nitin.rawat@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI1MDEyNiBTYWx0ZWRfX3ksxw3+xJekS
 WrAWNc6HPHzFmsQ3/BpBb/DP2aSoBbDb9LIVxQKSu8fsYscpYgS4cHbwIXBY6mC5VXCT8HJWsYp
 HcYc1EgMIyWv5VWWScEPBrkBk+SALBMuohXm4YUqXFbDmWQ8Rwiy2P1XdF1ZvWk4iIHJ4lXvw9m
 Sf2lZIseCOR7bneEDwxpkLld0eBVm9yYMvPzM1bYK8BCzmU8QoICe5lIH+E23sloctkBkUivLkY
 sQGohCibfnDHv1ts1mNPPw2B3mX5MMkNY+UKeWFW4WxbTVfB007DoS1QG7zRLfOhw5qpMO9T0tB
 6G1WOAX1w8NFOkeCokqPgLvxXOExMk7NSYFCKL0eWi/rgwZ2mFLq8n6DiRU2PRI4e2xYVKVrQTJ
 ScTIVdItVveK1Tmm5RIn8/URb4k8YPJ26qKjqe/fuHgS03yyD1p6LiQ4e7cMVPzAQLpUlQEXvgV
 VvI/95vtwfX3FApEZTA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI1MDEyNiBTYWx0ZWRfX5UAhp1lwzzdH
 J+XkRdo1rj0UivDyy295gZ+kLlUVlVBw+zsgcgDKmPfol2s/J1g0+5fvX/g9E1LwSVl5EdCi2oI
 /jJKoU5qeG2tfsK9uqTMVT93RdptzLY=
X-Proofpoint-GUID: NP0_VlL14shcL8tJvpMNRU0r6_6ixh4C
X-Proofpoint-ORIG-GUID: NP0_VlL14shcL8tJvpMNRU0r6_6ixh4C
X-Authority-Analysis: v=2.4 cv=SaHHsPRu c=1 sm=1 tr=0 ts=6a8dac1a cx=c_pps
 a=Ou0eQOY4+eZoSc0qltEV5Q==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=gowsoOTTUOVcmtlkKump:22 a=uj0N0nW6wbPdqk4i71QA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-25_04,2026-08-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0 spamscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608250126

This patch series introduces few fixes and performance optimizations
for the Qualcomm UFS host controller driver to improve performance
and to align with Qualcomm UFS hardware programming sequence.

The series addresses below issues:
1. Hardware programming sequence alignment for UFS controller v6.2
2. Performance tuning for sequential read workloads.

Changes from V1:
1. Dropped ufs: ufs-qcom: Add UFS ESI CPU affinity support from V1.
   I'll work and take it in separately in different series.
2. Addressed Konrad's comment to change version check from "only v6.2"
   to "starting with v6.2".
3. Addressed Konrad's comment to fix comment wording ("HS/LS" instead
    of "HS-LSS"):

Nitin Rawat (2):
  ufs: ufs-qcom: Restore HS/LS link startup mode for Qualcomm UFS
    controller v6.2+
  ufs: ufs-qcom: Fix sequential read variance

 drivers/ufs/host/ufs-qcom.c | 17 +++++++++++++----
 drivers/ufs/host/ufs-qcom.h |  1 +
 2 files changed, 14 insertions(+), 4 deletions(-)

--
2.34.1

