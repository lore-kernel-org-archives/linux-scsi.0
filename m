Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB5F374A1B;
	Sat, 29 Aug 2026 10:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787999720; cv=none; b=PHwizCRbtxqnfxrs1O2xS54E1RsX5WvO1LpaLAq4UPY/PY2ImWzHEb4UTY/X8knRgAvTM3KydWALtnWHXWssZBF8rtXAWNmwJXU6Imf8qFGXGkAbWOMdgajJy8PbmAxyGR7T83RITID5C8z9g2l8aPrNsXI8wKN+1JH0oVEwa7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787999720; c=relaxed/simple;
	bh=TMjEM4qL8n/RjmKlbHGpaQh+OEsEcOVV0nLrPlTqzYE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p9jPfLir8i/3dH69+GpApKaIwf71GPmL0zxEpfphxg0iOu+tcaj4uhr7dJP4+YotuZdYtRs8B+Nh7iBl/IJTfScCAUY9G6uAzQeNL16FGhnpr+YG6380mCbBNM/vyWnjBaQRcucxNhyyvHu/2tEVJavFPauGfCloKK32NHaXhBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O4hQnDvs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O4hQnDvs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1854E1F000E9;
	Sat, 29 Aug 2026 10:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787999716;
	bh=2cSRCs8wDnCpBsS5x9/4R2NQI4neq/3EffewAPnRfKA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O4hQnDvsR3xz25zX0vx3nLmgtgXidRy0h4sWYehV2mXaWQF9J/8/dCttJ+E6EWeiL
	 AU5vXmX8gEuh+eiBybVN36gcL9arMMcSOSmanqnA1H0jUHcst2QpkRCuZYvOQ1utna
	 CmwIa3FMYIznrNaOU5idsntYbhRRO3HxdH82sL2QSmZq4KSQ//9h/0e1+1QzkyWNZ0
	 0rU3vqxq8xzjrVdcdZh5qOVfsw3iXccSIzOadiD6bqnoMbprP3lZK1UtNz4gXJHS5C
	 0O9KudEm0w62SpmKO8x56+dxacucnGq4B3gGwuAtRjfi6EA2/TmEU4oUb4c3BtwI86
	 LMFxBKkcdwmyA==
Date: Sat, 29 Aug 2026 13:35:09 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Brian King <brking@us.ibm.com>, Hannes Reinecke <hare@suse.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Matthew Wilcox <willy@infradead.org>,
	Wen Xiong <wenxiong@linux.ibm.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, Hannes Reinecke <hare@kernel.org>,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH v2 0/4] scsi: replace __get_free_pages() with kmalloc()
Message-ID: <apK13danJIU2PD8f@kernel.org>
References: <20260704-b4-scsi-v2-0-7d2d21a810de@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260704-b4-scsi-v2-0-7d2d21a810de@kernel.org>

Hi Martin,

This seems to fall between the cracks.

Do you want me to resend?

On Sat, Jul 04, 2026 at 09:13:33AM +0300, Mike Rapoport (Microsoft) wrote:
> This is a (small) part of larger work of replacing page allocator calls
> with kmalloc.
> 
> My initial intention a few month ago was to remove ugly casts [1], but then
> willy pointed out that Linus objected to something like this [2] and it
> looks like more than a decade old technical debt.
> 
> Largely, anything that doesn't need struct page (or a memdesc in the
> future) should just use kmalloc() or kvmalloc() to allocate memory.
> kmalloc() guarantees alignment, physical contiguity and working
> virt_to_phys() and beside nicer API that returns void * on alloc and
> doesn't require to know the allocation size on free, kmalloc() provides
> better debugging capabilities than page allocator.
> 
> Another thing is that touching these allocation sites gives the reviewers
> opportunity to see if a PAGE_SIZE buffer is actually needed or maybe
> another size is appropriate.
> 
> For larger allocations that don't need physically contiguous memory
> kvmalloc() can be a better option that __get_free_pages() because under
> memory pressure it's is easier to allocate several order-0 pages than a
> physically contiguous chunk with the same number of pages.
> 
> And last, but not least, removing needless calls to page allocator should
> help with memdesc (aka project folio) conversion. There will be way less
> places to audit to see if the user was actually using struct page.
> 
> Also in git:
> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/scsi
> 
> [1] https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/
> [2] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/ 
> 
> ---
> v2 changes:
> * replace GFP_ATOMIC with GFP_NOIO in ipr driver
> 
> v1: https://patch.msgid.link/20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org
> 
> ---
> Mike Rapoport (Microsoft) (4):
>       scsi: target: file: use kmalloc() to allocate temporary protection buffer
>       scsi: proc: use kmalloc() in proc writers
>       scsi: ipr: use kmalloc() to allocate IPR dump buffer memory
>       scsi: sym53c8xx_2: replace __get_free_pages() with kmalloc()
> 
>  drivers/scsi/ipr.c                  | 4 ++--
>  drivers/scsi/scsi_devinfo.c         | 5 +++--
>  drivers/scsi/scsi_proc.c            | 9 +++++----
>  drivers/scsi/sym53c8xx_2/sym_hipd.h | 4 ++--
>  drivers/target/target_core_file.c   | 4 ++--
>  5 files changed, 14 insertions(+), 12 deletions(-)
> ---
> base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
> change-id: 20260611-b4-scsi-d0b0eb4895f4
> 
> --
> Sincerely yours,
> Mike.
> 

-- 
Sincerely yours,
Mike.
