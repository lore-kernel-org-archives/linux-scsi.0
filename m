Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3E63570C7
	for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 20:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806844; cv=none; b=jv/EWPQsq0UHwS0HMdLuSTiFsDy/dPqGijvxTPA9CsC20YT+0KRZ6nsRqlKGvYjkQ7UWlthiW8rvO2Lmeody8xs7h5IKuGkiHRNSs+0DGfqjD7bER70Nafl7EeAIE0eh4lh6LJ7V+rcm6QkhhibCgr496yzC3gn1aFr62BLieFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806844; c=relaxed/simple;
	bh=rCgYuDQcQ3nJcWNFmOxD+pxeBEJSNoep86nFob2zhE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uuvXc4s5Tqyt8NvQZX6czUmRvHwP5THzBOhoHCH9g2bBKN6TFT467gRYbMObI6K6D7FI732+0Xe6ouDMGlLty/9UwKTwjNQkzhTO5VWSfvVcqySgPDreUXM/qR9ks21Mf2Dnr0uflUcSIcAwrrBktbKwwVrsakJMB9iFV8HB/A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UG5kHdye; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UG5kHdye"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zfh98TqNQqR9uCNr2hB5bEgIJ/15ql7Yv0zNbj5EC/8=;
	b=UG5kHdyekVxl2COxryE7rTVFpFlW4AHnzKhV4PeSvna/5GVgRAWj993DdfAY48Inp8hUf9
	0nYmVxKL8Xnr1L42ChHzY7p9VJPl8AIo4+3HDDBRHa3BuU6cD7bYvMSWisNdY4AzWm1zKt
	6mkJ6XP6cxjb7a6uf0e70OjYh49ZROw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-aTzuUz5BNbOdLSBOJoG9bw-1; Thu, 21 Aug 2025 16:07:17 -0400
X-MC-Unique: aTzuUz5BNbOdLSBOJoG9bw-1
X-Mimecast-MFC-AGG-ID: aTzuUz5BNbOdLSBOJoG9bw_1755806836
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b9e4157303so922322f8f.2
        for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 13:07:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806836; x=1756411636;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zfh98TqNQqR9uCNr2hB5bEgIJ/15ql7Yv0zNbj5EC/8=;
        b=J8n4Eu9YJCmRLImnyWCF9Kg+rUtf/uCAkI6HOwMttS+RUiVFa9EyDkvLpeSC02DCYk
         jezy9nh21Y+5TCkrty2EhBVgJtOjjGMtESUTL4cqweC5PjChruCi8uFyfSeQ7Qkbf6oT
         CXVE0HD6QkISFvDvx3mLMfw5n2a4FXHPHEHHqTuKfpBrFWJ+CJxBlMS+Z325yiLOTdlm
         rc265sCRjeHi2vr/CE7PR8C7MZjqh+GosYH0kxq1dCkHyoWXGC2mrPvjELb1wx7Ajhak
         d0MCQD22NjJdJmSTlQkJ1WjjND9WAu80BwJPxkaJrSFHCIKpy2Z2g0JYngLpa2fdlm0f
         Rk3w==
X-Forwarded-Encrypted: i=1; AJvYcCWxnUwjhySB6X7yAM9novyJ7VyLrKrCaTK4GMt8DBWbqaHuGFAa7hdsCFJE0L9Q4vrb2JtTLM5EDx1a@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6KaFOtR5ObBSLFz0KtFjhT0/wUWlkLHaklReyKDVeKUnWUNfw
	uZXg+Fr6rhk+KWRZB1V+vaVM78RiwQvdp9wvP1WEcOU/HuWGD7eGedVstDXkKOSfZXhoWPNIAo7
	vuiogvwXxzYYksBLt7kgyHTiGyz1YYbmluqU087/FRlEqaPxiVNt9ZLdoq275ScM=
X-Gm-Gg: ASbGncsKBOctXcgwEJroGUOYuqE2fWs15sNlZl6vft5006De6wb5EYEy245c8ME7Dgk
	FnQEAgKn53WpgOe/tswsSiveFouXvQGTAyzBD45qwsNiMkz+Os+ZLNKFGW/SN300rKKjSlH2DGt
	I/03syyksCsyWjeKHspYRGEybtEN5fKOw9zIeW/dWJ8hgB+9GmfYVe5ZEc0IhOvsK2gbuwHaDFO
	qJD8QB7YtdYfvB63or75WLzqR6fEPDnEJCwdLX2l7PSmWE4Naf63f0CUsMKjhSnJbc9wqfhA++T
	zTHItdgoYVV3SwLJlUhyB88L7kXXIWRxOA5HsNaNFlvPPWc+t14WI32a5choHcDYxp8HxpeInCc
	giAySGNUydvoxKpJEquvDKQ==
X-Received: by 2002:a05:6000:1445:b0:3a5:27ba:47c7 with SMTP id ffacd0b85a97d-3c5dcc0da36mr162992f8f.48.1755806836145;
        Thu, 21 Aug 2025 13:07:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFpC+bUbLbCjHqucY3RiMYJPd72Xl9UYU3JmJwOiC1ZPXsKWXLLEiwWSHifO8HwGgrBWSbiEw==
X-Received: by 2002:a05:6000:1445:b0:3a5:27ba:47c7 with SMTP id ffacd0b85a97d-3c5dcc0da36mr162946f8f.48.1755806835650;
        Thu, 21 Aug 2025 13:07:15 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50dc00a8sm10958175e9.1.2025.08.21.13.07.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:15 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
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
Subject: [PATCH RFC 03/35] s390/Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
Date: Thu, 21 Aug 2025 22:06:29 +0200
Message-ID: <20250821200701.1329277-4-david@redhat.com>
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

Now handled by the core automatically once SPARSEMEM_VMEMMAP_ENABLE
is selected.

Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index bf680c26a33cf..145ca23c2fff6 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -710,7 +710,6 @@ menu "Memory setup"
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	select SPARSEMEM_VMEMMAP_ENABLE
-	select SPARSEMEM_VMEMMAP
 
 config ARCH_SPARSEMEM_DEFAULT
 	def_bool y
-- 
2.50.1

