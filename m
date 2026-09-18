Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AF1524AE4
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 20:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789763501; cv=pass; b=Z39NvIqMIYhVGorh0WnKZS1tTWVYpyLocy4SjHg+tarJziWKqBif9p/pno8gxZGgvqo+xlcRSFHnXtaDkdXuF83hjxzGvXitHqIeK9wE8NUvFn15VtX+qGQhOcK/pdJP0tFC4WqbT0CYlMnUFBfoFhORYwrPHE5WwJkBGI92o2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789763501; c=relaxed/simple;
	bh=B8p7ihCHzGvnzup/C6y6XYLlWrQRIq7YUbOlQS6xj3s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t1oFOHqZOe4LotCvDPGQXjnPAavmSItrh5J8moOo+oO9r/ehgeWMW5yCXfX5c7hMEO0i0xE73GeLsLRUbbFqRcS60bRKt3PBkfdlycFKQKKRbLxE7iclg/1uBYAAppIYp2OsYEx1v5b9An15rN9bLkZyaROgnevk9RIbhxxUwdU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UU0wjojH; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UU0wjojH"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-53113d72966so9411cf.1
        for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 13:31:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789763498; cv=none;
        d=google.com; s=arc-20260327;
        b=DEc/BL7p9PlBa9cF9to6xFAE1gFq+FRcN7tuvxLXS9+fH5ZmhD1HXa+ILXyRnMQqr5
         HrxeYNvEUmPOxcQ16QilHhOV/7+0lCeP5ICUnkmYMsPBMFbi2vVMuMx7B51vF0JOwQR3
         yBgYEGDM+TvnoWalqxhD6aT/GPN7ifL0GF9BRdsz7WQspaYcrUVUoIZEM1yThd6zySrD
         q1P/N/FQnDwY6pD4R96WTNTX1u74crhIw/iuzAgoo301TSOKLv4YKVb/h0f7qMKzarxE
         uWUI2Xb6jlL27iiprDx6Zx49lDfZ0/B4+N8gpBYvCTQOXsfwk0m+997DrL9KbOhvxdt1
         /dwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rakr0DVeS6w19WPN+xiAqZEbcFGWWdpHaQBH8HXSGgc=;
        fh=VJL+TIFiHnzu1BaLTuAwhQjpcx6vyPN3tUmcjX5tVIM=;
        b=bS5biBaRILRXanX0tqKprLCJXW9uKEQFbP0jde5LNZ9/gvZk+hXnKCtRuDTl5ymLZs
         aczEnEe5wHo1LRzXcpjP+TIeHr5Fxp6VZxuGZYxSmlr9rShMU261rmWTDlk1WoPP83Yv
         qflMBUyUyT6Ffsr8ydPowG3fTWfWlIh8F+4Mc8KLzgtFKEpbL08fBTG4lGS3V0xeXjHV
         qmJDLZNBPowsgpm2SRTmRHKy0z0fe1mEi0gnZOxYOul5qrXMviY/7uNwy8eF7xT/Vwf9
         IJrrRis7i7OSL29GSY1j+j1aloTlQOjLoa4MmUebyTsPi2vb0h9Tt4nP12/NziRBL1f4
         aigA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789763498; x=1790368298; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rakr0DVeS6w19WPN+xiAqZEbcFGWWdpHaQBH8HXSGgc=;
        b=UU0wjojHMZJdEefbV+oe7n3/1SeoG/dOO8hNK7Tj8QvphQy34bQ/TtZfJPFMbLM7Dz
         Y/YVWKsh9GRn1f4QL5Y0tAv574p+Z233A80/H7Il2x+C3qiCdyydEpXhoIeUomNkSzt1
         u26uedB4a+lTAzO3+lsk9SL/2xRHXFuNtkCjCNLqhT5/eS3sAp8P6KWPemR4yNW03+/t
         Y8eKGMCmYLtIa9slPbZ5/d3cujTWZUj7oR6ZaFLAEvvN8VjRm9Zsvsy20ZCKhB4uDz4q
         NgoOUOU2qI60k2fnz6n/kBaIH6Wtw6G2RqENciuFm00/6+5swPRTI5zkRENNInuJF/fH
         XfVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789763498; x=1790368298;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rakr0DVeS6w19WPN+xiAqZEbcFGWWdpHaQBH8HXSGgc=;
        b=kKQrTNiZ4OOBJFKqKehxfQ8iP55WsPzXFBCZ3gk9sK8B/g6gpmX7D9t6aqPy1Y4bTv
         HhzmTAeB/brq2+doJtib5kXL31laJFXSRpMit/ZNlcywEM2rSVlvGJU2yRulKpZsrs7i
         MtwKr2UTPLHCA2u/zpLaxGNDnOhmzi2h4y/3niy1aik0i7Rwy4h3g1yR3uEq3v+KMg11
         YwwL9DMBTP6V3WmskbZE4LQ5W0HikDGZiKF/nDsKmtJEL5jgyVF2jqwICNL71T3RhGWQ
         lwbSDbETeEkeIQVSi+tfEH/vKKkqlpSD++4P0QvJeFrEeEQJWPVstjth7wDAKjxTQd6T
         LBQA==
