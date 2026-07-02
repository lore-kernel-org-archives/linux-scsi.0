Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DF238F638;
	Thu,  2 Jul 2026 19:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783022189; cv=none; b=jcPZdc7oKEM64NKlqL5+ssFdPk6OOxwvm6lcA9Vopfz/y6/wLA+413dL/C64v46LA6HCE1Fthrm/vQz0CQbBCbD0x/rtehMEJpsIi3PF/J8WvX/fauTekohfPJq7EjPk22vSbT5Fn56EQwcsw4jBpviTMcJey3SkAHotkkYDU+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783022189; c=relaxed/simple;
	bh=CLVhselgALZ2WPmjJOTgDGJk4z/f5tUkr9rHB/5koSc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qVlAcGlqHpl6Bt9Gmp9xr6hcmsBit6Y5U0CRP9jbDnX5bpRdlTrcbbHpgO7IqUcMMdbc7l5eYIDtPh9uUNWZJ4VQ4Hyk4s213rsHXNYq2Qf2HETbcNBZvbEUaiPsPYzmZ946z/9TfZut8RGw0H8QfoidynagZXW1yM9cKJ7gfLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com; spf=none smtp.mailfrom=linux.vnet.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=idOXIE/h; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="idOXIE/h"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 662JIVhp723300;
	Thu, 2 Jul 2026 19:56:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ARtbxY
	bhp0hZ//wNwym/pGH2DsRIo+CQdaioZ5GnWrM=; b=idOXIE/hUHXhMXDrIaWvtd
	S1+wunE4Wd/UkD+XgzD+hVKnuNiEKO7vmtWejCd+D0WU5u9r/SGOpcN9RA8eViyk
	/IxhYJCwrbhBsSXbjAH6dOtRo5PqpFPfw6pgros/iw8F35935MPtXO7Gur+eMA1S
	HsbXuZ+fb4EsPrOX0uALIt27lsFWFmMGn5vPoqBDFoMo5zG2bF+u6JZjIjtiYyNt
	FWCXQPzszpYvMC70z/IFO9yaH34vChC4rZ1+m4JkC0uLN3hJePFFNjk/B7ezmbc8
	pEmVqPZwZ03WAh4DFC1tPbMXEd2P+dRM8CeDjKGLA4G2MnVlBi7N/J8DTJKHAi+A
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4f26qgbrt5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Jul 2026 19:56:10 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 662JndV7012631;
	Thu, 2 Jul 2026 19:56:09 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4f2s7wdp2w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Jul 2026 19:56:09 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 662Ju73c60293572
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 2 Jul 2026 19:56:07 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CFDF758059;
	Thu,  2 Jul 2026 19:56:07 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2B1A658055;
	Thu,  2 Jul 2026 19:56:07 +0000 (GMT)
Received: from [9.61.15.205] (unknown [9.61.15.205])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  2 Jul 2026 19:56:07 +0000 (GMT)
Message-ID: <05bd4fe1-fbf3-4849-96ca-930d04710903@linux.vnet.ibm.com>
Date: Thu, 2 Jul 2026 14:56:06 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] scsi: ipr: use kmalloc() to allocate IPR dump buffer
 memory
To: Mike Rapoport <rppt@kernel.org>
Cc: Hannes Reinecke <hare@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, wenxiong@linux.ibm.com
References: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
 <20260630-b4-scsi-v1-3-494fb37ebe7b@kernel.org>
 <7c8f0e70-f49c-4614-af95-002fb2be11ba@suse.com> <akTjQVQQNdeO9M28@kernel.org>
 <d92f22b9-9a4d-42f2-ba67-0371f85fedd3@linux.vnet.ibm.com>
 <akYLdBME5kgyi8Rw@kernel.org>
Content-Language: en-US
From: Brian King <brking@linux.vnet.ibm.com>
In-Reply-To: <akYLdBME5kgyi8Rw@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=RYqgzVtv c=1 sm=1 tr=0 ts=6a46c25a cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=sqwCBlrccO2WM5EiRCMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAyMDIwOCBTYWx0ZWRfX0DLtz8zK5vLN
 ZhtBmhIsKizP43rSeHVWqtGTGG3WCwBME7BJM1QJfOQNwPVEK583K4t72hdAP0KpmooNecnvYrm
 OX24Al9SDfxxwqvcHoja0COLZoMD6xk=
