Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F664D6C5D;
	Mon, 28 Sep 2026 15:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790610358; cv=none; b=fWbAHtBW2Mz1nQ6lbHViVSq7r1QcmtLp21vNGq4xbI17TYfVQgk438T6/XBjzjbcgxBmQAHolAd8pPekG6k5lF9sy8/EaXQkW8orAZp9xoCnWub3Ead+f+19LbTKxj7u9PlW+3bPFzTgIAmgZrI6IqIUjJ4QLciCn8KRkZ5zyAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790610358; c=relaxed/simple;
	bh=5/Mr4bZYVvwDb1E2f7zT2r2zcBHMFKR8KlLVnNXhPpU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=KahJg7p5MT5cUaZmlIz1kVOjSjMOHzrsxqKL0OAOrbaF4AAC/oQpP0sal9Jyym+0Un36WeBERDfjuLr9D5ef78uT1GPt/I/RW2i8xyskSFe5SAJYzuCMzp54jwMZ2j+I6oiSpzuu8/dbVcQEb3yB3g2XDs6nRFoa5osJnAoZdqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iJcwI/T5; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iJcwI/T5"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SF5ikb1269117;
	Mon, 28 Sep 2026 15:45:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=sYPvC5VNJ9T1YDXYML+EzE2jNgSNES
	NOr/gh5Y9PArw=; b=iJcwI/T5cBMdrureBRxpeRXvcWYx9sUOMKerugHJdeihbq
	bxd+LpUc6viAdnL151sA+u54WDwqGgHJ2gJYAHfZZKg1J7pJKc5g5uB5OYfezGxD
	dt8BP2fLheai9YHXaowUZi50lk07DmgOqsLrQ5QBIGL3GCVypYKvk3/SQZDlWfCR
	hoKtApQtyYmBty+KB/qZp2Fm9Z/bJFdi8MLDUG/c01HXRrWE6rzYMcECgpIjRIZ7
	2zpzYIHaAi7tFSZ5CuFaS8uADFkD2XOnVZSQnUO2JL6VdFdmOpubcyNeIpHxmSQ3
	fLtQBfpERK+abGNQZ+xyewIs6MfOwaEK8G5jaYfQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx3fk2a2y-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 15:45:53 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68SElWqV3181806;
	Mon, 28 Sep 2026 15:45:53 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gxtkg5rtb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 15:45:53 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68SFjquo30278370
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Sep 2026 15:45:52 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F0FA25803F;
	Mon, 28 Sep 2026 15:45:51 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D088C58056;
	Mon, 28 Sep 2026 15:45:51 +0000 (GMT)
Received: from d (unknown [9.61.160.252])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 28 Sep 2026 15:45:51 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-bot@kernel.org
Cc: "Tyrel Datwyler" <tyreld@linux.ibm.com>, sashiko-reviews@lists.linux.dev,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v11 07/11] scsi: ibmvfc: extend async event handlers for
 async sub-CRQ events
