From: Tim Pepper <tpepper@vato.org>
Subject: Re: Bad reactions to QUEUE FULL
Date: Wed, 30 Apr 2003 09:13:35 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030430091335.A14743@jose.vato.org>
References: <20030429220259.A13386@jose.vato.org> <1051714713.1818.32.camel@mulgrave> <20030430160851.GA2350@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpe-24-221-186-48.ca.sprintbbd.net ([24.221.186.48]:28936 "HELO
	jose.vato.org") by vger.kernel.org with SMTP id S262222AbTD3QCO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Apr 2003 12:02:14 -0400
Content-Disposition: inline
In-Reply-To: <20030430160851.GA2350@beaverton.ibm.com>; from andmike@us.ibm.com on Wed, Apr 30, 2003 at 09:08:51AM -0700
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>, olh@suse.de

Thanks Mike!  I'll run with this and see what happens.  Should I do it instead of
the one restoring the old direction?

Since it sounds LLDD related I'll bounce detailed trace info from each of
those drivers to the vendors for comment.

Thanks!

Tim

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
