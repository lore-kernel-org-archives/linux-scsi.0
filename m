Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6ED3AA4FA;
	Mon, 15 Jun 2026 20:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781557121; cv=none; b=nXO4l1NTHUU+bsVJ/0d26At89cHpl9902xPzVWbMatGm7uMY1NiqpPDrB22KJOADo21OBwaband3pMuOtkgN3BzyNPYbW1l4JVXerKoqb5LUiyMJyCavMSSI5AHBlABbxBUoIjgvwX0yTO5QGb0WMdhzARGptN8kmvaxNg1xt3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781557121; c=relaxed/simple;
	bh=Hh6e6oBFEudvpllTh1AUsSSlmGnUylBFPSr/TW7EeoU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g17vHoBnkSaO75aww3lRW+/bj3oaRfUdl+IXypKM7xq66jLFf0ukBBpWcCR81zJdgwgUV01h7EsqUEGaXULrf8zfj585vmzJhKFevy3YPUbANhxsS+gtxS2NWukTc7zeT9BB2gvHmYdMkqK5yDbpizF7Auasv5PXMHW7dZF0SeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GIkD3IQT; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GIkD3IQT"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65FJIVGY3358520;
	Mon, 15 Jun 2026 20:58:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=oGFUpn
	mE2WZ22uDvxh/lhc7tJMQJO/NWm+XB+QUYQ1o=; b=GIkD3IQTbtJw5fymXLqhoT
	mxepm5dhUw1wOkROWNvb6W2si7lvq/YYtvbMqCJ48WAO6ooFrun0NaEgFYCLsKME
	m71bThlejJXVD3kVdz/l+/J8LzXdltts9froShnvTu9D97E1dZIsCVqz/ETx+A/C
	Ye5cSw77GKbxyTFyCvNDOxowisMJs84mKcyfaO/z3eVIPqoag8VG4R7/tpkim/kd
	eha5s0jPJqv/2Hp7EL7plbJ1HklUJ3bVlF5W8NyixMPsUZIPxxZY8OooBoRzRb0S
	U+yfv5G0JYweTQAp2HS+S8+j7sAimcu2ItqsFWSChNh//Plhsuac8JNjiXOTDpUA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4es1eg251e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jun 2026 20:58:21 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65FKnf31018008;
	Mon, 15 Jun 2026 20:58:21 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4eshww0fa5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jun 2026 20:58:20 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65FKwJdf54788446
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Jun 2026 20:58:19 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9C73058043;
	Mon, 15 Jun 2026 20:58:19 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A748858055;
	Mon, 15 Jun 2026 20:58:18 +0000 (GMT)
Received: from [9.61.95.246] (unknown [9.61.95.246])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 15 Jun 2026 20:58:18 +0000 (GMT)
Message-ID: <03239655-0c9a-42af-b6a1-8141f44149f9@linux.ibm.com>
Date: Mon, 15 Jun 2026 13:58:18 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/7] ibmvfc: register and use asynchronous sub-queue
To: davemarq@linux.ibm.com,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Brian King <brking@linux.ibm.com>,
        Greg Joyce <gjoyce@linux.ibm.com>,
        Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
References: <20260608-ibmvfc-fpin-support-v2-0-d41f540fba5c@linux.ibm.com>
 <20260608-ibmvfc-fpin-support-v2-6-d41f540fba5c@linux.ibm.com>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <20260608-ibmvfc-fpin-support-v2-6-d41f540fba5c@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDIyMCBTYWx0ZWRfX+oUwlemkxjL0
 vu1Jhg6e2DkIxHTS0nJFvQ6dyGBqoQAg5EKFDnEOhIQ3unEEBdeRU8+Sd5IJt7dYDectE9AbplZ
 s2kRrCgM/Z5pmmS5BUknkr/McvyL+lw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDIyMCBTYWx0ZWRfX3j78mtdYka/O
 DK3UOc5PXQ4CUAAkF9ZI6ztpPc/4bOpO++L01aKew26o89lM22YX46fwzTE99qarnq8ig9PljBk
 EA3UOM28fhtmnsGX13xbPAtj/uUHAlZiMt1etDLooMN0/aOKDDFAuNovzl51UBTNrzPEzAsBXmM
 ZaNgVqxvihAZR6+LVUAKigyrxUfTVPnwbcYZUxr5TAHkIwQzEt1BODKVKS3lopffsjbt7ZBZ3BP
 pVgVteFOSZ1ZtdaVUSqAydAn0eaPOqTD83cW/BSRkMAcoqK/Q+fL7KMHQhN+k6dFmShvy9k3gt8
 RkZTNrJ6KdY3AtFPB3G/GhlmJ58lGRHuAAw+ODW4O3DqsAaoCogJfLRcBbhKJlglA8OrhMtdeM9
 HksVfj+JnXkPXIAFAWS/GljtaVps4HcZdNNLS3EBVCWd0wvZ63aaQ9+CtwlRwuvbcj67xqjtAuF
 IH7ib0WGTiXPrcjs1Yg==
