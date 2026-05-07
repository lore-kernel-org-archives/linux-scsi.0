Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC4D17B505;
	Thu,  7 May 2026 04:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778127186; cv=none; b=tUHkwA/TmMO+uwdZhH/wli6UohbVDUJ21RF1ajAwMFWUb0JG3peR5bawUnhDBy6J/v/+0jCemtNG76axOtpKOOgG2clMCj/OEyP5LJbm3zYUAR40LwPQ2rThHn5WHWGM5Thdv7Z+iYdaflgyStcFBPfgWeX+GgAVyNKT907qw20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778127186; c=relaxed/simple;
	bh=N4LMA7WfuEi8ZJGbpqJQgInFnu+8SuTLGOOgn4Zi+fc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fRAC6rmyUum+fO6E40aZHjx5OIK24KI5bcWTwV3KcLtMld9NUD+okRHv5ofyRzkEq0O8bW3UuNvZYzJM6NC5B/filMk/b4uYZp4qsVZsj0vUYS/YirV1q8jwm0B+3LUstLIkgdI0T6DuimOnfgJFxnxFQd9upffVHIOWTwP+nzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FHcxbp83; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FHcxbp83"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 646MeBRq3352136;
	Thu, 7 May 2026 04:12:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=7B3DbY
	WNPoXFy3w37BRL5KJZgewyDYufre5dH/Hqrl0=; b=FHcxbp83vOFdr17wTi06EX
	g8MgdO04ThtLSucGG8pukfdRwafDiH/IURdgDXyxn6EYHhHgr0wZTiPdz/0iRhvF
	cKZjiVLl7jvl3UQ2jsmGpGoT4c8fynJvKkpydb7N1Nx/ZxSy9gXLC4Bizt+JQVO3
	3tr8fMKsIAaos+jK/wgJy1EVrrnOBjVNK3ctN+IKjYF8IsV1PgZNpdqZAbJlgiY4
	iFJ9SfIkKf79hiGlaGwgBjNtT+ReK3kLQ7tUtv6zRYGQcIVHPN8fZpYyI/iDIPS9
	e160WN+dYe0jhXYac1abMA4zRq2Ym++h6QSDRrlzz9WOEtLOXxXrSnSN4PsAn8qQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9xxu6hm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 May 2026 04:12:51 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64749SFM029195;
	Thu, 7 May 2026 04:12:50 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dww3h9b1m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 May 2026 04:12:50 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6474Cnvl32703180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 7 May 2026 04:12:49 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9CA6F58052;
	Thu,  7 May 2026 04:12:49 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DAA575805D;
	Thu,  7 May 2026 04:12:48 +0000 (GMT)
Received: from [9.61.92.155] (unknown [9.61.92.155])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  7 May 2026 04:12:48 +0000 (GMT)
Message-ID: <291e79ea-d993-45e4-877e-4c25336c3076@linux.ibm.com>
Date: Wed, 6 May 2026 21:12:48 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] ibmvfc: add basic FPIN support
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
References: <20260408-ibmvfc-fpin-support-v1-0-52b06c464e03@linux.ibm.com>
 <20260408-ibmvfc-fpin-support-v1-1-52b06c464e03@linux.ibm.com>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <20260408-ibmvfc-fpin-support-v1-1-52b06c464e03@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA3MDAzNyBTYWx0ZWRfX1vur6aE3kJrb
 kgEFBDuPqKP4HB1IBH0bjjX4CcSPhZ4BJHz4BIOzGg0LEP7zQiSU7aDt8n7QbHVKZ1Am1yB42rn
 gU6gWyahZyskatjsOv/TC2Sxun/8X0wIKEBlyLeT8DxXaut0FM7+6P/WdxfIWJ//kXnbZT5Ysyv
 MB3M909ijFwT5xSuGFAG5rjilb8bsJkyQxby3FvezNuzw3L+e/Aq5vMJW8wpNs6GVoFddZkvxe7
 zuAmiI/QYtI5CtSwKQboHjYDPeMmyhpIlIljPZI6axMGwXMllnzPq6ZV/qPXlpdcDAAvFDaTb9K
 3xJJp4Jc9MGY2TWmnJ4Qxzpq8hwi0H06uYny/gOAXMh6RrgtO7mxLcUbzhz3a55JSqzrrHM1KUv
 YnndJJI7X7c/mw6pbPXULobLZZ6X6b100s/QC8D/XW+twBZzGRxbZfu9Yhd67TAb1Ew3gwe/qsW
 TKQPCd58gPo5ysvsyBw==
