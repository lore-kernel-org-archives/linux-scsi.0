Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3122DF12E
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 10:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767176477; cv=none; b=akO/Gv1K8zgIw1b1fd/uLGoIcRAkEzVyrHxEDw0UqkXNXeUo5MuHwy0ybrtzKP+5QXiJbGBcp0XMWNQ4v7BOSc/CGvZV3TspUVV6y+9sGlwTR6eB81tAgw14XAY8Ti1z5ReoyRZ931NvDUifx2FnIysYlx6uUs8+SofM/6gcZJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767176477; c=relaxed/simple;
	bh=jJ6O5KkP658Kzoen1OLLHGHGjbrUHLY0oOPUXGr5BJk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UEks4OHdy3O2JdV/sDvJcmE0hwmvi0mD2Fqo5iF+lRGm0HaDjp2qIxPKZDJEfZoZT/kF6GkGrH/N+2daGQED0vSEtUtANZIlLA0kUi5IXvdweaHoPWfOy5Uv7wpe2GbRTAYFj7cp+Z9nVz4QK9LSBURXZiV6zgipSIhkgx+L69g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gJMz9/Kx; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cDQpU87U; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gJMz9/Kx";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cDQpU87U"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BV0FwLo3068883
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 10:21:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=nzPReENl5jq
	P24RO4wk7cW8ZGHbcPiBK7hn8rIfW3pc=; b=gJMz9/Kx28vsyy5jyipqEuoI3ru
	eNTFhuImHSb/mV/yQoxTRXxGyS6g18f5u6TyOCH6c6m0VdFl5UyawL3BESdOqy/p
	kp1/K/lCV5+A4oUN/eEJcp+dMmWd6I83RnjZRkFEg75CRSXYOECFGOTgMolvEqgx
	FriUwsTaVW3b9YFmkkfCQfAyN8t6QsvlkmynlPxnyS/NR601vLXGwpvOWI969ZD/
	Fhqxi6WOlYGGcLirzIQQ3zMIWXVAmxm3KU6zIrihLHQcfGwyTWz6Xu3/e1uX5lzF
	DQ9O40LUfowITMQ41rq82/jO/LBFnOAJ5JZLu5ROM8djaG+cgR02JefPOcw==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bc0vdm48c-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 10:21:14 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-7ba9c366057so27441953b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 02:21:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767176474; x=1767781274; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nzPReENl5jqP24RO4wk7cW8ZGHbcPiBK7hn8rIfW3pc=;
        b=cDQpU87UeLLYIA0Msp0qHtXugxjzcUIKvLUUw6+L3tcPI59tWTcp5DG0u5EqiW80Ai
         i2+wBDX5BvkPDKI9vZCx3kk6UUOn+J7OiEBGfPxbWXOaO/V/NgVWs9kBPWNh6QdunQEW
         BXbNNA16Mq1d/LUls6F+T7w5LiqRWbBDFcnhbzxpykHpMOag2UC4b2vihartiv0wDffu
         8oMOwJt7V4XmZa4aHV04lfltYjJ8s+HJyVm7RxI4cQtVPDsKMxgDXm7kJwsOnQY1Zcln
         fEBpaGXUqzhkTJsDNeiEDs11gj8MlBknLXCND+TXT9TyxsJVo5az4dJ2N9lnLKUigHhZ
         liDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767176474; x=1767781274;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nzPReENl5jqP24RO4wk7cW8ZGHbcPiBK7hn8rIfW3pc=;
        b=XkqXUEJhXlUtapNQii9JCILIO0HuyU62n/j7ntmFhOsIcTb5E4X8IDuVRAvbuzI4mT
         H1A7E6+R664U2Vh5UoVMr+leWQ8ghoMa0FbX0xFwXsxAH/PUNn1fNxvYbAblwCZphwpP
         f3a8gVlKk49SMqZjPXCOm8/i/340RiIkC3DNMWRjrKPIWXjA1lC0mYJ1SelYAMS96qUx
         Xpgqu2XcT5/iJyqnB47Y86/B9ZDmc/Lja4BlE7mroqKFiJjA+1lvYGGnjqm68oTKqSOw
         GNXQIAT1JqPSIiEhU8Tw8gj+1f6GDNMxE5E/BmvHjhkAWSrpy1YLN+g9NlBXQdtsUxz4
         7aHg==
X-Forwarded-Encrypted: i=1; AJvYcCUSK5/yyAR60Dhmzi1aWrdidWrxcQQBefq8ymkjkRqW5EFjXIOacOQriZAbg2d8KYZG/f+Bxk477ZXj@vger.kernel.org
X-Gm-Message-State: AOJu0YzSK9aMYUNsvlaBXg2OEHM6tR1jNqGmHulyWQayKRMzSFxAgG2u
	nGU4ygy+SpyFl08Ayscf2a7fghv2dxOQo5ZfxSl7O98HBDlfw12TFGqUZVWVdMKVnEn44cxnE0y
	0xcFOgOyz4fEbc/JSnqiTo2yPziEb+O9KNEHcfjm9eSMtvA2FqehxUeyBkusS/W4J
