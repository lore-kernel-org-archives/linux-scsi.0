Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0331F130A;
	Tue,  7 Jan 2025 13:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736257764; cv=none; b=qgDfDn4Dd9wBrzu3Bq7HnPPuzqJp/2d16tF2a23Zm2bjDACLqYfkRa3tFhkbLnpCOLWE9sTJuFTlwlW5RVL+ZWENBOl/ZJ4o+BDkV1cl/mvgU8OsvSgXUhuQ85XqDflxXx/Q05txCMGthaEiksMR2l0WT1NPMMIxuj5SE+2tq/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736257764; c=relaxed/simple;
	bh=3Gv76W5ur0Tq5IaHcilkHVUxApfKjaF4coyGu1ZiQH4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cQbbbH2DTOtvJflVCXB4ePhF6vmsGUfbClQQgb2GzDoCy0+yIFrvyYkyZCYvm9YDV0oFyzknxgwuyUCfliLxOjSyog9bvbwR4TYWgW/TOrOHE9foAsUP3sYHKpWdDzIvmqXDJ1Qg1gwJWeD4uB2XhOZkDI2S19x5Fz7fba17iw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 92DC968D05; Tue,  7 Jan 2025 14:49:14 +0100 (CET)
Date: Tue, 7 Jan 2025 14:49:13 +0100
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@redhat.com>
Cc: Nilay Shroff <nilay@linux.ibm.com>, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	nbd@other.debian.org, linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 4/8] block: add a store_limit operations for sysfs
 entries
Message-ID: <20250107134913.GA22046@lst.de>
References: <20250107063120.1011593-1-hch@lst.de> <20250107063120.1011593-5-hch@lst.de> <Z3zXANbFk6GBZg_z@fedora> <ae6b7727-64d6-4d9e-9bf5-951e38d8a768@linux.ibm.com> <Z30AsQq89_lcstNl@fedora>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z30AsQq89_lcstNl@fedora>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 07, 2025 at 06:25:20PM +0800, Ming Lei wrote:
> __blk_mq_update_nr_hw_queues() freezes queue before acquiring ->syfs_lock too.
> 
> So yes, it is a mess wrt. order between ->sysfs_lock and freezing queue.

Let's sort out the current freeze vs limits lock issue first.  Next step
is to kill sysfs_lock in it's current form.

