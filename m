Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A264435AAA0
	for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 20:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806874; cv=none; b=DlN2o1U7diU4Mca4FOjCXey93GfirEY/0OeEtPzbhN6cQyd8fhzBBZ5IQ2sV4rzvuPYIod6B2J6ooAIPNI7A1IZeQGlRmTZsbIrDQ8cML46Tt8fAAjeK3rzGXEzQvERr8f0g1LRkEqre/LCUBu502WX259jxfUkb4+KLU4sQTFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806874; c=relaxed/simple;
	bh=d4tmPeOlqOBXo+X4Tiv9h/CbkpHAugux1EiNuLc/Y0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dMIUncqYczpAeanAaXTLZ1AwvgfGNuemjfY6F3ax5LkIjXa287xtyvjePtmUJKn9dBEEvWnd07IQB3PUaGG+BL2KhUX8AiQH00/VbUXAFQDhU5tf1rwPKDauwHtnwl2ozyy6loAdmShYqm0K/KrHucdB670jGkSMY5CbA4Xx/Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DUUHBeCr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DUUHBeCr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806871;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MzMWVCGQW0mP4+/ULAfe7CdOmgWkAKLnoxAB4Fy092E=;
	b=DUUHBeCrc65u8QTUrAfc2g4U/QqbSVKLJviUrSY5RAQty5mgT10DcpWgepQxhVPC9E5EvN
	itktZgvhEisvS9wOZ3COVI5kLyro0pvYm8iAbITx1qsA0pdhki276MucrAKrBVOVTZ9u8n
	QFBNq/iDujYy8oPb9X4N6lLfn4kB3oo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-TQXLYuYEMsW72_lMboWDHg-1; Thu, 21 Aug 2025 16:07:50 -0400
X-MC-Unique: TQXLYuYEMsW72_lMboWDHg-1
X-Mimecast-MFC-AGG-ID: TQXLYuYEMsW72_lMboWDHg_1755806869
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b9dc56225aso832666f8f.1
        for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 13:07:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806869; x=1756411669;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MzMWVCGQW0mP4+/ULAfe7CdOmgWkAKLnoxAB4Fy092E=;
        b=Q0orFY9Qx+VlZV/YAoJY2TPKiCr/fV8ph9z/TFuzo+Cyw2I9Yulzg9RrbFwcn2jax/
         23MQftegeaTTfMqS7IoEYSmPOcnUC28wQxToVl1jZryT05t+OA7c+EY/KGkuNkYsf7Rx
         W2s/Xs3+Kk1Tjbh1jQ0vFJ2yY08Nvu0xJXkpt03cO1zBp0DQgzpmAQBtxeiGl0QMV9rK
         pPqW/wGlz+FE3Bf0nqacHZXIyeQUQw6T42gcyAxuSGikRj5CWKYolIQVEkYZKYjCXXbF
         suRn93w4CeWhNezOllIeC3MrX0UR07DCqGdW9TJ5AIsKMQbh38Rq5X2SuNw9DMte0Lwh
         tqrA==
X-Forwarded-Encrypted: i=1; AJvYcCXsp9plOQYmvvfZ3SUoW7l2XqTo5euzqPAWGnfpg034BXkpeLhuxDdVP69c2OxediM61Q7Yoyj+np/0@vger.kernel.org
X-Gm-Message-State: AOJu0YzTzK4Bh6qczi9IvZwODm/SWJlSFNA1IrWcIv9ve2+EFQ/xFkxe
	RzXviHVPa8mHkzjY/onHXZLgFAfTkEH61xr4VKLhW7Ymhz+mkczyCwr13vr4WDkF4dLPBMO6MFP
	XU6P24jRjA+sDM4bPfsWkRQG36BtsriCF7uZB1LmWgwrj2ZJEV3PtL9VBsDr8o8I=
X-Gm-Gg: ASbGncucrnFGZpVu66wBj1SRLSSi0jcByFKy+U0pW+IUgzOxaz7lbcFnfhZ20MJNeug
	cQwoPTWuWgijf3xXSbF9GJoeLgW/PfWRsO1bAukSc4JfOwnRom7JPeUmfEZu7j39l2PW1q0ZE4U
	5LVT5zR1OEZVNrbIrfqk21A5PswHWs6WwprnfBf62ZIVYl6rt8ZKxX0swQHJTx8TI/LkO4Ninjl
	gGBuwSX/INEMKxigI7SCBZdaghTR8kfDbt2qMW/qzLiIYH3X/5VSW2nepC/7y+zDrprHc401Kox
	ipRKvAaliVo8UeLAN7ivDEv1v4WSEjTCY6PWys2gDPmStm/CNmwis6mwtKPuXMr/a1iqNtCixTI
	MOfchZJP/uyejKCod/KRzfg==
X-Received: by 2002:a05:6000:2901:b0:3b7:c703:ce4 with SMTP id ffacd0b85a97d-3c5dcff5f3amr167820f8f.59.1755806868913;
        Thu, 21 Aug 2025 13:07:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHCm64ALptQrKyrLlaLt4xJ2vziBy3gZm4Q1WMVX6wnWhr2W2tRcHnZJHBwxpAOnTfL4mKx+A==
X-Received: by 2002:a05:6000:2901:b0:3b7:c703:ce4 with SMTP id ffacd0b85a97d-3c5dcff5f3amr167760f8f.59.1755806868453;
        Thu, 21 Aug 2025 13:07:48 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c5826751d5sm1323274f8f.14.2025.08.21.13.07.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:47 -0700 (PDT)
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
Subject: [PATCH RFC 15/35] fs: hugetlbfs: remove nth_page() usage within folio in adjust_range_hwpoison()
Date: Thu, 21 Aug 2025 22:06:41 +0200
Message-ID: <20250821200701.1329277-16-david@redhat.com>
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

The nth_page() is not really required anymore, so let's remove it.
While at it, cleanup and simplify the code a bit.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 fs/hugetlbfs/inode.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 34d496a2b7de6..dc981509a7717 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -198,31 +198,22 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 static size_t adjust_range_hwpoison(struct folio *folio, size_t offset,
 		size_t bytes)
 {
-	struct page *page;
-	size_t n = 0;
-	size_t res = 0;
+	struct page *page = folio_page(folio, offset / PAGE_SIZE);
+	size_t n, safe_bytes;
 
-	/* First page to start the loop. */
-	page = folio_page(folio, offset / PAGE_SIZE);
 	offset %= PAGE_SIZE;
-	while (1) {
+	for (safe_bytes = 0; safe_bytes < bytes; safe_bytes += n) {
+
 		if (is_raw_hwpoison_page_in_hugepage(page))
 			break;
 
 		/* Safe to read n bytes without touching HWPOISON subpage. */
-		n = min(bytes, (size_t)PAGE_SIZE - offset);
-		res += n;
-		bytes -= n;
-		if (!bytes || !n)
-			break;
-		offset += n;
-		if (offset == PAGE_SIZE) {
-			page = nth_page(page, 1);
-			offset = 0;
-		}
+		n = min(bytes - safe_bytes, (size_t)PAGE_SIZE - offset);
+		offset = 0;
+		page++;
 	}
 
-	return res;
+	return safe_bytes;
 }
 
 /*
-- 
2.50.1

