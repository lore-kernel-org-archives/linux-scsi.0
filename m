Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED41D3FBB5E
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 06:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791354630; cv=none; b=KzHBYuWHauCIi49GUFs+ms+UAhcsZa2nYQ0rVXHBgJFCAaogfV79SXswClZHjf+UGiWVMhX6+bypcujeMSErsyYDWr851JrMGLvOpSPwHssjY0RErGXkKDM7krppdL8kwE7bdBa9WOm5IU3kRG84TZLp0Hls/ZywGY4VNm//yfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791354630; c=relaxed/simple;
	bh=qZOq97SsVPti3oQZnFWkZh3c728gDdolT+V4/jasJQk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=N3/AkXjYcuoKR+bYzbw0zZzmiVp3bymre5QHRlMU+c/kYhyvtGtzj92aKnbYpGXdksoO2bdCVxmkgcs3bhwpuL/6DhxdC9PwoSm2GDOwhdqf47+06rs9rNoJHSKE/MsJ3hJezhZnPjXdMl+zpC/a7Hc9Ucb1M/AxDzSh19hFPKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pmkvjIu5; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Cytya23i; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pmkvjIu5";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Cytya23i"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6974U2Hg2295029
	for <linux-scsi@vger.kernel.org>; Wed, 7 Oct 2026 06:30:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	IE7TTEPp+mYjYOJnw2S5JdN9e/VGEB2SwjVCAm8BKAQ=; b=pmkvjIu5pTBucmBx
	ZIW+KsjFyYfSfxpsR0enCF/4gAZ6g38FIiKEOHbwAPV7n2q3TeopIgpRIRX/Ibe+
	ks2mqnh+BDvMVoRMvb7ta6YNjSvOC5AmHB3eN/JHoieqILq7/A9dyvSfclTXaKma
	yd33B1dZPVNVPJM+xJ9QZe/3auqOU1vjvbWJqH1OoulH3vcEMkhfILdNqbP/iCah
	DMp0Zcy6NaKSyaHXYxmAp3g6q+UZ0ESnpMseDEoeGJXFCnORFf3izmD0b7p/2VlJ
	jjSOxc37ZqrKRNDr2MlVkGT4mRks6uPW0A6nvtr9W5I4yoYZH3BnzQ3IyesbJO6s
	+i6slg==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5c1s0wrj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 07 Oct 2026 06:30:28 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38ecc48b3c2so6758127a91.1
        for <linux-scsi@vger.kernel.org>; Tue, 06 Oct 2026 23:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791354627; x=1791959427; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IE7TTEPp+mYjYOJnw2S5JdN9e/VGEB2SwjVCAm8BKAQ=;
        b=Cytya23iWiKNFBrL/oEeqIX5TUAaP0bBm4CU6MOk8zmZox0fehUe3HRIDcAXyCT7V/
         fbiDKuPUefPp79iUSrLdbCFsKhdyOdi08kkDyn6lbNy6NtoZFM9Vc5u55HjHFCkD+O+p
         jEoCNVBxee8zys4GIhOniuMF8eCQBp8WH7x67pToCHmkxVKRbnN1FRTzoXIvHPxIWrnE
         AtUhit1HuCSuXNB3+0K5g4b931ds7FLmAGbDDIkouTnaDdhRNGUcQEd7HzkQNGvanfAb
         z3l9JE8M/nSo7bLgWgjhX5jtKYIFFQCIgVPuWyEgALyqoKv957ZepneZPRYsgRkip8X0
         4BBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791354627; x=1791959427;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IE7TTEPp+mYjYOJnw2S5JdN9e/VGEB2SwjVCAm8BKAQ=;
        b=QQFRpdUZ/jULDDBKENRnRQCJTRAnmhyDwNmyI0Z2yOASHHYLhVD//6tDGSgjU7t1it
         aeMt6QWg47jEqNVM2XHuhEBTFhN7pbBsVMio2ZhOysQf4cYr/zE8WVexNjvypiuPCSdH
         bhx0fGOR3zdE/FAPQUZR/eN87IkVufF1x1Wy+mcJlyD2snCT2eZVNnywt+5z2mMg7M0R
         NW+/v/DUAL4MGW8SaN/sqmR1HHddtCwRhIYjwzfhTfhb5VL3YfP+0O7+5LyoEo9ryd4G
         o7bhziFuquTuAPQsaSteTUzBu8q3N8GRk4f+Bqz6C8Wnkg8NMSrSjy0xrXpZLmzp1EHZ
         Gp7g==
