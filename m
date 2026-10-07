Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F06746AA8F;
	Wed,  7 Oct 2026 13:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791380152; cv=none; b=M6GN/SWccNjiX+a2RUm4+NVbmHNCDtw+1aR2EMSKjsG8a/vaa86fu/nYp3NwUXQiqvWgKElmiFAq5eUXtu3oB3hvJjJqzA6lMXD3sannALwlCeu6IGmKX2QDo+BZbHkDsqcs67cNlV84XxoEPgC7mBHsbSIos3ILPvpYx/ohs0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791380152; c=relaxed/simple;
	bh=W6JimfImUTlYtU9exqrNPolS9pKRZcCvt5wngj6JaEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RPDEUfT/7JbKHf+frCNUkCshFtGkJl67g6SgRZI0HJcj/L3/a6/75zGo1yAaE2+UkcSwSJkB5ovbzb3rWweGCuaOvn1RPDFR6KIDFnZ3kVYeKml2U577pygzNvPwtkz6uLW7DRYbqQatOt+hijALOKe2HfMRRmRQp2ISBQqzttc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CEBB3227A88; Wed,  7 Oct 2026 15:35:37 +0200 (CEST)
Date: Wed, 7 Oct 2026 15:35:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 2/7] block: introduce storage element management
Message-ID: <20261007133537.GB31906@lst.de>
References: <20261007082344.1049179-1-dlemoal@kernel.org> <20261007082344.1049179-3-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261007082344.1049179-3-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 07, 2026 at 05:23:39PM +0900, Damien Le Moal wrote:
> Co-developed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

That's a lot of credit for the two or three trivial fixes that got
folded in, I'd drop that line.

> +static int disk_wait_for_se_mgmt_completion(struct gendisk *disk)
> +{
> +	struct blk_storage_element *elements, *e;
> +	unsigned int i, nr_se, nr_elements = 0;
> +	unsigned int noio_flag;
> +	int ret;
> +
> +	/* The callers already checked that disk->fops->se_ops is set. */
> +	ret = disk->fops->se_ops->report_elements(disk, NULL, &nr_elements);

Sashikoa thing report_elements could be zero.  Which is of course
a bit stupid, but maybe we can protect against that by checking that
all members are set at registration time for the bdops?

> +	/*
> +	 * Poll the storage elements heath state to detect the end of a removal
> +	 * or restoration operation. Since we do not know how long the operation

Overly long line.

> +	 * may take, we cannot have a timeout on this loop. So make it
> +	 * interruptible by a fatal signal so that the user can terminate this
> +	 * retry loop if the device misbehaves.
> +	 */
> +	while (!fatal_signal_pending(current)) {
> +		/*
> +		 * Check if we have storage elements being removed or restored.
> +		 */
> +		nr_se = nr_elements;

Declare شr_se locally in the loop?

> +		ret = disk->fops->se_ops->report_elements(disk, elements,
> +							  &nr_se);
> +		if (ret) {
> +			pr_err("Failed to get storage elements\n");
> +			break;
> +		}
> +
> +		e = elements;

Same for e?  And maybe factor this entire loop into a helper to make
sure nothing leaks out.

> +		for (i = 0; i < nr_se; i++, e++) {
> +			if (e->status == BLK_SE_STS_REMOVE_IN_PROGRESS ||
> +			    e->status == BLK_SE_STS_RESTORE_IN_PROGRESS)
> +				break;

Switch?  And yeah, the Sashiko comment on the error handling here
looks correct to me.

> +		if (i >= nr_se)
> +			break;

And this looks a bit odd.  Why not use a goto to get out instead of
this nesting (splitting it into a separate helper would take care
of that with a direct return as well).

> +		/* Not done yet: wait and retry. */
> +		msleep(1000);

It would be nice to have a UA for this in future spec versions
instead of he busy wait.

> + * Fill at most @nr_elements storage element descriptors in the array @elements.
> + * The number of storage elements filled in the array is returned using
> + * @nr_elements. If @elements is NULL, only @nr_elements is returned to indicate

Overly long lines.

