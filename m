Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084E136DA00
	for <linux-scsi@vger.kernel.org>; Fri,  9 Oct 2026 10:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791542188; cv=none; b=SnkmifuZHIN1s+geXWT8QKQPhQbTQWp4opyuhQLhxKIEC5tWRUfvAelEsPKJ3STY4Ap8f5Fxb1bS/FkYRB/N0UGDJGR46vtbUO8zMzaJKcE5CMl90tHsvnTgpAqnd6TkaKRh7wA9K8r2wrBsrtMARUY2pZPmZxssIvGh9prwraM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791542188; c=relaxed/simple;
	bh=Yxi5c5piVGL5nj66cVK7xhnjJD3w3vB2CZvWuYrAivU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XIclGuTPHHV4VrROfbU6+agaaH+th0tbQUfYymkwNtRFyrbxl3TJC44dvtK37SjKab0aS1R3ibNc5qd2s/lBjUgVKGY0Ye+sSo/X5kookTF+YEOuxN5p5owLcFB7EK9C/m3ZbBU1U1SOcN4y5mmG66H0VuncLpLR8dsQv1E7eb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dlWos0kS; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BkUnC040; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dlWos0kS";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BkUnC040"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6998KOrJ1252507
	for <linux-scsi@vger.kernel.org>; Fri, 9 Oct 2026 10:36:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	JcqK3nQJsAx1QPTt7FvQEHKJzg6BbWDfOeS2ApKWAz0=; b=dlWos0kS/vAqciuz
	1fk2cKsi4pukeSW3VkhkJpz572AO7zgMljQN3TUplhtNiYdqJLyq6uHrisEv17rK
	wfV0qJ0nQG9wbSUutLnpYAz18M+k4H2plwUf50l4hA1S95MBhK51krwquahp4lyh
	NS4spaJcZJ9t3XyU0ZhpOXCA2d6RDLhc6j3wTLapQ6/9TPXK9dmHQLK093YtLJ45
	8zxeyd8sjcWZeXpJGYqS3fiRrWaOVh65R0uVXbMfYTdacZ9ugd37UJdX++jBTe2K
	3s8ZGJ9LOgjQi6O/p4eeeBX9fAneyos2fQs906qhrBLccKzG683eZGZiVAJlY+zY
	UauSQQ==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h6baj4b57-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 09 Oct 2026 10:36:26 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38ecc48b3c2so10967297a91.1
        for <linux-scsi@vger.kernel.org>; Fri, 09 Oct 2026 03:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791542185; x=1792146985; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JcqK3nQJsAx1QPTt7FvQEHKJzg6BbWDfOeS2ApKWAz0=;
        b=BkUnC040Z2tQsQJ2OnQkC0QD9R8dmOCOmBEMKUgNDYqMsFjlHc3vGT5LfOxnMosSwb
         ejj45x9gIV1lbPnXY9lTwMFB+PDxTailoxflp5FD5Pvtfoz2ZC6nqUApvoz3cBx9jc7R
         h3ZKkwfUGyJlHlaggeQuvWjvsxCop76dRePFY71iwrQ/GILl/AVeaA+xl13fhNjDu5mC
         LaP+WnDPTp7N1JdLd4FsHav+iS8ic0pqOyW6G0OY/S4Mx6vUJUeSOSApt5iOMEN5Rq6x
         RZWzdTGejcZEdXicrtd30iz18jI8CC6qRlPoDT/pIG1vYAZfOTwVk3QqWI8Tun2ndVgt
         Ywrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791542185; x=1792146985;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JcqK3nQJsAx1QPTt7FvQEHKJzg6BbWDfOeS2ApKWAz0=;
        b=r5y/zC+L8NXJB0Z2SX7t6/TMGEUJef2ucSzjo1gthH+D4zHwsP3Ur+scw44xR8Vqae
         YAG1OzULZ1tunL4OhUknTqKgUoPGxkLnTivpPJ6BoI/96EuSy1IJ1Rx+CQBHgBTt4Ii9
         Hz4qwgJoEafNVSgJET6Oh1sMEU/xFzGZ8cdUI3gWypFPzZEwuKZ8k2h7GbyGnLLsi2RO
         5B+JWwxxbLhtgxMFYh0KRoatdL1I7Yb0aiMGlxkVzdAqOOx+VRdGS3kiwXEL/QV+MKkf
         WHRm62NkhGswrOqzhoB/Y9O+e1jEwNlg6hMfFaqatBHExhjvp+eS8Rm2Lr31DqTdIik+
         qudQ==
X-Forwarded-Encrypted: i=1; AKwUvBwLfWTmHvtrk1Rf7rfbgEbc/oTT/9wGNpJERquLRzxzazXD70YHlIo1mUsoOdSQulDz8iaSjTA4oq6k@vger.kernel.org
X-Gm-Message-State: AFq9FYKIT2RGHJx1RV/N63Lyg81Vt65VdYGcRG5RLPnPhhNl7nd2wbID
	fGt9JfDNXkdZG9nezPCPvbo9o9qWKRCTT1FyH8S+I/VztOeCBRETVrIaCSxja6mzVcMVERu981n
	NWqEJrY5I861eWowPGobgsnbMZufbGCrkFdhov55iElQyD0BIe8QlgBmlveu2yj8D
