Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5499F13B58F;
	Tue,  7 Jan 2025 08:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736238151; cv=none; b=WUsqsHz7LhPlf33n4TIYokAmAHkcAYLJamfWzSF2aTORz8mdR6QkoppMGMsucyInQ4NYbP/soqgyaONhIM6xR+DHEwB3tbNs09N0T/5buH/Z82ZGpwk6ybsJ7lnTtOuLhe97naqRrU7zKFDDDl3gqYcZ+JrhI51YrTmWYP+6wuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736238151; c=relaxed/simple;
	bh=HkVQNZ83GBUom0d8zXzHJMWinjVD3yIp9DGVRWP1CEc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J2i7QEt/2imqBKMfQFmNV5oht6Pmsv+Jilz+rw1KFxSkEsSe4hmj5EldJqEC3dK3P7k+Ent8G9Qz4ZjxtCtWC3eerxqjUUBEqACW1zz8KEqZPy2191yBvxVRvzzQX+Fgi9ELrlPtMH+fET5mKOwh5QYNqF7JiCevwvWUxjWTIEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3D7E568AFE; Tue,  7 Jan 2025 09:22:25 +0100 (CET)
Date: Tue, 7 Jan 2025 09:22:24 +0100
From: Christoph Hellwig <hch@lst.de>
To: Nilay Shroff <nilay@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Damien Le Moal <dlemoal@kernel.org>, Ming Lei <ming.lei@redhat.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	nbd@other.debian.org, linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 6/8] nvme: fix queue freeze vs limits lock order
Message-ID: <20250107082224.GB15960@lst.de>
References: <20250107063120.1011593-1-hch@lst.de> <20250107063120.1011593-7-hch@lst.de> <96c48ba0-3db5-4504-a456-e57440aa1b56@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96c48ba0-3db5-4504-a456-e57440aa1b56@linux.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 07, 2025 at 12:28:29PM +0530, Nilay Shroff wrote:
> > -	blk_mq_freeze_queue(ns->disk->queue);
> >  	lim = queue_limits_start_update(ns->disk->queue);
> >  	nvme_set_ctrl_limits(ns->ctrl, &lim);
> > +
> > +	blk_mq_freeze_queue(ns->disk->queue);
> >  	ret = queue_limits_commit_update(ns->disk->queue, &lim);
> >  	set_disk_ro(ns->disk, nvme_ns_is_readonly(ns, info));
> >  	blk_mq_unfreeze_queue(ns->disk->queue);
> 
> I think we should freeze queue before nvme_set_ctrl_limits(). 

Why?

