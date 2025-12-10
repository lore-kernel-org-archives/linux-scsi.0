Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E73D266B6B
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 15:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765381854; cv=none; b=pw32va/PmaIRCXV1OTEaLuSedN3WrXS8ukteBjiSzVvcKh3huVAPASGc8oP27pINifwO2jHIZ/T4wXVILHxl5RyuIsvFf1F0RDo6CilIlV3nYbiUcKWSTpLtPG7c0gYXg4nWdrxkW3HVyJPsnBP0/6jOoq6U45F075tFWsZyolc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765381854; c=relaxed/simple;
	bh=o7drDZrAUJDSBez9RsLhsFME8yCRZ78zI6P8jv4utCM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=URAwQYIMwYUod3W1AYxLrTprIIJlfbwIXzKoww6PhwY5Zw0YcA3QwEuHorclee4200x2E9vpkUIofUEI1dIPhkd7eA1GekWNKTvbb6qIEWyFSrRTnvwMawi3GLvZ4GPlLOjYLyEw2JSFBMtcS/I69XOisHkuPkgMn5ieqSvDaVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PHJsWlfZ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IQQvuTIp; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PHJsWlfZ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IQQvuTIp"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BAAPhTP2303335
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 15:50:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=Cpyzssk0iqR
	6XnHl+tGOj35nKrptmEhANEPfVeOn+jg=; b=PHJsWlfZLB3w+UOQPHTBJyleP0/
	Hh6GwQT0/Emntv7yn3OrLblGL5Y9iRez4eAKmRH0Dcn87w7fAg6/QfGQ/4EWl5ue
	zEm9OUJjjq4BVkmzltMhWPlEdAtr+G2niQ2Oqd/zsqa4kVVG/7/LCIGDjPsWV3+T
	+/T/tVlTsbc29GjLM/YDkGaV9WaMayke2Y6JHC3snLG00pifnYYkIF+pK7EmygJ/
	f8iUrZHPuNp5lP1NQ4NP7QyLF0O/bK7nxBSUDLKX9yKYo37KVn9gad/4bj2xI9fT
	bHn6li00ubMyfXmEaD+CFprSskIlTJ0YGUymGTVmJbZceGcrAykD06srOzw==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ay73rgyvs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 15:50:51 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-297df52c960so89555ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 07:50:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1765381851; x=1765986651; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cpyzssk0iqR6XnHl+tGOj35nKrptmEhANEPfVeOn+jg=;
        b=IQQvuTIpnLAYwZE9KAXP4X5s8B0COAxmI08UIc5oyW5ThRIXDXmmIf9cwQ9etDmZRf
         bY5A60AMy1WjTJ6dKXSslktoviKLA3xFnEf3bhGtSoK8Fj/y6j2jrY+QTSp0fiGu6KML
         sBgfORct41cYUG6ArZ5inxUo245/ndzFs1O1d8YdFXQWoc7jcXxXxzVGQkpZohQ6kuSz
         Y4SgeFJ9Ne3HuwwSsZ+pHToalOavu751awsGPPq/PAQwfKTez38vxUSB3w+DRUxPlh3r
         QoWZJF1EPDSKDTT92XKNvq8bFRNPdFD6UyxbcZXPQjDqSBXBi8MGKbRAF4bUjJoQ8DMj
         jN8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765381851; x=1765986651;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Cpyzssk0iqR6XnHl+tGOj35nKrptmEhANEPfVeOn+jg=;
        b=oOPSCZBSz+H0kWfrBq6Y6CrhBtrjB3RskwhR1qpsUc/zuNGF+oUv8UhWn9/75hLgWZ
         PV/4ciph+6iYTTy/ikqtCwr5WEoiRn5aIYw+/1ETpaF3SnlCirSrLtNRo3Ltzphy4dPi
         NAYxGpF1ICfmhvqgRaLRktqesNAZpocNROafJmuVGITe+++MD5ThnEe2S7bfJ5+8ektE
         nZGaod1vg8wxnN0LA4wAIKLs7Gh43Fadc9ER3FO2o/SHTlNpIdu/v0GWZ6bDp6Jv+6AE
         s3KwiXfAFNGrOYVI4gcIeCzUKyOIRbxMM4pBGJCMbDbdaaRMAPQp6q9IHmLW/LzLUGku
         yeTQ==
