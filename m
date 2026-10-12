Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B221D9A66;
	Mon, 12 Oct 2026 14:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791817066; cv=none; b=JQFHpQ5Eu0koz6qVZN6TAu2ZYsqJd2WIQ0SsEIaDvkVWc/U1kYT+c/kkBR6Ld1HOoanpRcHFx9yvudmmTWCC9CwZC9uGyFgkRyl6Ax/O5DTc7l8u4BkAWb/oISW1xjQu3C8kvipBL5AKMbodf70x+o2JwgsYTGt90Zj5VfvbMo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791817066; c=relaxed/simple;
	bh=GgNXCH4agbTJpHHU4vXSD6pOVwbWam5q8VNsWom/pZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=utDDZ9owuMACq33a1aMj6d3XQrPTBpziJqB4bKTw8sPmAPdJsbLXB83+13VUxrk2WtyS9UMKQd/R8Nl+pZm2lUxMEJJcs2EOe43pfL056kv8l78nZPphziV5m04RmRuwoWTyt/rh4I1W4uRLtZe+5aouftTEBvQx5Y2O/KAAmkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B2235227A88; Mon, 12 Oct 2026 16:57:40 +0200 (CEST)
Date: Mon, 12 Oct 2026 16:57:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v5 4/9] block: add storage element management ioctls
Message-ID: <20261012145740.GB11255@lst.de>
References: <20261012130121.1902634-1-dlemoal@kernel.org> <20261012130121.1902634-5-dlemoal@kernel.org> <20261012143146.GB8609@lst.de> <46272028-d50a-40fa-806b-186f1f9575c2@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46272028-d50a-40fa-806b-186f1f9575c2@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Oct 12, 2026 at 04:56:18PM +0200, Damien Le Moal wrote:
> > 
> > Sashiko is obviously confused here about partitions that aren't supported
> > on zoned devices.  The conventional zones argument isn't entirely
> > stupid, but also not a great one.  Maybe we should add a check to just
> > reject the ioctls if conventional zones are present, as that would make
> > a mess of the depop anyway?
> 
> Not sure sure it makes sense. 3 things can happen:
> 1) The conv zone goes offline on remove
> 2) The conv zone goes read-only on remove
> 3) The conv zone content is totally unknown on restore since that is a
> destructive op.
> 
> So the "data loss" comment makes sense only in the case (2). All other cases
> lose the data anyway. As we make it clear that the user is responsible for sync
> & no io before issuing a remove ioctl, I am not sure if we really need to do
> anything special here. And we cannot really do anything special since we do not
> know which zones are going to be affected. So either we do nothing and let the
> user deal with potentially cached data not physically accessible anymore (not
> great), or like here invalidate everything.

Maybe add a comment?

