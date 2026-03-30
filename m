Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C442EBB8D
	for <linux-scsi@vger.kernel.org>; Mon, 30 Mar 2026 14:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774881864; cv=none; b=TaHUxSw+7dg1GXSsQqacTbyIJbkoXHY7FaY6JfpeQAIlFCLipdARAnq+aaX9oQa8gQV57zoucSKB3mLGZnb8+Rhxn/6a6oV4gowo71ltN4sIGLYcXa1Z9GP3Quvy2EXN8K9En3DyK4stzMGmJFetjHX5OBOf2qur674VigmQrHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774881864; c=relaxed/simple;
	bh=i9+BsmYWeNxA3vL77dGdjOl5/ZZThYuLjCOb2eFSiq8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nmqNSVWkFeJrtP92NKLiKz45MRC5nj9tDHd1oobbD+3+S+8Gyz8RmU95e2o8UCrZj8OHPwNSA9VAykPvBVppiSXncf0BHaWvR1eTIBFtvfIp7c1yAUyieIN/ziWAZ8PoqYOfpMGQ1ABfrhVZVRdz35S+ZRy+EB6i/4lNwQUSrCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AR98qoHh; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Q8hVSEU/; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AR98qoHh";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Q8hVSEU/"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62UApnXI2723211
	for <linux-scsi@vger.kernel.org>; Mon, 30 Mar 2026 14:44:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	MIP639OlwUQY/ZYHd3dviSGKSjGruowG/Nrh+/9Vwls=; b=AR98qoHhGydB1Pyt
	HA/DDuxCd7/Mh9ERcNVlPKByNrzU9yE9+nybLX0nXxUJOy9JwaJW2itHmPeY2Xpj
	eN/evKkOSWsQF/JlFwHV7SV5oxmBNMiJTXJmZCBijI0ejAIcewGdJU6UsSlDhmkc
	8qV172DQ9JMisb7jLacuXYb5ciYxMjRlTdxUtwh6k4s3Z3SBUww/g/UB6CCy5Pb5
	a9grxw60sPjIpXOR9KqbiRXY7ACK5iCIrqdVy5Gc4bvkwPk/KuoJPhZMcA2rC9X0
	ZLHa5gU0e0m5ok5Mz7EYnYhM6ushGYPrHXLPz6wb33YO+RSORn2Nvz9UYhPjS/LR
	LfJ2hw==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d7qt0gwqs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 30 Mar 2026 14:44:21 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-354c0234c1fso5316586a91.2
        for <linux-scsi@vger.kernel.org>; Mon, 30 Mar 2026 07:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774881861; x=1775486661; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MIP639OlwUQY/ZYHd3dviSGKSjGruowG/Nrh+/9Vwls=;
        b=Q8hVSEU/drnCtu8wIvcfX0D3IGiqjXmlkT80tP3g2dnfnBnv9Zk0rUzG0mDO+jRGS7
         vYGFBq6EZy4Rr495DeZ/otY4XJ0+uNStOuozf3RjyaUYSFvqcF34/jYyLxEK/8LHRgnB
         coSEsMQCP8MtLXFIST6eWLUed6CR8CKDR1WW+vfX0k72Kz7hY1svGim1INFmnxdvcx8A
         PJLiFfkXKIer/tMijsI42X9pEn5cxPO9hBGziNpjLcRsU1DNELxGBPqUrKx2ktjSMfzF
         xqc0T9T5Zai5ATjnz/N44j9tNRgJRKgSeccv+X3BTCSkWtuIiu9tW/AEGr0EcfuacP77
         zRWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774881861; x=1775486661;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MIP639OlwUQY/ZYHd3dviSGKSjGruowG/Nrh+/9Vwls=;
        b=mkVPROooTN2BQY/noA5NFb5cNe5hrBmqBYJo+ETEX0woZA8nAHgmFqlD5q/sGBcjOH
         jHivdqP6VyNCF6qHXmk0tMWCLbHadlxT9PO3oVDJsjUlmXR39PNjbXNGQPiT2039RYVZ
         pSR/dNmZbcwZ4bUR/y8vnSkazQeplvD4hdy1YZSeEzK4Bl6nNWk72EjLj44epoUJnUZN
         2YFXX94ty8tGYpPXgHTlzMhHZTZhEw+L+H1YGtCmbhpmi6ZUs6wAzzUM17gY+2Qo2h5a
         CBONhW1jxyGbGvpzwdCvyeJsCWKiKsSUaCUu4f6Td8Abn/d3VUz65IeYZpsKJukIiiIb
         hj7A==
