From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [patch for 2.6.29? 2/2] scsi: mpt: suppress debugobjects warning
Date: Tue, 21 Apr 2009 16:08:45 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1410F4D5B1@inbmail01.lsi.com>
References: <200903042012.n24KCIKH030001@imap1.linux-foundation.org>
 <20090420145511.35b9c201.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3mo2-old.postini.com ([64.18.14.205]:50849 "EHLO
	chip3mo2-old.postini.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbZDUKkB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2009 06:40:01 -0400
In-Reply-To: <20090420145511.35b9c201.akpm@linux-foundation.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

It is a clean patch. There is not harm to ack it, but since I have already submitted code changes to upstream which have replaced "kernel timer" by "completion queue.", I will suggest to wait for next driver version.

Init_timer() function will not be called from MPT fusion driver in next version

Next available upstream version will not have this slowpath warning.

- Kashyap

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Andrew Morton
Sent: Tuesday, April 21, 2009 3:25 AM
To: James.Bottomley@HansenPartnership.com; linux-scsi@vger.kernel.org; eparis@parisplace.org; Moore, Eric; tglx@linutronix.de
Subject: Re: [patch for 2.6.29? 2/2] scsi: mpt: suppress debugobjects warning

On Wed, 04 Mar 2009 12:12:18 -0800
akpm@linux-foundation.org wrote:

> From: "Eric Paris" <eparis@parisplace.org>
> 
> ODEBUG: object is on stack, but not annotated
> ------------[ cut here ]------------
> WARNING: at lib/debugobjects.c:253 __debug_object_init+0x1f3/0x276()
> Hardware name: VMware Virtual Platform
> Modules linked in: mptspi(+) mptscsih mptbase scsi_transport_spi ext3 jbd mbcache
> Pid: 540, comm: insmod Not tainted 2.6.28-mm1 #2
> Call Trace:
>  [<c042c51c>] warn_slowpath+0x74/0x8a
>  [<c0469600>] ? start_critical_timing+0x96/0xb7
>  [<c060c8ea>] ? _spin_unlock_irqrestore+0x2f/0x3c
>  [<c0446fad>] ? trace_hardirqs_off_caller+0x18/0xaf
>  [<c044704f>] ? trace_hardirqs_off+0xb/0xd
>  [<c060c8ea>] ? _spin_unlock_irqrestore+0x2f/0x3c
>  [<c042cb84>] ? release_console_sem+0x1a5/0x1ad
>  [<c05013e6>] __debug_object_init+0x1f3/0x276
>  [<c0501494>] debug_object_init+0x13/0x17
>  [<c0433c56>] init_timer+0x10/0x1a
>  [<e08e5b54>] mpt_config+0x1c1/0x2b7 [mptbase]
>  [<e08e3b82>] ? kmalloc+0x8/0xa [mptbase]
>  [<e08e3b82>] ? kmalloc+0x8/0xa [mptbase]
>  [<e08e6fa2>] mpt_do_ioc_recovery+0x950/0x1212 [mptbase]
>  [<c04496c2>] ? __lock_acquire+0xa69/0xacc
>  [<c060c8f1>] ? _spin_unlock_irqrestore+0x36/0x3c
>  [<c060c3af>] ? _spin_unlock_irq+0x22/0x26
>  [<c04f2d8b>] ? string+0x2b/0x76
>  [<c04f310e>] ? vsnprintf+0x338/0x7b3
>  [<c04496c2>] ? __lock_acquire+0xa69/0xacc
>  [<c060c8ea>] ? _spin_unlock_irqrestore+0x2f/0x3c
>  [<c04496c2>] ? __lock_acquire+0xa69/0xacc
>  [<c044897d>] ? debug_check_no_locks_freed+0xeb/0x105
>  [<c060c8f1>] ? _spin_unlock_irqrestore+0x36/0x3c
>  [<c04488bc>] ? debug_check_no_locks_freed+0x2a/0x105
>  [<c0446b8c>] ? lock_release_holdtime+0x43/0x48
>  [<c043f742>] ? up_read+0x16/0x29
>  [<c05076f8>] ? pci_get_slot+0x66/0x72
>  [<e08e89ca>] mpt_attach+0x881/0x9b1 [mptbase]
>  [<e091c8e5>] mptspi_probe+0x11/0x354 [mptspi]
> 
> Noticing that every caller of mpt_config has its CONFIGPARMS struct
> declared on the stack and thus the &pCfg->timer is always on the stack I
> changed init_timer() to init_timer_on_stack() and it seems to have shut
> up.....
> 
> Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/message/fusion/mptbase.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN drivers/message/fusion/mptbase.c~scsi-mpt-suppress-debugobjects-warning drivers/message/fusion/mptbase.c
> --- a/drivers/message/fusion/mptbase.c~scsi-mpt-suppress-debugobjects-warning
> +++ a/drivers/message/fusion/mptbase.c
> @@ -5934,7 +5934,7 @@ mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS
>  
>  	/* Initalize the timer
>  	 */
> -	init_timer(&pCfg->timer);
> +	init_timer_on_stack(&pCfg->timer);
>  	pCfg->timer.data = (unsigned long) ioc;
>  	pCfg->timer.function = mpt_timer_expired;
>  	pCfg->wait_done = 0;

I sent this twice, both times marked "for 2.6.29".  Both times it was
ignored and now people (including myself) are spending time re-solving
and already-solved problem (eg:
http://bugzilla.kernel.org/show_bug.cgi?id=13133).

I'll merge this patch, tagged for a 2.6.29.x backport.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
