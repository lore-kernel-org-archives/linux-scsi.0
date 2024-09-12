Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4081AD241;
	Thu, 12 Sep 2024 13:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726147020; cv=none; b=mMlFwwlojYJV/ef+HJa0m0nbLuQtf87frYCWN8wZY7omvAA7x2Nvz8Rv2AoPO8/gpi95JmiLKF0bfRleRRAHtzCaCKT/foyzJ75rsJHrQqjaAsRSEY5cVqWHngQCuOHzNWa5sj/q8rcvgiGcCexlmTXtvR+UebF33Z3Tpiu5rmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726147020; c=relaxed/simple;
	bh=sHMMlg6S2BC9qxXQqFP8udlN45B5qCVPc5EdBgBiurk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aOhdQsgyxBpZ4DaUgz317hIBn2Y9EITavU77Q6Uvdq30wPgh9HRQ4d2cNe56T+n/qxQ4WCDiELRRxVvR/DcOq69F9T+XmkNMyIjxVnKWZwrDGio+iepc13L9MqHAp3wyJjL3Ww8A7QvV1EAyyQ9B+4tBKAY4C23TWeOKc25GiM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 43F69227AAF; Thu, 12 Sep 2024 15:16:56 +0200 (CEST)
Date: Thu, 12 Sep 2024 15:16:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, kbusch@kernel.org,
	hch@lst.de, sagi@grimberg.me, James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC 3/4] block: Support atomic writes limits for
 stacked devices
Message-ID: <20240912131656.GC29641@lst.de>
References: <20240903150748.2179966-1-john.g.garry@oracle.com> <20240903150748.2179966-4-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240903150748.2179966-4-john.g.garry@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Sep 03, 2024 at 03:07:47PM +0000, John Garry wrote:
> +	} else if (t->features & BLK_FEAT_ATOMIC_WRITES) {
> +		t->atomic_write_hw_max = min_not_zero(t->atomic_write_hw_max,
> +						b->atomic_write_hw_max);
> +		t->atomic_write_boundary_sectors =
> +					min_not_zero(t->atomic_write_boundary_sectors,
> +						b->atomic_write_boundary_sectors);
> +		t->atomic_write_hw_unit_min = max(t->atomic_write_hw_unit_min,
> +						b->atomic_write_hw_unit_min);
> +		t->atomic_write_hw_unit_max =
> +					min_not_zero(t->atomic_write_hw_unit_max,
> +						b->atomic_write_hw_unit_max);

Maybe split this into a helper to make the code more readable?

Otherwise this looks good to me.
