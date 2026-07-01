Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9F823ED5B;
	Wed,  1 Jul 2026 09:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782899529; cv=none; b=CzNtL4nmyNg3SpvjNuHNljNNOpRZFjlqYTXK5dnr1CE5FZsWEpJl0V7CQMhesTXNWgaGIBnBiFjmb0B99yHVKUdzszsinV7oe8mYwxQpUYT4uJ3OnldFDCXUpn5G95gUoG3X8pV/c7DdsHUeNmafic0xaHOQhCxDkctyOx2BizM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782899529; c=relaxed/simple;
	bh=ELx7ZDK2Q+w9zyMMT+0vZs8o3nIbyU6iF4TcHZzYFPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=laf3KFOmcROznvvMt9PWhHlDTB3n4g2JduJlNrxXaaWrPgyqTbshz4c7EjmgHn8nAD6rEs+i4Sxrvsc7qCposbTjgtJW5vHuM2PTol8t7jUIcmysNL2bxF/bWsE2HPuZUvN7rv3u8uT2SWcl1TBWlkwBxDgcnBKZJ2oCmXgNWtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hUmFUbpx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hUmFUbpx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18DE91F00A3A;
	Wed,  1 Jul 2026 09:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782899528;
	bh=6AeWjVLYlFF7ljuv59DbbHj2vnwHWY4jNzYXr4Sv7xs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hUmFUbpx1y5tJpPtnUlhcT3j1560TB5Z7WidudXQhnXQ3iBlDbOGKHdvOXxORwcrE
	 tjmyXJMPH48NxKfebsrBvhUG7gACJwmZBgrQpAIcWhb5oG4zMfdDkGNOqXzmcJIxMZ
	 oFwE09qRkgyihGrox9lPD0M8pJPvZztnF7f92f8U84bzcQesV6RBPrds9JSGEOpWhf
	 qER8uTWo8wRBJgWEBBXX4UndrcxMWK4GJPF99H/7QvmN4QI4razDO5GnzxBRwUy9tZ
	 AH6UDHXZu9FYrBnZ8aE8ywkTbnCASgfyFqy+cxTE0e0MnA26p6ifh1mSGu+DbB+2e8
	 Okad/FnnS81yw==
Date: Wed, 1 Jul 2026 12:52:01 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Hannes Reinecke <hare@suse.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Brian King <brking@us.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: Re: [PATCH 3/4] scsi: ipr: use kmalloc() to allocate IPR dump buffer
 memory
Message-ID: <akTjQVQQNdeO9M28@kernel.org>
References: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
 <20260630-b4-scsi-v1-3-494fb37ebe7b@kernel.org>
 <7c8f0e70-f49c-4614-af95-002fb2be11ba@suse.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c8f0e70-f49c-4614-af95-002fb2be11ba@suse.com>

On Wed, Jul 01, 2026 at 09:03:06AM +0200, Hannes Reinecke wrote:
> On 6/30/26 12:54 PM, Mike Rapoport (Microsoft) wrote:
> > IPR dump machinery allocates memory to save adapter's crash dump using
> > __get_free_page().
> > 
> > This memory can be allocated with kmalloc() as there's nothing special
> > about it to go directly to the page allocator.
> > 
> > kmalloc() provides a better API that does not require ugly casts and
> > kfree() does not need to know the size of the freed object.
> > 
> > Replace use of __get_free_page() with kmalloc().
> > 
> > Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >   drivers/scsi/ipr.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> > index d207e5e81afe..5a212bfdeec2 100644
> > --- a/drivers/scsi/ipr.c
> > +++ b/drivers/scsi/ipr.c
> > @@ -2893,7 +2893,7 @@ static int ipr_sdt_copy(struct ipr_ioa_cfg *ioa_cfg,
> >   	       (ioa_dump->hdr.len + bytes_copied) < max_dump_size) {
> >   		if (ioa_dump->page_offset >= PAGE_SIZE ||
> >   		    ioa_dump->page_offset == 0) {
> > -			page = (__be32 *)__get_free_page(GFP_ATOMIC);
> > +			page = kmalloc(PAGE_SIZE, GFP_ATOMIC);
> >   			if (!page) {
> >   				ipr_trace;
> > @@ -3226,7 +3226,7 @@ static void ipr_release_dump(struct kref *kref)
> >   	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
> >   	for (i = 0; i < dump->ioa_dump.next_page_index; i++)
> > -		free_page((unsigned long) dump->ioa_dump.ioa_data[i]);
> > +		kfree(dump->ioa_dump.ioa_data[i]);
> >   	vfree(dump->ioa_dump.ioa_data);
> >   	kfree(dump);
> > 
>
> I _think_ we can replace this with kvmalloc, and allocate the entire
> dump buffer in one go. Once switched to kmalloc() it's kinda pointless
> to allocate separate page-sized buffers here.

kmalloc() performance is on par with __get_free_page(), but kvmalloc()
would be slower if it falls back to vmalloc(). 

I'm not familiar with the driver to say if this could be an issue here.
 
> Cheers,
> Hannes

-- 
Sincerely yours,
Mike.
