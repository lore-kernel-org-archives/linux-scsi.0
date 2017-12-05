From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] blk-mq: Fix several SCSI request queue lockups
Date: Tue, 5 Dec 2017 09:04:29 +0800
Message-ID: <20171205010428.GB8365@ming.t460p>
References: <20171204173032.16330-1-bart.vanassche@wdc.com>
 <20171204224200.GA6888@ming.t460p>
 <1512427697.2795.14.camel@wdc.com>
 <20171204230151.GD6888@ming.t460p>
 <1512430346.2795.34.camel@wdc.com>
 <20171205002040.GA8365@ming.t460p>
 <1512433798.2795.45.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1512433798.2795.45.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 05, 2017 at 12:29:59AM +0000, Bart Van Assche wrote:
> On Tue, 2017-12-05 at 08:20 +0800, Ming Lei wrote:
> > Also it is a bit odd to see request in hctx->dispatch now, and it can only
> > happen now when scsi_target_queue_ready() returns false, so I guess you apply
> > some change on target->can_queue(such as setting it as 1 in srp/ib code
> > manually)?
> 
> Yes, but that had already been mentioned. From the e-mail at the start of
> this e-mail thread: "Change the SRP initiator such that SCSI target queue
> depth is limited to 1." The changes I made in the SRP initiator are the same
> as those described in the following message from about one month ago:
> https://www.spinics.net/lists/linux-scsi/msg114720.html.

OK, got it.

Then no reason to revert commit(0df21c86bdbf scsi: implement .get_budget an
.put_budget for blk-mq) for one issue which may never happen in reality since
this reproducer need out-of-tree patch.

I don't mean it isn't a issue, but I don't think it has top priority
for reverting commit 0df21c86bdbf. Especially there isn't proof shown
that 0df21c86bdbf causes this issue since this commit won't change run
queue for requests in hctx->dispatch_list.

I's like to take a look if someone'd like to cooperate, such as
providing kernel log, test debug patch, and kind of things. Or when
I get this hardware to reproduce.

--
Ming
