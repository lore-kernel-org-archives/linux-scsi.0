Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF97B23EA86
	for <linux-scsi@vger.kernel.org>; Tue,  6 Jan 2026 13:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767704415; cv=none; b=jK5xqp8XyRCTZI6+S2EK/6Tt1DUOdoyTErqoopYIKIFYUtSwPsMt/A8WWIQev/NbGRxbmGlcm27ZQAqWkivFEW7oimI3OkekU0Whg1OQNwHQZIvBaVWzzViHV6jcFxk6HSszxp/OdLMpVTocBRQ6OTSJ6r42HGkJFpRdM14cyPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767704415; c=relaxed/simple;
	bh=0om2bX45QNGjgdqYVBRYqDITF50Dzz/TKfhxXmJQ3ok=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nK8+K7qu7QkeaEdygctRLChnpk94giEMCmIqc0CFptzZwCd5OdbhBISjOgbzkugmBeEohbspkmnSoFODoret20L3JrAagYjVR5ShLuv4yCRBr5Ui+syEbwcNseRR4iEnTGGcDXl8H7XXMWsETITqENl6hShKy2wqloWCQOYrVRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TRS+iD20; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PyEHG7xu; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TRS+iD20";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PyEHG7xu"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6066t28o3294872
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jan 2026 13:00:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	huXgOWlwMM/3UBQ256PZnVk2f03NpWBmmvrJXgXD0Ak=; b=TRS+iD206qbp/Mkt
	9OdYG4UisDFYd5ntCFRwFJ4HZaVAhjc73UvHfPF2sV+0KWWDWhvhgyWgDcwdyrFi
	npyzzP2A3ZGUZCfZ7K73l9nknH5H270HR0PikxT3sSj89UrAvmch17byE5+eJrWo
	K6dU/LjC/EhbcKwUXp+Vpr6Z+JuEqJ5aSm1NPdKL5zRJatwEuFbF1324Dxvi8gBK
	RQEoWDurhc0bIm7C1OWOg2KSqyOyHSPF/BfrqeiRpS2Z/9vTBcQktf6a2m+kSeTs
	KFjsgT8XqSNzHrMx3zERwRSrsV8iU/X0YHJzuvfFjOQAPZvmo+Kh/zDGTM10ymWg
	ZxVtVg==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bgwj010rq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 13:00:12 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-ba265ee0e34so930377a12.2
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 05:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767704412; x=1768309212; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=huXgOWlwMM/3UBQ256PZnVk2f03NpWBmmvrJXgXD0Ak=;
        b=PyEHG7xusrseNzo5jedutcub7PuuSnxtF16/xqn2CPu3WHbkmonFlpPaX3KMn38cGG
         SF2qYAZDPsixOkE3Q2dgA6cV5o00E2sjE1DQwvM88pvKG/ovROGB+bUQdX0orL6BzlY4
         c+AB3ZAZ7p0siU1UAuAC62CJj1x0G98+2Bh8d6X/APCuO+1b5b91+V4u1UPzVvQRc35N
         b2IBY1Yp7oa85YFrr9+Q5SSeDLqunhKL/6CQQH58RxE1HB/wzuuJ4Jid+Gjj9tMwW9sG
         2YznFiaN4zTVSuv19VJ1Ho2qheSWmQI6WhNLoSUSgyBk+NtuWq/qYACRhlaQGeicA7/q
         R7XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767704412; x=1768309212;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=huXgOWlwMM/3UBQ256PZnVk2f03NpWBmmvrJXgXD0Ak=;
        b=n5YWl4Vh82LmdNTXM/sKN7OpsFZwg8HlwfqZUSPFMYzsjnj0jHRcs8kCKF8m46RnNx
         MaByTCAVU50Vpd5H3stylkXo/403enTj0Eysfm8gmlr6yQJ5WMpxrcM0CN6Nq9DlhXQL
         tw0tdEZJL+fCqDeedvmds0SoPv+uz8NPWNSJoQc3lU/8Erupqj8hVb7TOWv9rBR6pnuD
         9byNKx3tLg1ZfBQclbVIdWamW99uVjTZj1PYqmNJpKPnvNtkrQVfZ79bVMmVniSKgTaj
         Qwy+5I6i+Oj4s9uhXGbE0a48mRQmstKvlqUJKgc3YqCUvYPIq/pHAPp2v+h68NCyS1lW
         x/VA==
