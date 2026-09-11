Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43763399361;
	Fri, 11 Sep 2026 03:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789098757; cv=none; b=LJP4QyVO1A858NZUrAn3+kZI69H/tN3aXO/XRmIWeCes5GVUpn81PEJQXEhjJsKClKaXPvthlRHPOJmxaei/rq30pT8jDT538aqE+ExR5g22ri5y6sJVJI9HDhsSnl0n2RcjZffikJnXXgJ/BKrRWD/pgPBoLK5Drs1HDlkYyR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789098757; c=relaxed/simple;
	bh=8EA+Xsx1ImIjrCakqZy6KyuSGR1AdaNQ76qBav/XaUY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RZk21A/xebMRHXygHpybjT415Kqb2AX10axcrsOqRAJetka2uzwua6MhLu52ihgtiHFYhZ9bAjEA/t/9HvPn5pDih7JLTynRNazTO4sC4eWDGhHyC7gL4yYAta6GCg9sUZrDUo/PWe9OVc7PQ+B5vSLV7VL1NJmnb6g6+59pWNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UHgHPYde; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UHgHPYde"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68B12L9f311176;
	Fri, 11 Sep 2026 03:52:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=5MhaLo
	KcHlY4J2M2xUojHgKAHcxvl3si7YN3XD0y+CI=; b=UHgHPYde96VD1ABCeeds5N
	FRwDddMh7ToeXVA1oaJtbn74+cT6qmD0X4DXubocZ4wGNd/XI7MqWYSK/Iqg6VfM
	N9zz40p6trumDfvKjcXXJEW94pFmh0TzRCxVk/Qtb47ay9ETEIKJXn8LeuatcfX3
	YoIMscn94IpauuFzTGah/lvgZFJLDjGGK79gIPf0rWfvuFZVuWaXL7QUM7eIUbXR
	tLl6YR2UkBGO01yqbgIvprzW0UwphiPpQdBlUuVx2qn/lwDajuVJbZb5bvGl097j
	Rl7RV1zRBxknzR/QRRfKhQZBFK4JQ27oXaUfGmXVJVG3689jIqRe+w0CpfPXEwOw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8ps57e-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 03:52:35 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68B15Etb900924;
	Fri, 11 Sep 2026 03:52:34 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gkvnrm6w1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 03:52:34 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68B3qYHr28246672
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Sep 2026 03:52:34 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1A38F58058;
	Fri, 11 Sep 2026 03:52:34 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D6AD058057;
	Fri, 11 Sep 2026 03:52:33 +0000 (GMT)
Received: from [9.61.103.123] (unknown [9.61.103.123])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Sep 2026 03:52:33 +0000 (GMT)
Message-ID: <465e2b19-3886-410e-b9be-5a6810e44c33@linux.ibm.com>
Date: Thu, 10 Sep 2026 20:52:33 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 4/9] scsi: ibmvfc: extend async event handlers for
 async sub-CRQ events
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260911021910.1038128-1-tyreld@linux.ibm.com>
 <20260911021910.1038128-5-tyreld@linux.ibm.com>
 <20260911023904.6A1FE1F000FF@smtp.kernel.org>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <20260911023904.6A1FE1F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=eM2GH3p1 c=1 sm=1 tr=0 ts=6aa37b03 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=gyMG8Wo-JCFS0uZrboUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 9NedwaOgZ8lYN7nJtIZMcVliT0-NoAVd
