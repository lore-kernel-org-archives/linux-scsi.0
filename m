From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi-misc-2.5 user per-device spare command
Date: Fri, 25 Apr 2003 11:12:27 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030425111227.B28577@infradead.org>
References: <20030424100229.A32098@beaverton.ibm.com> <20030424100317.A32134@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.mvhi.com ([195.224.96.167]:65289 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263208AbTDYKAV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2003 06:00:21 -0400
Content-Disposition: inline
In-Reply-To: <20030424100317.A32134@beaverton.ibm.com>; from patmans@us.ibm.com on Thu, Apr 24, 2003 at 10:03:17AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Thu, Apr 24, 2003 at 10:03:17AM -0700, Patrick Mansfield wrote:
> Patch against scsi-misc-2.5
> 
> Use a per-device spare command rather than a per-host spare.

Why?  This means we'll have a much bigger number of spare commands
around.

> +	/*
> +	 * Use any spare command first.
> +	 */
> +	cmd = sdev->spare_cmd;
> +	if (cmd != NULL)
> +		sdev->spare_cmd = NULL;
> +	else 
> +		cmd = kmem_cache_alloc(sdev->host->cmd_pool->slab,
> +				gfp_mask | sdev->host->cmd_pool->gfp_mask);

This logical is flawed.  We don't need a spare command if we always use
it first.  In addition the sdev->spare_cmd access is racy.

