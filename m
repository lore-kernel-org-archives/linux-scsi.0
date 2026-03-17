Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8106C363084
	for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2026 04:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773720890; cv=pass; b=SeGR24wFY9blblPApYFFBVQQXbcN1hEh99kaTVJ1Vwkunb6SZX+0zZkMvFhJGH0chywYaOalZOYJzUxOMeDJvd0gpZVNspyT77atlT8RFfOFPPRFEfqKmCu5p7PJU5btLkYSHFbVakTnWG4HswcTNIwb1d/dSti2aDnVyT/2HMM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773720890; c=relaxed/simple;
	bh=Fvrr0zaI0ly08THfBmh2v/R4nlDTrC1pk8kMvDyKw+I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aGWu+fb+K9zfk+TMCb2qe4jB2AJ8vLEdDXIGyylv8d8KRg4v5S2pE5OL9uFkLrCiOW13JNbnIgmtjSRCYqKcxxSrKnF6HFD6gwTlhfR5j7axHh8A4qGvf64mL9uoZKrEkAipJcgcwFR1czuW/p+7TKUBh3KGenh++5yGybCET+w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o87zi913; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o87zi913"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-667365131b0so2942a12.0
        for <linux-scsi@vger.kernel.org>; Mon, 16 Mar 2026 21:14:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773720885; cv=none;
        d=google.com; s=arc-20240605;
        b=J6arrOaXIV2EF5YEidiBLDnT06120dXk9wuZvJT5TLUcLj8rSEXuesa5S0Nxhhwd58
         ZMbyo0bVM7i6BEScdO5KmSpAQ2LKWGqH3DIN9N8SpYQNzRt2YgnvN5xnkaoaLOdASgu+
         bOYYJEZwyUJ17j6+zRu/7+H7nvi+E7ixS/yBm6oPKSJbeEUDk6GIXk84OCoxxBEcMTnC
         ry7YrStXwqEOQxqEnHjoYBb/CQpEesGc+0F+OwFD3er6GVUZ4BZIlXYAOu25usqRFuJa
         bXbWULhaOD5RptJ1SrGsgntLJkqePKg2aA/+fQ7+tlyenNMxC4Xj5TIunGjKJ+XPZxfQ
         Artw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YcyQ10La7z7dBA+gaHeygI/JcZo0DlNoTa72Nf5x2Ho=;
        fh=CpU0ABvN37YMSV2Fi28lN+b35ts8pMyxEvPl1qf9xRM=;
        b=i2fLZJW1QACQa7VQkr1DW+HV3BDIpVUQW78CAIQBWsosQc8Fzz0cw1yJYFF321KjII
         fttmlsUMK4oX94SWogSelQd42ud16VFjHMNldWGZXaJvwXw4ZDSzKU/iKcE0Hu9cZM5n
         Wcpm1RLS4sg98HJrtITRVS9z2VD20aUHVh/+GKRPX3wRMiiQfF969bNSWtEqS0+zQ9Xb
         HOtGsNdoHCj1ODdJLqTAA+6YPmw3z5pR8Z6B+oGL7Ac/wmaBiZ+3wD56ZOmueBMoQsEK
         fKP6kEFfWsW1Z6nxPF8mZZlD6Pct9VeHhfQSCy2k0gZUynsFw4ZgpmmQRCkISV5WEZ7B
         Wg/g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773720885; x=1774325685; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YcyQ10La7z7dBA+gaHeygI/JcZo0DlNoTa72Nf5x2Ho=;
        b=o87zi913SkiJlLd35xRCW62iQtKKX4dCKSZ0mMjpPhKn9IuuN0Q1aunP6GJOOv2KUX
         zYvT6B11l5ZsBIObL+mJhMrb/foqBpuBA+ykfOR0Z3aiqDKjx+dn3dYTGGZ5PC904eXn
         M/bLpD4Dd+3icRhQc8otyF0qWQ/XWlOyX//52yT0+lfyWKo/PYaZ+haDRsWVWkKAZTd2
         xogARs/GzL59kDRgFmIlPLFVIGwtm1fCNlGu6q0jmtCVfALph9czgVTvk9xgx+EUV5mD
         11sksyYeSeVYWRyy9JgbXBKlNf62nj0/nnUh7TNBNvFCYcH6y9TcOpYli2avR5wU4GTD
         gbiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773720885; x=1774325685;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YcyQ10La7z7dBA+gaHeygI/JcZo0DlNoTa72Nf5x2Ho=;
        b=UuTQYhs3TA5mWVqABQqMwK8LZr5vnk7rGHTtIJvCxMhd8NZ8qBNBJbkhvxC3AYJheJ
         E3EGv+3I7fCJ/R4rnRDcbs6ansmL5g3Y4a/4AlhIG25W6EnRhJcP8BrmasN3VDX/5l4/
         GO4wNLTGhbFSBQLS0hpc0+YCQfsELi6/9kldqY21SBfP5C+AisqDe04RqVnqkiMlW858
         9zj1qfmveyqUpgHpI0vrC0NgvCA0PPek63nX7HJ55Qiy6+keJHJr1f1cPHtFuqi+ZlwH
         JPQEr2CLJit++2d0OqZqQ4SMMGRu1kBJN2+RUHFTsQvJmJbOueFl1j7xzkgZhBItC8yy
         0hnA==