X-Proofpoint-GUID: T-PufasAcYK8KlFsDUSJIIjNCHz4sObS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAyMDIwOCBTYWx0ZWRfX/u9Enjp866xb
 ofyLluPJRph8NFljhrNz9hb/QSlgdEzKv05BCeTVpqAXA0VTZKE2HWv2KfkMoSPoAFNjhgvowwa
 N4rJ5zG6fjOWQb/i4wJVsKeB6cBLnuuJncKFVDC7rKg88LyHUNDU6Es1805qctAdnGdoD6up4kQ
 yC6K86wXxRPDxtoAtMoltF1MYSXXK3K4110LngNTEhyoEmt6SCiJwhmafHUM/dAlvbMtbnKWIZ8
 X2ZxEJSzgDcNO5pxw3vzYoMzhNsGCqMr9HovLjMTRaTDHXeBI5wR/8EOhgLgQuBAS6ULRoAauJu
 1Ri75z8O+0uzugz2CJhOAp2+Xrp1H8r8yCUibJ/q0KeL0fku0bpOaPyqEt8AJC1SnX4VMIwsWoJ
 7fgR850v5AYebG9scpH2y4fxtaqpbMDokNG/aCuMenfjO/B715OZJjLQF90cm9KGozY4NtOusQ7
 4JfDYdqn9cwF9UNk5bg==
X-Proofpoint-ORIG-GUID: T-PufasAcYK8KlFsDUSJIIjNCHz4sObS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-02_03,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 suspectscore=0 bulkscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607020208

On 7/2/26 1:55 AM, Mike Rapoport wrote:
> On Wed, Jul 01, 2026 at 04:03:48PM -0500, Brian King wrote:
>> On 7/1/26 4:52 AM, Mike Rapoport wrote:
>>> On Wed, Jul 01, 2026 at 09:03:06AM +0200, Hannes Reinecke wrote:
>>>> On 6/30/26 12:54 PM, Mike Rapoport (Microsoft) wrote:
>>>>> IPR dump machinery allocates memory to save adapter's crash dump using
>>>>> __get_free_page().
>>>>>
>>>>> This memory can be allocated with kmalloc() as there's nothing special
>>>>> about it to go directly to the page allocator.
>>>>>
>>>>> kmalloc() provides a better API that does not require ugly casts and
>>>>> kfree() does not need to know the size of the freed object.
>>>>>
>>>>> Replace use of __get_free_page() with kmalloc().
>>>>>
>>>>> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
>>>>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>>>> ---
>>>>>   drivers/scsi/ipr.c | 4 ++--
>>>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
>>>>> index d207e5e81afe..5a212bfdeec2 100644
>>>>> --- a/drivers/scsi/ipr.c
>>>>> +++ b/drivers/scsi/ipr.c
>>>>> @@ -2893,7 +2893,7 @@ static int ipr_sdt_copy(struct ipr_ioa_cfg *ioa_cfg,
>>>>>   	       (ioa_dump->hdr.len + bytes_copied) < max_dump_size) {
>>>>>   		if (ioa_dump->page_offset >= PAGE_SIZE ||
>>>>>   		    ioa_dump->page_offset == 0) {
>>>>> -			page = (__be32 *)__get_free_page(GFP_ATOMIC);
>>>>> +			page = kmalloc(PAGE_SIZE, GFP_ATOMIC);
>>>>>   			if (!page) {
>>>>>   				ipr_trace;
>>>>> @@ -3226,7 +3226,7 @@ static void ipr_release_dump(struct kref *kref)
>>>>>   	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
>>>>>   	for (i = 0; i < dump->ioa_dump.next_page_index; i++)
>>>>> -		free_page((unsigned long) dump->ioa_dump.ioa_data[i]);
>>>>> +		kfree(dump->ioa_dump.ioa_data[i]);
>>>>>   	vfree(dump->ioa_dump.ioa_data);
>>>>>   	kfree(dump);
>>>>>
>>>>
>>>> I _think_ we can replace this with kvmalloc, and allocate the entire
>>>> dump buffer in one go. Once switched to kmalloc() it's kinda pointless
>>>> to allocate separate page-sized buffers here.
>>>
>>> kmalloc() performance is on par with __get_free_page(), but kvmalloc()
>>> would be slower if it falls back to vmalloc(). 
>>>
>>> I'm not familiar with the driver to say if this could be an issue here.
>>
>> This code only runs when the adapter has hit a fatal error, so should be
>> extremely rare. The memory is getting allocated while the storage adapter
>> is in a failed state, so anything running on the system at the time could
>> be stalled until recovery is completed. This memory is allocated and should
>> be freed soon after the adapter recovers. In order for this code to
>> run, the iprdump daemon must be running, which will then read out the dump
>> after the adapter is recovered, and write it to disk, after which time, the
>> ipr driver will free the kernel memory.
> 
> Thanks for the explanation!
> 
> So the allocation is not on the hot path and it seems to me that
> performance differences between kmalloc() and slower vmalloc() won't move a
> needle relatively to the entire dump procedure.
> 
> And it seems that GFP_ATOMIC here is a historical artifact rather than
> actual necessity. ipr_get_ioa_dump() runs in a workqueue context without
> locks held so nothing warrants GFP_ATOMIC.

Agree that GFP_ATOMIC is not needed here, but we probably do need
GFP_NOIO since we don't want these allocations starting I/O as the
storage adapter is not in a state where it can handle I/O until
the card is reset.

Thanks,

Brian


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

