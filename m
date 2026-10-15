Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D823E2AB0;
	Thu, 15 Oct 2026 21:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792100837; cv=none; b=GVkqVd71rG6aydKZC/HU7ZFAfMnLou5vv7CgJG4bg7KzUTYTzJhviFOvC6ollOzajUBwyHlsMp273osljfc9Pvi8NfIBd30/J6bMAClunrZAqZMNzDKT3nXYb9MQYh9OprQYquKKR2w+q96zbZIcf0mn3+Mm7EuNFIZPpNIbIeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792100837; c=relaxed/simple;
	bh=P29+bjs79eC7BpoPjQ3+Px+lGsPYirb9IdhOIGwDoc4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Dnrn6Zrv6N8BK3CVTzoJS13KuYxeM9M8ZCBjiVIa+LUzRi+I4LgT/4LiGseNCXlkBfgq71t81Bqesxj+M0b8Gq5Efg2KrNjknWLWS4yhJ8g0Zi6TNBC/2v7nUt2REd9yv45f3iTMk2EEfTZuDXoQ7FvEsq7Cbi6dLq97b8uVbPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=epkmS+sk; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="epkmS+sk"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FJVteH668033;
	Thu, 15 Oct 2026 21:47:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=BH19KyJqtSSCvigcQRoHapTgOvCYSB
	z+5OPWhCYEZJc=; b=epkmS+skueIcYs3DfsjXStOku8ndpi6H28tGfqHMdxWLz/
	O7PMjcCbapv3FOD1VASuWfLR0H9wtdGjkqvVoxUI75BKhkvdQ1ylfNitft/4Okl1
	I72DM2XRZiObvtsXU38ZBYBiQWNhefluJro1wp46uez1AlKb1wr0rXse6ukg7Cds
	FpznC6NEjX2kMCcmIYbRhC1EhJbnAdg0KiUsgQmq4GVwXGQduGgWGMrg/5H2Ejtg
	mjL4agUkIzyZcexPaixRmkFhrBHkTsmFI+nwgTXw6qe4pgmjoSrYVLMqBbvesUAM
	ffZBdhiI5PXi2+6E/09KiVErQgdjZgT48YrryHkQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h7dugvamt-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 15 Oct 2026 21:47:13 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69FJ6mX12057773;
	Thu, 15 Oct 2026 21:47:12 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hawqwt6w5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Oct 2026 21:47:12 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69FLlCsK29229664
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Oct 2026 21:47:12 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E7F0A5805E;
	Thu, 15 Oct 2026 21:47:11 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CF4415805A;
	Thu, 15 Oct 2026 21:47:11 +0000 (GMT)
Received: from d (unknown [9.16.59.154])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 15 Oct 2026 21:47:11 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-bot@kernel.org
Cc: sashiko-reviews@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v14 04/11] scsi: ibmvfc: add basic FPIN support
In-Reply-To: <sashiko-outbox-173047@kernel.org> (sashiko-bot@kernel.org's
	message of "Thu, 15 Oct 2026 15:18:34 +0000")
References: <20261015-ibmvfc-fpin-support-v14-0-a0b063b8d825@linux.ibm.com>
	<20261015-ibmvfc-fpin-support-v14-4-a0b063b8d825@linux.ibm.com>
	<sashiko-outbox-173047@kernel.org>
Date: Thu, 15 Oct 2026 16:47:11 -0500
Message-ID: <878q3yd4bk.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Cr0q4X4D c=1 sm=1 tr=0 ts=6ad149e1 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=RCS4FwQSR9ayVb6XPsUA:9
X-Proofpoint-GUID: CMgX1n8pNVb5oYxOGOIpwVZQ8FujT2Nx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA4NiBTYWx0ZWRfX+fazdbFvP7Lk
 cU+wUSoW8mIoA9GCs+r8rFqn+g46RdBnXFd1QQQMeUO/r0Yr5ZENo0zIGn1D0RF3KIRmvbVNkbo
 pRZ7SgrYI0AEXd2/2OAXUpPS5H+TWv73sJ5+vM5cpwSHXkK50pGQQdwcT8N6a3hIkQCf6pjo5CE
 S9oDczHBm3n+cOp8pyO4ZsOy/p/HU2SZIWcDlphzJ7s24mnzswLJ/wz/EsEy+rsv0efl7DVLVCU
 e7QMyt7g3ydzqf1ZjfWp3kclTXiZWMseFIX62D+VoKwBkr9dT0LuZv6Z6qlMTPRv+CSsCZN89rL
 NMQm+bGL4q22H1heNTtEPOrlh2Mn+bk21x6kelKOJnvMUWYoYIW1QqrdrC29uMw2Da9Ft1l2o1+
 HtK9dz/M+72cW8jsKHFxNeloeieYjNjrhah4st7F21LFdYzKjZG2LYp8GW76WFvPiOZZt7UCgqk
 0sY3rXJ/vZLf4UsmuuA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA4NiBTYWx0ZWRfX+J5K052wd3CB
 zXjmviYqTYB3qzz9GZLcz1hOqp2ML96r5Oac+mH7yW2PY8ISgm3lykWdNWnHbTU5tvvBH8GCUsE
 HXgDNO0mHukX7XsqV+euzL5MLcmqAqU=
