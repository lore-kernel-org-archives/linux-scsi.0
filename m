Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB1A2FC038
	for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 20:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806858; cv=none; b=oeGUNHeQ/bMB2q9u8LhtI5l2szVhuGwyfJP6dQfRxzRcBppzi+SxJ+WZe44xY+EFhKCLf/1WkfCz1N52VmFbe2Flk1KUStbaAQL+txj2ThMhWSSzTtUr/dw4q4n1L3aEz+CFAqlN4HBeD9deyacKKsMiPPjioT+GLeYk+ezY4dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806858; c=relaxed/simple;
	bh=+tsaq0kMmRCBgLfPZThux65EZrTtOKARiF8G7W5lNZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pLTQy37HbLLk53MVESrXlJlE9Dgw2lH3YJrapD6HUdoXzK8cmcOgpFAi5EIukoY3TZwLYxOAB3TeQGwDrpcRAmGKtpsYOkOrXkol8htR3X8iY8C1oAeFoA3IxKY56HBLQfZsV1Pw8ER/YejyTWvUi+BakjyMSuFMsnUlU6XvODY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cTnGCs3U; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cTnGCs3U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806855;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r/kmddABpvZJu5K+QD662cz6jOGE1r8xokeQdlRgepQ=;
	b=cTnGCs3UqgoM2qDpp2bN0hwiGC7IW2T4kVwaj2WxfD46f+BGp/uVjeodqi8sddHs6S5T0D
	cQ4FdgpiQfdbJBz1Jtn8inWWcpurU68jRYcbSUXfdsXyamSI83MugkrRX/0r54YVM2LQpj
	bLnbFCuqHJOG2+Tuzqm6dNZhzI8MRb0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-27-xZBdKuB_MSiRGUvcmAKaNw-1; Thu, 21 Aug 2025 16:07:33 -0400
X-MC-Unique: xZBdKuB_MSiRGUvcmAKaNw-1
X-Mimecast-MFC-AGG-ID: xZBdKuB_MSiRGUvcmAKaNw_1755806853
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b9dc566cb4so996119f8f.1
        for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 13:07:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806853; x=1756411653;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r/kmddABpvZJu5K+QD662cz6jOGE1r8xokeQdlRgepQ=;
        b=JxhF44NLRfGaXTzqTuEeBEsiDiZBBGCurSJFMUIQMwTEMRibQdQst8LdgJOEYrpyOj
         +QqpSmSHsVfwcoqs1PnWEms91dNwWGRRtD7xot+/oqk3r5x2BWeS4K+CDyrp+OLeaaA0
         S8vruQMnii9F5oKRr3RXKbmxaqFcYEuN4BPZp3bVpYKh1gxIOFKb+ShCr9277PHZK+Lk
         hbdDSfAr3XxQ5YqAmniIAAE7fIAxTbb59UzF1A5jJOnMHyBGfjueWMVW8AZ8qh6pH2SF
         OpPPGT0Emh3JP2cv2+Mp/Y0HegOl1ooa/ONBzbZhSoUY6wmXdUOLNtJFbJHF/ue3Bd4Q
         kFnA==
X-Forwarded-Encrypted: i=1; AJvYcCVnlVLeSMzPZR5cIb77hIfxMHK3nczhSlABo+z0ttQo8TDj6dPN+RJJSTnmedyw4A7bU/Itg2PZdd6E@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7e9UVdktixpLI1vG66omx2GJraZsmB5LU/fEmpPnabN4d1zw/
	mSecBBBkS+eYmyLOKE5mX8+fovIYE+Kzn04NQGvo0MI9+WW7lDy7sBAg50uXZgBkrnds6tLXHA1
	CBW7yMprdhbprnNwlwdG+HWh7fciT7/lTRnEsapFCbQrnoukk9mxoSgaXdzjNVDg=
