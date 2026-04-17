Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3AC72FFDD5
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 04:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776401781; cv=none; b=P8qqazuK13zFP1/gV6SREcRamS8NbVVC8iygvvUN9nbFoggiVoCLgMQ1KKyu0Uf9HeZeCPghrvNxMDRXGd05Wpp9Ea3FDuVKR3YpeHGYzFEaHEF4vbdVJ4F8vhOiTbdUoj7TxjHjAGlvfC8SWyLjEbWcttnIGRuwLqYJZILK2HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776401781; c=relaxed/simple;
	bh=MiqNwpdUTpFI9j8de8EN6WUbCetEbxIgTdg62gd51m8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=m/tgtLYauWjnJ9fno/tn0fkzOOVNbAzsXEo+XlrWwbUwQIg7qD0rZDvDVD6O7o4X7OZvcu+6lRZToTSMwriWSyDVhdA7pD2AYx4vp6WkMBqKFnBxBQTRa7TtJBvfujeINbyqmHBuo1DGy67yCZ3Dkja9bN4I5gdkgNdzcPykqAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=IfYPmCb9; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NOurXzSk; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="IfYPmCb9";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NOurXzSk"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63H0fl8s4119533
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 04:56:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=fvI0EEPHps2diWkmNUsTUkelU9aTZHIpLB3
	2g+oyZ+g=; b=IfYPmCb9NDfUYVet58iCwKOjlOT3J8Ohs/vpm2tkLsFCFZFTrMR
	bZy6GeDKRO3btSDUOSqWkYRXAldTTMglJ/gra/FCciTwTL0ZAuiHQ8m3pE9C2LKU
	vyylI4Cv362F18zj4xCw6btj17f2R21i5Yc/rr1yoJU+VafDgqbI6d9nnEhfI6I6
	SFd42qaG+Rz3ByDWl66WjauKzm482l2VWpUrGTIIc4Tpts+t+M18+TqKft5lSKJC
	C458DHoHrn87i4jcBP09WISxBYwxI1XKcD/wqFPAC7UijRPWbROZ4V463MW33Y+j
	t+/LVi8fvCChQ8uCzJcPgTq7CMWU/OLwwLQ==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4djtd94aqx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 04:56:18 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2b2e8ff14e5so2272965ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 21:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776401778; x=1777006578; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fvI0EEPHps2diWkmNUsTUkelU9aTZHIpLB32g+oyZ+g=;
        b=NOurXzSkHyI4F1HUPvNrS2NiL5p3wkN+hfuxcqpyF3l8oCu65rqDLNuX7dL7S37xTU
         0H/ZyJo579M15eKIYgHAIiVjGjPutr1qEQA25BM0A/+CIj0rpkQG/y3eJtR6nn30PVKS
         MUhB8HMstTHytdX7xsWWyJPHXnw3hm9ncYJP1L3JGHM/Y2n7buAqLEzKgFEpfY6rHYLT
         I4STz8U2mNVnqYJzz8aHsXU/yEO8ASPdGbOKLayTeaTQTaWZXZXRvl7EeoexukqgGzau
         CvHKyPD3raKqgIJcF7SWGdPOiQynEIaHIyc80CDD0RKjyt6trICh9HNHM4D0QuCq+pwB
         sTPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776401778; x=1777006578;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fvI0EEPHps2diWkmNUsTUkelU9aTZHIpLB32g+oyZ+g=;
        b=KwCKcnzyBpSv+dF71a8309lYq84emvndlivRRHTIHtizBuBxDWSjWKbjBTebtINdzs
         ax9tI9Vgc8u8EpuskiUtEORH0ezPmLPY8wVT93w/lBKIir6DdGvukLs63DO/312JeaxA
         7g1p5/6gEuhpQVV0MeZEhMaOHRzow7NKPQKIRznnHJQyLkYLIwn9Da8kvEfxhMQc3KYh
         euU96qPDhhGSjJNJdqwwOkcmS0RJQK7KymykwrUk9wypO/d0/UrTr+1n7TFmWRJCAuqE
         01/gnDKIEsRlpV/urD/4sD0kBFTh1+OiUJ4ZjzeUJhXR8SO37K4xSxy3hFM1fV0WDelj
         QZUQ==
X-Forwarded-Encrypted: i=1; AFNElJ+rHKr1EA2RpJVSqISXFpy1adrIAqClJH14oi5qq4Msl78d8pMHMH4cENkH1lXpZ2sC4eH0jnUkHvxh@vger.kernel.org
X-Gm-Message-State: AOJu0YytwJmRQhcW4H980Kx8GPnbdy70MNrzJLgcB04UEMb9I10LfMLY
	PnRFdlVWG0Kvbr2aEl2mPtzlBBVLn2rlx+IoF3Mr7mckkphYVQm0HAf9gE7VW+RszdgRDwNSoJd
	v00TFN3PxYFQ7A8jc9JA0Nah4TNGUWety61KG5cROmzvew3EKci3EsVizehKY5I9Q
