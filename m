Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B8C3909A4
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2026 07:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777273256; cv=none; b=iop5gvertY31J0inCsof1E8hC5MepbfrZrxESC8srNm9Fb/CI5g0arzDE3ni68LZFnYQAlF6ZgdpOyRCpicDqyF6nlW4joNd/Exwm5DGLD5a1Sm5bJGdwmzNBdKCnHU4ilrLQr+a4/DvKWeK+StukVzoDO+3o7KoPJGD4vqshrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777273256; c=relaxed/simple;
	bh=reVwFnXqG4JCPAGIR03O9xtNh97cp7Jtw8Z0Syo5YXE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ajinXZRhdY5ZsIJjyD0h1VT9k0WQPxxqyjDa7mjCu+6N89s/Qqywt/RFSLx2XYTBpVFHyw1ze60FSbwCOtfNlrJg6cTbBcV2GiK5ld7nEE0gbxbWf9X/arnTZfNRcrg0ZJUoipe0PaKUi+UFRevS6AuhMEYpCkfXZfANfVW0ae8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MBRJ+ksc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iW/NT6Jn; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MBRJ+ksc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iW/NT6Jn"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63QKqa0V289376
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2026 07:00:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=lKM0gON4wq3lFQ9OTFi8OQ62Hdqmr4RmfkZ
	3dDyXj3I=; b=MBRJ+kscV4vUf72IjvT1JjwThzXsd7yE0d+xSBWtGvTZkQ70uLI
	OLl9PnOY01FzcsPPM5CGkN8DRrhruU6W0qduuefIWDdicGdrwyhA49X56Mql84t+
	twuuIRmB3EPjeQiX22fECHV8xMPDYiWa+nLiWWbu8uaqp6o3tBorvzcffDlFbo58
	EElklQTRogHOr8WyA4qKDnUYNu77xWe6q0no+38kMPoGBjor0JSezT4uKzhQqbgh
	c6vELuK0tGKoX6kr9EOEeUghxZCEG+VDkql6tlaccjooKbcfrIrWHGpatrKGMYxi
	zkZPvE57s2Z8l9kvj+9/evMhGMCBtxXDxQA==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4drpw9cpmn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2026 07:00:53 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-50d8e8c47a3so262750541cf.0
        for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2026 00:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777273253; x=1777878053; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lKM0gON4wq3lFQ9OTFi8OQ62Hdqmr4RmfkZ3dDyXj3I=;
        b=iW/NT6JnOLZilUUtwr4SArs6JeJO0viwFsdyYBh+4YaVhhFT3q/OYynE1nB23nWOgA
         yLLMsE1xMklDk8yLcnE+eBHlxEX1CuSX23RY0+RkOm2vzy6StvhlRJtBhV0i7MO2cGip
         r8PTl1R0AdB/XqH7BnUctNz28gZ1hEZ+dR981me2Ib81YVEmX9g/2z8ahD3baV+jj1dP
         EO/W5aCEDSTff0FCXfKk7e+1rYJbFp7VJzyUsIi9/ZEkM5OBtE6/D+5fd6O/ynDe/vLy
         tO18wJ9VxBDwrbqQK1aGBAznSfEfR2QG2C3mYOwBtLjYUpV05zbHfAvLIZxqIguspfpm
         E5zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777273253; x=1777878053;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lKM0gON4wq3lFQ9OTFi8OQ62Hdqmr4RmfkZ3dDyXj3I=;
        b=H7figz1t8fvK4jvZ7AYGcCnOIf03IpsvsVIE72OoymZusySNI5pVBoLtGAS6ZfBiFc
         Etxo3ETwGRTOR//oRMCV9dh9WxdBtzMykwrDdWQOIotxRVeUBGXxPsd11f8U75n75A8t
         DsNZ7K8xMLjqkmXjBQFq6U5u2PmqQ80DgxspP6nv+uSeStKvvHOkbRG7uCUJg9+oRnfU
         RJbgX0FYi4Qa+9Q24FT90M5gIfO0IHAbfSG+CEdsHvXPL8RMV7XpK1wQOqrfxIZ3adL6
         wpX4pIbC29Ll/qqlPPCPjonSdr+IsHRjhV0oM1mAdo7iNZs5Zhs/eJuh6ihNn6zVJmJw
         Fc4w==
