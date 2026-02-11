Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA66249EB
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 13:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770816616; cv=none; b=qm11n9bB/JmQHvzRWKlNqg2Ad5BYC2DQfPGRHA5iG2ZCT+0Own7SAXlsWzQg9//eNfa3KU8+7eDN5tWr/ZE10gIdgzUrn16R1ktgxGGS3/fI+RJWIDfj/CdCBepCGzB5jMciETISVuJnZIGcXFim121asIBtFxslEBLqGE4Uatc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770816616; c=relaxed/simple;
	bh=gdujZ99MevCVsCb4NBaclIUNi1Glc0RnL/gPWCQ/g1M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Nt/0zw6WFBob3NiCLEOpByM1au7lbuNEhMezvZ4G3AgFqwGtxhz7AfCvUfoRihbNMrNcvoU1rxv5srlBTkJbo2DPlZDBXMZWRxIQ7nk+lQQhNlvEzV5/ZKvFbIJlLfKQhJdVwRqxqu1iwN3AgHWhkkSPsn3T2tzVywf16G740SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hd84I2QF; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IYffNPSU; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hd84I2QF";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IYffNPSU"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61BAHSbq2297566
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 13:30:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=yBxQPWSZi11
	Gi7fw7yJ514mCuqG/sJlj9eUQZXPJahI=; b=hd84I2QFoG2o8wydmcKyOdgB8VC
	zvLHHYCfmvquU0D6I1mPVBrcI/y4ZqTQis7+VGF1L0JV/K3y2M7T5n5s++hSpQ16
	fHCNLBbYLBLwcf2EQOKRn+213CZ1aRSbdABqL5PIx2ODMNRGwK+B5JU5Le02N+s0
	ZvKWA0Gn/B76KmJ6pNFN3NeJXhktYJNs8JCb2rfNQN3c9TEm2yaV42mf2Ov+x75h
	wnMqm+S3fb2nYjWeiLYxHqhHbJmimXhdjaubz6g3+61eEwdSC/fHfWnl+BwO+wIA
	rOoTUmC6NAP4snoXBokUMlGflYpS/RiG98gt5I8GrjABQbLKuhTLz9JWcQg==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c8qvq8hhx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 13:30:14 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-82442b44d94so2927011b3a.2
        for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 05:30:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770816614; x=1771421414; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yBxQPWSZi11Gi7fw7yJ514mCuqG/sJlj9eUQZXPJahI=;
        b=IYffNPSUWCZOQqzKMnSyVhc160unRrFaoS30Fiyd0aK1GrPw8euciOKKGE/a8DmadT
         8q+V1FAMUnHnBdY82GgUKeCfJM/QPUeI4ptjgAMeXPJZW/JvSpizn43CBLsUds2cuJCY
         XP9xmSonN6pFo0MKlM0IVQCA6hCc+SZfcWFBKSCnHXmqRStgnTJw3RSvRCe361jWNDal
         fZ2O0OpjXvcBWbG/m7cLQ1PeP2UY0vs/I9M0HseDlLUKh3sU/UBRQzWXwaTSQdpCbU6p
         kEKpqRde3LjMoJR4XFOHiQNGUz0W2bCBvRWqQU4mBArZ63K//O7a60Pu1tF7qh3qpxRd
         KtwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770816614; x=1771421414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yBxQPWSZi11Gi7fw7yJ514mCuqG/sJlj9eUQZXPJahI=;
        b=q1zKfNaAmhZb+iTta3Uzof9TtmmpB3zkCx9jEzFE3ryrjvWMQbsVZo+GijKktBpNzL
         bIAjhkM/C2LSFB6OW9acmfMELTnm+ukjo55ffJ7oDnH7II9SrbRxG4CBvoAaKlXlA+GV
         oAkjA+BmpLmTDPeHo4INGU1r5MJQGUM6Xm4JLwB/o0W9tps94defH4jciJ2vT6P5gmFf
         ccT4KfyyxW6zxYN3GlUM/zTLhI1piW8GRY/5iRQ7crjwMkgoCotraaX6Hy5tjKW6HVlq
         UAy/R1CA1JsKPMnGJcavfIaLQ+bgF+OUaKnVG0kcOmEqN8TAy1XTGt1OnQreHd7BSeXS
         ZpdA==
