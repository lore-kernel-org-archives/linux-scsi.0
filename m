Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32AE4D0CD0;
	Mon, 12 Oct 2026 19:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791834301; cv=none; b=VgimLS2W8qWmpTMaT9HBBThfu5C8poChS7PgrfakJYH86U+cOS7/psXaPzwRP+7Myox9a+jVzZGnM2rm+lCw6kol7ZyVjqSFn7ocZSeF/KbMF/agUD6J50r5NxoMBW1CfEQnX/82FMNLLkb6R/ub237fuEtrXmtk8WFWHeOtjwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791834301; c=relaxed/simple;
	bh=1wVs4F5ciF8VSOAjs0XYmXKN6i1GpfW5Cso5tHzGzyU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=rpRq+9H38+BDaXlH0jQXZ6eFJXO+fQzc372QKQZID21pJGEahnzTPLd1RPOzCUIgW5rXGLr0BbrH59a0qZd8/vP7Uqy6gW3+9broXr+PPdk1v/pKy2BgEhak9uu19ibLr1S0LIeFeXeQMdkItICU7wCuNXeG3Wxmnw3RJ/XzqME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bw/duoUi; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bw/duoUi"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69CJiP4W3560170;
	Mon, 12 Oct 2026 19:44:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=zjS/aBFPPn2mAPT94SI3dE6M3aEDjq
	3ZP24JaOBqrEk=; b=bw/duoUi/GimlXjOuEgVAiHNkPqjpBEf4t6CmsI0PQPY3f
	baSDn/3Bu1NwwaE7OH/Dnu0H/zfFIsX27EG4nVs88Tt1A2YorT8CvCt83JIxrqY2
	uQnJ/SH4K/B1IwMNZVxQHS2ZLlyjsVgmfrATtjNZ+t2yF5eGfwEDZkgy2KJq00r+
	P7mqIlcKLkDOTKfRYG12S11ljFngCh2cjklxPjhnWIJQakCYnZdfdJjmOKHI8y7Q
	Fc2uiGQ02zdO9FVj8KyXmpgTusjiF9+yjGTsI1GblU9z8TTfO1++pMQ2k2S+OKNm
	yt5ZIYXkxs2ryO2/oaLgJtv9CeD9asJXCWfyXM6g==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h7dwhak6a-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 12 Oct 2026 19:44:58 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69CJdLLd1828949;
	Mon, 12 Oct 2026 19:44:57 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h802vpspx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 Oct 2026 19:44:57 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69CJiv2d60883222
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Oct 2026 19:44:57 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 10AE55805D;
	Mon, 12 Oct 2026 19:44:57 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C9E1658053;
	Mon, 12 Oct 2026 19:44:56 +0000 (GMT)
Received: from d (unknown [9.61.18.84])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 12 Oct 2026 19:44:56 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-bot@kernel.org
Cc: sashiko-reviews@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v13 08/11] scsi: ibmvfc: add interrupt routine for
 asynchronous sub CRQ
In-Reply-To: <sashiko-outbox-163322@kernel.org> (sashiko-bot@kernel.org's
	message of "Wed, 07 Oct 2026 19:44:57 +0000")
References: <20261007-ibmvfc-fpin-support-v13-0-b816abfa4fcc@linux.ibm.com>
	<20261007-ibmvfc-fpin-support-v13-8-b816abfa4fcc@linux.ibm.com>
	<sashiko-outbox-163322@kernel.org>
Date: Mon, 12 Oct 2026 14:44:56 -0500
Message-ID: <87mrsivh3b.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDA3OCBTYWx0ZWRfX25evwNUfcuJE
 kJwtxVnDM5Bj4fdF676ERWjBP/KjkErUlO00DYVKLsQkSsqUk81lWni0dNChbHJp+b2VS5Yt93S
 f+e3VYcR37Ae+ny+bGp2r9Lu1rn9fCY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDA3OCBTYWx0ZWRfXxBGLfn77mcqh
 UYrJVNy+bWh1g+39FVyhp7G9nam1VAdf+Tq6PHgntRdRP7BW+pCORBaupObIK9ZJTPi/hZlezI9
 hUn0kzi1pEtNkDHbVm9KvW4QpS5yuK6nXWtl2gHKPh12VhJ0EYJQ+Wl0X+xuwXNRvfrWdjcWjnu
 A4Mkm7Ei+/Qn7Rb1e70MbcP6QKjnWbe79oAzp1UOodNraX1qI3ePWbnai6NHVrDrMXsayintIo+
 cKWGyIx55d/7bUOilYCejWy6Toccd9ax4fsubQS/g4EYir7Wbb8xf6OwmfzitWE/9DuG49/ELJe
 MnK+2IPS1AMV8ocrz5BC1QPkeziA6x0RQna3LV5smH4ETF/ye+SvHwBjWpqQbwEayD9kF6y+eE3
 9cdIKNvlqVu902QQ5bn3KFFmnv9O0myJ1EhSzgFtTJTJ26RyVqB/VtPhAje4D1xEuNMafWHFbvU
 7GAKcrA8/XLzSCBiWAg==
