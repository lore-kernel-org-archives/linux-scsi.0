Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED490415B8D;
	Tue, 13 Oct 2026 22:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791928950; cv=none; b=OWwJZ/NDu0nW+oAYsJbkXoGe/8j5/b7FmY3//hmz41F7XpFp+dA1X+ZI9vZGUGmEnOMEANhuX0s2KWoPrcLeEhEpuzBkekqMDcp0Rn31dehBnQHT+7AF4wJsDyaX3tuRzu8O5gsmX1Vc1EyagSiZB59joRnZc6PKUoU4x0PVIbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791928950; c=relaxed/simple;
	bh=OK/EsuNv00L0Y4JX482L+kf0TNIBxs4e6ZbS2ZT12Pk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=VMMJCg/9lkilrTUXgzMX+NnO9hwj6BQIEEENyl3YGl5IueK0oTMs7i3LKq7yGNIhUHRDXd9/OSICn7McbsSXOsRf5ZRC2pbtRVWMef65mVgYeCo/IuzEi8IJFOKG6VmMz90odm+XHrDUxmCs2rJKkbL8ixfj536l5HgdYKAIjX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NNhC4EA1; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NNhC4EA1"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69DLqj2u2017848;
	Tue, 13 Oct 2026 22:02:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=NHnOFQUdTE+bIspnZ6rqBCWheBXRes
	FS1mxh8ZLb4Dk=; b=NNhC4EA1pmMCvivmaJwIa9acUQMNyD3pdKoP+ZiJHsOiGw
	HiKUES/DSF3QuZvzewr/Z01u3vQlLlyq4+0yTR9fPDWGREthRXrhJ1WTYAHdKz+A
	RzSLM6ghEgGczQ1swYDVuPgkkBe8baVi2fn2QDMvM9X/qV9vS1BBX7Ksqh4kPlcp
	8N3xEHIYHtTixUM+VkMLg3y6PB1Vi10cfbCGhPx8jiF4UFBg0y9wXAHZLmt9NJFG
	CpjqMFtLCqCq253bRKt0Mtr3ox1UV0Nqr10fkOF36uD/uYNRDvgPjqwlltr9Qbam
	k5iGJot2DKGEcSCs7q2PBH+CLYU7RCcIAj/mVk5w==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h7dugh5vb-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 13 Oct 2026 22:02:26 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69DL5lF73303974;
	Tue, 13 Oct 2026 22:02:25 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4h9qb6sxp0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 13 Oct 2026 22:02:25 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69DM2PeP27066982
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 22:02:25 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5BFED58055;
	Tue, 13 Oct 2026 22:02:25 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4045E58059;
	Tue, 13 Oct 2026 22:02:25 +0000 (GMT)
Received: from d (unknown [9.16.59.154])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 13 Oct 2026 22:02:25 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-bot@kernel.org
Cc: sashiko-reviews@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v13 10/11] scsi: ibmvfc: register and use asynchronous
 sub CRQ for events
In-Reply-To: <sashiko-outbox-163319@kernel.org> (sashiko-bot@kernel.org's
	message of "Wed, 07 Oct 2026 19:42:45 +0000")
References: <20261007-ibmvfc-fpin-support-v13-0-b816abfa4fcc@linux.ibm.com>
	<20261007-ibmvfc-fpin-support-v13-10-b816abfa4fcc@linux.ibm.com>
	<sashiko-outbox-163319@kernel.org>
Date: Tue, 13 Oct 2026 17:02:24 -0500
Message-ID: <87ik35b6of.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Cr0q4X4D c=1 sm=1 tr=0 ts=6aceaa72 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=ci5VvnE7D6JisPpjIkMA:9
X-Proofpoint-GUID: yLGxfJ1kG5IF19FU3LJWJONwsaQa_ZxI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDA4NiBTYWx0ZWRfX9zCN79dd9WGT
 LuIAP76FGAPUIWBAE6Z8Pz2zSvLXRpjFbK+HuRaoMAfVy7TJ2o5fHxKdVjoxPtzakUpRNV9mCXC
 D4iQtppd1ageqMhQ/rVfxxAFR43VFdJPaqij65FKOy2CO9sKigCjC3ICaZm+ROQr10Ss39XKn3P
 ovZTHJ180rLWRRH9akBgd9CNy4t2dX0609D86dwDO/FuYw2pT/Ghlx1iBvQWIZLw30gpWi9h+nE
 EPbn/8tZKCaF7PG5MglJuz1sXi3NOHd0ADFBpFMRZIcZwXKiwWABRnao0sYeg5pgpOyQHq6yxO7
 jeylNj2DjdTCBNcXpdGeOncPCtxIJaeJLyml6+aXeocV6QnS1BDsIWPXq6OFwOCaPMV9DgITGgb
 +4EiNJQVh+XIKYimB0zhxJLFQ2gxnd27FqQ4+MUPNXZnlEhixrYDHIzpLgkLUg1Thh7ulxFdsB3
 LoW07IyIMp7qqaUKw0Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDA4NiBTYWx0ZWRfX+nMUJaKW3SzB
 /6RkbVMURG4xHu+YjOy6rFksTuZxEO+2x1+smtj1YDpQ6ifOFj2ojo7ogaMgsHc1BBNpgELjRMN
 5cMqFXl2CJxTwBfiKDrWjf5zVTNypGY=
