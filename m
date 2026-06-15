Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1AC3AE715
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 09:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781514786; cv=none; b=t9UTI5krMp1J5oJCZybNJfHT8FipETPgjWzaOR5wVeKOx7wJKhGjm5/TNvM7rQO8s3FeBvqhKNNpJuUIu+i78OUzhTu3MP6ToY4FqjgZ8N8uqf3uiYdEmDnjKy6dsRVv/dCp+2MOUXG7J4pvj40tM1hKUwpu1V46uzaVy1ml50o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781514786; c=relaxed/simple;
	bh=Ao4k8UCAQ63pTsAXW+nwl6jaANXflQZYV4NF+HzDpas=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZTCKwgmUpG0+diflUrsQzc1dALxHG5wXlfrJHc3dEUeClonaiCS6EVOnujec2za3rygavBFSm34fdkf09HOHqSayzeg7inxhMvC3DS6bhORLyTag54HpicGA9lvD1QDh/uowyFq6JPTxEL+hs0BiSfhrlCOjIGdg9xBEvkyQNcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cEI5Z90v; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=H4BgJfsp; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cEI5Z90v";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="H4BgJfsp"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65F6KAas3692507
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 09:13:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=Tx+tU+JavHm
	9jlJKkOPRaMWM/yiGuddWBQeSbrpsom8=; b=cEI5Z90v7sQGWvONHb8jO52m6wC
	fmgZoRLcJOYeNR4JlBUnoH1tAl9QUjvCJ7mfFmMSv5Nx5oFAyVvQzf3+OxJaQFOB
	+ppN3Ym9Jw3I2rfHBKVSX0fdojvi+nP4wqQDejwiqO94BEalzIaoPj/FkXWZJcYR
	8aiyBmCzQlrHOOZ0X/RxHz9JWGGoqFnMyXdxoj4XbYWEX3jjZYMUw7Ib7heFaJlO
	c52ERPg5lDqV9D4syM2fHYWM2xWz6+OI+XLVaDJL6mkAq4wZXGm3vc2cny5/kD/n
	DBT6XMGO7vP5dyJA6FpRQ9uKKe7Rpybx0npYWb5aM1AShiFNkGpSxdoUhSQ==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eryk6ehhs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 09:13:02 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2bf32fb7cb2so23248275ad.2
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 02:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781514781; x=1782119581; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tx+tU+JavHm9jlJKkOPRaMWM/yiGuddWBQeSbrpsom8=;
        b=H4BgJfspnRauDaG7VACJHmQnuQRqF33M2r2onv2ap2xS0WBszVkH9UkWzG4cnPIfPv
         vVsHeJBRsmBGPW8trWsPCbJzhiOeLVj3KPiGYpzJp3VAY9kxqXJHkldCQXKatLckCOlV
         f6bghKNmDCaYIMoEvwTR+kUDkHHIWBPTfgI8hCMMgKZOtpQQzpEAz2uQChEEwwL6w8pa
         eoqU8LSTeKGHcAucIQIv6AN+T6LuKSqhDszTmS2ovehj39ObcHARYhCZX/mqAf1oPr2F
         ovQO7o8y5eUu+vomuTk7l3Y6eCO8SIaturSlJSSwB9pJ4tGTSd8tL5gkuAmkPSr7KDPl
         TPlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781514781; x=1782119581;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Tx+tU+JavHm9jlJKkOPRaMWM/yiGuddWBQeSbrpsom8=;
        b=kyAbx0mBRenZJd7N1nYEArSSKCAZJP/lVdYX6jYydryYxnMkMaLrIaZv2BZSbUor02
         xwQ21y1P4cRoXw/j+iuvlA3oJhFK0NsCMCNXU/HQiFWgP3ZAvrrLBAwCnY4gJs9z8JCE
         tAKj2a4s3n4KGz9mVrCzeEVXY/uGxADAPPjLi6VapwOb5/M3G66SrQEXJCJbR6dJKfxE
         uYsyF0smdIj/tUgSQ/+BhGgS4+QemfNPqusfSr3VeCMYdueYktcx5FM2C3xzJi6j+rcD
         69NQCzvhnyIyu6X5ilyS5eYjYadNKRr2AToZjgCWUWGjnW17dXW8f+SCfDjjBQtgy5R0
         EHpQ==
X-Forwarded-Encrypted: i=1; AFNElJ8XMADcabPHli0W1sN0WJyi0D61HvM4xQVHhRIVo2Z2EXi3BQL5hXDE0V4NPvz8n55xwHPGVGjrOT3U@vger.kernel.org
X-Gm-Message-State: AOJu0YwNy4tm8y/WSU3NGOVjo7n3/KW04/7tjxNifTuXS52l9zUx7kZV
	oEEPeos4J+DTV6+nGYdnptXK6hsw5JLA0JUlGhd9zFVcYg0InFKaVMwQSriTjXUXGE3fEQyWLHz
	fW5LdWSAmymJV8pRFyN214pFUP+DK66K4IcMwQNIjBqQ7hniWOug/oX4XoJj+57p1
