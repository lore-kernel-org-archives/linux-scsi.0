Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147E1551985;
	Fri, 16 Oct 2026 16:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792167825; cv=none; b=CYg0pt47F1pwLk0DAbaFLckzlVGBbdoYFiqkiBDbjlCgFUbTPGVwi4H4cOJ0NDj1USfsbpE4UIJBSiHBnAP57uCQY8hKF3KW/hPEY0B0KRRVdq9jyg35rJnnAKOwsIB/KG3Tr8wD++TnOl4BGrygM2YVmRQeOvKM/zL9taB9KC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792167825; c=relaxed/simple;
	bh=HR/+nwfObSLXvSSmTUc1fVmJ959u+lfBWTVbW2gagS0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=c/6RIhoRpmCMFPGRW00iXOEKjXWgrO7lNDnuIbLvJYyvboEpeo4C1ueLu8yJTNcvsQIPSvIEfLvVzuw0CQPucRewII1UTdv8/lbW2rbJ9V+fBk3zKKruuscUui605feLfWcEIGNZMwv3UgpiDm1t6a680XaHXRkmzNvJi1ogRq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ePdYSyqT; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ePdYSyqT"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GEEEAf2269602;
	Fri, 16 Oct 2026 16:23:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=5kiEa9fHaMWOgV7RVdeJ7EdoyJCmuJ
	hmUGRAAvXvGyI=; b=ePdYSyqTioUjDmVfrHcmut7Ml7PBibl/3E+Sl6iCeSL11L
	N+/1CQNtq9q9h09oiPDK6XgwYUKb+89db4gniSwoiechfAswnpnLnohzy9OCISpc
	JOcNsLjShM3QzHkIE7haYPFTwuKoFohhrMkuAzYJAtzN8U5Y2UqySuOI3sfEcM6S
	7/+0xfmFL8lYoaqJW8t60eeEky73cuYhnzRTqCObQrW5aDGeSDYe/9kkH26WRxVI
	K61PrcC5jbGjy8rBSKO+9RbhhNUK31FRyJyQ4T8yKUKk91wJYqe0Vk9/SqICxH+l
	5ePym6lzE30OXLX4zTlVGMk/oAVzXnHADelMqyqQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h7dwj0bsw-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 16:23:38 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69GEKTkJ3785918;
	Fri, 16 Oct 2026 16:23:38 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h9ypqc6b5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 16:23:38 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69GGNbI54719164
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Oct 2026 16:23:37 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8844D5805D;
	Fri, 16 Oct 2026 16:23:37 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 478D758058;
	Fri, 16 Oct 2026 16:23:37 +0000 (GMT)
Received: from d (unknown [9.61.189.254])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 16 Oct 2026 16:23:37 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-bot@kernel.org
Cc: sashiko-reviews@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v14 10/11] scsi: ibmvfc: register and use asynchronous
 sub CRQ for events
In-Reply-To: <sashiko-outbox-173070@kernel.org> (sashiko-bot@kernel.org's
	message of "Thu, 15 Oct 2026 15:28:19 +0000")
References: <20261015-ibmvfc-fpin-support-v14-0-a0b063b8d825@linux.ibm.com>
	<20261015-ibmvfc-fpin-support-v14-10-a0b063b8d825@linux.ibm.com>
	<sashiko-outbox-173070@kernel.org>
Date: Fri, 16 Oct 2026 11:23:36 -0500
Message-ID: <87mrsdbomv.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA2NCBTYWx0ZWRfX9iXjKi2hl5E+
 UnHws+RQpPZPlY420Y/ucPnd/zpr1BjkJ2kG7xQh6Hg39Yxi657ts4tq4w45M9QQ5VbYLvnkVw4
 XgvZXkXMJZ71WTZLrJ2Q26DoBcKPvSc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA2NCBTYWx0ZWRfX2flXlnI0sk7M
 0jhnt6+URby/UcAqEJ2K1VVOxSdmcnU3CFU7ImwJiriC+Wpi1rSWik8zcWp5CzPkhIT3yBuTdpE
 RvVJri+mY9bszJY0Z4b9luK8IuA93Oo6iAQ1FydfAmL0MG6NeOyKhimLZ7l3UNMMb2KaNfLT2VF
 S9vbLGbmhiJoL1XKpSTY7bZT6Z8ilbZch53O0Z9J7IRCy82gn7W0Ed1Pwg0xoffWwGfTfQ7TJaf
 UwKmq4z3VlMudd8pHqCxVN9XSaUXUZdqLXI8xxAc7PwGGijIag6wJzUeiPobXGiVxzDp6rTn7pa
 f4eCWNycrs4ZiusQGpCgPb1FgIlefuUO5rFhBo9SSVMrD46Dvv0n/VCLjjBmSFSKHoyBd/KpTN5
 hotpcqaXqXJ+oZDuLwZbPjPlHw/L9P3unPxUNodhf+MxMUsYT3fdl6hYhUbvDcsjv+rC0YD+tD8
 e7wWXUpUO4pCSizapCQ==
