Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCF336CC6F
	for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 20:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806895; cv=none; b=Fdow/9dJkYSjiBj9GR2oi5rAbkOcI6neQIyPZiN5RpPrJIiMjjz5dVOMIIQ/I+XU/LM3bJYOPuQng6uzSn5AemdFZWNrTUZJYTVV1l+HJnv+WaWtJwjBqNV+563GiFU3DSodmavWhKCwFROF0vqvMDd4VMyUh7Fh7IMvfc9MguQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806895; c=relaxed/simple;
	bh=35i5s1BcLEONuxohRPeqiFHOreLIpfTF289+ZIXZu/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8gFAGS5Q7VjzlclU6oSlPbHMYPB7TM7ssWGe8PKEtgrRTI7CA88WPM/Rr91o9a7l2MUp7+n2LoPJ9BDBDBDj2Dot0u/Rxsj768TCG7dPL1Ai/QEifj1NVtrQaZhv5HBPgTKP4cgFCUs1y7pCKh0BraLwa0+HY+9S9RAVkaEyo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iy3wgKBi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iy3wgKBi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806891;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pq6EMCEhMXNA7HGNe/O1qYHWHhWZrBzRdRZ7YmKumJw=;
	b=iy3wgKBi03EyZ3sRdRWSgr84psZuJtpBypQHP7law3eYFY+FVr08x31c3sGqpwjxqAGmTX
	xqBGUqiu8RyAPg93w1dvnEzol1HjwjQI/m6o382BgrH/D7lRFhyqnnqDsexkYq33pFBhbr
	yj7lMaG4r48RcxYaH/qGbQzbdKtKz3w=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-532-fPCd7a_BOESW_u9U6MDPlw-1; Thu, 21 Aug 2025 16:08:10 -0400
X-MC-Unique: fPCd7a_BOESW_u9U6MDPlw-1
X-Mimecast-MFC-AGG-ID: fPCd7a_BOESW_u9U6MDPlw_1755806889
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b9dc5c2820so445391f8f.1
        for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 13:08:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806889; x=1756411689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pq6EMCEhMXNA7HGNe/O1qYHWHhWZrBzRdRZ7YmKumJw=;
        b=l1wJ9bFMV1E8QeuISYsebRazLYUe4EOXcZAkwtSPpssHWJXIWhFC/8YUzF4ECPk3Jh
         iL/iWY7a7M63iVVwijfav9kLSSvHHCIharA31n3FSQqbgqdvkW1Q8KD3/KZkjevIjL+S
         IvNtnep/ggoDKBzvazPBbpPuwwlHLK4ajV+8s9kE4neEBUpPwtQqekF17Tiue/+37IoR
         Tn6VFnDjHYcyBT6DQeTTr8ifJ7elfMPGeSDUX7NM51SY8RbZ2yDU5tXol+8KL/bKVtLJ
         lpZDrZXlXIS/hyRDDzZJKe8ZHwCUO9/gSa5vQCT9NBxVL617TPukZW1MH3GWmizjwpP0
         K74A==
X-Forwarded-Encrypted: i=1; AJvYcCW04Nk8eCWwjjJWUddrwkbTIIyp6hYO3vJd1n4WFAVf/HdFvXc1/7yTN1xNG8LNLAUZm1YEoFG31UDr@vger.kernel.org
X-Gm-Message-State: AOJu0YzeBocx4E9x+mfpNTRdUwbYK+KVFX4UQN+QetcaLT53UK1qB8+L
	tUme13rV4pbm6MVAEhJ4EcarDQdL92rcHTZ7vAw1as8b2Nqr/LAd366iD0ubg0cVUStijiPkYR3
	k0vxvighMEk9l2+vHJwnvgeXCBYD9rWxWKM6Bc9SK7KBnKd8lMfcDHyj3U0PifC4=
X-Gm-Gg: ASbGncvtVca3uKZxO52GM8UUC+EhLhcePWMMOlqOhXY0h6E95kVGR4yTYpRUK17AlcO
	oxevBSfvCY9dh1BWn9PMGA5XkRhZqPAYUnlGMzCREk5jE/reUY35arS5puxVYU3Oihd7VHeMbQF
	lkZ5u42zFMo6DDmgK3XvrWk//m883cx+m4TJhpBdQpM6Kk4ggMvylo0zcRDoU3U6ug6jgoDnudx
	HvwwIFh57ZA74EAqWKK+8Tbi6Xh8P0U8Do8RRz16/lx8CCC4/xfrcYWpAyzRpg60xKlZ2ryvWSA
	ui9FZjmtSRRdbXwCPNYAXS/7BZzhCeZF4FT1cSQQZWzX90uvAA5HgDhQr/QkmBnzt9MAFoulzZC
	r4bRDMfa8lpn6c1i7uX76SQ==
X-Received: by 2002:a05:6000:40c9:b0:3b7:911c:83f with SMTP id ffacd0b85a97d-3c5da83bf5bmr151950f8f.9.1755806888891;
        Thu, 21 Aug 2025 13:08:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGeHEkncn914iQLB6IDJFbFllUgyuseH1VcCPvg+Bdgchh7CcvmYDhAXktPsYS0hqHcr6hQuQ==
X-Received: by 2002:a05:6000:40c9:b0:3b7:911c:83f with SMTP id ffacd0b85a97d-3c5da83bf5bmr151916f8f.9.1755806888456;
        Thu, 21 Aug 2025 13:08:08 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b4e2790a8sm21120815e9.1.2025.08.21.13.08.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:07 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	kasan-dev@googlegroups.com,
	kvm@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC 22/35] dma-remap: drop nth_page() in dma_common_contiguous_remap()
Date: Thu, 21 Aug 2025 22:06:48 +0200
Message-ID: <20250821200701.1329277-23-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dma_common_contiguous_remap() is used to remap an "allocated contiguous
region". Within a single allocation, there is no need to use nth_page()
anymore.

Neither the buddy, nor hugetlb, nor CMA will hand out problematic page
ranges.

Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 kernel/dma/remap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/dma/remap.c b/kernel/dma/remap.c
index 9e2afad1c6152..b7c1c0c92d0c8 100644
--- a/kernel/dma/remap.c
+++ b/kernel/dma/remap.c
@@ -49,7 +49,7 @@ void *dma_common_contiguous_remap(struct page *page, size_t size,
 	if (!pages)
 		return NULL;
 	for (i = 0; i < count; i++)
-		pages[i] = nth_page(page, i);
+		pages[i] = page++;
 	vaddr = vmap(pages, count, VM_DMA_COHERENT, prot);
 	kvfree(pages);
 
-- 
2.50.1

