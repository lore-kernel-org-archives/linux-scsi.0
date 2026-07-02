Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667C338E5DE;
	Thu,  2 Jul 2026 06:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782975357; cv=none; b=FekWMV0QABssqjN7CEsEsMLQkZsoHQu7Amhak/a0XX8OiLejNxu0PBIAuSKbGLgC1s2RC+X8LcU5Qz8bsgyWkY2ety/2A3bN2UOdRnIUFilIa5wujenz9/dbsQPl5vOle5Gxg8HwlN09qlYZEHz1rstuR1N1kBnyRFhpCR4LFiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782975357; c=relaxed/simple;
	bh=mWf55jdPYw1HpItANrs5nXq3Vddp2VnNacj4qXYUtu8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CmGhMOK94dKTDvXbMOZsSX2mf+N7jhU+Gy/JFxPCplZDyWCA12hIit4zk6NRh94h2z0+Pn4XPF6r/BpVX5hDGcwnOs/cfy5wenel2XIC6fNiZAqsoWw1Tz2C6JIyIlxSJS+dPd/et+ggk4nv810ORjaJYtfb6yQAJ8f/fy/EGOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HcLmfsxi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HcLmfsxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC411F000E9;
	Thu,  2 Jul 2026 06:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782975355;
	bh=4LxdqCe0JeG9WUIp4s2Eh1SE3f8d7mrBDKUmnGn7Xi0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HcLmfsxi3T0iAUFYp7cB/qZ3Uineb9IskS1dkQQW4WIVabkDaHcJVHBpCI4NaS6Ls
	 Vra90xk3j9oPQDJSMAD9+aCrDP9Bh6DHyqrrhMeX4eNP7Id/Nd6Loc1cEF9ZAo9sr5
	 eOWFzEM/YYmz7sPqACqJvSAPwYGAvBP46g/ZkfO0PVlc2qlmZ4MyUYDrSr5hywdkxw
	 fnHDLDXDB65fclxc0bTinYzcj+PvQ7WcDc5LB6kF56dCnZZwnQDE7BHrNFDN3xxpOt
	 RPUxcrGGxcNPv2MsbRQR1SOcreux70ay2LimdqK25yWBOSISyGfD/+B/MIvCiX/O9K
	 15w+IRoJJI+jQ==
Date: Thu, 2 Jul 2026 09:55:48 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Hannes Reinecke <hare@suse.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Brian King <brking@us.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, wenxiong@linux.ibm.com
Subject: Re: [PATCH 3/4] scsi: ipr: use kmalloc() to allocate IPR dump buffer
 memory
Message-ID: <akYLdBME5kgyi8Rw@kernel.org>
References: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
 <20260630-b4-scsi-v1-3-494fb37ebe7b@kernel.org>
 <7c8f0e70-f49c-4614-af95-002fb2be11ba@suse.com>
 <akTjQVQQNdeO9M28@kernel.org>
 <d92f22b9-9a4d-42f2-ba67-0371f85fedd3@linux.vnet.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d92f22b9-9a4d-42f2-ba67-0371f85fedd3@linux.vnet.ibm.com>

On Wed, Jul 01, 2026 at 04:03:48PM -0500, Brian King wrote:
> On 7/1/26 4:52 AM, Mike Rapoport wrote:
> > On Wed, Jul 01, 2026 at 09:03:06AM +0200, Hannes Reinecke wrote:
> >> On 6/30/26 12:54 PM, Mike Rapoport (Microsoft) wrote:
> >>> IPR dump machinery allocates memory to save adapter's crash dump using
> >>> __get_free_page().
> >>>
> >>> This memory can be allocated with kmalloc() as there's nothing special
> >>> about it to go directly to the page allocator.
> >>>
> >>> kmalloc() provides a better API that does not require ugly casts and
> >>> kfree() does not need to know the size of the freed object.
> >>>
> >>> Replace use of __get_free_page() with kmalloc().
> >>>
> >>> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> >>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> >>> ---
> >>>   drivers/scsi/ipr.c | 4 ++--
> >>>   1 file changed, 2 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> >>> index d207e5e81afe..5a212bfdeec2 100644
> >>> --- a/drivers/scsi/ipr.c
> >>> +++ b/drivers/scsi/ipr.c
> >>> @@ -2893,7 +2893,7 @@ static int ipr_sdt_copy(struct ipr_ioa_cfg *ioa_cfg,
> >>>   	       (ioa_dump->hdr.len + bytes_copied) < max_dump_size) {
> >>>   		if (ioa_dump->page_offset >= PAGE_SIZE ||
> >>>   		    ioa_dump->page_offset == 0) {
> >>> -			page = (__be32 *)__get_free_page(GFP_ATOMIC);
> >>> +			page = kmalloc(PAGE_SIZE, GFP_ATOMIC);
> >>>   			if (!page) {
> >>>   				ipr_trace;
> >>> @@ -3226,7 +3226,7 @@ static void ipr_release_dump(struct kref *kref)
> >>>   	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
> >>>   	for (i = 0; i < dump->ioa_dump.next_page_index; i++)
> >>> -		free_page((unsigned long) dump->ioa_dump.ioa_data[i]);
> >>> +		kfree(dump->ioa_dump.ioa_data[i]);
> >>>   	vfree(dump->ioa_dump.ioa_data);
> >>>   	kfree(dump);
> >>>
> >>
> >> I _think_ we can replace this with kvmalloc, and allocate the entire
> >> dump buffer in one go. Once switched to kmalloc() it's kinda pointless
> >> to allocate separate page-sized buffers here.
> > 
> > kmalloc() performance is on par with __get_free_page(), but kvmalloc()
> > would be slower if it falls back to vmalloc(). 
> > 
> > I'm not familiar with the driver to say if this could be an issue here.
> 
> This code only runs when the adapter has hit a fatal error, so should be
> extremely rare. The memory is getting allocated while the storage adapter
> is in a failed state, so anything running on the system at the time could
> be stalled until recovery is completed. This memory is allocated and should
> be freed soon after the adapter recovers. In order for this code to
> run, the iprdump daemon must be running, which will then read out the dump
> after the adapter is recovered, and write it to disk, after which time, the
> ipr driver will free the kernel memory.

Thanks for the explanation!

So the allocation is not on the hot path and it seems to me that
performance differences between kmalloc() and slower vmalloc() won't move a
needle relatively to the entire dump procedure.

And it seems that GFP_ATOMIC here is a historical artifact rather than
actual necessity. ipr_get_ioa_dump() runs in a workqueue context without
locks held so nothing warrants GFP_ATOMIC.
 
> Thanks,
> 
> Brian
> 
> 
> -- 
> Brian King
> Power Linux I/O
> IBM Linux Technology Center
> 

-- 
Sincerely yours,
Mike.
