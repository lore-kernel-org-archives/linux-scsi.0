Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DCA36D51F;
	Mon, 24 Aug 2026 15:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787585121; cv=none; b=ion65+1tV2p3ZSHteNEXGbbtFFtvMgNyDdGdpiMNbVza6FbJQ2wXl0rwjWNSbLw0vP2QcZvJHSgTPRMtFXwd7jimBUjFilKwDzWAkLtBtkdjz6Sj9VeCHhV8U94aIR0Wp33QiUCRSAv17a8Nj3vc1EVLq/XhiZWP398rCXABiXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787585121; c=relaxed/simple;
	bh=KKGcEXFe4ZxRx85agFPZ67EVtV94+pM4/zrtVMpMh/I=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=qMkFT0xWOthYbiaxozYZLol3e65l8o0H9W1iHpeHK4WdgQ+aYFxvSmzEEwMzIzkknPcwfD+EDBgAJBe11I270QSW1M/j1IwuW+lfqK7RHQtGtDkrADJxHpRofnzPdFElmJnwig5U/jpRhYui8VtIJ9gTC328t6izJgv9N5gyT70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ke8btP9a; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ke8btP9a"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67OD1VIi1957820;
	Mon, 24 Aug 2026 15:25:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=8klEpw9hKUJ5rXKrIrtNier1mKSI+W
	zQjX2Bac6Mq/Y=; b=ke8btP9aipO8B02Z0/3XZJncTqrzUNkVsjnwsKgTs9TEJn
	HNGady9Zdh/nVKMEITh6ojISHdxOanRwtetrjms1cBHSGyxhd3W1Im86urEmonch
	huvwJmbaGnYyrhFMG+Nfxqrtm8lq58bZAgGZwWMqP2Qag31TYi332Vcb4hr/QFI1
	/3LLKXGUXIMDcAiS0SB3XgNOx6004Jy8UvgKjDQ9qqHh7nJO3hDeAJ5VJxSJ4F4l
	5J4CNz1qnYjZbLeR9cpZZTWg62pDkuKBnWA2qQCMVhZe9Ey68ms463jf6OHkqw7A
	+18wqCyThJEsQEv6rJZ2oFeicXG6/QDGj7DCV+gA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g73g4j99g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Aug 2026 15:25:18 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67OFBJO1025577;
	Mon, 24 Aug 2026 15:25:17 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g7qkgxq8q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Aug 2026 15:25:17 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67OFPGXX32244308
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Aug 2026 15:25:17 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DD9FC58060;
	Mon, 24 Aug 2026 15:25:16 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C696D58056;
	Mon, 24 Aug 2026 15:25:16 +0000 (GMT)
Received: from d (unknown [9.61.150.207])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 24 Aug 2026 15:25:16 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH v6 8/8] scsi: ibmvfc: handle extended FPIN events
In-Reply-To: <20260817204153.384DC1F000E9@smtp.kernel.org>
References: <20260817-ibmvfc-fpin-support-v6-0-62a2d525e70d@linux.ibm.com>
	<20260817-ibmvfc-fpin-support-v6-8-62a2d525e70d@linux.ibm.com>
	<20260817204153.384DC1F000E9@smtp.kernel.org>
Date: Mon, 24 Aug 2026 10:25:16 -0500
Message-ID: <87se43mtgj.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RslBIyo3iB1a-EGzXtFWdxdFEyx6a5OL
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI0MDEyNiBTYWx0ZWRfX5YB9ZYuk5wwM
 p2Mck1W7rvLORBSWnVC0rjg5Wdy9hTINRuIKK5Qw1EqB+x43+b8YeReI5NNdBub2IMDF4vW1by2
 5DwOuszX0L5TYfjBxmfKYGWefzYNwL0=
X-Proofpoint-GUID: RslBIyo3iB1a-EGzXtFWdxdFEyx6a5OL
X-Authority-Analysis: v=2.4 cv=JZyMa0KV c=1 sm=1 tr=0 ts=6a8c625e cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8 a=uDYi2d91FQ9Up9g7aLIA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI0MDEyNiBTYWx0ZWRfX0KCz6ZJaHklQ
 8s9VFqHw/6KcT64j7RPwRuRQpjxGdscyZ0luHCnq9cTdVGdvsGp8V/EHCCJzG7mqQvGwWV6KtVJ
 VLICXyO/0R8osNfjcmIb2u3mKGUfgtkFwtkNI6r+O2tRCvKOvuyWGtHsvCpJLq5NP9O0YuzDI3H
 EbknB5nZRlHGrWoPbQcsNqBITTYpbmjcz5GtsHRgCTTiW+qPVQG4O2bGZN2YbVVIJCiYVFm30Dm
 VN7sce85R1DZ1rDjsDkzf2OwYEBQZqfmT7D38Rx+TmLIe3ABbPCjRh2j1ckijGfePKPQNFP5sv1
 Jqe/LwMKA2lfvEGlbDSUpRoTOJ8iTlsRDtupVwLTPUrGZl9BqwNF+jf7jRiOYL8Zh/ZLUzycb04
 X1+EU/mBjj+egy3sse5HXfY5TengSDIYs75V0nMGE0WLjk8llZy0q3TUqvxUBjdq4MBpyihOLcK
 TpkcuDCOFRia7Zbcfyg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-24_04,2026-08-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 adultscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608240126

sashiko-bot@kernel.org writes:

