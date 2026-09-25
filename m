Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D18D356777
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 07:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790320152; cv=none; b=uqfqKH/WJ9ZpIGo9uUfK0/sRgy78izxWUd+uiLBIjXI5GWerriyNWXpSJegNFtXUbYcTqNE3vmU08fWF4JbQfQiPyXF2HO0bu254iLxS16wSIbRSLjg9VuDl5dTVUOWHlLiLoX4rKrFOF/QnLmolC7345rXHvKmOziYCXu9I2aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790320152; c=relaxed/simple;
	bh=cF+KF/bZCBejNupHC1E8X2Ye7XVUrsTmGdD90OZkJ7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nCGwtuC3JYvEQ09BVenN+phLg14mkuBc/axYCI+caW/+8JP1k4jbAAH7Ggoe2BzEoUTIRcwH6qX7GTLcsMjNLzHOhAPnbeg5ddJDTDImxgOh7IbkM/ASFb7RZBkUroXJ6wkKIk6OR2EDdrXdBXf97jPRKKA7Iy0fbOdP9l9QVls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3224F68C4E; Fri, 25 Sep 2026 09:09:08 +0200 (CEST)
Date: Fri, 25 Sep 2026 09:09:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH v2 3/7] scsi: scsi_debug: Split corrupt_lbas()
Message-ID: <20260925070908.GC4621@lst.de>
References: <cover.1790290089.git.bvanassche@acm.org> <9484940ad7bb464786c9f52211129015ce8ec006.1790290090.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9484940ad7bb464786c9f52211129015ce8ec006.1790290090.git.bvanassche@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Sep 24, 2026 at 03:54:39PM -0700, Bart Van Assche wrote:
> Move the inner logic of corrupt_lbas() into a new helper function
> __corrupt_lbas() and call it from separate locked and unlocked branches
> in corrupt_lbas(). This patch prepares for enabling context analysis.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
