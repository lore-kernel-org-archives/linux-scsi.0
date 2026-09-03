Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01104562B7;
	Thu,  3 Sep 2026 15:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788448119; cv=none; b=RSFlO69PETb7kntKxnSBr2ylLk1/A5tUum8ndtQx6nMSTaC8SPkRQsUT1VEBVRlXmjumQidAVSjYBu8x1QHaEG18WpyPWVEhUpvYgHNGUVKX9cXiQVhp1TybxNopMq8T/ndevjA8furdRByPRDcPP8SKjho7gPzrqajKppK7EME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788448119; c=relaxed/simple;
	bh=RxIyO10FhKrxdxLqbT41yS1ViytjqWpdYbHXOhj34/0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=iaSQEdtGkIoPe0R7yjuTPwjsIKJ0wmXSvNBCP4Oi911FRf6SZVa7I+923wHfJXpdOfOxSUmbiX1dfuN2QFTFkYCK0o3yoD437U+hMC5Km7YmO3eAkIsiuZTS8mLzts7xh+spbWB8SfQFWZ1Kg/kdp42+AF8FNK65G0i2zrC1B1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GBTvSqdi; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GBTvSqdi"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 683DVY1H3109140;
	Thu, 3 Sep 2026 15:08:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=b471W3X5ZgO3ksHmnnl3jf2jUTJs41
	S2z4Jjq5ttgjI=; b=GBTvSqdif4FS8smQpsrtFZaol/seDeS8li3dZO+wldCUPt
	RHx0IB5hZ2F2H/4WpxgBi1SbHtMA6UV4XLoHb9rLxi66AGVVE0N7uewe21idib7i
	5k6vhNUSYYKHOw2sfuHXSYWtftGbEY0p2c3NOcM1CfwRfk2dFwEJpcfikYpVbpCd
	sqGVQ28a8bL4NCmpyFUS3npiBXuP188jSQK9ZButCzo/f+xLNKoMBOoaShjgHUSr
	I5d3kYIsjkIEF1s/uu/1EBvWZC9bhN5NT0U0X5Yh8rKreG43E1BcGQFAw4+laT1d
	XPlyuCAChuJQZWkU8efOBok/XYdPGzW6B/gFxHrg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbpx5wgpp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Sep 2026 15:08:36 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 683EuHrD007401;
	Thu, 3 Sep 2026 15:08:35 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gcb8hr4mc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Sep 2026 15:08:35 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 683F8Yak34472634
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 3 Sep 2026 15:08:34 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C5D395805F;
	Thu,  3 Sep 2026 15:08:34 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 91EF758053;
	Thu,  3 Sep 2026 15:08:34 +0000 (GMT)
Received: from d (unknown [9.16.41.19])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  3 Sep 2026 15:08:34 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH v7 2/8] scsi: ibmvfc: Add NOOP command support
In-Reply-To: <20260831214057.3FA141F000E9@smtp.kernel.org>
References: <20260831-ibmvfc-fpin-support-v7-0-77d0b9809080@linux.ibm.com>
	<20260831-ibmvfc-fpin-support-v7-2-77d0b9809080@linux.ibm.com>
	<20260831214057.3FA141F000E9@smtp.kernel.org>
