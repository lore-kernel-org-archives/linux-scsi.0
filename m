From: Jens Axboe <axboe@suse.de>
Subject: Re: When & how is the SCSI strategy routine called?
Date: Wed, 23 Mar 2005 11:39:28 +0100
Message-ID: <20050323103926.GQ24105@suse.de>
References: <267988DEACEC5A4D86D5FCD780313FBB06043621@exch-03.noida.hcltech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <267988DEACEC5A4D86D5FCD780313FBB06043621@exch-03.noida.hcltech.com>
Sender: linux-newbie-owner@vger.kernel.org
To: "Rajat  Jain, Noida" <rajatj@noida.hcltech.com>
Cc: lk <linux_kernel@patni.com>, linux-scsi@vger.kernel.org, linux-newbie@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 23 2005, Rajat  Jain, Noida wrote:
>  
> 
> Thanks lk.
> 
> It cleared a lot of things.
> 
> How ever, what I am wondering is:
> 
> - Does each device queue have a corresponding thread that is woken up when
> it is time to call the request function? And the request function is called
> in the context of this thread?
> 
> - I explored and found that there is some "worker thread" kblockd that does
> this task of monitoring the queue and calling the request function. I want
> to know whether there is a separate thread for each queue (device) , or just
> one for all the block devices?

There is on kblockd thread per cpu for all queues. But note that the
request function is only invoked through that, if you get the unplug
threshold kicking in _or_ the io scheduler uses it to awake the queue.
The normal path for unplugs (this is what invokes the request handler)
is exceeding unplug_thresh or somebody calling blk_run_backing_dev()
either directly or from blk_run_address_space().

Normally drivers will re-invoke the request handler themselves, when
requests complete. So once the unplug has happened, if there is a
continual influx of io for that queue, the queue will not get replugged
and it is the drivers responsibility to reinvoke the request handler.

-- 
Jens Axboe

-
To unsubscribe from this list: send the line "unsubscribe linux-newbie" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at http://www.linux-learn.org/faqs
