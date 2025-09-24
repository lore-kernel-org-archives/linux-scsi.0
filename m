Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1B825484D
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 23:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758756547; cv=none; b=c0pSLLYdCqfg6mNfRaq1D9kPqoTLjQRQADnAHGzkGh+g73XgT0POxscpGIemUOWo3A5ztZie3SITHDhYSMymog30lKYK0DU/BRB+kwLxjIh/rbHg81xiQEBeVlzlX5AfCkUTzq8HtIvy6K1cF9A1TZ3L5lesAkdyQDaqpK4jUx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758756547; c=relaxed/simple;
	bh=iNvBhLDG9ygoIMGrSAjur0ixwelDiqAhu5UHp/R+O/o=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=FQES0u463MyydhSNMp7Dtf4Dpw3DhXPgDHlCdo/duMsXetWNK3DuD+Oiu+djLe6uipVK5GWef+6BpxJDc9Xhpu9BtJZ/3PhbgH/QkMk8BZATnBo1dCr3hjInT7ceozJFk5vmuMnqxppoac0hHkzA+Du+cAVKZ5tvKgtfGAmaHoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pXOkAyPS; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pXOkAyPS"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58ODNUmN029443
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 23:29:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=9+l0csdA98QdCq8IK8vG8I
	Wfe5KMbV7vWJnvNBVhQ9w=; b=pXOkAyPSBZXFtG2rliNUD5sQmFFf9FZim01R5Z
	r99r2wPHw2nyj0Q2mPfoVqUBdPD1RFJarrW46tgkpRmnj8GvPqsb4OfGI+eYiRQA
	z5ob4Zv3J1zmNRj0CAFQpY4AUnXigx1GTaqBKsaVMlXYki6dzGNE/pdCpOf9zo1O
	Oi3nCArt74qgdLBZVTWOXPQ9NJujBjhOgxg97sVWBkHbVi+sxm5dyfhar7/69TPD
	3tb40dsM+BpX33k03BquvfgtMfe/LsopH6+vX+JFefBDQviV1nQ/1nJ8Q/1ODgh5
	jIoIsX6QStNrDGP/HH6ZYJpTqxFA5C1Zoth+yQp+yY32pVxg==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 499n1fnwj6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 23:29:05 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-26985173d8eso5023935ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 16:29:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758756545; x=1759361345;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9+l0csdA98QdCq8IK8vG8IWfe5KMbV7vWJnvNBVhQ9w=;
        b=TQUoRvSsfpeRut6vX8Z6bmmsMWbrK9TCT4caJ2x3l1/6xefsb8asATLhdDs/RotF53
         KpFzsMcbImGPJABmGxuEO8ogMhp/lvmifI2QXdslXmt/N6Vk3RSskxvQwNDaxtY35mZj
         pSerRdsRopzl58aN/blhXZPjqZpLSrsUZ9lqiivZw2naN1cSJtUlQVZmCjiHRDg0939/
         i2k49q+mwBqDCxIHe2GcrgtUf/tfEXZNyBIfJx5NT8iA+TfRT6F2ZtQ60wm3vvI5193G
         8eYQmLsNN8/soCRVDQSCfYPQGQ4lZaEx8ntqogtWfDrpxZSWQ+PH5sOWoBKHzJkyZzxD
         FdgA==
X-Forwarded-Encrypted: i=1; AJvYcCWfm810Iush17Yn2cSI8EFhSmd5OPe/rAcENO6DOE+0ClpDOwNkZsTYlwr7KZ4yWBqAr7kSGHZ8X8Df@vger.kernel.org
X-Gm-Message-State: AOJu0YwMNjEtHBq8iBve5nSejnmLc1veZwQN/8mqMgVWay9Y90gb4bgl
	1Lw6Rqd74XU+0RFT/m2qoTnDk1Syx+6JOy5pWyWoFXqN2iPyHFPmlOHlYsoGPgw5oNvPcWZGpBU
	uoHI6R+SGKI97z/DOC83JtWXBW0WJp/uRpYJJmz5fXazZcjhH1JihmCX0vTmpVJVG
X-Gm-Gg: ASbGncuV5HmdidE79p3GXgWFyDKYTxElUQatnNBNeEDP6TT+Lo8UMJ7MNNEAAqSqSV3
	tJp5KnT3AZDDY+4MMNjaA4cqYxzogazDWiQodAerT4UIQebYurYwOHIdh3gIrL3qMvKOKIQSEid
	F5WHa5E4Kkcqg2BL/9sB0UD48DJkSmSR10dS3goDLXL5mRy3iNEXbibYnNxJDPDx/wO6BMNueZy
	Z+LiG4U6EFGoDJGn4ju11xwp5YhaxD+EJqAShsBuYpICiAeaK1500HZMeOR/0SP3Af8WtMNUAT8
	VZ7Ae1xmx9908MRuQ+VcS2eRaVVrykLatjiCdAjZDx7sWnKI3IZ70Eh6fTD1jPprQGUquQKr5fi
	eg78q51f7JcTVYlI=
