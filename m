Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6D840B0F3
	for <linux-scsi@vger.kernel.org>; Mon,  3 Aug 2026 13:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785762549; cv=none; b=aH1PEENdFZ5vA9XUKrfAlotaIP5uRPfor1zk6ner2srRT4Tm4/rR29W3YhHsluHk9ihg84mL1bySUKml4Dy7qCCq5QzoNQXiPRHeMTpTgtHYOk/X1iLXPt72cAmktN/JEuI49fobT8LrLkHj/i3TA4Co7H7CAPInbzhuZyATedY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785762549; c=relaxed/simple;
	bh=vm+Yn64aFDp+QbVMtjKFCnfosLeMgH04LpkabcdCzqA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=APoJh0aA/O0Qp0Nw+w/jQ+vVTWN+qRXmNPq4r4BKCSZnkAzJ1scsx5ZFaoZUHeojyNdFglm0mfW+fHb61vRcvO6cGJsVIbSmCPGT7qMgl4zvZicV8HVtTqhH+eac8v9e/QAzLsYPtOHDfS5ZA4gBqYgowKyDiYRPNYKa2/ZT6Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Efd4kMHN; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dF8f5/nI; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Efd4kMHN";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dF8f5/nI"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 673C4la3856069
	for <linux-scsi@vger.kernel.org>; Mon, 3 Aug 2026 13:09:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=tQzBlaOnuUBoY6SiAYBdwdvzjNraSCTbt7z
	+aaqODd0=; b=Efd4kMHNaiThIwP7KIaA0EXedumBam5QlNMvCjgST44C23vc2UY
	Wm4Uc6/HE3bTuMNHBw9O14AxxtjaZlKFnZO+w2V9oE6OQbvy6C0S1gkS45eMwHBU
	H1t97NY5UmhGb6JoQjbQLBRm3tjdS6ndMlOITFPZ7ZnA1GnvawbHdiqp7CdNenuz
	Zn+bls+5WbetFibrbLVJ+T4GJcesUqtA9D2iadglnkcjQSf5sjYwNl3GRlG+3G6y
	KUjUvkeLWf8DrsrEoA2o/Gpl/BZkjlkk/Dmv6ZGO/ho9TGQZsU333cciFZ1m1zmF
	MfAnEEtv5+PF63PclaHhBFmbhm/EQzG3HQg==
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ftnrb9nam-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 03 Aug 2026 13:09:05 +0000 (GMT)
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7e9f565a6e7so4358725a34.2
        for <linux-scsi@vger.kernel.org>; Mon, 03 Aug 2026 06:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785762545; x=1786367345; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tQzBlaOnuUBoY6SiAYBdwdvzjNraSCTbt7z+aaqODd0=;
        b=dF8f5/nIFpED31BsCz7abOxU8nOYv5PS5LAoF1MRtwX1+smrulsqrDzt8DT114bJ0L
         U8tIV7Mv5vJz1sp3qtzZsOMjjdj4ppgW5r/hOYtivJ/ZjrE3V6VSW6WCI5nwwPyTj3zv
         YEFBRIMm1+SHg2Gyq6KxfoC0fqS8hHEHnts15KZ8xJflElOAGlp8NPPTHVGQxPLuS5TE
         RdPA6R49sDd1pAd8zH5yuajONQJCCp96cE67y//yHn6/XOEdt8piH420PY+RDAaGB6dN
         hoIJ6hwb9hHWEs/SvQhmQWS85riPkU8Nm2CF05znt3L7yOiTQiEMHhfeUV1AuF/Uf7Kg
         rCGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785762545; x=1786367345;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tQzBlaOnuUBoY6SiAYBdwdvzjNraSCTbt7z+aaqODd0=;
        b=AF0K8Y7u6fYX3lGNLWwrSNBu2UYscm6nFAF5W5xucsLgkONw6TN3M/poaowPBkr8hb
         OYP2dJtbQEDmY2V0aXqb9VC8tTxZayQswr8CrO5LlpAG0yuRjtPJZbdrezPVYqSccigi
         XvNPUHzgHVhwMeDQOHmqAyu1BDMaa2CDWoiNaVsdeuAyu70YR+wkhIGblkoGkUi8lPRe
         ZJniLBJxVFpJgdwoYHx+j6ZRKMTN21s3DXSnIZMqHgRVtYcJ/mzDHHDHqXMSSc95kFuV
         BX6rO9V5Zp/GdAVLoaQx6W6JL/oX/D1UqlWAEIVLsb6Zh9YVVivWf3KEQKrh2f5Rfy4G
         Avvg==
X-Forwarded-Encrypted: i=1; AHgh+Ro1JlMpzbpnGX3majsdc+dPw0a6DZM9i7kq981SCtQCN6PhUv7q1i+ozBtu7/j0vPCijRG+mUzOvEfA@vger.kernel.org
X-Gm-Message-State: AOJu0YyFhJQuT3MuM6aqWWYv8qr6IbeYFTGjME+dHW1WH7RltqL9jqlj
	pun2Z36txHgIIeUQW0bJ+/90Mi3F+EOSTYP7TChpee0iTx3iTEQkIQdKrhOUWdS44elCriwJtt+
	/K8rLLgopUvY4jm6zb5sOy+kCx58d97WGcfX3nFvpuG5pYy9vRWEPnO6CgFJCI/OU
