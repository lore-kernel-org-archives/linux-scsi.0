Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0130D49B1F3
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 19:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789415865; cv=pass; b=JnghqdIb93hsU9HMp/wUPBod01Z1fc86aGuphyCTDCBu9hTO3Z+WnyxNQYJwcNZouIWIc3F00+gR9f0p2qPBh+xDqPBTknJcFZn4eQdBdKhvXpjydrHGs+Tc8yaC1nXwoEjEiXswzIExSqB5fTpAEpHf6MFx/C51bqtGbipEtzc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789415865; c=relaxed/simple;
	bh=rm+zdLu0LlzNfMP/vZrBYvi966p9ISS8d4XEb3JQ094=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hzc0udI8PYlHnEX04yz+yl0sXonY4TustVZ/PmnE78hLi1oRAIMRilE5E08XKJO5dBuAMGNZLju8j3WARAlV3N0oC4Mw87JhAg8okNajIdG6ucux4ECvORKj/Zvg/E1mnMXkdDmJxa12OxItirZIaXGTgJlqip+4zNsmGp/SqOw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=VBYIS+ru; arc=pass smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="VBYIS+ru"
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-86b90133ae8so1980676b3a.1
        for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 12:57:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789415862; cv=none;
        d=google.com; s=arc-20260327;
        b=pD1dCQiGaLYxP606OWwCiD8c75Ek4Rxa6NPQ8ZxuV28tjO+KzHmx0sTm0i94E4iIlo
         iYR5WaVG6YDET0L500tfXT4cHUJcpar0ClqZdBr6/g24rpsf1+/4nUvKiB9w9nOHDq3/
         /B32hDW/en5mYHVFYtKiKj0oNi7LDR4K1CZtNiZurxNow+iHXU2vp1RmjKqd6B3pPQdq
         4htqwXhEuXVFyrFHH7NSQYayndJ/g2KBogpQ4u2kBU9vAZPQGeGlqZxymvuOieSEs3t+
         3iq7bauOfnvofWZ6kv9MMD/KEQAu7mLA9w/4i7daSiHIG7xqkbV8YrUnlu1UY+haDlTN
         t3OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iEa5EIpxI31VfZhRCWTdUVuFxMmPcLfnD5/j1cH2Le4=;
        fh=MDGDmlvz2s5PVw5e4J9OWaKAAMWQl7Px+XC4zZhlI7w=;
        b=kxTsSeuzLKM1bO4Ei7j9aTF01wXatNGqZqKlX70KrvcR+Y+gGkBc+72A7SxW1vS/GL
         nqhk8pp6M47TjTg2x+cvZNNh0JXflw2iN/yvkjoi8o+uwMUYq/pkzx4UFreN/qyOwco2
         Ce5CKae+ml88h7St82W7DrfSAMkAzA/ZrFOyoSlBPtEpJFxsvAtLfi8j+PkfGwEU+S49
         jeRkbnchKfAd1fnz0E29pPAli5r/gXKYRvz6SwZJIasWzImQj5JxshrbElRyxtvtMIg+
         SFlY4VhpTzt/64wzTHF+WtH2IWBE6UdEkcy8KGIqsdpuwoTqRaLLZzaHeNKFKKuEX4DG
         kYQA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1789415862; x=1790020662; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iEa5EIpxI31VfZhRCWTdUVuFxMmPcLfnD5/j1cH2Le4=;
        b=VBYIS+ruvec/YQ7NPDSavrBqZkup3jtMUSf2x9fg2vR4Q/ZYGnptCqM7UF9GBEk6Kb
         pwYbAK2sJEZFDjRFht2ALhGnWfzEgxLd1W4Nqjf3iOyc3C9CQVwNzR9p52/m8eg00t3y
         i3INHp65zySvAJlrkN0SKQiamBOPK/2OeoXHbM/ieIzmZObIDK9PzOChSRrcM8YAyS56
         Wpk2JsgEsfietAppzsrHDi7c7Qi8vepD85wgaha++Drvrzfs42k7ryFVO4ohzIir1SFu
         Dz5Af79neP1/ODat12UTHwq79Ug1vrjKu97+aj6V0fudJlIrOVtfB5xkOELTreMhvqOw
         VVNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789415862; x=1790020662;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iEa5EIpxI31VfZhRCWTdUVuFxMmPcLfnD5/j1cH2Le4=;
        b=ESVVDgjAu5Lv4l4dQn3ABPxooZ6vT1AL1t88f5IWeH2jv9x0VCxzn0b6z6wZt1jIHv
         Yp78qsnuMQtSvONmjBw0Oi2CONj+UTLpDz4feIvMXN0iTuAlOxqq21mqzvtKLEcJW21u
         JgjCbI/G3tMA7Yr/JnGMuZ/0Y7TzyPRvvW6hajwntYNqGrInwJrjHkrbEw/h6xSW5IA5
         MM6GC71+XZLZ9y230Ap9/jXNBIqN59hI1XcVfF1A2OlJqvZpvKwsuJAumw2FdgLtvfmK
         AD45f2onKNfR8t+Xd9CNi3qMCMFbOrgIwOoVffuZ/UoeHPwXkob2Waj6z2hL7HOrco80
         Mk7Q==
