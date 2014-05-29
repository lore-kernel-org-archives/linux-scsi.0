From: James Bottomley <jbottomley@parallels.com>
Subject: Re: Make SCSI error handler code easier to understand
Date: Thu, 29 May 2014 11:33:59 +0000
Message-ID: <1401363238.2163.5.camel@dabdike>
References: <538359DB.9080601@acm.org>
	 <20140528161528.55443865@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:37346 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563AbaE2LeR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 May 2014 07:34:17 -0400
In-Reply-To: <20140528161528.55443865@jlaw-desktop.mno.stratus.com>
Content-Language: en-US
Content-ID: <98E4C517AB04D046A250A51F9A210EDD@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "joe.lawrence@stratus.com" <joe.lawrence@stratus.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "bvanassche@acm.org" <bvanassche@acm.org>, "hare@suse.de" <hare@suse.de>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "william.kuzeja@stratus.com" <william.kuzeja@stratus.com>, "jdl1291@gmail.com" <jdl1291@gmail.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>

On Wed, 2014-05-28 at 16:15 -0400, Joe Lawrence wrote:
> On Mon, 26 May 2014 17:12:27 +0200
> Bart Van Assche <bvanassche@acm.org> wrote:
> 
> > Every now and then someone asks how it is avoided that the SCSI error
> > handler and the SCSI completion handler are invoked concurrently for
> > the same SCSI command. Hence this patch series that should make the SCSI
> > error handler code a little easier to understand.
> 
> Hi Bart,
> 
> We talked about REQ_ATOM_COMPLETE a while back (so I may be one of
> those people who periodically ask about SCSI error handling /
> completion), and I just thought I'd chime in here to clarify the
> scenario we were worried about.
> 
> Before d555a2ab "[SCSI] Fix spurious request sense in error handling"
> we saw the following sequence of events:
> 
>   [ 1394.345991] sd 2:0:1:0: [sdw] Done:
>   [ 1394.361790] TIMEOUT
>   [ 1394.374148] sd 2:0:1:0: [sdw]
>   [ 1394.388775] Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
>   [ 1394.409068] sd 2:0:1:0: [sdw] CDB:
>   [ 1394.424782] Read(10): 28 00 00 00 00 18 00 00 08 00
>   [ 1394.443772] sd 2:0:1:0: [sdw] scmd ffff88104dce02c0 abort scheduled
>   [ 1394.474026] sd 2:0:1:0: [sdw] aborting command ffff88104dce02c0
>   [ 1394.573338] qla2xxx [0000:46:00.0]-801c:2: Abort command issued nexus=2:1:0 --  1 2002.
>   [ 1394.609313] sd 2:0:1:0: [sdw] scmd ffff88104dce02c0 retry aborted command
>   
>   [ 1425.397434] sd 2:0:1:0: [sdw] Done:
>   [ 1425.417802] TIMEOUT
>   [ 1425.431914] sd 2:0:1:0: [sdw]
>   [ 1425.448247] Result: hostbyte=DID_TIME_OUT driverbyte=DRIVER_OK
>   [ 1425.470736] sd 2:0:1:0: [sdw] CDB:
>   [ 1425.488005] Read(10): 28 00 00 00 00 18 00 00 08 00
>   [ 1425.508472] sd 2:0:1:0: [sdw] scmd ffff88104dce02c0 previous abort failed
>   [ 1425.533299] scsi_eh_2: waking up 0/1/1
>   [ 1425.551189] sd 2:0:1:0: scsi_eh_prt_fail_stats: cmds failed: 1, cancel: 0
>   [ 1425.575897] Total of 1 commands on 1 devices require eh work
>   [ 1425.597970] sd 2:0:1:0: [sdw] scsi_eh_2: requesting sense
> 
>   ie, something like:
> 
>   CMD -> .queuecommand ... timeout
>   ABORT -> .eh_abort_handler
>   CMD (retry) -> .queuecommand ... timeout
>   ABORT -> scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD)
>   ... into scsi_error_handler ...
>   REQUEST SENSE -> .queuecommand
> 
> We eventually found our way into scsi_unjam_host, which "*knows*
> that all commands on the bus have either completed, failed or timed
> out.", and then scsi_send_eh_cmnd, which "hijacks" a SCSI command
> structure.  Presumably the second comment follows from the first.
> 
> But in the case of timeout, when was the LLDD informed to abort or
> forget about that scsi command structure?

When we get a successful abort, the command is back with the mid layer,
or when we complete a reset (all commands should now be taken from the
LLD).  We don't start trying to probe the device with a TUR until after
the command should be back with the mid layer.

> In our testing, it appeared that the LLDD's .queuecommand was called
> back-to-back with the same scsi_cmnd pointer.  The driver in question
> was qla2xxx, who keeps a driver-private structure to scsi_cmnd
> mapping (assumed to be one-to-one) that got confused by this sequence
> of events.

This was the bug in ACA emulation which the fix corrected.  After that
fix, we should only reuse the command for ACA emulation *if* we get a
successful return code indicating sense should be collected (meaning the
LLD relinquished the command).

> After d555a2ab, in this scenario scsi_unjam_host skips the request
> sense and escalates to the next level (scsi_eh_abort_cmds), skipping
> straight to the abort as we would have expected...  This avoids the
> scsi_cmnd "hijack"... but was it ever safe to do so in the first place?

The hijack is safe provided the LLD has relinquished the command, which
it does after status return, abort or reset.

> Or should LLDD expect to gracefully handle the same scsi_cmnd pointer
> coming into .queuecommand w/o an intermediate abort or other
> scsi_host_template callback?

No.

James

