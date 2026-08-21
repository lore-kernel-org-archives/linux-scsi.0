Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42EE3451DA;
	Fri, 21 Aug 2026 15:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787325097; cv=none; b=XsRtboNy5e5ZIE1wH4Uso9V0If5a8AEqd3/T01FKxsDH5s89Fk+1FMluyVRWpHYBGC4KfBNoyk8/P7HTkMmMhgC2JgSkuBbEEtgGJs6JVRTMJOF7OPDOpDP6E3YepqgdLwLTOC2NfwCDody5B9+3PWwjSVwLvWlEKjdg7ChxKiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787325097; c=relaxed/simple;
	bh=DCBGz7cfzc2BDovy7WHHvTMrYLE3LltyWuXom9eDyC8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=aAkbE99xzCvWnb1nHrtY3F5oBnaVdrlcJzOeIUUQiIPZcBj5uHCaBIiEENMI2zKbB3ZROhz1EUiGyQKPhtKnvZmZqkbqnI0q8aTNeTWOOxsCLuqOP6R+D7ajHe17eg61U6IY1PE/Zk7Uayaduhu9xx01NJ5ARMnoUD6I2NQ5bgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=D1rPhCWA; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="D1rPhCWA"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67LD1arQ1585745;
	Fri, 21 Aug 2026 15:11:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=zuW42G113NzdrZBUDfkdQWzF8P2DfT
	v8tGxmroOX63g=; b=D1rPhCWAPTU8WMQfLCXkERnyB5WglceW03AnXeasNMO7ks
	JjE85FCtAZ0ZDExcFrk/BXaZT/sV6a07zqSCDn8HQesDubu7GMQxJ15jXzqpV1oM
	6at3+TjkTpsAbtdG+SN4MWPfY6Bu9gdoKNOo7e8wK6oszh1VCAIKN+5kmXzV9pl5
	+rp/4uHG4u+74NAuntkqaT/wmlP5BQI6BCFonjC867/PNkjDGNIHQJa9imBG+quo
	Klm/8gt2lgIvv59eraPVSDvOfZXaK6nHfTMC8dul4ETIHPYlhVNoq6od4tAUdNUr
	sV/YF2Vn7h+M/GPBk+IuKFedTE2I6kaMXxbVVb4g==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g4yu0tc7u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Aug 2026 15:11:34 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67LFBHJD007819;
	Fri, 21 Aug 2026 15:11:34 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g354yw2gs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Aug 2026 15:11:34 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67LFArdn30016236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Aug 2026 15:10:54 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 44B4058043;
	Fri, 21 Aug 2026 15:11:33 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0F89958059;
	Fri, 21 Aug 2026 15:11:33 +0000 (GMT)
Received: from d (unknown [9.61.29.95])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 21 Aug 2026 15:11:32 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH v6 2/8] scsi: ibmvfc: Add NOOP command support
In-Reply-To: <20260817204153.DC6251F00A3A@smtp.kernel.org>
References: <20260817-ibmvfc-fpin-support-v6-0-62a2d525e70d@linux.ibm.com>
	<20260817-ibmvfc-fpin-support-v6-2-62a2d525e70d@linux.ibm.com>
	<20260817204153.DC6251F00A3A@smtp.kernel.org>
