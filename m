Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8116C19F137
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 04:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767157057; cv=none; b=uTESDQ9CKl7i7vL5P8iJQ9m624QuY67SaNHGqdAUuGtqLKi3yjC7bAWSVLkeeTIKdSTnE9yz4OsLVlJ+2Xusd086QAaIj70Xqqz61axDPQ/b76JeFz6F+/yN3pvKOi4MR6WwoMloLUImhfpgAscazG+D2vjgNY428vVbU3csbaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767157057; c=relaxed/simple;
	bh=nRnDSxaO0a1stVgF8xWHRpYYW1TnOZwqY8sNVXpPqaI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vEd0rGmDRU3KNyi15eJt9L69G0Ht3oGc0DEINF2GY+niQvU/8K7zuy/UyRJr9eFPgonyCFVEVpzGoP65UeTycp8g0L3Z+qaFhuezbUXGV5W/hXiWkYYW1SaS34fICcKfVbkUI6PigLuL4g/2HCKbjhICXgBG1Q2OaC2ANQ3YsHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kXmaVh8r; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HHaT3Q/v; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kXmaVh8r";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HHaT3Q/v"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BV4o5Ad1429017
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 04:57:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Ks5UXgo+vhH090NmXm3avHA2qXaqWvSkBGaUCGSgJBc=; b=kXmaVh8r4UkcesTY
	qc0YJrjzg+lnquHfI/MDmOhiwegbRk1yGdrxUJgpYbNv4L52c5t1qgQtOy6msbnD
	MhSMQXF9p9itFApOgbX9xOTkm9kDWaUVzLY+LNxTrlEXB8Q3obv/28K0l0ia/+Nc
	sbRAIb3xWo7r98qv4JhkPG89ztOTX/5wORw5VPdjC7mYZYCrgnjC/oOjLLZugYoc
	lyFiWp+TaniT23FPw8K278WEcAJS036mLYm3G5neKC1nt83XHswfuWtKIQEAqNr8
	yP+h1fCr6A+HB5aOo1V2GYXzaEHHSogfjDaK50vx3uPi4x9r7OiJ9bvCXQi0ncK5
	3TtfNA==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bcw5e00c0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 04:57:34 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2a13be531b2so227752915ad.2
        for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 20:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767157054; x=1767761854; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ks5UXgo+vhH090NmXm3avHA2qXaqWvSkBGaUCGSgJBc=;
        b=HHaT3Q/veOO479VKBRqrKO1dEbBq7wRX708kIZd8Q4jvdEikQOSJz/SmZ1xvejgv1n
         ca3CvvELquKuerJ0g5DGqfuuWmNzFOowLOeYMLhHcHqV7RqH3N9wkr2a6AUnUnJ8A3kj
         rO4oAfDFY+DMhka43VMOwOzOihB5igSWN00c7DE3v+smy+6gCcW61SDIj0uEvrbsf5zY
         qFnBNmckJPirxdPUNrHnp1NpKVS4S4zrS6+HnyxhhLAK+psTJdypnFUR2qErELnPWRG8
         LkmS1szdSGxq7l/uDPPUb45eErL5F2q4cOFYNumCwNUImJIUDB4uarggkGlPN/ocurJq
         8wYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767157054; x=1767761854;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ks5UXgo+vhH090NmXm3avHA2qXaqWvSkBGaUCGSgJBc=;
        b=GfFNaX9CcU0br5BRm07MvKJulmQ/SekkVjgQXrwx5F1Tnu7kIK4EFKe/tcGh9MiBy7
         E/4/czM60V7Hai0ybab7Wt8fA3Xs1AOblOw82ltdheOSR3EYHLPC+0U1JKSpMdzGEE//
         Aw2/K5ZP2rdrr1FlQttz76LYgR4jyd8l9+wDKlTrTTJltWssX48TfAwc5Fmr0nfuHReu
         H6OMsejW9zb++DCkO0CovEsVmGNl6edWS6WhUFcbYh0D/TesY49O7cn7JDZi8QLp9DwX
         Un3p/lYNmFynYwVKACH4+lANsOvH0cIFCQJX2tnqnDRf+8F2SXdHHR+IpPhwSeSNiTK+
         6Z1w==
X-Forwarded-Encrypted: i=1; AJvYcCWjzM/0xFu4Sc/aft3E0WiNmBC6Y5Pmyhcz4dGfQKbMJv4F8lphglaHCkxX8DL1qnGEAqhzGY8m7ry/@vger.kernel.org
X-Gm-Message-State: AOJu0Yxnk1n7pfgacOopu0l8a5tZExyHricFrxvVMAfL0LdtFzzNDSnK
	IQsEZzicPGf3lf7E8gic7SYZbdirWkwvso7uUoAkVYfNkPY4JQfzEclhR42OKx6u1+l2O/ibLNv
	b9UzNnamS0cJqLjcarUjxFyXC5aWQbbL05RHh+zgh6TtDIyugYOLrDo0Fe8ROzK4r
