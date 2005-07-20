From: Nish Aravamudan <nish.aravamudan@gmail.com>
Subject: Re: [PATCH 22/82] remove linux/version.h from drivers/message/fus ion
Date: Wed, 20 Jul 2005 10:55:02 -0700
Message-ID: <29495f1d05072010551c875a4a@mail.gmail.com>
References: <91888D455306F94EBD4D168954A9457C03281EB4@nacos172.co.lsil.com>
Reply-To: Nish Aravamudan <nish.aravamudan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.203]:32983 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261454AbVGTRzb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jul 2005 13:55:31 -0400
Received: by zproxy.gmail.com with SMTP id 40so1470509nzk
        for <linux-scsi@vger.kernel.org>; Wed, 20 Jul 2005 10:55:28 -0700 (PDT)
In-Reply-To: <91888D455306F94EBD4D168954A9457C03281EB4@nacos172.co.lsil.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>, Olaf Hering <olh@suse.de>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On 7/19/05, Moore, Eric Dean <Eric.Moore@lsil.com> wrote:
> On Tuesday, July 12, 2005 8:17 PM, Matt Domsch wrote:
> > In general, this construct:
> >
> > > > -#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,6))
> > > > -static int inline scsi_device_online(struct scsi_device *sdev)
> > > > -{
> > > > - return sdev->online;
> > > > -}
> > > > -#endif
> >
> > is better tested as:
> >
> > #ifndef scsi_device_inline
> > static int inline scsi_device_online(struct scsi_device *sdev)
> > {
> >     return sdev->online;
> > }
> > #endif
> >
> > when you can.  It cleanly eliminates the version test, and tests for
> > exactly what you're looking for - is this function defined.
> >
> 
> What you illustrated above is not going to work.
> If your doing #ifndef around a function, such as scsi_device_online, it's
> not going to compile
> when scsi_device_online is already implemented in the kernel tree.
> The routine scsi_device_online is a function, not a define.  For a define
> this would work.
> 
> I'm trying your example around msleep, msleep_interruptible, and
> msecs_to_jiffies, and
> my code simply won't compile in SLES9 SP2(-191).  In SLES9 SP1(-139), these
> three routines were not implemented and
> your suggestion works.  I won't be able to to a linux version check as this
> change occurred between service packs
> of the 2.6.5 kernel suse tree.   Anybody on the linux forums have any ideas?
> 
> Example:
> 
> #ifdef msleep
> static void inline msleep(unsigned long msecs)
> {
>         set_current_state(TASK_UNINTERRUPTIBLE);
>         schedule_timeout(msecs_to_jiffies(msecs) + 1);
> }
> #endif

Just an FYI, if you are trying to emulate the actual behavior of
msleep() in the current kernel via this function, then you need to
place the sleep in a while-loop. Please see kernel/timer.c::msleep().
Your version will wake up on wait-queue events, while msleep() in the
current kernel does not.

Thanks,
Nish
