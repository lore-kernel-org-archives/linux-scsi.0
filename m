Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB70036B067
	for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 08:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768291295; cv=none; b=boogWyFgszkTTkaL75rpn2rNCViSdt8US0VXg7o8D0L/Pu+ccqD9DbhI3YXKb6FLe39f6fNvC5/S0fO0zo/ZZFnQyMtmrQSj2X79TymCi1fyYGfnyYcoyzQtRHJBEdQxMUrSWzaoPAkjqielGWbqQxRJGvZFxWlOAitOsJFlWMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768291295; c=relaxed/simple;
	bh=n/olLfZ4nDPE0Fc/nYoIgrhjqAFOMhm0RkBbmAj4e+k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MJDKkFYEWxQZutLUKvh6eHnSuA3TptNLjXSYVfmbDKb0jKbv4na3HG5hdGbQwYm5AJXV0QS7khRNyWBZqgu1kV0hcvo3Bpjgi5rOPV+7FV7UztkW7f/Py7Pj596K3AboN4d4SOBAYHTNgobeoE3mwjdMV2mGd+UEZ29QSoKtH74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=K+dSf+5k; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EbUNtj5s; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="K+dSf+5k";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EbUNtj5s"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60D5gov83809483
	for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 08:01:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=YaxEWXLeS4I
	QAnQ85ZZDFxXJrHCM2rSQp1hb6FjV+/I=; b=K+dSf+5kMXEU6yqUPkTm9tD0WQS
	UQu6ImKknCr9SpOgUouKobt+kkzPpNt25i/24JtW2LBq5YUE5AJvzhMbFimlf2lx
	SMZauPccTi6AXcFnx0HggaCxv0E2WOEs25rjP0IH2xGJjjQ3LeFhpsX+L6LeeH3W
	ZV7XFw9n4m6EFUe4D/370Za3cfJnH8pbCcmVsWrpt/YmpW98fURJOg2xcWH7sqYc
	FT4JlYaInOmPV8jYf1yEZlwvxHdepFrOlgdXHictYn6Szt2O4g5J3SwQUqg9Dwah
	D+V1RjJ4Q8cUhnDgwlYRhYXTufXTz5Bf+MVMhZbahWva195RaywnX63F2hg==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bng55rcp9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 08:01:09 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2a0bb1192cbso67691705ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 00:01:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1768291268; x=1768896068; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YaxEWXLeS4IQAnQ85ZZDFxXJrHCM2rSQp1hb6FjV+/I=;
        b=EbUNtj5s198iuFMVkx/YlPUAafHE+LTUjSBhbC8IJIgBpjdh3CtC11mY0Mi8Qeo0mx
         CrPq7ff1/CgNMq7UlffpMbMqFVybSENC/vQd3A5M60z6Yxdq11vVJyxhPz8TG5m1pZfE
         908m9S0e72XxnsRI8uh0Cf1nHQRhTgL6nd7n67GsbeyPf+sVzsCkwWGxWk/cdJh13PDX
         5EJ0eX01yEzOlbcMd7As/MU8mmlZglEoBg9LE1EfTPa+pF57ntI5gJv2ErB7zMH0TZGA
         kdnu/Im65Evfit5G1ISrACJDD2D+uJx6/1IShZli95Gv134pNm1/gxEx0FbxBMFm3wMq
         6vxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768291268; x=1768896068;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YaxEWXLeS4IQAnQ85ZZDFxXJrHCM2rSQp1hb6FjV+/I=;
        b=owi5YsemXWoji0u57Y9tpU3spc50+kfXXG8WS6PaXWIUa3CHh+Q8+guaxJeJ1a7Zlg
         nMbL8iKaZVnNoapFQKMrGYbiXCXoFePhh6k+IV8AMOBX4XHcd3zbnPeQRHlG7N/PDXvt
         NwjTG2w59WlvaLxfl70mhK8qqd9Tu7oG5xsuggdy/rVw/zs6Vlq9Qpon9T/v5W1xCVYB
         xq9Fcn1gwoY7u3V4ydRJEMDxdQZNjResfoMzKH0mNcdjnhgk8de9P2w6NxMQ6UZ8Drpw
         hvGcLsYNwbO4bSqksmvZrDeffl6wLBUss42eSCGev612hx4ck9Fm/2Tf4sRCECXAP8Ji
         zMiw==
