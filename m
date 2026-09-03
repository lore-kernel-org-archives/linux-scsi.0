Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38FB4E8E1A;
	Thu,  3 Sep 2026 16:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788452293; cv=none; b=cyqW9WY/Pc7D1ex5WwVldNjEdGASJisMp+JLXPBlqD1BqN72Iy0Ff0U6MjjdVRL0rMNn3iLBiHETXLSnubJM+ThmWlbN30hn0C5FkUDFpFwSCDHubQNUfbDO2JSy1iUS7gMIc42EF9FUeMji5wqC6rQIm92fu0fuGqRkSs9rHAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788452293; c=relaxed/simple;
	bh=h3qXCFIhQC9JbGri9WFlBluanZs9Ub6R7OqUIYT5QlU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=lqv+M+ObgfyMt4qpxzF2HpILE5O6S3ttQYwuonaGEkEqicapry3S/L/pOlZlRs3ds9AIdIWTyUdMqXDbj9miDTxjN8c73Fr+sK5kB2n7kDsej5SEc0xHheyoh2YApogsF/Sy8AXKDxYwXfbyzGHNC1bwB5t35PUKyvVe5x92nIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=J/Sr3gfj; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="J/Sr3gfj"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 683G2SCf3425639;
	Thu, 3 Sep 2026 16:18:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=DL3ExOYmoEOyM93BzzpBubYc30tVOk
	tD2Dh5LaIMkB0=; b=J/Sr3gfjuWvVpudoqB7rPRLx8gVn6LsjifSYI/+3QSLbhu
	zqJoqc2tYDEvCC+6nuwt6PQ3H8oPwbxgCaCVEMbHf24CTvyi7jrA4vbcbL4TX4hL
	Jamqp0n5+XWXjRA25xZznle6dY34oSG/UYlA+xSJRU11SCOHwqz2tR2JmcQyQ991
	wvG4QqHxpeYrsrAiHkXQMOkl1aNxUoPnDDG+B/Jg/azpotnBnohZF4zK4PjpWG9p
	nAOuOgFvklJA/rzj2JHjfeOFQx7u0EBQJiTN7Gvph8ekWXcknyVJmidzTZnHWdnA
	YbOUz8F4HJZ9hrBzLC01L3Tgob5GO3ZR7hlZkZLA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbq555wat-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Sep 2026 16:18:10 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 683GBhv5018186;
	Thu, 3 Sep 2026 16:18:09 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gcbygr967-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Sep 2026 16:18:09 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 683GI9hK55509352
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 3 Sep 2026 16:18:09 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ED4E958065;
	Thu,  3 Sep 2026 16:18:08 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BA8B758055;
	Thu,  3 Sep 2026 16:18:08 +0000 (GMT)
Received: from d (unknown [9.16.41.19])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  3 Sep 2026 16:18:08 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH v7 5/8] scsi: ibmvfc: add interrupt routine for
 asynchronous sub CRQ
In-Reply-To: <20260831221836.C605B1F000E9@smtp.kernel.org>
References: <20260831-ibmvfc-fpin-support-v7-0-77d0b9809080@linux.ibm.com>
	<20260831-ibmvfc-fpin-support-v7-5-77d0b9809080@linux.ibm.com>
	<20260831221836.C605B1F000E9@smtp.kernel.org>
Date: Thu, 03 Sep 2026 11:18:08 -0500
Message-ID: <87a4py5mwv.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDE0MCBTYWx0ZWRfX/Twn5or5PRNe
 To7FqHsXH9SmZ2qqlKahZjUMYCs4UK1T34vNh2HcvHOz914zTdLtRmGZRBNS3+ET87mWsadwG/+
 tMV/I/ZZ2ewgaBviY+Vj1yCGyRCiK03SZ4VQQ6rRT9ZWmL+za0Wzcbg7iKZHYOlU/7DDjhjAJaq
 VtIeLMEqozC6csfknG4+Tpud8N9ZOj3TtvyPXrhkxm5dYLpuv0RAidSdTVm3y0ha4TMloGgCLE7
 woWJxFGQkyQrJswDU1pTrQrSZ0PZeqHB6p7a81lfd2douVaV2bWD7yLka63AvfdrCozKfTQuV1o
 NOrlCAlWJtNlebVHuNzeYt6FZN0vocohOi7twknW9XUI4rtDNZCmUPdp5y2nX+uxUraat/3DxgC
 d32DKVCa20UNC55TC69Ovve7C6hBfuaIPVlzL8C/HGWlGMzeHYm/fHRkjPHL+Fv/AynwJA/Ij99
 S+wPVH2TO2YlvgbI+Fg==