X-Proofpoint-ORIG-GUID: yLGxfJ1kG5IF19FU3LJWJONwsaQa_ZxI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610130086

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] scsi: ibmvfc: host state machine stall if ibmvfc_reg_sub_crqs() fails
> - [High] scsi: ibmvfc: NULL pointer deref in channel setup when mq_enabled=0
> --
>
> commit 3dd02df8d62690f440ff03238afa2613397c578a
> Author: Dave Marquardt <davemarq@linux.ibm.com>
>
> scsi: ibmvfc: register and use asynchronous sub CRQ for events
>     
> Wire the async sub-CRQ into the sub-CRQ lifecycle so it is allocated,
> registered, and freed alongside the SCSI channel queues. Updates
> ibmvfc_set_login_info() to advertise related capabilities.
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index 76246002ac724..acc11f3a237e1 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> [ ... ]
>> @@ -5821,6 +5828,7 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
>>  		for (i = 0; i < nvme->active_queues; i++)
>>  			nvme->scrqs[i].vios_cookie =
>>  				be64_to_cpu(setup->channel_handles[scsi->active_queues + i]);
>> +		async->scrqs[0].vios_cookie = be64_to_cpu(setup->async_sub_crq_handle);
>
> [Severity: High]
> Can this cause a NULL pointer dereference when the module parameter mq_enabled
> is 0?
>
> If mq_enabled is 0, ibmvfc_init_sub_crqs() returns early and skips allocation,
> leaving async->scrqs as NULL but vhost->do_enquiry as 1.
>
> If the VIOS later advertises IBMVFC_CAN_SUPPORT_CHANNELS during NPIV login,
> ibmvfc_npiv_login_done() sees do_enquiry is true and issues a channel enquiry.
> When that completes, we reach this code and unconditionally dereference the
> unallocated async->scrqs array.

Yes, it is a problem! I will fix in v14. 

> [ ... ]
>> @@ -5880,6 +5889,7 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
>>  		for (i = 0; i < nvme_channels; i++)
>>  			setup_buf->channel_handles[scsi_channels + i] =
>>  				cpu_to_be64(nvme->scrqs[i].cookie);
>> +		setup_buf->async_sub_crq_handle = cpu_to_be64(async->scrqs[0].cookie);
>>  	}
>
> [Severity: High]
> Similarly, can this unconditional access to async->scrqs[0].cookie trigger a
> NULL pointer dereference when mq_enabled is 0?

Yes.

> [ ... ]
>> @@ -7023,17 +7039,38 @@ static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
> [ ... ]
>>  static void ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
>>  {
>>  	ENTER;
>>  	if (!vhost->mq_enabled)
>>  		return;
>>  
>> -	if (ibmvfc_alloc_channels(vhost, &vhost->scsi_scrqs)) {
>> -		vhost->do_enquiry = 0;
>> -		vhost->mq_enabled = 0;
>> -		return;
>> -	}
>> +	/* register async_sub_crq channel */
>> +	if (ibmvfc_alloc_channels(vhost, &vhost->async_scrqs))
>> +		goto out;
>> +
>> +	ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs);
>
> [Severity: High]
> Does this cause a host state machine stall if ibmvfc_reg_sub_crqs() fails?
>
> If ibmvfc_reg_sub_crqs() fails internally, it clears vhost->do_enquiry but
> leaves vhost->mq_enabled set to 1. Because mq_enabled remains true,
> ibmvfc_set_login_info() continues to advertise IBMVFC_CAN_USE_CHANNELS to
> the VIOS.
>
> When the VIOS responds with IBMVFC_CAN_SUPPORT_CHANNELS,
> ibmvfc_npiv_login_done() enters the multi-queue branch, but because
> do_enquiry is now 0, it skips calling ibmvfc_channel_enquiry().
>
> It also bypasses the fallback block that would normally set
> IBMVFC_HOST_ACTION_QUERY and wake up vhost->work_wait_q:
>
> drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_npiv_login_done() {
>     if (ibmvfc_check_caps(vhost, IBMVFC_CAN_SUPPORT_CHANNELS)) {
>         if (ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_SCSI))
>             vhost->do_scsi_login = 1;
>         if (ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_NVMEOF))
>             vhost->do_nvme_login = 1;
>         if (vhost->do_enquiry)
>             ibmvfc_channel_enquiry(vhost);
>     } else {
>         vhost->do_enquiry = 0;
>         ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
>         wake_up(&vhost->work_wait_q);
>     }
> }
>
> Will this cause the initialization process to stall indefinitely in
> IBMVFC_HOST_ACTION_INIT_WAIT?

Yes, this appears to cause a stall.

-Dave
