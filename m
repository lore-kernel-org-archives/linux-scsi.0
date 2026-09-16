Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C073126B0
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 14:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570162; cv=none; b=l78A9H5gPwh8HOFpLo+bDzFNbNYTZdADgORlHKZ5QJbWA0nkPe2cxRLXdYj3/WiwQ/2891gwnuTE5piy/D5OEKJm87pgN3xk4ki+kHCD+t+sAwSwiNjBfLFfDc/YHYyPvTjiqqT5JArb9GNdcEfoCziM9arDxzp3bMkzGt+acC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570162; c=relaxed/simple;
	bh=ND+1deEgYvcG+3y/HizuVxmy9BVpV6lq4ejnNITcrPE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hr69/cSPUG8f0muvPwP/w0JY8nQUAkqUh6l7ibq1xoEehdPBnrtuGB/Uo5Kwm6IoaG7UMIa3S0p10dAuYMPNznIE8ZQnXwikhEdrS1Hv+K8Ppkyts1YJnSo8R0ETCgKFhJH1vpwCfkOnYw7HRFof4N6NzwibINW8uiSEoKZThSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=V2CHnqjg; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bXand/Q/; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="V2CHnqjg";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bXand/Q/"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GEYx3X3391035
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 14:49:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	eVgsS+87a5iYDHDygC1JoIvqJU8Cv/bwBlYzt+34NeM=; b=V2CHnqjgat6GNaGW
	PUiSEBlK9OoycpqiH+iMn2DtXGeysLP8DOfPagpjh3clUXFrf2P3DQenl7zPA7n+
	/hK2pcewtQH2lpSn4Jf9TPttzNfyTvr3dFaLY0jC1bh87cDIXHaWFk8IcqugaQ6j
	QGKfpKex3zeYRKsgZH+jjQ7ZfXuNKX4oNh0V4uy/RHIFYJggz55ei6QGumBuuaNs
	e7XUHauS2GaFjIRfE824O63zI4dqe7wj6AP6wnw3UkJiNm+Ovl/uxC9G9SKVvG+W
	3X1WGWuD01rHOMxdjKs+RxU/bJ5FSeeEvQSokZvPvDBX78rBeQxkVGwLITp71YqF
	hNJOEA==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gqftukc5k-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 14:49:19 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-39de1f85cb2so4348599a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 07:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789570159; x=1790174959; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eVgsS+87a5iYDHDygC1JoIvqJU8Cv/bwBlYzt+34NeM=;
        b=bXand/Q/lN5QFT/rcD5qMfpZnm2Vt3egsHYAtMuY5PQcOITeQuXBqc3sMQ7e3HJhVx
         PhywfBeC3/hZS9PNdnbB0v9sKXtANr77FdF8EoliJTut9V8sptejPZCDXpdL604nSH/e
         hIWVri+fXHlq4ZttBVe28u/qsJlPpVBas9QpWyEl2ur5G37iltviqA+SC6xZCBF8fIba
         3SzVO2Rhmmatf2x96GuyeNYLagRNkPEBZoYVWLeO9rAdTG2M5MMlJAqJWpiaHbnGZXYN
         oeHDC2TuQXMHc48eHWPYb5DjFEfFwYOIe4XNVjwW0y8C2J7mO4/yrJhT5RicKf/bV9mi
         gAUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789570159; x=1790174959;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eVgsS+87a5iYDHDygC1JoIvqJU8Cv/bwBlYzt+34NeM=;
        b=xRVHGKQoEj749E2T1ctlczZZvV2eh7nqvvkpEPswYgFsdrehJcUUq7HwfROaUwiV1h
         iBvLswLT53CXr8sQ54LRgEASwqhUdpKr/VQCeqWLMXxHtiJ6y/4yoQI8A+w68G2EhD28
         zZ8iefKBUAZkEAWdtY7PjhruUKC1TufdHFMpa28WKQMkwAYNanQnhLvr+xoqX3zzv0J5
         KJqZfLpSwx7uJqzU5N6+VP6H/budso4E/TDQzBTJrgHCVuTBOBpBf32jgnIofsEnphe3
         R5dGII1Xb+Ro9f4OnPr9MzKv0mBd4a8MG8sYfZZ/+DfTlkN+/CDpHokO3oDl8oaKCh8m
         WKbw==
