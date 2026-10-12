Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6AB48876E
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 12:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791807903; cv=none; b=qepvwBgqXfo1LcCtPuh8N9riGD1cTDwQ4iDdP3JaXCFnEZdiZ7YruZW5crpJvCs67vBu/68gDPWbSOs+WEjy27vMva277fbDjqzr15jcktCQcPY4Q9BEJ9Bhdr5RTAkaijz1c4kV3Ay0xFwu4TgFsyd5g1xecJRod5vjKjPDvSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791807903; c=relaxed/simple;
	bh=ZxE7Ds6CNVILe9lTB2vlYeqJMBgu0/aIlZn4d2urZLA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o3kT5MCrKjyYQAr7F8Xb63u/Eyuk+4DmGD3E5GFT3xbiTYXULIxamCALjVS7/v5Mzlos45bV2dRzQIpnnpqDNLlEQbPSpZbcGtGY72EWRQNjQOEoQRB5qwXPC19wt1uOTIh0nK2SlN9gV7fZuN1sQwtuScyCm4F2d4eXt+w2XRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 086C66732A; Mon, 12 Oct 2026 14:24:58 +0200 (CEST)
Date: Mon, 12 Oct 2026 14:24:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, John Garry <john.garry@linux.dev>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 7/8] scsi: scsi_debug: Improve lock context
 annotations
Message-ID: <20261012122457.GB31394@lst.de>
References: <cover.1791499174.git.bvanassche@acm.org> <e2ddd0bc90e0b5eb0b7eb72c0013d7e2e10be8fe.1791499174.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2ddd0bc90e0b5eb0b7eb72c0013d7e2e10be8fe.1791499174.git.bvanassche@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 08, 2026 at 03:42:18PM -0700, Bart Van Assche wrote:
>  static inline void
>  sdeb_meta_read_lock(struct sdeb_store_info *sip)
> +	__acquires_shared(&sip->macc_meta_lck)
> +	__context_unsafe(/*conditional locking*/)
>  {
> -	if (sdebug_no_rwlock) {
> -		if (sip)
> -			__acquire(&sip->macc_meta_lck);
> -		else
> -			__acquire(&sdeb_fake_rw_lck);
> -	} else {
> +	if (!sdebug_no_rwlock) {

Why can't this be modelled using a __acquire variant?  And if you
add __context_unsafe(/*conditional locking*/) please add a detailed
comment why that is needed, otherwise no one is going to understand
this in the future.

