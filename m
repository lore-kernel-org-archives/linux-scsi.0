Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1EF4F68A4;
	Fri,  2 Oct 2026 16:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790958946; cv=none; b=arHMWmTcUmfiO++wkgSj41w6si8q8DIYsGdQ1+v2Uq4A9+y0MPgSbEJTdHB3v3RJUHH1hjlLZsa2zFeaKoE7rSplpjKKhmkp1sS+bKpuYlqBURbgFsIhmPEIsTRgcHGpcpLm70yDqmOAaY6JOpPuh0dWtdJIgy1d2JHvnotdJqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790958946; c=relaxed/simple;
	bh=yGSkJxMy18/Bz7NclYc/G318ghg8b2tq9oF+Zp+IeB0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=KiIieiSn9+ShbXG3FI+P8OrtJNz+uBmHYSHEH1OeOPnTyTTT4i/6+qerBOJMHprCvahxS988ALLBqAu8P+tD2jRBAIaL53qzj3rzWnmVAKHjzcXFkZ2z0SjXWWWExDOFexmhzgsVOiMpR6M79kUzXpTAnhhsRpBJxUn5ERI+hQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GoxBAoN+; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GoxBAoN+"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 692FZUAA880981;
	Fri, 2 Oct 2026 16:35:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=D1VmDFKMDJ3bouc+8VsNpf1x62Y3Xq
	zNPPvfiP/wSDQ=; b=GoxBAoN+7yTAm0vmZwXa3m4xHHCeuzFdcI1dWG8B2eWBzK
	3+m4VDXwWTfEfz2Ig16zh47qoevlARh0jXEEd0VBcjONVfENbLC7kPIZlnhsItAg
	XS9m8QhNNuFZPUkE3l/qinzCSk580nxzns4QgX+vI1FQYbedRtYiQaWz8aUgRCh6
	mcwOmrwayGCgQKpf4AyFgMJ5v/K1YtdlofUQX7BJCpxbin5/p5L6EqQHpA6q8Tat
	zYaV1UjFlO7s9Qi9zev3yHEhb8ihAUbvwnO5ECZV3+3QPs3zCzZ+o/FjwiY/imeS
	f++EoYINhUwN/7BuhVozxi3rinQPVEzAXNGRIkHA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5ptru87-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 02 Oct 2026 16:35:37 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 692FHfgJ2708230;
	Fri, 2 Oct 2026 16:35:36 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4h21nu2vbm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Oct 2026 16:35:36 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 692GZZE625035418
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 2 Oct 2026 16:35:35 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AAEEA58066;
	Fri,  2 Oct 2026 16:35:35 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B0B45804B;
	Fri,  2 Oct 2026 16:35:35 +0000 (GMT)
Received: from d (unknown [9.61.92.40])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  2 Oct 2026 16:35:35 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-bot@kernel.org
Cc: sashiko-reviews@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v12 11/11] scsi: ibmvfc: handle extended FPIN events
In-Reply-To: <20260930183647.5E54C1F00898@smtp.kernel.org>
	(sashiko-bot@kernel.org's message of "Wed, 30 Sep 2026 18:36:46
	+0000")
References: <20260930-ibmvfc-fpin-support-v12-0-53a3fff7d77b@linux.ibm.com>
	<20260930-ibmvfc-fpin-support-v12-11-53a3fff7d77b@linux.ibm.com>
	<20260930183647.5E54C1F00898@smtp.kernel.org>
Date: Fri, 02 Oct 2026 11:35:34 -0500
Message-ID: <87fqyohxgp.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: T_n6XwhZp3VkwkGGB2vus8ikeFr8QdtP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAyMDA2NiBTYWx0ZWRfX0WAMu8f9cO81
 kDa2t1LNcn1RVuUdBwFUWkgeSJnCEoYaIxpnzhj3voJpP4ucV1WILDZDwByIcYq5eh7i/QgQZai
 1MgfZObBBGxz7uu6GkdeiNfWRzYBpT/zc5K8bpWWxPc2i9FggVb8M5tJ5FCCDXWX3863hYR+Msm
 p6QKTRmzbUsDBw4v+6rgSdXwwf5Qe7+TqKdBUsxHZaa/tJ0+MsL4p+C2tCkVJbdVjr8b8CPJwLd
 /JPRDbYSu+EXpOD6MdIlUENf330Oeguu5BP8RGXtNnMvVSEtaiKjK/61KBPxBZ33hrMUXoaJtsQ
 vHgdr9QnhB1qWQLQtRZFy4RZFEr4L72PkSKNxXSwtCYpd4KghlZgN8GbyaqeMJ95nxscF6uHiSq
 Lhz3S5oFWhy/ZR3J3AgPgIWzybIJjLVJbxYMQXH9NG+mUVATuBqiw2SY09YKjrEMHh/M9wDmk2B
 mW81r+8lNboCtYjS0AA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAyMDA2NiBTYWx0ZWRfX8cyJkYOqyfOV
 c2kIShT4scJtkvwx1jx5iua9DKQe3HKaXup2Ctw16SpulGEdKqiLrs1voOS1UVaDRYQfwIPkiNj
 opu/8n2McQTSqD57pUUMoYhjSislYLQ=
X-Authority-Analysis: v=2.4 cv=EY5d0/mC c=1 sm=1 tr=0 ts=6abfdd59 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8 a=MeOU1Y3gxzQrp_QwQ0kA:9
X-Proofpoint-GUID: T_n6XwhZp3VkwkGGB2vus8ikeFr8QdtP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-02_04,2026-10-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 suspectscore=0 adultscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610020066

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Medium] scsi: ibmvfc: unprocessed FPIN severity in extended FPIN events
> - [Medium] scsi: ibmvfc: KUnit tests for extended FPIN silently lack assertions and bypass core logic

