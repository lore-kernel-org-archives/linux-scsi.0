Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA36310645
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 16:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789145262; cv=none; b=TkkHRjLvwAQME1we5vC4KXagMvQr2IRitNueVQalTIyUvzLWp0ASs51HwPFnK15xElU0obR0tQqBahVSIfwVepOfE3b0i3Up13cIOtiRpkormAqZ4j4xMu+1OfRJzTMaCMo+HIefS2P0wtmGqOrP7UaCSF8UTpdCU9U8qd5iMrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789145262; c=relaxed/simple;
	bh=nVeQof90N9/+rn0tz6Y5h6juwjIaGy0PYkqqWpXw4xY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HEXL0KpgoJ3fOpR24s45fdx3wyI6S7sUvHGxh3XFIFckYycOFlyMdr7RrHcQfjsrZ1l0/Yl9ZOip7pAytQNhabUPNjyffgVTtEc8i9lwDV/Us156wDqllVaHF7kCyVm7+AQp9DUJ9cN1spU+oDzDgWeJyyh3WHHWXKMJ05Ejehk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Gyn0CnJT; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=UAX8ChM+; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Gyn0CnJT";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="UAX8ChM+"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68BEmEea3780627
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 16:47:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	kRRf0K4n/OMGCKpZc2soc2B/PhOw76TarQ44+SpuGLw=; b=Gyn0CnJTq1DkJPqn
	Y51z7WA82r1rUVVjSw+LbPwKv5TyYcKkz/ER8mU91MT7X4QxRMV+s7DCpuZk2b5m
	52QXOrlDZyhUTlPPjDcYryL3lD2lXgYqecTh9a2y3mHAJVNvS4SrAP44gYjnYfLA
	c8i26qWnODbnPajTBDqIWpuY9iWqF/BtbyOa390A4C9PZLSXxo5PatM20nEESppu
	dyk61MmDwWXHDOQ0rN3CkTsjunKzvx7+EOwpjhX8CH9M8NPstxOc0BSvqKrEuLWm
	QauT8eHDU1bbtXYDjt1E42OGUxlfryvWXEznHF4qqpcUsBxT+Cpxfgyf0V5m1Ezx
	vav+Ig==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gmcgfjh3g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 16:47:38 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-39b77130a7fso1864048a91.2
        for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 09:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789145257; x=1789750057; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kRRf0K4n/OMGCKpZc2soc2B/PhOw76TarQ44+SpuGLw=;
        b=UAX8ChM+CmdkO3cSxc53ufR7ipCje3IUvzz1YsppVz5/9Staiy61DPLBnjThSf3VKs
         U2sxThZOF4qt0PXDpKBbN8rcELYUxXLJNj772PxywUbenbHJvWJvz0PSXVt6TflPOzsw
         vqZcNtqgqAL/+1ijU3AnnqwNxrI8a/tdfJinU8GkZigVsCOTf+1vQmx/7IiMiL9uPK94
         cDWYyhXBe3lr/N4tUrmdgpBcewrjWcwVKAFXXGjCLWmjuz+hWfSGnj4rLgUQ0niGF5Nk
         bBlLvVyL051ssRJbHGPQrpa3nS09VjrR6ebUXC1AE54W4/favOndMTIvECPsIsks19Z6
         tJmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789145257; x=1789750057;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kRRf0K4n/OMGCKpZc2soc2B/PhOw76TarQ44+SpuGLw=;
        b=ENKgIEAguCw82pmGSMvWiaEV/mEpQ2WWSBxcmlGuC3R3odZf114OgaClrv4V0ihREH
         qPHYhBsIah/mCQOeAPKnl34sk3RVdzES5JkxF4sB8mpYC5/W3ufGbmqBy1bNkvZYLmY1
         5Qndlvsxdo75WtL10f9VFdTxdqLPyZrPutfmLVXalLR5ZoRmLhY+LyoDST8jjrltKRtm
         d/C7cCFrtopHCR3mFsxrrVC0J2rcDm1e3Pd5PnHufeY5SlLRus7SIkvHO2jXY6CFi0L1
         ki8txExMHmCsMbgiahqbS27BQ2MyDIlS4TS2ZzRE9zDNf2ld9SqFezqVpw+OASTbrkji
         5tqg==
X-Forwarded-Encrypted: i=1; AKwUvBz9YDqqpY43wjAu9Tso+L3LjpHZ5RU3EGucrhCBhQ81NeGbIky1jQnBWugd3lv/fKjtc4ejjgsEEgZR@vger.kernel.org
X-Gm-Message-State: AFuF++kRR7IPu6SKZ6SnNOMfAEV0MLg4CoD34eCyLGA7Y429bQ0K0gQa
	Se99FXfcq68m2RFYzyaJlQwAK/G8zeJGX5eVcwQDxAjxa6tmMLjKASMovJ5d77sQI4FVPddmjrF
	Pwm/ylsU8P3RkQBd5MnchM713ONpZnaAIiGq/qv77yToDkAffSQ/r7rqDIa11/lgZ
X-Gm-Gg: AYBFou3pQiv5VWG8259OFVkQjcA8H2yDFgKDi5PbckC1newWS6vCBDBOlup+dOd5w8D
	q86HVETRzFrfNUTw4tZ/Wz3YN2jg9Vp3LboZWaysclpPNp7cSMDQMCVuC5F8FahlqIOrw28KZv3
	0xTc2uDbA2N96MMlRvtyRsf1smZuk8ko5FB+YXpTNQlhJWTK1/Mw4KXZFDiTKxeXVw29sjfLsWk
	UM1FZBQcLhgTCzqKPcQYeAMdkA++oFaTMU5J2QI/ZDNo5TQhoec8h/AO1TE+LuyUfDTQHwoo6G8
	iwupyYc7ALbs7W18aUH4P+rbhf8IYq2hiHYrT4zOcSAXNlcqer6YBucpeLWhsUTHU4OltP+DM6Q
	i34lSIeiieUvf3i2S5wU8a0CZyA==