X-Gm-Gg: AeBDietKv8+DDt+l1uH6ZbQiezFJ+resUQqrTe6aKx2EJl+sBScAoqlYiH+IHKh9a0s
	SLi/dTH6SpH1ooVwinZ3/bOi/R6+7OrvcgEcM3c8z4I/v2y27lXflRAQDRTeB6WSueksY1VrOyt
	iuFih/kF57cHr+zeyPTRq1mfqSqnmxfFTQLTsAVmPNRz06Q6O8+dBVTuiEL5Z7KS4SB/DJQap79
	aVserwFPUctVDRvhBhyG+XPNtq+7NiO1ZTk7hqQE/3/0jlc9zst1gDfajSkMPz77UPuKRSGJzgU
	AgfIE7hKQVwFqzzOVkkBL6ApXwo7ynH4ID4DeETWoRn+w0uaJ8Ogz360bTHcJwHRMqGuVTw5Moe
	fgBqx2Lz71CYC2qvHcdd8DxHkbpvv6f1Rw63sNJ/A3MBq2Hboq2LGMxro+bJLjbWp
X-Received: by 2002:a17:903:1aae:b0:2ae:5629:ac55 with SMTP id d9443c01a7336-2b5f9f51fffmr12591075ad.21.1776401777824;
        Thu, 16 Apr 2026 21:56:17 -0700 (PDT)
X-Received: by 2002:a17:903:1aae:b0:2ae:5629:ac55 with SMTP id d9443c01a7336-2b5f9f51fffmr12590825ad.21.1776401777305;
        Thu, 16 Apr 2026 21:56:17 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fa9ff3a8sm5702115ad.12.2026.04.16.21.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 21:56:16 -0700 (PDT)
From: palash.kambar@oss.qualcomm.com
To: mani@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bvanassche@acm.org,
        nitin.rawat@oss.qualcomm.com, shawn.lin@rock-chips.com,
        Palash Kambar <palash.kambar@oss.qualcomm.com>
Subject: [PATCH v4 0/2] Add post change sequence for link start notify
Date: Fri, 17 Apr 2026 10:26:00 +0530
Message-Id: <20260417045602.3042928-1-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE3MDA0NiBTYWx0ZWRfXyTWmbVuO01HZ
 +V+3J/DB98QjlDxaOTCtBxKBTbK8+n91OUbA2X3TFxaWpY1cFC6zzDtcX4B9kRXVm0SkeJOo32Y
 VGsnzRjcvml+j8flr/7DRPkxROZrGSbdWFeWjOdS/M3cPIE191dt3yy7J0/02ZaaJTqncZUnyng
 v+F5mUlGVmNvQ6qgHrGYD7XBm4SDqaB5Kmig6yMyTZCdnfg4/63nffNljFOMpFqHcBRuDYdSXh+
 uE3MeBVePdePnTur2EZ2xI/sGZAEtbapGQWD09jTyAZ40GC3+oH8pbiIwARiMVfyITO7CTRZspe
 pYK8GVCDYky3FPa1Iars12mF/1lTotbA8VgCu1di39ImAN6dePNY1mfvYx3QwK+ilzrGsjiI7yn
 UALokMi18CtUmyyCiQuz+EMVa1VC0RiDMHa3ja5TumHAt3xsc1xrZOo4cgrlf+MNOiGeRiUI5wB
 82IwVX198yNwkV45DSA==
X-Authority-Analysis: v=2.4 cv=avuCzyZV c=1 sm=1 tr=0 ts=69e1bd72 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=EUspDBNiAAAA:8
 a=rbNoiXgGD7Sd92Kb1yEA:9 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-GUID: bWyK-lYNX29KPGyqM7ZO1Np4RBC9qyex
X-Proofpoint-ORIG-GUID: bWyK-lYNX29KPGyqM7ZO1Np4RBC9qyex
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_04,2026-04-16_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 spamscore=0 bulkscore=0 priorityscore=1501
 adultscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604170046

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
1) Addressed Manivannan's comments remove extra comment and return
   logic.

Palash Kambar (2):
  ufs: core: Configure only active lanes during link
  ufs: ufs-qcom: Enable Auto Hibern8 clock request support

 drivers/ufs/core/ufshcd.c   | 38 +++++++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufs-qcom.c | 10 ++++++++++
 drivers/ufs/host/ufs-qcom.h | 11 +++++++++++
 3 files changed, 59 insertions(+)

-- 
2.34.1

