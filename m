Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CA138B7CD
	for <linux-scsi@vger.kernel.org>; Thu, 26 Feb 2026 06:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772088244; cv=none; b=lKB04BxEytqzCk3XahAZ+qNNpEEjg4rGvWHza7/lnB7FmGGxCDLIyy0WSIiIWpB7nYWzOo4JXykfRdEz+BwcyQk9tiwRtYymPy9rR4nLBMWEBek94C0zhaHCcT3MFxMYazo37SSgO1eOuykuzPbm9kOrMLwt6SrRSobYyiXboMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772088244; c=relaxed/simple;
	bh=EYLnRvQq/XZ/fmr75XhBDUvkJv7sh9WL8NZdGYSiznI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RUImwg/H73pMp7CflV9uIV2UHBjDlgsPrTBtF8FU5BiAnYbBbBWUHA47/YQdwdL0vzWv9wDsaCLMYWS5KgE4NfWIg7HZS7EiMR2HbrBfslJwToxikpv6DBBnfaQ4/9xcB8M9Dt9pwPad99NW83a72FQ1Lg1xmTc96L1VsRHg7WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=C7Ev2g26; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fAbcdvkL; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="C7Ev2g26";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fAbcdvkL"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61Q4VMTO919314
	for <linux-scsi@vger.kernel.org>; Thu, 26 Feb 2026 06:44:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	SQh2B8R6nMFyJXVuNWlNbckjibOvrjgxpDp7qBRbScI=; b=C7Ev2g26obPSNOvb
	DcGheDihbCy35Ml01Ki8dwg2toGXXmLEjCgxMBZyCCqHExUoToyMc5fw44XmEdxW
	USLauPsLWWr1vqB48XgRXyCkSyHfevpPC5iB9ezpyjbHbos3/2hlGfrqD3Ygrzhp
	c7V8ZxCJRYHjWlSLtbI4ybFdgt+2WTKmtsrxVY1uFd+CMqTznQbvkIXRW+aYJLYi
	uD6RGk5BSVv3rQPjWWTcCI0T90pz0hJ6MoZPaWhAatvTFYJ4BOFVtDhGQSSsraWx
	1X4zbZbuLEImQDp/0YYPYw1yKRJeiLo1YV3477B8lvw2k9gKQaAKGdQWgvwxhGZu
	7HCoJg==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cj4w4t61v-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 26 Feb 2026 06:44:01 +0000 (GMT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-899afef8eebso94792856d6.3
        for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 22:44:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772088241; x=1772693041; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=SQh2B8R6nMFyJXVuNWlNbckjibOvrjgxpDp7qBRbScI=;
        b=fAbcdvkL0K+YOOXSYpJwvQaPsDTxrp8kowjVYx6pbNPHP2kSxAjCgiQpJ9ZS8u8xEh
         x3a0O5dj2CLvX5w5jJpcml2F9n/UGWRty8X5BeL4badeEmu8CxHr09XvDNFY4pTr5HFb
         7VqLL21CIOW46hUkd4R/nHpMlR86FGVYnZc0c3H3dETKu7/k8BBIOLmBHHjqyId01xsc
         YnWYxOZUsmFH1SH1s7/UycHa4VxKYKFnuGLrih4DkD18esN4ZwdEyOLHSLa3m1/ArdG/
         g97kgx8oxJKv+tVbR9mymEHRn2LV2Fu+KcD/6/u81ryrS47taz9Xp4X2WEYCmDOQAqnq
         3vyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772088241; x=1772693041;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SQh2B8R6nMFyJXVuNWlNbckjibOvrjgxpDp7qBRbScI=;
        b=FkvwCn0PNQVIR9F0CURG0CuqjVh9wc+7LI1jLVhJ8YjplMw5krsZ0TZyb49v0aEBpN
         msAENE66cAl/IoLEpnU4jW0K0XJvef5uwH8suJ2pfqOu8Pog/u9/1brezQk5cJYvemw5
         KPNaH7rpeL+h6bN/AQcBFM9bfPD8bCh//FPBR9uBqQhhlGLCadTZwErC4EFrwM0NcpWA
         OIAIjSFcIxHEMAnP90jLAnmdcJfsHgyG6XwYKqZ+CCxzC7CZ/5KCni6sRl7IBCX9tXad
         ndASfrR5T57NRtLR6BQNhbtQ1Wypf/ZxzTlFZpjfD1/ERVXpGdk7gdR/Riq/5f/HYs5e
         VO5w==
X-Forwarded-Encrypted: i=1; AJvYcCVlg9xdzUucxrCLZ0NeBWLqALvOlOMiJE5kqAE5Eld+QmN7rDfejdC4iR0Z5D8tN1BjUpfHTIXiATVI@vger.kernel.org
X-Gm-Message-State: AOJu0YxWwegeKkQittjvl6sxwuSU7/g9NEIxFy+8M8UIrWUgROYODc/F
	YcuJ7TTZy/cDLnfnKpLn5mLraR0h5BU7EcblQoVHvgDeNLjcFlDaCHuxh5Cym0H5R4sUYHYXWdB
	zbmMKlzMVk4iWvjORQaUR2MquYGtIzV1jNoKCM96sb+ricu6/tspzu8Ii/oFbHJrH
X-Gm-Gg: ATEYQzwxdJPvxAJCiAHpx0VyYnOYJstgUJQmDA9uNB9tuFdZQCSttgjbSjRPPO4j7QQ
	3+nrYgoQvNWnBrZ+lvijUZsbQO4RFVnsxHEiaAmO2DY9D5Qb20MU4tnnOKlCNfh7ma4D8tyH6/a
	34UwLAqJu4Dpd7FnNAxwrobZ9BkZIsCdQFjFZPd8QQpxwg2it0LhKuTin43CBGB0yu+zUakpm5p
	KMEya6FkuhOpF9aTZ2r3F+QuN6DEXsNeR+bUYgo5caCXy7bwBCjMn8IYdVJ4vKF1iULFJVcypcV
	goTr2WRuGN4gYByNdu8ju2lFmG4kGDhpWGNI5iNRmtD8GqVRgSmptsGHblyFJasN7Jq06HquHWe
	fKwEQtZ42K+t/zv/sXqp+YgJFN0Ngkhr8g2k2Lp+q0baxAJNqUg==
X-Received: by 2002:a05:620a:7081:b0:8cb:72b2:2a14 with SMTP id af79cd13be357-8cbbcf54cd1mr414965285a.16.1772088240619;
        Wed, 25 Feb 2026 22:44:00 -0800 (PST)
X-Received: by 2002:a05:620a:7081:b0:8cb:72b2:2a14 with SMTP id af79cd13be357-8cbbcf54cd1mr414963285a.16.1772088240212;
        Wed, 25 Feb 2026 22:44:00 -0800 (PST)
Received: from [192.168.1.29] ([178.197.223.140])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43970d4c982sm38910193f8f.31.2026.02.25.22.43.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 22:43:59 -0800 (PST)
Message-ID: <015f284a-4632-480f-b5db-aec86cd15850@oss.qualcomm.com>
Date: Thu, 26 Feb 2026 07:43:58 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/6] Enable UFS support on Milos
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        Konrad Dybcio <konradybcio@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Rob Herring
 <robh@kernel.org>, Bjorn Andersson <andersson@kernel.org>
