Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E9C4CC29F;
	Tue,  8 Sep 2026 19:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788897130; cv=none; b=DEe7OkTEQcnja7RgkDjUzNc4lZBBjq2xH4QLnmiKQZ0L8M/7BPZWJjjZDXYqJW0/lH2NGLAjXa+hD0LKT/NQuvctJYVJ+32/Srd8OjOHzLp3fcniw8HO3VAJPOr/K5b5CfQTjAA4y5eNcDoMfpS/J5SNF9HLpDFMZwcGxkqmqUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788897130; c=relaxed/simple;
	bh=buk9Et0pjaGB+CwfO6slRUsttAZBlgTAJDwxrRYxNeI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=FvCjuXqzggEu8yooQv8MUJ3q6gW7K0T2oHridGbxejCraHTnvyETkhjyu95xEXmlfmn3WNpTVj9gWdqUZcYZtefs7Y78VA/8FkRmq7ucBhwtjuwudlaU/p7X8CpYvZMD+8xueuuxD4PYeJ+ToeaG3nKaLO5CxC1A6e/qa3E6ZLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=f16UjN7W; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="f16UjN7W"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688F1erX3545271;
	Tue, 8 Sep 2026 19:52:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=LaFi3VQSmIrrxSVX9mzYsclfDACrlD
	xb3sAl4dFz0FM=; b=f16UjN7W88ma6pbCjlCEicxcH8TH0oykSPRMDyM11PFq40
	7QOCRdaU47VJqnXqUUdNQGlor4pqDECGje9SJaRPHR8GmYqesVUugUOU+GC2Mt5r
	TvKg69WlhBSrWnDBc/ROCFMZxrlWKB/K1FsRRE2ENB2HGUslt/w8+ZvDzdg7Mzfb
	eAnS8IRmCON7nbygxXYaIdaJeZsfZKMDPTLOIRTWyOL91XIiOT9/qoukYL7fHsqG
	gbJ6qyvRPG1rDBerPf6gjKgNrm6r2bEmjp4Oqp3R29zCPYkkmn+deGUj92GXmmLq
	4a+URpW57nqaJ30mTY8U/3alLuc6HWj+MtIovOJg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbqk1gcr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Sep 2026 19:52:07 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 688JfFYu008135;
	Tue, 8 Sep 2026 19:52:06 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gh03yduc5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Sep 2026 19:52:06 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 688Jq52D17695240
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 8 Sep 2026 19:52:05 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CC4BD5805F;
	Tue,  8 Sep 2026 19:52:05 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9B5515805A;
	Tue,  8 Sep 2026 19:52:05 +0000 (GMT)
Received: from d (unknown [9.16.41.19])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  8 Sep 2026 19:52:05 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH v7 7/8] scsi: ibmvfc: register and use asynchronous sub
 CRQ for events
In-Reply-To: <20260831224601.C23911F000E9@smtp.kernel.org>
References: <20260831-ibmvfc-fpin-support-v7-0-77d0b9809080@linux.ibm.com>
	<20260831-ibmvfc-fpin-support-v7-7-77d0b9809080@linux.ibm.com>
	<20260831224601.C23911F000E9@smtp.kernel.org>
Date: Tue, 08 Sep 2026 14:52:05 -0500
Message-ID: <8733vj34ii.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zBazI-BFkGTMQD4OsPuOdYUnnyfN64MP
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDIxMyBTYWx0ZWRfX151scRjXS33R
 qu2eLDl4RHGhhywIFAbdqBat6Hn8oUrjFOS8I/Q/r1a/uYWW1A9Wc68mpMTd44HzqFkVqMv1iyH
 Aua5cOq2vq1zjSXuWIRhYEPtgLEWdrY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDIxMyBTYWx0ZWRfX+yDRCQz+lV3m
 fffFEytKg1vopCK8QDZo+YgLLW993fPppKTQLAbRtgRT4FdVWOlujRM2nqzM3Y2GcmcEX5Sgk53
 M3YqJp8/Vt6dPo3OnrjYg9YpUSdkXBp2B0L4qZllwSuRESFN9oFdvQyXyH8y7gIeHPhD04tvLK7
 sUlHdYELUKT5vbllACtHQsjb2mMz8eMAixwTwCO7OxE2iWru6jySNI8i8PYmcDXJVwq7IH+pKWa
 7RNBiUej5PBl4hGxEnaW2MaWX+i6xtpagz6glurx0pHxFvW1SsUFRleD0RRE4gghs+XMipu6tnn
 Ml9L6kI5DPj3kYn2ftOOocX54CHe5v7I4b/qomF+Davw4W3cvnO1secGUMsUmQkJFcj49NjMy6N
 o72eOFUyS7uM1idq2EaEVrpUGrz7TniXt6jPJuP2w2VE6/PXEWjTV97svoeqQsHtB0YJoXegG4u
 MvcG4eYheDH1OXvrNBA==
