Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F163568E5
	for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 20:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806873; cv=none; b=jW0Yx70hHcYB1i3eyIZr7C0NORPir6V+VQ64qLQQ+jZ4kuC3Ga9f+CEjQW9JAOwYSGS+6OTpHq7LgIz1RkL0bSblRtLzMir6dsfzx05O/T6SQhP5ah51CxcvSMYvkDbU34BPSNNr6Euc7QZw3yT6JpEg3C5dt25UVzSdZwW7Lg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806873; c=relaxed/simple;
	bh=g5Pqhen6+TGsZaJhVjcxjHrty8uEIOPaJGSbz6Iayeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAuDGXJqoO3d6HXPMrofd7nrPZ1zUub5/EkaSn6fLdU3bz964+v2RwL27mMtkBf0v6g6KBSutMGQfwjsewvFDXNACwZq3RrZaDaIdU49tNUiy9UIzaIUaiRgMgXTMXgqH9xowbCN4O53JcjmjuA3zz0+p43a7mvvnvzz8pq4YwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jIRSUtF7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jIRSUtF7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TaqjYk7qiFpFT4dP16wKMuC8fiQfbkUwRRgQVKGzHC8=;
	b=jIRSUtF7Qsx0FT7WrG0s6ptvTaWbRuyOa0zj3WIy++xstX+EEKPU/aaEoPK7eplS3fmYF3
	pdniKt+n9l1WIdXbIwXKD+vnOqjE2bydKBQmH/jfjPhj0ucj04ezfkrl5NdHgKlds0kthC
	sX6p/Vv8knDVTkt3t2upH/Uf+X/Tn1I=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-799SsS1rOYeQ9cw_JeUk4A-1; Thu, 21 Aug 2025 16:07:48 -0400
X-MC-Unique: 799SsS1rOYeQ9cw_JeUk4A-1
X-Mimecast-MFC-AGG-ID: 799SsS1rOYeQ9cw_JeUk4A_1755806866
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1b0d221aso6547755e9.3
        for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 13:07:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806866; x=1756411666;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TaqjYk7qiFpFT4dP16wKMuC8fiQfbkUwRRgQVKGzHC8=;
        b=Kkv8Pwyu9VZYnUa872MJLuAAw+kalfUYF7CMO+ERD55IRjiBqyioAq0LpscWv7IRuI
         lWfYY0jDFFuAYg06ak5q5awnX2KI4JR6uaVMl8Rk+R9TmUT4BdWwhroLOulWQymXClkO
         n+mn7792z786aaQI+vZl7ByLSvPC37Nl0K/+vNIiM//74NaYwLq+rRkR4slcNNp7wSls
         O0Igb0e7+4hleyS9aq/HXoCpl2KN96zHfB7rZRpIXTU0Ybf8vIheE0+1eV803phajJti
         vhuIX6f7tMZDJFDEjnGG6H3dVTrXE3aEtuP/BABbJh17EKLlPCtbV8u0Ao0QUCwbgJeQ
         4ulA==
X-Forwarded-Encrypted: i=1; AJvYcCU0FNDJOj9DoHAc4lfKqR+AuqncsiYF3svAg9StAtwWOalXizJY8E/o6p7JynFkRw74IV6OFblKRqo+@vger.kernel.org
X-Gm-Message-State: AOJu0YxKTZjzipPpMnC4irwcJPdTAsnMhyMMaahOYbD/N5N5FeCSoUde
	u3jRIpPAqeNDJXh5ftSuU3slHvPs8wALgA+X3OArZ0TN0ZilcBWVEE+bSFCGhE1qcQ6yLoCNSfp
	G9l4UlmnMQoDNaIJmK+zQIXgL1yKKfh1lY7k6qzY5yRLK8+glb13OduG4CqTAh9I=
X-Gm-Gg: ASbGncsjuW8gO73qV9Pmd3gB3UOuh36Sq+yluv8N81vnJSRZHc+nRzH0I3bCFnqHOf+
	T3jKtBl/h+ua7s9hcQD9yd7vX/VJPdpbYN/PmzsisdhrPXt1BIQjOqH9XarjDrzCV34mG7+JX9X
	IJ1Y2WLfhjCUEShfJLqcD3RYOdYBR7aXDtnJXdEycUhDwLpReyfTPJmS57qm+daD431k+4YyVIj
	hcxOL7lT7X3Ux0ZxwZyTYk5lE2TEAhNDseOjUXoCdEKHLa2RyevGMfXFNgPn+rvTlPsVHk2tWlV
	KJA6GISRbvpnOdLa2+LJPeiQkr2jW4RSMEDviX8JvuSNI3i3FjcpUDoT4T9/YifE6WWwbvDkz+G
	7JWc/A5asNEl5LjwtOv2/jg==
X-Received: by 2002:a05:600c:1392:b0:453:5a04:b60e with SMTP id 5b1f17b1804b1-45b517d4e23mr2819635e9.26.1755806866199;
        Thu, 21 Aug 2025 13:07:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHUtzGc4rPv18tjnV22wd1xjfGI25AJiVbHUBF3o7jj7YvZLrrv8XzLc39l/Z4dCqHj4yY2QA==
X-Received: by 2002:a05:600c:1392:b0:453:5a04:b60e with SMTP id 5b1f17b1804b1-45b517d4e23mr2819075e9.26.1755806865726;
        Thu, 21 Aug 2025 13:07:45 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50dd0380sm8632985e9.10.2025.08.21.13.07.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:45 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
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
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC 14/35] mm/mm/percpu-km: drop nth_page() usage within single allocation
Date: Thu, 21 Aug 2025 22:06:40 +0200
Message-ID: <20250821200701.1329277-15-david@redhat.com>
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

We're allocating a higher-order page from the buddy. For these pages
(that are guaranteed to not exceed a single memory section) there is no
need to use nth_page().

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/percpu-km.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/percpu-km.c b/mm/percpu-km.c
index fe31aa19db81a..4efa74a495cb6 100644
--- a/mm/percpu-km.c
+++ b/mm/percpu-km.c
@@ -69,7 +69,7 @@ static struct pcpu_chunk *pcpu_create_chunk(gfp_t gfp)
 	}
 
 	for (i = 0; i < nr_pages; i++)
-		pcpu_set_page_chunk(nth_page(pages, i), chunk);
+		pcpu_set_page_chunk(pages + i, chunk);
 
 	chunk->data = pages;
 	chunk->base_addr = page_address(pages);
-- 
2.50.1

