From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V2] scsi_debugfs: fix crash in scsi_show_rq()
Date: Wed, 8 Nov 2017 08:59:07 +0800
Message-ID: <20171108005906.GE20599@ming.t460p>
References: <20171107152155.19949-1-ming.lei@redhat.com>
 <1510071227.2656.12.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1510071227.2656.12.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "JBottomley@parallels.com" <JBottomley@parallels.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@fb.com" <axboe@fb.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "john.garry@huawei.com" <john.garry@huawei.com>, "hare@suse.com" <hare@suse.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "osandov@fb.com" <osandov@fb.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 07, 2017 at 04:13:48PM +0000, Bart Van Assche wrote:
> On Tue, 2017-11-07 at 23:21 +0800, Ming Lei wrote:
> > cmd->cmnd can be allocated/freed dynamically in case of T10_PI_TYPE2_PROTECTION,
> > so we can't access it in scsi_show_rq() if 'SCpnt->cmnd != scsi_req(rq)->cmd',
> > because this request can be freed any time.
> 
> That description is inaccurate. It is not allowed to free SCpnt->cmnd while
> a command is being executed.

But can you prevent this request being freed when reading this debugfs
file?

> 
> > diff --git a/drivers/scsi/scsi_debugfs.c b/drivers/scsi/scsi_debugfs.c
> > index 5e9755008aed..7a50878446b4 100644
> > --- a/drivers/scsi/scsi_debugfs.c
> > +++ b/drivers/scsi/scsi_debugfs.c
> > @@ -9,7 +9,10 @@ void scsi_show_rq(struct seq_file *m, struct request *rq)
> >  	int msecs = jiffies_to_msecs(jiffies - cmd->jiffies_at_alloc);
> >  	char buf[80];
> >  
> > -	__scsi_format_command(buf, sizeof(buf), cmd->cmnd, cmd->cmd_len);
> > +	if (cmd->cmnd == scsi_req(rq)->cmd)
> > +		__scsi_format_command(buf, sizeof(buf), cmd->cmnd, cmd->cmd_len);
> > +	else
> > +		strcpy(buf, "unknown");
> >  	seq_printf(m, ", .cmd=%s, .retries=%d, allocated %d.%03d s ago", buf,
> >  		   cmd->retries, msecs / 1000, msecs % 1000);
> >  }
> 
> This change introduces a new bug, namely that "unknown" will appear in the
> debugfs output if (cmd->cmnd != scsi_req(rq)->cmd). Have you considered to use

Because there isn't reliable way to get the command safely, and I don't
think it is a new bug.

> the test (cmd->cmnd != NULL) instead?

No, that is worse, because you may cause use-after-free if you read a
freed buffer.


-- 
Ming
