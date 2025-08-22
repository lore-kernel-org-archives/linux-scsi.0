Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB4F30DD09
	for <linux-scsi@vger.kernel.org>; Fri, 22 Aug 2025 14:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755871206; cv=none; b=qpRW/FtfcUJShBYMzvmVHyVSBkfni1IMFXWzFmzjgbvalLM6s0988rn2xGn9GMQzemMp+J2BwRge8uZHzNYrWaldu6x7RrGcOWg3XzQxir4HJPqzEboUSd/jTXKJqSkjet7sfNVl3bAbdFXeUkq4xUQRJR9NST/mqLaJL6z89qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755871206; c=relaxed/simple;
	bh=Uf5BeT2cOeXT45NhomHkgVDa9aHp8Q7A4AmKdNga0dA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CFpXgzT1BtdbS72wzwlrQHuLABu8qToMX4oIGu9W2755yVehk4SSyEbfL7ybn3EpeVHtFs8elCXnprW0Ns37ANt0XPEdurtsVRtIGG0zAjXH0a40rk6yj8mCDDOGQjZZ8NlAzuXoN3VR8srJMH1AU0NJzTdNr9Q2Xgo9o4VuIU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S2RDm1yB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S2RDm1yB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755871203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=K6aDoQ2nZkjhSfUgeR22UAGAXQBWHHuCN2RUasZyd3Q=;
	b=S2RDm1yB6c1GB56ZgV5tcXh1KAFlFALQMn2dyFrAeOpNyUFP8+eYcgH0B5JChbpsLILSne
	TLRufLCWU76iALicbHkw+JlBl0U2Bu9MWAtnPz1RBG5ao3jUeNmgsjSh4C0ik81xNqfXeZ
	AV8zU3QJlstKesvTlK0FhINku+XxI1k=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-14-9Y2o_3hZM5uUXTNFdcBngg-1; Fri, 22 Aug 2025 10:00:02 -0400
X-MC-Unique: 9Y2o_3hZM5uUXTNFdcBngg-1
X-Mimecast-MFC-AGG-ID: 9Y2o_3hZM5uUXTNFdcBngg_1755871201
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a256a20fcso12451485e9.2
        for <linux-scsi@vger.kernel.org>; Fri, 22 Aug 2025 07:00:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755871201; x=1756476001;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K6aDoQ2nZkjhSfUgeR22UAGAXQBWHHuCN2RUasZyd3Q=;
        b=Q3muqG2swDV4CrMVJO+VmbYtqPfFn4uxX7yQb1dDZLPVutv4XcrwLDqdu0xxiuXO3X
         ANYOIU9dOK3vHoiadEqzSWeX2tsTSfAZv6Zt/+GAiYTnRiyCR5YWlqqtzkDnEXKwAWg/
         z24EYFnCnzqHmdUCqRdzzm73ijoPj1TFlhmmyEdtZ/v8iaR6JhqL0WFF8doSHmY1FM/Z
         ZtJ3gMRyCIU/ILIJgS4F5Zt7RIyXbxr82eU94c+ljxujUlbUmQFO9wAXoHhtm1uqxfIe
         XZd0Wg92cbvUlrHJGp2DpYZ+hyZ9Qm0I3GKzUtm4xXhj8bw/RK7uisrYgZ7p/SWWCYAD
         a5dw==
X-Forwarded-Encrypted: i=1; AJvYcCX0xBSOajIDAhEYO+jZhtJ8w8v/LWNcyrupMIf+lhYrBlzbvUJvUxTB0E3FE+ihOblyqTBDEh+HEQz9@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6Ty1hj30KJb5tMLJqVJFnmVgP2ZDrMvnQMOrkjEp7lMub2gTw
	3KwiTFNpjre0QUl8rE+TYZTrLZ3g+F5/vOFZQZFrAaP6pnJOOgB+jD+U+/gztEETo+1+KqI1ZSc
	3ydH9XV4WsVsxGFep6pTIA7KYkyJ0Fc0A/QQhbIe8xfEWDPP0N41xO0xrEurt5p0=
