Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0EE72D130C
	for <linux-scsi@vger.kernel.org>; Mon,  2 Feb 2026 09:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770024232; cv=none; b=WxTIq6OduQ/4qLPCTJYrCSsTgCdgB1MIHJ7Zw+lUsnkeY8ESfexEQzKC9hQbYdb4fUrAanrLkFNheehx8QhJq3WZloEfWo99Rx50g6bc9ABAArg0wJzuWbikAKJadGveHzdezeyxyaxYYBVOQCTiStGA3YtA0RsNeyU9dBlW7m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770024232; c=relaxed/simple;
	bh=GP1bzcxe+EHY5KGVtdvpPDNoR47aRz3nIOAhWoOyfg0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YW4D6WOERnLdwkTLZSdr2OopFg8rTJY+nw3zJMmIZhIEtuc/78ME3p2k8NqVaSDYI9ooEZzrXMDGVgmnP9SRWheQXRfx75vmpxzkh2GM0qPwNKWZpr18vvqGAYpmolIDqQc2kytthpqp8l5ZdWJofV3xeRycdYAABVvJN7G21ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PfDQ4Ajo; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=UaSnrIix; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PfDQ4Ajo";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="UaSnrIix"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61282xOs2705690
	for <linux-scsi@vger.kernel.org>; Mon, 2 Feb 2026 09:23:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	WBlp5DSD/AnyI1Z7oqwHn0hcX8LuXJktWOU+gIC22Ac=; b=PfDQ4AjoLu+D8LOQ
	YFCyWemC8wNLzAAfJZ0tlvPkP5XukQC4eJ/Zo0sJOOc3EdM2TIXmEiagVci1Xa0g
	j12S64EoFOwdezdLo3D7caqyGX7Ys/ONXxMUFkPx+kJ/Y5k4AT9OiFO0oJIcN77e
	18Y6Dp8oP7+vxttL+3dCbCbfKcyOhK4MmDYaVTRCdGDpHH8tDtkFFNEz1e/FnyaY
	YnBlKnVcEhdP1e2/hggeZG5Lmwx9Jw+e38ZGNkCjKOO4oU7KITv6pQNTAs8VFvv3
	qbsui77efS9THivzb4XUWrhwsAjv8hK4e2QEX2BtsHOB95vNAtYaxXJSbspqtQ1u
	6c/iDg==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c1awdcu2m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 02 Feb 2026 09:23:48 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8c6a182d4e1so71174085a.0
        for <linux-scsi@vger.kernel.org>; Mon, 02 Feb 2026 01:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770024228; x=1770629028; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WBlp5DSD/AnyI1Z7oqwHn0hcX8LuXJktWOU+gIC22Ac=;
        b=UaSnrIix7OqLuGZFYAL98CCcg/xSk5kAzMz6pGpI3QIIfXCheYYlQx083wmn2i8FyL
         +ZOX4NgO1nr/noEmUtW1IBDfB6YQF5NbsGKnTLjzVgqNj8W0n/kV8mnsHBN9RuNilYrZ
         fYIEGeOEsDD6evUrBcCcueMjqnbCLi6tKLoRWX4nI6+4dswYLC5HZUlLIM60LX5K22/G
         Ez2u4P3CgSkd4hBdiZyY81XqPG6UGzmLrt7A4BfMei8lBxh/FJFU9HIvGJ3qaDr4w1sA
         H/5D3lYBC94OtKlJ2/t+5N+zNGymVsZv97tw0BydDPSxsl3DI+/I7XwnnRa2C/Ec+cWg
         SwWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770024228; x=1770629028;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WBlp5DSD/AnyI1Z7oqwHn0hcX8LuXJktWOU+gIC22Ac=;
        b=axcM685Ucimqv1L1mqb8VNYVcxHFJcrICw1uNoW07lCqywsoVKW8+mE4CL4cVApcnV
         FLLXhxpp77LLo/a5YVsrXNcVT76ZBIpFWh2SG/YAq/hNgQQ0MMkVO1yhteBTS+x5lFj8
         Oo8UxQd/uKygwfa5lvBWy9jLP3Bvm4IXwVCZWpA8Hq75sdSHgrRRFmYQvd6qmZbv12k7
         DfuG4Ud0NkaQad8obL2K6cMBjrBpeKdMDr88b75ZuVaCyH6LG90dUES8CVrrMS2bUsJh
         H8C8P6fnJbGGbAVs78v+memwSp9W8pQXHqKNMMSEKgGuHWTitqQYubc5fEVZ0hbIsdP2
         400A==
X-Forwarded-Encrypted: i=1; AJvYcCUETuh/GoAtDpFnfxUb+xpD42UzySOuDO8wwOKtJOcWkT750+hBqwlif1E9hj54M6X6vDjcilddpxir@vger.kernel.org
X-Gm-Message-State: AOJu0YzFzQINCT7RzKgYeap6O67eEkiGYhBZs96u7+DXVR+oLvElC506
	CEgPYChaiKPBCToYxmLBQzQT6gPxd7T74ywD+AFRs0VhGRJ8T1ZBfdm4nRsARAQqK1HmpjiaU7n
	f7micY3Z3Mci5ppib8NsMi5E/oKS3YWoYyRotyhRf/cBpchQinygsY+9GT+Z6xyQH
