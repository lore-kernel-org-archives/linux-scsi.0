Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEDE4A43E7
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 16:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789145249; cv=none; b=CBp0uvk1dmbv1OAHdYYGUfhkSMh5Dt+WRfvuycqa5HPsLUKfvXGRwnGjdI410T007n1EGkO96Ob8SuonVwf2EtqR2Gz/vyqYvyhPE83pU+eb+YmaAWnD58yTtRY4C5tbcrMuCPMGumQTSujwWhtzLMEnrgOjf/hUMDW1gNvLqMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789145249; c=relaxed/simple;
	bh=bJGsImACvT9xM12juJhgFEgiAuk2ivW2Mi7AoKZyfZg=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=NE+0XWvFZiZSZzCZPmsIzl5cvZ3x6eDAOyGiUFASPhC+D94uYa0M+/0DOp0mpAfYuNfIPbH0xUNvEdPjsSXZgO5LxegU6vJ6EtqBDQKG7Nwg/C5dHqUqAZHut4G3e/5tnC/sRljtpN4sdYDbiO46+tm5oFrch9/3DEyJlZEZa70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=M2Pyuk39; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=G1TwiMSb; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="M2Pyuk39";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="G1TwiMSb"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68BFfgQr921130
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 16:47:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=zFWiaD82+LLEv+4Y9AJ0DX
	fzOC3GSd+sVzZ7Y6z32BM=; b=M2Pyuk39KtAEXKzA2rad6d8Rh5FP1aKqeYiCnH
	71rBlUozstcPj8RV63jHyw4M823w8F2u4yASW+T9hgOpmkiXmkfee1HvDxH8Lytg
	Inm9cUQE98qNLpNcEJ5pTnW0ntgYRpkidUO6QROj9RuzepB+9/HtePcyGg5Ln4pw
	xFF0vxfideoLigoWAhwCZdGb+SA6KLgoSOThjMuIvq4nN+HV0Lu5j+xpRzr4U4qv
	R018axdb6fJ8kCTLbXODMRE5+LApKAT0fB0wV+v5mMVUyLSoeIrcUby4Wzr7skb3
	Ly5XWWUl6zAfPuxJM2Ufq2AX+Tt7c3D3ss20hWhx1SmM8aKg==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gmmgv08ta-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 16:47:24 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-39db5b5f98bso230325a91.2
        for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 09:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789145244; x=1789750044; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=zFWiaD82+LLEv+4Y9AJ0DXfzOC3GSd+sVzZ7Y6z32BM=;
        b=G1TwiMSbf4+cynYxM5cMF0R4zuaCOjFCVsB6JqUtNSCryXFCaGkgd24vpEfCV2VBpE
         lLyt7W9zRM5a8bzv6G+GjoWNhFADn461shhGTTu0FCN1oAlNoG7T2MvvJAMFq5NzZJ+X
         zBnStbItHRP7wdMBSsUsVC0wPAJ1Wy4WyC2QYNjvCFjOGHUoIAmHdy7h9BTE80VyoG+p
         GVwMwBcsJObedjZLCAZQSgik63aaF3q0WispHihq0hOJP9kHUi7Rcb6dDyKO6QnXnrJJ
         h9cMAUpZsgGXUIg9PgPQl8DzjNGM+b9HwRBvLUaVKH6eG5wdaYVrXnh26tgbXkUcXFN6
         QC7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789145244; x=1789750044;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=zFWiaD82+LLEv+4Y9AJ0DXfzOC3GSd+sVzZ7Y6z32BM=;
        b=Q5tgh+Qq2E5KjF4haGQdbjnucdyljbTFydQx0lu7coiV0yLzBQ8NLM+lmVbSmf7wKs
         iGWUi4MS4sskVU5I+mvjwA/cDmZvL5oeQG00Ec9bb6jP08JfwNw9qI1nIRzSdf02L3xJ
         vaeWiC2N8Gk9GuL11RerTGE4uc9wW6BdMq8n/gA01gKetCSxMONPEyOgHhC6MyTjtO6e
         i/hc5JWHtcmmNhbjIkGSKUcW0jTPnx0LbPmWNvQb3DXH+n8Kye/+tUf//V28SfhRVGXh
         iVSYZtrWPJjYDjazlb3uq7VGLZs9cOXhaNeUFZX0TkbhmPFs2N7rGbhop0j0UTkGcy2U
         ZNKA==
