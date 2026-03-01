Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E71175A83
	for <linux-scsi@vger.kernel.org>; Sun,  1 Mar 2026 12:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772368836; cv=none; b=sPi4t7M1god8bThuvLX11lHAOpxOlYVtEuAbg3wRBepwlLTPraZnwqW6WlvCMzSy4VyVtNe86soMZxqid+JldhqNcNJg2LUkx4C4DFpCoaw+1sTpLFZ7Xgwn5QKgUiAPbDKisSIPSm43IwmEdp3J8vvYkY6LqLJOX39jnHJ9huY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772368836; c=relaxed/simple;
	bh=vw+fkwP2PkeUCuCO7xVGYAXadZGA94mTZJJckUms4rI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IF/smfFIwoaSpAWG+NvYvqr30Ltvn92zdOh3v2WTULf8WJnSUY96RGMzVvdQBGVSXzaMO5wt1MEDOsQ3TyfrfIiFngYrlY/PlMR68NcCSyeSBqrz6kqsz07CK7HDz7qOGutvGaGNcZ9NcBeyF4aP4RfwhfLr255memjAIwcDMnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ia7tx+Ly; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iTcDp3On; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ia7tx+Ly";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iTcDp3On"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6215t29v4175704
	for <linux-scsi@vger.kernel.org>; Sun, 1 Mar 2026 12:40:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	LycCnKbyfPWAJB199ujELYsvdQeyggfZ/NfmRLGgglM=; b=ia7tx+LyWndaEy0D
	xEI9YKsLr6ZhukR3AVJ+tsPFrYDPvBwcjnSttYzNS36UvFWTYZf9CmJ2Ly5CuBZW
	PTFc9sIpw50+cRvGvRedDxMGUPy3AhZGXoYjoGMtSKHokB2vrE+UxSe7qnmA8mqf
	XmNHiRpaaxgU/zY7oCerWPAwt5w3GMrgn9kMahSpKGrfuiugY1HsqEfit2tLRLlf
	ji9IdNwAwLwtin4WPnrUtSB1khH43j+2GO5seL/un4cewSF+cxa3sITYVXrTqQJX
	XQAp9UdyUJl9uAp7/KKUK2C+BXidNYu3OsaraPWAC58p5ljsmNHJ8UelJ3pPb5+e
	qRkRsw==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ckshktm1m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sun, 01 Mar 2026 12:40:33 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3595485abbbso2598918a91.2
        for <linux-scsi@vger.kernel.org>; Sun, 01 Mar 2026 04:40:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772368832; x=1772973632; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LycCnKbyfPWAJB199ujELYsvdQeyggfZ/NfmRLGgglM=;
        b=iTcDp3OnDjajO2qs6hT6ZegCDvy5833t/bh9gp4Jpv6fJ7xUu69byDCAkR+fogdhEA
         BFmeFl2gloTAEOCjpcKiKfS0xrY0o2Y+Ga7zwK7d4TWRzNbTHheikOj0laxY+R6s8VuC
         2RsV5rhIim9mPg7Iasc5+nWdVc+31pcsX6ObUbTEiO4iPN6LzTb5106tr3LU3tp9NAQ4
         1eVoivCGomWkQiqhYzR57rBLi2HqNVJCoI+RSIqngOdP5mhm1C0Tw+Osta5Ezb97ZO7O
         c3IbIy9QbaxjmCf2ETiafATKSeedeDw/QZmPGUM7DVaogJFsEH/7FZ9hLsV3ZAaDm49N
         pfGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772368832; x=1772973632;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LycCnKbyfPWAJB199ujELYsvdQeyggfZ/NfmRLGgglM=;
        b=lVul5N3HbNpQfonYl/PuGej77aFDUlyd82W88odN68A6oj2ZPAv1XDNMe2tljbwABz
         TUh8esUJrBNB8r/FkB436uW5nONtn197wVEG2kbaC9LSqxNzsaJXidkqZAncwnBGFit7
         Adl6eA0sOL5EFyHGOP5KZEXfXrPMZIUB70RuBeZcEQMBMLip+nvYB7EjfhuCuNhVblPx
         xXmmAh3SdF2uPHeWsTDp9rIOIgh2JW+E8iUungJO+/mxclc+VA2JUoQomgTRqWhvvTre
         4CTg7NuVWmCb3J7/3+rlqM1ELq7AQiGdALgUytYTaQxoAh0MIDpyhY5Ak0hHgX8SUOdX
         kLBg==