X-Proofpoint-ORIG-GUID: 4HWgafBYg7Nj5wNM11XgzD3ejXPBtzu1
X-Proofpoint-GUID: royV7bcXZ64_bUMNXxvc37s8R40m6mNA
X-Authority-Analysis: v=2.4 cv=ctWrVV4i c=1 sm=1 tr=0 ts=69fc1143 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=1ZkcIFJ3KA0uR8dLXY0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-06_02,2026-05-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 clxscore=1011
 suspectscore=0 impostorscore=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2605070037

On 4/8/26 10:07 AM, Dave Marquardt via B4 Relay wrote:
> From: Dave Marquardt <davemarq@linux.ibm.com>
> 
> - Add FPIN event descriptor
> - Add congestion cleared status
> - Add code to handle basic FPIN async event
> - Add KUnit tests

You need a more detailed description of your changes here for the commit log body.

You will also need a signed off tag from yourself for this to even be merged.

https://www.kernel.org/doc/html/latest/process/submitting-patches.html

> ---
>  drivers/scsi/Kconfig                 |  10 ++
>  drivers/scsi/ibmvscsi/Makefile       |   1 +
>  drivers/scsi/ibmvscsi/ibmvfc.c       | 189 ++++++++++++++++++++++++++++++++++-
>  drivers/scsi/ibmvscsi/ibmvfc.h       |   9 ++
>  drivers/scsi/ibmvscsi/ibmvfc_kunit.c |  95 ++++++++++++++++++
>  5 files changed, 302 insertions(+), 2 deletions(-)

<snip>

> +static struct fc_els_fpin *
> +ibmvfc_common_fpin_to_desc(u8 fpin_status, __be64 wwpn, __be16 modifier,
> +			   __be32 period, __be32 threshold, __be32 event_count)
> +{
> +	struct fc_fn_peer_congn_desc *pdesc;
> +	struct fc_fn_congn_desc *cdesc;
> +	struct fc_fn_li_desc *ldesc;
> +	struct fc_els_fpin *fpin;
> +	size_t size;
> +
> +	size = ibmvfc_fpin_size_helper(fpin_status);
> +	if (size == 0)
> +		return NULL;
> +
> +	fpin = kzalloc(size, GFP_KERNEL);

This appears to be called by ibmvfc_handle_async() with runs in atomic context
and cannot therefore sleep. This allocation needs to be GFP_ATOMIC. Although
there is another issue below that might make this moot.

> +	if (fpin == NULL)
> +		return NULL;
> +
> +	fpin->fpin_cmd = ELS_FPIN;
> +
> +	switch (fpin_status) {
> +	case IBMVFC_AE_FPIN_CONGESTION_CLEARED:
> +	case IBMVFC_AE_FPIN_LINK_CONGESTED:
> +		fpin->desc_len = cpu_to_be32(sizeof(struct fc_fn_congn_desc));
> +		cdesc = (struct fc_fn_congn_desc *)fpin->fpin_desc;
> +		cdesc->desc_tag = cpu_to_be32(ELS_DTAG_CONGESTION);
> +		cdesc->desc_len = cpu_to_be32(FC_TLV_DESC_LENGTH_FROM_SZ(*cdesc));
> +		if (fpin_status == IBMVFC_AE_FPIN_CONGESTION_CLEARED)
> +			cdesc->event_type = cpu_to_be16(FPIN_CONGN_CLEAR);
> +		else
> +			cdesc->event_type = cpu_to_be16(FPIN_CONGN_DEVICE_SPEC);
> +		cdesc->event_modifier = modifier;
> +		cdesc->event_period = period;
> +		cdesc->severity = FPIN_CONGN_SEVERITY_WARNING;
> +		break;
> +	case IBMVFC_AE_FPIN_PORT_CONGESTED:
> +	case IBMVFC_AE_FPIN_PORT_CLEARED:
> +		fpin->desc_len = cpu_to_be32(sizeof(struct fc_fn_peer_congn_desc));
> +		pdesc = (struct fc_fn_peer_congn_desc *)fpin->fpin_desc;
> +		pdesc->desc_tag = cpu_to_be32(ELS_DTAG_PEER_CONGEST);
> +		pdesc->desc_len = cpu_to_be32(FC_TLV_DESC_LENGTH_FROM_SZ(*pdesc));
> +		if (fpin_status == IBMVFC_AE_FPIN_PORT_CLEARED)
> +			pdesc->event_type = cpu_to_be16(FPIN_CONGN_CLEAR);
> +		else
> +			pdesc->event_type = cpu_to_be16(FPIN_CONGN_DEVICE_SPEC);
> +		pdesc->event_modifier = modifier;
> +		pdesc->event_period = period;
> +		pdesc->detecting_wwpn = cpu_to_be64(0);
> +		pdesc->attached_wwpn = wwpn;
> +		pdesc->pname_count = cpu_to_be32(1);
> +		pdesc->pname_list[0] = wwpn;
> +		break;
> +	case IBMVFC_AE_FPIN_PORT_DEGRADED:
> +		fpin->desc_len = cpu_to_be32(sizeof(struct fc_fn_li_desc));
> +		ldesc = (struct fc_fn_li_desc *)fpin->fpin_desc;
> +		ldesc->desc_tag = cpu_to_be32(ELS_DTAG_LNK_INTEGRITY);
> +		ldesc->desc_len = cpu_to_be32(FC_TLV_DESC_LENGTH_FROM_SZ(*ldesc));
> +		ldesc->event_type = cpu_to_be16(FPIN_LI_UNKNOWN);
> +		ldesc->event_modifier = modifier;
> +		ldesc->event_threshold = threshold;
> +		ldesc->event_count = event_count;
> +		ldesc->detecting_wwpn = cpu_to_be64(0);
> +		ldesc->attached_wwpn = wwpn;
> +		ldesc->pname_count = cpu_to_be32(1);
> +		ldesc->pname_list[0] = wwpn;
> +		break;
> +	default:
> +		/* This should be caught above. */
> +		kfree(fpin);
> +		fpin = NULL;
> +		break;
> +	}
> +
> +	return fpin;
> +}
> +
> +/**
> + * ibmvfc_basic_fpin_to_desc(): allocate and populate a struct fc_els_fpin struct
> + * containing a descriptor.
> + * @ibmvfc_fpin: Pointer to async crq
> + *
> + * Allocate a struct fc_els_fpin containing a descriptor and populate
> + * based on data from *ibmvfc_fpin.
> + *
> + * Return:
> + * NULL     - unable to allocate structure
> + * non-NULL - pointer to populated struct fc_els_fpin
> + */
> +static struct fc_els_fpin *
> +/*XXX*/ibmvfc_basic_fpin_to_desc(struct ibmvfc_async_crq *crq)

