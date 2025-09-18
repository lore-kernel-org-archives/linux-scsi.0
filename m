Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D3A246332
	for <linux-scsi@vger.kernel.org>; Thu, 18 Sep 2025 03:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758167484; cv=none; b=OuuNWZ569VfggnqX+0FE6fP4Nd3bLlEJZrHItuHza/KqgcprMH0coO7xhQimGoC+hQK+Qw28UAyD8frkmOpoDI4xvGceQAaM0eT2jOft/xk6SeXp5pPi9l+2gfyx7+yA6D3nkrEIt458u+TVOxBB14WGR0bBQSJgRNX7DikTy/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758167484; c=relaxed/simple;
	bh=Q1UzaGzq6P7C0d3Kk7lGXyHv7WHrKpY9e4KjhTv7BWk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IHc+o0xmTNgDkBR6tXDgWmOg/7XvLjJhHPP7t/K1CboNb170gTZ/vyDC+YoD0v/EM9AybR4XUzSHX0m8Uq5xSj+/R9k3AtuH5+P6NrBfnvaCjVRR+O5aeFm/EL7Rwe8UimAVNj0k0/e78/2hy5+Fq9N1HYxN3i4ImMYPSA5ENAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=lBPjrEJ6; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="lBPjrEJ6"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HGOwCW029503
	for <linux-scsi@vger.kernel.org>; Thu, 18 Sep 2025 03:51:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	cePgynOkPX0i4e0Q9p8l5Ioe+AP3QhPUc3Tf1eOnDf4=; b=lBPjrEJ6jzCXTtUF
	J2cyIIFzpRyFL+1O37uXTJHCrkYmtt5rrJrODGgwaFXe4NMwTa08iTdpLovWk5vb
	rU/viROc63w0qIC7RxY+rs9QT1lAxPM7gyM5sgSG/3lWbTVYpumMzJJ0ORCtnqc9
	B3x3UuiwUr9i6zmOIyVxKKHT7PuvRmN4kX6XOKgNd/WA8Ni0+TxxEEdxrz61SENA
	StMf0D0690ZVrw4pRWTRrFK+73poCJ5EYpsOjxru5BFz5dhMBKjVU9ThXgu+ZN8r
	qNZFtZ70VxRaKccCrFz9+KAoIUGyFkyYqmXiFaArgli92t+wKmr5zPjcS6mZkLM+
	EoN/Hw==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 497fy0vryh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 18 Sep 2025 03:51:21 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-76e2eb787f2so601034b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 17 Sep 2025 20:51:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758167481; x=1758772281;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cePgynOkPX0i4e0Q9p8l5Ioe+AP3QhPUc3Tf1eOnDf4=;
        b=Zig7N9QfHvOjF61sQH7Ti7v/dAfCuqQgSWdZjaYqYUtm9v8REiMJp9KrtuECePfk3m
         TzE9xQ2dlygOXNNywu/2URL5sbVDf8i9JN8gmuPBOlR5qeO0v5dijmznxuCDOp08Gi7M
         +pjlz3enqNnl3ETge4wLpDh0pdBjquKYJX9XMmbp2zCfK8z/MzHcDB8PCAG6gXSH26dU
         2cl3ZFWHQ8PO7U4VluUJ/iGqFrRIj+6bpnnRnLHXTXilHM8sjWTXAkc2wSgO5TGD92TT
         Zfxb6bRvoNQVkcr/9DzSiQ/9qxaxzQAHBT28XS1uUgCjyLC+5ZBVyqpP5kT1jVFW9eJ4
         fpZg==
