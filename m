Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44EAD3A3E72
	for <linux-scsi@vger.kernel.org>; Tue,  7 Apr 2026 08:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775550029; cv=none; b=mtvUAzFAvWIiolTuqF6WSUQzS7h0sZrZpf+4pASFbExxBecWVk/QxZSchiuQ5AXQYPiSaclw08RxzHE+hsfzHzq66k9OpL29y4lg7Xz2Eja+gSZJiQWPTaIFkOJzkX5XkHm9KqP09kVXceT8NXjjvzESF53gFVRnkNXKjyumV+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775550029; c=relaxed/simple;
	bh=H1OdIWKBGN79dZx53tiqG45UpbN4D8/v7v1Qk1dzF5M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s+dASP6kD4i0dZ+ItqMGFP4CTT2plopx5r1XJc3NMd/Df9yIS4piUndT3pwOPCD71Vs/KnGD0e6k+6mNru7LIhokgntwvmNuRiJDTI9ca49tePph8dbS6M2OYlhZnB9SWURAPbpch+Tl2WF95hjAw5gcQFYlg+Dn26rL+wXLME0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jBnEEJrh; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=eN8wFBFB; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jBnEEJrh";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="eN8wFBFB"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6376PhSo4009039
	for <linux-scsi@vger.kernel.org>; Tue, 7 Apr 2026 08:20:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	H1OdIWKBGN79dZx53tiqG45UpbN4D8/v7v1Qk1dzF5M=; b=jBnEEJrh8keogI4M
	bFdRa8+NNYy0lEDwDTOjfD09XftImcWrNbSEfQ8xjHd5Ao0DS3X5fxJBJJYIonWN
	G7AfNJk6fPWLx4rlfhw/u5n9yttHD1vvJ7C9HFrk1ZNWlZQsIvyS9Hdiw8e4NMTs
	LjIig8qFqk3Ih3RWwwb2Pcr2rJNOjjh+71z/RHpT0sEd0rzPkFQTZfzxckG7JhXl
	1Ug+WePeFOyHcwyvRl++swUOhuMJlm0mheS0tPsgFTODnEgS9mXzgTl6jLq2U5rm
	gkWYslmreSwbHuEkf3m7Bi0zJwPzUgWNdvKR1gO2ZsizgstQGWaEgl4aHG0iKZGu
	EJLg4Q==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dcmrksrnu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 07 Apr 2026 08:20:26 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2b23af7d7e8so134779735ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 07 Apr 2026 01:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775550025; x=1776154825; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H1OdIWKBGN79dZx53tiqG45UpbN4D8/v7v1Qk1dzF5M=;
        b=eN8wFBFBTwRgpgkk0i0BgoU9V7+umiMaBLlRpkGsVziTV+T3nbNp1xACkuP6wmT8eN
         MvuKTD7uOIJD/OTKt4CTXddIMDfSDsh3asnk5+hwolsfgGlin7va8zz21+ZWqpJA5ke0
         UQTbgWD0VDDkoT9QujahO020wJBUGhGrE6Hcb+XXReUqQzBKeTltakow2TzlyYfMo7Yj
         1Cd07zmWStQGiy0wPvagnfNmfaplIddSmgO85iT/k3OrUFkX2Z/9mEfiMVmwPEpXXb3u
         tmUP5z/mguCtyfNwCsO9rf3Ymad/Bo8giRK+cIwbnE+l4Vak/Dd1RBEVfKL97EBjFws/
         10NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775550025; x=1776154825;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H1OdIWKBGN79dZx53tiqG45UpbN4D8/v7v1Qk1dzF5M=;
        b=fev0DPLQOcfDGwQuB0Hk0i1zpstvWY7v5+PjSI7+YSPUsQu7F9MrKH7bUmbW9v2Osi
         Rcay+/t2+NDfWOCPxqn3mzSjMr6BqQr9acaWSSDcP61YHH3qiN3rQRslD08NqaSU4e2a
         EjSJSgIa+U7Ujm12Ifs5TSzijORdhdj5vMMYw9arsYDHWFqNIaUgqoQuoc1inHVpufRq
         vTk4Mb78mvRvHS7/meE4MLwJwmkXr8+LIm3ZwteenxtRoRAMbCzL9EPKYBukxmVhceda
         2vBRCOfULJrUh6Pw3fJjc23cdsCEWSjzlO+PFaC+RJ2u6IEDFHcoasSCf7vfj8wsBZlK
         7NnA==
X-Gm-Message-State: AOJu0YzwvRHVbMBINM5HxwYR7msOIjEvdCOCfs2XWUCyTAax7e5oqLmF
	4kQrCu9JvE2HHzMtlFBvuXJjmQVhwRwEgss3bRcZohRJX8nH2hP/SuASVaKL2VlB7hewbq+isee
	uVijIGWiJRXfJWoHlNlc3IB7AwgvuI/GCtOjfOPPcgHBca3P36Ed41AfHLz8jW/Z0kjIaP0xh
X-Gm-Gg: AeBDieuzQHdjY1kvK3P5jqebKrjD0eSYMASRKIn+71zZw4TKq1raWgn9gbqaLzNpZsV
	PXe+8Ls2sGmbh60OLv2dJhxHlFHMjZgG1EG9ILiJoAkYwDaSoCIk6JjAyU5X2dVolFuuprPrMCH
	sRCgSb1Hb8ezqf+bz9HlCr75Xa28xasoyOm+C6E3YL5Gm7paYnPRSJlC6xeMYwT1HsmJ3yEYFQ0
	h8Uyx6S4wGLjwu8rzknVeyRp+8zEMm8h2v/WsN7tyHdUoKu+nTlMMPYlALyrF64wLcEhYNy/9JZ
	CSJN+CeuTFE6c8sDsTcEr9OVZui7685FOITGWqIjyPJrwSPOvNqbrnRtzSee/GFHOe4TV39Kb5y
	QBr+jb3JAErmU5FuipcMFRzasDaS23uou1m/0E3SQCF39s3I=
