Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4927936D9E9;
	Fri,  3 Jul 2026 07:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783064958; cv=none; b=TdNRjB3DsH8B50x7ijacJ6Ay57XYQvT1EYlm1tnO+JDBVV1M7o1mgMpuc/TYH4VRygX2sUVr6+RnP1tBI7GRQQaDlOKpNTPj3iCfJcpnBQYT4sgaoYs7/FD6eHA9yt1E+7aFJ0OwCd1OetaUv/WoDRpXMMbWmV8q/GrjOMcZo64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783064958; c=relaxed/simple;
	bh=kVPXDPzXW/Ltl+aT6WHG2pxjCTzzdNh7Q2gCVmhy5gc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DBF/PX8mdjaEPbgJU/PYd45WZl4JzscVD0b/lBTKai//2KsKjqctD3efmCqIyuYK4G6DiKvtMMbB/eWYIyymwoVdALtSL9gHULfcIzRZ8pAmoPBaZO9RNm1ncayIuPuHQwERxomU2LTkfac6v93ML5bt9EztEDCOQEH6gyt8wxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KGndhYQa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KGndhYQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4B51F000E9;
	Fri,  3 Jul 2026 07:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783064956;
	bh=CIkFMzoXDcnD9nBYqCI1NBbFTtaOgztPoTY9RG1HHBE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KGndhYQaN4X8CaaQEmB0znlSGwQ/HhvM9w2Fh8Y3LCqMZLD34jkaonGoVr8naz/8R
	 8odk1aZvEVWkWOdMsKSj8HQE6EsO+iC9Ocw4h2DuiQSpU596U9wAJIeK3SBQTqGHY0
	 A+oQ2LOV+CRewhiM6DXQOxpws8ac4znk5faLJAy/WTGvC5Vt8tsBVYpPleIlf2aB4w
	 TQBLEVQr5O48u1+B+12LUe1qWExBY45ujKtKsPWIkYCDOTX5NeWCg2AXZ4LC6JUNhR
	 1sn5tUPOClaeL94RZuGO9B31uOuAAtYbhXFvQtvfAGjoF/4U+INVCRYLR+hi8fdAer
	 Tth7J2zspZEFQ==
Date: Fri, 3 Jul 2026 10:49:09 +0300
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
Message-ID: <akdpddKBt7gV6po5@kernel.org>
References: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
 <20260630-b4-scsi-v1-3-494fb37ebe7b@kernel.org>
 <7c8f0e70-f49c-4614-af95-002fb2be11ba@suse.com>
 <akTjQVQQNdeO9M28@kernel.org>
 <d92f22b9-9a4d-42f2-ba67-0371f85fedd3@linux.vnet.ibm.com>
 <akYLdBME5kgyi8Rw@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akYLdBME5kgyi8Rw@kernel.org>

On Thu, Jul 02, 2026 at 09:55:56AM +0300, Mike Rapoport wrote:
> On Wed, Jul 01, 2026 at 04:03:48PM -0500, Brian King wrote:
> > On 7/1/26 4:52 AM, Mike Rapoport wrote:
> > > On Wed, Jul 01, 2026 at 09:03:06AM +0200, Hannes Reinecke wrote:
> > >> On 6/30/26 12:54 PM, Mike Rapoport (Microsoft) wrote:
> > >>> IPR dump machinery allocates memory to save adapter's crash dump using
> > >>> __get_free_page().
> > >>>
> > >>> This memory can be allocated with kmalloc() as there's nothing special
> > >>> about it to go directly to the page allocator.
> > >>>
> > >>> kmalloc() provides a better API that does not require ugly casts and
> > >>> kfree() does not need to know the size of the freed object.
> > >>>
> > >>> Replace use of __get_free_page() with kmalloc().
> > >>>
> > >>> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> > >>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > >>> ---
> > >>>   drivers/scsi/ipr.c | 4 ++--
> > >>>   1 file changed, 2 insertions(+), 2 deletions(-)
> > >>>
> > >>> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> > >>> index d207e5e81afe..5a212bfdeec2 100644
> > >>> --- a/drivers/scsi/ipr.c
> > >>> +++ b/drivers/scsi/ipr.c
> > >>> @@ -2893,7 +2893,7 @@ static int ipr_sdt_copy(struct ipr_ioa_cfg *ioa_cfg,
> > >>>   	       (ioa_dump->hdr.len + bytes_copied) < max_dump_size) {
> > >>>   		if (ioa_dump->page_offset >= PAGE_SIZE ||
> > >>>   		    ioa_dump->page_offset == 0) {
> > >>> -			page = (__be32 *)__get_free_page(GFP_ATOMIC);
> > >>> +			page = kmalloc(PAGE_SIZE, GFP_ATOMIC);
> > >>>   			if (!page) {
> > >>>   				ipr_trace;
> > >>> @@ -3226,7 +3226,7 @@ static void ipr_release_dump(struct kref *kref)
> > >>>   	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
> > >>>   	for (i = 0; i < dump->ioa_dump.next_page_index; i++)
> > >>> -		free_page((unsigned long) dump->ioa_dump.ioa_data[i]);
> > >>> +		kfree(dump->ioa_dump.ioa_data[i]);
> > >>>   	vfree(dump->ioa_dump.ioa_data);
> > >>>   	kfree(dump);
> > >>>
> > >>
> > >> I _think_ we can replace this with kvmalloc, and allocate the entire
> > >> dump buffer in one go. Once switched to kmalloc() it's kinda pointless
> > >> to allocate separate page-sized buffers here.
> > > 
> > > kmalloc() performance is on par with __get_free_page(), but kvmalloc()
> > > would be slower if it falls back to vmalloc(). 
> > > 
> > > I'm not familiar with the driver to say if this could be an issue here.
> > 
> > This code only runs when the adapter has hit a fatal error, so should be
> > extremely rare. The memory is getting allocated while the storage adapter
> > is in a failed state, so anything running on the system at the time could
> > be stalled until recovery is completed. This memory is allocated and should
> > be freed soon after the adapter recovers. In order for this code to
> > run, the iprdump daemon must be running, which will then read out the dump
> > after the adapter is recovered, and write it to disk, after which time, the
> > ipr driver will free the kernel memory.
> 
> Thanks for the explanation!
> 
> So the allocation is not on the hot path and it seems to me that
> performance differences between kmalloc() and slower vmalloc() won't move a
> needle relatively to the entire dump procedure.

I looked more closely at the code. Currently the dump continues as long as
it can allocate memory and even if memory for the entire buffer is not
available there still will be some data in the dump.

With a single allocation that may be as large as 80M
(IPR_FMT3_MAX_IOA_DUMP_SIZE), an allocation failure would mean no data
would be dumped at all.

I think the current model is better than using a single kvmalloc()
allocation for the entire buffer.

I'm going to send v2 that keeps kmalloc() and only changes GFP_ATOMIC to
GFP_NOIO if there are no objections.

-- 
Sincerely yours,
Mike.
