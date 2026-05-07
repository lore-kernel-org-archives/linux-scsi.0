Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D94115B998;
	Thu,  7 May 2026 05:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778132905; cv=none; b=YB1WHS3/yDWYecgAwk+7tbxHrd/2UXvI+EFpjKgHXDEHL9+fsFyPsWO6in+ES/CDzphD+Ei9dmkumrIhfzt+hyqjxORrTR78Ifhb+/n/MX4bGqtEt9D+BvrdoQrVjN2E3YC5jWigW6DzJnxjvRZrjF4j0vPcSGpZd+Aq9psrfLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778132905; c=relaxed/simple;
	bh=7xveS67MU5Bpp+BproZKTWuXL/2pXFZ68Pgjhv1BLrc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CeVvdxSqWd4CaI3pHOR5S3B2ck1lck4eBNn4HW0v+nPfgdh4ZWgveKr5BuFhjSHpYl4VUS2sdO/8sEe0I0y6V/5ZW6m0ocAXjloTbAMDzcUS6W5+krV88jynDae7roVwbY0HcJuYyRzwffJBFusNrYHCn6XLy1wy0YQRgat9NFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LpMlg6TO; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LpMlg6TO"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 646MDcvv2830434;
	Thu, 7 May 2026 05:48:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=4tWIA8
	xuaJnClSLpoasW8KjkZq2qvXLMSSpCdK+pegk=; b=LpMlg6TOz9ovcxeI2qIsHM
	jrRtyPTCzbWoS3qC0k5/+Yua4tVeHu+P/F1qNAdj8thwgPmHFdFjYx/8hjitXHUZ
	d8QMB0YItFHYqagqJ/cp1dPbUOknta2Wi1GehTZ405VxNkx44vGrsjpf6uxpPzcm
	BDmahsiraPadumfdWofAKZ16tvm2qTYq5EtUEVVbjQ31kGJV3GCu2iNdbUXCQbdv
	tPkIHDC7HC3hh4XQCI54majcKbWT6a3zRf20AZpToUnROyJfBgAq6Hxn1xPLUWEW
	1DCTuZe/QWVuSMU9Xjm4IolLcP6J3CtOkxdO7L9myHa2vgiLyfpFa15O3dVJ0efA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9v7meq4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 May 2026 05:48:11 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6475dQfc004744;
	Thu, 7 May 2026 05:48:10 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dwuyw9q4g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 May 2026 05:48:10 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6475m9Rs27067078
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 7 May 2026 05:48:09 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2C5F25805D;
	Thu,  7 May 2026 05:48:09 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 62FE258052;
	Thu,  7 May 2026 05:48:08 +0000 (GMT)
Received: from [9.61.92.155] (unknown [9.61.92.155])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  7 May 2026 05:48:08 +0000 (GMT)
Message-ID: <8ac414a6-b4e9-4fd9-b316-3738b3229664@linux.ibm.com>
Date: Wed, 6 May 2026 22:48:08 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] ibmvfc: handle extended FPIN events
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
 <20260408-ibmvfc-fpin-support-v1-5-52b06c464e03@linux.ibm.com>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <20260408-ibmvfc-fpin-support-v1-5-52b06c464e03@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA3MDA1MiBTYWx0ZWRfX27OO9E9U6ENw
 uLpqPKsBTltXd6jwpIJ1uFx6r5IH6YOH0l3op7D8sS8ZOwF5Dd3bRqz3dgQ4LMhM9jMJRupD1H1
 O9KYJE8gPQ6qdI1zLNnDjJS012Q+v6fkaPweiSkOInG0pfyziyPD4WQ7yTJFRwsorSSNxiqTXAq
 OpJmvSNsL7eAx1ywTFbcyamAW1BN4T4P2dka3QDtnbJE1eK3tqDN9sBXKGl6RhW0pF26CZJ7SCO
 3ZK7KnS50HUqUQc1weCgAXkaXtlfYE+MU1mVD5ckrXk0NpB+f1YNaPyy9oei1i9zw/aoBfSIH5U
 NPLO8ll4H+84f1sZ4fhejpEFH3OSG/0Z59TKuCVmJDsqHpw0p8FayWl6ihfDEpQVWNX/gToq6Y3
 QN80rDJ4sP79ui/FRypJ70h7VvilIpJRT6xFklMOTyoyX6/7gdY0TAUYpxhVCAFSD42atMg1zjW
 XmfgLrcvXGcztmUeSBg==
