Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DC71C84A2;
	Thu, 25 Jun 2026 21:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782423140; cv=none; b=BhzRH9IOklMkIvai1ckGk5XNHFxLbiGj99wdYkX9cTDbbS0QU1yuUkyQqOPHswogE3uwre4ehmpxg2RAC9xLBo8pHvREOK0Wii/K1+ealM/8ny4WlPOPgX8LrS1KP6xGqaziD4dqDFM+tWPhN9sLnSo/MQOt3KW2pO7Gb/t9mZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782423140; c=relaxed/simple;
	bh=VYOT2t9ZLuqX7yN5yxxDBftk9GjY5tLYIGSQi5wZWGE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=hA7DS7Eh+OY7z2b7X7bMhwYHmHnYEA8YVfi4yAxmhabSYDP2KxztMKkjkqjYbB/tQeNeBfh/rBl1L8uziuGNqLGOKx6AZPNfImBq7D/L+AKK0yASa+TnAi3qv/IV5D4h7Xi+dUZVNBBrysf5eapz6KSZ0quLy9Q+p+QVxoYuvAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nuXwicU4; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nuXwicU4"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65PFmbET641966;
	Thu, 25 Jun 2026 21:31:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=y3OiORj2v8wrQURdwon43ud0Ub7I7k
	OreMaInM2eXUM=; b=nuXwicU4knm3XvidaxF5vrcm9Unx7xXNDYWLuIArCFU0Yp
	jG//nEA01VT5/1aJ9SPMLyapUMgKZYOVYoEPdW9KZYaG6bbWZXyyYXIXDWC1xSbS
	bbpwKdGYoow859+7T9QuejyuCvhsCRUfSX7ynlTnA2XZKaxlgJ9rvY+Yov7LF0po
	dUx2BPr76Y7XsnWm7G//Rv/vCBid0qK3Yibr0wHDGYfBYNlg7aGbRRzCVTOag6XU
	0x14KpIypvgnhrZirC4mWmI/81q1ldsg+c9KW2jHvuAzF654G6NRO/AfkhKmwHPf
	iyos81/TnxAbEwxRiKKTUIV/5JJ4ZZqkVl4ZqnwQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ewjhr3wvg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jun 2026 21:31:55 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65PLK2qv018632;
	Thu, 25 Jun 2026 21:31:55 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ex7vyyv4u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jun 2026 21:31:55 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65PLVrXB23134900
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Jun 2026 21:31:54 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C2AFF5805C;
	Thu, 25 Jun 2026 21:31:53 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F1DE25805F;
	Thu, 25 Jun 2026 21:31:52 +0000 (GMT)
Received: from d (unknown [9.61.3.205])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 25 Jun 2026 21:31:52 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        Madhavan Srinivasan
 <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas
 Piggin <npiggin@gmail.com>,
        "Christophe Leroy (CS GROUP)"
 <chleroy@kernel.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Brian King
 <brking@linux.ibm.com>,
        Greg Joyce <gjoyce@linux.ibm.com>,
        Kyle Mahlkuch
 <kmahlkuc@linux.ibm.com>
Subject: Re: [PATCH v2 6/7] ibmvfc: register and use asynchronous sub-queue
In-Reply-To: <03239655-0c9a-42af-b6a1-8141f44149f9@linux.ibm.com>
References: <20260608-ibmvfc-fpin-support-v2-0-d41f540fba5c@linux.ibm.com>
	<20260608-ibmvfc-fpin-support-v2-6-d41f540fba5c@linux.ibm.com>
	<03239655-0c9a-42af-b6a1-8141f44149f9@linux.ibm.com>
