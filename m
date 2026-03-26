Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7262D379EFE
	for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2026 16:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774541851; cv=none; b=WbtiwjJ4+ObBMiqdxMK16gVVEZuqkwYUFr9yvHyT3sVpVfo0STCTo4SJaK/cnMlOJO9MfXL5gQOqxSikL06/tZlAKarZPxAcbc4gtm6+prB+O34HYSiw4+BmGgYxe5bimCqdijzYvlhXBV0n2rNaTZXwtf6TSQwZBQzaiRrV1Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774541851; c=relaxed/simple;
	bh=tDSpY1TejOzwCOwtqoeML4zTegfiFUOPdcSviZLNYpA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p07YcUFwkoshgxpjvcjGBoyjeG7DDJOodM8RYs26d6FkuNJ4vTa4/w21v4ogxnqnnzeaEXXzKupvWRDAewBMM+p1X90pxdCQy8EbIBekUuN7xzKIZ/RERPuUS49Soc06eBAFDk2krw4o7xvRHs4CumE//J5QXgixH5oTZDJEGas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=UZOKp+zi; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LSpcZ4nc; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="UZOKp+zi";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LSpcZ4nc"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62QF9fwJ3898189
	for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2026 16:17:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rv1vMcePfr6BrkYqOV4MUVosqHAwIr52HNOnEfknKZQ=; b=UZOKp+zilRaU2178
	BbFu5L+mi0L69kdCdbiLtEBcwTnSNldcrrujeuW8oU1nBR67UkQFbvcMPDsYgIr8
	uYkNoKpaJsUviVpo+CQ4+Z8vDOj8TDHRHm2sxT37NlOzdZJoGx9+b6BmUNq2b/xE
	pN8odIvefr0tTz/4XYRhQb8ugqDsy+kAcou1gWX/1FihEC4gLU+wI60PveH8dLpM
	kzUhYHsgqqC5BljGyUZKfC4nHzJ9kjAxoTzl6hzTzAAXVpr+2sivwDhK3USjijls
	Ji0dBmZcBb4rcnpLMNhHkHk2LUQtSDxtz1Bz0ivnq3EVNtPV4uVwSTu4Fg0p1hPi
	08Dqug==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d50kg9u2s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2026 16:17:29 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-82c1e1a6cfbso985464b3a.0
        for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2026 09:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774541848; x=1775146648; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rv1vMcePfr6BrkYqOV4MUVosqHAwIr52HNOnEfknKZQ=;
        b=LSpcZ4ncs8ZWgHyCTwfQDUB+XU9VqLW+nBbe6MJ3nToBZG8SiNvJdclC8HjYmk0C3I
         seOk+oT43tFokC1+PmrUIO+loGr088rb8+t9Ns+rLP/IJWlLaIO+UyVsgXD5SDtl4l5b
         ZWXBoQ5nIkxpXfjRDslptj9ov/bvMS9XysgYsvdLKMRkZbgTOTnMI3tazUj4YKg2fGK2
         UCtNRvL8EdMzzgHjEgjFMCoeyfygy0lduIefL+z2tXU/4/ny+ShmYkYBeCn5gFi24MWv
         QTEG5jHftwyJgLMLk2hoBc0s0G47egjmQfynhnPlephxMa2gFqgGEh0Nb8kyGko+odoZ
         C1XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774541848; x=1775146648;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rv1vMcePfr6BrkYqOV4MUVosqHAwIr52HNOnEfknKZQ=;
        b=QRxzFVWqt7RXx6rUy/P4FTON5r8tIZugbwHPdZHAn1yOqn8Awl9+bNlsYsdJSxWttB
         o8L8hxnR0ulwUSnTWCDivyN56UPiVT9YrAwwtVC/N80X08jEmoIXf64hkw20ugZkURU1
         neRQptuw38HelSrOeqvU58lpe/L6Lp4IXj9O8drLCsat3UA/bzDZ6xT+ipQMMPff+05W
         v71mlEPBSSNLMf8XVD0jxbNbZZqJcJG93zgSIscS/vrjHYp4aUDWwwH+EzxG/0YfyOiV
         vF93am8NLx9y3hAA70eLxoGMZZP1gVR2OSChJGx3lN8EtHfbreUgH0DpJOnsSi6lYrlm
         CLng==
X-Forwarded-Encrypted: i=1; AJvYcCVYP3KvV8n9wNGl0uiSMSIf+dV7HBjXi4/6QUU6tFjBIY8Q+Qe7TM+4SBpTsxEM8BPvACs0amHDwPmF@vger.kernel.org
X-Gm-Message-State: AOJu0YxHtuh4FKcd4ZdgdYcIWXnFOxqfmnChS8D7af8ImHjLJMlrN2gz
	AUQGUaDdeTuKSjkUEjdW4akFq831Z7u2EhZ/x/4G4r7JcNfA2vApzt7UWhVK3NL+tiH96mzPwgR
	4lI+6+Y58kXo80jwWUi2oYlrs/bN4ZpDOIvazZF3aBKgL53PKW82IlWFnyI8j15NitkJUV+TL
