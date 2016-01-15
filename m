From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: don't count non-failure CHECK_CONDITION as error
Date: Fri, 15 Jan 2016 10:35:34 -0800
Message-ID: <1452882934.2356.13.camel@HansenPartnership.com>
References: <20160114214602.GC3520@mtj.duckdns.org>
	 <1452872774.2356.5.camel@HansenPartnership.com>
	 <1452873302.2356.9.camel@HansenPartnership.com>
	 <56992361.7030606@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57640 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751314AbcAOSfg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jan 2016 13:35:36 -0500
In-Reply-To: <56992361.7030606@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, Tejun Heo <tj@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Dave Jones <dsj@fb.com>, kernel-team@fb.com

On Fri, 2016-01-15 at 17:50 +0100, Douglas Gilbert wrote:
> On 16-01-15 04:55 PM, James Bottomley wrote:
> > On Fri, 2016-01-15 at 07:46 -0800, James Bottomley wrote:
> > > On Thu, 2016-01-14 at 16:46 -0500, Tejun Heo wrote:
> > > > SCSI command completion path bumps ioerr_cnt whenever scsi_cmd
> > > > ->result isn't zero; unfortunately, this means that non-error
> > > > sense
> > > > reporting bumps the counter too.  This is pronounced with ATA
> > > > passthrough commands because most of them explicitly request
> > > > the
> > > > resulting taskfile to be transported via sense data bumping the
> > > > count
> > > > unconditionally.
> > > > 
> > > > Don't bump the counter if scsi_cmd->result simply indicates
> > > > that
> > > > sense data is available.
> > > > 
> > > > Signed-off-by: Tejun Heo <tj@kernel.org>
> > > > Reported-by: Dave Jones <dsj@fb.com>
> > > > ---
> > > >   drivers/scsi/scsi_lib.c |    3 ++-
> > > >   1 file changed, 2 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > > > index fa6b2c4..e90e3f7 100644
> > > > --- a/drivers/scsi/scsi_lib.c
> > > > +++ b/drivers/scsi/scsi_lib.c
> > > > @@ -1622,7 +1622,8 @@ static void scsi_softirq_done(struct
> > > > request
> > > > *rq)
> > > >   	INIT_LIST_HEAD(&cmd->eh_entry);
> > > > 
> > > >   	atomic_inc(&cmd->device->iodone_cnt);
> > > > -	if (cmd->result)
> > > > +	if (cmd->result &&
> > > > +	    cmd->result != ((DRIVER_SENSE << 24) |
> > > > SAM_STAT_CHECK_CONDITION))
> > > >   		atomic_inc(&cmd->device->ioerr_cnt);
> > > 
> > > OK, it makes sense to me that we don't include non-error check
> > > conditions.  However, then you shouldn't be checking
> > > DRIVER_SENSE.
> > >   We still have a few drivers that rely on the error handler to
> > > fetch
> > > sense explicitly ... they could eventually return non-error
> > > conditions as well.
> > 
> > Actually, I take this back: if we add your proposal, we never
> > increment
> > the ioerr_cnt even for sense returns indicating failure.  That
> > looks to
> > be even worse than incrementing it too often.
> > 
> > The other problem is that if we do this for you, we should do the
> > same
> > for SCSI with BUSY and QUEUE_FULL ... they indicate temporary retry
> > conditions and shouldn't be treated as errors.
> > 
> > I'll stop looking now before I find any more problems with the
> > statistics code ...  I think it needs a rethink.
> 
> SCSI status and sense data is non-trivial to decode. It looks
> like someone thought that one-liner would bypass a lot of hard
> work. Most of the time sense data indicates an error but not
> always. Even worse, it can contain vendor specific codes. If
> this statistic is on the fast path then IMO it should be retired
> (and any others like it). For backward compatibility set it to
> 0 once at initialization and document the change. Or you could
> have a discouraging kernel config option such as
> CONFIG_EXPENSIVE_SCSI_STATISTICS ("nonsensical" is another term
> that comes to mind).

Well, I can see sense in having an error count of everything that comes
back that's not good status because it's easy and has a well defined
meaning (calling it the "error count" is more debatable, agreed).  It
appears that Dave and Tejun want the count to mean something else. 
 Lets treat this as a feature exercise: Dave and Tejun, what do you
want, then we can see if we could add an additional counter giving you
that.

James


