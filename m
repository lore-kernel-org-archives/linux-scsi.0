Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A1A32AADE;
	Thu,  7 May 2026 05:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778132507; cv=none; b=H6ftzNoOaK995IgxWM5YwHO15gEkqdm9bVNQOSeQckoEVNRMMg18CLFHexPEcPzwk//QDhYa32dYcREUS0YrQWBEKefN0gQRLGBYT3khOG51Lx2e3CXdkWUhWPuGMZri8xw0Z+001tzMqVK94uSA3RExUlW1/2Ve+lGYYMhOFVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778132507; c=relaxed/simple;
	bh=fK9hIoQUYt65SwgSG0Kz+oLQDQa6kGqhyuQlbpc17X4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XtITEWSqfs9PiEt3NWC2liTyGmdO00W7Eup3lOChTEpwqc7uSkCTtg7+vKCSXtBmhyuHQSWn6j6jfUORkA83hajxe75VpaVWdAdi498h9Fbm2Wk9Mg4l7z+0bo83NlKcHF6Ce6XBDu87+SdiNiG1Idhw+8V/y8uFouK1UQaLNXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=m5MEtBm9; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="m5MEtBm9"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6473VpXG599575;
	Thu, 7 May 2026 05:41:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=YhFM47
	Y1f2/rXc38z9Gg3fYawgWNaZ6Ot4dyNH8Y/Us=; b=m5MEtBm9aCfOMK34L8YHQr
	aQUY9cJnNQEoSqKKPbgI2vRdne52ReL/3ZtklPbN98430/qyxtFPOIZJr9iiz3il
	6r/MoJqLFxnSFoQpuxOzsVgJcWTYZeq6jH9Wbm27wsopx6dsoQcKW3JPIMTYp1e3
	U4/Io/yycFh0JZ1Sl/hiVwQ+3jsdXdR33IRwtb7H9KyJRHMIlWO33lPQ+jIFSK7w
	O2D16gBFe2OCVKHw0rgNA71Ng9zj+OhgqvZOMiHvwMFuB/FsvU2a7jozjrcO/yeU
	04Jc6XZraXJ68uzAAOrJsUArfr1i4raxKLTSywLvCrMGOk9+iydEIVF9uLT/SOoA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9y1mb6v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 May 2026 05:41:29 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6475dVPR004753;
	Thu, 7 May 2026 05:41:28 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dwuyw9pee-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 May 2026 05:41:28 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6475fRLq30736900
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 7 May 2026 05:41:27 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7358958056;
	Thu,  7 May 2026 05:41:27 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A0C4258052;
	Thu,  7 May 2026 05:41:26 +0000 (GMT)
Received: from [9.61.92.155] (unknown [9.61.92.155])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  7 May 2026 05:41:26 +0000 (GMT)
Message-ID: <e59242e4-f353-44eb-ad48-b76a9101d4fb@linux.ibm.com>
Date: Wed, 6 May 2026 22:41:26 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] ibmvfc: use async sub-queue for FPIN messages
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
 <20260408-ibmvfc-fpin-support-v1-4-52b06c464e03@linux.ibm.com>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <20260408-ibmvfc-fpin-support-v1-4-52b06c464e03@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: Y9o9xTPz29ROI9lwFy386KHmvV_4GtSx
X-Proofpoint-GUID: 5Eyk6eRk3iRu_dj1Nkx8ITJ2Pgx0smm7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA3MDA1MiBTYWx0ZWRfX564S03U3cNs9
 lo9mOai9qTFkmc+T9tnj314n73N5g6rx474TlT1ZZR0olLN0qUE9CLd/lJWGRxx83iAYLWPgarI
 siVZylT8FRK1iwH7crxiORvrr6SH3OZih8/h0fGkHOheF0ZnGoQskz1khxYOoWNyzg353J4rhkz
 kd/SJzRaRWWSciyg/SbMKdRTpJYdiQM62pjGU83Js+VB4cb+df/FYg4eoqouMb4+QgHsdPJpP6R
 IfhYwX06ydI/EbFMpCnguF51JYr+n2y4LYMH+8O8GzXG3eOcTPH/dtX8EfwvQn2WPu5UFx4uiwZ
 ckL8J9jRsAxfGijeGEaq65wrmBy3xPvHSi9b2C48ZJzqfeh/Sdb3HFU7oiQEKB5JnbyasU8bj40
 12oVUlo2/73uPeDiVsbUOLQfY3mZr/hOTiynYMu9HFZqTzPIoeKPZDTZVBLDQ52NWQKUO1X5y4H
 /LOK/NCNQQ/6ZXiCgQw==
