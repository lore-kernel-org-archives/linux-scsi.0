Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7315C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 06:52:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiKIGwZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 01:52:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbiKIGwZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 01:52:25 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8615B1A38D;
        Tue,  8 Nov 2022 22:52:24 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6CDED68D05; Wed,  9 Nov 2022 07:52:17 +0100 (CET)
Date:   Wed, 9 Nov 2022 07:52:16 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     kbusch@kernel.org, axboe@fb.com, hch@lst.de, sagi@grimberg.me,
        martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH 1/3] block: Add error codes for common PR failures
Message-ID: <20221109065216.GA11097@lst.de>
References: <20221109031106.201324-1-michael.christie@oracle.com> <20221109031106.201324-2-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109031106.201324-2-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 08, 2022 at 09:11:04PM -0600, Mike Christie wrote:
> If a PR operation fails we can return a device specific error which is
> impossible to handle in some cases because we could have a mix of devices
> when DM is used, or future users like lio only know it's interacting with
> a block device so it doesn't know the type.
> 
> This patch adds a new pr_status enum so drivers can convert errors to a
> common type which can be handled by the caller.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  include/uapi/linux/pr.h | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/include/uapi/linux/pr.h b/include/uapi/linux/pr.h
> index ccc78cbf1221..16b856fb8053 100644
> --- a/include/uapi/linux/pr.h
> +++ b/include/uapi/linux/pr.h
> @@ -4,6 +4,30 @@
>  
>  #include <linux/types.h>
>  
> +enum pr_status {
> +	PR_STS_SUCCESS			= 0x0,
> +	/*
> +	 * These error codes have no mappings to existing SCSI errors.
> +	 */
> +	/* The request is not supported. */
> +	PR_STS_OP_NOT_SUPP		= 0x7fffffff,
> +	/* The request is invalid/illegal. */
> +	PR_STS_OP_INVALID		= 0x7ffffffe,
> +	/*
> +	 * The following error codes are based on SCSI, because the interface
> +	 * was originally created for it and has existing users.
> +	 */
> +	/* Generic device failure. */
> +	PR_STS_IOERR			= 0x2,
> +	PR_STS_RESERVATION_CONFLICT	= 0x18,
> +	/* Temporary path failure that can be retried. */
> +	PR_STS_RETRY_PATH_FAILURE	= 0xe0000,
> +	/* The request was failed due to a fast failure timer. */
> +	PR_STS_PATH_FAST_FAILED		= 0xf0000,
> +	/* The path cannot be reached and has been marked as failed. */
> +	PR_STS_PATH_FAILED		= 0x10000,

Nit: I'd movee the NOT_SUPP/INVALID to the end to follow the numerical
order.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
