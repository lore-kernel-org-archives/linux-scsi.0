From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] libata: Report zeroed read after Trim and max
	discard size
Date: Sat, 21 Nov 2009 05:49:23 -0500
Message-ID: <20091121104923.GB30153@infradead.org>
References: <1258771524-26673-1-git-send-email-martin.petersen@oracle.com> <1258771524-26673-4-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38012 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbZKUKtg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Nov 2009 05:49:36 -0500
Content-Disposition: inline
In-Reply-To: <1258771524-26673-4-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jens.axboe@oracle.com, james.bottomley@hansenpartnership.com, hch@infradead.org, willy@wil.cx, jgarzik@pobox.com, sandeen@redhat.com, rwheeler@redhat.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Nov 20, 2009 at 09:45:23PM -0500, Martin K. Petersen wrote:
>  	 * with the unmap bit set.
>  	 */
> -	if (ata_id_has_trim(args->id))
> +	if (ata_id_has_trim(args->id)) {
> +		put_unaligned_be32(65535 * 512 / 8, &rbuf[20]);
>  		put_unaligned_be32(1, &rbuf[28]);

My reading of SPC is that the max unmap size only makes sense for
devices supporting UNMAP, while the SATL for now only supports WRITE
SAME with the unmap bit.

> -			rbuf[14] |= 0x80;
> +		if (ata_id_has_trim(args->id)) {
> +			rbuf[14] |= 0x80; /* TPE */
> +
> +			if (ata_id_has_zero_after_trim(args->id))
> +				rbuf[14] |= 0x40; /* TPRZ */

Looks good.

