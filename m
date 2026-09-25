Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49765470E84;
	Fri, 25 Sep 2026 12:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790340679; cv=none; b=cbxUAt+Bj52HXNmqJdDpnNAZRsjj5Dgd/O161WRAo+DMTGbQdVXlm8ejnc2WCCOLb4Gapqz4iG/ciFfmYUzH3Fb6yyHLPlRKR4mLVMmSNvjuKwgfA7TJfhpfmucvwIfQFGEHOxwGkHf1IfITQQUtKPLI/jwraTzFblbmRySvdxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790340679; c=relaxed/simple;
	bh=KO2TEy9loU8QK2IS8vmNyCcNin1HMfXr4zTewREYrSQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=na5ry8jNWA+1ZLoi1PtEmAHCFLXpUmeM9lbYdrEhjxGX2OMefczwPmCcKo4Fg/FErgUc9yy27ZLUMGenMb6leAUGwCQ45L2mdjgn34/0FLQS58ub8XJ49V55pFXdiCPQknizWltOxPMGh53WPKJfH1lYSckFVWoQphxnrWQKeFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y53djdWl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y53djdWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E621F00898;
	Fri, 25 Sep 2026 12:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790340678;
	bh=D3elFlAcGaZH0VbYl18NIe5+45MZxJu3tV5JyNgmc1k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y53djdWlLd4diT/AvrOcXi2GrVkUMfZOD6dmk5wrBuqGrapZjitCvRDfrBfg9d5x0
	 BnTKh4bxCfiX0tMKCdrW8JtFurhbBTQYO3LW88thuG01Cb/ZYE7hw59evarzLYTO38
	 7wZU6lEFZdgk6ZZ7hHn/Dp2Lao89/ocNv/c66cAQXdIQWZDLRciBbhbYw+b5WFshwd
	 SgfnG/v9weC791zQC+pDBEFG7GNZuzILu4ouO1eex0u514XgRGL7lU1F1WRmmHIXhs
	 yqzMlC0qHyJaHLn+n3KPUNM1XrW75NKKVif7jm3AOyuuULaCC+82pdP6bc1SuqvtsJ
	 b7HBLAWBmeiCg==
Date: Fri, 25 Sep 2026 13:51:09 +0100
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
Subject: Re: [PATCH v3 04/40] mm: consistently validate VMA state after
 mmap[_prepare] hooks
Message-ID: <arZriK1tyOC7DjBw@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-4-4583d8a23bca@kernel.org>
 <arVW5i8pvySq6Co2@gourry-fedora-PF4VCD3F>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arVW5i8pvySq6Co2@gourry-fedora-PF4VCD3F>

On Thu, Sep 24, 2026 at 01:17:28PM -0400, Gregory Price wrote:
> On Thu, Sep 17, 2026 at 05:22:13PM +0100, Lorenzo Stoakes (ARM) wrote:
> >  static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
> >  {
> ...
> > +	err = mmap_hook_validate(prev_start, prev_end, &prev_flags, vma);
> > +	if (unlikely(err)) {
> > +		vma->vm_start = prev_start;
> > +		vma->vm_end = prev_end;
> > +		vma_close(vma);
> >  	}
> > +
> > +	return err;
> >  }
> >
>
> I indepdeantly validated the sashiko report on this chunk.  Seems like
> close() should be deferred until after __map_new_file_vma() calls
> unmap_region().

Ack perhaps too quickly dismissed that one...!

>
> suggested fix is to drop vma_close() from mmap_file()  and update the
> cleanup in __mmap_new_file_vma()
>
> if (error) {
> 	UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
> 		    map->prev, map->next);
> 	vma_iter_set(vmi, vma->vm_end);
> 	unmap_region(&unmap);
>
> 	/* Release driver state only after its mappings are gone. */
> 	vma_close(vma);
>
> 	if (map_same_file(map))
> 		fput(map->vm_file);
> 	vma->vm_file = NULL;
>
> 	return error;
> }
>
> Example race:
>
>   Thread A                              Thread B
>
>   mmap(MAP_FIXED, address A)
>     driver remap_pfn_range(A, page P)
>                                          load/store at known address A
>                                          hardware finds the new present PTE
>     validation fails
>     ->close() frees page P
>                                          UAF
>     unmap_region()
>     TLB shootdown
>
> With that fix

Ack, yeah. It's kind of a situation that should never happen, but if validation
is supposed to actually be run against things then we should keep the kernel
stable when we do it :)

Will apply for the respin.

>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

Thanks!

>
> ~Gregory
>

--
Cheers, Lorenzo
