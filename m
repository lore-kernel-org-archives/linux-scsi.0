Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7398F351C14;
	Mon, 15 Jun 2026 23:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781566747; cv=none; b=FclSz5EOF0744prwMgqtzyIQdAXVRKrvZUDoPNJ2B1ho7267RQih9YnP0xpTxt0H0KpdlCtFHEkvpBr8ptljAA3GWfb1cHm4OKDnBZMYh2dyQKm+AmLIga9X3rCwLxU1fWrkqrHIdpYQkCouFwJE5temn7tU/6WCWn4JVYQR+YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781566747; c=relaxed/simple;
	bh=utQghqaGwtnZTc16b1knCLqmOAQDhQPdpG+/pTqVvLA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Oo/wQN/xJPnaEHxXVDGFT3WwsZMUAXgnyQBD3g3/cSy2wiRyF+qbNJH530FtfmFRmq+mOAM0FcIDWxPIz3C287uhL9NyczTZJ6GHbBdp7ftSMxyEOHCVWWwXardKczZK49Fe3N16BEdauajxYjDKD4TWS+8/5YHQcV0mx7iktTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PVg4a7Fa; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PVg4a7Fa"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65FJId9I3298917;
	Mon, 15 Jun 2026 23:38:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=9G1G5p
	3Mjpy73mUIM1wPOpn0HFz/jSQrDQcJyJ2h4UM=; b=PVg4a7Fa90sd3djCN5n0RO
	D8T0fgB5jQUWBCcFZdE0TL8JPAGKUTRCnpNmSqqZhpKilMquZqxgq3LPBXvcHGe7
	0K13sTmMQnfFcYHPb3svNawCrQA3VVI4VKJePFUqcYuSsM3QU9vKmlTZvpGeurmg
	xz3/kzCbX9VPeAFpiRAf85WQSteHvoqy5iPAu8OJHI47v0J95vmHLYsj16gz2iV3
	FX1/K0q+jgZUSihSJy0OaukQGDcluA6JXDiorO05bqefllrU9W5NCOLZbfRAkdqf
	HGBB+vWRYePRyQH6xct2gtxzmpbZ/h4j4rIFi1sXmOHFsK+ybzuiEghnXR71McTg
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4es1wm31t0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jun 2026 23:38:50 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65FNYtIl013047;
	Mon, 15 Jun 2026 23:38:50 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4eshhq10k9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jun 2026 23:38:50 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65FNcmiZ58392938
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Jun 2026 23:38:48 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3D23658055;
	Mon, 15 Jun 2026 23:38:48 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 56E9658043;
	Mon, 15 Jun 2026 23:38:47 +0000 (GMT)
Received: from [9.61.95.246] (unknown [9.61.95.246])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 15 Jun 2026 23:38:47 +0000 (GMT)
Message-ID: <000d3218-e3e0-4938-ae61-6de934ab6b61@linux.ibm.com>
Date: Mon, 15 Jun 2026 16:38:46 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/7] ibmvfc: add basic FPIN support
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
 <20260608-ibmvfc-fpin-support-v2-1-d41f540fba5c@linux.ibm.com>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <20260608-ibmvfc-fpin-support-v2-1-d41f540fba5c@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDI0NyBTYWx0ZWRfX31C4UGHbiZfm
 FtiZYbiOrcsV+wGuWwN91gziQbtFEdFHnAXWpQTlzeOSLSdnKkXx0UKJA50EstugIOuB9J1nTw6
 CHNh3yGKqTUjRPn9eI74ovU62TunjgE=
X-Proofpoint-GUID: 22s4p51MHvp5Ir0EQm5GWMDFGdTv9nHZ
X-Authority-Analysis: v=2.4 cv=SY/HsPRu c=1 sm=1 tr=0 ts=6a308d0b cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=uM-v_zyAtFk4-nL5UfUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDI0NyBTYWx0ZWRfX8kVRyXaz/Wag
 Cpyjbfy7VTHGd7yK9YfYvkLjujIrWTEbNL9Cui20UYy0jzW/QV8CzXhauH6Xeb7dwUQa+4Ai7Z+
 ySvS4+jfhkdi55yewfNCpmMycqddjBJnKkLiRB5ExIsBKo/o27V4zZGXImVtMhLAKOX8UmeB2uD
 8wjgCmVVkAnp7EUBqU4XxeH7cWn5ep53GSMz+xm2pIBd6fkfrwNQJhsBOmSaTesdzog5hWHXiCP
 d4fEXoT6dbCbnbALcEhkEoNGutrfPi7enl8xlMhUUVF0B24T4KkLG12lYgnn3aqmT5UJnlbNkmz
 vPpNuf3dISvKOw/8laX1Z0Zzz8vgY9lytdRj4vFOvt4a4DPtFcNDFI5E/eG8zXxbHunROZUpGJF
 j60xSmccEx6PjFPWTcezd1vZL0+yIRy8JvOct30qgLaj9MEJOiy31TbAht1/Fb7JFMBauesCdkm
 No9dfFWpgg1MdvHn6iA==
