From: Tim Pepper <tpepper@vato.org>
Subject: Re: Bad reactions to QUEUE FULL
Date: Sun, 4 May 2003 21:09:24 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030504210924.A27219@jose.vato.org>
References: <20030429220259.A13386@jose.vato.org> <1051714713.1818.32.camel@mulgrave> <20030430160851.GA2350@beaverton.ibm.com> <20030430091335.A14743@jose.vato.org> <20030430165130.GC2350@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpe-24-221-186-48.ca.sprintbbd.net ([24.221.186.48]:2828 "HELO
	jose.vato.org") by vger.kernel.org with SMTP id S261886AbTEED5B
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 May 2003 23:57:01 -0400
Content-Disposition: inline
In-Reply-To: <20030430165130.GC2350@beaverton.ibm.com>; from andmike@us.ibm.com on Wed, Apr 30, 2003 at 09:51:30AM -0700
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>, olh@suse.de

Bad news...this doesn't appear to have made much difference.  With it 3 of the
six machines were pretty much dead the morning after and the other three all have
hung IO.

On the other front I'm still waiting for word back from Emulex and Qlogic
on the detailed tracing I sent them.

> 
> --- linux-2.4/drivers/scsi/scsi_lib.c		Wed Apr 30 09:04:16 2003
> +++ linux-2.4-p/drivers/scsi/scsi_lib.c		Wed Apr 30 09:04:17 2003
> @@ -256,6 +256,17 @@
>  	if (SCpnt != NULL) {
>  
>  		/*
> +		 * This is a work around for a case where this Scsi_Cmnd
> +		 * may have been through the busy retry paths already. We
> +		 * clear the special flag and try to restore the
> +		 * read/write request cmd value.
> +		 */
> +		if (SCpnt->request.cmd == SPECIAL)
> +			SCpnt->request.cmd = 
> +				(SCpnt->sc_data_direction ==
> +				 SCSI_DATA_WRITE) ? WRITE : READ;
> +
> +		/*
>  		 * For some reason, we are not done with this request.
>  		 * This happens for I/O errors in the middle of the request,
>  		 * in which case we need to request the blocks that come after

-- 
*********************************************************
*  tpepper@vato dot org             * Venimus, Vidimus, *
*  http://www.vato.org/~tpepper     * Dolavimus         *
*********************************************************
