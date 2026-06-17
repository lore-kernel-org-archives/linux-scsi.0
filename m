Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BD12DB7A3;
	Wed, 17 Jun 2026 19:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781725615; cv=none; b=m2cp8J2zJW20Ug+K1xHI+Dx3jOM4SWVmSWFb0nG76+YnEakAuVAPbtqjE0/SlEre2m6K7Qt5DCJVmO6Mf8JyU4X/gy2l8nDAw0L9orfJ3TKVtuVvUhQnU7RsroQCtMS7s7+z5Y0SDWK02LfBDfzUUGa+oVML8ASOcxEnFHs16p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781725615; c=relaxed/simple;
	bh=8JTU7UxbTbE06AkjS2t4gSCVHtWGmUVh3YE6vkISARI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=n1RKfbwO3hLvcjXFTz026WUZk2Ya7Vz3RAavaTWD0PshgBhX/WO3+Zh14V51zqPhQn0bc/qrluH+Q/IkbyMAXSdjd+N3MQMOezSwPNFF8RIKU7RwNwgnzRn3nEFRFkqF5eAgrDaTrk8tgr/GxGh8zdBdsdzbhJyNPb9LbdC5bM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BfQn0ETP; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BfQn0ETP"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65HHmCSR1082447;
	Wed, 17 Jun 2026 19:46:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=Z3rebz/z5OzZE6RQuTTAguKU0UekT4
	SohTdWB7PpYP8=; b=BfQn0ETP8bG6VU4jOxobhHgO/18z4P3NIOiFvh6qQTyvuq
	sfwdtBXb7v3Yj3odEGPhet/kALHhdpbQOvs+dVdBauRplbF09gnhepKWYP8RUos2
	+jsg6l0xxumLRUpeFp14K4hhC0WbsFhbNuNkoBxaZff3bVLJme98xKmjBrPkvHnp
	89Ww9PP/eA8pV0wkxXh22ZtmTWMCPOToAKLnT+pSmw4CfDxPeJ2ESgEJfONtW3Xf
	AKIRFiJdWqf7ie/2+E3/uZOYSUtEYcT1dhR6CBfV7RSEdz+YtHOJtqQX4FhZEQV8
	/TKOffVIoufssv/SmUTUbPw/jC7ckRJaekAK9PGg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4eueqvvs9r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Jun 2026 19:46:39 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65HJYdYF016545;
	Wed, 17 Jun 2026 19:46:37 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ev17287du-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Jun 2026 19:46:37 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65HJkaL322872602
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Jun 2026 19:46:36 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 46B4458065;
	Wed, 17 Jun 2026 19:46:36 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9855858063;
	Wed, 17 Jun 2026 19:46:35 +0000 (GMT)
Received: from d (unknown [9.16.41.19])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 17 Jun 2026 19:46:35 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        Madhavan Srinivasan
 <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas
 Piggin <npiggin@gmail.com>,
        "Christophe Leroy (CS GROUP)"
 <chleroy@kernel.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Brian King
 <brking@linux.ibm.com>,
        Greg Joyce <gjoyce@linux.ibm.com>,
        Kyle Mahlkuch
 <kmahlkuc@linux.ibm.com>
Subject: Re: [PATCH v2 5/7] ibmvfc: allocate asynchronous sub-queue
In-Reply-To: <09278991-08df-4b99-9076-8f90689412ee@linux.ibm.com>
References: <20260608-ibmvfc-fpin-support-v2-0-d41f540fba5c@linux.ibm.com>
	<20260608-ibmvfc-fpin-support-v2-5-d41f540fba5c@linux.ibm.com>
	<09278991-08df-4b99-9076-8f90689412ee@linux.ibm.com>
Date: Wed, 17 Jun 2026 14:46:34 -0500
Message-ID: <87ik7har1h.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE3MDE4NiBTYWx0ZWRfXxUWZHn1+cqTr
 YSKU/8DFaQUdVLbodmEi6GN3hYt+kNcm/dE1ZPzoijaEQPvkXUQEe+HzFVoEYKADMVHJ2UOcV4G
 DRnvj5LhO5IyWcZXLqhP72xh1obxx7I=
