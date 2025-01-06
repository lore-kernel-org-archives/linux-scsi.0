Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC05114900B;
	Mon,  6 Jan 2025 15:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177274; cv=none; b=iKGEoAhNkvX1XQhTN+zGIP7eGC5oJ5GaSyKuE8aIK3Wi7uHoXw1rTRQuMVoAkOzixC4LKwjrX9su0LJiXv5YZh8QwOgvxUatpLWqPl/k7yHYIBpP6swK0UrvBGOO3ye9oqraa5S/OfcOyTZGtdfyE8+ZYeqUxHTFpuHM6MRypZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177274; c=relaxed/simple;
	bh=Q+Sn7tP2GijySTssF07MDC+pdwKRbv7+6PiebqHDPdg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=unfkgThZBp85u5/zZaeH6kxAYC4pz1+u8BwNSbvU7ZZp0YReIBXFIvf9IKVxpsCvWV/DoQnq0f7cKdpYyQQuZAyL4VYGPI8KvZ2bCq0trsCfx0NqAoCMjnLJy1tD+GUXCB9HM0SFqf0+RdvH2iutr01YpWl+U/8So2r+inCzTXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B42BE68C7B; Mon,  6 Jan 2025 16:27:48 +0100 (CET)
Date: Mon, 6 Jan 2025 16:27:48 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Ming Lei <ming.lei@redhat.com>, Nilay Shroff <nilay@linux.ibm.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	nbd@other.debian.org, virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 06/10] virtio_blk: use
 queue_limits_commit_update_frozen in cache_type_store
Message-ID: <20250106152748.GB27431@lst.de>
References: <20250106100645.850445-1-hch@lst.de> <20250106100645.850445-7-hch@lst.de> <07353499-b62d-488a-9575-12de5d9b6f2e@kernel.org> <20250106105957.GC21833@lst.de> <3cf61c5f-b53b-43b6-90de-e42272f74e3f@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3cf61c5f-b53b-43b6-90de-e42272f74e3f@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 06, 2025 at 10:09:16PM +0900, Damien Le Moal wrote:
> Sounds good to me, but let's be consistent then: do not remove the
> freeze/unfreeze from virtio_blk in patch 2 and do it here in this patch.
> Otherwise, patch 2 *does* change the behavior of virtio_blk, introducing a bug
> (missing freeze around commit update).

Yeah, I'll fix it up.  As mentioned in the cover letter I just brushed
this up just enough to be presentable for now.
