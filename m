From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: Make SCSI error handler code easier to understand
Date: Wed, 28 May 2014 16:15:28 -0400
Message-ID: <20140528161528.55443865@jlaw-desktop.mno.stratus.com>
References: <538359DB.9080601@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c11o147.mxlogic.net ([208.65.144.70]:37551 "EHLO
	p01c11o147.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaE1Uhb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2014 16:37:31 -0400
In-Reply-To: <538359DB.9080601@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>, Paolo Bonzini <pbonzini@redhat.com>, Joe Lawrence <jdl1291@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Bill Kuzeja <william.kuzeja@stratus.com>

On Mon, 26 May 2014 17:12:27 +0200
Bart Van Assche <bvanassche@acm.org> wrote:

> Every now and then someone asks how it is avoided that the SCSI error
> handler and the SCSI completion handler are invoked concurrently for
> the same SCSI command. Hence this patch series that should make the SCSI
> error handler code a little easier to understand.

Hi Bart,

We talked about REQ_ATOM_COMPLETE a while back (so I may be one of
those people who periodically ask about SCSI error handling /
completion), and I just thought I'd chime in here to clarify the
scenario we were worried about.

Before d555a2ab "[SCSI] Fix spurious request sense in error handling"
we saw the following sequence of events:

  [ 1394.345991] sd 2:0:1:0: [sdw] Done:
  [ 1394.361790] TIMEOUT
  [ 1394.374148] sd 2:0:1:0: [sdw]
  [ 1394.388775] Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
  [ 1394.409068] sd 2:0:1:0: [sdw] CDB:
  [ 1394.424782] Read(10): 28 00 00 00 00 18 00 00 08 00
  [ 1394.443772] sd 2:0:1:0: [sdw] scmd ffff88104dce02c0 abort scheduled
  [ 1394.474026] sd 2:0:1:0: [sdw] aborting command ffff88104dce02c0
  [ 1394.573338] qla2xxx [0000:46:00.0]-801c:2: Abort command issued nexus=2:1:0 --  1 2002.
  [ 1394.609313] sd 2:0:1:0: [sdw] scmd ffff88104dce02c0 retry aborted command
  
  [ 1425.397434] sd 2:0:1:0: [sdw] Done:
  [ 1425.417802] TIMEOUT
  [ 1425.431914] sd 2:0:1:0: [sdw]
  [ 1425.448247] Result: hostbyte=DID_TIME_OUT driverbyte=DRIVER_OK
  [ 1425.470736] sd 2:0:1:0: [sdw] CDB:
  [ 1425.488005] Read(10): 28 00 00 00 00 18 00 00 08 00
  [ 1425.508472] sd 2:0:1:0: [sdw] scmd ffff88104dce02c0 previous abort failed
  [ 1425.533299] scsi_eh_2: waking up 0/1/1
  [ 1425.551189] sd 2:0:1:0: scsi_eh_prt_fail_stats: cmds failed: 1, cancel: 0
  [ 1425.575897] Total of 1 commands on 1 devices require eh work
  [ 1425.597970] sd 2:0:1:0: [sdw] scsi_eh_2: requesting sense

  ie, something like:

  CMD -> .queuecommand ... timeout
  ABORT -> .eh_abort_handler
  CMD (retry) -> .queuecommand ... timeout
  ABORT -> scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD)
  ... into scsi_error_handler ...
  REQUEST SENSE -> .queuecommand

We eventually found our way into scsi_unjam_host, which "*knows*
that all commands on the bus have either completed, failed or timed
out.", and then scsi_send_eh_cmnd, which "hijacks" a SCSI command
structure.  Presumably the second comment follows from the first.

But in the case of timeout, when was the LLDD informed to abort or
forget about that scsi command structure?

In our testing, it appeared that the LLDD's .queuecommand was called
back-to-back with the same scsi_cmnd pointer.  The driver in question
was qla2xxx, who keeps a driver-private structure to scsi_cmnd
mapping (assumed to be one-to-one) that got confused by this sequence
of events.

After d555a2ab, in this scenario scsi_unjam_host skips the request
sense and escalates to the next level (scsi_eh_abort_cmds), skipping
straight to the abort as we would have expected...  This avoids the
scsi_cmnd "hijack"... but was it ever safe to do so in the first place?

Or should LLDD expect to gracefully handle the same scsi_cmnd pointer
coming into .queuecommand w/o an intermediate abort or other
scsi_host_template callback?

Regards,

-- Joe
