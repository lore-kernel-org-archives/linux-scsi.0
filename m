Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2976C576EB7;
	Tue,  8 Sep 2026 19:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788897214; cv=none; b=pkugssNp2r2kIu2DzsSV1SOWh2p000XO8AzBcAN8bwjZLhIU9pGCZS+Kv9OPX3Ylqu9rJdFHnvJoAqSWR+FS/M577tNY7w4/GTwmkDqQSCcPN2KDSgpUw0PCfO7sygVJFu7yCD6aKsuPDNOvHCj+DRnmntDB7HqVOH4taYjGbxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788897214; c=relaxed/simple;
	bh=pXHGJJBNDWiMjwA4qV8h/Ful9DoXYHHEsg+iwVwr5K8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=lhmX7EtChPWIYsgToVCpsX13QLzo7e21D1bugE4z5BT7AqsMzZ1MH1Kxv3JrcOin4Q5Fjm/KQ1n87VbjR2ZGyKOofSEaNs+ivrjfLU69iWe10xd5JrCE0OLU006YH62uwnvCAnXyu2lfzZlFpPvZlXmzGWjnPXGp/lBiNJ82TpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RrZng9/0; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RrZng9/0"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688F1nxb1094819;
	Tue, 8 Sep 2026 19:53:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=5JL/qaMgHGUggvAyDwWB2mPXdhwTEK
	SrZsxhmseJcWk=; b=RrZng9/0I5ttOxGYnRfAj/HdAs8mmzFX3Ertcpq8qDCpt3
	IE7lzW3RKCVYgqf52cm+zWakO7lEr577UgrlUGkwNxb+Jg8xLbH3PEzWI3wjiIX9
	rfbfrUSV9qCCuloSRQ4ivgyL6NKItkEMgH5eFvrHobDHeWbZ0TIQbSq+gTxWIH7/
	4BYoI4d1j68PiYoGQYJVQtbQKxy8QPUOMNgcQ+rJGf2ruyKSnRglOpzJl03cAtsx
	+UNDclQ7KGYfV/QStDkbLDVUqW1g/ELrpLiRhLgttNCYgv/3DMVnXYaa699+AW7N
	MTPQSN7bZgTCHQx43FBVEnByDa59ZslnfTlYUzAQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbj8989c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Sep 2026 19:53:31 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 688JfFZ4027307;
	Tue, 8 Sep 2026 19:53:30 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ggwdqe7f4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Sep 2026 19:53:30 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 688JrTCv39322186
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 8 Sep 2026 19:53:30 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C9A6958062;
	Tue,  8 Sep 2026 19:53:29 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 772B85805A;
	Tue,  8 Sep 2026 19:53:29 +0000 (GMT)
Received: from d (unknown [9.16.41.19])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  8 Sep 2026 19:53:29 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH v7 8/8] scsi: ibmvfc: handle extended FPIN events
In-Reply-To: <20260831225604.007591F000E9@smtp.kernel.org>
References: <20260831-ibmvfc-fpin-support-v7-0-77d0b9809080@linux.ibm.com>
	<20260831-ibmvfc-fpin-support-v7-8-77d0b9809080@linux.ibm.com>
	<20260831225604.007591F000E9@smtp.kernel.org>
