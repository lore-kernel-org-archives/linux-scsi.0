Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C93F4085C;
	Thu, 28 Mar 2024 06:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711605843; cv=none; b=L/k2pCQ24zYnp+6zMUOJ6jPOZFqsyPd5lRg4gbvC1S2cYaI/UGzY3bVSOcXosaEXV/34eJzT/g5seVAeeWEHxhIYKIVqWDiiG46BfzhDLwBQUMvVXCXiR+O/JvpPbJFQduqEDzrGEDRxGEwcy0H3oOqG1y77VlTtAfoEzZwIFOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711605843; c=relaxed/simple;
	bh=bB2CI9Hl4hXS1LHnxKg5x0dbsZtwYsDW9poMe+lwcDk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VYFljROOCAJilpgsWzUW8ZJwXMjPIFobcRsxnarA9pQOEw7Ys9Njep3u+D4BgIyRIX04u2sq2jPcBw858JaQo4Bg6Tm8YmSBUFJ+havlYLwB0XNZVDmqchcJ1Y1/Z3n6c6t28je/NexizENaBJwnDtzP9yznU/Q8rqomoFsUgyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9CEE668B05; Thu, 28 Mar 2024 07:03:57 +0100 (CET)
Date: Thu, 28 Mar 2024 07:03:57 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH v3 09/30] block: Pre-allocate zone write plugs
Message-ID: <20240328060357.GA16819@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org> <20240328004409.594888-10-dlemoal@kernel.org> <20240328043016.GA13701@lst.de> <714d0cbc-be4d-4aa9-b200-73c6caaa1d18@kernel.org> <20240328054652.GA16237@lst.de> <7d8f3ec4-c416-445f-92db-7d2b60726821@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d8f3ec4-c416-445f-92db-7d2b60726821@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 28, 2024 at 03:02:54PM +0900, Damien Le Moal wrote:
> But that is the problem: "checking the zone number again" means referencing the
> plug struct again from the lookup context while the last ref drop context is
> freeing the plug. That race can be lost by the lookup context and lead to
> referencing freed memory. So your solution would be OK for pre-allocated plugs
> only.

Not if it is done in the Rcu critical section.

> For kmalloc-ed() plugs, we still need the rcu grace period for free. So we
> can only optimize for the pre-allocated plugs...

Yes, bt it can use kfree_rcu which doesn't need the rcu_head in the
zwplug.