X-Gm-Gg: AY/fxX5ogZ+dRmD6QdzjjrChRsG9RV8ntEn0SpFQuvHQ324UujXjUNPumuu1Qx82BG9
	DCB+I/PYjuzsj0DtQ60tr5j1gtnhS0D4Ipl0gA76fJAiN14HjLjBDndO0t4TUKAZotAew3t6Cny
	IxDvTSk1aPvwsEJnzde3IKh4KO7w/3NiI0bh4SOXZZM0N8xh1A1EhLaFocI/FV8yTuCIaxGaP8y
	GKyoJI/NUmCTuGhZmsggsQj/d619RODozjldt/frnypuqXlw8iQWORcKA7UCQLB7XHZGre0CfbB
	3sw3u8hJB31lqQUlxHqBV3z+h0zohoKI63nRftKc+dMuvEcayyNmcqF4oUAIlxa2Zsl4fANFi2J
	Dl57Wr7nbD/QugPfkhX+ZgbsHr/1a7U0u6L3yV/70
X-Received: by 2002:a17:903:1a85:b0:2a0:acca:f3f2 with SMTP id d9443c01a7336-2a2f29370d3mr326717905ad.48.1767157054161;
        Tue, 30 Dec 2025 20:57:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGn3vmxsqgSirQ9sc3GALEuNjn6LQqOGszUghtGapmtZGCmqf6QjnlT2OI60YLyn0Ad5nuvvg==
X-Received: by 2002:a17:903:1a85:b0:2a0:acca:f3f2 with SMTP id d9443c01a7336-2a2f29370d3mr326717625ad.48.1767157053701;
        Tue, 30 Dec 2025 20:57:33 -0800 (PST)
Received: from [192.168.29.239] ([49.37.133.221])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e7c7263a3sm28803816a12.32.2025.12.30.20.57.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Dec 2025 20:57:33 -0800 (PST)
Message-ID: <d437486c-b782-48a3-a7ab-665cca769c79@oss.qualcomm.com>
Date: Wed, 31 Dec 2025 10:27:21 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 3/3] ufs: ufs-qcom: Add support for firmware-managed
 resource abstraction
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        quic_ahari@quicinc.com, linux-arm-msm@vger.kernel.org,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Shazad Hussain <quic_shazhuss@quicinc.com>
References: <20251114145646.2291324-1-ram.dwivedi@oss.qualcomm.com>
 <20251114145646.2291324-4-ram.dwivedi@oss.qualcomm.com>
 <avpwp57yqkljxkld7dsqdsc7m26wvmwwhvph6ljv43yjjdyqof@szlfmik6betd>
 <fcdeea3b-f20e-4b6c-9c64-5479f75b05b9@oss.qualcomm.com>
 <64hjdpdc745gazdzz7vuauhl5cohbfz2cgxb2yz2bt6mpezyb7@i2fyze7ozbc4>
Content-Language: en-US
From: Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
In-Reply-To: <64hjdpdc745gazdzz7vuauhl5cohbfz2cgxb2yz2bt6mpezyb7@i2fyze7ozbc4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjMxMDAzOCBTYWx0ZWRfX0HBEdCc8Xeh8
 29gSxL+iFHSH+tpcjA14ULWjk9M38grMA3oQNstNys8rdgv/kbkmLVjen92EfiJS3h/lCWx/o/e
 NOU7ht83o76ash2OvcD6dui8tzLt4RyYzdq2mEwcZTHQlx9s8q/8utbytF/kFwlycZe2JIv/Txn
 AiQUfsXSE3aExKhZe07Vu+q+WusN129fiS+GdRjQrGfEc3pbn2jpyrTJrxo0ukprKWPkpAQVZuL
 NtiVVYZ6zvcgwYhNKTlY+g/WiCfCRB2QsQWVR3SSuwdqCDYixTRe4X3oAVGhq6BerJVpE0UNsA4
 wJz5K/JdvD/s0mh2AigJqd0WfLmn/YpyWl2GvUqix+n7MEf77KDkNi++mMiCVcqbiqVbJ5ismCL
 m7ZUjGBpvO6QninMmUYEQv5KSzXUjx8z2wMRI4N5K3scCcupBcG6ZsxkgnY224bgDjjYMBBELI0
 jNEfgcQXrrOqsmi/b0g==
X-Proofpoint-GUID: 88dvm0lcLDks0Bl62xowXIw1z18SUpIU
X-Proofpoint-ORIG-GUID: 88dvm0lcLDks0Bl62xowXIw1z18SUpIU
X-Authority-Analysis: v=2.4 cv=Mdxhep/f c=1 sm=1 tr=0 ts=6954ad3e cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=+/UKhaqxHMWBDOh8pPecxQ==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=COk6AnOGAAAA:8 a=n3v4BAOmL911Yo7HB7gA:9
 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-31_01,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 priorityscore=1501 bulkscore=0 suspectscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2512310038