X-Authority-Analysis: v=2.4 cv=JaKMa0KV c=1 sm=1 tr=0 ts=6aa06767 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=BbhNMpo0M7q8ANbAelkA:9
X-Proofpoint-GUID: zBazI-BFkGTMQD4OsPuOdYUnnyfN64MP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080213

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
>
> New issues:
> - [High] Unconditional deregistration of the uninitialized async sub-CRQ causes a NULL pointer dereference.
>
> Pre-existing issues:
> - [High] Buffer overflow due to out-of-bounds array writes and reads when processing unvalidated queue counts from the VIOS.
> --
>
> commit 908a7af2b04b0b17f4fc0a40814f0dacec88332a
> Author: Dave Marquardt <davemarq@linux.ibm.com>
> scsi: ibmvfc: register and use asynchronous sub CRQ for events
>
> This commit wires the asynchronous sub-CRQ into the sub-CRQ lifecycle so it is
> allocated, registered, and freed alongside the SCSI channel queues. It modifies
> multi-queue initialization and teardown paths to accommodate the new queue and
> advertises relevant capabilities to the VIOS.
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index cc1ef82580608..adc730af67d2b 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>
> [ ... ]
>
>> @@ -5800,6 +5808,7 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
>>  		for (i = 0; i < nvme->active_queues; i++)
>>  			nvme->scrqs[i].vios_cookie =
>>  				be64_to_cpu(setup->channel_handles[scsi->active_queues + i]);
>> +		vhost->async_sub_crq.vios_cookie = be64_to_cpu(setup->async_sub_crq_handle);
>>  
>>  		ibmvfc_dbg(vhost, "Using %u SCSI channels\n",
>
> [Severity: High]
> This is a pre-existing issue, but can this out-of-bounds write occur if the
> VIOS returns untrusted queue counts?
>
> In ibmvfc_channel_setup_done(), the driver reads num_scsi_subq_channels and
> num_nvme_subq_channels from the VIOS response into active_queues without
> validating them against the dynamically allocated max_queues array size:
>
> ibmvfc_channel_setup_done() {
>     scsi->active_queues = be32_to_cpu(setup->num_scsi_subq_channels);
>     nvme->active_queues = be32_to_cpu(setup->num_nvme_subq_channels);
>     ...
> }
>
> The loop just above this patch hunk then directly uses this unvalidated value
> to write to the scrqs array:
>
> ibmvfc_channel_setup_done() {
>     ...
>     for (i = 0; i < scsi->active_queues; i++)
>         scsi->scrqs[i].vios_cookie =
>             be64_to_cpu(setup->channel_handles[i]);
>     ...
> }
>
> Could a compromised or malfunctioning VIOS provide values that exceed the
> locally allocated array size and cause a buffer overflow here?

We've always assumed the VIOS acts sanely. This issue will not be fixed
at this time.

> [ ... ]
>
>> @@ -7055,6 +7087,9 @@ static void ibmvfc_release_channels(struct ibmvfc_host *vhost,
>>  static void ibmvfc_release_sub_crqs(struct ibmvfc_host *vhost)
>>  {
>>  	ENTER;
>> +	ibmvfc_deregister_channel(vhost, &vhost->scsi_scrqs, -1);
>> +	ibmvfc_free_queue(vhost, &vhost->async_sub_crq);
>> +
>>  	if (!vhost->scsi_scrqs.scrqs)
>>  		return;
>
> [Severity: High]
> Does this unconditional teardown cause a NULL pointer dereference when
> multi-queue is disabled?
>
> During module unload or reset, if multi-queue was disabled (mq_enabled=0) or
> initialization failed, vhost->async_sub_crq is left zero-initialized.
>
> Unconditionally calling ibmvfc_deregister_channel() routes to a cleanup path
> that behaves as follows:
>
> ibmvfc_deregister_channel() {
>     ...
>     /* Clean out the queue */
>     memset(scrq->msgs.crq, 0, PAGE_SIZE);
>     ...
> }
>
> Since msgs.crq aliases the unallocated msgs.handle (which is NULL), will this
> memset() write 4KB of zeroes to a NULL pointer and cause a deterministic
> kernel panic?

A new check against scrq->msgs.handle will be added to
ibmvfc_deregister_channel() in the next revision of this patch,
preventing memset() against a NULL pointer.

-Dave
