From: Hannes Reinecke <hare@suse.de>
Subject: Question: eh_abort_handler() and terminate commands
Date: Fri, 24 May 2013 12:57:59 +0200
Message-ID: <519F47B7.1040504@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45412 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947Ab3EXK6B (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Fri, 24 May 2013 06:58:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: James Smart <james.smart@emulex.com>, Chad Dupuis <chad.dupuis@qlogic.com>, Linux-scsi@vger.kernel.org

Hi all,

after having posted the first attempt for an updated FC error
handler I found that the 'eh_abort_handler()' semantics are a bit odd.

Obviously, the 'eh_abort_handler' is called to abort a command.
But what _exactly_ is supposed to happen if it returns 'SUCCESS'?
Initially one does expect that the command has been aborted.
But then the callback itself does _not_ terminate the command,
it's rather expected that the caller of 'eh_abort_command' does it.

Which leads to the interesting question:
What happens with the actual command once eh_abort_handler returns?

As normally 'eh_abort_handler' is implemented as a TMF, one does
assume that the command itself will be returned by the target with
an appropriate status.
However, as the upper layer is expected to terminate the command
itself, we will never see this status, right?
OTOH it also means that the HBA firmware might receive a completion
for a command which the upper layer has already completed.
Will this completion ever being mirrored to the LLDD? Or discarded
by the firmware?
And how is one expected to handle the case where the TMF _failed_
on the target?

I would rather prefer to have the LLDD terminate the command; this
way we at least have a chance of getting a decent status back ...

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
