From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] bsg: return SAM device status code
Date: Fri, 23 Feb 2007 11:43:22 -0500
Message-ID: <45DF19AA.1000500@torque.net>
References: <20070223151231.GA15228@osc.edu>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:50479 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbXBWQn3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Feb 2007 11:43:29 -0500
In-Reply-To: <20070223151231.GA15228@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pete Wyckoff <pw@osc.edu>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-scsi@vger.kernel.org

Pete Wyckoff wrote:
> Use the status codes from the standard, not the shifted-by-one codes
> that are marked deprecated in scsi.h.  This makes bsg v4 status
> report the same value as sg v3 status too.

Pete,
Good pick up. We certainly don't want to re-introduce
the SCSI status byte shift from the old days.

Doug Gilbert


> Signed-off-by: Pete Wyckoff <pw@osc.edu>
> ---
>  block/bsg.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/block/bsg.c b/block/bsg.c
> index c85d961..e39a321 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
> @@ -438,7 +438,7 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
>  	/*
>  	 * fill in all the output members
>  	 */
> -	hdr->device_status = status_byte(rq->errors);
> +	hdr->device_status = rq->errors & 0xff;
>  	hdr->transport_status = host_byte(rq->errors);
>  	hdr->driver_status = driver_byte(rq->errors);
>  	hdr->info = 0;