X-Forwarded-Encrypted: i=1; AKwUvBzaDizqX6O6oaexWwEOwkXdFC15qSQJVynJdA7KbOyXbTAmNZ+yd2a+BrTw4Nvdy4/4X126EvfTnByj@vger.kernel.org
X-Gm-Message-State: AFuF++naCq2b2h4grgLIUHYAccLg5n1Oir6RmdWqKeOHwSFwwGPGe1z4
	PrCx4yKzgZ7btxb79h6eWiOpFgUNWsfWBhksowqmJh/CY/DkOg6H/kVOjPkiWpmnRU4RQRs8nU2
	lw/uc5qQIoLx/D+n59o8jPw31XrE09Vdevju0Q9IF
X-Gm-Gg: AYBFou3WNr5jxDgjfe15KrrmqFDxGjhYJaIQgazsAPLyqeyWT+22JT76MImpIqZH2P+
	y7ZTm0TV+5yznBdyEcW1Yn6iDCfPaj1kw0VcvpjAjO35cLVIH1d8gGgw8kNL8lEpXS+CY5c3xfj
	r7IDnb/RN/lJHmAZthmt2eS8U/W2rXFPzmgvadK48TyhCDglQbmt3QdixnLCECUDDsHtAnljY1m
	AiEXejxXfNasXRiQhKFE6AZwA6+L9SATw5ok/VVoTy1nlYTSAzV6JKxoH+vOCzyb1XB1Y2u8LQT
	0/t77AdgFRKwzX2G+255UOJ+2BF7gu+OVYJSaaxE0lFpD19Wy/CCHw==
X-Received: by 2002:ac8:5d08:0:b0:530:2f98:cebb with SMTP id
 d75a77b69052e-532b099561dmr605641cf.11.1789763497212; Fri, 18 Sep 2026
 13:31:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914180811.057cba8fcc48d6e0b53a2683@linux-foundation.org> <0b064fe6-ddb3-4f26-a1f2-2e9dd88d590f@kernel.org>
In-Reply-To: <0b064fe6-ddb3-4f26-a1f2-2e9dd88d590f@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 18 Sep 2026 13:31:24 -0700
X-Gm-Features: AcwNN1VqLTR47MatnNlBWbpWA8EMmoQNGykspJvqoxdaovPnF0EYfRCWZF-8zh0
Message-ID: <CAJuCfpFBichJH4OcmSHTb1rOuQBT6k5pXeua9_KgpWjDBKvsYw@mail.gmail.com>
Subject: Re: [PATCH v2 00/40] mm: make VMA flag semantics explicit, eliminate VM_SPECIAL
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Jaroslav Kysela <perex@perex.cz>, 
	Takashi Iwai <tiwai@suse.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>, Simona Vetter <simona@ffwll.ch>, 
	Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Arnd Bergmann <arnd@arndb.de>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, 
	selinux@vger.kernel.org, linux-sound@vger.kernel.org, bpf@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	fuse-devel@lists.linux.dev, Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 18, 2026 at 1:21=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/15/26 03:08, Andrew Morton wrote:
> > On Mon, 14 Sep 2026 15:57:20 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.=
org> wrote:
> >
> >> The VM_SPECIAL / VMA_SPECIAL_FLAGS mask conflates several unrelated
> >> properties:
> >>
> >> ...
> >>
> >> It's all rather a mess.
> >>
> >> This series brings some order to things by both limiting what drivers =
can
> >> do with VMA flags and switching to using predicates that describe
> >> behaviour, not arbitrary flags.
> >
> > That's a lot of patches.
> >
> > Review is thin and I expect this won't improve a lot.  Lots of "no
> > functional changes" changes.
>
> I'll expect to go through all of them. Might just take a bit ;)

ditto

>
> --
> Cheers,
>
> David
