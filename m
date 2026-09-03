Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E57381B0A;
	Thu,  3 Sep 2026 18:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788461020; cv=none; b=N7b70Cjh9SOlnmtdVaGNLl2+eCad6IWYJfGdcaKisdfuoT809djmvZ7Mi7bwuwoUqHJn8pVxNanc8ku59Zx4Wkd9OSamXl5VDqWuWud44TXjFU5jsfDJBxzlGm6duYD6RPll+5FTrILGC9mrX7KDxnnv33vP4yFgyUnFtIQJ7JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788461020; c=relaxed/simple;
	bh=VY9pyL00O9MfgC7Uz2zjys8pVKtfm83bsFaJSlzNPXY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=RsSRrsN83e7vqUEmHdPg2W7ScBtNysnvCyMAtzCxNnN4jix5miqjbjO5CaklEfG2kMQpLjyX8eUJjBVjxEhaIkXsZICR7Cc1w1e2dzXI+JIm/ueB3521XyPCBtclRJQt4/vUvlAeRmv3Mr35XM8eUDLQpH8BQCxufzPbvdT1mDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dtkkQXFL; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dtkkQXFL"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 683G2Q7r3425605;
	Thu, 3 Sep 2026 18:43:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=lNoCnKIKmJnAV/tEP3zbMoKZ1ehvE8
	Ho++ZZ+eK9vhs=; b=dtkkQXFLVj4zN5WP4jAeW4d3EpGb8vdw6tg/xz6evmG564
	b6KTgPCIu/bFjcKdhCPCTGhfTj91UJS13R8TsMlt+rN66U1OWyK1YWWWUAFMBKWL
	Pq0O/I0ZPpE3f2dd9UCiyypYNwGb0ziXB+WOSKP1kZ9dohBYJ1bTIwJPStTIJkEu
	CnuE4ReIlsQe5dz/VZBADuJCm7daYQouUi1O6xG/EZXIZOx+IHfeF9Kn1WuXPC33
	Uhw2DkMAxjs+KGpZnC47378XW8mb8u+Xq+Aauvjm1OGa6+1lL6wRnuNg2jTIzq7O
	IHGud3JfktcaG8y7QVADm3m7CqIK6ajajzVtHKyQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbq556jf0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Sep 2026 18:43:38 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 683IfXDx000412;
	Thu, 3 Sep 2026 18:43:37 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gecjasd4a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Sep 2026 18:43:37 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 683IhaVd16908906
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 3 Sep 2026 18:43:36 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7A1595805D;
	Thu,  3 Sep 2026 18:43:36 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 63B3658055;
	Thu,  3 Sep 2026 18:43:36 +0000 (GMT)
Received: from d (unknown [9.16.41.19])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  3 Sep 2026 18:43:36 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH v7 6/8] scsi: ibmvfc: extend channel registration and
 deregistration for async subq
In-Reply-To: <20260831223431.2F4341F000E9@smtp.kernel.org>
References: <20260831-ibmvfc-fpin-support-v7-0-77d0b9809080@linux.ibm.com>
	<20260831-ibmvfc-fpin-support-v7-6-77d0b9809080@linux.ibm.com>
	<20260831223431.2F4341F000E9@smtp.kernel.org>
Date: Thu, 03 Sep 2026 13:43:36 -0500
Message-ID: <8733vq5g6f.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDE2MiBTYWx0ZWRfX2qP3PaEyX4Kd
 tJ5492BHBpDhuwlYft5cEcaMVGDh5OLTIAzeZR+5HaQbhYqDTCmcIWr2Z1FOg/07RayUnrpQ0PT
 ZKSbptU5xBa9x9s/SCuVbwwKB+eaMIPEvtWIPifVup6zoftDSV78DDefGEAWqIiXb41GK+HQhgy
 YppNwK/wLChVboN32xzH84FYTF20N+FN1T+urHMQ0K3P+0FLK9qx3vJQvBwX8eRSLZOuBW7VS+K
 q+KFRe0h+o0Fb2kE8kUmn64SmFF6HXm4bNtmsJ6BC9HpwzIcK7Y3GGHJr8uzi8jrn8dad23lYPt
 tVggMZ//LGc8jNEDxfaY3VJpEDjUHdhB5dARsVRg2qeEHwnSaB5uEr0cWTm60PgI15hH9wjVNbS
 h5YHBC4yx6sxXuQ3PgIrij5L2VdRea5OQgyBDgWBs3UGc7PXpcm8TQ8Xm1eGefXBWxpP9yEODMp
 /EVssti3UgEx+9U975Q==
