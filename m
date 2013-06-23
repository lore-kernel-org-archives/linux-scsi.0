From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: eh_abort_handler implementations
Date: Sun, 23 Jun 2013 15:59:14 -0500
Message-ID: <51C761A2.1070602@cs.wisc.edu>
References: <51B84D63.9040602@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:56717 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab3FWU7a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Jun 2013 16:59:30 -0400
In-Reply-To: <51B84D63.9040602@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, James Smart <james.smart@emulex.com>, Ewan Milne <emilne@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 06/12/2013 05:28 AM, Hannes Reinecke wrote:
> Hi all,
> 
> as you might know, I'm trying to revamp the eh_abort_handler
> implementation by sending command aborts directly whenever
> the timeout triggers, without entering SCSI EH.
> 
> So, during testing where the remote port is disabled I've seen this:
> 
> [  864.734937] qla2xxx [0000:41:00.0]-8802:1: Aborting from RISC
> nexus=1:0:0 sp=ffff880225b0dd40 cmd=ffff8802248d76c0
> [  864.737274] qla2xxx [0000:41:00.0]-1800:1: Entered
> qla2x00_mailbox_command.
> [  864.738720] qla2xxx [0000:41:00.0]-1806:1: Prepare to issue mbox
> cmd=0x54.
> [  864.740268] qla2xxx [0000:41:00.0]-180f:1: Going to unlock irq &
> waiting for interrupts. jiffies=100022781.
> [  864.740574] qla2xxx [0000:41:00.0]-1814:1: Cmd=54 completed.
> [  864.740596] qla2xxx [0000:41:00.0]-3822:1: FCP command status:
> 0x5-0x0 (0x80000) nexus=1:0:0 portid=691400 oxid=0x38e
> cdb=28000000000000000800 len=0x1000 rsp_info=0x0 resid=0x0 fw_resid=0x0.
> [  864.740608] qla2xxx [0000:41:00.0]-1821:1: Done
> qla2x00_mailbox_command.
> [  864.740615] qla2xxx [0000:41:00.0]-8804:1: Abort command mbx
> success cmd=ffff8802248d76c0.
> [  864.740631] qla2xxx [0000:41:00.0]-801c:1: Abort command issued
> nexus=1:0:0 --  2002.
> 
> Again, the port is disabled, so the TMF _cannot_ be received by the
> remote port, let alone processed.
> But still the command abort is processed correctly and the command
> is returned to the upper layers.
> So with the current thinking the command abort was successful, and
> EH would exit, as the remote port was assumed to be working.
> But most evidently the remote port is _still_ not reachable, so the
> TMF _should_ have returned 'FAILED'.
> At least that's what we expect.
> But it looks as if this expectation is slightly skewed, as most
> likely a successful ABORT TASK TMF just means that the command was
> terminated, not that the remote port itself was working.
> 
> If _that_ should be the case it looks as if we _always_ should be
> issuing a RESET LUN TMF whenever command aborts have been processed.
> Would that be correct?
> 

I am not sure if I understand the question. For the iscsi drivers, when
the port is down we will return failed from the abort and lun reset
handler handler. The eh will then escalate and in the target reset
handler we will then wait for a successful reconnection/relogin or for
the replacement/recovery (like the dev_loss or fast io fail) to fire.

For iscsi at least, there is no need to send a lun reset if we are doing
session level recovery (the relogin/reconnection process). It would be
nice to just have a eh return code so the LLD/iscsi layer can just tell
the scsi eh to just skip some steps.

