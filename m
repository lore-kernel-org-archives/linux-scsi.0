Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328171F4CB7
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 06:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760421863; cv=none; b=tC7IioTbnMwvCDU9tReeBCm98Z5eUA/IpeehvGkSYnhfHnfzlfuh2HV26VP23v4CrxmV6iwtXIVRoL15NxsGfaZfYIqICi/x18b0hTG7bgMBB+aLnPGsu5yhi3VhjImsLI00UYn4sj3koC+9coHITPmuqoeyBppeBORNbafa8x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760421863; c=relaxed/simple;
	bh=SETPzXBTnAMaQ1frJwUjp06dh5JmQoMduT94d5pFWU8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=takDKr1cW1AUKMDUvf36GdO77/6S5Mu/HyZW+w1nRfmkBO/VF0jcqFX5cms8kypbJQmvney8E/EbzTYIzE93KIifZNafF9NfQIWlTIdm/fEAqQdASa9g+dA1leh1dUIFBvN4ECRdaZmh5ftj7fAglTyAlKIvdMX8UGkxh2mwkrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=OWZMcuVG; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="OWZMcuVG"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59DHDF3r008599
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 06:04:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=XpaNi5zmsS21XsRleV8eLPwHkBN0I4IbPH8
	sMXSuuhU=; b=OWZMcuVG5EuU+Ec32Zi9AvoBchnwyDhI/2DmAlRFOKIWUIMNjhm
	J/EjtaDAhwGgFMChQs0Rz2m6rKrPOnXXiD0Ss1syc12Hd6s1xrJA0iD8JzGaoAdf
	XH5WCGQ23w7yxffc1zXgLQbGNuaU3zVMquAjhmFzz3+p3DDIbRJ2N+DqKrovz7BI
	vI38dN3rwPX7x7km/EDlBOc4U9OtY6s6/vKSucyKW9+dafQ97YIKe0+zGasXg4p3
	BQryZJiakCGg6WypVjpEzPfVXL93MZ512JMzKS9TDpOn5wJ2dXnxq1PMypqOMZNk
	/6c88rMFK7Aib22EvhbuOhJN/iKDuXwxfJw==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49rtrt44mt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 06:04:20 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-76e2ea9366aso7386126b3a.2
        for <linux-scsi@vger.kernel.org>; Mon, 13 Oct 2025 23:04:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760421859; x=1761026659;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XpaNi5zmsS21XsRleV8eLPwHkBN0I4IbPH8sMXSuuhU=;
        b=JSK4+8k7O0MNLTDT99e25t+kCPepYZO3TfE8JLetF+5AE9jC/Se0S//f/G6na4IGsw
         p9xOCcf5A4GBT+2sZRGAER0mKWSRMlLLaP/4tI+sqCA2KG0I6kZtCDRC5MirCx9IbikA
         OinlWTvy8WLt51kBw3O5l2dIf/jyo0/42y5KKlyn32yDaRb66hU7d+1tY5Uj8OK0rNk/
         lyWQbkO6NMifpZ5AJuVnTZKleMU8r7rjyBJO63HQofUDx3MU728eF/FzdmtZZmvMjSq0
         Z6a67NOqleND1CFu06msFSmpzvj9TgLwtFjzAwPpFAmWYhCbiPaaY5Ms0pExTJZmP4c5
         BEaA==
X-Forwarded-Encrypted: i=1; AJvYcCVidnE5ICf1CcFzD9BgMCQ0SJhFrMgyJ92CZcEgEL6sPg+UwowNmB0YaSgnI7QrBmKivJ2B9pRejphh@vger.kernel.org
X-Gm-Message-State: AOJu0YyZ7ZYrPJpdhIP/jj8hfkZBtcFoN/pDhTxDP5k3gtOKTUZGMddE
	1GlI1ZyzfHMkrTzig+IC5YHJSK+zB10b3gfTWvKkLYULVbRYmxUmxEvu3OdLZ4GEdH2BJT+pZvs
	gSZ+lG+NfgosiuTr1rZWZVrE478FhVZVugzBXqLqECewQzNzEsaHIDfNXTVk/TAfc
