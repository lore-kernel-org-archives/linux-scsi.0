Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC87126E6F4
	for <linux-scsi@vger.kernel.org>; Mon,  6 Oct 2025 11:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759750134; cv=none; b=QQa4wBMaAo6LFSntLhLuTseXA3hPt8p/ejhC6eh4gCZj+EZaFPh7+fEbXH/L3ZepK9zy1k+SYTsHnyBKKQUV4yUMcuF1PLlcZuHoAGRYYQXqSVK7/oPwEEDoshWxaW5yMNVuZHKvKrCSyTeZpXREqbW5tKTLv8qHzgDOpugMJu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759750134; c=relaxed/simple;
	bh=eSgpgHXSepwBjz0bnm6+LZCWs3ejEkuQ5USydm4woLs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N8CLA1piAGz5mPjefTjX5keuSIrtbBO7cx+dOlie89ne8lcSvhRkQCaj0fTxMsIEiEwrQuONwvuLsBTklj+gLnwhbtN9TGP9CZnNMW6dqtFQ1j1KIAlSeXQgYwVmEmO/b/x6IJjAMpDB0cKFKLDWxAQtJBVN2N0ml8sSEXS5Kuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dsopm0Di; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dsopm0Di"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42204C4CEF5;
	Mon,  6 Oct 2025 11:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759750134;
	bh=eSgpgHXSepwBjz0bnm6+LZCWs3ejEkuQ5USydm4woLs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Dsopm0Di24g3Q7EWbUpP1M7tKuVPD5+ShDEqDyFl1k66dhzGHbj+/YyJJyx8Wv2wY
	 YfK+2rsznhFdZo394WwqIxYavgGsJ9+QRfafbiYp1YYHhL9O0OGLUrt/C5K6YxnyMY
	 njkXLfledH+Fy80h/P66z0AowD8VGSTwqYrfohb8lDguP76Wz4HW3IRxvpWoz4+r2T
	 7rqR8OFa/06d8e+xcshrfRnvXxynVMmGc/sDKZYPeyWKPTTew2FZmAVlULy5OjIyE4
	 S7vy2q+cRvYLmXaibUJzRJfqtbzDIQPKFIedU+aFesEYYsaNi3vqxSK5l4de0/NJ7g
	 F/0qeIst26tdA==
Date: Mon, 6 Oct 2025 13:28:49 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
	Don Brace <don.brace@microchip.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	storagedev@microchip.com, linux-scsi@vger.kernel.org,
	linux-kernel-mentees@lists.linuxfoundation.org,
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com
Subject: Re: [PATCH] scsi: Use kmalloc_array to prevent overflow of dynamic
 size calculation
Message-ID: <aOOn8TFTseukaZlS@ryzen>
References: <20251001113935.52596-1-bhanuseshukumar@gmail.com>
 <7761904f64c554821e71e30b205e092fc2f8478e.camel@HansenPartnership.com>
 <1c6cceec-da16-4867-88e0-c629accbb35c@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1c6cceec-da16-4867-88e0-c629accbb35c@gmail.com>

On Sat, Oct 04, 2025 at 09:55:22AM +0530, Bhanu Seshu Kumar Valluri wrote:
> On 03/10/25 20:23, James Bottomley wrote:
> > On Wed, 2025-10-01 at 17:09 +0530, Bhanu Seshu Kumar Valluri wrote:
> >> Use kmalloc_array to avoid potential overflow during dynamic size
> >> calculation inside kmalloc.
> > 
> > This description isn't correct.
> > 
> > Given this check
> > 
> >>  
> >> -	host_memory_descriptor->host_chunk_virt_address =
> >> kmalloc(sg_count * sizeof(void *), GFP_KERNEL);
> > 
> > How is it possible that this allocation could ever overflow?
> > 
> > If you want to change the description to say using kmalloc_array is
> > better practice or something (and the maintainer concurs) that's fine,
> > but we can't have a false justification in the kernel git log.
> > 
> > Regards,
> > 
> > James
> > 
> Hi,
> 
> Thank you for your helpful comment. 
> I will await till maintainer confirms if it is ok to push this change as v2 with
> subject line similar what you have suggested.

You misinterpreted James' reply ("and the maintainer concurs").

James is one of the two SCSI maintainers, so there is no need to
delay sending a V2.


Kind regards,
Niklas
