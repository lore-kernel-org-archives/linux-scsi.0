Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC1A16DED5;
	Tue, 10 Sep 2024 17:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725988774; cv=none; b=spN6539eVio1XJGdYfSvlkymvgoisIJ4OrICJOalA9I30sAmMqh2oL6Ma/LxBkILoBx+k2FEEHYMHUvejAPn5grp6p3CUbruSjR5A3eOF1VsWao7ujyKzHXUqu2NFf0J+8W/Svr+Fn4qVQnxh/cev8KdnbGqS2Bq0OX87Nb6nMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725988774; c=relaxed/simple;
	bh=Jc2puORiYOo6/PGjGJmiUGrpWVJCAW6zaHCUDlRoGBY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hh2LkETeYIM1DYd2XglQWR94N4l8PJ5JrVryaeV7jpI5T1lnmHnolwh+NFnbn7wq2BgBElWAeD+AAPObHwjRLYs5kfQIjdeyE7rXp4lvuMWw6lSOAC1bDuRny0YJIH4yvt0awhwRuqFHYWneOpL7atzBw2KPBlmtVvQfVxVNV6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YranuHzJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YranuHzJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B28C4CEC3;
	Tue, 10 Sep 2024 17:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725988773;
	bh=Jc2puORiYOo6/PGjGJmiUGrpWVJCAW6zaHCUDlRoGBY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YranuHzJ9O+PkhMM3y3l1AnOorUXlqQcyQwRVZS/I2MXrKLTxkSEksGcflLatAMsC
	 4/kt+ZrS9ugZZ9yVCSCvuhUSfP0poZrCz3oE97PAhK2UkTim4klKquEY+Kx01d9X9P
	 MvCOFl3/enrM4UlnoDdDOSM9NgREXE+5+P7lrmPf/5NK5SLZsdp+OL80v9z7QjeYgd
	 M85c3CEG05kKH67y3PR4hAuE1wgiEMe8n3A2InyDWc/2cno2zny4TBHcSFAzSp+RPw
	 qv2w+atYYdvYmpvf4/NkCptgGCEREaftSw2v9ngdba8BKIEDs4cwpRrqe0+7h6BlnY
	 ghHs1MsCCVZVQ==
Date: Tue, 10 Sep 2024 11:19:30 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, axboe@kernel.dk,
	martin.petersen@oracle.com, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	sagi@grimberg.me
Subject: Re: [PATCHv3 09/10] blk-integrity: consider entire bio list for
 merging
Message-ID: <ZuB_ok2gkamg2_Sl@kbusch-mbp>
References: <20240904152605.4055570-1-kbusch@meta.com>
 <20240904152605.4055570-10-kbusch@meta.com>
 <20240910154843.GI23805@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240910154843.GI23805@lst.de>

On Tue, Sep 10, 2024 at 05:48:43PM +0200, Christoph Hellwig wrote:
> On Wed, Sep 04, 2024 at 08:26:04AM -0700, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > If a bio is merged to a req, the entire bio list is merged, so don't
> > temporarily unchain it when counting segments for consideration.
> 
> As far as I can tell we never do merge decisions on bio lists.  If
> bi_next is non-NULL here it probably is due to scheduler lists or
> something like it.

I think bi_next is always NULL, so the unlinking should be a no-op. But
just in case it isn't, the current unlinking will get the wrong segment
count from the resulting merge.
