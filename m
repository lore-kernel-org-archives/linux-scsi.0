Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F93212C499
	for <linux-scsi@vger.kernel.org>; Sat,  8 Feb 2025 01:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738979008; cv=none; b=TL5pAk6pNWniEu6TSSgVuGYq0T5lg+HT/64R9L1a72A0oorIPe6QkJ4CtOsya6uqNGIvTTfXTy8iLoIQJC/O51dSGifuiBkEnsK2XCHqq7PhrYboBPC4BkYDzGuF11c3VbJF6quSPPqDU7F38fOKTH2VHJdTCLmN9+ZzVKMo5r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738979008; c=relaxed/simple;
	bh=8KOc8TEtPMV6vPScInXgKUCKf0lxAqvOCy5Faaq1d1I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MLJxscy3FsEJvvTZrlzif7qYuKT1Iqymkp0iPBZ8gJMNaO1SsXXTb1JSicX6PWKEbW0x4lIVkpFCOrvSp7Oj9acL4vWBhbQ+EQ3YPm+pmDFwtCQqC3Po+r3ghidaO9XhPTZasfQvjro9tuW4Mdtcehei7GkwatowEtjit0V9GFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZMVwTL2L; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZMVwTL2L"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 517CYuOk008308
	for <linux-scsi@vger.kernel.org>; Sat, 8 Feb 2025 01:43:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	uvl2a0j7vqsq5LA3kTdIeYd/weJt9uMnmK28HOLRjek=; b=ZMVwTL2LkACuACMy
	ygKp3yW7CTUwiETtROhJy1HJUozpmgXNUUmgzvu402fofhhXAr3pG6ToO3GZbMB+
	alcJaTXvhr0VKr+MC3iI6nxwUrSBUHMa/ToyIlzVWtjyy9iFfDbO9prOa7sDEJ5q
	JKAyFsaX3Lnho06J2tlJh86hzqfHIaYyTHi94uHS9FlxBfIJd84Pceie5+itI16o
	zqJ9mrIxd8rdKBoac1w9TJl2cvFunfELroOQrtVZNrspGu/aQDlmGchmdBxdJAct
	ZmHYSAsKtmH0AV4AfNm4EnQcyfhlxVo1jlMKUoAuLzTGOM8dGb1/6VZYxPcPcbB+
	isOj/g==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 44nja3sn64-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sat, 08 Feb 2025 01:43:26 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7b6fee34f95so34754385a.1
        for <linux-scsi@vger.kernel.org>; Fri, 07 Feb 2025 17:43:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738979005; x=1739583805;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uvl2a0j7vqsq5LA3kTdIeYd/weJt9uMnmK28HOLRjek=;
        b=ubG7RVHiLPih6384XbzuibhzYKq5byv3wyE6wNAZxJCzkqvLq+HmX2vAJKpyidzgVl
         9PZyYVQQAwr3kB4jYF/9KmrorKYhAXnce3Lnif/CG/lwo4JqZbK9bqBTKOUmXTYGoqYx
         i6Yn01msOKb0w7o/YQUFsX15ZWaW7Udq2J0vkpYs/ax1CUrpquxSHGF8mkkLbn6XnHAM
         ID7RHgo/KhxwNXgnzt7qWvdf04LQHEsap7oJlXGCvDMSpg93nNCoJfUuX6hRVQaM78ig
         kO2vZVyO0MchuMLDYXdGeRTDsTTJBpwPspm7dsfbkX1PwN14dsJPRS5IC6PAqJzOKPzT
         zVJQ==
X-Forwarded-Encrypted: i=1; AJvYcCXa3XSZjJlRruQwxrBeTDAyt5X5En8VjFqWmQcxjkfama7dI8c17mssJytcwuzOfdlrBiIvHtBdXdH8@vger.kernel.org
X-Gm-Message-State: AOJu0YyVBQnBBxuhdsxQ9doMydQGoa+lG3A0v4vpIlZPYgROHoudmNGq
	s8nrhbCXKjjZZ4Aa/08IkMm9JpSQKUS/BzHuA8fI23S6fZDm/+5WaZ6aiWnD0g9J0avqNO7WbRC
	7Nw5q+W7/Ij1di2UCDZ89loCH9CWVan9dUL3sqjVtuxmvPKHgdcJusLzVCXUm