In-Reply-To: <20260925050023.8E5481F000FF@smtp.kernel.org>
	(sashiko-bot@kernel.org's message of "Fri, 25 Sep 2026 05:00:23
	+0000")
References: <20260925044900.414340-1-tyreld@linux.ibm.com>
	<20260925044900.414340-8-tyreld@linux.ibm.com>
	<20260925050023.8E5481F000FF@smtp.kernel.org>
Date: Mon, 28 Sep 2026 10:45:51 -0500
Message-ID: <87ld8l5qhc.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IxI_TvdDSdLThxV2-h6QgauV-cIu_0b4
X-Proofpoint-GUID: IxI_TvdDSdLThxV2-h6QgauV-cIu_0b4
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA2MiBTYWx0ZWRfX96GX6A44GtY6
 gbWIkm0gQ6Bk4vSFqjJTElMey90sM9lKkkOxs1GIm1skdq9wH4X0Wm4DNPmFFmw5FbWoSdQvEOb
 pBL/ZAUQy6sS2Kql7U1EG6LhybRCyYA=
X-Authority-Analysis: v=2.4 cv=Vv62kO2n c=1 sm=1 tr=0 ts=6aba8bb1 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=JSOx8VvfMqNT5BbnElQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA2MiBTYWx0ZWRfXyg42/6IaEbWv
 p95NTqzj5gjLeck9mkEWpEQ1PkmHK/WnEEJh36RaYJlf1FYeeEjypmcoE+ZWu/qoSACDU0kpX/c
 LggElYoAeIGzwJSWo+MZgnd7bsqnnbJwz3qe8nv58+BwcfV1xoYg24x+iYQFevhvul4zGmJJX9N
 pFkvwS6fwB675DD0FbvayZXvD7Nu9VFynBaZy2ZY43Ml2CXEpN2lXxKDiuyrs3es/NwpvXr5EXi
 tZTgcdM9mVoip7lKefsSfxy42otlkgKOwwbnuncCAVWsBbqRp9lIWubycrDyxKNulxqtezpyqoT
 GYQXqm27fVyBONEGMGZRl7stMUFKBc4iB2gpYgi1ssV8utTULf1N76jN7wX/kkOdKacpBGxXaik
 K6YvHofq1iWfjpd5tAI/451a8/zKV9CQTIeeXLiAxgPGmzBL16wvO862sVzlP9tuiEpc5Znoxfd
 U6vZ0sUGytq/gNftEiA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 lowpriorityscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609280062

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] scsi: ibmvfc: FPIN descriptor uses potentially unpopulated WWPN from sub-CRQ
> --
>
> commit 8a1ab5ee327462636518cdba29b91df0f867bb9f
> Author: Dave Marquardt <davemarq@linux.ibm.com>
>
> scsi: ibmvfc: extend async event handlers for async sub-CRQ events
>
> This commit refactors async event handling to support both traditional async
> CRQs and new asynchronous sub-queue CRQs. It introduces a tagged union that
> wraps the async event and dispatches processing based on event type.
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index f465efadc02c8..321bb2f7219ed 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> @@ -3426,6 +3426,45 @@ ibmvfc_basic_fpin_to_desc(struct ibmvfc_async_crq *crq, u64 wwpn)
>>  					  cpu_to_be32(1));
>>  }
>>  
>> +/**
>> + * ibmvfc_full_fpin_to_desc(): allocate and populate a struct fc_els_fpin struct
>> + * containing a descriptor.
>> + * @ibmvfc_fpin: Pointer to async subq FPIN data
>> + *
>> + * Allocate a struct fc_els_fpin containing a descriptor and populate
>> + * based on data from *ibmvfc_fpin.
>> + *
>> + * Return:
>> + * NULL     - unable to allocate structure
>> + * non-NULL - pointer to populated struct fc_els_fpin
>> + */
>> +static struct fc_els_fpin *
>> +ibmvfc_full_fpin_to_desc(struct ibmvfc_async_sub_crq *ibmvfc_fpin)
>> +{
>> +	__be16 type;
>
> [ ... ]
>
>> +	return ibmvfc_common_fpin_to_desc(ibmvfc_fpin->fpin_status, ibmvfc_fpin->wwpn,
>> +					  type, cpu_to_be16(0),
>> +					  cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_THRESHOLD),
>> +					  cpu_to_be32(1));
>> +}
>
> [ ... ]
>
>> @@ -3463,28 +3502,40 @@ static struct ibmvfc_target *ibmvfc_find_target(struct list_head *target_list,
>>   */
>>  static void ibmvfc_process_async_work(struct work_struct *work)
>>  {
>
> [ ... ]
>
>> @@ -3496,7 +3547,11 @@ static void ibmvfc_process_async_work(struct work_struct *work)
>>  		goto free;
>>  	}
>>  
>> -	fpin = ibmvfc_basic_fpin_to_desc(crq, tgt->wwpn);
>> +	if (crq)
>> +		fpin = ibmvfc_basic_fpin_to_desc(crq, tgt->wwpn);
>> +	else
>> +		fpin = ibmvfc_full_fpin_to_desc(subq);
>> +
>
> [Severity: Medium]
> If the hardware sends an async sub-CRQ FPIN event lacking a WWPN but
> providing a valid node_name or scsi_id, the driver successfully resolves
> the target (tgt) earlier in this function. 
>
> However, ibmvfc_full_fpin_to_desc() uses subq->wwpn instead of the resolved
> tgt->wwpn. Could this generate an FPIN descriptor with a zero attached WWPN,
> causing fc_host_fpin_rcv() to fail to match the target's rport and drop the
> congestion statistics update?
>
> The legacy CRQ path safely passes tgt->wwpn via ibmvfc_basic_fpin_to_desc().
> Should ibmvfc_full_fpin_to_desc() be updated to also take tgt->wwpn?

I agree. I've extended ibmvfc_full_fpin_to_desc() with a new u64 wwpn
argument, similar to ibmvfc_basic_fpin_to_desc().

-Dave
