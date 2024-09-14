Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BEBF78289;
	Sat, 14 Sep 2024 07:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726299020; cv=none; b=qttV5fnTBTIok6D41uMNEfSG8Dy64arSUmSs4jBdoiXpvB5tvwBXyWJwqL4/fUblwtacGCBRp+hF9VmwVfOpqmO6/POwJ9+xltaDPfJoUQyONvDJvuSlSbyavgnIm6pwv9MCgSZH+jIUCkj3iU90e0Lhr/IYjdOn+N0P/lask6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726299020; c=relaxed/simple;
	bh=gseX/pj785D+U2dE34wr7iwO/+H7hFcymDmL549u72k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lb8azd0Qp5qirfMeyP91QCVn5KC59vByjNforwHdcFegMZLoLAxPaS/zEPpTMvv59UORDTypMeVniq70aUrovUW+/oRYOXkwm4ykdsxYJFUo0XxdsXeu7IB72U2sBkF9e1kw35dEioA6P5SvK3IkDFaSnAF0yqvvjXPGcnoD0aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 63265227AAA; Sat, 14 Sep 2024 09:30:12 +0200 (CEST)
Date: Sat, 14 Sep 2024 09:30:12 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, sagi@grimberg.me,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv5 4/9] blk-integrity: consider entire bio list for
 merging
Message-ID: <20240914073011.GA30261@lst.de>
References: <20240913182854.2445457-1-kbusch@meta.com> <20240913182854.2445457-5-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240913182854.2445457-5-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Sep 13, 2024 at 11:28:49AM -0700, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> If a bio is merged to a request, the entire bio list is merged, so don't
> temporarily detach it from its list when counting segments. In most
> cases, bi_next will already be NULL, so detaching is usually a no-op.
> But if the bio does have a list, the current code is miscounting the
> segments for the resulting merge.

As I explained in detail last round this is still wrong.  There is
no bio list here ever.

