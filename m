Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4253264EF
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 08:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783067760; cv=none; b=NEKsOvTSTaCcG1kzwFqrpS0o2yxhWrJTzf0K4qR7mZ90DZRmJ0DytHJy+X8c5B0UO9ZEuNDU6DiPXwYnBcaz86F+evPE5VhfvZCVbjx2jayCr0rCxZalolhbDJ1dyiJuEUM5ypAt32NWciazyzhVkhFECovuOZV+w60rPkGxZvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783067760; c=relaxed/simple;
	bh=eQxnoDMMeS8zqLXEAn5onMUP1uws6doz7zxSRSRHohU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R094xB9UVKehY5J3il4i2GujHuVyIimjx5yRy2idj1/CQe7gzGa9vVwamo41KH3INJ1X+SkN4Ur5FS1sago4xBausvB3MeGj/fjm/OQrPX3Zuref68Eali9CnP6PTkaMG9fdgRz34ZN+tKfNGtcKcvB0F2Am7qmFJbb6xURhZws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Tb4Op9JW; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Tb4Op9JW"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-493bb510ce4so2024535e9.1
        for <linux-scsi@vger.kernel.org>; Fri, 03 Jul 2026 01:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783067757; x=1783672557; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7WAbGtIrI1EcfzFik+M+qn8x7M7ZtMBRYdePiOvKmF8=;
        b=Tb4Op9JW37Lmr2DG4vEYzeEJG3hjor3+Yon/W712PqmIVFYj9N5pOVpBXYMsKO31ZZ
         TBhAzp2TMKKJMDQ1lR1VhchL6+rmevTkG68vaJY6fpeagCiEsx33iz+Z7ZTcEAJTdxNT
         zE9J5yU1q/rIL47vOxpGLrBz+aYbMWzHt1pKRsl2OoI/DNbUyajo/Y/CHGjNOFKplZRF
         2FrJqQoeVRRqSI6lyw/jV+LkW4C5AawbIAFewP9GsU8N34FJqEQK+lXxoHbW7AVttYrK
         e95S+f4IygosXRL5MbXeDymMSVlpWCroP/3+U6gergXPhpI4xkv7X+B+8g2ZuZDLwsBP
         d9YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783067757; x=1783672557;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7WAbGtIrI1EcfzFik+M+qn8x7M7ZtMBRYdePiOvKmF8=;
        b=TMy9nrCIFLxmGXEDGtAtJKcEcYLME//nfWAllcYz43aI477YIjAy1Ea3GZh47Ttcht
         H6P8pachu3w2CmKBS9FgiRxImE08e6KbOQ0a3G7JiVCbWWyMnMSMwjC6Yxo3zVgFzlmy
         FXFqbmE8R/JEV4h5Ww9QfpXdacis2anxPLzbtg7qDWF5jMKfCvKmUImxay1cJJj1G3kN
         KpFdg59cAsUFmOhQfMg8O4aTLEifFMrkGTykGJpeh5jODVAnzRlYf4u+YE3dn0jnZyt7
         SA0THqYcnGLWMXcGeoIS8fb68KvJH3mDGARhEGA8wI6owCVeY0vyAoGu6gIlRj6gZ09M
         AhBg==
X-Forwarded-Encrypted: i=1; AFNElJ95NzmLIAdB5ZkI0HMDTTlCd/L2J56GgdvpQB32i5VW40J0N9Nmj4IFLRLmnJgovOvaw6o5BqKiwQEm@vger.kernel.org
X-Gm-Message-State: AOJu0YzkF/m7lWfWxsvGnQgeHLixKdDYXBD/jQ0kXns3Io2Ba1ZJmEUd
	fvGGRLq/T7Hm13kSWxmLpQIand4zVeCgxBB19eyvCEAbpDBvfGHCB4gWgECB/1fO6uk=
X-Gm-Gg: AfdE7ckyFAx4JQutWKRgu/YD7wIUyUrutBQvSY+qaT4Ge/7w8XqdIOY0CYUENe0RcEd
	IzauwyQxUloNCo/pHMlegiNlyNJKVG06ckp2pCEaEZHR5OcT4ZxPyOyyOJ75jOfa3fMthBeNvdi
	lvoy6svQ2IQRonpcmDhBq895PWwAA9yhP9g3aYS+W3W7za2L6lHdlsHpH0jTqV2jIyhc+Q3OHCl
	GO5jEh2yEathJI/n5bObxYdXoTcIy2DkswLZltTMt87sxka+hHQjKorJzrdlzdCB6nHZgzYNbow
	aO9LQ3J0wjlcdfh4J9pSDz92gC8OqAKjIcsn0MMXZQsQ9BCX+O31dpANG6ibw3Yh0InfWjc7+kx
	nBWGF9NAJYE20vRLwjUI4DdPFCy4QKbViDNSY8ISgzTwh6hB63fNuD1rWq6aVfR8nl/Y+dSc5No
	Atomqo92l0neKhfTpN/zAWP8lxuocxCsWTeOCMIdG3n/4wH9AIOFln67njBw==
X-Received: by 2002:a05:600c:8590:b0:492:4363:e7eb with SMTP id 5b1f17b1804b1-493c2ba4f75mr109823175e9.32.1783067756702;
        Fri, 03 Jul 2026 01:35:56 -0700 (PDT)