X-Forwarded-Encrypted: i=1; AKwUvBzSyW9aAZXCNp9NsdD76P903BhrYoxGxbYYtjNKyOdoub7FMv6YBWqHm8NaSEhkuOM8euJNE5V9cgHI@vger.kernel.org
X-Gm-Message-State: AFuF++n4KX2B2qwmmnfHqvx4b9v4c9iSEsgrv7I7DDQvERU0g11H7XuL
	Icxsh4GUllritFglLAB4cSs0D0pfKHT3iHMRpL6cn7mQg8vree2M/lua9QzmytA6ro73ciIp/6/
	0+fOR12TgoMrGppRohUleKzChfAnxlCEg+8zd4HsSrMNDxuhtKA450RHU4ZE12XSI
X-Gm-Gg: AYBFou3EJbem4HRoYm9faAtzo3Qq9IbbGBPf5c2UpL4AB7EIEXvZZ85hGfv7eEUuPlq
	L3zVhxgbWw56qTY5F6XqVv+6JOtxsh0gzrCcSyr2gsLRLYmt+gIrBc7CAL4cueGJAuTs9KvfpGi
	josZYk+iNgFKzTr6tT//NQsmbD7t1INSPAYT7W2mps1l1+bw9Ek/B8LUCM/FfWnFCyO6rB7aAYg
	dmYzBU+padZkp+7+Ba+0ERdKwvBxzChKGppJjwMvKS5aHkl5IBOmEdbnBmf6SXCPFxFf55HQdGY
	hVzdfxjx3WplfEtntNhjXRLZ3UUuMEadV28Hk76U+4R3PdFDClRTVjwQ8Edmvgu3xXSNQvJtQHh
	F/MyCsnawiMjYniLlEGMGVNwuGV3x/rGZEdfYmBo6
X-Received: by 2002:a17:90b:2885:b0:398:d132:ba76 with SMTP id 98e67ed59e1d1-39e1e502f25mr6913673a91.21.1789570158605;
        Wed, 16 Sep 2026 07:49:18 -0700 (PDT)
X-Received: by 2002:a17:90b:2885:b0:398:d132:ba76 with SMTP id 98e67ed59e1d1-39e1e502f25mr6913598a91.21.1789570158156;
        Wed, 16 Sep 2026 07:49:18 -0700 (PDT)
Received: from [10.216.41.130] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e1bbfdd49sm5493700a91.11.2026.09.16.07.49.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2026 07:49:17 -0700 (PDT)
Message-ID: <6f5d5266-75b4-4f65-a19e-8fc27ca9d3ef@oss.qualcomm.com>
Date: Wed, 16 Sep 2026 20:19:10 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] arm64: dts: qcom: glymur-qcb: Enable UFS
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Vinod Koul <vkoul@kernel.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@sandisk.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        gopikrishna.garmidi@oss.qualcomm.com, jagadeesh.kona@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        sibi.sankar@oss.qualcomm.com, Taniya Das <taniya.das@oss.qualcomm.com>
References: <20260911-glymur_ufs_qcb_enablement-v1-0-b9fc5e2ee99a@oss.qualcomm.com>
 <20260911-glymur_ufs_qcb_enablement-v1-4-b9fc5e2ee99a@oss.qualcomm.com>
 <c3bc5b6c-f929-4576-9d7a-d5fb9cc80aef@oss.qualcomm.com>
