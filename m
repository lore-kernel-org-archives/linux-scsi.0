Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127F133F38E
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 09:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770715983; cv=none; b=VZAblGcnmb+VLeXtA8UA/RrUDma6axWGJRmx64bQ/R0UkRYMoMv2KGQC0e43JJgLEbTCz7rQvEMilkSw+eBs7/V1x8RPFK+7tPnKXJwKfdUOqsulA47CvRIjb3+ORj5a7PkocoYb87PK5rlnfEUlFrb+U4UoMC8J9S8OPP6TcaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770715983; c=relaxed/simple;
	bh=lYXkrcgF/gfCqHIjWikYj3wuxE8pK3C+vUdP+nhK84M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ixxshSs/ycDcrfPdW4bbt+XR1siBXHE5eMAK1A/9+3FheIa4xFpzbBBWYp4EYaLMMD/zXmlZo8b5zRotQajIpoi87YY0bYJQA9xqBrGr/rLsTH9skU55TcX1pvtFjYu+ZwMioQlRRG8RE1lerQyBgceKuvcGTLTlue2G66GivGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=G9iG4J1W; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=L3k+0wWE; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="G9iG4J1W";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="L3k+0wWE"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A3imsv1940746
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 09:33:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rLgXJquVUyBesXKA8dBPnaFYAdLbpSuCrTyxZs6wRLQ=; b=G9iG4J1W38x8r1bK
	yNGjcc5L8LSO9QweqAc875s9Kl/lrfPteKjrfaz0Z4iEQRw2Fqqide/Xw0T0Nq3V
	OeJ1GQX9drN9ZmvV/frtuq88//xXMqzD/RAEum592u+iCgAMqWHKCHvbnrIO90eX
	hd6oiwQPLfSCbI2zpvobZPqFHb3bokzC5b++ZxwcziC4LRqHbUo9YZw+MHLCIw/b
	EtVpgkQ/kyPMUFGfmpCIV5YbMwF79MFXyJ9aLPSDxUpLv4WLh43ewasvPdjajc3x
	Z8fYYyiSczCSma7I5pNsdnaRI6RNbruB4JStXmq3SG9WSFm2e33iu5x7ot7kE8HD
	RuVshw==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c7w1js15s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 09:33:01 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8c522c44febso164091985a.0
        for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 01:33:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770715980; x=1771320780; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rLgXJquVUyBesXKA8dBPnaFYAdLbpSuCrTyxZs6wRLQ=;
        b=L3k+0wWERRF01hka+ZTH5p3Cx5Op8220v8WNSc6XxhMKnBYUNGgD3/b4d0x1M0kSLb
         72UEdyhHs8BEIV9o2j0SbdnFrQ6d2FDAF7aHA0AakPWAxS0/eVyMm04Ad/x6FR2LeNoS
         DNSimueaKdrzWbepIylklDHyxlN7VFuuBqluPOQ2ld0EZE0UwQaOsl1WrphohwLH8cAy
         HJ3Tj/U1prlw3Z6zhot1Bk20dmhIf2grGNpRASsr1fRwU395d3EN4/5coTdNRRAcUmBY
         DIrXGckYWY3ms6A7W0hy0x8vsWQLlkoai55c6xVQDXrPRRXXQ2+CqsaIwg1WTsNN7vrD
         uu+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770715980; x=1771320780;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rLgXJquVUyBesXKA8dBPnaFYAdLbpSuCrTyxZs6wRLQ=;
        b=QW1Jdz82WNgyvMv0jrm3zpscW4hM4MgrJHtQCu1buW5zvmaI946rA2KaQueBs/71iV
         3qHfYQCIgaL8NX1VOBpCvRE1iT7E6jZuUpzxnWvSIo2b9BMDsrLopYMHf3IqJV1vbeld
         Lqln9xuT4pGP2OhEXifLZQ/XwH3BVXZhSlJz2zFDyXGutNzpy4fihh4Yzadhq9HFehEe
         GMi42PEyZCjXXJXk3oY56PEXWy5BFYu7ONCcU5zOH511g94FHXCyDHnCkR/iyI0fNge/
         DaYSvpEX/tfwkaUeXT+9z40yDojvKw7OOyPzqupKemxVx/m5h+vtJ9F8zlIlVzzAnevA
         gn3g==
X-Forwarded-Encrypted: i=1; AJvYcCUTMjHwdIFfwYWyCXDXNpqB2AvqiTlRkD6zT63calPgneTXhj05giv5QxdJPEz+iZkZY2CfUuIa9M4U@vger.kernel.org
X-Gm-Message-State: AOJu0YwVgVNacEzw4Bt6xZmVMzgTpKEwJIS9HkVriY3jAsSkJ1dkWzHV
	GyFkvWRwIBckn6Q2rbjTMaR4axdgtpEZ5RKTj2L8lBnrSWHd6iAg0NfUDBaHwOq0C0W69JHz8e+
	PgwOgyMVjnzvKr1qv4hRmAud9buPdZ0JB+0f8rec1or/j5sgbahwCZA5PdlCCKjSc
