Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67436480DD8
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 11:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791373243; cv=none; b=W+kMSGh3NmMfKogqvHgebWtJEyyz6Udt7iQh4n5ljBS/kTqcI6vo+GuO4blJOczu+1PSdnIVkw9ySEKMRPoLEaVrvdWkDnu7Dvg8A0re6/u1Q+60VCLDGrqW9X+/0Q79iC5Xb9+JmJRrXvMiJWN7n+xD1xK6Y2AXnpaQNB6tRvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791373243; c=relaxed/simple;
	bh=nkLPdIerbmqgOkiClXOYtAKohjRk+Y3ovsmMqzd3zDY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=spRgVoij2vWG6EWfR0g86Bg9D0kVZo7MAw+pMDsEs4OpEQeFyshAFwtFWk7CtB4qXrf0Rq8HuwG+zJMsg+saS1vL8QRW8jwHMf+aSBe56uDPG0ic74xFN9hwE47Qp6ljvQFvilog0Dff/v9yRkq6WJuj1wVJ6tcBcmXD5MyuO90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pMcmnHyo; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dy6EncTe; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pMcmnHyo";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dy6EncTe"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 697BVCYO3198240
	for <linux-scsi@vger.kernel.org>; Wed, 7 Oct 2026 11:40:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	jWsxroNby4qfMF5eUhWMwzBrpIDo9NyJ5QpYk6O3kDg=; b=pMcmnHyoA5U6lGin
	jgOvmzefdWqpj6lQe/3mFnQUciKpNppaaejO4+CQ0VZJgFTE2xqenoJStvujMCoB
	JRka/M3AgeV8PrDf9eE9fI7ao2Wt6t0m4jwrxaevg8mRujCCU7G1kq7a78VAYkJH
	CzSZgj637rI6UDQ5TTAonkdQGJf2zD5G8KvlmB8EASeoqD1oYjkWfTBHALEtMCiA
	4hJcaql0ksOrslHsodQTFVk9n7Y8P1aP+p7pN5wMFsX3ovbKmcjokuvk0a7IKzOG
	L0fLnQGVqOa0HkR8CRYU2jfmG2gCud+JDxtbC+Tpe7LnaklZNJiGdqxUP4u2OV7V
	LruWIA==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5c1s1wfm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 07 Oct 2026 11:40:14 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3a4f7eb79f2so4021475a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 07 Oct 2026 04:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791373214; x=1791978014; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jWsxroNby4qfMF5eUhWMwzBrpIDo9NyJ5QpYk6O3kDg=;
        b=dy6EncTedFbvAboVgy1JhE1W/1RefAYyOplGaQt9qSFKf6YGspg55GivWvuewqglXN
         HgjLnhMbKTwuG2grPdcEDP+GHz8HbnP7+7zVht8rYByIqXj0zF59GaBXcCiem85qoScT
         O5oApKOtQfidYMD1JQ5aGb+2GpyFnJoP7ZJ0l48QsvPWrsL+IAgsuWKiKKrUMOufXjjc
         pclRwtPDlOVAuZm3k6h18IMDLxISRa00WjR3dEtF5aXzDk1z745k6C/cgRL2HSwVImq3
         RsQAwXerYAKSOI9muhHHr8WiJ3wb+rg+vyonD6KJPONcOkVvxLKKLe9rRxwMG79PB7AI
         MZqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791373214; x=1791978014;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jWsxroNby4qfMF5eUhWMwzBrpIDo9NyJ5QpYk6O3kDg=;
        b=dZf+VvBTuna6IK8eFA+VPZnLaE9QJ7ZaF587VAXaZKTpeJWUxP52rQQi1wjg9khKBu
         bJBGg7DR3phR97BLJ694t3+j4ftatdDHg3pc2aovy/SX18kL7Yxrj+o4GCqBG9SxGoLp
         blGmIPPH1pKCL9/J8rT9EfMoyfGc2IO6BhLnhU2bem3WIw+BZO6GEaao2wrtnJ9W6D6F
         Som2UUxcFv/CNIuN/HCAr5pcBYVaRKnl1AZRACTSoDdoV1yBYHEm+aTSTcy53GKB7Hcx
         YWehHgf+Bdt3WM908A5Gr+T4GqwBBAA4uIEJYXXaUFCDJqClmQEt4ww5o9Or3PbeLhGu
         x/rg==
