Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DBD37FBF5
	for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 20:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806929; cv=none; b=XTCovUkTuSaVQeTm5tRtqtKAmZnmwDKkHcDaN+TG2tiSIhLXdFAqkTXuqD4U6ezz32s1E9TrMaugiynAPOuSH8ZhSOwl8zTwi6iWRgiB23yRFEBnRvIs9doWZCuNf5Nhls6fTA6BaiGwL6HnasXcg8NSgAYAiaE0x7stFWu1G9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806929; c=relaxed/simple;
	bh=izYuZWtM9expuJ4aw1W3JEFW5k9djBINp3Pti4HydYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SNAGz+dyRl/Dth80sbTSD58wezNH2x5H1kCcOTwq/HZ5Y+Ow9MUDybTINaAuDbieXD1Y9KTdsLoGgG5WJdPBoxy+IFRldg10UO7gV5hWknloJIGI9Tt9CQbK1S9Qwpaouz+IiAym/IPioEbFC/IiveggEqKke5jIuMiAiLsHXdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gfRnDWql; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gfRnDWql"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z7iPpUiW3LrFM0W3XrB+Z82uodwKTsefoCzXwhLbLUo=;
	b=gfRnDWqleQo/tZ4QAtrPQMKR/aUg3yes98cmHPGjoTSRneXIVL//IQrG0SWTbax/+5Iz/9
	ozw1hgbIbhMaJIcm3hzSqiWVfzGZ7WLufLzSMczJFDkBKFPEMw5zlWpb1ZFHB2I2YPlnlr
	vg9CY6UzsMjU9WGLhao23urW1yfcuAI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-539-DznbtxE8OjiOWVkH1YdkMw-1; Thu, 21 Aug 2025 16:08:44 -0400
X-MC-Unique: DznbtxE8OjiOWVkH1YdkMw-1
X-Mimecast-MFC-AGG-ID: DznbtxE8OjiOWVkH1YdkMw_1755806923
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b9e41037e6so864611f8f.1
        for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 13:08:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806923; x=1756411723;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z7iPpUiW3LrFM0W3XrB+Z82uodwKTsefoCzXwhLbLUo=;
        b=L9u0YtwCwcahQvXImh2dHb7S+tvp/yAQYiS1NWva9ebmRwVUIuKITu0/po3kvxePhr
         xXaI/E5AYVjSdlSpvmCHTjx5F7c3ij/HHvY+UUu60dq7/qXyJ2qquy15fyVoNCc6qOdd
         394YL8Gqi/c9hK0IsOo884Sw0PFmxd+/H3aZJvs/xF87WtnRe7Rrk+MA7PX8itbRQ4Sh
         x15M/mYxWA6up9rgmb3BPPVg2SYy4YI3Z9pQiFHs+gEoYFZypkN96s02Y82BsAvjK+l9
         Q/bQCrOF/W+mka2GL8P0EPhfgnGyag9jHtLNkOY4Wx8qEo7abWBrn/kGr9Vu16Glf7av
         jIsg==
X-Forwarded-Encrypted: i=1; AJvYcCV7UdGKwIXC8wW6+IbLXxv5aoUv0F1WYQDbXxD9RuQlYvTKGBwDEB0FAIM5rm9DfCoyAvGXlr/ZepfY@vger.kernel.org
X-Gm-Message-State: AOJu0YyeQpbZMxj8BHNgx2MBdDFbQSTco8ubdstgI4qPWes2FUlVMKYZ
	fE7vES9ccGBglkgFCOMAO68j+AP+htD1ov6fJuz1lwleH+yDZAnpdp0OHbahYKwcr2z7XClPE1d
	yYaupfk11Ywbhw6pPAop6LV5PXbNezhhHdR9lzmPvZ/iWAbA9RpiXjrIZKPWgSm0=
X-Gm-Gg: ASbGncsX7mPXMgchGVA0DBgjn3AXGS6f/ZBY0xOkPYWjTbATifllBYJWKp4p8SRyJMZ
	1FJzgQR+KzAUgNFvJL5nAsBw5SE6UQyYM0T4cSgCZmzpATTsWUbqerEcIAwyoJWbJYye3vrxWrA
	SHx30uzJs4qZrdBZihLYO+eFZ5DuSdNjKdZofgeiWSo+CpN/oISzvYGTp1Z+ZNq/uBNJVSpgfGT
	obx/IHpSWH19VTATeCgGT26t5Z6ih3X/0UphnrN3I2DEmkV5Vwks7IykvEZZgV8WJczmCUN32l5
	nJThlZfYCKsP+iwArtgnJP5HY58f2dpbMXc/0WlAnvwKInN3R6PTrQXQBS3lO+yiem3yMZsfsp7
	SwCSvQnG+q+IP4JhZvrd/3w==
X-Received: by 2002:a5d:64ed:0:b0:3b5:dafc:1525 with SMTP id ffacd0b85a97d-3c5dc7313famr204698f8f.33.1755806922966;
        Thu, 21 Aug 2025 13:08:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHnHzRKC08dohUKQD/XdldMc6IWYVddiLtTh8Yidep5vx+5++gzVG23SiimMwYZ+HldR36Zkg==
X-Received: by 2002:a5d:64ed:0:b0:3b5:dafc:1525 with SMTP id ffacd0b85a97d-3c5dc7313famr204645f8f.33.1755806922505;
        Thu, 21 Aug 2025 13:08:42 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50e3a587sm10028205e9.18.2025.08.21.13.08.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:42 -0700 (PDT)
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
Subject: [PATCH RFC 34/35] block: update comment of "struct bio_vec" regarding nth_page()
Date: Thu, 21 Aug 2025 22:07:00 +0200
Message-ID: <20250821200701.1329277-35-david@redhat.com>
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

Ever since commit 858c708d9efb ("block: move the bi_size update out of
__bio_try_merge_page"), page_is_mergeable() no longer exists, and the
logic in bvec_try_merge_page() is now a simple page pointer
comparison.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/bvec.h | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index 0a80e1f9aa201..3fc0efa0825b1 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -22,11 +22,8 @@ struct page;
  * @bv_len:    Number of bytes in the address range.
  * @bv_offset: Start of the address range relative to the start of @bv_page.
  *
- * The following holds for a bvec if n * PAGE_SIZE < bv_offset + bv_len:
- *
- *   nth_page(@bv_page, n) == @bv_page + n
- *
- * This holds because page_is_mergeable() checks the above property.
+ * All pages within a bio_vec starting from @bv_page are contiguous and
+ * can simply be iterated (see bvec_advance()).
  */
 struct bio_vec {
 	struct page	*bv_page;
-- 
2.50.1