X-Proofpoint-GUID: k2gTqRdWCAb4nkCDATJHqFizpiC_muL7
X-Authority-Analysis: v=2.4 cv=RoFQvymK c=1 sm=1 tr=0 ts=6acd38ba cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=WBn1sSDi7QvAjcg4snAA:9
X-Proofpoint-ORIG-GUID: k2gTqRdWCAb4nkCDATJHqFizpiC_muL7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-12_06,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0 bulkscore=0
 impostorscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610120078

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] scsi/ibmvfc: missing load-store memory barrier allows DMA ring data corruption
> --
>
> commit 69de3faf2b9168cb1feb3f85a48430596c1d9283
> Author: Dave Marquardt <davemarq@linux.ibm.com>
>
> scsi: ibmvfc: add interrupt routine for asynchronous sub CRQ
>
> This commit introduces an interrupt handler and a drain routine for
> asynchronous sub-CRQ events. It adds direct traversal of the async
> sub-CRQ ring and processes available entries while managing the queue lock
> and hardware interrupts.
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index 6db9df91e9e68..32bc00a4be7ec 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>
> [ ... ]
>
>> +static void ibmvfc_drain_async_subq(struct ibmvfc_queue *scrq)
>> +{
>> +	struct ibmvfc_host *vhost = scrq->vhost;
>> +	struct ibmvfc_async_crq_event ae = {
>> +		.type = IBMVFC_ASYNC_CRQ_SUB,
>> +	};
>> +	struct ibmvfc_async_sub_crq *crq;
>> +	unsigned long flags;
>> +	int done = 0;
>> +
>> +	spin_lock_irqsave(&vhost->host->host_lock, flags);
>> +	spin_lock(scrq->q_lock);
>> +	while (!done) {
>> +		while ((crq = ibmvfc_next_async_scrq(scrq)) != NULL) {
>> +			ae.subq = *crq;
>> +			ibmvfc_handle_async(&ae, scrq->vhost);
>> +			crq->valid = 0;
>
> [Severity: High]
> Could the store to crq->valid be reordered before the reads from the payload
> complete?
>
> On weakly-ordered architectures like PowerPC, a load from memory can be
> delayed and executed after a subsequent store unless separated by a memory
> barrier.
>
> While ibmvfc_handle_async() takes spinlocks in some paths, it does not
> execute any spinlock or hardware barrier before returning in others
> (such as IBMVFC_AE_LINK_UP or IBMVFC_AE_SCN_FABRIC).
>
> If the hardware observes valid == 0 early, it might overwrite the new event
> while the CPU is still reading it, causing the CPU to ingest corrupted data.
> Does this require an smp_mb() or smp_store_release() before clearing the
> valid bit?

Note that the IRQ is disabled in ibmvfc_interrupt_async_subq() before
calling ibmvfc_drain_async_subq():

	ibmvfc_toggle_scrq_irq(scrq, 0);
	ibmvfc_drain_async_subq(scrq);

So I'm unclear how the hardware would be writing to *crq. Certainly not
through an interrupt.

I don't think this is a valid concern.

>> +			wmb();	/* complete write */
>> +		}
>> +
>> +		ibmvfc_toggle_scrq_irq(scrq, 1);
>> +		crq = ibmvfc_next_async_scrq(scrq);
>> +		if (crq != NULL) {
>> +			ae.subq = *crq;
>> +			ibmvfc_toggle_scrq_irq(scrq, 0);
>> +			ibmvfc_handle_async(&ae, scrq->vhost);
>> +			crq->valid = 0;
>
> [Severity: High]
> Does this race-closure check also suffer from the same missing load-store
> barrier before clearing the valid bit?

Same issue here: interrupts are disabled.

>> +			wmb();	/* complete write */
>> +		} else
>> +			done = 1;
>> +	}
>> +	spin_unlock(scrq->q_lock);
>> +	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
>> +}