X-Forwarded-Encrypted: i=1; AFNElJ9I/q0pX/QNHFAcuuQzRv5THxa4RJuZzLkckPsBU7bF1dAhKmdbFFwYLPOXHt4widQNp8Uh9PYIeFNl@vger.kernel.org
X-Gm-Message-State: AOJu0Yzs6Vkcn+Ddo7Y77Z2X2QMU5dMjx1DRvMKXKL3K0WJBglCCbhUa
	ewsYxOz6SG1S8nDtS24XeokHRwjcxZTQN1o43dSdO51goQ+7Ni6fS5r1vmQUFXjOvtnk2h0jcWb
	FDEo1+dE28OHudMxa/49roKASFnM/+knZdeDkC4y/Si4IsZ6RieZnJDsE5SmW2Qdi
X-Gm-Gg: AeBDieunSl5ET7hDfdsQI1feD0ZJhlpr4lub0tBW7JsYbWbHQfMpwJJG+gjAdKVp+90
	mJ6089LVbSynzY2EOciNZjq+z/36vJOrHgNGn+eGm7rpjd64P31KG6rU2YAeas6u93ZeZv4Ngn1
	bOiyJpZcsriA05FHpR5LA58VNFCrbNNt7sV6ugqzTImxRitmcMqZbCRnJYAUaVQBEaKdrmyuKv9
	sWVBwcWlW3+0Cwy0dlP1drmn/qMVtEYuL3k7WKwv6gBieMV2ipK1YmT6ehr6+8QuEff1c5uYg88
	8iyOsRmz7ss+IDMvtou+eDnnlzOZsnQEOLi3RqV7kHr2IWLd/asUwcT4EkcEv+T8NYlh+63ndOQ
	BTisX+s8obCkG8aTnK55T5incwN/obOuvX5D3cmYcGAMWE0nGIyr1dYwAm4ZY7sAC3BJ0HA0DLb
	XieFeWN2tFvA==
X-Received: by 2002:ac8:5a49:0:b0:50e:60d7:b272 with SMTP id d75a77b69052e-50e60d7b686mr454914531cf.41.1777273252677;
        Mon, 27 Apr 2026 00:00:52 -0700 (PDT)
X-Received: by 2002:ac8:5a49:0:b0:50e:60d7:b272 with SMTP id d75a77b69052e-50e60d7b686mr454913841cf.41.1777273252059;
        Mon, 27 Apr 2026 00:00:52 -0700 (PDT)
Received: from quoll (5-226-109-134.static.ip.netia.com.pl. [5.226.109.134])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc10019bsm792875525e9.4.2026.04.27.00.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 00:00:51 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: =Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, linux-arm-msm@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH] scsi: ufs: qcom: Unify user-visible "Qualcomm" name
Date: Mon, 27 Apr 2026 09:00:49 +0200
Message-ID: <20260427070048.18017-2-krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1219; i=krzysztof.kozlowski@oss.qualcomm.com;
 h=from:subject; bh=reVwFnXqG4JCPAGIR03O9xtNh97cp7Jtw8Z0Syo5YXE=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBp7wmgZA0UJzF5hqKIxrOc61exk5shUh3ZaQB2i
 HlKi9RM8XyJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCae8JoAAKCRDBN2bmhouD
 1+t4EACLvIr3eRNjKBH7knXiyf5EgIfm6z0mNxeKx0Mt6pTPXShzRS99J9pRZFsWT7CwqtIfBDf
 O6b3yZ14R9vsK7EyjJH5GsHIt/QaxfDuBZSFNAUG43OpkQw86HSS+3wANE0IF+a1GerMU3kzlzc
 MG7+FxVb+SsOhMGGF4yXQ/M8p3+NjKAhPyH9nWSFuj9lJiRMHxPMrgq8+yTQvbj91uqSbvKDO7p
 Kc3DyawlyPU8EwbiXxI1BlaWOxRpkd+sk2/UX9/4COQ5fp27inlsggjgAjReH+R9tel3MVMZXeQ
 jNi6ZvFK2tzz+o/IzJ4UeFaFmfuszqQhcXA7Du6qfOVPyEaFi7EabF1z4Muj2d7AGKglx1jyPqe
 rbV4NU0a+aDAWmbvcTXXpaOg+tCQnJP7791OL2wUYumvpVDHzfYC5sXIrKw47NZ2wNjXElnCxjQ
 WD0kCVaP53M7tOpNX3v73wrb+eM26I2lBajmtjs5AQ7TaHnbJxSen2YDXJMdNrGnXtz/FJGuKge
 QYTvrO6wyI7rQmkegVLK8DYKpyGGNF/KIsf9EjJsd+/NRP340nqvzA9HrEcGzG0HgqCES0YfYv9
 Z84VagDD7y9/pMttgTAOPZDfJyPTmVXA4ZwAt8otbQx+z6tvkqaF9BjQw+/jhMrun9Mh4FGPoqs E98sN8gdlVm1tZQ==
