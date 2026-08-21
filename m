Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AD4233134;
	Fri, 21 Aug 2026 15:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787326221; cv=none; b=j9nhOLoWF0ql37MZkgXCbWrDQyyqffKYvx8lwThPHEEUQUEiXq3fLkzSKIYWK7S0Sav33XZKH+fGpc0/rSQec0vertadGD3OJs+2Zw0T8PS7Bj4uK/+bP+Lly3PPbzV+F7LERmcOdRAdXGGgeKenc7bf6XCBVP010MGTey62WvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787326221; c=relaxed/simple;
	bh=gDCHDwet9YZ0MrFn1oGA3qecUx9v2QZsrhMI34KM08g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=H3aoIk3pSwlR1Jmqds7UE0hU2z36AVpafaZj/oldeOlhTrRKKg9xCxuPs/8xgTr256ZuXRhJf+/b0htEioIVGKDxUgHel+pcVY1W8aF93ynZNGwn7sA4xQ3UD3jRzio69jq+FOGsxqbJxSl05Z2fZDeFAhvvjz3tPPWmRDb5Co8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VUqS8NGD; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VUqS8NGD"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67LD1in81530975;
	Fri, 21 Aug 2026 15:30:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=2MMiXfPWUY0d7HptZrFrNhQYDjO3QF
	H5i51EOefPQ1Q=; b=VUqS8NGDwkh286it4XdoICl5ME7LTcOgyD9/ZWMxEJY1f5
	56tWKukRuOJHRiBiyCoEj80rKZS9mc2qAlBW/qT2DYIgn1k0wayDviMu53aWpnI9
	cXv9Rnf46wwbgUMoQQLYggfwLfuo76/JtEEPgDR/IGEMGNVCfts1kezzVOXRd5ya
	yDr3kUGnn9/Nq4PsIqKFlIKRw6CI+V6rYxTWEeCkWuv2JHeSFqHXhIyaanwQOtut
	AE/3jBFy25FE2VYQGMFQy1ZJeNOhPEgQf6jP64N7YYdWf9E4fvp66AiLqhj5J2ga
	QvS4ygIZSObH5Oa/HFylezhflqqqXRuJ+maJDUtg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g4yu1tb7g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Aug 2026 15:30:18 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67LFQGFe024111;
	Fri, 21 Aug 2026 15:30:18 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g34ngw6g5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Aug 2026 15:30:18 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67LFUHt1721572
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Aug 2026 15:30:17 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6A6D858056;
	Fri, 21 Aug 2026 15:30:17 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3536F58054;
	Fri, 21 Aug 2026 15:30:17 +0000 (GMT)
Received: from d (unknown [9.61.29.95])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 21 Aug 2026 15:30:17 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH v6 6/8] scsi: ibmvfc: extend channel registration and
 deregistration for async subq
In-Reply-To: <20260817205022.18DB41F000E9@smtp.kernel.org>
References: <20260817-ibmvfc-fpin-support-v6-0-62a2d525e70d@linux.ibm.com>
	<20260817-ibmvfc-fpin-support-v6-6-62a2d525e70d@linux.ibm.com>
	<20260817205022.18DB41F000E9@smtp.kernel.org>
Date: Fri, 21 Aug 2026 10:30:16 -0500
Message-ID: <87o6evwkxj.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=LsCiDHdc c=1 sm=1 tr=0 ts=6a886f0b cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=EH_j107jPUcDJBdFlEsA:9
X-Proofpoint-GUID: -6YQf935qV173xJGEorL6n0JndEvHlV0
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIxMDExNyBTYWx0ZWRfX0Hx+Df7wq7xe
 p8U9MkZNcTbWBrdUClJuXm/kjsi2kvrFHteNChApXktXRImpkQyhOmYOKnteBB+ZUwLwIgppcAE
 rsFmI8BD6CylM4coSa50UAzvVzPZ0g4=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIxMDExNyBTYWx0ZWRfX2ceAOSu75Svo
 m06E2A/8ViYXdoGUzfsQ9hraW+HRrELifaz0hb90CiRN7NLhLn8R48OqKkN3EWHGUWJ/ZnQ214r
 IQTIlf+LGaDmEBODYuOLFnjq8HodFKSMI4ccdotaaXPovjO0fwtuvkvBIHs4kGVnPcBwSIKdign
 t15AcK9t80so1khC9p1ObbumNgw4f8Ex+lPP5pI1peiB4ZWw7faBv/zDb08/EzJPzUp666iFhWu
 90JtMN9sm94EWUZE+6Ra1iuIOqeUd2fBk5+CVv+S7vavs20I2dnsF0Bs2ODLhB2CJiYh6KE7/7j
 xT6dkp0nBxRD4tucEcuxGBE8djloP6/3XRly/094FDtSuFlmf0SJaz0CXAdHtKsxNd5v5SMpg2g
 bzRbS4ecPJf+N3aEDTWMZTz6ge3QsedCZmaZ+hq5HV5Hn9uRCKjnJo9g9Bxf9gLIAvQD7sdWHHs
 /N6m2nuA+RPsYv8DAGQ==
