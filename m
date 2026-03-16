Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C4621CC5A
	for <linux-scsi@vger.kernel.org>; Mon, 16 Mar 2026 22:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773701981; cv=pass; b=TyupnnBPDWYTfO91ynf4LH00KEZ7bG3yFOcndcj1cWnLxRCVVF51MZTPOsLLVg9XA1UvtG05rCjlcQ4HXhylPxieRvfZaZVjSVlLCnKkrvL951+enBIfyRNNCnhUso7/A33L/zTxcQ4M3Jb+mDiI7vbQ7w5S3KwEBxIgdX2TJAA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773701981; c=relaxed/simple;
	bh=n5yqztpjRLufPkj5VJdYxT7NEGdWEh93DgrTEzhQ/40=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oAEDMGpz0EM8yidV42Nptu8P9L3CgRy8njZMPqydC7jTtYp77j7jxQBxf6tREfX7lGej6zD3jWlZOoUUTuhtWOTifdCvZfXQJfBx23nDIm838lCcPFkvxzxAE5Vqqr3oVB7Eq6b1+5HljYP4mGT66/l1VSq61KixGspdNE0aqQY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DMh6LtIz; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DMh6LtIz"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5091ed02c54so96191cf.1
        for <linux-scsi@vger.kernel.org>; Mon, 16 Mar 2026 15:59:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773701978; cv=none;
        d=google.com; s=arc-20240605;
        b=DjuIrlJQagrRhgnFhbeaVa4GBoNWsIcZstV9ZNjBwxgi7dQyyhN+MyZ/UX3ma1USVF
         7AM7t6uHq4aAmBzUxTuCIFwDulhzrS8NQAXtVdhAC9Fq+HjydFeD6kPGUQ/bZ+ZuVUi+
         9AiCoI9GEOBdyPRtbwdagwn/4ZkjEx3iDLC9UB16G8WnNX1od4B55ltFin48yVpZCS/I
         qYcdUmKue2Rnp/DjM/KaYRX/DEIq7cP+70ZG5mh4mZnlTQTATpqaHaYiXjDWrZIpda4u
         j5LG/+U/4jYuhU2J4w18zlrpJDO8Re/2vm3CXGq4b6PBRI51k6h866EzVW7HC5fFHjtz
         Udfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q4cJcFtf4hpm0T0e+VviEvUx2ruLtbnKyeEs5ldKrcs=;
        fh=QLDKNkUksnStn1c+djk4ncSNF0tpz0lKYDWI4nGIPpo=;
        b=YPn9V0QAzavWo+gZUGwzwxT+qtnoW0C+yp4KPrgJbKWRFvcLzBY5x0op4KuqeBqshT
         BlCTs5i97VxN6knOlT0Je9OR5Dy32yHZj0XVwmILtY60tAh1qcbZiqEwCm/JhrAKHema
         TYflgvDkF2RqoBjXdvODGeQd9FywBnpb6AP56T4po/JU4vHHx4ryaU885u2ZgkrGEHvq
         bPXBbDIyRS+tU3dz1EQqjc4vx344iSEXqFDWA+dS6H0chDPMwKh3gKvYu1TCmhZxNFKV
         K0KBaEsILUDtAb/6HBMikaLnI7wRAd39futLQMAsaiNxYW74acXZoQQ4vPPONIrtp3ry
         fUeA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773701978; x=1774306778; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q4cJcFtf4hpm0T0e+VviEvUx2ruLtbnKyeEs5ldKrcs=;
        b=DMh6LtIzSVg4b4oelvmsNsDfbzbWWsMFFLbjMmv/YlM02GhO16UEdWQZg6lkAWRPiY
         e1b0KmY3hHsxDAB3vmpZRocTb7NTd5tHB/ikcd4xsxBL5ldcfp1KOJcM0VpyFU2AHvh4
         4uAdbzOZDE8uME31qR4W+uzm6Lwmwy2dZvyHFo2Rvt0dl5/tGGx2rGVR0o33Shwynwvr
         usSOa+82hpfddhkC5h1VRXC3VG8AwpLJ6dprpIWAojy9ZSikFkE8q9NMDEUo9lluWdWH
         bYJ5XaoPqjjoP33My/z3yFOUMrxZ9H5m7N826oNInydhwQo/asZ6I6F/C8NerdVOsS7o
         L/qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773701978; x=1774306778;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q4cJcFtf4hpm0T0e+VviEvUx2ruLtbnKyeEs5ldKrcs=;
        b=Kef5Noc8lNZ51URySHTE+eTCgCScqhBfw0YktYndGHx/nzNvQst0cx8OaQgVWjSBHA
         UwCYRU/Q0AQjCtidLhHf7r4BJpNbz0LGC4VAcjUZ7Fv3MYeC2vOJH+rq8qQL8Kuadx0P
         0i87lPNZKfR9RzY/luyzMjLLp5+ZJ7j7CjwkOkIVOyaquIPPJAqyW6biv6CPUtm8t3Im
         6YwhaCGXgrMUDjxtN6BHYuecB5rUT0DJMi5OmyNPiqhvIgiPFWyYph7C3aPq9otbc0If
         mksCnMOEOMDVfdygtvKGHc0LgMnOZc6pkfo25KR5+y7rqx9kRidsRpOH1SvThJEag6mC
         6bKA==