X-Proofpoint-GUID: _dX0RdRjUBecn8PaAQZ4yRLyYCEvdHux
X-Proofpoint-ORIG-GUID: 62PjvF7sY8nWRLQhetO_yuzPZK8kOPQZ
X-Authority-Analysis: v=2.4 cv=eu/vCIpX c=1 sm=1 tr=0 ts=69fc279b cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=EYKLyQfOhh-CJ0WtqnoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-06_02,2026-05-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605070052

On 4/8/26 10:07 AM, Dave Marquardt via B4 Relay wrote:
> From: Dave Marquardt <davemarq@linux.ibm.com>
> 
> - negotiate use of extended FPIN events with NPIV (VIOS)
> - add code to parse and handle extended FPIN events
> - add KUnit test to test extended FPIN event handling

Same nit here as the previous 4 patches.

> ---
>  drivers/scsi/ibmvscsi/ibmvfc.c       | 45 ++++++++++++++---
>  drivers/scsi/ibmvscsi/ibmvfc.h       | 31 ++++++++++++
>  drivers/scsi/ibmvscsi/ibmvfc_kunit.c | 97 +++++++++++++++++++++++++++++++++---
>  3 files changed, 161 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index 26e39b367022..5b2b861a34c2 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -1472,6 +1472,9 @@ static void ibmvfc_gather_partition_info(struct ibmvfc_host *vhost)
>  }
>  
>  static __be64 ibmvfc_npiv_chan_caps[] = {
> +	cpu_to_be64(IBMVFC_CAN_USE_CHANNELS | IBMVFC_USE_ASYNC_SUBQ |
> +		    IBMVFC_YES_SCSI | IBMVFC_CAN_HANDLE_FPIN |
> +		    IBMVFC_CAN_HANDLE_FPIN_EXT),
>  	cpu_to_be64(IBMVFC_CAN_USE_CHANNELS | IBMVFC_USE_ASYNC_SUBQ |
>  		    IBMVFC_YES_SCSI | IBMVFC_CAN_HANDLE_FPIN),
>  	cpu_to_be64(IBMVFC_CAN_USE_CHANNELS),
> @@ -3370,6 +3373,28 @@ ibmvfc_full_fpin_to_desc(struct ibmvfc_async_subq *ibmvfc_fpin)
>  					  cpu_to_be32(1));
>  }
>  
> +/**
> + * ibmvfc_ext_fpin_to_desc(): allocate and populate a struct fc_els_fpin struct
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
> +ibmvfc_ext_fpin_to_desc(struct ibmvfc_async_subq_fpin *ibmvfc_fpin)
> +{
> +	return ibmvfc_common_fpin_to_desc(ibmvfc_fpin->fpin_status, ibmvfc_fpin->wwpn,
> +					  ibmvfc_fpin->fpin_data.event_type_modifier,
> +					  ibmvfc_fpin->fpin_data.event_threshold,
> +					  ibmvfc_fpin->fpin_data.event_threshold,

I see mention of threshold and period previously. Why in this case is it just
the threshold value passed for both?

-Tyrel

> +					  ibmvfc_fpin->fpin_data.event_data.event_count);
> +}
> +
>  /**
>   * ibmvfc_handle_async - Handle an async event from the adapter
>   * @crq:	crq to process
> @@ -3491,10 +3516,12 @@ VISIBLE_IF_KUNIT void ibmvfc_handle_asyncq(struct ibmvfc_crq *crq_instance,
>  					   struct ibmvfc_host *vhost,
>  					   struct list_head *evt_doneq)
>  {
> +	struct ibmvfc_async_subq_fpin *sqfpin = (struct ibmvfc_async_subq_fpin *)crq_instance;
>  	struct ibmvfc_async_subq *crq = (struct ibmvfc_async_subq *)crq_instance;
>  	const struct ibmvfc_async_desc *desc = ibmvfc_get_ae_desc(be16_to_cpu(crq->event));
>  	struct ibmvfc_target *tgt;
>  	struct fc_els_fpin *fpin;
> +	u8 fpin_status;
>  
>  	ibmvfc_log(vhost, desc->log_level,
>  		   "%s event received. wwpn: %llx, node_name: %llx%s event 0x%x\n",
> @@ -3582,7 +3609,17 @@ VISIBLE_IF_KUNIT void ibmvfc_handle_asyncq(struct ibmvfc_crq *crq_instance,
>  				continue;
>  			if (!tgt->rport)
>  				continue;
> -			fpin = ibmvfc_full_fpin_to_desc(crq);
> +			if ((crq->flags & IBMVFC_ASYNC_IS_FPIN_EXT) == 0) {
> +				fpin = ibmvfc_full_fpin_to_desc(crq);
> +				fpin_status = crq->fpin_status;
> +			} else if (!(sqfpin->fpin_data.flags & IBMVFC_FPIN_EVENT_TYPE_VALID))
> +				dev_err(vhost->dev, "Invalid extended FPIN event received");
> +			else if (!ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_FPIN_EXT))
> +				dev_err(vhost->dev, "Unexpected extended FPIN event received");
> +			else {
> +				fpin = ibmvfc_ext_fpin_to_desc(sqfpin);
> +				fpin_status = sqfpin->fpin_status;
> +			}
>  			if (fpin) {
>  				fc_host_fpin_rcv(tgt->vhost->host,
>  						 sizeof(*fpin) + be32_to_cpu(fpin->desc_len),
> @@ -3591,12 +3628,8 @@ VISIBLE_IF_KUNIT void ibmvfc_handle_asyncq(struct ibmvfc_crq *crq_instance,
>  			} else
>  				dev_err(vhost->dev,
>  					"FPIN event %u received, unable to process\n",
> -					crq->fpin_status);
> +					fpin_status);
>  		}
> -		break;
> -	default:
> -		dev_err(vhost->dev, "Unknown async event received: %d\n", crq->event);
> -		break;
>  	}
>  }
>  EXPORT_SYMBOL_IF_KUNIT(ibmvfc_handle_asyncq);
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
> index b9f22613d144..c67db8d7b3fc 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.h
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.h
> @@ -186,6 +186,7 @@ struct ibmvfc_npiv_login {
>  #define IBMVFC_YES_SCSI			0x40
>  #define IBMVFC_USE_ASYNC_SUBQ		0x100
>  #define IBMVFC_CAN_USE_NOOP_CMD		0x200
> +#define IBMVFC_CAN_HANDLE_FPIN_EXT	0x800
>  	__be64 node_name;
>  	struct srp_direct_buf async;
>  	u8 partition_name[IBMVFC_MAX_NAME];
> @@ -236,6 +237,7 @@ struct ibmvfc_npiv_login_resp {
>  #define IBMVFC_SUPPORT_SCSI		0x200
>  #define IBMVFC_SUPPORT_ASYNC_SUBQ	0x800
>  #define IBMVFC_SUPPORT_NOOP_CMD		0x1000
> +#define IBMVFC_SUPPORT_FPIN_EXT		0x2000
>  	__be32 max_cmds;
>  	__be32 scsi_id_sz;
>  	__be64 max_dma_len;
> @@ -718,6 +720,7 @@ struct ibmvfc_async_crq {
>  struct ibmvfc_async_subq {
>  	volatile u8 valid;
>  #define IBMVFC_ASYNC_ID_IS_ASSOC_ID	0x01
> +#define IBMVFC_ASYNC_IS_FPIN_EXT	0x02
>  #define IBMVFC_FC_EEH			0x04
>  #define IBMVFC_FC_FW_UPDATE		0x08
>  #define IBMVFC_FC_FW_DUMP		0x10
> @@ -734,6 +737,34 @@ struct ibmvfc_async_subq {
>  	} id;
>  } __packed __aligned(8);
>  
> +struct ibmvfc_fpin_data {
> +#define IBMVFC_FPIN_EVENT_TYPE_VALID	0x01
> +#define IBMVFC_FPIN_MODIFIER_VALID	0x02
> +#define IBMVFC_FPIN_THRESHOLD_VALID	0x04
> +#define IBMVFC_FPIN_SEVERITY_VALID	0x08
> +#define IBMVFC_FPIN_EVENT_COUNT_VALID	0x10
> +	u8 flags;
> +	u8 reserved[3];
> +	__be16 event_type;
> +	__be16 event_type_modifier;
> +	__be32 event_threshold;
> +	union {
> +		u8 severity;
> +		__be32 event_count;
> +	} event_data;
> +} __packed __aligned(8);
> +
> +struct ibmvfc_async_subq_fpin {
> +	volatile u8 valid;
> +	u8 flags;
> +	u8 link_state;
> +	u8 fpin_status;
> +	__be16 event;
> +	__be16 pad;
> +	volatile __be64 wwpn;
> +	struct ibmvfc_fpin_data fpin_data;
> +} __packed __aligned(8);
> +
>  union ibmvfc_iu {
>  	struct ibmvfc_mad_common mad_common;
>  	struct ibmvfc_npiv_login_mad npiv_login;
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
> index 3a41127c4e81..6c2a7d6f8042 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
> @@ -3,6 +3,7 @@
>  #include <kunit/visibility.h>
>  #include <scsi/scsi_device.h>
>  #include <scsi/scsi_transport_fc.h>
> +#include <scsi/fc/fc_els.h>
>  #include <linux/list.h>
>  #include "ibmvfc.h"
>  
> @@ -71,6 +72,25 @@ static void ibmvfc_handle_fpin_event_test(struct kunit *test)
>  	ibmvfc_handle_asyncq((struct ibmvfc_crq *)&crq, vhost, &evt_doneq);
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
>  /**
>   * ibmvfc_noop_test - unit test for VFC_NOOP command
>   * @test: pointer to kunit structure
> @@ -97,29 +117,94 @@ static void ibmvfc_noop_test(struct kunit *test)
>  	ibmvfc_handle_crq(&crq, vhost, &evtq);
>  }
>  
> +#define IBMVFC_TEST_FPIN_EXT(fs, ev, stat) {			\
> +	crq.valid = 0x80;					\
> +	crq.flags = IBMVFC_ASYNC_IS_FPIN_EXT;			\
> +	crq.link_state = IBMVFC_AE_LS_LINK_UP;			\
> +	crq.fpin_status = (fs);					\
> +	crq.event = cpu_to_be16(IBMVFC_AE_FPIN);		\
> +	crq.wwpn = cpu_to_be64(tgt->wwpn);			\
> +	crq.fpin_data.flags = IBMVFC_FPIN_EVENT_TYPE_VALID;	\
> +	crq.fpin_data.event_type = cpu_to_be16((ev));		\
> +	pre = READ_ONCE(tgt->rport->fpin_stats.stat);		\
> +	ibmvfc_handle_asyncq((struct ibmvfc_crq *)&crq, vhost,	\
> +			     &evt_doneq);			\
> +	post = READ_ONCE(tgt->rport->fpin_stats.stat);		\
> +}
> +
>  /**
> - * ibmvfc_async_subq_test - unit test for allocating async subqueue
> + * ibmvfc_extended_fpin_test - unit test for extended FPIN events
>   * @test: pointer to kunit structure
>   *
> + * Tests
> + *
>   * Return: void
>   */
> -static void ibmvfc_async_subq_test(struct kunit *test)
> +static void ibmvfc_extended_fpin_test(struct kunit *test)
>  {
> +	enum ibmvfc_ae_fpin_status fs;
> +	struct ibmvfc_async_subq_fpin crq;
> +	struct fc_fpin_stats stats;
> +	struct ibmvfc_target *tgt;
>  	struct ibmvfc_host *vhost;
> -	struct list_head *queue;
>  	struct list_head *headp;
> +	LIST_HEAD(evt_doneq);
> +	u64 pre, post;
>  
>  	headp = ibmvfc_get_headp();
> -	queue = headp->next;
> -	vhost = container_of(queue, struct ibmvfc_host, queue);
> +	vhost = list_first_entry(headp, struct ibmvfc_host, queue);
> +	KUNIT_ASSERT_NOT_NULL_MSG(test, vhost, "No vhost");
>  
> -	KUNIT_EXPECT_NOT_NULL(test, vhost->scsi_scrqs.async_scrq);
> +	KUNIT_ASSERT_GE(test, vhost->num_targets, 1);
> +	tgt = list_first_entry(&vhost->targets, struct ibmvfc_target, queue);
> +	KUNIT_ASSERT_NOT_NULL(test, tgt->rport);
> +
> +	stats = tgt->rport->fpin_stats;
> +
> +	for (fs = IBMVFC_AE_FPIN_LINK_CONGESTED; fs <= IBMVFC_AE_FPIN_CONGESTION_CLEARED; fs++) {
> +		switch (fs) {
> +		case IBMVFC_AE_FPIN_PORT_CLEARED:
> +		case IBMVFC_AE_FPIN_CONGESTION_CLEARED:
> +			crq.valid = 0x80;
> +			crq.flags = IBMVFC_ASYNC_IS_FPIN_EXT;
> +			crq.link_state = IBMVFC_AE_LS_LINK_UP;
> +			crq.fpin_status = fs;
> +			crq.event = cpu_to_be16(IBMVFC_AE_FPIN);
> +			crq.wwpn = cpu_to_be64(tgt->wwpn);
> +			crq.fpin_data.flags = IBMVFC_FPIN_EVENT_TYPE_VALID;
> +			crq.fpin_data.event_type = cpu_to_be16(0);
> +			pre = READ_ONCE(tgt->rport->fpin_stats.cn_clear);
> +			ibmvfc_handle_asyncq((struct ibmvfc_crq *)&crq, vhost,
> +					     &evt_doneq);
> +			post = READ_ONCE(tgt->rport->fpin_stats.cn_clear);
> +			break;
> +		case IBMVFC_AE_FPIN_LINK_CONGESTED:
> +		case IBMVFC_AE_FPIN_PORT_CONGESTED:
> +			IBMVFC_TEST_FPIN_EXT(fs, FPIN_CONGN_CLEAR, cn_clear);
> +			IBMVFC_TEST_FPIN_EXT(fs, FPIN_CONGN_LOST_CREDIT, cn_lost_credit);
> +			IBMVFC_TEST_FPIN_EXT(fs, FPIN_CONGN_CREDIT_STALL, cn_credit_stall);
> +			IBMVFC_TEST_FPIN_EXT(fs, FPIN_CONGN_OVERSUBSCRIPTION, cn_oversubscription);
> +			IBMVFC_TEST_FPIN_EXT(fs, FPIN_CONGN_DEVICE_SPEC, cn_device_specific);
> +			break;
> +		case IBMVFC_AE_FPIN_PORT_DEGRADED:
> +			IBMVFC_TEST_FPIN_EXT(fs, FPIN_LI_UNKNOWN, li_failure_unknown);
> +			IBMVFC_TEST_FPIN_EXT(fs, FPIN_LI_LINK_FAILURE, li_link_failure_count);
> +			IBMVFC_TEST_FPIN_EXT(fs, FPIN_LI_LOSS_OF_SYNC, li_loss_of_sync_count);
> +			IBMVFC_TEST_FPIN_EXT(fs, FPIN_LI_LOSS_OF_SIG, li_loss_of_signals_count);
> +			IBMVFC_TEST_FPIN_EXT(fs, FPIN_LI_PRIM_SEQ_ERR, li_prim_seq_err_count);
> +			IBMVFC_TEST_FPIN_EXT(fs, FPIN_LI_INVALID_TX_WD, li_invalid_tx_word_count);
> +			IBMVFC_TEST_FPIN_EXT(fs, FPIN_LI_INVALID_CRC, li_invalid_crc_count);
> +			IBMVFC_TEST_FPIN_EXT(fs, FPIN_LI_DEVICE_SPEC, li_device_specific);
> +			break;
> +		}
> +	}
>  }
>  
>  static struct kunit_case ibmvfc_fpin_test_cases[] = {
>  	KUNIT_CASE(ibmvfc_handle_fpin_event_test),
>  	KUNIT_CASE(ibmvfc_noop_test),
>  	KUNIT_CASE(ibmvfc_async_subq_test),
> +	KUNIT_CASE(ibmvfc_extended_fpin_test),
>  	{},
>  };
>  
> 

