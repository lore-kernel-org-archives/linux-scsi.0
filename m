Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FAA19D09F;
	Tue, 10 Sep 2024 15:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725983038; cv=none; b=nf/mn5YF+zx6uAOWbqiZfSvExsIrtehilTXoSV5atlq/0p0YzbMmUhld5Y7VTJegt4OaT7cLJGZC26q+waZB86Q1dwGaAgfISA9Su7kVvaLhc4nUQzJNPpSEdPdh45eayiWG8UJB55paD8fkGNzUAQWotVsdWWi/iRS4LYIYyhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725983038; c=relaxed/simple;
	bh=7nxfyoyoRI3WlrOoJqkc8YFaji2APqHkA/d4vGg71y4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iAVRii/aK0PUdeihVOpigG+PSm9h04ZSbpvENmuUEBfi7XYlZ62xuDJzzML2olOrI/O/I3xm0XkBp82LoDzzq5eaaNMc5mIYIlLXfnZ55fROWg449IaFRiXdsx+6K0ejum6FN03mv1wyioB14EKcEbJRYJODzQwH1PBJTIvZPRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2C83468AFE; Tue, 10 Sep 2024 17:43:52 +0200 (CEST)
Date: Tue, 10 Sep 2024 17:43:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, sagi@grimberg.me,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv3 07/10] blk-integrity: simplify mapping sg
Message-ID: <20240910154351.GG23805@lst.de>
References: <20240904152605.4055570-1-kbusch@meta.com> <20240904152605.4055570-8-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240904152605.4055570-8-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Sep 04, 2024 at 08:26:02AM -0700, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> The segments are already packed to the queue limits when adding them to
> the bio, so each vector is already its own segment. No need to attempt
> compacting them even more.

Well.  For one the immutable bio API is explicitly designed so that
the callers don't need to know the limits, so this isn't really
true.

And the other thing the map_sg helpers for data and metadata do is
cross-bio merges, that is if the end of one bio is contiguous with
the start of the next, it will merge the segments.  I don't really
know how useful that is there days - maybe we can removed it with
a proper rational after a bit of testing.

Again the current code closely mirrors the code for mapping the data
bvecs, and I'd preferably keep them as close as possible.
