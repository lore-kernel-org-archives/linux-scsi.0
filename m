Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC1839F195
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2026 11:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776858591; cv=none; b=IHCy3aoRyCeP2U+CQrr2FYvzJk7NEuEhPGmt3FlGvYcmRWdH0XIRDycBHu1cjv5AN8LfyniyhKaQ1EG9pceNaKo4Y2lfKIcq2mx0GsjC1OsBGL6FfU0GV0jlHoInkT/+qCGVkUMJDpdI82byopAncNWKuLpktqeFUsHDNndEnlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776858591; c=relaxed/simple;
	bh=ZMaK0X40FEFlzwhWQ7WxGRU+7OKoGklGGBSI0TMpP2o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KYaZFtFCczf6pSk0exNfZ8HgbGPKEhlX0aEVvmI8sAu19bouk+3DoV3cNYxPWFngNfpfCexhN16DEOgNFvr1mh19w5XH2wUpSZngqdJi0K+PiJAeL+uB+Xk1NsW1fySaH0jct+1KlA1SvPssbZctUYZZ3QTeZXj+nF6rVXHtINg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RCkyuxSN; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gf5QhpIo; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RCkyuxSN";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gf5QhpIo"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63MBXP4U3730717
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2026 11:49:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=kjmyJu474LRd6KvQaKEAhntZ2nGNadIY1Ew
	xUoVlISs=; b=RCkyuxSNqLeYSuqhyOsdUYsbxVhh8M6Yvwh2eCS2EbdysAECvi5
	pE5rppjpEtNQ23btwNZ/S+bTjEpTJTaMukid1qvzVFSxf2BPFi1qu9sEpP3N/tHO
	d97HP7jfx5TOjpekAYGLOJ/f8YCkk9r5hqKQHj7+Jkl0KM/XuaSGBoqCGRYyZPca
	CteoROIoUqj3mkwWabNjZX/0315dAewB1I3B3q3gduwpnXXqw1Q0Y+J6Er1U5klu
	RMl7BvNrzW/YqR9enkuszGIn5wKylz1IL78FRpHQOqBRHyRtjMMVJCEBZCOtREtl
	Hcf+hNsNcDOR6Vrj1MhjoMsoLsITbTZjvWQ==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dpenfu4fk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2026 11:49:48 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2b4654f9bb6so56442505ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2026 04:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776858588; x=1777463388; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kjmyJu474LRd6KvQaKEAhntZ2nGNadIY1EwxUoVlISs=;
        b=gf5QhpIoQLkmJ72QxqipLpmdMK3HjvMmLxWHCcNFqqDtOgtK/jbq7KfSZt41z8QM06
         yv8E5RciHWT5KeVl6FjuF6XY0g+jvtnk6uAlvbItvLzMCRcIxWcKWNq2F28ivoJKiXvn
         O+RO28l1DZHxtSU6q8d9ufbw/p+fnlj0ppDrGdPj2JMphMh/twj1M87Kmz3dMQAB6i95
         MfKtWyigt992KgEapRFnL8mhbc94MzVlbmQKrkxf8v52fC9QRl8blQOFyTqatwMfxHXK
         A7wnfDsBZt8bwDiKYCYGnyylY5QnIvCBIbH58BcJpRnlS+Nup649xWQ7Z7xX6WuCwh5Y
         RRCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776858588; x=1777463388;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kjmyJu474LRd6KvQaKEAhntZ2nGNadIY1EwxUoVlISs=;
        b=ZlRZQwTuYYeENsRQzIT/Ld7aoK5kM7o4VIQmsom9L0v8nlpnwvIi/aVmycdbajlmWr
         acClURG2ax98OAQF3u03vfGUYF2hn5AIes2Na8ya1NpG6eZHlOLoNp3tAWpxiY7JWtXG
         su6aAYS9qFYT9WgdygAyhDqp3UYAN9K1so0uAXnLuZXjTQ9Yc72JsrZnS7jpGe+wU9up
         PLRLXkVMz2cqxOyRnAu36abW+/QwL6NPwJW92KJ5ei6H+k7tshXtz6XcbDHGVcEJmdOy
         9EfpmPXw+PehT4E+MizyE2a/2ML9jY1z/87RtJxiykgSsrV/IlWyEKUNoPNT0gzBYWNj
         urXA==
X-Forwarded-Encrypted: i=1; AFNElJ80gyXwTnDNYOlsiDTfpJzDQNhb0yyO0CnR2/8ThMxdG97gsyHr/0x9S4RxagsjCY7SyGLkKAJ36vFO@vger.kernel.org
X-Gm-Message-State: AOJu0Yz287P7VjLGS7UCmyXIPhMWj7FGbIq+0TF3Q5pW3UgJmHYzocOH
	qknMe+nMUOVbDaccU+xEYJaRJokk/txXQwXePBe/43j0pDRnB600o3YOuwr/76bJKJx34PyzkyO
	zi8DQOpP6b99QW6n/BiR+RVwwquWG+TTNuriz2zZejY6kb8t+sQI+KxwzxqxtSa0U
