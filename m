Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5979C47ACFF
	for <linux-scsi@vger.kernel.org>; Sun,  4 Oct 2026 18:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791137393; cv=pass; b=fgm/tLdn481IsgVFf5TyyOJlbYZ7YYmCOYO6i7YIVFCgSuWFTFiCpFUeCPzD/jfVgSMrJOwkLQqG77vPGp3KVP9PqaUQfZZ3Bkv0cgSu+PDuW/Z4leI4Lspw+s+NDFdHG43sOtLB+ywp/bU0DbPbR9nc7IWheZ12sSmzJHKt1u4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791137393; c=relaxed/simple;
	bh=p8mpZNJ/Ji/VmSUc1fEHKip1nG8b1aj7rE3YFXNPflA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GTYLbf1FtxN5yvXUu9EScVlgcpp/AtNpM10ykg4Vp9XsiKo2d07NGDX1fp1vh1bAkZ/fPQNAnJ7aFtT7nHYOHcXM8ADGw4ujNAhjXteXpsNqgQdbUm7NctgPwsc6eOSXkjgTZD4idgiOTLehdyjABRHT4XVsz3E6dBVi24cwonA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E0UoFfko; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E0UoFfko"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5337c7b9937so263661cf.0
        for <linux-scsi@vger.kernel.org>; Sun, 04 Oct 2026 11:09:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791137387; cv=none;
        d=google.com; s=arc-20260327;
        b=nqgVR/e9ucuDstdrXrO6JDwSWIar/35zSilnWQa69cpvtpFXljlsFrfU0rXNT4t6Yx
         YKUdyjaHeD2SWCDo/pTRj2AMAgxKd72ZIZJxS3GWN+w1V9hOUwz7chgPCCKryH/lVywX
         4Nxdr38Pnn4ZSI+4nfhNTlR+XrNsEwEjmlqooSah1pb/Uv8EsnfSdOH8Vn2WPbuh1rQR
         a6F8ytYwOUiF7U72yLNn+VplAF4sIrwcEb+ukUR+TT3zetdklzBtZmMv6ao7HMBOs4zi
         Hk8yhqLboztSHvBlxhiMt0qvRvvVf2jFXgYcjl7kjrzIwv13UmqpLFpwbY3ons8NhX6E
         umlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XLyJnDD7le8j0fwG4PV8CX7G4WYRHL5RcOgxsV2u/6k=;
        fh=fFJZhiiCtdXXSOBmeqa9FiffkgeIVDdHOGDq9UWg8WM=;
        b=U5HqC8qhzBEwYjkOn6UwtFanI0/7tL5fR/ARXlEYjmRe1UvuItLZ+tw6slb4OIUcjs
         8C+nn0cw/KGQ/64cerfQoRfsDGypF6bSRtIY677pq9WlxQ8/4X6b4nKghQxBV8ucICul
         eBkevWMLaUWz2bejurYyW5pCZQGGFyiotmu4VXq7o3/Eq41nObBmTTGVZldmad8WXaVS
         8ZNv2klDi3ZiGZRJqxJAK6lQy36hinm4KddEYEXCLhYnhHsOfrESW3F3ZnoJt+YtjGo7
         DGBW6Wyp1Pd1hrLjV0WXVolhOOYaFrlrM755h8h9r6ergR7Bmh3mqKMxfanc+Ue8MSEG
         JE8Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791137387; x=1791742187; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XLyJnDD7le8j0fwG4PV8CX7G4WYRHL5RcOgxsV2u/6k=;
        b=E0UoFfkoV/H9wZOO1BXTsRY/bCLNQ5va+n1jrcDtS6ZcHOYOr+TjpCV5xI5dC5CiUa
         e22B1ZgpqtwjJqepICJJO+jrz6k00TOHkYnIIjpp4Y9NRgjepbxoHkRAZGgxoPz2A2WJ
         FVS5V+Fb1XO8uZCwcmFtReiDU2tfMyYOqbc2e2Fir5ikY7YDP/IcD4shXPx9ZAdCC0QB
         sL4yQbXlj4oVvjG0g7x/t9HYU0mEgRKY+CG98f3yxbJnfVtgPBwcV6yZseK8V6UNNvDl
         2NhVVy6dWyVMtVxLNaJkty3xWEhdlMCkVEIcEgrAB7+y+C/gholsDJOVYIHpjJwyp72g
         YnAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791137387; x=1791742187;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XLyJnDD7le8j0fwG4PV8CX7G4WYRHL5RcOgxsV2u/6k=;
        b=lIWk5CWw2psQ9VdwGS28fYL6W933z+Nm2Djj7fO1vtKyMkWw0H4lFx1Tw6jfaex7lF
         nR5XQm3CjiR2gDCf4Krq39zUqUVw6BzsLmR3iC+jUO09EQu/1f5N6IUxoJDJpGN4Ccow
         BjMmHygyvDGv14ZMW3qd+KCWVueQLdx3I/AQywDYJrkd7niPdvBMZBhIUO/PiTlz4yPi
         OC8SXuatBaA5salD0xUxHLLcVnWBHxex+ksoizL8BWqJfpMJU1B51fogTIxQ/e5zjnS8
         pZw7Fnct53nhv7qNj/zYEc47000gsei/h9dZOWjroHC7lskgXxWDTPPeE63VS+zlJeFY
         pr0g==