> [Severity: High]
> Will extended FPIN events be incorrectly discarded here because of how the
> target lookup is performed?
>
> In the earlier part of ibmvfc_process_async_work(), node_name is read from
> the subq structure:
>
> ibmvfc_process_async_work() {
>         ...
>         if (is_subq) {
>                 subq = &aw->crq.subq;
>                 scsi_id = 0;
>                 wwpn = subq->wwpn;
>                 node_name = (subq->flags & IBMVFC_ASYNC_ID_IS_ASSOC_ID) ? 0 : subq->id.node_name;
>         }
>         ...
>         tgt = ibmvfc_find_target(&vhost->scsi_scrqs.targets, scsi_id, wwpn, node_name);
>         ...
>
> Because the ibmvfc_async_subq_fpin structure overlaps with the id union in
> ibmvfc_async_sub_crq, reading subq->id.node_name for extended FPINs will
> extract garbage bytes from the fpin_data.event_threshold and event_data
> fields.
>
> Does this cause ibmvfc_find_target() to fail and drop valid events?

Yes, quite possibly. I've updated the code that sets node_name in
ibmvfc_process_async_work() and ibmvfc_handle_async() to take into
account that node_name isn't available in the extended FPIN case.

> [Severity: High]
> Can this lead to a NULL pointer dereference during driver removal?
>
> When ibmvfc_remove() is called, the fpin_workq is destroyed:
>
> ibmvfc_remove() {
>         ...
>         destroy_workqueue(vhost->fpin_workq);
>         vhost->fpin_workq = NULL;
>         ...
> }
>
> If an FPIN interrupt arrives before the CRQ queues are disabled, the
> interrupt handler unconditionally queues work to it:
>
> ibmvfc_handle_async() {
>         ...
>         case IBMVFC_AE_FPIN:
>                 aw = kzalloc(sizeof(struct ibmvfc_async_work), GFP_ATOMIC);
>                 if (aw) {
>                         ...
>                         queue_work(vhost->fpin_workq, &aw->async_work_s);
>                 ...
> }
>
> Should the interrupts be disabled prior to tearing down the workqueue, or
> should we check if fpin_workq is NULL before queuing work?

Yes, fixed in v8.

>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
>> index 444e6e6e1c390..ce938b93ecb45 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
> [ ... ]
>> @@ -225,9 +226,118 @@ static void ibmvfc_full_fpin_test(struct kunit *test)
>>  			post[IBMVFC_AE_FPIN_CONGESTION_CLEARED]);
>>  }
>>  
>> +#define IBMVFC_TEST_FPIN_EXT(fs, ev, stat, crq) {		\
>> +	crq.valid = 0x80;					\
>> +	crq.flags = IBMVFC_ASYNC_IS_FPIN_EXT;			\
>> +	crq.link_state = IBMVFC_AE_LS_LINK_UP;			\
>> +	crq.fpin_status = (fs);					\
>> +	crq.event = cpu_to_be16(IBMVFC_AE_FPIN);		\
>> +	crq.wwpn = cpu_to_be64(tgt->wwpn);			\
>> +	crq.fpin_data.flags = IBMVFC_FPIN_EVENT_TYPE_VALID;	\
>> +	crq.fpin_data.event_type = cpu_to_be16((ev));		\
>> +	pre = READ_ONCE(tgt->rport->fpin_stats.stat);		\
>> +	ibmvfc_handle_async((struct ibmvfc_crq *)&crq, vhost, true);	\
>> +	msleep(1U);							\
>> +	post = READ_ONCE(tgt->rport->fpin_stats.stat);		\
>> +}
>
> [Severity: Medium]
> Is it expected that this macro only reads the pre and post statistics without
> asserting any changes? The KUNIT_EXPECT_* macros seem to be missing here
> to validate the update.

Yes, there is no validation. This is merely meant to exercise the
extended FPIN processing paths in the kernel and in multipathd.

> Additionally, could relying on msleep(1U) for synchronization lead to flaky
> test results when running under heavy load?

Fixed to use flush_workqueue().

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
> [ ... ]
>> +	for (fs = IBMVFC_AE_FPIN_LINK_CONGESTED; fs <= IBMVFC_AE_FPIN_CONGESTION_CLEARED; fs++) {
>> +		switch (fs) {
>> +		case IBMVFC_AE_FPIN_PORT_CLEARED:
>> +		case IBMVFC_AE_FPIN_CONGESTION_CLEARED:
>> +			crq[fs].valid = 0x80;
>> +			crq[fs].flags = IBMVFC_ASYNC_IS_FPIN_EXT;
>> +			crq[fs].link_state = IBMVFC_AE_LS_LINK_UP;
>> +			crq[fs].fpin_status = fs;
>> +			crq[fs].event = cpu_to_be16(IBMVFC_AE_FPIN);
>> +			crq[fs].wwpn = cpu_to_be64(tgt->wwpn);
>> +			crq[fs].fpin_data.flags = IBMVFC_FPIN_EVENT_TYPE_VALID;
>> +			crq[fs].fpin_data.event_type = cpu_to_be16(FPIN_CONGN_CLEAR);
>> +			pre = READ_ONCE(tgt->rport->fpin_stats.cn_clear);
>> +			ibmvfc_handle_async((struct ibmvfc_crq *)&crq[fs], vhost, true);
>> +			msleep(1U);
>> +			post = READ_ONCE(tgt->rport->fpin_stats.cn_clear);
>> +			break;
>
> [Severity: Medium]
> Similar to the macro above, this inline manual test logic is missing
> assertions to verify the stats actually changed. Does it need a KUNIT_EXPECT_*
> call here?

Same answer as above. Exercising the extended FPIN paths.

-Dave