X-Gm-Gg: ASbGnctIEnCM3hZ0TlU/90cASxTIcoF1ppH/kiKMNJUWadV16ylX5ZrRi+q57xTH63m
	nH320tbbiS7Ouv/sXkfeIYcaxK/Gs64Cjc33Jfz0i8jlM4rtLVepiHtVLIlmTd9bUnOBk2lXNXD
	rUd8nLsn8cNp+LvSuAJ+CQv8h3d6i+Ye0sknXfhIlPGAwaU0uCQs2i7b6kTUPNqZxnDj8ra7DIP
	ozDKFrQUMYIdG2IsZRmmQ4owSVosKn3uhJG9kkJ1zxO6aou4oCmm7VcbPSzhdV+DIhOJbAgrSKJ
	YGRkkIlmT54c3m0EAjr8uxTkx5WqNq6sZ2RH42FuaNS7wrER77FFwUpWR1oRYXqxWzdJ6VuQOw4
	W1uhm0Ev4nGuAQMBvm+kJYYWEcqhWznZSQUVdi8Ku8c5391M2Ru4JPPUqb11le4wbnyQ=
X-Received: by 2002:a05:600c:1554:b0:459:e06b:afb4 with SMTP id 5b1f17b1804b1-45b5179b4fcmr28181635e9.4.1755871200661;
        Fri, 22 Aug 2025 07:00:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGwWP+gcyHz5PASikvY9eCVK8ixT+7ngDF6OHjbY0O7J0DLjuT/QVU1ki3KQXQcrTer6FnpTg==
X-Received: by 2002:a05:600c:1554:b0:459:e06b:afb4 with SMTP id 5b1f17b1804b1-45b5179b4fcmr28181195e9.4.1755871200176;
        Fri, 22 Aug 2025 07:00:00 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2e:6100:d9da:ae87:764c:a77e? (p200300d82f2e6100d9daae87764ca77e.dip0.t-ipconnect.de. [2003:d8:2f2e:6100:d9da:ae87:764c:a77e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b57498d9csm82525e9.22.2025.08.22.06.59.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Aug 2025 06:59:59 -0700 (PDT)
Message-ID: <473f3576-ddf3-4388-aeec-d486f639950a@redhat.com>
Date: Fri, 22 Aug 2025 15:59:57 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 18/35] io_uring/zcrx: remove "struct io_copy_cache"
 and one nth_page() usage
To: Pavel Begunkov <asml.silence@gmail.com>, linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>,
 John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
 kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev,
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org,
 Zi Yan <ziy@nvidia.com>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-19-david@redhat.com>
 <b5b08ad3-d8cd-45ff-9767-7cf1b22b5e03@gmail.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <b5b08ad3-d8cd-45ff-9767-7cf1b22b5e03@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22.08.25 13:32, Pavel Begunkov wrote:
> On 8/21/25 21:06, David Hildenbrand wrote:
>> We always provide a single dst page, it's unclear why the io_copy_cache
>> complexity is required.
> 
> Because it'll need to be pulled outside the loop to reuse the page for
> multiple copies, i.e. packing multiple fragments of the same skb into
> it. Not finished, and currently it's wasting memory.

Okay, so what you're saying is that there will be follow-up work that 
will actually make this structure useful.

> 
> Why not do as below? Pages there never cross boundaries of their folios. > Do you want it to be taken into the io_uring tree?

This should better all go through the MM tree where we actually 
guarantee contiguous pages within a folio. (see the cover letter)

> 
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index e5ff49f3425e..18c12f4b56b6 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -975,9 +975,9 @@ static ssize_t io_copy_page(struct io_copy_cache *cc, struct page *src_page,
>    
>    		if (folio_test_partial_kmap(page_folio(dst_page)) ||
>    		    folio_test_partial_kmap(page_folio(src_page))) {
> -			dst_page = nth_page(dst_page, dst_offset / PAGE_SIZE);
> +			dst_page += dst_offset / PAGE_SIZE;
>    			dst_offset = offset_in_page(dst_offset);
> -			src_page = nth_page(src_page, src_offset / PAGE_SIZE);
> +			src_page += src_offset / PAGE_SIZE;

Yeah, I can do that in the next version given that you have plans on 
extending that code soon.

-- 
Cheers

David / dhildenb

