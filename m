Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE304433049;
	Mon, 21 Sep 2026 20:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790023275; cv=none; b=jZG2B3GBB3JR/HrpLqZY/zbuuPbBKHONLEGxVS8XdzMPWm5yolzoNFJVLlD7i2WyDF5J8ITVXM2vmLM2ySNccJ0G54vYqT/SAZYluqYyj4IvwhVlun6hfqcxh7bfuO93T5HXgGwUTUFvrSJbXd/W4pRXaN0VXWqV0CVOEo2Ae+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790023275; c=relaxed/simple;
	bh=tyIjVOPEdcjwsjgzj+jvF4Wz0kMh53F5KcN4fiGKbJc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c4yACMEL+whrCEpfLO9yn+YwDbCWf8a3ffW5vHlo1MVf6E6tO3fDr0EDiqQGqFqVpL9aKDpRML/seen3ARmSOxLmL8k7FOAAfenyzTg9jBgeFVzANi+1seixwgh9SWjU4gb5319WDoNcZ/X2NhYqhM7Np0YJzQvmNm/AiDosY5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DmMmxVVU; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DmMmxVVU"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LF8Pdi4193624;
	Mon, 21 Sep 2026 20:41:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=sws6k0
	mDF3hSgRc9u1g/C9IjEy4ChZADUQxPNGOl9jw=; b=DmMmxVVUFqx06vw7VEfKza
	X8g2K7ShRPU8wC38P0CyGRCrLPO3iX8zYZUvb66b3xKF7ZOK231Ac0OjqJOqOCv3
	pDMzpG9/s5fpIkV7L18lRo4B+Q7Q1403QXEtdk0Ont9ECekl8XNwccu+8EX+nmEA
	/6rBC1P+dXrZ+spbx9xPZIi9t8tpiCWAI0F6QXQhG5EcQXMSsoDO7d+gidhUu/V8
	aqiQ6EMXdwM7AV7IkADyfaloG/7wLzGuYyhtDDWSKDmXaMkEx5ke1LhGDFAhTHwc
	eUbX0QvZRlyftcr0ToNeTsD88mEpXlIZNdaHf42z40XtG8tpIaM2CybxCgKNHsAg
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gske1jn3h-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 20:41:06 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68LJIDKn2399617;
	Mon, 21 Sep 2026 20:41:06 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gt7dy6rrb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 20:41:06 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68LKf59524511082
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Sep 2026 20:41:05 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2079E58050;
	Mon, 21 Sep 2026 20:41:05 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 459F458052;
	Mon, 21 Sep 2026 20:41:04 +0000 (GMT)
Received: from [9.61.11.58] (unknown [9.61.11.58])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 21 Sep 2026 20:41:04 +0000 (GMT)
Message-ID: <ee433719-a4ac-49d0-84ec-2a8e4697d621@linux.ibm.com>
Date: Mon, 21 Sep 2026 13:41:03 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 6/9] scsi: ibmvfc: extend channel reg/dereg helpers
 for async sub-CRQ
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com
References: <20260911054832.1311668-1-tyreld@linux.ibm.com>
 <20260911054832.1311668-7-tyreld@linux.ibm.com>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <20260911054832.1311668-7-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: un4d6k4T0-ENgl4YYTxtrMi9zZtpYKsg
X-Authority-Analysis: v=2.4 cv=EOCTQFZC c=1 sm=1 tr=0 ts=6ab19663 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8
 a=Xv2pnnNrGwOS_ky8ChoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDMwMSBTYWx0ZWRfXxPri40Q2BbsW
 qdwm+z/lEfFcOeMotLh8k9he6ELzDcQHqgFVOUrlwTrIfELveOzFFsWn9U1O3zi40B5ENE557fW
 hiZBwrEVbui3iP8K3byoFAjRpxS92lc=
X-Proofpoint-GUID: un4d6k4T0-ENgl4YYTxtrMi9zZtpYKsg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDMwMSBTYWx0ZWRfX3u5cIkfXceZO
 EDZsMYK06fphlzovNDKLCfSDGaWelr+drlLgCukLxnR7lXGsPsYooDqYduf8FppUq3Ufy7XXOmY
 OAordkvIMD6segoI3+uqT46+/YmscD/QKGEnqhS8z09ZChfCa6PYVdnsFY3iIUdDe0dwr/pljA3
 +Jb4LMb1PpX+VkrLQjO+AYnQWb/wxn2IAaZweg1ZIdmfvNdrdo8X3JyChoTQBhRDHUnGGBeW+Sd
 EMYjOpH9fHR2rJ0z0jPSmBDLT4v4JJMvmSJnI79CmqqZn7U9i3F49OC+9bU+L3qn+/xDz49qbKv
 mRSPTMScaQDovxuhkkz4wJWqpKNdvTFs5Y2KIgbrCNn92mvxL2+JwNs30uXOlJJeTN5ch5ugtZ8
 KCx2XsudG4AxUlfv3CD+0wI/t3InzFGxdS9m7JoiEBsR5v3vs6besB3HUl6c3bFbtTfWNlWPSQJ
 nlG8sauuFoUtoBwkv8w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_05,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 priorityscore=1501 clxscore=1015 spamscore=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609210301

