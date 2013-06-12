From: Hannes Reinecke <hare@suse.de>
Subject: eh_abort_handler implementations
Date: Wed, 12 Jun 2013 12:28:51 +0200
Message-ID: <51B84D63.9040602@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57955 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754179Ab3FLK2y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jun 2013 06:28:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Smart <james.smart@emulex.com>, Ewan Milne <emilne@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi all,

as you might know, I'm trying to revamp the eh_abort_handler
implementation by sending command aborts directly whenever
the timeout triggers, without entering SCSI EH.

So, during testing where the remote port is disabled I've seen this:

[  864.734937] qla2xxx [0000:41:00.0]-8802:1: Aborting from RISC
nexus=3D1:0:0 sp=3Dffff880225b0dd40 cmd=3Dffff8802248d76c0
[  864.737274] qla2xxx [0000:41:00.0]-1800:1: Entered
qla2x00_mailbox_command.
[  864.738720] qla2xxx [0000:41:00.0]-1806:1: Prepare to issue mbox
cmd=3D0x54.
[  864.740268] qla2xxx [0000:41:00.0]-180f:1: Going to unlock irq &
waiting for interrupts. jiffies=3D100022781.
[  864.740574] qla2xxx [0000:41:00.0]-1814:1: Cmd=3D54 completed.
[  864.740596] qla2xxx [0000:41:00.0]-3822:1: FCP command status:
0x5-0x0 (0x80000) nexus=3D1:0:0 portid=3D691400 oxid=3D0x38e
cdb=3D28000000000000000800 len=3D0x1000 rsp_info=3D0x0 resid=3D0x0 fw_r=
esid=3D0x0.
[  864.740608] qla2xxx [0000:41:00.0]-1821:1: Done
qla2x00_mailbox_command.
[  864.740615] qla2xxx [0000:41:00.0]-8804:1: Abort command mbx
success cmd=3Dffff8802248d76c0.
[  864.740631] qla2xxx [0000:41:00.0]-801c:1: Abort command issued
nexus=3D1:0:0 --  2002.

Again, the port is disabled, so the TMF _cannot_ be received by the
remote port, let alone processed.
But still the command abort is processed correctly and the command
is returned to the upper layers.
So with the current thinking the command abort was successful, and
EH would exit, as the remote port was assumed to be working.
But most evidently the remote port is _still_ not reachable, so the
TMF _should_ have returned 'FAILED'.
At least that's what we expect.
But it looks as if this expectation is slightly skewed, as most
likely a successful ABORT TASK TMF just means that the command was
terminated, not that the remote port itself was working.

If _that_ should be the case it looks as if we _always_ should be
issuing a RESET LUN TMF whenever command aborts have been processed.
Would that be correct?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