Date: Thu, 03 Sep 2026 10:08:33 -0500
Message-ID: <87ld9i5q4u.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=PPc/P/qC c=1 sm=1 tr=0 ts=6a998d74 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=FbhALZS-eHYbuhQjA_cA:9
X-Proofpoint-GUID: HwloBN0P9OE_ehifyw4svsl8OVaDqxd7
X-Proofpoint-ORIG-GUID: HwloBN0P9OE_ehifyw4svsl8OVaDqxd7
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDEzMSBTYWx0ZWRfXwZDw8iRq5Msm
 oO1XzE9pYR/1e+6y0WohcJSs6YQ0k7iqwB6qiHvrDMZ+0pHeOaswxUPTpIMQYcdQg7LWzMdMgSC
 VQKAB0zQgoc6EaeIxXp8ziLROmMxUCw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDEzMSBTYWx0ZWRfXx/zLlDXLwU9Y
 wGb21RiqBWw6VC3HgxWjJQodUebzTirQ0sGZP3Z+4CvAOQBd9F5t33obd8ZgWDh/03SBSDHR1kn
 tZ3gV4lzO/vYk3nqBVoi0FDHgX43537YVwY/XX7bmjSy/RTSoCYCkhk5QcmNveF00fv6xqTkdYL
 e7hFFKwO5xRwN4SgYM9oevM24pyzuDptoYpl6DXbSywZwbNZ1Xm2b2pBPiQfsRJ9ian7cnNoTT+
 o7oJ7ecRGcLibLflzrE3PnSYl1qKcKwAuiDnp1RqBRJVRqLe1h0plG1COjt6HEkDNse94H7XIBt
 W6YaFthgjho/rFz4+i7aXIQKRm2u+zmQm4kbvo1Wr0arpUeNbOwf4QNIM7mwq66+fG8ym4qJI2v
 f2IcvBSgZelLLz7T3oRiFPod5sszz/51y86v3NsBnKPiSBlvldLD1gxp1/acwgKxq+pxp1u1W6g
 1v5S6wxIlVT+XeyEfcg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-03_04,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609030131

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
>
> New issues:
> - [Medium] The code suppresses logging of unexpected NOOP messages received before NPIV login completes, directly contradicting the commit message claim of logging early messages.
>
> Pre-existing issues:
> - [High] Dereferencing untrusted pointer `evt->queue` before validation in `ibmvfc_handle_scrq` can lead to a kernel panic or out-of-bounds read if the partner sends a malicious or corrupted non-NULL correlation token.
> --
>
> commit a2f1ce40ef9fb5e6c86a16b1ac92eb6c526f0a48
> Author: Dave Marquardt <davemarq@linux.ibm.com>
>
> scsi: ibmvfc: Add NOOP command support
>
> This commit adds support for VFC_NOOP messages from VIOS to enable keep-alive
> functionality between the client and server. It defines the VFC_NOOP CRQ
> format, adds handling in the CRQ handlers, and sets the NPIV login capability
> bit.
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index 78be00d31a064..e972e4ec5be00 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> [ ... ]
>> @@ -3693,6 +3695,14 @@ static void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost,
>>  	if (crq->format == IBMVFC_ASYNC_EVENT)
>>  		return;
>>  
>> +	if (crq->format == IBMVFC_NOOP) {
>> +		if (vhost->state == IBMVFC_ACTIVE &&
>> +		    !ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_NOOP_CMD))
>> +			dev_err_ratelimited(vhost->dev,
>> +					    "Received unexpected NOOP command from partner\n");
>> +		return;
>> +	}
>> +
>
> [Severity: Medium]
> The commit message states the intent is to "Log unexpected NOOP messages if
> received before VIOS advertises support during NPIV login." Does this
> condition match that intent?

No, this does not match. I will rewrite the commit message to reflect reality.

> In drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_handle_crq(), the code checks:
> if (vhost->state == IBMVFC_ACTIVE && !ibmvfc_check_caps(...))
>
> By requiring the host state to be IBMVFC_ACTIVE, this appears to suppress
> logging of unexpected NOOP messages received during the IBMVFC_INITIALIZING
> state, and only logs them after NPIV login has completed.
>
>>  	/* The only kind of payload CRQs we should get are responses to
>>  	 * things we send. Make sure this response is to something we
>>  	 * actually sent
> [ ... ]
>> @@ -4223,7 +4233,15 @@ static void ibmvfc_handle_scrq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost
>>  	case IBMVFC_CRQ_XPORT_EVENT:
>>  		return;
>>  	default:
>> -		dev_err(vhost->dev, "Got and invalid message type 0x%02x\n", crq->valid);
>> +		dev_err(vhost->dev, "Got an invalid message type 0x%02x\n", crq->valid);
>> +		return;
>> +	}
>> +
>> +	if (crq->format == IBMVFC_NOOP)
>> +		return;
>> +
>> +	if (unlikely(!evt)) {
>> +		dev_err(vhost->dev, "Received null event\n");
>>  		return;
>>  	}
>
> [Severity: High]
> This isn't a bug introduced by this patch, but can this lead to an
> out-of-bounds read or kernel panic if the VIOS partner sends a corrupted or
> malicious non-NULL correlation token?

We trust the VIOS partner, so I will not update this.

-Dave
