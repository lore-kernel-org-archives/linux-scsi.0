Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B962E4D2EC7;
	Fri, 21 Aug 2026 15:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787325368; cv=none; b=cG5iClqIT9B1uWGRzmNjrtyQMCBnT34Xx+QsY1TJevfaQZyF7c/YolT+y6kpHLGjGO5TgMMoo+CstULPhOcn1YVaIbp+JtnOfy3+UI8JIwHcMIsqw/Sc4Yum3FEtRMlPFyopaunRU5il0cMo3XFfvIkIVCTKxvd5E9SRZ6uwDS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787325368; c=relaxed/simple;
	bh=u2bFXzyEqF0qjPZdn9UBLqMfN5LO8RKaIAjSo3TFlcE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=cusPnfgGwUiKUkZsLf4qtgxjxUkIj41PR/bCztyHkO63bqOjexjPAuDRyL47xArhWpWTwogkjyoLZYjMOsQ/Pi/Tm82MMJWoNyqoTxzWEKC4awrOc8Gvtm+YDGbKFYXfmZmEfgrLwNmF1Bnayb9DEqhXAoqBXuzAk2DxPgWnPnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SOIJDbfc; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SOIJDbfc"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67LD22Ck1473913;
	Fri, 21 Aug 2026 15:16:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=tTFwJ7REdtHXeVhxM1E34cZaTS6m54
	LIkvNjmy7LXKI=; b=SOIJDbfc99VxPVfTX0P3KnZQUZMz9krBw9Y6CEb4i39CCA
	f8bxi1fCNz91UD12IBPff6tThsMEHPldBhWiyIDpKkcSxIgFLecYkAsKiSzIf+RH
	jfnRaBVu2A7YZd1aJBhs7skxCH4MqsRw7Z2+Vz+jNQ5XskfkKShjOtAf4qyi2tI4
	fR8VR26u9tEoetaEDoD8dH362Uq9zGDU6tWv1NPeXFIEnMRUn0YF0J7qvXs6aAEo
	Xou34TuAca7p5vnxv8nRfQ7cEUWYGm/3PdgMQgAC2dmN6A20aDI9kCV9okywBlzF
	fSWGWQLfOKa1kt8MgAlQV97cwDmRZNUiB8styiUA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g4yu4j71g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Aug 2026 15:16:04 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67LFBLsp007854;
	Fri, 21 Aug 2026 15:16:03 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g354yw33f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Aug 2026 15:16:03 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67LFG3SB31326746
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Aug 2026 15:16:03 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3A0DA58043;
	Fri, 21 Aug 2026 15:16:03 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 16B0E58059;
	Fri, 21 Aug 2026 15:16:03 +0000 (GMT)
Received: from d (unknown [9.61.29.95])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 21 Aug 2026 15:16:03 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH v6 4/8] scsi: ibmvfc: extend async event handlers to
 handle async sub queue events
In-Reply-To: <20260817204225.820DC1F000E9@smtp.kernel.org>
References: <20260817-ibmvfc-fpin-support-v6-0-62a2d525e70d@linux.ibm.com>
	<20260817-ibmvfc-fpin-support-v6-4-62a2d525e70d@linux.ibm.com>
	<20260817204225.820DC1F000E9@smtp.kernel.org>
Date: Fri, 21 Aug 2026 10:16:02 -0500
Message-ID: <87wltjwll9.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIxMDExNyBTYWx0ZWRfX+9ZKzqd0GrSv
 5knc2IBBw0lt7ZTlEhqgEM35gVxi9eGkTi2v52YZC6PCkSNAS7PFassa+47r+mhuDFmdjE3nBKL
 JkhM27spmpPiP5jxSE/Vpc+KeAxgN7k=
