Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B8F2C0283
	for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 20:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806850; cv=none; b=NjyaDdnwedvm5SGTbmn7oSMnoYVYl/72t07UCu74hMZNkiPezoqQJw67yhbPomq4LL/iN/ypJH6gfM3ejxkdtP4eDtc9Khr+isCQ8CZ4jNlhvNt8ireNUgVLZKPNBx/AAiJOd47NtwBW5u4kxa31+X5TJx2nHLzEQ2GD1dqAcJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806850; c=relaxed/simple;
	bh=vLP4m8ubY62ddowshnJEYGhNc+fB41I1n0umGIUlXAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dMuFh9NGFlVRH3Ou+fhNoeoHjVQd/eKwmVPTQdPJf9czh67cbuPpXmeie//BheXxLooDqy6Or/E7hU6QJ/Ge1MqCyNiex1EP7mgExyl7e//Tx6fjQijom1yT6FsA9ymWwNgUm4qhbfMz+w4n+Yn/eXSsBWDK/ssGc/+M0FG0n3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HOwlI5hz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HOwlI5hz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aOl+Pd7m6DQCTUATshUDhXjEbKNtUx8aQQ0CVjE/d9w=;
	b=HOwlI5hzbwdwUMDKrNZmw6XdskkvQ3mM+uOl6sSbIyU8iwCeyL/PVFZ3MmyxClNaRI0vu9
	Vpbsu4Dw8mpiVRR0gd8MGnVbQrG4NIkWqtNcez8VbCk82rZ5l7yN8WG5u9nzUmuHLbVKvh
	IVtfLNuGCSyUyD1BSRPUASOBjXEtwWI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-YRZA-2AgOSy8Igj7RJzyLQ-1; Thu, 21 Aug 2025 16:07:22 -0400
X-MC-Unique: YRZA-2AgOSy8Igj7RJzyLQ-1
X-Mimecast-MFC-AGG-ID: YRZA-2AgOSy8Igj7RJzyLQ_1755806842
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a1b0b6466so9581165e9.2
        for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 13:07:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806841; x=1756411641;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aOl+Pd7m6DQCTUATshUDhXjEbKNtUx8aQQ0CVjE/d9w=;
        b=wvJ08bqbftyoMNaMLHGl4mFJKCIVtXJzSXQmCVPiFAyDf2MrGxyUfyNM1KqJq3+hxx
         GfeJcAmrgF1M8t9x8JlaJwxNWL4YlYMxuiyOlK5oofqUHSJZc6ZEwlRNjMUUrpN2uRsn
         BmSLB9A+4qegSd0bacioeW+pIKLHzyx6X2ph7vjLo3SoHzHVQ8FVX5e4Kt9/MsZc+SdG
         LLfTXAxhLxtjAfLLVAGliY5vVdcyXe9b61weMK1Lr6GQB3K2NukxoNWOiNNpEZzn35gG
         CFjm0xax0hZBJDQNHByq1mcLxBznYpu/IsY3q80CEnCKJ6DG1cBe6X+Cxpx+PbqcRJpg
         xjPg==
X-Forwarded-Encrypted: i=1; AJvYcCVSbfFXFIZDFDCS4odVqz22NWVOGDm5QGrI/nN8mU07plnfutX9MU/SYIyfMBDa9WYVLIBElMQz/tZR@vger.kernel.org
X-Gm-Message-State: AOJu0YwEpvK4IPfLQBJA5/4jfISmxAGe26yWTGVMV5ve/jYkMyaWc9S7
	WlrkhPV2wLyJPe9RI1a5IvbT7jLt5U1LzyiMe8gDQsYmv2vyUDzTohABWLjxtITZlG0szjDjdMF
	fjr4PP5aLJeibsuvn3IjyUpoKJaT/wL4pQmC/FCuUWqcl7Z29/AOsDJjXSXeL+CM=
X-Gm-Gg: ASbGncs03f9etn3vYxnFBtyzmTqjTYXrcgYnMI7XUqtyf3iBeVcuZnkGuV12RKzyE1k
	C6EteRzRI0PoISeLLXYtCsTZJ/32bzgAZI7J6HaAE1xwzIZYPda3/QhnvJaCNVWtf699xvPlFnl
	UUcKA2G9+BvLWwE3dxUuQraHuxd1Xt0jq6gdTlAZX5VMxkK6itkjR7Su/F6UeaxM8vvf8ZD0p6j
	QEdGnac+dYCl6IirDornpVOiB2RLMvZ/FGfB1fiuCsdaneJgwStBlmekMuQQlKxOejHg33OSldk
	YWgN/zBJ1H8ai2guirwZTKlqzo2/Q2ajy8Pu+jaODNbBtXcMw5VSMHDW9L8n9PEpAkpbs6TLoJo
	V1lNlqattR/APOqRXcfccIA==
X-Received: by 2002:a05:600c:1993:b0:456:e39:ec1a with SMTP id 5b1f17b1804b1-45b517ad4a9mr2412405e9.14.1755806841660;
        Thu, 21 Aug 2025 13:07:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHtBnzBdejX2oNj8vG9iZBZKJew+pPrkGWxHzVnhFEnb5RkXIsj+cBFTtJrIXnzr/4lYhSU+w==
X-Received: by 2002:a05:600c:1993:b0:456:e39:ec1a with SMTP id 5b1f17b1804b1-45b517ad4a9mr2412295e9.14.1755806841198;
        Thu, 21 Aug 2025 13:07:21 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50dc00a8sm10960275e9.1.2025.08.21.13.07.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:20 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Shuah Khan <shuah@kernel.org>,
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
Subject: [PATCH RFC 05/35] wireguard: selftests: remove CONFIG_SPARSEMEM_VMEMMAP=y from qemu kernel config
Date: Thu, 21 Aug 2025 22:06:31 +0200
Message-ID: <20250821200701.1329277-6-david@redhat.com>
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

It's no longer user-selectable (and the default was already "y"), so
let's just drop it.

Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 tools/testing/selftests/wireguard/qemu/kernel.config | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/wireguard/qemu/kernel.config b/tools/testing/selftests/wireguard/qemu/kernel.config
index 0a5381717e9f4..1149289f4b30f 100644
--- a/tools/testing/selftests/wireguard/qemu/kernel.config
+++ b/tools/testing/selftests/wireguard/qemu/kernel.config
@@ -48,7 +48,6 @@ CONFIG_JUMP_LABEL=y
 CONFIG_FUTEX=y
 CONFIG_SHMEM=y
 CONFIG_SLUB=y
-CONFIG_SPARSEMEM_VMEMMAP=y
 CONFIG_SMP=y
 CONFIG_SCHED_SMT=y
 CONFIG_SCHED_MC=y
-- 
2.50.1

