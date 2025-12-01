Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35B82147F9;
	Mon,  1 Dec 2025 07:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764574054; cv=none; b=c8NYTVStTiawhDBkAqgIDyEJheOntNUYs1Uwd2SuMfvOoezMVgsZYTpSTYd+NBHwdeUqxW32waehDRfC2MK0piXyF5oj70ccsnE45fwHxcXsdkl6shv3aaU7Xo+J4LR/p4Vsx5soz9tL7yiwziALGhfxIJ8GMq9LN4yFJ6pVG7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764574054; c=relaxed/simple;
	bh=2Okf81j9R5+5F82x+aHwM4azSvYd8NchjYYTPyVUyRA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rd6Z2mGIu82km9Ld7Pvk7hOnHFwSxIRrYRkyPv4QIXm28FCMqgJKQN2RPMC1TOOU847tVm/3FDyG7a5i71ROngbMJkqHcdpQKdgE7wI2rTwIYiNYXcqOqldk4Ez+q/NPguJuKJSBcPSfOmjPKBvudrlkmTrhBsKwHnYZUX3gGP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 970BD6732A; Mon,  1 Dec 2025 08:27:27 +0100 (CET)
Date: Mon, 1 Dec 2025 08:27:27 +0100
From: Christoph Hellwig <hch@lst.de>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Christoph Hellwig <hch@lst.de>,
	Mike Christie <michael.christie@oracle.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH v2 2/4] nvme: reject invalid pr_read_keys() num_keys
 values
Message-ID: <20251201072727.GA20845@lst.de>
References: <20251127155424.617569-1-stefanha@redhat.com> <20251127155424.617569-3-stefanha@redhat.com> <69b3b390-77fe-440c-8747-096c0b26a112@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69b3b390-77fe-440c-8747-096c0b26a112@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Dec 01, 2025 at 07:11:31AM +0000, Chaitanya Kulkarni wrote:
> On 11/27/25 07:54, Stefan Hajnoczi wrote:
> > The pr_read_keys() interface has a u32 num_keys parameter. The NVMe
> > Reservation Report command has a u32 maximum length. Reject num_keys
> > values that are too large to fit.
> >
> > This will become important when pr_read_keys() is exposed to untrusted
> > userspace via an <linux/pr.h> ioctl.
> >
> > Signed-off-by: Stefan Hajnoczi<stefanha@redhat.com>
> > ---
> >   drivers/nvme/host/pr.c | 4 ++++
> >   1 file changed, 4 insertions(+)
> >
> > diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
> > index ca6a74607b139..156a2ae1fac2e 100644
> > --- a/drivers/nvme/host/pr.c
> > +++ b/drivers/nvme/host/pr.c
> > @@ -233,6 +233,10 @@ static int nvme_pr_read_keys(struct block_device *bdev,
> >   	int ret, i;
> >   	bool eds;
> >   
> > +	/* Check that keys fit into u32 rse_len */
> > +	if (num_keys > (U32_MAX - sizeof(*rse)) / sizeof(rse->regctl_eds[0]))
> > +		return -EINVAL;
> 
> de-referencing res in res->regctl_eds[0] is safe in this patch ?

sizeof does not dereference pointers in the expression.