X-Gm-Gg: AZuq6aLrhZVQfhZ7pHVVi6DCIdptELQxOrJT6V/ROQHRtHFkoCtHZO/o47kaTPuNMRr
	MwqAQ7l/ZdHTSJ9dOqRxZEgwdoq833jT+B7jmDfvxvUyKJBXfmqsoT8PFztu2hR2sFooHBHfEUc
	YF+oJ/vkg7XXw/gfIHa1RFKDBKWnxAonDT3mhTSdFyQ2zPDx4W/Pmv9R3jj/OZprq4EO2hLHolx
	dcalts7b+W8GI2dhLrLXPMgfqHFEH0auEmGAMqTsAu3IrffJyPEWoFHYyyXCi892RRSqSLQ0Zpo
	gWmG5TO1Wm4qw/N3U+n6hOgdeg4ZpxhQxfpA42gMmU6qCWpv+AakRqdcT6SDPjKHVeHnGTYu8FI
	OJ8sCWO5lv6gPDk6jt7KfMEF7rsJZBCU1Tizv30Bf3wEBHB03xmqdG+jkNX+YY1CkXaU=
X-Received: by 2002:a05:620a:7011:b0:8c6:a719:d16f with SMTP id af79cd13be357-8c9eb277e82mr1106098285a.4.1770024227984;
        Mon, 02 Feb 2026 01:23:47 -0800 (PST)
X-Received: by 2002:a05:620a:7011:b0:8c6:a719:d16f with SMTP id af79cd13be357-8c9eb277e82mr1106096285a.4.1770024227449;
        Mon, 02 Feb 2026 01:23:47 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8dbf2ed6besm846724866b.60.2026.02.02.01.23.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Feb 2026 01:23:46 -0800 (PST)
Message-ID: <13e311fb-1298-422c-8859-1b08201743ab@oss.qualcomm.com>
Date: Mon, 2 Feb 2026 10:23:43 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/4] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
References: <20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com>
 <20260128-enable-ufs-ice-clock-scaling-v4-2-260141e8fce6@oss.qualcomm.com>
 <20260128-daft-seriema-of-promotion-c50eb5@quoll>
 <aYBE/VljJTUNx3LK@hu-arakshit-hyd.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <aYBE/VljJTUNx3LK@hu-arakshit-hyd.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: u9jNy_AWn7VELVtdmUBjzaBwfq5IsjQ8
X-Proofpoint-ORIG-GUID: u9jNy_AWn7VELVtdmUBjzaBwfq5IsjQ8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAyMDA4MCBTYWx0ZWRfX8HJ+E575t4IS
 D78NSWZqycH6F1L3fko6In0cud1EA6cCpY7xzmBY5dHc3LbyKy+4R9kwwFH6y8kSad/7dpwQgqx
 XHrJFnMLfGXgt1XiUO0H3XnEg0F67lkPp2+q8WdWukMZJ8OL2wpWJLpnJwnPddp2Yj6fstYGZcI
 WyCRVpM3ghpx8RgNndJaYVFHJnqIiUUXI1KoKB1X2LtCCAENgbRRwQIE8mxDhH6xAj28zspg3jz
 AtQASazzP22fSt5tfWawP9vw4PMaVsDLKouDClZE7eB5lm4ycNOAlZ03r63HiTXWRQpCC08D08P
 /1NkXol247S2Q7F5VFl8TKFmaQllpmZny/hDuNMv+zqof213NUpLIIiRMDH1Ru+IN8ibszjcKkc
 tt5C22mbdZuXAZvz7Hz4K832cwTmRZ4dS0nG1oAK2o094nxP2KLgdgWw/EY3lOcNrYItgvGAnRF
 loz0Y0wmgCi01RWs5qQ==
X-Authority-Analysis: v=2.4 cv=T8OBjvKQ c=1 sm=1 tr=0 ts=69806d24 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=DrWC0EScB-dhYuGCIpMA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 clxscore=1015 suspectscore=0 impostorscore=0
 bulkscore=0 lowpriorityscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602020080

On 2/2/26 7:32 AM, Abhinaba Rakshit wrote:
> On Wed, Jan 28, 2026 at 12:04:26PM +0100, Krzysztof Kozlowski wrote:
>> On Wed, Jan 28, 2026 at 02:16:41PM +0530, Abhinaba Rakshit wrote:
>>>  	struct qcom_ice *engine;
>>> +	struct dev_pm_opp *opp;
>>> +	int err;
>>> +	unsigned long rate;
>>>  
>>>  	if (!qcom_scm_is_available())
>>>  		return ERR_PTR(-EPROBE_DEFER);
>>> @@ -584,6 +651,46 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
>>>  	if (IS_ERR(engine->core_clk))
>>>  		return ERR_CAST(engine->core_clk);
>>>  
>>> +	/* Register the OPP table only when ICE is described as a standalone
>>
>> This is not netdev...
> 
> Okay, if I understand it correct, its not conventional to use of_device_is_compatible
> outside netdev subsystem. Will update as mentioned below.

In Linux

/*
 * This style of comments is generally preferred

unless

/* You're contributing to netdev for weird legacy reasons
 * that nobody seems to understand

Konrad

