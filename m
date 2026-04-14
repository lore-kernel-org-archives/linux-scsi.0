Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20E83C2761
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 09:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776159110; cv=none; b=W1bR9je+lgyHdP2h9DHseDW6C/j1AgVcXHATRb9qENhCI92W1/NI/buVVpboBYOPgd7AgRGfDClZmfKsBkZu7B0GMRTIKaTk8bYkwdDfLpKNPXVqpRNmc3LeEeunNDwXDGVEVjllSec41qMissyZLRDgFu2F27oepqPm4kCiiEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776159110; c=relaxed/simple;
	bh=1DV8wn40yloWIVqC625tjVcC+VAluRD/D30m/TowZ1U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=I57ke89wIyAL/+H1xINMTYrkTIa4hE/8VfxxhckZKQ0p9rc2ZQx0Hr7iw6E3nB0FDInPR+t6WjQIjABgNiQ82YYufDosH1CxcBIMVzQ+o8Z4uID0UZjkgnReHlxf/eAqgtY/WkffMkIAKQK6M+2TNi9QWNxPNWEhQE/PgzHzIg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Arus0ye4; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=epHSPUKo; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Arus0ye4";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="epHSPUKo"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63E6kvH3395289
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 09:31:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=t4I0ceYasGeZcIvy+3li/bvUFtuLBCMTugD
	GFLqQGMU=; b=Arus0ye4ey4ZUZbTJzarhWNRp+qMDelPujH3McOgzHkZaumyeOe
	wU+mJ7ZpoXScQM02nDamxjt2m2MkOh5Jxg1qPc0etga+N+8wuverdCm8hC6fChvF
	Bb0mvIv77+GRinPiQHNj+nf1PDQQSazkcwm7NcalBCh1Fojv39kKq/uRGx2LaLZA
	wbyjSr0yOCvxioe8YiRxwMqbmE4GluB45H+lI6BOgl91zqpBnx7brc8HGlXjIMTN
	e8Nrp1q6md3CeYk9R9y0xScFpcKFQ1R+Y/MtcjhT4oanU1L75avbUwGxqavTZflm
	wY0TYZb1vPDH6FX9bJRB6v98eNJTKo9TchA==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dh870t3xh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 09:31:48 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-82c89d4ce16so3565549b3a.2
        for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 02:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776159108; x=1776763908; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=t4I0ceYasGeZcIvy+3li/bvUFtuLBCMTugDGFLqQGMU=;
        b=epHSPUKoc45e6dr+MIFByVkyTxhD+nVRfB8uY0h860OYtOjg3QtjXQCzwKoqz7IhdC
         vdd8z3HmDVdeDXKqIav7k5iL5Q+8uNaAxXljIXNBxyw4y7YIA02NNeMQ9apVQzK0VPLc
         R/+dVzx7ZZQKVbRZZTRmsjPzeuIsYOwgyEslgpXv4vzUW60m2FOP/KwNP/X/CgGatMHO
         v7KM3HfypcSVAImk+rnV9Ei0rUSHKGjTtjQBWvdGaircrjhyxJdjx1wz6FPJVQh4xZxI
         KMIdFfe3qptMPXLrYLSRmcsbBfnS5TXgiPH1yV0SRldRePy2iRZOkvhYQZSQnMXkflNa
         Gc8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776159108; x=1776763908;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t4I0ceYasGeZcIvy+3li/bvUFtuLBCMTugDGFLqQGMU=;
        b=hMrZMlGm3dWh4fBc6ZJEcpU6DRncEky4zT00F8eaiFwDAvrl338juuuWJ1QnTC8ZBv
         9dO5JdB1UqwCwWel1EV+hBiHLkD2M+sAVPVYJqCkEJUFkwM2AM3jtRZ8wXCgYSs0uDD5
         8R0nfo3FbBmejTFtuPM4FOGLvJCkyENyn3B74Di8B/LqOINYqjMRx/kjT9GY6QYT32F5
         LJVtTPZFyHZfmHP0QW440t8sYzK/QOa98M/4YgjgTuXBTxuw/CFbpvafG09yj3EHSWgs
         8SHN3CDhnglMGLfoc7fdzEDigVpdrO35bLe5o03qh7OD96X3Posua2kKZUQBToH3ko0M
         VfnA==
