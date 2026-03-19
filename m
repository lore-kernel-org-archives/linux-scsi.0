Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1493E1D0C
	for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2026 15:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773933593; cv=pass; b=SuZrW4Enh5a7aMnDiET6mGgxYeMMea0pdNE9U5+U3L37nNr/e5KvrgeXBq384Nl3JlIV/lcuc2OZtY9rI/xVTOLhG9i5u9Q+F31ANbAz8LuuP/uaN8e2mWVNfZCYmuDA34YWl9O5zrkJa1S/Ky2lJ8Ynh2Y1tb9YHfiwoO+rZZw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773933593; c=relaxed/simple;
	bh=cd2Yc6Pq+XjnR/Goq5WKVux5mwTDBBwiKIMMeMo1T34=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pkjLskg7bETlgYfz3bJbJnSPmR35eDU8cftQHDXmB30gt5HKWDEIYT3Du05SUJXSP6Z8/zSFz/oPcPqAuQAc2/Mvil5xZXodCMw7bUiXv/MSlhjKy6UqiE4IQG0Kbkp0C0VJcwllLRLKyM60oq0K48+ro4MwjC5Uc6mr14GGXwc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=APmyZl3o; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="APmyZl3o"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-667cde0fc88so10033a12.1
        for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2026 08:19:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773933590; cv=none;
        d=google.com; s=arc-20240605;
        b=fjzhjPCKfbpNZXfBGKvHNosmGqVFfpMEsy2W3KaxVoAYdqfxlyFRjjrkAFDshDCdul
         C1rF2Hjqh40YYFu48j3dCUHj2wR+jbrskak5s/rYBGOzGJyJMD2he20T1zoyQ/D7QwP0
         VaWdMkEcVYX4kJO7ZdpJ+j8H4VJH7m+sDxXAVOz42tmXNQcBiLsgGWi6pZESZtO8Uecu
         LrCq4/aJbD+k8viFtSmWHve5hlKxHaeV90E3VPZOQbDwGBycLL3ooau5cMxgshESa8ma
         6dFbxfwbKvapzwEK7H92Jd5yh75GPCD9n9okLj39repMfbujNv4OE7HNV9Rns0irQNS0
         b9Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OfH8Q5Td26D2zz2vaWeEEQdnUyXBLu9cQNzXDyggGWs=;
        fh=K47L4A50I2uWLEupiO5dY81nwThkD6BJRUnVPNohFxo=;
        b=AMYDjdihEbAhGfaCirpFLQDgifbQVAeswWKeGhhPmtKYAl/bmNsGxsbSUJaJeVl+KS
         81hb1/wt+RpHnwLJIllsTQnvlFzQyKrrBtyOx8aaFxL6dV1b4bfXWARNJ9JopehICqcL
         0f3jLfblnxwjJgiSKcHoJdoMHIXp1VfQiM8lKMpgdj3DDzp0ocEWnuNNNwTGu0hyg4Cm
         TKksfzF6M5b9F+DDKhtJurYnPj8QeBLpv5saeJkJQdjIVr/ckRqM9s4wbDcf0F2vgpZu
         Z2IUWEmI2Ad2VKnuCWG30JhNbXH/XMHRMc9YBO6fUa3AZNI87JSWg+SZq6OaCwCTrGKz
         tv1w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773933590; x=1774538390; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OfH8Q5Td26D2zz2vaWeEEQdnUyXBLu9cQNzXDyggGWs=;
        b=APmyZl3oeQueRTmeziy3SJdrcPsjCwIOAj2jNKPmTym9K8ETNtFxyE/UFMUYhtrc5q
         GB/nIPyLN6hfGntMHmt9dfHM7PfjMcnmARl7l9vxeRa5Z6X8vyFcJtavGpYR7HGrjgTd
         HpxbSNjN/pR2DCvhPHO07tEo4jMm5sTFowCJH+oxCaHcjzN1z2eJfXeIPKrS9nuO3Sui
         GiTp2InFaceJm8b9omVrtlETA1ZPWNMYCpfteIxl4+1j3B1JsIz7X9Rp+hvEi2VDArQn
         7dbUq2H0Fgz455Cn+z49tHCsEmp/3RJ2CiDks0Ufyr7BUn2X/enGHT6A0qkiAuhn994R
         CGUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773933590; x=1774538390;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OfH8Q5Td26D2zz2vaWeEEQdnUyXBLu9cQNzXDyggGWs=;
        b=X7t42cagnOIzWCtRtRzA47QMh1/mL/HjcXHecOnjVFKtj6+BrWOp0w8Rq5iv13q7tw
         fVAHBpAiW2R/d4f6SwtUgZCorCsKvsFLueK/2nyCmz21x+AohOsDpj2E6kGL0tLe1I8Y
         2r9zM+grExNniqWBASYc+cKGli0tTDx9XhnprNXnckM9g3+ghXWPfqiEBq949iMD6TEW
         tt3u1GS1n7uMIXJEaOA2u7z+e3LHoVexBXHU2hCyBqNDxJbAEamVGnHCpOUsRI5SzS3K
         VNnlYFrDLmy6mG5pBOJeG6+HryNZp6QT3Ke2PRrrzJSWhEfVPP29xNcsiRzwCX6YkPZX
         dTug==
