From: Russell King <rmk@arm.linux.org.uk>
Subject: Re: SCSI woes (followup)
Date: Wed, 25 Sep 2002 00:04:55 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020925000455.B9952@flint.arm.linux.org.uk>
References: <rmk@arm.linux.org.uk> <200209241346.g8ODkER09516@localhost.localdomain> <20020924145852.A28042@flint.arm.linux.org.uk> <20020924111847.A4151@eng2.beaverton.ibm.com> <20020924123250.A5890@eng2.beaverton.ibm.com> <20020924210042.C4409@flint.arm.linux.org.uk> <20020924152319.A12439@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from flint.arm.linux.org.uk ([3ffe:8260:2002:1:201:2ff:fe14:8fad])
	by caramon.arm.linux.org.uk with asmtp (TLSv1:DES-CBC3-SHA:168)
	(Exim 4.04)
	id 17tyjg-0000xx-00
	for linux-scsi@vger.kernel.org; Wed, 25 Sep 2002 00:04:56 +0100
Received: from rmk by flint.arm.linux.org.uk with local (Exim 4.04)
	id 17tyjf-0002sw-00
	for linux-scsi@vger.kernel.org; Wed, 25 Sep 2002 00:04:55 +0100
Content-Disposition: inline
In-Reply-To: <20020924152319.A12439@eng2.beaverton.ibm.com>; from patmans@us.ibm.com on Tue, Sep 24, 2002 at 03:23:19PM -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Tue, Sep 24, 2002 at 03:23:19PM -0700, Patrick Mansfield wrote:
> Have you seen Mike Anderon's 2.5 cleanup patch?
> 
> Patch:
> 
> http://www-124.ibm.com/storageio/gen-io/patch-scsi_error-2.5.34-1.gz
> 
> Posting:
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=103187417110244&w=2
> 
> I've been focusing on 2.5.x scsi (i.e. scsi multi-path), and would prefer
> work be done there first.

I'd rather not.  2.5.x is a little unstable for this box.  It holds
the master ARM kernel trees for 2.2, 2.4 and 2.5, and given the recent
"issues" with 2.5 IDE, I'd rather not have to reinstall the box from
scratch.

I will look at the patch though.

> > A request received via ioctl is queued at the tail of the request queue,
> > not the head.  I can give you a reference if you'd like. 8)
> 
> Yes, I understand that, but where is the original, non-door lock request
> coming from? 

You must have missed something I mentioned in a previous mail.  Let me
restate with hard evidence.

There are two, almost identical conditions where this goes pear shaped.

1. when restarting operations after error handling.

2. when trying to attach devices to drivers.

In the second case you end up with the precise case; you have a command
that is queued on the request list, and we try to lock the door.

Case 1:  yes, there is no pending request.  However, we do drop the
request on the floor because there are no Scsi_Cmnd structures available.
Here are the debugging messages:

!! scsi: device set offline - not ready or command retry failed after bus reset: host 0 channel 0 id 3 lun 0
!! unjam_host: returning success
!! host_busy = 1 host_blocked = 0
!! Adding timer for command c4489c00 at 100 (c00e1050)
!! Clearing timer for command c4489c00 1
!! host_busy = 1 host_blocked = 0
!! scsi_error.c: Waking up host to restart
!! scsi_error.c: device offline - report as SUCCESS
!! Command finished 1 0 0x6
!! Notifying upper driver of completion for device 3 6
!! restarting target 1
!! Request for device 1: queue empty
!! device 1 re-locking door
!! Open returning 1
!! Trying ioctl with scsi command 30
!! scsi_do_req (host = 0, channel = 0 target = 1, buffer =00000000, bufflen = 0, done = c00db780, timeout = 1000, retries = 5)
!! command : 1e  00  00  00  01  00
!! Request for device 1: req c0471ab4 cmd 4 special 1 completion c45d1e98 command=Prevent/Allow Medium Removal 00 00 00 01 00
!! 
!! Leaving scsi_do_req()

Here, we have dropped the command on the floor because there weren't any
Scsi_Cmnd structures available.  We are still waiting for it though, and
we are using the error handlers context, and thus blocking the error handler.

!! Deactivating command for device 3 (active=0, failed=0)
!! Request for device 3: queue empty
!! device 3 re-locking door
!! device 3 no request
!! scsi: INQUIRY failed with code 0x6
!! scsi: performing INQUIRY
!! scsi_do_req (host = 0, channel = 0 target = 4, buffer =c459fd44, bufflen = 256, done = c00db780, timeout = 600, retries = 3)
!! command : 12  00  00  00  ff  00
!! Request for device 4: req c0471db4 cmd 4 special 1 completion c459fc3c command=Inquiry 00 00 00 ff 00
!! 
!! Activating command for device 4 (1)
!! Leaving scsi_init_cmd_from_req()
!! Adding timer for command c4489e00 at 600 (c00e0de8)
!! scsi_dispatch_cmnd (host = 0, channel = 0, target = 4, command = c4489e58, buffer = c459fd44,
!! bufflen = 256, done = c00db780)
!! queuecommand : routine at cc81d784
!! scsi0.H: received command for id 4 (c4489e00) Inquiry 00 00 00 ff 00
!! scsi0.4: starting Inquiry 00 00 00 ff 00
!! scsi0.4: select: data pointers [c459fd44, 100]
!! scsi0.H: queue success
!! leaving scsi_dispatch_cmnd()
!! host blocked: host_busy=1 host_blocked=0 host_self_blocked=0
!! Leaving scsi_do_req()
!! Command timed out active=1 busy=1 failed=1
<< deadlock >>