X-Forwarded-Encrypted: i=1; AJvYcCXs+0elv3Dzfrm9ood8a1LY82JiHdI5UJpFW+K1x3Z7zb1qwQ8PJS/2//pbovZl+4aMnGQ8YhisztNa@vger.kernel.org
X-Gm-Message-State: AOJu0YwFKySzTTsssunlDhl3bFb6WJEGNJqN1ti0cVPO8cvYJGmKUxmW
	LodpGCBu45n0sOEMOhevhDczcAj7HwoVeCDwAOl5/fLbe60xpooO8IqelnWHucXfD5jJkIkD4Wv
	RQ7SxuOvTTr3Tv/9aBVRWTAJpqHq4B8UjZkBoqRjv4qBEDT5sLRJMMX7uLhZl30ut
X-Gm-Gg: AZuq6aIIf3E41is00f9+jPbJoGX2Ks3TAtKvZEkQF8QgoVkNV/DjvdpwzM5fq63Y/Cj
	uT59qZzatjPVMZ5Ort9fecB3bwuMGUQpxnpAom5ehDqwTogNaFknI5VUhNoKARGL/ol8zcOb3R9
	5ebFUdtvvUrFjXg1h+YVQhWs7ufKdIsP8F7LOTRVxwrT1yy7AdLVE7wov+WFQx4RuUamNplYBsO
	YzUrtgdi2ku//m7UL+KhrV4Ru5ACA99ij1QTNxoib5B8slt41o2q7WBAZmdVn9AohtBgtDZej4D
	+lRsNZsTi1PYEPk+eNHki5PSjNKpFchlls0uOP+BuW4ddAGdk+9aMI+5lmxJ9IAONrxAD6X9dNp
	Eq/HVXp0JrxYhXWq2WAk/Y3m/uNyZGUKtaabvTygfp9pwUpww9HSchD6US/dGsLfu
X-Received: by 2002:a05:6a00:6ca1:b0:824:374a:1402 with SMTP id d2e1a72fcca58-8249fc25cbfmr1597580b3a.11.1770816613599;
        Wed, 11 Feb 2026 05:30:13 -0800 (PST)
X-Received: by 2002:a05:6a00:6ca1:b0:824:374a:1402 with SMTP id d2e1a72fcca58-8249fc25cbfmr1597539b3a.11.1770816613061;
        Wed, 11 Feb 2026 05:30:13 -0800 (PST)
Received: from hu-pragalla-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8249e84bc1asm2143655b3a.58.2026.02.11.05.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 05:30:11 -0800 (PST)
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
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH V5 3/3] arm64: dts: qcom: hamoa-iot-evk: Enable UFS
Date: Wed, 11 Feb 2026 18:59:26 +0530
Message-Id: <20260211132926.3716716-4-pradeep.pragallapati@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260211132926.3716716-1-pradeep.pragallapati@oss.qualcomm.com>
References: <20260211132926.3716716-1-pradeep.pragallapati@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 9Qj8cWPuD5jsYOPDYEVQtMH0zoESPJgM
X-Authority-Analysis: v=2.4 cv=Q77fIo2a c=1 sm=1 tr=0 ts=698c8466 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=EUspDBNiAAAA:8
 a=VwQbUJbxAAAA:8 a=M7MUb3q_Ox69Zn6kGXoA:9 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-GUID: 9Qj8cWPuD5jsYOPDYEVQtMH0zoESPJgM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDEwNCBTYWx0ZWRfX8Xb7epW2IR3Y
 1iPkobFaQlv5WK+rXV44WlsCyjToX+tc4/MWslO+e07kw2yVOxDjBhXXPbArRb58L5uruFCYBdW
 r0DqHtfnXtvZnisoHzXGjvaFI7/bQHAgMI9AY/42VxkbEwRhSEkL9Cm8+ibR+Y2bb2pIoL2fm0v
 T7RuyAaaiEOpmTC2dROEUjd1PEB/o0cHgNBtBKDbPSuNrPhNQv2Bil/zEMSaz5ayCFFUb0cHSP7
 w+r5iYa0H/NsYV/IYK1R6DFc1Wvlc3gfNXQD8B9mc5oDg3Ad10xRWbYcxad7EEKURU9/uOvYb8i
 S0rGl6PLZZbxs4Wjbs2DjqlY5GFLTDu3KzS7/ygSR6wQUYM86QmgVc0+DvLRPEUnRgf5v15pYgV
 2+ai9QKt1MpVwokzPDGK7SkYk4uNj4l0bQ2vtUQQy0VFKlq9xz6rAfsVQ9Ln0RxTqX5rjqQxh2c
 CPaRE9q3VNUooGgDd8Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-11_01,2026-02-11_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 bulkscore=0 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 priorityscore=1501 adultscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602110104

Enable UFS for HAMOA-IOT-EVK board.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts b/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts
index 2390648a248f..fccf1d1bdc60 100644
--- a/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts
+++ b/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts
@@ -1461,6 +1461,24 @@ &uart21 {
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