X-Forwarded-Encrypted: i=1; AJvYcCUypiaNlMuMzDMCk0MAlgfOdgtVWu9XGHNAhymmxm3wCBnhsbJT3d9LLH7rvOwos/N1IL1rELpu3tlZ@vger.kernel.org
X-Gm-Message-State: AOJu0Yx92Ub9GBJ2i7M2RezJNOfgbS2ImOqDR/Z+IJfD98w7q7ktzaUY
	pLT7axhaClJhPcQsKPuTFx8k4K+1pMAhUKmUNawBXDDj3umwGEE1PZ2TxGy26U/1ZRjJkwHWC/r
	HXGJkIGITJWzr2LM6y4IasZaSgf7TvtHkt4oqI/Sx
X-Gm-Gg: ATEYQzzdic9rRfzhAynsMUFgWS7Omz4dohKeYLwfWu5S45RiNRrmD6xfRLNJB4KYjZL
	5ZDsFtYMzU55G59DsjQPpJWzBnPKpVjn6KhFHi6UuJG0tXBk6WTvqzYIqW8XVOtLBPlEzIYyIHM
	HD1N7uY8JAGlsV6ijyCuSpkfFglugHPD+zl+9yIaWHZa8/s8vNlZYFlnJ4tgMdBRnCjCIUFOWW+
	rWPx9vM+5IJVsHV+BAz1+qMqpQyQf7riYcFCQ9dNcJTqV0vfhWkQ0qLl0c/H4s+M1glE8P1GmaQ
	iMEkHwrX5DEXPdvyEHQI8soreR6m8xW43aK5
X-Received: by 2002:a05:6402:46c5:b0:665:d39:4b18 with SMTP id
 4fb4d7f45d1cf-66852d6c8abmr48783a12.8.1773933589136; Thu, 19 Mar 2026
 08:19:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1773695307.git.ljs@kernel.org> <48c6d25e374b57dba6df4fdddd4830d3fc1105be.1773695307.git.ljs@kernel.org>
 <CAJuCfpFXuHg4KPY27pqMC-xV5y9ZY2W72_R8_rxO0DvrJ=_yvw@mail.gmail.com>
 <CAJuCfpE5qZmi43EeZiRcy78pD6YvJb5n_xnoUJfwEjomowu0=A@mail.gmail.com>
 <8cdad898-b306-40fe-a367-efe7147f83b9@lucifer.local> <CAJuCfpHXqtxZr5s84jCcz513a2pgMeDoobsLBJH9pSON49cM+w@mail.gmail.com>
In-Reply-To: <CAJuCfpHXqtxZr5s84jCcz513a2pgMeDoobsLBJH9pSON49cM+w@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 19 Mar 2026 08:19:35 -0700
X-Gm-Features: AaiRm51bFJ7jnCWExjTkTJWtl61x7cY-2jhtQRDi8xxndWDLsjo0Sko90eA6oXU
Message-ID: <CAJuCfpG4F7r=AMTBRkazFeQsnKocu9OPFyV2TsQccLQc=oLwNA@mail.gmail.com>
Subject: Re: [PATCH v2 11/16] staging: vme_user: replace deprecated mmap hook
 with mmap_prepare
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

