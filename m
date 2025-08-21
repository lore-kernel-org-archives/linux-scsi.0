Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE643629A0
	for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 20:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806885; cv=none; b=QaY/9hySUnPW+qprIYYB8rTPVapkx6iTLZQjc6VbUDCnnMPmENDz02kkNUbGZRfjWZ9y8moUx60qP26/rzIWUG2t/bndi5JTp/WqVi36WumER5Gp0+iaEvfj5orskftugmQPd923PKnsq2inF4kY1Mv74aW4xQPMJgitPs1oOgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806885; c=relaxed/simple;
	bh=E88hXeAEs+yXdxHqIfTWo/GvQIeDr+kkFObDidynu1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZF8AxGR6w8ToFrqkdx2CHQSDRRJ7H+6vguZBJPk+xMn3fjGCrT7BbvZpSyUSsGHrx5qh//4fyUvfGjfay1w0/mSa/t7ljxVcSZUkbVfJPZ7g+KUwv8T3z3cW8pk/Js4MR05XSN+FZgim+iFP/GLoobuIxTE00w+M+1XskdraOxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=glYUhfC9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="glYUhfC9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w6VkvDa+3msZeC5nA9B9+aDln+Mg2ABReefULBX94/4=;
	b=glYUhfC95petK0g5XrmQqYibeCae0kE3MpZihKeJV8jNJrpscbhkHUJwNAsM28tKpbZZ/r
	FyLWJNJ0Ycg9t1aPfnZAxQZXYhnlMiG6xb3Y+qQtL9O0qv+NQ6inT7R4n3z6FF1nNZPcX5
	PWLnz9NTz+1zXwHnT4B+1V48Ow0Poxk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-304-kO0lPQwoN8-ifMzrV9OLww-1; Thu, 21 Aug 2025 16:08:01 -0400
X-MC-Unique: kO0lPQwoN8-ifMzrV9OLww-1
X-Mimecast-MFC-AGG-ID: kO0lPQwoN8-ifMzrV9OLww_1755806880
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a15f10f31so14273555e9.0
        for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 13:08:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806880; x=1756411680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w6VkvDa+3msZeC5nA9B9+aDln+Mg2ABReefULBX94/4=;
        b=xLfjuKII9kofJgWkHA/UAL1PfQw5Bm6ExqI3aAiGpHK/+nsEPwNJtmZilmre1WtVNN
         qo0vOkWQORy/Qgtji+EWksyagLDCyquo7IvKbRFCaaD5qh/kektPtLXb7UQwfZy/sMLn
         Pkqa+YGVuN2dzuDjMnpav04RbwjTZH2oxYJsPfeKeOvopxtxUreu65ybgESOeIjG5gQO
         EdAfq0jHvi4LtoC6rHal+XTdS1V9YJm33caDgxn/GbeZTvbZeanoyUbSjCnwe68U49qA
         4kYlAnCao7VnzsieHZ3hyH7lLW7aAtJ9xZYphFojSk/WarcUi88EkmNC67ams/tUOTn7
         gV7w==
X-Forwarded-Encrypted: i=1; AJvYcCXBLtDbDPWyNT/+5kwr9apruCSkQME4y7yy2M0BsboroENR7NJ1gVjwfppiQjPz1viEAka4BVKhYIru@vger.kernel.org
X-Gm-Message-State: AOJu0YwKwiMTSFukyAT2T5qjrcDv2WvXOsPwixBnKnJQ2dzigEwvFSBV
	XKX2UO+1TxCMrLQ6MUpRL6b33Bm8Ie9981ABXijvVeZb37ixfTnZSiuOBEOYAFoUU08MYSVuion
	zdsp4daw3LjdR5vo+1BtcfeVQxCZqVYew0nWXiyVlofMwxwsgJ349KFmsawy3QvI=
X-Gm-Gg: ASbGncuwDXfeZ/9/avXLsxsgzHgfS5VmnVav549U5CuB84pksU/8w65zKuhw+8G3eka
	S8PKL4PR4cFZJ5VPuHUeOPyHyslJbC+SjTXnPq0rl/+hpTE+KAKgwG79ChfvATe4O71/Kp0aa9t
	awN3teDWh+QRJWOeIalXFWWgCZPFRyw5hgPPPbS5skZTxZPGS7PXBxEFwyw0HdoBmr39DTgi2NF
	hbNIyCHVDT+kWCBd/F/nGceyuCJI2Uj2srJfowweAFb9KcKWvi/8yOl4UqFDSgrqMm/KZQ6vnJB
	mZLqTcErhdAY9ZP9HrnEYmjQPFC0u9uIbmNwvJ5O55hI/VJlemeBK6Q4R6JueqhOZQy7nfzd9T+
	lhZqbiB/RYk6w5sJsdf03Uw==
X-Received: by 2002:a05:600c:1c87:b0:456:942:b162 with SMTP id 5b1f17b1804b1-45b51792539mr3328665e9.11.1755806880045;
        Thu, 21 Aug 2025 13:08:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG9ciI0WdoI3CxhUtu7m/cESVsdReJmvmXFWCMaWsO+hhXySreox2GeOL2sJ8kVyLPwCYhbEA==
X-Received: by 2002:a05:600c:1c87:b0:456:942:b162 with SMTP id 5b1f17b1804b1-45b51792539mr3328365e9.11.1755806879543;
        Thu, 21 Aug 2025 13:07:59 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c07778939bsm12219075f8f.46.2025.08.21.13.07.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:59 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
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
Subject: [PATCH RFC 19/35] io_uring/zcrx: remove nth_page() usage within folio
Date: Thu, 21 Aug 2025 22:06:45 +0200
Message-ID: <20250821200701.1329277-20-david@redhat.com>
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

Within a folio/compound page, nth_page() is no longer required.
Given that we call folio_test_partial_kmap()+kmap_local_page(), the code
would already be problematic if the src_pages would span multiple folios.

So let's just assume that all src pages belong to a single
folio/compound page and can be iterated ordinarily.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 io_uring/zcrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index f29b2a4867516..107b2a1b31c1c 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -966,7 +966,7 @@ static ssize_t io_copy_page(struct page *dst_page, struct page *src_page,
 		size_t n = len;
 
 		if (folio_test_partial_kmap(page_folio(src_page))) {
-			src_page = nth_page(src_page, src_offset / PAGE_SIZE);
+			src_page += src_offset / PAGE_SIZE;
 			src_offset = offset_in_page(src_offset);
 			n = min(PAGE_SIZE - src_offset, PAGE_SIZE - dst_offset);
 			n = min(n, len);
-- 
2.50.1

