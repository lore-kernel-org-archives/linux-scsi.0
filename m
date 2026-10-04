Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2B03DB32D
	for <linux-scsi@vger.kernel.org>; Sun,  4 Oct 2026 17:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791133856; cv=pass; b=PRIie6eT3T+8oQsVxVRhZbsYwiYY2irJYhCJADIJTuYdViSNtVRjHZXsbJOrYvxKvH64cSVmWrR+eU4mx3bJsGGoGr8KfvhapMgqPctpy0U9uZ9mYeNSz2IcGLBJsHd5MQyYUpAyTlRKNlwtJAXlcorqWPOI9AIiKCmPUqnxBd8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791133856; c=relaxed/simple;
	bh=skAvVzU9J+cvf2yMLSTkCbfMIs6l25zJ8q18PQW6Hys=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XmlPYWJUc1+And7kFDGIYa8kFEE3S1mTSozvBZ9ZWkNqxsmnmbc1qRpJlfPCG53DIxFCqOQWKV2VU2gel5qXa07RsHYOv7sJxlQepoWLEb6GX4kNAfBO7yLoHJQnlYx21IGXCbbNQyH6OUnQfrhVJPpQT6lCUmBIUL1gRdIHkFo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SjkA+tRe; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SjkA+tRe"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-533202fe429so244601cf.0
        for <linux-scsi@vger.kernel.org>; Sun, 04 Oct 2026 10:10:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791133852; cv=none;
        d=google.com; s=arc-20260327;
        b=ac8DhIGPH6uYqWNfMkJu14mwuqxJZX3PtRdtHmJzbBsNHtBbOyiCdbowVsbRdn0ySu
         /HzNYWkjDIICCHB8ykgkW1qsY0v59Exs8ci4jKqshZcoDhsplD8t3Am7/tNtnFuOFxKi
         CQoHJuaSN+67uxICaIzfwSeYDcSE27acmC2r6l7DOJLpYn4ko1o9EEGAgXvmVlqAo+vH
         tBw43LRklvXE0T2OrRK4oGFu4/gAZFKGmQDZf9v9D32aRKn1504svzzm+hhFXcRNrU6t
         KD2w8LH+M875dKTQf2Ymuaw9LuV2z3Pqc8FlrXAvC1FVDS9daztPHXkpBF/y67MS3Hst
         nIrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nXFwGZqE64cDzbgwSCh2JqwiAkclwFSYOp8vtgN8R9U=;
        fh=Sev8y0QR+lZ4cO4to+5nMGIMsrCRF0Dlf5Enf/ZJ7+U=;
        b=I08Q3d0D+3918u73KHc4vL1jU4FzgvhMHiHnL9kwi2g5dDhapA9B7an0/o1+rkhdph
         KRHIQPqfayN8t2I+/qBm8b0D9eBVdTgq7zT0LQc20rMsYp193+gx7zODpnL4dP1z+FDt
         GB/d7bXNbMqllvNwT8tIIAGUZ4umYTKNGzbha6a/uPnv4rC2vCQcK4pLbxzRssu2EWuV
         Jj46h8q8b+PgbjKWLLWN5Ar+EVHN9GR4EdpsqFmgKFuoFNBypYuLyLcHA/F781CogxCD
         pm9urWF2RhUpQ14tjStplKDkn1d5lbaBGo+a5kqQPuOIH+9JRmj7BdPT5qbBodOIvz9O
         Qktg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791133852; x=1791738652; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nXFwGZqE64cDzbgwSCh2JqwiAkclwFSYOp8vtgN8R9U=;
        b=SjkA+tReNnGkHS5FpMvarIGVONwAbqLS7l08Nz6JHxcBhsMtuQvHUSiXD6C1SzKNzI
         j5Sop8XJTVqBUDgSaC8M1DmkvJsz86G1TfVIjtAxPff9EXOoGg+/PgY7WOKjmBa97M7h
         lbqHekE9RAewvm1bKpPlEocymHqfm4xrf1VVzn5ctr2VAiT6mVzBRayiIcrNyYOTj1zB
         XB+jggwej9YaDADODImPesFz9LovZw9Qy5bLC7r13RES8gOTlSZ0pJy07cqcVO9Wv3U1
         80snJUO8BpsVR71iScoQWl/FpvUTU51yk/5WPp+kYjLgTrpbSH1qkS0WOFkAhx5oZEXm
         AR1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791133852; x=1791738652;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nXFwGZqE64cDzbgwSCh2JqwiAkclwFSYOp8vtgN8R9U=;
        b=DLSDwAqvYpgnY98epCrc7PW9hQLyL13F/WcZluPb7yviJDOxQx/xfnfoJs+IhLZeLU
         H3FrO75BGkMpLkOpHewtNqgqdkF/jV6qHt2ILgDf8w5XJ7+Wms64ldF9V7O8/POhFEZH
         epyMxaqjlOXB/307yxzlyNa6hEKk8R5k/b1qVIAE4QYSuAtQnLlTVdqxP8U3QzsHeAk3
         QYPHbrJU7VQc5/jVqchpGFCvVtkS6HlAR1FxEXOLO8tebKRJxxX5mGWjU8rJwbmfw5hn
         Ebj3KngJl88jno5SPQD7a3KCncy3S/tG46pvnsdQCcnhSMxK8o7aRRk+sC14F8M6aA+T
         6yIg==
