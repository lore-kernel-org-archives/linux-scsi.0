Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE7024A078
	for <linux-scsi@vger.kernel.org>; Mon, 16 Mar 2026 02:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773627533; cv=pass; b=WcUqCFoLz+4l2oRWsum9ovEkypcmENkB3v0KixHKJYUHGEbigZ4TR64M1rT9LJZvytxTCk1k6JDRLglWkxfDc0rJww9skTG7LIeVdJT3oIvdK7knsIM6E8cLRl8XCYTmj1mKYRYdQojH6+3cmtQSvtuCCDMwnR9f0Ua/MitMo1Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773627533; c=relaxed/simple;
	bh=/UbTJeagNQInbFWy0pIUN/HhAyZA5x422F9e6lwoLuI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n30SXWM69KqWemmVLcdZ8ZnsbnYD6Fleqvo9fWC5lbmLLbO4lBz2y2EjWd9IteVELdnLFF1fkP3m7flLpjj0oHGxhIDOlmymquB4sLkHuFBj+FKKFGkX1SfLr7L4+RiUbECaJXK1MRKQ4smX9iZQeM8HH2KW8a9dgCCNuewzTw8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uVtN5Zyq; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uVtN5Zyq"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-509069a7a7fso801661cf.0
        for <linux-scsi@vger.kernel.org>; Sun, 15 Mar 2026 19:18:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773627530; cv=none;
        d=google.com; s=arc-20240605;
        b=a7k5MpCrogUxpJMo64XS+3B0wxu0W/LGkwrkeIARQl7LutxfTiTAlm6NG14RBqzziu
         USlx8mZpCkh9ySa4lEsy5L9UUdAdIvA3x2poMqCFXjcwbCTmGo3YmZ7z+KxBfYFy/7bb
         YKgwtCYEpRqL/1cK9BnnH206NkuGlPy367/6rYzQtImbf1MAkGkuzypHhrp9WgxbL0oU
         Uf1OByx+32TdvfuJ0tyBRmL5eQSfLHHnWdTbSj+/PsBwWpsOrwegIL4RqoH0arPDLT/X
         r11Ad9+rD2oD50VCjPCxUVVCuF3vyb+9b/I5iOVe8IqhtC5H+xvcJ8lH23G+sfsvexPh
         vNkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dnWGu44tSbdw9jKt/jasKkcuK6YSxM7E/Q2BjBYPLWs=;
        fh=1V4A2ULnKrwGhkk4rNml4DMTqdLJ6MPICxUExxpe+Gg=;
        b=DIm0o703Zqw47S2CCnIj11IaG/HCmqI+v6kMH+0yyuX4/Jq/hzs8DmjkAo9G6t29Wm
         jyLTHUjj/IuU2FARu7WAFqfh7+TAZlc0vbOMD/EfUMXEx0NVnAtvF/y7xPKF6HgFsZST
         pU0lireLu2o8d/jnbr5agbWh9WyWjrgMcOndknLzmh+ztFeOZJ6J1s276CnpErP11/Wp
         nsKWi6d3LLaXkEcWHEvrx6SftahEVF+yUaYw5JtCNc+zQ/v2fUDOVxagXS5ahV0rrcHa
         zCHgZK+W/kCdH5ibyMQbNZgfMiBDA2wzzedCviv7CNh9vrUIxyqpqG+eoR5R+ZmYHkLO
         ByEw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773627530; x=1774232330; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dnWGu44tSbdw9jKt/jasKkcuK6YSxM7E/Q2BjBYPLWs=;
        b=uVtN5ZyqvAJlVnn+4NnVNg1IaIGcorsAsoTCrA+S3dgcJj7sXqibaJWouAsjEOHCLM
         3i6XDoKdXhviOR8IK0QDsNFi00rvfkm1OM3A9leIQ5Z3tQA/ArY2RHdIL7extic6K9Qm
         AqY2iz5oQMNlBuzk0COCrQMJCGKOdFcR/Xeb8EhntxO5jYfiXuV2xB1OSeN0NDw5iFuX
         cmANuaVE98msZp0e6fBWxjikQMzqHbLElvGxwM6YL+lXvxOnKOrMuQ242VSsr/tcy7Bt
         dkGh2mLq1RMe6HIL47+QvLnl8xQrA45Xu1rtf+Ij/4pXaaZTFBrpLQWPS/zCS3ZRaF2y
         dSOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773627530; x=1774232330;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dnWGu44tSbdw9jKt/jasKkcuK6YSxM7E/Q2BjBYPLWs=;
        b=pRsIq8g9370PiIfHQ/15fSZF+VzX+TSucwjGRgruJqY6AOFE3Uw3z2f47SSk3ug9tC
         fdi+L5yxnO6oUGcUzK08KIEN915KTVd+jikneseAJtIcUuHJrc7UyDZAhWCjj/ArULds
         H7gndcLdNwSoYW5L7qq2kHolCmdVtVXXIAmw4v4qN6Eu730O84oEPz27JgZQVWymVtrJ
         J++DcUp7LaKtzg4FUalqNSNGT6JLuBTkA8aFFM5Ej5BRMVxM8tJBJl45pBHGew3pBP9F
         dJlGOgYS9+0NDjYTPcqN/tdO9Xuy7X3Quz8UImVmhF9+i5R6UQuc2Uv/ZOQQYfrSY09L
         kalA==
