Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB831DC980;
	Mon,  6 Jan 2025 11:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736161202; cv=none; b=AJfG5UeX+5uecY4Mi/ocPFcaBmOrt90AaFjjhZ8rEXTHDdx+MdFkdgBrliHZ2KuJp+wS4Lf/0F8RpT0PNtWauYdeMITMouaTEp/YHrhZBW/2OhZ7Z3N8CkQ/p7pDAqJciOMTTYBvkBTwHuwSeWj4b6UWpw1LtF0E4g7pqPQEvv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736161202; c=relaxed/simple;
	bh=C4BwM8wTsUHS0fgeA6O3ZA3t343dToo5BoOQQik5JZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TjwHnphKc3KCxPkc7Y0jtRlogALeUq4dYJy1SidEMLuvgqVKBxnLlMKsSbcBWQP+TE0z1Kby7G+J0TZ4WYSw12vIduiOIbfmz77qH5gvHJ/Qb1RMl6+4UiU6FnAeXcwYY1gtbGkUyP6TofrgBVfIRvp3hcoyp3adekoaBvmVeqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4254968D05; Mon,  6 Jan 2025 11:59:57 +0100 (CET)
Date: Mon, 6 Jan 2025 11:59:57 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Ming Lei <ming.lei@redhat.com>, Nilay Shroff <nilay@linux.ibm.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	nbd@other.debian.org, virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 06/10] virtio_blk: use
 queue_limits_commit_update_frozen in cache_type_store
Message-ID: <20250106105957.GC21833@lst.de>
References: <20250106100645.850445-1-hch@lst.de> <20250106100645.850445-7-hch@lst.de> <07353499-b62d-488a-9575-12de5d9b6f2e@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07353499-b62d-488a-9575-12de5d9b6f2e@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 06, 2025 at 07:56:19PM +0900, Damien Le Moal wrote:
> On 1/6/25 7:06 PM, Christoph Hellwig wrote:
> > So far cache_type_store didn't freeze the queue, fix that by using the
> > queue_limits_commit_update_frozen helper.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> This should be squashed in patch 2, no ?

patch 2 is supposed to just be a mechanical conversion, and each
behavior change should be in it's own patch.