X-Gm-Gg: AYBFou0UyGxttu70Vu+zWI1qsJ5wTE01roZgYsEEfuYeshtYXDLWDiInvP2kY85tniR
	n2PfaBK1fye7UuoEXFv+ZmlBdWf/6ctg5w+HnCUU6Y7j+98z5kIlylQGf0JSSJYv6TPyldDfu/J
	bo3UlF7wfRB/F8g/Sir7wjoGehGBTBb+THddgMov958FS0thUt6Y5xuD0nbi2vjHowa1oHeo5T7
	CvZBTwePxzm+VlPMeuN2YhBr87RlonabygX+ZkJpj1KWyESG5F6N8fSAjYsKtZIsrI3rKcZqyuh
	MZ3vw3tJUhIjnUhJur+tFLzRC6NtAr6xEvbDEHIMEdjRx6Kf5+3GpHpyfFRlxxwSdYfnCk25rjh
	cKJuQ04ykqszsYP8OUA541cpY
X-Received: by 2002:a17:90b:48d2:b0:3ab:413:49b1 with SMTP id 98e67ed59e1d1-3ab3a916118mr1239635a91.48.1791542185510;
        Fri, 09 Oct 2026 03:36:25 -0700 (PDT)
X-Received: by 2002:a17:90b:48d2:b0:3ab:413:49b1 with SMTP id 98e67ed59e1d1-3ab3a916118mr1239615a91.48.1791542185037;
        Fri, 09 Oct 2026 03:36:25 -0700 (PDT)
Received: from [10.213.101.15] ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab371c32cesm2827285a91.16.2026.10.09.03.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 03:36:24 -0700 (PDT)
From: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Date: Fri, 09 Oct 2026 16:05:53 +0530
Subject: [PATCH v4 1/5] dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy:
 Document Glymur QMP UFS PHY
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-glymur_ufs_qcb_enablement-v4-1-9a6ce83195b7@oss.qualcomm.com>
References: <20261009-glymur_ufs_qcb_enablement-v4-0-9a6ce83195b7@oss.qualcomm.com>
In-Reply-To: <20261009-glymur_ufs_qcb_enablement-v4-0-9a6ce83195b7@oss.qualcomm.com>
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
        Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791542167; l=1502;
 i=pradeep.pragallapati@oss.qualcomm.com; s=20260911;
 h=from:subject:message-id; bh=Yxi5c5piVGL5nj66cVK7xhnjJD3w3vB2CZvWuYrAivU=;
 b=j0jhMmEtJA+YqLldyS+bwxsUDp4NFZ743dNBsYchfU2n68dvRL+nxxDGysPoGUMV5R81MeaAB
 0+dBam3vK1vCLLNQesMKmuRJw1vgkgyq5SSJ77rx2lq1qfF5+wXGSWV
X-Developer-Key: i=pradeep.pragallapati@oss.qualcomm.com; a=ed25519;
 pk=uyRUsge8nQMwf3iW/e/o0U8z9nWLCMm1MGKxEftztic=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA5MDA0MiBTYWx0ZWRfX2I07armRLVgU
 7k+GVs8oEs1xevzBXYDjo3huw9MkuCgaI4wnmIU4YoWdKVGL3XrRkN9Bg2vPM7k6N3rbOANUoB3
 2IDHEaqskwxAFNY2G8VDvVQO7Hr/rWWy0+6B2qBCLg22JRp6oGfMkTyJWe+9KppM7dmpegihIOJ
 +EXnb1D3ezthJ/xeCfyH5uYtilTg/RmfRM+EolsobwW0Gux8ANdmiL8sNVCQBGkv9QuWdC4yktP
 7eh+B8Oax7gk5GaxPWoKw5e4J67by1CNrZlcEKRCo1vRND44XGfGJCW21zctS6AJkv+CgCJ4bag
 y2JmWSD9PVoNlS7+y3hSINuTN/WDgN655pE3bXIYOwsLFkfO7/01wRN+c4CsdYndrlyziW1Thrg
 6cLnKYivuLPLY0FUDD3hk+vSmwOKX5kZN0FgwdrmS+0Q8yoGDeMf96VKM7gi0ut3QXjkoeWBMmm
 Abw1wwjfY7MzDn5zUBA==
X-Proofpoint-GUID: I6IXpvVcr6mDumK_qkvXd7bCyHSagURI
X-Authority-Analysis: v=2.4 cv=H/dOUOYi c=1 sm=1 tr=0 ts=6ac8c3aa cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=M7MUb3q_Ox69Zn6kGXoA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-ORIG-GUID: I6IXpvVcr6mDumK_qkvXd7bCyHSagURI
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA5MDA0MiBTYWx0ZWRfXxW6Ll9aQWGMt
 8adeHjSJStOxOL+DArXE/GBhw4ekyzeXS3yrMaeiopLNcaDK6PLqVFH3a61+O60IIfetw17ZRle
 A3SPjTJ00SGdSVJvakQKc8nt/fX62a0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-09_03,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610020000
 definitions=main-2610090042

Document the QMP UFS PHY on Glymur SoC. Glymur does not have UFS PHY
gdsc power domain. So, document this in the binding.

Acked-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
index eb289c09906a..10435a0b5230 100644
--- a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
@@ -42,6 +42,7 @@ properties:
               - qcom,kaanapali-qmp-ufs-phy
           - const: qcom,sm8750-qmp-ufs-phy
       - enum:
+          - qcom,glymur-qmp-ufs-phy
           - qcom,hawi-qmp-ufs-phy
           - qcom,milos-qmp-ufs-phy
           - qcom,msm8996-qmp-ufs-phy
@@ -113,6 +114,7 @@ allOf:
         compatible:
           contains:
             enum:
+              - qcom,glymur-qmp-ufs-phy
               - qcom,hawi-qmp-ufs-phy
               - qcom,milos-qmp-ufs-phy
               - qcom,msm8998-qmp-ufs-phy
@@ -166,6 +168,7 @@ allOf:
         compatible:
           contains:
             enum:
+              - qcom,glymur-qmp-ufs-phy
               - qcom,msm8996-qmp-ufs-phy
               - qcom,msm8998-qmp-ufs-phy
     then:

-- 
2.34.1

