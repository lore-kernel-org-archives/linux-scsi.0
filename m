Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91168386C25
	for <linux-scsi@vger.kernel.org>; Fri,  3 Apr 2026 11:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775217544; cv=none; b=WHNf/E2LwQ40K8oCbqYjG088qfky8a3OBatJtE5n4tzHV6bDem7enoWnLx4eOY3LiPqsFyl2gnnhCmD7XPBZys7gn8a98sAJ6TyTZVr3cUTJ4Fy81fedyl0GNaVF4ZKsFhn8U1kdvxZuZ4nLjmG5EOx1HPMHpAn8tjS19J9vyTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775217544; c=relaxed/simple;
	bh=VdDqFLBRGI8N+m3XIIgjgCnSsQ+lqeTBaslDzgYOLLI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tR/H/24lNhgkXIer2LqkVmgJFMRuoGyAlj5+SmLOo5/h/mvK0kAaKmQxB2aTuyOgdATyPXR1gE87hPGcTfNBpBS5HJ/PQ3eZKcqaTB1XGy0N7OcPlMnewIVjiGlSKfajoIF0jZK4Xf2XrJ06DE3iiAt4UO//uumQSXThbbx3TEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hekn4g0r; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=K4mHRrHx; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hekn4g0r";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="K4mHRrHx"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 633BMc80982208
	for <linux-scsi@vger.kernel.org>; Fri, 3 Apr 2026 11:59:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Y6FSfCNss0WGbrLRmtEKpCH49PaDXVZ75wV9fa1v334=; b=hekn4g0rkwY8LM+u
	xixae2WYCWWnPmKBpBPD37o1iiyjkeYhBMdU8ClC37SVPcu556dCdNICvKFdodV2
	jzgek+Sisymt4CMeQ6REC9eRHHwHXZ06Yey/KkgTKGmqlh7GSGiZOnro7QIVolPo
	2EwtM7qrskk9u4h3KhCS/T22M4l7qytyN603PGA4K5wlrIHD/Hj9gsHbUGBvY7YX
	Tp4Kucse8b+1eM5lDNyeLNc1eH0VNf9NUBg+fY0N1GMx0KWTrNmQv070zO5NXZoF
	+09dPVIsav1F3rQHj2uL1Qoe+OwCiEWdj15CTwLwZWxlHk7T7QAlgvae5YDKv0B6
	haL6vw==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d9tupudx5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 03 Apr 2026 11:59:02 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-82c675116f1so2654670b3a.2
        for <linux-scsi@vger.kernel.org>; Fri, 03 Apr 2026 04:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775217541; x=1775822341; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y6FSfCNss0WGbrLRmtEKpCH49PaDXVZ75wV9fa1v334=;
        b=K4mHRrHx+SxdjTfdK5FrrWV77UjdBMpFL/4RMrOzeQMgqTR2VdIvcG1FzuqkJ2iH7g
         Iz99Is7SuTJ3hzPyVMjcDUjY0p4Ov7Gf4Q8nqnji+j8yt/L5rpvInTji8iVAEVW9XFEC
         j3pxRFcmD30EO5Nvlq0aCxSKZhWGWE6/L37DZFi27okXYbpJWrZws9VShKFtJMYJ1gSA
         xjfsvpEdGjqhUF33bIjTudF1DQ9+1hC4WzpbRDWn2wD7TmOUilr5ZBzNAphnlM82+ui9
         SwPOkNt755Tz383nrvdIFCYzTY4nm46k428XtV+A8Cv8ABCm4lw4R87EIoTRGXtfgJp6
         tWdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775217541; x=1775822341;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y6FSfCNss0WGbrLRmtEKpCH49PaDXVZ75wV9fa1v334=;
        b=M1kyienf5YJs2FqJDbTTVOOwzfP7yrZr7/bpJG+kEZpYCha6OhhldDWc2s/xiCbyZK
         96PY6LRTdA1vdyyi/GAYl6JFH9McV2oK3uCAjcr5QZXD0NJAxWv4SlyZ+Zo9ZnvbZVQM
         Jm5exrZ7VbUy8Yx6z2zOLNUnnUAI9YE5dZH3oVCwk718AFCSsK/c720e69UjKYL3IOSa
         aJRZ1ffUHIQla9QEHydA12df29j0rmlrhz6XQ1vr4HT7nH9b5pIxwckuWt1ligIvcJU/
         v+xNg3pgUffkzNmoe25ufLYvo0+NxCV9B+Wgyojx2kAtH8nw2vZUEk+u/Zl/s4dmY/lP
         Om3Q==
X-Forwarded-Encrypted: i=1; AJvYcCU/Br9cAZ0XDY+Nkrkf640xN2SdilzIGXebwOydaP7pFNqgBUDAYd2vWyUwcDfPdopetTc0l62W2J1Q@vger.kernel.org
X-Gm-Message-State: AOJu0YwTR2EJ8U3IPTmWKz2b67drl5Ej9BqD/a/3WnSBujPmNZ0CeFcM
	jD9zFROWaQ2RKe+t/8HQfTL8aze/9oQS3xlV66l9PnqL15R6XsnzPI434+1RHB3MeA0kH5c0cv9
	x969XHrMaqw7775qvuflswyqi6pYLCQCArhiI/7qnaPZGKcUjVMtf8qhPVTMVMAu1
