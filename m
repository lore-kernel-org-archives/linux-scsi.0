From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: 4.15.14 crash with iscsi target and dvd
Date: Thu, 5 Apr 2018 22:06:51 -0400
Message-ID: <20180406020651.GB16112@animx.eu.org>
References: <20180331015903.GA29398@animx.eu.org>
 <CAFLxGvzbA9XzXLsH56iyqYkitrSnBbOzD977u4266=w5zw0jNg@mail.gmail.com>
 <20180331221252.GA25573@animx.eu.org>
 <b68bf187c9cde1c36489fc5ab2187ca8750a1292.camel@wdc.com>
 <20180401113721.GA8471@animx.eu.org>
 <20180401163604.GB25011@animx.eu.org>
 <20180401182723.GA31755@animx.eu.org>
 <595a10cfb387e6b2ab4d2053b84fed9b3da9e079.camel@wdc.com>
 <20180406014644.GA16112@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180406014644.GA16112@animx.eu.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "richard.weinberger@gmail.com" <richard.weinberger@gmail.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Wakko Warner wrote:
> Bart Van Assche wrote:
> > On Sun, 2018-04-01 at 14:27 -0400, Wakko Warner wrote:
> > > Wakko Warner wrote:
> > > > Wakko Warner wrote:
> > > > > I tested 4.14.32 last night with the same oops.  4.9.91 works fine.
> > > > > From the initiator, if I do cat /dev/sr1 > /dev/null it works.  If I mount
> > > > > /dev/sr1 and then do find -type f | xargs cat > /dev/null the target
> > > > > crashes.  I'm using the builtin iscsi target with pscsi.  I can burn from
> > > > > the initiator with out problems.  I'll test other kernels between 4.9 and
> > > > > 4.14.
> > > > 
> > > > So I've tested 4.x.y where x one of 10 11 12 14 15 and y is the latest patch
> > > > (except for 4.15 which was 1 behind)
> > > > Each of these kernels crash within seconds or immediate of doing find -type
> > > > f | xargs cat > /dev/null from the initiator.
> > > 
> > > I tried 4.10.0.  It doesn't completely lockup the system, but the device
> > > that was used hangs.  So from the initiator, it's /dev/sr1 and from the
> > > target it's /dev/sr0.  Attempting to read /dev/sr0 after the oops causes the
> > > process to hang in D state.
> > 
> > Hello Wakko,
> > 
> > Thank you for having narrowed down this further. I think that you encountered
> > a regression either in the block layer core or in the SCSI core. Unfortunately
> > the number of changes between kernel versions v4.9 and v4.10 in these two
> > subsystems is huge. I see two possible ways forward:
> > - Either that you perform a bisect to identify the patch that introduced this
> >   regression. However, I'm not sure whether you are familiar with the bisect
> >   process.
> > - Or that you identify the command that triggers this crash such that others
> >   can reproduce this issue without needing access to your setup.
> > 
> > How about reproducing this crash with the below patch applied on top of
> > kernel v4.15.x? The additional output sent by this patch to the system log
> > should allow us to reproduce this issue by submitting the same SCSI command
> > with sg_raw.
> 
> Ok, so I tried this, but scsi_print_command doesn't print anything.  I added
> a check for !rq and the same thing that blk_rq_nr_phys_segments does in an
> if statement above this thinking it might have crashed during WARN_ON_ONCE.
> It still didn't print anything.  My printk shows this:
> [  36.263193] sr 3:0:0:0: cmd->request->nr_phys_segments is 0
> 
> I also had scsi_print_command in the same if block which again didn't print
> anything.  Is there some debug option I need to turn on to make it print?  I
> tried looking through the code for this and following some of the function
> calls but didn't see any config options.

I know now why scsi_print_command isn't doing anything.  cmd->cmnd is null.
I added a dev_printk in scsi_print_command where the 2 if statements return.
Logs:
[  29.866415] sr 3:0:0:0: cmd->cmnd is NULL

> > Subject: [PATCH] Report commands with no physical segments in the system log
> > 
> > ---
> >  drivers/scsi/scsi_lib.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index 6b6a6705f6e5..74a39db57d49 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -1093,8 +1093,10 @@ int scsi_init_io(struct scsi_cmnd *cmd)
> >  	bool is_mq = (rq->mq_ctx != NULL);
> >  	int error = BLKPREP_KILL;
> >  
> > -	if (WARN_ON_ONCE(!blk_rq_nr_phys_segments(rq)))
> > +	if (WARN_ON_ONCE(!blk_rq_nr_phys_segments(rq))) {
> > +		scsi_print_command(cmd);
> >  		goto err_exit;
> > +	}
> >  
> >  	error = scsi_init_sgtable(rq, &cmd->sdb);
> >  	if (error)
> -- 
>  Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
>  million bugs.
-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
