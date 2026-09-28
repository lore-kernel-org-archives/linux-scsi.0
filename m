Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8294D5997;
	Mon, 28 Sep 2026 15:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790610931; cv=none; b=A9JUcZhsLXx1365ocy8HFAsv4bVcncV0gKdFkCfvTsek0bJCK3ONL8XNX8PflHRz/16fNU0pcCjcGGmKf6i0bUFZQWrc37juAh6HJyQgzTIbcs7E27fgWdLB0gds3I0OucRBoQcroLeorQ/e8l/JZ3lEpqN9UOcP6Nov7jir5Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790610931; c=relaxed/simple;
	bh=gbKK6twKD80vkxHTj9mN7CXY8CPn4Ih5iuyqE8WENnI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=pBQPOgF2dQ8pEtoMMn2SYTSjkGwGNU5h/WbCwfwxIfxjqtNUw6SsYjo6JJnPPms7qhYYBT/7gXh5uix5/pTKyFCzhRaUxjkgywQbLd/X19j0gXJsOeWz9IwMWvHeN0I4j7Wj68KTU32GZJwWAfn+mvE/YETNbBwuDn39cOFy0LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DVMLktpZ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DVMLktpZ"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SF5VEf1460751;
	Mon, 28 Sep 2026 15:55:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=wWnA9sE8be8l6BDors2ktcKmyWDHBU
	mGxD9qE4i9pkI=; b=DVMLktpZih3+57VsH5pL86XNsdchnCsatWoh+JtEMpi6c3
	ZxaO0vHy4QSh27qSxH4aTd/O89jzqH+zANkIcO6U7ZpEDsNKiu0dHJGZWWmBXwot
	RpbCHzPeHgUj8OeuGu8oIcwiYk6oPPPRn6HXx/P2l5g4Q19X/IK+6ZpHU+yrLLAy
	3EPfdZjalXYICOvMq5qQmcuYe+3v1FlpWBDy4AAP2/dl0r/FXS/1GMzeNvMcZDmM
	37nJLcc1+38Bsu0/ciqpyoz2eZQpsNF4ggyAzZTqiCVsF9CQBh0pQ6BmssMEaqOQ
	KS3lf6ISCO9NDv8YLCUjUZ7jG32wJis+d7hC2SUw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5s52evj-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 15:55:28 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68SElUXj3181789;
	Mon, 28 Sep 2026 15:55:27 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gxtkg5ssm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 15:55:27 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68SFtRBg28967314
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Sep 2026 15:55:27 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E09DC58066;
	Mon, 28 Sep 2026 15:55:26 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 92E0658064;
	Mon, 28 Sep 2026 15:55:26 +0000 (GMT)
Received: from d (unknown [9.61.160.252])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 28 Sep 2026 15:55:26 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-bot@kernel.org
Cc: "Tyrel Datwyler" <tyreld@linux.ibm.com>, sashiko-reviews@lists.linux.dev,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v11 09/11] scsi: ibmvfc: extend channel reg/dereg
 helpers for async sub-CRQ
