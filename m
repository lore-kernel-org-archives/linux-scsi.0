Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C05E25DAEA
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 09:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767085397; cv=none; b=UfjPAKBztn9Jh0mrU0i0S2ZY3zeV3R2Ft/hvxeFHdRFd32GyU90LPiKAsGq9UxfEm8MOq0/wPbyV9NUzsdFaBzkhvHiy5fI/uPIZUp81GKIFi/aj4us7d3Som63V8cEnTRno8TLXLTbJxXoL1XWxEnpeN5zDTH7o+b4eBRqbIFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767085397; c=relaxed/simple;
	bh=4GBCj0hU48S2+i+MhfdDptBgFyH3UUTZ8+HpufexFM8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W3AOPPL/oDkLB2ht/lyFMBevw/N1/uPSWtC4u0/GdFF89niJwAodwvkyDPCUAzgmCniozJ3w28ko+jilsTbEr7NVomggqtgIH4AjHvhvKRGhsR9vQLkT8RyoAFZlN2NmaoWZ2E/Xbr8D08AyAVWf9OFREWmzRIrsY+Skl5qUu+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GuHBd3YA; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jjOz7LqB; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GuHBd3YA";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jjOz7LqB"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BU14IGd3754196
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 09:03:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	DZ1ZUU929l28kU0e3CGefBDE6aEb96VXDtF+iVlBDlo=; b=GuHBd3YA/Jvc5Qp/
	hq/XuTVq0m0wQkwKecnV2wxcu3KmErUz1T1cqUUabjQ2dHM4MnWfxi1KW7BHNRE2
	37YQ/Kw9YEXKErrcXTSgktOMNhPaMW7RLv15yt4K0EihUGDokK7K7/DKHDXmnlxf
	XsKqidtNeGj7fWGPwCCiMfr9wx5gzfEbWIF5RTX4Og3/WoRE6WjHH7NaVLeOyWin
	0umS0myHLkf8G9HYhcqMMRiwHO6aCq2MrsB2yF9e+eJFfT1hDXdiQQ7Fy5bW73wz
	y0U7Jd+2vexuI9zyaNmanlh149ZkhRQ0hqbfVNIdmGj08cVWtIcCMz5TmddRWRId
	EV8bEA==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bbc8yv0dd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 09:03:15 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-bbcf3bd4c8fso5960626a12.0
        for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 01:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767085395; x=1767690195; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DZ1ZUU929l28kU0e3CGefBDE6aEb96VXDtF+iVlBDlo=;
        b=jjOz7LqBc9rBcINV5Lg50qYj4nrgnMGM9ZQAEkM+kS/LNhptHAn+btR87F/6bPEC3q
         tPjdh9apgwX2zkfN+w55xBWhdmTTa3qzRUl9+FYI72Xypu57KRHa6wOjqXfwyw40HtSh
         yTXR44VK+GZQgpwPfFIAaoflyCcv0jeYm36hSzDZ2lH1hogguDU46aiKOOLYgRNAkHi4
         N8Ll3bm+KnOy3WBKGTEyxUfUntiawpflWe4AS+pa/VMSp2wWr0w4j5XRSbm0y/AwOC6Y
         CEwxQn19Tih8a+WyA9XIFAuwNLmg3omjjhEUJjmF0icIKa1ZzegI8+j+LPEpmC6Z9NsC
         w5KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767085395; x=1767690195;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DZ1ZUU929l28kU0e3CGefBDE6aEb96VXDtF+iVlBDlo=;
        b=qdXVk7E211uTRDnioCETEn4g0RLIH8hw84yp1ZAySJ1DC5B68a93K9j3jORgtyNB+/
         QAKiiRlXvoAl+PgyqFjoo9RF7nDHTRPJh1ImCiXdUawfc5/UoteWKl1D+22E4wbyrV7n
         5fUvGk+/5tp7Ui8OvuaQvcTHXgsF3atdJfJ9vZMm/73pdFU+ME52jPXgGlMAB4QcyOye
         rDGxfOre5ZgzwsI3jist3OZuuDLAQrFrMV2KWbzdzTjaqurJdRTA8me9oVk/IFIuOj2E
         cD5vk1YSEw7bkeCTJ+FGkYeUQQ4pgPPIRdei1YOtIMpSxq0de2Pa8nw7GR3TvBroFV+y
         /fVA==
