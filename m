Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792532922;
	b=1Oey7wBqRs9WHB3mc7prC5dVuVBb8O7SzW3eMjei54n0LDF4inRS+X1KfK9L1Gj4wzRk
	 /YStPK0PwwrYS1LVvSwh8+clFGZgnKDsqNyq04vKvALlOV100BbReEEHbWWKI+SjuzVZV
	 JsHX9qyjBsqcZKDI49P9f4UDF07F71xqOqkIERiOGFapQLJgu/Cgqmd8CWa4Ua3cwHAUY
	 XjUGVLDqQgfA5kF32tRhKiQivIBDnZCDz5JXjDlh/di2b98NeUYHCwDd/zm8mUwxJo+XT
	 b2D29pC6T/lDPAntHkpWvntcROi3EAjEGQsD5JwUay/yAUs42cQm69Gru9MqxWhlikA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792532922;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer;
	bh=lwH5lbGW7Jp7v2pgahH/8u5d5Q1US/ZAJYtMLpAtA4s=;
	b=t6yd+SUOp6c2E3B5fQI0P1kyHzxIMw/03j3rVuVz+9QYn0OTTd5M0blJKQX42xaWJaHN
	 kN6fSY2zHrXeCgctjo78Au5CKD9IRneSYcwv0zwO2ttO8nwYQa+VNwXp55rAPgSqkAMhG
	 Sy+VVuBgjHZ4OphbaVJuuixdCgzAbWAJ8MHoPziZxSB3zGCmJT7BBMHHNJM4DSudV+RLE
	 5C216fVOcGCHvt90MNjXK3dEez27Xyfw0VWzm6WDzw8Om+kG9BC+hmDdCWQWcVqHyy6uQ
	 fSzSLn5jyKiBQtIncQRgaepqDzlvm9s1xdd7nGf/GlDJBELTfsjVe9rWeLb7IgqSenA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Vnm419Qa;
	arc=none smtp.remote-ip=209.85.219.48
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E2D606A324
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 21:48:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7E2D606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Vnm419Qa
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-9178d514951so1192076d6.0
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 14:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792532920; x=1793137720; darn=vger.kernel.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=lwH5lbGW7Jp7v2pgahH/8u5d5Q1US/ZAJYtMLpAtA4s=;
        b=Vnm419Qa/kjE27NqFknpFQG1AEpyq49ddgDDuGG4m4PuK8jB4BIucxesyWwSf4SEa0
         uSz2H8eWQ3QAQVj6mvZloHz1ezWLtzmCORiSuo4nvX/Y89/2PHrTr2TW0P6Tm5o1c13y
         kFggrh0Im+PIpGTSB7fqkFQNt8NQtpgWN8Og3tQl5MkWnwnj8MF/yt/hQt64q5Q4ESGC
         hfbLwpJB1hqraCnMet5mFnXiToBilJJr7Z42YzL3pjg2EM6cMOlxUZWGIUnaMwpSxLeW
         e0X1EurcmLyvexnjMFYKgO/omwKsQow1isD1OoopS7BI9x0SWOD2yG9zXJviPhqLpw95
         dF7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792532920; x=1793137720;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lwH5lbGW7Jp7v2pgahH/8u5d5Q1US/ZAJYtMLpAtA4s=;
        b=gKhnQlqjxStrj+qdaU+pPhk/Dp7cOReJpL4KukybmE1ouuC1OrdjXsNgUq1lMUyRE0
         maEV7OaxNhh57OLyWK2n4k1KF+gWjkz5XjPkZkTjgxamS3E0/wCoA0zL9PBjjVL2uYjF
         1L8xI27ls+/inmABc0xZJjPlRG8rOt3BnYCL/me7JJaSetMsCxxEmH0YZza7ywlA+BPX
         Spu+hkzgmmSFj21ISoJyh/LB2zX3SEvPU1FrSC0wtX+70qZqTzinPl8M1mJ63XgWywxo
         vCxD8Z5SiMZh0VGDfklFpcn6t5+e0zzJeW/tqU/zinDbIjsMLJ1d2QKSPpKPOJiyqhWK
         RPmQ==
X-Forwarded-Encrypted: i=1; AKwUvBx939jJ1nwFnuila97FYzQhQcc3ABI+40wqN/K13FIP5OamFdYXgGpv+mRvg8sBglmVbFFrCUovBFDn@vger.kernel.org
X-Gm-Message-State: AFq9FYKEnWz+vbgsNm89JnGdKoDfDzS9Ca0toEW0ocys0hLxejmRlS6P
	Nse+WHlACuhmReFNOQlymJwjyttIEicJ5OcP+G5eE+1xyDEPvTYpYrej7iOW5dbyWuk=
X-Gm-Gg: AYBFou3IXI7Is+f0R9GA3LJZKCKQrsv4n5FbMj2yP3g/rFM1NkPqVmJVbYYW5GCDrbP
	e85hepMiWi5h+lLjb+98XJu5T/L4rv1x48XAfX8kchBgxLqDNhPn5eLGswnnCedyKn+npdoRAvj
	uuxYZicRklelYKVCho4UwELFg1e12Nru65DSn6+Tk0KF2k1IskQOI+9whYM7XQoEDl7di18TEyq
	RVkFRi2tkLs+CXD93SIQN8cVYxOPt1ddXNNnJKW2mdNDu9iYYhK71dOvE8+bu6OkLUH3aNyO7rg
	GRStl5Fx9uxzkX0hXOOFlYjm4sUuht8LjcbbAoQlWZ98HBnOq/nHm5yFSQStKGba8MYNgkvFYf8
	Lh1E+xcbjHYOuRf/m0Q/qVltMUFst5HXlmLhZZfizuNhNsWN1UtN5Ge9AUVqsRWEC8tqHYDel0d
	pc16KK3B98NK8Lo8+cz5H4lK8NpkALcwWkmh9q0AypyGopQni+0jEkTjr9InzXh6+3FxtS+Odt5
	ZNYHeAiQpR+phK6wQeu8vSzoezDIKwdwNs87EXU9CJ0hQ==
X-Received: by 2002:a05:6214:3c86:b0:91b:5d3a:5105 with SMTP id 6a1803df08f44-91c12f580cemr1790346d6.51.1792532920531;
        Tue, 20 Oct 2026 14:48:40 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c10bc99a7sm8625276d6.22.2026.10.20.14.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 14:48:37 -0700 (PDT)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v6 07/39] mm: assert mmap lock held, use new flags API
 in vm_insert_page[s]
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
 Paul Moore <paul@paul-moore.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, Simona Vetter <simona@ffwll.ch>, 
 Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
 Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
 linux-rdma@vger.kernel.org, selinux@vger.kernel.org, 
 linux-sound@vger.kernel.org, bpf@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
 fuse-devel@lists.linux.dev, Ihor Solodrai <ihor.solodrai@linux.dev>, 
 Bert Karwatzki <spasswolf@web.de>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-7-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-7-1aa3c9b139f9@kernel.org>
Date: Tue, 20 Oct 2026 17:48:32 -0400
Message-Id: <179253291264.1207257.80392040365771672.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-10-13 16:04 +0100, Lorenzo Stoakes (ARM) wrote:
> The existing logic asserts that an mmap write lock is held, bizarrely, by
> asserting that an mmap_read_trylock() fails (which is not the same thing).
> 
> Assert the mmap write lock here and switch to using the new VMA flags API
> while here.
> 
> Note that the vma_start_write() is explicitly broken out from
> vm_flags_set() here in order to use vma_set_flags() safely.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
Gregory Price (Meta) <gourry@gourry.net>
