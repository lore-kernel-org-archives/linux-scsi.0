Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3991BDAA0;
	Thu, 12 Sep 2024 15:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726153846; cv=none; b=WTMBzYVH3NWxG9zQ3ORc1rAPsBbqMFTTLHPlpxYezasCe8qrRmX51itOr90hGlwGcEPXv047yG/K7s/fKGtAvjhyImpBda+Xqtg4clG/JtwMBdJBr0Y+LuW0HhWDjZXqZ9AOOrrkkKwEtBNv4UG7ar8hz3Tl9MBMs0AYLRpjs2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726153846; c=relaxed/simple;
	bh=/IMSisvC+57atZwh2QHS9X09SSaX8g2NdIJj7j4DCV0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bY8JCVSBJpfTZOzlXBsTokFxXPoP0/bqJIDcGRHiAdu+DKcJSLP7LEET74Vz0VIFCfbHWOMV91YGH4mKXigQMX2jyKWMzMqx14TENEQlm23uegwMQvhhhenROygY6GmiMOZnO0DR1S2SdlN55B15q1xs2IbBvv99R9U2AyNi3aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A577D227AAF; Thu, 12 Sep 2024 17:10:38 +0200 (CEST)
Date: Thu, 12 Sep 2024 17:10:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, song@kernel.org,
	yukuai3@huawei.com, kbusch@kernel.org, sagi@grimberg.me,
	James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC 4/4] md/raid0: Atomic write support
Message-ID: <20240912151038.GA5858@lst.de>
References: <20240903150748.2179966-1-john.g.garry@oracle.com> <20240903150748.2179966-5-john.g.garry@oracle.com> <20240912131803.GD29641@lst.de> <340e4306-4442-4276-b420-6fee8ed97a7e@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <340e4306-4442-4276-b420-6fee8ed97a7e@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Sep 12, 2024 at 03:48:09PM +0100, John Garry wrote:
>
> I actually now think that I should change bio_split() to return NULL for 
> splitting a REQ_ATOMIC, like what do for ZONE_APPEND - calling bio_split() 
> like this is a common pattern in md RAID personalities. However, none of 
> the md RAID code check for a NULL split, which they really should, so I can 
> make that change also.

bio_split is a bit of a mess - even NULL isn't very good at returning
what caused it to fail.  Maybe a switch to ERR_PTR and an audit of
all callers might be a good idea.