Date: Fri, 21 Aug 2026 10:11:32 -0500
Message-ID: <875x13y0d7.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=MthiLWae c=1 sm=1 tr=0 ts=6a886aa6 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8 a=kXrVxv5XiihISqGrbLUA:9
X-Proofpoint-ORIG-GUID: DxNG_NX3pjCNoQJv4jjsGjXoFruYCkO0
X-Proofpoint-GUID: DxNG_NX3pjCNoQJv4jjsGjXoFruYCkO0
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIxMDExNyBTYWx0ZWRfX4N08gLA82Ksq
 YGd6Te+VmbGQLmfADr9tjMaF9KMgl9BJSmtA0KxNPwa9bQKKR0OVTpd41IsHAzkHxBiVRJhI0d2
 s+YDNdQy3OVOpipa7PcgAuTbnJuimOA=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIxMDExNyBTYWx0ZWRfXz0QIroVpAZr0
 LVOv9CIgRuNPgNDpJoQ7IysCNwYx0WwTv4TYbYPwcoUEqFz96pz56qBvt2y3scLFn3UC0sSgEoc
 jIJb6syqOCh0YdIChdptPM3N9qcKs9K3OxPLr5qlmnxZI3V1EUCa5YjdHXvmqWJpKCGIZyZiIET
 Tmb7d65oQ34U6AtE+uInbUzTbU1KCnEO4YqeiraUNO5zBqiMCCKuzI+DcTISn+4u/z8pxfaa4ti
 r7ZBhMbnP0Z5gyc8wdiHbgASqBPosMM4OCzIiUSgrX8TAs15i9lDQm/z/7r8j/VOO6vOiuJm+Zp
 tZlTPPM9+h4zQ7cYwuPfmmBnbyNVlk6i6uD0wA4vsAbLqUGeWG0ZTouPLfTMA6kV5xbP3ULCc+u
 uDQbMrthXmXa0sdi6nzX6tPSlbROdykwKuepuI3nBrUL1Gflu8Pd+EOuzeB7xC3gYlkQKdOVSfX
 TcWmf/CQG2Vej4oL/3w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-21_04,2026-08-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 bulkscore=0 phishscore=0 clxscore=1011
 spamscore=0 adultscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608210117

sashiko-bot@kernel.org writes:

>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index 22b4d639e74be..19a3f12615648 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>
> [ ... ]
>
>> @@ -4220,9 +4230,15 @@ static void ibmvfc_handle_scrq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost
>>  	case IBMVFC_CRQ_CMD_RSP:
>>  		break;
>>  	case IBMVFC_CRQ_XPORT_EVENT:
>> +	case IBMVFC_NOOP:
>
> [Severity: High]
> Does this code check IBMVFC_NOOP against the correct field?
>
> The switch statement evaluates crq->valid, but IBMVFC_NOOP is a message
> format (0x03).  Will the NOOP case be functionally dead here, causing NOOP
> messages to fall through to the command response handling?

Yep, my mistake. Fixed in v7.

>>  		return;
>>  	default:
>> -		dev_err(vhost->dev, "Got and invalid message type 0x%02x\n", crq->valid);
>> +		dev_err(vhost->dev, "Got an invalid message type 0x%02x\n", crq->valid);
>> +		return;
>> +	}
>> +
>> +	if (unlikely(!evt)) {
>> +		dev_err(vhost->dev, "Received null event\n");
>
> [Severity: High]
> Does this error path get triggered erroneously for every NOOP sent by the
> VIOS?
>
> If a NOOP message falls through to the command response handling, ioba is
> likely zero, which would cause evt to be null.  Will this spam the kernel
> log with 'Received null event' at a high rate and potentially cause disk
> exhaustion?

Fixed in v7 by checking for VFC_NOOP after the switch.

> [Severity: High]
> This is a pre-existing issue, but is it safe to dereference evt->queue
> before validation?
>
> Immediately after this null check, the code executes:
>
>         if (unlikely(!ibmvfc_valid_event(&evt->queue->evt_pool, evt))) {

There's

        if (unlikely(!evt)) {
        .
        .
        .

above. So this *HAS* been validated.

> [Severity: High]
> Could the destruction of vhost->fpin_workq during module removal cause a
> use-after-free?
>
> In ibmvfc_remove():
>
>         destroy_workqueue(vhost->fpin_workq);
>         vhost->fpin_workq = NULL;
>
> If hardware interrupts and tasklets are not disabled until
> ibmvfc_release_crq_queue() is called later, an IBMVFC_AE_FPIN event could
> trigger the interrupt handler and schedule the tasklet.
>
> Would this result in ibmvfc_handle_async() executing:
>
>         queue_work(vhost->fpin_workq, &aw->async_work_s);
>
> on the explicitly destroyed and NULL-ed workqueue?

Fixed in patch 1 in v7.

-Dave
