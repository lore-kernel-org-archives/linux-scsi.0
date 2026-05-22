Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450B6360EF8
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2026 17:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779470853; cv=none; b=cSknh3Gk8CZyCLPBGY6353466A1x1lYtn3gNXMocFSzu+IVTwvPNcaFOCdFvB7Ink3DESfGyHY5a5blwRnamxXeRfeIKDHAkoALxTVJ4MrKyVD4aFLIyyDZbdndCmDsVrP/NvkilvGJ4oQharO2WXTyRHxzMWPx/gbaBggIs9Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779470853; c=relaxed/simple;
	bh=5J92VyDWgLlUhHhTHy8tKjEQsCOLkA23R9MCmKQ/Gik=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YuVFGwaMGr0+YiRZa42JqMskh3XzX8KhIGXqsVAqG0GdBUY7Tt6JSKucaBR0en+aQ2zX2vkRJBJ05KjheG8h1ScREVgmPAPJ7sfgKoo3SyAjV0ApFNfGmHfQz4xcjQgr0go+T3giJyI1ysHIQK+L0X4zPkIROc1SW3m/d2JTQmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=lWPMRzJK; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=i3lOLQKv; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="lWPMRzJK";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="i3lOLQKv"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64MFr93P1816103
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2026 17:27:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=IwddrSzKn3iMA8482Qg57Y1aDHZnVmjtI5X
	veAcu0xk=; b=lWPMRzJKN7HeQN4GQ9Yz/4pz4w969E38tEFl1zP14zflezs9Msm
	4edV9ueXMugDSUCINXZR8HUG6W+E2its8baroXIznW1fJUwoyOvfnC9+/3btywx5
	MvUvzGBoXtkK39klviLdHLYC/DotuLcwXIzFcXLTIrDkKzbuLX8iBAZKCz5dJOg7
	K8EqTw3rf6QSltXkbh4GHu9dKtvb/szRpirAr+y7EAhoDztkf+0XQn/TG6xUalpi
	U6NZA0kWBRvFnLVJET4fpggXX5PjmiuUe59IteBcAQqsiEcuZOM4CuABRzekGhTU
	sfKLGC5fVvQirTMx6fh3Wy7gq6h6hWup1Ww==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eafrm34pa-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2026 17:27:31 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-83536dc3be5so8646166b3a.1
        for <linux-scsi@vger.kernel.org>; Fri, 22 May 2026 10:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779470850; x=1780075650; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IwddrSzKn3iMA8482Qg57Y1aDHZnVmjtI5XveAcu0xk=;
        b=i3lOLQKvJ+18q8afQH1lHLkECobsMdOujRXEH0lfvm/i3ger7r/H0S7FFvMGFU3YhM
         VwrGGhsiquAjy/ko24QdJv2OJDoH+Nh/lS04KkoVI679tAihJOlp2hLKhReJ8m1dkpls
         uY7QRHvwsoPm/D20Q9KeYuHSgsx4xF9rOr90IX89D+Xq5VXvBqT4BG8CvU8Dgk9xsolP
         xA4sEeqzkCTlmHp5XOfFRrwe8AQzFTcNi7IUAgn8NyyI06Y5Bf2MTqu56H/zag0IdUra
         BrraxgtIbZYHdiFkIKAShs+v2zVLDwhQFHz1RL0YX15DKbK6Z+D22m0cdkdyFBplpEjm
         iGAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779470850; x=1780075650;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IwddrSzKn3iMA8482Qg57Y1aDHZnVmjtI5XveAcu0xk=;
        b=C66JvUrzvp3lHtdCapWsADWCLEOyM7SjKOwuKSrNXBdUoz4XsnyjBtyGI8TSSEYNab
         hH7qIUb+0HZg1Q/dovAHqUMxerB0KQyAPvHAm8tugCitynN7LABuz0HVZYlrL7es37zB
         gARVK8H4LHEHDIGkTrmI87D3Rj01Qw2SJ75np2Cz2F1gAvc6wuvpRO95xPrpWLnhun1L
         k/yLV8oKwWVK3bVadEIKt8DNB1yszRdY3tZG8Ptr+xNHFJMNvzFGha/UzDutzsidKfGc
         gSncKkGh1tpKOPf4qn7SHAq1JarysHSV2z0SgrpFCk+QysrUuucxsEnHLHhVHK5vKVp+
         0+4Q==
X-Forwarded-Encrypted: i=1; AFNElJ/H9f20eMFaZW+MoLDUGG3pt3kzf49j+eGaytAn4Rh4RXJ17AI3iZI5oFKneB2r6szsWXL7SFY12hGa@vger.kernel.org
X-Gm-Message-State: AOJu0YylsVXzuLCEOBsDckhnRH0ssbBbGWYy+QRngQ+IdmURDKO+6wTC
	JzuTxaSGQt/uLz60K0tNid8F2icVn3sH3XEZifXYGp+nczAKk4fdc4uuK9SGhzC6quj5Rgn3ulN
	CU8zeuOTcfwAggp/iqtxOihWei+3AJSIM+d4eyDzHRM+WmhVQ88iqf4YqHPHb/tU3per0NKfL
