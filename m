From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] blktrace interface for sg devices
Date: Thu, 13 Dec 2007 10:19:42 +0100
Message-ID: <20071213091942.GB10113@kernel.dk>
References: <20071213090946.GA32110@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:17219 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538AbXLMJXQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 04:23:16 -0500
Content-Disposition: inline
In-Reply-To: <20071213090946.GA32110@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-btrace@vger.kernel.org

On Thu, Dec 13 2007, Christof Schmitt wrote:
> I am referring to the discussion of introducing statistics in the SCSI
> layer and the conclusion that blktrace already provides the data:
> http://lkml.org/lkml/2006/10/21/72
> http://lkml.org/lkml/2006/11/2/141
> 
> While blktrace works fine for disk devices, it currently does not
> provide data for non-disk devices like tape drives. To close this gap,
> i am looking for a way to get the same trace data also from other SCSI
> devices.
> 
> Since the SCSI layer internally uses the same request queuest for all
> devices and the queues already use the blktrace interface, the main
> missing part is the interface to enable the tracing for all SCSI
> devices.
> 
> Attached is a patch that adds the ioctl interface for blktrace to the
> sg generic scsi interface. This already allows to get some trace data
> for SCSI tape drives, although i have to do more testing.
> 
> For testing, any sg device file can be passed to blktrace, e.g.:
> # blktrace -d /dev/sg1 -o - | blkparse -i -
> 
> I am seeking input in this approach: Is this approach worth pursuing
> to enable blktrace to trace SCSI tape drives? Would there be a better
> approach to get this trace data?

I think this approach is the simplest and right way to do it. Tracing is
really just tied to the "transport" (transport here meaning how we
transport commands to the device), and even character scsi devices use
the block layer queue for this operation, as you note.

Let me know when you are happy with the patch, and I'll queue it up for
2.6.25.
> @@ -1066,6 +1068,16 @@ sg_ioctl(struct inode *inode, struct fil
>  	case BLKSECTGET:
>  		return put_user(sdp->device->request_queue->max_sectors * 512,
>  				ip);
> +	case BLKTRACESETUP:
> +	{
> +		return blk_trace_setup(sdp->device->request_queue , sdp->device->sdev_gendev.bus_id, &sdp->device->sdev_gendev, arg);
> +	}

Don't need those braces, some other space and long line style issues as
well.

> --- a/include/linux/blkdev.h	2007-12-13 08:48:23.000000000 +0100
> +++ b/include/linux/blkdev.h	2007-12-13 08:48:25.000000000 +0100
> @@ -747,6 +747,16 @@ static inline void blkdev_dequeue_reques
>  	elv_dequeue_request(req->q, req);
>  }
>  
> +#ifdef CONFIG_BLK_DEV_IO_TRACE
> +extern int blk_trace_setup(request_queue_t *q,  char * name, dev_t dev, char __user *arg);
> +extern int blk_trace_startstop(request_queue_t *q, int start);
> +extern int blk_trace_remove(request_queue_t *q);
> +#else
> +#define blk_trace_setup(q, name, dev, arg) do { } while(0)
> +#define blk_trace_startstop(q, start) do { } while(0)
> +#define blk_trace_remove(q) do { } while(0)
> +#endif
> +

Put these in the blktrace include file.

-- 
Jens Axboe

