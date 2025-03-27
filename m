Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7571E1DE4D0
	for <linux-scsi@vger.kernel.org>; Thu, 27 Mar 2025 20:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743108906; cv=none; b=LOms/dWw78tUrP8za4crGg7IZTqGEo17B3EzDoQEQRUdSavUKKNcs2qOqifb8+ZRLzQGbl8XDJG3JSQl2JiE5V1kHn3i4TqHf0OMfkcRh1C3WOo/fvsVseeJSfn6GLMPPM6G3a1PhI3aum2kf/MhIGpv4Hr4IUQEIKq6HZ6gsVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743108906; c=relaxed/simple;
	bh=GF+tNhKS0NGKG7yfNhdANlS+zkLxYeaSGBHz28Zf+iQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bTw0KY21LJ/wiiPRbf0iMNZGaE+UhGnE0y9i9Jt7pCMeVOvE+u2+R9RDWi4uGbcRftfylmNW9GNkHi2Mc24CIbE9mJhPj4fdcyehCOGagKzWvf5ARRxYhmsWswCuVxrUnSVeKxDFbAjo68YJDUmVEWUNgqCyMvDFxYxgBOiGlfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=KXNif2IX; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="KXNif2IX"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52REdQhR011742
	for <linux-scsi@vger.kernel.org>; Thu, 27 Mar 2025 20:55:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	k99KWcn22Kv/BaD8xTy7Mazz2sRmN24Z/pfpwI8GlMU=; b=KXNif2IXs6T4Djn/
	i4sM9DKSyVvH1fKzAEZJVJldkXS6Qty8lC+9fgcl/9n2eVj+E0dzOoqSyyBRMKEN
	o7HrNmi4hGeLJITabnjdmyB0wOSfsZEjpLJ+qRew4K6nftXk8FOnOi3de/kL2UoC
	4+90Nl5Wle0uW5AJ3uYlAOimfgIUJZ7D6fKgRsBFSGxcQ7ARAtUSSxh85phkZJJy
	YFnaK51X8BGC4dmFYDeq/lhA78GGFat/hcOKlOhSfw324/XMjbCYPjkGvgoffcAf
	IZJ+e7ydyEOOGkarMmGjI76ll+yj5/P9pLmNd8j8uyGnjtrbUka0EFuMYEX39yVK
	q7w5qw==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 45manj67h7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 27 Mar 2025 20:55:02 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2ff52e1c56fso3110702a91.2
        for <linux-scsi@vger.kernel.org>; Thu, 27 Mar 2025 13:55:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743108901; x=1743713701;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k99KWcn22Kv/BaD8xTy7Mazz2sRmN24Z/pfpwI8GlMU=;
        b=TS08SlbLJrDGuy2qxVZG8SwXu5ZGicHeU5tcXtmApmm633i+h0y25BySZUDL9bBZZ8
         h+Jd50piBsbNArTYXAjwB+uVSXqJUPd9M+cKbbSnuhrTP82jelY1lQtJvnm62taCP/gp
         WFJ9yhy8PSCu/2o/gH1OCh7Im0t2OKJU9MbuZK9nHtr5FwTCDARWZ0Ac0wQQG3yj0FFY
         nUUWqKmZs9ZiHiPLdb+hkULrcui0hELkaBm8mCNq63+o1POp6vTADQ4H3gZMoRSBRfPt
         d6SaJPyoGm52PvQ1rBCZGp8Z0KMELgiwkxEh5GAKUWrRMRiLCLJPI+CdNuoDnEvlykN/
         rwaA==
X-Forwarded-Encrypted: i=1; AJvYcCULSN41sC1/bsIRsbQmU6BvnUm3eqzl4JRQ/X2wCYpGFeJGA5RDUdHgv5mym9KQ8zukxNjZEvYTNtjs@vger.kernel.org
X-Gm-Message-State: AOJu0Yyi+X5hDieM6JPGhVU+x7578Np3wZ25KBAjZkH9wxgSkmGTgBQL
	RakQ1S/SaAqWatSZoFwqHlAE3AEXeGNwH45G3tlFmvri4I+0ipDVbh3fZv17d2UUx4a6saWWc7r
	E0qxDTBuLgipkAxWpH6o9oaKDO9Nq6BThzHVbaVqXb4nA364QKj3HRXxzutgQ
