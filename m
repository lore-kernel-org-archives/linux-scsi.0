Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D39B1F09AD
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 04:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776399806; cv=none; b=X/UrPhXduALOVp9G7XcGvx+VkB9KnBbKASbsZd4frt1z7InhyZzDBZ4eguramslMXdHSo8WCR0jlmc3Pukg/JVRsJFjpdsHPxaiB1crjSnnW+KoGisCxmu0+wW5t7HO/Co54MoCaaFLJ50/JV0YU6h9b5VMM15t7ZTIETZlEQvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776399806; c=relaxed/simple;
	bh=qKc0gjAZUePsNOZh83kahRoAT6OgZLpdshCKxlrNPCc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iC4DlsnzM2UMCZaWkq/IFP1jr41mNc5/Cz9G9sDKOtoLf/XB707uzjua+4Ceo8C16j5NXr2O1cePNljPA6H3NiCUADt8gJawbYQkqNabadP8Nf732vVzPxWK2Ui3CqgYOdm2AclR6E61zeldj541WwgE9wTmBUt7zQvARIZOilE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BJQ79aaL; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dJ22vFhX; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BJQ79aaL";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dJ22vFhX"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63H0fneN3102056
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 04:23:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	vhY2nvNwh4GE1c1ziD5DqknFPBAvBF9SUwT9Df1LzcU=; b=BJQ79aaLb6Iz5UHR
	9B3kfL+9IMfut3QZHEsLt6VATM2FOL1nIFybuO7vogwvQw7kTOLEo6imAO82GnrT
	KEMt28gglhkoM7a6oG1Yg0QI1OMjlQ5xH4EwUZ/4IV2vylAPaGTq2oKJQSL4kNEB
	iojOhQyRB+P7ijbZy4x93bNtkArLF9L9dsnaG0hLjDxY5G8l4MFTzK63dcYGOYsx
	Dyvt1duZupcXOcyV1aMPEvhKl99RSfcW/q4XdfOSyyfLHCogXGmu7IqBDBcHIi0i
	A+F6iipwTN4H7MfD27yvuM3AMRTw0L6eW0cf0jbj6kEqhXE4OSDzrxwkY085cbi2
	LI1q+A==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4djx4kbamj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 04:23:24 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2b2e8bba2e6so3774715ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 21:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776399803; x=1777004603; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vhY2nvNwh4GE1c1ziD5DqknFPBAvBF9SUwT9Df1LzcU=;
        b=dJ22vFhXhzTjwBTqcXIrsAm+s7jh4MSglSmPD7nCkjK3wthtRy3M8+fnRUP0dT1MM2
         BwDFRFqVSP1ANYKes28h7EJKp2GC8tENEFg0FVnC6O2BaCzaf/ykJ/NE9eZgryFppAQX
         BPUP4KiRSvVQBrjXVqeBpGqNPmPPc6TDxHPijWmESroskxooVKJB1chiAXijYheYEH7Z
         k00+q4OVeErrH54pl5NGjcF9q8G8AXDIolWsTm+Zq8LTpM/zGOztozPAVNkfyr1+26s5
         YoEqrOS3absPd7MatbeDXmtgpnskKUxzwEFs4tXDv6ordHHqVxoycnKhBgECWnK3Jlyd
         SD/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776399803; x=1777004603;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vhY2nvNwh4GE1c1ziD5DqknFPBAvBF9SUwT9Df1LzcU=;
        b=BwBYwTo/WZJq1Ce0XLa28omJLt2RSlo4TP2uezecq47Om4HAQhGM5cp8H3Ecin3Wpy
         SR4wHA2A3rfirWxJ860pKIs7Q084SEIH6lEwC+p0/POsRGYDxK13AM7vf5XcPFIqVRAh
         wN6fXi6BJuhftjr3Bhurt3kdA1a/e+IBKFST8c19/NLWWtliZUId7AeYtroz37tTiD9Y
         sB8LEI3S9K+vxFPPgPi4w3ZMkxSxNBsqxMAfi+6tJKwJVLMO78CoKvcy3Rp8YcIm+5uY
         nr/lAszL0XKGEGxVKNFDg8dAMKxamMKoNs61uPzzv0UbCLJnevJMzJ1L/Lf82fUvCSEP
         jkBA==
