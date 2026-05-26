Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8403D34AD
	for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 09:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779786630; cv=none; b=kL45iSgJCKOKG4d8soG6VkYO/ZMGvkdMRGqa1zN1UCEsdgRcQ+TsEFiYmrYjvtIMJHVDttvvDCu1v13GCuZl2JnvEVwp9DfRqcCpxnlg7hCKM+69RtYcL8ILov8Ty8imQa/K+AZbqV9Lv+QHOntWXJyT59M1IdALA4ZFOfaOpao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779786630; c=relaxed/simple;
	bh=uHxDfHp9+PexPpMOxr77xWIABoPMGfsxROU7WJAR3v8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aFNnGtEm4a3X+NnO8M80DbMt/X9JkUWiPDGO+rKQd8APHzDtIr+z5M5ulV3x5wmPzQ2hsy0+p3R6IWwAE8Hxy0+9J7EMmjUtoiaG2On19yEVkKCyKQWmweLQF3bbg2YXW7pUFhgfPykZQMiFEBnidAg8IG0Bj4JMQhmXuiWWNaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Z5y/eyU1; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ElPtuw0q; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Z5y/eyU1";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ElPtuw0q"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64Q7oCa63603993
	for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 09:10:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=T/2aewGB4Kp
	n1y8yQDIKkfGvFMIVNTd7+akHCzOQCLI=; b=Z5y/eyU1uBBwdHYbUe5m2j+i7jO
	K0dQFeC27fVxhamLDGwZaRMGFkSP7UKLMa/Agh7JgS8Pg39WllR+ns4CSj+nZIOH
	cCE/BNOiUSp9hMAJ4GjbPzaaySvURhl4aLXFWXaUwlaZHdiqschMqEHcaDBN4FSt
	T6wNQOrd8X37iVpp2Z8B4jdW9mkadVNgGd1j/UrBHPupHJpxOhbcDZWl/vAjnjCv
	zqsOM84QKZlva8N3x9vfFw4eOUpzs41bwKNsn+j2IGEpGmQyul1qCGNu4KXRvkII
	lBvm9JVFlvvGO7gD9kwzuxVm2hIpD43E1pf23zbFbfg5rD58z5SmwUmL/Tw==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ecpyqk8f0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 09:10:28 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2be9e0905a9so65978545ad.3
        for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 02:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779786627; x=1780391427; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T/2aewGB4Kpn1y8yQDIKkfGvFMIVNTd7+akHCzOQCLI=;
        b=ElPtuw0qBd/B8TKZkrF0IebpG7FJOdg27wJi4fzbgYYv9cARN63kf/exBYskrbOrKr
         x7w1oPS9tmqmi7+v7YbQAcoe5jdPGXwmTCfyB5GpQkuywGOMlL988lT3MsY5plhDLzRE
         fPdgmL+ndTCYH0YbRd6r5uH6wwCygoX8N5Xx6b2i4BAEwe6Bsp6iLxUrVVSOuHyWy7WY
         EDZM06BtsQpKIcHB+b/vc9h+aJ4856qqOKjZkIghRCnbk865gsEOboVR2jKQrLTNoxeJ
         n5VeB1qR9nRmXvkURiKCKSbnDW+EsgLO9/YhDlUzW8zYkTCyjXiA4SH71qZEb7RqaGlF
         FzRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779786627; x=1780391427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T/2aewGB4Kpn1y8yQDIKkfGvFMIVNTd7+akHCzOQCLI=;
        b=ZZ7y91xMFVEfyUEsB/buYfmEuEpxUpwXlki5YM4HYaTwSW4O3q6XJjN2aEyMpe2hl5
         Ptc/t7MLZqjLq2gaFtHNFA07f28XUExPP3WlhZ3pnjNYgxLE8jEFRipB5BpgumginNkp
         azYJkrWYly8gLT6sEx9w62qvuCEFt2ZcMoUY/76kHCrO3sKxHYBjfVPHPX0XIrGSZeZ7
         JTlIY1VbTPKLSMNQLWa0cSPhZLgGBibFcNOwa56vxqg3FHjDEWydiQ9dxDWSXIfgHhZz
         snOqX37OMqijChNQWN5GHz5LJUlG2Yy4LSXJ1V5Ifrlw/ZeqENWMW+qL1kOP/gC0HwZU
         SR6Q==