What is with this /*XXX*/? I can't find it once I apply the patchset so I assume
its removed in a later patch, but it should be removed here.

> +{
> +	return ibmvfc_common_fpin_to_desc(crq->fpin_status, crq->wwpn,
> +					  cpu_to_be16(0),
> +					  cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_PERIOD),
> +					  cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_THRESHOLD),
> +					  cpu_to_be32(1));
> +}
> +
>  /**
>   * ibmvfc_handle_async - Handle an async event from the adapter
>   * @crq:	crq to process
>   * @vhost:	ibmvfc host struct
>   *
>   **/
> -static void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
> -				struct ibmvfc_host *vhost)
> +VISIBLE_IF_KUNIT void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
> +					  struct ibmvfc_host *vhost)
>  {
>  	const struct ibmvfc_async_desc *desc = ibmvfc_get_ae_desc(be64_to_cpu(crq->event));
>  	struct ibmvfc_target *tgt;
> +	struct fc_els_fpin *fpin;
>  
>  	ibmvfc_log(vhost, desc->log_level, "%s event received. scsi_id: %llx, wwpn: %llx,"
>  		   " node_name: %llx%s\n", desc->desc, be64_to_cpu(crq->scsi_id),
> @@ -3269,11 +3422,37 @@ static void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
>  	case IBMVFC_AE_HALT:
>  		ibmvfc_link_down(vhost, IBMVFC_HALTED);
>  		break;
> +	case IBMVFC_AE_FPIN:
> +		if (!crq->scsi_id && !crq->wwpn && !crq->node_name)
> +			break;
> +		list_for_each_entry(tgt, &vhost->targets, queue) {
> +			if (crq->scsi_id && cpu_to_be64(tgt->scsi_id) != crq->scsi_id)
> +				continue;
> +			if (crq->wwpn && cpu_to_be64(tgt->ids.port_name) != crq->wwpn)
> +				continue;
> +			if (crq->node_name && cpu_to_be64(tgt->ids.node_name) != crq->node_name)
> +				continue;
> +			if (!tgt->rport)
> +				continue;
> +			fpin = ibmvfc_basic_fpin_to_desc(crq);
> +			if (fpin) {
> +				fc_host_fpin_rcv(tgt->vhost->host,
> +						 sizeof(*fpin) +
> +						       be32_to_cpu(fpin->desc_len),
> +						 (char *)fpin, 0);

This call to fc_host_fpin_rcv() appears to be problematic as it assumes no locks
are held, but ibmvfc_handle_async() is called with the scsi host lock held. We
already do a lot more work than we probaly should in our interrupt handler. I
think we maybe need to pass the FPIN work off to a workqueue instead to be
handled in process context instead.

-Tyrel