X-Received: by 2002:a17:90b:5287:b0:398:9bd5:490d with SMTP id 98e67ed59e1d1-39d9c22e224mr8967291a91.20.1789145257302;
        Fri, 11 Sep 2026 09:47:37 -0700 (PDT)
X-Received: by 2002:a17:90b:5287:b0:398:9bd5:490d with SMTP id 98e67ed59e1d1-39d9c22e224mr8967200a91.20.1789145256741;
        Fri, 11 Sep 2026 09:47:36 -0700 (PDT)
Received: from [10.213.101.15] ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39da64d4bdfsm944193a91.0.2026.09.11.09.47.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 09:47:36 -0700 (PDT)
From: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Date: Fri, 11 Sep 2026 22:17:06 +0530
Subject: [PATCH 2/5] scsi: ufs: qcom: dt-bindings: Document Glymur UFS
 controller
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-glymur_ufs_qcb_enablement-v1-2-b9fc5e2ee99a@oss.qualcomm.com>
References: <20260911-glymur_ufs_qcb_enablement-v1-0-b9fc5e2ee99a@oss.qualcomm.com>
In-Reply-To: <20260911-glymur_ufs_qcb_enablement-v1-0-b9fc5e2ee99a@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789145236; l=1348;
 i=pradeep.pragallapati@oss.qualcomm.com; s=20260911;
 h=from:subject:message-id; bh=nVeQof90N9/+rn0tz6Y5h6juwjIaGy0PYkqqWpXw4xY=;
 b=QnYHneeV9+kW1ROf5mDkfh/qHaTMW+7cpvw79FXnUfjg6WKLDqWbGEfXyTQNv5/QalqHBFloi
 lnGigFGogtsBtUzK4jB2uGc/GQkzYdQRUUoXpZmvhohD6OrAMiuqxv9
X-Developer-Key: i=pradeep.pragallapati@oss.qualcomm.com; a=ed25519;
 pk=uyRUsge8nQMwf3iW/e/o0U8z9nWLCMm1MGKxEftztic=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDIzNCBTYWx0ZWRfXy8l2vDhG3qCQ
 SbA6x5HSmYXkKyDPHWF+OSSVFyXKFRxHdvK6JNOllvXMOIB3tdJ7IsMjmjln8MxXvCWberQnTta
 Qlf16aLR4zLzmF7M51jcWrZiF9wqD1DTO9zEyN85tubNOKHgYxQ4w0HUK69Jlq8PmrJc7u/sid7
 NcGUr5hrs8mC7K3YnHut/99ZA3PLQ1ZgqZqqd/7baHvfgEYPsWdu617NTRLZ0H+PkaY36fDIZC8
 vvyvU1M5cfhKq2ebck4EPAbMmu9MdOsEDCN8vHwnNfKtDmuVzFdgFi7/oJtDaFhcbCj+4nSx8BC
 ZeBVkLn8vRAWVmAalIQ6MiROxwkyO4sopvWhdUXA1p2/4IYGwnONDKUR51VYZLo3tDkxZTf3ulI
 KquoLxUBNoWB/LBPe5khx4cEbNaJHtHshtl8bLCwaY+zu0gCvwUlqUlEMPF1IF9YFUgqrGKulxm
 ZlV3tXJagrOAq/S57gQ==
X-Proofpoint-GUID: ODQ4Wq0kzMdF4MQpvMa_Ob4nVapNKtTv
X-Proofpoint-ORIG-GUID: ODQ4Wq0kzMdF4MQpvMa_Ob4nVapNKtTv
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDIzNCBTYWx0ZWRfXznFzJUrRXXyi
 5UierI+wCxiLV9ky//FCDOORalm+z1yMTPjvR3Pgcok6Et5NdRvYLl6j2HY4cBXJ2idDAlyfJ5m
 7kEz2TpcFDu2BtchDV7cT2M7M3VN3z0=
X-Authority-Analysis: v=2.4 cv=ULtIjyfy c=1 sm=1 tr=0 ts=6aa430aa cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=Fvqz0uoX0QqgC4h9zMkA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_05,2026-09-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 phishscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 suspectscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110234

Document UFS Host Controller on Glymur SoC. Glymur UFSHC has a
multi-queue command (MCQ) register range in addition to the standard
one. So, both reg entries are required.

Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
index d03295806657..f132b1a9ebc2 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
@@ -16,6 +16,7 @@ select:
       contains:
         enum:
           - qcom,eliza-ufshc
+          - qcom,glymur-ufshc
           - qcom,hawi-ufshc
           - qcom,kaanapali-ufshc
           - qcom,maili-ufshc
@@ -30,6 +31,7 @@ properties:
     items:
       - enum:
           - qcom,eliza-ufshc
+          - qcom,glymur-ufshc
           - qcom,hawi-ufshc
           - qcom,kaanapali-ufshc
           - qcom,maili-ufshc
@@ -80,6 +82,7 @@ allOf:
           contains:
             enum:
               - qcom,eliza-ufshc
+              - qcom,glymur-ufshc
               - qcom,maili-ufshc
               - qcom,nord-ufshc
     then:

-- 
2.34.1

