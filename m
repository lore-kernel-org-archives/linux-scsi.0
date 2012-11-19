From: Hannes Reinecke <hare@suse.de>
Subject: Error handling on FC devices
Date: Mon, 19 Nov 2012 13:41:51 +0100
Message-ID: <50AA290F.8000105@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45641 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698Ab2KSMl4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Nov 2012 07:41:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, James Smart <james.smart@emulex.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

Hi all,

just when we thought we'd finally nailed the error handling on FC ...
A customer of ours recently hit this really nasty issue:
He had a 'drain' on the SAN, in the sense that the link was still=20
intact, but no commands were coming back from the link.

This caused the FC HBA / driver to not detect a link down, and so=20
the failing command was pushed onto the error handler.
Which of course resorted back to HBA reset, but by that time the=20
cluster already had kicked out the machine.
And as all machines in the cluster were connected to the same switch=20
this happened to all machines, resulting on a nice cluster shutdown.=20
And a really unhappy customer.

Looking closer multipathing actually managed to detect and switch=20
paths as desired, but as the initial failing command was pushed onto=20
the error handler all applications had to wait for this command to=20
finish before proceeding.

So the following questions:
- Why did the FC HBA not detect a 'link-down' scenario?
   (Incidentally, this happens with QLogic _and_ Emulex :-)
   I know this is not a typical link-down, but from my naive
   assumption the HBA should detect that commands are not
   making progress, and at least after RA TOV was expired
   it should try to reset the link.
- Can we speed up error handling for these cases?
   Currently we're waiting for eh to complete before returning
   the affected commands with a final state.
   However, after we've done a LUN reset there shouldn't be
   any command state left and we should be able to terminate
   outstanding commands directly, without having to wait for
   eh to finally complete. James?

Thanks.

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
