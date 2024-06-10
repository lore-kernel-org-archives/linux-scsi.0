Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CB87C6EB;
	Mon, 10 Jun 2024 11:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718020292; cv=none; b=Rf7F1IwldDSYaMQN22EJmmTl2wHORnQWBlgYALLKHHEDNZog3z335oCv6gddgGrTUkhupnKHjV8vg6GxWn1Z/ZW+KkqvRRh7gQwF5lWtI/EegFeMZS6Z0q1C/sAp6jKurZdmMPZ0Pplr6gLtV3whXOK84ZRU2D6T/HRm2obirc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718020292; c=relaxed/simple;
	bh=4BMYigr8n20qLkExmpi1CL6HMlbJdeTnGSrRXWT5NAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YgQxk7Jiaw1om8kJNZGmF+dUdncnV9Ml8O4IFTmx2MmCLlGLCZZzQHkpJW8cqTRzsZMpF6nFSd8kbwzqVnmXPd2X4HznULfz20DfXKzfm4NfPMP96EzYgRihxTBlVmkd9v6mTU6rT/svZCJyqBfM6yprQqGhIO3tn9qu6H0Uje0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9AD8067373; Mon, 10 Jun 2024 13:51:18 +0200 (CEST)
Date: Mon, 10 Jun 2024 13:51:18 +0200
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
Subject: Re: [PATCH 02/11] block: remove the unused BIP_{CTRL,DISK}_NOCHECK
 flags
Message-ID: <20240610115118.GA19227@lst.de>
References: <20240607055912.3586772-1-hch@lst.de> <20240607055912.3586772-3-hch@lst.de> <yq1le3d3ua9.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1le3d3ua9.fsf@ca-mkp.ca.oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 10, 2024 at 07:48:52AM -0400, Martin K. Petersen wrote:
> Fundamentally, the biggest problem we had with the original
> implementation was that the "integrity profile" was static on a per
> controller+device basis. The purpose of 1.1 was to make sure that how to
> handle integrity metadata was a per-I/O decision with what to check and
> how to do it driven by whichever entity attached the PI. As opposed to
> being inferred by controllers and targets (through INQUIRY snooping,
> etc.).
> 
> We can add the flags back as part of the io_uring series but it does
> seem like unnecessary churn to remove things in one release only to add
> them back in the next (I'm assuming passthrough will be in 6.12).

I can just keep the flags in, they aren't really in the way of anything
else here.  That being said, if you want opt-in aren't they the wrong
polarity anyway?