X-Forwarded-Encrypted: i=1; AFNElJ8DrC30Y4in8vPpEetRClqZWSQwFHlRHTsCq9Gb3M3AjzRDYmSSv99136XfFtxV4CHu3qLTD8t+vTl7@vger.kernel.org
X-Gm-Message-State: AOJu0YwKP79hesgcT3QEdF1m6T69N1f3zoHNVgQEaL2NT6DSw3CGr0AI
	a4OObAtDksTO5qQp3sOBVpXgkJHHXkXbghgFg7tSxQzBj27zMB8cEgV6iBjvVD9X1JMUQDGbcvi
	O0S8bsPwmx0EuceRpopjzQHeXvEZ1kDJpxi9iJNL1W/t13w3lCMoEDzUUMnG48GaXA4cSMjp1
X-Gm-Gg: AeBDievvte2JQgNh1JW1vUNwyqIRH5qeNHdUOPSptwxYAzsTvTnhkwRdVmj0dG50W0G
	NgcXFIfVrlj+YFkOPh8L87eRljF4E96+iDbOMUoNIc1i6r0XP/blkaXZN1CcRLskgtzPC5WRQQq
	bRtV4IYaaPkkPrU4Dauef8ubU4fi5htB+6SE2PvjAID7BH7DajqEMKUqA7i/9JoSfY8IYi0SGzB
	BlYYdbMokl2WbvSZNUOJBUJE4FNmQ4IIqCBS9+o7yGmZx/GQt0U43NYqWUXctMkTxEzwqngZ82w
	YGd7JaRROfEx0ekDH6gIx+DzU5xpP2blmxahzHFNTKwD6wemyh/DGhS2RyVoCkKRwRziIBNOtVd
	ZygCvctEd9ukKHsEZxEwEbg29Xk8T5+3IdzfDVFRXi8j1q1Tr8DIK2YKfVICA9cU=
X-Received: by 2002:a17:902:8308:b0:2ae:c529:a13f with SMTP id d9443c01a7336-2b5f9eb2249mr8309165ad.14.1776399803370;
        Thu, 16 Apr 2026 21:23:23 -0700 (PDT)
X-Received: by 2002:a17:902:8308:b0:2ae:c529:a13f with SMTP id d9443c01a7336-2b5f9eb2249mr8309025ad.14.1776399802903;
        Thu, 16 Apr 2026 21:23:22 -0700 (PDT)
Received: from [10.92.179.248] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fa9ff8d6sm4798705ad.1.2026.04.16.21.23.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2026 21:23:22 -0700 (PDT)
Message-ID: <1badc187-1fc0-4eaa-90a2-52e7fa172dc0@oss.qualcomm.com>
Date: Fri, 17 Apr 2026 09:53:18 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 1/2] ufs: core: Configure only active lanes during link
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        bvanassche@acm.org, shawn.lin@rock-chips.com,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, nitin.rawat@oss.qualcomm.com
References: <20260414093135.660725-1-palash.kambar@oss.qualcomm.com>
 <20260414093135.660725-2-palash.kambar@oss.qualcomm.com>
 <i6mbqvrhw2aggbrofp2p6kdhf3jfo4qdmpu72mhhkuqay4i3ua@hcnezixc2vhl>