X-Forwarded-Encrypted: i=1; AJvYcCV3ynAdElBwD5D0awkRCFNUvvHIiXDVCMi9ZXbRa+KvSHBTpD2dBQm0o3NjWpY+H5PjtO5Z52hsKEE7@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/udvJL6V7F8JORd3FVSkyeKORr1y3M9tDq/s7fnouQtv/IuK2
	80a6VTXxwE2MFG/6Q6k4Kj8vxSNVA3cEC5WWOdoZGAx/EN1seni8Ww8TGNfH4fCyaXgeJ5RgsIm
	qNXqck9Mmw0OAeIh3bbGlAiA/N5d9Ss252TmBz9FYqdeZNQvivQIF/ONJreSJ3XndExu3Y+L/
X-Gm-Gg: AY/fxX4IPeZkstEvumiHgUPzFphrwdNwY4qJ1aokeLYmCblnjsixyJqxgReV0YMZioC
	Wm1zWNPBP4g/xx5P3doGJcNvqxI+lFojcf/TfXXrQnyN0zkrMY/sITgarTFTBxp2uxP1jvuRvrx
	Z+rOgnBNhu3adBklpPjnXCxNbnByPGnPbkRPawy79TTxwRGenqpbwldPtYqSQooodJr/I4J+NGU
	k4waL59adXlA7KAzNthRqKkB2ol7Fobv1lDMlI4YfsJqGCQr9dHKcybOfDSOGSYPG7RkQg194TU
	zE25+gK5aAlFeDVWnjzZI8teZxQQBIz7LkA+0v7WU0o/9gMcWoUupl60HQWBgERt002UkjYGLXV
	5Qh6A8rCfEZdMbKcz9olBbrGogcGaR8/wot2lt14j
X-Received: by 2002:a17:902:d58a:b0:29f:2b9:6cca with SMTP id d9443c01a7336-2a3ee4da381mr221003825ad.44.1768291268476;
        Tue, 13 Jan 2026 00:01:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHXP9OsgiIaXkagh4wVTk+DADBkM11bBot0icm4O4mGX/wPGDsDAdA8XnbcgcDZVujpVRyS2Q==
X-Received: by 2002:a17:902:d58a:b0:29f:2b9:6cca with SMTP id d9443c01a7336-2a3ee4da381mr221003365ad.44.1768291267980;
        Tue, 13 Jan 2026 00:01:07 -0800 (PST)
Received: from hu-rdwivedi-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c48c15sm191132725ad.27.2026.01.13.00.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 00:01:07 -0800 (PST)
From: Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
To: mani@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, ram.dwivedi@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH V5 1/4] MAINTAINERS: broaden UFS Qualcomm binding file pattern
Date: Tue, 13 Jan 2026 13:30:43 +0530
Message-Id: <20260113080046.284089-2-ram.dwivedi@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260113080046.284089-1-ram.dwivedi@oss.qualcomm.com>
References: <20260113080046.284089-1-ram.dwivedi@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: r_gK1t0FqxX_Bj0MEND3GZ0tg2f3zeMO
X-Proofpoint-ORIG-GUID: r_gK1t0FqxX_Bj0MEND3GZ0tg2f3zeMO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEzMDA2NiBTYWx0ZWRfXyIfGqbUJ0TUb
 bEHEC7VoywNlpc80o/R45tP/RLc+pbAQuXe6E/yK5Kkgy+s29WtfYPyqyrCr5UFQJmybJcQJDAL
 QbeXF+s8qIuvt6SJ2ElkE6OPWAdHkVnMvup5MYYgihvr28My2Ja8x8IyEXw4Jq5PqXGGtJqyu1R
 Bz6Ge21uwwN5aJYpRGdJzifP9D3ir2QkKhPll9UcUlsPwRupjxXXogB/FJ/A+FbQX9JGXNwx4KB
 DsAotXUNgcFRj1Asyu9rDeC0boz69xTxQnBRuwEDEgWKR4IamEAHI6KecdNJkdLm6/OV8YF0AsW
 lr0pmuFr7v+IfexrtKpFRcQxVxl4hH0nyPSW76nNjZkdjbJOIga8cVDMpyidERo0wB0BvhEAJg/
 V6P78tLa+A6hH3wvN5FfsxxygEyNYiqZ3pY+UlOp1AA4XkmotEu6IwjQGmC6PuFI7P2FovWTMo5
 EiPj0M4bB8wSUml1p7Q==
X-Authority-Analysis: v=2.4 cv=IIsPywvG c=1 sm=1 tr=0 ts=6965fbc5 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=52jqHT57hFt4fz_33zkA:9
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_01,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 phishscore=0 priorityscore=1501 suspectscore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601130066

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