X-Forwarded-Encrypted: i=1; AKwUvBxEIyhBTpFcJSiTwPLqeBBakRkW3uhJuYzlHTgEzG6IuvysKgT2+dopBI79Y0pClr0Y6VOEmNJcidYu@vger.kernel.org
X-Gm-Message-State: AFq9FYKt1I1wBhKizVdtlNx6e050Z/1xCLP2KMrrBKFm20rfwBZYK9gR
	LjhR/XNfLbugJp11UzdFlvyo7DMm6BhMNdmn4HoQM4c3Xc4Qi67oO2Fv2Tb0WO9BNy8g2+fZJ/u
	wZIROek4SM3sNhBLE9rFLxCfshOtY302HGHJx0k9xxzQUUukFEZ6GONYrJY+LShis
X-Gm-Gg: AYBFou19uV0asJ+60lQrUN6Y/TiNUs9fUytjkfG7+Gn/MeJAoMOMWMPckL59YXLN0a0
	gIa5NVPUGJClGrfTqc15hMZNJGoraKBpk18RH7Ek6MYNiMcWh180xtxfEibFYnAytlgil4UqkwL
	7IC+EE6IV+fNdgMDugw4+YqPnmprIKBMhQzauUxtzatjema+bX9GV8kFr+IR5bQbXsOiUAosR9M
	rq3cpitiTR+VMI95debyJIIdOyXVbZt5l59RE1LIG+StVyVj11JtufziIkdbadSdw1l/qGNDJCC
	oX8yIdMqi5lbcM+53CqyZsZ4aIVqIKKfDBC/CAdhUCQLA/WSohy2cuVV3yEBaApDqLNPmelo8Sy
	yeiwRXh90WOW0nT9gAPEmNOFyggUFCLr2GTiEBA==
X-Received: by 2002:a17:90b:3c85:b0:3a4:c8d2:6c0f with SMTP id 98e67ed59e1d1-3a8a1187ecamr1280973a91.45.1791373213821;
        Wed, 07 Oct 2026 04:40:13 -0700 (PDT)
X-Received: by 2002:a17:90b:3c85:b0:3a4:c8d2:6c0f with SMTP id 98e67ed59e1d1-3a8a1187ecamr1280953a91.45.1791373213360;
        Wed, 07 Oct 2026 04:40:13 -0700 (PDT)
Received: from [10.218.41.37] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8533abe0asm9816087a91.1.2026.10.07.04.40.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2026 04:40:12 -0700 (PDT)
Message-ID: <88225357-eefd-4d44-81ba-da965b4790f6@oss.qualcomm.com>
Date: Wed, 7 Oct 2026 17:10:03 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/5] arm64: dts: qcom: glymur: Add UFS nodes
To: Pankaj Patil <pankaj.patil@oss.qualcomm.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: Vinod Koul <vkoul@kernel.org>, Neil Armstrong
 <neil.armstrong@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@sandisk.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        gopikrishna.garmidi@oss.qualcomm.com, jagadeesh.kona@oss.qualcomm.com,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        Abel Vesa <abelvesa@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-phy@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        nitin.rawat@oss.qualcomm.com, sibi.sankar@oss.qualcomm.com,
        Taniya Das <taniya.das@oss.qualcomm.com>
References: <20261007-glymur_ufs_qcb_enablement-v3-0-84cf4f861415@oss.qualcomm.com>
 <20261007-glymur_ufs_qcb_enablement-v3-3-84cf4f861415@oss.qualcomm.com>
 <a5p5gszuadvnvqcwffg6y55khdfhacwhegaxmmiwm72sfid6ex@cdwuo6sdmkgy>
 <297690cb-64d8-4e7d-9d97-66680f6a2b99@oss.qualcomm.com>
 <c5f4e404-c03c-43ae-9785-7be1d8b25fe4@oss.qualcomm.com>