X-Forwarded-Encrypted: i=1; AFNElJ+ymvS7sh1OqvCsU5/o5JR/cdo8dJIIEHOPNZAnDOCQ7ET7UhJT7IhVwqeu/53FUmgG9ql0iCfMZ1Sf@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7GWBIWs8PmcN3a4gMZuMzdyULFjgQ9JCO2dpTw+LDgcapxgqN
	w43R+1MGdgawzn3d2Acfy9x31XLeTehmwYZg586LC+F5CbXjaMmuiQouMv3uBYwyAT01g/pqs6h
	gv12/lMj6ug21Rzgf7nKPwc/uD+BCVt0WLSOuamtHixWJw4Pkr7jKPsQfzXUbpz+v
X-Gm-Gg: Acq92OFqijWeaPRhXflp3+NoMwOwy/2j2rXRjXWPylosYjxzJ/QzsO95UdTwEKybyCs
	9wuGyqcru7T9/xjsdLUXrIZQuG64qB27Vf8PyalZ2XTVQL44xsrCRQMtrt48WV98EnnILTfsLOn
	Pma6ycZ7nxr5kJnZlEG6XoKL+FKM/1AzuDcRHKL392FsqIO3rricg4iRbWOgEFsji1YANsm/MAK
	8lszMQgrHN5oMzj9j63Rf0OHICxuyHP72Wn2HFxxYhiWMOv48gnHV1OKE6VXjHVstwvteE7EaSj
	IoePVQVqC3yO6DMfTyR3kJPD3c2Ye+9NNqq3Ge4rur7INPeD0r+IJsGM5qau+FW9c2IFU/sBaDy
	UwxpR3lK3pqjSR1Vf+BhrH+ttn99l9gxe4e/kYmuSQpkd3TM/VaT4uA==
X-Received: by 2002:a17:902:f543:b0:2be:1c3c:72bb with SMTP id d9443c01a7336-2beb069d332mr184560825ad.33.1779786627400;
        Tue, 26 May 2026 02:10:27 -0700 (PDT)
X-Received: by 2002:a17:902:f543:b0:2be:1c3c:72bb with SMTP id d9443c01a7336-2beb069d332mr184560405ad.33.1779786626890;
        Tue, 26 May 2026 02:10:26 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb5695a40sm109237915ad.17.2026.05.26.02.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 02:10:26 -0700 (PDT)
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
Subject: [PATCH v3 2/3] scsi: ufs: qcom: dt-bindings: Document the Hawi UFS controller
Date: Tue, 26 May 2026 14:39:55 +0530
Message-Id: <20260526090956.2340262-3-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260526090956.2340262-1-palash.kambar@oss.qualcomm.com>
References: <20260526090956.2340262-1-palash.kambar@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=dtfrzVg4 c=1 sm=1 tr=0 ts=6a156384 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=EUspDBNiAAAA:8
 a=VwQbUJbxAAAA:8 a=dkR0I6OD3irOzcp_LXMA:9 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-GUID: c_n8fZzg8eEr8nsmkce6dUUzaj2009yl
X-Proofpoint-ORIG-GUID: c_n8fZzg8eEr8nsmkce6dUUzaj2009yl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI2MDA3OSBTYWx0ZWRfX63g4D2r3kQkX
 I2zi/U6QZmfQsSwbBVLxfJQNIjeO2R88vP7vaLug+sT3ZEZU4BPcjYfyB2VsS4QmFJDwSxZfEO5
 wu3EayezpMcFDMlmSX8wrm9mGG9DQyf6DGJX4niWwTJpH9cbeJQZF/qkZRVn9M6v6ihvTFAP2Tz
 A30KJj8DqTuEEyKG0m3LIiLPlLZWA0fAVrge2WAHL9J9rxHKiXnF2DRbyN0R1Ld6riAswL1M6nf
 qIOtqb9T3Kq2SFBvPtcVEJMzhn9992mJXcKDelhoVV7D8HWGhjuVnsPWjsmaXJQSqGp3vsgPF42
 XkH2YvH58Ir74jGTGuOGhq1X2myw4HVWr2fGbDKNBWw+IZptYF0mYBVhPaUjDF7KLTAeKtn71Wr
 v93YRPDc6EKpfDquvM96VAbaSHcHUE5Z3afCoH2eJtSW6pLpogU4XvH83EwTekBKgh7/g1ElT5b
 KnpPcb8ti03AQN0XO7Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-26_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 suspectscore=0 bulkscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605260079

From: Palash Kambar <palash.kambar@oss.qualcomm.com>

Document the UFS Controller on the Hawi Platform.

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
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

