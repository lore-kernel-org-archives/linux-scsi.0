Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0730C2F84F
	for <linux-scsi@vger.kernel.org>; Tue,  8 Jul 2025 15:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751988547; cv=none; b=ulSo5yxIZKhz9vUxbMX9a5906eatfyo7Wf4U7dO/3muKCjeHKw8IVAZmfpHQeQOZ6YXSEI/u4Pj5sllm7VXOw1TwKNnvkQ5Z6MVstCQKi0YR/Hb9MyGl/IRsumH2POVLOh8glbpoT8fYrXpIy/4NXl6p4Ef7Beil/wbZkisy8Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751988547; c=relaxed/simple;
	bh=v3QiLAwgJgyOMTcG8VOnoqZL5d47L+1i3KmT8SpcDak=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pa4wkyJOSAD6VZQx01H6a+QvBwR+qLRMr/4YxjLk+3uHzQJJgjqn6Jp1o0ZzDvspMFGk9/Z9II0wztN58F82s5HRDiNwj7omLpxpPQFOC8jivJUlyU70HW/KELarY70iXzawxxNe1txFxi1c9fxZ6N88gABVApkZSmS19o0jxog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PaLiYB+9; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PaLiYB+9"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 568AAbup031807
	for <linux-scsi@vger.kernel.org>; Tue, 8 Jul 2025 15:29:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	f2VkYsy8wJYahFxVTA7K93nD8ZG70Y+num13V84YJeA=; b=PaLiYB+9U6VBe6Zb
	Z6YD7vyUP0p8mXTtqP/KSfgqZoppbEvZV0wrg40L9oMe1yMbWORWzkUbn/9qnAuV
	wDsM4S/vYAUL4eOXe+eD1s0gy1ValTg4vQOTePXTF9AST0cnh2yxlOili05+KEhy
	io8Kvcmsx1GXMDKeVzMRaF/U+e6tSoWeQR+hYfLRovrGjqL7FBZm5R4721lxXAxB
	TjBEZDJ5Z76lQUCKr0iTNXqTUh66leirPv1wHEEQUVfYu1+CacKjw3nWaspTUnY+
	QM/0uRUCOtDFsJ7Fv7yXamhtBhqye7u7e0yeI9B6ZNkJJb9JAld3jR/vKeDCqlXS
	r/W6Eg==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 47pw7qpg5w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 08 Jul 2025 15:29:05 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7d3ea727700so29368485a.3
        for <linux-scsi@vger.kernel.org>; Tue, 08 Jul 2025 08:29:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751988544; x=1752593344;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f2VkYsy8wJYahFxVTA7K93nD8ZG70Y+num13V84YJeA=;
        b=YramYSLhz0LBTHBfm6m/9u4lsFCh96bvNznIIv98wfz/D2+sY0NdjjGPLTkeQTKgdE
         bIheTLV/cODHRREy0SvvhrJVzElPOmoeY98NG7qIP/K4KY/dyUV1FjoX1bSnBbY2+4K8
         GqeDpWqlUcai9BAg03eBIkb5KenUTBtwq8iDhvGXEVFxqYgVtbYEbs8XMhUsM1BvsZaS
         hYHJlF9DvWF/mMyF7TNWroj4jlxbP+kFqeAYH73kcPxP5Ko4ZRFwXe9trmwokDtaX8Pn
         F6pO3PMOSXpKDblKu6CyfP/PsKC3TEtj8aOrcjdUE+xcjFV5UmadZlchMO4jsw8njmBV
         33pg==
X-Forwarded-Encrypted: i=1; AJvYcCWwh55oQiJyksDpJHLvteUYu9cElBaGitCLHx38BiWlaR1HO2B05qJikfaRLQoZpavx5+69OkbvCY4A@vger.kernel.org
X-Gm-Message-State: AOJu0YzSlAsFkmm/OA/N0qyNsrS+45Tw6LyQNand6viokIJzU6Q2vyDv
	gDjOCFFRrrAmtXmrPmNaK1sF+ROK3ko3JrgnftHIwITwEvq971CpXxuLFliC3Z+nkuImXQoL/3C
	0UCmcG6eF+8zGHC3UXZPv2TVqc4eJK0plXjD9iLTJDW47i+S2cytrmb86WJFzuleY
