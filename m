Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C507132123;
	Thu, 13 Jun 2024 05:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718256936; cv=none; b=PO+x7ueGGKM1coEVsEh0gvEwgKSYcNRb5p0DdribK7MbMgrmRMYTxHOn/TU6DCbUFWvV+mCWQXq0yw6sJ19/pqK5YHi9HlKjzaOcDb5+1L9kxh9dveyPVCnGlKjB1rp5A3zjblxBnzbq4yxyym5L0lCDaaYwKS7D2RhJODvrWLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718256936; c=relaxed/simple;
	bh=6jSueb1RkmSpnl+3j/inMFJ2kmtKQxgvOzmIxq5phIM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cXgdmeCwF2GwYAZTJid84rvVLgYDIsKm3Mymt6/d3M3KlJCWt/lZVAWGSbsVEXAiBbRFUgzyd++BI0THjvk8P9iyNOjqIvkzSxxk32Szufyy4C7RyNzFozzmYpBpuxp+mENfOZ03xaG4hnlNkAZUxoj7zWiQDPTzKI95lljvGZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 680D568AFE; Thu, 13 Jun 2024 07:35:29 +0200 (CEST)
Date: Thu, 13 Jun 2024 07:35:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH 03/11] block: remove the BIP_IP_CHECKSUM flag
Message-ID: <20240613053528.GA17839@lst.de>
References: <20240607055912.3586772-1-hch@lst.de> <20240607055912.3586772-4-hch@lst.de> <yq1frtl3tmw.fsf@ca-mkp.ca.oracle.com> <20240610115732.GA19790@lst.de> <yq1bk492dv3.fsf@ca-mkp.ca.oracle.com> <20240610122423.GB21513@lst.de> <yq1zfrrz2hj.fsf@ca-mkp.ca.oracle.com> <20240612035122.GA25733@lst.de> <yq1tthyw1jr.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1tthyw1jr.fsf@ca-mkp.ca.oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 12, 2024 at 01:27:47PM -0400, Martin K. Petersen wrote:
> >> > Note that unlike the NOCHECK flag which I just cleaned up because they
> >> > were unused, this one actually does get in the way of the architecture
> >> > of the whole series :( We could add a per-bip csum_type but it would
> >> > feel really weird.
> >> 
> >> Why would it feel weird? That's how it currently works.
> >
> > Because there's no way to have it set to anything but the per-queue
> > one.
> 
> That's what the io_uring passthrough changes enable.

The checksum type?  How is that compatible with nvme?

Anyway, I'll just leave this flag in for the resend, but if we can't
come up with a coherent user for it in a merge cycle or two (which
I very much doubt) I'll send another patch to remove it.

