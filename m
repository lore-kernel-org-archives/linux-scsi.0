Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDF23C9EF1
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 05:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776923981; cv=none; b=fdri8B3Snpm8LwAwWSk0NlrIDbvbJioWgu8vejsSqCYjA06VMgFlXAS913kIPTD1VJ1ILfT5I5D1ygiVdWzuihnlRmXlXF7yaQi8ASKVG5vUehzbNeNugXdjTpfTHoEx3xL0bscN//sEa/bWOe7PHaEuMhLr2RS5HeNhVnGeHJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776923981; c=relaxed/simple;
	bh=CVgarFTME8J/zzzPOxQ1NifiNbNg5Ee45XPRFBAkSjo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UfnQBct5cdcwFn8K5mvnRHOKHVcRSYVN0+VzuEXUE4y2dbRSJVcCcMdPGKeqtGNU1b951o68IHar8ChpQ8DIqbjTkZfw2naDAfHtYl3U23IVJ29NumbLPL700ZWo9p3zKGAZKfFeTbbYqKJXmKh97iv5Wne+/gB9lYpIe8hm4UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WhkdHGLR; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BvzQ4llM; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WhkdHGLR";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BvzQ4llM"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63N5lMXM2630200
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 05:59:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=UafmC+M/+1YBMEy2f4UXF/XXX6hVc3RZaSW
	5mWq85tk=; b=WhkdHGLRmviSZWs+0dU1S4sDg+Bj8PP6qFkAA4RAdIkCFntGGGC
	FDLXwo/VzaaG3syy6BudkR7Tn5wjzzpvKfK/E8vJy1/pocbFAPY9AsbCiWiUZwda
	Hb/6oyweQeU0c9lvT/72041B+FtKd3U7LtQLVqo6A9JjhJg2xOElOgWjlBQFQFkD
	GT92D76AfOXKnc9eH4XXi4nt/ve/emG0fO28n+o1h/JcNINAoQP9xdyUOc/Psuab
	LkP5uM058J0I7dPKHVhIYTGjaOu24P3LwStcjM5Hf8G93e5azKkztiWAkxXgPEpL
	EmClOUDH4Ao4PHDLCT+Vkv/HwFxXewa+IpA==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dq35r9yyw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 05:59:38 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-35845fcf0f5so6856232a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2026 22:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776923977; x=1777528777; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UafmC+M/+1YBMEy2f4UXF/XXX6hVc3RZaSW5mWq85tk=;
        b=BvzQ4llMKrzNw9axnn3CPS7E5/uk9AZMs85fglrWD+3IpjjzTgV2Vks4y8kSc3KoK1
         3OsQ27URc6xrF8d6PHl3eynEsuXyFlkXR+uP3ZJJSy/D0c0fgx5vYhp1aixntAplVy53
         /FEORIQwTeSAG0crz888NJwWPnixOOUH0+rHso/94J36y78lXDU3C8sj7xru2mPv8y+R
         KqGsZnt7OHWO7X66SZ0uRFOPJwDrX74dfOh31isW6GsjLtXHuWnOYdRlgdlPZ3kJ/3Ki
         MgfRaQziPy5dRhUpKlpoL+7ZtBqlC0k0aNtmeLlAGRPTKntrYRg3W7736764a9QvK0Yb
         Fhlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776923977; x=1777528777;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UafmC+M/+1YBMEy2f4UXF/XXX6hVc3RZaSW5mWq85tk=;
        b=MM1xqf2Q/iv/g9JGjLziP3lajVSW2u445kxbgNx4X4v0utTEp1TWHoXwY6wdMvGUb0
         FfmNgCUNJL+mzBTXwtYyg6hSDI79JTBQjP+vH3fwcmkYhU9/cbBWI7K15GcCDz7hE4g9
         B2xow/o3ybKOROD9hbUY+2Jy5Qt/O/LbpgbsLmM9a1DaicG/jeEDGL4JAaM2YPpKMVQi
         VClCU4FpqzeYK+itib76WSOlF0ylqBVPuWIA3QfKgkolQpOMNy449/59BvapyvdLp2eC
         Pmhzhl9w9Tl0MxA7d2INtBo2DHRCGRwozRqArsgLDhkcmzvhJwyr11xzGfIizaWRolMY
         v4Xg==
X-Forwarded-Encrypted: i=1; AFNElJ+iVYoHnoQZc30zrqcTbtprmP2/TiodqNfRRF+zyRyqod1LhOBKYWkazDlkdCbD39bvVPLeZEpGiDMb@vger.kernel.org
X-Gm-Message-State: AOJu0YwOP5MvDY/8bIs5FEBirD0PUeF2zntv/Ewq3499OYH2s8wTXlGA
	ri3DQEr2lO1Gja39+NG1WK6WwMr38t6RR3mdjc7ubYgQNSrkge32Xem717/uZAi413Si8+p+85d
	fguSqK1BlysYWg8EoDRcdzEexv5dMxatZOG0OTdb1mSO9gLcQa+rzXqYWQBhPr4JC
