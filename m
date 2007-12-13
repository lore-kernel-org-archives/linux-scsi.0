From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [RFC] blktrace interface for sg devices
Date: Thu, 13 Dec 2007 17:23:32 +0100
Message-ID: <20071213162332.GA16902@schmichrtp.de.ibm.com>
References: <20071213090946.GA32110@schmichrtp.de.ibm.com> <20071213091942.GB10113@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:56837 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139AbXLMQXr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Dec 2007 11:23:47 -0500
Content-Disposition: inline
In-Reply-To: <20071213091942.GB10113@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-btrace@vger.kernel.org

On Thu, Dec 13, 2007 at 10:19:42AM +0100, Jens Axboe wrote:
[...]
> I think this approach is the simplest and right way to do it. Tracing is
> really just tied to the "transport" (transport here meaning how we
> transport commands to the device), and even character scsi devices use
> the block layer queue for this operation, as you note.
> 
> Let me know when you are happy with the patch, and I'll queue it up for
> 2.6.25.
> > @@ -1066,6 +1068,16 @@ sg_ioctl(struct inode *inode, struct fil
> >  	case BLKSECTGET:
> >  		return put_user(sdp->device->request_queue->max_sectors * 512,
> >  				ip);
> > +	case BLKTRACESETUP:
> > +	{
> > +		return blk_trace_setup(sdp->device->request_queue , sdp->device->sdev_gendev.bus_id, &sdp->device->sdev_gendev, arg);
> > +	}
> 
> Don't need those braces, some other space and long line style issues as
> well.
> 
> > --- a/include/linux/blkdev.h	2007-12-13 08:48:23.000000000 +0100
> > +++ b/include/linux/blkdev.h	2007-12-13 08:48:25.000000000 +0100
> > @@ -747,6 +747,16 @@ static inline void blkdev_dequeue_reques
> >  	elv_dequeue_request(req->q, req);
> >  }
> >  
> > +#ifdef CONFIG_BLK_DEV_IO_TRACE
> > +extern int blk_trace_setup(request_queue_t *q,  char * name, dev_t dev, char __user *arg);
> > +extern int blk_trace_startstop(request_queue_t *q, int start);
> > +extern int blk_trace_remove(request_queue_t *q);
> > +#else
> > +#define blk_trace_setup(q, name, dev, arg) do { } while(0)
> > +#define blk_trace_startstop(q, start) do { } while(0)
> > +#define blk_trace_remove(q) do { } while(0)
> > +#endif
> > +
> 
> Put these in the blktrace include file.

Thanks for your input. I will prepare and send an updated version of
the patch. I also want to do some more testing, especially to see how
i can get the sizes of read and write requests and latencies for SCSI
tape drives.

Christof Schmitt