X-Gm-Gg: ASbGncu7uCoq10RuZNRF7Jq9QPtK6yJSStoKWN4vqSQhrjXL2NSY7qAZY1M+cV1J62H
	In+gpmcd4ESpSfUJUGNGjt6Cw89UGXdf45Akuv78nFo6TRUGBSpvQwDZ+P8OYZLhzEyyeAy5ztZ
	Mlr4bns1TcSk6aXvO649dRxlvNqAfXb1LVQhYZeh9iCmH45B4NsmJOuiYzLJq2a9SWO6x4Tq1HZ
	GTh3KhgGYgpwK8cbkZ4QZOKbH+rH0XDNAibltvRwkhJ4hAYZG+W4PEPoBAih8/jtO3lXqXMHdg1
	UE1pfuTkJOvT5lLd0DmJnJ8Z/HILwdQrou1WEcz+OxC978tVJgPwLMS4VupdAdBXo1bClrNdjEz
	GbRY=
X-Received: by 2002:a05:620a:278d:b0:7c3:c814:591d with SMTP id af79cd13be357-7d5ddb5ef03mr1007280385a.1.1751988543766;
        Tue, 08 Jul 2025 08:29:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHIGLnfwf0hkf6haNlDbkMD8YH39A4+PUocC7CjST5W4oc1Te5ti4lqXAliQlmbnF2rJ0WVCA==
X-Received: by 2002:a05:620a:278d:b0:7c3:c814:591d with SMTP id af79cd13be357-7d5ddb5ef03mr1007277685a.1.1751988543250;
        Tue, 08 Jul 2025 08:29:03 -0700 (PDT)
Received: from [192.168.143.225] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae3f66d920asm919310166b.12.2025.07.08.08.29.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jul 2025 08:29:02 -0700 (PDT)
Message-ID: <9ae0d97b-e68d-4255-8ab5-18007763babd@oss.qualcomm.com>
Date: Tue, 8 Jul 2025 17:29:00 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC/RFT 2/5] ufs: ufs-qcom: Remove inferred MCQ mappings
To: Bart Van Assche <bvanassche@acm.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Cc: Marijn Suijten <marijn.suijten@somainline.org>,
        Can Guo <quic_cang@quicinc.com>,
        Nitin Rawat <quic_nitirawa@quicinc.com>, linux-arm-msm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250704-topic-qcom_ufs_mcq_cleanup-v1-0-c70d01b3d334@oss.qualcomm.com>
 <20250704-topic-qcom_ufs_mcq_cleanup-v1-2-c70d01b3d334@oss.qualcomm.com>
 <3c8622ed-db52-46e7-86db-c170b4aae55a@acm.org>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <3c8622ed-db52-46e7-86db-c170b4aae55a@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA4MDEzMCBTYWx0ZWRfX0ZQG/3LxtVGv
 AkzxNgGsTKzGaSA4AYEczCJNBnxBAB8Foge5NwMAnlMCB4FfS2Qf2vIfI5v5HAe+plVESMxr33L
 +pR6o+rN8yqUIdwJk/la32/bzUok+BCt7FgZNUjhJCk5r45jc6hTt7iRNTnqaxY6wJwjKvv9Ox8
 6F1+fiCmhDx1c/uNsqz5Dx/rSYfz2byheuLP1kWBepvLiZUtN2k0hZ8oxbrvoTwMTZfU3ESdHW8
 GuwffTdtbpIlMnbfx1CyT7oiYoiM9TAjpY4DseQe4D+wvwSf1c7C3yV6wA35BI+I/wGLkXRvJrK
 3gYvuWWFr4uWglDLjWIgHJBCUuwVnohjQx0T9HmoGIn5dHwvGHMZ539Kv282RSK3+8T0HFUpZJ5
 J561wguUehKTdNcR5GWTjC0qsxJr+bZtuXTWMt8VTOngR16HBIiXz4m0tVWQoPjqe7OXwnRv
X-Proofpoint-GUID: g9baHS7twtn7tD7_mer-_BGq0Eh0UG25
X-Proofpoint-ORIG-GUID: g9baHS7twtn7tD7_mer-_BGq0Eh0UG25
X-Authority-Analysis: v=2.4 cv=SOBCVPvH c=1 sm=1 tr=0 ts=686d3941 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=EJ2a9uInbOJvoxFTTbQA:9
 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-08_04,2025-07-07_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 impostorscore=0 mlxlogscore=808 mlxscore=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=0 spamscore=0 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2507080130

On 7/7/25 7:51 PM, Bart Van Assche wrote:
> On 7/4/25 10:36 AM, Konrad Dybcio wrote:
>> There are currently no platforms with MCQ enabled, so there is no
>> functional change.
> 
> Hmm ... my understanding is that your employer provides multiple
> development boards that support MCQ?

The commit message refers to the state of the upstream kernel, where
none of the platforms we support today use MCQ (which I can tell as
it would require describing an additional register region in DT).

Konrad
