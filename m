Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850C13F86E1
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 06:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791354597; cv=none; b=tQ1vwsTBmxdDR666ACsLheEoiecBF6FgJrsEh/Dzn6hz5s/7AOo2rbdRCRbrkKQE6hkYHdmTHUAMg4fk6xbJyFAPONpMq3rIFe8va1oETBIo3vxFz+Ztvkb9olZrPSGCAnZCe1IO1u9B0HWl9P8O0zeBNmt+0mzOACHCsJYirKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791354597; c=relaxed/simple;
	bh=dHA97+2+0JYIuKPe3in2smGgFvYwusOm38SwSWOCOKs=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=L0ujuwFRroTjMPnhm4QIVA4gu/SkVqbOVonWrq956i083znPbpHzIcDMeFDsJ0JoAq506ElfR4+mP7c86nIdR4w9dh+m3aK420N2ZGtLYcjUsaX9XXY0mlxPzMS7cL3zVyvx/yHKybAUevv85qNHdwxLPfAH664fQsulNXou4sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=g4ncJMTW; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AqHjzlsI; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="g4ncJMTW";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AqHjzlsI"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6974U9Dd3264005
	for <linux-scsi@vger.kernel.org>; Wed, 7 Oct 2026 06:29:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=bNj3YXbFi99+G0rbyhLVAh
	/fUq5/lgEJO3L7wMbr0g4=; b=g4ncJMTWdkdAK6nZ9qXiq0WkPNbyLGy1GBjcV2
	Zz4jEmdsWQtNF1/3phWlnjyQbqLBelkmX2JbB3hIPqs0njXE2F/3UEaErmA5TVSv
	6JPTEUeA+q282FKEwXsyF9ivc95ttX1qUIStsu4DjPEvAxsAgUMdiVvHKwwmeZDm
	YBk/R9TwZiLKBIo0WNKrAiGjh5DxcJ45OrCvO1E+oVvvGhwOPuP+MQlkdENYxPZI
	EPWNeaZ3wB4JKLXuniJMQ7xNtsbcOa/6oHCa4S0XLwR1awnI43F8CRjxb+9G3WKG
	WIcLc23OyOMzkYe38TqbOuYk1TmSU4Gs9rGwv8jjwEwjWTCQ==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5c608va9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 07 Oct 2026 06:29:55 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-39deb05ef51so3941797a91.3
        for <linux-scsi@vger.kernel.org>; Tue, 06 Oct 2026 23:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791354594; x=1791959394; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=bNj3YXbFi99+G0rbyhLVAh/fUq5/lgEJO3L7wMbr0g4=;
        b=AqHjzlsID3KXCf+a9ikY8K4rAIugIpVaXPhz6r+haUPQ/4aJ8L4fBs2d+QKBlP2uRI
         C2v2nMmVxjbhljO2WYdLpWMjR7OOkMXqlk7cQJxmjKtH5u8PZZFWtgTiOc2ydRbm08ov
         mFEVnZqQq97+KYbum1xDEpE8t35R3OL51QijYXOxVe9A3Lm314hZ2vYrRpkuTZkvNKwj
         XKNDKFY9ppu9WWHUacosuKhutUcz92MAZ4aRbprDBOMAwAVQQynNrJBZ2/Hg63If9H2p
         ofaXvqchLeGURX7avI1cNb34JyJPYXeeIb/Dn/X/doPHZjIwTF/LsrHf27KFis/FviLL
         y2pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791354594; x=1791959394;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=bNj3YXbFi99+G0rbyhLVAh/fUq5/lgEJO3L7wMbr0g4=;
        b=G9FQjj80EUqIG2DUC8xfe5QC0ILA0YcjKj13gHsAoCNTJ3SFrJMTexdgOwtFZRmfPv
         PLaZZIRr4jXabBf38KtfIQCl47Tt7V4L//E3qRbSGxW/V/V7TpeZT//NDD4DHtiwRzbv
         Kc4fsVPLSSRyvHJnCeOuRgC4CWufiwT+zwViWeCO7ChnFYBSTbVm4oeJJ6o75mZE/PeO
         wgNPmm3Qvn2DccMrWRM6JKvbqPvft6HFB+SkaEjH0W6MGFgN9sLoMKsWGzozM8FCMg5U
         5oEms25lrlY+51naVFhp2ZLZpoETC5GVQWRtkd5In60MRnLKtyksPqQfTDbEGVqMPT5x
         xyaw==