X-Proofpoint-ORIG-GUID: -6YQf935qV173xJGEorL6n0JndEvHlV0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-21_04,2026-08-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 adultscore=0 suspectscore=0 impostorscore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608210117

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [Critical] Kernel panic due to workqueue use-after-free during device teardown.
> - [Medium] Silent behavioral mutations: Undocumented parsing changes and test alterations.
> - [Low] Dead code and incomplete feature: async_sub_crq is never registered and lacks allocation.
> --
>
> --- Patch [6]: [PATCH v6 6/8] scsi: ibmvfc: extend channel registration and deregistration for async subq ---
> commit 31a5fe949f10ffb5d84b0f4c1f35d59e3b5dc785
> Author: Dave Marquardt <davemarq@linux.ibm.com>
> Subject: scsi: ibmvfc: extend channel registration and deregistration for async subq
>
> This patch extends ibmvfc_register_channel() and ibmvfc_deregister_channel()
> to accept a negative index. This convention signals that the async sub-CRQ
> should be operated on instead of an indexed scrq entry.
>
>> Extend both functions to accept a negative index as a sentinel value
>> signalling that the async sub-CRQ should be operated on instead of an
>> indexed scrq entry. When index < 0, the queue pointer is set to
>> &vhost->async_sub_crq, the IRQ is named "ibmvfc-<addr>-async", and the
>> handler is set to ibmvfc_interrupt_async_subq rather than the per-protocol
>> ibmvfc_interrupt_mq handler. hwq_id assignment is skipped for the async
>> queue since it has no meaningful hardware queue index.
>
> [Severity: Medium]
> Could the commit message be updated to mention the behavioral updates?
>
> The commit message thoroughly explains the new channel registration logic,
> but the patch also introduces undocumented parsing changes to node_name
> handling using IBMVFC_ASYNC_ID_IS_ASSOC_ID in ibmvfc_process_async_work(),
> along with silent alterations to the KUnit tests checking
> cn_device_specific.

The commit message is updated in v7.

>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index 3b5732f2fb6ec..4e6d2ff190751 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> [ ... ]
>> @@ -3593,7 +3593,7 @@ VISIBLE_IF_KUNIT void ibmvfc_handle_async(void *crq,
>>  		link_state = subq->link_state;
>>  		scsi_id = 0;
>>  		wwpn = subq->wwpn;
>> -		node_name = subq->id.node_name;
>> +		node_name = subq->flags & IBMVFC_ASYNC_ID_IS_ASSOC_ID ? 0 : subq->id.node_name;
>
> [Severity: Critical]
> Could this lead to a use-after-free regression during device teardown?
>
> If ibmvfc_remove() destroys and nullifies vhost->fpin_workq before the
> adapter interrupts are disabled via ibmvfc_release_crq_queue(), and an
> asynchronous FPIN event is received during this window,
> ibmvfc_handle_async() will invoke:
>
>     queue_work(vhost->fpin_workq, &aw->async_work_s);
>
> Since the workqueue pointer is already NULL, this would cause a fatal
> dereference.

Already fixed in previous patches in v7.

> [ ... ]
>> @@ -6798,13 +6791,29 @@ static int ibmvfc_init_crq(struct ibmvfc_host *vhost)
>>  	return retrc;
>>  }
>>  
>> +/**
>> + * ibmvfc_register_channel - Register a sub-CRQ channel with the hypervisor
>> + * @vhost:	ibmvfc host struct
>> + * @channels:	ibmvfc channels struct containing the channel array and protocol
>> + * @index:	index into the channels array for the queue to register, or
>> + *		a negative value to register the async sub-CRQ
>> + *
>> + * Register a sub-CRQ with the hypervisor via h_reg_sub_crq, map its hardware
>> + * IRQ to a Linux IRQ, and bind an interrupt handler to it. The handler is
>> + * selected based on the channel protocol (SCSI or NVMe) for normal queues, or
>> + * set to the async sub-CRQ handler when @index is negative.
>> + *
>> + * Return value:
>> + *	0 on success / non-zero on failure
>> + **/
>>  static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
>>  				   struct ibmvfc_channels *channels,
>>  				   int index)
>>  {
>>  	struct device *dev = vhost->dev;
>>  	struct vio_dev *vdev = to_vio_dev(dev);
>> -	struct ibmvfc_queue *scrq = &channels->scrqs[index];
>> +	bool is_async = index < 0;
>> +	struct ibmvfc_queue *scrq = !is_async ? &channels->scrqs[index] : &vhost->async_sub_crq;
>
> [Severity: Low]
> Is this negative index path reachable?
>
> Searching the codebase, it doesn't appear that any callers pass a negative
> index into ibmvfc_register_channel() or ibmvfc_deregister_channel().
>
> Additionally, if this path were reached, it looks like vhost->async_sub_crq
> is never initialized via ibmvfc_alloc_queue(). This could lead to passing an
> uninitialized msg_token to the hypervisor and a null pointer dereference
> during memset().

This is fixed in v7.

-Dave
