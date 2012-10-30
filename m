From: "Zhuang, Jin Can" <jin.can.zhuang@intel.com>
Subject: RE: [PATCH 6/7] Fix race between starved list processing and device
 removal
Date: Tue, 30 Oct 2012 05:40:49 +0000
Message-ID: <267107B7B5D6404FB174AB273F79D8BD1A5BC4@SHSMSX101.ccr.corp.intel.com>
References: <508A7B63.60608@acm.org> <508A7C6D.8070002@acm.org>
 <267107B7B5D6404FB174AB273F79D8BD1A4C39@SHSMSX101.ccr.corp.intel.com>
 <508E936F.7050004@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:10251 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442Ab2J3Fkx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Oct 2012 01:40:53 -0400
In-Reply-To: <508E936F.7050004@acm.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

Hi Bart,

Yes. Here's the warning. 
For the trace below, I used scsi_device_get/scsi_device_put() in scsi_run_queue(). (A little different from your patch). But I think it's the same.

10-23 18:15:53.309     8     8 I KERNEL  : [  268.994556] BUG: sleeping function called from invalid context at linux-2.6/kernel/workqueue.c:2500
10-23 18:15:53.309     8     8 I KERNEL  : [  269.006898] in_atomic(): 0, irqs_disabled(): 1, pid: 8, name: kworker/0:1
10-23 18:15:53.309     8     8 I KERNEL  : [  269.013689] Pid: 8, comm: kworker/0:1 Tainted: G        WC  3.0.34-140359-g85a6d67-dirty #43
10-23 18:15:53.309     8     8 I KERNEL  : [  269.022113] Call Trace:
10-23 18:15:53.309     8     8 I KERNEL  : [  269.024567]  [<c1859ea5>] ? printk+0x1d/0x1f
10-23 18:15:53.309     8     8 I KERNEL  : [  269.028828]  [<c123464a>] __might_sleep+0x10a/0x110
10-23 18:15:53.309     8     8 I KERNEL  : [  269.033695]  [<c12628a3>] wait_on_work+0x23/0x1a0
10-23 18:15:53.309     8     8 I KERNEL  : [  269.038390]  [<c1863ee6>] ? _raw_spin_unlock_irqrestore+0x26/0x50
10-23 18:15:53.309     8     8 I KERNEL  : [  269.044476]  [<c152fd66>] ? __pm_runtime_idle+0x66/0xf0
10-23 18:15:53.309     8     8 I KERNEL  : [  269.049706]  [<c165ae3e>] ? ram_console_write+0x4e/0xa0
10-23 18:15:53.309     8     8 I KERNEL  : [  269.054913]  [<c126472a>] __cancel_work_timer+0x6a/0x110
10-23 18:15:53.309     8     8 I KERNEL  : [  269.060217]  [<c12647ff>] cancel_work_sync+0xf/0x20
10-23 18:15:53.309     8     8 I KERNEL  : [  269.065087]  [<c1548d5d>] scsi_device_dev_release_usercontext+0x6d/0x100
10-23 18:15:53.309     8     8 I KERNEL  : [  269.071785]  [<c12626a2>] execute_in_process_context+0x42/0x50
10-23 18:15:53.309     8     8 I KERNEL  : [  269.077609]  [<c1548cc8>] scsi_device_dev_release+0x18/0x20
10-23 18:15:53.309     8     8 I KERNEL  : [  269.083174]  [<c15234a0>] device_release+0x20/0x80
10-23 18:15:53.309     8     8 I KERNEL  : [  269.087958]  [<c124a21e>] ? vprintk+0x2be/0x4e0
10-23 18:15:53.309     8     8 I KERNEL  : [  269.092479]  [<c148d1b4>] kobject_release+0x84/0x1f0
10-23 18:15:53.309     8     8 I KERNEL  : [  269.097439]  [<c1863d22>] ? _raw_spin_lock_irq+0x22/0x30
10-23 18:15:53.309     8     8 I KERNEL  : [  269.102732]  [<c148d130>] ? kobject_del+0x70/0x70
10-23 18:15:53.309     8     8 I KERNEL  : [  269.107430]  [<c148e8ec>] kref_put+0x2c/0x60
10-23 18:15:53.309     8     8 I KERNEL  : [  269.111688]  [<c148d06d>] kobject_put+0x1d/0x50
10-23 18:15:53.309     8     8 I KERNEL  : [  269.116209]  [<c15232a4>] put_device+0x14/0x20
10-23 18:15:53.309     8     8 I KERNEL  : [  269.120646]  [<c153daa7>] scsi_device_put+0x37/0x60
10-23 18:15:53.309     8     8 I KERNEL  : [  269.125515]  [<c1543cc7>] scsi_run_queue+0x247/0x320
10-23 18:15:53.309     8     8 I KERNEL  : [  269.130470]  [<c1545903>] scsi_requeue_run_queue+0x13/0x20
10-23 18:15:53.309     8     8 I KERNEL  : [  269.135941]  [<c1263efe>] process_one_work+0xfe/0x3f0
10-23 18:15:53.309     8     8 I KERNEL  : [  269.140997]  [<c15458f0>] ? scsi_softirq_done+0x120/0x120
10-23 18:15:53.309     8     8 I KERNEL  : [  269.146384]  [<c12644f1>] worker_thread+0x121/0x2f0
10-23 18:15:53.309     8     8 I KERNEL  : [  269.151254]  [<c12643d0>] ? rescuer_thread+0x1e0/0x1e0
10-23 18:15:53.309     8     8 I KERNEL  : [  269.156383]  [<c1267ffd>] kthread+0x6d/0x80
10-23 18:15:53.309     8     8 I KERNEL  : [  269.160558]  [<c1267f90>] ? __init_kthread_worker+0x30/0x30
10-23 18:15:53.309     8     8 I KERNEL  : [  269.166124]  [<c186a27a>] kernel_thread_helper+0x6/0x10

-Jincan

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Bart Van Assche
Sent: Monday, October 29, 2012 10:32 PM
To: Zhuang, Jin Can
Cc: linux-scsi; James Bottomley; Mike Christie; Jens Axboe; Tejun Heo; Chanho Min
Subject: Re: [PATCH 6/7] Fix race between starved list processing and device removal

On 10/28/12 19:01, Zhuang, Jin Can wrote:
> I recently ran into the same issue
> The test I did is plug/unplug u-disk in an interval of 1 second. And
 > I found when sdev1 is being removed, scsi_run_queue is triggered by  > sdev2, which then accesses all the starving scsi device including sdev1.
>
> I have adopted the solution below which works fine for me so far.
> But there's one thing to fix in the patch below. When it put_device
 > in scsi_run_queue, irq is disabled. As put_device may get into sleep,  > irq should be enabled before it's called.

Hello Jincan,

Thanks for testing and the feedback. However, are you sure that
put_device() for a SCSI device may sleep ? Have you noticed the
execute_in_process_context() call in scsi_device_dev_release() ?

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
