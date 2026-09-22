Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75C73769F0;
	Tue, 22 Sep 2026 23:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790119052; cv=none; b=YtcW2Yi3w+BUTSlA0yi4gwfWpOQ2JGp0CQkYb6rf8u3Vxhn+qLtkcGASnh8jSfU6ON6g5ffbveH7qY3a3joG1zq2CKCHNAlxwFWLheep4SGsgEv+D91rlRAcI46GzCb15Kfr5akfrsTPl8v0PBHKcJP8OJBiGhaR3KX5Jm2FIGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790119052; c=relaxed/simple;
	bh=SB8k2soM+RpvTYoU56sRqAMYXqKTRMffQri+OLSmCK4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nWsKVGheLTvRCeBpmM4SrODqaN4hGVbtBHZv4eQemFnLusBOAY9SN5Sg89DSLOW1Ru/eDT2gH+F7QBh4GTE9IrMMwlB0SFtrdYU1m0hRo29y2Fclqbf/Dk3tIyrWEPhRRuH8A+yzLQkZPuwQVOKBG0tz/gsCnRObIk1yNKO4sd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XvNtXpGF; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XvNtXpGF"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68MI76P61129513;
	Tue, 22 Sep 2026 23:17:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=W4mOqa
	Tr+peJFTZUrXoQ6lkkEWD+g7T5avZDT3doYhc=; b=XvNtXpGFI7M64GmAM0eKOn
	Ez9YDnSv+8dHfplWXHdbNINKuesoJgcF07cTREqDEUyvTLscPEU4GzT7WG7dRXzV
	ph+FRYjvCMW38fScAIoExiGbL20KnGMXeGNRy77tzhZlzNmz21B9PCkjzbWNvmny
	H+oWp5g4Ql1ibDax9SDpmQXGpBS5/uSMmr1lphUt0l+uV/5bDcZhyAmK8jxabLTj
	8SrVCsc92PwFakbkC/S0n479H3v6PTgGpu+k8yYImpcERn7PbJHuHr29I7iaC6mG
	54McP5uf5ev+Sj4GnYLRd2LHKBr33fbpbtPV/G1ksugTy3V3P6eM714YF49wQuOw
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gskg2gdd9-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 22 Sep 2026 23:17:23 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68MN4GB43239754;
	Tue, 22 Sep 2026 23:17:22 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gt67gutg8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Sep 2026 23:17:22 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68MNHLs831851082
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Sep 2026 23:17:21 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DFD0558063;
	Tue, 22 Sep 2026 23:17:20 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 19FFC5804B;
	Tue, 22 Sep 2026 23:17:20 +0000 (GMT)
Received: from [9.61.81.35] (unknown [9.61.81.35])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 22 Sep 2026 23:17:19 +0000 (GMT)
Message-ID: <0c5c6aa9-04d4-41fa-8cb4-f5ac55a8f63a@linux.ibm.com>
Date: Tue, 22 Sep 2026 16:19:06 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 8/9] scsi: ibmvfc: register and use asynchronous sub
 CRQ for events
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com
References: <20260911054832.1311668-1-tyreld@linux.ibm.com>
 <20260911054832.1311668-9-tyreld@linux.ibm.com>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <20260911054832.1311668-9-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: p0jD9hk_-aHqMM7OPqq7qPO1cDHNsAMA
X-Authority-Analysis: v=2.4 cv=I43w19gg c=1 sm=1 tr=0 ts=6ab30c83 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=dxymRrk4hePnmNfmlPsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDMwNSBTYWx0ZWRfX3E7qb+r7RQ6L
 q3ZCUsY8CRvX5Nunsz1N6aVoJGIqLVlCzcWSZ33QYmo8V30/yGzPZJhuFkkbetDiZHkKhCzJbjV
 x96JShds+DF76h91jp5ZaSJH1bNFRSEldH+2dtEY95SC9gVLQ1e9wlRA8GjlfLblVJP1566IxXL
 XoIAbbaZKmNPWhnOzc9hDQCmDSFunJcONZsT+hkDsIjBPV5j4ODgVqkOVkEhITIekrJ/YzPV0Vr
 13Vx4Bn2UJ3bEC4NjzoHan/xrQTcnSKJE6OhAwQ9R3aPq9gITip9ZZeqC+mIMSJb+x1TPqT7ENN
 cocjj/duD70PfpxG6AHtmRbOcneS3pQ/kVYgxZ8vSjajbCnRf14+F/KCRXXPTWT3jgyKyjjfQIp
 qP+oRoEZmv4Ovj50rCotunX1J2T0Ek822sIHWnsgYkxR563Ih3tq0KpEF6mZKFZN8iC0y9h+hiW
 xKt95m795J7I62nkJEQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDMwNSBTYWx0ZWRfX0rzbB+lbtywZ
 Q1IGzmOfUpGwN7Ocl5paQ6TowgX+6UcDPjPASZzt40xZcM8bqN82cilBaJMRbcoP1tbLs5Ri/Bd
 fpkM/D/UJG426Bd4lc9s3A0n/v142YQ=