X-Forwarded-Encrypted: i=1; AJvYcCVdtLTZyYB01fvL63BGAFCslYM5aODzkAQsnCNWWhbO2D9ZN5rJHJ/weMxBjni6fDKNu4I++c8W8twF@vger.kernel.org
X-Gm-Message-State: AOJu0YxyMiHm2oszx0Sj+sz+rnWjVN4HDdq5hDB+u+wfIMkdCIG1ZfGN
	XxdujltQ8rBrWL6Owqcyh8ZaVYzdwq3p4fox/79CN77G0P2kxsIo/izcaD9rKLvQ4AOD4y0Z4pV
	unJaXNqyMhlx6t/YzqcgJM6AwRJ3WQ6wsGUgYzFUm64iOh9OhZqFfEfFTQEUnKfqi
X-Gm-Gg: AY/fxX6R3i6cVTY7zsP+cpt34+mMW/EdSaIJhY40yhlyrVjU+64pCejchZLBjQzBXDu
	Ed2Ds8bOYeikPyRdCDxYTjb4K7gafiZNVicwzKE0r9yn1eUrhfpfToRfEAWj+GFeYPXDrebdHjE
	vOqsx5jhKPp6iv3S3hnn80hRqgFxMO5lEtVijrTHanaUjf4iZ85601UThQ5a6nenByrL7vKxoHH
	qWnQITsNVEJQPJ/FfQyMeNXcN27tyAqLAe2hrkZpzV6PlodnUkaf7yLN4dii+UCPvazhel1VlNG
	fUDQmFHxwoO2+4tZYj4/9CZwI1fo3hnVPcJXBMSyYkRkBzS5gMVB6dOA53tfYne8HjqRRkmFUOB
	sGudwxE1ahqOX8vDVaat09zb0qHP+/yD4uCfORQyGA7n98E/vxag=
X-Received: by 2002:a17:903:1a08:b0:2a0:8f6f:1a0d with SMTP id d9443c01a7336-2a3e2d4a754mr28040025ad.61.1767704411956;
        Tue, 06 Jan 2026 05:00:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEj1eTxDDzV+0Q9BC5FCCAwWShTr88gsLB31ddtNM4i8U1yoesSaOsi/0lEA1kMP18LZTgfqA==
X-Received: by 2002:a17:903:1a08:b0:2a0:8f6f:1a0d with SMTP id d9443c01a7336-2a3e2d4a754mr28039695ad.61.1767704411315;
        Tue, 06 Jan 2026 05:00:11 -0800 (PST)
Received: from [10.217.216.105] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cc8803sm22780885ad.71.2026.01.06.05.00.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jan 2026 05:00:10 -0800 (PST)
Message-ID: <e396bef2-e5bf-4e6d-98f4-37977d5d93ec@oss.qualcomm.com>
Date: Tue, 6 Jan 2026 18:30:05 +0530
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
Content-Language: en-US
From: Pradeep Pragallapati <pradeep.pragallapati@oss.qualcomm.com>
In-Reply-To: <7gi7sh5psh5v4y5mrbgln6j2cjeu5mogdw2n3a6znjtqyjcyuk@kxpe566v57p3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDExMiBTYWx0ZWRfXz1j+KJp66s5b
 hCM/KVIksaV+QZM3WLvpk+PGU7mVNrWitBjBjRobUWn5YUfUHqr+Xeib+bihZUdCTMIXsKNuBYQ
 GC5AE+4VYCxH0HSR/8spYSiyuwutQFSB1mPrieremgYnGsBpQd2OT0/X1b4TUqr9n7ORlE4dfdJ
 ZkpssDt5HjZjhm9VVZF/pbp5+7F5wKwOWyTU8r/Lcx/4RxlrgxFck816rBbsHl3RLVOl7G2Oktd
 uutbEs5ZsfY/rpabMGetmrRG1aRPRLPe1IjCHYt+5ZoYGwhjdyg49vh/4G5LBl61oes5vortp7D
 VvKnKlMEBnPHRBNg0eWVJMXg1ifDNuIT105t241zJzbWapt6hG2PClb8eK7hmKzakEfDr42fe1F
 BSuO2d+DPj+LE9BymI23PFgEKP7FsuHeIcJwxoGZONSskuUfg2Q4yyuRhmNlwKtkSc1bJ9lhCO2
 emixWUeklxh2Rkn6HRg==
