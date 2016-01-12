From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/2] avoid crashing when reading /proc/scsi/scsi and
 simultaneously removing devices
Date: Mon, 11 Jan 2016 18:35:42 -0800
Message-ID: <1452566142.2554.7.camel@HansenPartnership.com>
References: <1452533307-30142-1-git-send-email-emilne@redhat.com>
	 <1452539718.2363.12.camel@HansenPartnership.com>
	 <1452547979.22112.42.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452547979.22112.42.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: emilne@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org, martin.petersen@oracle.com, hare@suse.com
List-Id: linux-scsi@vger.kernel.org

On Mon, 2016-01-11 at 16:32 -0500, Ewan Milne wrote:
> On Mon, 2016-01-11 at 11:15 -0800, James Bottomley wrote:
> > On Mon, 2016-01-11 at 12:28 -0500, Ewan D. Milne wrote:
> > > From: "Ewan D. Milne" <emilne@redhat.com>
> > > 
> > > The klist traversal used by the reading of /proc/scsi/scsi is not
> > > interlocked
> > > against device removal.  It takes a reference on the containing
> > > object, but
> > > this does not prevent the device from being removed from the
> > > list. 
> > >  Thus, we
> > > get errors and eventually panic, as shown in the traces below. 
> > >  Fix
> > > this by
> > > keeping a klist iterator in the seq_file private data.
> > > 
> > > The problem can be easily reproduced by repeatedly increasing
> > > scsi_debug's
> > > max_luns to 30 and then deleting the devices via sysfs, while
> > > simulatenously
> > > accessing /proc/scsi/scsi.
> > >     
> > > From a patch originally developed by David Jeffery <
> > > djeffery@redhat.com>
> > 
> > OK, so it looks like this is a bug in the klist system.  When a
> > starting point is used, there should be a check to see if it's
> > still
> > active otherwise the whole thing is racy.  If it's fixed in klist,
> > the
> > fix works for everyone, not just SCSI.
> > 
> > How about this?  It causes the iterator to start at the beginning
> > if
> > the node has been deleted.  That will produce double output during
> > some
> > of your test, but I think that's OK given that this is a rare race.
> > 
> > James
> 
> I'm running with your change now, it does appear to fix the problem.
> I guess the question is whether this behavior would trip up any other
> klist users,

I don't see how it can.  We simply can't use a removed node as the
starting point without triggering the kref warn on you see in your log.
 Things just go downhill from there.  This will happen to any klist
user, not just us.  I'd contend that starting at the beginning is
better than an eventual panic for anyone.

What you should see currently is actually the list is truncated when
the problem is hit because the next pointer is set to the poison value.
 That causes another warn on and traversal truncation (or straight
dereference if you're unlucky).

>  for /proc/scsi/scsi it is probably not a problem.  The
> worst that might happen is that userspace tools that parse the output
> would get duplicate entries.

Well, it's not really possible to keep the current behaviour and
truncate the list (before oopsing).  There's no non-racy way of
positioning the iterator at the last element so it exits on
klist_next() because the list can be added to during the iteration.

James