X-Gm-Gg: AY/fxX612EXxM/1g78QEqy6oHw3JJ8VrmjsLoPt4+Kx6e8A3lSvqN2KDbILkzrhKhEZ
	Iwn0it9UPpWUzCUeWo5y1W75PZRg+uONEiTKpA1d4LC8qars7Q6LjvYGh2S8I328bD3ahfO4Hwj
	F3F4d3+CKII/1tZrrOGy6kgDDsOIQURxD83zT5wN0DRZsJenIHHZI9Biv7YSDb3Gsn4AcDrFrUZ
	ihbp6p9jx9MmJLXNJ69d5yKZcfHbqUNWerLjZRePgoRLl+C3Kog0TFo9GByaVxrG3pUCWKBu7Mx
	0KN4OzjLpl5ra7jorjqkH8lLwaziCo/0Caoaro2EVQbgyKWQW+SIce4gHK0SmKumSu28NXJNPT4
	YifEvRNJjth4EZuldpyDfZXpDmmbYkU4pHVt0v/5vdaH7vFWGYOIU
X-Received: by 2002:a05:6a20:258b:b0:366:14b0:1a3e with SMTP id adf61e73a8af0-376ab6cf789mr30573504637.76.1767176474043;
        Wed, 31 Dec 2025 02:21:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFy2a0ud3renotrFDPVYfZzPw7C12wYHHNp4u5pkRVwHNh2m7YvZ22IXQudwiY9TrqklLPVXw==
X-Received: by 2002:a05:6a20:258b:b0:366:14b0:1a3e with SMTP id adf61e73a8af0-376ab6cf789mr30573474637.76.1767176473559;
        Wed, 31 Dec 2025 02:21:13 -0800 (PST)
Received: from hu-pragalla-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e9223ae29sm32163920a91.16.2025.12.31.02.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Dec 2025 02:21:13 -0800 (PST)
From: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
To: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, martin.petersen@oracle.com,
        andersson@kernel.org, konradybcio@kernel.org,
        taniya.das@oss.qualcomm.com, dmitry.baryshkov@oss.qualcomm.com,
        manivannan.sadhasivam@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Subject: [PATCH V2 4/4] arm64: dts: qcom: hamoa-iot-evk: Enable UFS
Date: Wed, 31 Dec 2025 15:49:51 +0530
Message-Id: <20251231101951.1026163-5-pradeep.pragallapati@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251231101951.1026163-1-pradeep.pragallapati@oss.qualcomm.com>
References: <20251231101951.1026163-1-pradeep.pragallapati@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=dfONHHXe c=1 sm=1 tr=0 ts=6954f91a cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=FwCcbryfLnLJMkbT1zkA:9 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjMxMDA5MCBTYWx0ZWRfX2Q+NqIB7eaC7
 5JPLzVz+WT+Q0DBuaxFRDXqRdfoB9i0SFDQ3qZOBdBALO1Hzp2Htw3539L1papSCrGcxiz3b2Za
 Dg4UAlnYpQhlH5Bhr6LPDx7/XCymCDOz0vS2Z3ny3SNGkEt+5s1Sfb/0DYEfyWiTIBsvh2MGm8P
 ridBmQRYmW31Qa7xO5GHDstejNjYFfmgebcTM9++fESmzohyMvjwjzdNbzgJdq6xxGumvHS0afm
 x4EvQzl0JwDXod+bubi5CpEdzTtQuQftWBeVR9JXgnSm/Y0e0uqbWidNCwHPGanXMVs2hia8brf
 kVfSDKlK2iscQRaDC2sHdoFZbWfZ3vTL5TaShU1qeFOJUCIV4Xh/qAbpPUQcueGsr/tVnM5wgAQ
 zWfS6bUahg/4t/sGx+W+5OJyuI8i8hPap6eFz+1L3DLEfbjjvDr+LbRqGh25Wku0KRdvzC7rm5U
 O4Yt9hMZ4U9TuDhSLmA==
X-Proofpoint-GUID: FfYOZ3CVPF293iV2HOXdCDbwdM3kf4DE
X-Proofpoint-ORIG-GUID: FfYOZ3CVPF293iV2HOXdCDbwdM3kf4DE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-31_03,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 clxscore=1015 phishscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2512310090

Enable UFS for HAMOA-IOT-EVK board.

Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts b/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts
index 36dd6599402b..2b1e643975d9 100644
--- a/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts
+++ b/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts
@@ -1190,6 +1190,24 @@ &uart21 {
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

