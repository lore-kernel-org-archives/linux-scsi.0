From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] convert the remaining mid-layer pieces to scsi_execute_req
Date: Sat, 11 Jun 2005 19:54:43 +0100
Message-ID: <20050611185443.GB3406@pentafluge.infradead.org>
References: <1118502122.4924.7.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:41348 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261780AbVFKSyp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Jun 2005 14:54:45 -0400
Content-Disposition: inline
In-Reply-To: <1118502122.4924.7.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, Jun 11, 2005 at 10:02:02AM -0500, James Bottomley wrote:
> After this, we just have some drivers, all the ULDs and the SPI
> transport class using scsi_wait_req().
> 
> James
> 
> --- a/drivers/scsi/scsi_ioctl.c
> +++ b/drivers/scsi/scsi_ioctl.c
> @@ -88,25 +88,21 @@ static int ioctl_probe(struct Scsi_Host 
>  static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
>  				  int timeout, int retries)
>  {
> -	struct scsi_request *sreq;
>  	int result;
>  	struct scsi_sense_hdr sshdr;
> +	char sense[SCSI_SENSE_BUFFERSIZE];

What is the average stack size at this call depth?

	Jeff