X-Forwarded-Encrypted: i=1; AJvYcCW9VZefLD8WiRDWSkNGPGyIwgbetiRwKke4cLIZhkvmW0GkONsv2B0jSO3BHJEUtrlSwN4ZilK6qbZK@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1eakuNmS8jhdQtpy0uf2irmroC+ZZ8m4dF0pzT54R60XGjoyt
	MUQvZSLhFtccS0N1AB+akAzhYtL4z7Xm4PFGgSOzou7go1wt6Lo9sPYzNukFy3UqMWpIlniU9lW
	06rzPUOjRYTUW3nMy5R7DbLriq6MIFlROD5tDIEeP+/A/epKsc7ajo2bg4uA/msMb
X-Gm-Gg: ATEYQzzuwza3bKjyHw9xR76NzPTzRSdc3vS4QiNaQpjVgKiUcoWruafusQ3VXY8RYuy
	HUc80sa5eBxtbX+dNdDhZRqxoXp1K8mLEo4qZA/W/Li+muGy1tAJRc4snvfazIY48nePF+A2/uy
	BOJTJHSZh0D9X6CMQNHnP99t0Cyq1ar8TE32AfCm6eGKOHzMc5oC+rEd36FtJbg3l605TCGSb7X
	6bZ2yxURx9KWxsdyUxQR27hbu9QGiNRxGS0n73EKPvqf1EZ3dxCutt1BRoNHaZjs4Zkb5nW2Z9K
	KlVJZ2VHM/nPn9kejfVIU1R5HeR1H6MZD/y15qwEH/Ka8yl4oBI+gX5sbBiDKPWH7PjZsYJmXy2
	kXwTC2GfPZuT3VcgTraXJM03q4nFaqPjoFpxk3bJ8JDK7O1O6+Uw=
X-Received: by 2002:a05:6a21:328a:b0:39c:4af6:4301 with SMTP id adf61e73a8af0-39c87821730mr13239967637.9.1774881860687;
        Mon, 30 Mar 2026 07:44:20 -0700 (PDT)
X-Received: by 2002:a05:6a21:328a:b0:39c:4af6:4301 with SMTP id adf61e73a8af0-39c87821730mr13239928637.9.1774881860101;
        Mon, 30 Mar 2026 07:44:20 -0700 (PDT)
Received: from [10.217.223.121] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76916baab6sm6527687a12.2.2026.03.30.07.44.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2026 07:44:19 -0700 (PDT)
Message-ID: <90375d37-0440-48d9-a3d3-b0b442839d89@oss.qualcomm.com>
Date: Mon, 30 Mar 2026 20:14:13 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/3] soc: qcom: ice: Set ICE clk to TURBO on probe
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
References: <20260302-enable-ufs-ice-clock-scaling-v7-0-669b96ecadd8@oss.qualcomm.com>
 <20260302-enable-ufs-ice-clock-scaling-v7-3-669b96ecadd8@oss.qualcomm.com>
 <acF0ggIIJFb7mUUR@hu-arakshit-hyd.qualcomm.com>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
