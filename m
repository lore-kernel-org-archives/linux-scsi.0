From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] libata: error processing + rw 6 byte fix
Date: Tue, 23 Aug 2005 09:13:39 +0200
Message-ID: <20050823071338.GA11233@suse.de>
References: <430994BC.4060102@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:15853 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S1750821AbVHWHRG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Aug 2005 03:17:06 -0400
Content-Disposition: inline
In-Reply-To: <430994BC.4060102@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Mon, Aug 22 2005, Douglas Gilbert wrote:
>  	if (scsicmd[0] == READ_6 || scsicmd[0] == WRITE_6) {
> -		qc->nsect = tf->nsect = scsicmd[4];
> +		if (scsicmd[4] == 0) {
> +			/*
> +			 * For READ_6 and WRITE_6 (only)
> +			 * transfer_len==0 -> 256 blocks !!
> +			 */
> +			if (lba48) {
> +				tf->hob_nsect = 1;
> +				qc->nsect = 256;
> +			} else
> +				return 1;

This isn't quite right, for 28-bit lba a 0 sector value means 256
sectors to transfer as well. So just make that:

        if (lba48) {
                tf->hob_nsect = 1;
                qc->nsect = 256;
        }

        /* continue */

and it should work fine. Similarly for 48-bit lba, 0 means 16^2 sectors.

-- 
Jens Axboe