X-Proofpoint-GUID: p0jD9hk_-aHqMM7OPqq7qPO1cDHNsAMA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-22_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 adultscore=0 suspectscore=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609220305

On 9/10/26 10:48 PM, Tyrel Datwyler wrote:
> From: Dave Marquardt <davemarq@linux.ibm.com>
> 
> Wire the async sub-CRQ into the sub-CRQ lifecycle so it is allocated,
> registered, and freed alongside the SCSI channel queues.
> 
> In ibmvfc_init_sub_crqs(), allocate the async sub-CRQ queue buffer via
> ibmvfc_alloc_queue() before allocating the SCSI channels. Register it
> with the VIOS by calling ibmvfc_register_channel() with index -1 (the
> negative-index sentinel introduced in the previous commit). Either
> failure disables multi-queue and aborts init.
> 
> In ibmvfc_release_sub_crqs(), ibmvfc_reenable_crq_queue(), and
> ibmvfc_reset_crq(), deregister and re-register the async sub-CRQ
> alongside the SCSI channel queues.
> 
> In ibmvfc_channel_setup_done(), capture the async sub-CRQ handle
> returned by the VIOS in the channel setup response and store it in
> vhost->async_sub_crq.vios_cookie.
> 
> In ibmvfc_set_login_info(), advertise IBMVFC_USE_ASYNC_SUBQ,
> IBMVFC_CAN_HANDLE_FPIN, and IBMVFC_YES_SCSI capabilities whenever
> multi-queue channels are enabled. IBMVFC_YES_SCSI was previously only
> set for NVMe-enabled configurations; move it to the common multi-queue
> path so it is always advertised when channels are in use.
> 
> Fix a variable-shadowing bug in ibmvfc_register_channel() where the
> irq_failed cleanup loop reused rc for the H_FREE_SUB_CRQ hcall result,
> clobbering the error code returned to the caller. Introduce hcall_rc
> for the cleanup loop instead.

I think this should be its own patch.

> 
> Guard the memset() in ibmvfc_deregister_channel() behind a check of
> scrq->msgs.handle to prevent a NULL dereference when the function is
> called on a queue that was never allocated, such as async_sub_crq when
> multi-queue is disabled or initialization failed before
> ibmvfc_alloc_queue() was reached.

Same with this chunk.

-Tyrel

