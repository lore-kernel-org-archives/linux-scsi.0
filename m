From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: Re: [REEEEPOST] bnx2i + bnx2fc: convert to generic workqueue (#3)
Date: Fri, 12 May 2017 11:55:52 -0400 (EDT)
Message-ID: <alpine.OSX.2.00.1705121149580.1329@n6024mn55p0yw1.qlogic.org>
References: <20170410171254.30367-1-bigeasy@linutronix.de>  <20170504174427.6hebbnqwfgems6dg@linutronix.de>  <yq1inlass3y.fsf@oracle.com>  <alpine.OSX.2.00.1705091015070.1067@administrators-MacBook-Pro.local> <1494343100.2688.34.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0066.outbound.protection.outlook.com ([104.47.42.66]:9370
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756893AbdELP4Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 12 May 2017 11:56:24 -0400
In-Reply-To: <1494343100.2688.34.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, linux-scsi@vger.kernel.org, Chris Leech <cleech@redhat.com>, Chad Dupuis <chad.dupuis@qlogic.com>, rt@linutronix.de, Lee Duncan <lduncan@suse.com>, QLogic-Storage-Upstream@qlogic.com, Andrew Morton <akpm@linux-foundation.org>, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>


On Tue, 9 May 2017, 11:18am, James Bottomley wrote:

> On Tue, 2017-05-09 at 10:17 -0400, Chad Dupuis wrote:
> > On Mon, 8 May 2017, 10:04pm, Martin K. Petersen wrote:
> > 
> > > 
> > > Sebastian,
> > > 
> > > > Martin, do you see any chance to get this merged? Chad replied to
> > the
> > > > list that he is going to test it on 2017-04-10, didn't respond to
> > the
> > > > ping 10 days later. The series stalled last time in the same way.
> > > 
> > > I am very reluctant to merge something when a driver has an active
> > > maintainer and that person has not acked the change.
> > > 
> > > That said, Chad: You have been sitting on this for quite a while.
> > Please
> > > make it a priority. In exchange for veto rights you do have to
> > provide
> > > timely feedback on anything that touches your driver.
> > > 
> > > Thanks!
> > > 
> > 
> > We did do some testing and hit a calltrace during device discovery:
> > 
> > [ 1332.551799] INFO: task scsi_eh_15:1970 blocked for more than 120 
> > seconds.
> > [ 1332.551804] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > disables 
> > this message.
> > [ 1332.551807] scsi_eh_15      D ffff880823488c14     0  1970      2 
> > 0x00000080
> > [ 1332.551813]  ffff881053a17cb0 0000000000000046 ffff88084d693ec0 
> > ffff881053a17fd8
> > [ 1332.551817]  ffff881053a17fd8 ffff881053a17fd8 ffff88084d693ec0 
> > ffff880823488d48
> > [ 1332.551821]  ffff880823488d50 7fffffffffffffff ffff88084d693ec0 
> > ffff880823488c14
> > [ 1332.551825] Call Trace:
> > [ 1332.551838]  [<ffffffff8168b579>] schedule+0x29/0x70
> > [ 1332.551844]  [<ffffffff81688fc9>] schedule_timeout+0x239/0x2d0
> > [ 1332.551850]  [<ffffffff810882f8>] ? console_unlock+0x208/0x400
> > [ 1332.551855]  [<ffffffff810888b4>] ? vprintk_emit+0x3c4/0x510
> > [ 1332.551861]  [<ffffffff81096acb>] ?
> > lock_timer_base.isra.33+0x2b/0x50
> > [ 1332.551866]  [<ffffffff8168b956>] wait_for_completion+0x116/0x170
> > [ 1332.551874]  [<ffffffff810c4ec0>] ? wake_up_state+0x20/0x20
> > [ 1332.551885]  [<ffffffffa06ae234>] bnx2fc_abts_cleanup+0x3d/0x62 
> > [bnx2fc]
> > [ 1332.551892]  [<ffffffffa06a5a80>] bnx2fc_eh_abort+0x470/0x580
> > [bnx2fc]
> > [ 1332.551900]  [<ffffffff814570af>] scsi_error_handler+0x59f/0x8b0
> > [ 1332.551904]  [<ffffffff81456b10>] ? scsi_eh_get_sense+0x250/0x250
> > [ 1332.551911]  [<ffffffff810b052f>] kthread+0xcf/0xe0
> > [ 1332.551916]  [<ffffffff810b0460>] ?
> > kthread_create_on_node+0x140/0x140
> > [ 1332.551923]  [<ffffffff81696418>] ret_from_fork+0x58/0x90
> > [ 1332.551928]  [<ffffffff810b0460>] ?
> > kthread_create_on_node+0x140/0x140 
> 
> Reporting this when you found it would have been helpful ...
> 
> That said, it does look like a genuine hang in the workqueues, so it
> rather invalidates the current patch set.
> 
> > To be honest, I'm reluctant to merge these patches on bnx2fc as the
> > I/O path on this driver has been stable for quite some time and given
> > that it's an older driver I'm not looking to make changes there.
> 
> OK, so find a way to achieve both sets of goals because there's a limit
> to how long we allow "stable" drivers to hold up infrastructure changes
> within the kernel.  The main goal of the current patch set is to remove
> the cpu hotplug calls from the drivers because they want to remove them
> from the kernel.  This is rather complex because you're using per cpu
> work queues so you currently have to manage starting and stopping them
> as the CPUs come up or go down ... getting rid of that for standard
> kernel infrastructure will make the driver easier to keep in
> maintenance mode for longer.
> 
> James
> 

Ok, I believe I've found the issue here.  The machine that the test has 
performed on had many more possible CPUs than active CPUs.  We calculate 
which CPU to the work time on in bnx2fc_process_new_cqes() like this:

unsigned int cpu = wqe % num_possible_cpus();

Since not all CPUs are active, we were trying to schedule work on 
non-active CPUs which meant that the upper layers were never notified of 
the completion.  With this change:

diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c 
b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index c2288d6..6f08e43 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -1042,7 +1042,12 @@ static int bnx2fc_process_new_cqes(struct 
bnx2fc_rport *tgt)
                        /* Pending work request completion */
                        struct bnx2fc_work *work = NULL;
                        struct bnx2fc_percpu_s *fps = NULL;
-                       unsigned int cpu = wqe % num_possible_cpus();
+                       unsigned int cpu = wqe % num_active_cpus();
+
+                       /* Sanity check cpu to make sure it's online */
+                       if (!cpu_active(cpu))
+                               /* Default to CPU 0 */
+                               cpu = 0;
 
                        work = bnx2fc_alloc_work(tgt, wqe);
                        if (work) {

The issue is fixed.

Sebastian, can you add this change to your patch set?