X-Forwarded-Encrypted: i=1; AKwUvBxM0F63AL6beQdTYuIBdAw5Tfx7fy5mtBirVCf4lL48x4i7cT9INgCrQRalBngfqWjdilzW64PQAJf6@vger.kernel.org
X-Gm-Message-State: AFq9FYL757Ji7/Ab0UEDV2YAeTUxZd0DvS9W+SBEI39zTys7Ghvqvwe9
	/XzobSTgjob7Jw1XiLImIy2X8XPHSfYTrkgk3tN1Y4UnGxOXSUwRdm7J2/g+H8jyqCUBokjH0xb
	H2jocBxLd4EFx+TUgatOGiQQRSRasHfJg/N/t5IJVb/nK28TvG9tQjTWkcjw5PLFl
X-Gm-Gg: AYBFou0KnUrgnkXZmzqw/3HwKZTSzgFM0pJBMElMiBH/4ztC0Pbg3M8BknM776LF42A
	9Mxu3AwN6GLHI7V40ujsYPXTo887asT/urhyNH6Lds5/IVWo+R9FIjRbf4H0anrT0mreruzKho2
	zeYqzJSTh+7uFhzIAnoA1fNFpHA08UPYh7D9//gfSEStTo1cWh75hN7nFVFH9TWjLlxNctFVU4j
	Ridmcs6LeQagHXv7VEOv7ibwkgQdsMMsujkjohbF+QAUVLkJ+FTgAoIE/DITThMvZKjYAtTmwiS
	j9e5TLkHMdemu+fd71fH2X6Up5H+hGf7HW8cFIRq/BfjIRRPHBaRrJ0xV/Fc9PLTgbDfcIKqbw+
	BTWlm14wyazHuSt55V45GgYOLkg==
X-Received: by 2002:a17:90b:4c4e:b0:3a8:181a:2bfc with SMTP id 98e67ed59e1d1-3a8a0a909d4mr1015438a91.14.1791354594299;
        Tue, 06 Oct 2026 23:29:54 -0700 (PDT)
X-Received: by 2002:a17:90b:4c4e:b0:3a8:181a:2bfc with SMTP id 98e67ed59e1d1-3a8a0a909d4mr1015409a91.14.1791354593862;
        Tue, 06 Oct 2026 23:29:53 -0700 (PDT)
Received: from [10.213.101.15] ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a89ab81bb0sm2972690a91.5.2026.10.06.23.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 23:29:53 -0700 (PDT)
From: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Subject: [PATCH v3 0/5] Add UFS support for Glymur Qualcomm SoC
Date: Wed, 07 Oct 2026 11:59:33 +0530
Message-Id: <20261007-glymur_ufs_qcb_enablement-v3-0-84cf4f861415@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAM3mxWoC/42NUQuCMBRG/4rsuYmbOltP/Y8ImeuqA525uZGI/
 71pD/UQ0cuF88E9Z0EWjAKLTtGCDHhl1aADpIcIyVboBrC6BUY0oSzhhOCmm3tnSlfbcpRVCVp
 UHfSgJ0xymomMFzlNKhT+7wZq9djdl+uLDYwuJKb32Co7DWbe+55s6z8pT3CCK17LHCgA5+I8W
 BuPTnRy6Ps4HLTJPf0UHn8JaRASxgivC0iZYF+E67o+AR+S4PwvAQAA
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
        gopikrishna.garmidi@oss.qualcomm.com, jagadeesh.kona@oss.qualcomm.com,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        Abel Vesa <abelvesa@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        sibi.sankar@oss.qualcomm.com, Taniya Das <taniya.das@oss.qualcomm.com>,
        Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791354585; l=1813;
 i=pradeep.pragallapati@oss.qualcomm.com; s=20260911;
 h=from:subject:message-id; bh=dHA97+2+0JYIuKPe3in2smGgFvYwusOm38SwSWOCOKs=;
 b=WAELjHwK1UTXE8rQO/ltsrny8yaRhLMj3rTn+kifBQ/U8fK7nPalJp3iQT03sglkoHfIzv1H0
 uTsfiZN9vDNBaeF3Auc2ySPiLYgznJ2RtxE17ViuALtys4AYnehLviZ
