From: James.Smart@Emulex.Com
Subject: RE: 2.6.15-rc4 error messages with multiple qla2300 hba ports on fabric
Date: Fri, 2 Dec 2005 11:47:53 -0500
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7B8D@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:49305 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750809AbVLBQ4b convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Dec 2005 11:56:31 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com, mdr@sgi.com, linux-scsi@vger.kernel.org, hch@lst.de

We recently saw this as well. It's related to the number of targets
that go away simultaneously.

There ends up being many delete rport items on the work queue, and 
when the 1st one stalls to flush the work queues, it starts the 2nd,
which stops to flush, and so on.

My inclination is to look at what we have on the work queue and see if we can
circumvent some of the flush calls.

-- james s

Here's a backtrace:
rport-4:0-37: blocked FC remote port time out: removing target and saving binding
rport-4:0-42: blocked FC remote port time out: removing target and saving binding
rport-4:0-55: blocked FC remote port time out: removing target and saving binding
run_workqueue: recursion depth exceeded: 4
Call Trace:<ffffffff80146270>{flush_cpu_workqueue+96} <ffffffff8036a9b0>{_spin_lock_irqsave+32}
<ffffffff80146473>{flush_workqueue+115} <ffffffff880a05b5>{:scsi_transport_fc:fc_rport_tgt_remove+85}
<ffffffff801462e0>{flush_cpu_workqueue+208} <ffffffff880a0fc0>{:scsi_transport_fc:fc_timeout_deleted_rport+0}
<ffffffff8036a9b0>{_spin_lock_irqsave+32} <ffffffff80146473>{flush_workqueue+115}
<ffffffff880a05b5>{:scsi_transport_fc:fc_rport_tgt_remove+85}
<ffffffff801462e0>{flush_cpu_workqueue+208} <ffffffff880a0fc0>{:scsi_transport_fc:fc_timeout_deleted_rport+0}
<ffffffff880a0fc0>{:scsi_transport_fc:fc_timeout_deleted_rport+0}
<ffffffff8036a9b0>{_spin_lock_irqsave+32} <ffffffff880a0fc0>{:scsi_transport_fc:fc_timeout_deleted_rport+0}
<ffffffff80146473>{flush_workqueue+115} <ffffffff880a05b5>{:scsi_transport_fc:fc_rport_tgt_remove+85}
<ffffffff8014617c>{worker_thread+508} <ffffffff8012f0e0>{default_wake_function+0}
<ffffffff8012f0e0>{default_wake_function+0} <ffffffff80145f80>{worker_thread+0}
<ffffffff8014a9c9>{kthread+217} <ffffffff8010edbe>{child_rip+8}
<ffffffff8014a8f0>{kthread+0} <ffffffff8010edb6>{child_rip+0}
rport-4:0-53: blocked FC remote port time out: removing target and
saving binding
run_workqueue: recursion depth exceeded: 5
Call Trace:<ffffffff80146270>{flush_cpu_workqueue+96} <ffffffff8036a9b0>{_spin_lock_irqsave+32}
<ffffffff80146473>{flush_workqueue+115} <ffffffff880a05b5>{:scsi_transport_fc:fc_rport_tgt_remove+85}
<ffffffff801462e0>{flush_cpu_workqueue+208} <ffffffff880a0fc0>{:scsi_transport_fc:fc_timeout_deleted_rport+0}
<ffffffff8036a9b0>{_spin_lock_irqsave+32} <ffffffff80146473>{flush_workqueue+115}
<ffffffff880a05b5>{:scsi_transport_fc:fc_rport_tgt_remove+85}
<ffffffff801462e0>{flush_cpu_workqueue+208} <ffffffff880a0fc0>{:scsi_transport_fc:fc_timeout_deleted_rport+0}
<ffffffff8036a9b0>{_spin_lock_irqsave+32} <ffffffff80146473>{flush_workqueue+115}
<ffffffff880a05b5>{:scsi_transport_fc:fc_rport_tgt_remove+85}
<ffffffff801462e0>{flush_cpu_workqueue+208} <ffffffff880a0fc0>{:scsi_transport_fc:fc_timeout_deleted_rport+0}
<ffffffff880a0fc0>{:scsi_transport_fc:fc_timeout_deleted_rport+0}
<ffffffff8036a9b0>{_spin_lock_irqsave+32} <ffffffff880a0fc0>{:scsi_transport_fc:fc_timeout_deleted_rport+0}
<ffffffff80146473>{flush_workqueue+115} <ffffffff880a05b5>{:scsi_transport_fc:fc_rport_tgt_remove+85}
<ffffffff8014617c>{worker_thread+508} <ffffffff8012f0e0>{default_wake_function+0}
<ffffffff8012f0e0>{default_wake_function+0} <ffffffff80145f80>{worker_thread+0}
<ffffffff8014a9c9>{kthread+217} <ffffffff8010edbe>{child_rip+8}
<ffffffff8014a8f0>{kthread+0} <ffffffff8010edb6>{child_rip+0}
...
<ffffffff8014a9c9>{kthread+217} <ffffffff8010edbe>{child_rip+8}
<ffffffff8014a8f0>{kthread+0} <ffffffff8010edb6>{child_rip+0}
rport-4:0-38: blocked FC remote port time out: removing target and saving binding
run_workqueue: recursion depth exceeded: 30


-----Original Message-----
From: Andrew Vasquez [mailto:andrew.vasquez@qlogic.com]
Sent: Friday, December 02, 2005 11:29 AM
To: Michael Reed; linux-scsi@vger.kernel.org; Smart, James; Christoph Hellwig
Subject: RE: 2.6.15-rc4 error messages with multiple qla2300 hba ports on fabric




> From: Michael Reed [mailto:mdr@sgi.com]
>

Sidenote:  I'm on the east-coast until hopefully tonight -- won't
have a chance to look at debugging this for a couple of days...

> I've been testing with the qla2300 driver with 2.6.14.3 and 2.6.15-rc4.
> I've observed two sets of error messages which are not present with
> 2.6.14.3.
>
> First, the qla2300 driver is generating soft lockups.

Have a backtrace?

> Second, several error messages indicating that remote
> ports are being deleted are being emitted.
>
>  rport-2:0-16: blocked FC remote port time out: removing target and saving binding
>  run_workqueue: recursion depth exceeded: 29
>
> If the timing is just right, scsi errors are generated, though not evident
> in the attached dmesg file.
>
> I've observed similar behavior with my modified mpt fusion driver
> when multiple hba ports are on the fabric.  The kernels tested
> are as downloaded from kernel.org, without my mpt mods.
>
> (Andrew, I'm not "blaming" your driver for the rport issues.  I chose
> your driver to be the "victim" 'cause I didn't want to post this using
> under development code with mpt fusion.)
>
> Platform: SGI Altix IA64.
>
> What additional information should I acquire?