On Thu, Mar 19, 2026 at 8:19=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Thu, Mar 19, 2026 at 7:55=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@ker=
nel.org> wrote:
> >
> > On Tue, Mar 17, 2026 at 02:32:16PM -0700, Suren Baghdasaryan wrote:
> > > On Tue, Mar 17, 2026 at 2:26=E2=80=AFPM Suren Baghdasaryan <surenb@go=
ogle.com> wrote:
> > > >
> > > > On Mon, Mar 16, 2026 at 2:14=E2=80=AFPM Lorenzo Stoakes (Oracle) <l=
js@kernel.org> wrote:
> > > > >
> > > > > The f_op->mmap interface is deprecated, so update driver to use i=
ts
> > > > > successor, mmap_prepare.
> > > > >
> > > > > The driver previously used vm_iomap_memory(), so this change repl=
aces it
> > > > > with its mmap_prepare equivalent, mmap_action_simple_ioremap().
> > > > >
> > > > > Functions that wrap mmap() are also converted to wrap mmap_prepar=
e()
> > > > > instead.
> > > > >
> > > > > Also update the documentation accordingly.
> > > > >
> > > > > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> > > > > ---
> > > > >  Documentation/driver-api/vme.rst    |  2 +-
> > > > >  drivers/staging/vme_user/vme.c      | 20 +++++------
> > > > >  drivers/staging/vme_user/vme.h      |  2 +-
> > > > >  drivers/staging/vme_user/vme_user.c | 51 +++++++++++++++++------=
------
> > > > >  4 files changed, 42 insertions(+), 33 deletions(-)
> > > > >
> > > > > diff --git a/Documentation/driver-api/vme.rst b/Documentation/dri=
ver-api/vme.rst
> > > > > index c0b475369de0..7111999abc14 100644
> > > > > --- a/Documentation/driver-api/vme.rst
> > > > > +++ b/Documentation/driver-api/vme.rst
> > > > > @@ -107,7 +107,7 @@ The function :c:func:`vme_master_read` can be=
 used to read from and
> > > > >
> > > > >  In addition to simple reads and writes, :c:func:`vme_master_rmw`=
 is provided to