Date: Thu, 25 Jun 2026 16:31:52 -0500
Message-ID: <87fr2aparb.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=I4VVgtgg c=1 sm=1 tr=0 ts=6a3d9e4c cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=SH7YT8DN6fa1mytSqPEA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI1MDE4NCBTYWx0ZWRfXx43re6uLEfSH
 TSv3+dY3mIrvt7nc3TOkf+QI2va1r0Mj/NyZKdNMnia5zMGe4GL0SDqaPNaFtUEKNz831XMJLp8
 x9rll2+y4THN4MyhCygHXe4EAc6cyk7lxok/Vpang92B/jP9Zh7gtxXFeTF2AP863j05qRkxuHM
 aRKor3dTUKCXDbOYozBYTULhaybDh2M40WoRV6e6iH3V/Jez7rCq+zc5rhDnG0lQPZCIvQd6k/q
 Q6OvdWvuXLlTG7TbzoFq3sGzs+LSTcFcFFnE0ttV/24HKEkiFZyJ6fIRY/csiYH+LjHCHJe+F1X
 JnrFsm1iT91HGBpaMFB2TRNpJ2PzlAOvo8x3skDLu3baudLup2EYIQuDtnODYeWiCgDQXV8fbC7
 aLL+ahrt1Y8ePmvjwzSRvcZMYKN1OplZ9OJgEFJ0jZaDLAuOlB+icR1+GSTuRuHuVPlSwuzgW0X
 Uyj2Qofa3jIFp8eooDw==
X-Proofpoint-GUID: xXi5l3SNnkEoUSgIFiPeOepD73dZz1I0
X-Proofpoint-ORIG-GUID: 6X-YjsTIlR_xPDWahU5g91usVl0TvyyS
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI1MDE4NCBTYWx0ZWRfXwtR9wNj68p2l
 Dq4GPnNsfRo9CRLuv9UxhOQQfoU//E8uspcB5+RzAKMf5U8YYtlvQrwMulNV4fd9Ib82o/17WkL
 aakUrQCbm6vm7Zs2uh0TurGfcEUrLSs=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-25_02,2026-06-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606250184

Tyrel Datwyler <tyreld@linux.ibm.com> writes:

> On 6/8/26 11:30 AM, Dave Marquardt via B4 Relay wrote:
>> From: Dave Marquardt <davemarq@linux.ibm.com>
>> 
>> Refactor existing code for async events into a common routine,
>> register a channel and interrupt handler for the asynchronous
>> sub-queue, and set capability bits to request that VIOS use the
>> asynchronous sub-queue.
>
> Again, all your patches need Signed-off-by: tags to be accepted.
>
> Also, there is still a lot of different things happening in this patch
>
> You seem to be reworking the fpin_desc helpers which I'm not really seeing any
> reason that you couldn't squash those changes into patch 2. It seems like
> needless churn since, unless I'm missing something, there doesn't seem to be any
> new definitions added since patch 2 just reworking of the input parameters such
> that period goes away and is hardcoded and a new type paramerter is added.

Okay, I'll roll the ibmvfc_common_fpin_to_desc changes into patch 2.

