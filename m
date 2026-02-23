Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39487298CBE
	for <linux-scsi@vger.kernel.org>; Mon, 23 Feb 2026 14:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771857173; cv=none; b=hO3AnJrV7XAJuhrTK2Rfvae0GaF4ezF/IlryIIYLFR3Rq2ZXbMUl6lLYHUHXQAGXYrddJVSrHkTDNvBWNuhoRqNduimcG1DrEsmk72fsScBJFEU5AaR7piIWC6YR0Nzz1vH8dflrJIpGUAqCEUI9mJdDa+JeUqd0UUzFC+UBxug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771857173; c=relaxed/simple;
	bh=0xzDlC7N2Li2FtS8eDJ8PuGX0sJY8k9tUPeI83XobVQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=J/zGST4P+dLr41kv1/48kiiLF/ejgKUdZe2JcLHK13GHcRQcAObFXXqlYBMwfibiWksCj2lkyPyyNHkcvWuVE/HOsLKjgsAm7YsH9mLr8ZkhOOdgado3bcJRF4T1+BVmV+uTQ9g5uXp75+oKruEtEIfBgon+khVMgcvJ8t+S40w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=epqD4SEV; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gg/t3ddz; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="epqD4SEV";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gg/t3ddz"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61NAYRIA3409194
	for <linux-scsi@vger.kernel.org>; Mon, 23 Feb 2026 14:32:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=tmBlSydX8knIZXyl0Pvuba
	2NBQKTZ/5ssunahHjCvwg=; b=epqD4SEV+phP27q0p5NYRuMIxmEmAasi9l1PEL
	CwuwSnM75ttuchtcKbEX9bDOYr9atk66lzilgHfya/guQmcChXA/j0JIFO8f+h6B
	gsLQ1Wl0KgpLd25BUAu8HJorZLnk1CR1zWk3YQsAT6zqUGb7D97usTAMY2AuiC3y
	qkRDft2Rtbc06QccpnsVK4DwfHtLx9GszaLPLflhdqk4YgO9dcvZN6qoa+ppGPzh
	OxDGc89432jZ5/a5y7J5QQ0UzzAtX9ciLlbATI/hsak2qaakcT8t/6d7cv6P8VrF
	ADuXQgXo1GSeY/JmzR7pITbMcGxnrz2YqHRctMK/4B8kFa3w==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cgn8trmyk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 23 Feb 2026 14:32:51 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8c71655aa11so6754809785a.3
        for <linux-scsi@vger.kernel.org>; Mon, 23 Feb 2026 06:32:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771857170; x=1772461970; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tmBlSydX8knIZXyl0Pvuba2NBQKTZ/5ssunahHjCvwg=;
        b=gg/t3ddz6RQIbAiQ+YPXFbMBpuqbgrlpLsjPaxOMpAvMK9FJQ/IyYZ7Bu1+J7TJBqm
         GIS5eQBRUV9IxeCX0HG+Alcu11BxM4Rft0lYTlEPNUvhK1rqdOGj9I/0gB/KoP61Bqu6
         pr3z706iLvVELut0wOh/dYeI7v0XtZZlJ7yCEAXBlltZq/kX0yGsYv+z5t286yLZAHNw
         kShZkjY29EZp3jZfNBgZeFT7QGyYDQjz94j4WT2598IKD5sM+dr+Ah2dtiRSZG5zGaEp
         wO+ULCreBuaX2Tww+Yk9TZjgOolwwFYIa17Cc1XbIY42clIj10rUc0ncgX5XQQr3NksV
         h0Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771857170; x=1772461970;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tmBlSydX8knIZXyl0Pvuba2NBQKTZ/5ssunahHjCvwg=;
        b=adQN0u1aKYpX3ftSsCp7Xdpnh5LvqkdlTVHq9XMDtOvYiLmfRZtMNPWNhCddVLXAEz
         ILh8XF56gUAY1i+WsdZgYDTQ/YGwx6XsekZ4HFiB+PTxgjDd/CnzlByvuTiolJ7vaaox
         bnEnoV6eRA9DHbXUxkilJa3cvnJN7rNUDBZZHw0EsTRgqEn170hVf9Gif+KQuYE0R8uU
         yTivz7FFHF9ry7wR0yho5CImESI3bMXajN+KiCKkLhPAcU1aZqBvJV7fGZ8JFjDdcJYM
         U2+CAlafgD3CX/vLiWYg5R10FE3IrgkBr2P7p1s3GCf1rkaIZM6ed2CopTKlTdQ2SlTb
         DhUA==
