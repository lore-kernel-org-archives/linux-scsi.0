Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7991DC9AA;
	Mon,  6 Jan 2025 10:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736161151; cv=none; b=Ucl+/mXHb6TjPQbEwpqnFBioyG4YitVDNjRPvErp1CAXQCCZbK5lCwEDFge+WJAQKIEJvPZcwNAOxmxx5eaITgmADZQayd2fB1AjTuREu/6XsdRnMEVB8nKqO7Fb6/hMct11vGrtHCcT2qut2aaOHvfFTIWreL6Nh9Ci+U1Y/Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736161151; c=relaxed/simple;
	bh=IeKoNlvkzTkgU9FT99S2kHoF8QpEbi/1d9veU/3SYew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QTv27Bd9jEzB4GVgbSQ8e77FgvIBO+0FLJXWJaEf6VfzJ0aPCrT4t5b3CwKNDfBdNt0dB7mbabE0RC+Qu3+Aq3j6sEMzhjs88Y2ieWpF/Xf+xcFSntyOhWLxZfXQp590mmuMxem0pIWi9agWiklLUW7T987hbmQTblsJIur9KfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6422968CFE; Mon,  6 Jan 2025 11:59:05 +0100 (CET)
Date: Mon, 6 Jan 2025 11:59:05 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Ming Lei <ming.lei@redhat.com>, Nilay Shroff <nilay@linux.ibm.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	nbd@other.debian.org, virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 05/10] block: don't update BLK_FEAT_POLL in
 __blk_mq_update_nr_hw_queues
Message-ID: <20250106105905.GB21833@lst.de>
References: <20250106100645.850445-1-hch@lst.de> <20250106100645.850445-6-hch@lst.de> <1538d5e9-eb59-49a7-90c8-77a290f3a420@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538d5e9-eb59-49a7-90c8-77a290f3a420@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 06, 2025 at 07:55:30PM +0900, Damien Le Moal wrote:
> > +	lim->features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT | BLK_FEAT_POLL;
> 
> Why set BLK_FEAT_POLL unconditionally ? This is changing the current default
> for many devices, no ?

Due to the runtime check it doesn't actually change behavior.  But
it does change the value read from sysfs, which also need extra check
for poll queues.  But the entire point is that we don't have to update
this field when updating the queues, so yes it should be set
unconditonally.
