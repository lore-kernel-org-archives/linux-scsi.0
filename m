Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD13E371EB6
	for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 20:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806904; cv=none; b=EKabH77w7P3EZlcV5p+SsSUFRd6XpbP42rVlA7RzdheBA52tnHdBntQ15ZeAACPAeBOZ8vtiWvNUjflfShnZzETymYmJi6eExIr4XWgAV1zY6ULAvFnANnVjCFQN3jcKGYE7Z9l6HReooYceAXw04EI+7y/vdkx5ydXPRRe0b/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806904; c=relaxed/simple;
	bh=r9aVOOwiYkYkJ2XxN3c4oDiixJCUuv2T31t2h3Fc0ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JzhXB8G0iYGLfCdOVS5P21oNWqxOHmkCGh6skKJK/Ug2Ms46wRVJwaISp5yzRoAa4gN9r4VcvEMX34KxI04IZceO547AuyDsR6NOUg3c1WxTdE6A/26Jw+rw/L8Vl24bxmrMD4rWlhhaqCVDeg+YbXPZFr6iKfWvM7xqdQN5SDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TobQHE72; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TobQHE72"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5INZuVEW8ZoCVRVHt0CSLhpT4h786L9PUsnD4NVlnkc=;
	b=TobQHE723m2bw21PBPzEoo4me1lXI+LQ1c6ohnUWy6S9zSQVR28QJbgXq/qM5sTvkK07sb
	xd4zymHXVzNkG4UVO164ucoGh7UATB09rMKuVjM4k/cKprzszruOTfiy1HVCeeE2NOuGEk
	T2zFlNxQxtfc5ZdgI45eSY/Z0F8wznQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-v3-NJoPkNXe3UadvZJQqhw-1; Thu, 21 Aug 2025 16:08:18 -0400
X-MC-Unique: v3-NJoPkNXe3UadvZJQqhw-1
X-Mimecast-MFC-AGG-ID: v3-NJoPkNXe3UadvZJQqhw_1755806897
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b0511b3so8303245e9.1
        for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 13:08:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806897; x=1756411697;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5INZuVEW8ZoCVRVHt0CSLhpT4h786L9PUsnD4NVlnkc=;
        b=ffwvjD4MhZ+Ve1TGvT9vtLg1HlAyKukOLkTfx/cQivvcwP88EIJg0VlasrwX1HyaAL
         RBPFjdTbiPgGV4SCuLGC8FdD5SMGFZ5OjUrKA2aftGm3gypc4XZarGZyvyJ2pf2xTyED
         OBHQq/YQOfZHp58PwcZm1QOCuVc7yx1f+MBhp6Rsp+lsoS/A4OJEloGsALtgPnBAJ0Qx
         D3cBScvNSg9LhKGbteur2jcQs1exRF9Xs5qYcPCW1uOLN/KuboFxWBRMna9BkyMhrTMt
         4jfxFj7zNnIBixgdh5VXpbzZ+8MF0K3+wtP83I3MkcI+mn+SkybUJ0wnKy9yPG+0F0hH
         3K+w==
X-Forwarded-Encrypted: i=1; AJvYcCV3eSmKeIP+T7bVlwFp7m8NyaYj90DGv4ZTZ9WKspgunrPqJQlSSWpCFKXQwyPP4Y4KIJ+bQxcEWbv4@vger.kernel.org
X-Gm-Message-State: AOJu0YysH2qD2xh1XP7KiDLIOgdUH0/Ndc4tTuSt1VofkzwjeMC548LC
	9hPkymGWjRN7xyT4kj8DlMQHP4YobqQ0VMnvhGvMeipMEvPq3NIZKScTia9Arv4P+g7e3oFawXV
	ZwVefo/5gJKG4r3dzBCUUjBLUED2Lx1yBEaCfsqnf4jUX/oQaIQCy8rZUt0mxGfc=
X-Gm-Gg: ASbGncvW7O2NrXvE85RbPL5J6wOq8plrXb3oumsqbDJKNS3yALa1OVd5Hx10KUmt/lI
	+ah2n+kvwv0gMzgc3lzlsDPAV1EOGLn9odQWNglV2H6no20S/yskfErPZLf5/p+VKk/FXa6GHX/
	TTMLRAUARFgzZNEN8+cM3Mo2/4P40CJaI9e5yd9vPX4HmojkRZjgCrm5yVD4GilCcFsep+tAqYa
	1E2+dJaMbbbINKcXygCbL5SKEseCubBziXJSfaGNcQHIY5dssOluo3t7SiGh1g9fOPASXJYgx45
	s/2lI2r+qsrGp+zOZwSZjGsRcqLIK0RLD988F8TH8I78IUuq+lzxt/GB2qRyRBQqJKj70mV9YUu
	GMoWuG15kIeMhh1/S8zBvLQ==
X-Received: by 2002:a05:600c:470c:b0:456:285b:db29 with SMTP id 5b1f17b1804b1-45b517d416bmr2505925e9.29.1755806897448;
        Thu, 21 Aug 2025 13:08:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFPdYXvWWhsiYzUao4v8GSpApokx2tOJxTxGWaryOs6bj53AmOc+7o5w7P2pIRGnKU6jzi+ow==
X-Received: by 2002:a05:600c:470c:b0:456:285b:db29 with SMTP id 5b1f17b1804b1-45b517d416bmr2505625e9.29.1755806896948;
        Thu, 21 Aug 2025 13:08:16 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50e3a551sm8831035e9.19.2025.08.21.13.08.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:16 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
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
Subject: [PATCH RFC 25/35] drm/i915/gem: drop nth_page() usage within SG entry
Date: Thu, 21 Aug 2025 22:06:51 +0200
Message-ID: <20250821200701.1329277-26-david@redhat.com>
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

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/gpu/drm/i915/gem/i915_gem_pages.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_pages.c b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
index c16a57160b262..031d7acc16142 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
@@ -779,7 +779,7 @@ __i915_gem_object_get_page(struct drm_i915_gem_object *obj, pgoff_t n)
 	GEM_BUG_ON(!i915_gem_object_has_struct_page(obj));
 
 	sg = i915_gem_object_get_sg(obj, n, &offset);
-	return nth_page(sg_page(sg), offset);
+	return sg_page(sg) + offset;
 }
 
 /* Like i915_gem_object_get_page(), but mark the returned page dirty */
-- 
2.50.1