X-Authority-Analysis: v=2.4 cv=UbFhjqSN c=1 sm=1 tr=0 ts=69fc260a cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=bEZbapCrhuM-G9hfQ6AA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-06_02,2026-05-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605070052

On 4/8/26 10:07 AM, Dave Marquardt via B4 Relay wrote:
> From: Dave Marquardt <davemarq@linux.ibm.com>
> 
> - allocate async sub-queue
> - allocate interrupt and set up handler
> - negotiate use of async sub-queue with NPIV (VIOS)
> - refactor ibmvfc_basic_fpin_to_desc() and ibmvfc_full_fpin_to_desc()
>   into common routine
> - add KUnit test to verify async sub-queue is allocated

Again more descriptive commit log message required here. Also, this looks like a
lot of things being implmented. Can this be broken into multiple patches? It
sure looks like a bunch of functional changes that build on each other.

> ---
>  drivers/scsi/ibmvscsi/ibmvfc.c       | 325 ++++++++++++++++++++++++++++++++---
>  drivers/scsi/ibmvscsi/ibmvfc.h       |  29 +++-
>  drivers/scsi/ibmvscsi/ibmvfc_kunit.c |  52 +++---
>  3 files changed, 363 insertions(+), 43 deletions(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index 803fc3caa14d..26e39b367022 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -1471,6 +1471,13 @@ static void ibmvfc_gather_partition_info(struct ibmvfc_host *vhost)
>  	of_node_put(rootdn);
>  }
>  
> +static __be64 ibmvfc_npiv_chan_caps[] = {
> +	cpu_to_be64(IBMVFC_CAN_USE_CHANNELS | IBMVFC_USE_ASYNC_SUBQ |
> +		    IBMVFC_YES_SCSI | IBMVFC_CAN_HANDLE_FPIN),
> +	cpu_to_be64(IBMVFC_CAN_USE_CHANNELS),
> +};
> +#define IBMVFC_NPIV_CHAN_CAPS_SIZE (sizeof(ibmvfc_npiv_chan_caps)/sizeof(__be64))
> +

I really don't understand what you are doing here? You seem to be definig
various sets of capabilities, but how does the driver decide which set to use?
As far as I can tell the index is increased and the capabilities decrease each
time a transport event is received. This looks like maybe its just a testing hack.

>  /**
>   * ibmvfc_set_login_info - Setup info for NPIV login
>   * @vhost:	ibmvfc host struct
> @@ -1486,6 +1493,8 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
>  	const char *location;
>  	u16 max_cmds;
>  
> +	ENTER;
> +
>  	max_cmds = scsi_qdepth + IBMVFC_NUM_INTERNAL_REQ;
>  	if (mq_enabled)
>  		max_cmds += (scsi_qdepth + IBMVFC_NUM_INTERNAL_SUBQ_REQ) *
> @@ -1509,8 +1518,12 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
>  		cpu_to_be64(IBMVFC_CAN_MIGRATE | IBMVFC_CAN_SEND_VF_WWPN |
>  			    IBMVFC_CAN_USE_NOOP_CMD);
>  
> -	if (vhost->mq_enabled || vhost->using_channels)
> -		login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_CHANNELS);
> +	if (vhost->mq_enabled || vhost->using_channels) {
> +		if (vhost->login_cap_index >= IBMVFC_NPIV_CHAN_CAPS_SIZE)
> +			login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_CHANNELS);
> +		else
> +			login_info->capabilities |= ibmvfc_npiv_chan_caps[vhost->login_cap_index];
> +	}
>  
>  	login_info->async.va = cpu_to_be64(vhost->async_crq.msg_token);
>  	login_info->async.len = cpu_to_be32(async_crq->size *
> @@ -1524,6 +1537,8 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
>  	location = of_get_property(of_node, "ibm,loc-code", NULL);
>  	location = location ? location : dev_name(vhost->dev);
>  	strscpy(login_info->drc_name, location, sizeof(login_info->drc_name));
> +
> +	LEAVE;
>  }
>  
>  /**
> @@ -3323,7 +3338,7 @@ ibmvfc_common_fpin_to_desc(u8 fpin_status, __be64 wwpn, __be16 modifier,
>   * non-NULL - pointer to populated struct fc_els_fpin
>   */
>  static struct fc_els_fpin *
> -/*XXX*/ibmvfc_basic_fpin_to_desc(struct ibmvfc_async_crq *crq)