X-Gm-Message-State: AOJu0YxvfUKAJUmt+o774DyKqmkkcgAXBEhkPaqWXYmQGz7rxKkPbIWf
	hQfW87us+ybWq/nCHXq4OMzSVvkVnpWXhie0NkqOS2IQ4ZtxDt9ONLYtYhsBG1/QPVxzvmTsE7Y
	SPBvNYUTqv/H1kV5pTv+OwUf3UVdSQJYyvfc5agLDCeAxXRttiUC2eSzz5vsocdSl
X-Gm-Gg: ATEYQzw7TypYWzgXEZbG/Mj0z/IF5lds3Q3gM6ZcUerjNAjFMcLrGcziq291O9NT32i
	EFffO/EqJJfK6ZPJOOKFVIzdDp+/Zari9uopIQ6/VG9TEnRxm2lLDRhr1pmrPmHfW3agGTAuXiF
	N/qW+Cl8QlFiNfNiQ0IBReNq6S+ULw9wYgVRvunRPa/pQhiYtxSd5U+hy8/Zbm0zuis/XRe+czx
	Udi54jYYF7EzmKahbAX49oyPG7q2tOXUZFPrvmOLGUd5E4iYLG6mM2000SjlAsd+r0ldDxPvInM
	B4mVvoNZJKum6JE/aKIKIumPPb9Bol80iPqAjNLmCTwWf5IVFHvHocj50F5ZFlDk1c360Vl4TNx
	NHPIQ4zxyIDD7LHARMQFA1n50mw+GcLCGuDjPj7osTgUnYnc=
X-Received: by 2002:a17:90b:1f8a:b0:340:ad5e:cd with SMTP id 98e67ed59e1d1-35965c17f55mr6829978a91.5.1772368832462;
        Sun, 01 Mar 2026 04:40:32 -0800 (PST)
X-Received: by 2002:a17:90b:1f8a:b0:340:ad5e:cd with SMTP id 98e67ed59e1d1-35965c17f55mr6829961a91.5.1772368831949;
        Sun, 01 Mar 2026 04:40:31 -0800 (PST)
