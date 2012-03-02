From: scameron@beardog.cce.hp.com
Subject: Re: If abort request comes in for command not known to LLD?
Date: Fri, 2 Mar 2012 17:01:56 -0600
Message-ID: <20120302230156.GN17975@beardog.cce.hp.com>
References: <20120302154438.GE17975@beardog.cce.hp.com> <4F51372A.8080309@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:40496 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965354Ab2CBXB6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Mar 2012 18:01:58 -0500
Content-Disposition: inline
In-Reply-To: <4F51372A.8080309@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, scameron@beardog.cce.hp.com

On Fri, Mar 02, 2012 at 03:10:02PM -0600, Mike Christie wrote:
> On 03/02/2012 09:44 AM, scameron@beardog.cce.hp.com wrote:
> > 
> > What should the LLD do if an abort request comes into the
> > abort error handler from the midlayer for a command which is
> > not known to the LLD?
> > 
> > I see aic7xxx_osm.c handles it in this way in ahc_linux_queue_recovery_cmd():
> > 
> > no_cmd:
> >         /*
> >          * Our assumption is that if we don't have the command, no
> >          * recovery action was required, so we return success.  Again,
> >          * the semantics of the mid-layer recovery engine are not
> >          * well defined, so this may change in time.
> >          */
> >         retval = SUCCESS;
> > 
> > Is that the right thing to do?  Seems a bit weird, but if that's
> > the right thing to do, I can do that too.
> > 
> 
> How do you hit this case?

I'm not quite sure.  I haven't hit it, but have a report of it on RHEL5u5
with XFS filesystem under heavy load.  As a guess, I'd say a race between
driver completing the command and a timeout in the mid layer.  In any
case, it'd be nice to know what the kernel expects a driver to do if
it should encounter that situation.

> 
> I think it is ok. The reasons I have seen drivers hit it this is that
> race where the driver is completing a command while the timer code is
> starting to go off, or the cmd has timed out then the driver completes
> the command before the abort code is run.
> 
> In those cases the driver has cleaned up its internal accounting because
> the command has completed. At that point there is not much it can do
> even if it wanted to. It does not have away to look up things like
> internal tags/ids for the command.

Right, but it just seems weird for the driver to effectively say, "Sure,
I aborted that command", when it did no such thing.  If the driver tells
the kernel that a write got aborted when really it was completed, that
seems like it could be kind of bad.

-- steve