X-Gm-Gg: ASbGncv+K+wHxUzTXLgYiJflhAcBXuKeHjBuWQutsz9PC/mOymn1F3D504cpBzKty2W
	sxl4eL94ClWgMNZsWCmSROPtkWeBWw784PpcmHO7S6VCEGQpHCUTbr0B8CeFoFaVOq102yMNhHc
	VjlhXyHlEhvU9k0HHkEtgi+vetEoKu9X2Vwh5XM8BuaekBxHN5O3+UakdhR6FIRblsmmd6H/hv2
	Q+lYqTE8npQR/tu3TyPEw1e3Q/VEyIH3LCj8UDwABVi618FAt+M+Gk1krhJsSWkgfnyjN+QNOpv
	3C/YjxZKT4w0pViv5P1v0asLLWmzVHhZOwa0fQJ5n8V2x8v42wJibH495EE=
X-Received: by 2002:a05:620a:318e:b0:7b1:3bf8:b3c4 with SMTP id af79cd13be357-7c047afc65fmr327771485a.0.1738979004740;
        Fri, 07 Feb 2025 17:43:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH8UTS+vVH26H8xLRB9dyiuCt4iajAYis4LHIkOKK04eLWDXnRv19j6gDsEybLesd/OnD2ezg==
X-Received: by 2002:a05:620a:318e:b0:7b1:3bf8:b3c4 with SMTP id af79cd13be357-7c047afc65fmr327770685a.0.1738979004410;
        Fri, 07 Feb 2025 17:43:24 -0800 (PST)
Received: from [192.168.65.90] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dcf1b7b0a2sm3418731a12.22.2025.02.07.17.43.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2025 17:43:23 -0800 (PST)
Message-ID: <9368eaa3-f1f0-4581-9f18-24c2a6f8f5b3@oss.qualcomm.com>
Date: Sat, 8 Feb 2025 02:43:18 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] arm64: dts: qcom: sm8750: Add UFS nodes for SM8750
 SoC
To: Melody Olvera <quic_molvera@quicinc.com>, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson
 <andersson@kernel.org>,
        Andy Gross <agross@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>,
        Satya Durga Srinivasu Prabhala <quic_satyap@quicinc.com>,
        Trilok Soni <quic_tsoni@quicinc.com>
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, Nitin Rawat <quic_nitirawa@quicinc.com>,
        Manish Pandey <quic_mapa@quicinc.com>
References: <20250113-sm8750_ufs_master-v1-0-b3774120eb8c@quicinc.com>
 <20250113-sm8750_ufs_master-v1-4-b3774120eb8c@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20250113-sm8750_ufs_master-v1-4-b3774120eb8c@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: IZpiqmvycGGoZ9xyzf8jiGApr_bokHmr
X-Proofpoint-ORIG-GUID: IZpiqmvycGGoZ9xyzf8jiGApr_bokHmr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-07_11,2025-02-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 clxscore=1015 priorityscore=1501 bulkscore=0 spamscore=0 mlxscore=0
 impostorscore=0 mlxlogscore=891 malwarescore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502080010

On 13.01.2025 10:46 PM, Melody Olvera wrote:
> From: Nitin Rawat <quic_nitirawa@quicinc.com>
> 
> Add UFS host controller and PHY nodes for SM8750 SoC.
> 
> Co-developed-by: Manish Pandey <quic_mapa@quicinc.com>
> Signed-off-by: Manish Pandey <quic_mapa@quicinc.com>
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> Signed-off-by: Melody Olvera <quic_molvera@quicinc.com>
> ---

Please also add this bit:

diff --git a/arch/arm64/boot/dts/qcom/sm8750.dtsi b/arch/arm64/boot/dts/qcom/sm8750.dtsi
index 3bbd7d18598e..1f79f2adb0a5 100644
--- a/arch/arm64/boot/dts/qcom/sm8750.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8750.dtsi
@@ -532,9 +532,9 @@ gcc: clock-controller@100000 {
                                 <0>,
                                 <&sleep_clk>,
                                 <0>,
-                                <0>,
-                                <0>,
-                                <0>,
+                                <&ufs_mem_phy 0>,
+                                <&ufs_mem_phy 1>,
+                                <&ufs_mem_phy 2>,
                                 <0>;
 
                        #clock-cells = <1>;


Konrad
