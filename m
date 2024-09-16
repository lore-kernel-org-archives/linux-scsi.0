Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE863EA7B;
	Mon, 16 Sep 2024 06:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726469066; cv=none; b=JNi41PDFNtlZIsfquUFGznvRoDp40ug2EdDbWvnIhE2Q17tcEWgfq32fiCfCoBsyjoHN/7Zq0ZwVDbt0TyzwOMqNd8ga9pze0FT5U3MwyleJUnADkF8/4Rh1DuipskDg+/2o6PvKwU41tGDr0nJYP5bkaviLWbks7oxhd9TsJJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726469066; c=relaxed/simple;
	bh=Cs9VusHTvu1MM2e1VEyNgbm7IWh22QJeOkKJCdg3jCc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VCPbTQstxyj0dUIFwNpkV+f6VJMvvJOBcBMaiC6wCATqmZ3ZHd/n98RiR3pcLa/Q7LO5n0py2teSEzHu3Uje71bpR4tpeVgMqmR7LX9nLnxn0TCIpzjAdaLEPuHOLO9w61r4bciKSDDFleVsmxmpCK+OoK6Xaydi7Nv6BSTA88g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 37EC6227AAA; Mon, 16 Sep 2024 08:44:13 +0200 (CEST)
Date: Mon, 16 Sep 2024 08:44:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	axboe@kernel.dk, martin.petersen@oracle.com,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, sagi@grimberg.me
Subject: Re: [PATCHv5 4/9] blk-integrity: consider entire bio list for
 merging
Message-ID: <20240916064412.GA15929@lst.de>
References: <20240913182854.2445457-1-kbusch@meta.com> <20240913182854.2445457-5-kbusch@meta.com> <20240914073011.GA30261@lst.de> <ZuW-_hu1-98SEjll@kbusch-mbp>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZuW-_hu1-98SEjll@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, Sep 14, 2024 at 10:51:10AM -0600, Keith Busch wrote:
> On Sat, Sep 14, 2024 at 09:30:12AM +0200, Christoph Hellwig wrote:
> > On Fri, Sep 13, 2024 at 11:28:49AM -0700, Keith Busch wrote:
> > > From: Keith Busch <kbusch@kernel.org>
> > > 
> > > If a bio is merged to a request, the entire bio list is merged, so don't
> > > temporarily detach it from its list when counting segments. In most
> > > cases, bi_next will already be NULL, so detaching is usually a no-op.
> > > But if the bio does have a list, the current code is miscounting the
> > > segments for the resulting merge.
> > 
> > As I explained in detail last round this is still wrong.  There is
> > no bio list here ever.
> 
> Could you explain "wrong"? If we assume there is never bio list here,
> then the current code is performing a useless no-op, and this patch
> removes it. That's a good thing, no?

The wrong thing primarily is the above commit log.  The code change
itself is correct, but we'd be better off killing the iteration over
the bio chain as well to make the code less confusing.