X-Gm-Gg: ATEYQzzoZgZqtf0cC+Ei1I8ZMClXM1xb3Y57QyFnpkQzRwXFJYtIdT3rSFOv3KWI6Mc
	vGKnzUi4ZXu6MdRwTojfA0L4FstZYOlP4cp8iX8RzlsB/tL+o3QclUPSKkg8P6/7eiDWQAt3dJk
	+JT7vP2P+JjrlhBEsN5ISopiJPJgyKL36jX6orFi7VneCYB0yvgiAP1vYmjiVPXuRRVWP1mD2uv
	+cwoxXM7lX5Yc9XD7NEuppOUxmyBSPHFvs4WH+ZuQilaTJydCGRtmgW7HWKoot0vVU0NiWcCFru
	SXdupezX199XN8/Ugi9/xIq37ue35TKyMOkSeol+pTmk64argjtRppI6imKf/Roh1JINbMuQTnL
	aZ69apeh/4KyKNzP4Qd6HFUsjHBUFWvrT6q+h+o82If/A4cNSzqw86w==
X-Received: by 2002:a05:6a00:1c98:b0:81f:44f9:7c1a with SMTP id d2e1a72fcca58-82c6de863demr8484551b3a.3.1774541847944;
        Thu, 26 Mar 2026 09:17:27 -0700 (PDT)
X-Received: by 2002:a05:6a00:1c98:b0:81f:44f9:7c1a with SMTP id d2e1a72fcca58-82c6de863demr8484520b3a.3.1774541847445;
        Thu, 26 Mar 2026 09:17:27 -0700 (PDT)
Received: from [192.168.29.82] ([49.43.230.194])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82c7d20fc0fsm3820103b3a.19.2026.03.26.09.17.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2026 09:17:26 -0700 (PDT)
Message-ID: <93eacde8-41a4-44a2-a427-31e56cde9da0@oss.qualcomm.com>
Date: Thu, 26 Mar 2026 21:47:21 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/2] ufs: core: Configure only active lanes during link
To: Bart Van Assche <bvanassche@acm.org>, mani@kernel.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, nitin.rawat@oss.qualcomm.com
References: <20260311060912.3139257-1-palash.kambar@oss.qualcomm.com>
 <20260311060912.3139257-2-palash.kambar@oss.qualcomm.com>
 <7922d339-5e85-4b12-9e32-f095e10b1211@acm.org>
Content-Language: en-US
From: Palash Kambar <palash.kambar@oss.qualcomm.com>
In-Reply-To: <7922d339-5e85-4b12-9e32-f095e10b1211@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=SMZPlevH c=1 sm=1 tr=0 ts=69c55c19 cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=PiB50hzSAWR/pQeEMnc2VA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=zigxiAtAAKp8hoqNa4IA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI2MDExNSBTYWx0ZWRfX/oSl4aRR9D94
 sinbS87SHmaUG1ezRYCjx2CKcoEvkN7Mhi4MgprQNLEb0HsJfN+YDbPmjyjqN4O6YlP0Bx1RvXd
 K3AJR3xMZ9BV2TOWkS4q2mu/hRXEtBFwe1GDQW+DPYmjZ352V18spyFiXrtjwFPh8oGuq3srkC3
 vihH5guhsR2qiKWFz1/nxdLPOCVmIkdjG5K/kVF4Yd9iA6hPHEh1gCL7lL4fzAkq8gC7fPOq0ky
 QHb3p4Zw0TN5TR5PdgJRW75Dlp5VEPALAAzxuJ/JtE9TJ7IKHu0W9S9b9b1voOLoPhiYG3DBsiU
 75M+vB1uFnkZ0g2MRrnTuukYFNAw/34tMDJHrtv4k/R2uzRh6GBlAxG9J4lpO9xMq3GpRddmBCX
 lHtyF9YUNv1XI+FfIkW7AJdg1x3hesp+RvUKFCS+0oBZOWmxxIcjDbArMmCZxYHiFX4Tr3CzAkG
 JKb0xXGQaHR3aC22M0g==
X-Proofpoint-GUID: Cal67_MU8mw5S1m1AQlR_dzXjh6VWozm
X-Proofpoint-ORIG-GUID: Cal67_MU8mw5S1m1AQlR_dzXjh6VWozm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_03,2026-03-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 bulkscore=0
 impostorscore=0 spamscore=0 clxscore=1015 adultscore=0 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603260115



On 3/23/2026 9:13 PM, Bart Van Assche wrote:
> On 3/10/26 11:09 PM, palash.kambar@oss.qualcomm.com wrote:
>> [ ... ]
>> +static int ufshcd_get_connected_tx_lanes(struct ufs_hba *hba, u32 *tx_lanes)
>> +{
>> +    return ufshcd_dme_get(hba,
>> +                  UIC_ARG_MIB(PA_CONNECTEDTXDATALANES), tx_lanes);
>> +}
>> +
>> +static int ufshcd_get_connected_rx_lanes(struct ufs_hba *hba, u32 *rx_lanes)
>> +{
>> +    return ufshcd_dme_get(hba,
>> +                  UIC_ARG_MIB(PA_CONNECTEDRXDATALANES), rx_lanes);
>> +}
> 
> The body of the above two functions is very short. Please remove these
> functions and instead inline these function into their only caller.

Sure Bart, will address this.
> 
>> +static void ufshcd_validate_link_params(struct ufs_hba *hba)
>> +{
>> +    int val = 0;
>> +
>> +    if (ufshcd_get_connected_tx_lanes(hba, &val))
>> +        return;
> 
> Shouldn't it be reported if ufshcd_get_connected_tx_lanes() fails?
> 
>> +    if (ufshcd_get_connected_rx_lanes(hba, &val))
>> +        return;
> 
> Same question here - shouldn't it be reported if
> ufshcd_get_connected_rx_lanes() fails?
> 
> Why does this patch only call dev_err() in case of a mismatch instead of adjusting hba->lanes_per_direction or making initialization fail?

Idea was just to warn and catch the failure scenario. But I agree on your feedback. Will fix it.

> 
> Thanks,
> 
> Bart.

