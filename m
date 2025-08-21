Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5643F313556
	for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 20:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806864; cv=none; b=B8TNR9Af9yVGVzVRfJhgznl+V/yE6xVqOTmPb40FAsHsPCXJ4/sFjK1jFU9oS4pE9RAbTvwDjq9dDtUnHO7SU2o82hhtN31rzb7vbHuwl13TaHuO5wpkAozw2Tt98ATPS490f9v80MkVJ2r2J08wQES8cDvSQTa7nQrmRgapSnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806864; c=relaxed/simple;
	bh=XmsSbVhT3dGsaRmtyroJ024d7WMqPWbEWQJfIPHhOJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctA9+jp9yH+gcSu1Cnmkf4bnRXjWJUoSUyXjzf0Iwss+tkDBRAI5Fm4dqcbGcDDG+Hm0oEiTIbIJuOrYvZiOCLyPPYx+hdDEWULEQ1+fgNDumpRChefGt5SJ2nD4E/hNOb1fF9s8zn9bCj9Xyjn9K6zJ47TX/mAF4cyZhII7DI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YBm9EXR/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YBm9EXR/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806860;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QQ4Uu4zoWyKmYQrq0i4l3HgKr6VpAHaNUVdQgPTsBAE=;
	b=YBm9EXR/HmeipwW4WmVjWe76Aap9pkGcP63uHwl13JHG9suLg1dqim3KR7+bY3tx3LEkhm
	dZ6wjHWQ/HFKpCpHwmYFVRsGVUvJZMyxr4YyQxRNmFP3dfuEk/jhnd1rN725RUcDE55n7u
	eem5OiDiPB92SRaHf2cXz/8+Kq42t40=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-475-kDfsXHuXPjWs5tVRuNbRzg-1; Thu, 21 Aug 2025 16:07:39 -0400
X-MC-Unique: kDfsXHuXPjWs5tVRuNbRzg-1
X-Mimecast-MFC-AGG-ID: kDfsXHuXPjWs5tVRuNbRzg_1755806858
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b51411839so821545e9.0
        for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 13:07:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806858; x=1756411658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QQ4Uu4zoWyKmYQrq0i4l3HgKr6VpAHaNUVdQgPTsBAE=;
        b=k17jrO+iB2cg0l8OVcLJUoa7JqHWcqVyCwe0gh6jGoQWpDYAeK00eIyPfmckWpESRi
         nGFoGU+cDjyGhbyqgkUplBoL1D3JXZjgqtg6ehtncn7B7nQVzU1QByExaTiVqdQmUNNk
         aF3B0xUX5iiGuqlyNbV56EEA3RwV7Oel87zS9+mOSntSfCQpl5MyQwajAKv0IgB3DWqZ
         TbKzNSnPduRieceQo3MkOksKnJu/HKiizHSMsfsLnGYzktdbPbMZu4iD0JqtwrhWJ2JC
         bsutlp0QunPmQIJlimjQrz5IdATrvxtIlDGj2puM7khCiGzlm4NLHqlhqBcwetHU3u01
         CKXw==
X-Forwarded-Encrypted: i=1; AJvYcCVpHPfiWYZW/pK96BMgXct+nFV+lmlAaEFAutVAhRBF+huc26x/2URH4KsvwqkSyIDzRth1Iobi/3qf@vger.kernel.org
X-Gm-Message-State: AOJu0YzIUA1kFDWV+TS/SoYacenMZe0XwFxizYYKO7pcOrEmuUpJdlxg
	oeE+wOS3KDARHW8UfG8KEvOBryUVC7GLVjd3lXH1zimb8iDPna0K44DY2jVfShA7coGwvgZeT3E
	6ednYXF/Zfg2o8KsCPmmUrcmqe2zTnmTWragcmuPWiEyyK3l5EXXMtp6fGOLm6R0=
X-Gm-Gg: ASbGncvgmyewhNPdapdIZ8x5lpdxsBGVDRk0xfWBdfKpLpJhSfnc2LGdO7xKi9CWFPB
	tevnhwt46bMkkLD/yDB8DOlnFBrLdJbDNXDTgfa/dyTwi5gsl5nS1w61dzqZVlT267LLEg2sNY/
	3v3mSI/wARo0FSoLL+LpcxpSal0d+elB+OcHgU/lyNx4sg+YhG8Kr9OuwthsKjyT+NOJRiY5Wzf
	zBGcThSsvD7UBHiOva4t2+BvIMixUS2MLLNc3Rk+5Cy6oHmDrpjztIqmRbrE3nDc6Ymxewho72x
	Ikgqn6MiKCuynXsrYw/GPQYDxa1WwR7f92V9exQMhPUCX4RmZYr99Q7QAvKnLQ4grCQ02JJdFD0
	UeDtrFhoUjbkSqLfsjqwplg==
X-Received: by 2002:a05:600c:5251:b0:455:f380:32e2 with SMTP id 5b1f17b1804b1-45b517ca54cmr2646865e9.18.1755806857912;
        Thu, 21 Aug 2025 13:07:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHlSU80KqPPviGOLp6CI40u/NjPujjG4FLCG6NoakJIlvY80lRDOTTm20w50mEKFuk0YjVSLQ==
X-Received: by 2002:a05:600c:5251:b0:455:f380:32e2 with SMTP id 5b1f17b1804b1-45b517ca54cmr2646245e9.18.1755806857378;
        Thu, 21 Aug 2025 13:07:37 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b4e87858asm18672185e9.3.2025.08.21.13.07.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:36 -0700 (PDT)
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
Subject: [PATCH RFC 11/35] mm: sanity-check maximum folio size in folio_set_order()
Date: Thu, 21 Aug 2025 22:06:37 +0200
Message-ID: <20250821200701.1329277-12-david@redhat.com>
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

Let's sanity-check in folio_set_order() whether we would be trying to
create a folio with an order that would make it exceed MAX_FOLIO_ORDER.

This will enable the check whenever a folio/compound page is initialized
through prepare_compound_head() / prepare_compound_page().

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/internal.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/internal.h b/mm/internal.h
index 45b725c3dc030..946ce97036d67 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -755,6 +755,7 @@ static inline void folio_set_order(struct folio *folio, unsigned int order)
 {
 	if (WARN_ON_ONCE(!order || !folio_test_large(folio)))
 		return;
+	VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
 
 	folio->_flags_1 = (folio->_flags_1 & ~0xffUL) | order;
 #ifdef NR_PAGES_IN_LARGE_FOLIO
-- 
2.50.1

