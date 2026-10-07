Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D100B39936E
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 11:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791370850; cv=none; b=oHBLCOsOqnTB/1hRk5G5qBLRzYt7TDuetK3YNdX0BQ/ifbKxCXKx7MDTjbcZovUUM9Y9RPMcAhH6VCrJEP3v/hvj91vi9gF5euoaYy8X9OTB5rzhDA5pEw85u4LJX1MzDY5d8f9SYp7lf4Iqklz73t95VA7Ge32uTz4vAFTPvv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791370850; c=relaxed/simple;
	bh=VU/dQ6PyuT7ZXeA2t3pyo87RFBXHOriX+IpfI3AmWwc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EjitwFrOgASqKaIF3hF0erC0huEs7Rl5LoVxJDeWcPbNd9l9dTVyzhc9AupxQkZZJ9pidaWazQ9ekpGy9Z1OgSRfURrcRpXy5qKguqnMg7unSTWKpU2eMf7lN+3Nbi8FBSDeRIL0hi3FmtzWGXCag0Bc4A2CXSPPzip8fbwJhIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=oU1AcnTu; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RQcYMyor; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="oU1AcnTu";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RQcYMyor"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6977jiga151957
	for <linux-scsi@vger.kernel.org>; Wed, 7 Oct 2026 11:00:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Snd8Nbf+SiQhM0aPYxj0+20rz+GkPAR7nvSsrKWQQBo=; b=oU1AcnTuBUKPMdOX
	9jSWS530HrKrixtTyv3jinPa15dqNfDFg7UkF4MI8j56piw+vwI3Q1KmAw9K1Mxr
	WjsEdeiT1mCL0IH3bSTjABJ7mzknGXYBmCKEZ5HkYmg3bC4uXH2nTZyo/TlgspJJ
	SCyIvFNOdDcWsrRZjZ4WArTrfFZ2r9bNRA3xZFayD1ICpr8Yywi0QmJlg2qpVbf/
	v/iMMOtxB3Ar+XDIl2MCqkeMm2pgB8FCgD4QOQcDhnh61/Fhdzry/8RInu9jTrO7
	SycpXpktNObg3gZzDyBv92HTka/JRNjn20Lt9fQKDQg8mrft8HiBcD0ITOykMCFR
	JY0MWA==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5c719r86-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 07 Oct 2026 11:00:22 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc1eb205d31so4433673a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 07 Oct 2026 04:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791370822; x=1791975622; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Snd8Nbf+SiQhM0aPYxj0+20rz+GkPAR7nvSsrKWQQBo=;
        b=RQcYMyorVGr6kwkgU6d1UOCoRuJkSyxo26v7IO9u9n3yO6pbpvcuS1RlY0KyyW8xw5
         cIIaPBOgc6YT1ICvjXk1hs/bj0H+Kl5Ur2zI84DJ1TSaQYLkErMuG+1h6m7WspfkgxOD
         8r5bLsHK/94BtbZNv0b+rclrrQLwqovdXwDhz/yXq9GYntF1T8DXuuWjk/1OH5ZGMJ92
         hG0S70b6g6IyypNNRAFXK2AqkdgEny7IKF4tCK7aV82y7HVL5WP4zkgD5O492QEWvsoP
         qCO5dwItv2fN4C+q/0wEzpuZ4sAXXqQKyR/CbrnF8TrofrUc8Qtx02N/8cPFuWAlwOxj
         F6Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791370822; x=1791975622;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Snd8Nbf+SiQhM0aPYxj0+20rz+GkPAR7nvSsrKWQQBo=;
        b=pROQQcO1sb3ffKV65k5X9DYcWP1gWgW2i/v8PpvB3ZYWqLBvsNeHdv1L3O30/AAlAz
         Isvo4epDfG/MwopstcBwdu5C1zNxIo3gKzTJkiwOAgtaj1+yX5CgJpGmH2fzbbwFdu0/
         AyIxIVl7wQEHNiX3cXVK4y5lce2QMaTlYVRE1pvPzk9wCPfbcQ+QZBzz9hvf70JZKgin
         O8hQf5CMLZh/bzOb2fPql7jfd5Wc5Zd7M5eSa/dmwdxQBAMukOnXnWEnU4rvqGcPGna+
         aB7H+1wEFbgC0BzGJZdVksUHUf4EX1CQlTnE8m3hxx5H4xNM++gbEvgeMSJM0cAdNHDg
         Sc3g==
X-Forwarded-Encrypted: i=1; AKwUvBwYRR+9EUIqM2YPeTmTk2arWuJj0iZI1aNG1AiE7JKQTlYjG2xbO+FQiAqAvwrNBAoxmBn3Eznri6He@vger.kernel.org
X-Gm-Message-State: AFq9FYJvfLDvjqlCDgRFlTOSULap00Vll0IgL0H/hKgBBAnn0/8KhQSx
	JM7oAPLEbE1GYy9sPR3XHOQmocVE4G175AIf4j7ZC9PU5+AEDhm/eDGTckvgRNLlhUe5ClCpJV3
	dAN6XYwkZr+hMGTnbQm7WrCWHjIJWaFqFuOEK8tcAnVh8QViCNLkNgok6WJ7OKsQf