References: <20260112-milos-ufs-v2-0-d3ce4f61f030@fairphone.com>
 <bab87b07-42a8-4712-ba14-3489b7424ac3@kernel.org>
 <yq1v7fk42r1.fsf@ca-mkp.ca.oracle.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Content-Language: en-US
Autocrypt: addr=krzysztof.kozlowski@oss.qualcomm.com; keydata=
 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
 cwzYbmi/Et7T2+47PN9NZAOyb771QoVr8A==
In-Reply-To: <yq1v7fk42r1.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: wNQkcf3wspifXVKxWKxc5vbxCB2scvBK
X-Authority-Analysis: v=2.4 cv=IqMTsb/g c=1 sm=1 tr=0 ts=699febb1 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=6nO30s3o7FuWeffXwhKHTA==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=l5eyU-Q3JOpKGWt98rQA:9 a=QEXdDO2ut3YA:10 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDA1NyBTYWx0ZWRfXwC6HoyOS5YkE
 G9ruMDfoHn5UPL0qtmDtBS0EZYLqRAiYe54jE6Hpc/BXQhMeLy0rjVs35zLd+1HHp0EABe5xdPV
 sSV4c4kYXS6jmjqX/55TXpR1gTfqgNw+LUBLvmt1NZdbtUZxw7fxASmXFL5KshbpWPo+TuS8UmU
 yvGAvwYYKRor7d3VlstlOKo8/QJRBYJ5YRm4cOZ9fqD9iC81as090MpSGsg98NlGsoxE+//fGZ6
 LNuMqf+HDHarDPSCL5nJgsv1wE6XT+JfVVvNhlllnnbPfFyYTDQRjST11oK4Z2H85vPCxLo1qPE
 VZbTpwZBQ3cFmPwLaHRpoI6bj0otq5PlSzCUylr/i+di8BhzalsDlMTARIZejc9xpj6MuCAOQRc
 aDglKAUU69imAdNHQIeYISJeZvGFsJRMl4oWSa5Mrm1cgzVAvGqO/ln8zrqSb4c8QF7Bex3xY6t
 1T7SXETVZRhFmzJJAMQ==
X-Proofpoint-GUID: wNQkcf3wspifXVKxWKxc5vbxCB2scvBK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_04,2026-02-25_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1011 lowpriorityscore=0 suspectscore=0 adultscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602260057

On 26/02/2026 04:36, Martin K. Petersen wrote:
> 
> Hi Krzysztof!
> 
>> Driver subsystems CANNOT take DTS patches because DTS is independent
>> hardware description, thus combining them implies dependency and
>> usually means users can be silently affected. We expressed it many
>> times and documented it in point 7 of [1] (although it does not need
>> any documenting because it is different subsystem - why would you ever
>> take arm64 stuff without acks/permission from its maintainers?)
> 
> I frequently add impending series to my staging tree. This is done to
> see what breaks and what doesn't if I were to actually merge something.
> Being in staging does not imply that things subsequently go into
> scsi-queue. But obviously it does send the message that I am looking at
> merging patches from a given series in near future.
> 
> My script tries to cherry-pick any commits from a series that are not
> already in linux-next and which look relevant for the code to build and
> run in a cross-compiled environment. The script is certainly not
> perfect, figuring out cross-tree dependencies is not at all trivial. And
> I certainly appreciate when submitters clearly indicate which patches
> need to go through which tree. In this particular case there isn't a

The subsystem prefix defines it - first prefix in the subject.

Why would you take arm, arm64, mips or riscv marked patches without
their maintainers agreeing on this?

> dependency that would prevent me from building the code that I actually

You took patches which have nothing to do with building code. DTS has
nothing to do with that.

> merge. But that isn't always the case. And I clearly need to be able to
> build and validate the patches I subsequently put in scsi-queue.

You cannot validate DTS outside of SoC changes. It does not work like that.

> 
> I'll try to make my script more iterative and only backfill patches if
> the build fails. Hopefully that'll resolve the situation...

Can you instead DO NOT pick up patches which are clearly marked not for
SCSI? Like prefixes: arm64, ARM, RISC-V, MIPS and powerpc, unless
maintainers ask for that?

Best regards,
Krzysztof
