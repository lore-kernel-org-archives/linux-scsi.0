Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792741542;
	b=y+wWOBIDdIfRZd7ALaBOSRcglF1L93G+n1bAKvB4VqC7/7dc2/3UEL6H28KYAIGADJtL
	 9ImbyzB7Q7uwviguaXZaNDavonzKzJ/O2qBu/rn2EyTFAuSr+QHGh+NpQEQvlpNeNWZ+Z
	 psaNL5680uZoYRvamnmTCEv0LU1lQaeGMmO6t5846QvB3Hg+y68QUHs0ZGI8NAgciXQur
	 nTmIyXEhceCrHVoFnViQWyG0MvUWD0wUgZaaUytL+z0D8VkCcQu/VYJ1OKNRMubcjc2i9
	 phWtI+Xeeb4/G2xe37hj3PMPlRQU7jB5A8AzvFVoJr0P9UqpVrY6Qfw9fpvx6BUbNHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792741542;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=IEyRBF8vnbm1/HQ6cJJHHKiX1zU4rFzUPX8p8n7sqjI=;
	b=DOW65TGIWV508x1dd3tuN1aKVcmLQMysod8O1Eekb/zy7HZ8VOfsUfL8b4o/B4rr/XKj
	 wqKj1UpdJpBYlYAz8P+JL25SxrINwgEmQhntLq9I8jVFQJI4j3kP1nxR1yfwpjqUD8QZJ
	 TrDyOd3QEpC1yzQBTyp35QBsiyk21uoF4x16jo20ePMkG04longkF5k9B+V1XFpqV8q8V
	 Jkvfm2m2ybue7l7JUEEeBYocQNZA6XYKUfXfRIU8CrKDQtl6ohOsidEhykzhOFLoOuENm
	 IQ8y0wIpil9P1zqlcfrUfWPXwUW+LdbVXnKwiJTrBAT71MNR6AioMyczcunRVMt8/DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=TEXLeA+4;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=LswKgGdD;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C47606A322
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 07:45:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4C47606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=TEXLeA+4;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=LswKgGdD
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69N7FUxU588009
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 07:45:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	IEyRBF8vnbm1/HQ6cJJHHKiX1zU4rFzUPX8p8n7sqjI=; b=TEXLeA+4HFpXpAk6
	6rglDtWweoCysV8dXNKA16v1pE6XMKCS3cdS/6WjmTWWF+V15FXAU0/QCmuEhuCF
	JpN9D5eI3wHoosaWB0RB/rc+7bv6UomnSUCZL6X88RA2AiMeVlUA27evPW+vruDo
	AtzgGVW6LK62uovC4vH51RaEYZlyxgt9i7KLr6QbXrME6xQTzo4cE7OErdK8EDg0
	P1HeE5uC1PR2gFkOM+o3kacgJ7I6jVnxFMhE4ia7KgbZwNb9BQUQVY9tg3LOLMtt
	L0cdmX46eGSo2J8TmJqNgnKsxLF94sxf9SYTOi0vJuEsE0q0E/HUmVKi5iU+4D7M
	V4Tryg==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hfsmat1fm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 07:45:41 +0000 (GMT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-91bf35c4c78so1234326d6.0
        for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 00:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792741540; x=1793346340; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IEyRBF8vnbm1/HQ6cJJHHKiX1zU4rFzUPX8p8n7sqjI=;
        b=LswKgGdDU4Wh63hLYjQM9pRpZNtdiouDxKtpMCvDbYlYuwRB3C6cXmSnyVbKDSUJP1
         5LJ5HKYTo6wot1wCIplwUOiP9iGkaIcU/E7fOpuKP0q7ku8xavDEa6rfTjfMD9ma9/qJ
         7mH/n4yjvixlcQSeSBTxGRPlUvZtaBNukPOj4mG8t+Hos3E/JzxJyG8vliiO7L6UV6sh
         BS4B/6ThdJdnxRQM34bLdXhNip9tC7jRCwSrHwvBdiMb/07OJggEG4j9CofO4ObT9PV5
         Eg+aJF1PiwUfvTvgqpFgn5juTfS1vLeAY1dNZVG5BfmEl4HK5e1/IYLdcVjheuM4AyfZ
         oKlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792741540; x=1793346340;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IEyRBF8vnbm1/HQ6cJJHHKiX1zU4rFzUPX8p8n7sqjI=;
        b=SI9AVdxub3uculJB/TQ4+zMTLNNvbrKoWaD03AJJxKwTzeBmYkbQxEt/z3sqz7Mpqa
         PzH2MM0GnDv7wNuO3ecyoDzcYVxHUhrI4t9ox2WZq4nd/7+RFBFVxNMAZF/SqZhXpUZ5
         EpUkGmbuo3+WFuDnPSDvzV80co8M+gxqb+9+ZQFieeTT5pvAC/q0tCEEXC0nne3U7YsD
         UGQdWjvThDBEV7o9eZiGF9Qf+17xA6pWyPhBj4iN3Jfv1YR/6Ep8OLIcSLmCrolhF5ev
         u2eEdF0LZPaIi/ZKLhGbCfC7up5wmjasO0MJeAnvr6qycmxa3XBNE3zmVHR0y+oHnZCX
         2whw==
X-Forwarded-Encrypted: i=1; AKwUvBw4poWeMEZiQHaDN+bsWmJfGQ6AtJmGl30axJZ4KxlTiGXPmIhqSzlVPxrRDX7wif3sWWTIwXxQfUik@vger.kernel.org
X-Gm-Message-State: AFq9FYLgR0Ys77pinm+VmNsueTQyu9Foqo4tfikRok6qMDL8Ps10xQVw
	W5RyPOEEOXdZ04EeflEiaLlozJqSMdJgcjNtEPJjzpE//BkA7rVXa6KNEqkJHouzyupyFNo+J/Z
	XHqBZ59n+7veZ13LcyS2OS8AjJ+5uvAu2fs+7XSOvKBAy63NSSzWmhaUBNnLVQy9h
X-Gm-Gg: AYBFou3XzgjiHkYGI2w/BZB71xIC7oRajAPD9M4tJd3llSz3zPAnIBjM/6laVXOju7I
	glanjJdZU+B/bKEh8eC08mSG0kyM57g8cZHnmNPYPV16q6L0BCRQpvDNWPSBCYCk0lZx5GurjoJ
	l18G4w9WaXqGGweVFEEkT/JunChmxImD7zbhN4PD0VQRXbJ+3ZBKH/VtDdbX3xgHl72BEftQI1c
	lWvmUITBinBR/MS5HxS2aEB6Dqa25xjtN0+G4rtMDrncPK8WcdDD/ZcvrArwogw7NqrGcBe3MlV
	L3SiAkLfp88WWHEa3JMhlyBKni0HLB1oXMXnnE1jP71e1ay0Z0mWdVNgLLQd6IwwqLumvfoqB/i
	rdh+k1y3hNE65Ftlo8wc6Fg==
X-Received: by 2002:a05:620a:a997:10b0:93e:6d87:4f69 with SMTP id af79cd13be357-93f6f8da8f7mr285887285a.3.1792741539962;
        Fri, 23 Oct 2026 00:45:39 -0700 (PDT)
X-Received: by 2002:a05:620a:a997:10b0:93e:6d87:4f69 with SMTP id af79cd13be357-93f6f8da8f7mr285884885a.3.1792741539484;
        Fri, 23 Oct 2026 00:45:39 -0700 (PDT)
Received: from [192.168.226.26] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46a5c4ced7sm70249066b.13.2026.10.23.00.45.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2026 00:45:38 -0700 (PDT)
Message-ID: <a3298437-21c9-4b91-94f0-417d92045afc@oss.qualcomm.com>
Date: Fri, 23 Oct 2026 09:45:31 +0200
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: qcom: Reprogram ESI after a host controller
 reset
To: Joonhoe Kim <26rote@gmail.com>, mani@kernel.org, mkp@kernel.org
Cc: James.Bottomley@HansenPartnership.com, bvanassche@acm.org,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20261022165006.1275-1-26rote@gmail.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20261022165006.1275-1-26rote@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=V7LoQuni c=1 sm=1 tr=0 ts=6adb10a5 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=PeIWiMRIC7RC5FwImpMA:9 a=QEXdDO2ut3YA:10
 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAzMCBTYWx0ZWRfXwmZUDlkJAg4/
 rjCeSRyMNzPBCL8mqSwZV7+G5r+7ZshRBxkVbQDrE5hL+EWu1HEAEuG6BnTg05ou2VgKsGVTa0m
 ztP1Rbwea+XgR71Y5v4DHlrcSXU7+Cw=
X-Proofpoint-GUID: fM4hQJ_6E27DJxCHXM4zCs1aiX2tH9Z4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAzMCBTYWx0ZWRfX0lNqDtWR8htu
 zY9mw3s6CgH5dMYbGFoEVzfqCakyi/VezVjcxIRSIrqBKJ51KDhNPu21asxBNtJ8X7CLhr4xtRM
 jFGrHWxx4dU3T3mO+1uP9zs+dK1+s0IgaarjeKw3CtO3qglxSQpYdhSGERwviZhyOI9tEFYRQYd
 fmfC8mDw2J0CMREAdYdZqxKRdQyU0jg+ksOzgdt8EcMKCPCHxr4SYrIte6xJqwI1FpyLwnQjMnp
 FBfS1ARpcfCoXuz4spilT8SrZzH3LZnsJVFsumH869NM69Oi3/r6tC+eLAHyG5s3C8t3HqiNFa2
 isGrRZmh8pzGcn658NOqBQSQjyvxd5nbekJ/abI26JPp8b6THgf3zKLPHCXdTx61sf2B9nBfSv4
 zv7rs/hqdHRwrhY8De7BYBvqKxTQSm26DwvhzFfPoUkAcyqG2mkj+JT6ERA/o+6z0ODBykbJXXE
 yrDvkdHIIiVBLzLAj8g==
X-Proofpoint-ORIG-GUID: fM4hQJ_6E27DJxCHXM4zCs1aiX2tH9Z4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610230030

On 10/22/26 6:50 PM, Joonhoe Kim wrote:
> ufs_qcom_config_esi() returns early once the ESI interrupts are set up.
> ufshcd_config_mcq() also calls it after every host controller reset,
> which clears the ESI base address, the vector mask and ESI enable. After
> the error handler has reset the controller, the completions then arrive
> only on the legacy interrupt while mcq_esi_enabled stays set.
> 
> Allocate the MSIs and request their interrupts only once, but program
> the ESI registers on every call. The MSI message is not cached for
> platform MSIs, so keep the one written at allocation.
> 
> Fixes: 519b6274a777 ("scsi: ufs: qcom: Add MCQ ESI config vendor specific ops")
> Signed-off-by: Joonhoe Kim <26rote@gmail.com>
> ---

I'm not sure it's related, but with this change, do you still need

https://lore.kernel.org/linux-arm-msm/20261007143716.2161-1-26rote@gmail.com/

?

Konrad