> 
> Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
> Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
> ---
>  drivers/scsi/ibmvscsi/ibmvfc-core.c | 51 +++++++++++++++++++++++++----
>  1 file changed, 44 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> index c78e221f182a..70a3046135c7 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -192,6 +192,8 @@ static void ibmvfc_tgt_move_login(struct ibmvfc_target *);
>  
>  static void ibmvfc_dereg_sub_crqs(struct ibmvfc_host *, struct ibmvfc_channels *);
>  static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *, struct ibmvfc_channels *);
> +static void ibmvfc_deregister_channel(struct ibmvfc_host *, struct ibmvfc_channels *, int);
> +static int ibmvfc_register_channel(struct ibmvfc_host *, struct ibmvfc_channels *, int);
>  
>  static const char *unknown_error = "unknown error";
>  
> @@ -964,6 +966,7 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
>  	struct vio_dev *vdev = to_vio_dev(vhost->dev);
>  	unsigned long flags;
>  
> +	ibmvfc_deregister_channel(vhost, &vhost->scsi_scrqs, -1);
>  	ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
>  	ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);
>  
> @@ -986,6 +989,7 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
>  	spin_unlock(vhost->crq.q_lock);
>  	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
>  
> +	ibmvfc_register_channel(vhost, &vhost->scsi_scrqs, -1);
>  	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
>  	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
>  
> @@ -1006,6 +1010,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
>  	struct vio_dev *vdev = to_vio_dev(vhost->dev);
>  	struct ibmvfc_queue *crq = &vhost->crq;
>  
> +	ibmvfc_deregister_channel(vhost, &vhost->scsi_scrqs, -1);
>  	ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
>  	ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);
>  
> @@ -1042,6 +1047,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
>  	spin_unlock(vhost->crq.q_lock);
>  	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
>  
> +	ibmvfc_register_channel(vhost, &vhost->scsi_scrqs, -1);
>  	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
>  	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
>  
> @@ -1584,9 +1590,11 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
>  
>  	if (vhost->mq_enabled || vhost->using_channels) {
>  		login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_CHANNELS);
> +		login_info->capabilities |= cpu_to_be64(IBMVFC_USE_ASYNC_SUBQ);
> +		login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_HANDLE_FPIN);
> +		login_info->capabilities |= cpu_to_be64(IBMVFC_YES_SCSI);
>  		if (vhost->nvme_enabled) {
>  			login_info->capabilities |= cpu_to_be64(IBMVFC_YES_NVMEOF);
> -			login_info->capabilities |= cpu_to_be64(IBMVFC_YES_SCSI);
>  			login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_WWPN_ALL);
>  		}
>  	}
> @@ -5811,6 +5819,7 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
>  		for (i = 0; i < nvme->active_queues; i++)
>  			nvme->scrqs[i].vios_cookie =
>  				be64_to_cpu(setup->channel_handles[scsi->active_queues + i]);
> +		vhost->async_sub_crq.vios_cookie = be64_to_cpu(setup->async_sub_crq_handle);
>  
>  		ibmvfc_dbg(vhost, "Using %u SCSI channels\n",
>  			   scsi->active_queues);
> @@ -5870,6 +5879,7 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
>  		for (i = 0; i < nvme_channels; i++)
>  			setup_buf->channel_handles[scsi_channels + i] =
>  				cpu_to_be64(nvme->scrqs[i].cookie);
> +		setup_buf->async_sub_crq_handle = cpu_to_be64(vhost->async_sub_crq.cookie);
>  	}
>  
>  	ibmvfc_init_event(evt, ibmvfc_channel_setup_done, IBMVFC_MAD_FORMAT);
> @@ -6834,6 +6844,7 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
>  	bool is_async = index < 0;
>  	struct ibmvfc_queue *scrq = !is_async ? &channels->scrqs[index] : &vhost->async_sub_crq;
>  	int rc = -ENOMEM;
> +	int hcall_rc;
>  
>  	ENTER;
>  
> @@ -6902,8 +6913,8 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
>  
>  irq_failed:
>  	do {
> -		rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
> -	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
> +		hcall_rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
> +	} while (hcall_rc == H_BUSY || H_IS_LONG_BUSY(hcall_rc));
>  reg_failed:
>  	LEAVE;
>  	return rc;
> @@ -6953,8 +6964,10 @@ static void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
>  	}
>  
>  	/* Clean out the queue */
> -	memset(scrq->msgs.crq, 0, PAGE_SIZE);
> -	scrq->cur = 0;
> +	if (scrq->msgs.handle) {
> +		memset(scrq->msgs.crq, 0, PAGE_SIZE);
> +		scrq->cur = 0;
> +	}
>  
>  	LEAVE;
>  }
> @@ -6971,7 +6984,9 @@ static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
>  	for (i = 0; i < channels->max_queues; i++) {
>  		if (ibmvfc_register_channel(vhost, channels, i)) {
>  			for (j = i; j > 0; j--)
> -				ibmvfc_deregister_channel(vhost, channels, j - 1);
> +				ibmvfc_deregister_channel(
> +					vhost, channels, j - 1);
> +
>  			vhost->do_enquiry = 0;
>  			return;
>  		}
> @@ -7026,16 +7041,26 @@ static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
>  
>  static void ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
>  {
> +	int rc = 0;
> +
>  	ENTER;
>  	if (!vhost->mq_enabled)
>  		return;
>  
> -	if (ibmvfc_alloc_channels(vhost, &vhost->scsi_scrqs)) {
> +	rc = ibmvfc_alloc_queue(vhost, &vhost->async_sub_crq, IBMVFC_SUB_CRQ_FMT);
> +	if (rc) {
>  		vhost->do_enquiry = 0;
>  		vhost->mq_enabled = 0;
>  		return;
>  	}
>  
> +	/* register async_sub_crq channel */
> +	if (ibmvfc_register_channel(vhost, &vhost->scsi_scrqs, -1))
> +		goto free_async_sub_crq;
> +
> +	if (ibmvfc_alloc_channels(vhost, &vhost->scsi_scrqs))
> +		goto deregister_async_sub_crq;
> +
>  	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
>  
>  	if (vhost->nvme_enabled) {
> @@ -7046,6 +7071,15 @@ static void ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
>  	}
>  
>  	LEAVE;
> +	return;
> +
> + deregister_async_sub_crq:
> +	ibmvfc_deregister_channel(vhost, &vhost->scsi_scrqs, -1);
> +free_async_sub_crq:
> +	ibmvfc_free_queue(vhost, &vhost->async_sub_crq);
> +	vhost->do_enquiry = 0;
> +	vhost->mq_enabled = 0;
> +	return;
>  }
>  
>  static void ibmvfc_release_channels(struct ibmvfc_host *vhost,
> @@ -7069,6 +7103,9 @@ static void ibmvfc_release_channels(struct ibmvfc_host *vhost,
>  static void ibmvfc_release_sub_crqs(struct ibmvfc_host *vhost)
>  {
>  	ENTER;
> +	ibmvfc_deregister_channel(vhost, &vhost->scsi_scrqs, -1);
> +	ibmvfc_free_queue(vhost, &vhost->async_sub_crq);
> +
>  	if (!vhost->scsi_scrqs.scrqs)
>  		return;
>  

