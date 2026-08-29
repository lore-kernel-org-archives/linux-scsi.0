Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71AB839B481;
	Sat, 29 Aug 2026 07:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787989448; cv=none; b=LKDIcxvBURrlyoqbaMWtdDsA35AM8tm/tM4z+ahA/FtrAU7jpkOQUNORjTJVpPxo4v80aRGn+vIHRerM9PSgqrxxWYS4ODqz8oOqhtMCOg9UZ8iHnSSjetuqNU/JLFr4xeWbb/P/0Za5zd4tEM75wLolxz3Ezu68RmYwmRW7YTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787989448; c=relaxed/simple;
	bh=5zbv0xSLpvnj0GWPcspkXwRRijo/CJXXv3cRMWbElGk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WyHypGK3kp3+12GwaOkRWRlKgGjLfHpnfcwJoewsShHoMWDlarUc5OQm/ock/qy5SjATLSx2m5LcAoMMvtbG3NRLnE7M0DWSrAvpNtni7ODPYabgys+ZQfNv8AkznIVtjfQw2KUjs+AI8EV2hHGaVRTiG0cJHcHEISTGRpecYGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=NhQHjkzw; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="NhQHjkzw"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67T57pKg407286;
	Sat, 29 Aug 2026 07:44:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=p7vlKiSvlP2
	P03h2LJYf2PhtEKaa7ZOR84uf1Tsmn9Y=; b=NhQHjkzwCRAfxF2vYoYpreggQxJ
	/tAS7URNNVMHyWP7eXnP3hH+4C9lEVUq8IBmvmikxcEK6/0XoALYdmxW+fHBtNT+
	rr0V1sJ1u5BRqbusXdbCjlpcDtzapkEKoztLdk4P20hN87q3zQeYS4pi7FZm4uXi
	Mfk8ItPVNwmdTrz5n0qt3co6l+bKj97JYQGeoJ00k68Tyhn4uzxtglHEIMCPVn/o
	m4AQXkuEVuyqpz36uizAUAhfqGUawBnMoeOTh1yLU2rehoWzpPpYlO1c1urKtgpA
	xgiMMteMu2v3Z7KOCcFaw1bZuhQT8BDZ1BV+r+FE0f1tOshkffu7GgIPbkg==
Received: from apblrppmta01.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gbr6drbm2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 29 Aug 2026 07:44:04 +0000 (GMT)
Received: from pps.filterd (APBLRPPMTA01.qualcomm.com [127.0.0.1])
	by APBLRPPMTA01.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 67T7i1Oi002297;
	Sat, 29 Aug 2026 07:44:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by APBLRPPMTA01.qualcomm.com (PPS) with ESMTPS id 4gbrgh21uk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 29 Aug 2026 07:44:01 +0000 (GMT)