X-Forwarded-Encrypted: i=1; AJvYcCWv3y9mxFGCz2+pgP0epJ5ZIJ0h7Xa+ldmlpwL0BuOrzZC3Bq5iV8D8qul5UdJL96EMfaQd8Znsc4sm@vger.kernel.org
X-Gm-Message-State: AOJu0YxW+cfietk1hgtFGic7bqmzeW6FxkchljTVX986JPaz2yp+yScm
	UnGeG1bPzhh/fx+9rN98V/KS2CAKF1kpIx5f2Gi9twg6RjLWvDMLo+9kbrCds+15DvZMsPK9q+T
	h6nkJp9RfLOj5lhIsiKsFHuymdkCX67zffEjEopPNJVaKerR15SGd8xa0MvtwImLF
X-Gm-Gg: AY/fxX5CdX+B5vjR84uyCt2+QSwOTEidh3U3JsbgqHQoaz3RDCZ1Ke323QXdlAX1qPE
	bT84Yk6SIQK3q5AFa+B7ArhCru5D682QyBWdelahrdcWc9PKRmR9Y4mahyE5jslRPV0dCZG9U+0
	vF2qu4KBsoLiY+KkuNlwSE6lvHn5x8MAT4KRxc2/ZQMUPetQZK29W+zlRIqNUwiEnQu6XHy5rli
	CEbSF5bNnwBoOMtvfgpQGGoR7LT+Swi0AFNmxch4WYDi/lIdYekekY7If6V/Z2FRBu42byYamnA
	g2p5fGiLefXqbDCDe2q1jhf0eJKT1v2p1IWY3sPNzf72f7gCQuyH02UFDEV8aRDkMYfY/Mj4/Is
	qurW5J/kCcqJ9/bN2IJucRCLZt/My/XJG5OkoXcLZccCVNvl/ftI=
X-Received: by 2002:a05:6a20:1588:b0:366:14b0:4b18 with SMTP id adf61e73a8af0-3769ff1a89amr34483840637.35.1767085394479;
        Tue, 30 Dec 2025 01:03:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEbAGF2db+VKOhlDQMrg8j2Qk0RrNBOlo/z6NG5BVl4tukVcG15xd/QngN7ITvfdf94rAAulg==
X-Received: by 2002:a05:6a20:1588:b0:366:14b0:4b18 with SMTP id adf61e73a8af0-3769ff1a89amr34483814637.35.1767085393974;
        Tue, 30 Dec 2025 01:03:13 -0800 (PST)
Received: from [10.217.216.105] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e7961fbb9sm27338846a12.2.2025.12.30.01.03.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Dec 2025 01:03:13 -0800 (PST)
Message-ID: <28751331-d298-4cd6-b98a-c125e3f75eda@oss.qualcomm.com>
Date: Tue, 30 Dec 2025 14:33:07 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 3/4] arm64: dts: qcom: hamoa: Add UFS nodes for hamoa
 SoC
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, vkoul@kernel.org,
        neil.armstrong@linaro.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, martin.petersen@oracle.com, andersson@kernel.org,
        konradybcio@kernel.org, taniya.das@oss.qualcomm.com,
        dmitry.baryshkov@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com
References: <20251229060642.2807165-1-pradeep.pragallapati@oss.qualcomm.com>
 <20251229060642.2807165-4-pradeep.pragallapati@oss.qualcomm.com>
 <986facd7-92e7-4d29-a196-d49cd9f3d35f@oss.qualcomm.com>
