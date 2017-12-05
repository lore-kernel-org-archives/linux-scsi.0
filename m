From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] blk-mq: Fix several SCSI request queue lockups
Date: Tue, 5 Dec 2017 09:18:51 +0800
Message-ID: <20171205011850.GD8365@ming.t460p>
References: <20171204173032.16330-1-bart.vanassche@wdc.com>
 <20171204224200.GA6888@ming.t460p>
 <1512427697.2795.14.camel@wdc.com>
 <20171204230151.GD6888@ming.t460p>
 <1512430346.2795.34.camel@wdc.com>
 <20171205002040.GA8365@ming.t460p>
 <1512433798.2795.45.camel@wdc.com>
 <20171205010428.GB8365@ming.t460p>
 <1512436422.2795.47.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1512436422.2795.47.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 05, 2017 at 01:13:43AM +0000, Bart Van Assche wrote:
> On Tue, 2017-12-05 at 09:04 +0800, Ming Lei wrote:
> > Then no reason to revert commit(0df21c86bdbf scsi: implement .get_budget an
> > .put_budget for blk-mq) for one issue which may never happen in reality since
> > this reproducer need out-of-tree patch.
> 
> Sorry but I disagree completely. You seem to overlook that there may be other
> circumstances that trigger the same lockup, e.g. a SCSI queue full condition.

If the scsi_dev_queue_ready() returns false, .get_budget() catches that
and never add request to hctx->dispatch. And scsi_host_queue_ready()
always returns true, since we respect per-host queue depth by
blk_mq_get_driver_tag() before calling .queue_rq().

Or if I miss other cases, please point it out.

-- 
Ming