X-Forwarded-Encrypted: i=1; AJvYcCWvt9Gc1zDnM/k5TopmXgGxyi9fO9Dx4qp+Cc7UOVSVX+028MNsBbhJTiv1DZwW9Q7oiyowbviv7xPJ@vger.kernel.org
X-Gm-Message-State: AOJu0YzG+JLX3NCnL+TABYS72H0WuqMdgveGQf0g7G2x5G1QYgU/OS3+
	l9y2MlDwlXrSqVa0vptk6WPIZRtnj5nbNgiryvULHNzZn1FP//jqDZh3fjCtyvz0Ye/in/XgzXx
	pTXt56hHIdyKoc0RtPn3fc4ZizUHojZZoNNWrV7ts
X-Gm-Gg: ATEYQzxFxO+j7QPUdoL0CoHx/7fP5u6ZJFUmCUij4OD91t1AkNbpd0cE9wCudp84SLa
	b5tXpFeqw9qpR1C9Hxy3g8SIozUrjp9V/mhvmOkqXLbFgrNzp8kN3NafW+yfbI4UeJStAMH9K7y
	0sIVIJr2ypvmJuI6sl7ptHMZd+lXW/d0cUTtmpmpYwmHtQ9vGjeJWJgkhK75btJPTGBN8dxiB/0
	G+aMGo5DoFAYoPHNrpH1Fkuibtwtnb7kityHUlw9Uz7npQ4NpN/B09FHMfMwehXiXPCs1BaPJWZ
	zf0y2A==
X-Received: by 2002:aa7:db43:0:b0:662:fa40:a4ab with SMTP id
 4fb4d7f45d1cf-6672c04079dmr12810a12.5.1773720884078; Mon, 16 Mar 2026
 21:14:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1773695307.git.ljs@kernel.org> <1e58aaf3cdb61cc317d890c12c9a558dfc206913.1773695307.git.ljs@kernel.org>
In-Reply-To: <1e58aaf3cdb61cc317d890c12c9a558dfc206913.1773695307.git.ljs@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 16 Mar 2026 21:14:28 -0700
X-Gm-Features: AaiRm51gRTcyoMqq_XPyOc66DyE9InTC_Zt20apDrYUnF7DiAEmv2zggrx-iJUg
Message-ID: <CAJuCfpGocCSRT0yDxPOLg2NZ+W_ZSTjHGPZRKBd3U90=sQtHCw@mail.gmail.com>
Subject: Re: [PATCH v2 06/16] mm: add mmap_action_simple_ioremap()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "K . Y . Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, Richard Weinberger <richard@nod.at>, 
	Vignesh Raghavendra <vigneshr@ti.com>, Bodo Stroesser <bostroesser@gmail.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, David Howells <dhowells@redhat.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org, 
	linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-afs@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Ryan Roberts <ryan.roberts@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 16, 2026 at 2:13=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> Currently drivers use vm_iomap_memory() as a simple helper function for