> I would also help reduce the patch size and make it more reviewable if you split
> the the interrupt handler definition and queue registration into separate
> patches as well.
>
>> ---
>>  drivers/scsi/ibmvscsi/ibmvfc.c       | 376 +++++++++++++++++++++++++++--------
>>  drivers/scsi/ibmvscsi/ibmvfc.h       |   3 +
>>  drivers/scsi/ibmvscsi/ibmvfc_kunit.c |   2 +-
>>  3 files changed, 298 insertions(+), 83 deletions(-)
>> 
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
>> index ad1f5636e879..a2252cd2f44b 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
>> @@ -1514,7 +1514,8 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
>>  	login_info->max_cmds = cpu_to_be32(max_cmds);
>>  	login_info->capabilities =
>>  		cpu_to_be64(IBMVFC_CAN_MIGRATE | IBMVFC_CAN_SEND_VF_WWPN |
>> -			    IBMVFC_CAN_USE_NOOP_CMD);
>> +			    IBMVFC_CAN_USE_NOOP_CMD | IBMVFC_YES_SCSI |
>> +			    IBMVFC_USE_ASYNC_SUBQ | IBMVFC_CAN_HANDLE_FPIN);
>>  
>>  	if (vhost->mq_enabled || vhost->using_channels)
>>  		login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_CHANNELS);
>> @@ -3240,8 +3241,8 @@ static size_t ibmvfc_fpin_size_helper(u8 fpin_status)
>>   * non-NULL - pointer to populated struct fc_els_fpin
>>   */
>>  static struct fc_els_fpin *
>> -ibmvfc_common_fpin_to_desc(u8 fpin_status, __be64 wwpn, __be16 modifier,
>> -			   __be32 period, __be32 threshold, __be32 event_count)
>> +ibmvfc_common_fpin_to_desc(u8 fpin_status, __be64 wwpn, __be16 type, __be16 modifier,
>> +			   __be32 threshold, __be32 event_count)
>>  {
>
> This function signature changes here, and looking at the implemenation below I'm
> struggling to see why this couldn't just be all implmented immediatly in Patch #2.
>
>>  	struct fc_fn_peer_congn_desc *pdesc;
>>  	struct fc_fn_congn_desc *cdesc;
>> @@ -3253,7 +3254,7 @@ ibmvfc_common_fpin_to_desc(u8 fpin_status, __be64 wwpn, __be16 modifier,
>>  	if (size == 0)
>>  		return NULL;
>>  
>> -	fpin = kzalloc(size, GFP_KERNEL);
>> +	fpin = kzalloc(size, GFP_ATOMIC);
>
> Why are we changing this to GFP_ATOMIC? Isn't this only ever called from work
> queue context?

I've restored this for my next version of the patch series.

>>  	if (fpin == NULL)
>>  		return NULL;
>>  
>> @@ -3266,12 +3267,9 @@ ibmvfc_common_fpin_to_desc(u8 fpin_status, __be64 wwpn, __be16 modifier,
>>  		cdesc = (struct fc_fn_congn_desc *)fpin->fpin_desc;
>>  		cdesc->desc_tag = cpu_to_be32(ELS_DTAG_CONGESTION);
>>  		cdesc->desc_len = cpu_to_be32(FC_TLV_DESC_LENGTH_FROM_SZ(*cdesc));
>> -		if (fpin_status == IBMVFC_AE_FPIN_CONGESTION_CLEARED)
>> -			cdesc->event_type = cpu_to_be16(FPIN_CONGN_CLEAR);
>> -		else
>> -			cdesc->event_type = cpu_to_be16(FPIN_CONGN_DEVICE_SPEC);
>> +		cdesc->event_type = type;
>>  		cdesc->event_modifier = modifier;
>> -		cdesc->event_period = period;
>> +		cdesc->event_period = cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_PERIOD);
>>  		cdesc->severity = FPIN_CONGN_SEVERITY_WARNING;
>>  		break;
>>  	case IBMVFC_AE_FPIN_PORT_CONGESTED:
>> @@ -3281,12 +3279,9 @@ ibmvfc_common_fpin_to_desc(u8 fpin_status, __be64 wwpn, __be16 modifier,
>>  		pdesc = (struct fc_fn_peer_congn_desc *)fpin->fpin_desc;
>>  		pdesc->desc_tag = cpu_to_be32(ELS_DTAG_PEER_CONGEST);
>>  		pdesc->desc_len = cpu_to_be32(FC_TLV_DESC_LENGTH_FROM_SZ(*pdesc));
>> -		if (fpin_status == IBMVFC_AE_FPIN_PORT_CLEARED)
>> -			pdesc->event_type = cpu_to_be16(FPIN_CONGN_CLEAR);
>> -		else
>> -			pdesc->event_type = cpu_to_be16(FPIN_CONGN_DEVICE_SPEC);
>> +		pdesc->event_type = type;
>>  		pdesc->event_modifier = modifier;
>> -		pdesc->event_period = period;
>> +		pdesc->event_period = cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_PERIOD);
>>  		pdesc->detecting_wwpn = cpu_to_be64(0);
>>  		pdesc->attached_wwpn = wwpn;
>>  		pdesc->pname_count = cpu_to_be32(1);
>> @@ -3297,7 +3292,7 @@ ibmvfc_common_fpin_to_desc(u8 fpin_status, __be64 wwpn, __be16 modifier,
>>  		ldesc = (struct fc_fn_li_desc *)fpin->fpin_desc;
>>  		ldesc->desc_tag = cpu_to_be32(ELS_DTAG_LNK_INTEGRITY);
>>  		ldesc->desc_len = cpu_to_be32(FC_TLV_DESC_LENGTH_FROM_SZ(*ldesc));
>> -		ldesc->event_type = cpu_to_be16(FPIN_LI_UNKNOWN);
>> +		ldesc->event_type = type;
>>  		ldesc->event_modifier = modifier;
>>  		ldesc->event_threshold = threshold;
>>  		ldesc->event_count = event_count;
>> @@ -3331,9 +3326,47 @@ ibmvfc_common_fpin_to_desc(u8 fpin_status, __be64 wwpn, __be16 modifier,
>>  static struct fc_els_fpin *
>>  ibmvfc_basic_fpin_to_desc(struct ibmvfc_async_crq *crq, u64 wwpn)
>>  {
>> +	__be16 type;
>> +
>> +	switch (crq->fpin_status) {
>> +	case IBMVFC_AE_FPIN_LINK_CONGESTED:
>> +	case IBMVFC_AE_FPIN_PORT_CONGESTED:
>> +		type = cpu_to_be16(FPIN_CONGN_DEVICE_SPEC);
>> +		break;
>> +	case IBMVFC_AE_FPIN_PORT_CLEARED:
>> +	case IBMVFC_AE_FPIN_CONGESTION_CLEARED:
>> +		type = cpu_to_be16(FPIN_CONGN_CLEAR);
>> +		break;
>> +	case IBMVFC_AE_FPIN_PORT_DEGRADED:
>> +		type = cpu_to_be16(FPIN_LI_UNKNOWN);
>> +		break;
>> +	default:
>> +		return (NULL);
>> +	}
>> +
>>  	return ibmvfc_common_fpin_to_desc(crq->fpin_status, cpu_to_be64(wwpn),
>> -					  cpu_to_be16(0),
>> -					  cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_PERIOD),
>> +					  type, cpu_to_be16(0),
>> +					  cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_THRESHOLD),
>> +					  cpu_to_be32(1));
>> +}
>> +
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
>> +ibmvfc_full_fpin_to_desc(struct ibmvfc_async_subq *ibmvfc_fpin)
>> +{
>> +	return ibmvfc_common_fpin_to_desc(ibmvfc_fpin->fpin_status, ibmvfc_fpin->wwpn,
>> +					  cpu_to_be16(0), cpu_to_be16(0),
>>  					  cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_THRESHOLD),
>>  					  cpu_to_be32(1));
>>  }
>> @@ -3344,67 +3377,99 @@ ibmvfc_basic_fpin_to_desc(struct ibmvfc_async_crq *crq, u64 wwpn)
>>   */
>>  static void ibmvfc_process_async_work(struct work_struct *work)
>>  {
>> +	struct ibmvfc_async_subq_fpin *sqfpin;
>> +	struct ibmvfc_target *tgt, *next;
>> +	struct ibmvfc_async_subq *subq;
>>  	struct ibmvfc_async_work *aw;
>>  	struct ibmvfc_async_crq *crq;
>> -	struct ibmvfc_target *tgt;
>>  	struct ibmvfc_host *vhost;
>>  	struct fc_els_fpin *fpin;
>> +	__be64 node_name;
>> +	__be64 scsi_id;
>> +	__be64 wwpn;
>>  
>>  	aw = container_of(work, struct ibmvfc_async_work, async_work_s);
>>  	crq = aw->crq;
>> +	subq = aw->subq;
>>  	vhost = aw->vhost;
>>  
>> -	if (!crq->scsi_id && !crq->wwpn && !crq->node_name)
>> +	if ((!crq && !subq) || (crq && subq)) {
>> +		dev_err_ratelimited(vhost->dev,
>> +				    "FPIN event received, unable to process\n");
>>  		goto end;
>> -	list_for_each_entry(tgt, &vhost->targets, queue) {
>> -		if (crq->scsi_id && cpu_to_be64(tgt->scsi_id) != crq->scsi_id)
>> +	}
>> +
>> +	if (crq) {
>> +		wwpn = crq->wwpn;
>> +		node_name = crq->node_name;
>> +		scsi_id = crq->scsi_id;
>> +	} else {
>> +		wwpn = subq->wwpn;
>> +		node_name = subq->id.node_name;
>> +		scsi_id = 0;
>> +	}
>> +
>> +	if (!scsi_id && !wwpn && !node_name)
>> +		goto end;
>> +
>> +	list_for_each_entry_safe(tgt, next, &vhost->targets, queue) {
>> +		if (scsi_id && cpu_to_be64(tgt->scsi_id) != scsi_id)
>>  			continue;
>> -		if (crq->wwpn && cpu_to_be64(tgt->ids.port_name) != crq->wwpn)
>> +		if (wwpn && cpu_to_be64(tgt->ids.port_name) != wwpn)
>>  			continue;
>> -		if (crq->node_name && cpu_to_be64(tgt->ids.node_name) != crq->node_name)
>> +		if (node_name && cpu_to_be64(tgt->ids.node_name) != node_name)
>>  			continue;
>>  		if (!tgt->rport)
>>  			continue;
>> -		fpin = ibmvfc_basic_fpin_to_desc(crq, tgt->wwpn);
>> +		if (crq) {
>> +			fpin = ibmvfc_basic_fpin_to_desc(crq, tgt->wwpn);
>> +		} else {
>> +			sqfpin = (struct ibmvfc_async_subq_fpin *)subq;
>> +			fpin = ibmvfc_full_fpin_to_desc(subq);
>> +		}
>>  		if (fpin) {
>>  			fc_host_fpin_rcv(tgt->vhost->host,
>>  					 sizeof(*fpin) + be32_to_cpu(fpin->desc_len),
>>  					 (char *)fpin, 0);
>>  			kfree(fpin);
>>  		} else
>> -			dev_err_ratelimited(vhost->dev,
>> -					    "FPIN event %u received, unable to process\n",
>> -					    crq->fpin_status);
>> +			dev_err_ratelimited(vhost->dev, "FPIN event received, unable to process\n");
>>  	}
>>  
>>   end:
>> -	crq->valid = 0;
>> +	if (crq)
>> +		crq->valid = 0;
>> +	if (subq)
>> +		subq->valid = 0;
>>  
>>  	kfree(aw);
>>  }
>>  
>>  /**
>> - * ibmvfc_handle_async - Handle an async event from the adapter
>> - * @crq:	crq to process
>> + * ibmvfc_handle_async_common - Handle an async event from the adapter
>> + * @event:	event to process
>> + * @link_state:	link state
>>   * @vhost:	ibmvfc host struct
>> + * @scsi_id:	scsi_id (0 if not applicable)
>> + * @wwpn:	wwpn
>> + * @node_name:	node_name
>> + * @aw_crq:	crq pointer for async work (NULL if not needed)
>> + * @aw_subq:	subq pointer for async work (NULL if not needed)
>>   *
>>   **/
>> -VISIBLE_IF_KUNIT void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
>> -					  struct ibmvfc_host *vhost)
>> +static void ibmvfc_handle_async_common(u64 event, u8 link_state,
>> +				       struct ibmvfc_host *vhost,
>> +				       u64 scsi_id, u64 wwpn, u64 node_name,
>> +				       struct ibmvfc_async_crq *aw_crq,
>> +				       struct ibmvfc_async_subq *aw_subq)
>
> This is a lot of parameters which could be extracted here in the function if it
> just knew the type of async_crq. Would it be easier to no just take a void
> *async_instance parameter, and an is_subq boolean to determine if you cast the
> void * to ibmvfc_async_crq * or ibmvfc_async_sub_crq *?

Yes, good idea. I've changed this to

VISIBLE_IF_KUNIT void ibmvfc_handle_async(void *crq,
					  struct ibmvfc_host *vhost,
					  bool is_subq)

and will extract all of these parameters from crq.

>> +/**
>> + * ibmvfc_handle_async - Handle an async event from the adapter
>> + * @crq:	crq to process
>> + * @vhost:	ibmvfc host struct
>> + *
>> + **/
>> +VISIBLE_IF_KUNIT void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
>> +					  struct ibmvfc_host *vhost)
>
> async and asyncq as in the function name below can be hard to notice the
> difference in name convention. Maybe async_subq would be a better ender, but as
> it might be eaiser to just call ibmvfc_handle_async_common(crq, 0) and
> ibmfvc_handle_async(sub_crq, 1), as I outlined above in each of the interrupt
> handlers.

