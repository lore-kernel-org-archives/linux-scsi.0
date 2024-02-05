Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B99CB677;
	Mon,  5 Feb 2024 05:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707112252; cv=none; b=EC1Ra2YoQ4YEfY5HUjU8sQY30J6k5e1/6l/ahQIxdKSPtiDTcEtn8dNT9TIYYxT1JmLpTkQbEPJd1BM43xk1M12mdiksTYv9JzSuCldr/8x1/jZBd6cUeol6t65HhO20HR7GaRQKvr9dhYuo77Y2FE/iIkxqwyaEzC0l07eMoac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707112252; c=relaxed/simple;
	bh=iLnWKh3+t4nWT4ESnX5O6/yOok7IBDsGdBYzPPjkMpI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T31TjV2GwIeRhNtQFq8eJ0dM8EaphFuL8AdHIORCig3cHY/0wXrjJhds1bFUuoxn5wINl5MHnG9SO1/ovhCzMcTVPr/xcXudDd/tDeV1LkxWx06TIch4+3/u7tK4RQE0drBzePkMQRAdylxlnLPqelskZfpzZk+h52vGgw7A2F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 642F1227AA8; Mon,  5 Feb 2024 06:50:46 +0100 (CET)
Date: Mon, 5 Feb 2024 06:50:46 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 06/26] block: Introduce zone write plugging
Message-ID: <20240205055046.GA18392@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org> <20240202073104.2418230-7-dlemoal@kernel.org> <Zb8K4uSN3SNeqrPI@fedora> <a3f17ffb-872b-49cf-a1a7-553ca4a272c0@kernel.org> <ZcBFoqweG+okoTN6@fedora> <58fa0123-e884-4321-9b9b-8575cc7b4e1d@kernel.org> <20240205051159.GA17817@lst.de> <6e99511d-14f6-4077-87de-47ff285bc26c@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e99511d-14f6-4077-87de-47ff285bc26c@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Feb 05, 2024 at 02:37:41PM +0900, Damien Le Moal wrote:
> OK. So I think that Hannes'idea to get/put the queue usage counter reference
> based on a zone BIO plug becoming not empty (get ref) and becoming empty (put
> ref) may be simpler then. And that would also work in the same way for blk-mq
> and BIO based drivers.

Maybe I'm missing something, but I'm not sure how that would even work.

We need a q_usage_counter ref when doing all the submissions checks
(limits, bounce, etc) early in blk_mq_sunmit_bio, and that one should be
taken using the mormal bio_queue_enter patch to do the right thing on
nowait submissions, when the queue is already frozen, etc.  What
is the benefit of not just keeping that references vs releasing it
for all but the first bio just so that we need to grab another
new reference at the actual submission time?

