Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C29EEBA
	for <linux-scsi@vger.kernel.org>; Mon,  5 May 2025 06:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746425201; cv=none; b=pUxhh5t8tDD8n/X7DadUQmiEMIlY0CNljrqbIIBphJW3n4Fngdbj8CodXP78NPhLxdlC9EgrTfLtUv81nd+4g3DYHV6UlUk5RT861qLc3BIo65sQaDyiFkZM4IjtyC2PxUxOgFJ4H5TdsoaZaAd7yR9tNf3IpI9rSsbdKuElPbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746425201; c=relaxed/simple;
	bh=0HsuyfhRoX9evl6EAmxhYUSC1Yl/z15E4fxbv/eFkGg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kSYmlcQ0oxKtJf6yrhp38cKFNiSteyAEqnekUnVzf/j0kxY2OcQL7y0ldIfudOQVp1lc0qYav6gCkXxgUfEAWoQ7/XKLBA7l4p4eZTYN/6mb7/W7vvZYkCenrW+hctdFUboGAcu2pd2apENMCoLQ3nTs/et8i4h13g+i9j61EKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6C61A68C7B; Mon,  5 May 2025 08:06:34 +0200 (CEST)
Date: Mon, 5 May 2025 08:06:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: remove the stream_status member from
 scsi_stream_status_header
Message-ID: <20250505060633.GA21601@lst.de>
References: <20250501181623.2942698-1-hch@lst.de> <399f47d3-2a78-4321-98c0-990f35dc0f9a@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <399f47d3-2a78-4321-98c0-990f35dc0f9a@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, May 03, 2025 at 12:05:46PM -0700, Bart Van Assche wrote:
> There is an implicit assumption behind this patch, namely that the compiler 
> does not insert padding bytes between struct
> scsi_stream_status_header and struct scsi_stream_status. Shouldn't this be 
> made explicit with a BUILD_BUG_ON() expression?

We make that assumption for all our naturally alignend structures 
in every on-disk and on the wire structure.