X-Gm-Gg: AeBDieuZqUlc4wg3vgG8prNMnNkC0XzxCe2dg0JUQWBEDSi8I5KwA3Fz7vkYRBaVhIX
	0/vxTbRCJDDr4EAuZJahk7swZz2TNWMR+aIsSRxCmzYe7Sx8y3dIU8irtkJ6C8bVJxOKQBrpLG1
	p5P6eURPKJH5/DTr+92/46nVqfqPXDWOhY+4TUYSgjDHc0slBVUjE/ZEaSk51idNAzuCktsbmqB
	91Px3soVuePqGRFApYbYxHz6fFy7/aqkJq4QS1RqomhaKCzr/ewQbyq2yuJ9mW7lK5pqKaxyKLU
	nlB1m1qneNVUYtUDOOYfmYVjdrzFuq4Q5AcCR/X8orfGumMu+tkEOzXIcQxIUOuqvmBQEYPgM3D
	ANjfuXRTPqkQtQiUmMQFu4YpJVNFyOmlqYg75TrvpECeMMysr1RQtyED0fp4lwSB+
X-Received: by 2002:a17:902:868a:b0:2b0:4579:ae6 with SMTP id d9443c01a7336-2b5f9fe1e73mr163777445ad.38.1776858587743;
        Wed, 22 Apr 2026 04:49:47 -0700 (PDT)
X-Received: by 2002:a17:902:868a:b0:2b0:4579:ae6 with SMTP id d9443c01a7336-2b5f9fe1e73mr163777185ad.38.1776858587278;
        Wed, 22 Apr 2026 04:49:47 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5faa34ea7sm163047125ad.34.2026.04.22.04.49.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 04:49:46 -0700 (PDT)
From: palash.kambar@oss.qualcomm.com
To: mani@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, shawn.lin@rock-chips.com,
        bvanassche@acm.org, nitin.rawat@oss.qualcomm.com,
        Palash Kambar <palash.kambar@oss.qualcomm.com>
Subject: [PATCH V5 0/2] Add post change sequence for link start notify
Date: Wed, 22 Apr 2026 17:19:37 +0530
Message-Id: <20260422114939.2901925-1-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: HD4mjFoYF7nbUh1W3VBm7QgSfEq7KkZD
X-Authority-Analysis: v=2.4 cv=YJuvDxGx c=1 sm=1 tr=0 ts=69e8b5dc cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=EUspDBNiAAAA:8
 a=rbNoiXgGD7Sd92Kb1yEA:9 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIyMDExMyBTYWx0ZWRfX4S8ce5i/qlHT
 3l3QAIgcaNbyVzylgtSlPuVVVQ0WtZsLQxIV0/vU97SQAQpgB9A/H8aL74AqPKbvb9MHx+2VLFJ
 PdPtqelPxau+zdbXRifY+68+XNAN7S+PQRiy+hObv3boxhKhLT+FuJeuJQyZayVq6gkIcxgey2R
 dVAUa+xXyMimTLIrz7OGUlkElJA94BEvfaXnnRTdsJI5iemMpF2p0xizsXhm3yAeCPXj+lvwYpp
 0xkVr2GpDdYJnhGrDIs72LeK67+DLmYx2KfJvKD/vM9wlmRd8DzOdjWn6QUdeTg5gL4i2J0cgFe
 WvRyfdgGqTKr2rSzv5bb2d5j1PUA7UHgsi1rI2q0C7F5OYXFVJG8gwVobQJGx+96kn3HurGTB83
 DqwIDGlyq8QcfPzHItImbGdGqd+7jLvAS17sWvwTueJmN6/KdmjmTrz3g6DASX2I6Whzo6SvRjl
 A5XxcP3Tk0SEHq/f2sw==
X-Proofpoint-ORIG-GUID: HD4mjFoYF7nbUh1W3VBm7QgSfEq7KkZD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-22_01,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 adultscore=0 spamscore=0
 malwarescore=0 impostorscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604220113

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

Palash Kambar (2):
  ufs: core: Configure only active lanes during link
  ufs: ufs-qcom: Enable Auto Hibern8 clock request support

 drivers/ufs/core/ufshcd.c   | 35 +++++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufs-qcom.c | 10 ++++++++++
 drivers/ufs/host/ufs-qcom.h | 11 +++++++++++
 3 files changed, 56 insertions(+)

-- 
2.34.1