Note the nice race condition here.  Above, you'll notice that the command
timed out, and requires error handler work.  Oh, but the error handler is
blocked waiting for a command to complete that never will.  Below, the
command disconnected with DID_NO_CONNECT status.

For some reason, this host controller chip seems to be slow to report
this.

!! scsi0.4: disconnect phase=01
!! scsi0.4: command complete result=0x00010000 CDB: Inquiry 00 00 00 ff 00
!! Clearing timer for command c4489e00 0

Case 2:  I'll let you read through this.

!! Host status for host c0c7e000:
!! Device 1 c0c2d400:
!! Device 2 c0c2d800:
!! sg_init
!! sg_attach: dev=0
!! sg_attach: dev=1
!! Attached scsi removable disk sda at scsi0, channel 0, id 2, lun 0
!! scsi_do_req (host = 0, channel = 0 target = 2, buffer =c0bea000, bufflen = 0, done = c00db780, timeout = 3000, retries = 5)
!! command : 00  00  00  00  00  00
!! Request for device 2: req cc3fe0d4 cmd 4 special 1 completion c0d47d74 command=Test Unit Ready 00 00 00 00 00

!! device 2 re-locking door
!! Open returning 1
!! Trying ioctl with scsi command 30
!! scsi_do_req (host = 0, channel = 0 target = 2, buffer =00000000, bufflen = 0, done = c00db780, timeout = 1000, retries = 5)
!! command : 1e  00  00  00  01  00
!! Request for device 2: req cc3fe0d4 cmd 4 special 1 completion c0d47d74 command=Test Unit Ready 00 00 00 00 00

!! Activating command for device 2 (1)
!! Leaving scsi_init_cmd_from_req()
!! Adding timer for command c0c0e200 at 3000 (c00e0de8)
!! scsi_dispatch_cmnd (host = 0, channel = 0, target = 2, command = c0c0e258, buffer = c0bea000,
!! bufflen = 0, done = c00db780)
!! queuecommand : routine at cc81d784
!! scsi0.H: received command for id 2 (c0c0e200) Test Unit Ready 00 00 00 00 00
!! scsi0.2: starting Test Unit Ready 00 00 00 00 00
!! scsi0.2: select: data pointers [00000000, 0]
!! scsi0.H: queue success
!! leaving scsi_dispatch_cmnd()
!! scsi0.2: disconnect phase=0d
!! scsi0.2: command complete result=0x00000002 CDB: Test Unit Ready 00 00 00 00 00
!! scsi0.2: starting Request Sense 00 00 00 40 00
!! scsi0.2: select: data pointers [c0c0e30c, 40]
!! host blocked: host_busy=1 host_blocked=0 host_self_blocked=0
!! Leaving scsi_do_req()
!! scsi0.2: disconnect phase=0d
!! scsi0.H: request sense complete, result=0x00000000
!! scsi0.2: sense buffer: 70 00 06 00 00 00 00 0e 00 00 00 00 29 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
!! Clearing timer for command c0c0e200 1
!! Command needs retry 1 0 0x2
!! Adding timer for command c0c0e200 at 3000 (c00e0de8)
!! scsi_dispatch_cmnd (host = 0, channel = 0, target = 2, command = c0c0e258, buffer = c0bea000,
!! bufflen = 0, done = c00db780)
!! queuecommand : routine at cc81d784
!! scsi0.H: received command for id 2 (c0c0e200) Test Unit Ready 00 00 00 00 00
!! scsi0.2: starting Test Unit Ready 00 00 00 00 00
!! scsi0.2: select: data pointers [00000000, 0]
!! scsi0.H: queue success
!! leaving scsi_dispatch_cmnd()
!! scsi0.2: disconnect phase=0d
!! scsi0.2: command complete result=0x00000002 CDB: Test Unit Ready 00 00 00 00 00
!! scsi0.2: starting Request Sense 00 00 00 40 00
!! scsi0.2: select: data pointers [c0c0e30c, 40]
!! scsi0.2: disconnect phase=0d
!! scsi0.H: request sense complete, result=0x00000000
!! scsi0.2: sense buffer: 70 00 02 00 00 00 00 0e 00 00 00 00 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
!! Clearing timer for command c0c0e200 1
!! Command finished 1 0 0x2
!! Notifying upper driver of completion for device 2 8000002
<< deadlock >>

Both of the above are nicely reproducable, and are from my logs from earlier
today, where I've plenty of such examples.

So, lets review.

1. We deadlock the error handler when we issue a door lock request while
   trying to restart operations and there is are no requests pending,
   nor command structures available.

2. We deadlock if we issue a door lock request with a pending request.

-- 
Russell King (rmk@arm.linux.org.uk)                The developer of ARM Linux
             http://www.arm.linux.org.uk/personal/aboutme.html

