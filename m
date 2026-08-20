Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086013ABD91
	for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2026 06:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787206199; cv=none; b=Hb3uvxUnBo4nuzHtBc3VfF0boIy0fPo3ujv0yE0jO378W2ybJOSEHkWrWAfq5+wFcT6/HmwC6/T8TmfwjfYyH2M1oT5jQSTsXPtfBh0MduBb+wo+hreui1ohwgA5DiMIwWzUfyYlNqnDPTYjHc0rnX/I6Z8Q42H3UEIjznByIpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787206199; c=relaxed/simple;
	bh=nAv/UudLnau9sceZHcyl7sXdQ33UQNREXoppagNhbzc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GmuTjd/VwcK9L21nd9y7ZEDLBthCZpDsps63GRgEfZhlxiKtVZPBqKG6m8kGpHboWHZuVVULx3RW2YWC9RY31EyeIReTfMn81Fb22nmA144PpNWXS2QkgNwoXcl0uNOa2VMhv+VRNtAj4j1VUMGb+8pSNHReT3HI6YCgZC+U5kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1363F68C7B; Thu, 20 Aug 2026 08:09:47 +0200 (CEST)
Date: Thu, 20 Aug 2026 08:09:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi_debug: add support to corrupt data and/or reftag
Message-ID: <20260820060946.GA18804@lst.de>
References: <20260819065850.1358861-1-hch@lst.de> <20260819065850.1358861-2-hch@lst.de> <18c7a0ff-d88d-4865-936a-62e28e8fbb1c@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18c7a0ff-d88d-4865-936a-62e28e8fbb1c@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Aug 19, 2026 at 09:00:39AM -0700, Bart Van Assche wrote:
> On 8/18/26 11:58 PM, Christoph Hellwig wrote:
>> +static int corrupt_lbas(struct sdebug_dev_info *devip, u64 lba, u32 num,
>> +		u32 nr_bit_errors, s32 reftag_adjust);
>
> Can the corrupt_lbas() definition be moved here such that the forward
> declaration of this function can be removed?

Not without reordering the entire file unfortunately.  It depends
on various helpers further down the file, while the debugfs registration
happens further up.  I've tried a few approaches to sort this out,
but failed to come up with something simple enough.