Received: from APBLRPPMTA01.qualcomm.com (APBLRPPMTA01.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 67T7hv7W002255;
	Sat, 29 Aug 2026 07:44:00 GMT
Received: from hu-devc-hyd-u22-c.qualcomm.com ([10.213.101.157])
	by APBLRPPMTA01.qualcomm.com (PPS) with ESMTPS id 67T7i0Sx002291
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 29 Aug 2026 07:44:00 +0000 (GMT)
Received: by hu-devc-hyd-u22-c.qualcomm.com (Postfix, from userid 2342877)
	id 01FDF63E; Sat, 29 Aug 2026 13:13:59 +0530 (+0530)
From: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
To: krzk+dt@kernel.org, robh@kernel.org, conor+dt@kernel.org,
        andersson@kernel.org, konradybcio@kernel.org, mani@kernel.org,
        James.Bottomley@HansenPartnership.com, mkp@kernel.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Subject: [PATCH V1 2/2] arm64: dts: qcom: Set specified gear configuration for Hamoa
Date: Sat, 29 Aug 2026 13:13:55 +0530
Message-Id: <20260829074355.946543-3-nitin.rawat@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260829074355.946543-1-nitin.rawat@oss.qualcomm.com>
References: <20260829074355.946543-1-nitin.rawat@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI5MDA2NSBTYWx0ZWRfX+K9rVcdqOINS
 xICz679Km/jr9x+42li1iqSHbE4iCiAdWxiSC8dMCUT5U/+PI2wK+iN5sgTf/IqjNVGSccAhtn3
 UmYZeW31U4W3aSDVbXvJV999xrA/kCep1Ou8IejJ3HZF+lWhViJiTMqIx+JYAldWppDC1Sio8Xz
 SJGyd17U72/OtUCHiIbUWleisl6PTbnOIcWQ+MBhZGoLL3GVmziDATnkLKFUXZ+is2yj0NH0dro
 aWrzpx6YtppyVtP5F8d1yz6GhjCFp27kDsjk0aeMbprbEYeVjVbF3YZbg7usPC7m0o3FaC6i+xB
 9wocW+QxJvQrQ6X9kKoA3901njEwYTUBvWI0mSFOrAoIrPbp+I6mf0Q4soQ8FoatyKAFXxvrRG2
 wipkXrmhEOokAaOyBv78hnYWriQeMaEBm1yLF6u4bkMhwGrzCuVzNEZ/W/mxoKh1pH+bSR3q+vW
 tou5DFVDfp7SgVPZfkg==
X-Proofpoint-GUID: 359jAufMsg7_iIFoxriVtkEr15WN4ip-
X-Authority-Analysis: v=2.4 cv=Zakt8MVA c=1 sm=1 tr=0 ts=6a928dc4 cx=c_pps
 a=Ou0eQOY4+eZoSc0qltEV5Q==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=_K5XuSEh1TEqbUxoQ0s3:22 a=EUspDBNiAAAA:8 a=IWAy4dvJcaJ83IugCMUA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI5MDA2NSBTYWx0ZWRfXzTFtiN3zd6Fz
 kafqTilnmdTbs3+iqJ0YF3wCIfXQHrufQRBGB93V+siFlGUUGgUue5x/YSCM39/MVUVWca+RzOF
 IDCa1aYlC7gaA5iP3yvbThmvt9FhTnQ=
X-Proofpoint-ORIG-GUID: 359jAufMsg7_iIFoxriVtkEr15WN4ip-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-29_02,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 phishscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 suspectscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608290065

Assign the appropriate UFS HS gear speed levels to each OPP frequency
entry in the device tree, enabling proper per-frequency gear
scaling (G1 at 75MHz, G3 at 150MHz, G5 at 300MHz).

Signed-off-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/hamoa.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/hamoa.dtsi b/arch/arm64/boot/dts/qcom/hamoa.dtsi
index 8a96ea1bdb9c..ef7994c83bb7 100644
--- a/arch/arm64/boot/dts/qcom/hamoa.dtsi
+++ b/arch/arm64/boot/dts/qcom/hamoa.dtsi
@@ -3918,6 +3918,7 @@ opp-75000000 {
 						 /bits/ 64 <0>,
 						 /bits/ 64 <0>,
 						 /bits/ 64 <0>;
+					opp-level = <1>; /* HS-G1 */
 					required-opps = <&rpmhpd_opp_low_svs>;
 				};

@@ -3930,6 +3931,7 @@ opp-150000000 {
 						 /bits/ 64 <0>,
 						 /bits/ 64 <0>,
 						 /bits/ 64 <0>;
+					opp-level = <3>; /* HS-G3 */
 					required-opps = <&rpmhpd_opp_svs>;
 				};

@@ -3942,6 +3944,7 @@ opp-300000000 {
 						 /bits/ 64 <0>,
 						 /bits/ 64 <0>,
 						 /bits/ 64 <0>;
+					opp-level = <5>; /* HS-G5 */
 					required-opps = <&rpmhpd_opp_nom>;
 				};
 			};
--
2.34.1

