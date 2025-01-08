Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BC219F133;
	Wed,  8 Jan 2025 15:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736350155; cv=none; b=eCn9XL+2rEfzNGD9bE9bNZ/LmV0v1vIP0wTT6K1W6ymmdVRKCrTzgTJ/AidDVr/vAiOglKTWe4T6NdbI8CbK+35l+f6o85qEgwyXWkmkpzCSjh76PJ5vAoey/mQ2tEIXtz3IpS1qWmJKr/zhkvUoRPb0D3Q8Jy+pwt6KTb4laok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736350155; c=relaxed/simple;
	bh=PxDXBix9Vkf9rlHacss1vKZYtKq6qzLG9Usz7Z81wHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JUBEo/rRWEYJl1kchdRXbZpSt5R56FnR/KVxJOWPxLQ1rU3T9KL8Y39wwx5li/+3p3cQI0JTIM21LaqOO8icmjF9aTz4xdQpngvmeRRa9P5jhmq9SImy8DQ8uO/5PNFssXRZKzYcwg7CS2qwFXM8eKE8jVHhujb4Rw2BZ8bYieI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F1EFA68BFE; Wed,  8 Jan 2025 16:29:08 +0100 (CET)
Date: Wed, 8 Jan 2025 16:29:08 +0100
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Damien Le Moal <dlemoal@kernel.org>,
	Nilay Shroff <nilay@linux.ibm.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, nbd@other.debian.org,
	linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 05/10] block: fix queue freeze vs limits lock order in
 sysfs store methods
Message-ID: <20250108152908.GB24792@lst.de>
References: <20250108092520.1325324-1-hch@lst.de> <20250108092520.1325324-6-hch@lst.de> <Z35Vl6ob0zLH_Kh-@fedora>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z35Vl6ob0zLH_Kh-@fedora>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 08, 2025 at 06:38:15PM +0800, Ming Lei wrote:
> Looks fine, but now ->store_limit() is called without holding
> ->sysfs_lock, maybe it should be documented.

Ok, I had this in my own commit log, but it got lost when I stole
Damien's much better one instead :)

I assume you're fine with just documenting it in the commit log?

