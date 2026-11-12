Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794523179;
	b=KFlKGUAdc6SQtlTKXn2iI1LLbafDoF08AkQ3kUNCmG+QO/Y3JAtDDBotIEU44TDvDMV8
	 w2TryD9NGfr+bbsci+WHgMpUjSF7pG7GOQK0Ef2Odwr5UoWYJoXgX/j8T1+TsKd07DPim
	 ctc05xpNitRGpbtMVdE0y19b0V+fU+QPPfuAgrQ183UlFmhrHDa2tEs5hHaky+Jo+IgqE
	 euTOSrgTvtDQnqpo1ZtagyeiqvcNvno8DqSxN15b0dIk3M0ySpCebFs6ILI6HEMus+gDu
	 06czSkDzC1Jz2oVgujNqQAXRLDm0ZiNv/jejTWvMYCujI89sRJcmRyinXx0S8GSusbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794523179;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=h5d7qQ1TmiafTLELdwxVa2K3qpo7e3rfmt0oQazEA1I=;
	b=vX0MJS+NsNJsO2odnxblJ7C9q0NjksMcAVVrovRHHrob32zPn9hZOPHmTdrzi2uVBiBM
	 J2xGjK/JaCgong3V94YGZN90eUP4Upuq1XzpRUNRLHYUDV+IrAUvqWtn/BV5207HkU0pz
	 lRt+Ip4++r+c10pjZ+BC/jEbPZjF4E//1VOuNrBBClKVQ/eWxI1SuFu+r+0/No39+55g9
	 LK2J5Jn4+T3ZmbLsmTc8LHw92MMPAcevRd2THjIJzhTmKySshbJbwQn0H2SSPa2O0MEuD
	 976+bhv95I9ptwJa4qWNZY8RUjzs5hOlIPX6dByWIaH5IbBnvdznzLHzpOKPsv7BR6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=PffptluP;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=FeJVhMhO;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56AC260A2622
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 22:39:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56AC260A2622
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=PffptluP;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=FeJVhMhO
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ACJZkEd3120879
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 22:39:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	h5d7qQ1TmiafTLELdwxVa2K3qpo7e3rfmt0oQazEA1I=; b=PffptluPAo9AWFlH
	b6SXJuXvj4CNYdzrEcMKlMqjIGmfFAw7foySfT9Ag/2KpLeCba1+0DawoDpHTet/
	73jnUhT5yV+GliUh3/VuOF5hAa4cus18hUMidkNVdBA8XY3KvosqC9SIzaJzcRKh
	yjbvZBJvfvbLJBA/n6rG/sDuFoUufFwb+te7wO2ngClA95Jk/OQgtKjnrn5H0/yg
	XTtxdmtxb6DFy0nPlmmCmPMbsw0em7LuZcdq82epzuuMJSWB3mXTWToMe3c0kCPk
	Bhwkm8+QdgpVkcNYwvvx1kqHLq/wwlAENMop6WV6iI2gPMBG4a/+DS+BZHOKTScv
	YfpPnA==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hwbx32gy3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 22:39:38 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3425098ae4bso983560eec.0
        for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 14:39:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794523178; x=1795127978; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=h5d7qQ1TmiafTLELdwxVa2K3qpo7e3rfmt0oQazEA1I=;
        b=FeJVhMhO1ZG9zVHEigvHJWvYBBrEQHXGoocJNJSCtxDoD6UxFFMkxlupoBaqbA+M4V
         o8RmQQyw6QkQKGovol+mM7LYC5u0sDQTnVGFzKHx7n6eccYUIIvLAi9/7igSEqwhHXmh
         ZSFFyhTsuHet4QGuEsgffBo5vWNeR+5gCJC+d593K8b4jJyg263NniFo5585dgY8n/1y
         RaRZPCYNLEvC+uOeyK8fWOqOgiNclpLf0x93LpwKWsdbvMo7Vo+GGNOY4jZ/hJIbroZ8
         R67DBYj26P+C86ChVIXXAwVMPGFfYxzcbTuO8acVjwf0Y7uMvRIlvtCPO5UOHmaBkCxM
         8WHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794523178; x=1795127978;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h5d7qQ1TmiafTLELdwxVa2K3qpo7e3rfmt0oQazEA1I=;
        b=D+zMVrCEZ/rWjd6jHaRwdcyqIq7DSAgJyT8kxH8tXEwwjmnI+quOcLdAbGYCENRXbn
         ebB++jKEx3v+0TSQ3euyYANgiSRxcNvtO7eAVb/BisLCPDSPFYCT3CnMT/g9iPxnp3ez
         6FtpNyynGGx2OzFtsVwiZx2WeFpUw9V6GGEg9z8navjvloz0kCY1IDXv5ByskSCAyA90
         aSqz7SaIwwxoC5HSIP2R0kza7oYJ0W/SPJ6d+xpki7C6K7F05xXxLubMyYO64ZKO6sJO
         ORM0rSeWW6XpFrN7tDMTQJdEGyBa1aoNGAH9zloCSlbiyqDL6ggmEvJLhHoGkx/8N7Jj
         eYhw==
