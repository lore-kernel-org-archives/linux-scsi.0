Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A667FBAE;
	Fri, 31 May 2024 06:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717138569; cv=none; b=dVa5lUARRvDX/p8UKQ5IitJD1TP+b0ui7yONq+Pkkdiodk670mYDTT8VNJfnKQl2NCj39Xdq+FieBIdPZoW9E60pn6KovQ3tjLMR1AcrelZNabdKL0TbLXVTdPjGskdgeUekkLe99Q7sOJ2n01/9IS3FC323vugOwjAKRw2jM9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717138569; c=relaxed/simple;
	bh=Z2x78tyjOmxvq45Jr4kGu00bxqSO5Z0CtTdWXo4qyUQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=peu7SMj+cW+fXD7WZbWWVITjEOqxrslpyhRrCV7zu1IOojihhLgWyZ37PZCuJa8qUGOCCm59wYRECTWpVZ67i2wCXaX2nG3EdlcwiLTyAoNPw3/Z5hG8klZZR9ahky38bHpTMO4c9tMcZtczH0daDzpbKaOOvtEwoY14f87O8xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CC83168BEB; Fri, 31 May 2024 08:56:00 +0200 (CEST)
Date: Fri, 31 May 2024 08:56:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	Roger Pau Monn?? <roger.pau@citrix.com>,
	linux-um@lists.infradead.org, linux-block@vger.kernel.org,
	nbd@other.debian.org, ceph-devel@vger.kernel.org,
	xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 02/12] block: take io_opt and io_min into account for
 max_sectors
Message-ID: <20240531065600.GA18681@lst.de>
References: <20240529050507.1392041-1-hch@lst.de> <20240529050507.1392041-3-hch@lst.de> <CAOi1vP-F0FO4WTnrEt7FC-uu2C8NTbejvJQQGdZqT475c2G1jA@mail.gmail.com> <20240531055456.GC17396@lst.de> <CAOi1vP-VXeOH-kShRKv-b=id1zN9tLiqOo8EKpOWoJuQp_Pm1g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOi1vP-VXeOH-kShRKv-b=id1zN9tLiqOo8EKpOWoJuQp_Pm1g@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, May 31, 2024 at 08:48:12AM +0200, Ilya Dryomov wrote:
> We should revert io_opt from opts->alloc_size to objset_bytes (I think
> it's what you meant to say but typoed).

Yes, sorry.

> How do you want to handle it?  I can put together a patch, send it to
> ceph-devel and it will be picked by linux-next sometime next week.  Then
> this patch would grow a contextual conflict and the description would
> need to be updated to not mention a behavior change for rbd anymore.

If that works for you I'd much prefer to include it with this series.
I'd be happy to write it myself.