X-Forwarded-Encrypted: i=1; AJvYcCWM0pumwf5AfF4n6jCGHdoLR7AfjCi4AHXF0kCgMtPkAaIxFxYzVc0oRuQvq0ruT0RRAHOaWf+ncdaE@vger.kernel.org
X-Gm-Message-State: AOJu0YwS2yG+9YDvUEW9qDBa/ux9JhF+ReeZs4+5voXDvRhIWAOF6/Y5
	jk7Oex2aBTj1R0JaTMS9t25W7RQU0glzHdwau1wf9myMrBclxaRKRwzUMp3KJC7S9wR5A8YANWc
	gaHthUTRk3QyWW7TAfQjJm8nuqB4b5HkPh5zxgZzAbu4S6WWl4dv0cicUOUFUBHBM
X-Gm-Gg: AY/fxX5ZPkg5T3v2KVEd6y1m9KrTEWDT9Q01GVMq5Z+votg0lS0PMIp6j7yLwmNRE+a
	SBrNFzWL0dz84Z6UejHcrsRS7eedWSXyinW/cQcw/ZLctXqhZfbA1BwfWGXrAaize01w3HRLHR5
	7yC1g5UjVKnYZdS7j8Pa8WhKgjrAHTSksbngzffogWMM//zY5thfUVmZrF+FCRQ8SYmHFyXscak
	MuEO2TkjFRobVrcVrixl4FR2CpxIBPdsqyzJSatLINXgniYykRH66xwyogOJZPbHI7WmmuprWMz
	uhB88BNeNw1g512wuDmEVK38F5G6dXFQPNHHH0GN9MppSxLjOPnqoF+QmWZGGMHGR/CBdozxq13
	Nvd30AAe7VVHGfhxuTbUaWcMRYbWlt8xMpC98RGP+
X-Received: by 2002:a17:903:b0b:b0:297:e3f5:4a20 with SMTP id d9443c01a7336-29ec231f255mr32467325ad.26.1765381850756;
        Wed, 10 Dec 2025 07:50:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFLOpg4x7MmvcwigCDDq2GU/0z5pbMiL6qg75gGKsPElpzD1ynSU8r0WI24m3l3tG/tn4igvw==
X-Received: by 2002:a17:903:b0b:b0:297:e3f5:4a20 with SMTP id d9443c01a7336-29ec231f255mr32467025ad.26.1765381850291;
        Wed, 10 Dec 2025 07:50:50 -0800 (PST)
Received: from hu-rdwivedi-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29ed93e470fsm7780175ad.41.2025.12.10.07.50.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 07:50:49 -0800 (PST)
From: Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
To: mani@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, ram.dwivedi@oss.qualcomm.com,
        anjana.hari@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH V2 1/3] MAINTAINERS: broaden UFS Qualcomm binding file pattern
Date: Wed, 10 Dec 2025 21:20:31 +0530
Message-Id: <20251210155033.229051-2-ram.dwivedi@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251210155033.229051-1-ram.dwivedi@oss.qualcomm.com>
References: <20251210155033.229051-1-ram.dwivedi@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: SVk8HH_tZDrZ-Oz-3XmA8ae3KpAgwEtX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEwMDEyOSBTYWx0ZWRfX5rJpiGoPhR5o
 SI4DgHbtooaqOM7w1hk+xNHsnKsvJynaoScDHonBHfGMJOCCKm6X0l32fcfJfq4LLhBiFX6Nalf
 YUDXSU7TjjZPBArDsQdfMxRwVt2u9MhXuT+dXiXML1kAqcSUhIdq59MKNLeYUSxgK4mWlAwKRJZ
 IMLxMxw+H5OO3D/uc3UaFNsk839e/fIG+hnUxsyPW13sVfgRKM9vGaoSjhqgCuXwX5CDavl/2Jj
 WevPBq2HHTbngO+38eO8udlnHt3+pXcHitONCQHjzX/Kl+dJxkEpYCGUdsg6R0AbpD2SzIjzB4B
 Ex8h9cxCpQr2k+0dqaJiKuT2OoJlOlM1rwmhmciER8IH+lYSySR4XR3e86KUpbGtshUPswWIDGy
 otCDeTH38z1mPmnAvc0vmXaC5ng9Xw==
X-Authority-Analysis: v=2.4 cv=McFhep/f c=1 sm=1 tr=0 ts=693996db cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=52jqHT57hFt4fz_33zkA:9
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: SVk8HH_tZDrZ-Oz-3XmA8ae3KpAgwEtX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-10_01,2025-12-09_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2510240001
 definitions=main-2512100129

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
index c5a7cda26c60..f4d01ad6462c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -26812,7 +26812,7 @@ M:	Manivannan Sadhasivam <mani@kernel.org>
 L:	linux-arm-msm@vger.kernel.org
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
-F:	Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+F:	Documentation/devicetree/bindings/ufs/qcom*
 F:	drivers/ufs/host/ufs-qcom*
 
 UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER RENESAS HOOKS
-- 
2.34.1