X-Proofpoint-ORIG-GUID: 0jta4F-yQVrMQ5WhpVfM_oH5zJbfFbDs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_05,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 phishscore=0 suspectscore=0 spamscore=0 impostorscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606040000
 definitions=main-2606150247

On 6/8/26 11:30 AM, Dave Marquardt via B4 Relay wrote:
> From: Dave Marquardt <davemarq@linux.ibm.com>
> 
> Add support for basic FPIN messages to the ibmvfc driver. This includes
> 
> - adding FPIN handling support to the async event handler
> - offloading processing of FPIN messages to a work queue
> - converting the VIOS FPIN message to a struct fc_els_fpin as used by
>   the Linux kernel
> - passing the converted struct fc_els_fpin to fc_host_fpin_rcv for
>   processing
> 
> The FPIN message conversion routines include a common routine that
> will also be used in patches 6 and 7, which add full and extended FPIN
> support.
> ---
>  drivers/scsi/Kconfig                 |  10 ++
>  drivers/scsi/ibmvscsi/Makefile       |   1 +
>  drivers/scsi/ibmvscsi/ibmvfc.c       | 226 ++++++++++++++++++++++++++++++++++-
>  drivers/scsi/ibmvscsi/ibmvfc.h       |  15 +++
>  drivers/scsi/ibmvscsi/ibmvfc_kunit.c | 131 ++++++++++++++++++++
>  5 files changed, 379 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index c3042393af23..d5fc7eb2ebb1 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -758,6 +758,16 @@ config SCSI_IBMVFC
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called ibmvfc.
>  
> +config SCSI_IBMVFC_KUNIT_TEST
> +	tristate "KUnit tests for the IBM POWER Virtual FC Client" if !KUNIT_ALL_TESTS
> +	depends on SCSI_IBMVFC && KUNIT
> +	default KUNIT_ALL_TESTS
> +	help
> +	  Compile IBM POWER Virtual FC client KUnit tests. These tests
> +	  specifically test FPIN functionality. To compile this driver
> +	  as a module, choose M here: the module will be called
> +	  ibmvfc_kunit.
> +
>  config SCSI_IBMVFC_TRACE
>  	bool "enable driver internal trace"
>  	depends on SCSI_IBMVFC
> diff --git a/drivers/scsi/ibmvscsi/Makefile b/drivers/scsi/ibmvscsi/Makefile
> index 5eb1cb1a0028..75dc7aee15a0 100644
> --- a/drivers/scsi/ibmvscsi/Makefile
> +++ b/drivers/scsi/ibmvscsi/Makefile
> @@ -1,3 +1,4 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  obj-$(CONFIG_SCSI_IBMVSCSI)	+= ibmvscsi.o
>  obj-$(CONFIG_SCSI_IBMVFC)	+= ibmvfc.o
> +obj-$(CONFIG_SCSI_IBMVFC_KUNIT_TEST)	+= ibmvfc_kunit.o
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index 3dd2adda195e..9e5f0c0f0369 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -30,6 +30,9 @@
>  #include <scsi/scsi_tcq.h>
>  #include <scsi/scsi_transport_fc.h>
>  #include <scsi/scsi_bsg_fc.h>
> +#include <kunit/visibility.h>
> +#include <scsi/fc/fc_els.h>
> +#include <linux/overflow.h>
>  #include "ibmvfc.h"
>  
>  static unsigned int init_timeout = IBMVFC_INIT_TIMEOUT;
> @@ -3137,6 +3140,7 @@ static const struct ibmvfc_async_desc ae_desc [] = {
>  	{ "Halt",	IBMVFC_AE_HALT,		IBMVFC_DEFAULT_LOG_LEVEL },
>  	{ "Resume",	IBMVFC_AE_RESUME,	IBMVFC_DEFAULT_LOG_LEVEL },
>  	{ "Adapter Failed", IBMVFC_AE_ADAPTER_FAILED, IBMVFC_DEFAULT_LOG_LEVEL },
> +	{ "FPIN",	IBMVFC_AE_FPIN,		IBMVFC_DEFAULT_LOG_LEVEL },
>  };
>  
>  static const struct ibmvfc_async_desc unknown_ae = {
> @@ -3185,17 +3189,211 @@ static const char *ibmvfc_get_link_state(enum ibmvfc_ae_link_state state)
>  	return "";
>  }
>  
> +#define IBMVFC_FPIN_CONGN_DESC_SZ (sizeof(struct fc_els_fpin) + sizeof(struct fc_fn_congn_desc))
> +#define IBMVFC_FPIN_LI_DESC_SZ (sizeof(struct fc_els_fpin) + \
> +				struct_size_t(struct fc_fn_li_desc, pname_list, 1))
> +#define IBMVFC_FPIN_PEER_CONGN_DESC_SZ (sizeof(struct fc_els_fpin) + \
> +					struct_size_t(struct fc_fn_peer_congn_desc, pname_list, 1))
> +
> +/**
> + * ibmvfc_fpin_size_helper(): compute fpin structure size based on fpin status
> + * @fpin_status: status value
> + *
> + * Return:
> + * 0: invalid fpin_status
> + * other: valid size
> + */
> +static size_t ibmvfc_fpin_size_helper(u8 fpin_status)
> +{
> +	size_t size = 0;
> +
> +	switch (fpin_status) {
> +	case IBMVFC_AE_FPIN_LINK_CONGESTED:
> +	case IBMVFC_AE_FPIN_CONGESTION_CLEARED:
> +		size = IBMVFC_FPIN_CONGN_DESC_SZ;
> +		break;
> +	case IBMVFC_AE_FPIN_PORT_CONGESTED:
> +	case IBMVFC_AE_FPIN_PORT_CLEARED:
> +		size = IBMVFC_FPIN_PEER_CONGN_DESC_SZ;
> +		break;
> +	case IBMVFC_AE_FPIN_PORT_DEGRADED:
> +		size = IBMVFC_FPIN_LI_DESC_SZ;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return size;
> +}
> +
> +/**
> + * ibmvfc_common_fpin_to_desc(): allocate and populate a struct fc_els_fpin struct
> + * containing a descriptor.
> + *
> + * Allocate a struct fc_els_fpin containing a descriptor and populate
> + * based on data from *ibmvfc_fpin.
> + *
> + * Return:
> + * NULL     - unable to allocate structure
> + * non-NULL - pointer to populated struct fc_els_fpin
> + */
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
> +		fpin->desc_len =
> +			cpu_to_be32(struct_size_t(struct fc_fn_peer_congn_desc, pname_list, 1));
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
> +		fpin->desc_len = cpu_to_be32(struct_size_t(struct fc_fn_li_desc, pname_list, 1));
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
> +ibmvfc_basic_fpin_to_desc(struct ibmvfc_async_crq *crq, u64 wwpn)
> +{
> +	return ibmvfc_common_fpin_to_desc(crq->fpin_status, cpu_to_be64(wwpn),
> +					  cpu_to_be16(0),
> +					  cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_PERIOD),
> +					  cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_THRESHOLD),
> +					  cpu_to_be32(1));
> +}
> +
> +/**
> + * ibmvfc_process_async_work - Process IBMVFC_AE_FPIN async CRQ from work queue
> + * @work: pointer to work_struct
> + */
> +static void ibmvfc_process_async_work(struct work_struct *work)
> +{
> +	struct ibmvfc_async_work *aw;
> +	struct ibmvfc_async_crq *crq;
> +	struct ibmvfc_target *tgt;
> +	struct ibmvfc_host *vhost;
> +	struct fc_els_fpin *fpin;
> +
> +	aw = container_of(work, struct ibmvfc_async_work, async_work_s);
> +	crq = aw->crq;
> +	vhost = aw->vhost;
> +
> +	if (!crq->scsi_id && !crq->wwpn && !crq->node_name)
> +		goto end;
> +	list_for_each_entry(tgt, &vhost->targets, queue) {
> +		if (crq->scsi_id && cpu_to_be64(tgt->scsi_id) != crq->scsi_id)
> +			continue;
> +		if (crq->wwpn && cpu_to_be64(tgt->ids.port_name) != crq->wwpn)
> +			continue;
> +		if (crq->node_name && cpu_to_be64(tgt->ids.node_name) != crq->node_name)
> +			continue;
> +		if (!tgt->rport)
> +			continue;
> +		fpin = ibmvfc_basic_fpin_to_desc(crq, tgt->wwpn);
> +		if (fpin) {
> +			fc_host_fpin_rcv(tgt->vhost->host,
> +					 sizeof(*fpin) + be32_to_cpu(fpin->desc_len),
> +					 (char *)fpin, 0);
> +			kfree(fpin);
> +		} else
> +			dev_err_ratelimited(vhost->dev,
> +					    "FPIN event %u received, unable to process\n",
> +					    crq->fpin_status);
> +	}
> +
> + end:
> +	crq->valid = 0;


I've been mulling this over since last week and I'm inclined to agree with the
sashiko analysis as well that clearing this asynchrously is not ideal. I think
it's better to make a copy of the crq entry and pass the copy instead of a
pointer to the data in our actual ring buffer.

-Tyrel