Received: from [192.168.0.102] ([183.193.18.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35988e50b2fsm1382539a91.14.2026.03.01.04.40.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2026 04:40:31 -0800 (PST)
Message-ID: <8b486c76-6597-4b44-bf4a-bddc98aec6e8@oss.qualcomm.com>
Date: Sun, 1 Mar 2026 20:40:23 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] scsi: ufs: core: Add a sysfs entry for
 ufshcd_state
To: Bart Van Assche <bvanassche@acm.org>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>, Huan Tang <tanghuan@vivo.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Daniel Lee <chullee@google.com>, Liu Song <liu.song13@zte.com.cn>,
        Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>,
        Bean Huo <huobean@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20260225022942.345564-1-can.guo@oss.qualcomm.com>
 <20260225022942.345564-3-can.guo@oss.qualcomm.com>
 <7782e4fe-ddc5-4ef4-b632-5c137b31ed73@acm.org>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <7782e4fe-ddc5-4ef4-b632-5c137b31ed73@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAxMDExNCBTYWx0ZWRfX/06sDozjCqvh
 /zrfnGuWHI5sBgn24tKopbpNkuaHyZtfJn4KPYdunN2hexeoE5Wz7Xim0ydD668TGg9pCP+cLWw
 9QAfRr8FnY7xYfFg+c0Pmd2sEE/Ja0MrXKnMFA92IY61qy3rnKG5sgGEdPpi3FgsFHZcwfny1dc
 IaZ2Rdtzsa0qu4tAB7nRyMR7dGVUp/m3JHGyTDKKX9TljxbBa3ykgxWzCU4jLa+E7nhNY8pnjCb
 6kVdHiCwAF1qeQ4a8Yf5BlNY4XtTJYupVdwASNihO72rHSerkBFkeV/mfL99tmHZzaWn30/8fhN
 KQcvMU5a4CzYZ2KUbbbb45Ht6XX5dSIctmhnka5KoX9GQmTO2P4j12d708X2/jlBoH39ndNsz3v
 wbS7NqNw0gXZT57pGZ4pSCrtQGJHeAKURH24f/5owAAlZ7BYRwrhwTxybQyCDUoZwysRG/3VV4d
 s8FIlU+Sd03vtJ8HCTw==
X-Proofpoint-ORIG-GUID: U_SpH0Z4ZFoZmq8yKTKPHYWnNsU1nDOe
X-Authority-Analysis: v=2.4 cv=EvbfbCcA c=1 sm=1 tr=0 ts=69a433c1 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=4/OApUm1v7sVY8kc7hZvWg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=sX_B48vW15oCQFfOEhoA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-GUID: U_SpH0Z4ZFoZmq8yKTKPHYWnNsU1nDOe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-01_01,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 adultscore=0 impostorscore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603010114

Hi Bart,

On 2/26/2026 2:59 AM, Bart Van Assche wrote:
> On 2/24/26 6:29 PM, Can Guo wrote:
>> +What: /sys/bus/platform/drivers/ufshcd/*/ufshcd_state
>> +What:        /sys/bus/platform/devices/*.ufs/ufshcd_state
>> +Date:        February 2026
>> +Contact:    Can Guo <can.guo@oss.qualcomm.com>
>> +Description:
>> +        This attribute shows the state of ufshcd.
>> +
>> +        The attribute is read only.
>
> Please expand "state of ufshcd", e.g. into "state of the UFS host 
> controller driver".
>
>> +static const char * const ufshcd_states[] = {
>> +    [UFSHCD_STATE_RESET]            = "reset",
>> +    [UFSHCD_STATE_OPERATIONAL]        = "operational",
>> +    [UFSHCD_STATE_EH_SCHEDULED_NON_FATAL]    = 
>> "eh_scheduled_non_fatal",
>> +    [UFSHCD_STATE_EH_SCHEDULED_FATAL]    = "eh_scheduled_fatal",
>> +    [UFSHCD_STATE_ERROR]            = "error",
>> +};
>
> Please follow the kernel coding style with regard to spaces around "*".
>
>> +static ssize_t ufshcd_state_show(struct device *dev,
>> +                 struct device_attribute *attr, char *buf)
>> +{
>> +    struct ufs_hba *hba = dev_get_drvdata(dev);
>> +
>> +    return sysfs_emit(buf, "%s\n", ufshcd_states[hba->ufshcd_state]);
>> +}
>
> In the above function, please check that hba->ufshcd_state does not 
> exceed the bounds of the ufshcd_states[] array and also that
> ufshcd_states[hba->ufshcd_state] is not NULL.
>
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index c6c7de7a0603..32a508e1582e 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -7917,6 +7917,8 @@ static void ufshcd_process_probe_result(struct 
>> ufs_hba *hba,
>>           hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
>>       spin_unlock_irqrestore(hba->host->host_lock, flags);
>>   +    sysfs_notify(&hba->dev->kobj, NULL, "ufshcd_state");
>> +
>>       trace_ufshcd_init(hba, ret,
>>                 ktime_to_us(ktime_sub(ktime_get(), probe_start)),
>>                 hba->curr_dev_pwr_mode, hba->uic_link_state);
>
> Shouldn't there be one sysfs_notify(&hba->dev->kobj, NULL, 
> "ufshcd_state") call after every hba->ufshcd_state change?
Thanks for your review. My first thinking was to indicate to userspace
that DME QoS monitor has been reset by host. But on second thought, it
would be much simpler if I just use Bit[0] in dme_qos_nofitication
attribute to communicate that information to userspace, because DME QoS
events are mapped to Bit[3:1], meaning Bit[0] is free anyways. I am
dropping this change in next version.

Thanks,
Can Guo.
>
> Thanks,
>
> Bart.