X-Proofpoint-ORIG-GUID: CMgX1n8pNVb5oYxOGOIpwVZQ8FujT2Nx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610150086

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] scsi: ibmvfc: missing flush of dynamically allocated system_wq items causes UAF
> --
>
> commit 170496a5dbc89bab0a780529ef0e294023ca569c
> Author: Dave Marquardt <davemarq@linux.ibm.com>
>
> scsi: ibmvfc: add basic FPIN support
>
> Implement support for a basic level of Fabric Performance Impact
> Notifications (FPIN) in the ibmvfc driver to enable monitoring of
> fabric congestion and link integrity events.
>
> Add async event handler for IBMVFC_AE_FPIN events that offloads FPIN
> processing via schedule_work(). Convert VIOS FPIN messages to standard
> fc_els_fpin structures and pass them to fc_host_fpin_rcv() for processing
> by the FC transport layer.
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index 0fe6b6f4260ba..871decab29856 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> [ ... ]
>> @@ -3261,6 +3266,255 @@ static const char *ibmvfc_get_link_state(enum ibmvfc_ae_link_state state)
>>  	return "";
>>  }
>>  
> [ ... ]
>> +VISIBLE_IF_KUNIT void ibmvfc_process_async_work(struct work_struct *work)
>> +{
>> +	struct ibmvfc_async_work *aw;
>> +	struct ibmvfc_async_crq *crq;
>> +	struct ibmvfc_target *tgt;
>> +	struct ibmvfc_host *vhost;
>> +	struct fc_els_fpin *fpin;
>> +	unsigned long flags;
>> +
>> +	aw = container_of_const(work, struct ibmvfc_async_work, async_work_s);
>> +	vhost = aw->vhost;
>> +	crq = &aw->crq;
> [ ... ]
>> +	fpin = ibmvfc_basic_fpin_to_desc(crq, tgt->wwpn);
>> +	if (fpin) {
>> +		fc_host_fpin_rcv(tgt->vhost->host,
>> +				 sizeof(*fpin) + be32_to_cpu(fpin->desc_len),
>> +				 (char *)fpin, 0);
>> +		kfree(fpin);
>> +	} else
>> +		dev_err_ratelimited(vhost->dev, "FPIN event received, unable to process\n");
>> +
>> +	kref_put(&tgt->kref, ibmvfc_release_tgt);
>
> [Severity: High]
> Can this untracked async worker drop its reference and trigger the release
> function on a destroyed mempool?
>
> If ibmvfc_remove() has already completed and destroyed vhost->tgt_pool,
> this final kref_put() triggers ibmvfc_release_tgt():
>
> drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_release_tgt() {
> 	...
> 	mempool_free(tgt, tgt->vhost->tgt_pool);
> }
>
> This accesses the destroyed target mempool, causing a Use-After-Free.

Agreed.

>> + free:
>> +	scsi_host_put(aw->vhost->host);
>> +	kfree(aw);
>> +}
>> +EXPORT_SYMBOL_IF_KUNIT(ibmvfc_process_async_work);
>> +
>>  /**
>>   * ibmvfc_handle_async - Handle an async event from the adapter
>>   * @crq:	crq to process
> [ ... ]
>> @@ -3361,12 +3616,28 @@ static void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
>>  	case IBMVFC_AE_HALT:
>>  		ibmvfc_link_down(vhost, IBMVFC_HALTED);
>>  		break;
>> +	case IBMVFC_AE_FPIN:
>> +		if (vhost->state == IBMVFC_HOST_OFFLINE)
>> +			break;
>> +		aw = kzalloc_obj(*aw, GFP_ATOMIC);
>> +		if (aw) {
>> +			if (!scsi_host_get(vhost->host)) {
>> +				kfree(aw);
>> +				break;
>> +			}
>> +			INIT_WORK(&aw->async_work_s, ibmvfc_process_async_work);
>> +			aw->vhost = vhost;
>> +			aw->crq = *crq;
>> +			schedule_work(&aw->async_work_s);
>
> [Severity: High]
> Does this code risk a Use-After-Free during teardown?
>
> Since aw is queued to the global system_wq without being tracked,
> there doesn't seem to be a way to flush it in ibmvfc_remove().
>
> If ibmvfc_remove() runs concurrently with this pending work item, it calls
> ibmvfc_free_mem() which unconditionally destroys the target mempool:
>
> drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_free_mem() {
> 	...
> 	mempool_destroy(vhost->tgt_pool);
> 	...
> }
>
> This could lead to a crash when ibmvfc_process_async_work() completes and
> drops its reference.
>
> Additionally, because it is untracked on the global workqueue, it can execute
> after the module is unloaded, leading to a fatal instruction page fault.

Either ibmvfc needs to track its work items on the system work queues
and flush them all, or use its own work queue and ensure the work is all
done before calling ibmvfc_free_mem().

-Dave
