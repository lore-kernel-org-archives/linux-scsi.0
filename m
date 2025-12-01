Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E471E47C5;
	Mon,  1 Dec 2025 06:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764571016; cv=none; b=D5xwoepqwFXbS/VMrGYEZe0N4lelSJfMlKZwrjR1Mr0Nam0radBTUQ6XHOyuUOPsT8eBNYm3HfwY63C1El7cM3YAczfcc3d6nW+e5zDc1oRmgPUGx7sd1hql/dD/RcIKK4kfiJCaDl3ouUfz1YzChQz9ImLxfQCg/gXoZRRM/38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764571016; c=relaxed/simple;
	bh=pPrrDHz0W0DXf+whBTD9z+1kWN+BLRz7bv3kmbqZpIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WPmfRhLv63U/+1Ra6oNC4QtU/FVyulY0Ix6d4UqY76llGGQnRccq5TP8HTqiT2Iwmni0EVH3B+mIIi7oIWjWpHbxXvIgSftauQJAfVZOStIVOQf3f1hF3+Nx+c2kNEuPt2FgSaDu8n5yR8U3lfIs0dqL9mK4zISDUR6kdjKR284=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 992F368AA6; Mon,  1 Dec 2025 07:36:50 +0100 (CET)
Date: Mon, 1 Dec 2025 07:36:49 +0100
From: Christoph Hellwig <hch@lst.de>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: linux-block@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Christoph Hellwig <hch@lst.de>,
	Mike Christie <michael.christie@oracle.com>,
	linux-nvme@lists.infradead.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH v2 2/4] nvme: reject invalid pr_read_keys() num_keys
 values
Message-ID: <20251201063649.GB19461@lst.de>
References: <20251127155424.617569-1-stefanha@redhat.com> <20251127155424.617569-3-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251127155424.617569-3-stefanha@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 27, 2025 at 10:54:22AM -0500, Stefan Hajnoczi wrote:
> The pr_read_keys() interface has a u32 num_keys parameter. The NVMe
> Reservation Report command has a u32 maximum length. Reject num_keys
> values that are too large to fit.
> 
> This will become important when pr_read_keys() is exposed to untrusted
> userspace via an <linux/pr.h> ioctl.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>  drivers/nvme/host/pr.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
> index ca6a74607b139..156a2ae1fac2e 100644
> --- a/drivers/nvme/host/pr.c
> +++ b/drivers/nvme/host/pr.c
> @@ -233,6 +233,10 @@ static int nvme_pr_read_keys(struct block_device *bdev,
>  	int ret, i;
>  	bool eds;
>  
> +	/* Check that keys fit into u32 rse_len */
> +	if (num_keys > (U32_MAX - sizeof(*rse)) / sizeof(rse->regctl_eds[0]))
> +		return -EINVAL;
> +

We use struct_size to calculate the size below, which saturates on
overflow.  So just checking the rse_len variable returned by the that
would be nicer.  Bonus points for using sizeof_field() instead of
hardcoding U32_MAX.