X-Proofpoint-GUID: fnxEb9MJ4lM3AATC1O9u7RLfM7B84yYf
X-Authority-Analysis: v=2.4 cv=bMgm5v+Z c=1 sm=1 tr=0 ts=6a32f99f cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=HaNE_Ar9JYGMzoPkwGYA:9
X-Proofpoint-ORIG-GUID: OwpmVo_IkBAPvy1AFw_DtdXG9Vn7DItS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE3MDE4NiBTYWx0ZWRfXy3de5X5jmpeT
 6XAKcC7xRr2LVx7UKrep0gwcxlaySu3NAsbiDm0TgXWOfdxqi52549wxK00EIOV4EZHd0FLklse
 t3CSvKNZ9fX8EgG7qonY7/lsdnHqU9X5v7YFUHS4lOEopJ5jkQf3gGk3mcH2u5vYVGYrYs4MwEj
 P9fMIxlg+3jGR4OQfChNC2yeJE3iMUy3drEtXOMYvev49B+Z0JIwcc1hGADx1/MbIYWMR/CDrXt
 X1KKskcN/fIkP23dl7G0CICOpYNITzIxdKFUS/2BB5V2jTtW10NuxLvUnlutB2PmAsLz3V3dcSu
 2wnECFlFOaasMmAyT3HnRbKTCLtcACZDjy68d7c8GxmSedJcGmEC98LJHDvaOVZ4qtyvgo6AjhX
 6/Bu1EFLxtqTfvdl3akbdhjMLTbtYobw/wAQLXghBWfbvcy0/Hi7VqrJQUQBZlhiJescmwQqKfL
 /UL1Z31wLvb/aWG3MuQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-17_02,2026-06-17_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 priorityscore=1501 phishscore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606170186

Tyrel Datwyler <tyreld@linux.ibm.com> writes:

> On 6/8/26 11:30 AM, Dave Marquardt via B4 Relay wrote:
>> From: Dave Marquardt <davemarq@linux.ibm.com>
>> 
>> Allocate and set up the asynchronous sub-queue for asynchronous
>> events, as required for full and extended FPIN support.
>> ---
>>  drivers/scsi/ibmvscsi/ibmvfc.c | 28 ++++++++++++++++++++++++++++
>>  1 file changed, 28 insertions(+)
>> 
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
>> index a18861808325..ad1f5636e879 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
>> @@ -5352,6 +5352,8 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
>>  			for (i = 0; i < active_queues; i++)
>>  				scrqs->scrqs[i].vios_cookie =
>>  					be64_to_cpu(setup->channel_handles[i]);
>> +			scrqs->async_scrq->vios_cookie =
>> +				be64_to_cpu(setup->asyncSubqHandle);
>>  
>>  			ibmvfc_dbg(vhost, "Using %u channels\n",
>>  				   vhost->scsi_scrqs.active_queues);
>> @@ -5402,6 +5404,7 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
>>  		setup_buf->num_scsi_subq_channels = cpu_to_be32(num_channels);
>>  		for (i = 0; i < num_channels; i++)
>>  			setup_buf->channel_handles[i] = cpu_to_be64(scrqs->scrqs[i].cookie);
>> +		setup_buf->asyncSubqHandle = cpu_to_be64(scrqs->async_scrq->cookie);
>>  	}
>>  
>>  	ibmvfc_init_event(evt, ibmvfc_channel_setup_done, IBMVFC_MAD_FORMAT);
>> @@ -6369,6 +6372,24 @@ static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
>>  	if (!channels->scrqs)
>>  		return -ENOMEM;
>>  
>> +	channels->async_scrq = kzalloc_obj(*channels->async_scrq, GFP_KERNEL);
>> +
>> +	if (!channels->async_scrq) {
>> +		kfree(channels->scrqs);
>> +		channels->scrqs = NULL;
>> +		return -ENOMEM;
>
> This failure cleanup code starts duplicating here.
>
>> +	}
>> +
>> +	rc = ibmvfc_alloc_queue(vhost, channels->async_scrq,
>> +				IBMVFC_SUB_CRQ_FMT);
>> +	if (rc) {
>> +		kfree(channels->scrqs);
>> +		channels->scrqs = NULL;
>> +		kfree(channels->async_scrq);
>> +		channels->async_scrq = NULL;
>
> Again here plus freeing channels->scrqs memory.
>
>> +		return rc;
>> +	}
>> +
>>  	for (i = 0; i < channels->max_queues; i++) {
>>  		scrq = &channels->scrqs[i];
>>  		rc = ibmvfc_alloc_queue(vhost, scrq, IBMVFC_SUB_CRQ_FMT);
>> @@ -6380,6 +6401,9 @@ static int ibmvfc_alloc_channels(struct ibmvfc_host *vhost,
>>  			kfree(channels->scrqs);
>>  			channels->scrqs = NULL;
>>  			channels->active_queues = 0;
>> +			ibmvfc_free_queue(vhost, channels->async_scrq);
>> +			kfree(channels->async_scrq);
>> +			channels->async_scrq = NULL;
>
> And then again here. Could use goto to do the frees at the end of the function.
>
> free_async:
> 	kfree(channels->async_scrq);
> 	channels->async = NULL;
> free_scrqs:
> 	kfree(channels->scrqs);
> 	channels->scrqs = NULL;
>
> return rc;
>
>>  			return rc;
>>  		}
>>  	}
>> @@ -6418,6 +6442,10 @@ static void ibmvfc_release_channels(struct ibmvfc_host *vhost,
>>  
>>  		kfree(channels->scrqs);
>>  		channels->scrqs = NULL;
>> +
>> +		ibmvfc_free_queue(vhost, channels->async_scrq);
>
> Looks like missing kfree(channels->async_scrq) here.

I'll clean this up. Thanks.

-Dave
