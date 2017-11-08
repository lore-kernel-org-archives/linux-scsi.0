From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V2] scsi_debugfs: fix crash in scsi_show_rq()
Date: Wed, 8 Nov 2017 11:37:40 +0800
Message-ID: <20171108033733.GA30541@ming.t460p>
References: <20171107152155.19949-1-ming.lei@redhat.com>
 <1510071227.2656.12.camel@wdc.com>
 <20171108005906.GE20599@ming.t460p>
 <1510103203.2656.59.camel@wdc.com>
 <20171108011543.GG20599@ming.t460p>
 <1510110263.3118.74.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42162 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751807AbdKHDhz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Nov 2017 22:37:55 -0500
Content-Disposition: inline
In-Reply-To: <1510110263.3118.74.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "john.garry@huawei.com" <john.garry@huawei.com>, "hare@suse.com" <hare@suse.com>, "osandov@fb.com" <osandov@fb.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>

Hi James,

On Tue, Nov 07, 2017 at 07:04:23PM -0800, James Bottomley wrote:
> On Wed, 2017-11-08 at 09:15 +0800, Ming Lei wrote:
> > On Wed, Nov 08, 2017 at 01:06:44AM +0000, Bart Van Assche wrote:
> > > 
> > > On Wed, 2017-11-08 at 08:59 +0800, Ming Lei wrote:
> > > > 
> > > > On Tue, Nov 07, 2017 at 04:13:48PM +0000, Bart Van Assche wrote:
> > > > > 
> > > > > On Tue, 2017-11-07 at 23:21 +0800, Ming Lei wrote:
> > > > > > 
> > > > > > diff --git a/drivers/scsi/scsi_debugfs.c
> > > > > > b/drivers/scsi/scsi_debugfs.c
> > > > > > index 5e9755008aed..7a50878446b4 100644
> > > > > > --- a/drivers/scsi/scsi_debugfs.c
> > > > > > +++ b/drivers/scsi/scsi_debugfs.c
> > > > > > @@ -9,7 +9,10 @@ void scsi_show_rq(struct seq_file *m, struct
> > > > > > request *rq)
> > > > > >  	int msecs = jiffies_to_msecs(jiffies - cmd-
> > > > > > >jiffies_at_alloc);
> > > > > >  	char buf[80];
> > > > > >  
> > > > > > -	__scsi_format_command(buf, sizeof(buf), cmd->cmnd,
> > > > > > cmd->cmd_len);
> > > > > > +	if (cmd->cmnd == scsi_req(rq)->cmd)
> > > > > > +		__scsi_format_command(buf, sizeof(buf), cmd-
> > > > > > >cmnd, cmd->cmd_len);
> > > > > > +	else
> > > > > > +		strcpy(buf, "unknown");
> > > > > >  	seq_printf(m, ", .cmd=%s, .retries=%d, allocated
> > > > > > %d.%03d s ago", buf,
> > > > > >  		   cmd->retries, msecs / 1000, msecs %
> > > > > > 1000);
> > > > > >  }
> > > > > 
> > > > > This change introduces a new bug, namely that "unknown" will
> > > > > appear in the debugfs output if (cmd->cmnd != scsi_req(rq)-
> > > > > >cmd). Have you considered to use
> > > > 
> > > > Because there isn't reliable way to get the command safely, and I
> > > > don't think it is a new bug.
> > > > 
> > > > > 
> > > > > the test (cmd->cmnd != NULL) instead?
> > > > 
> > > > No, that is worse, because you may cause use-after-free if you
> > > > read a freed buffer.
> > > 
> > > It seems like your operating mode is still to contradict all
> > > feedback you get instead of trying to address the feedback you get?
> > > 
> > > Anyway, this is a debugging facility so I'm not convinced that
> > > avoiding a (very sporadic) use-after-free in this code is better
> > > than omitting very useful output.
> > 
> > OK, if no one objects the use-after-free, because this way may
> > trigger warning from some utility, such as KASAN.
> 
> Good grief, this list is supposed to be for technical discussions not
> kindergarten playground squabbles; could you both please act your age?

In my reply, I mentioned I don't object to check NULL any more, and only
provide one extra input about possible KASAN's complaint, which may annoy
people.

> 
> The patch as proposed would lose us all information about PI commands,
> hence the objection.  For the concern about use after free on the NULL
> check, what about modifying sd_uninit_command() to NULL SCpnt->cmnd
> before it calls mempool_free()?  That will likely eliminate the race
> window for printing the command.

That may decrease the window, but can't eliminate it because of write/read
can be reordered.

But looks better, will cook a patch soon, together with using READ_ONCE() and
WRITE_ONCE().

Thanks,
Ming