X-Forwarded-Encrypted: i=1; AJvYcCXc7APUHDj3HmgQWzRyl5kFbhWklcKSYQKGMOoBk5Slrjvbx6gdez6A6o4vZUBFDF0cP8nKZHKFZTeM@vger.kernel.org
X-Gm-Message-State: AOJu0YxL8Hogdu9BGnhtIkUf3DVsoQaDJeRYGLiV94ugYCKplXymESza
	VISpLqlov8fAUZ71KmuQ+fnCZ6jsVjkUCrS/U0OkAiwDaZ97uICdtPIJkTqea8SVPvoTjQA1oIt
	YJdg/TERyRWXgUZ8fqIm+OT+egPSZBxZdSVVXKiHm
X-Gm-Gg: ATEYQzxUz94d+7pXRVmXmVHNflckH5oA6Kz50GCHCUnAQmzDdhyI/XXEap7McCHzdWp
	wnmJpoVyA8NCgVyc7NI5iiiZecKjCIe5KEJqNX2L8Ne1cSfFVbb/pTdMguhvxIyjr37r3E1kcan
	NKApIuIJ0EWk89P7MJizVPThGLSInYeSP5oSuqSuxNRwvfK1sITa5t9dcEucTAEtcBeg8pdHE/u
	3vDTrE48DHljJ/ZhXpJ+YKV71BwTHvs22urKPGda4fko70oWs9IzTXeDEqZy/2GVpK4B4EHhh8K
	CKYrrg==
X-Received: by 2002:a05:622a:34d:b0:506:9852:75ec with SMTP id
 d75a77b69052e-5096a9f1e28mr18574031cf.9.1773627529027; Sun, 15 Mar 2026
 19:18:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0e0fe47852e6009f662b1fa42f836447b8d1283a.1773346620.git.ljs@kernel.org>
 <20260313110238.2500603-1-usama.arif@linux.dev> <24cbbaf6-19f2-4403-8cb7-415007597345@lucifer.local>
In-Reply-To: <24cbbaf6-19f2-4403-8cb7-415007597345@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 15 Mar 2026 19:18:38 -0700
X-Gm-Features: AaiRm510xG9rdMA-1YX4TcP6jNn-n0Y2wP6jWBejCDuFUbPHH2dWyPV1sklVvuE
Message-ID: <CAJuCfpH1gzi50aWni7rh9=2gM8WwCzm=fY14DCFbjweAq82i6Q@mail.gmail.com>
Subject: Re: [PATCH 04/15] mm: add vm_ops->mapped hook
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
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