I agree. I've refactored to a singled ibmvfc_handle_async() with a
boolean parameter indicating whether the CRQ is a subqueue CRQ or not.

>> +{
>> +	const struct ibmvfc_async_desc *desc = ibmvfc_get_ae_desc(be64_to_cpu(crq->event));
>> +	u64 event = be64_to_cpu(crq->event);
>> +
>> +	ibmvfc_log(vhost, desc->log_level,
>> +		   "%s event received. scsi_id: %llx, wwpn: %llx, node_name: %llx%s\n",
>> +		   desc->desc, be64_to_cpu(crq->scsi_id),
>> +		   be64_to_cpu(crq->wwpn), be64_to_cpu(crq->node_name),
>> +		   ibmvfc_get_link_state(crq->link_state));
>> +
>> +	ibmvfc_handle_async_common(event, crq->link_state, vhost,
>> +				   crq->scsi_id, crq->wwpn, crq->node_name,
>> +				   crq, NULL);
>>  }
>>  EXPORT_SYMBOL_IF_KUNIT(ibmvfc_handle_async);
>>  
>> +VISIBLE_IF_KUNIT void ibmvfc_handle_asyncq(struct ibmvfc_crq *crq_instance,
>> +					   struct ibmvfc_host *vhost)
>> +{
>> +	struct ibmvfc_async_subq *crq = (struct ibmvfc_async_subq *)crq_instance;
>> +	const struct ibmvfc_async_desc *desc = ibmvfc_get_ae_desc(be16_to_cpu(crq->event));
>> +	u64 event = be16_to_cpu(crq->event);
>> +
>> +	ibmvfc_log(vhost, desc->log_level,
>> +		   "%s event received. wwpn: %llx, node_name: %llx%s event 0x%x\n",
>> +		   desc->desc, be64_to_cpu(crq->wwpn), be64_to_cpu(crq->id.node_name),
>> +		   ibmvfc_get_link_state(crq->link_state), be16_to_cpu(crq->event));
>> +
>> +	ibmvfc_handle_async_common(event, crq->link_state, vhost,
>> +				   0, crq->wwpn, crq->id.node_name,
>> +				   NULL, crq);
>> +}
>> +EXPORT_SYMBOL_IF_KUNIT(ibmvfc_handle_asyncq);
>> +
>>  /**
>>   * ibmvfc_handle_crq - Handles and frees received events in the CRQ
>>   * @crq:	Command/Response queue
>> @@ -4117,6 +4229,13 @@ static void ibmvfc_handle_scrq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost
>>  	spin_unlock(&evt->queue->l_lock);
>>  }
>>  
>> +/**
>> + * ibmvfc_next_scrq - Returns the next entry in message subqueue
>> + * @scrq:	Pointer to message subqueue
>> + *
>> + * Returns:
>> + *	Pointer to next entry in queue / NULL if empty
>> + **/
>>  static struct ibmvfc_crq *ibmvfc_next_scrq(struct ibmvfc_queue *scrq)
>>  {
>>  	struct ibmvfc_crq *crq;
>> @@ -4132,6 +4251,57 @@ static struct ibmvfc_crq *ibmvfc_next_scrq(struct ibmvfc_queue *scrq)
>>  	return crq;
>>  }
>>  
>> +static void ibmvfc_drain_async_subq(struct ibmvfc_queue *scrq)
>> +{
>> +	struct ibmvfc_crq *crq;
>> +	unsigned long flags;
>> +	int done = 0;
>> +
>> +	ENTER;
>> +
>> +	spin_lock_irqsave(scrq->q_lock, flags);
>> +	while (!done) {
>> +		while ((crq = ibmvfc_next_scrq(scrq)) != NULL) {
>> +			ibmvfc_handle_asyncq(crq, scrq->vhost);
>> +			crq->valid = 0;
>
> Isn't up to the handle_async_common to clear the valid crq bit depending on the
> type of async action?

I've moved clearing the valid bit to ibmvfc_handle_async().

>> +			wmb();	/* complete write */
>> +		}
>> +
>> +		ibmvfc_toggle_scrq_irq(scrq, 1);
>> +		crq = ibmvfc_next_scrq(scrq);
>> +		if (crq != NULL) {
>> +			ibmvfc_toggle_scrq_irq(scrq, 0);
>> +			ibmvfc_handle_asyncq(crq, scrq->vhost);
>> +			crq->valid = 0;
>
> Same comment as above.
>
>> +			wmb();	/* complete write */
>> +		} else
>> +			done = 1;
>> +	}
>> +	spin_unlock_irqrestore(scrq->q_lock, flags);
>> +
>> +	LEAVE;
>> +}
>> +
>> +/**
>> + * ibmvfc_interrupt_asyncq - Handle an async event from the adapter
>> + * @irq:           interrupt request
>> + * @scrq_instance: async subq
>> + *
>> + **/
>> +static irqreturn_t ibmvfc_interrupt_asyncq(int irq, void *scrq_instance)
>> +{
>> +	struct ibmvfc_queue *scrq = (struct ibmvfc_queue *)scrq_instance;
>> +
>> +	ENTER;
>> +
>> +	ibmvfc_toggle_scrq_irq(scrq, 0);
>> +	ibmvfc_drain_async_subq(scrq);
>> +
>> +	LEAVE;
>> +
>> +	return IRQ_HANDLED;
>> +}
>> +
>>  static void ibmvfc_drain_sub_crq(struct ibmvfc_queue *scrq)
>>  {
>>  	struct ibmvfc_crq *crq;
>> @@ -5500,6 +5670,8 @@ static void ibmvfc_npiv_login_done(struct ibmvfc_event *evt)
>>  	unsigned int npiv_max_sectors;
>>  	int level = IBMVFC_DEFAULT_LOG_LEVEL;
>>  
>> +	ENTER;
>> +
>>  	switch (mad_status) {
>>  	case IBMVFC_MAD_SUCCESS:
>>  		ibmvfc_free_event(evt);
>> @@ -5578,6 +5750,8 @@ static void ibmvfc_npiv_login_done(struct ibmvfc_event *evt)
>>  		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
>>  		wake_up(&vhost->work_wait_q);
>>  	}
>> +
>> +	LEAVE;
>
> Also, please drop the ENTER/LEAVE macros as these look like debug artifacts.
> Especially, in common code paths like the interrupt handlers.

Done.

-Dave
