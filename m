Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE35B27FD4A
	for <linux-scsi@vger.kernel.org>; Tue,  6 Jan 2026 14:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767708712; cv=none; b=tsfzFIuQ2jrenYcfAyVVuE4Nz4CGg+dr6k+tZVN9wbSlj48D/De7BxMDXIhvDbxxiPR2P9cOvdmqR5cBjZ3WN1VDkxmKmGrDO/+z8JAcia/bIo653VMsju/W3Oh1AVrCC0bzXE6ZafGHpCTJoph/RGOkh+om6tRLh9chM7msWUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767708712; c=relaxed/simple;
	bh=CrRAiIbO/vVnAvGROcns70SoLhi/4G0NRfHWFjMslls=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cJYlr7/epuDYp0X4kfM+hYORdbCe5PT+ODQXfMjWgy2KHKOb7U2U2k2SRWqoTV8N5Ai38zHKCuRtJGYZRLATKGyVhpiqpHSpPAVL4mrru412qHrYHJP2J8sRXwi1gIKRH/3oxqJ5adhYFtsgLCr9a1JVtqjAYXyNHvWRRN0S680=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LmNdD/gu; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GiBemit5; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LmNdD/gu";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GiBemit5"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606A4Cet2429868
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jan 2026 14:11:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	C6oOMkFH1icyX+oG4Y2/26sOMMPItpGKJI0jnUs3F/U=; b=LmNdD/guSW5DSi4s
	1w3S3tW1ZHT8h4PRC2IQEMhcklzJJTm4Zm4VQJdjFtQsMzyuXsNNAWQib8pEWAaW
	VanOTmQyhxO38IdghxIGegGHgAKZbZY/CMwyRnEKjqmdkeSMhrMTPwKMp1dCMoDK
	HcbNudAz5aiexv/ZYsIJhXcZ7/QgBmjAS1vd5Y04cR1VmdnXHffVWJLwY4R6PVXa
	kK1uPA4eJumFcYDjzBsZsiRXd6IHgnM9p8aQjmcEIwlpruOn1cbu7tl4VMHJtwYm
	am7gC1weHxGvRQQHaCLmZusYVlOhH8QYMeRvI7rQd3V5Fawzdehx37cE45kVKKs2
	nabjRw==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bgr73a3d5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 14:11:50 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c1290abb178so1669496a12.2
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 06:11:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767708709; x=1768313509; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C6oOMkFH1icyX+oG4Y2/26sOMMPItpGKJI0jnUs3F/U=;
        b=GiBemit5UYXcqRaRBkccbuJdDVHWczrDRGsB8yu9i7cLtpPg4K9jzXXAsWARGgzEuk
         i65YLvUBjbZ+ix1r0OBB2tkzq+TAb/1m3AQnoCSBYxqOMWdXAZE23oSG8JLOZ6XTA/Lh
         oVIWT1Be5cZh5QXh3IQ7rI42iX0+Aj09zCgSwQNh21zD9SbVAJeOxIIb5JPn2dNlecP0
         I4pgtwA9ok3SmC98BkHmNfFKh4AeLrOq+T2pAuCTToLcWx1lufVERwAs4a5JLMRy2yM1
         wrYViovl5/dW6NGSM8KcokGSG12LK5JeuNZwvnOTeirdJKHozSmKvNeB38f/wHwPuFmV
         gVkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767708709; x=1768313509;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C6oOMkFH1icyX+oG4Y2/26sOMMPItpGKJI0jnUs3F/U=;
        b=rRJFiQFFZVK/OTih9n0/BOdYLtCkWQJoOGR21zbHKkMEG3YE0SNjz9c38MYVRF43JR
         eobaSauUIVr9uvKhjUpAn4x+1QxwB2q5VORk6V3nAyYl5XiykuZWn2XcgwDePYMNy0fz
         /5Rbfaa/NP6FniRbd1x9Z2e6k1oJ03XqZUaYIDJZfTAReuuj4f8sCznAo9BK75gJMUCo
         k23LIxlvWs3mXYHql+VOz3wABtXoVh8eNBF45gxGgzpudEUh8xrjUYw0LdS4vr2ok5wq
         18JfxydN0iy9R+JvUbUxAtFtdQZl+r1VwHxY9z0NVinFHdZf3O9dCFI4ne20k5U0OpTQ
         gSgw==