On Fri, Mar 13, 2026 at 4:58=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> On Fri, Mar 13, 2026 at 04:02:36AM -0700, Usama Arif wrote:
> > On Thu, 12 Mar 2026 20:27:19 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kern=
el.org> wrote:
> >
> > > Previously, when a driver needed to do something like establish a ref=
erence
> > > count, it could do so in the mmap hook in the knowledge that the mapp=
ing
> > > would succeed.
> > >
> > > With the introduction of f_op->mmap_prepare this is no longer the cas=
e, as
> > > it is invoked prior to actually establishing the mapping.
> > >
> > > To take this into account, introduce a new vm_ops->mapped callback wh=
ich is
> > > invoked when the VMA is first mapped (though notably - not when it is
> > > merged - which is correct and mirrors existing mmap/open/close behavi=
our).
> > >
> > > We do better that vm_ops->open() here, as this callback can return an
> > > error, at which point the VMA will be unmapped.
> > >
> > > Note that vm_ops->mapped() is invoked after any mmap action is
> > > complete (such as I/O remapping).
> > >
> > > We intentionally do not expose the VMA at this point, exposing only t=
he
> > > fields that could be used, and an output parameter in case the operat=
ion
> > > needs to update the vma->vm_private_data field.
> > >
> > > In order to deal with stacked filesystems which invoke inner filesyst=
em's
> > > mmap() invocations, add __compat_vma_mapped() and invoke it on
> > > vfs_mmap() (via compat_vma_mmap()) to ensure that the mapped callback=
 is
