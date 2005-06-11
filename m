From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] convert the remaining mid-layer pieces to
	scsi_execute_req
Date: Sat, 11 Jun 2005 14:09:25 -0500
Message-ID: <1118516965.4924.18.camel@mulgrave>
References: <1118502122.4924.7.camel@mulgrave>
	 <20050611185443.GB3406@pentafluge.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:65221 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261783AbVFKTJg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Jun 2005 15:09:36 -0400
In-Reply-To: <20050611185443.GB3406@pentafluge.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2005-06-11 at 19:54 +0100, Jeff Garzik wrote:
> On Sat, Jun 11, 2005 at 10:02:02AM -0500, James Bottomley wrote:
> > After this, we just have some drivers, all the ULDs and the SPI
> > transport class using scsi_wait_req().
> > 
> > James
> > 
> > --- a/drivers/scsi/scsi_ioctl.c
> > +++ b/drivers/scsi/scsi_ioctl.c
> > @@ -88,25 +88,21 @@ static int ioctl_probe(struct Scsi_Host 
> >  static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
> >  				  int timeout, int retries)
> >  {
> > -	struct scsi_request *sreq;
> >  	int result;
> >  	struct scsi_sense_hdr sshdr;
> > +	char sense[SCSI_SENSE_BUFFERSIZE];
> 
> What is the average stack size at this call depth?

Erm, well that's architecture dependent, as I'm sure you know.

On parisc64, none of the prior callers really goes over a stack frame,
so it's 128*depth.

James