X-Forwarded-Encrypted: i=1; AJvYcCUH+nY/0B/SSq/6rQ4o4kC5xORY/gxiSjzxaf1XMSU+5dD/fWYHhNbyyyt95avTsq3yaiucDrrQ5Asm@vger.kernel.org
X-Gm-Message-State: AOJu0YyOIwbchtuW17aHZdJHkPhULWA0RTX+usfPMb7ajjM/rOdcu12l
	YAVRSaWx/oPIHiGPf8ULRrXMXyewzK7uEUkw5bAkulXzRWG28lqG6+tWe/nCoMsVymMqpQgVF2b
	2mNOWGAMHoc0Oi/xaB2wPC8cq5fUOyf0zeBr3t0zmkrum9W1h9NGA+qM+InIXPLyxirc5pyG/
X-Gm-Gg: AZuq6aLUO4bTtQ4qpZ2NP3gygDceBOYdEFv6nEFiRjQywuripdkWbap2H23HJ1fUFeo
	FE0RYVsSEqJVaGykeAFBxTDXuuZdl1xHOQuMxfaZW3EpATuKDx0rtM0mFcH93EXG2swDYkrbB3D
	GwqyHuDhbjHH92spvpZfWtZhBPqnmP4FdEZzR2YbakRe5/yHW3IbPRV4bMgBrhjf3Un8HMJ+R66
	f/1vtwTCUR4eygfB/RyOQdTtcWZeB8nNwnkWjRJLVQzBUy3esoF2WxLJWGWQUnlFtRIPM7fCBf5
	iz3lKEXBjwF6S7MEtIThlTvT1YHsg1J0CpqeCa2PQ/hyA7iIhleXYIn6ShlREj/JRB3SgX0G3mg
	23wfcfu1CSCo0OcIYNF842mqB6RaDAw==
X-Received: by 2002:a05:620a:258f:b0:85c:bb2:ad8c with SMTP id af79cd13be357-8cb8caa0bf3mr961160785a.74.1771857170076;
        Mon, 23 Feb 2026 06:32:50 -0800 (PST)
X-Received: by 2002:a05:620a:258f:b0:85c:bb2:ad8c with SMTP id af79cd13be357-8cb8caa0bf3mr961147485a.74.1771857168555;
        Mon, 23 Feb 2026 06:32:48 -0800 (PST)
