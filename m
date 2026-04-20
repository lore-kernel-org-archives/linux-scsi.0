Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DA93876C8
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 10:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776679474; cv=none; b=h9vXE7izdmk8ZdI4HwRvQcJdmCpaQcoYfKTqQDIxuVb2Fxz4AIbJk+hXAv/NUV4R38XP3YJSiZE/QK4V3HFx7EgFAwyLyZ4SwRg6+08WQU3XrsMsd+aDZlWbbD96RacEUDijnf0Jle+NSUYibHXuXJMrdq0E5IFUJq+feHJHFH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776679474; c=relaxed/simple;
	bh=eV9AES1TbhXq51pA2mMeaDXNGOeNegLY90c01VW5r+s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ApTURphR9yQLTPLDVNV3drLKiUTb7Kr35CSGnTVXyIVEtmfaDkX/YrYkZUUcIOEmBOR35iyFXnXGQMgDxR03tUg0CkpE4bL4nXyuqFuNzOqyJIMuK8KW3BV4CamwJFdix2drN2dRj6HQBdBGgv3kLiyeB+ZMBKQp6zb/OheYV3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kniTWOR/; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CAsc0SDj; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kniTWOR/";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CAsc0SDj"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63K97pPf1599869
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 10:04:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=EHoyER7aYaxX3ZQ0duDO1RAvEw3sWVcW2tA
	TNTZNCgo=; b=kniTWOR/XREAZ+XnphXnrZ08z88NKFVhIEXCFD78IigEnTF/nS1
	6TuLtUW6juW4DFoVPBu7OsBa5C9RWqhO2W/MZm7sePFGayFbvETPj/eeN9/Gb83U
	CKbbTo6AieOyMQAHsDzrayohfPlgL5I6pQnpjb+TzvU84dBOshdOIhB0AgvNcJCA
	k/faOKNDCdU5x3Swgi4hlOvP4POSSas+r/ImfHEt3zSCliaVJcbhTvAB61NmqFiS
	bYuTqFSo5wu2hEniXl3dVy37qtGwuho+ceI26ZR/xGsL0095tOXu+Q2mOlXJipIL
	XjMBoslbKJlYqGQw12pBzqsIEEZ7VbM/e+A==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dnh8986xf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 10:04:31 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-2dd1c74508cso5324831eec.0
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 03:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776679470; x=1777284270; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EHoyER7aYaxX3ZQ0duDO1RAvEw3sWVcW2tATNTZNCgo=;
        b=CAsc0SDjzgb7NsYgZSqAw89njsNOWBTA0Mk76tKyxvq9aFMGWZLPrng9+M03UvQifC
         0b/B9XLrq1rx534m9CP8awRlZv08zwSpygRfxkkmiie8UuawwZubE/WWcAoWmseqp0OE
         Y5sdtnajfHCH1wat6uA5s0w511Bio01e73az6rb6LfiQnvkSCoKIfX+Uw/gcMo92vkwu
         ycpvDbv65bAL/qoRHcYdpFbgYHKNzWEgRhtViyRtxYMKkI5FeTZ2A5NGGlXumPCQON7M
         Mm9zZtc8hvBpnjFRREl8fj/EwzhWhDso8/7OqIOLAfGZxuzuJyJd/I83C8HiKQcrCCUS
         dMjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776679470; x=1777284270;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EHoyER7aYaxX3ZQ0duDO1RAvEw3sWVcW2tATNTZNCgo=;
        b=SIawPX5wMQtMAPIbx6XXmDghQUvbfdwW6dz+OXSE04mPSriJdJf5c1FaOnNFBzuHbY
         UX1kpbJdexCGbKWib50MPc5/5/VBKbYb8OKsYuKFeqZDJ3x03MlVpfsesmOXPJlm5w44
         bwvMiZP+j7K/MLfISyhVNT209YqZKqmc0rnbJjeIDNXzT6ZuIYZywLNNP2mvY15gP6wl
         6IxjkZr601D5dTVE9NmKEv8DBukDCI1SIsl89N6rDUD8DV5BJpjEiNOWCUYqdGjZGDgB
         LPyp6egYqx1/JteYpOwXicdMpJc7b29RCihsQceMMRcZadImR1JxeDJSobgrMed2wBCL
         S3Kw==
X-Forwarded-Encrypted: i=1; AFNElJ9VbCP2pkP1gksLsE8d5hpnOumHEVVKTq9gVkK/nWBFylep9E0bpB6RAnW++qHTIdPPTVMsVBOiVbPR@vger.kernel.org
X-Gm-Message-State: AOJu0YwDyFhDnlvNB2vHeaQKIlPjwWnGo4MVcvb4pMu9FaR0vv+00RYx
	FZmRaErvXcF5QPPmPUdYWVBvsFJztKLVCRIiG75T/n4YRLlZ1EJRdOyn3xtNoOhGKST+A6EoX+J
	ArocUSw6AnvoOoBNxZBbBNn+ZQmXVTqrg4ck+MMhTdZRmYDl3iRJz0wM5QFeNP/fJ