Content-Language: en-US
From: Pradeep Pragallapati <pradeep.pragallapati@oss.qualcomm.com>
In-Reply-To: <986facd7-92e7-4d29-a196-d49cd9f3d35f@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjMwMDA4MCBTYWx0ZWRfX1gpHlLCnOLzz
 3gnTkJkswxWaB/yeRgjh9c2ykNU2GxxgYmRZcH4rQ0oYkdPNhalflws6b9VA3E+17tKLMkmgulP
 ZAgGh9CGfGAF9DM1T4LVj57aAjMaTrITebwpdZMV/fSNzOBE3N5omGbCQTw1H3onFKAnOwQgUjL
 G2g2ORxvvdQRXR57DuwLil+QRZhZ5icID1hoEJh1KoQljpeDd6JAPo7cWoNvf5NtQZYrpAN2ilg
 7iYP6JW5aXd8acnn4JxwSLyHmBb5TBlDi3p9pPBTWk+CiiN8F2/QtO+7rGkW7YcxO102jn52RJb
 aR020BWg5jz//b9Hd3qJ8RPns7A8oUZxbArHtlhjC7ugrZpY1+kIEZBe8NAA1G6hk4H7ztrcWPl
 lapw2YVIGHM1IpGK5JTQ4LrfSvEcuyGo7It2xw9BNhwknwj/4QIUVs1a086mCh19n96Bce0Tyvi
 UxdQ/w2ZjBKOdUfmArA==
X-Authority-Analysis: v=2.4 cv=cP7tc1eN c=1 sm=1 tr=0 ts=69539553 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=XVHmVgbNHDG9-czVeNYA:9
 a=QEXdDO2ut3YA:10 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-ORIG-GUID: qR-lqPwdSNgY6Q2Bx3HjdeKUJhk_X1F5
X-Proofpoint-GUID: qR-lqPwdSNgY6Q2Bx3HjdeKUJhk_X1F5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-29_07,2025-12-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 impostorscore=0 adultscore=0 bulkscore=0 suspectscore=0 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2512120000
 definitions=main-2512300080


On 12/29/2025 5:45 PM, Konrad Dybcio wrote:
> On 12/29/25 7:06 AM, Pradeep P V K wrote:
>> Add UFS host controller and PHY nodes for hamoa SoC.
>>
>> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
>> ---
>>   arch/arm64/boot/dts/qcom/hamoa.dtsi | 119 +++++++++++++++++++++++++++-
>>   1 file changed, 118 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/boot/dts/qcom/hamoa.dtsi b/arch/arm64/boot/dts/qcom/hamoa.dtsi
>> index bb7c14d473c9..340b907657be 100644
>> --- a/arch/arm64/boot/dts/qcom/hamoa.dtsi
>> +++ b/arch/arm64/boot/dts/qcom/hamoa.dtsi
>> @@ -834,7 +834,10 @@ gcc: clock-controller@100000 {
>>   				 <0>,
>>   				 <0>,
>>   				 <0>,
>> -				 <0>;
>> +				 <0>,
>> +				 <&ufs_mem_phy 0>,
>> +				 <&ufs_mem_phy 1>,
>> +				 <&ufs_mem_phy 2>;
> This patch cannot be applied as-is (needs GCC bindings changes first)
> which you didn't mention in the cover letter.
>
> If it were picked up, we'd get DTB valdation errors.
ok, i will mention the link to GCC postings in my cover letter in my 
next patchset.
>
>>   
>>   			power-domains = <&rpmhpd RPMHPD_CX>;
>>   			#clock-cells = <1>;
>> @@ -3845,6 +3848,120 @@ pcie4_phy: phy@1c0e000 {
>>   			status = "disabled";
>>   		};
>>   
>> +		ufs_mem_phy: phy@1d80000 {
>> +			compatible = "qcom,hamoa-qmp-ufs-phy", "qcom,sm8550-qmp-ufs-phy";
>> +			reg = <0x0 0x1d80000 0x0 0x2000>;
> Please pad the address part to 8 hex digits, so 0x1d80000 -> 0x01d80000
>
> [...]
ack. i will update in my next patchset.
>
>> +		ufs_mem_hc: ufs@1d84000 {
>> +			compatible = "qcom,hamoa-ufshc", "qcom,sm8550-ufshc", "qcom,ufshc",
>> +				     "jedec,ufs-2.0";
> 1 a line would be neater, perhaps in the node above too
sure, will update in my next patchset.
>
>> +			reg = <0x0 0x1d84000 0x0 0x3000>;
> Similar case as before
ack. will update in my next patchset.
>
> lgtm otherwise
>
> Konrad
