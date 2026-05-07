Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A45B351C3D;
	Thu,  7 May 2026 22:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778192545; cv=none; b=m+UoylJQMNmOXBDzvl9dEAw+SaEuqpxeDlVvkY29G9oCEGmfgOPnR+g7mLDfqsAf3Q25TDqtLyOCGxB6hcYdPWeLu8xE7av1uXB47xniV3QmDAn+cnwqsx9t9DZWUxjbjl4nvpRE9lVEs0vJ5fbRqTeaLBkqJMFlsp1xdodD9ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778192545; c=relaxed/simple;
	bh=Uh5ekknx+OFXkGCwJZ9HTAln1iyKraBafXwgz+AB2qY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ojufCWhneLMvw/QPbtvOMs0ooI/AyUg5gqJb5LfWOfpZtYi04bz9GIKo5TLH4dfXG1VnwhT7RBOyy31ur/CYdPh82JfXI0X2Pf9AAFTJUSN3meQk6Msmhp2Lv39kd4+l6cZ3bcVzDRVrdgLyh7niT9lbKAKCMaHn2sLhYfrySmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=EDtZPzVx; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EDtZPzVx"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 647DBWqs3027467;
	Thu, 7 May 2026 22:22:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=nQcn6Hlng/z4pg1m0StoK2STY+yqG7
	7bxIGWsb/eZ38=; b=EDtZPzVxPguflW9e2c0BTKHafO9YlPAFcyCIxu2TLkU8YL
	trutBKEcLOwsMZ/H9iAZOqK168Bi9HCXtfpfAu/gQ6pxEqlc9OItFbv/8v4+ayML
	L68xICTGGD4fT5sVpXNfbHRIPIyPxfuSx9X9Y9QW8xXHJedOLZcfokc6YSr+4Txe
	u5UmzwttkFY5PBL/GcKhui2yTTUvTF27xT1MQNG0dEGF4El6UpztC+oxTU2G+CBi
	4TsknFQO5sUHdiY+Uxw592teVIM8545P9+TLxUea0nXqwCBxaQkf4dI4b31DYEud
	kg0LiuUUrw7wUHInIP/FL8kLwzmthm0qUksmW+Ug==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9v7s5fy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 May 2026 22:22:09 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 647MA1Fs020311;
	Thu, 7 May 2026 22:22:08 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dwwtgnk7e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 May 2026 22:22:08 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 647MM69421365448
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 7 May 2026 22:22:07 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D2C1558052;
	Thu,  7 May 2026 22:22:06 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8658E5805D;
	Thu,  7 May 2026 22:22:06 +0000 (GMT)