Received: from hackbox.lan ([86.121.162.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a9cb3f31sm189638825e9.13.2026.02.23.06.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 06:32:47 -0800 (PST)
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
Date: Mon, 23 Feb 2026 16:32:35 +0200
Subject: [PATCH] scsi: ufs: qcom: dt-bindings: Document the Eliza UFS
 controller
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260223-eliza-bindings-ufs-v1-1-c4059596337f@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAAJlnGkC/yXMQQ7CIBBA0auQWTsJzKJNvYpxAXTAMQYNI8ZIe
 nepLt/i/w7KVVjhaDpUfonKvQy4g4F48SUzyjoMZGmyRA75Jh+PQcoqJSu2pEje07SkJc6UYIS
 Pyknev+np/Le2cOX43E+wbV+XZUhldgAAAA==
X-Change-ID: 20260221-eliza-bindings-ufs-2aa269f9c72f
To: Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abel Vesa <abel.vesa@oss.qualcomm.com>
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=1128;
 i=abel.vesa@oss.qualcomm.com; h=from:subject:message-id;
 bh=0xzDlC7N2Li2FtS8eDJ8PuGX0sJY8k9tUPeI83XobVQ=;
 b=owEBbQKS/ZANAwAKARtfRMkAlRVWAcsmYgBpnGUJfiNLyr/PJJOJOjXGNqF7mzblOUPo3cruU
 /cpCLFHCrCJAjMEAAEKAB0WIQRO8+4RTnqPKsqn0bgbX0TJAJUVVgUCaZxlCQAKCRAbX0TJAJUV
 VhhqEADFwmKe9bIw5zQjYcxzlxVrWDmAj2P9R9s3QjAYNMpGJGntvZvBTS98gIJKBEEKiQdnVMo
 /7L4ziTGh3px3sFxEFBI8ByAN3xr2DeZTlxFiUoeNpkPVaN6m+c4kdR6EUltHod5J+7PAAAOGcy
 pEVqayaE9hrK6lrri7OJu2mZ7hspe6yssgM15NX3SWGw97+syBMP0CxvrezFonecPSbciKEXPIM
 eC+++3WpxZ28EJ9MNuriguxjQI/YM1nogVeZnZSZMD0CQ/rDU0dy+HVJAFBizPVYlTXAc72GEwa
 O/jtt0A7+uO/MwgKrQqSqAYpFO60eIxZoAPHyB+iKNNUXqq29BE2abBCZ5NqyxvRhN9XJ2H/o5O
 sj9pDaVQkyRzUHagrOiFjmzYeZj4wcvND71Gs8cT/taVhkpaeKqeEBVQhJytfbvlrOkTWEn2DLg
 TLKar1SzceWuFey7/meXUe6AsD9k3ZjQS4qs54oGLbijjnW8tzS8m6iMD/H/rlH2mm53q1MBlOf
 fQxZQdVJSlYMrgR/aJTpo2xmXphvST63wHmcQWmI0G58uLab9ElijEG29Qjy0NX8FvBGiBkcVuu
 zr8morp2GPmNbHx6jTXqH0nj+yfGR7mVTGQdj96smrrWTKw20vqcGYFzgNZNYz3IxUDY+YuTZAw
 rDUGXcvyhsu7F4g==
X-Developer-Key: i=abel.vesa@oss.qualcomm.com; a=openpgp;
 fpr=6AFF162D57F4223A8770EF5AF7BF214136F41FAE
X-Authority-Analysis: v=2.4 cv=X7Jf6WTe c=1 sm=1 tr=0 ts=699c6513 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=oauzzCmhM186DRC0Y2yWPg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=dkR0I6OD3irOzcp_LXMA:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-ORIG-GUID: _oBRnHGrtxNpfq60m4n-ICMrQn5VIPzh
X-Proofpoint-GUID: _oBRnHGrtxNpfq60m4n-ICMrQn5VIPzh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIzMDEyNCBTYWx0ZWRfXyAdBO83IWvYJ
 rHZn3D/P//7cV+xUItbYdLgMzW8+VVz3h8jUhPzIo0lPBG/Mb/aIRJIzJN5ytKKJQ3wFcUWwfR5
 cWzx72mmcsVLyCI1VdNZFZZIVilmgRUWj/1D8YXxdj8ecNOhbIu07NoBFLVhigFt2aQ6KCF6ebY
 5kTlFseSufqEm9AnV4KuWI1nDzOwsUtHvX1veZrS7+RZpDWA8O/2ucFNM13JVuUdoCclfWmh7tT
 PtWZwBDwq2uDikrMnO+5EnCf8TOiISXjWrl7JRnSuCkZM+4uf1JHhqPwH3gqhnrVZjLN3RGa1nL
 s0febyLpjwlni108XtqoK11G2sDQ5vLpxExO/aAMqnuOE3UfKnkS+w3O670ghQ38rPLpDMfKyfS
 5uipcj00BuwtooEKvhw6efZnBcK9qg/PJtdfOsq5yRfRriVcyTv9Z3piyDYuJcFk/asqxBUmWjw
 asVc9tOJmq9O64OVuOA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-23_03,2026-02-23_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 priorityscore=1501 clxscore=1015 bulkscore=0
 adultscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602230124

Document the UFS Controller on the Eliza Platform.

Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
index cea84ab2204f..80550144f932 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
@@ -15,6 +15,7 @@ select:
     compatible:
       contains:
         enum:
+          - qcom,eliza-ufshc
           - qcom,kaanapali-ufshc
           - qcom,sm8650-ufshc
           - qcom,sm8750-ufshc
@@ -25,6 +26,7 @@ properties:
   compatible:
     items:
       - enum:
+          - qcom,eliza-ufshc
           - qcom,kaanapali-ufshc
           - qcom,sm8650-ufshc
           - qcom,sm8750-ufshc

---
base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
change-id: 20260221-eliza-bindings-ufs-2aa269f9c72f

Best regards,
--  
Abel Vesa <abel.vesa@oss.qualcomm.com>