Received: from [192.168.178.47] (aftr-62-216-205-241.dynamic.mnet-online.de. [62.216.205.241])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493ccd9d620sm33431275e9.1.2026.07.03.01.35.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2026 01:35:56 -0700 (PDT)
Message-ID: <5b03b1d4-c094-437c-8934-64b94bd37138@suse.com>
Date: Fri, 3 Jul 2026 10:35:55 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] scsi: ipr: use kmalloc() to allocate IPR dump buffer
 memory
To: Mike Rapoport <rppt@kernel.org>, Brian King <brking@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Brian King <brking@us.ibm.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, wenxiong@linux.ibm.com
References: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
 <20260630-b4-scsi-v1-3-494fb37ebe7b@kernel.org>
 <7c8f0e70-f49c-4614-af95-002fb2be11ba@suse.com> <akTjQVQQNdeO9M28@kernel.org>
 <d92f22b9-9a4d-42f2-ba67-0371f85fedd3@linux.vnet.ibm.com>
 <akYLdBME5kgyi8Rw@kernel.org> <akdpddKBt7gV6po5@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <akdpddKBt7gV6po5@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/3/26 9:49 AM, Mike Rapoport wrote:
> On Thu, Jul 02, 2026 at 09:55:56AM +0300, Mike Rapoport wrote:
>> On Wed, Jul 01, 2026 at 04:03:48PM -0500, Brian King wrote:
>>> On 7/1/26 4:52 AM, Mike Rapoport wrote:
>>>> On Wed, Jul 01, 2026 at 09:03:06AM +0200, Hannes Reinecke wrote:
>>>>> On 6/30/26 12:54 PM, Mike Rapoport (Microsoft) wrote:
>>>>>> IPR dump machinery allocates memory to save adapter's crash dump using
>>>>>> __get_free_page().
>>>>>>
>>>>>> This memory can be allocated with kmalloc() as there's nothing special
>>>>>> about it to go directly to the page allocator.
>>>>>>
>>>>>> kmalloc() provides a better API that does not require ugly casts and
>>>>>> kfree() does not need to know the size of the freed object.
>>>>>>
>>>>>> Replace use of __get_free_page() with kmalloc().
>>>>>>
>>>>>> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
>>>>>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>>>>> ---
>>>>>>    drivers/scsi/ipr.c | 4 ++--
>>>>>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
>>>>>> index d207e5e81afe..5a212bfdeec2 100644
>>>>>> --- a/drivers/scsi/ipr.c
>>>>>> +++ b/drivers/scsi/ipr.c
>>>>>> @@ -2893,7 +2893,7 @@ static int ipr_sdt_copy(struct ipr_ioa_cfg *ioa_cfg,
>>>>>>    	       (ioa_dump->hdr.len + bytes_copied) < max_dump_size) {
>>>>>>    		if (ioa_dump->page_offset >= PAGE_SIZE ||
>>>>>>    		    ioa_dump->page_offset == 0) {
>>>>>> -			page = (__be32 *)__get_free_page(GFP_ATOMIC);
>>>>>> +			page = kmalloc(PAGE_SIZE, GFP_ATOMIC);
>>>>>>    			if (!page) {
>>>>>>    				ipr_trace;
>>>>>> @@ -3226,7 +3226,7 @@ static void ipr_release_dump(struct kref *kref)
>>>>>>    	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
>>>>>>    	for (i = 0; i < dump->ioa_dump.next_page_index; i++)
>>>>>> -		free_page((unsigned long) dump->ioa_dump.ioa_data[i]);
>>>>>> +		kfree(dump->ioa_dump.ioa_data[i]);
>>>>>>    	vfree(dump->ioa_dump.ioa_data);
>>>>>>    	kfree(dump);
>>>>>>
>>>>>
>>>>> I _think_ we can replace this with kvmalloc, and allocate the entire
>>>>> dump buffer in one go. Once switched to kmalloc() it's kinda pointless
>>>>> to allocate separate page-sized buffers here.
>>>>
>>>> kmalloc() performance is on par with __get_free_page(), but kvmalloc()
>>>> would be slower if it falls back to vmalloc().
>>>>
>>>> I'm not familiar with the driver to say if this could be an issue here.
>>>
>>> This code only runs when the adapter has hit a fatal error, so should be
>>> extremely rare. The memory is getting allocated while the storage adapter
>>> is in a failed state, so anything running on the system at the time could
>>> be stalled until recovery is completed. This memory is allocated and should
>>> be freed soon after the adapter recovers. In order for this code to
>>> run, the iprdump daemon must be running, which will then read out the dump
>>> after the adapter is recovered, and write it to disk, after which time, the
>>> ipr driver will free the kernel memory.
>>
>> Thanks for the explanation!
>>
>> So the allocation is not on the hot path and it seems to me that
>> performance differences between kmalloc() and slower vmalloc() won't move a
>> needle relatively to the entire dump procedure.
> 
> I looked more closely at the code. Currently the dump continues as long as
> it can allocate memory and even if memory for the entire buffer is not
> available there still will be some data in the dump.
> 
> With a single allocation that may be as large as 80M
> (IPR_FMT3_MAX_IOA_DUMP_SIZE), an allocation failure would mean no data
> would be dumped at all.
> 
> I think the current model is better than using a single kvmalloc()
> allocation for the entire buffer.
> 
> I'm going to send v2 that keeps kmalloc() and only changes GFP_ATOMIC to
> GFP_NOIO if there are no objections.
> 

Fair point.

You can add:

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
