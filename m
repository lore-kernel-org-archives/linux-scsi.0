Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774FF346781
	for <linux-scsi@vger.kernel.org>; Mon,  5 Jan 2026 14:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767624447; cv=none; b=bz9pR6nttLNU0yaPcy9X8PpCfjcfIoET3LKkTp8ZwAPKmogtcEuBDG6t3o8kFiTjNe639ZsbPX4s/Nv/tQytKrZar0KvpCG7AQEms2TbZzZODbFu0h+opYP2jZIreCWzoSL/+2tUsjktDKkA8OrUBSXxIiUSMS05hzZ9Ql+QCx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767624447; c=relaxed/simple;
	bh=3LB0cITSfH4Noq7m1s58c2osN7yIye+Lx3PTEFp67co=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UIA1L+VxjdXxRzkBHVeLcZnbBkWL1aEw9SAsnwdlcyNMXQw7RNtAaurC9YKztPNXErWLUA/ZybusFnVMSdWyAveYfrbNje6sSQYclYzcOh/DlNt+ntLXs9OnUCQ1ash3S71tqrq4AZbo1csQq+h+l98LcStkMUz+0AcLr5IsCeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AZTZ1ot2; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JH8HtNt8; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AZTZ1ot2";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JH8HtNt8"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6058L3jM3964598
	for <linux-scsi@vger.kernel.org>; Mon, 5 Jan 2026 14:47:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=Mty9CPP7Jsu
	pHUVUgRA6WjTGLkSoSb22qlCPdm1xAOg=; b=AZTZ1ot2tPsaM3lII25l/ce4Z3E
	UykNF77AW+sK7pz3dJYS34Ux8qHkn5vgVQi53oIZl8NwWRWqNGof0rmkwyus2VOL
	+2N9MRquPteRPdnPmqyZwUoHSOQSz7G26wIOhrn/JgTxDsoyN36fwym4Te51krMB
	rwikyzRDNuNZwoPXXYCnbtclPr6NdtKDIiLOLjGZ/fckKVNa2KZcukOtcdntE647
	PbiF2A9OcEVk2R1lTGpaG67DvXG0lTLw8wL6wIP6PH1fR2WVRr7vu64pY0gxsEaQ
	WxfUvSOCiO00wuGBONdPI5N87eWsbKBNUBb/TJaCgoSqLCLCTovjN2ZHiRQ==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4beuvd4sjp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 14:47:22 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-7aa148105a2so15627b3a.1
        for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 06:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767624442; x=1768229242; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mty9CPP7JsupHUVUgRA6WjTGLkSoSb22qlCPdm1xAOg=;
        b=JH8HtNt87KkQYtxGCEldOsRz7qiBjxx+hz/tJ3fE1goRfOy73icwo+lKcYGCzNwAq4
         3ZfHeMsbeTElh0bl750lHKd740+BxsXkGyKskH0gkg4P1ix/9a5SyGVfHVUDAlU2n5gB
         1RDgotpy4vuo5S8ZKyHI0ZaT5kKf9LihtsjFh4MMH2q/VAlXA+fwStvnMt55GPLrqTW0
         wZMJaRvZIe/9gbpTvuDeavEIAe88lJXl/yqQV/CeC4mSPXPV76SuVw6ZJzxVV0YxI6B8
         M4XV7lwfsXxhI8Rmj0kZwYlptePVzbI4xRXMoeczQMBzZxt3SV/F6w5a9xd7vS5IrUR0
         97Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767624442; x=1768229242;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Mty9CPP7JsupHUVUgRA6WjTGLkSoSb22qlCPdm1xAOg=;
        b=D8admVSLeiug3WoxMXzToqbeWOuhPjxmMQKaPffw0kWYErxXN8vsJOMsrZsoR2junB
         Mysn8xu6jvvbvEjrT664T+P2Rkv7/MHaAVxCbUD0H0laLKXklfqP/2dsqvavPxcQ9Bew
         0EYBnYGRTpCXk2TZAxysKyWYFg9j17PraAJxKQ4npYbQKDoZuoln+8+R39RoIaPEZSEr
         BgeFq7C82juORzvJW9v1SnVPdO9FpjRFeQ8RL+F2pabagK/nJyhSUaSwL3nwubIt3rZ7
         B12VTd9B7BrVNeUU7hAYH6JWKe594+ZB1RBXnUWNAK/Nyd8xM7DzfoGhWEoANAGoofUT
         xdlA==
X-Forwarded-Encrypted: i=1; AJvYcCVOZDmClguPsgk1G9NYYpmxnuN6wER30CT14HAnf5oxbzR7QAD+ELUbhGyfRC5c0Tr0YFXw+zSY+B/9@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0eo+vFf0pisOdKhcggnXDQ7isale6FyjitSg1VVZ5MAQfVZuQ
	czdwLk3JDxWr8Zdvhmyn0BoXJnsM0DaLz9zo61a6mPyvVDhtPHDC8HfEhZyxriJgvdiGs2NwCxC
	+r0r/w064WOnSXY1CgUGpQryFmuboYxA2qbnSQQCACAbT6X0nkgoQcKH1clOzSRA3