X-Proofpoint-GUID: yf9_M323pt-rPOH4DzlOAHKM1q35wsZ1
X-Proofpoint-ORIG-GUID: yf9_M323pt-rPOH4DzlOAHKM1q35wsZ1
X-Authority-Analysis: v=2.4 cv=RPmD2Yi+ c=1 sm=1 tr=0 ts=6a886bb4 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8 a=wjdOJu5Tfd68bEvC1G4A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIxMDExNyBTYWx0ZWRfX0I7Do/rGjuMU
 SpfINGcgpU1frlO59pHpfDw2nE/VcLN3IIIupx0J9MLhRWa6qpNpzZKSBLMA9zz21QiQYKiqNJc
 24pEI9HfaRnb5FEVdV9rdS2FUlh75wsnYlYK8Utxl4IpT7uvkV+VOwsFEKvt21EdCpU18loxjdf
 tNJ8SeP20vIFv8NEtq7xoG1T1dYLKwwMtzfMvXRSb/UdoCW3tRwWMYYBL4GlB/UFToD70AJ4W6v
 qQqVwD99Y/ycQ5+LCZW1G4PSy6f7oZr+mmRLOU4q0yHpvHHecC7y8YwR2yna9Efehm1TNPeUFiO
 v3+ropbMw0uMU1n4ZB5GOX3lXVduHSAoBKkqoV7x0Ouhi/9rrEfzRFT0yEfau5hEZ+L7wbnXzKY
 RXveQQ73QBDFQK0uVbkldXmZzMqhYTQ8nksCbyLfZ5ihDjCJ1iTxPTDtkO77V0qbQ/k1VJHy2ti
 W1FbArmmO81i0FDygSA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-21_04,2026-08-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 phishscore=0 adultscore=0 spamscore=0 priorityscore=1501
 bulkscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608210117

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 4 potential issue(s) to consider:
> - [High] Double clear of `valid` in the CRQ ring buffer introduces a race condition that can clobber subsequent hardware events.
> - [High] Missing check for `IBMVFC_ASYNC_ID_IS_ASSOC_ID` causes `assoc_id` to be incorrectly treated as a WWNN, preventing target lookup and dropping events.
> - [Medium] KUnit tests use `msleep()` to wait for asynchronous workqueue execution, leading to flaky test failures.
> - [Low] Dereferencing a `void *` pointer in the unmodified `nvme_scrqs` loop inside `ibmvfc_handle_async` causes a compilation error.
> --
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index 19a3f12615648..4d1630d2ab1b5 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> @@ -3462,28 +3501,41 @@ static struct ibmvfc_target *ibmvfc_find_target(struct list_head *target_list,
>>   */
>>  static void ibmvfc_process_async_work(struct work_struct *work)
>>  {
>> +	struct ibmvfc_async_sub_crq *subq = NULL;
>>  	struct ibmvfc_async_work *aw;
>> -	struct ibmvfc_async_crq *crq;
>> +	struct ibmvfc_async_crq *crq = NULL;
>>  	struct ibmvfc_target *tgt;
>>  	struct ibmvfc_host *vhost;
>> -	struct fc_els_fpin *fpin;
>> +	struct fc_els_fpin *fpin = NULL;
>>  	unsigned long flags;
>> +	__be64 node_name;
>> +	__be64 scsi_id;
>> +	bool is_subq;
>> +	__be64 wwpn;
>>  
>>  	aw = container_of_const(work, struct ibmvfc_async_work, async_work_s);
>>  	vhost = aw->vhost;
>> -	crq = &aw->crq;
>> +	is_subq = aw->is_subq;
>> +	if (is_subq) {
>> +		subq = &aw->crq.subq;
>> +		scsi_id = 0;
>> +		wwpn = subq->wwpn;
>> +		node_name = subq->id.node_name;
>
> [Severity: High]
> Does this incorrectly treat assoc_id as a WWNN? It looks like we should
> check the IBMVFC_ASYNC_ID_IS_ASSOC_ID flag before unconditionally reading
> node_name, as this could prevent target lookups and cause FPIN events
> to be dropped.

The v7 patches now check taht IBMVFC_ASYNC_ID_IS_ASSOC_ID is not set
before using subq->id.node_name.

> [ ... ]
>
>> @@ -3511,25 +3567,52 @@ static void ibmvfc_process_async_work(struct work_struct *work)
>>  
>>  /**
>>   * ibmvfc_handle_async - Handle an async event from the adapter
>> - * @crq:	crq to process
>> + * @crq:	ibmvfc_async_crq or ibmvfc_async_sub_crq
>>   * @vhost:	ibmvfc host struct
>> + * @is_sub_crq:	indicates whether the crq points to a struct ibmvfc_async_sub_crq
>>   *
>>   **/
>> -VISIBLE_IF_KUNIT void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
>> -					  struct ibmvfc_host *vhost)
>> +VISIBLE_IF_KUNIT void ibmvfc_handle_async(void *crq,
>> +					  struct ibmvfc_host *vhost,
>> +					  bool is_sub_crq)
>>  {
>
> [Severity: Low]
> Will this cause a compilation error? The crq parameter type is changed to a
> void pointer here, but there is still an unmodified nvme_scrqs loop later in
> ibmvfc_handle_async() that directly dereferences it like crq->scsi_id.

No, this does not cause a compilation error.

>> -	const struct ibmvfc_async_desc *desc = ibmvfc_get_ae_desc(be64_to_cpu(crq->event));
>> +	struct ibmvfc_async_crq *async_crq = NULL;
>> +	struct ibmvfc_async_sub_crq *subq = NULL;
>>  	const struct ibmvfc_async_desc *desc;
>>  	struct ibmvfc_async_work *aw;
>>  	struct ibmvfc_target *tgt;
>> -
>> -	ibmvfc_log(vhost, desc->log_level, "%s event received. scsi_id: %llx, wwpn: %llx,"
>> -		   " node_name: %llx%s\n", desc->desc, be64_to_cpu(crq->scsi_id),
>> -		   be64_to_cpu(crq->wwpn), be64_to_cpu(crq->node_name),
>> -		   ibmvfc_get_link_state(crq->link_state));
>> -
>> -	switch (be64_to_cpu(crq->event)) {
>> +	__be64 node_name;
>> +	__be64 scsi_id;
>> +	u8 link_state;
>> +	__be64 wwpn;
>> +	u64 event;
>> +
>> +	if (is_sub_crq) {
>> +		subq = crq;
>> +		event = be16_to_cpu(subq->event);
>> +		link_state = subq->link_state;
>> +		scsi_id = 0;
>> +		wwpn = subq->wwpn;
>> +		node_name = subq->id.node_name;
>
> [Severity: High]
> Is it possible to receive an assoc_id here instead of a node_name?
> Missing the check for IBMVFC_ASYNC_ID_IS_ASSOC_ID could result in mismatches
> during target lookup.

Fixed in v7.

> [ ... ]
>
>> @@ -3615,16 +3698,27 @@ VISIBLE_IF_KUNIT void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
>>  		if (aw) {
>>  			INIT_WORK(&aw->async_work_s, ibmvfc_process_async_work);
>>  			aw->vhost = vhost;
>> -			aw->crq = *crq;
>> +			aw->is_subq = is_sub_crq;
>> +			if (is_sub_crq)
>> +				aw->crq.subq = *subq;
>> +			else
>> +				aw->crq.async_crq = *async_crq;
>>  			queue_work(vhost->fpin_workq, &aw->async_work_s);
>>  		} else
>>  			dev_err_ratelimited(vhost->dev,
>>  					    "can't offload async CRQ to work queue\n");
>>  		break;
>>  	default:
>> -		dev_err(vhost->dev, "Unknown async event received: %lld\n", crq->event);
>> +		dev_err(vhost->dev, "Unknown async event received: %llu\n", event);
>>  		break;
>>  	}
>> +
>> +	rmb();
>> +	if (is_sub_crq)
>> +		subq->valid = 0;
>> +	else
>> +		async_crq->valid = 0;
>> +	wmb();
>>  }
>
> [Severity: High]
> Can clearing the valid byte here lead to silently dropped events?
>
> Since ibmvfc_handle_async() clears the valid byte to 0, it tells the hardware
> the slot can be reused.
>
> In the caller ibmvfc_tasklet():
>
> 	while ((async = ibmvfc_next_async_crq(vhost)) != NULL) {
> 		ibmvfc_handle_async(async, vhost, false);
> 		async->valid = 0;
> 		wmb();
> 	}
>
> If the hardware writes a new event into this slot between the first clear in
> ibmvfc_handle_async() and the redundant clear in ibmvfc_tasklet(), wouldn't
> the second clear overwrite the new event's valid byte and lose it?

In v7, the CRQ valid bit is now cleared by the caller of
ibmvfc_handle_async() in all cases.

> [ ... ]
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
>> index 64a517a74af8e..0b29c1e6478b5 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
>> @@ -58,7 +58,7 @@ static void ibmvfc_async_fpin_test(struct kunit *test)
>>  		crq[fs].scsi_id = cpu_to_be64(tgt->scsi_id);
>>  		crq[fs].wwpn = cpu_to_be64(tgt->wwpn);
>>  		crq[fs].node_name = cpu_to_be64(tgt->ids.node_name);
>> -		ibmvfc_handle_async(&crq[fs], vhost);
>> +		ibmvfc_handle_async(&crq[fs], vhost, false);
>>  		msleep(1U);
>>  	}
>
> [Severity: Medium]
> Will this lead to flaky tests on heavily loaded systems?
>
> Using msleep(1U) to wait for asynchronous workqueue execution might not give
> the workqueue enough time to run. Could we use flush_workqueue() instead?

In v7 all KUnit tests now use flush_workqueue().

> [ ... ]
>
>> @@ -93,7 +93,110 @@ static void ibmvfc_async_fpin_test(struct kunit *test)
>>  	crq[0].scsi_id = cpu_to_be64(tgt->scsi_id);
>>  	crq[0].wwpn = cpu_to_be64(tgt->wwpn);
>>  	crq[0].node_name = cpu_to_be64(tgt->ids.node_name);
>> -	ibmvfc_handle_async(&crq[0], vhost);
>> +	ibmvfc_handle_async(&crq[0], vhost, false);
>> +	msleep(1U);
>
> [Severity: Medium]
> Should we avoid using msleep(1U) here for synchronizing with the workqueue?
>
> If the workqueue doesn't run within 1 millisecond, the assertions that follow
> could fail.

See above.

> [ ... ]
>
>> +	/* bad path */
>> +	crq[0].valid = 0x80;
>> +	crq[0].link_state = IBMVFC_AE_LS_LINK_UP;
>> +	crq[0].fpin_status = 0; /* bad value */
>> +	crq[0].event = cpu_to_be16(IBMVFC_AE_FPIN);
>> +	crq[0].wwpn = cpu_to_be64(tgt->wwpn);
>> +	crq[0].id.node_name = cpu_to_be64(tgt->ids.node_name);
>> +	ibmvfc_handle_async(&crq[0], vhost, true);
>>  	msleep(1U);
>
> [Severity: Medium]
> Same concern here about using msleep(1U) to wait for the workqueue.

See above.

-Dave
