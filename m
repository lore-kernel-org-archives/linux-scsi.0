Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8353939D7
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 10:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776679479; cv=none; b=s+Fnba5EmYa/aZ9QZkQO9edSoi7f4PfWgux49IPZGsXMuEheuRWCk3CBgMMkUvaDVaOWmKT1tTqZmg0S/40z5M/nF2vByXUn7PZE96xMMlLhW6rtUw4RuSbV9i9ibHU5w1TdmItrFw2goWRHw7czToSkQbHQNX4vpaHvHoFe+d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776679479; c=relaxed/simple;
	bh=KqW4ho6y3A/FHoS7E1slFKZl/GqcfdvaciVSZoOmOiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UELsDssaOuNDv4O/DT3c+fK49XACvdKuYqQ2/tD/8bJuHRp6aAEYwWKgFT0fIFMq8CP6PKkcTHYwYjYK/wfzQnZTYLTO+yKR2M1IlAFPPwtm3zTpfFy5L3HpnhSJQcFccmCLJ5lWZ929iL4Gm+n7N/RfQPkJeIjq+AWwOGyPlh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=haxZqLW+; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EUxhLD1s; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="haxZqLW+";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EUxhLD1s"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63K97qp41599907
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 10:04:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=QmHOp54KgPu
	3xB4W0mKi44LzifYpPbFwkxhfR9KtlPY=; b=haxZqLW+tefYq4fy9gpFp51/eKh
	Pt1amrbYZP9erq6Bx1DGu16Ef9ig3Fb61JmVdJQo4KEM4RbgicZ/nj64aRyetJth
	d/UekbZnfuYxQSgWBCQEqnVyFQ2Qc1HanPJ8ltUdcyDe9NaBp2/m1GKMExbVW5dD
	NwgPxRJTQAtdOnMO1UwzSn7C9HDgopiZ/+nk+75g9pr4OsjUrFI5LILVvKqPOD5d
	mTaIbNBbnzoCgm1yNBu/tRkWzSCWxrrDEbUgthRqQ9d+jt7vgGmmpcCTpA6ymoRc
	W8kBgckJZsdtDFVzLdC5HFbz/dgiKZdWV+ccX/CK2RjmvWwf5/6j8ftyFFw==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dnh8986xs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 10:04:35 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-2c0ba59a830so4093790eec.0
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 03:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776679475; x=1777284275; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QmHOp54KgPu3xB4W0mKi44LzifYpPbFwkxhfR9KtlPY=;
        b=EUxhLD1sdNrjgz8T1bOCS/CLgRXMnQTMPKSxyumvts/7hec5Kxe02cuokbuIOrGv7z
         DYtJ6PLsfdooOtCFusbrY43WFcWOuCgWvF+T4t2tTErC5K7XPhCC9qgWJ46KS2dCesSe
         zOr0lfynhtn2Dvmqe+BY7GiykTd4h3TvFM5v8ZSTKfZNMGMwhBXvyFgZsJsaHeQu8nm8
         gz5tz1Tmi9LJeGZgLADmhdTEJIxEv0HdR5g2LlhD2QM3upyn3dXXPmyTNZ8bZk6vk/51
         0hclLf4qEKNN+VWcE3fWPn9Td1VHrAhkQhvjDtH8YPnSbOsycxMaERhu5zZgwivVFov/
         qPkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776679475; x=1777284275;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QmHOp54KgPu3xB4W0mKi44LzifYpPbFwkxhfR9KtlPY=;
        b=J88VZeNhgL4FsAsnbfzFb3pMVDTE8wW0f1n/tuIXRz7wIbfi7Mb/tp+y75ujpx68gt
         wp+TXUbaVVSYS76W/OJ0P5SWZZ7QB7AS0l6VdVgILLz7fGlrPmS75GEmyF3Kp92pyuMJ
         422ld7PO0BKZcOvg3o0PR+4l6AZwzWGP/2GzRl03V2Egeea51O0MHLy3EsSY/ts3N9Md
         MCx/RhD8Qx17bTIqxCG5/xOvc04O1h5zRZ5KdvWfyEIw6r9nQ5AO/Fq6Z6ssvfsFxym9
         XOMS/AX7/G/A5PNZoKgKWS/3JatD3UnaWC5Er4MlVxpZqr3TSxpxe7fnasZYKU0lGkN7
         8bgA==
X-Forwarded-Encrypted: i=1; AFNElJ8nwTGLYzA8J/C1wQDV6Knoe4iqBGR6vj+OMOuzuz8Xb1xKin9Wx8rSAcQG9kv2kgVox8TCsP+t9aJR@vger.kernel.org
X-Gm-Message-State: AOJu0YzirYCqB8DaypqK5hb1kmx+obNOyyqcsWjwrMLGpBju60/kwMaY
	ZKQSzdC4EaMySVnN0kOH+g95TdnFyuwvQxIvnyGMcP7T3EJ3VLHcoSnj+Av/AZsFrcBYGQgvYk+
	Q5tB9kn/H+NIOnRcSSCeWOz1TWbP0DvNAQeGwSCprAZjErKaLzaJgEvpvDYqpmQrP