X-Forwarded-Encrypted: i=1; AJvYcCWVfZaKxzJlwPdDWIJhgIcLjIvKMpxPDRiZ45A3gwFD1Eq1L3TkwpYfUulbXHCehKzrZ61cGy5BxH92@vger.kernel.org
X-Gm-Message-State: AOJu0YxiO0FMWfrnuY2myQcNqhQLRvRGCk1B4mn20sAOcQ7GfNLPIBIM
	aUog3y9UMJdNRnVtgysAs7zhkl/8kFHANmQxN1eYrH8Txo2q+FJMOGvJo3v/PGqSKC0NJfyr2KW
	a0UPaBrzhYshdsZpSCd2ktQKG7Nxb/RR0BLgEpA3u
X-Gm-Gg: ATEYQzxsgcvU1fkQAsMN7RbMl/qtatfVfnBr6Aahwgdsg3lTH8m9hRjTWFTZ4shtXLH
	yf1lRUa1wSCxQB3UVcFoxMu0JLFk+WtPX2qBG/kKyj4WKAkW6eEDv+A1rY7xVRDcdtM+t8Ve9D9
	3IYHMNrbY0PS0HBt8cLzPAIAsiBsOPkGAvOGoC3cDfMmWMPFSKtfyexFktwQLBbfOBYeOVQfrBf
	bde4e20guCsUTWIqNehzcZyVT79U8NvaClevjb7EiVZWAALuwD3tjB85gBA0uIEyH59tPv5J7Jq
	CSxOxqQaboiCZ7Uw
X-Received: by 2002:ac8:5e12:0:b0:4f3:54eb:f26e with SMTP id
 d75a77b69052e-5099ac78738mr2798501cf.1.1773701977490; Mon, 16 Mar 2026
 15:59:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1773346620.git.ljs@kernel.org> <c5bb61cf789df1ecb32facc29df9749987c7ddfc.1773346620.git.ljs@kernel.org>
 <CAJuCfpGd702=Xop3X5Aop9rrScdiAOQEEooTu1gcJqR9pmO5GA@mail.gmail.com> <6a0e73a5-519e-49ca-9f76-2f6cc5a1577c@lucifer.local>
In-Reply-To: <6a0e73a5-519e-49ca-9f76-2f6cc5a1577c@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 16 Mar 2026 15:59:26 -0700
X-Gm-Features: AaiRm5118TD3MF16DHCGoLHkzYMnffHjhVhwrz0uUgfCnERLy0ui_OLbleubf-w
Message-ID: <CAJuCfpEjTw1nQik_HWXHg2su2DwzPrn5NPGpeAVPrjJK0tOSkg@mail.gmail.com>
Subject: Re: [PATCH 02/15] mm: add documentation for the mmap_prepare file
 operation callback
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