X-Gm-Gg: AeBDieuga8iryJMKP/dFSuSDE+jhwSZlPVLJGF6FvTXsOmD79SB1IWKcP/JwoVWOeup
	Dmag1neoYmJKkGux8SGyYULAAI3bu73m80VV3uR+7jJIeiJY04hnDs9ef+KwggopfWoaJsG0Zw0
	v05VkJ0mqMdFKn82J3ZWi7I50tdaarkthIZglsIsm4GQwXzABqosoFfKdWDI40mG11nYx5cL1cY
	my4yZ7MlJQjxUUwtF92j9CSt/Z03rqSg165RFvvqMHMSmkklvWX+avf8tyohi7XYC6wHyK88uOV
	Z7Hh2hMBz7j6Fvoztjd0CFqNup9H2Y3v41URk+Nh2ehjiSQFm9ATOb8tfFp1DyD9YQAK3AWBM5Z
	HHDf9rv+2dvdyQe/w6kFA+Pr/qfquxenQH/0sqtBs0KxswdeZvK/bzLICP08pR8OG
X-Received: by 2002:a17:90b:17c5:b0:35a:10b6:1208 with SMTP id 98e67ed59e1d1-361402fd6bcmr24223621a91.14.1776923977115;
        Wed, 22 Apr 2026 22:59:37 -0700 (PDT)
X-Received: by 2002:a17:90b:17c5:b0:35a:10b6:1208 with SMTP id 98e67ed59e1d1-361402fd6bcmr24223577a91.14.1776923976642;
        Wed, 22 Apr 2026 22:59:36 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-361418c3944sm23461841a91.8.2026.04.22.22.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 22:59:36 -0700 (PDT)
From: palash.kambar@oss.qualcomm.com
To: mani@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bvanassche@acm.org,
        shawn.lin@rock-chips.com, nitin.rawat@oss.qualcomm.com,
        Palash Kambar <palash.kambar@oss.qualcomm.com>
Subject: [PATCH V6 0/2] Add post change sequence for link start notify
Date: Thu, 23 Apr 2026 11:29:12 +0530
Message-Id: <20260423055914.3566684-1-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIzMDA1MyBTYWx0ZWRfX153ZDhxD1A1Z
 P4ht0UmIeS+zseFpk4sjxuXNZgHckxbeUJlRdTotFybNKW5fOZD7OpYd2FTTNv4yfK4cOlZyH0n
 ImmJ8KAALt+X3ZhNQiB1LajQc6mRXYlSR7GjaI3x5FLNBpf4WyJDLZ+vlQp+njdqkE5QS+iotya
 AwnoILaEP055hbDSwxwdl7aNHprFPU+1SHB7m4pY8Xt8rrI5XkHp6BjqjRgD/Oi/RDO+OAUikcu
 YwYwWtsixoZUYwtOlhxZs1Zham0E8Y7X2XI4dq8f/aDdmKc/fkckPLCDaWjqFOHz7WdKmI85M2q
 9de6VJo3uNQiUhkqGrK98hhaCBw1J7bzvtSqFvg5dxd0eksyqRXelQoKyzb5qWXmDEsXozM7Wik
 oK6Xvc4Zc6HCYXcEe3H7JxaGvdmBSjlO1h8md3U91YrYK0gzzDn77SpCHfn4gu+TeZiVNs1nsey
 /duYOEK2gV8bUGKmGsQ==
X-Proofpoint-ORIG-GUID: z6J2HjLR0DNqQCkOa8jydBG7CK1mAJ3x
X-Proofpoint-GUID: z6J2HjLR0DNqQCkOa8jydBG7CK1mAJ3x
X-Authority-Analysis: v=2.4 cv=f5J4wuyM c=1 sm=1 tr=0 ts=69e9b54a cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=EUspDBNiAAAA:8
 a=rbNoiXgGD7Sd92Kb1yEA:9 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-23_01,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 phishscore=0 adultscore=0 malwarescore=0
 spamscore=0 suspectscore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604230053

From: Palash Kambar <palash.kambar@oss.qualcomm.com>

This patch series introduces two updates to the UFS subsystem aimed at
improving link stability and power efficiency on platforms using the
Qualcomm UFS host controller.

During link startup, the number of connected TX/RX lanes discovered may be
fewer than the lanes specified in the device tree. The current UFS core
driver configures all DT-defined lanes unconditionally, which can lead to
mismatches during power mode changes. Patch 1/2 ensures to fail on this.

Additionally, certain Qualcomm platforms support Auto Hibern8 (AH8), where
the UFS controller autonomously de-asserts clk_req signals to the GCC
during Hibern8 state. Enabling this mechanism allows the clock controller
to gate unused clocks, providing meaningful power savings. Patch 2/2 adds
support for enabling this feature as recommended by the Hardware
Programming Guidelines.

---
changes from V1
1) Addressed Shawn Lin's comments to fix comment to connected lanes.
2) Addressed Bart's comments to remove warning and trigger failure
   incase of lane mismatch.

changes from V2:
1) Addressed Shawn's comments to fix commit text.
2) Addressed Bart's comments to remove variable initializations and
   indentation fix.

changes from V3:
1) Addressed Manivannan's comments to remove extra comment and return
   logic.

changes from V4:
1) Addressed Manivannan's comments to fix indentation and return
   handling.

changes from V5:
1) Addressed Manivannan's comment and added back the missed tags from 
   V3.

Palash Kambar (2):
  ufs: core: Configure only active lanes during link
  ufs: ufs-qcom: Enable Auto Hibern8 clock request support

 drivers/ufs/core/ufshcd.c   | 35 +++++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufs-qcom.c | 10 ++++++++++
 drivers/ufs/host/ufs-qcom.h | 11 +++++++++++
 3 files changed, 56 insertions(+)

-- 
2.34.1

