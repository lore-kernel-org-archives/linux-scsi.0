Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1F53B442F;
	Fri, 21 Aug 2026 15:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787326152; cv=none; b=tbsbcKxjYa92tDccidGrZRt0NiK6XEjumJ6hi0IgyVcy35SAEz40doDwjrvM46TAMFQgICZlKeM0SXBSchAsvxfUB0ANM+QWL+k7196H4TcK0EuS0n2wAlHZUmwEqejf6GEn8qeeZ/0tQbaVT+vUtAHvVq2N6+A49mDARsOuA30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787326152; c=relaxed/simple;
	bh=hYuRIb/S/SwuxT0uYJghCpu64+ihTKciA5NuoJ1hgQM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=j0W4I7QmYczPPIrEsGlpNtEA9FqYJ31l1miueV1RG5dq2krnnWPTAviN7X769sW5VpwqKrwHoyT0cR2Xz5QY22uUKGAFQdpX3KGIItu6DXcqy9zZOtD7W1Z4jDBC5rwyorHHvzXPSTv4deBBJSWXY26qWjRbF7BLKuWUQXHI/p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=L0571EeK; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="L0571EeK"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67LD1ZtW1530581;
	Fri, 21 Aug 2026 15:29:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=fQfS1cQk2iMcz83MWMEriniPgGoFWu
	+0TYTXyRjFxxM=; b=L0571EeKxLRel0EbNKO3Jztsa9dXHgsn+LtbsA78n+SBRc
	+iXvdfFYY0OktVJcqfLAFgF5JLze4i2+r2VyiobAcIXPzoYOt0yzb9s/pA08Opb9
	0kwwA5AegzyUClz/hLksNk/whyGfbx+oiAnZqBmkaloTOvOf1ZOPTj+Pab/mcBkj
	zj4FBgd+suLxOCyCxbiDdx44xSgCeMLF5KIcnuqelzVHX9J3btbTeVdQYazLEoFA
	O/bNoyUg8cMJNAt0w0QuNjUqqVieyhXJn1tMgATUBeBuilxlvik1xxxgARnQTtmy
	t92XjzdTQFZMDCUEELf6qwdhuZ1tm7BrEfXQaViA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g4yu1tb1s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Aug 2026 15:29:06 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67LFQe4c011443;
	Fri, 21 Aug 2026 15:29:05 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g32twnfsv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Aug 2026 15:29:05 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67LFT4vk29622944
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Aug 2026 15:29:04 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 694D15803F;
	Fri, 21 Aug 2026 15:29:04 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4FB7C58056;
	Fri, 21 Aug 2026 15:29:04 +0000 (GMT)
Received: from d (unknown [9.61.29.95])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 21 Aug 2026 15:29:04 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH v6 5/8] scsi: ibmvfc: add interrupt routine for
 asynchronous sub CRQ
In-Reply-To: <20260817205107.D89501F000E9@smtp.kernel.org>
References: <20260817-ibmvfc-fpin-support-v6-0-62a2d525e70d@linux.ibm.com>
	<20260817-ibmvfc-fpin-support-v6-5-62a2d525e70d@linux.ibm.com>
	<20260817205107.D89501F000E9@smtp.kernel.org>