X-Forwarded-Encrypted: i=1; AFNElJ/ReJjHjdEwBoJBsO2UXAQNLD6D6NjlMm7br2LT0J2sOj+6y0OW6xxdlCvyi3reRG/Wc69R7EDAVT4E@vger.kernel.org
X-Gm-Message-State: AOJu0YwGdrdALWIxGhSjeKMMfLvZTgE5D2YzipWJ/mV/0VJykNlxz1fO
	mQF/2GsrWu7uLRdxnJ21VXpceywDz/cUjwrieuWzQXuIhAzceX8D2KBVgKAJV5C+7KCUoeSVKAD
	QWqcZ6mQ0v7qdVjYBJWKVZODx2S+JcUkq3rYoSleaL8YVXaJYUFyNAQyTgPtrqOx0
X-Gm-Gg: AeBDieu5ds8sr7lZJGPoCVcDb43WhPehU661JQWPDI6ChlAFfUZODUYpVoJikKlhSML
	PBvRWIGiqrVwdmHA+2qNitBojz/RHD3c1q4v4LDWVqyc5f519P63WAlXYibZnOATnFaLCPyfWxC
	BKZmGsMtktI3vICaOs51CRmDFdfwNHwlQOfiFDfA2iZOl8zQJfa/UBnHi3P4PqGK9J9BF6PuaO/
	XFdBOAAX8FBkbliME7HyYAavy4hoyhzwZB0EHtMWHiFpuvadZUhPXttWV4ynV7ZVveP0JKqpl2U
	lRIGKUb5fCjYVo7cwmPX19iPB+o6E+QKUp9zOiww3Ut4KwdFkB1pXFD5qLP/qiHdndqnphX/SPf
	Df+cY7Z9HfzeutreTtHjUnDCqRLOFqRxCb1eYM+hKKfZirgsy47EBVA==
X-Received: by 2002:a05:6a00:12cc:b0:824:a22c:c6d7 with SMTP id d2e1a72fcca58-82f0c2783f2mr17093595b3a.18.1776159107551;
        Tue, 14 Apr 2026 02:31:47 -0700 (PDT)
X-Received: by 2002:a05:6a00:12cc:b0:824:a22c:c6d7 with SMTP id d2e1a72fcca58-82f0c2783f2mr17093568b3a.18.1776159107038;
        Tue, 14 Apr 2026 02:31:47 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c35194asm17321642b3a.20.2026.04.14.02.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 02:31:46 -0700 (PDT)
From: palash.kambar@oss.qualcomm.com
To: mani@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, bvanassche@acm.org,
        shawn.lin@rock-chips.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        Palash Kambar <palash.kambar@oss.qualcomm.com>
Subject: [PATCH V3 0/2] Add post change sequence for link start notify
Date: Tue, 14 Apr 2026 15:01:33 +0530
Message-Id: <20260414093135.660725-1-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 4ZLWlN9ABFyovyipPlsfGuiUa-tRzUt-
X-Proofpoint-GUID: 4ZLWlN9ABFyovyipPlsfGuiUa-tRzUt-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDA4OCBTYWx0ZWRfX3RmPH55niWEI
 jDtLGTgYowToV34zqZvHqt1OnjLM43SfFtajOpBkRDlrnY/9lTKhR1PGmH1fjbA0AIc3C8DO6qB
 /4UgZSWPcVuvukoHAFV6gJpCb8SRUhfLfHtO4Vego/qljAx4tuiDPYFZv9x+PDVbh2NwsWd26lH
 487oOLetL9VpXZVGxqCJoQikCRIKeyvXTMiAO87PCBcPG4Qk4xpj04JbDMLSGO8oBGI7G2nzJ2p
 b8aNOV8L0eBxTMLX7X+a98wIEBRtvVXS3k/wQMQ7HXS6c6izN7r+CIDlthtU6Mg6Mg2Y2SYIECC
 PLB9U3p2YZU82Cwjw700wwNhss+1r27+pWwf0ZNO7uVTRwLXNqMo7cB2CbOiri5SFVLVjJjonkn
 Q9PQHmA8JSNBFi2TN1msL+9f266c/L3ip9yAGl0GA7jNBmNat4Bc8+c89nz6HrxFv4avZR+ReFo
 Nk33LtLOXwQQXdPec/A==
X-Authority-Analysis: v=2.4 cv=MK9QXsZl c=1 sm=1 tr=0 ts=69de0984 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=rbNoiXgGD7Sd92Kb1yEA:9 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_02,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 clxscore=1015 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604140088

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

Palash Kambar (2):
  ufs: core: Configure only active lanes during link
  ufs: ufs-qcom: Enable Auto Hibern8 clock request support

 drivers/ufs/core/ufshcd.c   | 37 +++++++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufs-qcom.c | 10 ++++++++++
 drivers/ufs/host/ufs-qcom.h | 11 +++++++++++
 3 files changed, 58 insertions(+)

-- 
2.34.1