X-Forwarded-Encrypted: i=1; AKwUvBzRH2uYpukK6MQBl2hBZCBn2bAI56re8ybiS+wK9ovNz1DSGqLkp4CujcXYkj+Z3U7VBDfWYOInY6PP@vger.kernel.org
X-Gm-Message-State: AFq9FYJS2rIJ2899ctjIyIImyDzZOeh5Ys4ULHzHhQqTUUDMaWPHcTne
	Bkodz0O+8RP51L23cLUp0gYpz90UPuUUABA2t/klPzIiAk3hi7HHJFCaRXtnSMaGw2pIPCNxF1a
	tbYa2QtdIvtClh50xANyotwFMIaeb9vWHNG1NPHYuHOw9kjx4DRVXAB7Jm/SPu3oI
X-Gm-Gg: AYBFou1yEF1A/MSYlu+xHpSVhbZq+Mh85MD+v3C/5DKUJs5qaq+5icueRHq3pEnZkJa
	K9mrBQf4gGfE1Iu4qnwuFuwIyN3rgnivFP/Nb0Xsbf+QV0QIO1ogOcZnymmlfQDZer5YFwM7k+h
	9CMnWD4UZFwNHly+GdXsT1cYmFBysL9A1gYvI0M8iJaKrAKesl0ojYQJPPTTJky2JOVnnKCXbE8
	oot+f2l5GV6Qs7Dc5OfhdzoRLaCX0gycHyU4nRhtsSX9A+If0XAdpXYaehMxIj/mO+5EP619+HE
	jfFcu3R7QD2alhwhDOqB2VWnZx/45eNkbtUR8GhxpNeZa+ZOpIduIGmsn+KK6jLwCu6LUD3d1r1
	N2SMzjIkdjO6II6SL0l+x+elZmg==
X-Received: by 2002:a17:90b:3d90:b0:3a0:8050:2ed1 with SMTP id 98e67ed59e1d1-3a8a14f00f2mr1079281a91.63.1791354626864;
        Tue, 06 Oct 2026 23:30:26 -0700 (PDT)
X-Received: by 2002:a17:90b:3d90:b0:3a0:8050:2ed1 with SMTP id 98e67ed59e1d1-3a8a14f00f2mr1079250a91.63.1791354626269;
        Tue, 06 Oct 2026 23:30:26 -0700 (PDT)
Received: from [10.213.101.15] ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a89ab81bb0sm2972690a91.5.2026.10.06.23.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 23:30:25 -0700 (PDT)
From: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Date: Wed, 07 Oct 2026 11:59:37 +0530
Subject: [PATCH v3 4/5] arm64: dts: qcom: glymur-qcb: Enable UFS
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261007-glymur_ufs_qcb_enablement-v3-4-84cf4f861415@oss.qualcomm.com>
References: <20261007-glymur_ufs_qcb_enablement-v3-0-84cf4f861415@oss.qualcomm.com>
In-Reply-To: <20261007-glymur_ufs_qcb_enablement-v3-0-84cf4f861415@oss.qualcomm.com>
To: Vinod Koul <vkoul@kernel.org>, Neil Armstrong <neil.armstrong@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@sandisk.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        gopikrishna.garmidi@oss.qualcomm.com, jagadeesh.kona@oss.qualcomm.com,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        Abel Vesa <abelvesa@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        sibi.sankar@oss.qualcomm.com, Taniya Das <taniya.das@oss.qualcomm.com>,
        Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791354585; l=1034;
 i=pradeep.pragallapati@oss.qualcomm.com; s=20260911;
 h=from:subject:message-id; bh=qZOq97SsVPti3oQZnFWkZh3c728gDdolT+V4/jasJQk=;
 b=kVxyYawAfd/MZUrRf/KK1FO5NfQZ3kO/Y5bJ/87gcwx4qFu1mHbh9wGu2di32gobLhkPD/kuE
 D6E9PjTCgNTBVUDYVPte9vN/OVuX7rLYaDXZORiDR+T81LeUpfB8WCd