X-Gm-Gg: AeBDiesZbIGACr9C1AE9Zput/J3wddLOqux5nv64h+5uGxKZ0AtUdkixwC0Bi+TCqxe
	YEKfKG81t9Mhz8g/VjI5pNu8ZZOuHs0uV9gXwid3d5pozP3BPXOroVVygpJxKW/z9fwVrAIjznO
	WVo1eEd9c3oFaXTq3qzekPpF/rPi9GytSQm/reOuAcB38+wZnNNv0hP+kN/Rp1u9laLKd4ca0zr
	nHlE31LCt5QUtANW0bKvcr+fT00x+qGcSVZWeq2jNbAiK54i5gTjxzPu/86FRWlJJQs9JwzWlie
	ys6Ddeff9RyjcZ5XwriewIrTKC77VVURpSEdwoYEM1+XkfadC/ZBG1c2Z3Ma2bSO8awOz5aHjsS
	zVGcujfIGbntBAcWh4Jbq4dN1HJsor9dJTMekjTzudBM9EfCUr6g=
X-Received: by 2002:a05:6a00:181b:b0:82a:687e:c048 with SMTP id d2e1a72fcca58-82d0db7e13dmr2833570b3a.30.1775217541344;
        Fri, 03 Apr 2026 04:59:01 -0700 (PDT)
X-Received: by 2002:a05:6a00:181b:b0:82a:687e:c048 with SMTP id d2e1a72fcca58-82d0db7e13dmr2833545b3a.30.1775217540848;
        Fri, 03 Apr 2026 04:59:00 -0700 (PDT)
Received: from [10.92.178.97] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9c747fdsm5780678b3a.50.2026.04.03.04.58.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Apr 2026 04:59:00 -0700 (PDT)
Message-ID: <3eeeb94d-a8ce-43e2-bdd6-642e36cb277e@oss.qualcomm.com>
Date: Fri, 3 Apr 2026 17:28:56 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 1/2] ufs: core: Configure only active lanes during link
To: Bart Van Assche <bvanassche@acm.org>, mani@kernel.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, shawn.lin@rock-chips.com,
        nitin.rawat@oss.qualcomm.com
References: <20260327090346.656324-1-palash.kambar@oss.qualcomm.com>
 <20260327090346.656324-2-palash.kambar@oss.qualcomm.com>
 <c8ae2a1e-e42a-4591-839d-e22f93ab6b17@acm.org>
Content-Language: en-US
From: Palash Kambar <palash.kambar@oss.qualcomm.com>
In-Reply-To: <c8ae2a1e-e42a-4591-839d-e22f93ab6b17@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAzMDEwNSBTYWx0ZWRfXwoui8jjjOXwq
 7YhFQ3QmJtomht0ChEaD/L0wSrYfBJyxFXBliNh3gmzaaiZnjTYTQiV7Plex4vR5s62dq91Dfd6
 KIb4b9hcqt9EkRk4axwEBGbREWNoMmo8K6dm7FbzfkpsXck47Q85/N7BsXIrJ4eyov7Yi+F3Q/8
 RHk6Lu1G3t7RryUhFz2newdQtvZlE2erytXKo9K3UHnhrES0tyS8mfaZQrkzO52fyPOxR2ecCdN
 36YQXlK0DncMlQORW11ywsf94wxxB6PBbI4QDnIwOylpFAqyyaOYroLZaNK+jPnr1siFNeKvDTa
 lx18M9KZMH1w+tmCbHpk+Pwod8O4KcvBSk+PnpBcQd/1Gd4VULcdJMZsxeyw8hTPuc2hz7MclvR
 p0Yhwrczx6PYVSsGASbnkYV7XEaCCS/wL+Gar2MzXfJ8HjeGFDa+5cbl4esAZ1khKQ6T0YHcheo
 8n47qRPUVF4TkFKxwzw==
X-Proofpoint-ORIG-GUID: mf5dV1KC9GDWV34dNE8YAUCx4emF1HM7
X-Proofpoint-GUID: mf5dV1KC9GDWV34dNE8YAUCx4emF1HM7
X-Authority-Analysis: v=2.4 cv=DZ0aa/tW c=1 sm=1 tr=0 ts=69cfab86 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=8rK0MGtTfqIXTTsz8cQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-03_03,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 adultscore=0 malwarescore=0 clxscore=1015 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604030105



On 3/28/2026 2:47 AM, Bart Van Assche wrote:
> On 3/27/26 2:03 AM, palash.kambar@oss.qualcomm.com wrote:
>> +static int ufshcd_validate_link_params(struct ufs_hba *hba)
>> +{
>> +    int ret = 0;
>> +    int val = 0;
> 
> Both initializers are superfluous. Please remove at least the
> initializer for "ret" since the first statement in this function assigns
> a value to "ret".
> 
>> +    ret = ufshcd_dme_get(hba,
>> +                 UIC_ARG_MIB(PA_CONNECTEDTXDATALANES), &val);
> 
> The formatting of the above statement does not follow the Linux kernel
> coding style. Please format it as follows:
> 
>     ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),
>                  &val);
> 
> A possible alternative to formatting code manually is to run something
> like "git clang-format HEAD^" from the command line.
> 
>> +    val = 0;
> 
> This assignment is superfluous, isn't it?
> 
>> +    ret = ufshcd_dme_get(hba,
>> +                 UIC_ARG_MIB(PA_CONNECTEDRXDATALANES), &val);
> 
> Please move the UIC_ARG_MIB() to the previous line.
> 
> Thanks,
> 
> Bart.

Sure Bart, will address these comments.

