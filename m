Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7745C4204D;
	Tue, 10 Sep 2024 15:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725982252; cv=none; b=ndHFX4d9VMce7dI8QJ91xzUnsQ7fRGIPIEZeGIXd1xSiA3B5jg3VcxG42diyfd4pOmlCGEnBbdjhuIMBuRPArdrV9yic1jif5TqQIxJFD3PLmm6lkfuec5wg4J+XrpTg0bBSpmhWWwUWGfLMONMaftdkBB4TJpXUCWsj9r0rAXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725982252; c=relaxed/simple;
	bh=MehRpKy+E5XmfVxihgrh0BaNToKNAlGSvRcpuKRL20I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EsI46OkBmNe+gK8OEksmAjQ9kOtaw4tz3h0Doo7aeSjqILv7PbdvIAkifS4qgKDPLplGCr6NPBbEuRrdO81yMDifsnXBbIBlSl8vzCI9GN1oY+aVWxF/mopThOYpBfUsZMz7joDpKkaVl9UdpquTU9QEosfJXMPhXGo45y4ZFBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2688E227AAE; Tue, 10 Sep 2024 17:30:47 +0200 (CEST)
Date: Tue, 10 Sep 2024 17:30:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, sagi@grimberg.me,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv3 02/10] block: provide helper for nr_integrity_segments
Message-ID: <20240910153046.GB23805@lst.de>
References: <20240904152605.4055570-1-kbusch@meta.com> <20240904152605.4055570-3-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240904152605.4055570-3-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Sep 04, 2024 at 08:25:57AM -0700, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> This way drivers that want this value don't need to concern themselves
> with the CONFIG_BLK_DEV_INTEGRITY setting.

Looks ok:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Although I wonder if we should simply define the field unconditionally
given that it is only 2 bytes wide and packs nicely.