X-Forwarded-Encrypted: i=1; AJvYcCX6SpxfnHcufWzLoUjB44pW6Y6iEzvwiStZGQ7cqaVLR2DY6Yjcp8hgRZI8ZOR8i+CSWIFj+lens/Vn@vger.kernel.org
X-Gm-Message-State: AOJu0YzUjjnJP5lzubcukXgp2bG7dgVPPqnhg7wohmFb0MEECIUbU/p/
	dAd9WMlY92N3tzGWZMo3QIypCaMy8R+qmUaY1gMy5ShgFE8TC55mj4YDAR7dSjhjFjqEjLbx39y
	HvaM/am4lGQp03vza3YFTul6NdujVpOij0WFZ5DPIjH03bOr/bjuY4WSIAdQymqcTeEnByZb5
X-Gm-Gg: ASbGncu/oLToCgIKcGhrCXj1PJbeCSAC1N7IbwgkYiS8qz2hd91I2iWkeJv7wnxQ3pR
	DpJMLi3GqS481UoR3qjVMb+7EYYO3RATPiaBY5OMD6DjjK6m4SnWx6/AULevCCe1IpQGXupZiwb
	eB2NlSUILvg+S91oYx67cTI6sGvN0g8ZXssan5ZKnQsPCzr5x8FGCcuwteQHF0Mg+E2s/DtEOyr
	uAbFC3YqBY0puiK3M+OxYqs2wGF1ZYby0wtPyaGeU6vzavtuyaUnkuLhc6EDuYEUopoQ8FUCmQn
	ayc9i3YIeimXqiEqIdbEhrOVC8ePPpEIrbBcZa65GytyOYFGmYXKwYv3siNUZ+1CK9ySDnBir0y
	7DsiNGs+/uQerNsq8BOAbVzHXer+hdUU=
X-Received: by 2002:a05:6a00:4392:b0:77c:6621:6162 with SMTP id d2e1a72fcca58-77c6621647emr4411196b3a.28.1758167480674;
        Wed, 17 Sep 2025 20:51:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFj6GV6QHFCCeginqyDRstH/fVNtkFoMluD5I+944GanVZgY3iAf5Xsxm9tV9NQfEx/bXULLQ==
X-Received: by 2002:a05:6a00:4392:b0:77c:6621:6162 with SMTP id d2e1a72fcca58-77c6621647emr4411169b3a.28.1758167480204;
        Wed, 17 Sep 2025 20:51:20 -0700 (PDT)
Received: from [10.133.33.249] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77cfee2d7f6sm863367b3a.84.2025.09.17.20.51.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 20:51:19 -0700 (PDT)
Message-ID: <9f2cba57-1d4a-4541-b127-5d207e4353c9@oss.qualcomm.com>
Date: Thu, 18 Sep 2025 11:51:12 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: ufs: core: Fix data race in CPU latency PM QoS
 request handling
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>
Cc: "tanghuan@vivo.com" <tanghuan@vivo.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>,
        "ziqi.chen@oss.qualcomm.com" <ziqi.chen@oss.qualcomm.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "quic_narepall@quicinc.com" <quic_narepall@quicinc.com>,
        "nitin.rawat@oss.qualcomm.com" <nitin.rawat@oss.qualcomm.com>,
        "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "neil.armstrong@linaro.org" <neil.armstrong@linaro.org>,
        "liu.song13@zte.com.cn" <liu.song13@zte.com.cn>,
        "can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
        zhongqiu.han@oss.qualcomm.com
References: <20250917094143.88055-1-zhongqiu.han@oss.qualcomm.com>
 <c28785e6db14f383cecea3e2b047adf0e928c4cd.camel@mediatek.com>