X-Gm-Gg: ASbGncs1fK7VsqBYyTe72jNZV0qmg1Z0h1glInv3/L2GF/Qs38+HQA8Fyr6WVz/wWZc
	eBfft6UXq0rgjCMSrPcGQKCIQmABhBn4vM9LnVkNPdfx/w1pLEZLtlwL0lXfML5QKCTb7LR7bYt
	LC4g10xgZvq1t4CRdnrdd4fS+gyXOcjjY3X5AZyovcV5lMDoGumPgYJ8YvL5rWnHRaAeYhpjf6C
	4gTg5cTP/3a0YujSgvYnPKHZkoH1Te3ia+O00b5ehjsYn98AVYkvTVBNMIsovhVPbkE8fbAL45O
	6aSCrVX6Afyv1Je4kYmX6w5FfyJ0njcTcmEy+lXPyzG7tZ0HZ2oJWJrMZRZ44mL3VlvVNy4RFte
	sOF8JrLNc6pLaN5Rff6s+8w==
X-Received: by 2002:a05:6000:2dc7:b0:3b9:15eb:6464 with SMTP id ffacd0b85a97d-3c5daefa9e0mr244698f8f.15.1755806852608;
        Thu, 21 Aug 2025 13:07:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHbqF8V2lF/CygktHxSJZNB7+pmyneW6nxhnLwTxWefpTwvecQ9FG1LkYH8lxi0WUYYPrMQFQ==
X-Received: by 2002:a05:6000:2dc7:b0:3b9:15eb:6464 with SMTP id ffacd0b85a97d-3c5daefa9e0mr244660f8f.15.1755806852102;
        Thu, 21 Aug 2025 13:07:32 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c077789c92sm12629958f8f.52.2025.08.21.13.07.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:31 -0700 (PDT)
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
Subject: [PATCH RFC 09/35] mm/mm_init: make memmap_init_compound() look more like prep_compound_page()
Date: Thu, 21 Aug 2025 22:06:35 +0200
Message-ID: <20250821200701.1329277-10-david@redhat.com>
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

Grepping for "prep_compound_page" leaves on clueless how devdax gets its
compound pages initialized.

Let's add a comment that might help finding this open-coded
prep_compound_page() initialization more easily.

Further, let's be less smart about the ordering of initialization and just
perform the prep_compound_head() call after all tail pages were
initialized: just like prep_compound_page() does.

No need for a lengthy comment then: again, just like prep_compound_page().

Note that prep_compound_head() already does initialize stuff in page[2]
through prep_compound_head() that successive tail page initialization
will overwrite: _deferred_list, and on 32bit _entire_mapcount and
_pincount. Very likely 32bit does not apply, and likely nobody ever ends
up testing whether the _deferred_list is empty.

So it shouldn't be a fix at this point, but certainly something to clean
up.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/mm_init.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 5c21b3af216b2..708466c5b2cc9 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1091,6 +1091,10 @@ static void __ref memmap_init_compound(struct page *head,
 	unsigned long pfn, end_pfn = head_pfn + nr_pages;
 	unsigned int order = pgmap->vmemmap_shift;
 
+	/*
+	 * This is an open-coded prep_compound_page() whereby we avoid
+	 * walking pages twice by initializing them in the same go.
+	 */
 	__SetPageHead(head);
 	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
 		struct page *page = pfn_to_page(pfn);
@@ -1098,15 +1102,8 @@ static void __ref memmap_init_compound(struct page *head,
 		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
 		prep_compound_tail(head, pfn - head_pfn);
 		set_page_count(page, 0);
-
-		/*
-		 * The first tail page stores important compound page info.
-		 * Call prep_compound_head() after the first tail page has
-		 * been initialized, to not have the data overwritten.
-		 */
-		if (pfn == head_pfn + 1)
-			prep_compound_head(head, order);
 	}
+	prep_compound_head(head, order);
 }
 
 void __ref memmap_init_zone_device(struct zone *zone,
-- 
2.50.1

