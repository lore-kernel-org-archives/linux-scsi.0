Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF83448BD52
	for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 16:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779123254; cv=none; b=b/hfxOJoTV6waR7H4EatJFMgENEIhXjtGO2VblGIwqGvuzhyx78njcOyTNK6O5srLdt6rMbsqcmD3GmZAko2z9bfCCgYA+suO3UbqSkCY9sODKSGyTqo3vtgsMSk0Px73PF9j+OwsileCLk1a1Dn4KWZ6lsXK9q90ME8eZfE6cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779123254; c=relaxed/simple;
	bh=VNEhOKBhobQqQsoEuqNm9mT3JANz2GEoOzRTHnEsEfk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KpSDc5LtjW2+ppi4+0kO9tMBLLctLjB539kbYBqaU1PqHHVrkRYrzAGTfuANArvWOH4DsSaqOKIIYgPpXu97FB0fbF2iXULuaOTJ670QZh9+LI2NXcSJVSTgySKmFQzF5fWlzz2lWkemgvkB9Qfb8ivsRLR+1ug1Rt76YXbnCDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=UxFBqabT; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=N4Ghzzlh; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="UxFBqabT";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="N4Ghzzlh"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64IEnGoQ2975395
	for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 16:54:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=lqhBDm7fYqu
	6MvZpBtGOglNbnbUjw4oExZ0wnZT6Ids=; b=UxFBqabTecW5vlb0rcdi4JEnZdY
	S2KzrNM3MalVdZP+7TvZsnJ6P7DFYCPv1fpY1NLr1BPBXRANhXP7v10aadNWe8Ej
	xv9X78RGLQ+xtuIG4ay6gR5TqYsMQpruf5ax4UEF8XO9bgQy1ldytPcJdJoLrHXh
	3a46lG/I30HxLo4bQBr0Ta6nrFzZ7jRoqW0pNV5V1cXT1rleZB28dyy7s5VcD5bR
	qbdkiouMHpduyyAFmMV/or7DEopALCJY4DYUa2JOPWFdVkHv+gA7hNa6dMH2wuTD
	Fr0AzlCS9wwTex20pF1ViOLe7sPFC9gVsH4Ed9m9NPbtLpCsaCAjXQHLxiw==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e84v48ffy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 16:54:12 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2b9fe2d6793so64766155ad.0
        for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 09:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779123252; x=1779728052; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lqhBDm7fYqu6MvZpBtGOglNbnbUjw4oExZ0wnZT6Ids=;
        b=N4GhzzlhAwB6y+o2Yb6SfVAZb7y0jsE+gHITUoiIIHbL+MjiE7tnX7+Mnqjx5XUlRh
         lyExfMYMJ4CYXuGKVXuUG6huf5jyIvW0so0UQu15SkE/OmEoQEPlVcPv09ECP2jSta7d
         vaCe7/Sr8WY2W+cwSmrKdQYpCnFZaR1FAZDnXcqBINuk1atg8Dit1kQQ9Zv3Q8nhdNVE
         1A6CjMvytW2Zv/RqtqGQh0PdJ/Iv3HFlmMFisjVVmN8wIcVKTBXiYPDnpUVyp5asD8tm
         fp5z6+dtLXi49YMzGO4yU1WiaNcUC5WvpYfE3H7/6JobaYgQoXijMQD+37iBEH88sRrw
         nbug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779123252; x=1779728052;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lqhBDm7fYqu6MvZpBtGOglNbnbUjw4oExZ0wnZT6Ids=;
        b=BujVoYk0uxjAZ6VlaQ8t0dwYIi0zk++5vqkLbk1+kP+k+hM/o8CCy1N16QL5+L98CQ
         CCQkooRXztDqqn97cL8K6Y9tPPi1wr4cjfc3tGXnUlV3BupGx+ZeKaOJ15RteFLS8cn7
         KamLCH2lo/a5thD/UuIlgAGV3mEFOpVK/quOYDt7XHzOHXVUwjuD6ImjGNgmWPSq9slD
         nUs1OToUgQyrScp5eRNhu2uV6/Jxgi5O4jy/Zk6KmPMEOw8/DPRL2AgmAorDpQJV0LsG
         m7iy7Q7FdqXG+8kuQe+FseGkqrOejrMa2a3H69m5yfT0plZQbjPGWXLr3JvUAGYxLz1L
         yCew==
X-Forwarded-Encrypted: i=1; AFNElJ9A/1dpvYoWs2Jz+TovuUeGZ4QyJzwpcavVOTDrQyi5MMVyS4s7cSXxRUxoEUdsQapPchG9z38TMunF@vger.kernel.org
X-Gm-Message-State: AOJu0YzZdAw7jzFaIXVGlyvw5E1WEIyoeGdqqbzgZIqASTP+wbgBPc7i
	nxHIwLFBxgScVj+noVB1uIJwNkTs/E8RYtHs39oVgDfCkR1hLR0CIMlx2qAZHpHukD7rXq63QS2
	3HJRMQmFYVjNRgMKY0ybPXteNUEnjFTU9iV3y/EdN6ZVNpWbNgBqBwRRElKQdPqpr