X-Developer-Key: i=pradeep.pragallapati@oss.qualcomm.com; a=ed25519;
 pk=uyRUsge8nQMwf3iW/e/o0U8z9nWLCMm1MGKxEftztic=
X-Proofpoint-ORIG-GUID: yOPxGjf4Cpmb9vv1F-UEBX-51ezV6JK0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDAyNSBTYWx0ZWRfX0O8S1FGKMrQP
 4r/hf49eDmPzArEs5cpOmu2iEvcOYqOGIgqpmeTMNUpiyPWRfTYOtC065hpEU9+fnhPziJxjumv
 GfcwKUcyYEs3W6ykKZReawbB8XXr7W6b5cbRThm2EZVrcJ323xSqV7I/q7AzulizNV6wCDrLj9O
 bw0VkSGhs4rqJClJQPtA+A3IhKqaNDx/Lo3O8U31nz+XZ7BFRt5BTs5fa+nO2RuNjMfWGpeCca5
 IFCcRqt0qN7MgwuagxBUxufwb+hqoUbgtyoBRHcsKur39oRD4XASjlhmkfrXLEsHtosBS57MXPj
 HQZReTKVjyfZDlO81nUBeKhJ14GC5XC/mFOVMPvM8MiF25RnpyW/PI4ZdFwaigAHPnDBRDlp4/m
 aLYQOQ7STzOdqHHRBUcTW2/tCP8X2U0efZ3b3tp287BXLyWXMVRv3CsFC0wL0eOo8DJ8oetO7ta
 72vTkCuca3aXJU29onA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDAyNSBTYWx0ZWRfXwrK2fBsHjK8G
 kk5j8HmCvZSMLRFBs3Em1WMJDd4TpOviPz/GMyTLz/U6SoMa442Q6g3lBGiSFtzAsV9Q9ogPlD7
 c+tfr3xBUingBfUAPdZtMALrXkACRJc=
X-Proofpoint-GUID: yOPxGjf4Cpmb9vv1F-UEBX-51ezV6JK0
X-Authority-Analysis: v=2.4 cv=NatzRGD4 c=1 sm=1 tr=0 ts=6ac5e704 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=cMKPt8sKVRzp0kMMbBYA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-07_02,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 clxscore=1015 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610070025

Enable UFS for glymur-qcb board.

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/glymur-qcb.dts | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/glymur-qcb.dts b/arch/arm64/boot/dts/qcom/glymur-qcb.dts
index 17d8ff3aed23..f17181bfeadb 100644
--- a/arch/arm64/boot/dts/qcom/glymur-qcb.dts
+++ b/arch/arm64/boot/dts/qcom/glymur-qcb.dts
@@ -697,3 +697,21 @@ bluetooth {
 		vddrfa1p8-supply = <&vreg_pmu_rfa_1p8>;
 	};
 };
+
+&ufs_mem_hc {
+	reset-gpios = <&tlmm 250 GPIO_ACTIVE_LOW>;
+
+	vcc-supply = <&vreg_l17b_e0_2p4>;
+	vcc-max-microamp = <1200000>;
+	vccq-supply = <&vreg_l12b_e0_1p14>;
+	vccq-max-microamp = <1200000>;
+
+	status = "okay";
+};
+
+&ufs_mem_phy {
+	vdda-phy-supply = <&vreg_l1c_e1_0p82>;
+	vdda-pll-supply = <&vreg_l4f_e1_1p08>;
+
+	status = "okay";
+};

-- 
2.34.1

