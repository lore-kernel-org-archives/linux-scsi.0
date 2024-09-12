Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009FF1A7262;
	Thu, 12 Sep 2024 13:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726146913; cv=none; b=CsNY96ioVcaxL5JQ0at4Y2AffDOoNB2jIypKuDcbnpOe7nL7/N3PxaDbR7Q/TdD8d0qMVhZ+m7oZka0ZUxvfZJdxjTTget3F3rg2FK5NlbfGvGDZ1xM9cVC67BQEghqIAyNiW57HuRye+Rs3lMKBptBRUVbDsijJfa+yCg8MMfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726146913; c=relaxed/simple;
	bh=8FwGi51IJYvy5gcceZmNn4qu12uowoQwGBJfuAgu/ME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ssa3zbRdbB1rXi1TQpRJdcRibht2t8lyIP8HjvIXjW8p8xj0+NSfT8OI47IINv6WDsiL33YRBQyZVqm4idR4dedrCoDQTDTabWJsvEYQfBlTkG7nAAs0lQbXe7PKC4Z7wDJp+yzCd3dJ+MkONBaS0HDXCN3ay5eVpizYoYaXu2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 276EA227AAF; Thu, 12 Sep 2024 15:15:07 +0200 (CEST)
Date: Thu, 12 Sep 2024 15:15:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, kbusch@kernel.org,
	hch@lst.de, sagi@grimberg.me, James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC 1/4] block: Make bdev_can_atomic_write() robust
 against mis-aligned bdev size
Message-ID: <20240912131506.GA29641@lst.de>
References: <20240903150748.2179966-1-john.g.garry@oracle.com> <20240903150748.2179966-2-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240903150748.2179966-2-john.g.garry@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Sep 03, 2024 at 03:07:45PM +0000, John Garry wrote:
> For bdev file operations, a write will be truncated when trying to write
> past the end of the device. This could not be tolerated for an atomic
> write.
> 
> Ensure that the size of the bdev matches max atomic write unit so that this
> truncation would never occur.

But we'd still support atomic writes for all but the last sectors of
the device?  Isn't this really an application problem?

If not supporting atomic writes at all for unaligned devices is the right
thing to do, we'll need to clearly document this somewhere.  Any maybe
also add a pr_once to log a message?

