Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E50537DF18
	for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 20:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806920; cv=none; b=jiuYVRFQcQm7qLHMQL/oXpMGKeQg2MzxlwLCaJkbP/45T4ELkuFgNU0J/w36wFHpHxdN/6I/k8LOi4z9wJlObk/CsXv0K+mEHXjvv3v+jMiAIKog6NcenwL8GRo5qAK1hYHojAO8J11kiuQWi9xV8lQAnvyLFfOUsDx5JYjYRoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806920; c=relaxed/simple;
	bh=u2IvbkeQqipan9xn1FH8uDngo5kbDeDcvQE423cldao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TN7WIcFg/MggdC9YT5XKw7TdrLchwlEeOueubGdGo+MsiWUVj9HT2XCxWcP5Woxc4udvDbPVfBpW+igzz/4C0iteZ0PKLqfOHTMkH4Ta01oGT2xwCgJqgeK7JVXkrYsmjs/kUWWCV4IB1A1ZF93FKQ3hTtF5WBZoRSoVgZX2uvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YrRZMfWZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YrRZMfWZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806917;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uIthYg0x+2djveHghlw2Jb9wmVGYKVQz7R4ULrPQfiU=;
	b=YrRZMfWZelkBpueKYz4JQ2V97fbY4tKY9hhb78/svIuZKOrZQUPNrdtEgyfhxJ/lhwgxie
	WgnQ4TS13S64WQg9svHUvdruNomyRi48m30jW8+zcXqPGH5fR+Dm2fIyQqiFLPLhkC7eQM
	xBXPb1GYJPkayzboOOyB4uvSZFx8nIs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-437-j_-nIoVxPcS8FV8OOcU8AA-1; Thu, 21 Aug 2025 16:08:33 -0400
X-MC-Unique: j_-nIoVxPcS8FV8OOcU8AA-1
X-Mimecast-MFC-AGG-ID: j_-nIoVxPcS8FV8OOcU8AA_1755806912
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b0cc989so8656895e9.3
        for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 13:08:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806912; x=1756411712;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uIthYg0x+2djveHghlw2Jb9wmVGYKVQz7R4ULrPQfiU=;
        b=m5ZAjkyw9D2qV2uqd7NWKM6eJXUvNGlkf/bUiCc0dsL9s+K64Nbk2kvLFsNznapmK6
         EXiluKxnfknaj80B5sckvI0YZXDQ7iEut0BZ3R2lYBpxfPo/dfBcYokjvObxvASiefQf
         Bncp6eOyrYU7g61WXG6JZN32msGrdFpFHoryv+w0y8pN+zuCasEOjXN/7pNYC6C4jetS
         dQUIduzraNHU66aU2TCLga2N/2I39JZPGqxql5/IBG44IPWklqxK0EA9OTyYRJrLCdkW
         bAC4/22L6THkhC5YDqjAZWEh42UbG8uGJIPzZ5ihGVv6RBNOgKgmrdl9sriqyK0PvT6i
         3bKg==
X-Forwarded-Encrypted: i=1; AJvYcCWcwJaXKafFM6RkbVwniG/7WIz7o2SlyejJbdiMSvr+JcBWC0Wx3qjJTH2WsD4VE/TCouliTTAzLpP8@vger.kernel.org
X-Gm-Message-State: AOJu0YwaHMyZw7YNmwEKfQYf272ZBq3rQkMw/oFWx360NZ956navjUzH
	FT+GDbqEdMiGzUAjWBsGVKuEU+z3PERhaWoW+XIt1IaDmKrzUwict+TKvOcI9A2VccTbNZX3l4Q
	xkW3Vt4Csh6wW4fxQbv5HXa0LKoC4Xv6X7edawClLtfi1qELDfvrmTNe8GGTDeBM=
X-Gm-Gg: ASbGncuQFzn0iPLoD3uMEsWvk9ISyfRTt7msc4pOVNBn28P4NuRMd4sfebQP61rzX20
	6H5oPF5qJkI8XHeWin0OrjlriZz7iaNP4jK6cW0h72iS95WCktCBVHll5f7V3Dtn0FykbC71pXI
	Gp6PdMz0PHbHXzeAJGV0+nj1CK0Fg8830STU62M/hOtS9aL+PZ3v3XflR1ReCciD5LLAQMVE4Rz
	dRudf6f46SRI9Ic9hbItKKnwKD9tj7dyXSwucGXwwA3loyiCraXadvNRWnqZZS/naw+/x0gTEla
	LRv6M+TQLf5IdGKXCpgZbI3Ld8qcRHsX1Gm8rnSr9HVh/EWEEheMxjo9wC9Bn9YDqwVhqL8bR8b
	1CrCYWieFc1fPXh69r/N7+g==
X-Received: by 2002:a05:6000:40de:b0:3a5:783f:528a with SMTP id ffacd0b85a97d-3c5dcefee22mr195308f8f.59.1755806912421;
        Thu, 21 Aug 2025 13:08:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFRe/VOMg0cdir08bDTWMwU06A85Ixelypa7wMbtHpunFYS8URS38ofNnAO5nDnYJmoWLlWSQ==
X-Received: by 2002:a05:6000:40de:b0:3a5:783f:528a with SMTP id ffacd0b85a97d-3c5dcefee22mr195231f8f.59.1755806911819;
        Thu, 21 Aug 2025 13:08:31 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50f16eb1sm7598185e9.3.2025.08.21.13.08.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:31 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
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
Subject: [PATCH RFC 30/35] vfio/pci: drop nth_page() usage within SG entry
Date: Thu, 21 Aug 2025 22:06:56 +0200
Message-ID: <20250821200701.1329277-31-david@redhat.com>
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

Cc: Brett Creeley <brett.creeley@amd.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Yishai Hadas <yishaih@nvidia.com>
Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/vfio/pci/pds/lm.c         | 3 +--
 drivers/vfio/pci/virtio/migrate.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/pds/lm.c b/drivers/vfio/pci/pds/lm.c
index f2673d395236a..4d70c833fa32e 100644
--- a/drivers/vfio/pci/pds/lm.c
+++ b/drivers/vfio/pci/pds/lm.c
@@ -151,8 +151,7 @@ static struct page *pds_vfio_get_file_page(struct pds_vfio_lm_file *lm_file,
 			lm_file->last_offset_sg = sg;
 			lm_file->sg_last_entry += i;
 			lm_file->last_offset = cur_offset;
-			return nth_page(sg_page(sg),
-					(offset - cur_offset) / PAGE_SIZE);
+			return sg_page(sg) + (offset - cur_offset) / PAGE_SIZE;
 		}
 		cur_offset += sg->length;
 	}
diff --git a/drivers/vfio/pci/virtio/migrate.c b/drivers/vfio/pci/virtio/migrate.c
index ba92bb4e9af94..7dd0ac866461d 100644
--- a/drivers/vfio/pci/virtio/migrate.c
+++ b/drivers/vfio/pci/virtio/migrate.c
@@ -53,8 +53,7 @@ virtiovf_get_migration_page(struct virtiovf_data_buffer *buf,
 			buf->last_offset_sg = sg;
 			buf->sg_last_entry += i;
 			buf->last_offset = cur_offset;
-			return nth_page(sg_page(sg),
-					(offset - cur_offset) / PAGE_SIZE);
+			return sg_page(sg) + (offset - cur_offset) / PAGE_SIZE;
 		}
 		cur_offset += sg->length;
 	}
-- 
2.50.1

