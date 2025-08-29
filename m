Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA409307ADA
	for <linux-scsi@vger.kernel.org>; Fri, 29 Aug 2025 10:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756461994; cv=none; b=sCDYGQCOKzMzAriPp6wL+sCopvFjzTLEhVWyRVe9um+uaByVkAX3/Egrvrrq28IGo/IdN+Gk7g36JGZdTvsahESr8yZmMRjq+ThFxhNCpYTs9CRr6w3ZJna/DEk3x29UvlLoOhS4NQb/pr0bS6VIzKiED/LGHEAdLirshWheJzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756461994; c=relaxed/simple;
	bh=yo0XFtlRucDU3CPmKUauZEk6meUI8I6YEGkEEcyZ+8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B3sdloxgrzVCftLpr5i51AIhEv0bVPEFFD4l8+/EYSxNGP5VWXqSiHVe/VaYNvZrW6l5FPWNHFier6oB8CfCWXX1I6CYgnEANkIHn6eKEylID7SWt1sZqxd3S44JjTWGLEAfe6uD2bfRHNGgQlsfA54tXk+gRS0c9H7zr3G5ymc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CufpOxBQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CufpOxBQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756461990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lPHoMHV5vJS1QZV5L+lWiiTGuBUarel82A4quq5C180=;
	b=CufpOxBQnIIw86j4pn4eVT8fpF4WjYfuz6x3z4E5eGTTUHM7tBECgweEARySJmSd9i0x5z
	GXjRFitRbobDUgsYPBkf21LLBn0NrcxUQavJwOCe+Omu0eekNNw83wee5PtefEXA90zHiC
	/EWDlGMkOsVrwSgf1Jcch3GWJr2pEIQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-1-sJ7SYEf-M8azJ8fx7lw0_Q-1; Fri, 29 Aug 2025 06:06:26 -0400
X-MC-Unique: sJ7SYEf-M8azJ8fx7lw0_Q-1
X-Mimecast-MFC-AGG-ID: sJ7SYEf-M8azJ8fx7lw0_Q_1756461985
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ce7f782622so647338f8f.1
        for <linux-scsi@vger.kernel.org>; Fri, 29 Aug 2025 03:06:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756461985; x=1757066785;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lPHoMHV5vJS1QZV5L+lWiiTGuBUarel82A4quq5C180=;
        b=kfp9ujIgfCEjAFt3KC5cmf/fDn95UpOJnzPZGQQVucCA+ZNvXSk9DhBrW18F+n8cQR
         +D+pLsBmNI6TUCBOPoVq4/V1awSBX4abQKeR6+viiw1r5cAflcLewz5psRHIaNOxHEqj
         ciZSRephzPofrHnc6Iw/hcvaMkvf0AjxYhtpmkC1GGSmchkaYkEOAbOgi5Ko5EX10XNB
         G6pTfAwltcW1xz3l//FtadXJH+Rs/g1I3mV4ASVWP6Ja2zedjX0QzW5M4iTGyqdeptMH
         Ia4gWG3w32XkSDlHxcgeK75Z3FGUTK3JCQAHUZNVo0l/0CNHGBZr6usK6Nprjy/C/U6l
         HqXA==
X-Forwarded-Encrypted: i=1; AJvYcCV6hbsR2fzIy87yC50VcwV/cIChHov8ywEdEHrEKpxgiJsPvN6nnyIllNmgRAvRG0keMEktFjTQ4EWs@vger.kernel.org
X-Gm-Message-State: AOJu0Yyx7Bfc3Pp7YWoAeB+ie+NbVMlF4Wi4I9fMA03wmhejpzFZ3GLD
	U/GpzABvlZcjdt0GvBw04Lygxq6va1PoWJMMiz37q9nNcXJLa2Rx+eLdQmA4pBmUX1X9R432A04
	x+THvSWcEfK5FDsy0xJsyUZhIt3+99ji5o/T8Hi+6Hb3KbIneLFwDkC9XcvPMmg4=
X-Gm-Gg: ASbGncucxqOJ/IYuQ6RL5lpuABiOgnPG6LPBADjetOMiukwokLuptiIlT3vjDljqzbM
	a6NEDN38/YYWpPUsKf9Hl477bI92F1ZIq7EZA5mqfUJZt97poLzQZVqDDOSPmQJpF2G6/KgSY9K
	s/jTyd8kNdB4bIyzPg/4JvcDuT5AYzegbPmHazbmdKzj+yEeDwn5uGDcCZTx954Z0NRfBHuF/5b
	p75qbOwIcVqU3tBzTUtJC1JIrLz03dRYDjUtPe+Td+lcwK7C3aCRWdOBXL8V7Lx/5I3BZpta1Cj
	T94GekrR4ykXTjmEaDdu+XxLfW9oboqeabHYDao8G+la9bGfSDC4lwHNr28dZcdr4SpUa9fNjup
	sTTPCxt9LEzPPe/uUb+inik5alH88cDAte34IDhA0iVqQdpX5TyYqAfUUrBKMymy1
