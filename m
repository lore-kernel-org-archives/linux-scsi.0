Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7974B1EF0B5;
	Tue,  7 Jan 2025 13:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736257922; cv=none; b=HcLr70MzBNxH0hXr0K4ytBTMh79NUImv0R4/ZJatGI6L0ms5MwIgnz7ubHgfhNg+ecHFaEsDeDmVgUCljfVTreeCyY1DUxmvb7aL0dOTXo+6M66OqcNuEKu53IZlQzIW5KKvns3t/PdVExEXCkjxUxOkzU9pMHsiCGHbCz2qMeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736257922; c=relaxed/simple;
	bh=yz6vbJm8iJofPPUgYLQWcg19/QI4zbwzO091muAh/xY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rR9ZcOAFrk6/k296bPIUh0t3XOyXEp6hMohPBIzGOx1XGOFub/QvJBsypIshhleI2AcNW8lC358DJ7UMOm4lALOens5K3vEJC4oe5RVWNpk/CgwDZiFbO0PJaahx2MQVind3OUtvbfaEZead2VrTdw1Ejx6J7tXcq9a6bCulP8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 830B868D07; Tue,  7 Jan 2025 14:51:53 +0100 (CET)
Date: Tue, 7 Jan 2025 14:51:53 +0100
From: Christoph Hellwig <hch@lst.de>
To: Nilay Shroff <nilay@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Damien Le Moal <dlemoal@kernel.org>, Ming Lei <ming.lei@redhat.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	nbd@other.debian.org, linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 3/8] block: don't update BLK_FEAT_POLL in
 __blk_mq_update_nr_hw_queues
Message-ID: <20250107135153.GB22046@lst.de>
References: <20250107063120.1011593-1-hch@lst.de> <20250107063120.1011593-4-hch@lst.de> <220cdd33-527f-405d-90af-2abaace36645@linux.ibm.com> <20250107082145.GA15960@lst.de> <90ae40c5-b695-4e17-8293-6a61648ed24a@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90ae40c5-b695-4e17-8293-6a61648ed24a@linux.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 07, 2025 at 02:53:40PM +0530, Nilay Shroff wrote:
> When I applied you patch on my system and access io_poll attribute
> of one of my nvme disk, I see it returns 1, though I didn't configure 
> poll queue for the disk. With this patch, as we're now always setting 
> BLK_FEAT_POLL (under blk_mq_alloc_queue()) it return 1. So when I haven't
> configured poll queue for NVMe driver, shouldn't it return 0 when I access 
> /sys/block/nvmeXnY/queue/io_poll ?  

While that was the case with the previous RFC series it should not be
the case with this version, as the nvme driver does not enable the
poll tag set map unless poll queues are enabled.  I also double checked
that I do not see it on any of my test setups.