X-Gm-Gg: Acq92OGa5m0ENfnoRrPSREfyeGzSnx9bpTk3pz+iK6t5AjEXlhCF4ug+iNrqaGrCF3a
	IlnCWu5AdE6UUOUbqe4xo3FZnN9jSJDuuHAOGQG6Su7uRdYww77hn0pI6awysv73efj4G9mgieF
	JMbh3/Cw3Q3w5UmLef7XbW17SO4Vui4Y/rBI+BFs1LpLWJM4Q/xTu7u7K17u6oEnLkSSf0ygtw/
	DguV55lzzPjcuaWJv9W8zmVD9/u0hLN4pBS97539yivhb5a97PJMIaK5g4Jrr1MPk/4svRXiux9
	vsnSA/EAegIRRM7Kh1ZqVueoSN07jfmDXsJW4akBMbd9cEDLE82KZ1veQT6zap9NQzUEB8TeVkk
	AVWjXRFHUrYzj7gUifAws77E0RtQi6j8vDpYM8bbiTJL/wmw3q2D24A==
X-Received: by 2002:a17:902:c941:b0:2c2:78c4:b74e with SMTP id d9443c01a7336-2c411d79d0cmr150200355ad.27.1781514781364;
        Mon, 15 Jun 2026 02:13:01 -0700 (PDT)
X-Received: by 2002:a17:902:c941:b0:2c2:78c4:b74e with SMTP id d9443c01a7336-2c411d79d0cmr150200005ad.27.1781514780889;
        Mon, 15 Jun 2026 02:13:00 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c433079999sm91669065ad.66.2026.06.15.02.12.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 02:13:00 -0700 (PDT)
From: palash.kambar@oss.qualcomm.com
To: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, mani@kernel.org,
        alim.akhtar@samsung.com, bvanassche@acm.org, andersson@kernel.org,
        dmitry.baryshkov@oss.qualcomm.com, abel.vesa@oss.qualcomm.com,
        luca.weiss@fairphone.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        Palash Kambar <palash.kambar@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH v4 1/2] dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Add Hawi UFS PHY compatible
Date: Mon, 15 Jun 2026 14:42:41 +0530
Message-Id: <20260615091242.1617492-2-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260615091242.1617492-1-palash.kambar@oss.qualcomm.com>
References: <20260615091242.1617492-1-palash.kambar@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDA5NiBTYWx0ZWRfXyq2QAHsfcbY8
 5SWB4XdP4EBVo/01qFYOC+zVNRKdVuPDCOtonWa7pmMfGxWNPy6Z3WQ2sWC3mXKl23VHwNSu14/
 0t2RjxX/9cnVJdBVv9hsFxKm08+Es54=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDA5NiBTYWx0ZWRfX+F7j53q/jnM5
 KGWPMGjh+6AASxIUMoMksaZbzNzNpxT9Iva4PGbq7jfFvt4/F+fqztdMPwbo6tpmHdDFnweYmMc
 RAIKs2hvfHSpeMKZst9C3tNLGTbtp1/pnmfQ4YYDQ01KmiRtapcmD0je0wzrpwXeG6Hwu4CzCze
 8Fr8uO03LLTNuX40j/jaZ1qkzwgz61hmaTK3BH/6mL1qCUt/J/a5aquNQ+C0Sfil67Dm1gZevbt
 fMGfkCjz0StoxUyhq2e1WjWEmHPeMezsgA3IXQF8vwAgePo0eNocSz6rto5pmHMcBMcTNLW0VE9
 1g+8M5g5UfdIOLIDahg+pagP1YVjmPKNasXBn32wztyEPh+n184gpJ8FMnyX87c7dJHxm/7ltQe
 1XdYtR51SFWIAIqG4surSeibcwmBpAqjKvlgLnrukuH1ckTuebCavmDdLh0VRxWZTucsFBfQ9CD
 WFIGeZtbAkIgolsvgfw==
X-Authority-Analysis: v=2.4 cv=NrThtcdJ c=1 sm=1 tr=0 ts=6a2fc21e cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=VwQbUJbxAAAA:8 a=MMZtLZuhhDi3SW52_uAA:9 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: kDb6fwXFDQ_gOfcFZXLKOho57Se8IPCV
X-Proofpoint-ORIG-GUID: kDb6fwXFDQ_gOfcFZXLKOho57Se8IPCV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_02,2026-06-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 suspectscore=0 impostorscore=0
 clxscore=1015 priorityscore=1501 phishscore=0 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606150096

From: Palash Kambar <palash.kambar@oss.qualcomm.com>

Document QMP UFS PHY compatible for Hawi SoC.

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>
---
 .../devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml      | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
index b2c5c9a375a3..4efe40c0dc97 100644
--- a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
@@ -38,6 +38,7 @@ properties:
               - qcom,kaanapali-qmp-ufs-phy
           - const: qcom,sm8750-qmp-ufs-phy
       - enum:
+          - qcom,hawi-qmp-ufs-phy
           - qcom,milos-qmp-ufs-phy
           - qcom,msm8996-qmp-ufs-phy
           - qcom,msm8998-qmp-ufs-phy
@@ -108,6 +109,7 @@ allOf:
         compatible:
           contains:
             enum:
+              - qcom,hawi-qmp-ufs-phy
               - qcom,milos-qmp-ufs-phy
               - qcom,msm8998-qmp-ufs-phy
               - qcom,sa8775p-qmp-ufs-phy
-- 
2.34.1