X-Developer-Key: i=pradeep.pragallapati@oss.qualcomm.com; a=ed25519;
 pk=uyRUsge8nQMwf3iW/e/o0U8z9nWLCMm1MGKxEftztic=
X-Proofpoint-ORIG-GUID: Fy52I04psopZ5YYooKXZvncns-9BZmHD
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDAyNSBTYWx0ZWRfX0xTVxiYubN4W
 +MMQdCkDmhxdcIG3WvT5gZnP6DE2uOtl9TPK7YSyQUvC4jNtJHTNSq/Zl6V5OpeAHNpJ/jG5/4+
 IOlPuH2k6ceIZXSm2Hgo+8kvJBkWsz0=
X-Authority-Analysis: v=2.4 cv=PM+aavqC c=1 sm=1 tr=0 ts=6ac5e6e3 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=bCOaQtj3lm0yH_HaZWYA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-GUID: Fy52I04psopZ5YYooKXZvncns-9BZmHD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDAyNSBTYWx0ZWRfX+7LWBb+V1iZB
 cIuYSz6ENcMn5guXK+11duGbHLCPn5SAT3mlm1NnC8TL16g3C6ZDoCTW859tKXgy3hJxzBJfo9q
 LCEXFRS/xnPsmYSx6WrEnkEqcaVSAUdw/mBp+DgNxSbhLtXk0qTvl6AhcvHpt240sm4r1RmEJ+m
 R3dDQfOcPyGyHnMrpbRGPD3N/wiZj5kTvctwvt36ImKWX3Kxc4JtUNnctUfh8dOGjNV6g6Tfp6j
 JsBl3/xB0ByTASlxy8sSruhFNdnDv6EGXuPLY+rL7XVZXZ8OzH0rrjrJ2XHJkJ5KkuCnG1xuSLE
 7ex/1OIth39bSCdiP4neBgGi+62ZVTWwenL2d+OGCL1h5Y0FbCZr7ET/kYAyZQdZCOtBeotJtEu
 wKb2RZ1QO7kBjnwCfFQrEiGezQT+tPUirBZqas9M+p9GeXvXUPqM0ODgAyeo+wI8FL9uSPwQd09
 COjp5Rad9Emph7Gzc8Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-07_02,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2610070025

This series adds the DT bindings, device tree support for the UFS PHY
and UFS Host Controller, along with the required PHY driver updates to
enable UFS support on the Glymur Qualcomm platform.

Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
---
Changes in v3:
- Rebased on top of latest linux-next(tag: next-20261006).
- Retained all RB-by and AB-by tags as is.
- Link to v2: https://lore.kernel.org/r/20260918-glymur_ufs_qcb_enablement-v2-0-16619f7e36a6@oss.qualcomm.com

Changes in v2:
- Added 201.5MHz OPP svs l1 entry [Konrad]
- Addressed minor cosmetic edits [Konrad]
- Sorted references label alphabetically [Konrad]
- Add RB-by for SoC dtsi & board dts [Abel]
- Add RB-by for phy driver changes [Abel]
- Add AB-by for phy driver changes [Konrad]
- Link to v1: https://lore.kernel.org/r/20260911-glymur_ufs_qcb_enablement-v1-0-b9fc5e2ee99a@oss.qualcomm.com

---
Pradeep P V K (5):
      dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Document Glymur QMP UFS PHY
      scsi: ufs: qcom: dt-bindings: Document Glymur UFS controller
      arm64: dts: qcom: glymur: Add UFS nodes
      arm64: dts: qcom: glymur-qcb: Enable UFS
      phy: qcom-qmp-ufs: Add Glymur support

 .../bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml    |   2 +
 .../devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml |   3 +
 arch/arm64/boot/dts/qcom/glymur-qcb.dts            |  18 +++
 arch/arm64/boot/dts/qcom/glymur.dtsi               | 125 ++++++++++++++++++++-
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c            |  99 ++++++++++++++++
 5 files changed, 244 insertions(+), 3 deletions(-)
---
base-commit: eea3fef32a9cf36abcb5975a5a594e4135a6b026
change-id: 20260911-glymur_ufs_qcb_enablement-1524a497520b

Best regards,
-- 
Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>

