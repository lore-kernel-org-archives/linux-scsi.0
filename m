Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423BF43BDBD
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 07:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790320242; cv=none; b=JzOQYYaSJADDlPh8pQQ1XeLmyMp12nh/C5oWw0UF9gutpeoRVfqt7cnBGeAq5W4G3Q5G8P8cjcuBop6OotzZp/CInu4ZO+4VUSnyy0UwCxybb3fGZHCTsCkovYuxWu1iqNvTnd42EAWI/CwbJbGwIxK3fV2Nzk31YTiUkLioXkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790320242; c=relaxed/simple;
	bh=uU+1JuWpGw3wHvJl6GFfO7NsJ4qqEhnnqZbdBbTndX0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mM0ES5sx9BGOmxxVaRzex3lR++PJgP6ZXRQ6zSGNMnUgDyvJ+b6Q81IMdtvINxOSVhhwPdXD6PnrjPnwCCCwjonneytUIvnxIt+VLJ8XyjaQfaB5kvMIbJc0HEwe8taoO+TxnDmeCzQvW8l8kcMvXR6XgewJWaVMpYEyKg3uDjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C28E568C4E; Fri, 25 Sep 2026 09:10:37 +0200 (CEST)
Date: Fri, 25 Sep 2026 09:10:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH v2 4/7] scsi: scsi_debug: Split resp_read_dt0()
Message-ID: <20260925071037.GD4621@lst.de>
References: <cover.1790290089.git.bvanassche@acm.org> <4b4b537c1a2c95b81d0c8b8f9c4c31e2b9f47369.1790290090.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b4b537c1a2c95b81d0c8b8f9c4c31e2b9f47369.1790290090.git.bvanassche@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Sep 24, 2026 at 03:54:40PM -0700, Bart Van Assche wrote:
>  }
>  
> +/*
> + * Returns the number of bytes transferred, or -1 with *scsi_status set to a
> + * SCSI status code on failure.
> + */
> +static int __resp_read_dt0(struct scsi_cmnd *scp, struct sdeb_store_info *sip,
> +			   u64 lba, u32 num, u32 ei_lba, int *scsi_status)
> +{
> +	u8 *cmd = scp->cmnd;
> +
> +	/* DIX + T10 DIF */
> +	if (unlikely(sdebug_dix && scsi_prot_sg_count(scp))) {
> +		switch (prot_verify_read(scp, lba, num, ei_lba)) {

Pleas split the enrire DIX case out into a separate helper to reduce
the indentation when you touch this anyway.

> +		case 1: /* Guard tag error */
> +			if (cmd[1] >> 5 != 3) { /* RDPROTECT != 3 */
> +				mk_sense_buffer(scp, ABORTED_COMMAND,
> +					LOGICAL_BLOCK_GUARD_CHECK_FAILED);
> +				*scsi_status = check_condition_result;
> +				return -1;
> +			} else if (scp->prot_flags & SCSI_PROT_GUARD_CHECK) {

No need for an else after a return. 

> +				*scsi_status = check_condition_result;
> +				return -1;
> +			} else if (scp->prot_flags & SCSI_PROT_REF_CHECK) {

Same here.