X-Received: by 2002:a17:903:b0e:b0:2b2:52af:52b8 with SMTP id d9443c01a7336-2b28184a5cfmr165775685ad.11.1775550025333;
        Tue, 07 Apr 2026 01:20:25 -0700 (PDT)
X-Received: by 2002:a17:903:b0e:b0:2b2:52af:52b8 with SMTP id d9443c01a7336-2b28184a5cfmr165775405ad.11.1775550024905;
        Tue, 07 Apr 2026 01:20:24 -0700 (PDT)
Received: from [10.239.31.132] ([114.94.8.21])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2749a440csm159668255ad.65.2026.04.07.01.20.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2026 01:20:24 -0700 (PDT)
Message-ID: <90959d7b-e238-44f9-b538-1ea01e8bd397@oss.qualcomm.com>
Date: Tue, 7 Apr 2026 16:20:20 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RE: [PATCH 0/3] Reduce interrupt latency
To: Bart Van Assche <bvanassche@acm.org>,
        Richard Patrick <richardp@quicinc.com>,
        Can Guo <can.guo@oss.qualcomm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiaosen He <xiaosen.he@oss.qualcomm.com>
References: <20260330183311.1941942-1-bvanassche@acm.org>
 <6e4ce34a-23e6-4dca-837a-b89feb504e41@acm.org>
 <LV3PR02MB10127544190699309108FAE5EF953A@LV3PR02MB10127.namprd02.prod.outlook.com>
Content-Language: en-US
From: Xiaosen <xiaosen.he@oss.qualcomm.com>
In-Reply-To: <LV3PR02MB10127544190699309108FAE5EF953A@LV3PR02MB10127.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=Rrz16imK c=1 sm=1 tr=0 ts=69d4be4a cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=Uz3yg00KUFJ2y2WijEJ4bw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=N54-gffFAAAA:8 a=COk6AnOGAAAA:8 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=AAWbIBZvV0B6f2Oj_GcA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: _hxlj6mwP9DRw_ZM59FVJgEo4HujW3Ab
X-Proofpoint-GUID: _hxlj6mwP9DRw_ZM59FVJgEo4HujW3Ab
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA3MDA3NCBTYWx0ZWRfX2NzzSYy3L6zu
 a8aTEkhS0WqiIVPzpdU6+010fJfa41Btjr/WudlWJ825sJBlnaIc9XrzzEmYWVqkbvk1KPBkxAB
 3PKf95VTcpBt7tXszC3DQ/BkAnoujfAquei/ZSSZhUEY86oD6Fmnn/BhUySDSxO+MvWHzSYxagq
 zyPIxBhMz9Tl26ZEpE/rYmqnth2WsS8oeXsHBoNsil6ZE6Szm1gk6615zZ2TEnP1+m+GnzULiSo
 DYEX8NpjJT2n8hb1nDQSdDxIhZkv5pytVc5LsNhKZzRPSlhfVEB+FDBJU4/5f4z6YJg8FHjvPFu
 H/AAZ01WDivOK7pWtItrdoOxjT6UPOe3tF4VDRYyEAAKxNgBZ8eDrEY7CJlgeMhUu479AFT+nYf
 pkZ2qF6eBaQ2WaMZI0z41CjCcFtAvIte12BjKSO30ixAd3ft0w7LtEMeeSvVN7XJpQAUCHWPVpO
 EDVvDUiX9ZYGq9uKARg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-07_02,2026-04-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 impostorscore=0 priorityscore=1501
 phishscore=0 bulkscore=0 suspectscore=0 adultscore=0 clxscore=1011
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2604010000
 definitions=main-2604070074

Hi Bart,

This patch series work fine on Qualcomm MCQ devices.

Tested-and-reviewed-by: Xiaosen He <xiaosen.he@oss.qualcomm.com>

On 3/31/2026 10:01 AM, Can Guo wrote:
> Hi Bart,
>
> I am adding Xiaosen to help on your request. Please expect some turnaround time.
>
> Thanks.
> Best Regards,
> Can Guo
>
> -----Original Message-----
> From: Bart Van Assche <bvanassche@acm.org>
> Sent: Tuesday, March 31, 2026 2:36 AM
> To: Can Guo (QUIC) <quic_cang@quicinc.com>
> Cc: linux-scsi@vger.kernel.org; Martin K . Petersen <martin.petersen@oracle.com>
> Subject: Re: [PATCH 0/3] Reduce interrupt latency
>
> WARNING: This email originated from outside of Qualcomm. Please be wary of any links or attachments, and do not enable macros.
>
> On 3/30/26 11:33 AM, Bart Van Assche wrote:
>> On Android systems it is important to keep the time spent in interrupts short.
>> This keeps the user interface responsive and prevents audio
>> stuttering. Hence this patch series to reduce the time spent in the
>> UFS interrupt handler. Please consider this patch series for the next merge window.
> (replying to my own email)
>
> Hi,
>
> Can anyone help me to test this patch series on an MCQ Qualcomm system?
> I do not have access to such a setup.
>
> Thanks,
>
> Bart.
