Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375D2352FFD
	for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 20:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806931; cv=none; b=HoUYvp/UvmA+whwKXyMwIKezsXo0oXshDWGC4dGJArwg1Kwd8UNFswavQGoWtx65Bv2LheYWKh1Hpgczvx95Q/UQu9o0ZUhbKUeE1QJskbPbUqC9tDwU2JE7SpT7/FoPhynlzlBVUaLHXVgf5hoXlCMSv3UKU/4uHOdUWmooRxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806931; c=relaxed/simple;
	bh=vBZZGz0SB0V7Hvywd1N29mvuGT2dBN/lU5Bb9Xz8Q6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYeodm6E9uk9+5Ov/86Du1RpreZoWz3XQIGM1KbvEn8oLvlRuTyJGqtFWiSOVmbn0c9f8cB2X9i2gnkdMnrtxZCpHPMYschPpxUkOKAN9uUM8ANZgQfui8HIsTqHe8HIUxp3hTZ4kizPdDnMv0LtEALi+iSkcdQ/cuQ0Ug8oHUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e1JSg2B2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e1JSg2B2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806928;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8aQmj/0+AYT4mPx/DatgQPPbmq0Lkvm9KCqKkKCdC9Q=;
	b=e1JSg2B2zYR4/k9MYnGN1wDcaVC0eaxaiLJohSY7QvdYHyg4VRv+llTGlQa4rwq5tW0NC5
	d9/gP1NklKkwL0k06r9F7aLwoefh2d/vgLLQbqgpE6xsiDSjZh7lOltjT5v2OJLwsEIq+J
	9PrzJIojvoLP/Q7Xbp8qcgcl6dtJiFA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-ihgX2O0COfmZZwcPWPRSpA-1; Thu, 21 Aug 2025 16:08:46 -0400
X-MC-Unique: ihgX2O0COfmZZwcPWPRSpA-1
X-Mimecast-MFC-AGG-ID: ihgX2O0COfmZZwcPWPRSpA_1755806926
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a1b05d31cso7263185e9.1
        for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 13:08:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806925; x=1756411725;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8aQmj/0+AYT4mPx/DatgQPPbmq0Lkvm9KCqKkKCdC9Q=;
        b=sqzXbrUj3lBVFqWNLfbixhh3VZv3PEGp7zvfJvR0lstIHlG5ysWkch4F6I3AMs7IBI
         TUGXMJ8NHpAUapIxDbBcRaVDdd/5zRe3PaqAyYuXGPBDRVEkunHouoSeisbRPCENzPc/
         wHbpmhnMgdJs8p1bd++ennDRliNBvxmWqF2qDdFXIfL71IloqG6sPAlGEFHYKqo21hoE
         8C9YaNBD+D74Z5ouqF4nA8uh5ym05ObqHqSlmqPoNtJnSPY3e7zyBErsX1lwx4xsh0Pf
         CaSmnQ4pQDNBDvkWvuHm7z1ON0l0SAtOGyp2xIiYGKNpcREyxjN8AtsIynNJw9wRnQIh
         dCCg==
X-Forwarded-Encrypted: i=1; AJvYcCXhfL4JpAoJ1qdQFwGksICD42FXiN1dLfp44y7IOZV2wH7FJhbJGdkndJs7ZR3rFxaODIsHJHBKb94M@vger.kernel.org
X-Gm-Message-State: AOJu0YzbsQ8NMApPS+k6zNVc0zEn+01GVB2jHLpauUU4aBPZMbmxwjn+
	9T69Z2tk6KVfZogYuLAT+wRRHvZXa4pngKa8N5iq0abb9OsyuzjqMeZpmed/G1YeOECb3FHoWRd
	tFjh3keOo2g+fzJFnNJA7DUoYiiIB3fEhnjiA9fE3/ENeIDW23FQhhbFFVMItXpU=
X-Gm-Gg: ASbGncvVyvlhooP7Bj0upo6iR4Ks57wcXrZsySSanaCOiRM3KUNVla7tIS4d5RduNaz
	GkkbQJxFuzfYnH3oK8hgri2pW7ABs0/hpXOAhqlpdEjvrCXwHTZSKF5Yy5/5ab3RcQA3WD5tADp
	sJ+VpRg+YRToMywfc29WGYu8TIaPGupMapQ1g126spWnM380hnOatJrM3pwUtjewT8E3ahQC2k0
	gWW+zdfpNhUAdJaMfgaCVz2CAN7IklWpuXQ1khrYOckmpaDD2Mm5RswAUV6KmR460m1nvJWmAt8
	8GIrTSxTxwkbxkTCwfWf+5XuX3utYwvvkCcFva9GGlbCkUiVvQg7AHLP5JVBj1Yams/q14iGoSa
	G82Ik4ZCsmjNmB1hsA9+ccQ==
X-Received: by 2002:a05:600c:3b25:b0:459:da89:b06 with SMTP id 5b1f17b1804b1-45b517b008dmr3774395e9.16.1755806925534;
        Thu, 21 Aug 2025 13:08:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHDDv+I9AWZPVyKVFD2prHDmQqsK3mzEWwP5yNf0oRJXtHjmqgi3hMC3hwAmszm5rTAtK85Rg==
X-Received: by 2002:a05:600c:3b25:b0:459:da89:b06 with SMTP id 5b1f17b1804b1-45b517b008dmr3774035e9.16.1755806925116;
        Thu, 21 Aug 2025 13:08:45 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50e0a479sm8895255e9.21.2025.08.21.13.08.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:44 -0700 (PDT)
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
Subject: [PATCH RFC 35/35] mm: remove nth_page()
Date: Thu, 21 Aug 2025 22:07:01 +0200
Message-ID: <20250821200701.1329277-36-david@redhat.com>
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

Now that all users are gone, let's remove it.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm.h                   | 2 --
 tools/testing/scatterlist/linux/mm.h | 1 -
 2 files changed, 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f59ad1f9fc792..3ded0db8322f7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -210,9 +210,7 @@ extern unsigned long sysctl_admin_reserve_kbytes;
 
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
 bool page_range_contiguous(const struct page *page, unsigned long nr_pages);
-#define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
 #else
-#define nth_page(page,n) ((page) + (n))
 static inline bool page_range_contiguous(const struct page *page,
 		unsigned long nr_pages)
 {
diff --git a/tools/testing/scatterlist/linux/mm.h b/tools/testing/scatterlist/linux/mm.h
index 5bd9e6e806254..121ae78d6e885 100644
--- a/tools/testing/scatterlist/linux/mm.h
+++ b/tools/testing/scatterlist/linux/mm.h
@@ -51,7 +51,6 @@ static inline unsigned long page_to_phys(struct page *page)
 
 #define page_to_pfn(page) ((unsigned long)(page) / PAGE_SIZE)
 #define pfn_to_page(pfn) (void *)((pfn) * PAGE_SIZE)
-#define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
 
 #define __min(t1, t2, min1, min2, x, y) ({              \
 	t1 min1 = (x);                                  \
-- 
2.50.1

