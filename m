Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A97039A4DC;
	Wed, 26 Aug 2026 21:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787781448; cv=none; b=u8XcNH9MLj+aSE5qeoDoZzcRzsrHqjn1QNLm3gduB1kvFLAO47JAipCO61ACHTxJ3XLbdfHVwBEysm98CaTRMBBQgw98CfELolDsIsPTum87FKiV6INW8CFmJx1E3+xh3Z9kmVfQf6NeryMfWc9AK7vknH+f4qi+pQcV/6rrgk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787781448; c=relaxed/simple;
	bh=wfsPe5eWfL9zm76HdklVCo6ph8MOwGizOjGIUyXuInA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nEgv9Br0HsV+3lIB6QX9JoQyOC4Z2iKiqg65lPq4Bx85mATMfjb0gz/j5gIvgG3UTBozrzH7Kk3SEzTh2H76kaF8okL/F5UiRTSWfysyIrDv8WMaITyGr0oITH3SKxkoUHB4q9Awc8Evm33OhWI3lf3p495TE0Hc9v82cgzFoiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lwGQ+oKc; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lwGQ+oKc"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67QL1hFi3280729;
	Wed, 26 Aug 2026 21:57:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=AQXeQR
	N1rEiOEItLmkumHWEw+OGKJ2C+epYumUGcIfQ=; b=lwGQ+oKc7jrqiPp8qC7oq/
	VqF7AXJeyCU1PX9jr85EUHxnZQE/Kgbe53Sq70iV8rpyQXKuJz+xa6fYcbC/Zdts
	Pbmm+XTDcEX0AdbYG0PaQFyYyhOLqicJZU9tVKevWXLlqKe/gaACl+Yu7pqxc+Lt
	B52I6zlgi2fLpBGjxywOSPBWmXMfhgoWzx47RRZKgIy8Ym0oo/qftE4K5LZzDdHr
	ZPk7KUWUZGYROJm6b65r95swgPvjouQlVfypJpiiMvNeKz3DqyzRmKrsxEEVUYFQ
	y3OoRjEVfyQcprwGErztNa5TSh9sR6FXK4rgQsbcXhlFXbZn6x43yjwNrAOXbQMA
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g73er1cyk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Aug 2026 21:57:26 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67QLuK5b028727;
	Wed, 26 Aug 2026 21:57:25 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g7ragm8w9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Aug 2026 21:57:25 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67QLvNwb656284
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Aug 2026 21:57:23 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9751758054;
	Wed, 26 Aug 2026 21:57:23 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 32C4F5805A;
	Wed, 26 Aug 2026 21:57:23 +0000 (GMT)
Received: from [9.61.29.217] (unknown [9.61.29.217])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 26 Aug 2026 21:57:23 +0000 (GMT)
Message-ID: <7f3e63da-c28c-4696-9a4a-fe8fa7cd1d8e@linux.ibm.com>
Date: Wed, 26 Aug 2026 14:57:22 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 7/8] scsi: ibmvfc: register and use asynchronous sub
 CRQ for events
To: Dave Marquardt <davemarq@linux.ibm.com>, sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260817-ibmvfc-fpin-support-v6-0-62a2d525e70d@linux.ibm.com>
 <20260817-ibmvfc-fpin-support-v6-7-62a2d525e70d@linux.ibm.com>
 <20260817204231.3364C1F000E9@smtp.kernel.org> <87jypjwk9f.fsf@linux.ibm.com>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <87jypjwk9f.fsf@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RVUA1vI0J9jaMUvIKWu4v0kl7WW6J8bv
X-Proofpoint-ORIG-GUID: RVUA1vI0J9jaMUvIKWu4v0kl7WW6J8bv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI2MDE4MSBTYWx0ZWRfX3S46jidvMWzU
 1B7I1hs56OylNsvtWUgq84GuzjYTYehIXrss6J8s5g1OHPless3nPxMnVCk+j3aahpkVm1ClhNG
 UTyoYyq/VZlLtNzLXUOBerumPXJ73HMYHfDgQX5Ja1RZlsCP+Pk7J6GRWTZUneJEZGDTgPe7D7X
 O93zdlOPo9AAsS+cgxZTEuL3XGmL+LQrfB5r7deNXUkIypYWhkq0mr5KIv7T2PjdZmsumN9Nmuv
 zx/iw9wNCpahUiLGxSDXxYeu1niQWgb79F4S6CIfibNIco8waJFTN9xXuYGMTvu6l1b9f0VcvRV
 7jmS7Q8D43GlizjW0mJlElRjtOIObkXdRu3sRZGW+ERS2snY5TNsWE0JblD2jPXmn/4SKYmGrTl
 44y7f7q08fJIuaA9+YKNHHo+lQyc2TQMfTJA/qs/9aVg3wC2YS11qUJdcg0Wc1kKKv+24N4QblL
 aK8hCttDEW9AndrDnvw==