> I/O remapping memory over a range starting at a specified physical addres=
s
> over a specified length.
>
> In order to utilise this from mmap_prepare, separate out the core logic
> into __simple_ioremap_prep(), update vm_iomap_memory() to use it, and add
> simple_ioremap_prepare() to do the same with a VMA descriptor object.
>
> We also add MMAP_SIMPLE_IO_REMAP and relevant fields to the struct
> mmap_action type to permit this operation also.
>
> We use mmap_action_ioremap() to set up the actual I/O remap operation onc=
e
> we have checked and figured out the parameters, which makes
> simple_ioremap_prepare() easy to implement.
>
> We then add mmap_action_simple_ioremap() to allow drivers to make use of
> this mode.
>
> We update the mmap_prepare documentation to describe this mode.
>
> Finally, we update the VMA tests to reflect this change.
>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

A couple of nits, but otherwise LGTM.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  Documentation/filesystems/mmap_prepare.rst |  3 +
>  include/linux/mm.h                         | 24 +++++-
>  include/linux/mm_types.h                   |  6 +-
>  mm/internal.h                              |  2 +
>  mm/memory.c                                | 87 +++++++++++++++-------
>  mm/util.c                                  | 12 +++
>  tools/testing/vma/include/dup.h            |  6 +-
>  7 files changed, 112 insertions(+), 28 deletions(-)
>
> diff --git a/Documentation/filesystems/mmap_prepare.rst b/Documentation/f=
ilesystems/mmap_prepare.rst
> index 20db474915da..be76ae475b9c 100644
> --- a/Documentation/filesystems/mmap_prepare.rst
> +++ b/Documentation/filesystems/mmap_prepare.rst
> @@ -153,5 +153,8 @@ pointer. These are:
>  * mmap_action_ioremap_full() - Same as mmap_action_ioremap(), only remap=
s
>    the entire mapping from ``start_pfn`` onward.
>
> +* mmap_action_simple_ioremap() - Sets up an I/O remap from a specified
> +  physical address and over a specified length.
> +
>  **NOTE:** The ``action`` field should never normally be manipulated dire=
ctly,
>  rather you ought to use one of these helpers.
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index ad1b8c3c0cfd..df8fa6e6402b 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4337,11 +4337,33 @@ static inline void mmap_action_ioremap(struct vm_=
area_desc *desc,
>   * @start_pfn: The first PFN in the range to remap.
>   */
>  static inline void mmap_action_ioremap_full(struct vm_area_desc *desc,
> -                                         unsigned long start_pfn)
> +                                           unsigned long start_pfn)
>  {
>         mmap_action_ioremap(desc, desc->start, start_pfn, vma_desc_size(d=
esc));
>  }
>
> +/**
> + * mmap_action_simple_ioremap - helper for mmap_prepare hook to specify =
that the
> + * physical range in [start_phys_addr, start_phys_addr + size) should be=
 I/O
> + * remapped.
> + * @desc: The VMA descriptor for the VMA requiring remap.
> + * @start_phys_addr: Start of the physical memory to be mapped.
> + * @size: Size of the area to map.
> + *
> + * NOTE: Some drivers might want to tweak desc->page_prot for purposes o=
f
> + * write-combine or similar.
> + */
> +static inline void mmap_action_simple_ioremap(struct vm_area_desc *desc,
> +                                             phys_addr_t start_phys_addr=
,
> +                                             unsigned long size)
> +{
> +       struct mmap_action *action =3D &desc->action;
> +
> +       action->simple_ioremap.start_phys_addr =3D start_phys_addr;
> +       action->simple_ioremap.size =3D size;
> +       action->type =3D MMAP_SIMPLE_IO_REMAP;
> +}
> +
>  int mmap_action_prepare(struct vm_area_desc *desc);
>  int mmap_action_complete(struct vm_area_struct *vma,
>                          struct mmap_action *action);
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 4a229cc0a06b..50685cf29792 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -814,6 +814,7 @@ enum mmap_action_type {
>         MMAP_NOTHING,           /* Mapping is complete, no further action=
. */
>         MMAP_REMAP_PFN,         /* Remap PFN range. */
>         MMAP_IO_REMAP_PFN,      /* I/O remap PFN range. */
> +       MMAP_SIMPLE_IO_REMAP,   /* I/O remap with guardrails. */
>  };
>
>  /*
> @@ -822,13 +823,16 @@ enum mmap_action_type {
>   */
>  struct mmap_action {
>         union {
> -               /* Remap range. */
>                 struct {
>                         unsigned long start;
>                         unsigned long start_pfn;
>                         unsigned long size;
>                         pgprot_t pgprot;
>                 } remap;
> +               struct {
> +                       phys_addr_t start_phys_addr;
> +                       unsigned long size;
> +               } simple_ioremap;
>         };
>         enum mmap_action_type type;
>
> diff --git a/mm/internal.h b/mm/internal.h
> index f5774892071e..0eaca2f0eb6a 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1804,6 +1804,8 @@ int dup_mmap(struct mm_struct *mm, struct mm_struct=
 *oldmm);
>  int remap_pfn_range_prepare(struct vm_area_desc *desc);
>  int remap_pfn_range_complete(struct vm_area_struct *vma,
>                              struct mmap_action *action);
> +int simple_ioremap_prepare(struct vm_area_desc *desc);
> +/* No simple_ioremap_complete, is ultimately handled by remap complete. =
*/
>
>  static inline int io_remap_pfn_range_prepare(struct vm_area_desc *desc)
>  {
> diff --git a/mm/memory.c b/mm/memory.c
> index 9dec67a18116..f3f4046aee97 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3170,6 +3170,59 @@ int remap_pfn_range_complete(struct vm_area_struct=
 *vma,
>         return do_remap_pfn_range(vma, start, pfn, size, prot);
>  }
>
> +static int __simple_ioremap_prep(unsigned long vm_start, unsigned long v=
m_end,

nit: vm_start and vm_end are used only to calculate vm_len. You could
reduce the number of arguments by just passing vm_len.

> +                                pgoff_t vm_pgoff, phys_addr_t start_phys=
,
> +                                unsigned long size, unsigned long *pfnp)
> +{
> +       const unsigned long vm_len =3D vm_end - vm_start;
> +       unsigned long pfn, pages;
> +
> +       /* Check that the physical memory area passed in looks valid */
> +       if (start_phys + size < start_phys)
> +               return -EINVAL;
> +       /*
> +        * You *really* shouldn't map things that aren't page-aligned,
> +        * but we've historically allowed it because IO memory might
> +        * just have smaller alignment.
> +        */
> +       size +=3D start_phys & ~PAGE_MASK;
> +       pfn =3D start_phys >> PAGE_SHIFT;
> +       pages =3D (size + ~PAGE_MASK) >> PAGE_SHIFT;
> +       if (pfn + pages < pfn)
> +               return -EINVAL;
> +
> +       /* We start the mapping 'vm_pgoff' pages into the area */
> +       if (vm_pgoff > pages)
> +               return -EINVAL;
> +       pfn +=3D vm_pgoff;
> +       pages -=3D vm_pgoff;
> +
> +       /* Can we fit all of the mapping? */
> +       if ((vm_len >> PAGE_SHIFT) > pages)
> +               return -EINVAL;
> +
> +       *pfnp =3D pfn;
> +       return 0;
> +}
> +
> +int simple_ioremap_prepare(struct vm_area_desc *desc)
> +{
> +       struct mmap_action *action =3D &desc->action;
> +       const phys_addr_t start =3D action->simple_ioremap.start_phys_add=
r;
> +       const unsigned long size =3D action->simple_ioremap.size;
> +       unsigned long pfn;
> +       int err;
> +
> +       err =3D __simple_ioremap_prep(desc->start, desc->end, desc->pgoff=
,
> +                                   start, size, &pfn);
> +       if (err)
> +               return err;
> +
> +       /* The I/O remap logic does the heavy lifting. */
> +       mmap_action_ioremap(desc, desc->start, pfn, vma_desc_size(desc));

nit: Looks like a perfect opportunity to use mmap_action_ioremap_full() her=
e.

> +       return mmap_action_prepare(desc);

Ok, so IIUC this uses recursion:
mmap_action_prepare(MMAP_SIMPLE_IO_REMAP) -> simple_ioremap_prepare()
-> mmap_action_prepare(MMAP_IO_REMAP_PFN).

> +}
> +
>  /**
>   * vm_iomap_memory - remap memory to userspace
>   * @vma: user vma to map to
> @@ -3187,32 +3240,16 @@ int remap_pfn_range_complete(struct vm_area_struc=
t *vma,
>   */
>  int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsig=
ned long len)
>  {
> -       unsigned long vm_len, pfn, pages;
> -
> -       /* Check that the physical memory area passed in looks valid */
> -       if (start + len < start)
> -               return -EINVAL;
> -       /*
> -        * You *really* shouldn't map things that aren't page-aligned,
> -        * but we've historically allowed it because IO memory might
> -        * just have smaller alignment.
> -        */
> -       len +=3D start & ~PAGE_MASK;
> -       pfn =3D start >> PAGE_SHIFT;
> -       pages =3D (len + ~PAGE_MASK) >> PAGE_SHIFT;
> -       if (pfn + pages < pfn)
> -               return -EINVAL;
> -
> -       /* We start the mapping 'vm_pgoff' pages into the area */
> -       if (vma->vm_pgoff > pages)
> -               return -EINVAL;
> -       pfn +=3D vma->vm_pgoff;
> -       pages -=3D vma->vm_pgoff;
> +       const unsigned long vm_start =3D vma->vm_start;
> +       const unsigned long vm_end =3D vma->vm_end;
> +       const unsigned long vm_len =3D vm_end - vm_start;
> +       unsigned long pfn;
> +       int err;
>
> -       /* Can we fit all of the mapping? */
> -       vm_len =3D vma->vm_end - vma->vm_start;
> -       if (vm_len >> PAGE_SHIFT > pages)
> -               return -EINVAL;
> +       err =3D __simple_ioremap_prep(vm_start, vm_end, vma->vm_pgoff, st=
art,
> +                                   len, &pfn);
> +       if (err)
> +               return err;
>
>         /* Ok, let it rip */
>         return io_remap_pfn_range(vma, vma->vm_start, pfn, vm_len, vma->v=
m_page_prot);
> diff --git a/mm/util.c b/mm/util.c
> index cdfba09e50d7..aa92e471afe1 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1390,6 +1390,8 @@ int mmap_action_prepare(struct vm_area_desc *desc)
>                 return remap_pfn_range_prepare(desc);
>         case MMAP_IO_REMAP_PFN:
>                 return io_remap_pfn_range_prepare(desc);
> +       case MMAP_SIMPLE_IO_REMAP:
> +               return simple_ioremap_prepare(desc);
>         }
>
>         WARN_ON_ONCE(1);
> @@ -1421,6 +1423,14 @@ int mmap_action_complete(struct vm_area_struct *vm=
a,
>         case MMAP_IO_REMAP_PFN:
>                 err =3D io_remap_pfn_range_complete(vma, action);
>                 break;
> +       case MMAP_SIMPLE_IO_REMAP:
> +               /*
> +                * The simple I/O remap should have been delegated to an =
I/O
> +                * remap.
> +                */
> +               WARN_ON_ONCE(1);
> +               err =3D -EINVAL;
> +               break;
>         }
>
>         return mmap_action_finish(vma, action, err);
> @@ -1434,6 +1444,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
>                 break;
>         case MMAP_REMAP_PFN:
>         case MMAP_IO_REMAP_PFN:
> +       case MMAP_SIMPLE_IO_REMAP:
>                 WARN_ON_ONCE(1); /* nommu cannot handle these. */
>                 break;
>         }
> @@ -1452,6 +1463,7 @@ int mmap_action_complete(struct vm_area_struct *vma=
,
>                 break;
>         case MMAP_REMAP_PFN:
>         case MMAP_IO_REMAP_PFN:
> +       case MMAP_SIMPLE_IO_REMAP:
>                 WARN_ON_ONCE(1); /* nommu cannot handle this. */
>
>                 err =3D -EINVAL;
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/=
dup.h
> index 4570ec77f153..114daaef4f73 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -453,6 +453,7 @@ enum mmap_action_type {
>         MMAP_NOTHING,           /* Mapping is complete, no further action=
. */
>         MMAP_REMAP_PFN,         /* Remap PFN range. */
>         MMAP_IO_REMAP_PFN,      /* I/O remap PFN range. */
> +       MMAP_SIMPLE_IO_REMAP,   /* I/O remap with guardrails. */
>  };
>
>  /*
> @@ -461,13 +462,16 @@ enum mmap_action_type {
>   */
>  struct mmap_action {
>         union {
> -               /* Remap range. */
>                 struct {
>                         unsigned long start;
>                         unsigned long start_pfn;
>                         unsigned long size;
>                         pgprot_t pgprot;
>                 } remap;
> +               struct {
> +                       phys_addr_t start;
> +                       unsigned long len;
> +               } simple_ioremap;
>         };
>         enum mmap_action_type type;
>
> --
> 2.53.0
>
