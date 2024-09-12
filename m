Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906C91A0BF1;
	Thu, 12 Sep 2024 13:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726146975; cv=none; b=A8XbEAnueR5hHPBwgqZNKQTaTVKqdxXAs/z10HoyouQR/Gifpa1GA5b/wj1iNI4i+KJ/qOjGZPW2fzTYr527wHlm2SDc+UckZ9jDUOuV9UaX9erKIZUl2aJ1IY+OkF2+yN5hctUbSMUKrl43YDsF8Ykj4Zu39dECtG3SETiCoZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726146975; c=relaxed/simple;
	bh=+cFhvyPxMR1JHrFzXtB4vwM+YTH/GqtPmmqk+RCfnYY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lDMMgF238wzudQeUKV4tb+xn95WTrh+1zZUFA9+RUBvUg0gkmi8nRFbcejCJHNLc2+gwN9eCZGKarwn6QqmfZ3Qcjyxuh4RBww8vTo6PfroUWmXMGU11321mCBEyM7FFjiRW9UUGAz9bx7oygvuvu3kzptcte6lTFW6kh013Gcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A264D227AAF; Thu, 12 Sep 2024 15:16:10 +0200 (CEST)
Date: Thu, 12 Sep 2024 15:16:10 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, kbusch@kernel.org,
	hch@lst.de, sagi@grimberg.me, James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC 2/4] block: Add BLK_FEAT_ATOMIC_WRITES flag
Message-ID: <20240912131610.GB29641@lst.de>
References: <20240903150748.2179966-1-john.g.garry@oracle.com> <20240903150748.2179966-3-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240903150748.2179966-3-john.g.garry@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

> @@ -176,7 +176,7 @@ static void blk_validate_atomic_write_limits(struct queue_limits *lim)
>  {
>  	unsigned int boundary_sectors;
>  
> -	if (!lim->atomic_write_hw_max)
> +	if (!(lim->features & BLK_FEAT_ATOMIC_WRITES) || !lim->atomic_write_hw_max)

Overly long line here.

Otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
