From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/1] RFC: scsi/dm-mpath: return -EACCES on reservation
 conflict
Date: Fri, 25 Feb 2011 21:39:09 -0500
Message-ID: <20110226023908.GA3650@redhat.com>
References: <1255406553-7054-1-git-send-email-michaelc@cs.wisc.edu>
 <20101217165957.GB1934@redhat.com>
 <AANLkTin+LqQBbdf6z0foVStsBpr1bwLeK4jrOKmhx2M4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884Ab1BZCjX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2011 21:39:23 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTin+LqQBbdf6z0foVStsBpr1bwLeK4jrOKmhx2M4@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Williams <Eddie.Williams@us.sios.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Hannes Reinecke <hare@suse.de>

On Fri, Feb 25 2011 at  1:40pm -0500,
Eddie Williams <Eddie.Williams@us.sios.com> wrote:

> I did not see a resolution on this and don't see any changes in
> linux-2.6.38-rc4...

None of the improved SCSI error differentiation made it in 2.6.38.

But it was discussed and resolved on linux-scsi, see:
http://marc.info/?l=linux-scsi&m=129527914627980&w=2

The final commit, which reflects the above discussion, was staged in
James' scsi-misc-2.6 for 2.6.39 inclusion.  It includes special
processing to properly account for RESERVATION CONFLICT (differentiates
SCSI errors further and returns EBADE), see:
http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=63583cca745f440167bf27877182dc13e19d4bcf

>From that commit's header:
"EBADE: I/O error restricted to the I_T_L nexus"
...
"I/O errors restricted to the I_T_L nexus might be retried
on another nexus / path, but they should _not_ be queued
if no paths are available."

Also, the mpath change (also queued for 2.6.39) includes proper handling
of EBADE:
http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=751b2a7d623ead9e55f751a6087efeab454b5659


> I would like to disagree that it is not useful or appropriate to retry an IO
> that gets a RESERVATION CONFLICT on different paths to the storage.  The
> issue is a possible window when a path is hot added to the system and before
> a registration is added for the new path.  OK, this window is for SCSI-3
> reservations not SCSI-2...
> 
> If an IO is sent down the new path in this window then it will get a
> reservation conflict.  If the IO is retried on another path (that is
> registered) then it will work.
> 
> So I think the reservation conflict should be retried on each path and then
> failed if none work.  The key issue being we don't want to get into an
> infinite loop here where we retry forever especially when another IO comes
> does (like a read if the lock is a write lock or for many devices a test
> unit ready) that will look like the path is fine so mark the path good
> again.
> 
> The alternative to retrying would be to make sure that before an IO is
> allowed down a new path that the path is registered.  This would mean that
> instead of registering/reserving the paths by an application outside of
> device mapper multipath that it would need to be done inside device mapper
> so it knows what/when to register.
> 
> Eddie Williams
> On Fri, Dec 17, 2010 at 11:59 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > On Tue, Oct 13 2009 at 12:02am -0400,
> > michaelc@cs.wisc.edu <michaelc@cs.wisc.edu> wrote:
> >
> > > From: Mike Christie <michaelc@cs.wisc.edu>
> > >
> > > This patch was made over this patch
> > > http://marc.info/?l=linux-scsi&m=125417106125449&w=2
> > >
> > > The basic problem is that we do not want dm-multipath to retry
> > > this error, but the scsi layer returns -EIO or -EILSEQ, so
> > > dm-multipath cannot distinguish between a reservation conflict
> > > and other errors.
> > >
> > > This problem was originally discussed here
> > >
> > http://www.linux-archive.org/device-mapper-development/180290-dm-mpath-scsi-persistent-reservation.html
> > >
> > > I have considered adding new blk error values (I have sent pactches
> > > for this before and can send updated ones if we want to go this route),
> > > and even just using more -EXYZ values for scsi errors, but in the end I
> > am
> > > just not sure it ended up being worth it, so this patch just
> > > handles the one error.
> > >
> > > The problem with adding new blk errors is that it seems only dm-multipath
> > > knows what it wants (have not seen anything from the FS or RAID people),
> > > and I also do not know what every device is sending so I cannot
> > completely
> > > clean up cases like where a device returns a error (check condition
> > > and sense) indicating a controller port is temporarily unavialable.
> > > For example, I do not know if I am getting a ILLEGAL request for some
> > > non retryable device error vs the controller is getting its FW updated
> > > (for a non retryable device error case we do not want to fail the path
> > > and just want to fail the IO, but for FW update we just want to fail
> > > the path), so I have to treat those device errors like a transport error
> > > and just fail the path.
> > >
> > > So, I did another take just using lots of different -EXYZ values. See
> > > this patch
> > >
> > > for an example. The problem is still that the transport error
> > > and generic error cases are the same so all I bought was the handling
> > > of the reservation conflict.
> > >
> > > And, that is how I ended up here where I am only handling the one
> > > error I know for sure will cause problems with the infrastructure we
> > have.
> > > I am  not in love with this patch, so please give me any other
> > > suggestions.
> > >
> > > Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> > > ---
> > >  drivers/md/dm-mpath.c   |    2 +-
> > >  drivers/scsi/scsi_lib.c |    4 ++++
> > >  2 files changed, 5 insertions(+), 1 deletions(-)
> > >
> > > diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> > > index 32d0b87..93e6ce5 100644
> > > --- a/drivers/md/dm-mpath.c
> > > +++ b/drivers/md/dm-mpath.c
> > > @@ -1214,7 +1214,7 @@ static int do_end_io(struct multipath *m, struct
> > request *clone,
> > >       if (!error && !clone->errors)
> > >               return 0;       /* I/O complete */
> > >
> > > -     if (error == -EOPNOTSUPP)
> > > +     if (error == -EOPNOTSUPP || error == -EACCES)
> > >               return error;
> > >
> > >       if (mpio->pgpath)
> > > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > > index 1086552..5635035 100644
> > > --- a/drivers/scsi/scsi_lib.c
> > > +++ b/drivers/scsi/scsi_lib.c
> > > @@ -797,6 +797,10 @@ void scsi_io_completion(struct scsi_cmnd *cmd,
> > unsigned int good_bytes)
> > >                * happens.
> > >                */
> > >               action = ACTION_RETRY;
> > > +     else if (status_byte(cmd->result) == RESERVATION_CONFLICT) {
> > > +             error = -EACCES;
> > > +             description = "Could not access device";
> > > +             action = ACTION_FAIL;
> > >       } else if (sense_valid && !sense_deferred) {
> > >               switch (sshdr.sense_key) {
> > >               case UNIT_ATTENTION:
> > > --
> > > 1.6.2.2
> >
> > Hi Mike,
> >
> > Just a reminder that Hannes has proposed a slightly different approach
> > (returning -EREMOTEIO instead of -EACCES).  Here is the version of
> > Hannes' patch that I reviewed/rebased/tweaked last week:
> > https://patchwork.kernel.org/patch/384612/
> >
> > (NOTE: the scsi_decide_disposition() change relative to
> > RESERVATION_CONFLICT).
> >
> > And here is the corresponding DM mpath change:
> > https://patchwork.kernel.org/patch/384602/
> >
> > If you agree with this approach your ack would be appreciated.
> >
> > Thanks,
> > Mike
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