>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> [ ... ]
>> @@ -3471,6 +3472,41 @@ ibmvfc_full_fpin_to_desc(struct ibmvfc_async_sub_crq *ibmvfc_fpin, u64 wwpn)
>> +static struct fc_els_fpin *
>> +ibmvfc_ext_fpin_to_desc(struct ibmvfc_async_subq_fpin *ibmvfc_fpin)
>> +{
>> +	u8 flags = ibmvfc_fpin->fpin_data.flags;
>> +	__be32 threshold = cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_THRESHOLD);
>> +	__be16 modifier = 0;
>> +	__be32 count = cpu_to_be32(1);
>> +	__be16 type = 0;
>> +
>> +	if (flags & IBMVFC_FPIN_EVENT_TYPE_VALID)
>> +		type = ibmvfc_fpin->fpin_data.event_type;
>> +	if (flags & IBMVFC_FPIN_MODIFIER_VALID)
>> +		modifier = ibmvfc_fpin->fpin_data.event_type_modifier;
>> +	if (flags & IBMVFC_FPIN_THRESHOLD_VALID)
>> +		threshold = ibmvfc_fpin->fpin_data.event_threshold;
>> +	if (flags & IBMVFC_FPIN_EVENT_COUNT_VALID)
>> +		count = ibmvfc_fpin->fpin_data.event_data.event_count;
>> +
>> +	return ibmvfc_common_fpin_to_desc(ibmvfc_fpin->fpin_status,
>
> [Severity: Medium]
> Does this code intentionally discard the event severity?
>
> The extended FPIN payload can specify severity when the
> IBMVFC_FPIN_SEVERITY_VALID flag is set, but that flag appears to be ignored
> during this unpacking process.
>
> Furthermore, looking at the existing ibmvfc_common_fpin_to_desc() function
> that this calls, it hardcodes the generated severity:
>
> static struct fc_els_fpin *
> ibmvfc_common_fpin_to_desc(...)
> {
> ...
>         cdesc->severity = FPIN_CONGN_SEVERITY_WARNING;
> ...
> }
>
> Will this cause higher severity events sent by the VIOS to be permanently
> downgraded and incorrectly reported to the FC transport layer?

For the next revision I'm updating ibmvfc_common_fpin_to_desc() to have
a __u8 severity parameter, and its wrappers to pass either
FPIN_CONGN_SEVERITY_WARNING as a default or in the case of
ibmvfc_ext_fpin_to_desc() using the passed severity if
the severity passed in the ibmvfc_async_subq_fpin data is set.

> [ ... ]
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
>> --- a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
> [ ... ]
>> @@ -266,9 +267,147 @@ static void ibmvfc_full_fpin_test(struct kunit *test)
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
>> +	pre = READ_ONCE(rport->fpin_stats.stat);				\
>> +	spin_lock_irqsave(vhost->host->host_lock, flags);			\
>> +	ibmvfc_handle_async(&ae, vhost);					\
>> +	spin_unlock_irqrestore(vhost->host->host_lock, flags);			\
>> +	flush_workqueue(vhost->fpin_workq);					\
>> +	post = READ_ONCE(rport->fpin_stats.stat);				\
>> +}
>
> [Severity: Medium]
> Are we missing the KUnit assertions in this macro?
>
> The test records the pre and post statistics, but there are no checks
> (such as KUNIT_EXPECT_GT(test, post, pre)) to verify the statistics actually
> incremented.

Yes. Adding KUNIT_EXPECT_GT here.

> Because this test uses a live global vhost via ibmvfc_get_first_vhost()
> without mocking the IBMVFC_SUPPORT_FPIN_EXT capability, a test run on an
> adapter lacking this capability will silently fall through to this bypass path
> in ibmvfc_process_async_work():
>
>     } else if (!ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_FPIN_EXT)) {
>             dev_err_ratelimited(vhost->dev,
>                                 "Unexpected extended FPIN event received\n");
>     }
>
> Since there are no assertions, does this mean the test still reports a pass
> despite completely failing to process the events?

I've added the same check in ibmvfc_extended_fpin_test() and will skip
the test if IBMVFC_SUPPORT_FPIN_EXT is not set.

-Dave
