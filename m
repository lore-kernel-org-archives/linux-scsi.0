Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F983570B5
	for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 20:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806844; cv=none; b=JpYS77o25zejd0J6pm71fefjntBzzwXGFGm4JRanILBn3iVV6USUk4EeoS0MmqLMnwUQGifNVRctGQltw05XLob/1jpqaRu8oHj16NkmsZLC7agXj9wpwfSfJHy4xPbd400sZCnrm0C3TzD7Mf6uO76ErHsYkmHuW3XWCqRxgg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806844; c=relaxed/simple;
	bh=Cw7Tggvlta2Xmlg9ZVygUv1C92bk8NKTD0n9SH6aeIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=phAyJx0rBTXOWdr81MFtf/i+BtBiOOBwjHsagmLLh9C8d14Ayj3JBSRnK4CD5mySDMPNGPn0XsK7ODnAnG8EWa86qrNHJWzH5c17Ae4m9VC+6kLVPvEN/9xRthl1jAyee8VADAvoL0XKYC4skdMNy5oq9rmOUTS+VSFb/S9/IVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WYIYoMlW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WYIYoMlW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iU84NUWejaBSUFBs/T0/O04YrYLlq1RcxZMywEFGjU0=;
	b=WYIYoMlWacp2r7qNmwcpi1+0At+LSwhjqbQA/jXa0bs/nyO9JlTkYZwDqUnePI9k2s7ANo
	dh7FppcVyrJTlwPunLc/qw9melOsZxQg1sqaVcroQMVlKCbypmteAHrvgPMjDaL6C2WRFq
	Q1hxU6iMy3LaqBQ4CtK2xvmsqe31hvo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-543-PP54IQJgMiqJrLnp-w2lMA-1; Thu, 21 Aug 2025 16:07:20 -0400
X-MC-Unique: PP54IQJgMiqJrLnp-w2lMA-1
X-Mimecast-MFC-AGG-ID: PP54IQJgMiqJrLnp-w2lMA_1755806839
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b05b15eso10515375e9.1
        for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 13:07:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806839; x=1756411639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iU84NUWejaBSUFBs/T0/O04YrYLlq1RcxZMywEFGjU0=;
        b=JFBgARZINzI6mkeUriftqe7i6DKg2qcmVHkMKVydW+7G/L/6z0XlMlhtDiNNSH3i1C
         Nca5Io+KkFwz5uekh6rvaG1q/ASNjoG5uJFFV2s4PfAsxhqdoC5xd8hDCxEx1WQQxNED
         +VujZqSG5DmMKsVDfYOEffTWMMIRQnPlTwIiN3wc0eq6hxCl2FenPcUcgFPEhg8DNKdm
         LhKHha1k+KjFYkf06wRUMdSyWbu5HhXY/JtWxewVHsMioefM6gixE6KjPl9pHduqJNOk
         5MUtUuldj7A+beJcDHZVCtn2Qz2cmCJChYagVtB+kcY5qTZkSieHenomyN6+K94xLEKD
         6vyw==
X-Forwarded-Encrypted: i=1; AJvYcCVA1yeh39h1aRvnKmBb9xhktj1R2dYA0E8/onFOMd77IP5J3ry93Amsbo8PYfR7h9e8e57IV3tuH+Vb@vger.kernel.org
X-Gm-Message-State: AOJu0YwoOFC6Em4qRTBE83Fv48MXt0qO8oynYF1B1rRUfw/sw1TE9Feu
	EQg523VoFNyhgcfvHiWaHv4xaWGjwR6uh9ckgOi9FGdTuKRHI2uwEpHq8gSxzzqkymvQ6+hHFL5
	TcrSdCtUMHPv6uT2ES7gnwjf0ZjNmK9tHWkAAI3e7ognzThpMtoviH0gwlV9XepI=
X-Gm-Gg: ASbGncvAqJj6hor4DpD65NklULjxGNJPcQWEDUZVcY9KplClFaNiDAsT6WGfi2xq+Fw
	YRFRwaBl3D8tLkjGN+KfPEZ2TFeNLxHHKvP142GbquU/w8MOPLQiVdbIXZcJFlfIe0AwywK24tO
	fiHU+TzGAeEmV3bjAAvXIm+CbJTSxSQpxuKCaPeDaLbf2PZCEPJfbBuFSHaNot2xz8o8UfIQ7cL
	d8fht2sk8Bjdz7Wzw5AUFscGl5FloOwJoyKM3ljhhtmo+KwDUgE3qoGckzErf11rPJHRscTWGRL
	+qy5BEb06Uj/JcT8kUYniIDM2dICYDpKwcAHzrEJd6Fn5GnJ7iq7lMa31X+EyIcVEBzA58ZGWNI
	liK7CBxXRUMFrdhzi++f8xQ==
X-Received: by 2002:a05:600c:1f95:b0:459:db80:c2ce with SMTP id 5b1f17b1804b1-45b51799428mr2845805e9.7.1755806838982;
        Thu, 21 Aug 2025 13:07:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHMhnqxttMNkrL8PAxIX9Mfq64uKkvY2MjzJ39LtAH2Yg7PxwVl8kOZ6CXLaaMF5rYTxrWwyA==
X-Received: by 2002:a05:600c:1f95:b0:459:db80:c2ce with SMTP id 5b1f17b1804b1-45b51799428mr2845125e9.7.1755806838506;
        Thu, 21 Aug 2025 13:07:18 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50dea2b9sm8988005e9.15.2025.08.21.13.07.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:18 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
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
Subject: [PATCH RFC 04/35] x86/Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
Date: Thu, 21 Aug 2025 22:06:30 +0200
Message-ID: <20250821200701.1329277-5-david@redhat.com>
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

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/x86/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 58d890fe2100e..e431d1c06fecd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1552,7 +1552,6 @@ config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	select SPARSEMEM_STATIC if X86_32
 	select SPARSEMEM_VMEMMAP_ENABLE if X86_64
-	select SPARSEMEM_VMEMMAP if X86_64
 
 config ARCH_SPARSEMEM_DEFAULT
 	def_bool X86_64 || (NUMA && X86_32)
-- 
2.50.1