X-Received: by 2002:a17:902:db01:b0:272:dee1:c133 with SMTP id d9443c01a7336-27ed49ded13mr14244185ad.22.1758756544865;
        Wed, 24 Sep 2025 16:29:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEUEPADcwlddCviiL0reaYKNZCOT/tRIgVAPefqNdpaaX6oQdCmVpOJj5ORnG7Clz7s+SorlA==
X-Received: by 2002:a17:902:db01:b0:272:dee1:c133 with SMTP id d9443c01a7336-27ed49ded13mr14243955ad.22.1758756544429;
        Wed, 24 Sep 2025 16:29:04 -0700 (PDT)
Received: from hu-jingyw-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66cdfafsm4292825ad.30.2025.09.24.16.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 16:29:04 -0700 (PDT)
From: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
Subject: [PATCH 0/2] Add UFS support for Kaanapali
Date: Wed, 24 Sep 2025 16:28:59 -0700
Message-Id: <20250924-knp-ufs-v1-0-42e0955a1f7c@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALt+1GgC/x3MUQqDMBCE4avIPndBpVXTq5Q+xDjRpTSVXVsE8
 e6mPn7wz2xkUIHRvdhI8ROTT8qoLgWFyacRLEM21WV9K13V8ivN/I3G17YJLqJzDSLlelZEWc+
 nxzO79wbu1acw/fdvbwuU9v0AMNSaCHIAAAA=
To: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org,
        Jingyi Wang <jingyi.wang@oss.qualcomm.com>, aiqun.yu@oss.qualcomm.com,
        tingwei.zhang@oss.qualcomm.com, trilok.soni@oss.qualcomm.com,
        yijie.yang@oss.qualcomm.com,
        Nitin Rawat <nitin.rawat@oss.qualcomm.com>
X-Mailer: b4 0.15-dev-99b12
X-Developer-Signature: v=1; a=ed25519-sha256; t=1758756543; l=658;
 i=jingyi.wang@oss.qualcomm.com; s=20250911; h=from:subject:message-id;
 bh=iNvBhLDG9ygoIMGrSAjur0ixwelDiqAhu5UHp/R+O/o=;
 b=259J+ycLevBFX4HiFzgSeQV3oznulyjnT7EPeTQadK+TvFBBkL0cJtcubNHatuDgWE2EAWeFO
 wSvsT6yl5qzDNQJe7HxhU/TDFOjakz3gnGHdI2MRwPveN68RqnE3bS/
X-Developer-Key: i=jingyi.wang@oss.qualcomm.com; a=ed25519;
 pk=PSoHZ6KbUss3IW8FPRVMHMK0Jkkr/jV347mBYJO3iLo=
X-Proofpoint-ORIG-GUID: MXi21NtvzzTEx7MPM6Jhac-0mk_4fDTq
X-Proofpoint-GUID: MXi21NtvzzTEx7MPM6Jhac-0mk_4fDTq
X-Authority-Analysis: v=2.4 cv=No/Rc9dJ c=1 sm=1 tr=0 ts=68d47ec1 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=EUspDBNiAAAA:8 a=YZPfJuuz2T7GfvdrPZMA:9
 a=QEXdDO2ut3YA:10 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAzNyBTYWx0ZWRfX/ch4XpWP26p7
 bWTWi1uVX0XPrdHPUU0lqk4N67UCB7EOpSuAI1ujgE0v3X0Q7hdfFznNrZ8/PhbbWlQT1gw/EqK
 7NhSz/uwzFuaNbR284MioiXaIrVOXjtBBcVzcUcYS6cXntu9t5gS+rvQhZumc3/B7SBwHYoApCZ
 cO+FNh+MWDayDaVooSRz/fyxslZw9xpDhN41o5FyA4p1wNvwYUZQAVQGv+60khifIwDHID7F4fu
 2D+qQk6UpT26saEvm/nr6199LVQn83CQfm09w4RPHoUjr7eRbXfWdqZOLVxD1hlnGygI2KBFo6e
 MH2JUN+2Tbj7CAdIGrIE6/MWMpix5x2JGDrPyiMVf3wINZnmOpwnuiFeYAHqYWX88SiDxQMi7zd
 35FNBl2F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_07,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 spamscore=0 suspectscore=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509200037

Document the Kaanapali UFS controller and QMP UFS PHY.

Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
---
Jingyi Wang (1):
      dt-bindings: phy: Add QMP UFS PHY compatible for Kaanapali

Nitin Rawat (1):
      dt-bindings: ufs: qcom: Document the Kaanapali UFS controller

 Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml | 4 ++++
 Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml         | 2 ++
 2 files changed, 6 insertions(+)
---
base-commit: ae2d20002576d2893ecaff25db3d7ef9190ac0b6
change-id: 20250917-knp-ufs-476c9fe896ef

Best regards,
-- 
Jingyi Wang <jingyi.wang@oss.qualcomm.com>