I mentioned this /*XXX*/ in an earlier patch. This needs to be fixed in that patch.

> +ibmvfc_basic_fpin_to_desc(struct ibmvfc_async_crq *crq)
>  {
>  	return ibmvfc_common_fpin_to_desc(crq->fpin_status, crq->wwpn,
>  					  cpu_to_be16(0),
> @@ -3332,6 +3347,29 @@ static struct fc_els_fpin *
>  					  cpu_to_be32(1));
>  }
>  
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
> +	return ibmvfc_common_fpin_to_desc(ibmvfc_fpin->fpin_status,
> +					  ibmvfc_fpin->wwpn,
> +					  cpu_to_be16(0),
> +					  cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_PERIOD),
> +					  cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_THRESHOLD),
> +					  cpu_to_be32(1));
> +}
> +
>  /**
>   * ibmvfc_handle_async - Handle an async event from the adapter
>   * @crq:	crq to process
> @@ -3449,6 +3487,120 @@ VISIBLE_IF_KUNIT void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
>  }
>  EXPORT_SYMBOL_IF_KUNIT(ibmvfc_handle_async);
>  
> +VISIBLE_IF_KUNIT void ibmvfc_handle_asyncq(struct ibmvfc_crq *crq_instance,
> +					   struct ibmvfc_host *vhost,
> +					   struct list_head *evt_doneq)
> +{
> +	struct ibmvfc_async_subq *crq = (struct ibmvfc_async_subq *)crq_instance;
> +	const struct ibmvfc_async_desc *desc = ibmvfc_get_ae_desc(be16_to_cpu(crq->event));
> +	struct ibmvfc_target *tgt;
> +	struct fc_els_fpin *fpin;
> +
> +	ibmvfc_log(vhost, desc->log_level,
> +		   "%s event received. wwpn: %llx, node_name: %llx%s event 0x%x\n",
> +		   desc->desc, be64_to_cpu(crq->wwpn), be64_to_cpu(crq->id.node_name),
> +		   ibmvfc_get_link_state(crq->link_state), be16_to_cpu(crq->event));

Was there no way to not copy/paste what looks like basically ibmvfc_handle_async
into ibmvfc_handle_asyncq? This is a bunch of unnecessary code bloat. The major
difference seems that crq->event is be64 on the standard CRQ and be16 on a
sub-crq and accessing certain fields differently.

Again I think maybe we need to consider moving all the async work into a workqueue.

> +
> +	switch (be16_to_cpu(crq->event)) {
> +	case IBMVFC_AE_RESUME:
> +		switch (crq->link_state) {
> +		case IBMVFC_AE_LS_LINK_DOWN:
> +			ibmvfc_link_down(vhost, IBMVFC_LINK_DOWN);
> +			break;
> +		case IBMVFC_AE_LS_LINK_DEAD:
> +			ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
> +			break;
> +		case IBMVFC_AE_LS_LINK_UP:
> +		case IBMVFC_AE_LS_LINK_BOUNCED:
> +		default:
> +			vhost->events_to_log |= IBMVFC_AE_LINKUP;
> +			vhost->delay_init = 1;
> +			__ibmvfc_reset_host(vhost);
> +			break;
> +		}
> +
> +		break;
> +	case IBMVFC_AE_LINK_UP:
> +		vhost->events_to_log |= IBMVFC_AE_LINKUP;
> +		vhost->delay_init = 1;
> +		__ibmvfc_reset_host(vhost);
> +		break;
> +	case IBMVFC_AE_SCN_FABRIC:
> +	case IBMVFC_AE_SCN_DOMAIN:
> +		vhost->events_to_log |= IBMVFC_AE_RSCN;
> +		if (vhost->state < IBMVFC_HALTED) {
> +			vhost->delay_init = 1;
> +			__ibmvfc_reset_host(vhost);
> +		}
> +		break;
> +	case IBMVFC_AE_SCN_NPORT:
> +	case IBMVFC_AE_SCN_GROUP:
> +		vhost->events_to_log |= IBMVFC_AE_RSCN;
> +		ibmvfc_reinit_host(vhost);
> +		break;
> +	case IBMVFC_AE_ELS_LOGO:
> +	case IBMVFC_AE_ELS_PRLO:
> +	case IBMVFC_AE_ELS_PLOGI:
> +		list_for_each_entry(tgt, &vhost->targets, queue) {
> +			if (!crq->wwpn && !crq->id.node_name)
> +				break;
> +	#ifdef notyet
> +			if (cpu_to_be64(tgt->scsi_id) != acrq->scsi_id)
> +				continue;
> +	#endif
> +			if (crq->wwpn && cpu_to_be64(tgt->ids.port_name) != crq->wwpn)
> +				continue;
> +			if (crq->id.node_name &&
> +			    cpu_to_be64(tgt->ids.node_name) != crq->id.node_name)
> +				continue;
> +			if (tgt->need_login && be64_to_cpu(crq->event) == IBMVFC_AE_ELS_LOGO)
> +				tgt->logo_rcvd = 1;
> +			if (!tgt->need_login || be64_to_cpu(crq->event) == IBMVFC_AE_ELS_PLOGI) {
> +				ibmvfc_del_tgt(tgt);
> +				ibmvfc_reinit_host(vhost);
> +			}
> +		}
> +		break;
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
> +	case IBMVFC_AE_FPIN:
> +		if (!crq->wwpn && !crq->id.node_name)
> +			break;
> +		list_for_each_entry(tgt, &vhost->targets, queue) {
> +			if (crq->wwpn && cpu_to_be64(tgt->ids.port_name) != crq->wwpn)
> +				continue;
> +			if (crq->id.node_name &&
> +			    cpu_to_be64(tgt->ids.node_name) != crq->id.node_name)
> +				continue;
> +			if (!tgt->rport)
> +				continue;
> +			fpin = ibmvfc_full_fpin_to_desc(crq);
> +			if (fpin) {
> +				fc_host_fpin_rcv(tgt->vhost->host,
> +						 sizeof(*fpin) + be32_to_cpu(fpin->desc_len),
> +						 (char *)fpin, 0);
> +				kfree(fpin);
> +			} else
> +				dev_err(vhost->dev,
> +					"FPIN event %u received, unable to process\n",
> +					crq->fpin_status);
> +		}
> +		break;
> +	default:
> +		dev_err(vhost->dev, "Unknown async event received: %d\n", crq->event);
> +		break;
> +	}
> +}
> +EXPORT_SYMBOL_IF_KUNIT(ibmvfc_handle_asyncq);
> +
>  /**
>   * ibmvfc_handle_crq - Handles and frees received events in the CRQ
>   * @crq:	Command/Response queue
> @@ -3500,6 +3652,7 @@ VISIBLE_IF_KUNIT void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_ho
>  			dev_err(vhost->dev, "Host partner adapter deregistered or failed (rc=%d)\n", crq->format);
>  			ibmvfc_purge_requests(vhost, DID_ERROR);
>  			ibmvfc_link_down(vhost, IBMVFC_LINK_DOWN);
> +			vhost->login_cap_index++;
>  			ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_RESET);
>  		} else {
>  			dev_err(vhost->dev, "Received unknown transport event from partner (rc=%d)\n", crq->format);
> @@ -4078,6 +4231,13 @@ static void ibmvfc_handle_scrq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost
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
> @@ -4093,6 +4253,65 @@ static struct ibmvfc_crq *ibmvfc_next_scrq(struct ibmvfc_queue *scrq)
>  	return crq;
>  }
>  
> +static void ibmvfc_drain_async_subq(struct ibmvfc_queue *scrq)
> +{
> +	struct ibmvfc_crq *crq;
> +	struct ibmvfc_event *evt, *temp;
> +	unsigned long flags;
> +	int done = 0;
> +	LIST_HEAD(evt_doneq);
> +
> +	ENTER;
> +
> +	spin_lock_irqsave(scrq->q_lock, flags);
> +	while (!done) {
> +		while ((crq = ibmvfc_next_scrq(scrq)) != NULL) {
> +			ibmvfc_handle_asyncq(crq, scrq->vhost, &evt_doneq);
> +			crq->valid = 0;
> +			wmb();
> +		}
> +
> +		ibmvfc_toggle_scrq_irq(scrq, 1);
> +		crq = ibmvfc_next_scrq(scrq);
> +		if (crq != NULL) {
> +			ibmvfc_toggle_scrq_irq(scrq, 0);
> +			ibmvfc_handle_asyncq(crq, scrq->vhost, &evt_doneq);
> +			crq->valid = 0;
> +			wmb();
> +		} else
> +			done = 1;
> +	}
> +	spin_unlock_irqrestore(scrq->q_lock, flags);
> +
> +	list_for_each_entry_safe(evt, temp, &evt_doneq, queue_list) {
> +		timer_delete(&evt->timer);
> +		list_del(&evt->queue_list);
> +		ibmvfc_trc_end(evt);
> +		evt->done(evt);
> +	}
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
> @@ -5316,6 +5535,8 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
>  			for (i = 0; i < active_queues; i++)
>  				scrqs->scrqs[i].vios_cookie =
>  					be64_to_cpu(setup->channel_handles[i]);
> +			scrqs->async_scrq->vios_cookie =
> +				be64_to_cpu(setup->asyncSubqHandle);
>  
>  			ibmvfc_dbg(vhost, "Using %u channels\n",
>  				   vhost->scsi_scrqs.active_queues);
> @@ -5366,6 +5587,7 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
>  		setup_buf->num_scsi_subq_channels = cpu_to_be32(num_channels);
>  		for (i = 0; i < num_channels; i++)
>  			setup_buf->channel_handles[i] = cpu_to_be64(scrqs->scrqs[i].cookie);
> +		setup_buf->asyncSubqHandle = cpu_to_be64(scrqs->async_scrq->cookie);
>  	}
>  
>  	ibmvfc_init_event(evt, ibmvfc_channel_setup_done, IBMVFC_MAD_FORMAT);
> @@ -5461,6 +5683,8 @@ static void ibmvfc_npiv_login_done(struct ibmvfc_event *evt)
>  	unsigned int npiv_max_sectors;
>  	int level = IBMVFC_DEFAULT_LOG_LEVEL;
>  
> +	ENTER;
> +
>  	switch (mad_status) {
>  	case IBMVFC_MAD_SUCCESS:
>  		ibmvfc_free_event(evt);
> @@ -5540,6 +5764,8 @@ static void ibmvfc_npiv_login_done(struct ibmvfc_event *evt)
>  		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
>  		wake_up(&vhost->work_wait_q);
>  	}
> +
> +	LEAVE;
>  }
>  
>  /**
> @@ -6188,14 +6414,26 @@ static int ibmvfc_init_crq(struct ibmvfc_host *vhost)
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
> @@ -6214,20 +6452,23 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
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
> @@ -6238,12 +6479,14 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
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
> +	if (scrq >= channels->scrqs && scrq < channels->scrqs + channels->active_queues)
> +		scrq->hwq_id = scrq - channels->scrqs;
>  
>  	LEAVE;
>  	return 0;
> @@ -6257,13 +6500,21 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
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
> @@ -6278,7 +6529,8 @@ static void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
>  	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
>  
>  	if (rc)
> -		dev_err(dev, "Failed to free sub-crq[%d]: rc=%ld\n", index, rc);
> +		dev_err(dev, "Failed to free sub-crq[%s]: rc=%ld\n",
> +			ibmvfc_channel_index(channels, scrq, buf, sizeof(buf)), rc);
>  
>  	/* Clean out the queue */
>  	memset(scrq->msgs.crq, 0, PAGE_SIZE);
> @@ -6296,10 +6548,19 @@ static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
>  	if (!vhost->mq_enabled || !channels->scrqs)
>  		return;
>  
> +	if (ibmvfc_register_channel_handler(vhost, channels,
> +					    channels->async_scrq,
> +					    ibmvfc_interrupt_asyncq))
> +		return;
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
> @@ -6318,7 +6579,8 @@ static void ibmvfc_dereg_sub_crqs(struct ibmvfc_host *vhost,
>  		return;
>  
>  	for (i = 0; i < channels->max_queues; i++)
> -		ibmvfc_deregister_channel(vhost, channels, i);
> +		ibmvfc_deregister_channel(vhost, channels, &channels->scrqs[i]);
> +	ibmvfc_deregister_channel(vhost, channels, channels->async_scrq);
>  
>  	LEAVE;
>  }
> @@ -6334,6 +6596,21 @@ static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
>  	if (!channels->scrqs)
>  		return -ENOMEM;
>  
> +	channels->async_scrq = kzalloc_obj(*channels->async_scrq, GFP_KERNEL);
> +
> +	if (!channels->async_scrq) {
> +		kfree(channels->scrqs);
> +		return -ENOMEM;
> +	}
> +
> +	rc = ibmvfc_alloc_queue(vhost, channels->async_scrq,
> +				IBMVFC_SUB_CRQ_FMT);
> +	if (rc) {
> +		kfree(channels->scrqs);
> +		kfree(channels->async_scrq);
> +		return rc;
> +	}
> +
>  	for (i = 0; i < channels->max_queues; i++) {
>  		scrq = &channels->scrqs[i];
>  		rc = ibmvfc_alloc_queue(vhost, scrq, IBMVFC_SUB_CRQ_FMT);
> @@ -6345,6 +6622,9 @@ static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
>  			kfree(channels->scrqs);
>  			channels->scrqs = NULL;
>  			channels->active_queues = 0;
> +			ibmvfc_free_queue(vhost, channels->async_scrq);
> +			kfree(channels->async_scrq);
> +			channels->async_scrq = NULL;
>  			return rc;
>  		}
>  	}
> @@ -6629,6 +6909,7 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
>  	vhost->using_channels = 0;
>  	vhost->do_enquiry = 1;
>  	vhost->scan_timeout = 0;
> +	vhost->login_cap_index = 0;
>  
>  	strcpy(vhost->partition_name, "UNKNOWN");
>  	init_waitqueue_head(&vhost->work_wait_q);
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
> index 4f680c5d9558..b9f22613d144 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.h
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.h
> @@ -182,6 +182,9 @@ struct ibmvfc_npiv_login {
>  #define IBMVFC_CAN_HANDLE_FPIN		0x04
>  #define IBMVFC_CAN_USE_MAD_VERSION	0x08
>  #define IBMVFC_CAN_SEND_VF_WWPN		0x10
> +#define IBMVFC_YES_NVMEOF		0x20
> +#define IBMVFC_YES_SCSI			0x40
> +#define IBMVFC_USE_ASYNC_SUBQ		0x100
>  #define IBMVFC_CAN_USE_NOOP_CMD		0x200
>  	__be64 node_name;
>  	struct srp_direct_buf async;
> @@ -231,6 +234,7 @@ struct ibmvfc_npiv_login_resp {
>  #define IBMVFC_CAN_SUPPORT_CHANNELS	0x80
>  #define IBMVFC_SUPPORT_NVMEOF		0x100
>  #define IBMVFC_SUPPORT_SCSI		0x200
> +#define IBMVFC_SUPPORT_ASYNC_SUBQ	0x800
>  #define IBMVFC_SUPPORT_NOOP_CMD		0x1000
>  	__be32 max_cmds;
>  	__be32 scsi_id_sz;
> @@ -565,7 +569,7 @@ struct ibmvfc_channel_setup_mad {
>  	struct srp_direct_buf buffer;
>  } __packed __aligned(8);
>  
> -#define IBMVFC_MAX_CHANNELS	502
> +#define IBMVFC_MAX_CHANNELS	501
>  
>  struct ibmvfc_channel_setup {
>  	__be32 flags;
> @@ -580,6 +584,7 @@ struct ibmvfc_channel_setup {
>  	struct srp_direct_buf buffer;
>  	__be64 reserved2[5];
>  	__be64 channel_handles[IBMVFC_MAX_CHANNELS];
> +	__be64 asyncSubqHandle;
>  } __packed __aligned(8);
>  
>  struct ibmvfc_connection_info {
> @@ -710,6 +715,25 @@ struct ibmvfc_async_crq {
>  	__be64 reserved;
>  } __packed __aligned(8);
>  
> +struct ibmvfc_async_subq {
> +	volatile u8 valid;
> +#define IBMVFC_ASYNC_ID_IS_ASSOC_ID	0x01
> +#define IBMVFC_FC_EEH			0x04
> +#define IBMVFC_FC_FW_UPDATE		0x08
> +#define IBMVFC_FC_FW_DUMP		0x10
> +	u8 flags;
> +	u8 link_state;
> +	u8 fpin_status;
> +	__be16 event;
> +	__be16 pad;
> +	volatile __be64 wwpn;
> +	volatile __be64 nport_id;
> +	union {
> +		__be64 node_name;
> +		__be64 assoc_id;
> +	} id;
> +} __packed __aligned(8);
> +
>  union ibmvfc_iu {
>  	struct ibmvfc_mad_common mad_common;
>  	struct ibmvfc_npiv_login_mad npiv_login;
> @@ -849,6 +873,7 @@ struct ibmvfc_queue {
>  
>  struct ibmvfc_channels {
>  	struct ibmvfc_queue *scrqs;
> +	struct ibmvfc_queue *async_scrq;
>  	enum ibmvfc_protocol protocol;
>  	unsigned int active_queues;
>  	unsigned int desired_queues;
> @@ -989,6 +1014,8 @@ static inline int ibmvfc_check_caps(struct ibmvfc_host *vhost, unsigned long cap
>  
>  #ifdef VISIBLE_IF_KUNIT
>  VISIBLE_IF_KUNIT void ibmvfc_handle_async(struct ibmvfc_async_crq *crq, struct ibmvfc_host *vhost);
> +VISIBLE_IF_KUNIT void ibmvfc_handle_asyncq(struct ibmvfc_crq *crq_instance,
> +					   struct ibmvfc_host *vhost, struct list_head *evt_doneq);
>  VISIBLE_IF_KUNIT struct list_head *ibmvfc_get_headp(void);
>  VISIBLE_IF_KUNIT void ibmvfc_handle_crq(struct ibmvfc_crq *crq,
>  					struct ibmvfc_host *vhost,
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
> index 3359e4ebebe2..3a41127c4e81 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
> @@ -22,14 +22,14 @@ MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
>  static void ibmvfc_handle_fpin_event_test(struct kunit *test)
>  {
>  	u64 *stats[IBMVFC_AE_FPIN_CONGESTION_CLEARED + 1] = { NULL };
> -	u64 post[IBMVFC_AE_FPIN_CONGESTION_CLEARED + 1];
> -	u64 pre[IBMVFC_AE_FPIN_CONGESTION_CLEARED + 1];
>  	enum ibmvfc_ae_fpin_status fs;
> -	struct ibmvfc_async_crq crq;
> +	struct ibmvfc_async_subq crq;
>  	struct ibmvfc_target *tgt;
>  	struct ibmvfc_host *vhost;
>  	struct list_head *queue;
>  	struct list_head *headp;
> +	LIST_HEAD(evt_doneq);
> +	u64 pre, post;
>  
>  
>  	headp = ibmvfc_get_headp();
> @@ -52,31 +52,23 @@ static void ibmvfc_handle_fpin_event_test(struct kunit *test)
>  		crq.valid = 0x80;
>  		crq.link_state = IBMVFC_AE_LS_LINK_UP;
>  		crq.fpin_status = fs;
> -		crq.event = cpu_to_be64(IBMVFC_AE_FPIN);
> -		crq.scsi_id = cpu_to_be64(tgt->scsi_id);
> +		crq.event = cpu_to_be16(IBMVFC_AE_FPIN);
>  		crq.wwpn = cpu_to_be64(tgt->wwpn);
> -		crq.node_name = cpu_to_be64(tgt->ids.node_name);
> -		pre[fs] = *stats[fs];
> -		ibmvfc_handle_async(&crq, vhost);
> -		post[fs] = *stats[fs];
> -		KUNIT_EXPECT_EQ(test, post[fs], pre[fs]+1);
> +		crq.id.node_name = cpu_to_be64(tgt->ids.node_name);
> +		pre = *stats[fs];
> +		ibmvfc_handle_asyncq((struct ibmvfc_crq *)&crq, vhost, &evt_doneq);
> +		post = *stats[fs];
> +		KUNIT_EXPECT_EQ(test, post, pre+1);
>  	}
>  
>  	/* bad path */
> -	for (fs = IBMVFC_AE_FPIN_LINK_CONGESTED; fs <= IBMVFC_AE_FPIN_CONGESTION_CLEARED; fs++)
> -		pre[fs] = *stats[fs];
>  	crq.valid = 0x80;
>  	crq.link_state = IBMVFC_AE_LS_LINK_UP;
>  	crq.fpin_status = 0; /* bad value */
> -	crq.event = cpu_to_be64(IBMVFC_AE_FPIN);
> -	crq.scsi_id = cpu_to_be64(tgt->scsi_id);
> +	crq.event = cpu_to_be16(IBMVFC_AE_FPIN);
>  	crq.wwpn = cpu_to_be64(tgt->wwpn);
> -	crq.node_name = cpu_to_be64(tgt->ids.node_name);
> -	ibmvfc_handle_async(&crq, vhost);
> -	for (fs = IBMVFC_AE_FPIN_LINK_CONGESTED; fs <= IBMVFC_AE_FPIN_CONGESTION_CLEARED; fs++) {
> -		post[fs] = *stats[fs];
> -		KUNIT_EXPECT_EQ(test, pre[fs], post[fs]);
> -	}
> +	crq.id.node_name = cpu_to_be64(tgt->ids.node_name);
> +	ibmvfc_handle_asyncq((struct ibmvfc_crq *)&crq, vhost, &evt_doneq);
>  }
>  
>  /**
> @@ -105,9 +97,29 @@ static void ibmvfc_noop_test(struct kunit *test)
>  	ibmvfc_handle_crq(&crq, vhost, &evtq);
>  }
>  
> +/**
> + * ibmvfc_async_subq_test - unit test for allocating async subqueue
> + * @test: pointer to kunit structure
> + *
> + * Return: void
> + */
> +static void ibmvfc_async_subq_test(struct kunit *test)
> +{
> +	struct ibmvfc_host *vhost;
> +	struct list_head *queue;
> +	struct list_head *headp;
> +
> +	headp = ibmvfc_get_headp();
> +	queue = headp->next;
> +	vhost = container_of(queue, struct ibmvfc_host, queue);
> +
> +	KUNIT_EXPECT_NOT_NULL(test, vhost->scsi_scrqs.async_scrq);
> +}
> +
>  static struct kunit_case ibmvfc_fpin_test_cases[] = {
>  	KUNIT_CASE(ibmvfc_handle_fpin_event_test),
>  	KUNIT_CASE(ibmvfc_noop_test),
> +	KUNIT_CASE(ibmvfc_async_subq_test),
>  	{},
>  };
>  
> 

