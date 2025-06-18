Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB9013E02D;
	Wed, 18 Jun 2025 05:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750225491; cv=none; b=LAjqsl52dFs6De076F6k40d8un2uG4PjNC7c3UUbjP6fjS1tFiE3hqbGPVD04Yxcow1DJYHk+NeaCd4I2GEYly/mp5YoUHiijiiUGxUOCKSPLPrSBWAyUn5x3jh+3+4Z9F7V4ZHnyWZNMwP1wDTjbwItFeGMXGdRp9ex0UKLHlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750225491; c=relaxed/simple;
	bh=oqbCLNf9FDlc1EYgqNMbz+08gM+1Nm+dhYlBy1mdxJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r9gsMXZ/QCEEmznqqfKy/TvpfR8qj6twfR95S0WaFOSSc3ai4Yf84frKAeBAWzqgsW1zmaNW9vb8s6ZQsjDVMDh6QDuhRJpxav8LaC1cCYnqe0MDSe96HrHAV58Syo8smR+XRsw1+kSQPwVAa5a0wrwLhkEeNvniFhYTBG+Bu64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1304268D0E; Wed, 18 Jun 2025 07:44:45 +0200 (CEST)
Date: Wed, 18 Jun 2025 07:44:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, "Ewan D. Milne" <emilne@redhat.com>,
	Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH] scsi: storvsc: set max_segment_size as UINT_MAX
 explicitly
Message-ID: <20250618054444.GA28826@lst.de>
References: <20250616160509.52491-1-ming.lei@redhat.com> <20250617050240.GA2178@lst.de> <aFEYYSCREiCMGBAH@fedora>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFEYYSCREiCMGBAH@fedora>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 17, 2025 at 03:25:21PM +0800, Ming Lei wrote:
> > @@ -473,7 +473,9 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_host_template *sht, int priv
> >  	else
> >  		shost->max_sectors = SCSI_DEFAULT_MAX_SECTORS;
> >  
> > -	if (sht->max_segment_size)
> > +	if (sht->virt_boundary_mask)
> > +		shost->virt_boundary_mask = sht->virt_boundary_mask;
> > +	else if (sht->max_segment_size)
> >  		shost->max_segment_size = sht->max_segment_size;
> >  	else
> >  		shost->max_segment_size = BLK_MAX_SEGMENT_SIZE;
> 
> This way works, but I prefer to set it explicitly in driver, instead of
> making block layer more fragile to deal with def ->max_segment_size
> if ->virt_boundary_mask is defined

The block layer already enforces this as it is a requirement.  It is
just the SCSI wrapper that broke it.  Without this proper fix iser
is still broken, and srp might or might not.

> - for low level driver, if ->virt_boundary_mask is defined, ->max_segment_size
> should be UINT_MAX obviously since it implies single `virt segment`.
> Setting UINT_MAX in driver has document benefit too.

No, it doesn't.  It means you need to cargo cult copy and paste code
instead of solving the problem in the proper place.

> - for logical block device(md, dm, ...), both ->virt_boundary_mask and
> ->max_segment_size may be set, and it is fine since logical block device
> driver needn't to deal with sg

Stacked devices should not inherit the hardware limits at all because
we split below them, but that's a separate story.  Either way this is
not relevant here as we don't have stacking drivers that use the
SCSI layer.

