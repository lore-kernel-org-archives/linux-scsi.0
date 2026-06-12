Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B77367291;
	Fri, 12 Jun 2026 22:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781303743; cv=none; b=UEwk01v1lT14OsWRoBKJ6c/gkZj42qaLyFhwF3wy5X6UviKNb0bKFwUIxz0GwslvM3gitTDqIV8FOnAAgBWkytjR4sAUvQzuEiNGxTMGgcoBCROMFz7vdxoaG72bI6u5ODLilxlcePlmRp8qm1diPxEi1zVyjO/pcCmpUYPQMXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781303743; c=relaxed/simple;
	bh=M0Pe8sbx9o2tQ3ZQLPVz8FPYPXvCLqtWZ+bFCuvH0FA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r9fczRjxvkdVpf0n3tlnyFCldto9iXXj94Qo+YcZ0xfq7oLdl+IhKGdHYxxyKIjnDajZZPB+wPoUO4+F0eEjJe/B0Bc1aB/5m6yKItqtHntRe8O70k5u8zQdKqRRfVntu46OfnTZ4cyMWS2sqv0sPQ4kpPc/HjWYMN3V2pXWlMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=i1ZZ7969; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="i1ZZ7969"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65CCtGjI3872955;
	Fri, 12 Jun 2026 22:35:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=tcozaS
	NDxW287Z2KI+BjjJnFriV5XYqdoKxv9KEBfjs=; b=i1ZZ7969zhe5HD+UxnzS6Q
	IW7bJYEWdTZdvVy5LMsJXnlldiN5s+7cMUx35f5awVxm6kO1zoC1xLTnYNGmCkAm
	bSdifScmh8tPMll3wVz6po6CTlddaR4Xh+1NDORlcQNChhSAsBYcHqxENtWlN18H
	E+asoNIbZ2utc302Tr0SGoXM6Mf99TCWdVUrCdCoQjo4OyXyu41xuk0HDmcYGCgZ
	Cx9fp87a8NtwGeABsGWvnhaNq6NFaZ9P9ifW8JN2ox2DJddIQMGww3gZKPnzSZsu
	w5HbcIEgWP9jBcOw6dILzF7G+5ZOnSy1/lOE+pgwvIJ10NwgBAnhCLeiJpsJciDA
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4eqe8f39vq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 22:35:21 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65CMYarW003327;
	Fri, 12 Jun 2026 22:35:20 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4eqe0a9xfe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 22:35:20 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65CMZJ0G25625122
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Jun 2026 22:35:19 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2102B58068;
	Fri, 12 Jun 2026 22:35:19 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C50965803F;
	Fri, 12 Jun 2026 22:35:17 +0000 (GMT)
Received: from [9.61.160.241] (unknown [9.61.160.241])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 12 Jun 2026 22:35:17 +0000 (GMT)
Message-ID: <d99205f7-8467-4918-8102-4b84620fd0ff@linux.ibm.com>
Date: Fri, 12 Jun 2026 15:35:17 -0700
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDIxMCBTYWx0ZWRfX1HnA7gSHOoKi
 GdBnvYZ6HX5g4P0l0sYtw+57QXozaxobkNHLz2EMD+3G9eS9yXyjHZjeQIm37Sidp/ubEfncKHf
 i9AZ5/goll4WnVkNvf/R6rmjCfo6YyQE5m4c6KuATBUqlTA+nDnSwJMFF1QBjYpLU+nf2ofebUS
 691qm4DMQZjkB0twUue8L2GGe2QdwEiSMjD2UIf0qb9NbWhqUNulkJ81CWDZqSR2igyUnz/G0Y1
 n4fa4GcueECCfayTVHcCL2jBKGtXY9NmxbC5IS2PxE77VK95nkxOyUs9VkvArte9MHOmECaPL3w
 fWhnJQjwAI8Jg5rJGeuTJiawzTR04ECLWkKRoXqmAvprwnZE2x9AP7rDiwe3oaJs2f+piiTkeBQ
 +TcF7HTcwvUXCruXtEYU6xSH80L+fZKmmCG3JdwWNsCB5gZnbMuQd+cJietg8eWzGQdaH8Pi2DX
 0O3+O37U0qTJGccNdOg==
X-Authority-Analysis: v=2.4 cv=dr7rzVg4 c=1 sm=1 tr=0 ts=6a2c89aa cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=x49wV4nTLdBlH4IQi7IA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: m0Dn58y3kFfRlbOQFJBom6gv6POwOqU1
X-Proofpoint-GUID: ToOt9YvdzwHDg0Le4IXAbOfSFHrlv3eb
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDIxMCBTYWx0ZWRfX1OXbErOJ4bCz
 RM4St7Lw51+cZmbL1PLVbakNTBL9ul7Z1lP2l0upSWWcYw/aoZLiKYVuBj8z/XLac8DDDJDO2Dc
 jAGEi8OrfeZOr58bNzbVWYMKCvZW6fY=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_03,2026-06-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 bulkscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606120210

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

You are missing a Signed-off-by tag here.

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

To be consistent with other places in the driver !size instead of size == 0 check.

> +		return NULL;
> +
> +	fpin = kzalloc(size, GFP_KERNEL);
> +	if (fpin == NULL)

Same nit here !fpin instead of fpin == NULL.

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

While not wrong 0 is 0 regardless of endianiess. Is this value always going to
be zero here or is this place holder code that changes later in this patchset?
If its the case this isn't a place holder the original fpin struct was allocated
with kzalloc so this value should be zero already.

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

Same comment as above.

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

Should we be holding the host lock when iterateing targets?

-Tyrel
