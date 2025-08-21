Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDF437289B
	for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 20:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806907; cv=none; b=HUGeoL5H4wKk/MYrTjvwhUymqSu8Bel4ajmQo+TPZcZXl+gwxM7cA1LluiVxHqiKEYNnXR4E/7D+epb3rx5KHaYdBUoH08PAseypKS8WC+++U/Ujw8munLngYdIIBX2hwNxOxrM4WkrNCNBBwOI7QgxnAh4L+0cKBj9fTI08/0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806907; c=relaxed/simple;
	bh=sP22NtXAK7RUwr0f+hWxIzaLt9EECIyrZ2EEKfR5Am4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sUeiHRBWWbXMo8WsPFisjoEfaP7ys5dJgyCPas/1SD1FbQye0z/LVjs5KZkwVQ4f4CqlrZLDn9cuFc1YPTXPM4LtVZMEArptpPsuR8sy892cnOB7h6f2+FJbj1Kr8cdYyG/4W0srRTQS63JRYvrXsWso8xklIE6xNcldTHtyERE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QwRLkPIR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QwRLkPIR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806904;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5m4ogAvLOK+AKMqlHwhkjmyVbS/4gGgmBykcdwEFmjg=;
	b=QwRLkPIRQJar9QXzAMrCIHPucU14oN4FlrZoD0fhCyPb1aTLhJj7/3LpoqPNPFLvBOI6Zx
	74pATYiShwnQ9rTAwnMMQ3dVTUdbk/CkmO8v5Z2pnsFSIWjBE76cqtlZ2pUMgwqk3zZfJL
	ZroEdUEWDye6/obpB5nSueoL7M5v3BA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-269-kaoO0HD5OGWWdFsZZ2Ttsw-1; Thu, 21 Aug 2025 16:08:21 -0400
X-MC-Unique: kaoO0HD5OGWWdFsZZ2Ttsw-1
X-Mimecast-MFC-AGG-ID: kaoO0HD5OGWWdFsZZ2Ttsw_1755806900
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b4d6f3ab0so8382815e9.0
        for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 13:08:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806900; x=1756411700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5m4ogAvLOK+AKMqlHwhkjmyVbS/4gGgmBykcdwEFmjg=;
        b=ZkdngnZc0K5gbbyQ2j10npOWBk+UP+2CcsW6e9nn0mcQUSjYoyrwPqlqzloPqHdkO/
         J0BmPF57Dv6b3g/zmzCcY1x5k1Yopag/v0TGrQh7J+gPxPs9j4vchPyKjQzAsS0vY//e
         GXiCakkVz2zirgBGzZ8Ibmzppx4KverfuT7jMHzy7+dME7ukWpUFgdchFiKyOuPhfARn
         y4tBS2Tics/bYJKv1MpmO+VOXmUDYV47hmHF/DNIDbsPD+i4RSQ1RVtBHffzDTJQm7yN
         s3dATqKL9RmgQ8jvkJgTzg7lwkrxqj0jDb3Y6Ja3T2YB4MomrH9HhsSR2hpyjD/v2YbP
         RNYw==
X-Forwarded-Encrypted: i=1; AJvYcCU+2x/+7Jq7xx0gHDGvdYVVIXvHNJRdxdRRyA1Eq/0aTw86zRoA+8XqvPkX26LrugbySJfTdn6XS7cW@vger.kernel.org
X-Gm-Message-State: AOJu0YwVm9EdZjdCr5r/OK3vs/HT7h1ZsEeweunG9CbCFwKMXXrwK/B1
	iM0dMGVh9C/HEKkCW2zvAWCVUBAAarzdk4Wgxdduo/rI5+ZYxOXsGRiCq28vYobTPs1vvDpGZ7+
	7wZ6qD7EXgF3Gz6GsoNF/aB2f/vUK/PEeBAF4K+XGSr6WHiHx1GHoa05VbSh01Nw=
X-Gm-Gg: ASbGnct9jIH4MFf5i6p3D4Jyh6F+jTRucK6MOakmFZmGjjyVOX9yCmBPUzbLNoBojAD
	NJ9/ME8uDbykrWetqK3oSaNyMatWNvuS/iIbS7+yifMK5INlJTBrQQ6E5WvZY7nUR4yGoU4CMtR
	tr1KtF4XJkC7FlpNRlLbp9H3mqOcsP5uCVWzxB1fpAiQ507bV4i+McS40PUeajD0xtfp4YXX3Lf
	821Jf0vXbQtAQMICmGJmFlDOO5Gh6Uxak1djrqa6/q53emaIz0rdMaFkh8B8wxvQRlp4hgIsKSl
	AMeRbJoGOMUvZBe4dMQEdCHjDYgiZbMUDCy2oXZP5vGvpHNRZxhkcjlWSLd72sHVcceK9IFHdBx
	UaNG1rLuXDC/l8cS4eXuaIA==
X-Received: by 2002:a05:600d:15a:10b0:458:bc3f:6a77 with SMTP id 5b1f17b1804b1-45b51f2fe8dmr510015e9.2.1755806900253;
        Thu, 21 Aug 2025 13:08:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGpV2b3uhR/IYbmrTMgtg0gx1wkF4+JdBDenNBBSMhYf9nynPUCNMa8PTADPxo4/liFiw6TqA==
X-Received: by 2002:a05:600d:15a:10b0:458:bc3f:6a77 with SMTP id 5b1f17b1804b1-45b51f2fe8dmr509915e9.2.1755806899756;
        Thu, 21 Aug 2025 13:08:19 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c07487986fsm13999227f8f.1.2025.08.21.13.08.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:19 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Alex Dubov <oakad@yahoo.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
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
Subject: [PATCH RFC 26/35] mspro_block: drop nth_page() usage within SG entry
Date: Thu, 21 Aug 2025 22:06:52 +0200
Message-ID: <20250821200701.1329277-27-david@redhat.com>
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

Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/memstick/core/mspro_block.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index c9853d887d282..985cfca3f6944 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -560,8 +560,7 @@ static int h_mspro_block_transfer_data(struct memstick_dev *card,
 		t_offset += msb->current_page * msb->page_size;
 
 		sg_set_page(&t_sg,
-			    nth_page(sg_page(&(msb->req_sg[msb->current_seg])),
-				     t_offset >> PAGE_SHIFT),
+			    sg_page(&(msb->req_sg[msb->current_seg])) + t_offset / PAGE_SIZE,
 			    msb->page_size, offset_in_page(t_offset));
 
 		memstick_init_req_sg(*mrq, msb->data_dir == READ
-- 
2.50.1

