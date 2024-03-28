Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BDD381AD;
	Thu, 28 Mar 2024 04:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711599209; cv=none; b=rVviFKIK1Yon/deZQqz+LwiZvpGUSvTCJ/gBDY7UgodCbqAutq//toHKgKpY9T/PXGZ0J/8y1GZuJdhio0pFQKqI9edzIH/GG45pnQMXgxfRpQcwHBQG6NTt8T/GejA+wIAb5KaZsMDTgoCo8SPBMkVLgB2qIErnddXv7N9ngaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711599209; c=relaxed/simple;
	bh=97n0l9Cye3dcMu//qmNro8xE7Ur6T9BhpinOtQjNjaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AVvkSHAedisspnNTUTSJ0rUCLD6aYLJK9x3RpIcXSIOwMKnrxco5ITnwjEOO9o14WRJrPKVvsRQhLtB1iuLeQAtgJORWg81b3aGf+S87LzYqYPQX5i7y1H8Wp8jDxn15mGgmyk0nIdG+jR4+OUya8OO9m26LerlSDM2FAQdXlVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3218868B05; Thu, 28 Mar 2024 05:13:23 +0100 (CET)
Date: Thu, 28 Mar 2024 05:13:23 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 03/30] block: Remove req_bio_endio()
Message-ID: <20240328041323.GB13510@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org> <20240328004409.594888-4-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328004409.594888-4-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 28, 2024 at 09:43:42AM +0900, Damien Le Moal wrote:
> Moving req_bio_endio() code into its only caller, blk_update_request(),
> allows reducing accesses to and tests of bio and request fields. Also,
> given that partial completions of zone append operations is not
> possible and that zone append operations cannot be merged, the update
> of the BIO sector using the request sector for these operations can be
> moved directly before the call to bio_endio().

Note that we should actually be able to support merging zone appends.

And this patch actually moves the assignment to the right place to be
able to deal with it, we'll just need to track the start offset to the
start of the request so that we can assign the right bi_sector.

Reviewed-by: Christoph Hellwig <hch@lst.de>