X-Gm-Gg: AR+sD10K374xR6WuW6qjoYZmT0a88JoMpdQeB5dMa7neehQ4doHzCNM5DQ5aCqcxURo
	3c7anoCoQ3JcFoErCfazODFYkE/IfwgO6ZuGShNdGtEEBeFOp/fvv+NwiSkbOGaS7QZ8RH39JHY
	C1d3KrMVz2EC3mkfz+IWco80yCOjP9FkG5SUjiJLRTV+3hLkf3TMbg9y8kN+23AWMGgUN5AXEXc
	bw5LnOiB8iIDnmTiyNwbgU8NmuDtOPdirQjze6DwfHazlEMYkHlULLCR8kF7Ti5aYHMTmyMWqlt
	Hbhdv+E8ZtUlZk3jISFU675Ns076grd4MGeXd7WRfp78h+lREipds2WRMGDvr6z5HTiPpb2n0aw
	H7GYpTZVQVbjes6JaRUlW66Ck5KN4snwJ
X-Received: by 2002:a05:6830:44a1:b0:7e9:e0f3:b914 with SMTP id 46e09a7af769-7f196ea7991mr17856180a34.13.1785762545038;
        Mon, 03 Aug 2026 06:09:05 -0700 (PDT)
X-Received: by 2002:a05:6830:44a1:b0:7e9:e0f3:b914 with SMTP id 46e09a7af769-7f196ea7991mr17856105a34.13.1785762544580;
        Mon, 03 Aug 2026 06:09:04 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f18f0d6ef6sm7366929a34.21.2026.08.03.06.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 06:09:04 -0700 (PDT)
From: palash.kambar@oss.qualcomm.com
To: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, mani@kernel.org,
        alim.akhtar@samsung.com, bvanassche@acm.org, andersson@kernel.org,
        dmitry.baryshkov@oss.qualcomm.com, abel.vesa@oss.qualcomm.com,
        luca.weiss@fairphone.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        Palash Kambar <palash.kambar@oss.qualcomm.com>
Subject: [PATCH v5 0/2] Add Hawi UFS PHY and Controller support
Date: Mon,  3 Aug 2026 18:38:50 +0530
Message-Id: <20260803130852.1432714-1-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDExOCBTYWx0ZWRfX3L8+9hmRvtxa
 J3BV4boTVsMVFZ9IEf2oXze4M66rHLA0M7vEnDgDQKAeQ/IwGZdAnAsXNiWokwqXv2ZgsWnWt0T
 1VA1ciar8XWonskRifx1Ffi33gPQcGE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDExOCBTYWx0ZWRfX5Cm4u59tMt2v
 Q82uFaXW1OsaZWG+1RYc7jUtMFXuLvaVPO87FWWViYBWNqBkzZZdYiEFubO8O9X3iNPLNpbQir3
 aRpmgOfyObFD33ZDzwDyVEDPFH5fLauQoqe2e6Av/vDr8t+kZBninHo5mepHjZt5dYSt8CJoXR3
 w/DpOtvxJgXjdrgD2h/ZegFL6o2JgZMCHZvTwwD7rhM5peU15IcEY8rNoimEXwM+awIrr9CuuAz
 T8LKDDsFnC8xqQeS7AuPTP6hRd7z/34i6Vk+06NHANLpKWBo7RDo6aSiDZ0raj+d59Q9HcP3VZE
 lcg2sI2Gf6O+FS6+cERpc1aJHorZOO2sriFD73QRiFp1qy71OMuFOIc0h+bpPfpfB5zDTB2Qncy
 xwogYNgBsMR/cAMp521cCl7HNi7WCBUQf+EFDrJJm1hfZ/fuPzhW0MYYWL8iDckZBOSpnDv1Abg
 yMrHHf/DNiNH3jVMlIA==
X-Authority-Analysis: v=2.4 cv=RNSD2Yi+ c=1 sm=1 tr=0 ts=6a7092f1 cx=c_pps
 a=7uPEO8VhqeOX8vTJ3z8K6Q==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=EUspDBNiAAAA:8
 a=wRtOOnJjwWicnHpPwtUA:9 a=EXS-LbY8YePsIyqnH6vw:22
X-Proofpoint-GUID: SlqFfz3LzY1jlv3ZqzVZ2trCDujP8M7Y
X-Proofpoint-ORIG-GUID: SlqFfz3LzY1jlv3ZqzVZ2trCDujP8M7Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-03_03,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 clxscore=1011 adultscore=0 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608030118

From: Palash Kambar <palash.kambar@oss.qualcomm.com>

This series introduces devicetree binding documentation and PHY
initialization support required to enable UFS on this platform.

  1. Devicetree binding documentation for the QMP UFS PHY
     used on Qualcomm Hawi.
  2. Initialization sequence tables and configuration required
     for the QMP UFS PHY on Hawi SoC.

---
changes from V1
1) Addressed Dmitry's comments to fix versioning for PCS and qserdes.
2) Addressed Mani's comments and fixed missed compatible string and
   binding name correction.

changes from V2
1) Addressed Dmitry's comments to remove whitespace and stray line.

changes from V3:
1) Addressed Vinod's comment on missing macros.
2) Binding patch for UFS controller has been merged, so removed here.

changes from V4:
1) Rebased code to tip.

Palash Kambar (2):
  phy: qcom-qmp-ufs: Add UFS PHY support on Hawi
  dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Add Hawi UFS PHY
    compatible

 .../phy/qcom,sc8280xp-qmp-ufs-phy.yaml        |   2 +
 .../phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h    |  24 +++
 .../qualcomm/phy-qcom-qmp-qserdes-com-v8.h    |  13 +-
 .../phy-qcom-qmp-qserdes-txrx-ufs-v8.h        |  37 +++++
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c       | 139 ++++++++++++++++++
 5 files changed, 214 insertions(+), 1 deletion(-)
 create mode 100644 drivers/phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h
 create mode 100644 drivers/phy/qualcomm/phy-qcom-qmp-qserdes-txrx-ufs-v8.h

-- 
2.34.1