X-Proofpoint-GUID: MDHGMrgm325-zyqlkZGq9gNO7LSpywbL
X-Authority-Analysis: v=2.4 cv=NuDhtcdJ c=1 sm=1 tr=0 ts=6a30676e cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=m3nlXbFJLPSYDraHrWwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: d0rrd6DEhgqc6IhYRgv4GxoGjfu28lPV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_05,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 suspectscore=0 impostorscore=0 clxscore=1015
 phishscore=0 bulkscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606150220

On 6/8/26 11:30 AM, Dave Marquardt via B4 Relay wrote:
> From: Dave Marquardt <davemarq@linux.ibm.com>
> 
> Refactor existing code for async events into a common routine,
> register a channel and interrupt handler for the asynchronous
> sub-queue, and set capability bits to request that VIOS use the
> asynchronous sub-queue.

Again, all your patches need Signed-off-by: tags to be accepted.

Also, there is still a lot of different things happening in this patch

You seem to be reworking the fpin_desc helpers which I'm not really seeing any
reason that you couldn't squash those changes into patch 2. It seems like
needless churn since, unless I'm missing something, there doesn't seem to be any
new definitions added since patch 2 just reworking of the input parameters such
that period goes away and is hardcoded and a new type paramerter is added.

I would also help reduce the patch size and make it more reviewable if you split
the the interrupt handler definition and queue registration into separate
patches as well.

