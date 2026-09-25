Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678A248820A;
	Fri, 25 Sep 2026 09:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790329876; cv=none; b=OPQO7zS9qrTxS3ZHT1A4GfQhQ4aYT0YztxM2dRjZ9+Le4A1hfT0jc+0b0oFsiXsVmVTiM4jtzbc2b1Cso9lv6KE46R76CWqC0ai0QVgksEjFB6sZGa6VfOXJTSd+AIw0v5rEt1HV2y0nvScxcjjIGvqnHzYRA0wN6jJ8bEUwWVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790329876; c=relaxed/simple;
	bh=Fm+32Vf3S+niz7+EEpuoV4bUdgfxBo5mLwbtfW1D9qA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BYxYrtViSzGpoTDMxFq+x434XDxTUTpuF/dSykSL6HUxTntrPHGYoqhKRqZbYyMJ7oKwU4TWMxIyWNttOm6pxkhkb1oBu5KaYR8eUj+XgoqrWkYhaHvdmivMg9YeYY2Usfmm+LaHYpWc/X+tuNG4TIGWTPgIlzDMZVkxjcLRQX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JSUBBGwl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JSUBBGwl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3B71F000FF;
	Fri, 25 Sep 2026 09:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790329872;
	bh=Yk8oUNugjqXaeddwMIx0+ekaXJEnqfxT78aSMnwYEnI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JSUBBGwlrH3ZgwJ6l/4+E323TPon9dlzQmxSgi4dKP5ej5M+6JNROW2aYv/s16dE8
	 CRGnOlxQkSQ+kwX4jOwHjC4XJeglXJXbstdRLEGVyfy9uuaU5RY7j/bQVZeovmWADu
	 BMPfHT0+2IVfelM7WD5GXNkc8n0jApkA5i6t7amcABDPyOlWU00gWD4tXhMUjhBqDP
	 hNtSCW963vazV7rBBtraH4k8uB392AUIFbbnM1RHSRvA6CGYdjO1l8WDJIm8Wq65e1
	 FusdmWKynvIGTrqdUJHAe9NC9EjgtAYk10ou/aFv3U2NgPrnFm53wiqaIk0D7TVJJV
	 MhzR8ZFfariJg==
Date: Fri, 25 Sep 2026 10:51:04 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-sound@vger.kernel.org, 
	bpf@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev
Subject: Re: [PATCH v3 05/40] mm/vma: ensure mmap_prepare doesn't set actions
 on a mergeable vma
Message-ID: <arZC7UscjpjVJxnV@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-5-4583d8a23bca@kernel.org>
 <arVkwC_wNoTLjRYf@gourry-fedora-PF4VCD3F>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arVkwC_wNoTLjRYf@gourry-fedora-PF4VCD3F>

On Thu, Sep 24, 2026 at 02:00:18PM -0400, Gregory Price wrote:
> On Thu, Sep 17, 2026 at 05:22:14PM +0100, Lorenzo Stoakes (ARM) wrote:
> > When a user requests an mmap_action be performed in mmap_prepare, this
> > involves populating the VMA range with data.
> >
> > However, if the VMA is mergeable, it might then mistakenly be merged with
> > another VMA without having populated the range.
> >
> > Every mmap action currently available sets VMA flags such that the VMA
> > cannot be merged.
> >
> > However, to ensure that no future mmap action falls foul of this, assert
> > that this is the case upon mmap_prepare validation.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/vma.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/mm/vma.c b/mm/vma.c
> > index d6ed10cefc8f..62f2ce1ad5a1 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -2809,6 +2809,15 @@ static int mmap_validate(unsigned long prev_start, unsigned long prev_end,
> >  int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
> >  			  const struct vm_area_desc *desc)
> >  {
> > +	/*
> > +	 * It is not valid to execute mmap actions for VMAs which can be merged,
> > +	 * as any such merge would leave portions of the mapping incorrectly
> > +	 * unmapped.
> > +	 */
> > +	if (vma_flags_can_merge(&desc->vma_flags) &&
> > +	    WARN_ON_ONCE(desc->action.type != MMAP_NOTHING))
> > +		return -EINVAL;
> > +
>
> If you wanted to make this unit-testable, you could pull it out into a
> separate function:
>
> static bool mmap_action_is_valid(const struct vm_area_desc *desc)
> {
> 	return desc->action.type == MMAP_NOTHING ||
> 		!vma_flags_can_merge(&desc->vma_flags);
> }
>
> then write:
>
> if (WARN_ON_ONCE(!mmap_action_is_valid(desc)))
> 	return -EINVAL;
>
> And you can write a unit test directly against mmap_action_is_valid

You mean to isolate this check specifically?

All of the functions in vma.c are unit-testable in the userland VMA tests,
obviously here you'd be testing further stuff but you could certainly assert a
mergeable VMA specifying an action should result in an error there.

I'm also keen not to proliferate two many 'kinds' of validation.

As mmap_validate() checks pretty much everything BUT the action check, and it
has to work across mmap_prepare and mmap hooks.

So the idea here is we put the mmap_prepare-specific stuff in
mmap_prepare_validate() and the shared stuff in mmap_validate().

And already the stuff that can be validated just against flags lives in
mmap_validate_vma_flags() so that is itself separated out nicely.

>
> otherwise
>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

Thanks!

--
Cheers, Lorenzo