X-Gm-Gg: ASbGnctfe670Gvqp2jLFCTxynmaTqtShHp0BHSfzlACxAj1hQw4sZ5gLpVXHJEtG8fE
	TPkpqEfjPXlenOHCgBGoV3AOPv8gb5uGxJL+ksmW09MDLBixCC+qbZ0p0c6WgmrYpRDIAYxZHJV
	fAfUTdneksPsB5YuVlsO8jtm4iyyzwMya4urWc0KtPxoTBiLd5bJkoU+xJ6giWDzhS8/uSM4YZz
	sABnCldcrXi/Z0uKyYZgVpAqJHSsAlx1w44uAzsm5ueLhyvGpmQGYOZUajhaB26RCpUKwNOEukC
	RoA/Glu89UYl+Tcg0HKhFMWh5PAO37VeA0EPVe9mdWgKdfBIZp4O5nAQSWnJQLxhGsg+qwY=
X-Received: by 2002:a05:6a20:94c8:b0:1f5:79c4:5da6 with SMTP id adf61e73a8af0-1fea2d47f34mr7718541637.5.1743108901435;
        Thu, 27 Mar 2025 13:55:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHasiOtfj/2S9UBpTwqjAT0yKrB460ri2h4Rfh7vrVELdUg7mprX2fAHQbXNDqTRU1adHUsPw==
X-Received: by 2002:a05:6a20:94c8:b0:1f5:79c4:5da6 with SMTP id adf61e73a8af0-1fea2d47f34mr7718502637.5.1743108900938;
        Thu, 27 Mar 2025 13:55:00 -0700 (PDT)
Received: from hu-molvera-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af93ba10da3sm330889a12.66.2025.03.27.13.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Mar 2025 13:55:00 -0700 (PDT)
From: Melody Olvera <melody.olvera@oss.qualcomm.com>
Date: Thu, 27 Mar 2025 13:54:28 -0700
Subject: [PATCH v3 1/4] dt-bindings: ufs: qcom: Document the SM8750 UFS
 Controller
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250327-sm8750_ufs_master-v3-1-bad1f5398d0a@oss.qualcomm.com>
References: <20250327-sm8750_ufs_master-v3-0-bad1f5398d0a@oss.qualcomm.com>
In-Reply-To: <20250327-sm8750_ufs_master-v3-0-bad1f5398d0a@oss.qualcomm.com>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>, Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nitin Rawat <quic_nitirawa@quicinc.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Melody Olvera <melody.olvera@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1743108898; l=1192;
 i=melody.olvera@oss.qualcomm.com; s=20241204; h=from:subject:message-id;
 bh=3CU4DQyV0/viVrQ8BNTaqxvwVFs8M8ct8Q0UrUVEtQ4=;
 b=gqI/dFoFrkNVxeJmU5J90T6vfTNx9vZ8rcCOnnp3O7svt/u9Pvnx+oSGeSMskouQHh6L3BdE8
 Db8F++0eobjCxiqXnj8eFbjnYd5Tzz1pNDnJXl8tzkcoqCIMJIGBQ4Y
X-Developer-Key: i=melody.olvera@oss.qualcomm.com; a=ed25519;
 pk=1DGLp3zVYsHAWipMaNZZTHR321e8xK52C9vuAoeca5c=
X-Proofpoint-GUID: AmlRq2iz8PbPo8U_Zcb6obO7HxfN9uN4
X-Proofpoint-ORIG-GUID: AmlRq2iz8PbPo8U_Zcb6obO7HxfN9uN4
X-Authority-Analysis: v=2.4 cv=KvJN2XWN c=1 sm=1 tr=0 ts=67e5bb26 cx=c_pps a=RP+M6JBNLl+fLTcSJhASfg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17 a=IkcTkHD0fZMA:10 a=Vs1iUdzkB0EA:10 a=COk6AnOGAAAA:8 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8
 a=u0-Bzi-a7h-vFBLzmccA:9 a=QEXdDO2ut3YA:10 a=iS9zxrgQBfv6-_F4QbHw:22 a=TjNXssC_j7lpFel5tvFf:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-27_04,2025-03-27_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=845
 malwarescore=0 priorityscore=1501 clxscore=1015 mlxscore=0 spamscore=0
 impostorscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0
 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2503270141

From: Nitin Rawat <quic_nitirawa@quicinc.com>

Document the UFS Controller on the SM8750 Platform.

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
Signed-off-by: Melody Olvera <melody.olvera@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
index a03fff5df5ef2c70659371bf302c59b5940be984..6c6043d9809e1d6bf489153ab0aea5186d3563cc 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
@@ -43,6 +43,7 @@ properties:
           - qcom,sm8450-ufshc
           - qcom,sm8550-ufshc
           - qcom,sm8650-ufshc
+          - qcom,sm8750-ufshc
       - const: qcom,ufshc
       - const: jedec,ufs-2.0
 
@@ -158,6 +159,7 @@ allOf:
               - qcom,sm8450-ufshc
               - qcom,sm8550-ufshc
               - qcom,sm8650-ufshc
+              - qcom,sm8750-ufshc
     then:
       properties:
         clocks:

-- 
2.48.1