X-Gm-Gg: AY/fxX52nEp3OQQR0MlEvdyqhDHdiMOhWtG7RFkQqFaKKR8M3ql2rVD+1vgSRAhejbB
	co7CSJKAURbgoknkHuctyGwTOzP0+tiE8Is3CrOzFlrR609CHh+xw13UO1subxLyXgMSajOwK5C
	Rwp52jgRzA8dmPmBtATK9xtdK0NYhBUDXf1m+NUaalZ/3XDigWnfGcEVoytk/auOLm64H+Zicjm
	OqLafAHHTBDjfdkBhFUU1/aEtXT3OWRKdGX9xgwuQj4z60RLkvd0iyBgNgju2WoL/GYcBkAS9yo
	79DOYQKxjtaXILvfLRAS18IRyq7/R6Caqb0Yrdrk/zq0iVc4B1lTKTx2anuLl0dCMAouTFPk8aH
	9XQlwDeM3ZQh//NuVv4IVHFgt4aYlkEPGwqUG3gfVemRdlGL/PyHG
X-Received: by 2002:a05:6a21:33a7:b0:361:2c56:fca8 with SMTP id adf61e73a8af0-376a94bf4d9mr48524653637.50.1767624441928;
        Mon, 05 Jan 2026 06:47:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE2wtrYbipNacalqk2LCQQAhAXGMY/TBWgzGU3+kj5xHT979UWEgYLatyUBSXBbg7RMrIfyjQ==
X-Received: by 2002:a05:6a21:33a7:b0:361:2c56:fca8 with SMTP id adf61e73a8af0-376a94bf4d9mr48524613637.50.1767624441406;
        Mon, 05 Jan 2026 06:47:21 -0800 (PST)
Received: from hu-pragalla-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f476ec311sm6634868a91.4.2026.01.05.06.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 06:47:21 -0800 (PST)
From: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
To: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, martin.petersen@oracle.com,
        andersson@kernel.org, konradybcio@kernel.org,
        taniya.das@oss.qualcomm.com, dmitry.baryshkov@oss.qualcomm.com,
        manivannan.sadhasivam@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: [PATCH V3 4/4] arm64: dts: qcom: hamoa-iot-evk: Enable UFS
Date: Mon,  5 Jan 2026 20:16:43 +0530
Message-Id: <20260105144643.669344-5-pradeep.pragallapati@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260105144643.669344-1-pradeep.pragallapati@oss.qualcomm.com>
References: <20260105144643.669344-1-pradeep.pragallapati@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: U9FVoZ8PD7UjXNZLm5peVIoSeZkR6Qzy
X-Proofpoint-GUID: U9FVoZ8PD7UjXNZLm5peVIoSeZkR6Qzy
X-Authority-Analysis: v=2.4 cv=OuhCCi/t c=1 sm=1 tr=0 ts=695bcefa cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=cMKPt8sKVRzp0kMMbBYA:9 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDEyOSBTYWx0ZWRfX5DAd3KtXRhua
 PjM3nqRjmBih5pUdXhnj1NDz1K1x9lOVUqDFp7ML+7SffE2ETUUC3URkrq2JpdINWAU++b1PUPW
 QipKdD+dj7V6dcKjOlYPvRGueIzwnsiA0AJUrtkDVbg09V2qq0VPdD9ZuwR9fcdaiizCVonT4Z9
 syVlIuyjipCQVVwNAEroqP3HI3sfMvw5ypabOlIabqeJzXIahoATmz2eDIw+ZMOuOSXmfScKZz/
 Ai2sHiGzRoC4IsRpCT7c51WIH3IQ/p3FGvj2BA/AxF/JKLMUGa0hDpCZUzVRAiHCZKjopPdWvjJ
 26evCS59FxfbpoLuXBuNOdkdb3RPcYOMgUas2ziNEeeH2hoP1BZ8u5ugMaESn+l/l/vVuGg4QmL
 3DDSrccpXmU2fbazxFat9Ugko0hTjoYvgA1VCBaha8jp1U1wRfSJZDRFCfGYoe7wXivL7SxHp8V
 /FTFCqIIeAGyOhtrtiA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_01,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 impostorscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 suspectscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601050129

Enable UFS for HAMOA-IOT-EVK board.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts b/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts
index 88e3e7bed998..23cd913b05f5 100644
--- a/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts
+++ b/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts
@@ -1253,6 +1253,24 @@ &uart21 {
 	status = "okay";
 };
 
+&ufs_mem_phy {
+	vdda-phy-supply = <&vreg_l3i_0p8>;
+	vdda-pll-supply = <&vreg_l3e_1p2>;
+
+	status = "okay";
+};
+
+&ufs_mem_hc {
+	reset-gpios = <&tlmm 238 GPIO_ACTIVE_LOW>;
+
+	vcc-supply = <&vreg_l17b_2p5>;
+	vcc-max-microamp = <1300000>;
+	vccq-supply = <&vreg_l2i_1p2>;
+	vccq-max-microamp = <1200000>;
+
+	status = "okay";
+};
+
 &usb_1_ss0_dwc3_hs {
 	remote-endpoint = <&pmic_glink_ss0_hs_in>;
 };
-- 
2.34.1