X-Developer-Key: i=krzysztof.kozlowski@oss.qualcomm.com; a=openpgp; fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: TAm1_rk0Q41RQyckxmo1h_sNJakRvOTr
X-Authority-Analysis: v=2.4 cv=H67rBeYi c=1 sm=1 tr=0 ts=69ef09a5 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=nnYKl1aPHK5ktf5uHVwi7Q==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=xgK18a4npx_stkMsbSEA:9 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI3MDA3MyBTYWx0ZWRfX80pwWQl/bQMp
 4VBZM8M+u0ILlGuMIY49DT+FpfKdsBEQxolB1hQ9WXrWvwiBTGJ9/CyPIyh98/yn7rw8Z2a79a0
 Le40so5fB4l5+SUVCTBo/RZSnPgncDcfHhVqA7AGSNs0I5vodl11X5fIXL6Rs19ydNOMZQ9+y8x
 yfAK0YQnu4Z7Xh+6FAnR0GA+DYeFGuRlTt/2k0w4D6vqB/UE1Kco0JSdk/PnTh0I2Z740SZKu9A
 mKo0XClnSVYJTwYRAnYuFGlSf2LIcp8CET68Hb9m3Yu6yf6j6eVp+64BbrMyQhkphTR+xbiOehM
 0PUCh76irOsKo1gNIfmvUiOzgoVDZ1+MdDsTbeiQXynv9RHKH0FD+V9hPHtQrW4WUlqOIGYvHAf
 AS9Shh7Q5LtNGpJIPORF+bXhS+9nLrceTLX26zkrUAoAOLwMMLPAFR7tRQhSPDaZaDJG9IF9T1J
 PTIXTQy6AO+KhfFfJww==
X-Proofpoint-ORIG-GUID: TAm1_rk0Q41RQyckxmo1h_sNJakRvOTr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-27_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604270073

Various names for Qualcomm as a company are used in user-visible config
options: QCOM, Qualcomm and Qualcomm Technologies.  Switch to unified
"Qualcomm" so it will be easier for users to identify the options when
for example running menuconfig.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

---

And "Qualcomm Technologies" has even variations over the tree:
Qualcomm Technologies
Qualcomm Technologies Inc.
Qualcomm Technologies, Inc.

I am doing this tree wide:
https://lore.kernel.org/all/?q=f%3Akrzysztof+s%3A%22Unify+user-visible%22+s%3AQualcomm
---
 drivers/ufs/host/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
index 964ae70e7390..ff170c0b6da0 100644
--- a/drivers/ufs/host/Kconfig
+++ b/drivers/ufs/host/Kconfig
@@ -55,7 +55,7 @@ config SCSI_UFS_DWC_TC_PLATFORM
 	  If unsure, say N.
 
 config SCSI_UFS_QCOM
-	tristate "QCOM specific hooks to UFS controller platform driver"
+	tristate "Qualcomm specific hooks to UFS controller platform driver"
 	depends on SCSI_UFSHCD_PLATFORM && ARCH_QCOM
 	depends on GENERIC_MSI_IRQ
 	depends on RESET_CONTROLLER
-- 
2.51.0