Received: from d (unknown [9.61.133.117])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  7 May 2026 22:22:06 +0000 (GMT)
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
Subject: Re: [PATCH 1/5] ibmvfc: add basic FPIN support
In-Reply-To: <291e79ea-d993-45e4-877e-4c25336c3076@linux.ibm.com> (Tyrel
	Datwyler's message of "Wed, 6 May 2026 21:12:48 -0700")
References: <20260408-ibmvfc-fpin-support-v1-0-52b06c464e03@linux.ibm.com>
	<20260408-ibmvfc-fpin-support-v1-1-52b06c464e03@linux.ibm.com>
	<291e79ea-d993-45e4-877e-4c25336c3076@linux.ibm.com>
Date: Thu, 07 May 2026 17:22:06 -0500
Message-ID: <87qznmeu7l.fsf@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA3MDIyNCBTYWx0ZWRfX+7mYhgxUjOIV
 S6WKGKKfyJ23eYIESwPRWQ3zEToTja10gyurNijQpYr4QQg+7Q2nqHYjrdw0SwWYPI1ImcZMLlk
 HoJ+gOogr/uv22XYl3LzSwEaii63QVAngbW9MK3CFnFwQKgMPobQgaM9i3qGiMjyPS3/HQqdh3o
 BmbKNGwprod4P+DXKS1ey3XwGsBYAyEkSoWDhj9jEe+iew+AdWvAb3KppB/Nu/b06567YqwyDGN
 b2mfF5Rwz7/vOfsSskRfXVPntVc2OdsfH3B/O3SjImxc+y+6exO6Hsain2eMm0wXzmHrWQwv1U3
 hRdL0y8RVbdklE8i2HVsviQ0mGrVF4bM8f9cXKuYnyZvM9Ck5J0KdmSFOpcyvUggxtHU4Y5udO9
 /9tI6yXKO8D9c7BgEzC/mgiU/au/BWQKKi7ScRdHRCh2nD2blOi0U02kAg0Lp2KdYRjWBUuwQpi
 /61dHJZuRiXqSuN2yZg==
X-Proofpoint-GUID: M8JU62HESjLJubQJGlw14DZUn02Wr_PK
X-Proofpoint-ORIG-GUID: S3tVDxT70JtvpZRjSGPBfSCjSB5j_PgH
X-Authority-Analysis: v=2.4 cv=eu/vCIpX c=1 sm=1 tr=0 ts=69fd1092 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=Vb3baSn078BpY_Ri2uMA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-07_02,2026-05-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605070224

Tyrel Datwyler <tyreld@linux.ibm.com> writes:

> On 4/8/26 10:07 AM, Dave Marquardt via B4 Relay wrote:
>> From: Dave Marquardt <davemarq@linux.ibm.com>
>> 
>> - Add FPIN event descriptor
>> - Add congestion cleared status
>> - Add code to handle basic FPIN async event
>> - Add KUnit tests
>
> You need a more detailed description of your changes here for the commit log body.
>
> You will also need a signed off tag from yourself for this to even be merged.

Odd. I used b4 to prepare the patch set, and it should have added a
Signed-off-by: tag. I'll double check it next round.

> https://www.kernel.org/doc/html/latest/process/submitting-patches.html
>
>> ---
>>  drivers/scsi/Kconfig                 |  10 ++
>>  drivers/scsi/ibmvscsi/Makefile       |   1 +
>>  drivers/scsi/ibmvscsi/ibmvfc.c       | 189 ++++++++++++++++++++++++++++++++++-
>>  drivers/scsi/ibmvscsi/ibmvfc.h       |   9 ++
>>  drivers/scsi/ibmvscsi/ibmvfc_kunit.c |  95 ++++++++++++++++++
>>  5 files changed, 302 insertions(+), 2 deletions(-)
>
> <snip>
>
>> +static struct fc_els_fpin *
>> +ibmvfc_common_fpin_to_desc(u8 fpin_status, __be64 wwpn, __be16 modifier,
>> +			   __be32 period, __be32 threshold, __be32 event_count)
>> +{
>> +	struct fc_fn_peer_congn_desc *pdesc;
>> +	struct fc_fn_congn_desc *cdesc;
>> +	struct fc_fn_li_desc *ldesc;
>> +	struct fc_els_fpin *fpin;
>> +	size_t size;
>> +
>> +	size = ibmvfc_fpin_size_helper(fpin_status);
>> +	if (size == 0)
>> +		return NULL;
>> +
>> +	fpin = kzalloc(size, GFP_KERNEL);
>
> This appears to be called by ibmvfc_handle_async() with runs in atomic context
> and cannot therefore sleep. This allocation needs to be GFP_ATOMIC. Although
> there is another issue below that might make this moot.

Noted. As to the problem below, once this is moved to running in a work
queue worker thread, this can stay as is.

>> +	if (fpin == NULL)
>> +		return NULL;
>> +
>> +	fpin->fpin_cmd = ELS_FPIN;
>> +
>> +	switch (fpin_status) {
>> +	case IBMVFC_AE_FPIN_CONGESTION_CLEARED:
>> +	case IBMVFC_AE_FPIN_LINK_CONGESTED:
>> +		fpin->desc_len = cpu_to_be32(sizeof(struct fc_fn_congn_desc));
>> +		cdesc = (struct fc_fn_congn_desc *)fpin->fpin_desc;
>> +		cdesc->desc_tag = cpu_to_be32(ELS_DTAG_CONGESTION);
>> +		cdesc->desc_len = cpu_to_be32(FC_TLV_DESC_LENGTH_FROM_SZ(*cdesc));
>> +		if (fpin_status == IBMVFC_AE_FPIN_CONGESTION_CLEARED)
>> +			cdesc->event_type = cpu_to_be16(FPIN_CONGN_CLEAR);
>> +		else
>> +			cdesc->event_type = cpu_to_be16(FPIN_CONGN_DEVICE_SPEC);
>> +		cdesc->event_modifier = modifier;
>> +		cdesc->event_period = period;
>> +		cdesc->severity = FPIN_CONGN_SEVERITY_WARNING;
>> +		break;
>> +	case IBMVFC_AE_FPIN_PORT_CONGESTED:
>> +	case IBMVFC_AE_FPIN_PORT_CLEARED:
>> +		fpin->desc_len = cpu_to_be32(sizeof(struct fc_fn_peer_congn_desc));
>> +		pdesc = (struct fc_fn_peer_congn_desc *)fpin->fpin_desc;
>> +		pdesc->desc_tag = cpu_to_be32(ELS_DTAG_PEER_CONGEST);
>> +		pdesc->desc_len = cpu_to_be32(FC_TLV_DESC_LENGTH_FROM_SZ(*pdesc));
>> +		if (fpin_status == IBMVFC_AE_FPIN_PORT_CLEARED)
>> +			pdesc->event_type = cpu_to_be16(FPIN_CONGN_CLEAR);
>> +		else
>> +			pdesc->event_type = cpu_to_be16(FPIN_CONGN_DEVICE_SPEC);
>> +		pdesc->event_modifier = modifier;
>> +		pdesc->event_period = period;
>> +		pdesc->detecting_wwpn = cpu_to_be64(0);
>> +		pdesc->attached_wwpn = wwpn;
>> +		pdesc->pname_count = cpu_to_be32(1);
>> +		pdesc->pname_list[0] = wwpn;
>> +		break;
>> +	case IBMVFC_AE_FPIN_PORT_DEGRADED:
>> +		fpin->desc_len = cpu_to_be32(sizeof(struct fc_fn_li_desc));
>> +		ldesc = (struct fc_fn_li_desc *)fpin->fpin_desc;
>> +		ldesc->desc_tag = cpu_to_be32(ELS_DTAG_LNK_INTEGRITY);
>> +		ldesc->desc_len = cpu_to_be32(FC_TLV_DESC_LENGTH_FROM_SZ(*ldesc));
>> +		ldesc->event_type = cpu_to_be16(FPIN_LI_UNKNOWN);
>> +		ldesc->event_modifier = modifier;
>> +		ldesc->event_threshold = threshold;
>> +		ldesc->event_count = event_count;
>> +		ldesc->detecting_wwpn = cpu_to_be64(0);
>> +		ldesc->attached_wwpn = wwpn;
>> +		ldesc->pname_count = cpu_to_be32(1);
>> +		ldesc->pname_list[0] = wwpn;
>> +		break;
>> +	default:
>> +		/* This should be caught above. */
>> +		kfree(fpin);
>> +		fpin = NULL;
>> +		break;
>> +	}
>> +
>> +	return fpin;
>> +}
>> +
>> +/**
>> + * ibmvfc_basic_fpin_to_desc(): allocate and populate a struct fc_els_fpin struct
>> + * containing a descriptor.
>> + * @ibmvfc_fpin: Pointer to async crq
>> + *
>> + * Allocate a struct fc_els_fpin containing a descriptor and populate
>> + * based on data from *ibmvfc_fpin.
>> + *
>> + * Return:
>> + * NULL     - unable to allocate structure
>> + * non-NULL - pointer to populated struct fc_els_fpin
>> + */
>> +static struct fc_els_fpin *
>> +/*XXX*/ibmvfc_basic_fpin_to_desc(struct ibmvfc_async_crq *crq)
>
> What is with this /*XXX*/? I can't find it once I apply the patchset so I assume
> its removed in a later patch, but it should be removed here.

An artifact I missed in squashing commits. Thanks for pointing it out.

>> +{
>> +	return ibmvfc_common_fpin_to_desc(crq->fpin_status, crq->wwpn,
>> +					  cpu_to_be16(0),
>> +					  cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_PERIOD),
>> +					  cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_THRESHOLD),
>> +					  cpu_to_be32(1));
>> +}
>> +
>>  /**
>>   * ibmvfc_handle_async - Handle an async event from the adapter
>>   * @crq:	crq to process
>>   * @vhost:	ibmvfc host struct
>>   *
>>   **/
>> -static void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
>> -				struct ibmvfc_host *vhost)
>> +VISIBLE_IF_KUNIT void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
>> +					  struct ibmvfc_host *vhost)
>>  {
>>  	const struct ibmvfc_async_desc *desc = ibmvfc_get_ae_desc(be64_to_cpu(crq->event));
>>  	struct ibmvfc_target *tgt;
>> +	struct fc_els_fpin *fpin;
>>  
>>  	ibmvfc_log(vhost, desc->log_level, "%s event received. scsi_id: %llx, wwpn: %llx,"
>>  		   " node_name: %llx%s\n", desc->desc, be64_to_cpu(crq->scsi_id),
>> @@ -3269,11 +3422,37 @@ static void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
>>  	case IBMVFC_AE_HALT:
>>  		ibmvfc_link_down(vhost, IBMVFC_HALTED);
>>  		break;
>> +	case IBMVFC_AE_FPIN:
>> +		if (!crq->scsi_id && !crq->wwpn && !crq->node_name)
>> +			break;
>> +		list_for_each_entry(tgt, &vhost->targets, queue) {
>> +			if (crq->scsi_id && cpu_to_be64(tgt->scsi_id) != crq->scsi_id)
>> +				continue;
>> +			if (crq->wwpn && cpu_to_be64(tgt->ids.port_name) != crq->wwpn)
>> +				continue;
>> +			if (crq->node_name && cpu_to_be64(tgt->ids.node_name) != crq->node_name)
>> +				continue;
>> +			if (!tgt->rport)
>> +				continue;
>> +			fpin = ibmvfc_basic_fpin_to_desc(crq);
>> +			if (fpin) {
>> +				fc_host_fpin_rcv(tgt->vhost->host,
>> +						 sizeof(*fpin) +
>> +						       be32_to_cpu(fpin->desc_len),
>> +						 (char *)fpin, 0);
>
> This call to fc_host_fpin_rcv() appears to be problematic as it assumes no locks
> are held, but ibmvfc_handle_async() is called with the scsi host lock held. We
> already do a lot more work than we probaly should in our interrupt handler. I
> think we maybe need to pass the FPIN work off to a workqueue instead to be
> handled in process context instead.

Agreed. I'm working on adding a work queue for offloading this FPIN
processing.

-Dave
