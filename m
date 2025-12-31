Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A82B30FC06
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 04:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767156984; cv=none; b=khCZHJnhhfnYvzssp3cp5end6P4AlHoW7upr+g5MuhhMj5oPZDueTvaghvB22629fQDs4DXNafM/otRBNTeXJbm4wmTtMoKhsbZz/FrNuaMLkM5Nq8I7KctbxmjHO3CKlixvxE7yVbS12Z3hUBjWDd58yuCd2bNv+h6tfBDewCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767156984; c=relaxed/simple;
	bh=n/olLfZ4nDPE0Fc/nYoIgrhjqAFOMhm0RkBbmAj4e+k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JInKrWiTFc8e/uT1x832wMROmaqOZbzdLi/rvRq6foQHUEK4xVFgEVGbhW+DJRcGygB/agRhy2slIRJvV1/w3yPUtfTBW5fcZK09+52JRvIwN294Nou9mcEdzoZ8DYBwvoNz3uNZ5x8pwLk7brcWHwewyW7iexTsEIR9BZgE66M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=d4oYp9q/; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FOAewJjW; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="d4oYp9q/";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FOAewJjW"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BV3demF1830627
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 04:56:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=YaxEWXLeS4I
	QAnQ85ZZDFxXJrHCM2rSQp1hb6FjV+/I=; b=d4oYp9q/uUWbk9VaKQyOeCV5tI2
	PUZbuY9d7qDLGGnYFF/vu3UKASyntZSxiRLUkZsV9Ouna2y1PMBG+FuUx3DqN3Cn
	3fdUwO77APDOaOsUV4tM2T1jCCCcUTb7IqWDXCvP+1uKT2GVgmaaLn0OEWulcb6A
	myHqNDzFVwe3U678KNHwp/pAyLeqKPlG3bzb2TQhK8gJcanXVzz0+VRuzjRpwdUc
	pbZBESK/e9rA2EsGKe2W1WhOYUKdzc2sFa4OjFe1tAfNy9XFBSLGgcp2MiOu8anm
	27/H0e2GevC9rmmznaZPRwVRsg2Zisio1ouzPnfR0oIc3uBxacvujBZ557A==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bcv4ag3r5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 04:56:22 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-34ac814f308so23675842a91.3
        for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 20:56:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767156982; x=1767761782; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YaxEWXLeS4IQAnQ85ZZDFxXJrHCM2rSQp1hb6FjV+/I=;
        b=FOAewJjW+9vG1cHDery4qRljWODsKYkdVsA2GtdT9H4q4x7rnQy79t+gil9kUbvJvX
         q9oHQePBhlc9JEzX83b70L/+WmsUq+U2m5MIIHWdOPysKARYVXsnGxsgPY485yFj5Ck7
         dlUATneCBWUwegkLj3ly8GnCEJECEFCNXPG+1JmINRGNiroj31n7Cg8ax45CodipBsAw
         RukZdxwFwuuyQQuoWfo3ddzSd1tdsRVWe6rFDA+9E4cIPBqs4VtIk6UBnG/03b8uWj2z
         2r7cX2RQBSleOdKIVErcZNwoGPZQ6TPJifYPq7bEQub2O9wwE6dMIrlCvxUbf2N7dBUn
         Tjyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767156982; x=1767761782;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YaxEWXLeS4IQAnQ85ZZDFxXJrHCM2rSQp1hb6FjV+/I=;
        b=kIhDO6I7TH1I+5VDf6Y6cGiTD7hIYw4JMVn079aEvxVn9eTrw0RL+hOlooh1fCan+7
         SXPq15Iwh5BhEBvp/ysOM3kng4Oc2cmdjccne0jK0GyfPO2D1ST+8OqIxvhbOY8l8Nus
         9uLSKjIvSkMi5eqRc4bjhTXEWj9xLS9nPwIaU5zKnWghgWKvltJJ1yDLDXxep3IdSAP7
         5gnFXkk0VKH+sMWSip5hI+bJLvXqXDL9j55hj6N2O5BqAHu7LdJDbGUn0ixwFhLQIWqi
         WdG8qhFNxqUA5HFdK4pG0SqVNXDmKvsRh5kvjTXznVd89cJpL/DGvmWTDQzEf2owf10N
         eUHw==
X-Forwarded-Encrypted: i=1; AJvYcCXQiqotBBTiLnFYiOiMglr732PNe74xp7iPL7XuC2+HC/s+J4SwfLmrejoo8g3JkbVve8uyvcR75vvn@vger.kernel.org
X-Gm-Message-State: AOJu0YzxYh33SPlHDhoWV+le7cCWz8/QiGRUnKSb6OfwdhyF4ai1A9jr
	gEOaj2ZWGcb+6t4D/SMqwsGkekxfBDYfxyIsmZce5uqa60ErwfiFawqAT4Xb+Wkang3UV7y2/V7
	8EDlOu68zO5x38Z4rNGyl7EZF7UXyMsWQHa7vEFEflig0L4jzW0d3UIhPutKBdtb/