X-Received: by 2002:a05:6000:2082:b0:3ce:663a:c92f with SMTP id ffacd0b85a97d-3ce663af648mr3716840f8f.25.1756461984552;
        Fri, 29 Aug 2025 03:06:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG+cEIb1Z4u6pTtqsfT89DbTAZZhLHMJCnkgKmDWXX/Q7MNQLWv1cM4WZiGdQoi1AW0dJ7LMQ==
X-Received: by 2002:a05:6000:2082:b0:3ce:663a:c92f with SMTP id ffacd0b85a97d-3ce663af648mr3716770f8f.25.1756461983963;
        Fri, 29 Aug 2025 03:06:23 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1d:100:4f8e:bb13:c3c7:f854? (p200300d82f1d01004f8ebb13c3c7f854.dip0.t-ipconnect.de. [2003:d8:2f1d:100:4f8e:bb13:c3c7:f854])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b74950639sm85846585e9.17.2025.08.29.03.06.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Aug 2025 03:06:23 -0700 (PDT)
Message-ID: <547145e0-9b0e-40ca-8201-e94cc5d19356@redhat.com>
Date: Fri, 29 Aug 2025 12:06:21 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 06/36] mm/page_alloc: reject unreasonable
 folio/compound page sizes in alloc_contig_range_noprof()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
 SeongJae Park <sj@kernel.org>, Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-7-david@redhat.com>
 <f195300e-42e2-4eaa-84c8-c37501c3339c@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <f195300e-42e2-4eaa-84c8-c37501c3339c@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 28.08.25 16:37, Lorenzo Stoakes wrote:
> On Thu, Aug 28, 2025 at 12:01:10AM +0200, David Hildenbrand wrote:
>> Let's reject them early, which in turn makes folio_alloc_gigantic() reject
>> them properly.
>>
>> To avoid converting from order to nr_pages, let's just add MAX_FOLIO_ORDER
>> and calculate MAX_FOLIO_NR_PAGES based on that.
>>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>> Acked-by: SeongJae Park <sj@kernel.org>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> Some nits, but overall LGTM so:
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> 
>> ---
>>   include/linux/mm.h | 6 ++++--
>>   mm/page_alloc.c    | 5 ++++-
>>   2 files changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 00c8a54127d37..77737cbf2216a 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -2055,11 +2055,13 @@ static inline long folio_nr_pages(const struct folio *folio)
>>
>>   /* Only hugetlbfs can allocate folios larger than MAX_ORDER */
>>   #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
>> -#define MAX_FOLIO_NR_PAGES	(1UL << PUD_ORDER)
>> +#define MAX_FOLIO_ORDER		PUD_ORDER
>>   #else
>> -#define MAX_FOLIO_NR_PAGES	MAX_ORDER_NR_PAGES
>> +#define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
>>   #endif
>>
>> +#define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
> 
> BIT()?

I don't think we want to use BIT whenever we convert from order -> folio 
-- which is why we also don't do that in other code.

BIT() is nice in the context of flags and bitmaps, but not really in the 
context of converting orders to pages.

One could argue that maybe one would want a order_to_pages() helper 
(that could use BIT() internally), but I am certainly not someone that 
would suggest that at this point ...  :)

> 
>> +
>>   /*
>>    * compound_nr() returns the number of pages in this potentially compound
>>    * page.  compound_nr() can be called on a tail page, and is defined to
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index baead29b3e67b..426bc404b80cc 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -6833,6 +6833,7 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
>>   int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>>   			      acr_flags_t alloc_flags, gfp_t gfp_mask)
>>   {
>> +	const unsigned int order = ilog2(end - start);
>>   	unsigned long outer_start, outer_end;
>>   	int ret = 0;
>>
>> @@ -6850,6 +6851,9 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>>   					    PB_ISOLATE_MODE_CMA_ALLOC :
>>   					    PB_ISOLATE_MODE_OTHER;
>>
>> +	if (WARN_ON_ONCE((gfp_mask & __GFP_COMP) && order > MAX_FOLIO_ORDER))
>> +		return -EINVAL;
> 
> Possibly not worth it for a one off, but be nice to have this as a helper function, like:
> 
> static bool is_valid_order(gfp_t gfp_mask, unsigned int order)
> {
> 	return !(gfp_mask & __GFP_COMP) || order <= MAX_FOLIO_ORDER;
> }
> 
> Then makes this:
> 
> 	if (WARN_ON_ONCE(!is_valid_order(gfp_mask, order)))
> 		return -EINVAL;
> 
> Kinda self-documenting!

I don't like it -- especially forwarding __GFP_COMP.

is_valid_folio_order() to wrap the order check? Also not sure.

So I'll leave it as is I think.

Thanks for all the review!

-- 
Cheers

David / dhildenb

