From: Hannes Reinecke <hare@suse.de>
Subject: Re: Error handling on FC devices
Date: Wed, 28 Nov 2012 08:09:56 +0100
Message-ID: <50B5B8C4.1040503@suse.de>
References: <50AA290F.8000105@suse.de>  <50B3EDEA.40008@emulex.com> <1354046601.4420.14.camel@localhost.localdomain> <94D0CD8314A33A4D9D801C0FE68B40294CCFD463@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55826 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab2K1HKC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Nov 2012 02:10:02 -0500
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40294CCFD463@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "emilne@redhat.com" <emilne@redhat.com>, "James.Smart@emulex.com" <James.Smart@emulex.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

On 11/27/2012 09:29 PM, Elliott, Robert (Server Storage) wrote:
> There is a new command in SPC-4 called REMOVE I_T NEXUS that is inten=
ded to help
 > that situation.  REMOVE I_T NEXUS lets the application client use=20
a good I_T nexus
 > to abort commands that were being processed on a bad I_T nexus,=20
so it can safely
 > re-issue those commands on the good I_T nexus without worrying=20
that the original
 > commands might resume.
>
> In contrast:
> - the ABORT TASK, ABORT TASK SET, and CLEAR TASK SET must use the sam=
e I_T nexus
 >   as the commands being aborted, so are not viable if that I_T=20
nexus is bad
> - LOGICAL UNIT RESET aborts commands from every I_T nexus, so in addi=
tion to
 >   aborting commands from the bad I_T nexus it also affects=20
commands on the
 >   good I_T nexus
>
Hmm. Nice in principle, but the problem here is that we cannot=20
guarantee the nexus is still intact.
So one would need to implement this in the HBA firmware; the=20
firmware would need to be able to process the TMF, and do the=20
appropriate things for the FC stack like dropping the rport etc.

Good idea, though.

James, Andrew, Chad?
Any chance of having a firmware supporting REMOVE IT-NEXUS ?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