Content-Language: en-US
From: Pradeep Pragallapati <pradeep.pragallapati@oss.qualcomm.com>
In-Reply-To: <c5f4e404-c03c-43ae-9785-7be1d8b25fe4@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: np6cs526tXMb00S7E1zZlZ6NbIrV66JI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDA0NiBTYWx0ZWRfX0veJI/ryur/0
 zUlS0dg4oHd9zhmjImKChECAT+xixTCHEwEJFxU2FSyASUBb2xkyO8vhDUkkkAuNjgVcr/tiwjw
 ytVCJWSE9uyL8y1yYC9U5molsAyo1UmbNhEEUbIhY4QABWtwCHCmSR87e7YIv7/0BcWFdyUf3SL
 gn5mBuH7K2yrGwGOT+r6+YBnhulcnognQm4jF1Ow/mMeecwQdd1ZALsk66JebX9tTL8bxn/FyS0
 CCAiCccYa6eP3q58AXuamtoO8gejWiqhgrY494fKrdkV2Z1hiQOez2KdIXYDyUoKhsoZnjpMAcS
 6mCWdmJkzCSS90Ir700mQYA8fSJicJIC9tu3wZmpB4b4Km94v7WnzMKTUezVxeN4eyv0scu2IfN
 CMouVHDOI1hxH/Eoge2AkGtAHlg2ohPZRb+1ey6kX6yHl60rdzNMRL0W25f0Yti6Higm+dZgWNS
 vvZOYCra4K8CzAMESIQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDA0NiBTYWx0ZWRfX0nsMvncFayF6
 hAq5mKTkdQU9cr/wbLSpEpDRz/JZJQgOBBsjmz5gvrpoHwGAB7krg63oE7EnGBcZAGhK0jQEg/4
 TSA8BnwW24SoPteB9N0NoX3C77/HcbY=
X-Proofpoint-GUID: np6cs526tXMb00S7E1zZlZ6NbIrV66JI
X-Authority-Analysis: v=2.4 cv=NatzRGD4 c=1 sm=1 tr=0 ts=6ac62f9e cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=P-IC7800AAAA:8 a=EUspDBNiAAAA:8 a=gawzJeqBqYZ62S9bEcIA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22 a=d3PnA9EDa4IxuAV0gXij:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-07_04,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 clxscore=1015 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610070046



On 10/7/2026 5:05 PM, Pankaj Patil wrote:
> On 10/7/2026 4:30 PM, Pradeep Pragallapati wrote:
>>
>>
>> On 10/7/2026 1:13 PM, Dmitry Baryshkov wrote:
>>> On Wed, Oct 07, 2026 at 11:59:36AM +0530, Pradeep P V K wrote:
>>>> Add UFS PHY and UFS host controller nodes for Glymur SoC.
>>>>
>>>> Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
>>>> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
>>>> ---
>>>>  arch/arm64/boot/dts/qcom/glymur.dtsi | 125 ++++++++++++++++++++++++++++++++++-
>>>>  1 file changed, 122 insertions(+), 3 deletions(-)
>>>>
>>>> @@ -4102,6 +4102,125 @@ rng: rng@10c3000 {
>>>>  			reg = <0x0 0x010c3000 0x0 0x1000>;
>>>>  		};
>>>>  
>>>> +		ufs_mem_phy: phy@1d80000 {
>>>> +			compatible = "qcom,glymur-qmp-ufs-phy";
>>>> +			reg = <0x0 0x01d80000 0x0 0x2000>;
>>>> +
>>>> +			clocks = <&rpmhcc RPMH_CXO_CLK>,
>>>> +				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
>>>> +				 /* UFS and PCIE4 share the same clkref */
>>>> +				 <&tcsr TCSR_PCIE_4_CLKREF_EN>;
>>>> +
>>>> +			clock-names = "ref",
>>>> +				      "ref_aux",
>>>> +				      "qref";
>>>> +
>>>> +			resets = <&ufs_mem_hc 0>;
>>>> +			reset-names = "ufsphy";
>>>
>>> power-domains = <&gcc GCC_UFS_PHY_GDSC> ? Or is there
>>> GCC_UFS_MEM_PHY_GDSC, which is simply not described in gcc?
>>>
>>> If there are none, it should be reflected in the DT bindings, together
>>> with the explanation in the commit message.
>>>
>> Yes, Glymur SoC does not support UFS PHY GDSC. Sure, i will update the DT-bindings accordingly and include the explanation in the commit of next patch series.
> 
> The support exists? I can see the gdsc in gcc-glymur.c
> https://elixir.bootlin.com/linux/v7.3-rc5/source/drivers/clk/qcom/gcc-glymur.c#L7768

This (gcc_ufs_phy_gdsc) is for UFSHC but for ufs phy (gcc_ufs_mem_phy_gdsc) the support was not present.> 
> 
>>
>>>> +
>>>> +			#clock-cells = <1>;
>>>> +			#phy-cells = <0>;
>>>> +
>>>> +			status = "disabled";
>>>> +		};
>>>> +
>>>
>>
>>
> 