X-Proofpoint-ORIG-GUID: DdA_9BFOVAXbscv2toN7s4bJWU6CWIeQ
X-Authority-Analysis: v=2.4 cv=CNgamxrD c=1 sm=1 tr=0 ts=6a999dc2 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=lYOFyddZlkxiCvi58e4A:9
X-Proofpoint-GUID: DdA_9BFOVAXbscv2toN7s4bJWU6CWIeQ
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDE0MCBTYWx0ZWRfX2wGmXzAWegT8
 Ap6eAcgORCo8/cY2hBdgYZNLKLLmcT+e5Zq/957GVZ+fEC0IgfYGekh0S9yDh+1zoixYfEoXmeA
 eV38kiB7iLwr0kPJdlpN5bESi4yumDw=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-03_05,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609030140

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] The `ibmvfc_drain_async_subq()` function calls
> `ibmvfc_handle_async()` without holding the primary SCSI host lock
> (`vhost->host->host_lock`). This leads to severe data races and list
> corruption because `ibmvfc_handle_async()` mutates shared state and
> iterates over lists that are concurrently modified by other threads
> holding the lock.
> --
>
> commit d6b23b1e849e5108314e933b9d7ab6b8580d0218
> Author: Dave Marquardt <davemarq@linux.ibm.com>
>
> scsi: ibmvfc: add interrupt routine for asynchronous sub CRQ
>
> Add ibmvfc_interrupt_async_subq(), an IRQ handler dedicated to
> asynchronous sub-CRQ events from the adapter. The handler disables
> the sub-CRQ IRQ and then calls ibmvfc_drain_async_subq() to consume
> all pending entries before re-enabling interrupts.
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index 229b06effd4cf..a28875c1f9830 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> @@ -4369,6 +4369,56 @@ static struct ibmvfc_crq *ibmvfc_next_scrq(struct ibmvfc_queue *scrq)
>>  	return crq;
>>  }
>>  
>> +static void ibmvfc_drain_async_subq(struct ibmvfc_queue *scrq)
>> +{
>> +	struct ibmvfc_crq *crq;
>> +	int done = 0;
>> +
>> +	spin_lock(scrq->q_lock);
>> +	while (!done) {
>> +		while ((crq = ibmvfc_next_scrq(scrq)) != NULL) {
>> +			struct ibmvfc_async_crq_event ae = {
>> +				.type = IBMVFC_ASYNC_CRQ_SUB,
>> +				.subq = *(struct ibmvfc_async_sub_crq *)crq,
>> +			};
>> +			ibmvfc_handle_async(&ae, scrq->vhost);
>
> [Severity: High]
> Does this code need to hold the host_lock before calling ibmvfc_handle_async()?
>
> Calling ibmvfc_handle_async() with only the local queue lock (scrq->q_lock)
> held can lead to unprotected list iterations:
>
> drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_handle_async() {
>     ...
> 		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
>     ...
> }
>
> It can also lead to unprotected read-modify-write operations on shared state:
>
> drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_handle_async() {
>     ...
> 			vhost->events_to_log |= IBMVFC_AE_LINKUP;
>     ...
> }
>
> If it races with normal target initialization, addition, or removal routines
> running on other CPUs holding the host_lock, could it result in list corruption
> or use-after-free?

I agree. Adding use of host lock in next revision.

>> +			crq->valid = 0;
>> +			wmb();	/* complete write */
>> +		}
>> +
>> +		ibmvfc_toggle_scrq_irq(scrq, 1);
>> +		crq = ibmvfc_next_scrq(scrq);
>> +		if (crq != NULL) {
>> +			struct ibmvfc_async_crq_event ae = {
>> +				.type = IBMVFC_ASYNC_CRQ_SUB,
>> +				.subq = *(struct ibmvfc_async_sub_crq *)crq,
>> +			};
>> +			ibmvfc_toggle_scrq_irq(scrq, 0);
>> +			ibmvfc_handle_async(&ae, scrq->vhost);
>
> [Severity: High]
> Does this call to ibmvfc_handle_async() also need the host_lock for the same
> reasons as above?
>
>> +			crq->valid = 0;
>> +			wmb();	/* complete write */
>> +		} else
>> +			done = 1;
>> +	}
>> +	spin_unlock(scrq->q_lock);
>> +}

Yes.

-Dave