X-Proofpoint-GUID: 9NedwaOgZ8lYN7nJtIZMcVliT0-NoAVd
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDA0NSBTYWx0ZWRfXxAbeNInYcdW9
 ViYqWplLuC8GYAELeZLbIsTzCnEE/MPERUbox6lPGo7JzTFqV6ujBZwhDJ8g2BF2mSrWfv979r8
 r+e/ZvoqrywxHbed+L4NqGyUi+aWjoU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDA0NSBTYWx0ZWRfX5RXbJDJGNNYG
 vOOvg5XS56qJ7JiBY+YllBO/S3PAq3JHz1Oc0+ajekpS0lJN16g3kLl1PF/B4ngxMH6NL5FLhgr
 urH8tuBWly8CLXfyEhKuDO/oQeh+T8+gb5Rxbvb8DzAmTqVr0f+8B2jTA+hOwrYZLss57AB9MQh
 D40+Lw8lq9PsPExkIXHWe0DeE5W2bzO0x3eP0oVkPxw5xb6t+nQ84xVLOO0f1MGcUmE+GiPnuwi
 cpaRKDm/ky9gErr3vgKE3fCURu6kNMGKjlsJP60Wt4BRUhl2M1Gi16AWKooXD2QHyK1t9zybI9+
 cHjL+8xhCgOmo+jaq0fK9HTZUSOAGFIfMqYZUdvnbbMiWGM9fs+/TAvQuV1ffc85+smXK4p4ec0
 +rtev4O0+Zq4xItqDEyt/mBmysUDd1jmYj1UQL0vuCVXhBU6EY9ciMSXhUpusMF6fb1iD8ycnBY
 6oOipKP0mfaOpAj0VAQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_01,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 malwarescore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110045

On 9/10/26 7:39 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential issue(s) to consider:
> - [High] ibmvfc_find_target() incorrectly skips targets unless they support BOTH SCSI and NVMe, causing FPIN events to be dropped.
> - [Medium] Missing scsi_id extraction for async sub-CRQ events.
> - [Medium] Incorrect WWPN populated in FPIN descriptor for async sub-CRQ events when subq->wwpn is 0.
> - [Low] Missing address-of operator '&' when passing host_lock to spin_lock_irqsave() and spin_unlock_irqrestore(), causing a build failure.
> --
> 
> commit 997e4bca2edfad65478e2c572b7c236ba500e1bb
> Author: Dave Marquardt <davemarq@linux.ibm.com>
> 
> scsi: ibmvfc: extend async event handlers for async sub-CRQ events
> 
> This patch refactors async event handling to support both traditional async
> CRQs and new asynchronous sub-queue CRQs using a tagged union. It also
> updates FPIN processing logic to extract identifiers from the appropriate
> event type.
> 
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index 6b2eb82ceb98d..daec81f48857d 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> [ ... ]
>> @@ -3426,6 +3426,45 @@ ibmvfc_basic_fpin_to_desc(struct ibmvfc_async_crq *crq, u64 wwpn)
>> +static struct fc_els_fpin *
>> +ibmvfc_full_fpin_to_desc(struct ibmvfc_async_sub_crq *ibmvfc_fpin)
>> +{
>> +	__be16 type;
> [ ... ]
>> +	return ibmvfc_common_fpin_to_desc(ibmvfc_fpin->fpin_status, ibmvfc_fpin->wwpn,
>> +					  type, cpu_to_be16(0),
>> +					  cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_THRESHOLD),
>> +					  cpu_to_be32(1));
>> +}
> 
> [Severity: Medium]
> If the async sub-CRQ event arrives with a WWPN of 0 but the target is
> successfully matched via node_name, will this embed a WWPN of 0 into the
> FPIN descriptor?
> 
> It looks like fc_host_fpin_rcv() would then fail to find the remote port by
> WWPN, silently dropping the FPIN and missing statistics updates. Would it be
> safer to pass in the matched tgt->wwpn here, similar to how it's done for
> standard CRQs?

The wwpn and node name should never be zero.

