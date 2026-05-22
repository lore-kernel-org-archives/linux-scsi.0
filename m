Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4BD405840
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2026 15:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779463118; cv=none; b=Sp5S2Y5QURyTMVDP+3w7SpX3V2AD8zBA7xOcLrM8i+mM1OcGAna8OrefOph/bF/GegtHtBGKY4RFWYanZMNSGbjW8xpQiN0IdG+WsvMy6OCRde8DghuoyAq6TeN1Z0eNnS94AZt5tfl4f1ZkCXnroE3xlg3sTrHg6ER3iDf8bRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779463118; c=relaxed/simple;
	bh=ghSsUzXL6mQt9R7pPAb0Q7x6xgkE7K8eBHRojIg7EMQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I6YJe5+5+gnI9aK+xEDPXxLWgvr00Rjz7QAjvhbVkXMQzMPmBnontomKRT5NTCdn19oPTEuuwaH14y5ImkbiguxyhDpgFv5zvMyKNI6bgr2oEsLamlD/wYeicFKBg5hR2YO5GhdOISlFUbg/BO7G3Q2XRLH5Ae+gB9Vv8c3maHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TSG/Aq5Z; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=E26Q01lY; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TSG/Aq5Z";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="E26Q01lY"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64MEhFJh399343
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2026 15:18:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	g9xwrB635o2Tco+xITvF9/6o4dCfeeIrZ/2XNZN3wKc=; b=TSG/Aq5ZLHvsdsHD
	uddgC4ytLcmrJ9zxb6CWJrl/4JCe0eOAsgxWUSU0h38S0G2YRxhVtVrsEqngZVhx
	qIvT2NJ61XDgX93Kfy2JyAZLFHXmsP5nGvRXb60wofLA8iContnb3ZChpgRjAkr6
	gIwzGb0PH1CpIh6LjoFQn5zquOrW5noolIh0y0TjLzoBtDiym2FDQKivU94urFhD
	0r7JQSjBOdMo9Qd2iTx24aBMJssbwHr9c807cvkU2wMHdNS3oYYSlaNMQdBGgajD
	kWRCE8cnV2IrpAWO8VGT50HibeJ3bbb+3Vk8TXkUEMuth/TJp/yzf6aQt+IteVf0
	4tnuBg==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ea5p9w10j-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2026 15:18:29 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2b2ecc96a9aso83883345ad.1
        for <linux-scsi@vger.kernel.org>; Fri, 22 May 2026 08:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779463109; x=1780067909; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g9xwrB635o2Tco+xITvF9/6o4dCfeeIrZ/2XNZN3wKc=;
        b=E26Q01lYfjqdpOo5MbbxqE68n2pPZKF157JIkqa3X6KcLfSYFnUN3JXwcgdlRoi2LG
         3YH0hE3AYAIaG+C5EFC/zYyCCsEQulXxk2p3V+kzaLVEG+628uqsv+4OabPZO+aadCUV
         6Xo5zycFZRU50CZdb1ovCiyedLsXECOjstBnOe/pIRdXKEltpGkBYiGAiUkk7wfZ9rOe
         uukIyWljaBHwNUF+jOZd87dlHoDJSm8GgEiqj0iJY74ZA10Sv4juzCZ0YnJw4HPF02EV
         o0Hv6QLQyB4WuPWfFUOaTxxpzRsAGwm5fzLxQDziWu9fzmnGCXP0du9pPogKYI0vu/HY
         +6kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779463109; x=1780067909;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g9xwrB635o2Tco+xITvF9/6o4dCfeeIrZ/2XNZN3wKc=;
        b=ErzqsNGxuYIFgb0Dujsu+ay8gAJaVPu+WBx0aUS2JZLUrjZL1xWpQlLwfaKgYyEZTM
         wGrLzyWoyd4Q0qN2jElP3qzzsKAeyWJe5+PylNomKxSrQiV3U6YoMuE2TsJeE0MNpKv9
         sNUz0RYgSKduvGPp66lYJTZCaW/9HQyvhTtcRmxrLzeJZ2LVG6jIZ7YZ441qlajjqV5q
         9RguSakcQ0e8po/hI1WgesMzBoOOjVIhCe88d5Pn6k9aHsfHI1mIBmaUkFu1qeCCJYWE
         wZLhQFd78jTN3mEoAGNfmwd/jl7g1ZGNjS2x5uYsMwYYttj5SbWytnowFiJeA/9pec9O
         oB4Q==
X-Forwarded-Encrypted: i=1; AFNElJ+O0y3zsNYKGYMdmDrC48lCBINmuKiyXzCnGA5Q37I0jqOAQgz5CntcjgHZagRdc4RwLZU9nO/2gRop@vger.kernel.org
X-Gm-Message-State: AOJu0YwTSDK2+74a7TE539gV4qrSPruxJfN7Eci4sPh94B8tUFvJuYR3
	v6I7zm3Hb1zsFni22QU85WlPYCnybYqIoYQxDm2RQJj8W9b5NfzMOvdtDCl+d0/5xqmHEquhqs9
	XYWTHr+aNTeZ89UjLr4D7odFEytRGXPRcflb4r9QKywg0KYpnt//z1vIhcIlYk0F0