X-Forwarded-Encrypted: i=1; AKwUvBzvYRZw8eCbUFWYPMFBPsPPZvFoXRtQOictsTvG1Jdf3FtUohXNG4USMyO9lsS8z6+dxXqh0ITydev/@vger.kernel.org
X-Gm-Message-State: AFuF++no6a4+3b4+mphcWqk0DdQXfVTk143JJ/NeVI2/PSfkY1Qxc2ee
	Z3H+J/EdQwe4xHdvFRqwrqkD2CzVjcmlaujG6IEd9NVqRTLzixHFkfCMv/1wCOMdgT2SuWbTMe+
	1eTMBms1WttbQG6uD3Jm9/yO+UJ20IxXZiAVJ0Fdf1dNyvlhTWxJyD+TLuESSBjNoaQdFk1iR
X-Gm-Gg: AYBFou2Vxs2kk3cCBJkbhZVWRv0JIWgfAenGxpwR2c9iy+b3th89G7lIRDCoxPqvcwW
	PnTjkB65+HcqD2HYe8YkUuCPPZTDptStaKdtgVqWyU6Fh4zBPFmfXX7GYDl2FJKSZBjLreZb6TD
	r1dkVp25Q5MwtDgXdGy13D/pmnTyXzcL6NRKgWJZktHfjH8aBiNNlNCNSWPuTbOFHs7pqaKJ9Ai
	YSUA14ULpZlCPXPpRbz0nal0wNXsNhF0Aye2C8duDgcq5ztzK4AmB+pQUApYRVrXQfXxYNm0XpZ
	rdsUnmUaSJU2stXDwzJDDnzHvBGDXnxVgZzs66G1p53rjbHUokmbIF5GFOhL99Lt6yfEohi2uev
	74UlJB+95As8pkckAqWgZmFCy6Q==
X-Received: by 2002:a17:90b:1f8e:b0:39b:2b5a:8dc5 with SMTP id 98e67ed59e1d1-39d9bd987a6mr8508359a91.6.1789145243617;
        Fri, 11 Sep 2026 09:47:23 -0700 (PDT)
X-Received: by 2002:a17:90b:1f8e:b0:39b:2b5a:8dc5 with SMTP id 98e67ed59e1d1-39d9bd987a6mr8508313a91.6.1789145243180;
        Fri, 11 Sep 2026 09:47:23 -0700 (PDT)
Received: from [10.213.101.15] ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39da64d4bdfsm944193a91.0.2026.09.11.09.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 09:47:22 -0700 (PDT)
From: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Subject: [PATCH 0/5] Add UFS support for Glymur Qualcomm SoC
Date: Fri, 11 Sep 2026 22:17:04 +0530
Message-Id: <20260911-glymur_ufs_qcb_enablement-v1-0-b9fc5e2ee99a@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIgwpGoC/02OXW7DIBCEr2LxXCRYL7j4KlVk8bOkqLaTgG01i
 nL3kDpq+7azmvlmbqxQTlRY39xYpi2VdJqrkG8N8592PhJPoWoGArQwUvLjeJ3WPKyxDBfvBpq
 tG2mieeFSAVo0nQLhWM2fM8X0/cP+OOw602WtFcv+/Gvom50v8MXnlc/9+MV3S+FKgUZSRpO2/
 SbZ/32vdPe7jtdlXBIEcN7INoZ+a58JZwtxf5qmtPRNBBedb5VCb7WRBt9RtKIDg4DOBKLnFQD
 Z4X5/AHsXhpAnAQAA
X-Change-ID: 20260911-glymur_ufs_qcb_enablement-1524a497520b
To: Vinod Koul <vkoul@kernel.org>, Neil Armstrong <neil.armstrong@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@sandisk.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        gopikrishna.garmidi@oss.qualcomm.com, jagadeesh.kona@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        sibi.sankar@oss.qualcomm.com, Taniya Das <taniya.das@oss.qualcomm.com>,
        Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789145236; l=2110;
 i=pradeep.pragallapati@oss.qualcomm.com; s=20260911;
 h=from:subject:message-id; bh=bJGsImACvT9xM12juJhgFEgiAuk2ivW2Mi7AoKZyfZg=;
 b=9lAVJWvM3G+ZFTJ4H36ve2HVhPJYTkVEvGF/7ChP/40cX7VIcizqD1Mv0hcnhj3AZgC02UQUU
 rIIGBkxBShdDcRoPiq97ZoDIZv2Hjq3C1K5sezm29WdGXtxOmEYLq0c
X-Developer-Key: i=pradeep.pragallapati@oss.qualcomm.com; a=ed25519;
 pk=uyRUsge8nQMwf3iW/e/o0U8z9nWLCMm1MGKxEftztic=
