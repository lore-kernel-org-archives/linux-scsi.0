Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F7425C818;
	Fri, 16 Oct 2026 15:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792166037; cv=none; b=f8Oql/DSmY3UvcCW0516la3spylK75CDUy3jIueYSH683Q2gAnvHoask+99suRovtjli3vtNIbie5cgy+YOBo+1VTrgP/pIVOGBMfvzwvh0NUERwF3MoLUE3SlW0VbJKuY3xmJsrYZIVfrYPiKrbtas1H4uzdFncdVVJT1FEKRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792166037; c=relaxed/simple;
	bh=yjR9YohEk9r0B5Bt/aE1yVkGKeBubww7kAMCTUVyJD8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=JF7/MIdGbcAXXzXW8eaWGmPzrj+7BgA4BgNU1t6PT03mhS9I5sWEMv6aM/QMCgapS7uvg7KdbS3sF5SPI/ck3YZJx9HYIn6RkzG+V1y86dI4sVuSNJwIc5g5JUJ9WG0Km7naJEk2N/A4iqg6eg+03XrZFdeEY3eHaAr/JxX7V3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nzTc+Q3Y; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nzTc+Q3Y"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GEEDBN2839646;
	Fri, 16 Oct 2026 15:53:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=Sus2b9A/FQpep4EebbjSO+xeWNwUuT
	C8IdCEnIp6SvI=; b=nzTc+Q3YBEuOORkZoDwEhnekXLkPwjnJ8lGT9XC9aeAOsQ
	Gt5adWY5tI8EXok6hc2J6+BkN4QqCDE/UZbZ6ByILhfb6DY6iaAYDzkW9B/2A+1b
	Bgw7wGVixrky4m9NXdr7jcO5IG75xCmdmJLXIy7AWINGcZsO1h4Q0OmFrfD+KcbI
	XWndSn340C9KimWUO32zHCFt5tnYVjZkE0wOkQyF9mKOMPQyFMIkz+LLKeN9P4h0
	yAbu95EmH/ExeuZCgHZ1RqkvvlP0XoABBmrbD2T0ao1y46EOobUadgnvxHMR8ZfM
	B4vX/8sqCOaAUEk+zjTmF+nGuwLk3VtpPcc+H7Yg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h7dv0yed5-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 15:53:53 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69GE5hA73752573;
	Fri, 16 Oct 2026 15:53:52 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hb34mm5qq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 15:53:52 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69GFrq2m26084020
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Oct 2026 15:53:52 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4770F58050;
	Fri, 16 Oct 2026 15:53:52 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0414758045;
	Fri, 16 Oct 2026 15:53:52 +0000 (GMT)
Received: from d (unknown [9.61.189.254])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 16 Oct 2026 15:53:51 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-bot@kernel.org
Cc: sashiko-reviews@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v14 09/11] scsi: ibmvfc: extend channel reg/dereg
 helpers for async sub-CRQ
In-Reply-To: <sashiko-outbox-173056@kernel.org> (sashiko-bot@kernel.org's
	message of "Thu, 15 Oct 2026 15:21:15 +0000")
References: <20261015-ibmvfc-fpin-support-v14-0-a0b063b8d825@linux.ibm.com>
	<20261015-ibmvfc-fpin-support-v14-9-a0b063b8d825@linux.ibm.com>
	<sashiko-outbox-173056@kernel.org>
Date: Fri, 16 Oct 2026 10:53:51 -0500
Message-ID: <87qzhpbq0g.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA2MiBTYWx0ZWRfXzds0Yt7T4a5J
 lG/L+fRGZd6hKUq6ZqA31mtx825M1RLMH0tJFQu36ODmhHm7hVmZp04gmvhnphpwjcql7VS165C
 9SP7VaTXx4iHNxB1z8yGy1pOuL5c748GisO7aWML6CMJY1ZDm1qN7pCp8UvP1JD+Xwxlk/xJz0d
 HahtJ7ssoYXeA0LmP9kyftyOK77ffZilLgMhKmR7dAivRpzI09cFB6xE4Tw2f2VyMuTg8zg2sbC
 Q6r9c8l5NBK8JlpsKQ30mrWQQQ5khuV6voT5BSjWA3UYTOsxGHWIZyUJqwErB6z6QWSKGQOnr3s
 NY6OGWWlqYK4jHShF43s9o8aFWPb0OmTXCkyLO0m/xP/mfrfZO32/TWapJG3JEKCClNFqvxHaPg
 ezvWCUWKFufM2cArRjE51e4CGuUswIGcO2YyAX7VdWpkxf7FtBL6VC6ATZ+TCfbpdsoHQyle5fD
 xrRc5hfiSEj/1GZg+mw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA2MiBTYWx0ZWRfX+jdNr9HUk1dZ
 ot+bAu9JNQHpS7mSBFDqrPl4n+FvQORNijXyBtTYWVN2LBnCSX7mJOHmeR594vC0lf6UQflxmd9
 CEgD3Q2pC1xqtwo30M+fxzaRgvkmN9E=
X-Proofpoint-ORIG-GUID: 8ghDN1npoILsNmHt848mzVjPdiDJrUKG
X-Authority-Analysis: v=2.4 cv=a6KlZkSF c=1 sm=1 tr=0 ts=6ad24891 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=18-5Fqv7mxGyy7mi-rEA:9
X-Proofpoint-GUID: 8ghDN1npoILsNmHt848mzVjPdiDJrUKG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_02,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0 clxscore=1015
 phishscore=0 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610160062

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Low] scsi: ibmvfc: race reading uninitialized hwq_id on early interrupt
> --
>
> commit 305244f5c1aeffae812f2cadfc3586d45148fbbe
> Author: Dave Marquardt <davemarq@linux.ibm.com>
>
> scsi: ibmvfc: extend channel reg/dereg helpers for async sub-CRQ
>     
> This commit extends ibmvfc_register_channel() and ibmvfc_deregister_channel()
> to handle IBMVFC_PROTO_ASYNC channels. It removes the __maybe_unused
> annotation from ibmvfc_interrupt_async_subq and updates error messages to
> include the channel protocol.
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index fc69012efccc0..b12655f028879 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>
> [ ... ]
>
>> @@ -6882,7 +6901,8 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
>>  	rc = request_irq(scrq->irq, scrq->handler, 0, scrq->name, scrq);
>
> [Severity: Low]
> Is there a potential race condition here when the interrupt is requested?
>
> If a hardware interrupt triggers immediately after request_irq() enables it,
> the newly bound handler ibmvfc_interrupt_async_subq() could run before
> scrq->hwq_id is initialized:
>
> ibmvfc_register_channel()
>     ...
>     rc = request_irq(scrq->irq, scrq->handler, 0, scrq->name, scrq);
>     ...
>     scrq->hwq_id = index;
>
> If an early interrupt happens, the handler calls ibmvfc_toggle_scrq_irq(),
> which uses scrq->hwq_id for error logging if the hypervisor call fails.
>
> Could this result in reading an uninitialized (zeroed) scrq->hwq_id in the
> dev_err() message? Would it be safer to initialize scrq->hwq_id before
> calling request_irq()?

Yes, it would be safer. Consequences, as you say, are low, as hwq_id is
used for error logging in ibmvfc_toggle_scrq_irq(). In the case
described, it would log "sub-crq[0]" rather than the correct sub-crq index.

Will fix in v15.

-Dave