X-Gm-Gg: Acq92OEuCFAgPDTq4H055FGxDF/Y+ebPwt1+BC9X4ePgxL4vPu74alNx119TgyOmQpi
	TZwD4fWrzZz5h6zAQt3vvMKXNOhepKptSPeeSy6gFhY6fuy7oP8r+Xj6lLkbMGrmxqCwF36VMD0
	I7YprJUBLYtr0qn5vvNRmamgN2TVQ6xx2uhqcjqcfcOfkPaOuEKzHDdE57vuD7IuPKEZSJst/lM
	6O1DI09A6eWxOCigiB8MgmatIWzoY7/TyW4pniuEhY6yAhfkJ94rUdit9+u0TRmZFmSbnymV1YN
	F3dwpU6b0OZE2bwJlOsGU0T1WjbEnR+fKh69M2fKZFt1BA2ltlELKS4i00dRd9AxcN9jblUPKVj
	fLlCUbmDIeSBLQgYBY3zeDt9TgS0AcQ0CgX908swhJbs+AtZlUZiSUQ==
X-Received: by 2002:a17:902:e885:b0:2ae:803e:6c12 with SMTP id d9443c01a7336-2beb069c435mr44303105ad.6.1779463109028;
        Fri, 22 May 2026 08:18:29 -0700 (PDT)
X-Received: by 2002:a17:902:e885:b0:2ae:803e:6c12 with SMTP id d9443c01a7336-2beb069c435mr44302585ad.6.1779463108467;
        Fri, 22 May 2026 08:18:28 -0700 (PDT)
Received: from [192.168.29.82] ([49.37.133.141])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb5695b2esm19652165ad.4.2026.05.22.08.18.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 08:18:28 -0700 (PDT)
Message-ID: <e39b9326-1c19-44e0-8d3f-a299ddad22c9@oss.qualcomm.com>
Date: Fri, 22 May 2026 20:48:21 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 1/3] dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Add
 Hawi UFS PHY compatible
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org, andersson@kernel.org,
        dmitry.baryshkov@oss.qualcomm.com, abel.vesa@oss.qualcomm.com,
        luca.weiss@fairphone.com, linux-arm-msm@vger.kernel.org,
        linux-phy@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20260518165346.1732548-1-palash.kambar@oss.qualcomm.com>
 <20260518165346.1732548-2-palash.kambar@oss.qualcomm.com>
 <uut3u6djc2dc23aznjxdqvkehpx3ooa7eknzjzubnlmylwvxxb@aow3lpjurhnt>
Content-Language: en-US
From: Palash Kambar <palash.kambar@oss.qualcomm.com>
In-Reply-To: <uut3u6djc2dc23aznjxdqvkehpx3ooa7eknzjzubnlmylwvxxb@aow3lpjurhnt>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=DKm/JSNb c=1 sm=1 tr=0 ts=6a1073c5 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=p6nWuE1qLcVxvtXth5uE9A==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=nJdWcSulx8WbVkVVkBoA:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-GUID: D7XWe2j0_7bc-vLTZPXi0NTc_yC5CsFA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDE1MiBTYWx0ZWRfX7jmUFiNK/3du
 5HO6VFLTDB6nEZ7XZAfdQAnDFiOlaouuzdrhIgKlvLJ0j2aLbRsyyeRtjbjoOnNP3RjOajxwWot
 8G4maFT0FZgqk9wHLnj8X05ESSrS0YYqnq8fF8Vo0Y5gSskr1wS1ySrt857BGFje4W9zOJjlhGZ
 Ni/9HPnpButbBijVmIgpMay8kddKEIt44DodgLWVOx6295eYIefjYVJY1KOVeI0P+05wjSjDb7z
 EeJ2UUnC0QW3vEEgGdFpw2Y4PyIaZVCGQ19TB97k+tcrkYOOcs4qzesM+6FZmQjUrhHUh4Xo9hM
 W/uZ/VF6yUzfb+tKtu79Jg9vz0DT2Qp5qM+PE2ArZPQg1SXZR3LgPwTSBXUjeMS17JeK5c/L8mb
 2bMMkNQoejriinC/E7GmPgOpO2W8rBfTXZKRFb+22NIdVlSC9PuUVajR3ofjtQF29lEZxSJbH3F
 CrUi6H9y4SHb6SrTOgQ==
X-Proofpoint-ORIG-GUID: D7XWe2j0_7bc-vLTZPXi0NTc_yC5CsFA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-22_04,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 adultscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605220152



On 5/19/2026 11:35 AM, Manivannan Sadhasivam wrote:
> On Mon, May 18, 2026 at 10:23:44PM +0530, palash.kambar@oss.qualcomm.com wrote:
>> From: Palash Kambar <palash.kambar@oss.qualcomm.com>
>>
>> Document QMP UFS PHY compatible for Hawi SoC.
>>
>> Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>
>> ---
>>  .../devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml       | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
>> index 9616c736b6d4..2326dcf38a46 100644
>> --- a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
>> +++ b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
>> @@ -37,6 +37,7 @@ properties:
>>                - qcom,kaanapali-qmp-ufs-phy
>>            - const: qcom,sm8750-qmp-ufs-phy
>>        - enum:
>> +          - qcom,hawi-qmp-ufs-phy
> 
> Don't you need to add the Hawi compatible to the below check for clocks?
> 
> - Mani
> 

Sure Mani Will update. Thanks.