X-Forwarded-Encrypted: i=1; AKwUvBwh743MKQ4/bIDOI7DOEmMPNMPDUdqfUKcH1t2HcD9VHrhibbXttNQ5DZ0aUX9G9B6TXyip72o0A1qG@vger.kernel.org
X-Gm-Message-State: AFuF++mZX6zKYuFJ1yX2HOffz/IgUvT8yULlaUNsyqlHczX9UxN4R/h3
	XORHOwmgWJN1/onLKTYC3EH4I+c3fa4Tc8tF7QpwZnRN7+4srrrhdBy1aiFj1jPUeLUVbNpF0Tn
	7itSh1Qa8Ae2Uj9MfiiIEfcitOGwuWBgOuHVNeWHd
X-Gm-Gg: AYBFou13OuNeAZiuUu/mwWDliYvASvgOIFOOg6TmOAX/MOFu9E0y0QSjcbOFDcQn//Z
	s/yk5BSbq0z4DRW72sxB+97Icuu1+mSSN2Jls/IPH89SsrGZQ3ymEDdd24sJL89eAofqv1iOUC+
	BaKagHjw2IKduk3q2iZLKRHi9cqbl6SinJVf8+aG4NuMzl7hskVExqJikGPc7xY+S/ScbD6BFxu
	rfCicMZ5EzKEGfaW5jX7h3vuIoq0/GGgHyd+a0Q6Hr8wCx9xzSPtRU3Fu8+NyFb5uijKfCERPPB
	zhiCSA2qJXRGIzZ7nypdvitVATGxWmr0JgKFV0qdK8Ht+7oOKRL2i8mE
X-Received: by 2002:a05:622a:2506:b0:52f:9ed4:8d75 with SMTP id
 d75a77b69052e-5351497fbecmr18649011cf.15.1791133850875; Sun, 04 Oct 2026
 10:10:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-1-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-1-a1f052500fd7@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 4 Oct 2026 10:10:39 -0700
X-Gm-Features: AclHuK-xwRjaaPrwB80Vzu7EPALPdSfCYFBDDTpR92M3U_nW5dShbdAXxId4uf4
Message-ID: <CAJuCfpH04aBbW+mnQY3cX5gfEvOHP7nUMAJNaGWtQ5NoE1JKyA@mail.gmail.com>
Subject: Re: [PATCH v4 01/38] mm/vma: fix mmap_prepare file handling, remove file_doesnt_need_get
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
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
	"Martin K. Petersen" <mkp@kernel.org>, Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, 
	Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
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

On Sat, Oct 3, 2026 at 6:33=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> The map->file_doesnt_need_get flag is confusing and the existing
> implementation has holes.
>
> Drivers are permitted to change the owning file of a mapping. If they do
> so, they are required to take a reference on that file.
>
> The mmap() operation which ultimately invokes __mmap_region() is guarante=
ed
> to drop the refcount for the original file the mapping was made under, bu=
t
> this is not true for the replaced file.
>
> This has been addressed so far by tracking map->file_doesnt_need_get, whi=
ch
> is rather poorly named and unfortunately fails to correctly track whether
> or not an additional put were needed in a number of cases.
>
> Make life easier by removing this flag, and instead drop the reference fo=
r
> both mmap_prepare and the deprecated mmap callback in a new function
> map_put_vm_file().
>
> Track whether this needs to be done by aligning mmap_state with
> vm_area_desc and store the original file in the map->file field, keeping
> the updated file in map->vm_file.
>
> In order to have the same behaviour for both types of hooks, only drop th=
e
> reference __mmap_new_file_vma() itself took in its error path, deferring
> the replaced file's reference to map_put_vm_file().
>
> To make this work correctly, map->vm_file has to be updated before any
> error handling, so update __mmap_new_file_vma() and call_mmap_prepare() t=
o
> set this field first.
>
> Also when mmap_prepare() changes the file and is then merged, the referen=
ce
> count also must be decremented, so update the logic to call
> map_put_vm_file() in this case too.
>
> Also update __compat_vma_mmap() to manually perform this step for stacked
> file systems using the compatibility layer, and update
> compat_set_vma_from_desc() to replace vma_set_file() with a correct
> refcount/file update.
>
> No in-tree driver is impacted by the incorrect implementation of this
> currently (no driver that does this is mergeable for one), so this does n=
ot
> need to be a fix.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>