> > > handled when an mmap() caller invokes a nested filesystem's mmap_prep=
are()
> > > callback.
> > >
> > > We can now also remove call_action_complete() and invoke
> > > mmap_action_complete() directly, as we separate out the rmap lock log=
ic to
> > > be called in __mmap_region() instead via maybe_drop_file_rmap_lock().
> > >
> > > We also abstract unmapping of a VMA on mmap action completion into it=
s own
> > > helper function, unmap_vma_locked().
> > >
> > > Additionally, update VMA userland test headers to reflect the change.
> > >
> > > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > > ---
> > >  include/linux/fs.h              |  9 +++-
> > >  include/linux/mm.h              | 17 +++++++
> > >  mm/internal.h                   | 10 ++++
> > >  mm/util.c                       | 86 ++++++++++++++++++++++++-------=
--
> > >  mm/vma.c                        | 41 +++++++++++-----
> > >  tools/testing/vma/include/dup.h | 34 ++++++++++++-
> > >  6 files changed, 158 insertions(+), 39 deletions(-)
> > >
> > > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > > index a2628a12bd2b..c390f5c667e3 100644
> > > --- a/include/linux/fs.h
> > > +++ b/include/linux/fs.h
> > > @@ -2059,13 +2059,20 @@ static inline bool can_mmap_file(struct file =
*file)
> > >  }
> > >
> > >  int compat_vma_mmap(struct file *file, struct vm_area_struct *vma);
> > > +int __vma_check_mmap_hook(struct vm_area_struct *vma);
> > >
> > >  static inline int vfs_mmap(struct file *file, struct vm_area_struct =
*vma)
> > >  {
> > > +   int err;
> > > +
> > >     if (file->f_op->mmap_prepare)
> > >             return compat_vma_mmap(file, vma);
> > >
> > > -   return file->f_op->mmap(file, vma);
> > > +   err =3D file->f_op->mmap(file, vma);
> > > +   if (err)
> > > +           return err;
> > > +
> > > +   return __vma_check_mmap_hook(vma);
> > >  }
> > >
> > >  static inline int vfs_mmap_prepare(struct file *file, struct vm_area=
_desc *desc)
> > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > index 12a0b4c63736..7333d5db1221 100644
> > > --- a/include/linux/mm.h
> > > +++ b/include/linux/mm.h
> > > @@ -759,6 +759,23 @@ struct vm_operations_struct {
> > >      * Context: User context.  May sleep.  Caller holds mmap_lock.
> > >      */
> > >     void (*close)(struct vm_area_struct *vma);
> > > +   /**
> > > +    * @mapped: Called when the VMA is first mapped in the MM. Not ca=
lled if
> > > +    * the new VMA is merged with an adjacent VMA.
> > > +    *
> > > +    * The @vm_private_data field is an output field allowing the use=
r to
> > > +    * modify vma->vm_private_data as necessary.
> > > +    *
> > > +    * ONLY valid if set from f_op->mmap_prepare. Will result in an e=
rror if
> > > +    * set from f_op->mmap.
> > > +    *
> > > +    * Returns %0 on success, or an error otherwise. On error, the VM=
A will
> > > +    * be unmapped.
> > > +    *
> > > +    * Context: User context.  May sleep.  Caller holds mmap_lock.
> > > +    */
> > > +   int (*mapped)(unsigned long start, unsigned long end, pgoff_t pgo=
ff,
> > > +                 const struct file *file, void **vm_private_data);
> > >     /* Called any time before splitting to check if it's allowed */
> > >     int (*may_split)(struct vm_area_struct *vma, unsigned long addr);
> > >     int (*mremap)(struct vm_area_struct *vma);
> > > diff --git a/mm/internal.h b/mm/internal.h
> > > index 7bfa85b5e78b..f0f2cf1caa36 100644
> > > --- a/mm/internal.h
> > > +++ b/mm/internal.h
> > > @@ -158,6 +158,8 @@ static inline void *folio_raw_mapping(const struc=
t folio *folio)
> > >   * mmap hook and safely handle error conditions. On error, VMA hooks=
 will be
> > >   * mutated.
> > >   *
> > > + * IMPORTANT: f_op->mmap() is deprecated, prefer f_op->mmap_prepare(=
).
> > > + *

What exactly would one do to "prefer f_op->mmap_prepare()"?
Since you are adding this comment for mmap_file(), I think you need to
describe more specifically what one should call instead.

> > >   * @file: File which backs the mapping.
> > >   * @vma:  VMA which we are mapping.
> > >   *
> > > @@ -201,6 +203,14 @@ static inline void vma_close(struct vm_area_stru=
ct *vma)
> > >  /* unmap_vmas is in mm/memory.c */
> > >  void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap);
> > >
> > > +static inline void unmap_vma_locked(struct vm_area_struct *vma)
> > > +{
> > > +   const size_t len =3D vma_pages(vma) << PAGE_SHIFT;
> > > +
> > > +   mmap_assert_locked(vma->vm_mm);

You must hold the mmap write lock when unmapping. Would be better to
assert mmap_assert_write_locked() or even vma_assert_write_locked(),
which implies mmap_assert_write_locked().

> > > +   do_munmap(vma->vm_mm, vma->vm_start, len, NULL);
> > > +}
> > > +
> > >  #ifdef CONFIG_MMU
> > >
> > >  static inline void get_anon_vma(struct anon_vma *anon_vma)
> > > diff --git a/mm/util.c b/mm/util.c
> > > index dba1191725b6..2b0ed54008d6 100644
> > > --- a/mm/util.c
> > > +++ b/mm/util.c
> > > @@ -1163,6 +1163,55 @@ void flush_dcache_folio(struct folio *folio)
> > >  EXPORT_SYMBOL(flush_dcache_folio);
> > >  #endif
> > >
> > > +static int __compat_vma_mmap(struct file *file, struct vm_area_struc=
t *vma)
> > > +{
> > > +   struct vm_area_desc desc =3D {
> > > +           .mm =3D vma->vm_mm,
> > > +           .file =3D file,
> > > +           .start =3D vma->vm_start,
> > > +           .end =3D vma->vm_end,
> > > +
> > > +           .pgoff =3D vma->vm_pgoff,
> > > +           .vm_file =3D vma->vm_file,
> > > +           .vma_flags =3D vma->flags,
> > > +           .page_prot =3D vma->vm_page_prot,
> > > +
> > > +           .action.type =3D MMAP_NOTHING, /* Default */
> > > +   };
> > > +   int err;
> > > +
> > > +   err =3D vfs_mmap_prepare(file, &desc);
> > > +   if (err)
> > > +           return err;
> > > +
> > > +   err =3D mmap_action_prepare(&desc, &desc.action);
> > > +   if (err)
> > > +           return err;
> > > +
> > > +   set_vma_from_desc(vma, &desc);
> > > +   return mmap_action_complete(vma, &desc.action);
> > > +}
> > > +
> > > +static int __compat_vma_mapped(struct file *file, struct vm_area_str=
uct *vma)
> > > +{
> > > +   const struct vm_operations_struct *vm_ops =3D vma->vm_ops;
> > > +   void *vm_private_data =3D vma->vm_private_data;
> > > +   int err;
> > > +
> > > +   if (!vm_ops->mapped)
> > > +           return 0;
> > > +
> >
> > Hello!
> >
> > Can vm_ops be NULL here?  __compat_vma_mapped() is called from
> > compat_vma_mmap(), which is reached when a filesystem provides
> > mmap_prepare.  If the mmap_prepare hook does not set desc->vm_ops,
> > vma->vm_ops will be NULL and this dereferences a NULL pointer.
>
> I _think_ for this to ever be invoked, you would need to be dealing with =
a
> file-backed VMA so vm_ops->fault would HAVE to be defined.
>
> But you're right anyway as a matter of principle we should check it! Will=
 fix.
>
> >
> > For e.g. drivers/char/mem.c, mmap_zero_prepare() would trigger
> > a NULL pointer dereference here.
> >
> > Would need to do
> >       if (!vm_ops || !vm_ops->mapped)
> >               return 0;
> >
> > here
>
> Yes.
>
> >
> >
> > > +   err =3D vm_ops->mapped(vma->vm_start, vma->vm_end, vma->vm_pgoff,=
 file,
> > > +                        &vm_private_data);
> > > +   if (err)
> > > +           unmap_vma_locked(vma);
> >
> > when mapped() returns an error, unmap_vma_locked(vma) is called
> > but execution continues into the vm_private_data update below.  After
> > unmap_vma_locked() the VMA may be freed (do_munmap can remove the VMA
> > entirely), so accessing vma->vm_private_data after that is a
> > use-after-free.
>
> Very good point :) will fix thanks!
>
> Probably:
>
>         if (err)
>                 unmap_vma_locked(vma);
>         else if (vm_private_data !=3D vma->vm_private_data)
>                 vma->vm_private_data =3D vm_private_data;
>
>         return err;
>
> Would be fine.
>
> >
> > Probably need to do:
> >       if (err) {
> >               unmap_vma_locked(vma);
> >               return err;
> >       }
> >
> > > +   /* Update private data if changed. */
> > > +   if (vm_private_data !=3D vma->vm_private_data)
> > > +           vma->vm_private_data =3D vm_private_data;
> > > +
> > > +   return err;
> > > +}
> > > +
> > >  /**
> > >   * compat_vma_mmap() - Apply the file's .mmap_prepare() hook to an
> > >   * existing VMA and execute any requested actions.
> > > @@ -1191,34 +1240,26 @@ EXPORT_SYMBOL(flush_dcache_folio);
> > >   */
> > >  int compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
> > >  {
> > > -   struct vm_area_desc desc =3D {
> > > -           .mm =3D vma->vm_mm,
> > > -           .file =3D file,
> > > -           .start =3D vma->vm_start,
> > > -           .end =3D vma->vm_end,
> > > -
> > > -           .pgoff =3D vma->vm_pgoff,
> > > -           .vm_file =3D vma->vm_file,
> > > -           .vma_flags =3D vma->flags,
> > > -           .page_prot =3D vma->vm_page_prot,
> > > -
> > > -           .action.type =3D MMAP_NOTHING, /* Default */
> > > -   };
> > >     int err;
> > >
> > > -   err =3D vfs_mmap_prepare(file, &desc);
> > > -   if (err)
> > > -           return err;
> > > -
> > > -   err =3D mmap_action_prepare(&desc, &desc.action);
> > > +   err =3D __compat_vma_mmap(file, vma);
> > >     if (err)
> > >             return err;
> > >
> > > -   set_vma_from_desc(vma, &desc);
> > > -   return mmap_action_complete(vma, &desc.action);
> > > +   return __compat_vma_mapped(file, vma);
> > >  }
> > >  EXPORT_SYMBOL(compat_vma_mmap);
> > >
> > > +int __vma_check_mmap_hook(struct vm_area_struct *vma)
> > > +{
> > > +   /* vm_ops->mapped is not valid if mmap() is specified. */
> > > +   if (WARN_ON_ONCE(vma->vm_ops->mapped))
> > > +           return -EINVAL;
> >
> > I think vma->vm_ops can be NULL here. Should be:
> >
> >       if (vma->vm_ops && WARN_ON_ONCE(vma->vm_ops->mapped))
> >               return -EINVAL;
>
> I think again you'd probably only invoke this on file-backed so be ok, bu=
t again
> as a matter of principle we should check it so will fix, thanks!
>
> >
> > > +
> > > +   return 0;
> > > +}
> > > +EXPORT_SYMBOL(__vma_check_mmap_hook);