X-Forwarded-Encrypted: i=1; AL+hErGWQ3yoW9alYkKP50PB6rJqhyoE4jofvy7T4AMfq2JTAjlWIvKq4P1xb4klvl0b417NWlI4RE5jGLMo@vger.kernel.org
X-Gm-Message-State: APuU4Z8W6lOB4xLEOHqq0Ulm7bxLGLwciR5itLLqgKqoh2T0z/uBIzE7
	/98i/StnGxIm5N6yfa2IFtx58nC3RJVseK+SbEdeyJRKRh85PAfkUEeQ6EsY2VBr70z/KHp5qIc
	I8V1x10brgzmP2jbzkPIDnygr3FbGhxstq7OkracdQnKUBfoGciqLzM2VzM965wJe
X-Gm-Gg: AYBFou1Mwne3Wl/nQB9h+NGz1eWyI6bZBVBjEAw7Lbuqn1d3TFRU5M8zvxjzcWtZKtF
	RFdr4XSOjxAdj4u5nuy1Z3V4KyiLlNX1LTJrJe6xHIyX3esZ9Ie+vTgAaTjWErcQFfECKJthsTC
	h5QH9vqtu9m/6HowzDUnXzKCp3IHY+GvrTAntHA8gHWPEgz6/CK7fYYxDaW3qEsVpwZp3JFhs1d
	+g0LwwRO17V61dCq0nJejwQ9ehY3JUDQ6nf+toXrcQScfNXvMioSSzmsGaqwIjWjBvfDiftwSjv
	uXG0ehQy39o9YFoEbEC93EuEqAHFr9H7x67n1FL2v5Q3v613k0ujdiMIkfhn8jINlK+Gecs7LQQ
	gYD6YAJm3hRfT4xaeR9TNOeH1m8VXrSJsPgOaJusvNsjwKEnzGJKvP0buwotSabX3rcrCzUTHW2
	VXXf3QVoT45w==
X-Received: by 2002:a05:701b:2402:b0:1b2:6d4d:9d8a with SMTP id a92af1059eb24-1b4f5ea832dmr2727950c88.2.1794523178001;
        Thu, 12 Nov 2026 14:39:38 -0800 (PST)
X-Received: by 2002:a05:701b:2402:b0:1b2:6d4d:9d8a with SMTP id a92af1059eb24-1b4f5ea832dmr2727934c88.2.1794523177498;
        Thu, 12 Nov 2026 14:39:37 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031468b7sm2333496c88.5.2026.11.12.14.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 14:39:37 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Fri, 13 Nov 2026 04:08:30 +0530