X-Gm-Gg: Acq92OGJerH4HxAhR9NtXIYi2neOXJkurXhqZq04BM1jR6kPCgr4/pRSXm3TwAPI5EP
	VwSrlcxW+fNjklHg8BcXj9roIXumT4EaGZ8+NZxauageFUZKP6g5ICuhgtOx1v3fAENTehFsDsE
	ZatcqtAEIQWNzj7KGa0VaT1y+5EptwUwhwSTwFQoC7PiMp59NklcevK3kpVIyLMYQG9POjJE1a9
	tFkn4AYyw6N7QHZxow0Pc4Gfu8pX0eLJzjM5Vmybq7/n2qVxscnKs6caTtNMdimILAeqgTZbhk+
	vofIPapH+DnvjOuLXsZA/oNhs+Z/eGHJtdrO7BMFAIGhg55ZYdrs+iOGw1u4MUvmdCODmPAS3Hi
	xkBY+HXEXohtNMtaJ2x+RT4NGCecPGTe6rVpNFq3QQ+QHxXRuSFoVHQ==
X-Received: by 2002:a05:6a00:2a09:b0:83e:c8f8:cec7 with SMTP id d2e1a72fcca58-8415f352254mr4810275b3a.35.1779470850005;
        Fri, 22 May 2026 10:27:30 -0700 (PDT)
X-Received: by 2002:a05:6a00:2a09:b0:83e:c8f8:cec7 with SMTP id d2e1a72fcca58-8415f352254mr4810241b3a.35.1779470849562;
        Fri, 22 May 2026 10:27:29 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84164ea09a9sm3045693b3a.31.2026.05.22.10.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 10:27:25 -0700 (PDT)
From: palash.kambar@oss.qualcomm.com
To: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, mani@kernel.org,
        alim.akhtar@samsung.com, bvanassche@acm.org, andersson@kernel.org,
        dmitry.baryshkov@oss.qualcomm.com, abel.vesa@oss.qualcomm.com,
        luca.weiss@fairphone.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Palash Kambar <palash.kambar@oss.qualcomm.com>
Subject: [PATCH V2 0/3] Add Hawi UFS PHY and Controller support
Date: Fri, 22 May 2026 22:57:13 +0530
Message-Id: <20260522172716.820490-1-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: SWyEKPWLY4g3pKan_lowFsQrNNbdDGom
X-Authority-Analysis: v=2.4 cv=Zekt8MVA c=1 sm=1 tr=0 ts=6a109203 cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=wRtOOnJjwWicnHpPwtUA:9 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDE3NCBTYWx0ZWRfX4uTxWu0eVBz8
 6tVqpGDdJ689m/E8RjnMjBHh1D0UtAMZbpSD3Dt+SffzmjPk3cxATZ7l7Hm+c9iNr51T1Zp+lbZ
 WPHq4DqwLJl0weylDOSHq/bc3DOZT5QyhYkud4xlQbehPqq/qBBpsVRao09YUG/R+rFIdI5JMgw
 oO2hatDcLu9SQ6BZlljercwobZ/MwMil5aL7YIMIcXVjt2Pxg+pAzbVlEmMzHmGhvp73bros2JH
 898ApVjLDBXExYmOwaiQ/WUHExbFFAqrejEqHy+CDSSugltv4Gl93JSsH+7JYwv8wh9g1Pj8ejp
 Lu3qo8BMCF+ZwWy+Wplp9vrXIwCsF6r89nX2DtO14vouTO0vrOceRDvS7HyqbIh0GTrvpPuQcWF
 icMvqDSnYsvNxtZWysjfdEQDbD9q9nKVfhFI/Ax/6e5Avo7WfXPWF8I/+1o86WyWIFRiMliPEe0
 wG//3RYd1piY5GrKZHQ==
X-Proofpoint-GUID: SWyEKPWLY4g3pKan_lowFsQrNNbdDGom
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-22_04,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605220174

From: Palash Kambar <palash.kambar@oss.qualcomm.com>

This series introduces devicetree binding documentation and PHY
initialization support required to enable UFS on this platform.

  1. Devicetree binding documentation for the QMP UFS PHY
     used on Qualcomm Hawi.
  2. Devicetree binding documentation for the UFS controller
     instance present on the Hawi platform.
  3. Initialization sequence tables and configuration required
     for the QMP UFS PHY on Hawi SoC.

---
changes from V1
1) Addressed Dmitry's comments to fix versioning for PCS and qserdes.
2) Addressed Mani's comments and fixed missed compatible string and
   binding name correction.

Palash Kambar (3):
  dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Add Hawi UFS PHY
    compatible
  scsi: ufs: qcom :dt-bindings: Document the Hawi UFS controller
  phy: qcom-qmp-ufs: Add UFS PHY support on Hawi

 .../phy/qcom,sc8280xp-qmp-ufs-phy.yaml        |   2 +
 .../bindings/ufs/qcom,sm8650-ufshc.yaml       |   2 +
 .../phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h    |  24 +++
 .../phy-qcom-qmp-qserdes-txrx-ufs-v8.h        |  37 +++++
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c       | 140 ++++++++++++++++++
 5 files changed, 205 insertions(+)
 create mode 100644 drivers/phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h
 create mode 100644 drivers/phy/qualcomm/phy-qcom-qmp-qserdes-txrx-ufs-v8.h

-- 
2.34.1