On 9/10/26 10:48 PM, Tyrel Datwyler wrote:
> From: Dave Marquardt <davemarq@linux.ibm.com>
> 
> ibmvfc_register_channel() and ibmvfc_deregister_channel() previously only
> handled indexed sub-CRQ channels drawn from the channels->scrqs[] array.
> The async sub-CRQ (vhost->async_sub_crq) had no registration path through
> these helpers, requiring separate handling.
> 
> Extend both functions to accept a negative index as a sentinel value
> signalling that the async sub-CRQ should be operated on instead of an
> indexed scrq entry. When index < 0, the queue pointer is set to
> &vhost->async_sub_crq, the IRQ is named "ibmvfc-<addr>-async", and the
> handler is set to ibmvfc_interrupt_async_subq rather than the per-protocol
> ibmvfc_interrupt_mq handler. hwq_id assignment is skipped for the async
> queue since it has no meaningful hardware queue index.
> 
> Stopped marking ibmvfc_interrupt_async_subq as __maybe_unused.
> 
> Error messages in both paths are updated to distinguish async sub-CRQ
> failures from indexed sub-CRQ failures. Kernel-doc headers are added to
> both functions documenting the negative-index convention.
> 
> Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
> Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>

I was a little relectuant about the chages here initially, and the more I look
at this the more I don't like it. So I think I'm changing my mind to a NACK here.

We want channel registration to be generic and the using a negative index to
identify an async subq seems like a hack. The reality is there is only one
channel and its at index 0. Futher, the async events are there own protocol that
we process in the client so treat them as such and use the channel protocol
field to identify that this is an async subq.

