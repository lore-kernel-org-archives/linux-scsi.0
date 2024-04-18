Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0576125622
	for <linux-scsi@vger.kernel.org>; Thu, 18 Apr 2024 07:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713423797; cv=none; b=GJuEY5TDG7FljGI2FBo0EKxU4i1+cgxkMYzbo0qImPAXjwaM8mPFu8zQ+nl7sMfZsFso7TvUG3qI/ehri6asIclSjtlvbU6/Ex5I5ttI9swbyhu6/N/lZs3+nBXFcS6hBuZs5bPx6zDdXPo3ZbyD5+yHgw5ZQ0maCMZyL0HejW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713423797; c=relaxed/simple;
	bh=jwewhxERYWOGCKgp3MgZK2lUaTWnoXaNmi6YERownjw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jwfg3O0Eec5ojyxPPmcqhnCziqzrHTaUH4/ERiRodneinkWcAzACi2J5ofLmKg1L84WHc8WPJPejUS5tK5crZN8QqIr01rDC1wrF86QNlNy7JgKbuZGjmYifkcW/AG0GwzDTrMJkDtD8je1QDPHUAF5fxMIRQwFL5HiYVfMN9+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6DD3068C7B; Thu, 18 Apr 2024 09:03:04 +0200 (CEST)
Date: Thu, 18 Apr 2024 09:03:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: Hannes Reinecke <hare@kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	James Bottomley <james.bottomley@hansenpartnership.com>,
	linux-scsi@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>
Subject: Re: [PATCH] scsi_lib: Align max_sectors to kb
Message-ID: <20240418070304.GA26607@lst.de>
References: <20240418070015.27781-1-hare@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240418070015.27781-1-hare@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Apr 18, 2024 at 09:00:15AM +0200, Hannes Reinecke wrote:
> max_sectors can be modified via sysfs, but only in kb units.

Yes.

> Which leads to a misalignment on stacked devices if the original
> max_sector size is an odd number.

How?

Note that we really should not stack max_sectors anyway, as it's only
used for splitting in the lower device to start with.