X-Forwarded-Encrypted: i=1; AJvYcCVWL4rX9TV2wBwhy4X0H/qXP2Iq9R8zdVJN+akbRs5H23iayPDuMmA0r35QrZCNcBWckqm/TAfERXU+@vger.kernel.org
X-Gm-Message-State: AOJu0YynWRsMMKYbOPwm3kvnynlQWY6VECYKBZzm7I1QS1DMD2apEdKp
	rDvtz5Ah657L1OpcrCvURKKwujqoN/I7jE99XxvTOnWPWAg0L6EK3+x94BKTuwEIJn5vGwtR6rk
	TeFacZ3QALpCUcsynviCRSrKQAjnvjvjIcJltwqLjZ5yK7mzBhnnktq6X1tyDJ3A1
X-Gm-Gg: AY/fxX6V45OiXIdpX9RMyRO8IMVLPJnX1il18I64z10coPZcsXbo5qiUPF9UlnDJ+GL
	DoAGfioY9r4OvB5FpOD2WuVlIO+18X5+nVXqbdr0A42RowWy4AaVVqPomKsT4eNs0G7tFhbm+j1
	JvJedrkSbOJhUCd2swlEu/XIoqBQqvcnYZRIzaR7+hy9IAT/ZSlzGuxVfzVIutlfjZuAHYr4sfN
	EZePxVtOG3pbinOEuCNDnqMJXN9FxWjiu0xQtU9RAuq+t8qQBgnSseIi156D7m4V4r/pn46Ind1
	Q2ZVSHKkVja+Ahe25/bIxHzLRKy9fvgNp33g4G/QngL5zWxBcDvvAiFYdVjdQIGJ0blE2r9SJSa
	xqltRoeZz+uev73LtsEmO5wrjDbyrwVX157tO5xsq+3fsAVKYvrA=
X-Received: by 2002:a05:6a20:9193:b0:366:14af:9bb8 with SMTP id adf61e73a8af0-389823e669bmr2747140637.66.1767708709180;
        Tue, 06 Jan 2026 06:11:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHkNJzHueZJopbOADbo0HQYswpQnnoxRAE8m7ARtjucQr/D5znXt4T4E4ZptoObFHwYrocHNw==
X-Received: by 2002:a05:6a20:9193:b0:366:14af:9bb8 with SMTP id adf61e73a8af0-389823e669bmr2747114637.66.1767708708558;
        Tue, 06 Jan 2026 06:11:48 -0800 (PST)
Received: from [10.217.216.105] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c4cc9e7e8afsm2568498a12.29.2026.01.06.06.11.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jan 2026 06:11:48 -0800 (PST)
Message-ID: <01468d87-0e2f-4328-89d7-d1fa6952d355@oss.qualcomm.com>
Date: Tue, 6 Jan 2026 19:41:41 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 3/4] arm64: dts: qcom: hamoa: Add UFS nodes for
 x1e80100 SoC
To: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Cc: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, martin.petersen@oracle.com,
        andersson@kernel.org, konradybcio@kernel.org,
        taniya.das@oss.qualcomm.com, dmitry.baryshkov@oss.qualcomm.com,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        Konrad Dybcio
 <konrad.dybcio@oss.qualcomm.com>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>
References: <20260105144643.669344-1-pradeep.pragallapati@oss.qualcomm.com>
 <20260105144643.669344-4-pradeep.pragallapati@oss.qualcomm.com>
 <7gi7sh5psh5v4y5mrbgln6j2cjeu5mogdw2n3a6znjtqyjcyuk@kxpe566v57p3>
 <e396bef2-e5bf-4e6d-98f4-37977d5d93ec@oss.qualcomm.com>
 <dbkrbec6t2agwk2swe7olz6zkhyphpbcl7dpmlwie4esvbbvro@s7ybpmaod3d5>
Content-Language: en-US
From: Pradeep Pragallapati <pradeep.pragallapati@oss.qualcomm.com>
In-Reply-To: <dbkrbec6t2agwk2swe7olz6zkhyphpbcl7dpmlwie4esvbbvro@s7ybpmaod3d5>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=QrxTHFyd c=1 sm=1 tr=0 ts=695d1826 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=i9k5oBss9a2rpNCq0dQA:9 a=QEXdDO2ut3YA:10 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-ORIG-GUID: n9SeI1Iem5sCequ-x8MUC4jcC1zyAOCv
X-Proofpoint-GUID: n9SeI1Iem5sCequ-x8MUC4jcC1zyAOCv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDEyMyBTYWx0ZWRfXwa/CzrETU+ca
 fEkMiur9jY1qWMpeHIIN7kVPRcBAIWTAvNXfv3qIQ1XfXtNaDuNYMkZ/roGPFndsvCop1kTap4l
 gLlCRoay23V83ormghOS2Qec5p5EL8YWiwdkpnxc7E7MdBauxjVRy1AGTUaeKKuQaaRZmgBsk2P
 pMvw/uBGoTbrSUYuGsjlDofi+Q7U/vujKuFK9C/a9xYkP/RbzbNE6Ma1/OFXIxt9wgzjrHv3hZJ
 UXhvpOUugVhsqMQNowaYWgyU5XF/5aQILKvCtzl+Il7UOp65eBtx3RtugP2C921wyXwcA71voNY
 pWppQ5sp6P3SgomjqqPZ6LV5Yvx1KW2+HfGRNZGhrQBUM6F+Xp8guOy/EtBinfLbW54TTIA8qgG
 T79ev26cRdixQw5DnNRQAVE3dB0zBH+iIwbdMHBz78I9hGGFcVuTm+SsPDbLr29XrfiIZ0c3gOP
 17lsIiIN9pQf9FS3l2Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 malwarescore=0 suspectscore=0 spamscore=0
 adultscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601060123