In-Reply-To: <acF0ggIIJFb7mUUR@hu-arakshit-hyd.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=XN09iAhE c=1 sm=1 tr=0 ts=69ca8c45 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=MkXX12_YoDuTWG391pEA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-GUID: biBb5Qs-O64ntwYiAi9-XHjBSRmfV60p
X-Proofpoint-ORIG-GUID: biBb5Qs-O64ntwYiAi9-XHjBSRmfV60p
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzMwMDExNSBTYWx0ZWRfX4MsjHx4AD8ku
 9J6UorCFpYdVONiBB5YY3AjxOFs3aOoc3J794fRAIC4wnH8r3fZbPhx1S3nhvgQUpx7F/eSFGKn
 NKddmAMWtZD94evfO5lXAw6VvyEQCD3VMwsJsUBOYg5xlrpdshi9ofBH+IZlURyuRfgia8z9MOw
 HGgqZXNVy4CLEYlVapPGpn2IKcl16/snEgyo7h8MdWuiBBPEOLbs+4W1Vgi/uUiD9UG+ao2+rBm
 3EkeGIRD1YbTRvlpbGp5fe3dAGfIMd81JXgYmprW7HxacDNJ+6ibIC+Z6gXxt8Usgwe59pwuzGx
 l6S6gXugby8LjoX2eXj7bNLM4Oj31pHbgaeEmKaUIAjuWbv/iGDwOJTb3olMQECoqUVznIKK/sd
 IjvDMnG6xTjWDdLmsHyPawZXFJVjUGGiWUrROS7HOq4jZr8tBY9Bmus43gAD9tWFLAOvAgb/NEB
 PO/Un6VVdj9K/qy6t+A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-29_05,2026-03-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 phishscore=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603300115



On 3/23/2026 10:42 PM, Abhinaba Rakshit wrote:
> On Mon, Mar 02, 2026 at 04:19:15PM +0530, Abhinaba Rakshit wrote:
>> MMC controller lacks a clock scaling mechanism, unlike the UFS
>> controller. By default, the MMC controller is set to TURBO mode
>> during probe, but the ICE clock remains at XO frequency,
>> leading to read/write performance degradation on eMMC.
>>
>> To address this, set the ICE clock to TURBO during probe to
>> align it with the controller clock. This ensures consistent
>> performance and avoids mismatches between the controller
>> and ICE clock frequencies.
>>
>> For platforms where ICE is represented as a separate device,
>> use the OPP framework to vote for TURBO mode, maintaining
>> proper voltage and power domain constraints.
>>
>> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
>> ---
>>  drivers/soc/qcom/ice.c | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
>> index 7976a18d9a4cda1ad6b62b66ce011e244d0f6856..e8ee02a709574afa4ebb8e4395a8d899bf1d4976 100644
>> --- a/drivers/soc/qcom/ice.c
>> +++ b/drivers/soc/qcom/ice.c
>> @@ -659,6 +659,13 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
>>  			dev_info(dev, "ICE OPP table is not registered, please update your DT\n");
>>  	}
>>  
>> +	if (engine->has_opp) {
>> +		/* Vote for maximum clock rate for maximum performance */
>> +		err = dev_pm_opp_set_rate(dev, INT_MAX);
>> +		if (err)
>> +			dev_warn(dev, "Failed boosting the ICE clk to TURBO\n");
>> +	}
>> +
>>  	engine->core_clk_freq = clk_get_rate(engine->core_clk);
>>  	if (!qcom_ice_check_supported(engine))
>>  		return ERR_PTR(-EOPNOTSUPP);
> 
> Hi Konrad
> 
> Since you previously reviewed this change, I wanted to share an improved approach
> that I recently realized for handling ICE clock scaling in the MMC use‑case.
> 
> So far, we have been voting for the maximum frequency during the ICE device probe
> to align with MMC requirements.
> But because the ICE probe is common across different storage clients, applying
> the MAX vote at probe time may unintentionally impact other storage paths.
> 
> Now that we have a generic scaling API exposed, we can make this logic
> MMC‑specific instead. In particular, within sdhci_msm_ice_init().
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/drivers/mmc/host/sdhci-msm.c#n1966,
> we can invoke: qcom_ice_scale_clk(ice, INT_MAX, false);
>

I agree, this is better instead of blindly turning the clk freq to maximum.

I was about to ask you to move this to qcom_ice_probe() as per comments in previous
commit. However, since you have mentioned this now, I suggest adding a call in
sdhci_msm_ice_init() to qcom_ice_clk_scale() immediately after it calls qcom_ice_create().

Regards,
Harshal

> This ensures the MAX clock vote is applied only in the MMC context,
> without altering behavior for other storage clients relying on the ICE driver.
> 
> I believe this results in a cleaner and correctly scoped design.
> Let me know your thoughts.
> 
> Abhinaba Rakshit
> 