On Mon, Mar 16, 2026 at 12:17=E2=80=AFPM Lorenzo Stoakes (Oracle)
<ljs@kernel.org> wrote:
>
> On Sun, Mar 15, 2026 at 04:23:14PM -0700, Suren Baghdasaryan wrote:
> > On Thu, Mar 12, 2026 at 1:27=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@k=
ernel.org> wrote:
> > >
> > > This documentation makes it easier for a driver/file system implement=
er to
> > > correctly use this callback.
> > >
> > > It covers the fundamentals, whilst intentionally leaving the less lov=
ely
> > > possible actions one might take undocumented (for instance - the
> > > success_hook, error_hook fields in mmap_action).
> > >
> > > The document also covers the new VMA flags implementation which is th=
e only
> > > one which will work correctly with mmap_prepare.
> > >
> > > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > > ---
> > >  Documentation/filesystems/mmap_prepare.rst | 131 +++++++++++++++++++=
++
> > >  1 file changed, 131 insertions(+)
> > >  create mode 100644 Documentation/filesystems/mmap_prepare.rst
> > >
> > > diff --git a/Documentation/filesystems/mmap_prepare.rst b/Documentati=
on/filesystems/mmap_prepare.rst
> > > new file mode 100644
> > > index 000000000000..76908200f3a1
> > > --- /dev/null
> > > +++ b/Documentation/filesystems/mmap_prepare.rst
> > > @@ -0,0 +1,131 @@
> > > +.. SPDX-License-Identifier: GPL-2.0
> > > +
> > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> > > +mmap_prepare callback HOWTO
> > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> > > +
> > > +Introduction
> > > +############
> > > +
> > > +The `struct file->f_op->mmap()` callback has been deprecated as it i=
s both a
> > > +stability and security risk, and doesn't always permit the merging o=
f adjacent
> > > +mappings resulting in unnecessary memory fragmentation.
> > > +
> > > +It has been replaced with the `file->f_op->mmap_prepare()` callback =
which solves
> > > +these problems.
> > > +
> > > +## How To Use
> > > +
> > > +In your driver's `struct file_operations` struct, specify an `mmap_p=
repare`
> > > +callback rather than an `mmap` one, e.g. for ext4:
> > > +
> > > +
> > > +.. code-block:: C
> > > +
> > > +    const struct file_operations ext4_file_operations =3D {
> > > +        ...
> > > +        .mmap_prepare    =3D ext4_file_mmap_prepare,
> > > +    };
> > > +
> > > +This has a signature of `int (*mmap_prepare)(struct vm_area_desc *)`=
.
> > > +
> > > +Examining the `struct vm_area_desc` type:
> > > +
> > > +.. code-block:: C
> > > +
> > > +    struct vm_area_desc {
> > > +        /* Immutable state. */
> > > +        const struct mm_struct *const mm;
> > > +        struct file *const file; /* May vary from vm_file in stacked=
 callers. */
> > > +        unsigned long start;
> > > +        unsigned long end;
> > > +
> > > +        /* Mutable fields. Populated with initial state. */
> > > +        pgoff_t pgoff;
> > > +        struct file *vm_file;
> > > +        vma_flags_t vma_flags;
> > > +        pgprot_t page_prot;
> > > +
> > > +        /* Write-only fields. */
> > > +        const struct vm_operations_struct *vm_ops;
> > > +        void *private_data;
> > > +
> > > +        /* Take further action? */
> > > +        struct mmap_action action;
> >
> > So, action still belongs to /* Write-only fields. */ section? This is
> > nitpicky, but it might be better to have this as:
> >
> >         /* Write-only fields. */
> >         const struct vm_operations_struct *vm_ops;
> >         void *private_data;
> >         struct mmap_action action; /* Take further action? */
>
> Absolutely not. This field is not to be written to by the user.
>
> We sadly have to allow hugetlb to do some hacks, but these are things we =
don't
> want to point out.

Ack.

>
> Users should use mmap_action_xxx() functions.
>
> >
> > > +    };
> > > +
> > > +This is straightforward - you have all the fields you need to set up=
 the
> > > +mapping, and you can update the mutable and writable fields, for ins=
tance:
> > > +
> > > +.. code-block:: Cw
> > > +
> > > +    static int ext4_file_mmap_prepare(struct vm_area_desc *desc)
> > > +    {
> > > +        int ret;
> > > +        struct file *file =3D desc->file;
> > > +        struct inode *inode =3D file->f_mapping->host;
> > > +
> > > +        ...
> > > +
> > > +        file_accessed(file);
> > > +        if (IS_DAX(file_inode(file))) {
> > > +            desc->vm_ops =3D &ext4_dax_vm_ops;
> > > +            vma_desc_set_flags(desc, VMA_HUGEPAGE_BIT);
> > > +        } else {
> > > +            desc->vm_ops =3D &ext4_file_vm_ops;
> > > +        }
> > > +        return 0;
> > > +    }
> > > +
> > > +Importantly, you no longer have to dance around with reference count=
s or locks
> > > +when updating these fields - __you can simply go ahead and change th=
em__.
> > > +
> > > +Everything is taken care of by the mapping code.
> > > +
> > > +VMA Flags
> > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > +
> > > +Along with `mmap_prepare`, VMA flags have undergone an overhaul. Whe=
re before
> > > +you would invoke one of `vm_flags_init()`, `vm_flags_reset()`, `vm_f=
lags_set()`,
> > > +`vm_flags_clear()`, and `vm_flags_mod()` to modify flags (and to hav=
e the
> > > +locking done correctly for you, this is no longer necessary.
> > > +
> > > +Also, the legacy approach of specifying VMA flags via `VM_READ`, `VM=
_WRITE`,
> > > +etc. - i.e. using a `VM_xxx` macro has changed too.
> > > +
> > > +When implementing `mmap_prepare()`, reference flags by their bit num=
ber, defined
> > > +as a `VMA_xxx_BIT` macro, e.g. `VMA_READ_BIT`, `VMA_WRITE_BIT` etc.,=
 and use one
> > > +of (where `desc` is a pointer to `struct vma_area_desc`):
> > > +
> > > +* `vma_desc_test_flags(desc, ...)` - Specify a comma-separated list =
of flags you
> > > +  wish to test for (whether _any_ are set), e.g. - `vma_desc_test_fl=
ags(desc,
> > > +  VMA_WRITE_BIT, VMA_MAYWRITE_BIT)` - returns `true` if either are s=
et,
> > > +  otherwise `false`.
> > > +* `vma_desc_set_flags(desc, ...)` - Update the VMA descriptor flags =
to set
> > > +  additional flags specified by a comma-separated list,
> > > +  e.g. - `vma_desc_set_flags(desc, VMA_PFNMAP_BIT, VMA_IO_BIT)`.
> > > +* `vma_desc_clear_flags(desc, ...)` - Update the VMA descriptor flag=
s to clear
> > > +  flags specified by a comma-separated list, e.g. - `vma_desc_clear_=
flags(desc,
> > > +  VMA_WRITE_BIT, VMA_MAYWRITE_BIT)`.
> > > +
> > > +Actions
> > > +=3D=3D=3D=3D=3D=3D=3D
> > > +
> > > +You can now very easily have actions be performed upon a mapping onc=
e set up by
> > > +utilising simple helper functions invoked upon the `struct vm_area_d=
esc`
> > > +pointer. These are:
> > > +
> > > +* `mmap_action_remap()` - Remaps a range consisting only of PFNs for=
 a specific
> > > +  range starting a virtual address and PFN number of a set size.
> > > +
> > > +* `mmap_action_remap_full()` - Same as `mmap_action_remap()`, only r=
emaps the
> > > +  entire mapping from `start_pfn` onward.
> > > +
> > > +* `mmap_action_ioremap()` - Same as `mmap_action_remap()`, only perf=
orms an I/O
> > > +  remap.
> > > +
> > > +* `mmap_action_ioremap_full()` - Same as `mmap_action_ioremap()`, on=
ly remaps
> > > +  the entire mapping from `start_pfn` onward.
> > > +
> > > +**NOTE:** The 'action' field should never normally be manipulated di=
rectly,
> > > +rather you ought to use one of these helpers.
> >
> > I'm guessing the start and size parameters passed to
> > mmap_action_remap() and such are restricted by vm_area_desc.start
> > vm_area_desc.end. If so, should we document those restrictions and
> > enforce them in the code?
>
> I mean it's the same restrictions as all of the functions already apply i=
f you
> were to use them with a VMA descriptor.
>
> I think implicitly a remap will fail if you try it out of the VMA range a=
t the
> point of applying the change.
>
> But it might be worth adding range_in_vma_desc() checks at prepare time, =
will
> see if I can do that for the respin.
>
> I think it's pretty obvious that you shouldn't be trying to remap totally
> unrelated memory, so I'm not sure that's at a level of granularity that's=
 suited
> to this document though.

I just saw you already have WARN_ON_ONCE() inside mmap_action_remap()
to check for these limits, so codewise I think we are already good.

For documentation I'll rely on your judgement whether to mention this or no=
t.

>
> >
> > > +    struct vm_area_desc {
> > > +        /* Immutable state. */
> > > +        const struct mm_struct *const mm;
> > > +        struct file *const file; /* May vary from vm_file in stacked=
 callers. */
> > > +        unsigned long start;
> > > +        unsigned long end;
> >
> >
> > > --
> > > 2.53.0
> > >