> ---
>  mm/internal.h |  1 +
>  mm/util.c     |  5 +++-
>  mm/vma.c      | 83 +++++++++++++++++++++++++++++++++++------------------=
------
>  mm/vma.h      |  6 +++--
>  4 files changed, 59 insertions(+), 36 deletions(-)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index 0dca33db068f..fe576d468af4 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -7,6 +7,7 @@
>  #ifndef __MM_INTERNAL_H
>  #define __MM_INTERNAL_H
>
> +#include <linux/file.h>
>  #include <linux/fs.h>
>  #include <linux/khugepaged.h>
>  #include <linux/mm.h>
> diff --git a/mm/util.c b/mm/util.c
> index bf0513d1d3d0..016932780925 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1228,8 +1228,11 @@ int __compat_vma_mmap(struct vm_area_desc *desc,
>
>         /* Perform any preparatory tasks for mmap action. */
>         err =3D mmap_action_prepare(desc);
> -       if (err)
> +       if (err) {
> +               if (desc->vm_file !=3D vma->vm_file)
> +                       fput(desc->vm_file);
>                 return err;
> +       }
>         /* Update the VMA from the descriptor. */
>         compat_set_vma_from_desc(vma, desc);
>         /* Complete any specified mmap actions. */
> diff --git a/mm/vma.c b/mm/vma.c
> index 55917d097933..c27aea6d58d9 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -24,7 +24,8 @@ struct mmap_state {
>                 vm_flags_t vm_flags;
>                 vma_flags_t vma_flags;
>         };
> -       struct file *file;
> +       struct file *file;      /* mmap()-specified file. */
> +       struct file *vm_file;   /* May be updated by mmap_prepare. */
>         pgprot_t page_prot;
>
>         /* User-defined fields, perhaps updated by .mmap_prepare(). */
> @@ -43,8 +44,6 @@ struct mmap_state {
>
>         /* Determine if we can check KSM flags early in mmap() logic. */
>         bool check_ksm_early :1;
> -       /* If .mmap_prepare changed the file, we don't need to pin. */
> -       bool file_doesnt_need_get :1;
>  };
>
>  #define MMAP_STATE(name, mm_, vmi_, addr_, len_, pgoff_, anon_pgoff_, vm=
a_flags_, file_) \
> @@ -58,6 +57,7 @@ struct mmap_state {
>                 .pglen =3D PHYS_PFN(len_),                               =
 \
>                 .vma_flags =3D vma_flags_,                               =
 \
>                 .file =3D file_,                                         =
 \
> +               .vm_file =3D file_,                                      =
 \
>                 .page_prot =3D vma_flags_to_page_prot(vma_flags_),       =
 \
>         }
>
> @@ -70,7 +70,7 @@ struct mmap_state {
>                 .vma_flags =3D (map_)->vma_flags,                        =
 \
>                 .pgoff =3D (map_)->pgoff,                                =
 \
>                 .anon_pgoff =3D (map_)->anon_pgoff,                      =
 \
> -               .file =3D (map_)->file,                                  =
 \
> +               .file =3D (map_)->vm_file,                               =
 \
>                 .prev =3D (map_)->prev,                                  =
 \
>                 .middle =3D vma_,                                        =
 \
>                 .next =3D (vma_) ? NULL : (map_)->next,                  =
 \
> @@ -2447,7 +2447,7 @@ void mm_drop_all_locks(struct mm_struct *mm)
>   */
>  static bool accountable_mapping(struct mmap_state *map)
>  {
> -       const struct file *file =3D map->file;
> +       const struct file *file =3D map->vm_file;
>
>         /*
>          * hugetlb has its own accounting separate from the core VM
> @@ -2496,7 +2496,7 @@ static void vms_abort_munmap_vmas(struct vma_munmap=
_struct *vms,
>
>  static void update_ksm_flags(struct mmap_state *map)
>  {
> -       map->vma_flags =3D ksm_vma_flags(map->mm, map->file, map->vma_fla=
gs);
> +       map->vma_flags =3D ksm_vma_flags(map->mm, map->vm_file, map->vma_=
flags);
>  }
>
>  static void set_desc_from_map(struct vm_area_desc *desc,
> @@ -2506,7 +2506,7 @@ static void set_desc_from_map(struct vm_area_desc *=
desc,
>         desc->end =3D map->end;
>
>         desc->pgoff =3D map->pgoff;
> -       desc->vm_file =3D map->file;
> +       desc->vm_file =3D map->vm_file;
>         desc->vma_flags =3D map->vma_flags;
>         desc->page_prot =3D map->page_prot;
>  }
> @@ -2586,6 +2586,10 @@ static int __mmap_setup(struct mmap_state *map, st=
ruct vm_area_desc *desc,
>         return 0;
>  }
>
> +static bool map_same_file(struct mmap_state *map)
> +{
> +       return map->vm_file =3D=3D map->file;
> +}
>
>  static int __mmap_new_file_vma(struct mmap_state *map,
>                                struct vm_area_struct *vma)
> @@ -2593,20 +2597,23 @@ static int __mmap_new_file_vma(struct mmap_state =
*map,
>         struct vma_iterator *vmi =3D map->vmi;
>         int error;
>
> -       vma->vm_file =3D map->file;
> -       if (!map->file_doesnt_need_get)
> -               get_file(map->file);
> +       vma->vm_file =3D map->vm_file;
> +       if (map_same_file(map))
> +               get_file(map->vm_file);
>
> -       if (!map->file->f_op->mmap)
> +       if (!map->vm_file->f_op->mmap)
>                 return 0;
>
>         error =3D mmap_file(vma->vm_file, vma);
> +       map->vm_file =3D vma->vm_file;
> +
>         if (error) {
>                 UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
>                             map->prev, map->next);
> -               fput(vma->vm_file);
> -               vma->vm_file =3D NULL;
> +               if (map_same_file(map))
> +                       fput(map->vm_file);
>
> +               vma->vm_file =3D NULL;
>                 vma_iter_set(vmi, vma->vm_end);
>                 /* Undo any partial mapping done by a device driver. */
>                 unmap_region(&unmap);
> @@ -2623,7 +2630,6 @@ static int __mmap_new_file_vma(struct mmap_state *m=
ap,
>                         !vma_flags_test(&map->vma_flags, VMA_MAYWRITE_BIT=
) &&
>                         vma_test(vma, VMA_MAYWRITE_BIT));
>
> -       map->file =3D vma->vm_file;
>         map->vma_flags =3D vma->flags;
>
>         return 0;
> @@ -2631,7 +2637,7 @@ static int __mmap_new_file_vma(struct mmap_state *m=
ap,
>
>  static void map_set_anon(struct mmap_state *map)
>  {
> -       map->file =3D NULL;
> +       map->vm_file =3D NULL;
>         map->vm_ops =3D NULL;
>         map->pgoff =3D map->addr >> PAGE_SHIFT;
>  }
> @@ -2643,7 +2649,7 @@ static bool map_is_private(const struct mmap_state =
*map)
>
>  static bool map_is_anon(const struct mmap_state *map)
>  {
> -       return map_is_private(map) && !map->file;
> +       return map_is_private(map) && !map->vm_file;
>  }
>
>  /*
> @@ -2688,7 +2694,7 @@ static int __mmap_new_vma(struct mmap_state *map, s=
truct vm_area_struct **vmap,
>         }
>
>         /* Invoke callbacks. */
> -       if (map->file)
> +       if (map->vm_file)
>                 error =3D __mmap_new_file_vma(map, vma);
>         else if (!is_anon)
>                 error =3D shmem_zero_setup(vma);
> @@ -2797,11 +2803,15 @@ static int call_mmap_prepare(struct mmap_state *m=
ap,
>         int err;
>
>         /* Invoke the hook. */
> -       err =3D vfs_mmap_prepare(map->file, desc);
> +       err =3D vfs_mmap_prepare(map->vm_file, desc);
>         if (err)
>                 return err;
>
> -       /* It's invalid for mmap_preprare hooks to clear vm_ops. */
> +       /* Update first so file refcount tracked correctly. */
> +       if (desc->vm_file !=3D map->vm_file)
> +               map->vm_file =3D desc->vm_file;
> +
> +       /* It's invalid for mmap_prepare hooks to clear vm_ops. */
>         if (!desc->vm_ops)
>                 return -EINVAL;
>
> @@ -2811,10 +2821,6 @@ static int call_mmap_prepare(struct mmap_state *ma=
p,
>
>         /* Update fields permitted to be changed. */
>         map->pgoff =3D desc->pgoff;
> -       if (desc->vm_file !=3D map->file) {
> -               map->file_doesnt_need_get =3D true;
> -               map->file =3D desc->vm_file;
> -       }
>         map->vma_flags =3D desc->vma_flags;
>         map->page_prot =3D desc->page_prot;
>         /* User-defined fields. */
> @@ -2826,7 +2832,7 @@ static int call_mmap_prepare(struct mmap_state *map=
,
>          * anonymous mappings. Rather than allowing these mappings to be =
odd
>          * outliers, simply make them truly anonymous.
>          */
> -       if (map_is_private(map) && file_is_dev_zero(map->file))
> +       if (map_is_private(map) && file_is_dev_zero(map->vm_file))
>                 map_set_anon(map);
>
>         return 0;
> @@ -2845,7 +2851,7 @@ static void set_vma_user_defined_fields(struct vm_a=
rea_struct *vma,
>   */
>  static bool can_set_ksm_flags_early(struct mmap_state *map)
>  {
> -       struct file *file =3D map->file;
> +       struct file *file =3D map->vm_file;
>
>         /* Anonymous mappings have no driver which can change them. */
>         if (!file)
> @@ -2868,6 +2874,20 @@ static bool can_set_ksm_flags_early(struct mmap_st=
ate *map)
>         return false;
>  }
>
> +static void map_put_vm_file(struct mmap_state *map)
> +{
> +       /*
> +        * An error occurred or the VMA was merged.
> +        *
> +        * If the file was changed by the driver (which is required to in=
crement
> +        * the replacement file's reference count), drop its reference co=
unt.
> +        *
> +        * On error, the caller always drops the original file regardless=
.
> +        */
> +       if (map->vm_file && !map_same_file(map))
> +               fput(map->vm_file);
> +}
> +
>  static unsigned long __mmap_region(struct file *file, unsigned long addr=
,
>                 unsigned long len, vma_flags_t vma_flags,
>                 unsigned long pgoff, struct list_head *uf)
> @@ -2922,7 +2942,10 @@ static unsigned long __mmap_region(struct file *fi=
le, unsigned long addr,
>
>         __mmap_complete(&map, vma);
>
> -       if (have_mmap_prepare && allocated_new) {
> +       if (!allocated_new) {
> +               /* Merged, so need to drop refcount. */
> +               map_put_vm_file(&map);
> +       } else if (have_mmap_prepare) {
>                 error =3D mmap_action_complete(vma, &desc.action,
>                                              /*is_compat=3D*/false);
>                 if (error)
> @@ -2936,13 +2959,7 @@ static unsigned long __mmap_region(struct file *fi=
le, unsigned long addr,
>         if (map.charged)
>                 vm_unacct_memory(map.charged);
>  abort_munmap:
> -       /*
> -        * This indicates that .mmap_prepare has set a new file, differin=
g from
> -        * desc->vm_file. But since we're aborting the operation, only th=
e
> -        * original file will be cleaned up. Ensure we clean up both.
> -        */
> -       if (map.file_doesnt_need_get)
> -               fput(map.file);
> +       map_put_vm_file(&map);
>         vms_abort_munmap_vmas(&map.vms, &map.mas_detach);
>         return error;
>  }
> diff --git a/mm/vma.h b/mm/vma.h
> index e97bd2dfa786..f15faa83f3d6 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -394,8 +394,10 @@ static inline void compat_set_vma_from_desc(struct v=
m_area_struct *vma,
>
>         /* Mutable fields. Populated with initial state. */
>         vma_set_pgoff(vma, desc->pgoff);
> -       if (desc->vm_file !=3D vma->vm_file)
> -               vma_set_file(vma, desc->vm_file);
> +       if (desc->vm_file !=3D vma->vm_file) {
> +               fput(vma->vm_file);
> +               vma->vm_file =3D desc->vm_file;
> +       }
>         vma->flags =3D desc->vma_flags;
>         vma->vm_page_prot =3D desc->page_prot;
>
>
> --
> 2.55.0
>
