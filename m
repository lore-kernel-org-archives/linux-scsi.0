Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BE86BFD5
	for <linux-scsi@vger.kernel.org>; Tue, 21 May 2024 23:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716333251; cv=none; b=o2kmMFBAqk9msLQcM+EGMmwVIKaZifZek1BVaT0oGzo+X9EDacZD6C6ZJg0h5EOH1E6nixuuv0e2nqabPZR5kEVwC3k319DQgNcn11hHGgsItTzU3WPEEj4B6E4ktdFF+QfiR8Z41IVwcvnyVV4rMTPguIF2JyIWwn7JVu8uoAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716333251; c=relaxed/simple;
	bh=iDkTOPPmvml63eT86W/+XuEVW4dARsWFpYvQ7d2YflE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Iwtu0k4e0/XUxQ2pE5OLUN2KM7WeYVXltaWQ09S7IFkKfSmfeWvzgNhoHPm1CzJhEpt24GIbRqxFqO6Rbyo3DiSsj8oBX3e5yBnEkf5tACbEZNRSBzOEKrw/T+wstgC6b0pSm8nwIpiOeYZ8HKt8/cslYUQScE7O9yOxYG/LjEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F418668C7B; Wed, 22 May 2024 01:13:57 +0200 (CEST)
Date: Wed, 22 May 2024 01:13:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: convert SCSI to atomic queue limits, part 1 (v2)
Message-ID: <20240521231357.GA820@lst.de>
References: <20240402130645.653507-1-hch@lst.de> <43db1cdb-5985-4f3d-8789-6097c47d8ea9@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43db1cdb-5985-4f3d-8789-6097c47d8ea9@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, May 15, 2024 at 11:22:25AM -0600, John Garry wrote:
> What is the idea for dropping blk_queue_max_discard_sectors() call in 
> sd_config_discard() -> blk_queue_max_discard_sectors() and the like, i.e. 
> the ULD changes?

I'll have a series out in a bit to get rid of the old limits API, hopefully
we can merge that as one of the first things for 6.11.