X-Proofpoint-GUID: HnEJ0JJr7iLDbl6tTZbl9YFT5_njgH9i
X-Authority-Analysis: v=2.4 cv=RoFQvymK c=1 sm=1 tr=0 ts=6ad24f8a cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=UOPc1gLBq9Gu-FjWPGEA:9
X-Proofpoint-ORIG-GUID: HnEJ0JJr7iLDbl6tTZbl9YFT5_njgH9i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_02,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0 bulkscore=0
 impostorscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610160064

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [Critical] scsi: ibmvfc: DMA Use-After-Free due to skipped sub-CRQ deregistration
> - [High] scsi: ibmvfc: data race on host state bitfields due to lockless mq_enabled write
> - [High] scsi: ibmvfc: missing bounds check on active_queues causes heap overflow
> --
>
> commit 4d5dd0876862baa994058a6b3ad652d84e0497a5
> Author: Dave Marquardt <davemarq@linux.ibm.com>
>
> scsi: ibmvfc: register and use asynchronous sub CRQ for events
>
> Wire the async sub-CRQ into the sub-CRQ lifecycle so it is allocated,
> registered, and freed alongside the SCSI channel queues.
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index b12655f028879..594e5f136040a 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> [ ... ]
>> @@ -5817,6 +5824,7 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
>>  		vhost->do_enquiry = 0;
>>  		scsi->active_queues = be32_to_cpu(setup->num_scsi_subq_channels);
>>  		nvme->active_queues = be32_to_cpu(setup->num_nvme_subq_channels);
>
> [Severity: High]
> Does this code overflow scsi->scrqs[] or nvme->scrqs[] if the hypervisor
> returns a value for setup->num_scsi_subq_channels or
> setup->num_nvme_subq_channels that is larger than the allocated
> scsi->max_queues or nvme->max_queues?
>
> The active_queues values are read directly from the hypervisor response
> without any bounds checking, and are then used as limits in the
> initialization loops below.
>
> If a buggy or malicious hypervisor sends excessively large values, could it
> cause an out-of-bounds write into the scrqs array or cause page faults on
> the setup buffer?

I will clamp the values to the minimum of the hypervisor value and the
max_queues value of the ibmvfc_channel structures.

>> +		async->active_queues = (async->scrqs && setup->async_sub_crq_handle) ? 1 : 0;
>>  
>>  		if (flags & IBMVFC_CHANNELS_CANCELED) {
>>  			ibmvfc_dbg(vhost, "Channels Canceled\n");
>> @@ -5832,6 +5840,8 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
>>  		for (i = 0; i < nvme->active_queues; i++)
>>  			nvme->scrqs[i].vios_cookie =
>>  				be64_to_cpu(setup->channel_handles[scsi->active_queues + i]);
>> +		for (i = 0; i < async->active_queues; i++)
>> +			async->scrqs[i].vios_cookie = be64_to_cpu(setup->async_sub_crq_handle);
>>  
>>  		ibmvfc_dbg(vhost, "Using %u SCSI channels\n",
>>  			   scsi->active_queues);
> [ ... ]
>> @@ -6988,6 +7004,7 @@ static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
>>  			for (j = i; j > 0; j--)
>>  				ibmvfc_deregister_channel(vhost, channels, j - 1);
>>  			vhost->do_enquiry = 0;
>> +			vhost->mq_enabled = 0;
>
> [Severity: High]
> Since vhost->do_enquiry and vhost->mq_enabled are bitfields, these
> assignments compile into read-modify-write operations on the containing
> word.
>
> ibmvfc_reg_sub_crqs() is called by worker threads like
> ibmvfc_reenable_crq_queue() outside of the host_lock.
>
> If a tasklet concurrently processes an event and calls a completion handler
> like ibmvfc_channel_setup_done() (which executes under host_lock and writes
> to another bitfield in the same word, such as vhost->using_channels = 1),
> could this lockless read-modify-write overwrite the locked modifications
> and corrupt the host state machine flags?

Yes. I'll add holding the host lock while making these updates.

> [Severity: Critical]
> If channel registration fails here, vhost->mq_enabled is cleared to 0.
>
> Since async_scrqs is successfully registered earlier in
> ibmvfc_init_sub_crqs(), when teardown happens, ibmvfc_release_sub_crqs()
> will call ibmvfc_dereg_sub_crqs() for async_scrqs.
>
> However, ibmvfc_dereg_sub_crqs() returns immediately if
> !vhost->mq_enabled:
>
> drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_dereg_sub_crqs() {
>     if (!vhost->mq_enabled || !channels->scrqs)
>         return;
>     ...
> }
>
> Will this cause ibmvfc_dereg_sub_crqs() to bypass deregistering the async
> sub-CRQ, leaving the hypervisor DMA mappings and IRQ handlers active while
> the memory is subsequently freed by ibmvfc_release_channels()?

Fixed in other patch fixes.

-Dave