X-Gm-Gg: Acq92OGhGAhsM7l0b0eiwQW8FG0k/8ixzGGnHMhDNJ+OaRHJwIv0no2q3kS01lQnxuG
	M5UN8PBBvGjAuFmwgELPfMeBQPDTNlexDt2nYCOM/kx4pWOBN9TgrW6Ty6U3uHwvhl1x14W1YYG
	BkCLj4HGfka+NIVmuplGjKRMkCb4PX4HpNJ5x7731VTPhuFusZEbr8AwAvRmilHk/2ehnldqL9t
	HTVNX9eQ5MT4IeJwr/Pb5QLJf2+ZfQe9U8rBnvrRxKpFtCFszP5goYAL2J20crZkG52ffZswtEP
	M5MoRcfvA7UAdGK8jcaWzxtN3hIfhPk67MUV0UfY82iAr5zTn5mNcm0X8FTpbjiTT3iVeCmRvrR
	pT0XbDtfEe2vB8lpeYpKJUxBBB0SjREH89VP1Z3OLeiHxCgx94u7s/g==
X-Received: by 2002:a17:903:8c4:b0:2bd:8fc0:1198 with SMTP id d9443c01a7336-2bd8fc01303mr150907145ad.5.1779123252193;
        Mon, 18 May 2026 09:54:12 -0700 (PDT)
X-Received: by 2002:a17:903:8c4:b0:2bd:8fc0:1198 with SMTP id d9443c01a7336-2bd8fc01303mr150906935ad.5.1779123251728;
        Mon, 18 May 2026 09:54:11 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5bd5fc47sm149971045ad.10.2026.05.18.09.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 09:54:11 -0700 (PDT)
From: palash.kambar@oss.qualcomm.com
To: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, mani@kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        andersson@kernel.org, dmitry.baryshkov@oss.qualcomm.com,
        abel.vesa@oss.qualcomm.com, luca.weiss@fairphone.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Palash Kambar <palash.kambar@oss.qualcomm.com>
Subject: [PATCH V1 2/3] dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Document the Hawi UFS controller
Date: Mon, 18 May 2026 22:23:45 +0530
Message-Id: <20260518165346.1732548-3-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260518165346.1732548-1-palash.kambar@oss.qualcomm.com>
References: <20260518165346.1732548-1-palash.kambar@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=VJPtWdPX c=1 sm=1 tr=0 ts=6a0b4434 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=EUspDBNiAAAA:8
 a=dkR0I6OD3irOzcp_LXMA:9 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-ORIG-GUID: TELrQQDsibjBdkoSKYbF_dXp7VrqS1nv
X-Proofpoint-GUID: TELrQQDsibjBdkoSKYbF_dXp7VrqS1nv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE4MDE2NiBTYWx0ZWRfXwEr/zQ04hsAS
 2qInQqy042tX5TaVNX+nEwI3bhdaspJ6y05OY/VUwjkug0Sa6qWL8RhhErVyIO0B3pbeCMeIr3Q
 9/7pfRZmE9h5wASLce0Bso//9AWhLZ9rCwDMUuJURWBlC0rv2XEqSKGiTZYBFR3x89I/5yFTByr
 QRbJ5wxgpchGEMZTtnj8nBr5K6Q0zfGQMckQ6Opsw23EzW8Jfpvc9KvbmXseSoav8n0PMJhY9mx
 o8+r42/La7cNo0Pnz5EneTfQSDfCSFfzXrKr/bcxvQ7flPZeSwZ5Z6fIIdSGwgWVVsla1lXyAMR
 1lylP+mdDOwfbLIIlCd05OwhniqzFAPZi8xPZMriAKvPXeHW62yRjeLGxEo7XBuk2wduxXQBUTJ
 7FyqMGjuZwLd5NLVd7tnEY2BZtQuFLX8OxfJvUN2OOM8QUwtT6tfZZ0GGvfp8e2MgkiBGac9ARC
 T09BFp/qHl/NAAoG3pw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-18_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 adultscore=0 malwarescore=0 bulkscore=0
 spamscore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605180166

From: Palash Kambar <palash.kambar@oss.qualcomm.com>

Document the UFS Controller on the Hawi Platform.

Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
index f28641c6e68f..3de00affa4c6 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
@@ -16,6 +16,7 @@ select:
       contains:
         enum:
           - qcom,eliza-ufshc
+          - qcom,hawi-ufshc
           - qcom,kaanapali-ufshc
           - qcom,sm8650-ufshc
           - qcom,sm8750-ufshc
@@ -27,6 +28,7 @@ properties:
     items:
       - enum:
           - qcom,eliza-ufshc
+          - qcom,hawi-ufshc
           - qcom,kaanapali-ufshc
           - qcom,sm8650-ufshc
           - qcom,sm8750-ufshc
-- 
2.34.1

