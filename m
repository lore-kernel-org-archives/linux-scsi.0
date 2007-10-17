From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 1/7] git-scsi-misc gdth fix
Date: Wed, 17 Oct 2007 08:28:48 -0400
Message-ID: <1192624128.28752.20.camel@localhost.localdomain>
References: <200710162128.l9GLSJV1018164@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:46016 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761494AbXJQM2z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 08:28:55 -0400
In-Reply-To: <200710162128.l9GLSJV1018164@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org, davemilter@gmail.com

On Tue, 2007-10-16 at 14:28 -0700, akpm@linux-foundation.org wrote:
> From: James Bottomley <James.Bottomley@SteelEye.com>
> 
> On Sun, 2007-10-14 at 12:21 -0700, Andrew Morton wrote:
> > On Sun, 14 Oct 2007 22:45:47 +0400 "Dave Milter" <davemilter@gmail.com> wrote:
> >
> > > I build linux-2.6.23-mm1 and try to boot it using qemu,
> > > and it crashed with trace like this:
> > > do_page_fault
> > > error_code
> > > lock_acquire
> > > _spin_lock_irqsave
> > > gdth_timeout
> > > run_timer_softirq
> > > __do_softirq
> > > do_softirq
> > >
> > > I have screenshot, but have no idea, is it legal to include it, if I
> > > sent copy to lkml.
> > > config of kernel in attachment,
> > > I apply all three patches from hot-fixes.
> > >
> >
> > The screenshot is here:  http://userweb.kernel.org/~akpm/crash.png
> >
> > It would appear that gdth_timeout() is passing a bad pointer into
> > spin_lock_irqsave().
> 
> There's a bug in the gdth rework in that the instance can be deleted
> from the list before the actual timer is stopped.  This can be worked
> around I think by the following patch; although we really should be
> stopping the timer from firing when the list goes empty.
> 
> 
> 
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/scsi/gdth.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff -puN drivers/scsi/gdth.c~git-scsi-misc-gdth-fix drivers/scsi/gdth.c
> --- a/drivers/scsi/gdth.c~git-scsi-misc-gdth-fix
> +++ a/drivers/scsi/gdth.c
> @@ -3793,6 +3793,9 @@ static void gdth_timeout(ulong data)
>      gdth_ha_str *ha;
>      ulong flags;
>  
> +    if (list_empty(&gdth_instances))
> +	return;
> +
>      ha = list_first_entry(&gdth_instances, gdth_ha_str, list);
>      spin_lock_irqsave(&ha->smp_lock, flags);
>  

This is almost certainly the wrong fix for real hardware.  Although it
kills the timer when the list goes empty, nothing will ever restart it
when the list fills again.

Boaz, since you touched all of this, you get to fix it.  The correct fix
will be to control the timer along with the actual list instead of at
entry/exit time.  If you're not going to add this empty check to the
timer routine, make sure you use del_timer_sync() before removing the
last element from the list.

James