> ---
>  drivers/scsi/ibmvscsi/ibmvfc.c       | 376 +++++++++++++++++++++++++++--------
>  drivers/scsi/ibmvscsi/ibmvfc.h       |   3 +
>  drivers/scsi/ibmvscsi/ibmvfc_kunit.c |   2 +-
>  3 files changed, 298 insertions(+), 83 deletions(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index ad1f5636e879..a2252cd2f44b 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -1514,7 +1514,8 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
>  	login_info->max_cmds = cpu_to_be32(max_cmds);
>  	login_info->capabilities =
>  		cpu_to_be64(IBMVFC_CAN_MIGRATE | IBMVFC_CAN_SEND_VF_WWPN |
> -			    IBMVFC_CAN_USE_NOOP_CMD);
> +			    IBMVFC_CAN_USE_NOOP_CMD | IBMVFC_YES_SCSI |
> +			    IBMVFC_USE_ASYNC_SUBQ | IBMVFC_CAN_HANDLE_FPIN);
>  
>  	if (vhost->mq_enabled || vhost->using_channels)
>  		login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_CHANNELS);
> @@ -3240,8 +3241,8 @@ static size_t ibmvfc_fpin_size_helper(u8 fpin_status)
>   * non-NULL - pointer to populated struct fc_els_fpin
>   */
>  static struct fc_els_fpin *
> -ibmvfc_common_fpin_to_desc(u8 fpin_status, __be64 wwpn, __be16 modifier,
> -			   __be32 period, __be32 threshold, __be32 event_count)
> +ibmvfc_common_fpin_to_desc(u8 fpin_status, __be64 wwpn, __be16 type, __be16 modifier,
> +			   __be32 threshold, __be32 event_count)
>  {

This function signature changes here, and looking at the implemenation below I'm
struggling to see why this couldn't just be all implmented immediatly in Patch #2.

>  	struct fc_fn_peer_congn_desc *pdesc;
>  	struct fc_fn_congn_desc *cdesc;
> @@ -3253,7 +3254,7 @@ ibmvfc_common_fpin_to_desc(u8 fpin_status, __be64 wwpn, __be16 modifier,
>  	if (size == 0)
>  		return NULL;
>  
> -	fpin = kzalloc(size, GFP_KERNEL);
> +	fpin = kzalloc(size, GFP_ATOMIC);

Why are we changing this to GFP_ATOMIC? Isn't this only ever called from work
queue context?

>  	if (fpin == NULL)
>  		return NULL;
>  
> @@ -3266,12 +3267,9 @@ ibmvfc_common_fpin_to_desc(u8 fpin_status, __be64 wwpn, __be16 modifier,
>  		cdesc = (struct fc_fn_congn_desc *)fpin->fpin_desc;
>  		cdesc->desc_tag = cpu_to_be32(ELS_DTAG_CONGESTION);
>  		cdesc->desc_len = cpu_to_be32(FC_TLV_DESC_LENGTH_FROM_SZ(*cdesc));
> -		if (fpin_status == IBMVFC_AE_FPIN_CONGESTION_CLEARED)
> -			cdesc->event_type = cpu_to_be16(FPIN_CONGN_CLEAR);
> -		else
> -			cdesc->event_type = cpu_to_be16(FPIN_CONGN_DEVICE_SPEC);
> +		cdesc->event_type = type;
>  		cdesc->event_modifier = modifier;
> -		cdesc->event_period = period;
> +		cdesc->event_period = cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_PERIOD);
>  		cdesc->severity = FPIN_CONGN_SEVERITY_WARNING;
>  		break;
>  	case IBMVFC_AE_FPIN_PORT_CONGESTED:
> @@ -3281,12 +3279,9 @@ ibmvfc_common_fpin_to_desc(u8 fpin_status, __be64 wwpn, __be16 modifier,
>  		pdesc = (struct fc_fn_peer_congn_desc *)fpin->fpin_desc;
>  		pdesc->desc_tag = cpu_to_be32(ELS_DTAG_PEER_CONGEST);
>  		pdesc->desc_len = cpu_to_be32(FC_TLV_DESC_LENGTH_FROM_SZ(*pdesc));
> -		if (fpin_status == IBMVFC_AE_FPIN_PORT_CLEARED)
> -			pdesc->event_type = cpu_to_be16(FPIN_CONGN_CLEAR);
> -		else
> -			pdesc->event_type = cpu_to_be16(FPIN_CONGN_DEVICE_SPEC);
> +		pdesc->event_type = type;
>  		pdesc->event_modifier = modifier;
> -		pdesc->event_period = period;
> +		pdesc->event_period = cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_PERIOD);
>  		pdesc->detecting_wwpn = cpu_to_be64(0);
>  		pdesc->attached_wwpn = wwpn;
>  		pdesc->pname_count = cpu_to_be32(1);
> @@ -3297,7 +3292,7 @@ ibmvfc_common_fpin_to_desc(u8 fpin_status, __be64 wwpn, __be16 modifier,
>  		ldesc = (struct fc_fn_li_desc *)fpin->fpin_desc;
>  		ldesc->desc_tag = cpu_to_be32(ELS_DTAG_LNK_INTEGRITY);
>  		ldesc->desc_len = cpu_to_be32(FC_TLV_DESC_LENGTH_FROM_SZ(*ldesc));
> -		ldesc->event_type = cpu_to_be16(FPIN_LI_UNKNOWN);
> +		ldesc->event_type = type;
>  		ldesc->event_modifier = modifier;
>  		ldesc->event_threshold = threshold;
>  		ldesc->event_count = event_count;
> @@ -3331,9 +3326,47 @@ ibmvfc_common_fpin_to_desc(u8 fpin_status, __be64 wwpn, __be16 modifier,
>  static struct fc_els_fpin *
>  ibmvfc_basic_fpin_to_desc(struct ibmvfc_async_crq *crq, u64 wwpn)
>  {
> +	__be16 type;
> +
> +	switch (crq->fpin_status) {
> +	case IBMVFC_AE_FPIN_LINK_CONGESTED:
> +	case IBMVFC_AE_FPIN_PORT_CONGESTED:
> +		type = cpu_to_be16(FPIN_CONGN_DEVICE_SPEC);
> +		break;
> +	case IBMVFC_AE_FPIN_PORT_CLEARED:
> +	case IBMVFC_AE_FPIN_CONGESTION_CLEARED:
> +		type = cpu_to_be16(FPIN_CONGN_CLEAR);
> +		break;
> +	case IBMVFC_AE_FPIN_PORT_DEGRADED:
> +		type = cpu_to_be16(FPIN_LI_UNKNOWN);
> +		break;
> +	default:
> +		return (NULL);
> +	}
> +
>  	return ibmvfc_common_fpin_to_desc(crq->fpin_status, cpu_to_be64(wwpn),
> -					  cpu_to_be16(0),
> -					  cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_PERIOD),
> +					  type, cpu_to_be16(0),
> +					  cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_THRESHOLD),
> +					  cpu_to_be32(1));
> +}
> +
> +/**
> + * ibmvfc_full_fpin_to_desc(): allocate and populate a struct fc_els_fpin struct
> + * containing a descriptor.
> + * @ibmvfc_fpin: Pointer to async subq FPIN data
> + *
> + * Allocate a struct fc_els_fpin containing a descriptor and populate
> + * based on data from *ibmvfc_fpin.
> + *
> + * Return:
> + * NULL     - unable to allocate structure
> + * non-NULL - pointer to populated struct fc_els_fpin
> + */
> +static struct fc_els_fpin *
> +ibmvfc_full_fpin_to_desc(struct ibmvfc_async_subq *ibmvfc_fpin)
> +{
> +	return ibmvfc_common_fpin_to_desc(ibmvfc_fpin->fpin_status, ibmvfc_fpin->wwpn,
> +					  cpu_to_be16(0), cpu_to_be16(0),
>  					  cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_THRESHOLD),
>  					  cpu_to_be32(1));
>  }
> @@ -3344,67 +3377,99 @@ ibmvfc_basic_fpin_to_desc(struct ibmvfc_async_crq *crq, u64 wwpn)
>   */
>  static void ibmvfc_process_async_work(struct work_struct *work)
>  {
> +	struct ibmvfc_async_subq_fpin *sqfpin;
> +	struct ibmvfc_target *tgt, *next;
> +	struct ibmvfc_async_subq *subq;
>  	struct ibmvfc_async_work *aw;
>  	struct ibmvfc_async_crq *crq;
> -	struct ibmvfc_target *tgt;
>  	struct ibmvfc_host *vhost;
>  	struct fc_els_fpin *fpin;
> +	__be64 node_name;
> +	__be64 scsi_id;
> +	__be64 wwpn;
>  
>  	aw = container_of(work, struct ibmvfc_async_work, async_work_s);
>  	crq = aw->crq;
> +	subq = aw->subq;
>  	vhost = aw->vhost;
>  
> -	if (!crq->scsi_id && !crq->wwpn && !crq->node_name)
> +	if ((!crq && !subq) || (crq && subq)) {
> +		dev_err_ratelimited(vhost->dev,
> +				    "FPIN event received, unable to process\n");
>  		goto end;
> -	list_for_each_entry(tgt, &vhost->targets, queue) {
> -		if (crq->scsi_id && cpu_to_be64(tgt->scsi_id) != crq->scsi_id)
> +	}
> +
> +	if (crq) {
> +		wwpn = crq->wwpn;
> +		node_name = crq->node_name;
> +		scsi_id = crq->scsi_id;
> +	} else {
> +		wwpn = subq->wwpn;
> +		node_name = subq->id.node_name;
> +		scsi_id = 0;
> +	}
> +
> +	if (!scsi_id && !wwpn && !node_name)
> +		goto end;
> +
> +	list_for_each_entry_safe(tgt, next, &vhost->targets, queue) {
> +		if (scsi_id && cpu_to_be64(tgt->scsi_id) != scsi_id)
>  			continue;
> -		if (crq->wwpn && cpu_to_be64(tgt->ids.port_name) != crq->wwpn)
> +		if (wwpn && cpu_to_be64(tgt->ids.port_name) != wwpn)
>  			continue;
> -		if (crq->node_name && cpu_to_be64(tgt->ids.node_name) != crq->node_name)
> +		if (node_name && cpu_to_be64(tgt->ids.node_name) != node_name)
>  			continue;
>  		if (!tgt->rport)
>  			continue;
> -		fpin = ibmvfc_basic_fpin_to_desc(crq, tgt->wwpn);
> +		if (crq) {
> +			fpin = ibmvfc_basic_fpin_to_desc(crq, tgt->wwpn);
> +		} else {
> +			sqfpin = (struct ibmvfc_async_subq_fpin *)subq;
> +			fpin = ibmvfc_full_fpin_to_desc(subq);
> +		}
>  		if (fpin) {
>  			fc_host_fpin_rcv(tgt->vhost->host,
>  					 sizeof(*fpin) + be32_to_cpu(fpin->desc_len),
>  					 (char *)fpin, 0);
>  			kfree(fpin);
>  		} else
> -			dev_err_ratelimited(vhost->dev,
> -					    "FPIN event %u received, unable to process\n",
> -					    crq->fpin_status);
> +			dev_err_ratelimited(vhost->dev, "FPIN event received, unable to process\n");
>  	}
>  
>   end:
> -	crq->valid = 0;
> +	if (crq)
> +		crq->valid = 0;
> +	if (subq)
> +		subq->valid = 0;
>  
>  	kfree(aw);
>  }
>  
>  /**
> - * ibmvfc_handle_async - Handle an async event from the adapter
> - * @crq:	crq to process
> + * ibmvfc_handle_async_common - Handle an async event from the adapter
> + * @event:	event to process
> + * @link_state:	link state
>   * @vhost:	ibmvfc host struct
> + * @scsi_id:	scsi_id (0 if not applicable)
> + * @wwpn:	wwpn
> + * @node_name:	node_name
> + * @aw_crq:	crq pointer for async work (NULL if not needed)
> + * @aw_subq:	subq pointer for async work (NULL if not needed)
>   *
>   **/
> -VISIBLE_IF_KUNIT void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
> -					  struct ibmvfc_host *vhost)
> +static void ibmvfc_handle_async_common(u64 event, u8 link_state,
> +				       struct ibmvfc_host *vhost,
> +				       u64 scsi_id, u64 wwpn, u64 node_name,
> +				       struct ibmvfc_async_crq *aw_crq,
> +				       struct ibmvfc_async_subq *aw_subq)

This is a lot of parameters which could be extracted here in the function if it
just knew the type of async_crq. Would it be easier to no just take a void
*async_instance parameter, and an is_subq boolean to determine if you cast the
void * to ibmvfc_async_crq * or ibmvfc_async_sub_crq *?
>  {
> -	const struct ibmvfc_async_desc *desc = ibmvfc_get_ae_desc(be64_to_cpu(crq->event));
> +	struct ibmvfc_target *tgt, *next;
>  	struct ibmvfc_async_work *aw;
> -	struct ibmvfc_target *tgt;
>  	bool clear_valid = true;
>  
> -	ibmvfc_log(vhost, desc->log_level, "%s event received. scsi_id: %llx, wwpn: %llx,"
> -		   " node_name: %llx%s\n", desc->desc, be64_to_cpu(crq->scsi_id),
> -		   be64_to_cpu(crq->wwpn), be64_to_cpu(crq->node_name),
> -		   ibmvfc_get_link_state(crq->link_state));
> -
> -	switch (be64_to_cpu(crq->event)) {
> +	switch (event) {
>  	case IBMVFC_AE_RESUME:
> -		switch (crq->link_state) {
> +		switch (link_state) {
>  		case IBMVFC_AE_LS_LINK_DOWN:
>  			ibmvfc_link_down(vhost, IBMVFC_LINK_DOWN);
>  			break;
> @@ -3419,7 +3484,6 @@ VISIBLE_IF_KUNIT void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
>  			__ibmvfc_reset_host(vhost);
>  			break;
>  		}
> -
>  		break;
>  	case IBMVFC_AE_LINK_UP:
>  		vhost->events_to_log |= IBMVFC_AE_LINKUP;
> @@ -3439,58 +3503,106 @@ VISIBLE_IF_KUNIT void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
>  		vhost->events_to_log |= IBMVFC_AE_RSCN;
>  		ibmvfc_reinit_host(vhost);
>  		break;
> +	case IBMVFC_AE_LINK_DOWN:
> +	case IBMVFC_AE_ADAPTER_FAILED:
> +		ibmvfc_link_down(vhost, IBMVFC_LINK_DOWN);
> +		break;
> +	case IBMVFC_AE_LINK_DEAD:
> +		ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
> +		break;
> +	case IBMVFC_AE_HALT:
> +		ibmvfc_link_down(vhost, IBMVFC_HALTED);
> +		break;
>  	case IBMVFC_AE_ELS_LOGO:
>  	case IBMVFC_AE_ELS_PRLO:
>  	case IBMVFC_AE_ELS_PLOGI:
> -		list_for_each_entry(tgt, &vhost->targets, queue) {
> -			if (!crq->scsi_id && !crq->wwpn && !crq->node_name)
> +		list_for_each_entry_safe(tgt, next, &vhost->targets, queue) {
> +			if (!scsi_id && !wwpn && !node_name)
>  				break;
> -			if (crq->scsi_id && cpu_to_be64(tgt->scsi_id) != crq->scsi_id)
> +			if (scsi_id && cpu_to_be64(tgt->scsi_id) != scsi_id)
>  				continue;
> -			if (crq->wwpn && cpu_to_be64(tgt->ids.port_name) != crq->wwpn)
> +			if (wwpn && cpu_to_be64(tgt->ids.port_name) != wwpn)
>  				continue;
> -			if (crq->node_name && cpu_to_be64(tgt->ids.node_name) != crq->node_name)
> +			if (node_name && cpu_to_be64(tgt->ids.node_name) != node_name)
>  				continue;
> -			if (tgt->need_login && be64_to_cpu(crq->event) == IBMVFC_AE_ELS_LOGO)
> +			if (tgt->need_login && event == IBMVFC_AE_ELS_LOGO)
>  				tgt->logo_rcvd = 1;
> -			if (!tgt->need_login || be64_to_cpu(crq->event) == IBMVFC_AE_ELS_PLOGI) {
> +			if (!tgt->need_login || event == IBMVFC_AE_ELS_PLOGI) {
>  				ibmvfc_del_tgt(tgt);
>  				ibmvfc_reinit_host(vhost);
>  			}
>  		}
>  		break;
> -	case IBMVFC_AE_LINK_DOWN:
> -	case IBMVFC_AE_ADAPTER_FAILED:
> -		ibmvfc_link_down(vhost, IBMVFC_LINK_DOWN);
> -		break;
> -	case IBMVFC_AE_LINK_DEAD:
> -		ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
> -		break;
> -	case IBMVFC_AE_HALT:
> -		ibmvfc_link_down(vhost, IBMVFC_HALTED);
> -		break;
>  	case IBMVFC_AE_FPIN:
>  		aw = kzalloc(sizeof(struct ibmvfc_async_work), GFP_ATOMIC);
>  		if (aw) {
>  			clear_valid = false;
>  			INIT_WORK(&aw->async_work_s, ibmvfc_process_async_work);
>  			aw->vhost = vhost;
> -			aw->crq = crq;
> +			if (aw_crq)
> +				aw->crq = aw_crq;
> +			if (aw_subq)
> +				aw->subq = aw_subq;
>  			schedule_work(&aw->async_work_s);
>  		} else
>  			dev_err_ratelimited(vhost->dev,
>  					    "can't offload async CRQ to work queue\n");
>  		break;
>  	default:
> -		dev_err(vhost->dev, "Unknown async event received: %lld\n", crq->event);
> +		dev_err(vhost->dev, "Unknown async event received: %llu\n", event);
>  		break;
>  	}
>  
> -	if (clear_valid)
> -		crq->valid = 0;
> +	if (clear_valid) {
> +		if (aw_crq)
> +			aw_crq->valid = 0;
> +		if (aw_subq)
> +			aw_subq->valid = 0;

You are missing wmb() barriers here.

> +	}
> +}
> +
> +/**
> + * ibmvfc_handle_async - Handle an async event from the adapter
> + * @crq:	crq to process
> + * @vhost:	ibmvfc host struct
> + *
> + **/
> +VISIBLE_IF_KUNIT void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
> +					  struct ibmvfc_host *vhost)

async and asyncq as in the function name below can be hard to notice the
difference in name convention. Maybe async_subq would be a better ender, but as
it might be eaiser to just call ibmvfc_handle_async_common(crq, 0) and
ibmfvc_handle_async(sub_crq, 1), as I outlined above in each of the interrupt
handlers.

> +{
> +	const struct ibmvfc_async_desc *desc = ibmvfc_get_ae_desc(be64_to_cpu(crq->event));
> +	u64 event = be64_to_cpu(crq->event);
> +
> +	ibmvfc_log(vhost, desc->log_level,
> +		   "%s event received. scsi_id: %llx, wwpn: %llx, node_name: %llx%s\n",
> +		   desc->desc, be64_to_cpu(crq->scsi_id),
> +		   be64_to_cpu(crq->wwpn), be64_to_cpu(crq->node_name),
> +		   ibmvfc_get_link_state(crq->link_state));
> +
> +	ibmvfc_handle_async_common(event, crq->link_state, vhost,
> +				   crq->scsi_id, crq->wwpn, crq->node_name,
> +				   crq, NULL);
>  }
>  EXPORT_SYMBOL_IF_KUNIT(ibmvfc_handle_async);
>  
> +VISIBLE_IF_KUNIT void ibmvfc_handle_asyncq(struct ibmvfc_crq *crq_instance,
> +					   struct ibmvfc_host *vhost)
> +{
> +	struct ibmvfc_async_subq *crq = (struct ibmvfc_async_subq *)crq_instance;
> +	const struct ibmvfc_async_desc *desc = ibmvfc_get_ae_desc(be16_to_cpu(crq->event));
> +	u64 event = be16_to_cpu(crq->event);
> +
> +	ibmvfc_log(vhost, desc->log_level,
> +		   "%s event received. wwpn: %llx, node_name: %llx%s event 0x%x\n",
> +		   desc->desc, be64_to_cpu(crq->wwpn), be64_to_cpu(crq->id.node_name),
> +		   ibmvfc_get_link_state(crq->link_state), be16_to_cpu(crq->event));
> +
> +	ibmvfc_handle_async_common(event, crq->link_state, vhost,
> +				   0, crq->wwpn, crq->id.node_name,
> +				   NULL, crq);
> +}
> +EXPORT_SYMBOL_IF_KUNIT(ibmvfc_handle_asyncq);
> +
>  /**
>   * ibmvfc_handle_crq - Handles and frees received events in the CRQ
>   * @crq:	Command/Response queue
> @@ -4117,6 +4229,13 @@ static void ibmvfc_handle_scrq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost
>  	spin_unlock(&evt->queue->l_lock);
>  }
>  
> +/**
> + * ibmvfc_next_scrq - Returns the next entry in message subqueue
> + * @scrq:	Pointer to message subqueue
> + *
> + * Returns:
> + *	Pointer to next entry in queue / NULL if empty
> + **/
>  static struct ibmvfc_crq *ibmvfc_next_scrq(struct ibmvfc_queue *scrq)
>  {
>  	struct ibmvfc_crq *crq;
> @@ -4132,6 +4251,57 @@ static struct ibmvfc_crq *ibmvfc_next_scrq(struct ibmvfc_queue *scrq)
>  	return crq;
>  }
>  
> +static void ibmvfc_drain_async_subq(struct ibmvfc_queue *scrq)
> +{
> +	struct ibmvfc_crq *crq;
> +	unsigned long flags;
> +	int done = 0;
> +
> +	ENTER;
> +
> +	spin_lock_irqsave(scrq->q_lock, flags);
> +	while (!done) {
> +		while ((crq = ibmvfc_next_scrq(scrq)) != NULL) {
> +			ibmvfc_handle_asyncq(crq, scrq->vhost);
> +			crq->valid = 0;

Isn't up to the handle_async_common to clear the valid crq bit depending on the
type of async action?

> +			wmb();	/* complete write */
> +		}
> +
> +		ibmvfc_toggle_scrq_irq(scrq, 1);
> +		crq = ibmvfc_next_scrq(scrq);
> +		if (crq != NULL) {
> +			ibmvfc_toggle_scrq_irq(scrq, 0);
> +			ibmvfc_handle_asyncq(crq, scrq->vhost);
> +			crq->valid = 0;

Same comment as above.

> +			wmb();	/* complete write */
> +		} else
> +			done = 1;
> +	}
> +	spin_unlock_irqrestore(scrq->q_lock, flags);
> +
> +	LEAVE;
> +}
> +
> +/**
> + * ibmvfc_interrupt_asyncq - Handle an async event from the adapter
> + * @irq:           interrupt request
> + * @scrq_instance: async subq
> + *
> + **/
> +static irqreturn_t ibmvfc_interrupt_asyncq(int irq, void *scrq_instance)
> +{
> +	struct ibmvfc_queue *scrq = (struct ibmvfc_queue *)scrq_instance;
> +
> +	ENTER;
> +
> +	ibmvfc_toggle_scrq_irq(scrq, 0);
> +	ibmvfc_drain_async_subq(scrq);
> +
> +	LEAVE;
> +
> +	return IRQ_HANDLED;
> +}
> +
>  static void ibmvfc_drain_sub_crq(struct ibmvfc_queue *scrq)
>  {
>  	struct ibmvfc_crq *crq;
> @@ -5500,6 +5670,8 @@ static void ibmvfc_npiv_login_done(struct ibmvfc_event *evt)
>  	unsigned int npiv_max_sectors;
>  	int level = IBMVFC_DEFAULT_LOG_LEVEL;
>  
> +	ENTER;
> +
>  	switch (mad_status) {
>  	case IBMVFC_MAD_SUCCESS:
>  		ibmvfc_free_event(evt);
> @@ -5578,6 +5750,8 @@ static void ibmvfc_npiv_login_done(struct ibmvfc_event *evt)
>  		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
>  		wake_up(&vhost->work_wait_q);
>  	}
> +
> +	LEAVE;

Also, please drop the ENTER/LEAVE macros as these look like debug artifacts.
Especially, in common code paths like the interrupt handlers.

-Tyrel

>  }
>  
>  /**
> @@ -6226,14 +6400,26 @@ static int ibmvfc_init_crq(struct ibmvfc_host *vhost)
>  	return retrc;
>  }
>  
> -static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
> -				   struct ibmvfc_channels *channels,
> -				   int index)
> +static inline char *ibmvfc_channel_index(struct ibmvfc_channels *channels,
> +					 struct ibmvfc_queue *scrq,
> +					 char *buf, size_t bufsize)
> +{
> +	if (scrq < channels->scrqs || scrq >= channels->scrqs + channels->active_queues)
> +		strscpy(buf, "async", 6);
> +	else
> +		snprintf(buf, bufsize, "%ld", scrq - channels->scrqs);
> +	return buf;
> +}
> +
> +static int ibmvfc_register_channel_handler(struct ibmvfc_host *vhost,
> +					   struct ibmvfc_channels *channels,
> +					   struct ibmvfc_queue *scrq,
> +					   irq_handler_t irq)
>  {
>  	struct device *dev = vhost->dev;
>  	struct vio_dev *vdev = to_vio_dev(dev);
> -	struct ibmvfc_queue *scrq = &channels->scrqs[index];
>  	int rc = -ENOMEM;
> +	char buf[16];
>  
>  	ENTER;
>  
> @@ -6252,20 +6438,23 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
>  
>  	if (!scrq->irq) {
>  		rc = -EINVAL;
> -		dev_err(dev, "Error mapping sub-crq[%d] irq\n", index);
> +		dev_err(dev, "Error mapping sub-crq[%s] irq\n",
> +			ibmvfc_channel_index(channels, scrq, buf, sizeof(buf)));
>  		goto irq_failed;
>  	}
>  
>  	switch (channels->protocol) {
>  	case IBMVFC_PROTO_SCSI:
> -		snprintf(scrq->name, sizeof(scrq->name), "ibmvfc-%x-scsi%d",
> -			 vdev->unit_address, index);
> -		scrq->handler = ibmvfc_interrupt_mq;
> +		snprintf(scrq->name, sizeof(scrq->name), "ibmvfc-%x-scsi%s",
> +			 vdev->unit_address,
> +			 ibmvfc_channel_index(channels, scrq, buf, sizeof(buf)));
> +		scrq->handler = irq;
>  		break;
>  	case IBMVFC_PROTO_NVME:
> -		snprintf(scrq->name, sizeof(scrq->name), "ibmvfc-%x-nvmf%d",
> -			 vdev->unit_address, index);
> -		scrq->handler = ibmvfc_interrupt_mq;
> +		snprintf(scrq->name, sizeof(scrq->name), "ibmvfc-%x-nvmf%s",
> +			 vdev->unit_address,
> +			 ibmvfc_channel_index(channels, scrq, buf, sizeof(buf)));
> +		scrq->handler = irq;
>  		break;
>  	default:
>  		dev_err(dev, "Unknown channel protocol (%d)\n",
> @@ -6276,12 +6465,14 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
>  	rc = request_irq(scrq->irq, scrq->handler, 0, scrq->name, scrq);
>  
>  	if (rc) {
> -		dev_err(dev, "Couldn't register sub-crq[%d] irq\n", index);
> +		dev_err(dev, "Couldn't register sub-crq[%s] irq\n",
> +			ibmvfc_channel_index(channels, scrq, buf, sizeof(buf)));
>  		irq_dispose_mapping(scrq->irq);
>  		goto irq_failed;
>  	}
>  
> -	scrq->hwq_id = index;
> +	if (scrq >= channels->scrqs && scrq < channels->scrqs + channels->max_queues)
> +		scrq->hwq_id = scrq - channels->scrqs;
>  
>  	LEAVE;
>  	return 0;
> @@ -6295,13 +6486,21 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
>  	return rc;
>  }
>  
> +static inline int
> +ibmvfc_register_channel(struct ibmvfc_host *vhost,
> +			struct ibmvfc_channels *channels,
> +			struct ibmvfc_queue *scrq)
> +{
> +	return ibmvfc_register_channel_handler(vhost, channels, scrq, ibmvfc_interrupt_mq);
> +}
> +
>  static void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
>  				      struct ibmvfc_channels *channels,
> -				      int index)
> +				      struct ibmvfc_queue *scrq)
>  {
>  	struct device *dev = vhost->dev;
>  	struct vio_dev *vdev = to_vio_dev(dev);
> -	struct ibmvfc_queue *scrq = &channels->scrqs[index];
> +	char buf[16];
>  	long rc;
>  
>  	ENTER;
> @@ -6316,7 +6515,8 @@ static void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
>  	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
>  
>  	if (rc)
> -		dev_err(dev, "Failed to free sub-crq[%d]: rc=%ld\n", index, rc);
> +		dev_err(dev, "Failed to free sub-crq[%s]: rc=%ld\n",
> +			ibmvfc_channel_index(channels, scrq, buf, sizeof(buf)), rc);
>  
>  	/* Clean out the queue */
>  	memset(scrq->msgs.crq, 0, PAGE_SIZE);
> @@ -6334,10 +6534,21 @@ static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
>  	if (!vhost->mq_enabled || !channels->scrqs)
>  		return;
>  
> +	if (ibmvfc_register_channel_handler(vhost, channels,
> +					    channels->async_scrq,
> +					    ibmvfc_interrupt_asyncq)) {
> +		vhost->do_enquiry = 0;
> +		return;
> +	}
> +
>  	for (i = 0; i < channels->max_queues; i++) {
> -		if (ibmvfc_register_channel(vhost, channels, i)) {
> +		if (ibmvfc_register_channel(vhost, channels, &channels->scrqs[i])) {
>  			for (j = i; j > 0; j--)
> -				ibmvfc_deregister_channel(vhost, channels, j - 1);
> +				ibmvfc_deregister_channel(
> +					vhost, channels, &channels->scrqs[j - 1]);
> +			ibmvfc_deregister_channel(vhost, channels,
> +							channels->async_scrq);
> +
>  			vhost->do_enquiry = 0;
>  			return;
>  		}
> @@ -6356,7 +6567,8 @@ static void ibmvfc_dereg_sub_crqs(struct ibmvfc_host *vhost,
>  		return;
>  
>  	for (i = 0; i < channels->max_queues; i++)
> -		ibmvfc_deregister_channel(vhost, channels, i);
> +		ibmvfc_deregister_channel(vhost, channels, &channels->scrqs[i]);
> +	ibmvfc_deregister_channel(vhost, channels, channels->async_scrq);
>  
>  	LEAVE;
>  }
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
> index f026f30f98d3..2e02acde0178 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.h
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.h
> @@ -715,6 +715,7 @@ struct ibmvfc_async_crq {
>  struct ibmvfc_async_work {
>  	struct ibmvfc_host *vhost;
>  	struct ibmvfc_async_crq *crq;
> +	struct ibmvfc_async_subq *subq;
>  	struct work_struct async_work_s;
>  };
>  
> @@ -1008,6 +1009,8 @@ struct ibmvfc_host {
>  
>  #ifdef VISIBLE_IF_KUNIT
>  VISIBLE_IF_KUNIT void ibmvfc_handle_async(struct ibmvfc_async_crq *crq, struct ibmvfc_host *vhost);
> +VISIBLE_IF_KUNIT void ibmvfc_handle_asyncq(struct ibmvfc_crq *crq_instance,
> +					   struct ibmvfc_host *vhost);
>  VISIBLE_IF_KUNIT struct list_head *ibmvfc_get_headp(void);
>  #endif
>  
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
> index e41e2a49e549..c8799eaf4927 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
> @@ -44,7 +44,7 @@ static void ibmvfc_async_fpin_test(struct kunit *test)
>  	fc_host = shost_to_fc_host(vhost->host);
>  
>  	pre[IBMVFC_AE_FPIN_LINK_CONGESTED] = READ_ONCE(fc_host->fpin_stats.cn_device_specific);
> -	pre[IBMVFC_AE_FPIN_PORT_CONGESTED] = READ_ONCE(tgt->rport->fpin_stats.cn);
> +	pre[IBMVFC_AE_FPIN_PORT_CONGESTED] = READ_ONCE(tgt->rport->fpin_stats.cn_device_specific);
>  	pre[IBMVFC_AE_FPIN_PORT_CLEARED] = READ_ONCE(tgt->rport->fpin_stats.cn_clear);
>  	pre[IBMVFC_AE_FPIN_PORT_DEGRADED] = READ_ONCE(tgt->rport->fpin_stats.li_failure_unknown);
>  	pre[IBMVFC_AE_FPIN_CONGESTION_CLEARED] = READ_ONCE(fc_host->fpin_stats.cn_clear);
> 