Date: Tue, 08 Sep 2026 14:53:29 -0500
Message-ID: <87y0db1pvq.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MxTzPEwDuisfZOKfr45jnTzpFKCzOysH
X-Proofpoint-ORIG-GUID: MxTzPEwDuisfZOKfr45jnTzpFKCzOysH
X-Authority-Analysis: v=2.4 cv=RNCD2Yi+ c=1 sm=1 tr=0 ts=6aa067bb cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=6Gl4y3GjniSOq7oWkPEA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDIxMyBTYWx0ZWRfX/V/thuYqJBC7
 K3TuREw8Uixo6cca72i6zqTDjeNI2m5zHHckprdRJPYRkxshWPwHwMQmUN5ILRik2HGW5Y2ef8K
 xHTO+D6pP9BJdd70GsaVxqQVVBOZI5I=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDIxMyBTYWx0ZWRfX9leIMSyHYqi4
 OG/1my9QwVti/HS4g4B/wFRPgabUcNBTjds6bsmEBmoCA29IH2Z6MAmb1jn4+4psSFwsbqmq8tJ
 VSdBQyoQRzMMgOS66CdqV9sGqw64068TrPeBh0QGaoBRP9FZVuEKXb9xhKOKC1y+GpnRBVr7k0C
 AZeHdzvXRY/sGybjio1FVIJcdanR/GwzLsK2RKunhRdQJHXLM7uPl5V2J0znTOSBTQrmT8QxLY+
 4tBc0cLhWqF1kuD4NOVEqB+Ue0EcdmN/jHK+0M6CBmstgKtz1koTHvxLZmmm+50OSc8nQqz9qbU
 ZVUxHnmTWJa2jUIixfwNhcOUyr/TkrimYNbJ5SFUGExU9ZV7055WTINdjsX9PFaOzUlTRCNN+FH
 +j3NsRh+2iNxlQGpD41Fx/bRCppea3vI0IZeDYOZoaciqKM7bybTfMYKqWfGTY9BJLK0k6aj9lP
 CNYXbfmyfqT7KB12i0Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 clxscore=1015 spamscore=0
 impostorscore=0 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080213

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] The `ibmvfc_extended_fpin_test` test suite is entirely invalid due to missing KUnit assertions and incorrect statistics targeting.
> --
>
> commit 7f2470a8cbfd29182f9253c971ce356e69e43c8e
> Author: Dave Marquardt <davemarq@linux.ibm.com>
>
> scsi: ibmvfc: handle extended FPIN events
>
> Implement support for extended FPIN messages received via the asynchronous 
> sub-queue. Add parsing and processing logic to convert these into 
> fc_els_fpin structures. Include comprehensive KUnit tests to validate the 
> extended FPIN event handling.
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
>> index 47f7c4e79cd81..b016c7da24cd6 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
>
> [ ... ]
>
>> +#define IBMVFC_TEST_FPIN_EXT(fs, ev, stat, crq) {				\
>> +	struct ibmvfc_async_crq_event ae = { .type = IBMVFC_ASYNC_CRQ_SUB };	\
>> +	(crq).valid = 0x80;							\
>> +	(crq).flags = IBMVFC_ASYNC_IS_FPIN_EXT;					\
>> +	(crq).link_state = IBMVFC_AE_LS_LINK_UP;				\
>> +	(crq).fpin_status = (fs);						\
>> +	(crq).event = cpu_to_be16(IBMVFC_AE_FPIN);				\
>> +	(crq).wwpn = cpu_to_be64(tgt->wwpn);					\
>> +	(crq).fpin_data.flags = IBMVFC_FPIN_EVENT_TYPE_VALID;			\
>> +	(crq).fpin_data.event_type = cpu_to_be16((ev));				\
>> +	ae.subq = *(struct ibmvfc_async_sub_crq *)&(crq);			\
>> +	pre = READ_ONCE(tgt->rport->fpin_stats.stat);				\
>> +	ibmvfc_handle_async(&ae, vhost);					\
>> +	flush_workqueue(vhost->fpin_workq);					\
>> +	post = READ_ONCE(tgt->rport->fpin_stats.stat);				\
>> +}
>
> [Severity: Medium]
> Does this macro actually verify the statistics have changed? It captures the
> pre and post state, but doesn't appear to perform any KUnit assertions
> (like KUNIT_EXPECT_GE) to validate the test results.

This test is about exercising the extended FPIN functionality, and does
not test for correctness. I will add a comment about this in the next
patch revision.

> Additionally, this macro always queries tgt->rport->fpin_stats for all events.
> Is this correct for host-level link congestion events which might update
> fc_host->fpin_stats instead?
>
>> +
>> +/**
>> + * ibmvfc_extended_fpin_test - unit test for extended FPIN events
>> + * @test: pointer to kunit structure
>> + *
>> + * Tests
>> + *
>> + * Return: void
>> + */
>> +static void ibmvfc_extended_fpin_test(struct kunit *test)
>> +{
>> +	enum ibmvfc_ae_fpin_status fs;
>
> [ ... ]
>
>> +	for (fs = IBMVFC_AE_FPIN_LINK_CONGESTED; fs <= IBMVFC_AE_FPIN_CONGESTION_CLEARED; fs++) {
>> +		switch (fs) {
>> +		case IBMVFC_AE_FPIN_PORT_CLEARED:
>> +		case IBMVFC_AE_FPIN_CONGESTION_CLEARED: {
>> +			struct ibmvfc_async_crq_event ae = { .type = IBMVFC_ASYNC_CRQ_SUB };
>> +
>> +			crq[fs].valid = 0x80;
>> +			crq[fs].flags = IBMVFC_ASYNC_IS_FPIN_EXT;
>> +			crq[fs].link_state = IBMVFC_AE_LS_LINK_UP;
>> +			crq[fs].fpin_status = fs;
>> +			crq[fs].event = cpu_to_be16(IBMVFC_AE_FPIN);
>> +			crq[fs].wwpn = cpu_to_be64(tgt->wwpn);
>> +			crq[fs].fpin_data.flags = IBMVFC_FPIN_EVENT_TYPE_VALID;
>> +			crq[fs].fpin_data.event_type = cpu_to_be16(FPIN_CONGN_CLEAR);
>> +			ae.subq = *(struct ibmvfc_async_sub_crq *)&crq[fs];
>> +			pre = READ_ONCE(tgt->rport->fpin_stats.cn_clear);
>> +			ibmvfc_handle_async(&ae, vhost);
>> +			flush_workqueue(vhost->fpin_workq);
>> +			post = READ_ONCE(tgt->rport->fpin_stats.cn_clear);
>> +			break;
>> +		}
>
> [Severity: Medium]
> Similar to the macro above, is there a missing KUnit assertion here in
> ibmvfc_extended_fpin_test() to validate that the statistics were properly
> updated?