X-Gm-Gg: AeBDietRBjZSqgavMO60y1arDvzk29NOH5uBpoIOARJCyeR33WR6TpmxfzMws8uWQNa
	qU/Vj3SVb0Pz782SCD2A9bRkM3S6Ixz71DOPz21trKhXaFmKKpL2o5YG2NbY17dzj/yXCBoaz+K
	vPAr39QIDnDQ8jKiOnUUYneMsSU6/9d1tY7VA+QbupagThRBKXYU/1EY7ZJidls81N26SkKKCtT
	/x/W89evc0q+NvmGjwNcwBgr6XQdMB+/CCg3qfIVMCtoc/jJ7mea0EGb1x+7e4x6f88LlMl9nWp
	C0spcAcUJqA9Z4froc7vf0K4Rd7+dTqZ1hi73V5k1sLcAN4J8cA79pvpsxQKxJ8JpfHlD+ui7sg
	MomhGG8KV+NZQIOcNfsw0Xescjlu6Zg+5Y2oIdbGWJEuVqeT2F0B5Iy0vQvqpG7xQzQwvUAf/BN
	L8g+u40ilVOHi1RlVp
X-Received: by 2002:a05:7300:641a:b0:2dd:6937:79d6 with SMTP id 5a478bee46e88-2e46c48a9cfmr4728310eec.7.1776679474631;
        Mon, 20 Apr 2026 03:04:34 -0700 (PDT)
X-Received: by 2002:a05:7300:641a:b0:2dd:6937:79d6 with SMTP id 5a478bee46e88-2e46c48a9cfmr4728287eec.7.1776679474072;
        Mon, 20 Apr 2026 03:04:34 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y.qualcomm.com (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2e53d2cfef3sm13076436eec.24.2026.04.20.03.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 03:04:33 -0700 (PDT)
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
Subject: [PATCH 1/2] scsi: ufs: dt-bindings: Add compatible for Nord UFS Host Controller
Date: Mon, 20 Apr 2026 18:04:15 +0800
Message-ID: <20260420100416.1252983-2-shengchao.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260420100416.1252983-1-shengchao.guo@oss.qualcomm.com>
References: <20260420100416.1252983-1-shengchao.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIwMDA5NyBTYWx0ZWRfX91GPGCWbf/YG
 cMKtAYzDhFemQgzMxMjh4K61yDQzumfU1kXt7rY0oBkwJCXNkU+fOFB5apzYZ/0wkRKIOJ5OFNK
 d4Uc2GiVyELfgF4FEEFEYl0ThVyu40jSP7zmVpKsWnSDMSAVCDXbULDYeGa/ViALwsDx7SatfHl
 hIvLQAXw82mYOZajTeIGFu9/iweUl9zCnBWbqKV8EBwnUM1s36uoT12MX0aV7j70130AMyFIpLT
 TbSSQEtOlm8e9TulIEtdBIu4H6a25WiUfhNP77p2GKivLuDqU3QswX62YmHxg4YhhStlfDtBBJp
 0XVT4s2oJ5+88q/Fxk3KitvTkrcX5kzsXL0OtDiO5k7AcB/2vtDJLnFsBjT8VrCKHDC7wBckDlC
 guTIVJAjW/quTuWfsWrHHsprp4ZVNmDCNLGa5XWafrbds3vmazL+9oxwhGMq2MX1a1kr+xm/Mjp
 v9zOxhCrZ3UczJ8YPIg==
X-Authority-Analysis: v=2.4 cv=D6B37PRj c=1 sm=1 tr=0 ts=69e5fa33 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=EUspDBNiAAAA:8
 a=o674AwMwzFixoRFAmicA:9 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-ORIG-GUID: Pu7nZjnmGKqboDays_zs90FiqIi_zr-n
X-Proofpoint-GUID: Pu7nZjnmGKqboDays_zs90FiqIi_zr-n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_02,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 phishscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604200097

Document UFS Host Controller on Qualcomm Nord SoC.  Like the Eliza SoC,
Nord has a multi-queue command (MCQ) register range in addition to
the standard one, making both reg entries required.

Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
index f28641c6e68f..900d93b675cd 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
@@ -17,6 +17,7 @@ select:
         enum:
           - qcom,eliza-ufshc
           - qcom,kaanapali-ufshc
+          - qcom,nord-ufshc
           - qcom,sm8650-ufshc
           - qcom,sm8750-ufshc
   required:
@@ -28,6 +29,7 @@ properties:
       - enum:
           - qcom,eliza-ufshc
           - qcom,kaanapali-ufshc
+          - qcom,nord-ufshc
           - qcom,sm8650-ufshc
           - qcom,sm8750-ufshc
       - const: qcom,ufshc
@@ -74,6 +76,7 @@ allOf:
           contains:
             enum:
               - qcom,eliza-ufshc
+              - qcom,nord-ufshc
     then:
       properties:
         reg:
-- 
2.43.0