Content-Language: en-US
From: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
In-Reply-To: <c28785e6db14f383cecea3e2b047adf0e928c4cd.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 3Z4liSj5ORVKBi2idDIR86zXc2hGkHbr
X-Authority-Analysis: v=2.4 cv=btZMBFai c=1 sm=1 tr=0 ts=68cb81b9 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=Z4KVirGCbA_36vunRFwA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-GUID: 3Z4liSj5ORVKBi2idDIR86zXc2hGkHbr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX/9tiajUDepuK
 uz2BV81TFMNeuOh6pztqvWxDjDAedj9Fe+lCf9PYTCUTUr7p86X+yCkIZTOSFMXEPv2YD+CDe3b
 LL3/dCwoTP4kR4MyAdZ7fVF3Trh3L9N1toSD2uhZvgPlvyuN4w1+kVr7l0Vpp3RZeCVc8Ryl8FM
 dna8PE4SbHkQdYw8idxKoNIFtZgEHxJCZcgpgXbfdEcwy/TT4xeGIagTf6S9V+HEj/OdOzkbEAS
 Cb9OpAiEf8yaU/URMXbq8McuPBbnXFX9J8YAduSB7jZ/oGCvniW2b0iCc+h+PvDe4QyRv6VmIt9
 v1bihv6jUzV0eXHRyzk8shHbnzgqqGjYAjkU1llGRd7o4Ps8Dje20lmu2HFNwmMfNyiPBn7yu+q
 QwyyKWYE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 impostorscore=0 clxscore=1015 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 suspectscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2509160202

On 9/18/2025 11:16 AM, Peter Wang (王信友) wrote:
> On Wed, 2025-09-17 at 17:41 +0800, Zhongqiu Han wrote:
>> 
>>         ufshcd_init_clk_gating(hba);
>> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
>> index ea0021f067c9..277dda606f4d 100644
>> --- a/include/ufs/ufshcd.h
>> +++ b/include/ufs/ufshcd.h
>> @@ -938,6 +938,7 @@ enum ufshcd_mcq_opr {
>>   * @ufs_rtc_update_work: A work for UFS RTC periodic update
>>   * @pm_qos_req: PM QoS request handle
>>   * @pm_qos_enabled: flag to check if pm qos is enabled
>> + * @pm_qos_mutex: synchronizes PM QoS request and status updates
>>   * @critical_health_count: count of critical health exceptions
>>   * @dev_lvl_exception_count: count of device level exceptions since
>> last reset
>>   * @dev_lvl_exception_id: vendor specific information about the
>> @@ -1110,6 +1111,8 @@ struct ufs_hba {
>>         struct delayed_work ufs_rtc_update_work;
>>         struct pm_qos_request pm_qos_req;
>>         bool pm_qos_enabled;
>> +       /* synchronizes PM QoS request and status updates */
>> 
> 
> Hi Zhongqiu,
> 
> I think this line can be removed to make the code cleaner,
> since you’ve already explained the purpose of each parameter above.
> 
> Thanks.
> Peter
> 
> 
> 
>> +       struct mutex pm_qos_mutex;
>> 
>>         int critical_health_count;
>>         atomic_t dev_lvl_exception_count;
>> --
>> 2.43.0
>> 
> 


Hi Peter,
Thanks a lot for your review~

---
In Patch V1, we got below info from checkpatch.pl strict mode:

include/ufs/ufshcd.h:1140: CHECK:UNCOMMENTED_DEFINITION: struct mutex 
definition without comment
+	struct mutex pm_qos_mutex;


So since V2, the comment was added. I want to strictly follow the
community coding style guidelines. Thank you~

> 
> 
> 
> ************* MEDIATEK Confidentiality Notice
>   ********************
> The information contained in this e-mail message (including any
> attachments) may be confidential, proprietary, privileged, or otherwise
> exempt from disclosure under applicable laws. It is intended to be
> conveyed only to the designated recipient(s). Any use, dissemination,
> distribution, printing, retaining or copying of this e-mail (including its
> attachments) by unintended recipient(s) is strictly prohibited and may
> be unlawful. If you are not an intended recipient of this e-mail, or believe
>   
> that you have received this e-mail in error, please notify the sender
> immediately (by replying to this e-mail), delete any and all copies of
> this e-mail (including any attachments) from your system, and do not
> disclose the content of this e-mail to any other person. Thank you!
> 



-- 
Thx and BRs,
Zhongqiu Han