X-Gm-Gg: AZuq6aJPO0X9+eYjdFid9yvXcK3pYoK/EPr1fz1Y15YDL/1cTIraX31L9YD0aj0OajV
	p9Dt4XteTzdbntOyvWz6ZIAHPTBOePD2Z2m9VutpkZnA+Ka8Lt5UxIB3MyJOius5DmEcKAIakYw
	0J0/Nj+G8EuVyiGeTdJvl3Nf+m9Ne5rHeZEsFZh/o5IV+MHhMbpKpIkElbcQ/3gN7oNl8/GxMe8
	EitmYfaz+Pwgy5KaiOKLUkqaKYVbDtPK0+0eVgS+1rLtWpujIDl40kBUMrxffb36pD973iW70VP
	AE8zgl7qDJyzzqXCckfJQzcIyLBSQZxr4JvTifeAHo+tYV3d6DA38eP5nhEMh+pVUxOvEH2b6R4
	eFXK3R2edfVEy20h8117rq7S3SGsBvYzPj1kj6Z8ZYnyuOnV73ZlbsXl+JsZt4CGSxcP9pKHbw/
	PsaqM=
X-Received: by 2002:a05:620a:258e:b0:8c9:eae0:d1df with SMTP id af79cd13be357-8cb1ff5ebc8mr100761685a.6.1770715980353;
        Tue, 10 Feb 2026 01:33:00 -0800 (PST)
X-Received: by 2002:a05:620a:258e:b0:8c9:eae0:d1df with SMTP id af79cd13be357-8cb1ff5ebc8mr100760085a.6.1770715979873;
        Tue, 10 Feb 2026 01:32:59 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8edae32664sm489037866b.58.2026.02.10.01.32.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Feb 2026 01:32:58 -0800 (PST)
Message-ID: <068a7b3a-22a6-4e83-acef-85353af53390@oss.qualcomm.com>
Date: Tue, 10 Feb 2026 10:32:55 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] scsi: ufs: ufs-qcom: Remove NULL check from
 devm_of_qcom_ice_get()
To: manivannan.sadhasivam@oss.qualcomm.com,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abel.vesa@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson
 <ulf.hansson@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Sumit Garg <sumit.garg@oss.qualcomm.com>
References: <20260210-qcom-ice-fix-v2-0-9c1ab5d6502c@oss.qualcomm.com>
 <20260210-qcom-ice-fix-v2-4-9c1ab5d6502c@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260210-qcom-ice-fix-v2-4-9c1ab5d6502c@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: 6darpIIB_p7lZDliVIQDSAVaVidESZsf
X-Proofpoint-ORIG-GUID: 6darpIIB_p7lZDliVIQDSAVaVidESZsf
X-Authority-Analysis: v=2.4 cv=YrIChoYX c=1 sm=1 tr=0 ts=698afb4d cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=EUspDBNiAAAA:8 a=AC2hTCgHVLFjDka4hzMA:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDA3OSBTYWx0ZWRfX6ZKmr8cOoN9Y
 BPSprDNsM9cxbryMt9rYaX4/13GC1U8mCpl+LPJ2e2zz0AbdirNdTgewUn1glIz9xM0jLjtqw07
 a06sHv8OKTzaHZQa0UW8LVli+TK2myrWec0its6zL7lrlGddb44+bxh/qi0VZgRd+eHIM6d4sy6
 t11m9oJp/YOFqScpKyuQspMeptJDfGLMb18NfuFsxGBazkIjl7vy153um1slyFsFXZfGtl9hngP
 LOmiurvEsQx07iToO/uw4NpUxtUegYFFKHS9vI+zBw+cuekCbDgY1JaRdJlEkti0uCUk4VbKuZG
 9KIqalXhQguu2DVoFHQu05bawQkw6gMQ5mAQ278djxXvLFHFlIKqzDJwd7PFNwrQbUucyBd3tU+
 EIXJuR8nzNcGkHxhKQKsBNdP6Bvl+GGD/trOlN5RzmgH3I1phe1OiAJJ90+J+XBcCSe5HiwTOUE
 wfH04QjZUqHldmOTTuQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-09_01,2026-02-09_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 bulkscore=0 adultscore=0 clxscore=1015
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602100079

On 2/10/26 7:56 AM, Manivannan Sadhasivam via B4 Relay wrote:
> From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> 
> Now since the devm_of_qcom_ice_get() API never returns NULL, remove the
> NULL check and also simplify the error handling.
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