Content-Language: en-US
From: Palash Kambar <palash.kambar@oss.qualcomm.com>
In-Reply-To: <i6mbqvrhw2aggbrofp2p6kdhf3jfo4qdmpu72mhhkuqay4i3ua@hcnezixc2vhl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: ehKVEVGiw8mVpCZxr2JF1eKGPVxNa9k5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE3MDA0MCBTYWx0ZWRfXwY/9MQOj+EVg
 PzDUxw1bwUNo5iY0bXQ0gaZQPoBBRX63YRp+1Ztelq69Ea+DS47DirKwfJPVsM3dm4vm7eX/wLc
 F/yfCC9LAjxrKlKZdCUyun8FfQkio6EsZdx/mZ+R6gTQvuwZwRB9PcrnsKS8fu1NE+MJTaeP0pT
 GGWCAIhUCOXj9/NLcchEX23oye3DRIMUH+qxUJRTsKczjtcUJQyVfrmOWptED4Qr0KfzLBCvIVz
 845UCddb3Jdm7bWvSm15qXy1W06FYIpMu06bLDDwJZStvhDtc0h63ticHrY/8Yma4Fbib62+t6M
 aU2ryJzWix0sZvOw5qY5cjUJjshi2bS3GFVli9rLXdOYLQJbuUB/xMoMbUHxIwc10EbgR/nxz1I
 VBeUiTgsTPm7IrQXNYboEs4Tx3PvZSZ80juqh+bIzIRqHXdAP/xqSZCicbRDA9kchjMkgsTDJDL
 MN3gBBOLYzhNKWBHRfg==
X-Authority-Analysis: v=2.4 cv=H47rBeYi c=1 sm=1 tr=0 ts=69e1b5bc cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=Db-oeYxN4i5GQM4S5YAA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-ORIG-GUID: ehKVEVGiw8mVpCZxr2JF1eKGPVxNa9k5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_04,2026-04-16_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 bulkscore=0 adultscore=0 spamscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604170040



On 4/16/2026 4:42 PM, Manivannan Sadhasivam wrote:
> On Tue, Apr 14, 2026 at 03:01:34PM +0530, palash.kambar@oss.qualcomm.com wrote:
>> From: Palash Kambar <palash.kambar@oss.qualcomm.com>
>>
>> The number of connected lanes detected during UFS link startup can be
>> fewer than the lanes specified in the device tree. The current driver
>> logic attempts to configure all lanes defined in the device tree,
>> regardless of their actual availability. This mismatch may cause
>> failures during power mode changes.
>>
>> Hence, Add a check during link startup to ensure that only the lanes
>> actually discovered are considered valid. If a mismatch is detected,
>> fail the initialization early, preventing the driver from entering
>> an unsupported configuration that could cause power mode transition
>> failures.
>>
>> Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>
>> ---
>>  drivers/ufs/core/ufshcd.c | 37 +++++++++++++++++++++++++++++++++++++
>>  1 file changed, 37 insertions(+)
>>
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index 31950fc51a4c..754bf4df3016 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -5035,6 +5035,38 @@ void ufshcd_update_evt_hist(struct ufs_hba *hba, u32 id, u32 val)
>>  }
>>  EXPORT_SYMBOL_GPL(ufshcd_update_evt_hist);
>>  
>> +static int ufshcd_validate_link_params(struct ufs_hba *hba)
>> +{
>> +	int ret;
>> +	int val;
> 
> ret, val
> 
>> +
>> +	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),
>> +			     &val);
>> +	if (ret)
>> +		goto out;
>> +
>> +	if (val != hba->lanes_per_direction) {
>> +		dev_err(hba->dev, "Tx lane mismatch [config,reported] [%d,%d]\n",
>> +			hba->lanes_per_direction, val);
>> +		ret = -ENOLINK;
>> +		goto out;
>> +	}
>> +
>> +	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDRXDATALANES),
>> +			     &val);
>> +	if (ret)
>> +		goto out;
>> +
>> +	if (val != hba->lanes_per_direction) {
>> +		dev_err(hba->dev, "Rx lane mismatch [config,reported] [%d,%d]\n",
>> +			hba->lanes_per_direction, val);
>> +		ret = -ENOLINK;
> 
> 		goto out;
> 
>> +	}
>> +
> 
> return 0;
> 
>> +out:
>> +	return ret;
>> +}
>> +
>>  /**
>>   * ufshcd_link_startup - Initialize unipro link startup
>>   * @hba: per adapter instance
>> @@ -5108,6 +5140,11 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
>>  			goto out;
>>  	}
>>  
>> +	/* Check successfully detected lanes */
> 
> Drop the comment.

Will update as per suggestion.
Thanks.
> 