X-Proofpoint-ORIG-GUID: nNdcDsrwh3BYkpSl0Me4-2RE9uEkTfSD
X-Authority-Analysis: v=2.4 cv=CNgamxrD c=1 sm=1 tr=0 ts=6a99bfda cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8 a=cFIKowR6tQ2XqRsfE8cA:9
X-Proofpoint-GUID: nNdcDsrwh3BYkpSl0Me4-2RE9uEkTfSD
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDE2MiBTYWx0ZWRfX/pkxUQ/dnUbf
 y72es/9NxzRyJiv8z9jS2AofViI6CBpZdDPrbG27/faNyt0zRGWxirYpwf9Bx9olLpzLoMqZZ1r
 nVI3TGMBAz3jPDEe6kjKQcMPt2Gmodk=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-03_05,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609030162

sashiko-bot@kernel.org writes:

>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> @@ -4409,7 +4409,7 @@ static void ibmvfc_drain_async_subq(struct ibmvfc_queue *scrq)
>>   * @scrq_instance: async subq
>>   *
>>   **/
>> -static irqreturn_t __maybe_unused ibmvfc_interrupt_async_subq(int irq, void *scrq_instance)
>> +static irqreturn_t ibmvfc_interrupt_async_subq(int irq, void *scrq_instance)
>>  {
>>  	struct ibmvfc_queue *scrq = (struct ibmvfc_queue *)scrq_instance;
>>  
>
> [Severity: High]
> Now that the async sub-CRQ handler is enabled by this patch, can its
> execution race with target teardown or host reset? 
>
> In drivers/scsi/ibmvscsi/ibmvfc-core.c, the interrupt handler calls:
> ibmvfc_interrupt_async_subq() -> ibmvfc_drain_async_subq() ->
> ibmvfc_handle_async().
>
> The ibmvfc_handle_async() function expects to hold vhost->host->host_lock,
> but this call chain only holds scrq->q_lock. Consequently, it iterates over
> and modifies vhost->scsi_scrqs.targets without the proper lock. 
>
> Could this lockless list traversal cause a use-after-free or data corruption
> when handling dynamic async events sent by the hypervisor?
>
> [ ... ]

This is fixed in the next revision of patch 5, where the host lock is
acquired and released in ibmvfc_handle_async.

>> @@ -6825,36 +6841,49 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
> [ ... ]
>>  	rc = request_irq(scrq->irq, scrq->handler, 0, scrq->name, scrq);
>>  
>>  	if (rc) {
>> -		dev_err(dev, "Couldn't register sub-crq[%d] irq\n", index);
>> +		if (!is_async)
>> +			dev_err(dev, "Couldn't register sub-crq[%d] irq\n", index);
>> +		else
>> +			dev_err(dev, "Couldn't register async sub-crq irq\n");
>>  		irq_dispose_mapping(scrq->irq);
>>  		goto irq_failed;
>>  	}
>
> [Severity: Medium]
> This is a pre-existing issue, but does leaving scrq->irq populated with a
> stale value after irq_dispose_mapping() cause a kernel warning during
> teardown?
>
> If request_irq() fails in ibmvfc_register_channel(), the error path calls
> irq_dispose_mapping(scrq->irq) but does not clear the irq field to 0. Later,
> when ibmvfc_deregister_channel() is unconditionally called for the async
> sub-CRQ during teardown, it might call free_irq(scrq->irq, scrq) on this
> stale mapping ID (or on 0 if it was never registered). 
>
> Should scrq->irq be explicitly cleared to 0 in this error path to prevent
> invalid IRQ descriptor warnings?

Agreed, this is a bug. I will add a separate patch to fix this issue.

-Dave
