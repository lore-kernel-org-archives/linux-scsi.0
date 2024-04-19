Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287CFC127
	for <linux-scsi@vger.kernel.org>; Fri, 19 Apr 2024 06:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713507648; cv=none; b=Uo56KtCRUsIyBYmeO03W5IP9UVmk6HMauUAqiun9tC26/I4o/RTQ2MjnoWbqFy8jWUOVb5SRhn8oLSvCgxxnOQ1KOrwI/SHSyAGuISAPpTZ8nkRdyfS+QTUwE0m/Fcot2VmKcZnuAkuUoJZSbQPjAVqDzeQughvi7BUOTPNmaTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713507648; c=relaxed/simple;
	bh=3lD2+HiBGnS6KWtfWfTa1vDTgNKmztbRKqBXzLC0KHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iC8ENeks3ye1Rkg0/wHHs2EOo3pmg2SfC9xSK54pQzFnDWEem2Ptacyt7Z7wF8xKWOHBH8exhLDDxdH1HNMRT8yR3fVCl8vB+ZZPVbRB1VMYsMgOF/5ucCtTo/mRFfRL7TTvaT88mTrQFUFaHmhpUyXm2voIlOlZUBU1oVelHJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4F6C068CFE; Fri, 19 Apr 2024 08:20:35 +0200 (CEST)
Date: Fri, 19 Apr 2024 08:20:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	James Bottomley <james.bottomley@hansenpartnership.com>,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi_lib: Align max_sectors to kb
Message-ID: <20240419062035.GA12480@lst.de>
References: <20240418070015.27781-1-hare@kernel.org> <20240418070304.GA26607@lst.de> <5707dfc3-f8e2-4050-9bba-029facc32ca9@suse.de> <20240418145129.GA32025@lst.de> <410750a52af76fdc3bcf6265c9036037cb8141da.camel@suse.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <410750a52af76fdc3bcf6265c9036037cb8141da.camel@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Apr 18, 2024 at 06:46:06PM +0200, Martin Wilck wrote:
> > Why would we?  It makes absolutly no sense to inherit these limits,
> > the lower device will split anyway which is very much the point of
> > the immutable bio_vec work.
> > 
> 
> Sorry, I don't follow. With (request-based) dm-multipath on top of
> SCSI, we hit the "over max size limit" condition in
> blk_insert_cloned_request() [1], which will cause IO to fail at the dm
> level. So at least in this configuration, it's crucial that the upper
> device inherit the lower device's limits.

Oh, indeed.  Request based multipath is different from everyone else.
I really wish we could spend the effort to convert it to bio based
and remove this special case..