On 12-Dec-25 6:15 AM, Manivannan Sadhasivam wrote:
> On Wed, Dec 10, 2025 at 09:33:08PM +0530, Ram Kumar Dwivedi wrote:
>>
>>
>> On 20-Nov-25 11:23 AM, Manivannan Sadhasivam wrote:
>>> On Fri, Nov 14, 2025 at 08:26:46PM +0530, Ram Kumar Dwivedi wrote:
>>>> From: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
>>>>
>>>> Add a compatible string for SA8255p platforms where resources such as
>>>> PHY, clocks, regulators, and resets are managed by firmware through an
>>>> SCMI server. Use the SCMI power protocol to abstract these resources and
>>>> invoke power operations via runtime PM APIs (pm_runtime_get/put_sync).
>>>>
>>>> Introduce vendor operations (vops) for SA8255p targets to enable SCMI-
>>>> based resource control. In this model, capabilities like clock scaling
>>>> and gating are not yet supported; these will be added incrementally.
>>>>
>>>> Co-developed-by: Anjana Hari <quic_ahari@quicinc.com>
>>>> Signed-off-by: Anjana Hari <quic_ahari@quicinc.com>
>>>> Co-developed-by: Shazad Hussain <quic_shazhuss@quicinc.com>
>>>> Signed-off-by: Shazad Hussain <quic_shazhuss@quicinc.com>
>>>> Signed-off-by: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
>>>> ---
>>>>  drivers/ufs/host/ufs-qcom.c | 161 +++++++++++++++++++++++++++++++++++-
>>>>  drivers/ufs/host/ufs-qcom.h |   1 +
>>>>  2 files changed, 161 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
>>>> index 8d119b3223cb..13ccf1fb2ebf 100644
>>>> --- a/drivers/ufs/host/ufs-qcom.c
>>>> +++ b/drivers/ufs/host/ufs-qcom.c
>>>> @@ -14,6 +14,7 @@
>>>>  #include <linux/of.h>
>>>>  #include <linux/phy/phy.h>
>>>>  #include <linux/platform_device.h>
>>>> +#include <linux/pm_domain.h>
>>>>  #include <linux/reset-controller.h>
>>>>  #include <linux/time.h>
>>>>  #include <linux/unaligned.h>
>>>> @@ -619,6 +620,27 @@ static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba,
>>>>  	return err;
>>>>  }
>>>>  
>>>> +static int ufs_qcom_fw_managed_hce_enable_notify(struct ufs_hba *hba,
>>>> +						 enum ufs_notify_change_status status)
>>>> +{
>>>> +	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
>>>> +
>>>> +	switch (status) {
>>>> +	case PRE_CHANGE:
>>>> +		ufs_qcom_select_unipro_mode(host);
>>>> +		break;
>>>> +	case POST_CHANGE:
>>>> +		ufs_qcom_enable_hw_clk_gating(hba);
>>>> +		ufs_qcom_ice_enable(host);
>>>> +		break;
>>>> +	default:
>>>> +		dev_err(hba->dev, "Invalid status %d\n", status);
>>>> +		return -EINVAL;
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>>  /**
>>>>   * ufs_qcom_cfg_timers - Configure ufs qcom cfg timers
>>>>   *
>>>> @@ -789,6 +811,38 @@ static int ufs_qcom_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>>>>  	return ufs_qcom_ice_resume(host);
>>>>  }
>>>>  
>>>> +static int ufs_qcom_fw_managed_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
>>>> +				       enum ufs_notify_change_status status)
>>>> +{
>>>> +	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
>>>> +
>>>> +	if (status == PRE_CHANGE)
>>>> +		return 0;
>>>> +
>>>> +	if (hba->spm_lvl != UFS_PM_LVL_5) {
>>>> +		dev_err(hba->dev, "Unsupported spm level %d\n", hba->spm_lvl);
>>>> +		return -EINVAL;
>>>> +	}
>>>
>>> You should consider moving this check to ufs-sysfs.c where the sysfs write is
>>> handled. Failing due to unsupported suspend level at the last moment could be
>>> avoided.
>>
>> Hi Mani,
>>
>> We have planned to support other spm levels also in follow up series
>> once the basic UFS SCMI functionality is upstreamed.  This spm_lvl check
>> is intended as a temporary safeguard while we only support SPM level 5. 
>> If you'd still prefer a change, I caupdate this in the next patchset.
>>
> 
> Please do it now as I don't see it logical to error out in suspend callback.
Hi Mani,

I have addressed the issue in latest patchset.

Thanks,
Ram.


> 
> - Mani
> 