X-Gm-Gg: ASbGncvPejvTi61fYf26rxI44WpSldoVa8bZT39uoOS/5Q1dU3jvrTD6BKa5hcmY9q1
	fcPJ7/EkarARiWyhDoneya2hTavzv2HQ5zWCU6PoZYvsEh2lNpzrsKEA15gzBxUzcjdChMs1PCk
	+R73JpZThyiQDG1JiPBVqq1ZAPHYrxOapSnpJhyDNhtu+T5UjxYQ26WVkO5FoJtVguOeKOUjcjm
	5lcRaslihkie7VwQ0TgFPqFtr770TnFUWpgUI7YmnzDzxR3RlxFRunFhuaPozzIGMfM8a6zJIP7
	1nLePYNpX0nfWM5oxNKlUlbKIE+I5Ex/HUB7xzxd/sNT0cXFehFX1M0uSJgCs0NkI2k4wmim
X-Received: by 2002:a05:6a00:92a2:b0:781:17ba:ad76 with SMTP id d2e1a72fcca58-79387c17394mr28610029b3a.24.1760421859518;
        Mon, 13 Oct 2025 23:04:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFC6tNUKNUKSOjotjmKZx/9exMqkN4NekwtaO/BhywRYMP7gUY3U0B74E+0I+cPrGa37Hy3ng==
X-Received: by 2002:a05:6a00:92a2:b0:781:17ba:ad76 with SMTP id d2e1a72fcca58-79387c17394mr28610003b3a.24.1760421859081;
        Mon, 13 Oct 2025 23:04:19 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7992b0604cfsm13946024b3a.9.2025.10.13.23.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 23:04:18 -0700 (PDT)
From: palash.kambar@oss.qualcomm.com
To: mani@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, peter.griffin@linaro.org, krzk@kernel.org,
        peter.wang@mediatek.com, beanhuo@micron.com, quic_nguyenb@quicinc.com,
        adrian.hunter@intel.com, ebiggers@kernel.org,
        neil.armstrong@linaro.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, quic_cang@quicinc.com,
        quic_nitirawa@quicinc.com,
        Palash Kambar <palash.kambar@oss.qualcomm.com>
Subject: [PATCH V1 0/2] Address race condition in MCQ mode and enhance
Date: Tue, 14 Oct 2025 11:34:04 +0530
Message-Id: <20251014060406.1420475-1-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: uRWjzcfaR_xzCFqlcB5LbIReIg0r1nMZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEzMDAyMiBTYWx0ZWRfX82tN0wooEQEz
 PI8rKvksWq83FxvzLlMmqvFo+SRXNS+IK/5lxWEvo5YMWfvYJtqJOINfIovXHIJFbEsyTbvZqyS
 rTc3q+q4CwIp6A9lKYQBs4ZDRcs/Vqw+o1vLwIzWWJXN4tSbSuyYuq6BCSXA56uVw1NWRTkqJ1/
 QNgbJ5tK69W+36IdmoG/TfjDS3GtW4qDpEMdQKVDyVGMLqYqbGVJaRVDS0Acfll10XT0yyfNMnb
 Bj6avox/eqDnEFEjK5+VtriB51Jri3QPVA/OKHRcQ3bbiNw6FeVA3zpZQ0WCi+yxKEk90h57lsA
 u6HjMGwA8K2K1xAO9AzIJ0yS0xNjKiaJYjsvHy2T9qImOajriFtmkbEoCChIJl+HGs8Kx8d2pHZ
 Jm/r1NiOLqjKsnoMR2H90EZPg0V/Qw==
X-Authority-Analysis: v=2.4 cv=SfD6t/Ru c=1 sm=1 tr=0 ts=68ede7e4 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8
 a=AlCj3w5ouSWVjIIyBF0A:9 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-GUID: uRWjzcfaR_xzCFqlcB5LbIReIg0r1nMZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-14_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1011 adultscore=0 phishscore=0 lowpriorityscore=0
 bulkscore=0 impostorscore=0 priorityscore=1501 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510130022

From: Palash Kambar <palash.kambar@oss.qualcomm.com>

This patch series addresses a race condition in MCQ mode of the QCOM 
UFS host controller for hardware version 6.

The second patch integrates the logic into the UFS core layer by
invoking appropriate vops.

Can Guo (1):
  ufs: ufs-qcom: Disable AHIT before SQ tail update to prevent race in
    MCQ mode

Palash Kambar (1):
  ufs: core:Add vendor-specific callbacks and update setup_xfer_req
    interface

 drivers/ufs/core/ufshcd.c     |  6 ++++--
 drivers/ufs/host/ufs-exynos.c |  6 +++++-
 drivers/ufs/host/ufs-qcom.c   | 35 +++++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufs-qcom.h   |  1 +
 include/ufs/ufshcd.h          |  5 +++--
 5 files changed, 48 insertions(+), 5 deletions(-)

-- 
2.34.1

