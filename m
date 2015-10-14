From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/3] SCSI: Fix hard lockup in scsi_remove_target()
Date: Wed, 14 Oct 2015 07:30:36 -0700
Message-ID: <1444833036.2220.38.camel@HansenPartnership.com>
References: <cover.1444829611.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47850 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753617AbbJNOai (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Oct 2015 10:30:38 -0400
In-Reply-To: <cover.1444829611.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 2015-10-14 at 15:50 +0200, Johannes Thumshirn wrote:
> Removing a SCSI target via scsi_remove_target() suspected to be racy. When a
> sibling get's removed from the list it can occassionly happen that one CPU is
> stuck endlessly looping around this code block
> 
> list_for_each_entry(starget, &shost->__targets, siblings) {
>         if (starget->state == STARGET_DEL)
>                 continue;

How long is the __targets list?  It seems a bit unlikely that this is
the exact cause, because for a short list all in STARGET_DEL that loop
should exit very quickly.  Where in the code does scsi_remove_target
+0x68/0x240 actually point to?

Is it not a bit more likely that we're following a removed list element?
Since that points back to itself, the list_for_each_entry() would then
circulate forever.  If that's the case the simple fix would be to use
the safe version of the list traversal macro.

James


> Resulting in the following hard lockup.
> 
> Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 0
> [...]
> Call Trace:
>  [<ffffffff8100471d>] dump_trace+0x7d/0x2d0
>  [<ffffffff81004a04>] show_stack_log_lvl+0x94/0x170
>  [<ffffffff81005cc1>] show_stack+0x21/0x50
>  [<ffffffff8151aa75>] dump_stack+0x41/0x51
>  [<ffffffff8151545a>] panic+0xc8/0x1d7
>  [<ffffffff810fbdda>] watchdog_overflow_callback+0xba/0xc0
>  [<ffffffff811336c8>] __perf_event_overflow+0x88/0x240
>  [<ffffffff8101e3aa>] intel_pmu_handle_irq+0x1fa/0x3e0
>  [<ffffffff81522836>] perf_event_nmi_handler+0x26/0x40
>  [<ffffffff81521fcd>] nmi_handle.isra.2+0x8d/0x180
>  [<ffffffff815221e6>] do_nmi+0x126/0x3c0
>  [<ffffffff8152159b>] end_repeat_nmi+0x1a/0x1e
>  [<ffffffffa00212e8>] scsi_remove_target+0x68/0x240 [scsi_mod]
>  [<ffffffff81072742>] process_one_work+0x172/0x420
>  [<ffffffff810733ba>] worker_thread+0x11a/0x3c0
>  [<ffffffff81079d34>] kthread+0xb4/0xc0
>  [<ffffffff81528cd8>] ret_from_fork+0x58/0x90
> 
> This series attacks the issue by 1) decoupling the __targets and __devices
> lists of struct Scsi_Host from the host_lock spinlock by introducing spinlocks
> for each list and 2) de-coupling the list traversals needed for detecting
> targets/devices to be removed from the actual removal by moving list entries to
> be deleted to a second list and perform the deletion there.
> 
> 
> The whole series survived a nearly 48h test loop of:
> while [ $not_done  ]; do
> 	umount $mountpoint;
> 	rmmod $module;
> 	modprobe $module;
> 	mount $mountpoint;
> done
> 
> This is a follow up of the patch proposed here:
> http://marc.info/?l=linux-scsi&m=144377409311774&w=2
> incorporating Christoph's comment
> 
> Johannes Thumshirn (3):
>   SCSI: Introduce device_lock and target_lock in Scsi_Host
>   SCSI: Rework list handling in scsi_target_remove
>   SCSI: Rework list handling in __scsi_target_remove
> 
>  drivers/scsi/53c700.c     |  3 +++
>  drivers/scsi/hosts.c      |  2 ++
>  drivers/scsi/scsi.c       |  8 ++++----
>  drivers/scsi/scsi_scan.c  | 10 +++++-----
>  drivers/scsi/scsi_sysfs.c | 43 +++++++++++++++++++++----------------------
>  include/scsi/scsi_host.h  |  2 ++
>  6 files changed, 37 insertions(+), 31 deletions(-)
> 