In-Reply-To: <20260925050533.1FCBC1F000FF@smtp.kernel.org>
	(sashiko-bot@kernel.org's message of "Fri, 25 Sep 2026 05:05:32
	+0000")
References: <20260925044900.414340-1-tyreld@linux.ibm.com>
	<20260925044900.414340-10-tyreld@linux.ibm.com>
	<20260925050533.1FCBC1F000FF@smtp.kernel.org>
Date: Mon, 28 Sep 2026 10:55:25 -0500
Message-ID: <87eced5q1e.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA2MiBTYWx0ZWRfX8yumfrFQQvtS
 r7xwMEU053KiwpHxcoaV2WzkshOa0xIMfNj1niSAaH5/dOSSTTeJ/WIuFzpwHItWuy8PMU/GBra
 X9KZMjJJuT+4ahwM0Uol1h0MDyKBgOw=
X-Authority-Analysis: v=2.4 cv=HJ5WhYtv c=1 sm=1 tr=0 ts=6aba8df0 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=jB3ii0AURvSd5AnP4dwA:9
X-Proofpoint-GUID: 0vv7_baaFRQY8Zfxn9B0k307Qp8T65hq
X-Proofpoint-ORIG-GUID: 0vv7_baaFRQY8Zfxn9B0k307Qp8T65hq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA2MiBTYWx0ZWRfXxhBcy/vUnr16
 mUlW+aGZbcC3dF/coSqplCC4rFnusICmjuk3AB0trpt0ra+MyQrGQ+z6v3PpePypNCg/8b7MW0Z
 ih+fbVxnuWArglJNe+3a9g1VuZQ7LZaxIWcfhGB2ZjugH3VVnfJAxb8qxFVTsxkMRcc3CUa0PJy
 Dd3S8aAh63Wlo9jAQPcIigrmv5kD3DPKN93EgySa6OnJCc8c4Iao3K0vVKiJORJhgR2Wzcr0B0J
 5z2GRKr89d9UHNIexgTwH1Uv+c1n1bhkF18CC0y3lzJPJZFKlF2qEjWpJcHpzaY67AxYts7qPNv
 VwlH/sPAVDd6shKQRtm0nym6Uudlpr/IIoKnl1eRuLHH47IVER5cOhbdWS/wKGQF/yvndSJAiSE
 9jbIxG4Y/Fn/0rmo7H98vF6inla/QIn/IDt5GsuFL2t3L8uWP9p81dcWL5eiuoUik98EKxZtHTH
 F2QjVpUj8AMEpoS2E+g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0
 spamscore=0 impostorscore=0 phishscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609280062

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Low] scsi: ibmvfc: kernel-doc incorrectly instructs passing negative index
> --
>
> commit 6798e7ba7398cb1f91e10a6432ae9b3192653f37
> Author: Dave Marquardt <davemarq@linux.ibm.com>
>
> scsi: ibmvfc: extend channel reg/dereg helpers for async sub-CRQ
>
> ibmvfc_register_channel() and ibmvfc_deregister_channel() previously only
> handled SCSI and NVMe sub-CRQ channels identified by the channel protocol.
> The async sub-CRQ had no registration path through these helpers, requiring
> separate handling. This commit adds IBMVFC_PROTO_ASYNC to extend both
> functions to handle the async sub-CRQ.
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index b354bfb1a9b67..b967c82e99430 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> [ ... ]
>> @@ -6812,6 +6812,21 @@ static int ibmvfc_init_crq(struct ibmvfc_host *vhost)
>>  	return retrc;
>>  }
>>  
>> +/**
>> + * ibmvfc_register_channel - Register a sub-CRQ channel with the hypervisor
>> + * @vhost:	ibmvfc host struct
>> + * @channels:	ibmvfc channels struct containing the channel array and protocol
>> + * @index:	index into the channels array for the queue to register, or
>> + *		a negative value to register the async sub-CRQ
>> + *
>> + * Register a sub-CRQ with the hypervisor via h_reg_sub_crq, map its hardware
>> + * IRQ to a Linux IRQ, and bind an interrupt handler to it. The handler is
>> + * selected based on the channel protocol (SCSI or NVMe) for normal queues, or
>> + * set to the async sub-CRQ handler when @index is negative.
>> + *
>> + * Return value:
>> + *	0 on success / non-zero on failure
>> + **/
>>  static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
>>  				   struct ibmvfc_channels *channels,
>>  				   int index)
>
> [Severity: Low]
> Does this kernel-doc correctly document the expected index values?
>
> The documentation explicitly directs the caller to pass a negative index for
> async sub-CRQs, but ibmvfc_register_channel() begins with an unconditional
> array access:
>
>     struct ibmvfc_queue *scrq = &channels->scrqs[index];
>
> If a developer follows the documentation and passes a negative index, wouldn't
> this result in an immediate out-of-bounds array access? Currently, callers
> pass 0 for the async sub-CRQ, so this crash isn't reachable today, but the
> comment could mislead future users.

Right. This suggestion to use a negative index is an artifact of older
implementation choices and was missed in more recent patch
revisions. I'll fix it in v12.

> [ ... ]
>> @@ -6883,6 +6905,18 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
>>  	return rc;
>>  }
>>  
>> +/**
>> + * ibmvfc_deregister_channel - Deregister a sub-CRQ channel with the hypervisor
>> + * @vhost:	ibmvfc host struct
>> + * @channels:	ibmvfc channels struct containing the sub-CRQ array
>> + * @index:	index into the sub-CRQ array, or -1 to deregister the
>> + *		asynchronous sub-CRQ
>> + *
>> + * Frees the IRQ, disposes of the IRQ mapping, and calls H_FREE_SUB_CRQ to
>> + * release the sub-CRQ with the hypervisor. On success the queue message
>> + * buffer is zeroed and the current index is reset. If H_FREE_SUB_CRQ fails,
>> + * an error is logged but the channel resources are cleaned up regardless.
>> + */
>>  static void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
>>  				      struct ibmvfc_channels *channels,
>>  				      int index)
>
> [Severity: Low]
> Is this the same documentation issue as above?
>
> The kernel-doc for ibmvfc_deregister_channel() directs using -1 for the
> asynchronous sub-CRQ, but similar to ibmvfc_register_channel(), it accesses
> the array unconditionally:
>
>     struct ibmvfc_queue *scrq = &channels->scrqs[index];
>
> Could this lead to an out-of-bounds array access if someone passes -1 as
> documented?

I'll fix this also.

-Dave
