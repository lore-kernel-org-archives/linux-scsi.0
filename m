Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB7938D404;
	Thu, 24 Sep 2026 14:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790259399; cv=none; b=qLwuzJhKI25wUvqk7KC6GtgWNjq+fGKVC9zxlyglx9fPtsv2x6dQUXaquP9r87lOgCPWJ6jNMDSbWwxAsRUJgzG2Gi8kqg9JnWA5J0zR4eTMWmkIuwCAxz4YtxsN7gDezLrS2PZeC9mS2wveGLbZKC0kZD5ErmyXMXJ8+ZpjXOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790259399; c=relaxed/simple;
	bh=ngZfYK94JjIgjmJTzq7A7UXNR3eejMz7MSsks3/S9+o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fKcY/27TCxaF0d87Jv6HF126UUzIzYQ5e3AtYdYPoVlZH+w8/AOl06ySEUknSM8GShRJcVM/nEn35LRil+cLR3JuvW04kc4gYEZLBUUmZQynR8hY/pgGDYdStb5GkWQWCxek5CEYT57YV9UvdBr16JdPjYqnwW042bzw/zuq5es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DelI1lat; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DelI1lat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1291F000FF;
	Thu, 24 Sep 2026 14:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790259397;
	bh=7x2oCQZdB1pEZJ9BKZqGBbpuzlB6uHWWh3FaM74ud3s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DelI1latDOPYEd1hv+WzOAa4FUG4CCHu7FlqzIMVlwqJSZZAWrXy2gCaLeb0CVJZF
	 CGmv/ZseFEqoHE30P1DURV/12b7HQK4r0+1F3PCpjn41nlhVxfqRry20jW9Vzj7YMQ
	 hl8sb0m4Rl+Tiww8YIktsOGx0SMFDKYeZmPipKZE=
Date: Thu, 24 Sep 2026 16:16:15 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: Hannes Reinecke <hare@suse.de>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Joe Eykholt <jeykholt@cisco.com>,
	Robert Love <robert.w.love@intel.com>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] scsi: libfc: fix directory server rport memory leak
Message-ID: <2026092455-country-unreached-47eb@gregkh>
References: <20260924133429.1587511-1-lgs201920130244@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924133429.1587511-1-lgs201920130244@gmail.com>

On Thu, Sep 24, 2026 at 09:34:29PM +0800, Guangshuo Li wrote:
> fc_rport_create() does not add FC_FID_DIR_SERV rports to
> lport->disc.rports. If fc_frame_alloc() fails in
> fc_rport_recv_plogi_req() after creating a directory server rport, its
> initial reference is not released through the normal rport teardown
> path.
> 
> Normal rports are added to lport->disc.rports and removed from the list
> before their initial reference is dropped. The directory server rport
> bypasses both operations.
> 
> Add directory server rports to lport->disc.rports and use the existing
> list removal path when they are deleted. Keep the existing directory
> server callback and retry behavior unchanged.
> 
> The issue was identified by a static analysis tool I developed and
> confirmed by manual review.

Great, please document that as is asked for in the kernel documentation
in the changelog here please.

thanks,

greg k-h
