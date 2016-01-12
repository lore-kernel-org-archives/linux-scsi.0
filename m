From: Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH] [SCSI] osst: remove double conversion of timeout
Date: Tue, 12 Jan 2016 15:10:42 +0000
Message-ID: <20160112151042.GA27289@osadl.at>
References: <1452197433-26086-1-git-send-email-hofrat@osadl.org>
 <DDB9C85B850785449757F9914A034FCB445092F8@G9W0766.americas.hpqcorp.net>
 <20160108073155.GA16584@osadl.at>
 <DDB9C85B850785449757F9914A034FCB4450A1AF@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <DDB9C85B850785449757F9914A034FCB4450A1AF@G9W0766.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hpe.com>
Cc: Nicholas Mc Guire <hofrat@osadl.org>, Willem Riede <osst@riede.org>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "osst-users@lists.sourceforge.net" <osst-users@lists.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 11, 2016 at 12:54:48AM +0000, Seymour, Shane M wrote:
> 
> > did I overlook something here ?
> 
> You probably didn't overlook anything my comments were based on how msleep
> was coded.
>
...I did overlookck something - comments in the code may not always be 
correct...

Unfortunatly the comment regarding schedule_timeout() in timer.c turns out 
to be wrong as clarified by Thomas Gleixnr - see below:

<snip>
On Tue, 12 Jan 2016, Nicholas Mc Guire wrote:
> On Mon, Jan 11, 2016 at 09:15:25AM +0100, Thomas Gleixner wrote:
> > On Sat, 9 Jan 2016, Nicholas Mc Guire wrote:
> > 
> > >  The while loop in msleep does not seem necessary as
> > > timeout is unsigned long and no larger than MAX_JIFFY_OFFSET (which is
> > > LONG_MAX/2 - 1) so the while-loop condition is always true at the beginning
> > > (msecs_to_jiffies will return >=0 always and with the +1 timeout is >= 1 so
> > > the while condition is always true at the start) and
> > > schedule_timeout_uninterruptible always returns 0, so the while loop always
> > > terminates after the first loop.
> > 
> > Err, no. schedule_timeout_uninterruptible() can return > 0 when there was a
> > non timer wakeup. Thinks spurious wakeups. So we need that loop.
> 
> ok - thanks - was following the comment in schedule_timeout which states:
> /**
>  * schedule_timeout - sleep until timeout
>  * @timeout: timeout value in jiffies
>  *
>  * Make the current task sleep until @timeout jiffies have
>  * elapsed. The routine will return immediately unless
>  * the current task state has been set (see set_current_state()).
>  *
>  * You can set the task state as follows -
>  *
>  * %TASK_UNINTERRUPTIBLE - at least @timeout jiffies are guaranteed to
>  * pass before the routine returns. The routine will return 0
> <snip>
> 
> So I had assumed that would not actualy be possible given this comment.
> Is the while(timeout) loop im msleep() just defensive programming or is 
> there a spurious timer wakeup path that defeats TASK_UNINTERRUPTIBLE ? 
> Probably a stupid question but I was unable to figure out how such an 
> wakeup would occure.

That comment is wrong. Just a simple example:

     wait_for_completion_io_timeout(x, timeout)
       wait_for_common_io(x, timeout, TASK_UNINTERRUPTIBLE)
         __wait_for_common(x, io_schedule_timeout, timeout, state)
	   do_wait_for_common(x, action, timeout, state)
   	     ...
	     io_schedule_timeout(timeout)
		schedule_timeout(timeout);

So the function can return either because the timer fired or the completion
completed. In the latter case the @timeout jiffies certainly have not passed.

> > > Q: what is the purpose of the + 1 offset to the jiffies here ?
> > > 
> > > msleep was introduced in 2.6.7 but without the + 1, so with:
> > > 	unsigned long timeout = msecs_to_jiffies(msecs);
> > > in 2.6.10-rc2 the msecs_to_jiffies(msecs) + 1; is introduced.
> > > Nishanth Aravamudan <nacc@us.ibm.com> (https://lkml.org/lkml/2004/11/19/294)
> > > seems to be the origin while converting msleep to a macro, but no reason
> > > for the + 1 is given there.
> > 
> > Not really. The +1 was introduced with the following commit:
> > 
> > https://git.kernel.org/cgit/linux/kernel/git/tglx/history.git/commit/kernel/timer.c?id=c259ef842622a5e64418d9dab3b62ee051867edf
> >
> 
> thanks - was ignorant of history.git being available.
> will go try and understand where that "lost jiffie" could come from.

Assume HZ=1000 and msleep(1). If the msleep() is issued right at the edge of
the next tick interrupt, then it would return almost immediately. Certainly
not what you would expect, right?

Thanks,

	tglx

<snip>

 So the proposed patch is simply wrong and the replacement of the 
msleep() by schedule_timeout_uninterruptible() is not equivalent.

thx!
hofrat
