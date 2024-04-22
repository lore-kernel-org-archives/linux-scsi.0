Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F6A4AEC8
	for <linux-scsi@vger.kernel.org>; Mon, 22 Apr 2024 07:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713770934; cv=none; b=W0/e7l2A6V0sGnw1AR0lzENw3M4xCDJDJUBBvCA+7ty2YVYfzvwHVVfuhsn1YXHBuVVLvUfWf9+BMNTKP+Vz0hSznkrlMDwO0dIGugo526BGK/KKaTC37WmiMC9+eHGou7biB2q8FiV7Rn34kwqio3iLfEl9xiJ004C3/57FmrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713770934; c=relaxed/simple;
	bh=nFmgUjFS52Lo52E77EaZj7u7FZAMqovH66Dw2lTny3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ye0+WJ+AlXTLdy5wHjz2vcYiefGFSATR2ElNk+p2epdBtRNLOcRECu9/gVh7aQc1SkakpvhT+k3bvL1uTodOb74MLc2F0Vt9p35WXN1iVEKAbcWZRcwDgE11FOixoonCDx0sKYU0pHv47uB8a5FHQ2Yv8+GLYSsmzt4Nh5OHoI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 74A3468C4E; Mon, 22 Apr 2024 09:28:47 +0200 (CEST)
Date: Mon, 22 Apr 2024 09:28:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Hannes Reinecke <hare@kernel.org>,
	Mike Snitzer <snitzer@kernel.org>, Hannes Reinecke <hare@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	James Bottomley <james.bottomley@hansenpartnership.com>,
	linux-scsi@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: [PATCH] scsi_lib: Align max_sectors to kb
Message-ID: <20240422072847.GA4605@lst.de>
References: <20240418070015.27781-1-hare@kernel.org> <20240418070304.GA26607@lst.de> <5707dfc3-f8e2-4050-9bba-029facc32ca9@suse.de> <20240418145129.GA32025@lst.de> <410750a52af76fdc3bcf6265c9036037cb8141da.camel@suse.com> <20240419062035.GA12480@lst.de> <be267b46dd6bea6d82334d9d591c9a5054ff3b17.camel@suse.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <be267b46dd6bea6d82334d9d591c9a5054ff3b17.camel@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Apr 19, 2024 at 10:27:53AM +0200, Martin Wilck wrote:
> Well, it's just a matter of setting "queue_mode" in the multipath
> configuration.

Yes, and no.  We'd probably at very last want a blk_plug callback to
allow making decisions for entire large I/Os instead of on a per-bio
basis.

> Mike has pointed out in 76e33fe4e2c4 that many of the original reasons
> for introducing request-based dm-multipath have been obsoleted by
> faster hardware and improvements in the generic block layer. 

Yes.

> I am open for discussion on this subject, but with my distribution 
> maintainer hat on, I don't expect the default being changed for end
> customers soon. Actually, with NVMe rising, I wonder if a major
> technology switch for dm-multipath (which is effectively SCSI multipath
> these days) makes sense at this point in time.

Well, it'll take ages until anything upstream gets into the enterprise
distros, which array users tend to use anyway.  But I'd really love
to get the ball rolling upstream rather sooner than later even if there
is no need for immediate action.  The reason is that request based
dm multipath causes a lot of special casing in the block core and
dm, and that has become a significant maintenance burden.

So if you have a chance to test the current bio based path, or help
with testing a plug callback (I can try to write a patch for that,
but I don't really have a good test setup) we can start to see where
we are in practice in terms of still needing the request based stacking,
and if there is a feasible path to move away from it.