-Tyrel
> ---
>  drivers/scsi/ibmvscsi/ibmvfc-core.c | 93 ++++++++++++++++++++++-------
>  1 file changed, 70 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> index 670f6b3a5476..a9cf1096e755 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -4419,7 +4419,7 @@ static void ibmvfc_drain_async_subq(struct ibmvfc_queue *scrq)
>   * @scrq_instance: async subq
>   *
>   **/
> -static irqreturn_t __maybe_unused ibmvfc_interrupt_async_subq(int irq, void *scrq_instance)
> +static irqreturn_t ibmvfc_interrupt_async_subq(int irq, void *scrq_instance)
>  {
>  	struct ibmvfc_queue *scrq = (struct ibmvfc_queue *)scrq_instance;
>  
> @@ -6810,13 +6810,29 @@ static int ibmvfc_init_crq(struct ibmvfc_host *vhost)
>  	return retrc;
>  }
>  
> +/**
> + * ibmvfc_register_channel - Register a sub-CRQ channel with the hypervisor
> + * @vhost:	ibmvfc host struct
> + * @channels:	ibmvfc channels struct containing the channel array and protocol
> + * @index:	index into the channels array for the queue to register, or
> + *		a negative value to register the async sub-CRQ
> + *
> + * Register a sub-CRQ with the hypervisor via h_reg_sub_crq, map its hardware
> + * IRQ to a Linux IRQ, and bind an interrupt handler to it. The handler is
> + * selected based on the channel protocol (SCSI or NVMe) for normal queues, or
> + * set to the async sub-CRQ handler when @index is negative.
> + *
> + * Return value:
> + *	0 on success / non-zero on failure
> + **/
>  static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
>  				   struct ibmvfc_channels *channels,
>  				   int index)
>  {
>  	struct device *dev = vhost->dev;
>  	struct vio_dev *vdev = to_vio_dev(dev);
> -	struct ibmvfc_queue *scrq = &channels->scrqs[index];
> +	bool is_async = index < 0;
> +	struct ibmvfc_queue *scrq = !is_async ? &channels->scrqs[index] : &vhost->async_sub_crq;
>  	int rc = -ENOMEM;
>  
>  	ENTER;
> @@ -6836,36 +6852,49 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
>  
>  	if (!scrq->irq) {
>  		rc = -EINVAL;
> -		dev_err(dev, "Error mapping sub-crq[%d] irq\n", index);
> +		if (!is_async)
> +			dev_err(dev, "Error mapping sub-crq[%d] irq\n", index);
> +		else
> +			dev_err(dev, "Error mapping async sub-crq irq\n");
>  		goto irq_failed;
>  	}
>  
> -	switch (channels->protocol) {
> -	case IBMVFC_PROTO_SCSI:
> -		snprintf(scrq->name, sizeof(scrq->name), "ibmvfc-%x-scsi%d",
> -			 vdev->unit_address, index);
> -		scrq->handler = ibmvfc_interrupt_mq;
> -		break;
> -	case IBMVFC_PROTO_NVME:
> -		snprintf(scrq->name, sizeof(scrq->name), "ibmvfc-%x-nvmf%d",
> -			 vdev->unit_address, index);
> -		scrq->handler = ibmvfc_interrupt_mq;
> -		break;
> -	default:
> -		dev_err(dev, "Unknown channel protocol (%d)\n",
> -			channels->protocol);
> -		goto irq_failed;
> +	if (!is_async) {
> +		switch (channels->protocol) {
> +		case IBMVFC_PROTO_SCSI:
> +			snprintf(scrq->name, sizeof(scrq->name), "ibmvfc-%x-scsi%d",
> +				 vdev->unit_address, index);
> +			scrq->handler = ibmvfc_interrupt_mq;
> +			break;
> +		case IBMVFC_PROTO_NVME:
> +			snprintf(scrq->name, sizeof(scrq->name), "ibmvfc-%x-nvmf%d",
> +				 vdev->unit_address, index);
> +			scrq->handler = ibmvfc_interrupt_mq;
> +			break;
> +		default:
> +			dev_err(dev, "Unknown channel protocol (%d)\n",
> +				channels->protocol);
> +			goto irq_failed;
> +		}
> +	} else {
> +		snprintf(scrq->name, sizeof(scrq->name), "ibmvfc-%x-async",
> +			 vdev->unit_address);
> +		scrq->handler = ibmvfc_interrupt_async_subq;
>  	}
>  
>  	rc = request_irq(scrq->irq, scrq->handler, 0, scrq->name, scrq);
>  
>  	if (rc) {
> -		dev_err(dev, "Couldn't register sub-crq[%d] irq\n", index);
> +		if (!is_async)
> +			dev_err(dev, "Couldn't register sub-crq[%d] irq\n", index);
> +		else
> +			dev_err(dev, "Couldn't register async sub-crq irq\n");
>  		irq_dispose_mapping(scrq->irq);
>  		goto irq_failed;
>  	}
>  
> -	scrq->hwq_id = index;
> +	if (!is_async)
> +		scrq->hwq_id = index;
>  
>  	LEAVE;
>  	return 0;
> @@ -6879,13 +6908,26 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
>  	return rc;
>  }
>  
> +/**
> + * ibmvfc_deregister_channel - Deregister a sub-CRQ channel with the hypervisor
> + * @vhost:	ibmvfc host struct
> + * @channels:	ibmvfc channels struct containing the sub-CRQ array
> + * @index:	index into the sub-CRQ array, or -1 to deregister the
> + *		asynchronous sub-CRQ
> + *
> + * Frees the IRQ, disposes of the IRQ mapping, and calls H_FREE_SUB_CRQ to
> + * release the sub-CRQ with the hypervisor. On success the queue message
> + * buffer is zeroed and the current index is reset. If H_FREE_SUB_CRQ fails,
> + * an error is logged but the channel resources are cleaned up regardless.
> + */
>  static void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
>  				      struct ibmvfc_channels *channels,
>  				      int index)
>  {
>  	struct device *dev = vhost->dev;
>  	struct vio_dev *vdev = to_vio_dev(dev);
> -	struct ibmvfc_queue *scrq = &channels->scrqs[index];
> +	bool is_async = index < 0;
> +	struct ibmvfc_queue *scrq = !is_async ? &channels->scrqs[index] : &vhost->async_sub_crq;
>  	long rc;
>  
>  	ENTER;
> @@ -6899,8 +6941,13 @@ static void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
>  					scrq->cookie);
>  	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
>  
> -	if (rc)
> -		dev_err(dev, "Failed to free sub-crq[%d]: rc=%ld\n", index, rc);
> +	if (rc) {
> +		if (!is_async)
> +			dev_err(dev, "Failed to free sub-crq[%d]: rc=%ld\n",
> +				index, rc);
> +		else
> +			dev_err(dev, "Failed to free async sub-crq: rc=%ld\n", rc);
> +	}
>  
>  	/* Clean out the queue */
>  	memset(scrq->msgs.crq, 0, PAGE_SIZE);