X-Authority-Analysis: v=2.4 cv=QsRuG1yd c=1 sm=1 tr=0 ts=6a8f6146 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=NANaV8vmqpoZotx7PusA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI2MDE4MSBTYWx0ZWRfX7AMb3faIWweb
 iMFq5PKec9O7irHA6moF4DFmYTvH7RLpfJSgtgRj/MA8J39iBW9dqvkxRkor2L0kTPswVlmVZIn
 QzYFohu+qNudsp7XbjpeX/Q83YDSRFo=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-26_06,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 lowpriorityscore=0 clxscore=1011 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608260181

On 8/21/26 8:44 AM, Dave Marquardt wrote:
> sashiko-bot@kernel.org writes:
> 
>> Thank you for your contribution! Sashiko AI review found 5 potential issue(s) to consider:
>>
>> New issues:
>> - [High] The newly added async_sub_crq is leaked and leaves its IRQ registered if ibmvfc_alloc_channels() fails during SCSI channel initialization.
>> - [High] The async_sub_crq is completely omitted from the CRQ reset and re-enable sequences, breaking its lifecycle.
>>
>> Pre-existing issues:
>> - [Critical] NULL pointer dereference in ibmvfc_channel_setup() when mq_enabled == 0.
>> - [High] Missing bounds checks on hypervisor-provided queue counts can lead to out-of-bounds array accesses.
>> - [High] Error codes from request_irq() are unconditionally clobbered, silently masking critical failures.
>> --
>>
>> --- Patch [7]: [PATCH v6 7/8] scsi: ibmvfc: register and use asynchronous sub CRQ for events ---
>> commit 10af0529db6ade6b831181ddc695f2e8713b38ee
>> Author: Dave Marquardt <davemarq@linux.ibm.com>
>>
>> scsi: ibmvfc: register and use asynchronous sub CRQ for events
>>     
>> Wire the async sub-CRQ into the sub-CRQ lifecycle so it is allocated,
>> registered, and freed alongside the SCSI channel queues.
>>
>>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> [ ... ]
>>> @@ -5792,6 +5794,7 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
>>>  		for (i = 0; i < nvme->active_queues; i++)
>>>  			nvme->scrqs[i].vios_cookie =
>>>  				be64_to_cpu(setup->channel_handles[scsi->active_queues + i]);
>>
>> [Severity: High]
>> This is a pre-existing issue, but is it possible for an unexpectedly large
>> response from the hypervisor to cause out-of-bounds array accesses here?
> 
> Up to this point in the driver history, we have trusted the answeres
> from PHYP, the IBM PowerVM hypervisor.
> 
>> Looking at drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_channel_setup_done(),
>> the unvalidated active_queues count returned by the VIOS is used directly
>> as a loop limit to write into the driver's nvme->scrqs and scsi->scrqs
>> arrays.
>>
>> Could a malformed or compromised response corrupt adjacent memory?
>>
>>> +		vhost->async_sub_crq.vios_cookie = be64_to_cpu(setup->async_sub_crq_handle);
>>>  
>>>  		ibmvfc_dbg(vhost, "Using %u SCSI channels\n",
>>>  			   scsi->active_queues);
>> [ ... ]
>>> @@ -5851,6 +5854,7 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
>>>  		for (i = 0; i < nvme_channels; i++)
>>>  			setup_buf->channel_handles[scsi_channels + i] =
>>>  				cpu_to_be64(nvme->scrqs[i].cookie);
>>
>> [Severity: Critical]
>> This is a pre-existing issue, but does this loop risk a NULL pointer
>> dereference when mq_enabled is 0?
>>
>> Looking at drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_channel_setup(),
>> if the driver is loaded with mq_enabled=0, ibmvfc_init_sub_crqs() returns
>> early without allocating scsi_scrqs.scrqs. 
>>
>> However, if a modern VIOS supports channels, the enquiry succeeds and sets
>> max_vios_scsi_channels > 0.
>>
>> This would cause ibmvfc_channel_setup() to compute scsi_channels > 0 and
>> unconditionally execute this loop, accessing the unallocated
>> scsi->scrqs[i].cookie array.
> 
> I will study this more, but it will not be fixed in the v7 patch series.

If mq=0 we do not do enquiry or channel setup, and fall back to legacy CRQ only
mode. This is a false-positive.

-Tyrel