X-Forwarded-Encrypted: i=1; AKwUvBwhBQYqetoboGhP/R6A5swJOE5hurJkK690r2rbWrh/m1Mlt7gyR3Kb3kRyHs+ZNMGH8NMNsf7aNtWb@vger.kernel.org
X-Gm-Message-State: AFuF++nQiLcdt662cO2nVdSF96C6b+d/uYQI/taqon0lY0Gb4G3PyK2E
	evqEgNbF56g0reLL6GEZpgauUr4mKjMvrMluEjjptwSTvfpXz2mFjCAltBQF0O2xB5L9ZjTXs7m
	Tk/GJ8bCu2bax2R6FkxGcG5vtpAqp10rd1Qkaye/U
X-Gm-Gg: AYBFou1se1+Iip30ry2NGfBVCn2goY8TJ320UIuGw0lpkMR0F6q+GoyN+mnUM14yik1
	ZubDBOudhVla5YXKdSvq5uRwThgjKXXLe6d4a3TcLS54N58tvFv1fx/3mTGL9XmBdqjBkK9B0mR
	gdoJFjrekGyjYIbU6pmn+eObjWrd4MFkgoSHPrLXJEEzA96HM+enTztklW6IAu57xEHri0ebHVs
	IpDtnITkJDnhPeN+GJlG2c8RTwmFFIyyCWV1VwKjsw2e26wiF+brei0KQ7LGknPc9gmVyLPRkO1
	TUEzCvPG3r9kK/0ZnWrio6pYcSfIBqx3rNUY5eTDLWR5yR+Btb0FElx2
X-Received: by 2002:a05:622a:e159:10b0:52f:9ed4:8d76 with SMTP id
 d75a77b69052e-535146449camr14146121cf.14.1791137386702; Sun, 04 Oct 2026
 11:09:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-19-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-19-a1f052500fd7@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 4 Oct 2026 11:09:35 -0700
X-Gm-Features: AclHuK-kwJ_Uo7kW-aV-ulJRzQPF_vjK2tdCaS-4gRgk6ACv9UztvH0OKE8MWEw
Message-ID: <CAJuCfpFKJ+31TZOWhwoTQTseOEy0AgAjz5eK9fdXmL40D0OY6Q@mail.gmail.com>
Subject: Re: [PATCH v4 19/38] HSI: cmt_speech: convert mmap hook to
 mmap_prepare, refactor
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

On Sat, Oct 3, 2026 at 6:39=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> Use the mmap_prepare in favour of the deprecated mmap hook as part of the
> work to convert one to another.
>
> Since this is simply a refcounted kernel page that has been allocated, it
> should not be marked VM_IO and should be inserted using the kernel page
> insertion mechanism, so convert it to do this instead.
>
> Use the VMA descriptor's private data field as a scratch buffer to store
> the page in - this stays valid throughout the kernel page mapping
> operation.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>


> ---
>  drivers/hsi/clients/cmt_speech.c | 33 +++++++++------------------------
>  1 file changed, 9 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/hsi/clients/cmt_speech.c b/drivers/hsi/clients/cmt_s=
peech.c
> index 7226677ebde7..801697b74d4f 100644
> --- a/drivers/hsi/clients/cmt_speech.c
> +++ b/drivers/hsi/clients/cmt_speech.c
> @@ -1084,22 +1084,6 @@ static void cs_hsi_stop(struct cs_hsi_iface *hi)
>         kfree(hi);
>  }
>
> -static vm_fault_t cs_char_vma_fault(struct vm_fault *vmf)
> -{
> -       struct cs_char *csdata =3D vmf->vma->vm_private_data;
> -       struct page *page;
> -
> -       page =3D virt_to_page((void *)csdata->mmap_base);
> -       get_page(page);
> -       vmf->page =3D page;
> -
> -       return 0;
> -}
> -
> -static const struct vm_operations_struct cs_char_vm_ops =3D {
> -       .fault  =3D cs_char_vma_fault,
> -};
> -
>  static int cs_char_fasync(int fd, struct file *file, int on)
>  {
>         struct cs_char *csdata =3D file->private_data;
> @@ -1256,18 +1240,19 @@ static long cs_char_ioctl(struct file *file, unsi=
gned int cmd,
>         return r;
>  }
>
> -static int cs_char_mmap(struct file *file, struct vm_area_struct *vma)
> +static int cs_char_mmap_prepare(struct vm_area_desc *desc)
>  {
> -       if (vma->vm_end < vma->vm_start)
> -               return -EINVAL;
> +       struct file *file =3D desc->file;
> +       struct cs_char *csdata =3D file->private_data;
> +       struct page **pages =3D (struct page **)&desc->private_data;
>
> -       if (vma_pages(vma) !=3D 1)
> +       if (vma_desc_pages(desc) !=3D 1)
>                 return -EINVAL;
>
> -       vm_flags_set(vma, VM_IO | VM_DONTDUMP | VM_DONTEXPAND);
> -       vma->vm_ops =3D &cs_char_vm_ops;
> -       vma->vm_private_data =3D file->private_data;
> +       vma_desc_set_flags(desc, VMA_DONTDUMP_BIT, VMA_DONTEXPAND_BIT);
>
> +       *pages =3D virt_to_page((void *)csdata->mmap_base);
> +       mmap_action_map_kernel_pages_full(desc, pages);
>         return 0;
>  }
>
> @@ -1353,7 +1338,7 @@ static const struct file_operations cs_char_fops =
=3D {
>         .write          =3D cs_char_write,
>         .poll           =3D cs_char_poll,
>         .unlocked_ioctl =3D cs_char_ioctl,
> -       .mmap           =3D cs_char_mmap,
> +       .mmap_prepare   =3D cs_char_mmap_prepare,
>         .open           =3D cs_char_open,
>         .release        =3D cs_char_release,
>         .fasync         =3D cs_char_fasync,
>
> --
> 2.55.0
>
