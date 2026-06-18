Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659622E7373
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 21:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781819740; cv=none; b=mnuI0UAm3vdn3fyfZkyWsTvYUpx69aHa8c4hKWTpQL0MIfKZ43/nJoDerEaQhL1dPXvz8WXqhRYgcIPVhM+U2iz/o0Ezx3z+8rmWx/aZy1IO/Ab789rnggzKFYPEq+WNoFuRbJFjJvbfFlhu2DVNkmezLVlc4saVPCNUtmrceY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781819740; c=relaxed/simple;
	bh=MHeE9gSz/1T0NL4o3NPZo9mrwnldmtumUWG12dasCNU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XnlnUcx2qVTQZ2EH+qk4XFarOuu+b7IhItHUwBI5uN5R85iS/uPoHfcVBbWBbIX44yJb4VU3r5CCkqSW0nS2nY+Va9hQHKeYptQH12lcciYxgyyJt7X8vmoCMR/Tzkn9ukxU700wTI2zzNgIOSCwVbr7RVcf3XVvCLrzqOAp9ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LaZdDqJQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LaZdDqJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1BF1F000E9;
	Thu, 18 Jun 2026 21:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781819739;
	bh=MHeE9gSz/1T0NL4o3NPZo9mrwnldmtumUWG12dasCNU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LaZdDqJQFQM/+fHlbtHBfljdpJ2L9v4z6KKjR0sTW4MM8+0CQwn4aUgC3JMpBj2/S
	 TCXsVgv9SzdCQNP/151G3Nsmkf1OUXgvmaSNSk6Dme77MgB3E2+KDAqSwJYhWKlBod
	 WYAxzqrrSIe8+hLeh26LqNvgUwYOKHnHXnP3ZGJQ5Rq8lAP2T7zpPzXFW9jM07Bpox
	 Ok8wfSBnn+jaOAvUEXcvpYqKYFDl4WEAZjhugZW+Pm0Ik+LS5ByGzMfk8IUFOLwDQL
	 +5NiRdD+r4h5q4aZNAm/Iy+5i1e7RvHuvNEKCgGlMHyxikj883bDpg+JZQXzvaCCil
	 EXrsUDbQvs+zw==
Date: Thu, 18 Jun 2026 15:55:36 -0600
From: Keith Busch <kbusch@kernel.org>
To: Maurizio Lombardi <mlombard@arkamax.eu>
Cc: Hannes Reinecke <hare@suse.de>, John Meneghini <jmeneghi@redhat.com>,
	Maurizio Lombardi <mlombard@redhat.com>, hch@lst.de,
	chaitanyak@nvidia.com, bvanassche@acm.org,
	linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
	James.Bottomley@hansenpartnership.com, emilne@redhat.com,
	bgurney@redhat.com
Subject: Re: [PATCH V3 0/3] Ensure ordered namespace registration during
 async scan
Message-ID: <ajRpWLqaEyA6cwkJ@kbusch-mbp>
References: <20260225161203.76168-1-mlombard@redhat.com>
 <aZ9sjbZ3CEW_1rW1@kbusch-mbp>
 <DGOQMFJJ6K5P.3KLF45WQT2SAS@arkamax.eu>
 <e43b914c-2ca5-455e-b0fe-3ce2eb0c64bd@redhat.com>
 <aaCNtpPzP9TIDNjE@kbusch-mbp>
 <869034b1-c7e8-4e35-b153-43fd787a8edd@suse.de>
 <aaXE4s3AT45UIAN8@kbusch-mbp>
 <DJBICZU143X2.3S261SDT21N0V@arkamax.eu>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DJBICZU143X2.3S261SDT21N0V@arkamax.eu>

On Wed, Jun 17, 2026 at 07:41:58PM +0200, Maurizio Lombardi wrote:
> Did you manage to find a solution for this race?
> I just wanted to check whether you had any patches ready for testing since
> this discussion.

At last month's LSFMM, I heard concerns that this would break something.
I don't remember the specifics as I wasn't trying to push the issue. I
think this feedback was from the more fabrics focused folks, maybe Randy
Jennings, Nilay Shroff or John Meneghini remembers?