X-Authority-Analysis: v=2.4 cv=bdBmkePB c=1 sm=1 tr=0 ts=695d075c cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=CRlJY8YO9k0lXNWMlzEA:9 a=QEXdDO2ut3YA:10 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-ORIG-GUID: Q1axOhCGYMtwCbvNAsZzRdSj2dXXwRFk
X-Proofpoint-GUID: Q1axOhCGYMtwCbvNAsZzRdSj2dXXwRFk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 impostorscore=0 clxscore=1015 phishscore=0
 spamscore=0 suspectscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601060112



On 1/6/2026 1:36 PM, Manivannan Sadhasivam wrote:
> On Mon, Jan 05, 2026 at 08:16:42PM +0530, Pradeep P V K wrote:
>> Add UFS host controller and PHY nodes for x1e80100 SoC.
>>
> 
> Minor nits below. With those fixed,
> 
> Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
> 
>> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>> Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
>> Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
>> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
>> ---
>>   arch/arm64/boot/dts/qcom/hamoa.dtsi | 123 +++++++++++++++++++++++++++-
>>   1 file changed, 120 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm64/boot/dts/qcom/hamoa.dtsi b/arch/arm64/boot/dts/qcom/hamoa.dtsi
>> index f7d71793bc77..33899fa06aa4 100644
>> --- a/arch/arm64/boot/dts/qcom/hamoa.dtsi
>> +++ b/arch/arm64/boot/dts/qcom/hamoa.dtsi
>> @@ -835,9 +835,9 @@ gcc: clock-controller@100000 {
>>   				 <0>,
>>   				 <0>,
>>   				 <0>,
>> -				 <0>,
>> -				 <0>,
>> -				 <0>;
>> +				 <&ufs_mem_phy 0>,
>> +				 <&ufs_mem_phy 1>,
>> +				 <&ufs_mem_phy 2>;
>>   
>>   			power-domains = <&rpmhpd RPMHPD_CX>;
>>   			#clock-cells = <1>;
>> @@ -3848,6 +3848,123 @@ pcie4_phy: phy@1c0e000 {
>>   			status = "disabled";
>>   		};
>>   
>> +		ufs_mem_phy: phy@1d80000 {
>> +			compatible = "qcom,x1e80100-qmp-ufs-phy",
>> +				     "qcom,sm8550-qmp-ufs-phy";
>> +			reg = <0x0 0x01d80000 0x0 0x2000>;
>> +
>> +			clocks = <&rpmhcc RPMH_CXO_CLK>,
>> +				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
>> +				 <&tcsr TCSR_UFS_PHY_CLKREF_EN>;
>> +
>> +			clock-names = "ref",
>> +				      "ref_aux",
>> +				      "qref";
>> +			resets = <&ufs_mem_hc 0>;
>> +			reset-names = "ufsphy";
>> +
>> +			power-domains = <&gcc GCC_UFS_MEM_PHY_GDSC>;
>> +
>> +			#clock-cells = <1>;
>> +			#phy-cells = <0>;
>> +
>> +			status = "disabled";
>> +		};
>> +
>> +		ufs_mem_hc: ufs@1d84000 {
> 
> ufshc@
ok, i will update in the next patchset.
> 
>> +			compatible = "qcom,x1e80100-ufshc",
>> +				     "qcom,sm8550-ufshc",
>> +				     "qcom,ufshc",
>> +				     "jedec,ufs-2.0";
> 
> Drop jedec compatible as Qcom UFS controller cannot fallback to generic ufshc
> driver.
"jedec,ufs-2.0" was set to const in dt-bindings, dropping now will lead 
to dtbs_check failures. is it ok, if i continue with it ?
> 
> - Mani
> 

