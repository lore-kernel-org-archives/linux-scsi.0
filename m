From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: memory allocation in sg_io()
Date: Thu, 10 Jan 2008 06:30:09 -0700
Message-ID: <20080110133009.GB18741@parisc-linux.org>
References: <200801101333.12293.oliver@neukum.org> <47861815.5090008@panasas.com> <200801101419.09651.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:43133 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832AbYAJNaO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jan 2008 08:30:14 -0500
Content-Disposition: inline
In-Reply-To: <200801101419.09651.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, axboe@kernel.dk, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, Jan 10, 2008 at 02:19:08PM +0100, Oliver Neukum wrote:
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
> 
> Yes, you are doing DMA on the stack.

Nobody does DMA to rq->sense.  ub does a memcpy to it.  cciss does a
memcpy to it.  scsi_lib assigns its own buffer to req->sense, ignoring
the one passed down.

That's how this code gets away with it.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
