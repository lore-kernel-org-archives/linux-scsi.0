Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C4A15821F;
	Fri, 31 May 2024 12:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717158245; cv=none; b=biJwa0f04Xhks6DQprMRDPMo/AINUT7LFROTjuGlZT2q/ps77CYVqi855i2FcfkBFvR/cZ6+Xngs0EYU60xnqjNMpo6qzCZF8V+QOcIy3rVFQ4h/HcKrLYL3SlUcuPpAufRrj1yw2YWvhL0aoGsCvr3B/bnlwQsBylS6YGJz98Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717158245; c=relaxed/simple;
	bh=/zV/0BX+Nflg7gyvvmEduFrAr2NotCKunw+ajwML+NM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YPBcp3FsEwjVz7AK4p1arqDh5JrhrnzkjALEaY7xsd2XRHPlHuNS9mDJbA8eHB1f4XBfumdH7pu29CLwWwNz/FCmoa+pOZjwRTlxM/49Y3u3trZuLSMWlaLR+Y2WpQQ5y5J0tC0ORyICune04UedxSdaTiaryUz/J1BjAowKbaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5085768BFE; Fri, 31 May 2024 14:23:56 +0200 (CEST)
Date: Fri, 31 May 2024 14:23:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	Roger Pau Monn?? <roger.pau@citrix.com>,
	linux-um@lists.infradead.org, linux-block@vger.kernel.org,
	nbd@other.debian.org, ceph-devel@vger.kernel.org,
	xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org
Subject: Re: convert the SCSI ULDs to the atomic queue limits API v2
Message-ID: <20240531122356.GA24343@lst.de>
References: <20240531074837.1648501-1-hch@lst.de> <yq17cfadwd0.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq17cfadwd0.fsf@ca-mkp.ca.oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, May 31, 2024 at 08:07:54AM -0400, Martin K. Petersen wrote:
> If you have other block layer changes depending on this series we'll
> probably need a shared branch. I'll need to make several changes to sd.c
> to fix reported issues, including a couple in the zeroing/discard
> department.

Yes, I also want to move the various feature flags that currently
abususe queue->flags into the queue limits.  In the worst case I could
delay that for another merge window, but a shared branch would be
a lot nicer.