X-Gm-Gg: AeBDieu7XC4f7BfTvjR1s1bgdBZVanH8ZJjnDNmuy9erJKc85ewQflEyWnvnS8gnEW7
	C9hhP8m8EMN5bWYKklp2alpFykF7VWxlpJf01x9fqbs5apTKRibAW0uRf7Kc/S/zjnP0ZQAq65D
	fawPmS5CmyNAGzB7OG5RwFlpF8WMmplf2G/o2L30t1ucLOBxZrWV5mszGMvjrphuw9io7Xx87Mw
	VMEJ9bSRJKP8n8NxwVqVfbzaOJW79Uv9j5BDbG5Vvd86f2IAUwEvhBGmRpQ4yz4lKldYirl1Eo2
	yDG73aioQed/dQQeZv7dqrnoSPMHXkFG3hQz0kuYJ3QjuV/VEyu7FDmYT2Ei5mbyIaegwiugmoc
	q+cOYWWDk5DzQ/o+DT/kiWwPge9NHTHVE5MPhQUXe6R6TPKPee7gBrVURtulzpiSKehu92AE/k5
	jFSqZPCHfMwl9hRDxE
X-Received: by 2002:a05:7301:1f06:b0:2dd:6937:79d5 with SMTP id 5a478bee46e88-2e464dacd7cmr6486555eec.8.1776679470193;
        Mon, 20 Apr 2026 03:04:30 -0700 (PDT)
X-Received: by 2002:a05:7301:1f06:b0:2dd:6937:79d5 with SMTP id 5a478bee46e88-2e464dacd7cmr6486536eec.8.1776679469653;
        Mon, 20 Apr 2026 03:04:29 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y.qualcomm.com (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2e53d2cfef3sm13076436eec.24.2026.04.20.03.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 03:04:29 -0700 (PDT)
From: Shawn Guo <shengchao.guo@oss.qualcomm.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <lumag@kernel.org>,
        Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shengchao.guo@oss.qualcomm.com>
Subject: [PATCH 0/2] scsi: ufs: dt-bindings: Add compatibles for Nord UFS controller
Date: Mon, 20 Apr 2026 18:04:14 +0800
Message-ID: <20260420100416.1252983-1-shengchao.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIwMDA5NyBTYWx0ZWRfX+p4/nAoGO+IZ
 S+ru7A1DTEIEQrAMjhz6wx8QDVoX9hP9lVACtbYtineBmKrciX2Ct84ny/XSHRq9wo8JEzz5d7q
 TKV+yUPJbVx1epUIbmR0+2nlx+9P46UzjLPQJHuoxPCzsNJ8gDI6XQTYz7nrlrxFO/eOi5hRagB
 KQ9ATaH8O4HT4C6FNfY46gELBf5OOY69WQ5HSEkdmvI1rPQBlZL6Rpj4H3Go6fkBNZ98hVb5Xfw
 uiMWtBeDzVMpcr3wvf2fNVsv6wJ4HJ3vjgmNn+Q5TJtXbymUlObAf2Ghx7IUWzC0nY00kUDheah
 F5/B6xT/m61rIe+pFlbmgJ6C19zgfusejsPE9koAvxLBYIMbC7wMNAbyydG5C5k/P3/MKfrdXDx
 dMD+rXaWIN+a+AGFMecM8ExoMHRepo6BNooj/fajS2buIF8tGHgLj+Xc3OURPo5GN7Wn/XEMpQp
 pmm7yj6WRvoSe/jPXsA==
X-Authority-Analysis: v=2.4 cv=D6B37PRj c=1 sm=1 tr=0 ts=69e5fa2f cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=a7bZ31jgoYMsa_LFyGoA:9
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-ORIG-GUID: 4-qLloByVtvGcl5loo9CQaPtA_T4U_vf
X-Proofpoint-GUID: 4-qLloByVtvGcl5loo9CQaPtA_T4U_vf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_02,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 phishscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604200097

This series documents the UFS host controller on Qualcomm Nord SoC.

Nord is a Qualcomm SoC series. Its UFS controller has a multi-queue
command (MCQ) register range in addition to the standard one,
both of which are required.

Nord also has an automotive variant, SA8797P, where the platform
firmware implements an SCMI server and manages UFS resources such as
the PHY, clocks, regulators and resets. As a result, SA8797P shares
the minimal OS-visible DT interface of SA8255P and uses it as the
fallback compatible.

Deepti Jaggi (1):
  scsi: ufs: dt-bindings: Add compatible for SA8797P UFS Host Controller

Shawn Guo (1):
  scsi: ufs: dt-bindings: Add compatible for Nord UFS Host Controller

 .../devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml        | 7 +++++--
 .../devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml         | 3 +++
 2 files changed, 8 insertions(+), 2 deletions(-)

-- 
2.43.0

