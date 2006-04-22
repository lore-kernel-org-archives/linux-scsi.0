From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: qla2xxx lock ordering question
Date: Sat, 22 Apr 2006 17:34:40 +0200
Message-ID: <1145720080.2882.11.camel@laptopd505.fenrus.org>
References: <1145438524.3085.19.camel@laptopd505.fenrus.org>
	 <20060420234606.GO8514@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus1.kernel.org ([204.152.191.4]:40626 "EHLO zeus1.kernel.org")
	by vger.kernel.org with ESMTP id S1750909AbWDVSwo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Apr 2006 14:52:44 -0400
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by zeus1.kernel.org (8.13.1/8.13.1) with ESMTP id k3MFbtIL024401
	for <linux-scsi@vger.kernel.org>; Sat, 22 Apr 2006 15:37:56 GMT
In-Reply-To: <20060420234606.GO8514@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: mingo@elte.hu, linux-scsi@vger.kernel.org

On Thu, 2006-04-20 at 16:46 -0700, Andrew Vasquez wrote:
> On Wed, 19 Apr 2006, Arjan van de Ven wrote:
> 
> > a question about qla2xxx lock ordering since it trips up with Ingo's
> > lock depenceny tool:
> > 
> > in qla2x00_mailbox_command() the code first grabs the mbx_reg_lock lock,
> > then the hardware_lock. So far so good. But then...
> > it drops the mbx_reg_lock, does stuff, and regrabs the mbx_reg_lock
> > lock, while keeping the hardware_lock held!
> > 
> > This appears to be an AB-BA deadlock risk since for the second part you
> > are taking the locks in the wrong order... or am I missing something
> > here?
> 
> Actually the code is a bit convoluted, but I believe we are OK.  There
> are two scenarios we need to consider:

the full output of the tool is shown below.
As a summary, the instrumentation keeps track of all locks you hold at a
certain time, and keeps track of "lock A is taken with lock B helt", and
then verifies ordering. (there are a whole lot of smart things going on
and a lot more tests, but only this one is relevant here). The trace
below says that initially a code sequence was seen which did
hardware_lock -> mbx_reg_lock, and that now a mbx_reg_lock->hwlock
sequence is seen; which is then conflicting....

qla2200 0000:01:06.0: Verifying loaded RISC code...

============================================
[ BUG: circular locking deadlock detected! ]
--------------------------------------------
modprobe/657 is trying to acquire lock:
 (&ha->hardware_lock){..}, at: [<ffffffff880ab619>] qla2x00_mailbox_command+0x87/0x4de [qla2xxx]

but task is already holding lock:
 (&ha->mbx_reg_lock){..}, at: [<ffffffff880aba44>] qla2x00_mailbox_command+0x4b2/0x4de [qla2xxx]

which lock already depends on the new lock,
which could lead to circular deadlocks!

the existing dependency chain (in reverse order) is:
-> #1 (&ha->mbx_reg_lock){..}: [<ffffffff880aba44>] qla2x00_mailbox_command+0x4b2/0x4de [qla2xxx]
-> #0 (&ha->hardware_lock){..}: [<ffffffff880ab619>] qla2x00_mailbox_command+0x87/0x4de [qla2xxx]

other info that might help us debug this:

1 locks held by modprobe/657:
 #0:  (&ha->mbx_reg_lock){..}, at: [<ffffffff880aba44>] qla2x00_mailbox_command+0x4b2/0x4de [qla2xxx]

stack backtrace:

Call Trace:
 [<ffffffff802a26f9>] print_circular_bug_tail+0x52/0x59
 [<ffffffff802a3223>] __lockdep_lock_chain+0x6a2/0x7ec
 [<ffffffff880ab619>] :qla2xxx:qla2x00_mailbox_command+0x87/0x4de
 [<ffffffff880ab619>] :qla2xxx:qla2x00_mailbox_command+0x87/0x4de
 [<ffffffff802a33a3>] lockdep_lock_chain+0x36/0x4f
 [<ffffffff8026ab61>] _spin_lock_irqsave+0x24/0x34
 [<ffffffff880ab619>] :qla2xxx:qla2x00_mailbox_command+0x87/0x4de
 [<ffffffff880aa974>] :qla2xxx:qla2x00_chip_diag+0x25/0x2fc
 [<ffffffff880ac4ac>] :qla2xxx:qla2x00_mbx_reg_test+0x5a/0xa3
 [<ffffffff802a28cc>] trace_hardirqs_on+0x11d/0x129
 [<ffffffff880aabdf>] :qla2xxx:qla2x00_chip_diag+0x290/0x2fc
 [<ffffffff880a9bff>] :qla2xxx:qla2x00_initialize_adapter+0x147/0x263
 [<ffffffff880a641c>] :qla2xxx:qla2x00_probe_one+0xf05/0x1345
 [<ffffffff880c602a>] :qla2200:qla2200_probe_one+0xd/0xf
 [<ffffffff8033b268>] pci_device_probe+0xe8/0x14f
 [<ffffffff803986ba>] driver_probe_device+0x5c/0xb1
 [<ffffffff80398824>] __driver_attach+0x89/0xdb
 [<ffffffff8039879b>] __driver_attach+0x0/0xdb
 [<ffffffff8039805a>] bus_for_each_dev+0x49/0x7a
 [<ffffffff803985de>] driver_attach+0x1c/0x1e
 [<ffffffff80397c88>] bus_add_driver+0x8c/0x13b
 [<ffffffff80398acb>] driver_register+0x88/0x8c
 [<ffffffff8033b46e>] __pci_register_driver+0x63/0x86
 [<ffffffff880dd017>] :qla2200:qla2200_init+0x17/0x19
 [<ffffffff802a5fd0>] sys_init_module+0xb0/0x1b4
 [<ffffffff8026328e>] system_call+0x7e/0x83