Content-Language: en-US
From: Pradeep Pragallapati <pradeep.pragallapati@oss.qualcomm.com>
In-Reply-To: <c3bc5b6c-f929-4576-9d7a-d5fb9cc80aef@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDIwMSBTYWx0ZWRfX+7mWyBsl+AoS
 CW2ZyqR1u8FNnr+9KxE5+GK80rKJ9ZHeUYp1Vd77E20G3/kNVvH2/jR3TIRD+YoRvaMCB+odfkb
 1NhekfHuuFh8WL5L10Q1CA/5sL18aUVfQLX1Fh1e9NsXn+VUymzeCQ3b6p57ZKtnzGqAArAbcbs
 A9HM4+saGqCuRPa+KTAf5VPywltVdLJ+l3GRPAqRSE6WLHHy/kUg89Fcu64MPlle4fwGWcOaLiG
 +K22BwLQ3im7A2Uqle5CxUyCeZ05vTTtMR5r3jUrhQjmUB/ongMUfL3bbj7C8fEbGu45hfcqg7V
 bE6AO5eia8wzdHPyJ4rWXhBIEk++9NBpVfKWxjqs99XLjAcqzeHMJUsnmxXCGGaN4vmP2OoS4Mj
 CIMWSjTm/PW9tchEBwGJOvLdoIGhRvSUq4ZQVaGLW0jr3hpj0Yd6kiDk5zHBpn6aFiJwqTauQNY
 1Wjqrj+wdgwbOdEu1Lg==
X-Authority-Analysis: v=2.4 cv=a5ulZkSF c=1 sm=1 tr=0 ts=6aaaac6f cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=Z03_-bexLPcab5i0-bQA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDIwMSBTYWx0ZWRfX9o4wy4bCcwLj
 bCMlqwYvmdZzYg8ajWT5iqnl1ZZzHSmoWCj6JNoys2qUtWuNfk0KOWy4zFLBBLrTWwErAjSk/CW
 pwR6h5ispos2sarXeCD9vg/ArSLLAeA=
X-Proofpoint-GUID: efEvI8ivbLiNmE2tV9TVVlbMuJhKa74z
X-Proofpoint-ORIG-GUID: efEvI8ivbLiNmE2tV9TVVlbMuJhKa74z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_02,2026-09-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 clxscore=1015 priorityscore=1501 adultscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609160201



On 9/14/2026 2:44 PM, Konrad Dybcio wrote:
> On 9/11/26 6:47 PM, Pradeep P V K wrote:
>> Enable UFS for glymur-qcb board.
>>
>> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
>> ---
>>   arch/arm64/boot/dts/qcom/glymur-qcb.dts | 18 ++++++++++++++++++
>>   1 file changed, 18 insertions(+)
>>
>> diff --git a/arch/arm64/boot/dts/qcom/glymur-qcb.dts b/arch/arm64/boot/dts/qcom/glymur-qcb.dts
>> index 17d8ff3aed23..b6e384024dff 100644
>> --- a/arch/arm64/boot/dts/qcom/glymur-qcb.dts
>> +++ b/arch/arm64/boot/dts/qcom/glymur-qcb.dts
>> @@ -697,3 +697,21 @@ bluetooth {
>>   		vddrfa1p8-supply = <&vreg_pmu_rfa_1p8>;
>>   	};
>>   };
>> +
>> +&ufs_mem_phy {
>> +	vdda-phy-supply = <&vreg_l1c_e1_0p82>;
>> +	vdda-pll-supply = <&vreg_l4f_e1_1p08>;
>> +
>> +	status = "okay";
>> +};
>> +
>> +&ufs_mem_hc {
> 
> Please keep the label references sorted alphabetically
sure, i will sort it in my next patchset.>
> Konrad
> 
>> +	reset-gpios = <&tlmm 250 GPIO_ACTIVE_LOW>;
>> +
>> +	vcc-supply = <&vreg_l17b_e0_2p4>;
>> +	vcc-max-microamp = <1200000>;
>> +	vccq-supply = <&vreg_l12b_e0_1p14>;
>> +	vccq-max-microamp = <1200000>;
>> +
>> +	status = "okay";
>> +};
>>

