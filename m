Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A816A32277E
	for <linux-scsi@vger.kernel.org>; Fri, 29 Aug 2025 14:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756478559; cv=none; b=Ynrt0Z1iAzlDUV5lABzM/pPaKPg8fsyJeg3jYC7ov2IO4Xk/LfO1nvTIzDpQ0Auj0HBPjzvDn8Al/n65myaReGU0O8azyv+T4JmTyaq5joEj+6HioStEATYHSdPiioVbJYhQekI7na4TByW9QC1poE/nhDVHRkrxn1vx4NzczAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756478559; c=relaxed/simple;
	bh=iK+mTeelSq4+0PIo31sNfLt0VEevDDd2df1MJsi73l0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iCo2UNc4atcrBuT2eE7FQxEaak6RG9pJ9Kz4H0L5HBLXqPxgyNFS07uph2UXYYIeO3FoVbZePUymS/0/cBN+HF5W3b8IYZd1BnFeF+PNxDdseLHDhzGoZCcQ/yuuWs2EzuFeqkG4bMI8dL/jzpXp0CFCELCBwZkscLfcOMSUy6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ggmBBqWE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ggmBBqWE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756478556;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ReHesm1JzI77Ttn1crqpxEHfJBy9ITN9OqG2sWgOwWM=;
	b=ggmBBqWE/YuVjG+H4tfBTt6+W0or6V/23DDrOchhzu76Q8pIMJAis5Oke4Qx6pIABAn5ya
	5sT7heW0ebxuIYfVlppvVqJ4XQVsjHEtpuTl4VHx1IyelpL/XDLPT1M/XjhX+I9+zjcNwA
	zAGqaMveTKqWnJxY8rGNWtMdTeZkH2c=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-227-1LDF78U3PGeA__KkhrDEYQ-1; Fri, 29 Aug 2025 10:42:34 -0400
X-MC-Unique: 1LDF78U3PGeA__KkhrDEYQ-1
X-Mimecast-MFC-AGG-ID: 1LDF78U3PGeA__KkhrDEYQ_1756478554
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1b0c5377so11183775e9.3
        for <linux-scsi@vger.kernel.org>; Fri, 29 Aug 2025 07:42:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756478553; x=1757083353;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ReHesm1JzI77Ttn1crqpxEHfJBy9ITN9OqG2sWgOwWM=;
        b=q29UUMU5wYSXH6jYmppbZSQzVcj/Ast0XJ+3gIqYM3JKqq5YL9lBza7h9aTgzGMETh
         YeCsbE+wxzFNxI5m8AxDbkvVvqu8T6zc+RmF7krzaxKDu/j0JvVupuSxL0zbKHoywGWh
         Lg7MlZ1hv4ZxZodcDwBMks1GaL6cQ6sK7ziikbUQWcKQx2p1jNoyuQkWhHG0Gcwy/g3x
         fNW6H7Y8iYYY50OoW6WWXNpHCR41gNUIqG9gJ4Pdg+P8iqERkSn65mpJ+u8V9yJ03TxI
         GFWRdpg9Kw4s9mHtXiuM+NZf3i/zSmBuqL1Ma/BSJCEcY3TNB43tkKrwj5W7a4MIOxNc
         cGFQ==
X-Forwarded-Encrypted: i=1; AJvYcCVHlPltkxNXPM8zTPxq5Reni+p5e7rIjdAedXgSy9Xp+bm/CUmBPLcAngZbYcwxN1TPZDp7ewOiaZkU@vger.kernel.org
X-Gm-Message-State: AOJu0YzvTvZs4dH3Y3gGgRi6dotE/5zn6RG5ufNEDeoBozkXVD0TZKZp
	xCCOKk0B1yxDltB2H4Rsh5FDKzv7QFF4fFpsTQ3WMBbOVY8GWi4JklUJAuBqhi4JTHL2Nt4XzGL
	a45JUe8WuQfQvsougZ4MS9nkm6iqGnwdOARQEgA6xrrzSXfF4BBguPMnrHNegKIw=
X-Gm-Gg: ASbGncvb/6TBr9jExEeXt5FyH7D3jD1Uti+Z4zg+kSMiGKfYsN3QZo9ThP2mM/jdg20
	/Q5I0wXLhaY3Rtf6jXBQusD7miRQdy+0APZRy+doIWktS0DxRH6v0XHcnA4cpvg55+07/NGPVbY
	19OfpAYv+BiBivT/sBr+6fXzxZIR1Wq2i8ZnCzEKgE+n0cijWS0RtbSuiVqHcSc4B6ybrHRbyrQ
	PXeQw3XnzbQRdEywxsHAFlnInp1fNSF60yDOZdPu9ZY9DRbfDSbcT/tke/Kb+UUnFsTFwzy4ocx
	nxdr5cN2HC+JHHVrQoNzTEzR/okFXszDqecl+uPcjeJ4UvLyi6Itb2pnTUjax605JQWi6lUX8PJ
	cZe/BsdOEGXgE5zIYj2itHRDN+xN17IIyQrH2Yjs5/ajjQ6vdiOIVAKxNiSdridhh
X-Received: by 2002:a05:600c:a47:b0:456:1824:4808 with SMTP id 5b1f17b1804b1-45b517cfe66mr203887675e9.32.1756478553399;
        Fri, 29 Aug 2025 07:42:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGqWe4aldLOwoA0lSJmYOAtk/gyCTKTz2xhXTH3fTqBq+gNs3GiB4PdE3KR16CB5LbW/sn45Q==
X-Received: by 2002:a05:600c:a47:b0:456:1824:4808 with SMTP id 5b1f17b1804b1-45b517cfe66mr203887385e9.32.1756478552938;
        Fri, 29 Aug 2025 07:42:32 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1d:100:4f8e:bb13:c3c7:f854? (p200300d82f1d01004f8ebb13c3c7f854.dip0.t-ipconnect.de. [2003:d8:2f1d:100:4f8e:bb13:c3c7:f854])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e89920dsm46578795e9.16.2025.08.29.07.42.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Aug 2025 07:42:32 -0700 (PDT)
Message-ID: <7cd5f8c9-9bd3-40ed-a3df-a359dcfe1567@redhat.com>
Date: Fri, 29 Aug 2025 16:42:30 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 36/36] mm: remove nth_page()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
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
 wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-37-david@redhat.com>
 <18c6a175-507f-464c-b776-67d346863ddf@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <18c6a175-507f-464c-b776-67d346863ddf@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 28.08.25 20:25, Lorenzo Stoakes wrote:
> On Thu, Aug 28, 2025 at 12:01:40AM +0200, David Hildenbrand wrote:
>> Now that all users are gone, let's remove it.
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> HAPPY DAYYS!!!!
> 
> Happy to have reached this bit, great work! :)

I was just as happy when I made it to the end of this series :)

Thanks for all the review!!

-- 
Cheers

David / dhildenb