On 1/6/2026 7:22 PM, Manivannan Sadhasivam wrote:
> On Tue, Jan 06, 2026 at 06:30:05PM +0530, Pradeep Pragallapati wrote:
>>
>>
>> On 1/6/2026 1:36 PM, Manivannan Sadhasivam wrote:
>>> On Mon, Jan 05, 2026 at 08:16:42PM +0530, Pradeep P V K wrote:
>>>> Add UFS host controller and PHY nodes for x1e80100 SoC.
>>>>
>>>
>>> Minor nits below. With those fixed,
>>>
>>> Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
>>>
>>>> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>>>> Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
>>>> Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
>>>> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
>>>> ---
>>>>    arch/arm64/boot/dts/qcom/hamoa.dtsi | 123 +++++++++++++++++++++++++++-
>>>>    1 file changed, 120 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/boot/dts/qcom/hamoa.dtsi b/arch/arm64/boot/dts/qcom/hamoa.dtsi
>>>> index f7d71793bc77..33899fa06aa4 100644
>>>> --- a/arch/arm64/boot/dts/qcom/hamoa.dtsi
>>>> +++ b/arch/arm64/boot/dts/qcom/hamoa.dtsi
>>>> @@ -835,9 +835,9 @@ gcc: clock-controller@100000 {
>>>>    				 <0>,
>>>>    				 <0>,
>>>>    				 <0>,
>>>> -				 <0>,
>>>> -				 <0>,
>>>> -				 <0>;
>>>> +				 <&ufs_mem_phy 0>,
>>>> +				 <&ufs_mem_phy 1>,
>>>> +				 <&ufs_mem_phy 2>;
>>>>    			power-domains = <&rpmhpd RPMHPD_CX>;
>>>>    			#clock-cells = <1>;
>>>> @@ -3848,6 +3848,123 @@ pcie4_phy: phy@1c0e000 {
>>>>    			status = "disabled";
>>>>    		};
>>>> +		ufs_mem_phy: phy@1d80000 {
>>>> +			compatible = "qcom,x1e80100-qmp-ufs-phy",
>>>> +				     "qcom,sm8550-qmp-ufs-phy";
>>>> +			reg = <0x0 0x01d80000 0x0 0x2000>;
>>>> +
>>>> +			clocks = <&rpmhcc RPMH_CXO_CLK>,
>>>> +				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
>>>> +				 <&tcsr TCSR_UFS_PHY_CLKREF_EN>;
>>>> +
>>>> +			clock-names = "ref",
>>>> +				      "ref_aux",
>>>> +				      "qref";
>>>> +			resets = <&ufs_mem_hc 0>;
>>>> +			reset-names = "ufsphy";
>>>> +
>>>> +			power-domains = <&gcc GCC_UFS_MEM_PHY_GDSC>;
>>>> +
>>>> +			#clock-cells = <1>;
>>>> +			#phy-cells = <0>;
>>>> +
>>>> +			status = "disabled";
>>>> +		};
>>>> +
>>>> +		ufs_mem_hc: ufs@1d84000 {
>>>
>>> ufshc@
>> ok, i will update in the next patchset.
>>>
>>>> +			compatible = "qcom,x1e80100-ufshc",
>>>> +				     "qcom,sm8550-ufshc",
>>>> +				     "qcom,ufshc",
>>>> +				     "jedec,ufs-2.0";
>>>
>>> Drop jedec compatible as Qcom UFS controller cannot fallback to generic ufshc
>>> driver.
>> "jedec,ufs-2.0" was set to const in dt-bindings, dropping now will lead to
>> dtbs_check failures. is it ok, if i continue with it ?
> 
> I was implying that you need to drop it from both binding and dts. It was
> incorrect from the start anyway, so there is no ABI breakage. But make sure you
> justify it in the description.
> 
sure, i will update in my next patchset.

> - Mani
> 

