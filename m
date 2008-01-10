From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: memory allocation in sg_io()
Date: Thu, 10 Jan 2008 14:24:01 +0100
Message-ID: <20080110132401.GB6258@kernel.dk>
References: <200801101333.12293.oliver@neukum.org> <47861815.5090008@panasas.com> <200801101419.09651.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:5343 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055AbYAJNYE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jan 2008 08:24:04 -0500
Content-Disposition: inline
In-Reply-To: <200801101419.09651.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, Jan 10 2008, Oliver Neukum wrote:
> Am Donnerstag, 10. Januar 2008 14:05:25 schrieb Boaz Harrosh:
> > On Thu, Jan 10 2008 at 14:33 +0200, Oliver Neukum <oliver@neukum.org> wrote:
> > > Hi,
> > > 
> > > could you explain to me why this code can get away with allocating the
> > > sense buffer on the stack?
> > > 
> > > static int sg_io(struct file *file, struct request_queue *q,
> > > 		struct gendisk *bd_disk, struct sg_io_hdr *hdr)
> > > {
> > > 	unsigned long start_time;
> > > 	int writing = 0, ret = 0, has_write_perm = 0;
> > > 	struct request *rq;
> > > 	char sense[SCSI_SENSE_BUFFERSIZE];
> > > 
> > > 	Regards
> > > 		Oliver
> > > -
> > where? what? do you mean in scsi_ioctl.c?
> > why not it's a synchronous call?
> > Do you mean 96 bytes is too big?
> > Do you mean DMA alignment and cache coherency? I'm working
> > on that for scsi devices.
> 
> Yes, you are doing DMA on the stack.

There are many offenders like that, just take a peek in cdrom.c for
instance.

-- 
Jens Axboe