X-Gm-Gg: AYBFou10nJBrDOGdGiXOkhKLqRn0R6faepyPtJPc6OWUxQLeiXvzCCLn+DcpOK5VGw7
	xPb6xYpKgV/5OLyBANQWbZvZ4HIhLfrW/nS9ppa8apHoHoVDV5mmx6u/p/3t5XeTjNPe88dCXmo
	q5GfQ+iS8Q53uMxChGbO2QWazv0uHa6YfLXvWDsB8B30xw92GnICNd5hrPdqKJf4C52KtSOOb/G
	Vutaxu/JRyYS1xn054yVTMJ/ySR5tKvsmRECRWCXReMacLn8eBoREeZa8Rnm9UcV2aBv0uBW0Iv
	YehicoHIDRZCmztj2d62QUYqHUgLdgT5V+1Cbj9l6X8oNyOY+1p1KxovR7dY18nOhxZgX8aafnL
	tHM2ZqdUdJzgPOUnKFLpAy8VlUZ0/iUHbHRpx3aGs
X-Received: by 2002:a17:90b:5887:b0:3a7:250:386e with SMTP id 98e67ed59e1d1-3a8a07404admr1701822a91.22.1791370822182;
        Wed, 07 Oct 2026 04:00:22 -0700 (PDT)
X-Received: by 2002:a17:90b:5887:b0:3a7:250:386e with SMTP id 98e67ed59e1d1-3a8a07404admr1701772a91.22.1791370821390;
        Wed, 07 Oct 2026 04:00:21 -0700 (PDT)
Received: from [10.217.216.105] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd0a92d5ebesm1232959a12.12.2026.10.07.04.00.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2026 04:00:20 -0700 (PDT)
Message-ID: <297690cb-64d8-4e7d-9d97-66680f6a2b99@oss.qualcomm.com>
Date: Wed, 7 Oct 2026 16:30:12 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/5] arm64: dts: qcom: glymur: Add UFS nodes
To: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
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
Content-Language: en-US
From: Pradeep Pragallapati <pradeep.pragallapati@oss.qualcomm.com>
In-Reply-To: <a5p5gszuadvnvqcwffg6y55khdfhacwhegaxmmiwm72sfid6ex@cdwuo6sdmkgy>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDA0MyBTYWx0ZWRfX0JFhZgNxAA/S
 jnXtbRTUxVHVlj8aPUZT+im+7QxRDYRAPdTI7xE+845ceab2/qb9tPNa6mXqe9MRAwXLrXTlgW2
 yobnqiyozVgPysChtf7fGd77YR9HUPE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDA0MyBTYWx0ZWRfX5wYMup8iVXjo
 NIy9zbjKcL4kRwfM7iPN0y1Q09JRkw0j4kshga5GVzcyxzQE9iCNYWxLZ0tmhwEmIdKdFpux+1N
 LJXiA128KB5oW8Db6bBzWCvki2HnGYed5okBVrCMlCU2uPXfReX5nwSJ4o7qalQBhjcFBEL2ZMs
 EpjSMHezVPBSLiXDfyCB3tJ3r92mk4jy2pZCaBmqfh3xyICzyo4wTl45vCG4PRzhiQmHqT1iLGn
 O4tx6+ySyhTa75EifYvUNo2vmxaBKtJF9NRr7camBMv/uY1grQOA+Rp9XchYdZTNGF+bSfE3bMs
 feYsyN+CsbSMx52IGMdnM/d+4cV6ixYByZGDOYz2tlSQn+a0OmH0iEUmMrAr8aCs8fJ1dqf8ENO
 DuThqOaNv5x7nBVEvN74an4Mntm5h0bQMP80vEuSNmS+MVT9hU1cKoZde7FcG9i7Vn4CIDjazas
 PDdGf7x0shx+Oj6EiUw==
X-Proofpoint-GUID: L-4vJLkjHA_SFqVz--vXCxcoO4ONXzQW
X-Proofpoint-ORIG-GUID: L-4vJLkjHA_SFqVz--vXCxcoO4ONXzQW
X-Authority-Analysis: v=2.4 cv=LvYHWXdc c=1 sm=1 tr=0 ts=6ac62646 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=SwwKY9vyf4oML-p5yksA:9 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-07_03,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 adultscore=0 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2610070043



On 10/7/2026 1:13 PM, Dmitry Baryshkov wrote:
> On Wed, Oct 07, 2026 at 11:59:36AM +0530, Pradeep P V K wrote:
>> Add UFS PHY and UFS host controller nodes for Glymur SoC.
>>
>> Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
>> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
>> ---
>>  arch/arm64/boot/dts/qcom/glymur.dtsi | 125 ++++++++++++++++++++++++++++++++++-
>>  1 file changed, 122 insertions(+), 3 deletions(-)
>>
>> @@ -4102,6 +4102,125 @@ rng: rng@10c3000 {
>>  			reg = <0x0 0x010c3000 0x0 0x1000>;
>>  		};
>>  
>> +		ufs_mem_phy: phy@1d80000 {
>> +			compatible = "qcom,glymur-qmp-ufs-phy";
>> +			reg = <0x0 0x01d80000 0x0 0x2000>;
>> +
>> +			clocks = <&rpmhcc RPMH_CXO_CLK>,
>> +				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
>> +				 /* UFS and PCIE4 share the same clkref */
>> +				 <&tcsr TCSR_PCIE_4_CLKREF_EN>;
>> +
>> +			clock-names = "ref",
>> +				      "ref_aux",
>> +				      "qref";
>> +
>> +			resets = <&ufs_mem_hc 0>;
>> +			reset-names = "ufsphy";
> 
> power-domains = <&gcc GCC_UFS_PHY_GDSC> ? Or is there
> GCC_UFS_MEM_PHY_GDSC, which is simply not described in gcc?
> 
> If there are none, it should be reflected in the DT bindings, together
> with the explanation in the commit message.
> 
Yes, Glymur SoC does not support UFS PHY GDSC. Sure, i will update the DT-bindings accordingly and include the explanation in the commit of next patch series.

>> +
>> +			#clock-cells = <1>;
>> +			#phy-cells = <0>;
>> +
>> +			status = "disabled";
>> +		};
>> +
> 

