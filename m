From: Oliver Neukum <oliver@neukum.org>
Subject: Re: memory allocation in sg_io()
Date: Thu, 10 Jan 2008 14:19:08 +0100
Message-ID: <200801101419.09651.oliver@neukum.org>
References: <200801101333.12293.oliver@neukum.org> <47861815.5090008@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out001.kontent.com ([81.88.40.215]:41228 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbYAJNSb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jan 2008 08:18:31 -0500
In-Reply-To: <47861815.5090008@panasas.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: axboe@kernel.dk, SCSI development list <linux-scsi@vger.kernel.org>

Am Donnerstag, 10. Januar 2008 14:05:25 schrieb Boaz Harrosh:
> On Thu, Jan 10 2008 at 14:33 +0200, Oliver Neukum <oliver@neukum.org> wrote:
> > Hi,
> > 
> > could you explain to me why this code can get away with allocating the
> > sense buffer on the stack?
> > 
> > static int sg_io(struct file *file, struct request_queue *q,
> > 		struct gendisk *bd_disk, struct sg_io_hdr *hdr)
> > {
> > 	unsigned long start_time;
> > 	int writing = 0, ret = 0, has_write_perm = 0;
> > 	struct request *rq;
> > 	char sense[SCSI_SENSE_BUFFERSIZE];
> > 
> > 	Regards
> > 		Oliver
> > -
> where? what? do you mean in scsi_ioctl.c?
> why not it's a synchronous call?
> Do you mean 96 bytes is too big?
> Do you mean DMA alignment and cache coherency? I'm working
> on that for scsi devices.

Yes, you are doing DMA on the stack.

	Regards
		Oliver