X-Gm-Gg: AY/fxX4xc3m5dAvPUo5nvX8dJzWEgMIGtwqingdlxd4RkAS7Xv1a3bPriX7FVKFYzpl
	NBl4ABifcfyrcKzrJfdBWjznVOtY/C7yHuTjNgV77+eL/iDabVtd7k6bZWkrREFxR+XCnLMJA9Z
	lqCaENGNlT62PmFBB8VczcNtCKtnDx5+l+o9hCyG9Pk4ZGcizOpNDiedhr5W9smrpniIV7EaIuP
	De9ebezOQ3UaX+wwdmFyY4l/EcNrk9H+5O7vZsY0ZTdna/bYrAFGM47z6iJtJ9/nDUru4geywkn
	mtgSI82yts9vwHLqHIZLcHLMxUXFK0GLPF/b2lqcITXzvWYg3lLZns2FXk99YJgLszTPYTUePr7
	eL50aGunSx77raPCZFP899Vh3TqVrAiXPfF5gXqP+
X-Received: by 2002:a17:90a:dfd0:b0:34c:253d:581d with SMTP id 98e67ed59e1d1-34e92139ac9mr28297981a91.9.1767156981835;
        Tue, 30 Dec 2025 20:56:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH1Cw52gEmn3J+jHIF5EeK4gMmpZSxVOepfaWx2DOsUmuRGWiYQiMvdTve6e3AkMOg8HCyXbA==
X-Received: by 2002:a17:90a:dfd0:b0:34c:253d:581d with SMTP id 98e67ed59e1d1-34e92139ac9mr28297961a91.9.1767156981415;
        Tue, 30 Dec 2025 20:56:21 -0800 (PST)
Received: from hu-rdwivedi-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e70d4f7d3sm34547697a91.4.2025.12.30.20.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 20:56:21 -0800 (PST)
From: Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
To: mani@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, ram.dwivedi@oss.qualcomm.com,
        anjana.hari@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH V3 1/4] MAINTAINERS: broaden UFS Qualcomm binding file pattern
Date: Wed, 31 Dec 2025 10:25:50 +0530
Message-Id: <20251231045553.622611-2-ram.dwivedi@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251231045553.622611-1-ram.dwivedi@oss.qualcomm.com>
References: <20251231045553.622611-1-ram.dwivedi@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: Zsf3UhmxosPzXIvjU4tT202COZtqCx91
X-Authority-Analysis: v=2.4 cv=Ps6ergM3 c=1 sm=1 tr=0 ts=6954acf6 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=52jqHT57hFt4fz_33zkA:9
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjMxMDAzOSBTYWx0ZWRfX6yf/YeGF4mg9
 pazRgSFqz1N0k1StANrZwR7yda3fqNP3weJzyAmLLT4tw3s5HT0PXj4ZER+TlKbPHOHfyEUhshE
 98Xzw2zEYKKMIfAdBfMZyBbVhosiWG3D8mizgbS6AsPa8EU2Yw2sU2KpD2mskwCcvfyM+vOGKUz
 0O8SA3WQGWWZPt/ySBaPhYXDvU1gu4BlG2fbHhts8vzDkyQAdiJdbre09zok0uaBXAbeydCJ9DF
 3HgSxlzsI9qKwpbTCPObJ16nq+Cp6Si7U1ezO3Vgt6L7CpgMvwNCwIgJ5uyelwC0IgA72Y86YsR
 3WB6Klgqwg2gpYNCCJdkU9IVCRIPo4QGNG26pQS3Cuqwgo/8NOML3YlhFR/n08ivt5phMz1nh/m
 B9poR/gbzepihiJdsfhAhJhpTmhJsVvvTKytjthdKnNym4xFH2xkt9hNDU/Q8UiSEOzozeHL1H7
 3tr4v4VleBW/QOrUt9A==
X-Proofpoint-GUID: Zsf3UhmxosPzXIvjU4tT202COZtqCx91
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-31_01,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 spamscore=0 impostorscore=0 malwarescore=0
 adultscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2512310039

Update the file pattern for UFS Qualcomm devicetree bindings to match
all files under `Documentation/devicetree/bindings/ufs/qcom*` instead
of only `qcom,ufs.yaml`. This ensures maintainers are correctly
notified for any related binding changes.

Acked-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0dbf349fc1ed..70c43fc74401 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -26842,7 +26842,7 @@ M:	Manivannan Sadhasivam <mani@kernel.org>
 L:	linux-arm-msm@vger.kernel.org
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
-F:	Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+F:	Documentation/devicetree/bindings/ufs/qcom*
 F:	drivers/ufs/host/ufs-qcom*
 
 UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER RENESAS HOOKS
-- 
2.34.1

