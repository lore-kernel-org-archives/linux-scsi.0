From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V2] scsi_debugfs: fix crash in scsi_show_rq()
Date: Wed, 8 Nov 2017 09:15:44 +0800
Message-ID: <20171108011543.GG20599@ming.t460p>
References: <20171107152155.19949-1-ming.lei@redhat.com>
 <1510071227.2656.12.camel@wdc.com>
 <20171108005906.GE20599@ming.t460p>
 <1510103203.2656.59.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1510103203.2656.59.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "john.garry@huawei.com" <john.garry@huawei.com>, "hare@suse.com" <hare@suse.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "osandov@fb.com" <osandov@fb.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 08, 2017 at 01:06:44AM +0000, Bart Van Assche wrote:
> On Wed, 2017-11-08 at 08:59 +0800, Ming Lei wrote:
> > On Tue, Nov 07, 2017 at 04:13:48PM +0000, Bart Van Assche wrote:
> > > On Tue, 2017-11-07 at 23:21 +0800, Ming Lei wrote:
> > > > diff --git a/drivers/scsi/scsi_debugfs.c b/drivers/scsi/scsi_debugfs.c
> > > > index 5e9755008aed..7a50878446b4 100644
> > > > --- a/drivers/scsi/scsi_debugfs.c
> > > > +++ b/drivers/scsi/scsi_debugfs.c
> > > > @@ -9,7 +9,10 @@ void scsi_show_rq(struct seq_file *m, struct request *rq)
> > > >  	int msecs = jiffies_to_msecs(jiffies - cmd->jiffies_at_alloc);
> > > >  	char buf[80];
> > > >  
> > > > -	__scsi_format_command(buf, sizeof(buf), cmd->cmnd, cmd->cmd_len);
> > > > +	if (cmd->cmnd == scsi_req(rq)->cmd)
> > > > +		__scsi_format_command(buf, sizeof(buf), cmd->cmnd, cmd->cmd_len);
> > > > +	else
> > > > +		strcpy(buf, "unknown");
> > > >  	seq_printf(m, ", .cmd=%s, .retries=%d, allocated %d.%03d s ago", buf,
> > > >  		   cmd->retries, msecs / 1000, msecs % 1000);
> > > >  }
> > > 
> > > This change introduces a new bug, namely that "unknown" will appear in the
> > > debugfs output if (cmd->cmnd != scsi_req(rq)->cmd). Have you considered to use
> > 
> > Because there isn't reliable way to get the command safely, and I don't
> > think it is a new bug.
> > 
> > > the test (cmd->cmnd != NULL) instead?
> > 
> > No, that is worse, because you may cause use-after-free if you read a
> > freed buffer.
> 
> It seems like your operating mode is still to contradict all feedback you get
> instead of trying to address the feedback you get?
> 
> Anyway, this is a debugging facility so I'm not convinced that avoiding a
> (very sporadic) use-after-free in this code is better than omitting very
> useful output.

OK, if no one objects the use-after-free, because this way may trigger
warning from some utility, such as KASAN.

-- 
Ming