X-Forwarded-Encrypted: i=1; AKwUvBxNKtKu9FqL1+IaDdVWqADU5xSI6lpXePt53mZ2X2jkaMZlWDoaAuC+hR+KgX9KxVEPD0Hl2GQrAf58@vger.kernel.org
X-Gm-Message-State: AFuF++lSEnsSoPIjCV/1mLr8e6d2hg3SiMxDu35jMlGpKbLqXCUXdacu
	iQyRLG02hjOkpV+DnpktC315EYkE6kbHJd34+8opNhD70ljP2xCVGjibCs1IuMR9PwGnvpyQ6Rg
	SVlSP9FaD6pOiTTten1Pad7uuZPgvlA0A8uVndkZF
X-Gm-Gg: AYBFou0kMv39fO/Hjs7z64lodibV3A/psL8YiORFdDtwfScUcOxGy9KimH0Zvf7UyXD
	oO0N1QNPA8j9fvk/cnlceNCwvBGIU/zaqqemUUKa68p/7q8uyVa/hRD01nh68MMHF28BaCwFDaK
	0Ir3rgGwrI1sTtpaAHhNXJm6B3QOnGr+kEUpBgUgwUbGUxo0iBfr3p4G+Lk3Sotwb0kfkJvI0Jr
	6WG0bkD2uyoTOkIFV2gRcQYJ5hYugWXuoLcKztusI70AMNt5SfMNVbeS6JYNxFxH2pTIdrl0/XN
	CvbWNRJF66z2itoMD7ozlb1XfuvM4HwScO5UnzcQb++qGZvRaI05Q893JA89ypwk3fm/blor95W
	iHOsanGh2Tpg=
X-Received: by 2002:a05:6a00:18a9:b0:858:b809:6ec0 with SMTP id
 d2e1a72fcca58-86f869a920dmr8896742b3a.23.1789415862342; Mon, 14 Sep 2026
 12:57:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-12-7d9781ed5361@kernel.org>
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-12-7d9781ed5361@kernel.org>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 14 Sep 2026 15:57:29 -0400
X-Gm-Features: AcwNN1XaLRK0KaZAmfcRvdaBSkZOdh14LF1fb-xWULoFVhBfqyRklsdKoWBmLag
Message-ID: <CAHC9VhQ3TwdGGH6YtVyMqJX4avJwsadcRvRhAoUhCvJEHk=i=g@mail.gmail.com>
Subject: Re: [PATCH v2 12/40] selinux: reject writable opens of policy file,
 drop mmap shared/write check
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
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
	fuse-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 14, 2026 at 11:05=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.=
org> wrote:
>
> The policy file has no write method and is exposed read-only (S_IRUGO in
> selinux_files[]), yet sel_open_policy() performs no open mode check, so a
> CAP_DAC_OVERRIDE caller can open it O_RDWR. Reject FMODE_WRITE at open, a=
s
> kernfs does.
>
> The file can then never be mapped with FMODE_WRITE, so do_mmap() always
> clears VM_MAYWRITE and VM_SHARED for MAP_SHARED mappings and the VM_SHARE=
D
> check in sel_mmap_policy() cannot be reached. Remove it.
>
> This also stops sel_mmap_policy() clearing VM_MAYWRITE on a mapping that =
is
> neither a PFN map nor a mixed map, ahead of the core enforcing that only
> such mappings may do so.
>
> Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> Reviewed-by: Jann Horn <jannh@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  security/selinux/selinuxfs.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)

Acked-by: Paul Moore <paul@paul-moore.com>

--=20
paul-moore.com