> 
>>  /**
>>   * ibmvfc_find_target - Search for a target in a target list
>>   * @target_list: list head of targets to search
>> @@ -3463,28 +3502,39 @@ static struct ibmvfc_target *ibmvfc_find_target(struct list_head *target_list,
>>   */
>>  static void ibmvfc_process_async_work(struct work_struct *work)
>>  {
>> +	struct ibmvfc_async_sub_crq *subq = NULL;
>>  	struct ibmvfc_async_work *aw;
>> -	struct ibmvfc_async_crq *crq;
>> +	struct ibmvfc_async_crq *crq = NULL;
>>  	struct ibmvfc_target *tgt;
>>  	struct ibmvfc_host *vhost;
>> -	struct fc_els_fpin *fpin;
>> +	struct fc_els_fpin *fpin = NULL;
>>  	unsigned long flags;
>> +	__be64 node_name;
>> +	__be64 scsi_id;
>> +	__be64 wwpn;
>>  
>>  	aw = container_of_const(work, struct ibmvfc_async_work, async_work_s);
>>  	vhost = aw->vhost;
>> -	crq = &aw->crq;
>> +	if (aw->event.type == IBMVFC_ASYNC_CRQ_SUB) {
>> +		subq = &aw->event.subq;
>> +		scsi_id = 0;
> 
> [Severity: Medium]
> The commit message states we "extract WWPN, node_name, and scsi_id from the
> appropriate union member based on event type."
> 
> However, for async sub-CRQ events here and in ibmvfc_handle_async(), scsi_id
> is hardcoded to 0 instead of extracting nport_id from the payload. Could this
> cause target lookup failures if WWPN and node_name happen to be 0?

Again wwpn and node_name should never be zero here.

> 
>> +		wwpn = subq->wwpn;
>> +		node_name = (subq->flags & IBMVFC_ASYNC_ID_IS_ASSOC_ID) ? 0 : subq->id.node_name;
>> +	} else {
>> +		crq = &aw->event.async_crq;
>> +		scsi_id = crq->scsi_id;
>> +		wwpn = crq->wwpn;
>> +		node_name = crq->node_name;
>> +	}
>>  
>> -	if (!crq->scsi_id && !crq->wwpn && !crq->node_name)
>> +	if (!scsi_id && !wwpn && !node_name)
>>  		goto free;
>>  
>>  	spin_lock_irqsave(vhost->host->host_lock, flags);
>> -	tgt = ibmvfc_find_target(&vhost->scsi_scrqs.targets, crq->scsi_id,
>> -				 crq->wwpn, crq->node_name);
>> +	tgt = ibmvfc_find_target(&vhost->scsi_scrqs.targets, scsi_id, wwpn, node_name);
> 
> [Severity: High]
> Does ibmvfc_find_target() incorrectly skip targets unless they support BOTH
> SCSI and NVMe?
> 
> Looking at the implementation of ibmvfc_find_target():
> 
>     if (!tgt->rport || !tgt->nvme_remote_port)
>         continue;
> 
> Because a target represents a single endpoint for a specific protocol (SCSI or
> NVMe), it will only ever have either tgt->rport or tgt->nvme_remote_port,
> never both.
> 
> Because of the logical OR, this condition always evaluates to true. Could this
> effectively break FPIN event handling by causing every target to be skipped?

This was covered in patch 1 and will be fixed in v10.

> 
> [ ... ]
>> @@ -3512,25 +3566,51 @@ static void ibmvfc_process_async_work(struct work_struct *work)
>>  
>>  /**
>>   * ibmvfc_handle_async - Handle an async event from the adapter
> [ ... ]
>>  	if (ae->type == IBMVFC_ASYNC_CRQ_SUB) {
>> -	switch (be64_to_cpu(crq->event)) {
>> +		subq = &ae->subq;
>> +		event = be16_to_cpu(subq->event);
>> +		link_state = subq->link_state;
>> +		scsi_id = 0;
> 
> [Severity: Medium]
> Similarly, this hardcodes scsi_id to 0 for async sub-CRQ events instead of
> extracting it from the event payload.
>

scsi_id is not part of a subq event payload. We set it to zero to ensure we
don't pass junk  to ibmvfc_find_target.

-Tyrel

