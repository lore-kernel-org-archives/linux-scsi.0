From: Jens Axboe <axboe@suse.de>
Subject: Re: BUG() in 2.4: sg direct IO + exit()
Date: Sun, 28 Mar 2004 14:43:01 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040328124259.GA24370@suse.de>
References: <04Mar23.100431est.332209@cyborg.cybernetics.com> <406185C6.6050705@torque.net> <20040324130208.GQ3377@suse.de> <406559A5.6080301@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:6378 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261704AbUC1MnJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Mar 2004 07:43:09 -0500
Content-Disposition: inline
In-Reply-To: <406559A5.6080301@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: tonyb@cybernetics.com, linux-scsi@vger.kernel.org

On Sat, Mar 27 2004, Douglas Gilbert wrote:
> Jens Axboe wrote:
> >On Wed, Mar 24 2004, Douglas Gilbert wrote:
> >
> >>Tony Battersby wrote:
> >>
> >>>The following BUG() is triggered in 2.4.x when a program calls exit()
> >>>immediately after sending a SCSI command that uses direct IO:
> <snip>
> >>>Call Trace:
> >>>[<c0127cb0>] unmap_kiobuf+0x30/0x50 [kernel]
> >>>[<d0885db6>] sg_unmap_and+0x26/0x50 [sg]
> >>>[<d0885cc9>] sg_finish_rem_req+0x39/0x70 [sg]
> >>>[<d0885451>] sg_cmd_done_bh+0x281/0x380 [sg]
> >>>[<c01ab65a>] scsi_finish_command+0xda/0xe0 [kernel]
> >>>[<c01ab380>] scsi_bottom_half_handler+0xc0/0x230 [kernel]
> >>>[<c011dacb>] bh_action+0x4b/0x90 [kernel]
> <snip>
> 
> >>Tony,
> >>It is not causing an oops when I try with scsi_debug and lk 2.6.5-rc2.
> >>Neither is there a problem with a Suse 9 stock SMP kernel
> >>(2.4.21-99-smp4G) on an old dual celeron (A-bit mb) box with a
> >>Sony SDT-7000 tape drive on /dev/sg0.
> >>
> >>I'll keep looking. The oops suggests that the memory is not being
> >>locked down (as you are probably aware).
> >
> >
> >Looks like an sg bug, you are doing direct io cleanup from interrupt
> >context if the fd has been closed (SCSI -> sg_cmd_done_bh ->
> >sg_finish_rem_req -> sg_unmap_and -> unmap_kiobuf).
> 
> It is my understanding the unmap_kiobuf() can be safely called
> from an interrupt context. If that is not the case then the
> user task needs to be held in the sg_release() until the
> SCSI command finishes or a cleanup kernel thread is needed.
> Neither option seems particularly pretty.

As you can see from the trace I outlined above, it's clearly not the
case. I think it would be fine (and the logical thing to do) to block in
->release() until pending commands have completed.

> kiobufs are gone in lk 2.6 in which both the sg and st
> drivers call page_cache_release() in the same context.

Hmm, I'm not so sure it's legal to call set_page_dirty() from interrupt
context. Ah you are using SetPageDirty() which isn't as optimal, but I
think it should be ok from interrupt context. I still think it's a lot
cleaner (and better, move it out of interrupt context) to cleanup in the
context of the process issuing the io.

-- 
Jens Axboe