X-Proofpoint-GUID: F1mQqVVa5sJBh31qiUbMqmREt7SMxxcS
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDIzNCBTYWx0ZWRfX6U6CacPKy0D8
 u0/X7OP0zlvIMQpJq8UoBtnfecBdx2xigs7vYbx5NXfwOyhOERrp7NMv7PG/UGU28xva6noOwwC
 GfS0xV6RW5d6p70sligeCuChKNuiUb0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDIzNCBTYWx0ZWRfXz5mXDuzXOt76
 srP7LbvocRpsnPdGLN1vbCj3rPNadd/gtckxBZjrvqaps7BstEG6nQeBOLwjI11+JYhtxHzShOZ
 eSdwkFhEsv7TqvUNzleW8aR4Z6EqXrEasOqaJtVh3dAbSxG5EgdAfp2FkYPzAor2tlklbeXJfRY
 +a4qbL89W0lPR8IlShxG/+1qOE2zXz1Mzqe+/H0XWFV+Cq0+Lxf0d84TNRjfOZiyTby906NGax8
 aN9QlqYJisKt6rlABwG+rsyZ6OsEh8h1nc1j5vPBHmRJFr9+lpcDA4/epp1kF+mB+Z9elcD2w6a
 uS3oPg3Bs7TG2BEzofab8rCSPWUyFZqXHPnE1VelOH5VRA75r3qKUXJb/T66ASSULWD5LFHdfEF
 CRAjHyckDVBoJL23kcAbQM9y3UomuvWefB444eH/yKVjUkQxH5TKvI+AqTqyhga4P72TUT/FsuR
 82bhwObJxHvavsfvLiA==
X-Proofpoint-ORIG-GUID: F1mQqVVa5sJBh31qiUbMqmREt7SMxxcS
X-Authority-Analysis: v=2.4 cv=EfFd0/mC c=1 sm=1 tr=0 ts=6aa4309c cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=Cnq2yzGENyK2wpwfoncA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_05,2026-09-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 phishscore=0 spamscore=0 clxscore=1011
 impostorscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110234

This series adds the DT bindings, device tree support for the UFS PHY
and UFS Host Controller, along with the required PHY driver updates to
enable UFS support on the Glymur Qualcomm platform.

This series depends on Glymur LNBB clocks[1] and Glymur QCB platform[2]
series.

[1]: https://lore.kernel.org/all/20260905-glymur-ufs-clk-changes-v1-0-cdff2c67a8c2@oss.qualcomm.com/
[2]: https://lore.kernel.org/all/20260908-glymur-qcb-v3-0-c194c0219218@oss.qualcomm.com/

Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
---
Pradeep P V K (5):
      dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Document Glymur QMP UFS PHY
      scsi: ufs: qcom: dt-bindings: Document Glymur UFS controller
      arm64: dts: qcom: glymur: Add UFS nodes
      arm64: dts: qcom: glymur-qcb: Enable UFS
      phy: qcom-qmp-ufs: Add Glymur support

 .../bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml    |   2 +
 .../devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml |   3 +
 arch/arm64/boot/dts/qcom/glymur-qcb.dts            |  18 ++++
 arch/arm64/boot/dts/qcom/glymur.dtsi               | 114 ++++++++++++++++++++-
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c            |  99 ++++++++++++++++++
 5 files changed, 233 insertions(+), 3 deletions(-)
---
base-commit: f2bfbc3554ca6919484030729424b9dee2942d24
change-id: 20260911-glymur_ufs_qcb_enablement-1524a497520b
prerequisite-change-id: 20260904-glymur-ufs-clk-changes-55264e596e6a:v1
prerequisite-patch-id: 934a81749f6e977edb9214104fe2bbf4c7758663
prerequisite-patch-id: d4215d48878aac66f72ef5b6c74d81d1163a596e
prerequisite-patch-id: 28be2089f7836210401b8a68c7cc0ca90d63c375
prerequisite-patch-id: cdf227f5515ad8faec49bde5e0475755a961100f
prerequisite-change-id: 20260711-glymur-qcb-1e2d2bc913fd:v3
prerequisite-patch-id: 53dfb255c51efb63dd26fae3cb30307f0d175ac2
prerequisite-patch-id: 7fa1b965056eaf3b90ce81a537d28c5a2adc73fa
prerequisite-patch-id: 96b042ef08bba0e028c86ea2a473d996880ab38e
prerequisite-patch-id: d2f390b67a2ec320db1e725f4b84b500f1f0400c

Best regards,
-- 
Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>