> > > > >  do a read-modify-write transaction. Parts of a VME window can al=
so be mapped
> > > > > -into user space memory using :c:func:`vme_master_mmap`.
> > > > > +into user space memory using :c:func:`vme_master_mmap_prepare`.
> > > > >
> > > > >
> > > > >  Slave windows
> > > > > diff --git a/drivers/staging/vme_user/vme.c b/drivers/staging/vme=
_user/vme.c
> > > > > index f10a00c05f12..7220aba7b919 100644
> > > > > --- a/drivers/staging/vme_user/vme.c
> > > > > +++ b/drivers/staging/vme_user/vme.c
> > > > > @@ -735,9 +735,9 @@ unsigned int vme_master_rmw(struct vme_resour=
ce *resource, unsigned int mask,
> > > > >  EXPORT_SYMBOL(vme_master_rmw);
> > > > >
> > > > >  /**
> > > > > - * vme_master_mmap - Mmap region of VME master window.
> > > > > + * vme_master_mmap_prepare - Mmap region of VME master window.
> > > > >   * @resource: Pointer to VME master resource.
> > > > > - * @vma: Pointer to definition of user mapping.
> > > > > + * @desc: Pointer to descriptor of user mapping.
> > > > >   *
> > > > >   * Memory map a region of the VME master window into user space.
> > > > >   *
> > > > > @@ -745,12 +745,13 @@ EXPORT_SYMBOL(vme_master_rmw);
> > > > >   *         resource or -EFAULT if map exceeds window size. Other=
 generic mmap
> > > > >   *         errors may also be returned.
> > > > >   */
> > > > > -int vme_master_mmap(struct vme_resource *resource, struct vm_are=
a_struct *vma)
> > > > > +int vme_master_mmap_prepare(struct vme_resource *resource,
> > > > > +                           struct vm_area_desc *desc)
> > > > >  {
> > > > > +       const unsigned long vma_size =3D vma_desc_size(desc);
> > > > >         struct vme_bridge *bridge =3D find_bridge(resource);
> > > > >         struct vme_master_resource *image;
> > > > >         phys_addr_t phys_addr;
> > > > > -       unsigned long vma_size;
> > > > >
> > > > >         if (resource->type !=3D VME_MASTER) {
> > > > >                 dev_err(bridge->parent, "Not a master resource\n"=
);
> > > > > @@ -758,19 +759,18 @@ int vme_master_mmap(struct vme_resource *re=
source, struct vm_area_struct *vma)
> > > > >         }
> > > > >
> > > > >         image =3D list_entry(resource->entry, struct vme_master_r=
esource, list);
> > > > > -       phys_addr =3D image->bus_resource.start + (vma->vm_pgoff =
<< PAGE_SHIFT);
> > > > > -       vma_size =3D vma->vm_end - vma->vm_start;
> > > > > +       phys_addr =3D image->bus_resource.start + (desc->pgoff <<=
 PAGE_SHIFT);
> > > > >
> > > > >         if (phys_addr + vma_size > image->bus_resource.end + 1) {
> > > > >                 dev_err(bridge->parent, "Map size cannot exceed t=
he window size\n");
> > > > >                 return -EFAULT;
> > > > >         }
> > > > >
> > > > > -       vma->vm_page_prot =3D pgprot_noncached(vma->vm_page_prot)=
;
> > > > > -
> > > > > -       return vm_iomap_memory(vma, phys_addr, vma->vm_end - vma-=
>vm_start);
> > > > > +       desc->page_prot =3D pgprot_noncached(desc->page_prot);
> > > > > +       mmap_action_simple_ioremap(desc, phys_addr, vma_size);
> > > > > +       return 0;
> > > > >  }
> > > > > -EXPORT_SYMBOL(vme_master_mmap);
> > > > > +EXPORT_SYMBOL(vme_master_mmap_prepare);
> > > > >
> > > > >  /**
> > > > >   * vme_master_free - Free VME master window
> > > > > diff --git a/drivers/staging/vme_user/vme.h b/drivers/staging/vme=
_user/vme.h
> > > > > index 797e9940fdd1..b6413605ea49 100644
> > > > > --- a/drivers/staging/vme_user/vme.h
> > > > > +++ b/drivers/staging/vme_user/vme.h
> > > > > @@ -151,7 +151,7 @@ ssize_t vme_master_read(struct vme_resource *=
resource, void *buf, size_t count,
> > > > >  ssize_t vme_master_write(struct vme_resource *resource, void *bu=
f, size_t count, loff_t offset);
> > > > >  unsigned int vme_master_rmw(struct vme_resource *resource, unsig=
ned int mask, unsigned int compare,
> > > > >                             unsigned int swap, loff_t offset);
> > > > > -int vme_master_mmap(struct vme_resource *resource, struct vm_are=
a_struct *vma);
> > > > > +int vme_master_mmap_prepare(struct vme_resource *resource, struc=
t vm_area_desc *desc);
> > > > >  void vme_master_free(struct vme_resource *resource);
> > > > >
> > > > >  struct vme_resource *vme_dma_request(struct vme_dev *vdev, u32 r=
oute);
> > > > > diff --git a/drivers/staging/vme_user/vme_user.c b/drivers/stagin=
g/vme_user/vme_user.c
> > > > > index d95dd7d9190a..11e25c2f6b0a 100644
> > > > > --- a/drivers/staging/vme_user/vme_user.c
> > > > > +++ b/drivers/staging/vme_user/vme_user.c
> > > > > @@ -446,24 +446,14 @@ static void vme_user_vm_close(struct vm_are=
a_struct *vma)
> > > > >         kfree(vma_priv);
> > > > >  }
> > > > >
> > > > > -static const struct vm_operations_struct vme_user_vm_ops =3D {
> > > > > -       .open =3D vme_user_vm_open,
> > > > > -       .close =3D vme_user_vm_close,
> > > > > -};
> > > > > -
> > > > > -static int vme_user_master_mmap(unsigned int minor, struct vm_ar=
ea_struct *vma)
> > > > > +static int vme_user_vm_mapped(unsigned long start, unsigned long=
 end, pgoff_t pgoff,
> > > > > +                             const struct file *file, void **vm_=
private_data)
> > > > >  {
> > > > > -       int err;
> > > > > +       const unsigned int minor =3D iminor(file_inode(file));
> > > > >         struct vme_user_vma_priv *vma_priv;
> > > > >
> > > > >         mutex_lock(&image[minor].mutex);
> > > > >
> > > > > -       err =3D vme_master_mmap(image[minor].resource, vma);
> > > > > -       if (err) {
> > > > > -               mutex_unlock(&image[minor].mutex);
> > > > > -               return err;
> > > > > -       }
> > > > > -
> > > >
> > > > Ok, this changes the set of the operations performed under image[mi=
nor].mutex.
> > > > Before we had:
> > > >
> > > > mutex_lock(&image[minor].mutex);
> > > > vme_master_mmap();
> > > > <some final adjustments>
> > > > mutex_unlock(&image[minor].mutex);
> > > >
> > > > Now we have:
> > > >
> > > > mutex_lock(&image[minor].mutex);
> > > > vme_master_mmap_prepare()
> > > > mutex_unlock(&image[minor].mutex);
> > > > vm_iomap_memory();
> > > > mutex_lock(&image[minor].mutex);
> > > > vme_user_vm_mapped(); // <some final adjustments>
> > > > mutex_unlock(&image[minor].mutex);
> > > >
> > > > I think as long as image[minor] does not change while we are not
> > > > holding the mutex we should be safe, and looking at the code it see=
ms
> > > > to be the case. But I'm not familiar with this driver and might be
> > > > wrong. Worth double-checking.
> >
> > The file is pinned for the duration, the mutex is associated with the f=
ile,
> > so there's no sane world in which that could be problematic.
> >
> > Keeping in mind that we manipulate stuff on vme_user_vm_close() that
> > directly acceses image[minor] at an arbitary time.
>
> That was my understanding as well. Thanks for confirming.
>
> >
> > >
> > > A side note: if we had to hold the mutex across all those operations =
I
> > > think we would need to take the mutex in the vm_ops->mmap_prepare and
> > > add a vm_ops->map_failed hook or something along that line to drop th=
e
> > > mutex in case mmap_action_complete() fails. Not sure if we will have
> > > such cases though...
> >
> > No, I don't want to do this if it can be at all avoided. You should in
> > nearly any sane circumstance be able to defer things until the mapped h=
ook
> > anyway.
> >
> > Also a merge can happen too after an .mmap_prepare, so we'd have to hav=
e
> > some 'success' hook and I'm just not going there it'll end up open to a=
buse
> > again.
> >
> > (We do have success and error filtering hooks right now, sadly, but the=
y're
> > really for hugetlb and I plan to find a way to get rid of them).
> >
> > The mmap_prepare is meant to essentially be as stateless as possible.
>
> Yes, I also hope we won't encounter cases requiring us to keep any
> state information between the mmap_prepare and mapped stages.
>
> >
> > Anyway I don't think it's relevant here.
> >
> > >
> > > >
> > > > >         vma_priv =3D kmalloc_obj(*vma_priv);
> > > > >         if (!vma_priv) {
> > > > >                 mutex_unlock(&image[minor].mutex);
> > > > > @@ -472,22 +462,41 @@ static int vme_user_master_mmap(unsigned in=
t minor, struct vm_area_struct *vma)
> > > > >
> > > > >         vma_priv->minor =3D minor;
> > > > >         refcount_set(&vma_priv->refcnt, 1);
> > > > > -       vma->vm_ops =3D &vme_user_vm_ops;
> > > > > -       vma->vm_private_data =3D vma_priv;
> > > > > -
> > > > > +       *vm_private_data =3D vma_priv;
> > > > >         image[minor].mmap_count++;
> > > > >
> > > > >         mutex_unlock(&image[minor].mutex);
> > > > > -
> > > > >         return 0;
> > > > >  }
> > > > >
> > > > > -static int vme_user_mmap(struct file *file, struct vm_area_struc=
t *vma)
> > > > > +static const struct vm_operations_struct vme_user_vm_ops =3D {
> > > > > +       .mapped =3D vme_user_vm_mapped,
> > > > > +       .open =3D vme_user_vm_open,
> > > > > +       .close =3D vme_user_vm_close,
> > > > > +};
> > > > > +
> > > > > +static int vme_user_master_mmap_prepare(unsigned int minor,
> > > > > +                                       struct vm_area_desc *desc=
)
> > > > > +{
> > > > > +       int err;
> > > > > +
> > > > > +       mutex_lock(&image[minor].mutex);
> > > > > +
> > > > > +       err =3D vme_master_mmap_prepare(image[minor].resource, de=
sc);
> > > > > +       if (!err)
> > > > > +               desc->vm_ops =3D &vme_user_vm_ops;
> > > > > +
> > > > > +       mutex_unlock(&image[minor].mutex);
> > > > > +       return err;
> > > > > +}
> > > > > +
> > > > > +static int vme_user_mmap_prepare(struct vm_area_desc *desc)
> > > > >  {
> > > > > -       unsigned int minor =3D iminor(file_inode(file));
> > > > > +       const struct file *file =3D desc->file;
> > > > > +       const unsigned int minor =3D iminor(file_inode(file));
> > > > >
> > > > >         if (type[minor] =3D=3D MASTER_MINOR)
> > > > > -               return vme_user_master_mmap(minor, vma);
> > > > > +               return vme_user_master_mmap_prepare(minor, desc);
> > > > >
> > > > >         return -ENODEV;
> > > > >  }
> > > > > @@ -498,7 +507,7 @@ static const struct file_operations vme_user_=
fops =3D {
> > > > >         .llseek =3D vme_user_llseek,
> > > > >         .unlocked_ioctl =3D vme_user_unlocked_ioctl,
> > > > >         .compat_ioctl =3D compat_ptr_ioctl,
> > > > > -       .mmap =3D vme_user_mmap,
> > > > > +       .mmap_prepare =3D vme_user_mmap_prepare,
> > > > >  };
> > > > >
> > > > >  static int vme_user_match(struct vme_dev *vdev)
> > > > > --
> > > > > 2.53.0
> > > > >
> >
> > Cheers, Lorenzo