Date: Fri, 21 Aug 2026 10:29:03 -0500
Message-ID: <87se47wkzk.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=LsCiDHdc c=1 sm=1 tr=0 ts=6a886ec2 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=unQBfwMNYyptg2-DW7QA:9
X-Proofpoint-GUID: c_Tblzr0-rFoKv4q_rrBJKKf50bjTlFe
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIxMDExNyBTYWx0ZWRfX3zaAVgmCsPOd
 8m9vjFnl/SXfD4sZcuJlWLF+ANXB6Ghm+LBpI7vdBOdbLoenJFN13FBPB4l81aL47hD0gPY7b/k
 501vC+KS9+HPbmoDMch1TDkUwCzn3IA=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIxMDExNyBTYWx0ZWRfX+TIeNgNa18+j
 E4v23e1VuX8+Ih99sndL7rGcoNIOJt348mW0KsZkzlsLzoKeiDWha2bOzEoresoxVZHJXr+8W7V
 EM3TCy8gId/Tm6su4XUYUh9WXcTOwAw8NNsK2PzCqmls1naUWO+jknmDCxErbKY4VLUM5+7eUHY
 ftENnec0LDUVzLXLpNH0lzAU0IPsNpXK9pvntIAdeG8OZ5aZ/sBAY0V2xdL2PN9Y0Uv4NxIkU8K
 APGU3cV88nI2owfj7XtCsvNomen4FOMJvkASuOKxcrxOFGDwsq337Jf8OafGYWzcWcraUlPWIoX
 hrNdH28ZrDTEbwmOgnT/zXi07wHX/7WPYaX/sZBrcpG3dlBiBnKTR2p46OmDdcvea5Zi9ZT5Ijx
 vXRnNCT6JUuXxYUt2iMkr9GMX8dcMXpgNNzVZHHcYhG7obxmSj7QJc4dm2mL/2vsJQlRIjeV4n+
 55C+48hpzXVbGgIt2ag==
X-Proofpoint-ORIG-GUID: c_Tblzr0-rFoKv4q_rrBJKKf50bjTlFe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-21_04,2026-08-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 adultscore=0 suspectscore=0 impostorscore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608210117

sashiko-bot@kernel.org writes:

> New issues:
> - [High] Double clearing of the CRQ valid byte creates a race condition causing silently dropped hardware events.
> - [High] The fpin_workq is destroyed before unregistering the CRQ/Sub-CRQ IRQ handlers, leading to a NULL pointer dereference.
> - [Medium] Nested acquisition of queue locks sharing the same lockdep class triggers a recursive locking warning.
> - [Low] The newly added interrupt handler `ibmvfc_interrupt_async_subq` is never registered.
> - [Low] ibmvfc_handle_async() attempts to dereference a void pointer, breaking compilation.
>
> Pre-existing issues:
> - [High] Uninitialized variable 'shwqs' causes out-of-bounds access and kernel panic in ibmvfc_purge_requests.
> --
>
> --- Patch [5]: [PATCH v6 5/8] scsi: ibmvfc: add interrupt routine for asynchronous sub CRQ ---
> commit 0805a2f1bf2f7cec43403295f1715fe78c1224dd
> Author: Dave Marquardt <davemarq@linux.ibm.com>
>
> scsi: ibmvfc: add interrupt routine for asynchronous sub CRQ
>
> This commit adds an interrupt handler for asynchronous sub-CRQ events,
> which drains pending entries and re-enables interrupts.
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index 4d1630d2ab1b5..3b5732f2fb6ec 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> [ ... ]
>> @@ -4372,6 +4372,52 @@ static struct ibmvfc_crq *ibmvfc_next_scrq(struct ibmvfc_queue *scrq)
>>  	return crq;
>>  }
>>  
>> +static void ibmvfc_drain_async_subq(struct ibmvfc_queue *scrq)
>> +{
>> +	struct ibmvfc_host *vhost = scrq->vhost;
>> +	struct ibmvfc_crq *crq;
>> +	unsigned long flags;
>> +	int done = 0;
>> +
>> +	spin_lock_irqsave(vhost->host->host_lock, flags);
>> +	spin_lock(scrq->q_lock);
>
> [Severity: Medium]
> Does acquiring this lock trigger a recursive locking warning?
>
> Both async_sub_crq.q_lock and scsi_q[i].q_lock appear to be initialized
> from the same spin_lock_init(&queue->_lock) in ibmvfc_alloc_queue(),
> meaning they share the same lockdep class.
>
> If an event handled here triggers a host reset, the call chain could be:
> ibmvfc_drain_async_subq() -> ibmvfc_handle_async() ->
> ibmvfc_hard_reset_host() -> ibmvfc_purge_requests()
>
> ibmvfc_purge_requests() then acquires scsi_q[i].q_lock for all active
> channels, potentially causing lockdep to flag a false-positive recursive
> locking splat.

I don't see an actual problem here, other than a false-positive.

>> +	while (!done) {
>> +		while ((crq = ibmvfc_next_scrq(scrq)) != NULL) {
>> +			ibmvfc_handle_async(crq, scrq->vhost, true);
>
> [Severity: Low]
> Does changing ibmvfc_handle_async() to accept a void *crq cause
> a compilation error?

No, it does not cause a compilation error.

> It looks like the NVMe target iteration loop in ibmvfc_handle_async()
> still attempts to dereference the pointer directly:
>
> if (!crq->scsi_id && !crq->wwpn && !crq->node_name)
>
> Dereferencing a void pointer will break the build.
>
> [Severity: High]
> This is a pre-existing issue, but does ibmvfc_purge_requests() use an
> uninitialized variable when called from this path?
>
> If a host reset occurs, the chain ibmvfc_handle_async() ->
> ibmvfc_hard_reset_host() -> ibmvfc_purge_requests() is triggered.
>
> In ibmvfc_purge_requests(), shwqs is declared but not initialized:
> int shwqs, nhwqs = 0;
>
> If vhost->using_channels is false, shwqs remains uninitialized.
> The loop then uses it as a bound:
> for (i = 0; i < shwqs; i++) {

I can't find any definitions of or references to shwqs in the existing
code.

> Could this cause an out-of-bounds access on the scsi_q array?
>
>> +			crq->valid = 0;
>> +			wmb();	/* complete write */
>
> [Severity: High]
> Does clearing the valid byte here create a race condition?

The CRQ Valid bit is now cleared by callers of ibmvfc_handle_async() in v7.

> When processing an event, ibmvfc_handle_async() already hands ownership
> back to the adapter by clearing the valid byte and issuing a write
> memory barrier.
>
> If the adapter writes a new event into this CRQ slot exactly between
> the clear in ibmvfc_handle_async() and the clear here, will the newly
> arrived event be permanently overwritten and lost?
>
>> +		}
>> +
>> +		ibmvfc_toggle_scrq_irq(scrq, 1);
>> +		crq = ibmvfc_next_scrq(scrq);
>> +		if (crq != NULL) {
>> +			ibmvfc_toggle_scrq_irq(scrq, 0);
>> +			ibmvfc_handle_async(crq, scrq->vhost, true);
>> +			crq->valid = 0;
>> +			wmb();	/* complete write */
>> +		} else
>> +			done = 1;
>> +	}
>> +	spin_unlock(scrq->q_lock);
>> +	spin_unlock_irqrestore(vhost->host->host_lock, flags);
>> +}
>> +
>> +/**
>> + * ibmvfc_interrupt_async_subq - Handle an async event from the adapter
>> + * @irq:           interrupt request
>> + * @scrq_instance: async subq
>> + *
>> + **/
>> +static irqreturn_t ibmvfc_interrupt_async_subq(int irq, void *scrq_instance)
>
> [Severity: Low]
> Is this interrupt handler ever registered?

Not yet. In v7 I added the __maybe_unused attribute for this new
function, and remove it in the the next patch where its actually used.

> [Severity: High]
> Can an async event arriving during driver teardown cause a NULL pointer
> dereference?
>
> During ibmvfc_remove(), vhost->fpin_workq is destroyed and set to NULL
> before device interrupts are disabled via ibmvfc_release_crq_queue().
>
> If an async FPIN event arrives from the adapter in this window, this
> interrupt handler will run and eventually call ibmvfc_handle_async(),
> which executes:
> queue_work(vhost->fpin_workq, &aw->async_work_s);
>
> Could this trigger a panic by queuing work to a NULL workqueue?

Already fixed in previous patches in v7.

-Dave
