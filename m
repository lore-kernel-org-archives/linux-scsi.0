From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH 02/28] be2iscsi: Replace _bh with _irqsave/irqrestore
Date: Fri, 5 Aug 2016 13:38:44 -0500
Message-ID: <57A4DD34.4080000@redhat.com>
References: <1469092085-14311-1-git-send-email-jitendra.bhivare@broadcom.com>
 <1469092085-14311-3-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937329AbcHESiq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Aug 2016 14:38:46 -0400
In-Reply-To: <1469092085-14311-3-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>, linux-scsi@vger.kernel.org

On 07/21/2016 04:07 AM, Jitendra Bhivare wrote:
> Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 21
> Pid: 13242, comm: flush-8:80 Tainted: G        W  -- ------------
> 2.6.32-573.el6.x86_64 #1
> Call Trace:
> <NMI>  [<ffffffff81537a84>] ? panic+0xa7/0x16f
> [<ffffffff810149c9>] ? sched_clock+0x9/0x10
> [<ffffffff810ed4bd>] ? watchdog_overflow_callback+0xcd/0xd0
> [<ffffffff81124037>] ? __perf_event_overflow+0xa7/0x240
> [<ffffffff8101dc54>] ? x86_perf_event_set_period+0xf4/0x180
> [<ffffffff81124684>] ? perf_event_overflow+0x14/0x20
> [<ffffffff81024a02>] ? intel_pmu_handle_irq+0x202/0x3f0
> [<ffffffff8153cd89>] ? perf_event_nmi_handler+0x39/0xb0
> [<ffffffff8153e845>] ? notifier_call_chain+0x55/0x80
> [<ffffffff81389ba0>] ? scsi_done+0x0/0x60
> [<ffffffff8153e8aa>] ? atomic_notifier_call_chain+0x1a/0x20
> [<ffffffff810a788e>] ? notify_die+0x2e/0x30
> [<ffffffff8153c503>] ? do_nmi+0x1c3/0x350
> [<ffffffff8153bdc0>] ? nmi+0x20/0x30
> [<ffffffff81389ba0>] ? scsi_done+0x0/0x60
> [<ffffffff81389ba0>] ? scsi_done+0x0/0x60
> [<ffffffff8153b62e>] ? _spin_lock+0x1e/0x30
> <<EOE>>  [<ffffffffa00e2eaf>] ? iscsi_queuecommand+0x7f/0x4e0 [libiscsi]
> [<ffffffff81389df5>] ? scsi_dispatch_cmd+0xe5/0x310
> [<ffffffff813927be>] ? scsi_request_fn+0x5be/0x750
> [<ffffffff81089bad>] ? del_timer+0x7d/0xe0
> [<ffffffff81273542>] ? __generic_unplug_device+0x32/0x40
> [<ffffffff8126e823>] ? elv_insert+0xd3/0x190
> [<ffffffff8126e920>] ? __elv_add_request+0x40/0x90
> 
> In beiscsi_alloc_pdu, _bh versions of spin_lock are being used for
> protecting SGLs and WRBs. _bh versions are needed as the function gets
> invoked in process context and BLOCK_IOPOLL softirq.
> 
> In spin_unlock_bh, after releasing the lock and enabling BH, do_softirq
> is called which executes till last SOFTIRQ.
> 
> beiscsi_alloc_pdu is called under session lock. Through block layer,
> iSCSI stack in some cases send IOs with interrupts disabled. In such paths,


What path is this? Is this with mq enabled or disabled?