nit: Any reason __vma_check_mmap_hook() is not inlined next to its
user vfs_mmap()?

> > > +
> > >  static void set_ps_flags(struct page_snapshot *ps, const struct foli=
o *folio,
> > >                      const struct page *page)
> > >  {
> > > @@ -1316,10 +1357,7 @@ static int mmap_action_finish(struct vm_area_s=
truct *vma,
> > >      * invoked if we do NOT merge, so we only clean up the VMA we cre=
ated.
> > >      */
> > >     if (err) {
> > > -           const size_t len =3D vma_pages(vma) << PAGE_SHIFT;
> > > -
> > > -           do_munmap(current->mm, vma->vm_start, len, NULL);
> > > -
> > > +           unmap_vma_locked(vma);
> > >             if (action->error_hook) {
> > >                     /* We may want to filter the error. */
> > >                     err =3D action->error_hook(err);
> > > diff --git a/mm/vma.c b/mm/vma.c
> > > index 054cf1d262fb..ef9f5a5365d1 100644
> > > --- a/mm/vma.c
> > > +++ b/mm/vma.c
> > > @@ -2705,21 +2705,35 @@ static bool can_set_ksm_flags_early(struct mm=
ap_state *map)
> > >     return false;
> > >  }
> > >
> > > -static int call_action_complete(struct mmap_state *map,
> > > -                           struct mmap_action *action,
> > > -                           struct vm_area_struct *vma)
> > > +static int call_mapped_hook(struct vm_area_struct *vma)
> > >  {
> > > -   int ret;
> > > +   const struct vm_operations_struct *vm_ops =3D vma->vm_ops;
> > > +   void *vm_private_data =3D vma->vm_private_data;
> > > +   int err;
> > >
> > > -   ret =3D mmap_action_complete(vma, action);
> > > +   if (!vm_ops || !vm_ops->mapped)
> > > +           return 0;
> > > +   err =3D vm_ops->mapped(vma->vm_start, vma->vm_end, vma->vm_pgoff,
> > > +                        vma->vm_file, &vm_private_data);
> > > +   if (err) {
> > > +           unmap_vma_locked(vma);
> > > +           return err;
> > > +   }
> > > +   /* Update private data if changed. */
> > > +   if (vm_private_data !=3D vma->vm_private_data)
> > > +           vma->vm_private_data =3D vm_private_data;
> > > +   return 0;
> > > +}
> > >
> > > -   /* If we held the file rmap we need to release it. */
> > > -   if (map->hold_file_rmap_lock) {
> > > -           struct file *file =3D vma->vm_file;
> > > +static void maybe_drop_file_rmap_lock(struct mmap_state *map,
> > > +                                 struct vm_area_struct *vma)
> > > +{
> > > +   struct file *file;
> > >
> > > -           i_mmap_unlock_write(file->f_mapping);
> > > -   }
> > > -   return ret;
> > > +   if (!map->hold_file_rmap_lock)
> > > +           return;
> > > +   file =3D vma->vm_file;
> > > +   i_mmap_unlock_write(file->f_mapping);
> > >  }
> > >
> > >  static unsigned long __mmap_region(struct file *file, unsigned long =
addr,
> > > @@ -2773,8 +2787,11 @@ static unsigned long __mmap_region(struct file=
 *file, unsigned long addr,
> > >     __mmap_complete(&map, vma);
> > >
> > >     if (have_mmap_prepare && allocated_new) {
> > > -           error =3D call_action_complete(&map, &desc.action, vma);
> > > +           error =3D mmap_action_complete(vma, &desc.action);
> > > +           if (!error)
> > > +                   error =3D call_mapped_hook(vma);
> > >
> > > +           maybe_drop_file_rmap_lock(&map, vma);
> > >             if (error)
> > >                     return error;
> > >     }
> > > diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/incl=
ude/dup.h
> > > index 908beb263307..47d8db809f31 100644
> > > --- a/tools/testing/vma/include/dup.h
> > > +++ b/tools/testing/vma/include/dup.h
> > > @@ -606,12 +606,34 @@ struct vm_area_struct {
> > >  } __randomize_layout;
> > >
> > >  struct vm_operations_struct {
> > > -   void (*open)(struct vm_area_struct * area);
> > > +   /**
> > > +    * @open: Called when a VMA is remapped or split. Not called upon=
 first
> > > +    * mapping a VMA.
> > > +    * Context: User context.  May sleep.  Caller holds mmap_lock.
> > > +    */

This comment should have been introduced in the previous patch.

> > > +   void (*open)(struct vm_area_struct *vma);
> > >     /**
> > >      * @close: Called when the VMA is being removed from the MM.
> > >      * Context: User context.  May sleep.  Caller holds mmap_lock.
> > >      */
> > > -   void (*close)(struct vm_area_struct * area);
> > > +   void (*close)(struct vm_area_struct *vma);
> > > +   /**
> > > +    * @mapped: Called when the VMA is first mapped in the MM. Not ca=
lled if
> > > +    * the new VMA is merged with an adjacent VMA.
> > > +    *
> > > +    * The @vm_private_data field is an output field allowing the use=
r to
> > > +    * modify vma->vm_private_data as necessary.
> > > +    *
> > > +    * ONLY valid if set from f_op->mmap_prepare. Will result in an e=
rror if
> > > +    * set from f_op->mmap.
> > > +    *
> > > +    * Returns %0 on success, or an error otherwise. On error, the VM=
A will
> > > +    * be unmapped.
> > > +    *
> > > +    * Context: User context.  May sleep.  Caller holds mmap_lock.
> > > +    */
> > > +   int (*mapped)(unsigned long start, unsigned long end, pgoff_t pgo=
ff,
> > > +                 const struct file *file, void **vm_private_data);
> > >     /* Called any time before splitting to check if it's allowed */
> > >     int (*may_split)(struct vm_area_struct *area, unsigned long addr)=
;
> > >     int (*mremap)(struct vm_area_struct *area);
> > > @@ -1345,3 +1367,11 @@ static inline void vma_set_file(struct vm_area=
_struct *vma, struct file *file)
> > >     swap(vma->vm_file, file);
> > >     fput(file);
> > >  }
> > > +
> > > +static inline void unmap_vma_locked(struct vm_area_struct *vma)
> > > +{
> > > +   const size_t len =3D vma_pages(vma) << PAGE_SHIFT;
> > > +
> > > +   mmap_assert_locked(vma->vm_mm);
> > > +   do_munmap(vma->vm_mm, vma->vm_start, len, NULL);
> > > +}
> > > --
> > > 2.53.0
> > >
> > >
>
> Cheers, Lorenzo
