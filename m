From: Hannes Reinecke <hare@suse.de>
Subject: Re: Error handling on FC devices
Date: Fri, 30 Nov 2012 12:44:45 +0100
Message-ID: <50B89C2D.8030108@suse.de>
References: <50AA290F.8000105@suse.de>  <50B3EDEA.40008@emulex.com> <1354046601.4420.14.camel@localhost.localdomain> <94D0CD8314A33A4D9D801C0FE68B40294CCFD463@G9W0745.americas.hpqcorp.net> <50B5B8C4.1040503@suse.de> <50B78715.2060109@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36778 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758013Ab2K3Los (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Nov 2012 06:44:48 -0500
In-Reply-To: <50B78715.2060109@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@emulex.com
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "emilne@redhat.com" <emilne@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

On 11/29/2012 05:02 PM, James Smart wrote:
> Always possible - but....   Our f/w works at the FCP level and
> below, which means it doesn't know/do SCSI commands - e.g what the
> cdb within the FCP CMD frame is; know anything about SCSI device
> classes and state; etc. And it shouldn't be required to do so.
> Anytime this has been there in the past, it's been problematic.
>
> if we want to do this - we should add it to the midlayer/transport.
>
D'accord. Transport layer looks like a good fit.

What we should be doing is hooking up 'bus_reset' to be equivalent=20
to REMOVE I_T NEXUS (SAS is already doing this).

In our case a REMOVE I_T NEXUS would be roughly equivalent to
scsi_remote_port_delete(); only we should be starting aborting
outstanding I/O directly and not waiting for fast_fail_tmo
to kick in.

I'll be posting a patch.

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
