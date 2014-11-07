From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] libata: Whitelist SSDs that are known to properly
 return zeroes after TRIM
Date: Fri, 7 Nov 2014 00:24:06 -0800
Message-ID: <20141107082406.GA8394@infradead.org>
References: <1415336894-15327-1-git-send-email-martin.petersen@oracle.com>
 <1415336894-15327-2-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49333 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaKGIYG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Nov 2014 03:24:06 -0500
Content-Disposition: inline
In-Reply-To: <1415336894-15327-2-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org, neilb@suse.de

On Fri, Nov 07, 2014 at 12:08:12AM -0500, Martin K. Petersen wrote:
>  		if (ata_id_has_trim(args->id)) {
> -			rbuf[14] |= 0x80; /* TPE */
> +			rbuf[14] |= 0x80; /* LBPME */
>  
> -			if (ata_id_has_zero_after_trim(args->id))
> -				rbuf[14] |= 0x40; /* TPRZ */
> +			if (ata_id_has_zero_after_trim(args->id) &&
> +			    dev->horkage & ATA_HORKAGE_ZERO_AFTER_TRIM) {
> +				ata_dev_warn(dev, "Enabling discard_zeroes_data\n");

I think this should _info, not _warn.

Otherwise looks good to me,

Reviewed-by: Christoph Hellwig <hch@lst.de>

It would be nice if there was a way to trigger the flag from userspace,
so that we don't need to rebuild the kernel to add a whitelist entry.
