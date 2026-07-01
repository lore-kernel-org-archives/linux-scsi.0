Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0A5284662;
	Wed,  1 Jul 2026 13:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782913847; cv=none; b=hzijQMk6u1PP9942463MMyKRLYSBrYl6Rm9q1xAV/DjlbHN8FeKWNmNJcsSqIOXbXC3PnGYu92aAnnvZywZqFw7/tFIysgRwJAHEgpsyWKKNnynCqFBe0HEowPNWbj2DR1rX+hPQ8IN/KkUTWBAC9a9E1jXGg8Zz3WOk1GvFw9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782913847; c=relaxed/simple;
	bh=TlqeOZh9bWT6AIgGajdGMaW5iesYgy8BaTb2Gi9XdvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DuD+SZ8FmLiUzlz9tTJWQ4CJd12yTiFaOIPlSLVGSJRN06IbuZsI0nDStHQb/PiyGM0kpl+s/Y+qMPccjyA7+92XCcnUJL3c6d1WDHWNBoEI8iZ7JWMFeFrf2dK3eW96P87yE/42PDHOBTbWElqZRcivNnG5bSheavMyv8Ms32U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nWWc9DcK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nWWc9DcK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E291F000E9;
	Wed,  1 Jul 2026 13:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782913845;
	bh=ie8R7oVh0jgJpbjerp22bW6nCIKQRE3693vV7WPgBXA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nWWc9DcKOfk9brqgIj8O56He2iH5VsBU3XE+1yCaLLVN+LUcuTKToV/2wwChCwT6S
	 NlxpFP7sq9JeVsc51fuD5bejBNcUsvdPbU481DWQZtb46PqEVF9yAeRTsLBp8rpBHQ
	 yaWaqdLYGOQ0JAh+5D9PFOvpuNFEPwDMelKnt00yu61YbFuhKyazGbcPsPrFwiPp2x
	 2HyADEiPSDGo4fppXAQRFo8JA/ZI7p/0NFBNIJwFTk21S0USj2Dx3X06T6eEvvmY4e
	 TucbpRuXzf2K/OSioOp/8nmSPxsojrfbx900L1GLuBEcMfNLwIdlXV3HG+f5RpWJjg
	 Mxl+PGg+RUZHw==
Date: Wed, 1 Jul 2026 16:50:40 +0300
From: Mike Rapoport <rppt@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Brian King <brking@us.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: Re: [PATCH 2/4] scsi: proc: use kmalloc() in proc writers
Message-ID: <akUbMCOyt2NHNWCM@kernel.org>
References: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
 <20260630-b4-scsi-v1-2-494fb37ebe7b@kernel.org>
 <9d23ada8-8b43-4ab8-beeb-b51c99ea0eba@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d23ada8-8b43-4ab8-beeb-b51c99ea0eba@oracle.com>

On Wed, Jul 01, 2026 at 11:52:21AM +0100, John Garry wrote:
> On 30/06/2026 11:54, Mike Rapoport (Microsoft) wrote:
> >   	if (!buf || length>PAGE_SIZE)
> >   		return -EINVAL;
> > -	if (!(buffer = (char *) __get_free_page(GFP_KERNEL)))
> > +	if (!(buffer = kmalloc(PAGE_SIZE, GFP_KERNEL)))
> >   		return -ENOMEM;
> 
> It would have been nice to use standard coding style checks for allocation
> failures, i.e.
> 
> 	buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
> 	if (!buffer)
> 		return -ENOMEM;

Sure.
 
> >   	if (copy_from_user(buffer, buf
> 
> 
> Regardless of that:
> 
> Reviewed-by: John Garry <john.g.garry@oracle.com>

Thanks!

-- 
Sincerely yours,
Mike.