Subject: [PATCH v13 4/6] arm64: dts: qcom: kodiak: Add OPP-table for ICE
 UFS and ICE SDHC nodes
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-enable-ice-clock-scaling-v13-4-258dc817bd63@oss.qualcomm.com>
References: <20261113-enable-ice-clock-scaling-v13-0-258dc817bd63@oss.qualcomm.com>
In-Reply-To: <20261113-enable-ice-clock-scaling-v13-0-258dc817bd63@oss.qualcomm.com>
To: Abel Vesa <abelvesa@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Authority-Analysis: v=2.4 cv=S+5MU4sP c=1 sm=1 tr=0 ts=6af6402a cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=Gfx0KCctoiflwLzBlNcA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDA5MCBTYWx0ZWRfX4e3kKD7q3aeo
 GykZU63ItzMej0dLYp2SVqKsKyWYKatq1lwiJMhlNn7OoakiviX/jASt7O5+8hX8lhJdQwpqiwe
 o4XPoho0GXX4ADOV6UP5HM0sGGHIZmgLSth+VoYA7NOscJ6NIc6vvK9T+2vNN+6j9m9BdbcFKBn
 qAP0Wv81rXYjkX1EJv77yn518y8hF1Vy/j/BVxOMN6zpDbU3c6ejVWcRMeBfgC7Ul5AB6O6e6v4
 025F2nQFzzqaeI9Il2eX62+YuwIgKhKTbPqvi2/bexx5AMwScOjm2XviRNyh9C5NrPSXEbR44Cb
 vZvQuHVG3eYdj8IgPUQeq/eV3A2EWTx8uYgy4F+8cPNRm3aqm6t1PpNtdlxcgPrf62CL1s3iivp
 l+O8/di6kWYgMp3ujYhzYaJSjd+t+QKnE5IJTLxERKK5PRQhCe4Jhxr1zNdmALNay3234760900
 zicm1kvz2dF9qR5zdsg==
X-Proofpoint-ORIG-GUID: hjA2j8GiHHOE3ie_Il9nOTFsM6XU5DGU
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDA5MCBTYWx0ZWRfX5RogEx4OFn4R
 7+7S640uooKEOCkQLq1ZYWdSP//AhyMb1S3RbRduOFLDgH8GUMEW5NshUJ6VRLiFx/YHfoPE5CR
 W8U1L5mocy4M6VNH5t7L2kaCT8rqrkI=
X-Proofpoint-GUID: hjA2j8GiHHOE3ie_Il9nOTFsM6XU5DGU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_03,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0 malwarescore=0
 adultscore=0 spamscore=0 suspectscore=0 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120090

Qualcomm Inline Crypto Engine (ICE) platform driver now, supports
an optional OPP-table.

Add OPP-table for ICE UFS and ICE SDHC device nodes for Kodiak
platform.

Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/kodiak.dtsi | 42 ++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/kodiak.dtsi b/arch/arm64/boot/dts/qcom/kodiak.dtsi
index 10e9a5279ed60cea1514097354b8f0f59ffca2fc..397764d78dba579fe95654deb7b01ae3b1735f89 100644
--- a/arch/arm64/boot/dts/qcom/kodiak.dtsi
+++ b/arch/arm64/boot/dts/qcom/kodiak.dtsi
@@ -1100,6 +1100,27 @@ sdhc_ice: crypto@7c8000 {
 			clock-names = "core",
 				      "iface";
 			power-domains = <&rpmhpd SC7280_CX>;
+
+			operating-points-v2 = <&sdhc_ice_opp_table>;
+
+			sdhc_ice_opp_table: opp-table {
+				compatible = "operating-points-v2";
+
+				opp-100000000 {
+					opp-hz = /bits/ 64 <100000000>;
+					required-opps = <&rpmhpd_opp_low_svs>;
+				};
+
+				opp-150000000 {
+					opp-hz = /bits/ 64 <150000000>;
+					required-opps = <&rpmhpd_opp_svs>;
+				};
+
+				opp-300000000 {
+					opp-hz = /bits/ 64 <300000000>;
+					required-opps = <&rpmhpd_opp_svs_l1>;
+				};
+			};
 		};
 
 		gpi_dma0: dma-controller@900000 {
@@ -2608,6 +2629,27 @@ ice: crypto@1d88000 {
 			clock-names = "core",
 				      "iface";
 			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
+
+			operating-points-v2 = <&ice_opp_table>;
+
+			ice_opp_table: opp-table {
+				compatible = "operating-points-v2";
+
+				opp-75000000 {
+					opp-hz = /bits/ 64 <75000000>;
+					required-opps = <&rpmhpd_opp_low_svs>;
+				};
+
+				opp-150000000 {
+					opp-hz = /bits/ 64 <150000000>;
+					required-opps = <&rpmhpd_opp_svs>;
+				};
+
+				opp-300000000 {
+					opp-hz = /bits/ 64 <300000000>;
+					required-opps = <&rpmhpd_opp_nom>;
+				};
+			};
 		};
 
 		cryptobam: dma-controller@1dc4000 {

-- 
2.34.1

