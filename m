From: Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH] [SCSI] osst: remove double conversion of timeout
Date: Fri, 8 Jan 2016 07:31:55 +0000
Message-ID: <20160108073155.GA16584@osadl.at>
References: <1452197433-26086-1-git-send-email-hofrat@osadl.org>
 <DDB9C85B850785449757F9914A034FCB445092F8@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <DDB9C85B850785449757F9914A034FCB445092F8@G9W0766.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hpe.com>
Cc: Nicholas Mc Guire <hofrat@osadl.org>, Willem Riede <osst@riede.org>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "osst-users@lists.sourceforge.net" <osst-users@lists.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 08, 2016 at 12:02:18AM +0000, Seymour, Shane M wrote:
> Hi Nicholas,
> 
> > -		msleep(jiffies_to_msecs(initial_delay));
> > +		schedule_timeout_uninterruptible(initial_delay);
>  
> The code to msleep looks like this:
> 
> /**
>  * msleep - sleep safely even with waitqueue interruptions
>  * @msecs: Time in milliseconds to sleep for
>  */
> void msleep(unsigned int msecs)
> {
> 	unsigned long timeout = msecs_to_jiffies(msecs) + 1;
> 
> 	while (timeout)
> 		timeout = schedule_timeout_uninterruptible(timeout);
> }
> 
> So msleep will wait for the requested amount of time to pass even if woken early but your change may not. To make it equivalent you would need to borrow code from msleep and remove the "if (initial_delay > 0)" and just have:

If I understand the documentation to 
schedule_timeout() correctly then this is not the 
case:
<snip>
/**
 * schedule_timeout - sleep until timeout
 * @timeout: timeout value in jiffies
 *
 * Make the current task sleep until @timeout jiffies have
 * elapsed. The routine will return immediately unless
 * the current task state has been set (see set_current_state()).
 *
 * You can set the task state as follows -
 *
 * %TASK_UNINTERRUPTIBLE - at least @timeout jiffies are guaranteed to
 * pass before the routine returns. The routine will return 0
...
<snip>

 and schedule_timeout_uninterruptiple does that

signed long __sched schedule_timeout_uninterruptible(signed long timeout)
{
        __set_current_state(TASK_UNINTERRUPTIBLE);
        return schedule_timeout(timeout);
}

so my understanding is that this will not return early and should thus
be equivalent to the behavior of msleep.

did I overlook something here ?

thx!
hofrat
